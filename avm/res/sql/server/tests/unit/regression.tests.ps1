param (
    [Parameter()]
    [array] $moduleFolderPaths,

    [Parameter()]
    [string] $repoRootPath
)

BeforeDiscovery {
    $namingScenarios = @(
        @{ scenario = 'baseline'; overrides = @{} }
        @{ scenario = 'idem'; overrides = @{ iteration = 'idem' } }
        @{ scenario = 'independent'; overrides = @{ run = 'run-two'; vaultRunToken = 'vault-two' } }
        @{ scenario = 'subscription'; overrides = @{ subscription = '22222222-2222-2222-2222-222222222222' } }
        @{ scenario = 'longPrefix'; overrides = @{ prefix = ('a' * 100) } }
    )
    $fixtureCases = @(
        @{ fixture = 'audit'; ordinaryKinds = @('storageAccountName', 'server'); globalKinds = @('storageAccountName', 'server'); hasVault = $false; hasPoolId = $false }
        @{ fixture = 'vulnAssm'; ordinaryKinds = @('storageAccountName', 'server'); globalKinds = @('storageAccountName', 'server'); hasVault = $false; hasPoolId = $false }
        @{ fixture = 'max'; ordinaryKinds = @('storageAccountName', 'server', 'pool'); globalKinds = @('storageAccountName', 'server', 'keyVaultName'); hasVault = $true; hasPoolId = $false }
        @{ fixture = 'waf-aligned'; ordinaryKinds = @('storageAccountName', 'server', 'pool', 'elasticPoolResourceId'); globalKinds = @('storageAccountName', 'server', 'keyVaultName'); hasVault = $true; hasPoolId = $true }
        @{ fixture = 'cmk-uami'; ordinaryKinds = @(); globalKinds = @('keyVaultName'); hasVault = $true; hasPoolId = $false }
    )
    foreach ($case in $fixtureCases) { $case.scenarios = $namingScenarios }

    $primaryId = '/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/test-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/primary'
    $userAssignedIdentities = @{ $primaryId = @{ principalId = 'user-principal' } }
    $mixedIdentity = @{ type = 'SystemAssigned,UserAssigned'; principalId = 'system-principal'; userAssignedIdentities = $userAssignedIdentities }
    $identityCases = @(
        @{ key = 'mixed'; scenario = 'primary UAMI with SAMI'; expected = 'user-principal'; server = @{ identity = $mixedIdentity; properties = @{ primaryUserAssignedIdentityId = $primaryId } } }
        @{ key = 'userOnly'; scenario = 'UAMI only'; expected = 'user-principal'; server = @{ identity = @{ type = 'UserAssigned'; userAssignedIdentities = $userAssignedIdentities }; properties = @{ primaryUserAssignedIdentityId = $primaryId } } }
        @{ key = 'mixedCase'; scenario = 'differently cased primary ID'; expected = 'user-principal'; server = @{ identity = $mixedIdentity; properties = @{ primaryUserAssignedIdentityId = $primaryId.ToUpperInvariant() } } }
        @{ key = 'systemOnly'; scenario = 'SAMI only'; expected = 'system-principal'; server = @{ identity = @{ type = 'SystemAssigned'; principalId = 'system-principal' }; properties = @{} } }
        @{ key = 'noPrimary'; scenario = 'mixed identities without a primary'; expected = 'system-principal'; server = @{ identity = $mixedIdentity; properties = @{} } }
        @{ key = 'unresolved'; scenario = 'unresolvable primary'; expected = $null; server = @{ identity = $mixedIdentity; properties = @{ primaryUserAssignedIdentityId = "$primaryId-missing" } } }
        @{ key = 'missing'; scenario = 'missing identity'; expected = $null; server = @{ properties = @{} } }
    )
    $classicConfiguration = @{ name = 'default' }
    $assessmentCases = @(
        @{ scenario = 'neither'; classic = $null; express = $null; classicEnabled = $false; expressDeployed = $false; rejects = $false }
        @{ scenario = 'classicOnly'; classic = $classicConfiguration; express = $null; classicEnabled = $true; expressDeployed = $false; rejects = $false }
        @{ scenario = 'expressDisabled'; classic = $null; express = 'Disabled'; classicEnabled = $false; expressDeployed = $true; rejects = $false }
        @{ scenario = 'classicAndExpressDisabled'; classic = $classicConfiguration; express = 'Disabled'; classicEnabled = $true; expressDeployed = $true; rejects = $false }
        @{ scenario = 'expressEnabled'; classic = $null; express = 'Enabled'; classicEnabled = $false; expressDeployed = $true; rejects = $false }
        @{ scenario = 'conflicting'; classic = $classicConfiguration; express = 'Enabled'; classicEnabled = $false; expressDeployed = $false; rejects = $true }
    )
}

