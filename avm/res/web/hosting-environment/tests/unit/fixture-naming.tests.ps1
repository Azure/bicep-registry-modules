Describe 'App Service Environment fixture identities' {
    Context '<fixture>' -ForEach @(
        @{ fixture = 'defaults' }
        @{ fixture = 'max' }
        @{ fixture = 'waf-aligned' }
    ) {
        BeforeAll {
            $fixturePath = Join-Path $PSScriptRoot '..' 'e2e' $fixture 'main.test.bicep'
            $source = Get-Content -LiteralPath $fixturePath -Raw
            $nameMatch = [regex]::Match($source, '(?ms)^module testDeployment\b.*?\bparams:\s*\{\s*name: (?<expression>[^\r\n]+)')
            $serviceMatch = [regex]::Match($source, "(?m)^param serviceShort string = '(?<value>[^']+)'")
            if (-not $nameMatch.Success -or -not $serviceMatch.Success) { throw "Missing $fixture environment name or identifier." }
            $nameExpression = $nameMatch.Groups['expression'].Value
            if ($nameExpression -ceq 'hostingEnvironmentName') {
                $variableMatch = [regex]::Match($source, '(?m)^var hostingEnvironmentName = (?<expression>[^\r\n]+)')
                if (-not $variableMatch.Success) { throw 'Missing environment identity expression.' }
                $nameExpression = $variableMatch.Groups['expression'].Value
            }
            $defaults = @{
                subscription = '00000000-0000-4000-8000-000000000001'
                group = 'fixture-one'
                prefix = 'gci'
                service = $serviceMatch.Groups['value'].Value
                root = 'attempt-one'
                location = 'eastus'
            }
            $overrides = @(
                @{}
                @{ subscription = '00000000-0000-4000-8000-000000000002' }
                @{ group = 'fixture-two' }
                @{ root = 'attempt-two'; location = 'westus3' }
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
                    $expression = $nameExpression.
                        Replace('resourceGroup.id', "'/subscriptions/$($values.subscription)/resourceGroups/$($values.group)'").
                        Replace('deployment().name', "'$($values.root)'").
                        Replace('resourceLocation', "'$($values.location)'").
                        Replace('namePrefix', "'$($values.prefix)'").
                        Replace('serviceShort', "'$($values.service)'").
                        Replace('iteration', "'$iteration'")
                    $parameters += "param case${index}${iteration} = $expression"
                }
            }
            $parameterPath = Join-Path $TestDrive "$fixture-names.bicepparam"
            $parameterOutput = Join-Path $TestDrive "$fixture-names.json"
            $parameters -join "`n" | Set-Content -LiteralPath $parameterPath
            $diagnostics = bicep build-params $parameterPath --no-restore --outfile $parameterOutput 2>&1
            if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
            $names = (Get-Content -LiteralPath $parameterOutput -Raw | ConvertFrom-Json -AsHashtable).parameters
            $compiledPath = Join-Path $TestDrive "$fixture.json"
            $diagnostics = bicep build $fixturePath --no-restore --outfile $compiledPath 2>&1
            if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
            $template = Get-Content -LiteralPath $compiledPath -Raw | ConvertFrom-Json -AsHashtable -Depth 100
            $resources = $template.resources -is [System.Collections.IDictionary] ? @($template.resources.Values) : @($template.resources)
            $tested = @($resources | Where-Object { $_.copy.name -eq 'testDeployment' })[0]
        }

        It 'Separates otherwise identical environments across subscriptions and groups' {
            $names.case0init.value | Should -Not -Be $names.case1init.value
            $names.case0init.value | Should -Not -Be $names.case2init.value
        }

        It 'Preserves identity across retries, regions and serial init/idem' {
            $names.case0init.value | Should -BeExactly $names.case3init.value
            foreach ($index in 0..7) { $names["case${index}init"].value | Should -BeExactly $names["case${index}idem"].value }
            $tested.copy.mode | Should -BeExactly 'serial'
            $tested.copy.batchSize | Should -Be 1
        }

        It 'Bounds the DNS-compatible name while retaining full input uniqueness' {
            foreach ($name in $names.Values) { $name.value | Should -Match '^[a-zA-Z0-9][a-zA-Z0-9-]{0,58}[a-zA-Z0-9]$' }
            $names.case4init.value.Length | Should -Be 60
            $names.case4init.value | Should -Not -Be $names.case5init.value
            $names.case4init.value | Should -Not -Be $names.case6init.value
        }

        It 'Uses one identity for the resource and its identifying tag without changing subnet wiring' {
            $tested.properties.parameters.name.value | Should -BeExactly "[variables('hostingEnvironmentName')]"
            $tested.properties.parameters.subnetResourceId.value | Should -Match '\.outputs\.subnetResourceId\.value'
            if ($fixture -ne 'defaults') {
                $tested.properties.parameters.tags.value.hostingEnvironmentName | Should -BeExactly "[variables('hostingEnvironmentName')]"
                $tested.properties.parameters.internalLoadBalancingMode.value | Should -BeExactly 'Web, Publishing'
                $tested.properties.parameters.zoneRedundant.value | Should -BeTrue
            }
        }
    }
}
