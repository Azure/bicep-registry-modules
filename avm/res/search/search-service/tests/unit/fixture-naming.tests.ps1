Describe 'Search fixture global resource identities' {
    Context '<scenario> <kind>' -ForEach @(
        @{ scenario = 'pe'; kind = 'storage'; parameter = 'storageAccountName'; maximumLength = 24; expectedLength = 24 }
        @{ scenario = 'max'; kind = 'service'; parameter = 'name'; maximumLength = 60; expectedLength = 60 }
        @{ scenario = 'pe'; kind = 'vault'; parameter = 'keyVaultName'; maximumLength = 24; expectedLength = 20 }
        @{ scenario = 'pe'; kind = 'service'; parameter = 'name'; maximumLength = 60; expectedLength = 60 }
        @{ scenario = 'defaults'; kind = 'service'; parameter = 'name'; maximumLength = 60; expectedLength = 60 }
    ) {
        BeforeAll {
            $fixturePath = Join-Path $PSScriptRoot '..' 'e2e' $scenario 'main.test.bicep'
            $source = Get-Content -LiteralPath $fixturePath -Raw
            if ($kind -in @('storage', 'vault')) {
                $nameSource = [regex]::Match($source, '(?ms)^module nestedDependencies\b.*?^}').Value
                $namePattern = "(?m)^\s+${parameter}: (?<expression>[^\r\n]+)"
            } else {
                $nameSource = [regex]::Match($source, '(?ms)^module testDeployment\b.*\z').Value
                $namePattern = "(?m)^\s+name: (?<expression>'[^\r\n]*namePrefix[^\r\n]+)"
            }
            $nameMatch = [regex]::Match($nameSource, $namePattern)
            $serviceMatch = [regex]::Match($source, "(?m)^param serviceShort string = '(?<value>[^']+)'")
            if (-not $nameMatch.Success -or -not $serviceMatch.Success) { throw "Missing $scenario fixture $kind name or service identifier." }

            $defaults = @{
                subscription = '00000000-0000-4000-8000-000000000001'
                group = 'fixture-one'
                root = 'attempt-one'
                location = 'eastus'
                prefix = 'gci'
                service = $serviceMatch.Groups['value'].Value
            }
            $overrides = @(
                @{}
                @{ subscription = '00000000-0000-4000-8000-000000000002' }
                @{ group = 'fixture-two' }
                @{ root = 'attempt-two' }
                @{ location = 'norwayeast' }
                @{ prefix = ('g' * 100); service = ('s' * 100 + 'a') }
                @{ prefix = ('g' * 100); service = ('s' * 100 + 'b') }
                @{ prefix = ('g' * 100 + 'b'); service = ('s' * 100 + 'a') }
            )
            if ($kind -eq 'vault') {
                $overrides += @(
                    @{ prefix = 'gci-token'; service = 'ssspr-type' }
                    @{ prefix = ''; service = '' }
                )
            }
            $parameterSource = @('using none')
            for ($index = 0; $index -lt $overrides.Count; $index++) {
                $values = $defaults.Clone()
                foreach ($key in $overrides[$index].Keys) { $values[$key] = $overrides[$index][$key] }
                foreach ($iteration in @('init', 'idem')) {
                    $expression = $nameMatch.Groups['expression'].Value.
                    Replace('resourceGroup.id', "'/subscriptions/$($values.subscription)/resourceGroups/$($values.group)'").
                    Replace('subscription().subscriptionId', "'$($values.subscription)'").
                    Replace('resourceGroupName', "'$($values.group)'").
                    Replace('deployment().name', "'$($values.root)'").
                    Replace('resourceLocation', "'$($values.location)'").
                    Replace('namePrefix', "'$($values.prefix)'").
                    Replace('serviceShort', "'$($values.service)'").
                    Replace('iteration', "'$iteration'")
                    $parameterSource += "param resource${index}${iteration} = $expression"
                }
            }
            $parameterPath = Join-Path $TestDrive "$scenario-names.bicepparam"
            $parameterOutput = Join-Path $TestDrive "$scenario-names.json"
            $parameterSource -join "`n" | Set-Content -LiteralPath $parameterPath
            $diagnostics = bicep build-params $parameterPath --no-restore --outfile $parameterOutput 2>&1
            if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
            $names = (Get-Content -LiteralPath $parameterOutput -Raw | ConvertFrom-Json -AsHashtable).parameters

            $fixtureOutput = Join-Path $TestDrive "$scenario.json"
            $diagnostics = bicep build $fixturePath --no-restore --outfile $fixtureOutput 2>&1
            if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
            $template = Get-Content -LiteralPath $fixtureOutput -Raw | ConvertFrom-Json -AsHashtable -Depth 100
            $resources = $template.resources -is [System.Collections.IDictionary] ? @($template.resources.Values) : @($template.resources)
            $dependencies = @($resources | Where-Object { $_.name -match '-nestedDependencies' })[0]
            $testModule = @($resources | Where-Object { $_.name -match '-test-' })[0]
            $namedModule = $kind -eq 'service' ? $testModule : $dependencies
            $resourceType = switch ($kind) {
                storage { 'Microsoft.Storage/storageAccounts' }
                service { 'Microsoft.Search/searchServices' }
                vault { 'Microsoft.KeyVault/vaults' }
            }
            $namedResources = $namedModule.properties.template.resources
            $namedResources = $namedResources -is [System.Collections.IDictionary] ? @($namedResources.Values) : @($namedResources)
            $namedResource = @($namedResources | Where-Object type -EQ $resourceType)[0]
        }

        It 'Separates otherwise identical deployments in different subscriptions' {
            $names.resource0init.value | Should -Not -Be $names.resource1init.value
        }

        It 'Separates deployments in different resource groups' {
            $names.resource0init.value | Should -Not -Be $names.resource2init.value
        }

        It 'Keeps resource identity stable across root attempts, regions and init/idem' {
            $names.resource0init.value | Should -BeExactly $names.resource3init.value
            $names.resource0init.value | Should -BeExactly $names.resource4init.value
            foreach ($index in 0..($overrides.Count - 1)) {
                $names["resource${index}init"].value | Should -BeExactly $names["resource${index}idem"].value
            }
            $testModule.copy.count | Should -BeExactly "[length(createArray('init', 'idem'))]"
            $testModule.copy.mode | Should -BeExactly 'serial'
            $testModule.copy.batchSize | Should -Be 1
        }

        It 'Meets the provider character and length limits' {
            foreach ($entry in $names.Values) {
                if ($kind -eq 'storage') {
                    $entry.value | Should -Match '^[a-z0-9]{3,24}$'
                } elseif ($kind -eq 'vault') {
                    $entry.value | Should -Match '^[a-zA-Z][a-zA-Z0-9-]{1,22}[a-zA-Z0-9]$'
                    $entry.value | Should -Not -Match '--'
                } else {
                    $entry.value | Should -Match '^[a-z0-9]{2}(?:[a-z0-9-]{0,57}[a-z0-9])?$'
                    $entry.value | Should -Not -Match '--'
                }
                $entry.value.Length | Should -BeLessOrEqual $maximumLength
            }
            $names.resource5init.value.Length | Should -Be $expectedLength
        }

        It 'Keeps full prefix and service inputs distinct after truncation' {
            $names.resource5init.value | Should -Not -Be $names.resource6init.value
            $names.resource5init.value | Should -Not -Be $names.resource7init.value
        }

        It 'Passes the scope-qualified name to the intended resource' {
            $namedModule.properties.parameters[$parameter].value | Should -Match 'uniqueString\('
            $namedModule.properties.parameters[$parameter].value | Should -Match "parameters\('resourceGroupName'\)"
            $namedResource.name | Should -BeExactly "[parameters('$parameter')]"
        }

        It 'Preserves the private-link or maximum encryption and identity coverage' {
            if ($kind -eq 'storage') {
                $dependencies.properties.template.outputs.storageAccountResourceId.value | Should -Match "parameters\('storageAccountName'\)"
                $testModule.properties.parameters.sharedPrivateLinkResources.value[0].privateLinkResourceId |
                    Should -Match '\.outputs\.storageAccountResourceId\.value'
                @($testModule.properties.parameters.sharedPrivateLinkResources.value).Count | Should -Be 2
                $testModule.properties.parameters.publicNetworkAccess.value | Should -BeExactly 'Disabled'
            } elseif ($kind -eq 'vault') {
                $dependencies.resourceGroup | Should -BeExactly "[parameters('resourceGroupName')]"
                $dependencies.dependsOn | Should -Contain 'resourceGroup'
                $testModule.dependsOn | Should -Contain 'nestedDependencies'
                $namedResource.location | Should -BeExactly "[parameters('location')]"
                $namedResource.properties.tenantId | Should -BeExactly '[tenant().tenantId]'
                $namedResource.properties.enableRbacAuthorization | Should -BeTrue
                $namedResource.properties.Contains('accessPolicies') | Should -BeTrue
                @($namedResource.properties.accessPolicies).Count | Should -Be 0
                $namedResource.properties.Contains('enablePurgeProtection') | Should -BeTrue
                $namedResource.properties.enablePurgeProtection | Should -BeNullOrEmpty
                $namedResource.properties.enabledForTemplateDeployment | Should -BeTrue
                $namedResource.properties.enabledForDiskEncryption | Should -BeTrue
                $namedResource.properties.enabledForDeployment | Should -BeTrue
                $dependencies.properties.template.outputs.keyVaultResourceId.value |
                    Should -BeExactly "[resourceId('Microsoft.KeyVault/vaults', parameters('keyVaultName'))]"
                $dependencies.properties.template.outputs.keyVaultLocation.value | Should -Match "parameters\('keyVaultName'\)"
                $vaultLinks = @($testModule.properties.parameters.sharedPrivateLinkResources.value | Where-Object groupId -EQ 'vault')
                $vaultLinks.Count | Should -Be 1
                $vaultLinks[0].privateLinkResourceId | Should -BeExactly "[reference('nestedDependencies').outputs.keyVaultResourceId.value]"
                @($testModule.properties.parameters.sharedPrivateLinkResources.value).Count | Should -Be 2
                @($testModule.properties.parameters.privateEndpoints.value).Count | Should -Be 2
                $testModule.properties.parameters.publicNetworkAccess.value | Should -BeExactly 'Disabled'
            } elseif ($scenario -eq 'pe') {
                $parameters = $testModule.properties.parameters
                $parameters.publicNetworkAccess.value | Should -BeExactly 'Disabled'
                @($parameters.privateEndpoints.value).Count | Should -Be 2
                foreach ($endpoint in $parameters.privateEndpoints.value) {
                    $endpoint.subnetResourceId | Should -BeExactly "[reference('nestedDependencies').outputs.subnetResourceId.value]"
                    $endpoint.privateDnsZoneGroup.privateDnsZoneGroupConfigs[0].privateDnsZoneResourceId |
                        Should -BeExactly "[reference('nestedDependencies').outputs.privateDNSZoneResourceId.value]"
                }
                $parameters.privateEndpoints.value[0].applicationSecurityGroupResourceIds[0] |
                    Should -BeExactly "[reference('nestedDependencies').outputs.applicationSecurityGroupResourceId.value]"
                @($parameters.sharedPrivateLinkResources.value).Count | Should -Be 2
                $parameters.sharedPrivateLinkResources.value[0].privateLinkResourceId |
                    Should -BeExactly "[reference('nestedDependencies').outputs.storageAccountResourceId.value]"
                $parameters.sharedPrivateLinkResources.value[1].privateLinkResourceId |
                    Should -BeExactly "[reference('nestedDependencies').outputs.keyVaultResourceId.value]"
                $testModule.dependsOn | Should -Contain 'nestedDependencies'
            } elseif ($scenario -eq 'defaults') {
                @($testModule.properties.parameters.Keys).Count | Should -Be 1
                $testModule.properties.parameters.Contains('name') | Should -BeTrue
                $testModule.resourceGroup | Should -BeExactly "[parameters('resourceGroupName')]"
                $dependencies | Should -BeNullOrEmpty
            } else {
                $testModule.properties.parameters.cmkEnforcement.value | Should -BeExactly 'Enabled'
                $testModule.properties.parameters.hostingMode.value | Should -BeExactly 'HighDensity'
                $testModule.properties.parameters.managedIdentities.value.systemAssigned | Should -BeTrue
                @($testModule.properties.parameters.managedIdentities.value.userAssignedResourceIds).Count | Should -Be 1
                @($testModule.properties.parameters.roleAssignments.value).Count | Should -Be 3
            }
        }
    }
}
