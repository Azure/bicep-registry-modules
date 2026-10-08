Describe 'Cosmos fixture resource identities' {
    Context '<scenario> <kind>' -ForEach @(
        @{ scenario = 'mongodb'; kind = 'account'; serial = $true; location = 'westus3' }
        @{ scenario = 'sqldb'; kind = 'account'; serial = $false; location = 'westus3' }
        @{ scenario = 'sqlroles'; kind = 'account'; serial = $true; location = 'spaincentral' }
        @{ scenario = 'managedIdentity'; kind = 'account'; serial = $false; location = 'eastus2' }
        @{ scenario = 'managedIdentity'; kind = 'assignment'; serial = $false; location = 'eastus2' }
        @{ scenario = 'perimeter'; kind = 'account'; serial = $true; location = 'francecentral' }
    ) {
        BeforeAll {
            $fixturePath = Join-Path $PSScriptRoot '..' 'e2e' $scenario 'main.test.bicep'
            $source = Get-Content -LiteralPath $fixturePath -Raw
            $testSource = [regex]::Match($source, '(?ms)^module testDeployment\b.*\z').Value
            $nameMatch = [regex]::Match($testSource, '(?ms)\bparams:\s*\{\s*name: (?<expression>[^\r\n]+)')
            $serviceMatch = [regex]::Match($source, "(?m)^param serviceShort string = '(?<value>[^']+)'")
            if (-not $nameMatch.Success -or -not $serviceMatch.Success) { throw "Missing $scenario account name or service identifier." }
            $fixtureVariables = @{}
            foreach ($variable in [regex]::Matches($source, '(?m)^var (?<name>databaseAccountName|databaseAccountResourceId) = (?<expression>[^\r\n]+)')) {
                $fixtureVariables[$variable.Groups['name'].Value] = $variable.Groups['expression'].Value
            }
            $identityExpression = $nameMatch.Groups['expression'].Value
            if ($kind -eq 'assignment') {
                $assignmentMatch = [regex]::Match($testSource, '(?ms)roleAssignments:\s*\[.*?\bname: (?<expression>guid\(.*?\))\s+roleDefinitionIdOrName:')
                if (-not $assignmentMatch.Success) { throw 'Missing explicit managed-identity role assignment.' }
                $identityExpression = $assignmentMatch.Groups['expression'].Value
            }
            $scopeExpressions = @()
            if ($scenario -eq 'sqlroles') {
                $scopeExpressions += @([regex]::Matches($testSource, '(?ms)assignableScopes:\s*\[\s*(?<expression>[^\r\n]+)') |
                    ForEach-Object { $_.Groups['expression'].Value.Trim() })
                $scopeExpressions += @([regex]::Matches($testSource, "(?m)^\s+roleDefinitionId: (?<expression>[^\r\n]+/sqlRoleDefinitions/[^'\r\n]+')") |
                    ForEach-Object { $_.Groups['expression'].Value })
                $scopeExpressions += @([regex]::Matches($testSource, "(?m)^\s+scope: (?<expression>'[^\r\n]+')") |
                    ForEach-Object { $_.Groups['expression'].Value })
                if ($scopeExpressions.Count -ne 5) { throw 'Missing explicit SQL role scopes or fully qualified definition reference.' }
            }
            function Resolve-FixtureExpression([string] $Expression, [hashtable] $Values, [string] $Iteration) {
                foreach ($variableName in @('databaseAccountResourceId', 'databaseAccountName')) {
                    if ($Expression -match "\b$variableName\b") {
                        if (-not $fixtureVariables.ContainsKey($variableName)) { throw "Unresolved fixture variable: $variableName" }
                        $Expression = $Expression.Replace($variableName, "($($fixtureVariables[$variableName]))")
                    }
                }
                $Expression.
                Replace('nestedDependencies.outputs.managedIdentityPrincipalId', "'$($Values.principal)'").
                Replace('resourceGroup.id', "'/subscriptions/$($Values.subscription)/resourceGroups/$($Values.group)'").
                Replace('subscription().subscriptionId', "'$($Values.subscription)'").
                Replace('resourceGroupName', "'$($Values.group)'").
                Replace('deployment().name', "'$($Values.root)'").
                Replace('enforcedLocation', "'$($Values.location)'").
                Replace('namePrefix', "'$($Values.prefix)'").
                Replace('serviceShort', "'$($Values.service)'").
                Replace('iteration', "'$Iteration'")
            }
            $defaults = @{
                subscription = '00000000-0000-4000-8000-000000000001'
                group = 'fixture-one'
                root = 'attempt-one'
                location = $location
                prefix = 'gci'
                service = $serviceMatch.Groups['value'].Value
                principal = '00000000-0000-4000-8000-000000000011'
            }
            $overrides = @(
                @{}
                @{ subscription = '00000000-0000-4000-8000-000000000002' }
                @{ group = 'fixture-two' }
                @{ root = 'attempt-two' }
                @{ location = 'norwayeast' }
                @{ principal = '00000000-0000-4000-8000-000000000012' }
                @{ prefix = ('g' * 100); service = ('s' * 100 + 'a') }
                @{ prefix = ('g' * 100); service = ('s' * 100 + 'b') }
                @{ prefix = ('g' * 100 + 'b'); service = ('s' * 100 + 'a') }
            )
            $inputs = @()
            $parameterSource = @('using none')
            for ($index = 0; $index -lt $overrides.Count; $index++) {
                $values = $defaults.Clone()
                foreach ($key in $overrides[$index].Keys) { $values[$key] = $overrides[$index][$key] }
                $inputs += $values
                foreach ($iteration in @('init', 'idem')) {
                    $parameterSource += "param identity${index}${iteration} = $(Resolve-FixtureExpression $identityExpression $values $iteration)"
                    $parameterSource += "param account${index}${iteration} = $(Resolve-FixtureExpression $nameMatch.Groups['expression'].Value $values $iteration)"
                    for ($scopeIndex = 0; $scopeIndex -lt $scopeExpressions.Count; $scopeIndex++) {
                        $parameterSource += "param scope${scopeIndex}case${index}${iteration} = $(Resolve-FixtureExpression $scopeExpressions[$scopeIndex] $values $iteration)"
                    }
                }
            }
            $parameterPath = Join-Path $TestDrive "$scenario-$kind.bicepparam"
            $parameterOutput = Join-Path $TestDrive "$scenario-$kind-names.json"
            $parameterSource -join "`n" | Set-Content -LiteralPath $parameterPath
            $diagnostics = bicep build-params $parameterPath --no-restore --outfile $parameterOutput 2>&1
            if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
            $names = (Get-Content -LiteralPath $parameterOutput -Raw | ConvertFrom-Json -AsHashtable).parameters
            $fixtureOutput = Join-Path $TestDrive "$scenario-$kind.json"
            $diagnostics = bicep build $fixturePath --no-restore --outfile $fixtureOutput 2>&1
            if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
            $template = Get-Content -LiteralPath $fixtureOutput -Raw | ConvertFrom-Json -AsHashtable -Depth 100
            $resources = $template.resources -is [System.Collections.IDictionary] ? @($template.resources.Values) : @($template.resources)
            $testModule = @($resources | Where-Object { $_.name -match '-test-' })[0]
            $parameters = $testModule.properties.parameters
            $accountResources = $testModule.properties.template.resources
            $accountResources = $accountResources -is [System.Collections.IDictionary] ? @($accountResources.Values) : @($accountResources)
            $account = @($accountResources | Where-Object type -EQ 'Microsoft.DocumentDB/databaseAccounts')[0]
            $compiledIdentity = $kind -eq 'account' ? $parameters.name.value : $parameters.roleAssignments.value[1].name
            foreach ($variableName in @('databaseAccountResourceId', 'databaseAccountName')) {
                $reference = "variables('$variableName')"
                if ($compiledIdentity.Contains($reference)) {
                    $compiledVariable = $template.variables[$variableName]
                    if ($compiledVariable -isnot [string] -or -not $compiledVariable.StartsWith('[') -or -not $compiledVariable.EndsWith(']')) {
                        throw "Unexpected compiled variable: $variableName"
                    }
                    $compiledIdentity = $compiledIdentity.Replace($reference, $compiledVariable.Substring(1, $compiledVariable.Length - 2))
                }
            }
        }

        It 'Separates otherwise identical deployments in different subscriptions' {
            $names.identity0init.value | Should -Not -Be $names.identity1init.value
        }

        It 'Separates deployments in different resource groups' {
            $names.identity0init.value | Should -Not -Be $names.identity2init.value
        }

        It 'Keeps identity stable across roots, regions and init/idem without changing the deployment shape' {
            $names.identity0init.value | Should -BeExactly $names.identity3init.value
            $names.identity0init.value | Should -BeExactly $names.identity4init.value
            foreach ($index in 0..($overrides.Count - 1)) {
                $names["identity${index}init"].value | Should -BeExactly $names["identity${index}idem"].value
            }
            $template.variables.enforcedLocation | Should -BeExactly $location
            if ($serial) {
                $testModule.copy.count | Should -BeExactly "[length(createArray('init', 'idem'))]"
                $testModule.copy.mode | Should -BeExactly 'serial'
                $testModule.copy.batchSize | Should -Be 1
            } else {
                $testModule.Contains('copy') | Should -BeFalse
            }
        }

        It 'Meets the account-name or assignment-GUID constraints' {
            foreach ($index in 0..($overrides.Count - 1)) {
                foreach ($iteration in @('init', 'idem')) {
                    $value = $names["identity${index}${iteration}"].value
                    if ($kind -eq 'assignment') {
                        $value | Should -Match '^[0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12}$'
                    } else {
                        $value | Should -Match '^[a-z0-9-]{3,44}$'
                    }
                }
            }
            $names.identity6init.value.Length | Should -Be ($kind -eq 'assignment' ? 36 : 44)
        }

        It 'Retains full input identity and distinguishes recreated assignment principals only' {
            $names.identity6init.value | Should -Not -Be $names.identity7init.value
            $names.identity6init.value | Should -Not -Be $names.identity8init.value
            $names.account0init.value | Should -BeExactly $names.account5init.value
            if ($kind -eq 'assignment') {
                $names.identity0init.value | Should -Not -Be $names.identity5init.value
            } else {
                $names.identity0init.value | Should -BeExactly $names.identity5init.value
            }
        }

        It 'Passes the scoped identity to the account or explicit assignment' {
            $compiledIdentity | Should -Match "parameters\('resourceGroupName'\)"
            $compiledIdentity | Should -Match 'uniqueString\('
            $account.name | Should -BeExactly "[parameters('name')]"
            $testModule.resourceGroup | Should -BeExactly "[parameters('resourceGroupName')]"
            if ($kind -eq 'assignment') {
                $compiledIdentity | Should -Match 'Microsoft.DocumentDB/databaseAccounts'
                $compiledIdentity | Should -Match '\.outputs\.managedIdentityPrincipalId\.value'
            }
        }

        It 'Preserves scenario coverage and all coupled account and principal references' {
            if ($scenario -eq 'perimeter') {
                ($parameters.Keys | Sort-Object) -join ',' | Should -BeExactly 'name,networkRestrictions'
                $parameters.networkRestrictions.value.publicNetworkAccess | Should -BeExactly 'SecuredByPerimeter'
                $testModule.dependsOn | Should -Contain 'resourceGroup'
            } else {
                $parameters.zoneRedundant.value | Should -BeFalse
            }
            if ($scenario -eq 'mongodb') {
                @($parameters.mongodbDatabases.value).Count | Should -Be 2
                foreach ($database in $parameters.mongodbDatabases.value) {
                    @($database.collections).Count | Should -Be 2
                }
                $template.outputs.Count | Should -Be 8
                foreach ($output in $template.outputs.Values) { $output.type | Should -BeExactly 'securestring' }
            } elseif ($scenario -eq 'sqldb') {
                @($parameters.sqlDatabases.value).Count | Should -Be 14
                $databaseNames = @($parameters.sqlDatabases.value | ForEach-Object name)
                $databaseNames | Should -Contain 'all-partition-key-types'
                $databaseNames | Should -Contain 'empty-containers-array'
                $databaseNames | Should -Contain 'no-containers-specified'
            } elseif ($scenario -eq 'sqlroles') {
                $definitions = $parameters.sqlRoleDefinitions.value
                $assignments = $parameters.sqlRoleAssignments.value
                @($definitions).Count | Should -Be 3
                $definitions[0].name | Should -BeExactly "[guid('optional-role-identifier')]"
                @($definitions[0].dataActions).Count | Should -Be 3
                @($definitions[1].dataActions).Count | Should -Be 1
                @($definitions[2].dataActions).Count | Should -Be 1
                $definitions[2].Contains('assignableScopes') | Should -BeFalse
                $definitions[0].assignments[0].principalId | Should -BeExactly "[reference('nestedDependencies').outputs.identityPrincipalId.value]"
                @($assignments).Count | Should -Be 3
                $assignments[1].roleDefinitionId | Should -BeExactly '00000000-0000-0000-0000-000000000001'
                $assignments[2].roleDefinitionId | Should -BeExactly 'Cosmos DB Built-in Data Reader'
                foreach ($assignment in $assignments) {
                    $assignment.principalId | Should -BeExactly "[reference('nestedDependencies').outputs.identityPrincipalId.value]"
                }
                foreach ($index in 0..($overrides.Count - 1)) {
                    foreach ($iteration in @('init', 'idem')) {
                        $accountId = "/subscriptions/$($inputs[$index].subscription)/resourceGroups/$($inputs[$index].group)/providers/Microsoft.DocumentDB/databaseAccounts/$($names["account${index}${iteration}"].value)"
                        $names["scope0case${index}${iteration}"].value | Should -BeExactly $accountId
                        $names["scope1case${index}${iteration}"].value | Should -BeExactly $accountId
                        $names["scope2case${index}${iteration}"].value | Should -BeExactly "$accountId/sqlRoleDefinitions/00000000-0000-0000-0000-000000000001"
                        $names["scope3case${index}${iteration}"].value | Should -BeExactly "$accountId/dbs/simple-db"
                        $names["scope4case${index}${iteration}"].value | Should -BeExactly "$accountId/dbs/simple-db/colls/container-001"
                    }
                }
            } elseif ($scenario -eq 'managedIdentity') {
                $roles = $parameters.roleAssignments.value
                @($roles).Count | Should -Be 3
                $roles[0].roleDefinitionIdOrName | Should -BeExactly 'Reader'
                $roles[1].roleDefinitionIdOrName | Should -BeExactly 'b24988ac-6180-42a0-ab88-20f7382dd24c'
                $roles[2].roleDefinitionIdOrName | Should -BeExactly "[subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '43d0d8ad-25c7-4714-9337-8ba259a9fe05')]"
                $roles[0].Contains('name') | Should -BeFalse
                $roles[2].Contains('name') | Should -BeFalse
                foreach ($role in $roles) {
                    $role.principalId | Should -BeExactly "[reference('nestedDependencies').outputs.managedIdentityPrincipalId.value]"
                    $role.principalType | Should -BeExactly 'ServicePrincipal'
                }
                $parameters.managedIdentities.value.systemAssigned | Should -BeTrue
                @($parameters.managedIdentities.value.userAssignedResourceIds).Count | Should -Be 1
                $parameters.managedIdentities.value.userAssignedResourceIds[0] |
                    Should -BeExactly "[reference('nestedDependencies').outputs.managedIdentityResourceId.value]"
                $testModule.dependsOn | Should -Contain 'nestedDependencies'
            }
        }
    }
}
