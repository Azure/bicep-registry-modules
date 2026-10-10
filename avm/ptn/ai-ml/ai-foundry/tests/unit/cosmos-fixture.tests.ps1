Describe 'Foundry bring-your-own Cosmos account identity' {
    BeforeAll {
        $fixtureFolder = Join-Path $PSScriptRoot '..' 'e2e' 'ex.bring-your-own'
        $dependencySource = Get-Content -LiteralPath (Join-Path $fixtureFolder 'dependencies.bicep') -Raw
        $accountSource = [regex]::Match($dependencySource, '(?ms)^resource cosmosDbAccount\b.*?^}').Value
        $nameMatch = [regex]::Match($accountSource, '(?m)^\s+name: (?<expression>[^\r\n]+)')
        if (-not $nameMatch.Success) { throw 'Missing bring-your-own Cosmos account name.' }
        $defaults = @{
            subscription = '00000000-0000-4000-8000-000000000001'
            dependencyGroup = 'dependency-one'
            targetGroup = 'foundry-one'
            root = 'attempt-one'
            location = 'australiaeast'
            workload = '0gcifndrybyo'
        }
        $overrides = @(
            @{}
            @{ subscription = '00000000-0000-4000-8000-000000000002' }
            @{ dependencyGroup = 'dependency-two' }
            @{ targetGroup = 'foundry-two' }
            @{ root = 'attempt-two' }
            @{ location = 'norwayeast' }
            @{ workload = ('g' * 100 + 'a') }
            @{ workload = ('g' * 100 + 'b') }
        )
        $parameterSource = @('using none')
        for ($index = 0; $index -lt $overrides.Count; $index++) {
            $values = $defaults.Clone()
            foreach ($key in $overrides[$index].Keys) { $values[$key] = $overrides[$index][$key] }
            foreach ($iteration in @('init', 'idem')) {
                $expression = $nameMatch.Groups['expression'].Value.
                Replace('resourceGroup().id', "'/subscriptions/$($values.subscription)/resourceGroups/$($values.dependencyGroup)'").
                Replace('subscription().subscriptionId', "'$($values.subscription)'").
                Replace('resourceGroupName', "'$($values.targetGroup)'").
                Replace('deployment().name', "'$($values.root)'").
                Replace('workloadName', "'$($values.workload)'").
                Replace('location', "'$($values.location)'").
                Replace('iteration', "'$iteration'")
                $parameterSource += "param account${index}${iteration} = $expression"
            }
        }
        $parameterPath = Join-Path $TestDrive 'cosmos-names.bicepparam'
        $parameterOutput = Join-Path $TestDrive 'cosmos-names.json'
        $parameterSource -join "`n" | Set-Content -LiteralPath $parameterPath
        $diagnostics = bicep build-params $parameterPath --no-restore --outfile $parameterOutput 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $names = (Get-Content -LiteralPath $parameterOutput -Raw | ConvertFrom-Json -AsHashtable).parameters
        $fixtureOutput = Join-Path $TestDrive 'foundry-byo.json'
        $diagnostics = bicep build (Join-Path $fixtureFolder 'main.test.bicep') --no-restore --outfile $fixtureOutput 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $template = Get-Content -LiteralPath $fixtureOutput -Raw | ConvertFrom-Json -AsHashtable -Depth 100
        $resources = $template.resources -is [System.Collections.IDictionary] ? @($template.resources.Values) : @($template.resources)
        $dependencies = @($resources | Where-Object { $_.name -match 'module\.dependencies' })[0]
        $testModule = @($resources | Where-Object { $_.name -match '-test-' })[0]
        $dependencyResources = $dependencies.properties.template.resources
        $dependencyResources = $dependencyResources -is [System.Collections.IDictionary] ? @($dependencyResources.Values) : @($dependencyResources)
        $account = @($dependencyResources | Where-Object type -EQ 'Microsoft.DocumentDB/databaseAccounts')[0]
    }

    It 'Separates otherwise identical dependency accounts in different subscriptions' {
        $names.account0init.value | Should -Not -Be $names.account1init.value
    }

    It 'Separates accounts in different dependency resource groups' {
        $names.account0init.value | Should -Not -Be $names.account2init.value
    }

    It 'Keeps dependency identity independent of the consuming Foundry resource group' {
        $names.account0init.value | Should -BeExactly $names.account3init.value
        $dependencies.resourceGroup | Should -BeExactly "[format('dep-{0}-bicep-{1}-dependencies-rg', parameters('namePrefix'), parameters('serviceShort'))]"
    }

    It 'Keeps roots, regions and serial init/idem stable' {
        $names.account0init.value | Should -BeExactly $names.account4init.value
        $names.account0init.value | Should -BeExactly $names.account5init.value
        foreach ($index in 0..($overrides.Count - 1)) {
            $names["account${index}init"].value | Should -BeExactly $names["account${index}idem"].value
        }
        $template.variables.enforcedLocation | Should -BeExactly 'australiaeast'
        $testModule.copy.count | Should -BeExactly "[length(createArray('init', 'idem'))]"
        $testModule.copy.mode | Should -BeExactly 'serial'
        $testModule.copy.batchSize | Should -Be 1
    }

    It 'Meets the Cosmos account character and length constraints' {
        foreach ($entry in $names.Values) { $entry.value | Should -Match '^[a-z0-9-]{3,44}$' }
        $names.account6init.value.Length | Should -Be 44
    }

    It 'Retains workload identity beyond the bounded readable prefix' {
        $names.account6init.value | Should -Not -Be $names.account7init.value
    }

    It 'Compiles the account name using its owning scope and full workload input' {
        $account.name | Should -Match 'uniqueString\(resourceGroup\(\)\.id, parameters\(''workloadName''\)\)'
        $account.location | Should -BeExactly "[parameters('location')]"
    }

    It 'Preserves account configuration, the exported resource ID and all bring-your-own connections' {
        $account.kind | Should -BeExactly 'GlobalDocumentDB'
        $account.properties.databaseAccountOfferType | Should -BeExactly 'Standard'
        @($account.properties.locations).Count | Should -Be 1
        $account.properties.locations[0].locationName | Should -BeExactly "[parameters('location')]"
        $account.properties.locations[0].isZoneRedundant | Should -BeFalse
        $account.properties.locations[0].failoverPriority | Should -Be 0
        $account.properties.consistencyPolicy.defaultConsistencyLevel | Should -BeExactly 'Session'
        $account.properties.enableFreeTier | Should -BeFalse
        $nameExpression = $account.name.Substring(1, $account.name.Length - 2)
        $dependencies.properties.template.outputs.cosmosDbAccountResourceId.value |
            Should -BeExactly "[resourceId('Microsoft.DocumentDB/databaseAccounts', $nameExpression)]"
        $parameters = $testModule.properties.parameters
        $parameters.cosmosDbConfiguration.value.existingResourceId | Should -Match '\.outputs\.cosmosDbAccountResourceId\.value'
        $parameters.keyVaultConfiguration.value.existingResourceId | Should -Match '\.outputs\.keyVaultResourceId\.value'
        $parameters.storageAccountConfiguration.value.existingResourceId | Should -Match '\.outputs\.storageAccountResourceId\.value'
        $parameters.aiSearchConfiguration.value.existingResourceId | Should -Match '\.outputs\.aiSearchResourceId\.value'
        $parameters.includeAssociatedResources.value | Should -BeTrue
        $parameters.aiFoundryConfiguration.value.createCapabilityHosts | Should -BeTrue
        @($parameters.aiModelDeployments.value).Count | Should -Be 1
        ($testModule.dependsOn -join "`n") | Should -Match 'module\.dependencies'
    }
}
