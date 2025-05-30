targetScope = 'resourceGroup'

metadata name = 'WAF-aligned dependencies'
metadata description = 'This sub-module creates a virtual network and subnet for use with the WAF pattern. It is used specifically in the WAF-aligned test.'

@description('The location where to deploy all resources.')
param location string = resourceGroup().location

@description('Required. The name of the managed identity to create.')
param managedIdentityName string

@description('Required. The name of the deployment script to create.')
param deploymentScriptName string

@description('Required. The name of the virtual network to create.')
param virtualNetworkName string

@description('Optional. The address prefix for the virtual network.')
param virtualNetworkAddressPrefix string = '10.0.0.0/16'

@description('Required. The name of the virtual network subnet to create.')
param subnetName string

// ================= //
// Deployment script //
// ================= //

module userAssignedManagedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.1' = {
  params: {
    name: managedIdentityName
    location: location
  }
}

module roleAssignment 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = {
  params: {
    resourceId: userAssignedManagedIdentity.outputs.resourceId
    principalId: userAssignedManagedIdentity.outputs.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: 'acdd72a7-3385-48ef-bd42-f606fba81ae7' // Reader
  }
}

module deploymentScript 'br/public:avm/res/resources/deployment-script:0.5.1' = {
  dependsOn: [
    roleAssignment
  ]
  params: {
    name: deploymentScriptName
    kind: 'AzurePowerShell'
    azPowerShellVersion: '8.0'
    managedIdentities: {
      userAssignedResourceIds: [
        userAssignedManagedIdentity.outputs.resourceId
      ]
    }
    scriptContent: loadTextContent('../../utilities/e2e-template-assets/scripts/Get-PairedRegion.ps1')
    arguments: '-Location \\"${location}\\"'
    retentionInterval: 'P1D'
  }
}

// =============== //
// Virtual network //
// =============== //

module virtualNetwork 'br/public:avm/res/network/virtual-network:0.7.0' = {
  params: {
    name: virtualNetworkName
    location: location
    addressPrefixes: [
      virtualNetworkAddressPrefix
    ]
    subnets: [
      {
        name: subnetName
        addressPrefix: cidrSubnet(virtualNetworkAddressPrefix, 16, 0)
      }
    ]
  }
}

@description('The name of the paired region.')
output pairedRegionName string = deploymentScript.outputs.outputs.pairedRegionName

@description('The resource ID of the created virtual network.')
output virtualNetworkResourceId string = virtualNetwork.outputs.resourceId

@description('The resource ID of the created virtual network subnet.')
output virtualNetworkSubnetResourceId string = virtualNetwork.outputs.subnetResourceIds[0]