BeforeAll {
    $moduleRoot = $moduleFolderPaths[0]
}

Describe 'SQL fixture resource naming' {
    Context '<fixture>' -ForEach $fixtureCases {
        BeforeAll {
            $source = Get-Content -LiteralPath (Join-Path $moduleRoot "tests\e2e\$fixture\main.test.bicep") -Raw
            $suffix = [regex]::Match($source, '(?m)^var resourceSuffix = ([^\r\n]+)').Groups[1].Value.Trim()
            $service = [regex]::Match($source, "param serviceShort string = '([^']+)'").Groups[1].Value
            $expressions = @{}
            foreach ($property in @('storageAccountName', 'keyVaultName', 'elasticPoolResourceId')) {
                $match = [regex]::Match($source, "(?m)^\s+$property`: ([^\r\n]+)")
                if ($match.Success) { $expressions[$property] = $match.Groups[1].Value.Trim() }
            }
            $server = [regex]::Match($source, '(?s)module testDeployment .*?params: \{\s*name: ([^\r\n]+)').Groups[1].Value.Trim()
            $expressions.server = $server
            $pool = [regex]::Match($source, '(?s)elasticPools: \[\s*\{\s*name: ([^\r\n]+)')
            if ($pool.Success) { $expressions.pool = $pool.Groups[1].Value.Trim() }
            $kinds = @($ordinaryKinds + $globalKinds | Select-Object -Unique)
            foreach ($kind in $kinds) {
                if (-not $expressions[$kind]) { throw "Missing $fixture $kind expression." }
            }
            if ($fixture -in @('max', 'waf-aligned')) {
                $helper = Get-Content -LiteralPath (Join-Path $repoRootPath 'utilities\e2e-template-assets\templates\diagnostic.dependencies.bicep') -Raw
                $storageExpression = [regex]::Match($helper, "(?s)resource storageAccount '[^']+' = \{\s*name:\s*([^\r\n]+)").Groups[1].Value.Trim()
                if (-not $storageExpression) { throw 'Missing diagnostic storage account name expression.' }
            }
            $defaults = @{
                subscription = '11111111-1111-1111-1111-111111111111'
                prefix = 'avm'
                run = 'run-one'
                vaultRunToken = 'vault-one'
                iteration = 'init'
            }
            $parameters = @('using none')
            $groupIds = @{}
            foreach ($case in $scenarios) {
                $values = $defaults.Clone()
                foreach ($property in $case.overrides.Keys) { $values[$property] = $case.overrides[$property] }
                $key = $case.scenario
                $groupId = "/subscriptions/$($values.subscription)/resourceGroups/dep-$($values.prefix)-sql.servers-$service-rg"
                $groupIds[$key] = $groupId
                if ($suffix) {
                    $parameters += "param ${key}Suffix = $($suffix.Replace('subscription().id', "'$($values.subscription)'").Replace('baseTime', "'$($values.run)'").Replace('deployment().name', "'$($values.run)'"))"
                }
                foreach ($kind in $kinds) {
                    $expression = $expressions[$kind].
                        Replace('namePrefix', "'$($values.prefix)'").
                        Replace('serviceShort', "'$service'").
                        Replace('resourceSuffix', "${key}Suffix").
                        Replace('resourceGroup.id', "'$groupId'").
                        Replace('vaultRunToken', "'$($values.vaultRunToken)'").
                        Replace('baseTime', "'$($values.run)'").
                        Replace('deployment().name', "'$($values.run)'").
                        Replace('iteration', "'$($values.iteration)'")
                    if ($kind -eq 'storageAccountName' -and $fixture -in @('max', 'waf-aligned')) {
                        $expression = $storageExpression.Replace('storageAccountName', "($expression)").Replace('resourceGroup().id', "'$groupId'")
                    }
                    $parameters += "param ${key}${kind} = $expression"
                }
            }
            $parameterPath = Join-Path $TestDrive "$fixture-names.bicepparam"
            $outputPath = Join-Path $TestDrive "$fixture-names.json"
            $parameters -join "`n" | Set-Content -LiteralPath $parameterPath
            $diagnostics = bicep build-params $parameterPath --no-restore --outfile $outputPath 2>&1
            if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
            $names = (Get-Content -LiteralPath $outputPath -Raw | ConvertFrom-Json -AsHashtable).parameters
        }

        It 'Keeps <_> stable across independent runs' -ForEach $ordinaryKinds {
            $names["independent$_"].value | Should -BeExactly $names["baseline$_"].value
        }

        It 'Keeps <_> stable across init/idem' -ForEach $ordinaryKinds {
            $names["idem$_"].value | Should -BeExactly $names["baseline$_"].value
        }

        It 'Differentiates <_> across subscriptions' -ForEach $globalKinds {
            $names["subscription$_"].value | Should -Not -Be $names["baseline$_"].value
        }

        if ($hasVault) {
            It 'Keeps the Key Vault stable across init/idem within one run' {
                $names.idemkeyVaultName.value | Should -BeExactly $names.baselinekeyVaultName.value
            }

            It 'Uses a fresh Key Vault name for an independent run' {
                $names.independentkeyVaultName.value | Should -Not -Be $names.baselinekeyVaultName.value
            }

            It 'Meets Key Vault naming constraints (<scenario>)' -ForEach @($scenarios | Where-Object { $_.scenario -in @('baseline', 'longPrefix') }) {
                $names["${scenario}keyVaultName"].value | Should -Match '^[a-zA-Z][a-zA-Z0-9-]{1,22}[a-zA-Z0-9]$'
                $names["${scenario}keyVaultName"].value | Should -Not -Match '--'
            }
        }

        if ($ordinaryKinds -contains 'storageAccountName') {
            It 'Meets storage account naming constraints (<scenario>)' -ForEach @($scenarios | Where-Object { $_.scenario -in @('baseline', 'longPrefix') }) {
                $names["${scenario}storageAccountName"].value | Should -Match '^[a-z0-9]{3,24}$'
            }
        }

        if ($hasPoolId) {
            It 'Uses the deployed server and pool names in the elastic pool ID (<scenario>)' -ForEach $scenarios {
                $server = $names["${scenario}server"].value
                $pool = $names["${scenario}pool"].value
                $names["${scenario}elasticPoolResourceId"].value | Should -Be "$($groupIds[$scenario])/providers/Microsoft.Sql/servers/$server/elasticPools/$pool"
            }
        }
    }
}

