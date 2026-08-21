metadata name = 'App ManagedEnvironments Certificates'
metadata description = 'This module deploys a App Managed Environment Certificate.'

@description('Required. The name of the file share.')
param name string

@description('Conditional. The name of the parent app managed environment. Required if the template is used in a standalone deployment.')
param managedEnvironmentName string

@description('Required. The access mode for the storage.')
param accessMode string

@description('Required. Type of storage: "SMB" or "NFS".')
param kind ('SMB' | 'NFS')

@description('Required. Storage account name.')
param storageAccountName string

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.app-managedenvironment-storage.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource managedEnvironment 'Microsoft.App/managedEnvironments@2025-10-02-preview' existing = {
  name: managedEnvironmentName
}

resource storage 'Microsoft.App/managedEnvironments/storages@2025-10-02-preview' = {
  name: name
  parent: managedEnvironment
  properties: {
    nfsAzureFile: kind == 'NFS'
      ? {
          accessMode: accessMode
          server: '${storageAccountName}.file.${environment().suffixes.storage}'
          shareName: '/${storageAccountName}/${name}'
        }
      : null
    azureFile: kind == 'SMB'
      ? {
          accessMode: accessMode
          accountName: storageAccountName
          accountKey: listkeys(resourceId('Microsoft.Storage/storageAccounts', storageAccountName), '2025-01-01').keys[0].value
          shareName: name
        }
      : null
  }
}

@description('The name of the file share.')
output name string = storage.name

@description('The resource ID of the file share.')
output resourceId string = storage.id

@description('The resource group the file share was deployed into.')
output resourceGroupName string = resourceGroup().name
