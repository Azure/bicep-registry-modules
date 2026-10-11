Describe 'Log Analytics storage fixture identities' {
    Context '<scenario>' -ForEach @(
        @{ scenario = 'max' }
        @{ scenario = 'waf-aligned' }
    ) {
        BeforeAll {
            $fixturePath = Join-Path $PSScriptRoot '..' 'e2e' $scenario 'main.test.bicep'
            $source = Get-Content -LiteralPath $fixturePath -Raw
            $dependencySource = [regex]::Match($source, '(?ms)^module nestedDependencies\b.*?^}').Value
            $nameMatch = [regex]::Match($dependencySource, '(?m)^\s+storageAccountName: (?<expression>[^\r\n]+)')
            $serviceMatch = [regex]::Match($source, "(?m)^param serviceShort string = '(?<value>[^']+)'")
            if (-not $nameMatch.Success -or -not $serviceMatch.Success) { throw "Missing $scenario fixture storage name or service identifier." }

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
            $parameterPath = Join-Path $TestDrive "$scenario-storage.bicepparam"
            $parameterOutput = Join-Path $TestDrive "$scenario-storage.json"
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
            $dependencyResources = $dependencies.properties.template.resources
            $dependencyResources = $dependencyResources -is [System.Collections.IDictionary] ? @($dependencyResources.Values) : @($dependencyResources)
            $storage = @($dependencyResources | Where-Object type -EQ 'Microsoft.Storage/storageAccounts')[0]
        }

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

        It 'Keeps linked storage and storage insights connected to the renamed account' {
            $dependencies.properties.template.outputs.storageAccountResourceId.value | Should -Match "parameters\('storageAccountName'\)"
            $testModule.properties.parameters.linkedStorageAccounts.value[0].storageAccountIds[0] |
                Should -Match '\.outputs\.storageAccountResourceId\.value'
            $testModule.properties.parameters.storageInsightsConfigs.value[0].storageAccountResourceId |
                Should -Match '\.outputs\.storageAccountResourceId\.value'
        }
    }
}

