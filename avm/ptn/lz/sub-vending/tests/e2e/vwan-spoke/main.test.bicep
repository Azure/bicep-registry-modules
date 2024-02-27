targetScope = 'managementGroup'

@description('Optional. The location to deploy resources to.')
param location string = 'uksouth'

param prNumber string

@description('Optional. The subscription billing scope.')
param subscriptionBillingScope string

module nestedDependencies 'dependencies.bicep' = {
  name: '${uniqueString(deployment().name, location)}-nestedDependencies'
  scope: resourceGroup('e4e7395f-dc45-411e-b425-95f75e470e16', 'rsg-blzv-perm-hubs-001')
  params: {
    hubVirtualNetworkName: 'vnet-uksouth-hub-blzv'
  }
}

module createSub '../../../main.bicep' = {
  name: 'sub-blzv-tests-pr-${prNumber}-blank-sub'
  params: {
    subscriptionAliasEnabled: true
    subscriptionBillingScope: subscriptionBillingScope
    subscriptionAliasName: 'sub-blzv-tests-pr-${prNumber}'
    subscriptionDisplayName: 'sub-blzv-tests-pr-${prNumber}'
    subscriptionTags: {
      prNumber: prNumber
    }
    subscriptionWorkload: 'Production'
    subscriptionManagementGroupAssociationEnabled: true
    subscriptionManagementGroupId: 'bicep-lz-vending-automation-child'
    deploymentScriptResourceGroupName: 'rsg-${location}-ds-pr-${prNumber}'
    deploymentScriptManagedIdentityName: 'id-${location}-pr-${prNumber}'
    deploymentScriptName: 'ds-${location}-pr-${prNumber}'
    virtualNetworkEnabled: false
    roleAssignmentEnabled: true
    roleAssignments: [
      {
        principalId: '7eca0dca-6701-46f1-b7b6-8b424dab50b3'
        definition: 'Reader'
        relativeScope: ''
      }
    ]
    deploymentScriptNetworkSecurityGroupName: 'nsg-${location}-ds-pr-${prNumber}'
    deploymentScriptVirtualNetworkName: 'vnet-${location}-ds-pr-${prNumber}'
    deploymentScriptStorageAccountName: 'stglzds${location}${prNumber}'
    deploymentScriptLocation: location
    virtualNetworkLocation: location
    resourceProviders: {
      'Microsoft.HybridCompute': [ 'ArcServerPrivateLinkPreview' ]
      'Microsoft.AVS': [ 'AzureServicesVm' ]
    }
  }
}

module vwanSpoke '../../../main.bicep' = {
  name: 'sub-blzv-tests-pr-${prNumber}-add-vwan-spoke'
  params: {
    subscriptionAliasEnabled: false
    existingSubscriptionId: createSub.outputs.subscriptionId
    virtualNetworkEnabled: true
    virtualNetworkLocation: location
    virtualNetworkResourceGroupName: 'rsg-${location}-net-vwan-pr-${prNumber}'
    deploymentScriptResourceGroupName: 'rsg-${location}-ds-pr-${prNumber}'
    deploymentScriptManagedIdentityName: 'id-${location}-pr-${prNumber}'
    deploymentScriptName: 'ds-${location}-pr-${prNumber}'
    virtualNetworkName: 'vnet-${location}-vwan-pr-${prNumber}'
    virtualNetworkAddressSpace: [
      '10.200.0.0/16'
    ]
    virtualNetworkResourceGroupLockEnabled: false
    virtualNetworkPeeringEnabled: true
    hubNetworkResourceId: nestedDependencies.outputs.hubNetworkResourceId
    deploymentScriptNetworkSecurityGroupName: 'nsg-${location}-ds-pr-${prNumber}'
    deploymentScriptVirtualNetworkName: 'vnet-${location}-ds-pr-${prNumber}'
    deploymentScriptStorageAccountName: 'stglzds${location}${prNumber}'
    deploymentScriptLocation: location
  }
}
