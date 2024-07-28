metadata name = 'Any example deployment script utility'
metadata description = 'This module provides you with whatever deployment script experience.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the deployment script.')
param storageDeploymentScriptName string

@description('Optional. The location to deploy into.')
param location string = resourceGroup().location

@description('Required. The resource Id of the managed identity to use for the deployment script.')
param managedIdentityResourceId string

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.utl.general.any-deployment-script.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

resource assetsStorageAccount_upload 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: storageDeploymentScriptName
  location: location
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentityResourceId}': {}
    }
  }
  properties: {
    azPowerShellVersion: '9.7'
    retentionInterval: 'P1D'
    scriptContent: loadTextContent('source/dummy.ps1')
    timeout: 'PT30M'
    cleanupPreference: 'Always'
  }
}

@description('The name of the analysis service.')
output name string = assetsStorageAccount_upload.name

@description('The resource ID of the analysis service.')
output resourceId string = assetsStorageAccount_upload.id

@description('The resource group the analysis service was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = assetsStorageAccount_upload.location
