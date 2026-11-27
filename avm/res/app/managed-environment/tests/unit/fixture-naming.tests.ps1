BeforeAll {
    $fixturePath = Join-Path $PSScriptRoot '..' 'e2e' 'max' 'main.test.bicep'
    $source = Get-Content -LiteralPath $fixturePath -Raw
    $dependencySource = [regex]::Match($source, '(?ms)^module nestedDependencies\b.*?^}').Value
    $nameMatch = [regex]::Match($dependencySource, '(?m)^\s+storageAccountName: (?<expression>[^\r\n]+)')
    $serviceMatch = [regex]::Match($source, "(?m)^param serviceShort string = '(?<value>[^']+)'")
    if (-not $nameMatch.Success -or -not $serviceMatch.Success) { throw 'Missing maximum fixture storage name or service identifier.' }

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
            $parameterSource += "param storage${index}${iteration} = $expression"
        }
    }
    $parameterPath = Join-Path $TestDrive 'max-storage.bicepparam'
    $parameterOutput = Join-Path $TestDrive 'max-storage.json'
    $parameterSource -join "`n" | Set-Content -LiteralPath $parameterPath
    $diagnostics = bicep build-params $parameterPath --no-restore --outfile $parameterOutput 2>&1
    if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
    $names = (Get-Content -LiteralPath $parameterOutput -Raw | ConvertFrom-Json -AsHashtable).parameters

    $fixtureOutput = Join-Path $TestDrive 'max.json'
    $diagnostics = bicep build $fixturePath --no-restore --outfile $fixtureOutput 2>&1
    if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
    $template = Get-Content -LiteralPath $fixtureOutput -Raw | ConvertFrom-Json -AsHashtable -Depth 100
    $resources = $template.resources -is [System.Collections.IDictionary] ? @($template.resources.Values) : @($template.resources)
    $dependencies = @($resources | Where-Object { $_.name -match '-paramNested' })[0]
    $testModule = @($resources | Where-Object { $_.name -match '-test-' })[0]
    $dependencyResources = $dependencies.properties.template.resources
    $dependencyResources = $dependencyResources -is [System.Collections.IDictionary] ? @($dependencyResources.Values) : @($dependencyResources)
    $storage = @($dependencyResources | Where-Object type -EQ 'Microsoft.Storage/storageAccounts')[0]
}

Describe 'Maximum managed environment storage fixture identity' {
    It 'Separates otherwise identical deployments in different subscriptions' {
        $names.storage0init.value | Should -Not -Be $names.storage1init.value
    }

    It 'Separates deployments in different resource groups' {
        $names.storage0init.value | Should -Not -Be $names.storage2init.value
    }

    It 'Keeps storage identity stable across root attempts, regions and init/idem' {
        $names.storage0init.value | Should -BeExactly $names.storage3init.value
        $names.storage0init.value | Should -BeExactly $names.storage4init.value
        foreach ($index in 0..7) {
            $names["storage${index}init"].value | Should -BeExactly $names["storage${index}idem"].value
        }
        $testModule.copy.count | Should -BeExactly "[length(createArray('init', 'idem'))]"
        $testModule.copy.mode | Should -BeExactly 'serial'
        $testModule.copy.batchSize | Should -Be 1
    }

    It 'Meets the 3-24 character lowercase storage naming rules' {
        foreach ($entry in $names.Values) { $entry.value | Should -Match '^[a-z0-9]{3,24}$' }
        $names.storage5init.value.Length | Should -Be 24
    }

    It 'Keeps full prefix and service inputs distinct after truncation' {
        $names.storage5init.value | Should -Not -Be $names.storage6init.value
        $names.storage5init.value | Should -Not -Be $names.storage7init.value
    }

    It 'Passes the scope-qualified name to the actual dependency account' {
        $dependencies.properties.parameters.storageAccountName.value | Should -Match 'uniqueString\('
        $dependencies.properties.parameters.storageAccountName.value | Should -Match "parameters\('resourceGroupName'\)"
        $storage.name | Should -BeExactly "[parameters('storageAccountName')]"
    }

    It 'Keeps both SMB and NFS shares connected to the renamed account' {
        $dependencies.properties.template.outputs.storageAccountName.value | Should -BeExactly "[parameters('storageAccountName')]"
        $shares = @($testModule.properties.parameters.storages.value)
        $shares.Count | Should -Be 2
        $shares.kind | Should -Contain 'SMB'
        $shares.kind | Should -Contain 'NFS'
        foreach ($share in $shares) {
            $share.storageAccountName | Should -Match '\.outputs\.storageAccountName\.value'
            $share.accessMode | Should -BeExactly 'ReadWrite'
        }
        $storage.sku.name | Should -BeExactly 'Premium_LRS'
    }
}

