BeforeAll {
    $fixturePath = Join-Path $PSScriptRoot '..' 'e2e' 'encrwuai' 'main.test.bicep'
    $source = Get-Content -LiteralPath $fixturePath -Raw
    $match = [regex]::Match($source, "(?m)^\s+name: (?<expression>'[^\r\n]*namePrefix[^\r\n]+)")
    if (-not $match.Success) { throw 'Missing user-assigned encryption fixture workspace name expression.' }

    $scenarios = @(
        @{ subscription = '00000000-0000-4000-8000-000000000001'; group = 'fixture-one'; root = 'attempt-one'; location = 'eastus'; prefix = 'gci'; service = 'swenua' }
        @{ subscription = '00000000-0000-4000-8000-000000000002'; group = 'fixture-one'; root = 'attempt-one'; location = 'eastus'; prefix = 'gci'; service = 'swenua' }
        @{ subscription = '00000000-0000-4000-8000-000000000001'; group = 'fixture-two'; root = 'attempt-one'; location = 'eastus'; prefix = 'gci'; service = 'swenua' }
        @{ subscription = '00000000-0000-4000-8000-000000000001'; group = 'fixture-one'; root = 'attempt-two'; location = 'eastus'; prefix = 'gci'; service = 'swenua' }
        @{ subscription = '00000000-0000-4000-8000-000000000001'; group = 'fixture-one'; root = 'attempt-one'; location = 'norwayeast'; prefix = 'gci'; service = 'swenua' }
        @{ subscription = '00000000-0000-4000-8000-000000000001'; group = 'fixture-one'; root = 'attempt-one'; location = 'eastus'; prefix = ('g' * 100); service = ('s' * 100 + 'a') }
        @{ subscription = '00000000-0000-4000-8000-000000000001'; group = 'fixture-one'; root = 'attempt-one'; location = 'eastus'; prefix = ('g' * 100); service = ('s' * 100 + 'b') }
        @{ subscription = '00000000-0000-4000-8000-000000000001'; group = 'fixture-one'; root = 'attempt-one'; location = 'eastus'; prefix = ('g' * 100 + 'b'); service = ('s' * 100 + 'a') }
    )
    $parameterSource = @('using none')
    for ($index = 0; $index -lt $scenarios.Count; $index++) {
        $scenario = $scenarios[$index]
        foreach ($iteration in @('init', 'idem')) {
            $expression = $match.Groups['expression'].Value.
            Replace('resourceGroup.id', "'/subscriptions/$($scenario.subscription)/resourceGroups/$($scenario.group)'").
            Replace('subscription().subscriptionId', "'$($scenario.subscription)'").
            Replace('resourceGroupName', "'$($scenario.group)'").
            Replace('deployment().name', "'$($scenario.root)'").
            Replace('resourceLocation', "'$($scenario.location)'").
            Replace('namePrefix', "'$($scenario.prefix)'").
            Replace('serviceShort', "'$($scenario.service)'").
            Replace('iteration', "'$iteration'")
            $parameterSource += "param workspace${index}${iteration} = $expression"
        }
    }
    $parameterPath = Join-Path $TestDrive 'workspace-names.bicepparam'
    $parameterOutput = Join-Path $TestDrive 'workspace-names.json'
    $parameterSource -join "`n" | Set-Content -LiteralPath $parameterPath
    $diagnostics = bicep build-params $parameterPath --no-restore --outfile $parameterOutput 2>&1
    if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
    $names = (Get-Content -LiteralPath $parameterOutput -Raw | ConvertFrom-Json -AsHashtable).parameters

    $fixtureOutput = Join-Path $TestDrive 'encrwuai.json'
    $diagnostics = bicep build $fixturePath --no-restore --outfile $fixtureOutput 2>&1
    if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
    $template = Get-Content -LiteralPath $fixtureOutput -Raw | ConvertFrom-Json -AsHashtable -Depth 100
    $resources = $template.resources -is [System.Collections.IDictionary] ? @($template.resources.Values) : @($template.resources)
    $dependencies = @($resources | Where-Object { $_.properties.parameters -is [System.Collections.IDictionary] -and $_.properties.parameters.Contains('keyVaultName') })[0]
    $testModule = @($resources | Where-Object { $_.properties.parameters -is [System.Collections.IDictionary] -and $_.properties.parameters.Contains('customerManagedKey') })[0]
    $dependencyResources = $dependencies.properties.template.resources
    $dependencyResources = $dependencyResources -is [System.Collections.IDictionary] ? @($dependencyResources.Values) : @($dependencyResources)
    $vault = @($dependencyResources | Where-Object type -EQ 'Microsoft.KeyVault/vaults')[0]
    $keyRole = @($dependencyResources | Where-Object type -EQ 'Microsoft.Authorization/roleAssignments')[0]
}

