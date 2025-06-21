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
        name: 'app-subnet'
        addressPrefix: '10.110.1.0/24'
        routeTableName: 'rt-${resourceLocation}-hs-${namePrefix}-${serviceShort}-1'
      }
    ]
    virtualNetworkResourceGroupLockEnabled: false
    peerAllVirtualNetworks: true
    routeTablesResourceGroupName: 'rsg-${resourceLocation}-net-rt-${namePrefix}-${serviceShort}'
    routeTables: [
      {
        name: 'rt-${resourceLocation}-hs-${namePrefix}-${serviceShort}-1'
        location: resourceLocation
        routes: [
          {
            name: 'route1'
            properties: {
              nextHopType: 'None'
              addressPrefix: '0.0.0.0/0'
            }
          }
        ]
      }
    ]
    additionalVirtualNetworks: [
      {
        name: 'vnet-${resourceLocation}-hs-${namePrefix}-${serviceShort}-1'
        location: resourceLocation
        addressPrefixes: ['10.120.0.0/16']
        resourceGroupName: 'rsg-${resourceLocation}-net-hs-${namePrefix}-${serviceShort}-1'
        subnets: [
          {
            name: 'subnet1'
            addressPrefix: '10.120.1.0/24'
            networkSecurityGroup: {
              name: 'nsg-${resourceLocation}-hs-${namePrefix}-${serviceShort}-1'
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
        resourceGroupLockEnabled: false
      }
      {
        name: 'vnet-${resourceLocation}-hs-${namePrefix}-${serviceShort}-2'
        resourceGroupName: 'rsg-${resourceLocation}-net-hs-${namePrefix}-${serviceShort}-2'
        location: resourceLocation
        addressPrefixes: ['10.90.0.0/16']
        resourceGroupLockEnabled: false
        peerToHubNetwork: false
        subnets: [
          {
            name: 'data-subnet'
            addressPrefix: '10.90.1.0/24'
            associateWithNatGateway: true
            routeTableName: 'rt-${resourceLocation}-hs-${namePrefix}-${serviceShort}-1'
          }
        ]
        deployNatGateway: true
        natGatewayConfiguration: {
          name: 'natgw-${resourceLocation}-hs-${namePrefix}-${serviceShort}-2'
        }
      }
    ]
    resourceProviders: {}
  }
}

output createdSubId string = testDeployment.outputs.subscriptionId
output namePrefix string = namePrefix
output serviceShort string = serviceShort
output resourceLocation string = resourceLocation
