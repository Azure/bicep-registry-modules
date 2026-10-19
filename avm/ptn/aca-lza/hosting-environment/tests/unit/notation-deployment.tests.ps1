Describe 'ACA-LZA compiled signing and consuming deployment behavior' {
    BeforeAll {
        $moduleRoot = (Resolve-Path (Join-Path $PSScriptRoot '..' '..')).Path
        $compiledPath = Join-Path $TestDrive 'aca-waf.json'
        $fixture = Join-Path $moduleRoot 'tests' 'e2e' 'waf-aligned' 'main.test.bicep'
        $diagnostics = bicep build $fixture --outfile $compiledPath 2>&1
        if ($LASTEXITCODE -ne 0) { throw "Actual ACA signing fixture compilation failed: $($diagnostics -join "`n")" }
        $compiled = Get-Content -LiteralPath $compiledPath -Raw | ConvertFrom-Json -AsHashtable -Depth 200
        $parent = @($compiled.resources | Where-Object { $_.properties.template.parameters.ContainsKey('deploySampleApplication') })[0]
        $main = $parent.properties.template
        $sample = $main.resources.sampleApplication
        $sampleResources = @($sample.properties.template.resources)
        $producer = @($sampleResources | Where-Object name -CEQ 'verify-sample-image')[0]
        $consumer = @($sampleResources | Where-Object { $_.properties.parameters.ContainsKey('containers') })[0]
        $signing = $producer.properties.template
        $script = @($signing.resources | Where-Object {
                $_.properties.parameters -and $_.properties.parameters.ContainsKey('scriptContent')
            })[0]
        $negative = @($compiled.resources | Where-Object {
                $_.properties.parameters.ContainsKey('sampleVerification')
            })[0]
    }

    Describe 'ACA-LZA cross-platform compiled naming preservation' {
        It 'Produces the same complete naming template and values from LF and CRLF JSONC inputs' {
            $moduleRoot = (Resolve-Path (Join-Path $PSScriptRoot '..' '..')).Path
            $namingRoot = Join-Path $moduleRoot 'modules' 'naming'
            $fixture = Join-Path $TestDrive 'naming.module.bicep'
            Copy-Item -LiteralPath (Join-Path $namingRoot 'naming.module.bicep') -Destination $fixture
            $rules = [IO.File]::ReadAllText((Join-Path $namingRoot 'naming-rules.jsonc')).Replace("`r`n", "`n")
            $compiled = [Collections.Generic.List[Text.Json.Nodes.JsonNode]]::new()
            foreach ($newline in @("`n", "`r`n")) {
                [IO.File]::WriteAllText(
                    (Join-Path $TestDrive 'naming-rules.jsonc'),
                    $rules.Replace("`n", $newline),
                    [Text.UTF8Encoding]::new($false)
                )
                $outputPath = Join-Path $TestDrive "naming-$($compiled.Count).json"
                $diagnostics = bicep build $fixture --outfile $outputPath 2>&1
                if ($LASTEXITCODE -ne 0) { throw "Actual naming compilation failed: $($diagnostics -join "`n")" }
                $compiled.Add([Text.Json.Nodes.JsonNode]::Parse([IO.File]::ReadAllText($outputPath)))
            }
            [Text.Json.Nodes.JsonNode]::DeepEquals($compiled[0], $compiled[1]) |
                Should -BeTrue -Because 'the generated naming deployment must not depend on the checkout newline convention'
            $rulesNode = $compiled[0]['variables']['naming']
            if ($rulesNode -is [Text.Json.Nodes.JsonValue]) {
                if ($rulesNode.GetValue[string]() -cnotmatch "^\[variables\('(?<variable>[^']+)'\)\]$") {
                    throw 'Compiled naming rules did not resolve to an object or a direct variable reference.'
                }
                $rulesNode = $compiled[0]['variables'][$Matches.variable]
            }
            $actualRules = $rulesNode.ToJsonString() | ConvertFrom-Json -AsHashtable
            ($actualRules | ConvertTo-Json -Depth 20 -Compress) |
                Should -BeExactly (($rules | ConvertFrom-Json -AsHashtable) | ConvertTo-Json -Depth 20 -Compress)
        }
    }

    It 'Keeps optional sample deployment off by default but exercises the complete gate in the existing WAF fixture' {
        $main.parameters.deploySampleApplication.defaultValue | Should -BeFalse
        $sample.condition | Should -BeExactly "[parameters('deploySampleApplication')]"
        $parent.properties.parameters.deploySampleApplication.value | Should -BeTrue
    }

    It 'Cannot create the consuming container app before obtaining the verifier-produced immutable image' {
        $containerImage = $consumer.properties.parameters.containers.value[0].image
        $containerImage | Should -Match "\.outputs\.image\.value\]$"
        $containerImage | Should -Match "'verify-sample-image'"
        $containerImage | Should -Not -Match 'mcr\.microsoft\.com|:latest'
        @($consumer.dependsOn | Where-Object { $_ -match "'verify-sample-image'" }).Count | Should -Be 1
    }

    It 'Uses the private registry and its declared pull identity rather than public fallback or registry passwords' {
        $registry = $consumer.properties.parameters.registries.value[0]
        $registry.server | Should -BeExactly "[parameters('containerRegistryLoginServer')]"
        $registry.identity | Should -BeExactly "[parameters('containerRegistryUserAssignedIdentityId')]"
        @($consumer.properties.parameters.managedIdentities.value.userAssignedResourceIds) |
            Should -Be @("[parameters('containerRegistryUserAssignedIdentityId')]")
        $registry.Keys | Should -Not -Contain 'passwordSecretRef'
        $registry.Keys | Should -Not -Contain 'username'
    }

    It 'Confines the signer to the newly deployed registry, vault and script storage resource scopes' {
        $assignments = @($signing.resources | Where-Object type -CEQ 'Microsoft.Authorization/roleAssignments')
        $assignments.Count | Should -Be 3
        @($assignments.scope | Sort-Object) | Should -Be @(
            "[resourceId('Microsoft.ContainerRegistry/registries', parameters('containerRegistryName'))]"
            "[resourceId('Microsoft.KeyVault/vaults', parameters('keyVaultName'))]"
            "[resourceId('Microsoft.Storage/storageAccounts', parameters('storageAccountName'))]"
        )
        $signing.variables.registryRoles | Should -Be @(
            '577a9874-89fd-4f24-9dbd-b5034d0ad23a'
            '8311e382-0749-4cb8-b61a-304f252e45ec'
            'c8d4ff99-41c3-41a8-9f60-21dfdad59608'
        )
        $signing.variables.vaultRoles | Should -Be @(
            'a4417e6f-fecd-4de8-b567-7b0420556985'
            '12338af0-0e69-4776-bea7-57ae8d297424'
        )
    }

    It 'Runs signing inside the existing private deployment subnet and storage with normal script cleanup' {
        $script.properties.parameters.subnetResourceIds.value | Should -Be @("[parameters('deploymentSubnetResourceId')]")
        $script.properties.parameters.storageAccountResourceId.value |
            Should -BeExactly "[resourceId('Microsoft.Storage/storageAccounts', parameters('storageAccountName'))]"
        $script.properties.parameters.cleanupPreference.value | Should -BeExactly 'Always'
        $script.properties.parameters.managedIdentities.value.userAssignedResourceIds[0] | Should -Match 'image-signer-'
    }

    It 'Passes the actual verified digest, public root and scoped signer to the in-network native rejection tests' {
        $negative.properties.parameters.sampleVerification.value | Should -Match '\.outputs\.sampleImageVerification\.value\]$'
        $negative.properties.parameters.sampleVerification.value | Should -Match 'test-'
        @($negative.dependsOn).Count | Should -BeGreaterThan 0
        $compiled.outputs.notationVerification.value | Should -Match '\.outputs\.results\.value\]$'
    }

    It 'Keeps the actual composed signing and negative-control scripts within the provider 32000-character limit' {
        $signingContent = $signing.variables.'$fxv#0' + "`n" + $signing.variables.runScript
        $testVariables = $negative.properties.template.variables
        $testVariables.'$fxv#1' | Should -BeExactly (
            Get-Content -LiteralPath (Join-Path $moduleRoot 'tests' 'e2e' 'waf-aligned' 'Test-NotationImageVerification.ps1') -Raw
        )
        $negativeContent = $testVariables.'$fxv#0' + "`n" + $testVariables.'$fxv#1' + "`n" + $testVariables.runTests
        $signingContent.Length | Should -BeGreaterThan 10000
        $negativeContent.Length | Should -BeGreaterThan $signingContent.Length
        $signingContent.Length | Should -BeLessOrEqual 32000
        $negativeContent.Length | Should -BeLessOrEqual 32000
    }
}