Describe 'SQL auditing identity selection' -ForEach @(@{ identityCases = $identityCases }) {
    BeforeAll {
        $source = Get-Content -LiteralPath (Join-Path $moduleRoot 'auditing-setting\main.bicep') -Raw
        $selectionExpression = [regex]::Match($source, '(?s)var serverIdentityPrincipalId = (.*?)\r?\n\s*module storageAccount_sbdc_rbac').Groups[1].Value.Trim()
        $principalExpression = [regex]::Match($source, '(?s)managedIdentityPrincipalId:\s*(.*?)\r?\n\s*\}').Groups[1].Value.Trim()
        if (-not $selectionExpression -or -not $principalExpression) { throw 'Missing auditing identity selection expressions.' }
        $parameters = @('using none')
        foreach ($case in $identityCases) {
            $serverJson = $case.server | ConvertTo-Json -Depth 6 -Compress
            $parameters += "var $($case.key)Server = any(json('$serverJson'))"
            $parameters += "param $($case.key)Principal = $($selectionExpression.Replace('server.', "$($case.key)Server."))"
        }
        $parameterPath = Join-Path $TestDrive 'auditing-identities.bicepparam'
        $outputPath = Join-Path $TestDrive 'auditing-identities.json'
        $parameters -join "`n" | Set-Content -LiteralPath $parameterPath
        $diagnostics = bicep build-params $parameterPath --no-restore --outfile $outputPath 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $principals = (Get-Content -LiteralPath $outputPath -Raw | ConvertFrom-Json -AsHashtable).parameters
    }

    It 'Selects the expected auditing principal for <scenario>' -ForEach $identityCases {
        if ($null -eq $expected) {
            $principals["${key}Principal"].value | Should -BeNullOrEmpty
        } else {
            $principals["${key}Principal"].value | Should -BeExactly $expected
        }
    }

    It 'Rejects managed-identity storage auditing with <scenario>' -ForEach @($identityCases | Where-Object { $_.key -in @('unresolved', 'missing') }) {
        $serverJson = $server | ConvertTo-Json -Depth 6 -Compress
        $parameters = @(
            'using none'
            "var server = any(json('$serverJson'))"
            "var serverIdentityPrincipalId = $selectionExpression"
            "param principal = $principalExpression"
        )
        $parameterPath = Join-Path $TestDrive "$key-auditing-principal.bicepparam"
        $outputPath = Join-Path $TestDrive "$key-auditing-principal.json"
        $parameters -join "`n" | Set-Content -LiteralPath $parameterPath
        $diagnostics = bicep build-params $parameterPath --no-restore --outfile $outputPath 2>&1
        $LASTEXITCODE | Should -Not -Be 0
        ($diagnostics | Out-String) | Should -Match 'The SQL server must have a system-assigned or a primary user-assigned identity'
    }
}

