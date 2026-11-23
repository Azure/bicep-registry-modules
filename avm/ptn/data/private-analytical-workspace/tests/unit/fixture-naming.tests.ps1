param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.Parent.Parent.Parent.FullName,
    [array] $moduleFolderPaths
)

Describe 'Private analytical workspace <fixtureName> dependency vault isolation' -ForEach @(
    @{ fixtureName = 'uc03-priv'; legacyName = 'dep-gci-kv-dpawu3pr' }
    @{ fixtureName = 'uc03-pub'; legacyName = 'dep-gci-kv-dpawu3p-1' }
) {
    BeforeAll {
        $fixturePath = Join-Path $repoRootPath 'avm' 'ptn' 'data' 'private-analytical-workspace' 'tests' 'e2e' $fixtureName 'main.test.bicep'
        $fixture = Get-Content -LiteralPath $fixturePath -Raw
        $expression = [regex]::Match($fixture, '(?m)^\s+keyVaultName:\s*(.+)').Groups[1].Value.Trim()
        $serviceShort = [regex]::Match($fixture, "(?m)^param serviceShort string = '([^']+)'").Groups[1].Value
        if (-not $expression -or -not $serviceShort) { throw 'Missing actual fixture vault-name expression or service identifier.' }
        $compiledPath = Join-Path $TestDrive "$fixtureName.json"
        $diagnostics = bicep build $fixturePath --no-restore --outfile $compiledPath 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $template = Get-Content -LiteralPath $compiledPath -Raw | ConvertFrom-Json -AsHashtable

        $scenarios = @(
            @{ subscription = '11111111-1111-1111-1111-111111111111'; group = 'fixture-group'; time = '2026-10-19 17:00:00Z'; prefix = 'gci'; region = 'northeurope' }
            @{ subscription = '22222222-2222-2222-2222-222222222222'; group = 'fixture-group'; time = '2026-10-19 17:00:00Z'; prefix = 'gci'; region = 'northeurope' }
            @{ subscription = '11111111-1111-1111-1111-111111111111'; group = 'fixture-group'; time = '2026-10-19 18:00:00Z'; prefix = 'gci'; region = 'northeurope' }
            @{ subscription = '11111111-1111-1111-1111-111111111111'; group = 'fixture-group'; time = '2026-10-19 17:00:00Z'; prefix = 'other'; region = 'northeurope' }
            @{ subscription = '11111111-1111-1111-1111-111111111111'; group = 'another-group'; time = '2026-10-19 17:00:00Z'; prefix = 'gci'; region = 'northeurope' }
            @{ subscription = '11111111-1111-1111-1111-111111111111'; group = 'fixture-group'; time = '2026-10-19 17:00:00Z'; prefix = 'gci'; region = 'westeurope' }
            @{ subscription = '11111111-1111-1111-1111-111111111111'; group = 'fixture-group'; time = '2026-10-19 17:00:00Z'; prefix = ('a' * 80); region = 'northeurope' }
        )
        $parameterLines = @('using none')
        for ($scenarioIndex = 0; $scenarioIndex -lt $scenarios.Count; $scenarioIndex++) {
            $scenario = $scenarios[$scenarioIndex]
            foreach ($attempt in 1..3) {
                foreach ($iteration in @('init', 'idem')) {
                    $suffix = "${scenarioIndex}t${attempt}${iteration}"
                    $value = $expression.
                    Replace('resourceGroup.id', "'/subscriptions/$($scenario.subscription)/resourceGroups/$($scenario.group)'").
                    Replace('namePrefix', "'$($scenario.prefix)'").
                    Replace('serviceShort', "'$serviceShort'").
                    Replace('enforcedLocation', "'$($scenario.region)'").
                    Replace('baseTime', "'$($scenario.time)'").
                    Replace('deployment().name', "'attempt-$attempt-$iteration'")
                    $parameterLines += "param vault$suffix = $value"
                }
            }
        }
        $parameterPath = Join-Path $TestDrive "$fixtureName.bicepparam"
        $parameterOutput = Join-Path $TestDrive "$fixtureName-names.json"
        $parameterLines -join "`n" | Set-Content -LiteralPath $parameterPath
        $diagnostics = bicep build-params $parameterPath --no-restore --outfile $parameterOutput 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $names = (Get-Content -LiteralPath $parameterOutput -Raw | ConvertFrom-Json -AsHashtable).parameters
    }

    It 'Separates vault names when <dimension> changes' -ForEach @(
        @{ dimension = 'subscription'; scenarioIndex = 1 }
        @{ dimension = 'run'; scenarioIndex = 2 }
        @{ dimension = 'prefix'; scenarioIndex = 3 }
        @{ dimension = 'resource group'; scenarioIndex = 4 }
        @{ dimension = 'effective region'; scenarioIndex = 5 }
    ) {
        $names["vault${scenarioIndex}t1init"].value | Should -Not -Be $names.vault0t1init.value
    }

    It 'Keeps the vault stable across initial, repeat and retry deployments in the same scope' {
        foreach ($scenarioIndex in 0..6) {
            $scopedNames = @(
                foreach ($attempt in 1..3) {
                    foreach ($iteration in @('init', 'idem')) {
                        $names["vault${scenarioIndex}t${attempt}${iteration}"].value
                    }
                }
            )
            @($scopedNames | Select-Object -Unique).Count | Should -Be 1
        }
    }

    It 'Does not reuse the legacy globally fixed dependency vault name' {
        foreach ($name in $names.Values.value) {
            $name | Should -Not -Be $legacyName
        }
    }

    It 'Produces legal bounded vault names even with a long injected prefix' {
        foreach ($name in $names.Values.value) {
            $name | Should -Match '^dep-[a-z0-9]{13}-kv$'
            $name.Length | Should -BeLessOrEqual 24
        }
    }

    It 'Wires the isolated vault through the real dependency and preserves private/public init and repeat coverage' {
        $dependencies = $template.resources | Where-Object { $_.properties.parameters.keyVaultName }
        $dependencies.resourceGroup | Should -Be "[parameters('resourceGroupName')]"
        $dependencies.properties.parameters.keyVaultName.value |
            Should -Be "[format('dep-{0}-kv', uniqueString(subscriptionResourceId('Microsoft.Resources/resourceGroups', parameters('resourceGroupName')), parameters('namePrefix'), parameters('serviceShort'), variables('enforcedLocation'), parameters('baseTime')))]"
        $vaultModule = $dependencies.properties.template.resources | Where-Object name -EQ "[parameters('keyVaultName')]"
        $vaultModule.properties.parameters.name.value | Should -Be "[parameters('keyVaultName')]"
        $deployments = $template.resources | Where-Object { $_.properties.parameters.keyVaultResourceId }
        $deployments.copy.batchSize | Should -Be 1
        $deployments.copy.count | Should -Match "'init', 'idem'"
        $deployments.properties.parameters.keyVaultResourceId.value | Should -Match 'outputs\.keyVaultResourceId\.value'
        $deployments.properties.parameters.enableDatabricks.value | Should -BeTrue
        $advancedOptions = $deployments.properties.parameters.advancedOptions.value
        $advancedOptions.virtualNetwork.subnetNamePrivateLink | Should -Not -BeNullOrEmpty
        if ($fixtureName -eq 'uc03-priv') {
            $advancedOptions.keyVault.enablePurgeProtection | Should -BeFalse
        } else {
            $advancedOptions.networkAcls.ipRules | Should -Contain '104.43.16.94'
        }
    }
}
