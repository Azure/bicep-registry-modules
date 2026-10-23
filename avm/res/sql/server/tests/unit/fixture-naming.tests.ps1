Describe 'SQL security fixture storage identities' {
    Context '<fixture>' -ForEach @(
        @{ fixture = 'audit'; setting = 'auditSettings'; firewall = 'Allow' }
        @{ fixture = 'vulnAssm'; setting = 'vulnerabilityAssessmentsObj'; firewall = 'Deny' }
    ) {
        BeforeAll {
            $fixturePath = Join-Path $PSScriptRoot '..' 'e2e' $fixture 'main.test.bicep'
            $source = Get-Content -LiteralPath $fixturePath -Raw
            $nameMatch = [regex]::Match($source, '(?m)^\s+storageAccountName: (?<expression>[^\r\n]+)')
            $serviceMatch = [regex]::Match($source, "(?m)^param serviceShort string = '(?<value>[^']+)'")
            if (-not $nameMatch.Success -or -not $serviceMatch.Success) { throw "Missing $fixture storage name or service identifier." }
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
                    $expression = $nameMatch.Groups['expression'].Value.
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
            $dependencies = @($resources | Where-Object { $_.name -match '-nestedDependencies' })[0]
            $tested = @($resources | Where-Object { $_.copy.name -eq 'testDeployment' })[0]
            $dependencyResources = $dependencies.properties.template.resources
            $dependencyResources = $dependencyResources -is [System.Collections.IDictionary] ? @($dependencyResources.Values) : @($dependencyResources)
            $storage = @($dependencyResources | Where-Object type -EQ 'Microsoft.Storage/storageAccounts')[0]
        }

        It 'Separates identical names across subscriptions and owning resource groups' {
            $names.case0init.value | Should -Not -Be $names.case1init.value
            $names.case0init.value | Should -Not -Be $names.case2init.value
        }

        It 'Keeps the account stable across root attempts, regions and init/idem' {
            $names.case0init.value | Should -BeExactly $names.case3init.value
            foreach ($index in 0..7) { $names["case${index}init"].value | Should -BeExactly $names["case${index}idem"].value }
            $tested.copy.mode | Should -BeExactly 'serial'
            $tested.copy.batchSize | Should -Be 1
        }

        It 'Meets storage account length and character constraints without losing truncated identity' {
            foreach ($name in $names.Values) { $name.value | Should -Match '^[a-z0-9]{3,24}$' }
            $names.case4init.value.Length | Should -Be 24
            $names.case4init.value | Should -Not -Be $names.case5init.value
            $names.case4init.value | Should -Not -Be $names.case6init.value
        }

        It 'Preserves the actual account and security-setting resource ID wiring' {
            $dependencies.properties.parameters.storageAccountName.value | Should -Match 'uniqueString\('
            $dependencies.properties.parameters.storageAccountName.value | Should -Match "parameters\('resourceGroupName'\)"
            $storage.name | Should -BeExactly "[parameters('storageAccountName')]"
            $storage.sku.name | Should -BeExactly 'Standard_LRS'
            $storage.properties.networkAcls.defaultAction | Should -BeExactly $firewall
            $dependencies.properties.template.outputs.storageAccountResourceId.value |
                Should -BeExactly "[resourceId('Microsoft.Storage/storageAccounts', parameters('storageAccountName'))]"
            $tested.properties.parameters[$setting].value.storageAccountResourceId | Should -Match '\.outputs\.storageAccountResourceId\.value'
        }
    }
}
