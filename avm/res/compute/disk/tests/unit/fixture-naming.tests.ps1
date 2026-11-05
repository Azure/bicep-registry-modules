BeforeAll {
    $fixturePath = Join-Path $PSScriptRoot '..' 'e2e' 'import' 'main.test.bicep'
    $source = Get-Content -LiteralPath $fixturePath -Raw
    $dependencySource = [regex]::Match($source, '(?ms)^module nestedDependencies\b.*?^}').Value
    $nameMatch = [regex]::Match($dependencySource, '(?m)^\s+storageAccountName: (?<expression>[^\r\n]+)')
    $serviceMatch = [regex]::Match($source, "(?m)^param serviceShort string = '(?<value>[^']+)'")
    if (-not $nameMatch.Success -or -not $serviceMatch.Success) { throw 'Missing import fixture storage name or service identifier.' }

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
    $parameterPath = Join-Path $TestDrive 'import-storage.bicepparam'
    $parameterOutput = Join-Path $TestDrive 'import-storage.json'
    $parameterSource -join "`n" | Set-Content -LiteralPath $parameterPath
    $diagnostics = bicep build-params $parameterPath --no-restore --outfile $parameterOutput 2>&1
    if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
    $names = (Get-Content -LiteralPath $parameterOutput -Raw | ConvertFrom-Json -AsHashtable).parameters

    $fixtureOutput = Join-Path $TestDrive 'import.json'
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

Describe 'Imported disk storage fixture identity' {
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

    It 'Keeps the imported VHD URI and account ID connected to the renamed account' {
        $dependencies.properties.template.outputs.vhdUri.value | Should -Match "parameters\('storageAccountName'\)"
        $dependencies.properties.template.outputs.vhdUri.value | Should -Match 'environment\(\)\.suffixes\.storage'
        $dependencies.properties.template.outputs.storageAccountResourceId.value | Should -Match "parameters\('storageAccountName'\)"
        $testModule.properties.parameters.sourceUri.value | Should -Match '\.outputs\.vhdUri\.value'
        $testModule.properties.parameters.storageAccountId.value | Should -Match '\.outputs\.storageAccountResourceId\.value'
        $testModule.properties.parameters.createOption.value | Should -BeExactly 'Import'
        $storage.properties.allowBlobPublicAccess | Should -BeFalse
    }
}
