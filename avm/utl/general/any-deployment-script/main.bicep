metadata name = 'Any example deployment script utility'
metadata description = 'This module provides you with whatever deployment script experience.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the deployment script.')
param storageDeploymentScriptName string

@description('Optional. The location to deploy into.')
param location string = resourceGroup().location

@description('Required. The resource Id of the managed identity to use for the deployment script.')
param managedIdentityResourceId string

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

// ================ //
// Definitions      //
// ================ //
//
