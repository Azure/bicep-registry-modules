param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Lab fixture storage naming' {
    BeforeAll {
        $fixturePath = Join-Path $repoRootPath 'avm' 'res' 'dev-test-lab' 'lab' 'tests' 'e2e' 'max' 'main.test.bicep'
        $fixture = Get-Content -LiteralPath $fixturePath -Raw
        $nameExpression = [regex]::Match($fixture, '(?m)^\s+storageAccountName:\s*(.+)').Groups[1].Value.Trim()
        $nameExpression | Should -Not -BeNullOrEmpty
        $compiledPath = Join-Path $TestDrive 'fixture.json'
        $diagnostics = bicep build $fixturePath --no-restore --outfile $compiledPath 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $template = Get-Content -LiteralPath $compiledPath -Raw | ConvertFrom-Json -AsHashtable
        $dependencies = $template.resources | Where-Object { $_.properties.parameters.storageAccountName }

        $scenarios = @(
            @{ subscription = '11111111-1111-1111-1111-111111111111'; group = 'dep-gci-devtestlab.labs-dtllmax-rg'; short = 'dtllmax' }
            @{ subscription = '22222222-2222-2222-2222-222222222222'; group = 'dep-gci-devtestlab.labs-dtllmax-rg'; short = 'dtllmax' }
            @{ subscription = '11111111-1111-1111-1111-111111111111'; group = 'dep-other-devtestlab.labs-dtllmax-rg'; short = 'dtllmax' }
            @{ subscription = '11111111-1111-1111-1111-111111111111'; group = 'dep-gci-devtestlab.labs-dtllmax-rg'; short = 'dtllwaf' }
            @{ subscription = '11111111-1111-1111-1111-111111111111'; group = ('A' * 90); short = 'UPPER-with-punctuation' }
        )
        $parameterLines = @('using none')
        for ($scopeIndex = 0; $scopeIndex -lt $scenarios.Count; $scopeIndex++) {
            $scenario = $scenarios[$scopeIndex]
            $id = "/subscriptions/$($scenario.subscription)/resourceGroups/$($scenario.group)"
            foreach ($attempt in 1..3) {
                foreach ($iteration in @('init', 'idem')) {
                    $expression = $nameExpression.Replace('resourceGroup.id', "'$id'").
                    Replace('serviceShort', "'$($scenario.short)'").
                    Replace('namePrefix', "'gci'").
                    Replace('deployment().name', "'attempt-$attempt-$iteration'").
                    Replace('baseTime', "'2026-09-28 21:00:00Z'")
                    $parameterLines += "param name${scopeIndex}t${attempt}${iteration} = $expression"
                }
            }
        }
        $parameterLines += @(
            'param legacySubscriptionOne = ''dep${''gci''}sa${''dtllmax''}'''
            'param legacySubscriptionTwo = ''dep${''gci''}sa${''dtllmax''}'''
        )
        $parameterPath = Join-Path $TestDrive 'names.bicepparam'
        $parameterOutput = Join-Path $TestDrive 'names.json'
        $parameterLines -join "`n" | Set-Content -LiteralPath $parameterPath
        $diagnostics = bicep build-params $parameterPath --no-restore --outfile $parameterOutput 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $names = (Get-Content -LiteralPath $parameterOutput -Raw | ConvertFrom-Json -AsHashtable).parameters
    }

    It 'Reproduces the previous globally colliding name across subscriptions' {
        $names.legacySubscriptionOne.value | Should -Be 'depgcisadtllmax'
        $names.legacySubscriptionTwo.value | Should -Be $names.legacySubscriptionOne.value
    }

    It 'Emits the scope-derived name to the actual storage dependency' {
        $dependencies.properties.parameters.storageAccountName.value | Should -Be "[format('dep{0}', uniqueString(subscriptionResourceId('Microsoft.Resources/resourceGroups', parameters('resourceGroupName')), parameters('serviceShort')))]"
        $storage = $dependencies.properties.template.resources | Where-Object { $_.type -eq 'Microsoft.Storage/storageAccounts' }
        $storage.name | Should -Be "[parameters('storageAccountName')]"
    }

    It 'Produces distinct names across subscription, resource-group and fixture scopes' {
        $scopeNames = @(0..4 | ForEach-Object { $names["name${_}t1init"].value })
        @($scopeNames | Select-Object -Unique).Count | Should -Be 5
    }

    It 'Keeps initial, repeat and all retry attempts stable within each scope' {
        foreach ($scopeIndex in 0..4) {
            $scopeNames = @(
                foreach ($attempt in 1..3) {
                    foreach ($iteration in @('init', 'idem')) {
                        $names["name${scopeIndex}t${attempt}${iteration}"].value
                    }
                }
            )
            @($scopeNames | Select-Object -Unique).Count | Should -Be 1
        }
    }

    It 'Evaluates to valid 3..24-character lowercase storage names even with long or punctuated scope inputs' {
        foreach ($entry in ($names.GetEnumerator() | Where-Object { $_.Key -like 'name*' })) {
            $entry.Value.value | Should -Match '^[a-z0-9]{3,24}$'
            $entry.Value.value.Length | Should -Be 16
        }
        $nameExpression | Should -Not -Match 'deployment\(\)\.name|utcNow|baseTime'
    }
}
