Describe 'Dev Center image-builder storage fixture identities' {
    BeforeAll {
        $fixturePath = Join-Path $PSScriptRoot '..' 'e2e' 'max' 'main.test.bicep'
        $source = Get-Content -LiteralPath $fixturePath -Raw
        $serviceMatch = [regex]::Match($source, "(?m)^param serviceShort string = '(?<value>[^']+)'")
        if (-not $serviceMatch.Success) { throw 'Missing fixture service identifier.' }
        $expressions = @{}
        foreach ($parameter in @('assetsStorageAccountName', 'deploymentScriptStorageAccountName')) {
            $match = [regex]::Match($source, "(?m)^\s+$parameter`: (?<expression>[^\r\n]+)")
            if (-not $match.Success) { throw "Missing image-builder parameter $parameter." }
            $expressions[$parameter] = $match.Groups['expression'].Value
        }
        $defaults = @{
            subscription = '00000000-0000-4000-8000-000000000001'
            group = 'fixture-one'
            prefix = 'gci'
            service = $serviceMatch.Groups['value'].Value
            root = 'attempt-one'
            location = 'uksouth'
            time = '2026-01-01'
        }
        $overrides = @(
            @{}
            @{ subscription = '00000000-0000-4000-8000-000000000002' }
            @{ group = 'fixture-two' }
            @{ root = 'attempt-two'; location = 'westus3'; time = '2026-01-02' }
            @{ prefix = ('g' * 100); service = ('s' * 100) }
            @{ prefix = ('g' * 100); service = ('s' * 100 + 'b') }
            @{ prefix = ('g' * 100 + 'b'); service = ('s' * 100) }
            @{ prefix = ''; service = 'a' }
        )
        $parameters = @('using none')
        for ($index = 0; $index -lt $overrides.Count; $index++) {
            $values = $defaults.Clone()
            foreach ($key in $overrides[$index].Keys) { $values[$key] = $overrides[$index][$key] }
            foreach ($iteration in @('init', 'idem')) {
                foreach ($parameter in $expressions.Keys) {
                    $expression = $expressions[$parameter].
                        Replace('resourceGroup2.id', "'/subscriptions/$($values.subscription)/resourceGroups/$($values.group)-2'").
                        Replace('resourceGroup1.id', "'/subscriptions/$($values.subscription)/resourceGroups/$($values.group)'").
                        Replace('deployment().name', "'$($values.root)'").
                        Replace('enforcedLocation', "'$($values.location)'").
                        Replace('baseTime', "'$($values.time)'").
                        Replace('namePrefix', "'$($values.prefix)'").
                        Replace('serviceShort', "'$($values.service)'").
                        Replace('iteration', "'$iteration'")
                    $parameters += "param case${index}${iteration}${parameter} = $expression"
                }
            }
        }
        $parameterPath = Join-Path $TestDrive 'storage-names.bicepparam'
        $parameterOutput = Join-Path $TestDrive 'storage-names.json'
        $parameters -join "`n" | Set-Content -LiteralPath $parameterPath
        $diagnostics = bicep build-params $parameterPath --no-restore --outfile $parameterOutput 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $names = (Get-Content -LiteralPath $parameterOutput -Raw | ConvertFrom-Json -AsHashtable).parameters
        $compiledPath = Join-Path $TestDrive 'max.json'
        $diagnostics = bicep build $fixturePath --no-restore --outfile $compiledPath 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $template = Get-Content -LiteralPath $compiledPath -Raw | ConvertFrom-Json -AsHashtable -Depth 100
        $resources = $template.resources -is [System.Collections.IDictionary] ? @($template.resources.Values) : @($template.resources)
        $builder = @($resources | Where-Object { $_.name -match '-imageBuilder' })[0]
    }

    It 'Separates both accounts across subscriptions and owning groups' {
        foreach ($parameter in $expressions.Keys) {
            $names["case0init$parameter"].value | Should -Not -Be $names["case1init$parameter"].value
            $names["case0init$parameter"].value | Should -Not -Be $names["case2init$parameter"].value
        }
    }

    It 'Keeps identities stable across roots, regions, time changes and init/idem' {
        foreach ($parameter in $expressions.Keys) {
            $names["case0init$parameter"].value | Should -BeExactly $names["case3init$parameter"].value
            foreach ($index in 0..7) {
                $names["case${index}init$parameter"].value | Should -BeExactly $names["case${index}idem$parameter"].value
            }
        }
    }

    It 'Bounds both account names and preserves distinctions beyond their readable prefixes' {
        foreach ($name in $names.Values) { $name.value | Should -Match '^[a-z0-9]{3,24}$' }
        foreach ($parameter in $expressions.Keys) {
            $names["case4init$parameter"].value.Length | Should -Be 24
            $names["case4init$parameter"].value | Should -Not -Be $names["case5init$parameter"].value
            $names["case4init$parameter"].value | Should -Not -Be $names["case6init$parameter"].value
        }
    }

    It 'Keeps asset storage and deployment-script storage distinct even after truncation' {
        foreach ($index in 0..7) {
            $names["case${index}initassetsStorageAccountName"].value |
                Should -Not -Be $names["case${index}initdeploymentScriptStorageAccountName"].value
        }
    }

    It 'Uses the image-builder resource group and preserves its existing execution settings' {
        $builder.properties.parameters.resourceGroupName.value | Should -BeExactly "[format('{0}-2', parameters('resourceGroupName'))]"
        foreach ($parameter in $expressions.Keys) {
            $value = $builder.properties.parameters[$parameter].value
            $value | Should -Match 'uniqueString\('
            $value | Should -Match "format\('\{0\}-2', parameters\('resourceGroupName'\)\)"
        }
        $builder.properties.parameters.deploymentsToPerform.value | Should -BeExactly 'All'
        $builder.properties.parameters.waitForImageBuild.value | Should -BeTrue
        $builder.properties.parameters.waitForImageBuildTimeout.value | Should -BeExactly 'PT40M'
        $template.variables.enforcedLocation | Should -BeExactly 'uksouth'
    }
}
