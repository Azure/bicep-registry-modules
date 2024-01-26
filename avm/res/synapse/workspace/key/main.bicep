metadata name = 'Synapse Workspaces Keys'
metadata description = 'This module deploys a Synapse Workspaces Key.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Encryption key name.')
param name string

@description('Conditional. The name of the parent Synapse Workspace. Required if the template is used in a standalone deployment.')
param workspaceName string

@description('Optional. The geo-location where the resource lives.')
param location string = resourceGroup().location

@description('Required. Used to activate the workspace after a customer managed key is provided.')
param isActiveCMK bool

@description('Required. The resource ID of a key vault to reference a customer managed key for encryption from.')
param keyVaultResourceId string

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

resource cMKKeyVault 'Microsoft.KeyVault/vaults@2023-02-01' existing = {
  name: last(split(keyVaultResourceId, '/'))
  scope: resourceGroup(split(keyVaultResourceId, '/')[2], split(keyVaultResourceId, '/')[4])

  resource cMKKey 'keys@2023-02-01' existing = {
    name: name
  }
}

resource workspace 'Microsoft.Synapse/workspaces@2021-06-01' existing = {
  name: workspaceName
}

resource key 'Microsoft.Synapse/workspaces/keys@2021-06-01' = {
  name: name
  parent: workspace
  properties: {
    isActiveCMK: isActiveCMK
    keyVaultUrl: cMKKeyVault::cMKKey.properties.keyUri
  }
}

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

@description('The name of the deployed key.')
output name string = key.name

@description('The resource ID of the deployed key.')
output resourceId string = key.id

@description('The resource group of the deployed key.')
output resourceGroupName string = resourceGroup().name
