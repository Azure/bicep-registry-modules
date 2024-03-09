metadata name = 'Hub and spoke topology.'
metadata description = 'This instance deploys a subscription with a hub-spoke network topology.'

targetScope = 'managementGroup'

@description('Optional. The location to deploy resources to.')
param location string = 'uksouth'

@description('Optional. The subscription billing scope.')
param subscriptionBillingScope string

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'
//param namePrefix string = 'avmsb'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ssahs'

module nestedDependencies 'dependencies.bicep' = {
  name: '${uniqueString(deployment().name, location)}-nestedDependencies'
  scope: resourceGroup('e4e7395f-dc45-411e-b425-95f75e470e16', 'rsg-blzv-perm-hubs-001')
  params: {
    hubVirtualNetworkName: 'vnet-uksouth-hub-blzv'
  }
}

/*module createSub '../../../main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}'
  params: {
    subscriptionAliasEnabled: true
    deploymentScriptLocation: location
    virtualNetworkLocation: location
    subscriptionBillingScope: subscriptionBillingScope
    subscriptionAliasName: 'sub-blzv-tests-${namePrefix}-${serviceShort}'
    subscriptionDisplayName: 'sub-blzv-tests-${namePrefix}-${serviceShort}'
    subscriptionTags: {
      namePrefix: namePrefix
      serviceShort: serviceShort
    }
    subscriptionWorkload: 'Production'
    subscriptionManagementGroupAssociationEnabled: true
    subscriptionManagementGroupId: 'bicep-lz-vending-automation-child'
    deploymentScriptResourceGroupName: 'rsg-${location}-ds-${namePrefix}-${serviceShort}'
    deploymentScriptManagedIdentityName: 'id-${location}-${namePrefix}-${serviceShort}'
    deploymentScriptName: 'ds-${location}-${namePrefix}-${serviceShort}'
    deploymentScriptNetworkSecurityGroupName: 'nsg-${location}-ds-${namePrefix}-${serviceShort}'
    deploymentScriptVirtualNetworkName: 'vnet-${location}-ds-${namePrefix}-${serviceShort}'
    deploymentScriptStorageAccountName: 'stgds${location}${namePrefix}${serviceShort}'
    resourceProviders: {
      'Microsoft.HybridCompute': [ 'ArcServerPrivateLinkPreview' ]
      'Microsoft.AVS': [ 'AzureServicesVm' ]
    }
  }
}*/

module testDeployment '../../../main.bicep' = {
  //name: 'sub-blzv-tests-${namePrefix}-${serviceShort}-add-vnet-spoke'
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}'
  params: {
    deploymentScriptLocation: location
    subscriptionAliasEnabled: true
    subscriptionBillingScope: subscriptionBillingScope
    subscriptionAliasName: 'sub-blzv-tests-${namePrefix}-${serviceShort}'
    subscriptionDisplayName: 'sub-blzv-tests-${namePrefix}-${serviceShort}'
    subscriptionWorkload: 'Production'
    subscriptionManagementGroupAssociationEnabled: true
    subscriptionManagementGroupId: 'bicep-lz-vending-automation-child'
    //existingSubscriptionId: createSub.outputs.subscriptionId
    virtualNetworkEnabled: true
    virtualNetworkLocation: location
    virtualNetworkResourceGroupName: 'rsg-${location}-net-hs-${namePrefix}-${serviceShort}'
    deploymentScriptResourceGroupName: 'rsg-${location}-ds-${namePrefix}-${serviceShort}'
    deploymentScriptManagedIdentityName: 'id-${location}-${namePrefix}-${serviceShort}'
    deploymentScriptName: 'ds-${location}-${namePrefix}-${serviceShort}'
    virtualNetworkName: 'vnet-${location}-hs-${namePrefix}-${serviceShort}'
    deploymentScriptNetworkSecurityGroupName: 'nsg-${location}-ds-${namePrefix}-${serviceShort}'
    deploymentScriptVirtualNetworkName: 'vnet-${location}-ds-${namePrefix}-${serviceShort}'
    deploymentScriptStorageAccountName: 'stgds${location}${namePrefix}${serviceShort}'
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
        relativeScope: '/resourceGroups/rsg-${location}-net-hs-${namePrefix}-${serviceShort}'
      }
    ]
    resourceProviders: {
      'Microsoft.HybridCompute': [ 'ArcServerPrivateLinkPreview' ]
      'Microsoft.AVS': [ 'AzureServicesVm' ]
    }
  }
}

output createdSubId string = testDeployment.outputs.subscriptionId
output hubNetworkResourceId string = nestedDependencies.outputs.hubNetworkResourceId
