Describe 'App Configuration encryption vault identity' {
    BeforeAll {
        $fixturePath = Join-Path $PSScriptRoot '..' 'e2e' 'encr' 'main.test.bicep'
        $source = Get-Content -LiteralPath $fixturePath -Raw
        $nameMatch = [regex]::Match($source, '(?m)^\s+keyVaultName: (?<expression>[^\r\n]+)')
        $serviceMatch = [regex]::Match($source, "(?m)^param serviceShort string = '(?<value>[^']+)'")
        if (-not $nameMatch.Success -or -not $serviceMatch.Success) { throw 'Missing encryption vault name or service identifier.' }
        $defaults = @{
            subscription = '00000000-0000-4000-8000-000000000001'
            group = 'fixture-one'
            prefix = 'gci'
            service = $serviceMatch.Groups['value'].Value
            root = 'attempt-one'
            location = 'westus3'
            time = '2026-10-08 00:03:47Z'
        }
        $overrides = @(
            @{}
            @{ subscription = '00000000-0000-4000-8000-000000000002' }
            @{ group = 'fixture-two' }
            @{ root = 'attempt-two' }
            @{ location = 'norwayeast' }
            @{ time = '2026-10-08 00:07:57Z' }
            @{ prefix = ('g' * 100); service = ('s' * 100 + 'a') }
            @{ prefix = ('g' * 100); service = ('s' * 100 + 'b') }
            @{ prefix = ('g' * 100 + 'b'); service = ('s' * 100 + 'a') }
        )
        $parameterSource = @('using none')
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
                    Replace('baseTime', "'$($values.time)'").
                    Replace('iteration', "'$iteration'")
                $parameterSource += "param case${index}${iteration} = $expression"
            }
        }
        $parameterPath = Join-Path $TestDrive 'vault-names.bicepparam'
        $parameterOutput = Join-Path $TestDrive 'vault-names.json'
        $parameterSource -join "`n" | Set-Content -LiteralPath $parameterPath
        $diagnostics = bicep build-params $parameterPath --no-restore --outfile $parameterOutput 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $names = (Get-Content -LiteralPath $parameterOutput -Raw | ConvertFrom-Json -AsHashtable).parameters
        $fixtureOutput = Join-Path $TestDrive 'encr.json'
        $diagnostics = bicep build $fixturePath --no-restore --outfile $fixtureOutput 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $template = Get-Content -LiteralPath $fixtureOutput -Raw | ConvertFrom-Json -AsHashtable -Depth 100
        $resources = $template.resources -is [System.Collections.IDictionary] ? @($template.resources.Values) : @($template.resources)
        $dependencies = @($resources | Where-Object { $_.name -match '-nestedDependencies' })[0]
        $testModule = @($resources | Where-Object { $_.name -match '-test-' })[0]
        if ($template.resources -is [System.Collections.IDictionary]) {
            $dependencyId = 'nestedDependencies'
            $dependencyReference = "reference('nestedDependencies')"
        } else {
            $resourceId = "extensionResourceId(format('/subscriptions/{0}/resourceGroups/{1}', subscription().subscriptionId, parameters('resourceGroupName')), 'Microsoft.Resources/deployments', $($dependencies.name.Trim('[', ']')))"
            $dependencyId = "[$resourceId]"
            $dependencyReference = "reference($resourceId, '$($dependencies.apiVersion)')"
        }
        $nested = $dependencies.properties.template
        $nestedResources = $nested.resources -is [System.Collections.IDictionary] ? @($nested.resources.Values) : @($nested.resources)
        $vault = @($nestedResources | Where-Object type -EQ 'Microsoft.KeyVault/vaults')[0]
        $key = @($nestedResources | Where-Object type -EQ 'Microsoft.KeyVault/vaults/keys')[0]
        $roles = @($nestedResources | Where-Object type -EQ 'Microsoft.Authorization/roleAssignments')
    }

    It 'Separates otherwise identical vault generations in different subscriptions' {
        $names.case0init.value | Should -Not -Be $names.case1init.value
    }

    It 'Separates vault generations in different resource groups' {
        $names.case0init.value | Should -Not -Be $names.case2init.value
    }

    It 'Keeps each generation stable across roots, regions and serial init/idem' {
        $names.case0init.value | Should -BeExactly $names.case3init.value
        $names.case0init.value | Should -BeExactly $names.case4init.value
        foreach ($index in 0..($overrides.Count - 1)) {
            $names["case${index}init"].value | Should -BeExactly $names["case${index}idem"].value
        }
        $template.parameters.baseTime.defaultValue | Should -BeExactly "[utcNow('u')]"
        $testModule.copy.count | Should -BeExactly "[length(createArray('init', 'idem'))]"
        $testModule.copy.mode | Should -BeExactly 'serial'
        $testModule.copy.batchSize | Should -Be 1
    }

    It 'Meets vault-name constraints for short and long inputs' {
        foreach ($index in 0..($overrides.Count - 1)) {
            foreach ($iteration in @('init', 'idem')) {
                $value = $names["case${index}${iteration}"].value
                $value | Should -Match '^[a-z][a-z0-9-]{1,22}[a-z0-9]$'
                $value | Should -Not -Match '--'
            }
        }
        $names.case6init.value.Length | Should -Be 20
    }

    It 'Retains differences beyond the readable prefix and service-name bounds' {
        $names.case6init.value | Should -Not -Be $names.case7init.value
        $names.case6init.value | Should -Not -Be $names.case8init.value
    }

    It 'Separates generations whose timestamps previously shared a three-character hash prefix' {
        $names.case0init.value | Should -Not -Be $names.case5init.value
    }

    It 'Passes the scope-qualified generation to the vault in its owning group' {
        $compiledName = $dependencies.properties.parameters.keyVaultName.value
        $compiledName | Should -Match "parameters\('resourceGroupName'\)"
        $compiledName | Should -Match "parameters\('baseTime'\)"
        $compiledName | Should -Match 'uniqueString\('
        $dependencies.resourceGroup | Should -BeExactly "[parameters('resourceGroupName')]"
        $testModule.resourceGroup | Should -BeExactly $dependencies.resourceGroup
        $vault.name | Should -BeExactly "[parameters('keyVaultName')]"
        $testModule.dependsOn | Should -Contain $dependencyId
    }

    It 'Preserves purge protection, key permissions and all customer-managed-key relationships' {
        $vault.properties.enablePurgeProtection | Should -BeTrue
        $vault.properties.softDeleteRetentionInDays | Should -Be 7
        $vault.properties.enableRbacAuthorization | Should -BeTrue
        @($vault.properties.accessPolicies).Count | Should -Be 0
        $vault.properties.enabledForTemplateDeployment | Should -BeTrue
        $vault.properties.enabledForDiskEncryption | Should -BeTrue
        $vault.properties.enabledForDeployment | Should -BeTrue
        $key.name | Should -Match 'keyEncryptionKey'
        $key.properties.kty | Should -BeExactly 'RSA'
        $roles.Count | Should -Be 1
        $roles[0].scope | Should -Match 'keyEncryptionKey'
        $roles[0].scope | Should -Match "parameters\('keyVaultName'\)"
        $roles[0].properties.roleDefinitionId | Should -Match '12338af0-0e69-4776-bea7-57ae8d297424'
        $roles[0].properties.principalType | Should -BeExactly 'ServicePrincipal'
        $roles[0].properties.principalId | Should -BeExactly $nested.outputs.managedIdentityPrincipalId.value
        $parameters = $testModule.properties.parameters
        $parameters.customerManagedKey.value.keyName | Should -BeExactly "[$dependencyReference.outputs.keyName.value]"
        $parameters.customerManagedKey.value.keyVaultResourceId | Should -BeExactly "[$dependencyReference.outputs.keyVaultResourceId.value]"
        $parameters.customerManagedKey.value.userAssignedIdentityResourceId | Should -BeExactly "[$dependencyReference.outputs.managedIdentityResourceId.value]"
        $parameters.enablePurgeProtection.value | Should -BeFalse
        $parameters.softDeleteRetentionInDays.value | Should -Be 1
        $parameters.disableLocalAuth.value | Should -BeExactly "[parameters('disableLocalAuth')]"
        @($parameters.keyValues.value).Count | Should -Be 1
        $parameters.keyValues.value[0].roleAssignments[0].roleDefinitionIdOrName | Should -BeExactly 'Reader'
        $parameters.keyValues.value[0].roleAssignments[0].principalId | Should -BeExactly "[$dependencyReference.outputs.managedIdentityPrincipalId.value]"
    }
}