Describe 'Secondary managed environment vault fixture identity' {
        BeforeAll {
            $vaultFixturePath = Join-Path $PSScriptRoot '..' 'e2e' 'secondary-rg' 'main.test.bicep'
            $vaultSource = Get-Content -LiteralPath $vaultFixturePath -Raw
            $secondarySource = [regex]::Match($vaultSource, '(?ms)^module secondaryDependencies\b.*?^}').Value
            $vaultMatch = [regex]::Match($secondarySource, '(?m)^\s+keyVaultName: (?<expression>[^\r\n]+)')
            $ownerSource = [regex]::Match($vaultSource, '(?ms)^resource secondaryResourceGroup\b.*?^}').Value
            $ownerMatch = [regex]::Match($ownerSource, '(?m)^\s+name: (?<expression>[^\r\n]+)')
            $vaultService = [regex]::Match($vaultSource, "(?m)^param serviceShort string = '(?<value>[^']+)'")
            if (-not $vaultMatch.Success -or -not $ownerMatch.Success -or -not $vaultService.Success) {
                throw 'Missing secondary vault name, owning group or service identifier.'
            }
            $vaultDefaults = $defaults.Clone()
            $vaultDefaults.service = $vaultService.Groups['value'].Value
            $vaultOverrides = $overrides + @(@{ prefix = 'gci-token'; service = 'amecert-type' }, @{ prefix = ''; service = '' })
            $vaultParameterSource = @('using none')
            for ($index = 0; $index -lt $vaultOverrides.Count; $index++) {
                $values = $vaultDefaults.Clone()
                foreach ($key in $vaultOverrides[$index].Keys) { $values[$key] = $vaultOverrides[$index][$key] }
                $ownerExpression = $ownerMatch.Groups['expression'].Value.Replace('resourceGroupName', "'$($values.group)'")
                $ownerId = "'/subscriptions/$($values.subscription)/resourceGroups/`${($ownerExpression)}'"
                foreach ($iteration in @('init', 'idem')) {
                    $expression = $vaultMatch.Groups['expression'].Value.
                    Replace('secondaryResourceGroup.id', "($ownerId)").
                    Replace('primaryResourceGroup.id', "'/subscriptions/$($values.subscription)/resourceGroups/$($values.group)'").
                    Replace('subscription().subscriptionId', "'$($values.subscription)'").
                    Replace('resourceGroupName', "'$($values.group)'").
                    Replace('deployment().name', "'$($values.root)'").
                    Replace('resourceLocation', "'$($values.location)'").
                    Replace('namePrefix', "'$($values.prefix)'").
                    Replace('serviceShort', "'$($values.service)'").
                    Replace('iteration', "'$iteration'")
                    $vaultParameterSource += "param vault${index}${iteration} = $expression"
                }
            }
            $vaultParameterPath = Join-Path $TestDrive 'secondary-vault.bicepparam'
            $vaultParameterOutput = Join-Path $TestDrive 'secondary-vault-names.json'
            $vaultParameterSource -join "`n" | Set-Content -LiteralPath $vaultParameterPath
            $diagnostics = bicep build-params $vaultParameterPath --no-restore --outfile $vaultParameterOutput 2>&1
            if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
            $vaultNames = (Get-Content -LiteralPath $vaultParameterOutput -Raw | ConvertFrom-Json -AsHashtable).parameters
            $vaultFixtureOutput = Join-Path $TestDrive 'secondary-rg.json'
            $diagnostics = bicep build $vaultFixturePath --no-restore --outfile $vaultFixtureOutput 2>&1
            if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
            $vaultTemplate = Get-Content -LiteralPath $vaultFixtureOutput -Raw | ConvertFrom-Json -AsHashtable -Depth 100
            $vaultResources = $vaultTemplate.resources -is [System.Collections.IDictionary] ? @($vaultTemplate.resources.Values) : @($vaultTemplate.resources)
            $vaultDependencies = @($vaultResources | Where-Object {
                    $_.type -eq 'Microsoft.Resources/deployments' -and $_.properties.parameters.Contains('keyVaultName')
                })[0]
            $vaultTestModule = @($vaultResources | Where-Object { $_.name -match '-test-' })[0]
            $nestedVaultResources = $vaultDependencies.properties.template.resources
            $nestedVaultResources = $nestedVaultResources -is [System.Collections.IDictionary] ? @($nestedVaultResources.Values) : @($nestedVaultResources)
            $vault = @($nestedVaultResources | Where-Object type -EQ 'Microsoft.KeyVault/vaults')[0]
        }

        It 'Separates otherwise identical deployments in different subscriptions' {
            $vaultNames.vault0init.value | Should -Not -Be $vaultNames.vault1init.value
        }

        It 'Separates deployments in different owning resource groups' {
            $vaultNames.vault0init.value | Should -Not -Be $vaultNames.vault2init.value
        }

        It 'Keeps vault identity stable across roots, regions and serial init/idem' {
            $vaultNames.vault0init.value | Should -BeExactly $vaultNames.vault3init.value
            $vaultNames.vault0init.value | Should -BeExactly $vaultNames.vault4init.value
            foreach ($index in 0..($vaultOverrides.Count - 1)) {
                $vaultNames["vault${index}init"].value | Should -BeExactly $vaultNames["vault${index}idem"].value
            }
            $vaultTestModule.copy.count | Should -BeExactly "[length(createArray('init', 'idem'))]"
            $vaultTestModule.copy.mode | Should -BeExactly 'serial'
            $vaultTestModule.copy.batchSize | Should -Be 1
        }

        It 'Meets vault character and length constraints for all prefix inputs' {
            foreach ($entry in $vaultNames.Values) {
                $entry.value | Should -Match '^[a-zA-Z][a-zA-Z0-9-]{1,22}[a-zA-Z0-9]$'
                $entry.value | Should -Not -Match '--'
            }
            $vaultNames.vault5init.value.Length | Should -Be 20
        }

        It 'Keeps full prefix and service inputs distinct' {
            $vaultNames.vault5init.value | Should -Not -Be $vaultNames.vault6init.value
            $vaultNames.vault5init.value | Should -Not -Be $vaultNames.vault7init.value
        }

        It 'Uses the actual secondary scope rather than the consuming primary group' {
            $vaultDependencies.resourceGroup | Should -BeExactly "[format('{0}-snd', parameters('resourceGroupName'))]"
            $vaultDependencies.properties.parameters.keyVaultName.value |
                Should -Match "uniqueString\(subscriptionResourceId\('Microsoft.Resources/resourceGroups', format\('\{0\}-snd', parameters\('resourceGroupName'\)\)\)"
            $vaultTestModule.resourceGroup | Should -BeExactly "[parameters('resourceGroupName')]"
            $vault.name | Should -BeExactly "[parameters('keyVaultName')]"
        }

        It 'Preserves vault security and the external certificate identity and URI chain' {
            $vault.properties.enableRbacAuthorization | Should -BeTrue
            @($vault.properties.accessPolicies).Count | Should -Be 0
            $vault.properties.Contains('enablePurgeProtection') | Should -BeTrue
            $vault.properties.enablePurgeProtection | Should -BeNullOrEmpty
            $vault.properties.enabledForTemplateDeployment | Should -BeTrue
            $vault.properties.enabledForDiskEncryption | Should -BeTrue
            $vault.properties.enabledForDeployment | Should -BeTrue
            $vaultDependencies.properties.template.outputs.keyVaultResourceId.value |
                Should -BeExactly "[resourceId('Microsoft.KeyVault/vaults', parameters('keyVaultName'))]"
            $certScript = @($nestedVaultResources | Where-Object type -EQ 'Microsoft.Resources/deploymentScripts')[0]
            $certScript.properties.arguments | Should -Match "parameters\('keyVaultName'\)"
            $certificate = $vaultTestModule.properties.parameters.certificate.value.certificateKeyVaultProperties
            $certificate.identityResourceId | Should -Match '\.outputs\.managedIdentityResourceId\.value'
            $certificate.keyVaultUrl | Should -Match '\.outputs\.keyVaultUri\.value'
            $certificate.keyVaultUrl | Should -Match '\.outputs\.certificateSecretUrl\.value'
            $vaultTestModule.properties.parameters.internal.value | Should -BeTrue
            @($vaultTestModule.properties.parameters.managedIdentities.value.userAssignedResourceIds).Count | Should -Be 1
        }
}

