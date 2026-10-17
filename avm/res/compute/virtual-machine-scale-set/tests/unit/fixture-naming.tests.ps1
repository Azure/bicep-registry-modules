BeforeAll {
    $fixturePath = Join-Path $PSScriptRoot '..' 'e2e' 'windows.waf-aligned' 'main.test.bicep'
    $source = Get-Content -LiteralPath $fixturePath -Raw
    $match = [regex]::Match($source, '(?m)^\s+keyVaultName: (?<expression>[^\r\n]+)')
    if (-not $match.Success) { throw 'Missing Windows WAF fixture Key Vault name expression.' }

    $scenarios = @(
        @{ subscription = '00000000-0000-4000-8000-000000000001'; group = 'fixture-one'; root = 'attempt-one'; location = 'eastus'; prefix = 'gci'; service = 'cvmsswinwaf' }
        @{ subscription = '00000000-0000-4000-8000-000000000002'; group = 'fixture-one'; root = 'attempt-one'; location = 'eastus'; prefix = 'gci'; service = 'cvmsswinwaf' }
        @{ subscription = '00000000-0000-4000-8000-000000000001'; group = 'fixture-two'; root = 'attempt-one'; location = 'eastus'; prefix = 'gci'; service = 'cvmsswinwaf' }
        @{ subscription = '00000000-0000-4000-8000-000000000001'; group = 'fixture-one'; root = 'attempt-two'; location = 'eastus'; prefix = 'gci'; service = 'cvmsswinwaf' }
        @{ subscription = '00000000-0000-4000-8000-000000000001'; group = 'fixture-one'; root = 'attempt-one'; location = 'norwayeast'; prefix = 'gci'; service = 'cvmsswinwaf' }
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
            $parameterSource += "param vault${index}${iteration} = $expression"
        }
    }
    $parameterPath = Join-Path $TestDrive 'vault-names.bicepparam'
    $parameterOutput = Join-Path $TestDrive 'vault-names.json'
    $parameterSource -join "`n" | Set-Content -LiteralPath $parameterPath
    $diagnostics = bicep build-params $parameterPath --no-restore --outfile $parameterOutput 2>&1
    if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
    $names = (Get-Content -LiteralPath $parameterOutput -Raw | ConvertFrom-Json -AsHashtable).parameters

    $fixtureOutput = Join-Path $TestDrive 'windows.waf-aligned.json'
    $diagnostics = bicep build $fixturePath --no-restore --outfile $fixtureOutput 2>&1
    if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
    $template = Get-Content -LiteralPath $fixtureOutput -Raw | ConvertFrom-Json -AsHashtable -Depth 100
    $resources = $template.resources -is [System.Collections.IDictionary] ? @($template.resources.Values) : @($template.resources)
    $dependencies = @($resources | Where-Object { $_.properties.parameters -is [System.Collections.IDictionary] -and $_.properties.parameters.Contains('keyVaultName') })[0]
    $testModule = @($resources | Where-Object { $_.properties.parameters -is [System.Collections.IDictionary] -and $_.properties.parameters.Contains('skuName') })[0]
    $dependencyResources = $dependencies.properties.template.resources
    $dependencyResources = $dependencyResources -is [System.Collections.IDictionary] ? @($dependencyResources.Values) : @($dependencyResources)
    $vault = @($dependencyResources | Where-Object type -EQ 'Microsoft.KeyVault/vaults')[0]
    $keyRole = @($dependencyResources | Where-Object { $_.type -eq 'Microsoft.Authorization/roleAssignments' -and $_.properties.roleDefinitionId -match '12338af0-0e69-4776-bea7-57ae8d297424' })[0]
}

Describe 'Windows WAF fixture Key Vault identity' {
    It 'Separates otherwise identical deployments in different subscriptions' {
        $names.vault0init.value | Should -Not -Be $names.vault1init.value
    }

    It 'Separates deployments in different resource groups' {
        $names.vault0init.value | Should -Not -Be $names.vault2init.value
    }

    It 'Preserves the same vault across retries, regions and serial init/idem deployments' {
        $names.vault0init.value | Should -BeExactly $names.vault3init.value
        $names.vault0init.value | Should -BeExactly $names.vault4init.value
        foreach ($index in 0..7) {
            $names["vault${index}init"].value | Should -BeExactly $names["vault${index}idem"].value
        }
        $dependencies.Contains('copy') | Should -BeFalse
        $testModule.copy.count | Should -BeExactly "[length(createArray('init', 'idem'))]"
        $testModule.copy.mode | Should -BeExactly 'serial'
        $testModule.copy.batchSize | Should -Be 1
    }

    It 'Meets the 3-24 character vault limit without consecutive hyphens' {
        foreach ($entry in $names.Values) {
            $entry.value | Should -Match '^[a-zA-Z][a-zA-Z0-9-]{1,22}[a-zA-Z0-9]$'
            $entry.value | Should -Not -Match '--'
        }
    }

    It 'Keeps full prefix and service inputs distinct when readable names would be truncated' {
        $names.vault5init.value | Should -Not -Be $names.vault6init.value
        $names.vault5init.value | Should -Not -Be $names.vault7init.value
    }

    It 'Forwards the scope-qualified name to the actual vault resource' {
        $dependencies.properties.parameters.keyVaultName.value | Should -Match 'uniqueString\('
        $dependencies.properties.parameters.keyVaultName.value | Should -Match "parameters\('resourceGroupName'\)"
        $vault.name | Should -BeExactly "[parameters('keyVaultName')]"
    }

    It 'Preserves the encryption identity, key permissions and output references' {
        $vault.properties.enableRbacAuthorization | Should -BeTrue
        $vault.properties.enabledForDiskEncryption | Should -BeTrue
        $vault.properties.enablePurgeProtection | Should -BeNullOrEmpty
        $keyRole.scope | Should -Match 'Microsoft.KeyVault/vaults/keys|keyVault::key'
        $keyRole.properties.principalType | Should -BeExactly 'ServicePrincipal'
        $testModule.properties.parameters.managedIdentities.value.systemAssigned | Should -BeFalse
        $testModule.properties.parameters.extensionAzureDiskEncryptionConfig.value.enabled | Should -BeTrue
        $testModule.properties.parameters.extensionAzureDiskEncryptionConfig.value.settings.KeyEncryptionKeyURL |
            Should -Match '\.outputs\.keyVaultEncryptionKeyUrl\.value'
    }

    It 'Preserves region selection and Windows WAF coverage' {
        $template.parameters.resourceLocation.defaultValue | Should -BeExactly '[deployment().location]'
        $testModule.properties.parameters.location.value | Should -BeExactly "[parameters('resourceLocation')]"
        $testModule.properties.parameters.osType.value | Should -BeExactly 'Windows'
        $testModule.properties.parameters.skuName.value | Should -BeExactly 'Standard_D4ads_v5'
        $testModule.properties.parameters.extensionAntiMalwareConfig.value.enabled | Should -BeTrue
        $testModule.properties.parameters.encryptionAtHost.value | Should -BeFalse
    }
}
