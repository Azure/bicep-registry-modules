metadata name = 'Vwan topology.'
metadata description = 'This instance deploys a subscription with a vwan network topology.'

targetScope = 'managementGroup'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = 'uksouth'

@description('Optional. The subscription billing scope.')
param subscriptionBillingScope string = 'providers/Microsoft.Billing/billingAccounts/7690848/enrollmentAccounts/350580'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'sawan1'

module nestedDependencies 'dependencies.bicep' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  scope: resourceGroup('9948cae8-8c7c-4f5f-81c1-c53317cab23d', 'rsg-blzv-perm-hubs-001')
  params: {
    hubVirtualNetworkName: 'vnet-uksouth-hub-blzv'
    virtualHubName: 'vhub-uksouth-blzv'
  }
}
module testDeployment '../../../main.bicep' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}'
  params: {
    subscriptionAliasEnabled: true
    subscriptionBillingScope: subscriptionBillingScope
    subscriptionAliasName: 'dep-sub-blzv-tests-${namePrefix}-${serviceShort}'
    subscriptionDisplayName: 'dep-sub-blzv-tests-${namePrefix}-${serviceShort}'
    subscriptionTags: {
      namePrefix: namePrefix
      serviceShort: serviceShort
    }
    subscriptionWorkload: 'Production'
    subscriptionManagementGroupAssociationEnabled: true
    subscriptionManagementGroupId: 'bicep-lz-vending-automation-child'
    virtualNetworkEnabled: true
    virtualNetworkLocation: resourceLocation
    virtualNetworkResourceGroupName: 'rsg-${resourceLocation}-net-vwan-${namePrefix}-${serviceShort}'
    deploymentScriptResourceGroupName: 'rsg-${resourceLocation}-ds-${namePrefix}-${serviceShort}'
    deploymentScriptManagedIdentityName: 'id-${resourceLocation}-${namePrefix}-${serviceShort}'
    deploymentScriptName: 'ds-${namePrefix}${serviceShort}'
    virtualNetworkName: 'vnet-${resourceLocation}-vwan-${namePrefix}-${serviceShort}'
    virtualNetworkAddressSpace: [
      '10.210.0.0/16'
    ]
    virtualNetworkResourceGroupLockEnabled: false
    virtualNetworkPeeringEnabled: true
    hubNetworkResourceId: nestedDependencies.outputs.virtualHubResourceId
    roleAssignmentEnabled: true
    roleAssignments: [
      {
        principalId: '896b1162-be44-4b28-888a-d01acc1b4271'
        definition: 'Network Contributor'
        relativeScope: '/resourceGroups/rsg-${resourceLocation}-net-vwan-${namePrefix}-${serviceShort}'
      }
    ]
    deploymentScriptNetworkSecurityGroupName: 'nsg-${resourceLocation}-ds-${namePrefix}-${serviceShort}'
    deploymentScriptVirtualNetworkName: 'vnet-${resourceLocation}-ds-${namePrefix}-${serviceShort}'
    deploymentScriptStorageAccountName: 'stgds${namePrefix}${serviceShort}${substring(uniqueString(deployment().name), 0, 4)}'
    deploymentScriptLocation: resourceLocation
    resourceProviders: {}
  }
}

output createdSubId string = testDeployment.outputs.subscriptionId
output virtualHubResourceId string = nestedDependencies.outputs.virtualHubResourceId
output hubNetworkResourceId string = nestedDependencies.outputs.hubNetworkResourceId
output namePrefix string = namePrefix
output serviceShort string = serviceShort
output resourceLocation string = resourceLocation
