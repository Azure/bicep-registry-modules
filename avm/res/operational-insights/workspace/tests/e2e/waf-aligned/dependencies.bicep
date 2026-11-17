@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Storage Account to create.')
param storageAccountName string

@description('Required. The name of the Automation Account to create.')
param automationAccountName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Deployment Script that selects a supported replication region.')
param replicationRegionScriptName string

resource storageAccount 'Microsoft.Storage/storageAccounts@2026-04-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    networkAcls: {
      defaultAction: 'Deny'
      bypass: 'AzureServices'
    }
  }
}

resource automationAccount 'Microsoft.Automation/automationAccounts@2024-10-23' = {
  name: automationAccountName
  location: location
  properties: {
    sku: {
      name: 'Basic'
    }
  }
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: managedIdentityName
  location: location
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('msi-${location}-${managedIdentity.id}-Reader-RoleAssignment')
  properties: {
    principalId: managedIdentity.properties.principalId
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'acdd72a7-3385-48ef-bd42-f606fba81ae7'
    ) // Reader
    principalType: 'ServicePrincipal'
  }
}

resource getReplicationRegionScript 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: replicationRegionScriptName
  location: location
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {
    azPowerShellVersion: '11.0'
    retentionInterval: 'P1D'
    arguments: '-Location \\"${location}\\"'
    scriptContent: loadTextContent('../../shared/Get-ReplicationRegion.ps1')
  }
  tags: {
    SecurityControl: 'Ignore' // SFI policies would prevent key based authentication to the storage account
  }
  dependsOn: [
    roleAssignment
  ]
}

@description('The resource ID of the created Storage Account.')
output storageAccountResourceId string = storageAccount.id

@description('The resource ID of the created Automation Account.')
output automationAccountResourceId string = automationAccount.id

@description('The name of a supported replication region.')
output replicationRegionName string = getReplicationRegionScript.properties.outputs.replicationRegionName
