metadata name = 'Multiple virtual networks.'
metadata description = 'This instance deploys a subscription with a multiple virtual networks.'

targetScope = 'managementGroup'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

// This parameter needs to be updated with the billing account and the enrollment account of your environment.
@description('Required. The scope of the subscription billing. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'CI-SubscriptionBillingScope\'.')
@secure()
param subscriptionBillingScope string = ''

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ssvnet'

@description('Optional. A short guid for the subscription name.')
param subscriptionGuid string = toLower(substring(newGuid(), 0, 4))

@description('Optional. The subscription id of the existing hub virtual network.')
param vnetHubSubId string = '9948cae8-8c7c-4f5f-81c1-c53317cab23d'

@description('Optional. The resource group of the existing hub virtual network.')
param vnetHubResourceGroup string = 'rsg-blzv-perm-hubs-001'

@description('Optional. The name of the existing hub virtual network.')
param hubVirtualNetworkName string = 'vnet-uksouth-hub-blzv'

@description('Required. Principle ID of the user. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'CI-testUserObjectId\'.')
@secure()
param testUserObjectId string = ''

// Provide a reference to an existing hub virtual network.
module nestedDependencies 'dependencies.bicep' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  scope: resourceGroup(vnetHubSubId, vnetHubResourceGroup)
  params: {
    hubVirtualNetworkName: hubVirtualNetworkName
  }
}
module testDeployment '../../../main.bicep' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${subscriptionGuid}'
  params: {
    subscriptionAliasEnabled: true
    subscriptionBillingScope: subscriptionBillingScope
    subscriptionAliasName: 'dep-sub-blzv-tests-${namePrefix}-${serviceShort}-${subscriptionGuid}'
    subscriptionDisplayName: 'dep-sub-blzv-tests-${namePrefix}-${serviceShort}-${subscriptionGuid}'
    subscriptionWorkload: 'Production'
    subscriptionTags: {
      namePrefix: namePrefix
      serviceShort: serviceShort
    }
    subscriptionManagementGroupAssociationEnabled: true
    subscriptionManagementGroupId: 'bicep-lz-vending-automation-child'
    virtualNetworkEnabled: true
    virtualNetworkName: 'vnet-${resourceLocation}-hs-${namePrefix}-${serviceShort}'
    virtualNetworkLocation: resourceLocation
    virtualNetworkResourceGroupName: 'rsg-${resourceLocation}-net-hs-${namePrefix}-${serviceShort}'
    virtualNetworkAddressSpace: [
      '10.110.0.0/16'
    ]
    virtualNetworkSubnets: [
      {
        name: 'Subnet1'
        addressPrefix: '10.110.1.0/24'
      }
    ]
    virtualNetworkResourceGroupLockEnabled: false
    virtualNetworkPeeringEnabled: true
    virtualNetworkUseRemoteGateways: false
    hubNetworkResourceId: nestedDependencies.outputs.hubNetworkResourceId
    additionalVirtualNetworks: [
      {
        name: 'vnet-${resourceLocation}-hs-${namePrefix}-${serviceShort}-2'
        location: resourceLocation
        addressPrefixes: ['10.120.0.0/16']
        resourceGroupName: 'rsg-${resourceLocation}-net-hs-${namePrefix}-${serviceShort}-2'
        subnets: [
          {
            name: 'Subnet1'
            addressPrefix: '10.120.1.0/24'
            networkSecurityGroup: {
              name: 'nsg-${resourceLocation}-hs-${namePrefix}-${serviceShort}-2'
              location: resourceLocation
              securityRules: [
                {
                  name: 'Allow-HTTPS'
                  properties: {
                    access: 'Allow'
                    direction: 'Inbound'
                    priority: 100
                    protocol: 'Tcp'
                    description: 'Allow HTTPS'
                    destinationAddressPrefix: '*'
                    sourceAddressPrefix: '*'
                    sourcePortRange: '*'
                    destinationPortRange: '443'
                  }
                }
              ]
            }
          }
        ]
      }
      {
        name: 'vnet-${resourceLocation}-hs-${namePrefix}-${serviceShort}-3'
        location: resourceLocation
        addressPrefixes: ['10.90.0.0/16']
        peerToHubNetwork: true
      }
    ]
    resourceProviders: {}
  }
}

output createdSubId string = testDeployment.outputs.subscriptionId
output hubNetworkResourceId string = nestedDependencies.outputs.hubNetworkResourceId
output namePrefix string = namePrefix
output serviceShort string = serviceShort
output resourceLocation string = resourceLocation
