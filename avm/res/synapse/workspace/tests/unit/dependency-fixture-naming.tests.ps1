param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.Parent.Parent.Parent.FullName,
    [array] $moduleFolderPaths
)

Describe 'Synapse user-assigned encryption dependency isolation' {
    BeforeAll {
        $fixturePath = Join-Path $repoRootPath 'avm' 'res' 'synapse' 'workspace' 'tests' 'e2e' 'encrwuai' 'main.test.bicep'
        $fixture = Get-Content -LiteralPath $fixturePath -Raw
        $expressions = @{
            group   = [regex]::Match($fixture, '(?m)^param resourceGroupName string = (.+)').Groups[1].Value.Trim()
            storage = [regex]::Match($fixture, '(?m)^\s+storageAccountName:\s*(.+)').Groups[1].Value.Trim()
        }
        foreach ($expression in $expressions.Values) {
            if (-not $expression) { throw 'Missing fixture resource-name expression.' }
        }
        $compiledPath = Join-Path $TestDrive 'fixture.json'
        $diagnostics = bicep build $fixturePath --no-restore --outfile $compiledPath 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $template = Get-Content -LiteralPath $compiledPath -Raw | ConvertFrom-Json -AsHashtable

        $scenarios = @(
            @{ subscription = '11111111-1111-1111-1111-111111111111'; time = '2026-10-19 17:00:00Z'; prefix = 'gci' }
            @{ subscription = '22222222-2222-2222-2222-222222222222'; time = '2026-10-19 17:00:00Z'; prefix = 'gci' }
            @{ subscription = '11111111-1111-1111-1111-111111111111'; time = '2026-10-19 18:00:00Z'; prefix = 'gci' }
            @{ subscription = '11111111-1111-1111-1111-111111111111'; time = '2026-10-19 17:00:00Z'; prefix = 'other' }
        )
        $parameterLines = @('using none')
        for ($scopeIndex = 0; $scopeIndex -lt $scenarios.Count; $scopeIndex++) {
            $scenario = $scenarios[$scopeIndex]
            foreach ($attempt in 1..3) {
                foreach ($iteration in @('init', 'idem')) {
                    $suffix = "${scopeIndex}t${attempt}${iteration}"
                    $groupExpression = $expressions.group.
                    Replace('subscription().id', "'$($scenario.subscription)'").
                    Replace('namePrefix', "'$($scenario.prefix)'").
                    Replace('serviceShort', "'swenua'").
                    Replace('baseTime', "'$($scenario.time)'").
                    Replace('deployment().name', "'attempt-$attempt-$iteration'")
                    $parameterLines += "var scope$suffix = $groupExpression"
                    $parameterLines += "param group$suffix = scope$suffix"
                    $idExpression = "'/subscriptions/$($scenario.subscription)/resourceGroups/`${scope$suffix}'"
                    $expression = $expressions.storage.
                    Replace('resourceGroup.id', $idExpression).
                    Replace('namePrefix', "'$($scenario.prefix)'").
                    Replace('serviceShort', "'swenua'").
                    Replace('baseTime', "'$($scenario.time)'").
                    Replace('deployment().name', "'attempt-$attempt-$iteration'")
                    $parameterLines += "param storage$suffix = $expression"
                }
            }
        }
        $parameterPath = Join-Path $TestDrive 'names.bicepparam'
        $parameterOutput = Join-Path $TestDrive 'names.json'
        $parameterLines -join "`n" | Set-Content -LiteralPath $parameterPath
        $diagnostics = bicep build-params $parameterPath --no-restore --outfile $parameterOutput 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $names = (Get-Content -LiteralPath $parameterOutput -Raw | ConvertFrom-Json -AsHashtable).parameters
    }

    It 'Isolates <symbol> names across subscriptions, runs and prefixes' -ForEach @(
        @{ symbol = 'group' }
        @{ symbol = 'storage' }
    ) {
        $scopedNames = @(0..3 | ForEach-Object { $names["${symbol}${_}t1init"].value })
        @($scopedNames | Select-Object -Unique).Count | Should -Be 4
    }

    It 'Keeps <symbol> stable across initial, repeat and regional retry deployments' -ForEach @(
        @{ symbol = 'group' }
        @{ symbol = 'storage' }
    ) {
        foreach ($scopeIndex in 0..3) {
            $scopedNames = @(
                foreach ($attempt in 1..3) {
                    foreach ($iteration in @('init', 'idem')) {
                        $names["${symbol}${scopeIndex}t${attempt}${iteration}"].value
                    }
                }
            )
            @($scopedNames | Select-Object -Unique).Count | Should -Be 1
        }
    }

    It 'Does not reuse the legacy fixed resource group' {
        foreach ($entry in ($names.GetEnumerator() | Where-Object Key -Like 'group*')) {
            $entry.Value.value | Should -Not -Be 'dep-gci-synapse.workspaces-swenua-rg'
            $entry.Value.value | Should -Match '^dep-[a-z]+-synapse\.workspaces-swenua-[a-z0-9]{13}-rg$'
            $entry.Value.value.Length | Should -BeLessOrEqual 90
        }
    }

    It 'Produces valid globally scoped storage names' {
        foreach ($entry in ($names.GetEnumerator() | Where-Object Key -Like 'storage*')) {
            $entry.Value.value | Should -Match '^dep[a-z0-9]{13}$'
        }
    }

    It 'Wires the isolated group and storage into the real dependency and preserves both CMK deployments' {
        $group = $template.resources | Where-Object type -EQ 'Microsoft.Resources/resourceGroups'
        $group.name | Should -Be "[parameters('resourceGroupName')]"
        $dependencies = $template.resources | Where-Object { $_.properties.parameters.storageAccountName }
        $dependencies.resourceGroup | Should -Be "[parameters('resourceGroupName')]"
        $dependencies.properties.parameters.storageAccountName.value |
            Should -Be "[format('dep{0}', uniqueString(subscriptionResourceId('Microsoft.Resources/resourceGroups', parameters('resourceGroupName')), parameters('namePrefix'), parameters('serviceShort')))]"
        $deployment = $template.resources | Where-Object { $_.properties.parameters.customerManagedKey }
        $deployment.copy.batchSize | Should -Be 1
        $deployment.copy.count | Should -Match "'init', 'idem'"
        $deployment.resourceGroup | Should -Be "[parameters('resourceGroupName')]"
        $deployment.properties.parameters.customerManagedKey.value.userAssignedIdentityResourceId | Should -Not -BeNullOrEmpty
        $deployment.properties.parameters.customerManagedKey.value.keyVaultResourceId | Should -Not -BeNullOrEmpty
        $deployment.properties.parameters.customerManagedKey.value.keyName | Should -Not -BeNullOrEmpty
    }
}