Describe 'SQL vulnerability assessment configuration' -ForEach @(@{ assessmentCases = $assessmentCases }) {
    BeforeAll {
        $source = Get-Content -LiteralPath (Join-Path $moduleRoot 'main.bicep') -Raw
        $guard = [regex]::Match($source, '(?s)var checkVulnerabilityAssessmentConfig = (.*?)\r?\n\r?\n').Groups[1].Value.Trim()
        $classicCondition = [regex]::Match($source, '(?m)^module server_vulnerabilityAssessment .*? = if \((.*)\) \{').Groups[1].Value
        $expressCondition = [regex]::Match($source, '(?m)^resource server_sqlVulnerabilityAssessment .*? = if \((.*)\) \{').Groups[1].Value
        if (-not $guard -or -not $classicCondition -or -not $expressCondition) { throw 'Missing vulnerability assessment guard or deployment conditions.' }
        $template = Get-Content -LiteralPath (Join-Path $moduleRoot 'main.json') -Raw | ConvertFrom-Json -AsHashtable -Depth 100
    }

    It 'Preserves deployment behavior for <scenario>' -ForEach $assessmentCases {
        $classicJson = ConvertTo-Json -InputObject $classic -Compress
        $expressJson = ConvertTo-Json -InputObject $express -Compress
        $parameters = @(
            'using none'
            "var vulnerabilityAssessmentsObj = any(json('$classicJson'))"
            "var expressVulnerabilityAssessmentState = any(json('$expressJson'))"
            "var checkVulnerabilityAssessmentConfig = $guard"
            "param classicDeployment = $classicCondition"
            "param expressDeployment = $expressCondition"
        )
        # build-params wraps fail() messages reached through variables(), so also evaluate the guard directly.
        if ($rejects) { $parameters += "param configurationCheck = $guard" }
        $parameterPath = Join-Path $TestDrive "$scenario-assessment.bicepparam"
        $outputPath = Join-Path $TestDrive "$scenario-assessment.json"
        $parameters -join "`n" | Set-Content -LiteralPath $parameterPath
        $diagnostics = bicep build-params $parameterPath --no-restore --outfile $outputPath 2>&1
        if ($rejects) {
            $LASTEXITCODE | Should -Not -Be 0
            ($diagnostics | Out-String) | Should -Match 'cannot be combined with the express configuration'
            ($diagnostics | Out-String) | Should -Match 'Failed to evaluate parameter "classicDeployment"'
            ($diagnostics | Out-String) | Should -Match 'Failed to evaluate parameter "expressDeployment"'
        } else {
            $LASTEXITCODE | Should -Be 0 -Because ($diagnostics | Out-String)
            $deployments = (Get-Content -LiteralPath $outputPath -Raw | ConvertFrom-Json -AsHashtable).parameters
            $deployments.classicDeployment.value | Should -Be $classicEnabled
            $deployments.expressDeployment.value | Should -Be $expressDeployed
        }
    }

    It 'Wires the guard into the compiled <resource> condition' -ForEach @(
        @{ resource = 'server_vulnerabilityAssessment'; parameter = 'vulnerabilityAssessmentsObj' }
        @{ resource = 'server_sqlVulnerabilityAssessment'; parameter = 'expressVulnerabilityAssessmentState' }
    ) {
        $condition = $template.resources[$resource].condition
        $condition | Should -Match ([regex]::Escape("parameters('$parameter')"))
        if ($condition -match "variables\('checkVulnerabilityAssessmentConfig'\)") {
            $template.variables.checkVulnerabilityAssessmentConfig | Should -Match 'fail\('
        } else {
            $condition | Should -Match 'fail\('
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
    }

    It 'Routes <_> using the published master database interface' -ForEach @('workspaceId', 'storageAccountId', 'eventHubAuthorizationRuleId', 'eventHubName', 'marketplacePartnerId') {
        $settings[0].properties[$_] | Should -Match "parameters\('masterDatabaseDiagnosticSettings'\)"
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
