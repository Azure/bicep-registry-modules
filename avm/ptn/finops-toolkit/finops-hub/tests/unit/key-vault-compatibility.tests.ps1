param (
    [string] $RepoRootPath = (Resolve-Path (Join-Path $PSScriptRoot '..' '..' '..' '..' '..' '..')).Path
)

Describe 'FinOps Key Vault module compatibility' {
    BeforeAll {
        . (Join-Path $RepoRootPath 'utilities' 'tests' 'helper' 'Initialize-PSRuleTest.ps1')
        Initialize-PSRuleTest -RepoRootPath $RepoRootPath

        $modulePath = Join-Path $PSScriptRoot '..' '..' 'main.bicep'
        $compiledPath = Join-Path $TestDrive 'finops-hub.json'
        $diagnostics = bicep build $modulePath --no-restore --outfile $compiledPath 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $template = Get-Content -LiteralPath $compiledPath -Raw | ConvertFrom-Json -AsHashtable -Depth 100
        $resources = $template.resources -is [System.Collections.IDictionary] ? @($template.resources.Values) : @($template.resources)
        $wrappers = @($resources | Where-Object { $_.name -match '-keyVault' })
        if ($wrappers.Count -ne 1) { throw 'Expected one FinOps Key Vault wrapper.' }
        $wrapper = $wrappers[0].properties.template
        $wrapperResources = $wrapper.resources -is [System.Collections.IDictionary] ? @($wrapper.resources.Values) : @($wrapper.resources)
        $vaultCalls = @($wrapperResources | Where-Object { $_.properties.template.metadata.name -eq 'Key Vaults' })
        if ($vaultCalls.Count -ne 1) { throw 'Expected one published Key Vault module call.' }
        $vaultCall = $vaultCalls[0]
        $vaultTemplate = $vaultCall.properties.template
        $vaultResources = $vaultTemplate.resources -is [System.Collections.IDictionary] ? @($vaultTemplate.resources.Values) : @($vaultTemplate.resources)
        $secretCalls = @($vaultResources | Where-Object { $_.properties.template.metadata.name -eq 'Key Vault Secrets' })
        if ($secretCalls.Count -ne 1) { throw 'Expected one Key Vault secret module declaration.' }
        $secretCall = $secretCalls[0]
        $secretTemplate = $secretCall.properties.template
    }

    It 'Passes the original storage key and validity timestamps through the secret array' {
        $secrets = $vaultCall.properties.parameters.secrets.value
        ($secrets -is [array]) | Should -BeTrue
        $secrets.Count | Should -Be 1
        $secrets[0].name | Should -BeExactly "[parameters('storageAccountName')]"
        $secrets[0].value | Should -BeExactly "[listKeys(resourceId('Microsoft.Storage/storageAccounts', parameters('storageAccountName')), '2023-01-01').keys[0].value]"
        $secrets[0].attributes.exp | Should -Be 1702648632
        $secrets[0].attributes.nbf | Should -Be 10000
        $secrets[0].Contains('attributesExp') | Should -BeFalse
        $secrets[0].Contains('attributesNbf') | Should -BeFalse
        $storage = @($wrapperResources | Where-Object type -EQ 'Microsoft.Storage/storageAccounts')
        $storage.Count | Should -Be 1
        $storage[0].existing | Should -BeTrue
        $storage[0].name | Should -BeExactly "[parameters('storageAccountName')]"
    }

    It 'Keeps the secret value protected at both module boundaries' {
        $vaultTemplate.parameters.secrets.type | Should -BeExactly 'array'
        $secretTypeName = $vaultTemplate.parameters.secrets.items.'$ref'.Split('/')[-1]
        $vaultTemplate.definitions[$secretTypeName].properties.value.type | Should -Be 'securestring'
        $secretTemplate.parameters.value.type | Should -Be 'securestring'
        $secretTemplate.parameters.value.Contains('defaultValue') | Should -BeFalse
        @($wrapper.outputs.Keys | Sort-Object) | Should -Be @('name', 'resourceId', 'uri')
    }

    It 'Expands the real storage-key expression into a vault secret without parameter defaults' {
        $wrapperPath = Join-Path $TestDrive 'key-vault-wrapper.json'
        $parameterPath = Join-Path $TestDrive 'key-vault-wrapper.parameters.json'
        $wrapper | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath $wrapperPath
        @{
            '$schema' = 'https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#'
            contentVersion = '1.0.0.0'
            parameters = @{
                hubName = @{ value = 'finops-expansion-test' }
                uniqueSuffix = @{ value = 'unit' }
                storageAccountName = @{ value = 'finopsexpansiontest' }
            }
        } | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $parameterPath

        $expanded = @(Export-AzRuleTemplateData -TemplateFile $wrapperPath -ParameterFile $parameterPath -PassThru -ErrorAction Stop)
        $expandedVaults = @($expanded | Where-Object type -EQ 'Microsoft.KeyVault/vaults')
        $expandedVaults | Should -HaveCount 1
        $expandedSecrets = @($expandedVaults[0].resources | Where-Object type -EQ 'Microsoft.KeyVault/vaults/secrets')
        $expandedSecrets | Should -HaveCount 1
        $expandedSecrets[0].name | Should -BeExactly "$($expandedVaults[0].name)/finopsexpansiontest"
        $expandedSecrets[0].properties.value | Should -BeExactly '{{Secret}}'
        $expandedSecrets[0].properties.attributes.exp | Should -Be 1702648632
        $expandedSecrets[0].properties.attributes.nbf | Should -Be 10000
    }

    It 'Still rejects a genuinely missing required secret value during expansion' {
        $secretPath = Join-Path $TestDrive 'missing-secret-value.json'
        $parameterPath = Join-Path $TestDrive 'missing-secret-value.parameters.json'
        $secretTemplate | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath $secretPath
        @{
            '$schema' = 'https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#'
            contentVersion = '1.0.0.0'
            parameters = @{
                name = @{ value = 'storage-key' }
                keyVaultName = @{ value = 'finops-expansion-test' }
            }
        } | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $parameterPath

        { Export-AzRuleTemplateData -TemplateFile $secretPath -ParameterFile $parameterPath -PassThru -ErrorAction Stop } |
            Should -Throw "*parameter named 'value' was not set*"
    }

    It 'Forwards nested secret attributes without changing enabled or content defaults' {
        $secretExpression = "coalesce(parameters('secrets'), createArray())[copyIndex()]"
        $secretCall.properties.parameters.attributesExp.value | Should -BeExactly "[tryGet(tryGet($secretExpression, 'attributes'), 'exp')]"
        $secretCall.properties.parameters.attributesNbf.value | Should -BeExactly "[tryGet(tryGet($secretExpression, 'attributes'), 'nbf')]"
        $secretCall.properties.parameters.attributesEnabled.value | Should -BeExactly "[tryGet(tryGet($secretExpression, 'attributes'), 'enabled')]"
        $secretTemplate.parameters.attributesEnabled.defaultValue | Should -BeTrue
        $secretTemplate.parameters.contentType.nullable | Should -BeTrue
        $secretTemplate.parameters.contentType.type | Should -Be 'securestring'
    }

    It 'Preserves access-policy authorization and vault protection settings' {
        $parameters = $vaultCall.properties.parameters
        $parameters.enableRbacAuthorization.value | Should -BeFalse
        $parameters.accessPolicies.value | Should -BeExactly "[variables('formattedAccessPolicies')]"
        $parameters.Contains('roleAssignments') | Should -BeFalse
        $parameters.enablePurgeProtection.value | Should -BeFalse
        $parameters.enableSoftDelete.value | Should -BeTrue
        $parameters.softDeleteRetentionInDays.value | Should -Be 90
        $parameters.enableVaultForDeployment.value | Should -BeTrue
        $parameters.enableVaultForTemplateDeployment.value | Should -BeTrue
        $parameters.enableVaultForDiskEncryption.value | Should -BeTrue
        $parameters.createMode.value | Should -BeExactly 'default'
    }

    It 'Preserves vault naming, resource tags and regional SKU selection' {
        $parameters = $vaultCall.properties.parameters
        $parameters.name.value | Should -BeExactly "[variables('keyVaultName')]"
        $wrapper.variables.keyVaultPrefix | Should -BeExactly "[format('{0}-vault', replace(parameters('hubName'), '_', '-'))]"
        $wrapper.variables.keyVaultSuffix | Should -BeExactly "[format('-{0}', parameters('uniqueSuffix'))]"
        $parameters.tags.value | Should -BeExactly "[union(coalesce(parameters('tags'), createObject()), coalesce(tryGet(parameters('tagsByResource'), 'Microsoft.KeyVault/vaults'), createObject()))]"
        $parameters.sku | Should -BeExactly "[if(startsWith(parameters('location'), 'china'), createObject('value', 'standard'), createObject('value', parameters('sku')))]"
    }

    It 'Uses the 2026 API for the deployed vault and secret' {
        $vault = @($vaultResources | Where-Object type -EQ 'Microsoft.KeyVault/vaults')
        $vault.Count | Should -Be 1
        $vault[0].apiVersion | Should -BeExactly '2026-02-01'
        $secretResources = $secretTemplate.resources -is [System.Collections.IDictionary] ? @($secretTemplate.resources.Values) : @($secretTemplate.resources)
        $secret = @($secretResources | Where-Object type -EQ 'Microsoft.KeyVault/vaults/secrets')
        $secret.Count | Should -Be 1
        $secret[0].apiVersion | Should -BeExactly '2026-02-01'
        $secret[0].properties.value | Should -BeExactly "[parameters('value')]"
    }

    It 'Documents hubName as required without adding a default or changing public outputs' {
        $template.parameters.hubName.type | Should -BeExactly 'string'
        $template.parameters.hubName.Contains('defaultValue') | Should -BeFalse
        $template.parameters.hubName.nullable | Should -Not -BeTrue
        $template.parameters.hubName.metadata.description | Should -BeExactly 'Required. Name of the hub. Used to ensure unique resource names.'
        @($template.outputs.Keys | Sort-Object) | Should -Be @(
            'dataFactoryName'
            'location'
            'name'
            'resourceGroupName'
            'storageAccountId'
            'storageAccountName'
            'storageUrlForPowerBi'
        )
    }
}
