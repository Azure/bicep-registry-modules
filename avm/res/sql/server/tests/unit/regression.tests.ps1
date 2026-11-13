param (
    [Parameter()]
    [array] $moduleFolderPaths,

    [Parameter()]
    [string] $repoRootPath
)

BeforeAll {
    $moduleRoot = $moduleFolderPaths[0]
}

Describe 'SQL fixture resource naming' {
    BeforeAll {
        $helper = Get-Content -LiteralPath (Join-Path $repoRootPath 'utilities\e2e-template-assets\templates\diagnostic.dependencies.bicep') -Raw
        $storageExpression = [regex]::Match($helper, "(?s)resource storageAccount '[^']+' = \{\s*name:\s*([^\r\n]+)").Groups[1].Value.Trim()
        $parameters = [System.Collections.Generic.List[string]]::new()
        $parameters.Add('using none')
        $cases = @()
        $fixtureIndex = 0
        foreach ($fixture in @('audit', 'vulnAssm', 'max', 'waf-aligned', 'cmk-uami')) {
            $source = Get-Content -LiteralPath (Join-Path $moduleRoot "tests\e2e\$fixture\main.test.bicep") -Raw
            $suffix = [regex]::Match($source, '(?m)^var resourceSuffix = ([^\r\n]+)').Groups[1].Value.Trim()
            if (-not $suffix) { throw "Missing resource suffix in $fixture." }
            $service = [regex]::Match($source, "param serviceShort string = '([^']+)'").Groups[1].Value
            $expressions = @{}
            foreach ($property in @('storageAccountName', 'keyVaultName', 'elasticPoolResourceId')) {
                $match = [regex]::Match($source, "(?m)^\s+$property`: ([^\r\n]+)")
                if ($match.Success) { $expressions[$property] = $match.Groups[1].Value.Trim() }
            }
            $server = [regex]::Match($source, '(?s)module testDeployment .*?params: \{\s*name: ([^\r\n]+)').Groups[1].Value.Trim()
            if ($server.Contains('resourceSuffix')) { $expressions.server = $server }
            $pool = [regex]::Match($source, '(?s)elasticPools: \[\s*\{\s*name: ([^\r\n]+)')
            if ($pool.Success) { $expressions.pool = $pool.Groups[1].Value.Trim() }
            foreach ($scopeIndex in 0..1) {
                $subscription = @('11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222')[$scopeIndex]
                foreach ($prefix in @('avm', 'test')) {
                    $groupId = "/subscriptions/$subscription/resourceGroups/dep-$prefix-sql.servers-$service-rg"
                    foreach ($attempt in 1..2) {
                        foreach ($iteration in @('init', 'idem')) {
                            $key = "f${fixtureIndex}s${scopeIndex}${prefix}a${attempt}${iteration}"
                            $parameters.Add("param ${key}Suffix = $($suffix.Replace('subscription().id', "'$subscription'").Replace('baseTime', "'attempt-$attempt-$iteration'"))")
                            foreach ($kind in $expressions.Keys) {
                                $expression = $expressions[$kind].
                                Replace('namePrefix', "'$prefix'").
                                Replace('serviceShort', "'$service'").
                                Replace('resourceSuffix', "${key}Suffix").
                                Replace('resourceGroup.id', "'$groupId'").
                                Replace('baseTime', "'attempt-$attempt-$iteration'").
                                Replace('deployment().name', "'attempt-$attempt-$iteration'")
                                if ($kind -eq 'storageAccountName' -and $fixture -in @('max', 'waf-aligned')) {
                                    $expression = $storageExpression.Replace('storageAccountName', "($expression)").Replace('resourceGroup().id', "'$groupId'")
                                }
                                $parameters.Add("param ${key}${kind} = $expression")
                                $cases += @{
                                    key     = "${key}${kind}"
                                    fixture = $fixture
                                    scope   = $scopeIndex
                                    prefix  = $prefix
                                    kind    = $kind
                                    groupId = $groupId
                                    pairKey = $key
                                }
                            }
                        }
                    }
                }
            }
            $fixtureIndex++
        }
        $parameterPath = Join-Path $TestDrive 'names.bicepparam'
        $outputPath = Join-Path $TestDrive 'names.json'
        $parameters -join "`n" | Set-Content -LiteralPath $parameterPath
        $diagnostics = bicep build-params $parameterPath --no-restore --outfile $outputPath 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $names = (Get-Content -LiteralPath $outputPath -Raw | ConvertFrom-Json -AsHashtable).parameters
    }

    It 'Keeps resource names stable across reruns and init/idem iterations' {
        foreach ($group in ($cases | Group-Object fixture, scope, prefix, kind)) {
            @($group.Group | ForEach-Object { $names[$_.key].value } | Select-Object -Unique).Count |
                Should -Be 1 -Because $group.Name
        }
    }

    It 'Differentiates global resource names across subscriptions' {
        foreach ($group in ($cases | Where-Object { $_.kind -in @('storageAccountName', 'keyVaultName', 'server') } | Group-Object fixture, prefix, kind)) {
            @($group.Group | ForEach-Object { $names[$_.key].value } | Select-Object -Unique).Count |
                Should -Be 2 -Because $group.Name
        }
    }

    It 'Respects storage account and Key Vault naming constraints' {
        foreach ($case in $cases) {
            $name = $names[$case.key].value
            if ($case.kind -eq 'storageAccountName') {
                $name | Should -Match '^[a-z0-9]{3,24}$' -Because $case.fixture
            } elseif ($case.kind -eq 'keyVaultName') {
                $name | Should -Match '^[a-zA-Z][a-zA-Z0-9-]{1,22}[a-zA-Z0-9]$' -Because $case.fixture
                $name | Should -Not -Match '--'
            }
        }
    }

    It 'Uses the deployed server and pool names in elastic pool resource IDs' {
        foreach ($case in ($cases | Where-Object { $_.kind -eq 'elasticPoolResourceId' })) {
            $server = $names["$($case.pairKey)server"].value
            $pool = $names["$($case.pairKey)pool"].value
            $names[$case.key].value | Should -Be "$($case.groupId)/providers/Microsoft.Sql/servers/$server/elasticPools/$pool"
        }
    }
}

Describe 'SQL master database diagnostic settings' {
    BeforeAll {
        $template = Get-Content -LiteralPath (Join-Path $moduleRoot 'main.json') -Raw | ConvertFrom-Json -AsHashtable
        $settings = @($template.resources.Values | Where-Object { $_.type -eq 'Microsoft.Insights/diagnosticSettings' })
        $source = Get-Content -LiteralPath (Join-Path $moduleRoot 'main.bicep') -Raw
        $implementation = [regex]::Match($source, '(?s)resource masterDatabase_diagnosticSettings .*?\r?\n\]').Value
        $fallbacks = @([regex]::Matches($implementation, 'for group in \(([^\r\n]+)\): \{'))
        if ($fallbacks.Count -ne 2) { throw 'Expected metric and log category expressions in master database diagnostics.' }
        $parameters = @(
            'using none'
            'param defaultSetting = {}'
            "param explicitSetting = { metricCategories: [{ category: 'AllMetrics', enabled: false }], logCategoriesAndGroups: [{ category: 'SQLSecurityAuditEvents' }, { category: 'DevOpsOperationsAudit' }] }"
        )
        foreach ($scenario in @('default', 'explicit')) {
            $parameters += "param ${scenario}Metrics = $($fallbacks[0].Groups[1].Value.Replace('diagnosticSetting.', "${scenario}Setting."))"
            $parameters += "param ${scenario}Logs = $($fallbacks[1].Groups[1].Value.Replace('diagnosticSetting.', "${scenario}Setting."))"
        }
        $parameterPath = Join-Path $TestDrive 'diagnostics.bicepparam'
        $outputPath = Join-Path $TestDrive 'diagnostics.json'
        $parameters -join "`n" | Set-Content -LiteralPath $parameterPath
        $diagnostics = bicep build-params $parameterPath --no-restore --outfile $outputPath 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $categories = (Get-Content -LiteralPath $outputPath -Raw | ConvertFrom-Json -AsHashtable).parameters
    }

    It 'Deploys one diagnostic settings loop using the published master database interface' {
        $settings.Count | Should -Be 1
        $settings[0].copy.count | Should -Match "parameters\('masterDatabaseDiagnosticSettings'\)"
        $settings[0].scope | Should -Match 'Microsoft.Sql/servers/databases'
        $settings[0].scope | Should -Match "'master'"
        $template.parameters.ContainsKey('diagnosticSettings') | Should -BeFalse
        foreach ($property in @('workspaceId', 'storageAccountId', 'eventHubAuthorizationRuleId', 'eventHubName', 'marketplacePartnerId')) {
            $settings[0].properties[$property] | Should -Match "parameters\('masterDatabaseDiagnosticSettings'\)"
        }
    }

    It 'Defaults to all logs without enabling unsupported master database metrics' {
        $categories.defaultMetrics.value.Count | Should -Be 0
        $categories.defaultLogs.value.Count | Should -Be 1
        $categories.defaultLogs.value[0].categoryGroup | Should -Be 'allLogs'
    }

    It 'Preserves explicitly requested metrics and both audit log categories' {
        $categories.explicitMetrics.value[0].category | Should -Be 'AllMetrics'
        $categories.explicitMetrics.value[0].enabled | Should -BeFalse
        $categories.explicitLogs.value.category | Should -Be @('SQLSecurityAuditEvents', 'DevOpsOperationsAudit')
    }
}
