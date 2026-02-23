@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Deployment Script to create to get the paired region name.')
param pairedRegionScriptName string

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

resource getPairedRegionScript 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: pairedRegionScriptName
  location: location
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {
    azPowerShellVersion: '14.0'
    retentionInterval: 'P1D'
    arguments: '-Location \\"${location}\\"'
    scriptContent: loadTextContent('../../../../../../../utilities/e2e-template-assets/scripts/Get-PairedRegion.ps1')
  }
  dependsOn: [
    roleAssignment
  ]
  tags: {
    // SFI policies would prevent key based authentication to the storage account
    SecurityControl: 'Ignore'
  }
}

@description('The name of the paired region.')
output pairedRegionName string = getPairedRegionScript.properties.outputs.pairedRegionName

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId
