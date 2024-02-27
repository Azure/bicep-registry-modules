targetScope = 'managementGroup'

@description('Optional. The location to deploy resources to.')
param location string = 'uksouth'

@description('Optional. The subscription billing scope.')
param subscriptionBillingScope string

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ssvwan'

module nestedDependencies 'dependencies.bicep' = {
  name: '${uniqueString(deployment().name, location)}-nestedDependencies'
  scope: resourceGroup('e4e7395f-dc45-411e-b425-95f75e470e16', 'rsg-blzv-perm-hubs-001')
  params: {
    hubVirtualNetworkName: 'vnet-uksouth-hub-blzv'
  }
}

module createSub '../../../main.bicep' = {
  name: 'sub-blzv-tests-${namePrefix}-${serviceShort}-blank-sub'
  params: {
    subscriptionAliasEnabled: true
    subscriptionBillingScope: subscriptionBillingScope
    subscriptionAliasName: 'sub-blzv-tests-${namePrefix}-${serviceShort}'
    subscriptionDisplayName: 'sub-blzv-tests-${namePrefix}-${serviceShort}'
    subscriptionTags: {
      namePrefix: namePrefix
    }
    subscriptionWorkload: 'Production'
    subscriptionManagementGroupAssociationEnabled: true
    subscriptionManagementGroupId: 'bicep-lz-vending-automation-child'
    deploymentScriptResourceGroupName: 'rsg-${location}-ds-${namePrefix}-${serviceShort}'
    deploymentScriptManagedIdentityName: 'id-${location}-${namePrefix}-${serviceShort}'
    deploymentScriptName: 'ds-${location}-${namePrefix}-${serviceShort}'
    virtualNetworkEnabled: false
    roleAssignmentEnabled: true
    roleAssignments: [
      {
        principalId: '7eca0dca-6701-46f1-b7b6-8b424dab50b3'
        definition: 'Reader'
        relativeScope: ''
      }
    ]
    deploymentScriptNetworkSecurityGroupName: 'nsg-${location}-ds-${namePrefix}-${serviceShort}'
    deploymentScriptVirtualNetworkName: 'vnet-${location}-ds-${namePrefix}-${serviceShort}'
    deploymentScriptStorageAccountName: 'stgds${location}${namePrefix}${serviceShort}'
    deploymentScriptLocation: location
    virtualNetworkLocation: location
    resourceProviders: {
      'Microsoft.HybridCompute': [ 'ArcServerPrivateLinkPreview' ]
      'Microsoft.AVS': [ 'AzureServicesVm' ]
    }
  }
}

module vwanSpoke '../../../main.bicep' = {
  name: 'sub-blzv-tests-${namePrefix}-${serviceShort}-add-vwan-spoke'
  params: {
    subscriptionAliasEnabled: false
    existingSubscriptionId: createSub.outputs.subscriptionId
    virtualNetworkEnabled: true
    virtualNetworkLocation: location
    virtualNetworkResourceGroupName: 'rsg-${location}-net-vwan-${namePrefix}-${serviceShort}'
    deploymentScriptResourceGroupName: 'rsg-${location}-ds-${namePrefix}-${serviceShort}'
    deploymentScriptManagedIdentityName: 'id-${location}-${namePrefix}-${serviceShort}'
    deploymentScriptName: 'ds-${location}-${namePrefix}-${serviceShort}'
    virtualNetworkName: 'vnet-${location}-vwan-${namePrefix}-${serviceShort}'
    virtualNetworkAddressSpace: [
      '10.200.0.0/16'
    ]
    virtualNetworkResourceGroupLockEnabled: false
    virtualNetworkPeeringEnabled: true
    hubNetworkResourceId: nestedDependencies.outputs.hubNetworkResourceId
    deploymentScriptNetworkSecurityGroupName: 'nsg-${location}-ds-${namePrefix}-${serviceShort}'
    deploymentScriptVirtualNetworkName: 'vnet-${location}-ds-${namePrefix}-${serviceShort}'
    deploymentScriptStorageAccountName: 'stgds${location}${namePrefix}${serviceShort}'
    deploymentScriptLocation: location
  }
}
