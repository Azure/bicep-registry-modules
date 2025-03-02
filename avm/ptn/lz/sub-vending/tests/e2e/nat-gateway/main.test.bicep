metadata name = 'Hub and spoke topology with NAT gateway.'
metadata description = 'This instance deploys a subscription with a hub-spoke network topology with NAT gateway.'

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
param serviceShort string = 'ssanat'

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
    virtualNetworkLocation: resourceLocation
    virtualNetworkResourceGroupName: 'rsg-${resourceLocation}-net-hs-${namePrefix}-${serviceShort}'
    virtualNetworkName: 'vnet-${resourceLocation}-hs-${namePrefix}-${serviceShort}'
    virtualNetworkAddressSpace: [
      '10.120.0.0/16'
    ]
    virtualNetworkDeployNatGateway: true
    virtualNetworkNatGatewayConfiguration: {
      name: 'natgw-${resourceLocation}-hs-${namePrefix}-${serviceShort}'
      publicIPAddressProperties: [
        {
          name: 'pip-natgw-${resourceLocation}-${namePrefix}-${serviceShort}'
          zones: [
            1
            2
            3
          ]
        }
      ]
    }
    virtualNetworkSubnets: [
      {
        name: 'Subnet1'
        addressPrefix: '10.120.1.0/24'
        associateWithNatGateway: true
      }
    ]
    virtualNetworkResourceGroupLockEnabled: false
    roleAssignmentEnabled: true
    //Network contributor role
    roleAssignments: [
      {
        principalId: '896b1162-be44-4b28-888a-d01acc1b4271'
        definition: '/providers/Microsoft.Authorization/roleDefinitions/4d97b98b-1d4f-4787-a291-c67834d212e7'
        relativeScope: '/resourceGroups/rsg-${resourceLocation}-net-hs-${namePrefix}-${serviceShort}'
      }
    ]
    resourceProviders: {
      'Microsoft.Network': []
    }
    deploymentScriptStorageAccountName: 'stg${uniqueString(resourceLocation,namePrefix,serviceShort)}lzv'
  }
}

output createdSubId string = testDeployment.outputs.subscriptionId
output namePrefix string = namePrefix
output serviceShort string = serviceShort
output resourceLocation string = resourceLocation
