Describe 'Cognitive Services account key read ordering' {
    BeforeAll {
        $bicep = (Get-AvmTool -Name bicep -Path $PSScriptRoot -ErrorAction Stop).Path
        if (-not $bicep) { throw 'The managed Bicep compiler is not installed.' }
        $modulePath = Join-Path $PSScriptRoot '..' '..' 'main.bicep'
        $compiledPath = Join-Path $TestDrive 'account.json'
        $diagnostics = & $bicep build $modulePath --outfile $compiledPath 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $template = Get-Content -LiteralPath $compiledPath -Raw | ConvertFrom-Json -AsHashtable -Depth 100
        $keyRead = $template.resources.cognitiveService_keys

        $source = Get-Content -LiteralPath $modulePath -Raw
        $condition = [regex]::Match($source, '(?ms)^module cognitiveService_keys\b.*?= if \((?<condition>.*?)\) \{')
        if (-not $condition.Success) { throw 'Missing conditional key-read module.' }
        $exportConfigurations = @(
            'null'
            '{}'
            "{ keyVaultResourceId: 'vault' }"
            "{ accessKey1Name: 'key1' }"
            "{ accessKey2Name: 'key2' }"
            "{ accessKey1Name: 'key1', accessKey2Name: 'key2' }"
        )
        $parameters = @('using none')
        foreach ($disabled in @('true', 'false')) {
            for ($index = 0; $index -lt $exportConfigurations.Count; $index++) {
                $expression = $condition.Groups['condition'].Value.
                    Replace('disableLocalAuth', $disabled).
                    Replace('secretsExportConfiguration', $exportConfigurations[$index])
                $parameters += "param ${disabled}${index} = $expression"
            }
        }
        $parameterPath = Join-Path $TestDrive 'key-read-conditions.bicepparam'
        $parameterOutput = Join-Path $TestDrive 'key-read-conditions.json'
        $parameters -join "`n" | Set-Content -LiteralPath $parameterPath
        $diagnostics = & $bicep build-params $parameterPath --outfile $parameterOutput 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $conditions = (Get-Content -LiteralPath $parameterOutput -Raw | ConvertFrom-Json -AsHashtable).parameters
    }

    It 'Fetches keys in an inner-scoped deployment after the account and both child collections' {
        $keyRead.type | Should -BeExactly 'Microsoft.Resources/deployments'
        $keyRead.dependsOn | Should -HaveCount 3
        foreach ($dependency in @('cognitiveService', 'cognitiveService_deployments', 'cognitiveService_commitmentPlans')) {
            $keyRead.dependsOn | Should -Contain $dependency
        }
        $keyRead.properties.expressionEvaluationOptions.scope | Should -BeExactly 'inner'
        $keyRead.properties.parameters.accountName.value | Should -BeExactly "[parameters('name')]"
        $keyRead.properties.template.resources.Count | Should -Be 1
        $keyRead.properties.template.resources.cognitiveService.existing | Should -BeTrue
        $keyRead.properties.template.resources.cognitiveService.name | Should -BeExactly "[parameters('accountName')]"
    }

    It 'Does not read keys when local auth is disabled and no key export is requested' {
        $template.parameters.disableLocalAuth.defaultValue | Should -BeTrue
        $keyRead.condition | Should -BeExactly "[or(or(not(parameters('disableLocalAuth')), contains(coalesce(parameters('secretsExportConfiguration'), createObject()), 'accessKey1Name')), contains(coalesce(parameters('secretsExportConfiguration'), createObject()), 'accessKey2Name'))]"
        foreach ($index in 0..5) {
            $conditions["true${index}"].value | Should -Be ($index -ge 3)
            $conditions["false${index}"].value | Should -BeTrue
        }
    }

    It 'Preserves secure nullable key outputs and their local-auth guard' {
        foreach ($outputName in @('primaryKey', 'secondaryKey')) {
            $output = $template.outputs[$outputName]
            $output.type | Should -BeExactly 'securestring'
            $output.nullable | Should -BeTrue
            $output.value | Should -BeExactly "[if(not(parameters('disableLocalAuth')), listOutputsWithSecureValues('cognitiveService_keys', '2025-04-01').$outputName, null())]"
        }
    }

    It 'Keeps key reads and key values inside secure helper outputs' {
        foreach ($entry in @(
            @{ name = 'primaryKey'; key = 'key1' }
            @{ name = 'secondaryKey'; key = 'key2' }
        )) {
            $output = $keyRead.properties.template.outputs[$entry.name]
            $output.type | Should -BeExactly 'securestring'
            $output.value | Should -BeExactly "[listKeys('cognitiveService', '2025-06-01').$($entry.key)]"
        }
        $outerExpressions = @{
            variables = $template.variables
            outputs   = $template.outputs
            resources = @(
                foreach ($resource in $template.resources.Values) {
                    if ($resource.properties -is [System.Collections.IDictionary]) {
                        $resource.properties.parameters
                    }
                }
            )
        } | ConvertTo-Json -Depth 100 -Compress
        $outerExpressions | Should -Not -Match '(?i)\blistKeys\('
    }

    It 'Exports either requested key only after the ordered key read without changing the export condition' {
        $export = $template.resources.secretsExport
        $export.condition | Should -BeExactly "[not(equals(parameters('secretsExportConfiguration'), null()))]"
        $export.dependsOn | Should -Contain 'cognitiveService_keys'
        $secrets = $export.properties.parameters.secretsToSet.value
        $secrets | Should -Not -Match '(?i)\blistKeys\('
        $secrets | Should -Match "contains\(parameters\('secretsExportConfiguration'\), 'accessKey1Name'\)"
        $secrets | Should -Match "contains\(parameters\('secretsExportConfiguration'\), 'accessKey2Name'\)"
        $secrets | Should -Match "listOutputsWithSecureValues\('cognitiveService_keys', '2025-04-01'\)\.primaryKey"
        $secrets | Should -Match "listOutputsWithSecureValues\('cognitiveService_keys', '2025-04-01'\)\.secondaryKey"
    }

    It 'Reaches the key read from the model deployment fixture' {
        $fixturePath = Join-Path $PSScriptRoot '..' 'e2e' 'ai-model-deployment' 'main.test.bicep'
        $fixtureOutput = Join-Path $TestDrive 'fixture.json'
        $diagnostics = & $bicep build $fixturePath --outfile $fixtureOutput 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $fixture = Get-Content -LiteralPath $fixtureOutput -Raw | ConvertFrom-Json -AsHashtable -Depth 100
        $inputs = $fixture.resources.testDeployment.properties.parameters

        $inputs.Keys | Should -Not -Contain 'secretsExportConfiguration'
        $inputs.deployments.value | Should -HaveCount 1
        $inputs.disableLocalAuth.value | Should -BeFalse

        # The key read must be selected for these inputs, and it must wait for the model deployments.
        $fixtureCondition = Join-Path $TestDrive 'fixture-condition.bicepparam'
        $fixtureConditionOutput = Join-Path $TestDrive 'fixture-condition.json'
        $expression = $condition.Groups['condition'].Value.
            Replace('disableLocalAuth', 'false').
            Replace('secretsExportConfiguration', 'null')
        "using none`nparam selected = $expression" | Set-Content -LiteralPath $fixtureCondition
        $diagnostics = & $bicep build-params $fixtureCondition --outfile $fixtureConditionOutput 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        (Get-Content -LiteralPath $fixtureConditionOutput -Raw | ConvertFrom-Json -AsHashtable).parameters.selected.value |
            Should -BeTrue
        $keyRead.dependsOn | Should -Contain 'cognitiveService_deployments'
    }

    It 'Retains empty child collections, serial model writes, and the private endpoint dependencies' {
        $template.resources.cognitiveService_deployments.copy.count |
            Should -BeExactly "[length(coalesce(parameters('deployments'), createArray()))]"
        $template.resources.cognitiveService_deployments.copy.mode | Should -BeExactly 'serial'
        $template.resources.cognitiveService_deployments.copy.batchSize | Should -Be 1
        $template.resources.cognitiveService_commitmentPlans.copy.count |
            Should -BeExactly "[length(coalesce(parameters('commitmentPlans'), createArray()))]"
        foreach ($dependency in @('cognitiveService_deployments', 'cognitiveService_commitmentPlans')) {
            $template.resources.cognitiveService_privateEndpoints.dependsOn | Should -Contain $dependency
        }
    }
}