Describe 'Log Analytics maximum fixture role names' {
    BeforeAll {
        $fixturePath = Join-Path $PSScriptRoot '..' 'e2e' 'max' 'main.test.bicep'
        $source = Get-Content -LiteralPath $fixturePath -Raw
        $roleBlock = [regex]::Match($source, '(?ms)^      roleAssignments:\s*\[(?<assignments>.*?)^      \]')
        $roleMatches = [regex]::Matches($roleBlock.Groups['assignments'].Value, '(?s)\{\s*name:\s*(?<expression>.*?)\s+roleDefinitionIdOrName:')
        $serviceMatch = [regex]::Match($source, "(?m)^param serviceShort string = '(?<value>[^']+)'")
        if (-not $roleBlock.Success -or $roleMatches.Count -ne 2 -or -not $serviceMatch.Success) {
            throw 'Expected two explicit workspace role names and the maximum fixture service identifier.'
        }
        $expressions = @($roleMatches | ForEach-Object { $_.Groups['expression'].Value.Trim() })
        $defaults = @{
            subscription = '00000000-0000-4000-8000-000000000001'
            group = 'fixture-one'
            principal = '00000000-0000-4000-8000-000000000003'
            prefix = 'gci'
            service = $serviceMatch.Groups['value'].Value
        }
        $script:lawRoleScenarios = @(
            @{}
            @{ subscription = '00000000-0000-4000-8000-000000000002' }
            @{ group = 'fixture-two' }
            @{ principal = '00000000-0000-4000-8000-000000000004' }
            @{ prefix = 'local' }
            @{ service = 'another' }
        )
        $parameterSource = @('using none')
        for ($scopeIndex = 0; $scopeIndex -lt $script:lawRoleScenarios.Count; $scopeIndex++) {
            $values = $defaults.Clone()
            foreach ($key in $script:lawRoleScenarios[$scopeIndex].Keys) {
                $values[$key] = $script:lawRoleScenarios[$scopeIndex][$key]
            }
            $groupId = "/subscriptions/$($values.subscription)/resourceGroups/$($values.group)"
            $identityId = "$groupId/providers/Microsoft.ManagedIdentity/userAssignedIdentities/fixture-identity"
            foreach ($attempt in 1..3) {
                $location = @('eastus', 'norwayeast', 'swedencentral')[$attempt - 1]
                foreach ($iteration in @('init', 'idem')) {
                    for ($roleIndex = 0; $roleIndex -lt $expressions.Count; $roleIndex++) {
                        $expression = $expressions[$roleIndex].
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
                        $parameterSource += "param role${roleIndex}scope${scopeIndex}t${attempt}${iteration} = $expression"
                    }
                }
            }
        }
        $parameterPath = Join-Path $TestDrive 'max-role-names.bicepparam'
        $parameterOutput = Join-Path $TestDrive 'max-role-names.json'
        $parameterSource -join "`n" | Set-Content -LiteralPath $parameterPath
        $diagnostics = bicep build-params $parameterPath --no-restore --outfile $parameterOutput 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $script:lawRoleNames = (Get-Content -LiteralPath $parameterOutput -Raw | ConvertFrom-Json -AsHashtable).parameters

        $fixtureOutput = Join-Path $TestDrive 'max-roles.json'
        $diagnostics = bicep build $fixturePath --no-restore --outfile $fixtureOutput 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $script:lawRoleTemplate = Get-Content -LiteralPath $fixtureOutput -Raw | ConvertFrom-Json -AsHashtable -Depth 100
        $resources = $script:lawRoleTemplate.resources
        $resources = $resources -is [System.Collections.IDictionary] ? @($resources.Values) : @($resources)
        $testModules = @($resources | Where-Object { $_.name -match '-test-' })
        if ($testModules.Count -ne 1) { throw 'Expected one tested Log Analytics workspace module.' }
        $script:lawRoleTestModule = $testModules[0]
        $script:lawRoleAssignments = @($script:lawRoleTestModule.properties.parameters.roleAssignments.value)
    }

    It 'Separates <role> assignment names across <dimension>' -ForEach @(
        @{ role = 'Reader'; roleIndex = 0; dimension = 'subscriptions'; scopeIndex = 1 }
        @{ role = 'Contributor'; roleIndex = 1; dimension = 'subscriptions'; scopeIndex = 1 }
        @{ role = 'Reader'; roleIndex = 0; dimension = 'resource groups'; scopeIndex = 2 }
        @{ role = 'Contributor'; roleIndex = 1; dimension = 'resource groups'; scopeIndex = 2 }
        @{ role = 'Reader'; roleIndex = 0; dimension = 'recreated principals'; scopeIndex = 3 }
        @{ role = 'Contributor'; roleIndex = 1; dimension = 'recreated principals'; scopeIndex = 3 }
        @{ role = 'Reader'; roleIndex = 0; dimension = 'workspace prefixes'; scopeIndex = 4 }
        @{ role = 'Contributor'; roleIndex = 1; dimension = 'workspace prefixes'; scopeIndex = 4 }
        @{ role = 'Reader'; roleIndex = 0; dimension = 'workspace short names'; scopeIndex = 5 }
        @{ role = 'Contributor'; roleIndex = 1; dimension = 'workspace short names'; scopeIndex = 5 }
    ) {
        $script:lawRoleNames["role${roleIndex}scope${scopeIndex}t1init"].value |
            Should -Not -Be $script:lawRoleNames["role${roleIndex}scope0t1init"].value
    }

    It 'Keeps <role> names stable for retained principals across root, location and init/idem changes' -ForEach @(
        @{ role = 'Reader'; roleIndex = 0 }
        @{ role = 'Contributor'; roleIndex = 1 }
    ) {
        for ($scopeIndex = 0; $scopeIndex -lt $script:lawRoleScenarios.Count; $scopeIndex++) {
            $names = @(
                foreach ($attempt in 1..3) {
                    foreach ($iteration in @('init', 'idem')) {
                        $script:lawRoleNames["role${roleIndex}scope${scopeIndex}t${attempt}${iteration}"].value
                    }
                }
            )
            @($names | Select-Object -Unique).Count | Should -Be 1
        }
    }

    It 'Produces distinct valid GUIDs for the two explicit assignments' {
        foreach ($entry in $script:lawRoleNames.Values) {
            $entry.value | Should -Match '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$'
        }
        for ($scopeIndex = 0; $scopeIndex -lt $script:lawRoleScenarios.Count; $scopeIndex++) {
            $script:lawRoleNames["role0scope${scopeIndex}t1init"].value |
                Should -Not -Be $script:lawRoleNames["role1scope${scopeIndex}t1init"].value
        }
    }

    It 'Keeps two custom-name cases and the third automatic-name case' {
        $script:lawRoleAssignments.Count | Should -Be 3
        $script:lawRoleAssignments[0].Contains('name') | Should -BeTrue
        $script:lawRoleAssignments[1].Contains('name') | Should -BeTrue
        $script:lawRoleAssignments[2].Contains('name') | Should -BeFalse
    }

    It 'Preserves role definitions, ServicePrincipal types and the actual identity reference' {
        $script:lawRoleAssignments[0].roleDefinitionIdOrName | Should -BeExactly 'Reader'
        $script:lawRoleAssignments[1].roleDefinitionIdOrName | Should -BeExactly 'b24988ac-6180-42a0-ab88-20f7382dd24c'
        $script:lawRoleAssignments[2].roleDefinitionIdOrName |
            Should -BeExactly "[subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '43d0d8ad-25c7-4714-9337-8ba259a9fe05')]"
        foreach ($assignment in $script:lawRoleAssignments) {
            $assignment.principalType | Should -BeExactly 'ServicePrincipal'
            $assignment.principalId | Should -BeExactly $script:lawRoleAssignments[0].principalId
            $assignment.principalId | Should -Match '\.outputs\.managedIdentityPrincipalId\.value'
        }
        $script:lawRoleTestModule.properties.parameters.managedIdentities.value.systemAssigned | Should -BeTrue
    }

    It 'Forwards the complete workspace scope and assignment principal into both names' {
        foreach ($assignment in $script:lawRoleAssignments[0..1]) {
            $assignment.name | Should -Match 'Microsoft.OperationalInsights/workspaces/'
            $assignment.name | Should -Match "subscriptionResourceId\('Microsoft.Resources/resourceGroups', parameters\('resourceGroupName'\)\)"
            $assignment.name | Should -Match "parameters\('namePrefix'\)"
            $assignment.name | Should -Match "parameters\('serviceShort'\)"
            $principalExpression = $assignment.principalId.Substring(1, $assignment.principalId.Length - 2)
            $assignment.name | Should -Match ([regex]::Escape($principalExpression))
        }
    }

    It 'Keeps location unpinned and initial/idempotency deployments serial' {
        $script:lawRoleTemplate.parameters.resourceLocation.defaultValue | Should -BeExactly '[deployment().location]'
        $script:lawRoleTestModule.properties.parameters.location.value | Should -BeExactly "[parameters('resourceLocation')]"
        $script:lawRoleTestModule.properties.parameters.name.value |
            Should -BeExactly "[format('{0}{1}001', parameters('namePrefix'), parameters('serviceShort'))]"
        $script:lawRoleTestModule.copy.mode | Should -BeExactly 'serial'
        $script:lawRoleTestModule.copy.batchSize | Should -Be 1
        $script:lawRoleTestModule.copy.count | Should -BeExactly "[length(createArray('init', 'idem'))]"
    }
}
