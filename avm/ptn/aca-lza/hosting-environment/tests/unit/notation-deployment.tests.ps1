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

    Describe 'ACA-LZA actual post-deployment consumer verification' {
        BeforeAll {
            $moduleRoot = (Resolve-Path (Join-Path $PSScriptRoot '..' '..')).Path
            $tokens = $null
            $parseErrors = $null
            $ast = [Management.Automation.Language.Parser]::ParseFile(
                (Join-Path $moduleRoot 'tests' 'e2e' 'waf-aligned' 'notation.tests.ps1'),
                [ref] $tokens, [ref] $parseErrors)
            if ($parseErrors) { throw 'Actual post-deployment consumer test could not be parsed.' }
            $checks = @($ast.FindAll({
                        param($node)
                        $node -is [Management.Automation.Language.CommandAst] -and
                        $node.GetCommandName() -eq 'It' -and
                        $node.CommandElements[1].Value -eq 'Runs the verified digest in the actual managed-identity consumer latest ready revision'
                    }, $true))
            if ($checks.Count -ne 1) { throw 'Expected exactly one actual consumer post-deployment test.' }
            $consumerAssertion = $checks[0].CommandElements[-1].ScriptBlock.GetScriptBlock()
            function Get-AzResource {
                [CmdletBinding()]
                param ([string] $ResourceGroupName, [string] $ResourceType, [switch] $ExpandProperties)
                throw 'Offline consumer tests must not access Azure.'
            }
            function Invoke-AzRestMethod {
                [CmdletBinding()]
                param ([string] $Method, [string] $Path)
                throw 'Offline consumer tests must not access Azure.'
            }
        }

        BeforeEach {
            $sample = @{ strictVerification = $true; image = 'registry.invalid/aca-lza/sample@sha256:' + ('a' * 64) }
            $outputs = @{
                testDeploymentOutputs = @{
                    value = @{
                        resourceGroupName = @{ value = 'case-owned' }
                        containerRegistryUserAssignedIdentityResourceId = @{ value = '/fixture/pull-identity' }
                    }
                }
            }
            $app = [pscustomobject]@{
                ResourceGroupName = 'case-owned'
                ResourceId = '/subscriptions/fixture/resourceGroups/case-owned/providers/Microsoft.App/containerApps/sample'
                Properties = @{
                    provisioningState = 'Succeeded'
                    latestRevisionName = 'sample--new'
                    latestReadyRevisionName = 'sample--new'
                    template = @{ containers = @(@{ image = $sample.image }) }
                    configuration = @{
                        activeRevisionsMode = 'Single'
                        registries = @(@{ server = 'registry.invalid'; identity = '/fixture/pull-identity' })
                    }
                }
            }
            $script:consumerResources = @($app)
            $script:consumerRevision = @{
                id = "$($app.ResourceId)/revisions/sample--new"
                name = 'sample--new'
                properties = @{
                    active = $true
                    provisioningState = 'Provisioned'
                    healthState = 'Healthy'
                    runningState = 'Running'
                    replicas = 2
                    template = @{ containers = @(@{ image = $sample.image }) }
                }
            }
            $script:consumerRestStatus = 200
            $script:consumerRestMalformed = $false
            Mock Get-AzResource { $script:consumerResources }
            Mock Invoke-AzRestMethod {
                [pscustomobject]@{
                    StatusCode = $script:consumerRestStatus
                    Content = if ($script:consumerRestMalformed) { 'not JSON' } else {
                        $script:consumerRevision | ConvertTo-Json -Depth 10
                    }
                }
            }
        }

        It 'Checks actual consumer metadata for <scenario>' -ForEach @(
            @{ scenario = 'verified ready consumer'; accepted = $true }
            @{ scenario = 'case-insensitive resource identity'; accepted = $true }
            @{ scenario = 'missing consumer'; accepted = $false }
            @{ scenario = 'extra consumer'; accepted = $false }
            @{ scenario = 'foreign resource group'; accepted = $false }
            @{ scenario = 'different digest'; accepted = $false }
            @{ scenario = 'mutable tag'; accepted = $false }
            @{ scenario = 'missing container'; accepted = $false }
            @{ scenario = 'extra container'; accepted = $false }
            @{ scenario = 'failed provisioning'; accepted = $false }
            @{ scenario = 'missing ready revision'; accepted = $false }
            @{ scenario = 'stale ready revision'; accepted = $false }
            @{ scenario = 'multiple revision mode'; accepted = $false }
            @{ scenario = 'different registry'; accepted = $false }
            @{ scenario = 'different pull identity'; accepted = $false }
            @{ scenario = 'password fallback'; accepted = $false }
            @{ scenario = 'missing group output'; accepted = $false }
            @{ scenario = 'missing pull identity output'; accepted = $false }
            @{ scenario = 'unverified sample'; accepted = $false }
            @{ scenario = 'revision scaling with running pods'; accepted = $true }
            @{ scenario = 'revision unavailable'; accepted = $false }
            @{ scenario = 'revision malformed response'; accepted = $false }
            @{ scenario = 'revision wrong resource'; accepted = $false }
            @{ scenario = 'revision wrong name'; accepted = $false }
            @{ scenario = 'revision inactive'; accepted = $false }
            @{ scenario = 'revision provisioning'; accepted = $false }
            @{ scenario = 'revision unhealthy'; accepted = $false }
            @{ scenario = 'revision stopped'; accepted = $false }
            @{ scenario = 'revision degraded'; accepted = $false }
            @{ scenario = 'revision zero pods'; accepted = $false }
            @{ scenario = 'revision different digest'; accepted = $false }
            @{ scenario = 'revision missing container'; accepted = $false }
            @{ scenario = 'revision extra container'; accepted = $false }
            @{ scenario = 'revision scaling without pods'; accepted = $false }
        ) {
            switch ($scenario) {
                'case-insensitive resource identity' { $app.Properties.configuration.registries[0].identity = '/FIXTURE/PULL-IDENTITY' }
                'missing consumer' { $script:consumerResources = @() }
                'extra consumer' { $script:consumerResources = @($app, $app) }
                'foreign resource group' { $app.ResourceGroupName = 'foreign' }
                'different digest' { $app.Properties.template.containers[0].image = 'registry.invalid/aca-lza/sample@sha256:' + ('b' * 64) }
                'mutable tag' { $app.Properties.template.containers[0].image = 'registry.invalid/aca-lza/sample:latest' }
                'missing container' { $app.Properties.template.containers = @() }
                'extra container' { $app.Properties.template.containers += @{ image = $sample.image } }
                'failed provisioning' { $app.Properties.provisioningState = 'Failed' }
                'missing ready revision' { $app.Properties.latestReadyRevisionName = $null }
                'stale ready revision' { $app.Properties.latestReadyRevisionName = 'sample--old' }
                'multiple revision mode' { $app.Properties.configuration.activeRevisionsMode = 'Multiple' }
                'different registry' { $app.Properties.configuration.registries[0].server = 'foreign.invalid' }
                'different pull identity' { $app.Properties.configuration.registries[0].identity = '/fixture/foreign-identity' }
                'password fallback' { $app.Properties.configuration.registries[0].passwordSecretRef = 'password' }
                'missing group output' { $outputs.testDeploymentOutputs.value.resourceGroupName.value = $null }
                'missing pull identity output' {
                    $outputs.testDeploymentOutputs.value.containerRegistryUserAssignedIdentityResourceId.value = $null
                    $app.Properties.configuration.registries[0].identity = $null
                }
                'unverified sample' { $sample.strictVerification = $false }
                'revision scaling with running pods' { $script:consumerRevision.properties.runningState = 'Processing' }
                'revision unavailable' { $script:consumerRestStatus = 404 }
                'revision malformed response' { $script:consumerRestMalformed = $true }
                'revision wrong resource' { $script:consumerRevision.id = '/fixture/foreign-revision' }
                'revision wrong name' { $script:consumerRevision.name = 'sample--old' }
                'revision inactive' { $script:consumerRevision.properties.active = $false }
                'revision provisioning' { $script:consumerRevision.properties.provisioningState = 'Provisioning' }
                'revision unhealthy' { $script:consumerRevision.properties.healthState = 'Unhealthy' }
                'revision stopped' { $script:consumerRevision.properties.runningState = 'Stopped' }
                'revision degraded' { $script:consumerRevision.properties.runningState = 'Degraded' }
                'revision zero pods' { $script:consumerRevision.properties.replicas = 0 }
                'revision different digest' {
                    $script:consumerRevision.properties.template.containers[0].image = 'registry.invalid/aca-lza/sample@sha256:' + ('b' * 64)
                }
                'revision missing container' { $script:consumerRevision.properties.template.containers = @() }
                'revision extra container' { $script:consumerRevision.properties.template.containers += @{ image = $sample.image } }
                'revision scaling without pods' {
                    $script:consumerRevision.properties.runningState = 'Processing'
                    $script:consumerRevision.properties.replicas = 0
                }
            }
            if ($accepted) {
                { . $consumerAssertion } | Should -Not -Throw
            } else {
                { . $consumerAssertion } | Should -Throw
            }
            if ($scenario -in @('missing group output', 'missing pull identity output', 'unverified sample')) {
                Should -Invoke Get-AzResource -Times 0 -Exactly
            } else {
                Should -Invoke Get-AzResource -Times 1 -Exactly -ParameterFilter {
                    $ResourceGroupName -eq 'case-owned' -and $ResourceType -eq 'Microsoft.App/containerApps' -and $ExpandProperties
                }
            }
            if ($scenario -in @('verified ready consumer', 'case-insensitive resource identity') -or $scenario.StartsWith('revision ')) {
                Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly -ParameterFilter {
                    $Method -eq 'GET' -and
                    $Path -eq '/subscriptions/fixture/resourceGroups/case-owned/providers/Microsoft.App/containerApps/sample/revisions/sample--new?api-version=2024-03-01'
                }
            } else {
                Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
            }
        }
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
