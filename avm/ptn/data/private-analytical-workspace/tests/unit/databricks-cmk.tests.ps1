param (
    [string] $RepoRootPath = (Resolve-Path (Join-Path $PSScriptRoot '..' '..' '..' '..' '..' '..')).Path
)

Describe 'Private analytical workspace Databricks CMK isolation' {
    BeforeAll {
        . (Join-Path $RepoRootPath 'utilities' 'tests' 'helper' 'Initialize-PSRuleTest.ps1')
        Initialize-PSRuleTest -RepoRootPath $RepoRootPath

        $modulePath = Join-Path $PSScriptRoot '..' '..' 'main.bicep'
        $compiledPath = Join-Path $TestDrive 'pattern.json'
        $diagnostics = bicep build $modulePath --no-restore --outfile $compiledPath 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $pattern = Get-Content -LiteralPath $compiledPath -Raw | ConvertFrom-Json -AsHashtable -Depth 100
        $databricksCall = $pattern.resources.dbw
        $databricks = $databricksCall.properties.template
        $databricksPath = Join-Path $TestDrive 'databricks.json'
        $databricks | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath $databricksPath
    }

    It 'Does not activate optional customer-managed keys for the pattern' {
        $databricksCall.condition | Should -BeExactly "[parameters('enableDatabricks')]"
        $pattern.parameters.enableDatabricks.defaultValue | Should -BeFalse
        $databricksCall.properties.parameters.Contains('customerManagedKey') | Should -BeFalse
        $databricksCall.properties.parameters.Contains('customerManagedKeyManagedDisk') | Should -BeFalse
        $databricksCall.properties.parameters.prepareEncryption.value | Should -BeTrue
    }

    It 'Isolates optional existing vault and key lookups behind conditional deployments' {
        $resources = $databricks.resources -is [System.Collections.IDictionary] ? @($databricks.resources.Values) : @($databricks.resources)
        @($resources | Where-Object { $_.type -like 'Microsoft.KeyVault/*' }) | Should -HaveCount 0
        $lookups = @($resources | Where-Object {
            $_.type -eq 'Microsoft.Resources/deployments' -and $_.properties.template.outputs -and
            $_.properties.template.outputs.Contains('vaultUri')
        })
        $lookups | Should -HaveCount 2
        foreach ($lookup in $lookups) {
            $lookup.condition | Should -Match "not\(empty\(parameters\('customerManagedKey"
            $lookup.properties.template.parameters.keyVaultResourceId.Contains('defaultValue') | Should -BeFalse
            $lookup.properties.template.parameters.keyName.Contains('defaultValue') | Should -BeFalse
            ($lookup.properties.template | ConvertTo-Json -Depth 100 -Compress) | Should -Not -Match 'dummyVault|dummyKey'
        }
        $databricks.resources.workspace.dependsOn | Should -Not -Contain 'cMKKeyVault'
        $databricks.resources.workspace.dependsOn | Should -Not -Contain 'cMKManagedDiskKeyVault'
    }

    Context '<scenario>' -ForEach @(
        @{ scenario = 'No CMK'; serviceKey = $false; diskKey = $false }
        @{ scenario = 'Service CMK only'; serviceKey = $true; diskKey = $false }
        @{ scenario = 'Disk CMK only'; serviceKey = $false; diskKey = $true }
        @{ scenario = 'Separate service and disk keys in the same vault'; serviceKey = $true; diskKey = $true }
    ) {
        It 'Expands the actual dependency without placeholder vaults or unwanted encryption lookups' {
            $parameters = @{
                name = @{ value = 'analytics-dbw' }
                enableTelemetry = @{ value = $false }
                prepareEncryption = @{ value = $true }
            }
            $vaultId = '/subscriptions/00000000-0000-4000-8000-000000000001/resourceGroups/encryption/providers/Microsoft.KeyVault/vaults/analytics-keys'
            if ($serviceKey) {
                $parameters.customerManagedKey = @{
                    value = @{ keyVaultResourceId = $vaultId; keyName = 'service-key'; keyVersion = 'service-version' }
                }
            }
            if ($diskKey) {
                $parameters.customerManagedKeyManagedDisk = @{
                    value = @{ keyVaultResourceId = $vaultId; keyName = 'disk-key'; keyVersion = 'disk-version'; autoRotationEnabled = $false }
                }
            }
            $parameterPath = Join-Path $TestDrive "databricks-$serviceKey-$diskKey.parameters.json"
            @{
                '$schema' = 'https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#'
                contentVersion = '1.0.0.0'
                parameters = $parameters
            } | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $parameterPath
            $expanded = @(Export-AzRuleTemplateData -TemplateFile $databricksPath -ParameterFile $parameterPath -PassThru -ErrorAction Stop)
            $workspaces = @($expanded | Where-Object type -EQ 'Microsoft.Databricks/workspaces')
            $workspaces | Should -HaveCount 1
            $workspaces[0].properties.parameters.prepareEncryption.value | Should -BeTrue
            $lookupDeployments = @($expanded | Where-Object {
                $_.type -eq 'Microsoft.Resources/deployments' -and $_.name -match '-cmk(?:Disk)?KeyVault$'
            })
            $lookupDeployments | Should -HaveCount ([int] $serviceKey + [int] $diskKey)
            @($expanded | Where-Object { $_.name -match 'dummyVault|dummyKey' }) | Should -HaveCount 0
            $encryption = $workspaces[0].properties.encryption
            if (-not $serviceKey -and -not $diskKey) {
                $encryption | Should -BeNullOrEmpty
            } else {
                if ($serviceKey) {
                    $encryption.entities.managedServices.keyVaultProperties.keyName | Should -BeExactly 'service-key'
                    $encryption.entities.managedServices.keyVaultProperties.keyVersion | Should -BeExactly 'service-version'
                } else {
                    $encryption.entities.managedServices | Should -BeNullOrEmpty
                }
                if ($diskKey) {
                    $encryption.entities.managedDisk.keyVaultProperties.keyName | Should -BeExactly 'disk-key'
                    $encryption.entities.managedDisk.keyVaultProperties.keyVersion | Should -BeExactly 'disk-version'
                    $encryption.entities.managedDisk.rotationToLatestKeyVersionEnabled | Should -BeFalse
                } else {
                    $encryption.entities.managedDisk | Should -BeNullOrEmpty
                }
            }
        }
    }

    Context 'Fixture coverage' {
        Context '<fixture>' -ForEach @(
            @{ fixture = 'defaults'; enabled = $false; existing = @() }
            @{ fixture = 'min-priv'; enabled = $false; existing = @() }
            @{ fixture = 'min-pub'; enabled = $false; existing = @() }
            @{ fixture = 'max'; enabled = $true; existing = @() }
            @{ fixture = 'waf-aligned'; enabled = $true; existing = @('logAnalyticsWorkspaceResourceId') }
            @{ fixture = 'uc01-priv'; enabled = $true; existing = @() }
            @{ fixture = 'uc01-pub'; enabled = $true; existing = @() }
            @{ fixture = 'uc02-priv'; enabled = $true; existing = @('virtualNetworkResourceId') }
            @{ fixture = 'uc02-pub'; enabled = $true; existing = @('virtualNetworkResourceId') }
            @{ fixture = 'uc03-priv'; enabled = $true; existing = @('virtualNetworkResourceId', 'logAnalyticsWorkspaceResourceId', 'keyVaultResourceId') }
            @{ fixture = 'uc03-pub'; enabled = $true; existing = @('virtualNetworkResourceId', 'logAnalyticsWorkspaceResourceId', 'keyVaultResourceId') }
        ) {
            BeforeAll {
                $fixturePath = Join-Path $PSScriptRoot '..' 'e2e' $fixture 'main.test.bicep'
                $outputPath = Join-Path $TestDrive "$fixture.json"
                $diagnostics = bicep build $fixturePath --no-restore --outfile $outputPath 2>&1
                if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
                $template = Get-Content -LiteralPath $outputPath -Raw | ConvertFrom-Json -AsHashtable -Depth 100
                $resources = $template.resources -is [System.Collections.IDictionary] ? @($template.resources.Values) : @($template.resources)
                $testCalls = @($resources | Where-Object { $_.type -eq 'Microsoft.Resources/deployments' -and $_.copy.name -eq 'testDeployment' })
                if ($testCalls.Count -ne 1) { throw "Expected one serial test declaration in $fixture." }
                $testCall = $testCalls[0]
                $patternTemplate = $testCall.properties.template
                $databricksCall = $patternTemplate.resources.dbw
            }

            It 'Uses the fixed production dependency without changing Databricks enablement or serial redeployment' {
                $actualEnabled = $testCall.properties.parameters.Contains('enableDatabricks') ?
                    $testCall.properties.parameters.enableDatabricks.value :
                    $patternTemplate.parameters.enableDatabricks.defaultValue
                $actualEnabled | Should -Be $enabled
                $testCall.copy.mode | Should -BeExactly 'serial'
                $testCall.copy.batchSize | Should -Be 1
                $databricksCall.condition | Should -BeExactly "[parameters('enableDatabricks')]"
                ($databricksCall.properties.template | ConvertTo-Json -Depth 100 -Compress) | Should -Not -Match 'dummyVault|dummyKey'
            }

            It 'Preserves each bring-your-own resource boundary and the Databricks network parameters' {
                $actualExisting = @($testCall.properties.parameters.Keys | Where-Object {
                    $_ -in @('virtualNetworkResourceId', 'logAnalyticsWorkspaceResourceId', 'keyVaultResourceId')
                })
                ($actualExisting | Sort-Object) -join ',' | Should -BeExactly (($existing | Sort-Object) -join ',')
                $parameters = $databricksCall.properties.parameters
                $parameters.customVirtualNetworkResourceId.value | Should -Match "if\(variables\('createNewVNET'\), reference\('vnet'\)\.outputs\.resourceId\.value"
                $parameters.customVirtualNetworkResourceId.value | Should -Match "parameters\('virtualNetworkResourceId'\)"
                $parameters.customVirtualNetworkResourceId.value | Should -Match '\.resourceId\]$'
                $parameters.disablePublicIp.value | Should -BeTrue
                $parameters.privateStorageAccount.value | Should -BeExactly 'Enabled'
                $parameters.privateEndpoints.value | Should -HaveCount 2
                $parameters.storageAccountPrivateEndpoints.value | Should -HaveCount 1
                $parameters.skuName.value | Should -BeExactly 'premium'
                $parameters.Contains('customerManagedKey') | Should -BeFalse
                $parameters.Contains('customerManagedKeyManagedDisk') | Should -BeFalse
            }
        }
    }
}
