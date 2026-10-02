param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Diagnostic fixture resource naming' {
    BeforeAll {
        $helperPath = Join-Path $repoRootPath 'utilities' 'e2e-template-assets' 'templates' 'diagnostic.dependencies.bicep'
        $helper = Get-Content -LiteralPath $helperPath -Raw
        $expressions = @{}
        foreach ($symbol in @('storageAccount', 'eventHubNamespace')) {
            $match = [regex]::Match($helper, "(?s)resource $symbol '[^']+' = \{\s*name:\s*(?<expression>[^\r\n]+)")
            if (-not $match.Success) { throw "Missing resource-name expression for $symbol." }
            $expressions[$symbol] = $match.Groups['expression'].Value.Trim()
        }

        $compiledPath = Join-Path $TestDrive 'diagnostics.json'
        $diagnostics = bicep build $helperPath --no-restore --outfile $compiledPath 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $template = Get-Content -LiteralPath $compiledPath -Raw | ConvertFrom-Json -AsHashtable
        $storage = $template.resources | Where-Object { $_.type -eq 'Microsoft.Storage/storageAccounts' }
        $namespace = $template.resources | Where-Object { $_.type -eq 'Microsoft.EventHub/namespaces' }

        $scenarios = @(
            @{ subscription = '11111111-1111-1111-1111-111111111111'; group = 'fixture-a'; storage = 'diagnosticstorage'; namespace = 'diagnostic-events' }
            @{ subscription = '22222222-2222-2222-2222-222222222222'; group = 'fixture-a'; storage = 'diagnosticstorage'; namespace = 'diagnostic-events' }
            @{ subscription = '11111111-1111-1111-1111-111111111111'; group = 'fixture-b'; storage = 'diagnosticstorage'; namespace = 'diagnostic-events' }
            @{ subscription = '11111111-1111-1111-1111-111111111111'; group = 'fixture-a'; storage = 'anotherstorage'; namespace = 'another-events' }
            @{ subscription = '11111111-1111-1111-1111-111111111111'; group = 'fixture-a'; storage = ('s' * 23 + '1'); namespace = ('N' + 's' * 48 + '1') }
            @{ subscription = '11111111-1111-1111-1111-111111111111'; group = 'fixture-a'; storage = ('s' * 23 + '2'); namespace = ('N' + 's' * 48 + '2') }
            @{ subscription = '11111111-1111-1111-1111-111111111111'; group = ('fixture-' + 'x' * 80); storage = 'abc'; namespace = 'a-b-01' }
            @{ subscription = '11111111-1111-1111-1111-111111111111'; group = 'fixture-a'; storage = '0diagnostics'; namespace = ('diagnostics-' + 'n' * 100) }
        )
        $parameters = @('using none')
        for ($scopeIndex = 0; $scopeIndex -lt $scenarios.Count; $scopeIndex++) {
            $scenario = $scenarios[$scopeIndex]
            $groupId = "/subscriptions/$($scenario.subscription)/resourceGroups/$($scenario.group)"
            foreach ($attempt in 1..3) {
                foreach ($iteration in @('init', 'idem')) {
                    foreach ($symbol in @('storageAccount', 'eventHubNamespace')) {
                        $expression = $expressions[$symbol].
                        Replace('resourceGroup().id', "'$groupId'").
                        Replace('storageAccountName', "'$($scenario.storage)'").
                        Replace('eventHubNamespaceName', "'$($scenario.namespace)'").
                        Replace('deployment().name', "'attempt-$attempt-$iteration'")
                        $parameters += "param ${symbol}${scopeIndex}t${attempt}${iteration} = $expression"
                    }
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

    It 'Changes <symbol> names across subscriptions and resource groups' -ForEach @(
        @{ symbol = 'storageAccount' }
        @{ symbol = 'eventHubNamespace' }
    ) {
        $scopedNames = @(0..2 | ForEach-Object { $names["${symbol}${_}t1init"].value })
        @($scopedNames | Select-Object -Unique).Count | Should -Be 3
    }

    It 'Keeps <symbol> names stable across initial, repeat and retry deployments' -ForEach @(
        @{ symbol = 'storageAccount' }
        @{ symbol = 'eventHubNamespace' }
    ) {
        foreach ($scopeIndex in 0..7) {
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

    It 'Includes the complete <symbol> base name in the suffix even when prefixes are truncated' -ForEach @(
        @{ symbol = 'storageAccount' }
        @{ symbol = 'eventHubNamespace' }
    ) {
        $first = $names["${symbol}4t1init"].value
        $second = $names["${symbol}5t1init"].value
        $first.Substring($first.Length - 13) | Should -Not -Be $second.Substring($second.Length - 13)
        $names["${symbol}0t1init"].value | Should -Not -Be $names["${symbol}3t1init"].value
    }

    It 'Produces valid lowercase storage names within the 24-character limit' {
        foreach ($scopeIndex in 0..7) {
            $name = $names["storageAccount${scopeIndex}t1init"].value
            $name | Should -Match '^[a-z0-9]{3,24}$'
            $name | Should -Not -Be $scenarios[$scopeIndex].storage
        }
        $names.storageAccount4t1init.value.Length | Should -Be 24
        $names.storageAccount6t1init.value | Should -Match '^abc[a-z0-9]{13}$'
    }

    It 'Produces valid Event Hub namespace names within the 50-character limit' {
        foreach ($scopeIndex in 0..7) {
            $name = $names["eventHubNamespace${scopeIndex}t1init"].value
            $name | Should -Match '^[a-zA-Z][a-zA-Z0-9-]{4,48}[a-zA-Z0-9]$'
            $name | Should -Not -Be $scenarios[$scopeIndex].namespace
        }
        $names.eventHubNamespace4t1init.value.Length | Should -Be 50
        $names.eventHubNamespace7t1init.value.Length | Should -Be 50
        $names.eventHubNamespace6t1init.value | Should -Match '^a-b-01-[a-z0-9]{13}$'
    }

    It 'Keeps the scoped workspace, event hub and authorization-rule names unchanged' {
        $workspace = $template.resources | Where-Object { $_.type -eq 'Microsoft.OperationalInsights/workspaces' }
        $hub = $template.resources | Where-Object { $_.type -eq 'Microsoft.EventHub/namespaces/eventhubs' }
        $rule = $template.resources | Where-Object { $_.type -eq 'Microsoft.EventHub/namespaces/authorizationRules' }
        $workspace.name | Should -Be "[parameters('logAnalyticsWorkspaceName')]"
        $hub.name | Should -Match "parameters\('eventHubNamespaceEventHubName'\)"
        $rule.name | Should -Match 'RootManageSharedAccessKey'
        $template.outputs.eventHubNamespaceEventHubName.value | Should -Be "[parameters('eventHubNamespaceEventHubName')]"
        $template.resources.Count | Should -Be 5
    }

    It 'Builds output resource IDs from the generated resource names' {
        $storageName = $storage.name.Substring(1, $storage.name.Length - 2)
        $namespaceName = $namespace.name.Substring(1, $namespace.name.Length - 2)
        $template.outputs.storageAccountResourceId.value | Should -Be "[resourceId('Microsoft.Storage/storageAccounts', $storageName)]"
        $template.outputs.eventHubNamespaceResourceId.value | Should -Be "[resourceId('Microsoft.EventHub/namespaces', $namespaceName)]"
        $template.outputs.eventHubAuthorizationRuleId.value | Should -Match ([regex]::Escape($namespaceName))
    }
}
