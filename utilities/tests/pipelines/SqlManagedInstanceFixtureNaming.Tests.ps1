param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'SQL managed-instance vulnerability assessment storage naming' {
    BeforeAll {
        $fixtureFolder = Join-Path $repoRootPath 'avm' 'res' 'sql' 'managed-instance' 'tests' 'e2e' 'vulnAssm'
        $helper = Get-Content -LiteralPath (Join-Path $fixtureFolder 'dependencies.bicep') -Raw
        $match = [regex]::Match($helper, "(?s)resource storageAccount '[^']+' = \{\s*name:\s*(?<expression>[^\r\n]+)")
        if (-not $match.Success) { throw 'Missing storage resource-name expression.' }
        $nameExpression = $match.Groups['expression'].Value.Trim()

        $compiledPath = Join-Path $TestDrive 'fixture.json'
        $diagnostics = bicep build (Join-Path $fixtureFolder 'main.test.bicep') --no-restore --outfile $compiledPath 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $template = Get-Content -LiteralPath $compiledPath -Raw | ConvertFrom-Json -AsHashtable
        $dependencies = $template.resources | Where-Object { $_.properties.parameters.storageAccountName }
        $storage = $dependencies.properties.template.resources | Where-Object { $_.type -eq 'Microsoft.Storage/storageAccounts' }
        $testDeployment = $template.resources | Where-Object { $_.properties.parameters.vulnerabilityAssessment }

        $scenarios = @(
            @{ subscription = '11111111-1111-1111-1111-111111111111'; group = 'dep-gci-sql.managedinstances-sqlmivln-rg'; storage = 'depgcivsqlmivln01' }
            @{ subscription = '22222222-2222-2222-2222-222222222222'; group = 'dep-gci-sql.managedinstances-sqlmivln-rg'; storage = 'depgcivsqlmivln01' }
            @{ subscription = '11111111-1111-1111-1111-111111111111'; group = 'dep-other-sql.managedinstances-sqlmivln-rg'; storage = 'depgcivsqlmivln01' }
            @{ subscription = '11111111-1111-1111-1111-111111111111'; group = 'dep-gci-sql.managedinstances-sqlmivln-rg'; storage = 'anotherstorage' }
            @{ subscription = '11111111-1111-1111-1111-111111111111'; group = 'dep-gci-sql.managedinstances-sqlmivln-rg'; storage = ('s' * 23 + '1') }
            @{ subscription = '11111111-1111-1111-1111-111111111111'; group = 'dep-gci-sql.managedinstances-sqlmivln-rg'; storage = ('s' * 23 + '2') }
            @{ subscription = '11111111-1111-1111-1111-111111111111'; group = ('A' * 90); storage = 'abc' }
            @{ subscription = '11111111-1111-1111-1111-111111111111'; group = 'dep-gci-sql.managedinstances-sqlmivln-rg'; storage = '0sqlstorage' }
        )
        $parameters = @('using none')
        for ($scopeIndex = 0; $scopeIndex -lt $scenarios.Count; $scopeIndex++) {
            $scenario = $scenarios[$scopeIndex]
            $groupId = "/subscriptions/$($scenario.subscription)/resourceGroups/$($scenario.group)"
            foreach ($attempt in 1..3) {
                foreach ($iteration in @('init', 'idem')) {
                    $expression = $nameExpression.Replace('resourceGroup().id', "'$groupId'").
                    Replace('storageAccountName', "'$($scenario.storage)'").
                    Replace('deployment().name', "'attempt-$attempt-$iteration'")
                    $parameters += "param name${scopeIndex}t${attempt}${iteration} = $expression"
                }
            }
        }
        $parameterPath = Join-Path $TestDrive 'names.bicepparam'
        $parameterOutput = Join-Path $TestDrive 'names.json'
        $parameters -join "`n" | Set-Content -LiteralPath $parameterPath
        $diagnostics = bicep build-params $parameterPath --no-restore --outfile $parameterOutput 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $names = (Get-Content -LiteralPath $parameterOutput -Raw | ConvertFrom-Json -AsHashtable).parameters
    }

    It 'Produces distinct names across subscriptions and resource groups' {
        $scopedNames = @(0..2 | ForEach-Object { $names["name${_}t1init"].value })
        @($scopedNames | Select-Object -Unique).Count | Should -Be 3
    }

    It 'Keeps names stable across initial, repeat and retry deployments' {
        for ($scopeIndex = 0; $scopeIndex -lt $scenarios.Count; $scopeIndex++) {
            $scopedNames = @(
                foreach ($attempt in 1..3) {
                    foreach ($iteration in @('init', 'idem')) {
                        $names["name${scopeIndex}t${attempt}${iteration}"].value
                    }
                }
            )
            @($scopedNames | Select-Object -Unique).Count | Should -Be 1
        }
        $nameExpression | Should -Not -Match 'deployment\(\)|utcNow|newGuid|baseTime|iteration'
    }

    It 'Hashes the full base name even when displayed prefixes are truncated' {
        $first = $names.name4t1init.value
        $second = $names.name5t1init.value
        $first.Substring(0, 11) | Should -BeExactly ('s' * 11)
        $second.Substring(0, 11) | Should -BeExactly $first.Substring(0, 11)
        $first.Substring(11) | Should -Not -Be $second.Substring(11)
        $names.name0t1init.value | Should -Not -Be $names.name3t1init.value
    }

    It 'Produces valid lowercase storage names within the 24-character limit' {
        foreach ($entry in $names.Values) {
            $entry.value | Should -MatchExactly '^[a-z0-9]{3,24}$'
        }
        $names.name4t1init.value.Length | Should -Be 24
        $names.name5t1init.value.Length | Should -Be 24
        $names.name6t1init.value | Should -MatchExactly '^abc[a-z0-9]{13}$'
    }

    It 'Emits the scoped storage name inside the dependency resource group' {
        $dependencies.resourceGroup | Should -Be "[parameters('resourceGroupName')]"
        $dependencies.properties.expressionEvaluationOptions.scope | Should -Be 'inner'
        $storage.name | Should -Be "[format('{0}{1}', take(parameters('storageAccountName'), 11), uniqueString(resourceGroup().id, parameters('storageAccountName')))]"
    }

    It 'Passes the generated storage resource ID to both SQL configurations' {
        $storageName = $storage.name.Substring(1, $storage.name.Length - 2)
        $dependencies.properties.template.outputs.storageAccountResourceId.value | Should -Be "[resourceId('Microsoft.Storage/storageAccounts', $storageName)]"
        $dependencyName = $dependencies.name.Substring(1, $dependencies.name.Length - 2)
        $securityStorage = $testDeployment.properties.parameters.securityAlertPolicy.value.storageAccountResourceId
        $securityStorage | Should -Match ([regex]::Escape($dependencyName))
        $securityStorage | Should -Match '^\[reference\(.*\.outputs\.storageAccountResourceId\.value\]$'
        $testDeployment.properties.parameters.vulnerabilityAssessment.value.storageAccountResourceId | Should -BeExactly $securityStorage
    }
}
