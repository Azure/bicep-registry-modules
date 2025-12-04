metadata name = 'Using IPAM pool for address allocation.'
metadata description = 'This instance deploys the module with a virtual network that uses Azure Virtual Network Manager IPAM for automatic IP address allocation.'

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
param serviceShort string = 'ssaipam'

@description('Optional. A short guid for the subscription name.')
param subscriptionGuid string = toLower(substring(newGuid(), 0, 4))

@description('Optional. Subscription ID of the subscription to create the dependencies into. Injected by CI.')
param subscriptionId string = '#_subscriptionId_#'

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-lz-ipam-${serviceShort}-rg'

var enableDeployment = !empty(subscriptionBillingScope)

// Dependencies
module resourceGroup 'br/public:avm/res/resources/resource-group:0.4.2' = {
  scope: subscription('${subscriptionId}')
  name: '${uniqueString(deployment().name, resourceLocation)}-resourceGroup'
  params: {
    name: resourceGroupName
    location: resourceLocation
  }
}
module nestedDependencies 'dependencies.bicep' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  scope: az.resourceGroup(subscriptionId, resourceGroupName)
  params: {
    location: resourceLocation
    networkManagerName: 'vnm-${resourceLocation}-${namePrefix}-${serviceShort}'
    ipamPoolName: 'ipam-pool-${namePrefix}-${serviceShort}'
    subscriptionId: subscriptionId
  }
  dependsOn: [
    resourceGroup
  ]
}

module testDeployment '../../../main.bicep' = if (enableDeployment) {
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
    virtualNetworkName: 'vnet-${resourceLocation}-ipam-${namePrefix}-${serviceShort}'
    virtualNetworkLocation: resourceLocation
    virtualNetworkResourceGroupName: 'rsg-${resourceLocation}-net-ipam-${namePrefix}-${serviceShort}'
    // Use IPAM pool resource ID instead of CIDR notation
    virtualNetworkAddressSpace: [
      nestedDependencies.outputs.ipamPoolResourceId
    ]
    // Allocate 256 IP addresses (equivalent to a /24 network)
    virtualNetworkIpamPoolNumberOfIpAddresses: '256'
    virtualNetworkSubnets: [
      {
        name: 'Subnet1'
        // Use IPAM for automatic subnet IP allocation
        ipamPoolPrefixAllocations: [
          {
            pool: {
              id: nestedDependencies.outputs.ipamPoolResourceId
            }
            numberOfIpAddresses: '64'
          }
        ]
      }
      {
        name: 'Subnet2'
        // Use IPAM for automatic subnet IP allocation
        ipamPoolPrefixAllocations: [
          {
            pool: {
              id: nestedDependencies.outputs.ipamPoolResourceId
            }
            numberOfIpAddresses: '32'
          }
        ]
      }
    ]
    virtualNetworkResourceGroupLockEnabled: false
    deploymentScriptResourceGroupName: 'rsg-${resourceLocation}-ds-${namePrefix}-${serviceShort}'
    deploymentScriptManagedIdentityName: 'id-${resourceLocation}-${namePrefix}-${serviceShort}'
    deploymentScriptName: 'ds-${namePrefix}-${serviceShort}'
    deploymentScriptNetworkSecurityGroupName: 'nsg-${resourceLocation}-ds-${namePrefix}-${serviceShort}'
    deploymentScriptVirtualNetworkName: 'vnet-${resourceLocation}-ds-${namePrefix}-${serviceShort}'
    deploymentScriptStorageAccountName: 'stgds${namePrefix}${serviceShort}${substring(uniqueString(deployment().name), 0, 4)}'
    deploymentScriptLocation: resourceLocation
    resourceProviders: {
      'Microsoft.Network': []
    }
  }
}

output createdSubId string = enableDeployment ? testDeployment.?outputs.?subscriptionId ?? '' : ''
output namePrefix string = namePrefix
output serviceShort string = serviceShort
output resourceLocation string = resourceLocation
output ipamPoolResourceId string = nestedDependencies.outputs.ipamPoolResourceId
