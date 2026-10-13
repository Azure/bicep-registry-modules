Describe 'ACA storage secret export compatibility' {
    BeforeAll {
        $modulePath = Join-Path $PSScriptRoot '..' '..' 'modules' 'supporting-services' 'modules' 'storage.bicep'
        $compiledPath = Join-Path $TestDrive 'storage.json'
        $diagnostics = bicep build $modulePath --no-restore --outfile $compiledPath 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $template = Get-Content -LiteralPath $compiledPath -Raw | ConvertFrom-Json -AsHashtable -Depth 100
        $resources = $template.resources -is [System.Collections.IDictionary] ? @($template.resources.Values) : @($template.resources)
        $storageCalls = @($resources | Where-Object { $_.properties.template.metadata.name -eq 'Storage Accounts' })
        $secretCalls = @($resources | Where-Object { $_.properties.template.metadata.name -eq 'Key Vault Secrets' })
        if ($storageCalls.Count -ne 1 -or $secretCalls.Count -ne 1) {
            throw 'Expected one storage account module and one secret module.'
        }
        $storageCall = $storageCalls[0]
        $secretCall = $secretCalls[0]
        $storageTemplate = $storageCall.properties.template
        $secretTemplate = $secretCall.properties.template
    }

    It 'Exports the same first storage key with the unchanged listKeys API and secret name' {
        $storageCall.properties.parameters.name.value | Should -BeExactly "[parameters('storageAccountName')]"
        $storageTemplate.outputs.resourceId.value | Should -BeExactly "[resourceId('Microsoft.Storage/storageAccounts', parameters('name'))]"
        $secretCall.properties.parameters.value.value | Should -BeExactly "[listKeys(resourceId('Microsoft.Storage/storageAccounts', parameters('storageAccountName')), '2023-05-01').keys[0].value]"
        $secretCall.properties.parameters.name.value | Should -BeExactly 'ciStorageAccessKey1'
        $secretTemplate.resources.secret.name | Should -BeExactly "[format('{0}/{1}', parameters('keyVaultName'), parameters('name'))]"
    }

    It 'Uses the existing destination vault subscription, resource group and name' {
        $secretCall.subscriptionId | Should -BeExactly "[split(parameters('keyVaultResourceId'), '/')[2]]"
        $secretCall.resourceGroup | Should -BeExactly "[split(parameters('keyVaultResourceId'), '/')[4]]"
        $secretCall.properties.parameters.keyVaultName.value | Should -BeExactly "[last(split(parameters('keyVaultResourceId'), '/'))]"
        $secretTemplate.resources.keyVault.existing | Should -BeTrue
        $secretTemplate.resources.keyVault.name | Should -BeExactly "[parameters('keyVaultName')]"
    }

    It 'Waits for the unchanged storage deployment before reading its key' {
        $storageNameExpression = $storageCall.name.Substring(1, $storageCall.name.Length - 2)
        @($secretCall.dependsOn) | Should -Be @(
            "[resourceId('Microsoft.Resources/deployments', $storageNameExpression)]"
        )
        $secretCall.properties.mode | Should -BeExactly 'Incremental'
        $secretCall.properties.expressionEvaluationOptions.scope | Should -BeExactly 'inner'
    }

    It 'Configures exactly one active exporter and leaves the old exporter disabled' {
        $resources.Count | Should -Be 3
        $secretCall.Contains('condition') | Should -BeFalse
        $secretCall.Contains('copy') | Should -BeFalse
        $storageCall.properties.parameters.Contains('secretsExportConfiguration') | Should -BeFalse
        $storageTemplate.parameters.secretsExportConfiguration.nullable | Should -BeTrue
        $storageTemplate.parameters.secretsExportConfiguration.Contains('defaultValue') | Should -BeFalse
        $storageTemplate.resources.secretsExport.condition | Should -BeExactly "[not(equals(parameters('secretsExportConfiguration'), null()))]"
    }

    It 'Keeps the secret value secure and never exposes it as an output' {
        $secretTemplate.parameters.value.type | Should -BeExactly 'securestring'
        $secretTemplate.resources.secret.properties.value | Should -BeExactly "[parameters('value')]"
        @($secretCall.properties.parameters.Keys | Sort-Object) | Should -Be @(
            'enableTelemetry', 'keyVaultName', 'name', 'value'
        )
        foreach ($output in @($template.outputs.Values) + @($secretTemplate.outputs.Values)) {
            $output.value | Should -Not -Match "listKeys\(|parameters\('value'\)"
        }
        @($secretTemplate.outputs.Keys | Sort-Object) | Should -Be @(
            'name', 'resourceGroupName', 'resourceId', 'secretUri', 'secretUriWithVersion'
        )
    }

    It 'Uses the 2026 API while retaining the reviewed secret defaults' {
        $secretTemplate.resources.keyVault.apiVersion | Should -BeExactly '2026-02-01'
        $secretTemplate.resources.secret.apiVersion | Should -BeExactly '2026-02-01'
        $secretTemplate.parameters.attributesEnabled.defaultValue | Should -BeTrue
        foreach ($name in @('attributesExp', 'attributesNbf', 'contentType', 'tags')) {
            $secretTemplate.parameters[$name].nullable | Should -BeTrue
            $secretTemplate.parameters[$name].Contains('defaultValue') | Should -BeFalse
            $secretCall.properties.parameters.Contains($name) | Should -BeFalse
        }
        $secretTemplate.parameters.contentType.type | Should -BeExactly 'securestring'
        $properties = $secretTemplate.resources.secret.properties
        @($properties.Keys | Sort-Object) | Should -Be @('attributes', 'contentType', 'value')
        $properties.contentType | Should -BeExactly "[parameters('contentType')]"
        $properties.attributes.enabled | Should -BeExactly "[parameters('attributesEnabled')]"
        $properties.attributes.exp | Should -BeExactly "[parameters('attributesExp')]"
        $properties.attributes.nbf | Should -BeExactly "[parameters('attributesNbf')]"
        $secretTemplate.resources.secret.tags | Should -BeExactly "[parameters('tags')]"
    }

    It 'Does not add roles, identities or vault configuration' {
        $secretCall.properties.parameters.Contains('roleAssignments') | Should -BeFalse
        $secretTemplate.parameters.roleAssignments.nullable | Should -BeTrue
        $secretTemplate.parameters.roleAssignments.Contains('defaultValue') | Should -BeFalse
        $roleCopies = @($secretTemplate.variables.copy | Where-Object name -EQ 'formattedRoleAssignments')
        $roleCopies.Count | Should -Be 1
        $roleCopies[0].count | Should -BeExactly "[length(coalesce(parameters('roleAssignments'), createArray()))]"
        $secretTemplate.resources.secret_roleAssignments.copy.count | Should -BeExactly "[length(coalesce(variables('formattedRoleAssignments'), createArray()))]"
        @($secretTemplate.resources.Keys | Sort-Object) | Should -Be @(
            'avmTelemetry', 'keyVault', 'secret', 'secret_roleAssignments'
        )
        $secretTemplate.resources.keyVault.Contains('properties') | Should -BeFalse
        $secretTemplate.resources.secret.Contains('identity') | Should -BeFalse
    }

    It 'Forwards telemetry opt-out to the published secret module' {
        $secretCall.properties.parameters.enableTelemetry.value | Should -BeExactly "[parameters('enableTelemetry')]"
        $secretTemplate.resources.avmTelemetry.condition | Should -BeExactly "[parameters('enableTelemetry')]"
        @($secretTemplate.resources.avmTelemetry.properties.template.resources).Count | Should -Be 0
        $secretTemplate.resources.avmTelemetry.name | Should -Match "replace\('0\.1\.1', '\.', '-'\)"
    }

    It 'Preserves storage network, share, diagnostic and tag inputs' {
        $parameters = $storageCall.properties.parameters
        $parameters.kind.value | Should -BeExactly 'StorageV2'
        $parameters.skuName.value | Should -BeExactly 'Standard_ZRS'
        $parameters.publicNetworkAccess.value | Should -BeExactly 'Disabled'
        $parameters.networkAcls.value.bypass | Should -BeExactly 'AzureServices'
        $parameters.networkAcls.value.defaultAction | Should -BeExactly 'Deny'
        $parameters.fileServices.value.shares | Should -BeExactly "[variables('shares')]"
        $parameters.privateEndpoints.value.Count | Should -Be 1
        $parameters.privateEndpoints.value[0].service | Should -BeExactly 'file'
        $parameters.privateEndpoints.value[0].subnetResourceId | Should -BeExactly "[parameters('spokePrivateEndpointSubnetResourceId')]"
        $parameters.diagnosticSettings.value[0].workspaceResourceId | Should -BeExactly "[parameters('diagnosticWorkspaceId')]"
        $parameters.tags.value | Should -BeExactly "[parameters('tags')]"
        $parameters.Contains('customerManagedKey') | Should -BeFalse
        $parameters.Contains('managedIdentities') | Should -BeFalse
        $parameters.Contains('roleAssignments') | Should -BeFalse
    }

    It 'Preserves the helper public inputs and outputs without exposing export internals' {
        @($template.parameters.Keys | Sort-Object) | Should -Be @(
            'diagnosticSettingsName', 'diagnosticWorkspaceId', 'enableTelemetry', 'hubVNetResourceId',
            'keyVaultResourceId', 'location', 'spokePrivateEndpointSubnetResourceId', 'spokeVNetResourceId',
            'storageAccountName', 'storagePrivateEndpointName', 'storageShares', 'tags'
        )
        @($template.outputs.Keys | Sort-Object) | Should -Be @(
            'containerAppsEnvironmentStorage', 'storageAccountName', 'storageAccountResourceId'
        )
        $template.outputs.containerAppsEnvironmentStorage.value | Should -BeExactly "[variables('storageShare')]"
        $template.variables.storageShare | Should -BeExactly 'smbfileshare'
    }
}