Describe 'User-assigned encryption fixture workspace identity' {
    It 'Separates otherwise identical deployments in different subscriptions' {
        $names.workspace0init.value | Should -Not -Be $names.workspace1init.value
    }

    It 'Separates deployments in different resource groups' {
        $names.workspace0init.value | Should -Not -Be $names.workspace2init.value
    }

    It 'Preserves workspace identity across retries, regions and serial init/idem deployments' {
        $names.workspace0init.value | Should -BeExactly $names.workspace3init.value
        $names.workspace0init.value | Should -BeExactly $names.workspace4init.value
        foreach ($index in 0..7) {
            $names["workspace${index}init"].value | Should -BeExactly $names["workspace${index}idem"].value
        }
        $testModule.copy.count | Should -BeExactly "[length(createArray('init', 'idem'))]"
        $testModule.copy.mode | Should -BeExactly 'serial'
        $testModule.copy.batchSize | Should -Be 1
    }

    It 'Meets the 1-50 character workspace naming rules' {
        foreach ($entry in $names.Values) {
            $entry.value | Should -Match '^[a-z0-9](?:[a-z0-9-]{0,48}[a-z0-9])?$'
            $entry.value | Should -Not -Match '-ondemand'
        }
    }

    It 'Keeps full prefix and service inputs distinct after truncation' {
        $names.workspace5init.value | Should -Not -Be $names.workspace6init.value
        $names.workspace5init.value | Should -Not -Be $names.workspace7init.value
    }

    It 'Forwards a scope-qualified name to the tested workspace module' {
        $testModule.properties.parameters.name.value | Should -Match 'uniqueString\('
        $testModule.properties.parameters.name.value | Should -Match "parameters\('resourceGroupName'\)"
    }

    It 'Preserves user-assigned encryption identity, key permissions and purge protection' {
        $testModule.properties.parameters.customerManagedKey.value.userAssignedIdentityResourceId |
            Should -Match '\.outputs\.managedIdentityResourceId\.value'
        $testModule.properties.parameters.Contains('encryptionActivateWorkspace') | Should -BeFalse
        $vault.properties.enableRbacAuthorization | Should -BeTrue
        $vault.properties.enablePurgeProtection | Should -BeTrue
        $vault.properties.softDeleteRetentionInDays | Should -Be 7
        $keyRole.scope | Should -Match 'Microsoft.KeyVault/vaults/keys|keyVault::key'
        $keyRole.properties.roleDefinitionId | Should -Match '12338af0-0e69-4776-bea7-57ae8d297424'
        $keyRole.properties.principalType | Should -BeExactly 'ServicePrincipal'
    }

    It 'Preserves region selection and the data lake dependencies' {
        $template.parameters.resourceLocation.defaultValue | Should -BeExactly '[deployment().location]'
        $dependencies.properties.parameters.location.value | Should -BeExactly "[parameters('resourceLocation')]"
        $testModule.properties.parameters.defaultDataLakeStorageAccountResourceId.value |
            Should -Match '\.outputs\.storageAccountResourceId\.value'
        $testModule.properties.parameters.defaultDataLakeStorageFilesystem.value |
            Should -Match '\.outputs\.storageContainerName\.value'
    }
}
