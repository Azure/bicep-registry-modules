metadata name = 'Using IPAM pool for address allocation.'
metadata description = 'This instance deploys the module with a virtual network that uses Azure Virtual Network Manager IPAM for automatic IP address allocation.'

targetScope = 'managementGroup'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = 'uksouth' // IPAM only works within a region today so restrict to 'uksouth' for testing.

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

@description('Optional. The resource ID of the existing IPAM pool to use for address allocation.')
param ipamPoolResourceId string = '/subscriptions/9948cae8-8c7c-4f5f-81c1-c53317cab23d/resourceGroups/rsg-blzv-perm-hubs-001/providers/Microsoft.Network/networkManagers/vnm-uksouth-blzv-001/ipamPools/ipam-pool-blzv-001'

var enableDeployment = !empty(subscriptionBillingScope)

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
      ipamPoolResourceId
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
              id: ipamPoolResourceId
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
              id: ipamPoolResourceId
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
output ipamPoolResourceId string = ipamPoolResourceId
