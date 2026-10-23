BeforeAll {
    $modulePath = Join-Path $PSScriptRoot '..' '..'
    $source = Get-Content -LiteralPath (Join-Path $modulePath 'main.bicep') -Raw
    $galleryMatch = [regex]::Match($source, "(?s)module logAnalyticsWorkspace_solutions '[^']+' = \[.*?for .*?: if \((?<condition>.*?)\) \{\s*name:")
    $onboardingMatch = [regex]::Match($source, "(?s)resource logAnalyticsWorkspace_sentinelOnboarding '[^']+' = if \((?<condition>.*?)\) \{\s*name:")
    if (-not $galleryMatch.Success -or -not $onboardingMatch.Success) { throw 'Missing Sentinel deployment conditions.' }

    $sentinel = @{ name = 'SecurityInsights(test-workspace)'; plan = @{ product = 'OMSGallery/SecurityInsights'; publisher = 'Microsoft' } }
    $automation = @{ name = 'AzureAutomation(test-workspace)'; plan = @{ product = 'OMSGallery/AzureAutomation' } }
    $sql = @{ name = 'SQLAuditing(test-workspace)'; plan = @{ product = 'SQLAuditing'; publisher = 'Microsoft' } }
    $scenarios = @(
        @{ enabled = $true; solutions = @($automation, $sentinel, $sql); legacy = @($true, $false, $true); onboarding = $true }
        @{ enabled = $false; solutions = @($automation, $sentinel, $sql); legacy = @($true, $true, $true); onboarding = $false }
        @{ enabled = $true; solutions = @($sentinel); legacy = @($false); onboarding = $true }
        @{ enabled = $true; solutions = @($automation, $sql); legacy = @($true, $true); onboarding = $false }
        @{ enabled = $true; solutions = @(); legacy = @(); onboarding = $false }
        @{ enabled = $true; solutions = $null; legacy = @(); onboarding = $false }
    )
    $parameterSource = @('using none')
    for ($index = 0; $index -lt $scenarios.Count; $index++) {
        $scenario = $scenarios[$index]
        $solutionsJson = ConvertTo-Json -InputObject $scenario.solutions -Depth 5 -Compress
        $parameterSource += "var solutions$index = json('$solutionsJson')"
        $galleryCondition = $galleryMatch.Groups['condition'].Value.
        Replace('gallerySolutions', "solutions$index").
        Replace('onboardWorkspaceToSentinel', $scenario.enabled.ToString().ToLowerInvariant())
        $onboardingCondition = $onboardingMatch.Groups['condition'].Value.
        Replace('gallerySolutions', "solutions$index").
        Replace('onboardWorkspaceToSentinel', $scenario.enabled.ToString().ToLowerInvariant())
        $parameterSource += "param legacy$index = map(solutions$index ?? [], gallerySolution => $galleryCondition)"
        $parameterSource += "param onboarding$index = $onboardingCondition"
    }
    $parameterPath = Join-Path $TestDrive 'sentinel-conditions.bicepparam'
    $outputPath = Join-Path $TestDrive 'sentinel-conditions.json'
    $parameterSource -join "`n" | Set-Content -LiteralPath $parameterPath
    $diagnostics = bicep build-params $parameterPath --no-restore --outfile $outputPath 2>&1
    if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
    $conditions = (Get-Content -LiteralPath $outputPath -Raw | ConvertFrom-Json -AsHashtable).parameters

    $fixturePath = Join-Path $modulePath 'tests' 'e2e' 'max' 'main.test.bicep'
    $fixtureOutput = Join-Path $TestDrive 'max.json'
    $diagnostics = bicep build $fixturePath --no-restore --outfile $fixtureOutput 2>&1
    if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
    $fixture = Get-Content -LiteralPath $fixtureOutput -Raw | ConvertFrom-Json -AsHashtable
    $resources = $fixture.resources -is [System.Collections.IDictionary] ? @($fixture.resources.Values) : @($fixture.resources)
    $testModule = @($resources | Where-Object {
            $_.type -eq 'Microsoft.Resources/deployments' -and
            $_.properties.parameters.ContainsKey('gallerySolutions')
        })[0]
    $template = $testModule.properties.template
}

Describe 'Sentinel onboarding ownership' {
    It 'Uses only the onboarding API for SecurityInsights when onboarding is enabled' {
        foreach ($index in @(0, 2)) {
            $conditions["legacy$index"].value | Should -Be $scenarios[$index].legacy
            $conditions["onboarding$index"].value | Should -BeTrue
        }
    }

    It 'Preserves every legacy gallery deployment when onboarding is disabled' {
        $conditions.legacy1.value | Should -Be @($true, $true, $true)
        $conditions.onboarding1.value | Should -BeFalse
    }

    It 'Preserves the existing SecurityInsights gallery prerequisite' {
        foreach ($index in @(3, 4, 5)) {
            @($conditions["legacy$index"].value) | Should -Be $scenarios[$index].legacy
            $conditions["onboarding$index"].value | Should -BeFalse
        }
        $template.parameters.onboardWorkspaceToSentinel.defaultValue | Should -BeFalse
    }

    It 'Keeps non-Sentinel gallery indices and deployment names unchanged' {
        $gallery = $template.resources.logAnalyticsWorkspace_solutions
        $gallery.copy.count | Should -Be "[length(coalesce(parameters('gallerySolutions'), createArray()))]"
        $gallery.name | Should -Match 'LAW-Solution-\{1\}'
        $gallery.properties.parameters.name.value |
            Should -Be "[coalesce(parameters('gallerySolutions'), createArray())[copyIndex()].name]"
        $gallery.condition | Should -Match "parameters\('onboardWorkspaceToSentinel'\)"
    }

    It 'Keeps the stable onboarding API and does not override pricing or encryption defaults' {
        $onboarding = $template.resources.logAnalyticsWorkspace_sentinelOnboarding
        $onboarding.type | Should -Be 'Microsoft.SecurityInsights/onboardingStates'
        $onboarding.apiVersion | Should -Be '2025-09-01'
        $onboarding.name | Should -Be 'default'
        $onboarding.properties.Count | Should -Be 0
        $onboarding.dependsOn | Should -Contain 'logAnalyticsWorkspace'
    }

    It 'Keeps SecurityInsights and both other gallery solutions in the maximum fixture' {
        $parameters = $testModule.properties.parameters
        $parameters.onboardWorkspaceToSentinel.value | Should -BeTrue
        $gallery = @($parameters.gallerySolutions.value)
        $gallery.Count | Should -Be 3
        $gallery[0].plan.product | Should -Be 'OMSGallery/AzureAutomation'
        $gallery[1].plan.product | Should -Be 'OMSGallery/SecurityInsights'
        $gallery[2].plan.product | Should -Be 'SQLAuditing'
        $parameters.features.value.disableLocalAuth | Should -BeTrue
        $parameters.replication.value.enabled | Should -BeTrue
    }

    It 'Keeps sequential initial and idempotency deployments without a pinned region' {
        $testModule.copy.count | Should -Be "[length(createArray('init', 'idem'))]"
        $testModule.copy.mode | Should -Be 'serial'
        $testModule.copy.batchSize | Should -Be 1
        $fixture.parameters.resourceLocation.defaultValue | Should -Be '[deployment().location]'
    }
}