Describe 'Maximum managed environment custom role identity' {
    BeforeAll {
        $roleBlock = [regex]::Match($source, '(?ms)^      roleAssignments:\s*\[(?<assignments>.*?)^      \]')
        $roleMatches = [regex]::Matches($roleBlock.Groups['assignments'].Value, '(?s)\{\s*name:\s*(?<expression>.*?)\s+roleDefinitionIdOrName:')
        if (-not $roleBlock.Success -or $roleMatches.Count -ne 1) {
            throw 'Expected exactly one explicit environment role-assignment name.'
        }
        $nameExpression = $roleMatches[0].Groups['expression'].Value.Trim()
        $roleDefaults = $defaults.Clone()
        $roleDefaults.principal = '00000000-0000-4000-8000-000000000003'
        $script:environmentRoleScenarios = @(
            @{}
            @{ subscription = '00000000-0000-4000-8000-000000000002' }
            @{ group = 'fixture-two' }
            @{ principal = '00000000-0000-4000-8000-000000000004' }
            @{ prefix = 'local' }
            @{ service = 'another' }
        )
        $roleParameters = @('using none')
        for ($scopeIndex = 0; $scopeIndex -lt $script:environmentRoleScenarios.Count; $scopeIndex++) {
            $values = $roleDefaults.Clone()
            foreach ($key in $script:environmentRoleScenarios[$scopeIndex].Keys) {
                $values[$key] = $script:environmentRoleScenarios[$scopeIndex][$key]
            }
            $groupId = "/subscriptions/$($values.subscription)/resourceGroups/$($values.group)"
            $identityId = "$groupId/providers/Microsoft.ManagedIdentity/userAssignedIdentities/fixture-identity"
            foreach ($attempt in 1..3) {
                $location = @('eastus', 'norwayeast', 'swedencentral')[$attempt - 1]
                foreach ($iteration in @('init', 'idem')) {
                    $expression = $nameExpression.
                    Replace('resourceGroup.id', "'$groupId'").
                    Replace('subscription().subscriptionId', "'$($values.subscription)'").
                    Replace('resourceGroupName', "'$($values.group)'").
                    Replace('nestedDependencies.outputs.managedIdentityPrincipalId', "'$($values.principal)'").
                    Replace('nestedDependencies.outputs.managedIdentityResourceId', "'$identityId'").
                    Replace('namePrefix', "'$($values.prefix)'").
                    Replace('serviceShort', "'$($values.service)'").
                    Replace('deployment().name', "'attempt-$attempt'").
                    Replace('deployment().location', "'$location'").
                    Replace('resourceLocation', "'$location'").
                    Replace('iteration', "'$iteration'")
                    $roleParameters += "param rolescope${scopeIndex}t${attempt}${iteration} = $expression"
                }
            }
        }
        $roleParameterPath = Join-Path $TestDrive 'max-role-name.bicepparam'
        $roleParameterOutput = Join-Path $TestDrive 'max-role-name.json'
        $roleParameters -join "`n" | Set-Content -LiteralPath $roleParameterPath
        $diagnostics = bicep build-params $roleParameterPath --no-restore --outfile $roleParameterOutput 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $script:environmentRoleNames = (Get-Content -LiteralPath $roleParameterOutput -Raw | ConvertFrom-Json -AsHashtable).parameters
        $script:environmentRoleAssignments = @($testModule.properties.parameters.roleAssignments.value)
    }

    It 'Separates Contributor assignment names across <dimension>' -ForEach @(
        @{ dimension = 'subscriptions'; scopeIndex = 1 }
        @{ dimension = 'resource groups'; scopeIndex = 2 }
        @{ dimension = 'recreated principals'; scopeIndex = 3 }
        @{ dimension = 'environment prefixes'; scopeIndex = 4 }
        @{ dimension = 'environment short names'; scopeIndex = 5 }
    ) {
        $script:environmentRoleNames["rolescope${scopeIndex}t1init"].value |
            Should -Not -Be $script:environmentRoleNames.rolescope0t1init.value
    }

    It 'Keeps the retained principal name stable across root, location and init/idem changes' {
        for ($scopeIndex = 0; $scopeIndex -lt $script:environmentRoleScenarios.Count; $scopeIndex++) {
            $roleNames = @(
                foreach ($attempt in 1..3) {
                    foreach ($iteration in @('init', 'idem')) {
                        $script:environmentRoleNames["rolescope${scopeIndex}t${attempt}${iteration}"].value
                    }
                }
            )
            @($roleNames | Select-Object -Unique).Count | Should -Be 1
        }
    }

    It 'Produces a distinct valid GUID for each scope, principal and environment name combination' {
        foreach ($entry in $script:environmentRoleNames.Values) {
            $entry.value | Should -Match '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$'
        }
        @($script:environmentRoleNames.Values.value | Select-Object -Unique).Count |
            Should -Be $script:environmentRoleScenarios.Count
    }

    It 'Keeps only the Contributor custom name and both automatic-name cases' {
        $script:environmentRoleAssignments.Count | Should -Be 3
        $script:environmentRoleAssignments[0].Contains('name') | Should -BeFalse
        $script:environmentRoleAssignments[1].Contains('name') | Should -BeTrue
        $script:environmentRoleAssignments[2].Contains('name') | Should -BeFalse
    }

    It 'Preserves the roles, ServicePrincipal types and actual managed-identity reference' {
        $script:environmentRoleAssignments[0].roleDefinitionIdOrName | Should -BeExactly 'Reader'
        $script:environmentRoleAssignments[1].roleDefinitionIdOrName | Should -BeExactly 'b24988ac-6180-42a0-ab88-20f7382dd24c'
        $script:environmentRoleAssignments[2].roleDefinitionIdOrName |
            Should -BeExactly "[subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '43d0d8ad-25c7-4714-9337-8ba259a9fe05')]"
        foreach ($assignment in $script:environmentRoleAssignments) {
            $assignment.principalType | Should -BeExactly 'ServicePrincipal'
            $assignment.principalId | Should -BeExactly $script:environmentRoleAssignments[1].principalId
            $assignment.principalId | Should -Match '\.outputs\.managedIdentityPrincipalId\.value'
        }
        $testModule.properties.parameters.managedIdentities.value.systemAssigned | Should -BeTrue
        @($testModule.properties.parameters.managedIdentities.value.userAssignedResourceIds).Count | Should -Be 1
        $testModule.properties.parameters.managedIdentities.value.userAssignedResourceIds[0] |
            Should -Match '\.outputs\.managedIdentityResourceId\.value'
    }

    It 'Forwards the full environment scope and assignment principal into the custom name' {
        $assignment = $script:environmentRoleAssignments[1]
        $assignment.name | Should -Match 'Microsoft\.App/managedEnvironments/'
        $assignment.name | Should -Match "subscriptionResourceId\('Microsoft.Resources/resourceGroups', parameters\('resourceGroupName'\)\)"
        $assignment.name | Should -Match "parameters\('namePrefix'\)"
        $assignment.name | Should -Match "parameters\('serviceShort'\)"
        $principalExpression = $assignment.principalId.Substring(1, $assignment.principalId.Length - 2)
        $assignment.name | Should -Match ([regex]::Escape($principalExpression))
    }

    It 'Keeps location unpinned, the environment name unchanged and init/idem serial' {
        $template.parameters.resourceLocation.defaultValue | Should -BeExactly '[deployment().location]'
        $testModule.properties.parameters.location.value | Should -BeExactly "[parameters('resourceLocation')]"
        $testModule.properties.parameters.name.value |
            Should -BeExactly "[format('{0}{1}001', parameters('namePrefix'), parameters('serviceShort'))]"
        $testModule.copy.mode | Should -BeExactly 'serial'
        $testModule.copy.batchSize | Should -Be 1
        $testModule.copy.count | Should -BeExactly "[length(createArray('init', 'idem'))]"
    }
}
