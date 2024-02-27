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
    deploymentScriptLocation: location
    virtualNetworkLocation: location
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
    deploymentScriptNetworkSecurityGroupName: 'nsg-${location}-ds-pr-${prNumber}'
    deploymentScriptVirtualNetworkName: 'vnet-${location}-ds-pr-${prNumber}'
    deploymentScriptStorageAccountName: 'stglzds${location}${prNumber}'
    roleAssignmentEnabled: true
    roleAssignments: [
      {
        principalId: '7eca0dca-6701-46f1-b7b6-8b424dab50b3'
        definition: 'Reader'
        relativeScope: ''
      }
    ]
    resourceProviders: {
      'Microsoft.HybridCompute': [ 'ArcServerPrivateLinkPreview' ]
      'Microsoft.AVS': [ 'AzureServicesVm' ]
    }
  }
}

module hubSpoke '../../../main.bicep' = {
  name: 'sub-blzv-tests-pr-${prNumber}-add-vnet-spoke'
  params: {
    deploymentScriptLocation: location
    subscriptionAliasEnabled: false
    existingSubscriptionId: createSub.outputs.subscriptionId
    virtualNetworkEnabled: true
    virtualNetworkLocation: location
    virtualNetworkResourceGroupName: 'rsg-${location}-net-hs-pr-${prNumber}'
    deploymentScriptResourceGroupName: 'rsg-${location}-ds-pr-${prNumber}'
    deploymentScriptManagedIdentityName: 'id-${location}-pr-${prNumber}'
    deploymentScriptName: 'ds-${location}-pr-${prNumber}'
    virtualNetworkName: 'vnet-${location}-hs-pr-${prNumber}'
    deploymentScriptNetworkSecurityGroupName: 'nsg-${location}-ds-pr-${prNumber}'
    deploymentScriptVirtualNetworkName: 'vnet-${location}-ds-pr-${prNumber}'
    deploymentScriptStorageAccountName: 'stglzds${location}${prNumber}'
    virtualNetworkAddressSpace: [
      '10.100.0.0/16'
    ]
    virtualNetworkResourceGroupLockEnabled: false
    virtualNetworkPeeringEnabled: true
    virtualNetworkUseRemoteGateways: false
    hubNetworkResourceId: nestedDependencies.outputs.hubNetworkResourceId
    roleAssignmentEnabled: true
    roleAssignments: [
      {
        principalId: '7eca0dca-6701-46f1-b7b6-8b424dab50b3'
        definition: 'Network Contributor'
        relativeScope: '/resourceGroups/rsg-${location}-net-hs-pr-${prNumber}'
      }
    ]
  }
}

output createdSubId string = createSub.outputs.subscriptionId
