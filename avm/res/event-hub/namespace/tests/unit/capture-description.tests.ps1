Describe 'Event Hubs capture and Key Vault integration' {
    BeforeAll {
        $modulePath = (Resolve-Path (Join-Path $PSScriptRoot '..' '..')).Path
        $source = Get-Content -LiteralPath (Join-Path $modulePath 'eventhub' 'main.bicep') -Raw
        $identity = [regex]::Match($source, '(?ms)^var captureIdentity = (?<expression>.*?)\r?\n\r?\nvar enableReferencedModulesTelemetry')
        $capture = [regex]::Match($source, '(?ms)^    \.\.\.(?<expression>\(!empty\(captureDescription\).*?^      : \{\}\))(?=\r?\n  \}\r?\n\})')
        if (-not $identity.Success -or -not $capture.Success) { throw 'Production capture expressions were not found.' }

        function Get-TemplateResources {
            param ([System.Collections.IDictionary] $Template)
            if ($Template.resources -is [System.Collections.IDictionary]) { @($Template.resources.Values) }
            else { @($Template.resources) }
        }

        $compiledPath = Join-Path $TestDrive 'namespace.json'
        $diagnostics = bicep build (Join-Path $modulePath 'main.bicep') --no-restore --outfile $compiledPath 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $parent = Get-Content -LiteralPath $compiledPath -Raw | ConvertFrom-Json -AsHashtable -Depth 100

        $compiledPath = Join-Path $TestDrive 'max.json'
        $diagnostics = bicep build (Join-Path $modulePath 'tests' 'e2e' 'max' 'main.test.bicep') --no-restore --outfile $compiledPath 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $fixture = Get-Content -LiteralPath $compiledPath -Raw | ConvertFrom-Json -AsHashtable -Depth 100
    }

    It 'Evaluates the production capture expression for <caseName>' -ForEach @(
        @{ caseName = 'null'; inputValue = $null; present = $false }
        @{ caseName = 'empty'; inputValue = @{}; present = $false }
        @{ caseName = 'disabled-no-destination'; inputValue = @{ enabled = $false }; present = $true; enabled = $false }
        @{ caseName = 'enabled-no-destination'; inputValue = @{ enabled = $true }; present = $true; enabled = $true }
        @{
            caseName = 'default-enabled-system-identity'
            inputValue = @{
                encoding = 'Avro'
                destination = @{ name = 'EventHubArchive.AzureBlockBlob'; identity = @{ systemAssigned = $true }; properties = @{ blobContainer = 'capture' } }
            }
            present = $true; enabled = $true; identityType = 'SystemAssigned'
        }
        @{
            caseName = 'disabled-user-identity'
            inputValue = @{
                enabled = $false
                destination = @{
                    name = 'EventHubArchive.AzureBlockBlob'
                    identity = @{ userAssignedResourceId = '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test/providers/Microsoft.ManagedIdentity/userAssignedIdentities/capture' }
                    properties = @{ blobContainer = 'capture' }
                }
            }
            present = $true; enabled = $false; identityType = 'UserAssigned'
        }
        @{
            caseName = 'default-enabled-without-identity'
            inputValue = @{ destination = @{ name = 'EventHubArchive.AzureBlockBlob'; properties = @{ blobContainer = 'capture' } } }
            present = $true; enabled = $true
        }
    ) {
        $json = ConvertTo-Json -InputObject $inputValue -Depth 10 -Compress
        $parameterPath = Join-Path $TestDrive "$caseName.bicepparam"
        @(
            'using none'
            # Prevent literal-only narrowing of the production nullable input.
            "var captureDescription = any(json('$json'))"
            "var captureIdentity = $($identity.Groups['expression'].Value)"
            "param properties = $($capture.Groups['expression'].Value)"
        ) | Set-Content -LiteralPath $parameterPath
        $output = Join-Path $TestDrive "$caseName.json"
        $diagnostics = bicep build-params $parameterPath --outfile $output 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $properties = (Get-Content -LiteralPath $output -Raw | ConvertFrom-Json -AsHashtable -Depth 100).parameters.properties.value
        $properties.Contains('captureDescription') | Should -Be $present
        if ($present) {
            $actual = $properties.captureDescription
            $actual.enabled | Should -Be $enabled
            $actual.Contains('destination') | Should -Be ($null -ne $inputValue.destination)
            if ($inputValue.destination) {
                $actual.destination.name | Should -BeExactly $inputValue.destination.name
                $actual.destination.properties.blobContainer | Should -BeExactly $inputValue.destination.properties.blobContainer
                if ($identityType) {
                    $actual.destination.identity.type | Should -BeExactly $identityType
                    $actual.destination.identity.userAssignedIdentity | Should -Be $inputValue.destination.identity.userAssignedResourceId
                } else {
                    $actual.destination.identity | Should -BeNullOrEmpty
                }
            }
        } else {
            $properties.Count | Should -Be 0
        }
    }

    It 'Retains the migrated Key Vault CMK and secret resources beside the updated Event Hub child' {
        $resources = @(Get-TemplateResources $parent)
        $vault = @($resources | Where-Object type -EQ 'Microsoft.KeyVault/vaults')
        $key = @($resources | Where-Object type -EQ 'Microsoft.KeyVault/vaults/keys')
        $vault | Should -HaveCount 1
        $key | Should -HaveCount 1
        $vault[0].apiVersion | Should -BeExactly '2026-02-01'
        $key[0].apiVersion | Should -BeExactly '2026-02-01'
        $vault[0].existing | Should -BeTrue
        $key[0].existing | Should -BeTrue
        $exports = @($resources | Where-Object {
                $_.properties.template -and
                @(Get-TemplateResources $_.properties.template | Where-Object type -EQ 'Microsoft.KeyVault/vaults/secrets').Count -gt 0
            })
        $exports | Should -HaveCount 1
        $secrets = @(Get-TemplateResources $exports[0].properties.template | Where-Object type -EQ 'Microsoft.KeyVault/vaults/secrets')
        $secrets | Should -HaveCount 1
        $secrets[0].apiVersion | Should -BeExactly '2026-02-01'
        $eventHub = @($resources | Where-Object { $_.copy.name -eq 'eventHubNamespace_eventhubs' })
        $eventHub | Should -HaveCount 1
        $eventHub[0].properties.parameters.captureDescription.value | Should -BeExactly "[tryGet(coalesce(parameters('eventhubs'), createArray())[copyIndex()], 'captureDescription')]"
    }

    It 'Keeps four maximum-fixture hubs, explicit disabled capture and both serial deployment iterations' {
        $calls = @(Get-TemplateResources $fixture | Where-Object { $_.properties.parameters.eventhubs })
        $calls | Should -HaveCount 1
        $call = $calls[0]
        $call.copy.count | Should -BeExactly "[length(createArray('init', 'idem'))]"
        $call.copy.mode | Should -BeExactly 'serial'
        $call.copy.batchSize | Should -Be 1
        $hubs = @($call.properties.parameters.eventhubs.value)
        $hubs | Should -HaveCount 4
        $hubs[1].captureDescription.Contains('enabled') | Should -BeFalse
        $hubs[3].captureDescription.enabled | Should -BeFalse
        $hubs[3].captureDescription.destination.identity.userAssignedResourceId | Should -Not -BeNullOrEmpty
        $call.properties.parameters.networkRuleSets.value.publicNetworkAccess | Should -BeExactly 'Disabled'
        $call.properties.parameters.zoneRedundant.value | Should -BeTrue
        $call.properties.parameters.roleAssignments.value[0].roleDefinitionIdOrName | Should -BeExactly 'Reader'
        $call.properties.parameters.roleAssignments.value[2].roleDefinitionIdOrName | Should -Match '43d0d8ad-25c7-4714-9337-8ba259a9fe05'
    }
}
