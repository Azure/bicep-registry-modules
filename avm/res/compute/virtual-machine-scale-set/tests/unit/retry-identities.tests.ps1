BeforeAll {
    $modulePath = Join-Path $PSScriptRoot '..' '..'
    $fixturePath = Join-Path $modulePath 'tests' 'e2e' 'linux.max' 'main.test.bicep'
    $source = Get-Content -LiteralPath $fixturePath -Raw
    $scriptParameters = @('storageUploadDeploymentScriptName', 'sshDeploymentScriptName')
    $expressions = @{}
    foreach ($parameter in $scriptParameters) {
        $match = [regex]::Match($source, "(?m)^\s+$parameter`: (?<expression>[^\r\n]+)")
        if (-not $match.Success) { throw "Missing deployment script name expression for $parameter." }
        $expressions[$parameter] = $match.Groups['expression'].Value
    }

    $scenarios = @(
        @{ root = 'attempt-one'; location = 'eastus'; prefix = 'gci'; service = 'cvmsslinmax' }
        @{ root = 'attempt-two'; location = 'eastus'; prefix = 'gci'; service = 'cvmsslinmax' }
        @{ root = 'attempt-one'; location = 'centralus'; prefix = 'gci'; service = 'cvmsslinmax' }
        @{ root = 'attempt-two'; location = 'norwayeast'; prefix = 'gci'; service = 'cvmsslinmax' }
        @{ root = 'attempt-one'; location = 'eastus'; prefix = ('g' * 100); service = ('s' * 100 + '1') }
        @{ root = 'attempt-one'; location = 'eastus'; prefix = ('g' * 100); service = ('s' * 100 + '2') }
    )
    $parameterSource = @('using none')
    for ($index = 0; $index -lt $scenarios.Count; $index++) {
        $scenario = $scenarios[$index]
        foreach ($iteration in @('init', 'idem')) {
            foreach ($parameter in $scriptParameters) {
                $expression = $expressions[$parameter].
                Replace('deployment().name', "'$($scenario.root)'").
                Replace('resourceLocation', "'$($scenario.location)'").
                Replace('namePrefix', "'$($scenario.prefix)'").
                Replace('serviceShort', "'$($scenario.service)'")
                $parameterSource += "param ${parameter}${index}${iteration} = $expression"
            }
        }
    }
    $parameterPath = Join-Path $TestDrive 'script-names.bicepparam'
    $outputPath = Join-Path $TestDrive 'script-names.json'
    $parameterSource -join "`n" | Set-Content -LiteralPath $parameterPath
    $diagnostics = bicep build-params $parameterPath --no-restore --outfile $outputPath 2>&1
    if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
    $names = (Get-Content -LiteralPath $outputPath -Raw | ConvertFrom-Json -AsHashtable).parameters

    $fixtureOutput = Join-Path $TestDrive 'linux.max.json'
    $diagnostics = bicep build $fixturePath --no-restore --outfile $fixtureOutput 2>&1
    if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
    $template = Get-Content -LiteralPath $fixtureOutput -Raw | ConvertFrom-Json -AsHashtable
    $resources = $template.resources -is [System.Collections.IDictionary] ? @($template.resources.Values) : @($template.resources)
    $dependencies = @($resources | Where-Object {
            $_.type -eq 'Microsoft.Resources/deployments' -and
            $_.properties.parameters.ContainsKey('storageUploadDeploymentScriptName')
        })[0]
    $testModule = @($resources | Where-Object {
            $_.type -eq 'Microsoft.Resources/deployments' -and
            $_.properties.parameters.ContainsKey('skuName')
        })[0]
    $dependencyResources = $dependencies.properties.template.resources
    $dependencyResources = $dependencyResources -is [System.Collections.IDictionary] ? @($dependencyResources.Values) : @($dependencyResources)
    $scripts = @($dependencyResources | Where-Object type -EQ 'Microsoft.Resources/deploymentScripts')
}

Describe 'Linux maximum fixture retry identities' {
    It 'Changes both script names for a new root attempt in the same region' {
        foreach ($parameter in $scriptParameters) {
            $names["${parameter}0init"].value | Should -Not -Be $names["${parameter}1init"].value
        }
    }

    It 'Changes both script names when the deployment region changes' {
        foreach ($parameter in $scriptParameters) {
            $names["${parameter}0init"].value | Should -Not -Be $names["${parameter}2init"].value
        }
    }

    It 'Keeps both script identities stable between init and idem' {
        foreach ($index in 0..5) {
            foreach ($parameter in $scriptParameters) {
                $names["${parameter}${index}init"].value | Should -BeExactly $names["${parameter}${index}idem"].value
            }
        }
        $dependencies.ContainsKey('copy') | Should -BeFalse
        $testModule.copy.count | Should -Be "[length(createArray('init', 'idem'))]"
        $testModule.copy.mode | Should -Be 'serial'
        $testModule.copy.batchSize | Should -Be 1
    }

    It 'Keeps generated names valid within the 90-character API limit' {
        foreach ($entry in $names.Values) {
            $entry.value | Should -Match '^[a-zA-Z0-9][a-zA-Z0-9-]{0,89}$'
        }
        foreach ($parameter in $scriptParameters) {
            $names["${parameter}4init"].value.Length | Should -Be 90
        }
    }

    It 'Keeps SSH and upload script identities distinct after truncation' {
        foreach ($index in 0..5) {
            $names["storageUploadDeploymentScriptName${index}init"].value |
                Should -Not -Be $names["sshDeploymentScriptName${index}init"].value
        }
        foreach ($parameter in $scriptParameters) {
            $names["${parameter}4init"].value | Should -Not -Be $names["${parameter}5init"].value
        }
    }

    It 'Passes the qualified names through to both deployment script resources' {
        $scripts.Count | Should -Be 2
        $scripts.name | Should -Contain "[parameters('storageUploadDeploymentScriptName')]"
        $scripts.name | Should -Contain "[parameters('sshDeploymentScriptName')]"
        foreach ($parameter in $scriptParameters) {
            $dependencies.properties.parameters[$parameter].value | Should -Match 'deployment\(\)\.name'
            $dependencies.properties.parameters[$parameter].value | Should -Match "parameters\('resourceLocation'\)"
        }
    }

    It 'Preserves managed identity permissions, cleanup and script outputs' {
        foreach ($script in $scripts) {
            $script.identity.type | Should -Be 'UserAssigned'
            $script.properties.retentionInterval | Should -Be 'P1D'
            $script.properties.ContainsKey('cleanupPreference') | Should -BeFalse
            @($script.dependsOn | Where-Object { $_ -match "Microsoft.Authorization/roleAssignments.+Contributor" }).Count | Should -Be 1
        }
        $testModule.properties.parameters.publicKeys.value[0].keyData | Should -Match '\.outputs\.SSHKeyPublicKey\.value'
        $testModule.properties.parameters.extensionCustomScriptConfig.value.settings.fileUris[0] |
            Should -Match '\.outputs\.storageAccountCSEFileUrl\.value'
        $testModule.properties.parameters.disablePasswordAuthentication.value | Should -BeTrue
    }

    It 'Preserves region selection and zonal Linux scale-set coverage' {
        $template.parameters.resourceLocation.defaultValue | Should -Be '[deployment().location]'
        $testModule.properties.parameters.location.value | Should -Be "[parameters('resourceLocation')]"
        $testModule.properties.parameters.osType.value | Should -Be 'Linux'
        $testModule.properties.parameters.skuName.value | Should -Be 'Standard_D4ads_v5'
        $testModule.properties.parameters.availabilityZones.value | Should -Be @(2)
    }
}
