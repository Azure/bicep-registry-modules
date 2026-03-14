metadata name = 'Using standalone NSG deployment.'
metadata description = 'This instance deploys the module to test standalone NSG deployments.'

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
param serviceShort string = 'ssansg'

@description('Optional. A short guid for the subscription name.')
param subscriptionGuid string = toLower(substring(newGuid(), 0, 4))

module testDeployment '../../../main.bicep' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${subscriptionGuid}'
  params: {
    subscriptionAliasEnabled: true
    subscriptionBillingScope: subscriptionBillingScope
    subscriptionAliasName: 'dep-sub-blzv-tests-${namePrefix}-${serviceShort}-${subscriptionGuid}'
    subscriptionDisplayName: 'dep-sub-blzv-tests-${namePrefix}-${serviceShort}-${subscriptionGuid}'
    subscriptionTags: {
      namePrefix: namePrefix
      serviceShort: serviceShort
    }
    subscriptionWorkload: 'Production'
    subscriptionManagementGroupAssociationEnabled: true
    subscriptionManagementGroupId: 'bicep-lz-vending-automation-child'
    resourceProviders: {}
    networkSecurityGroups: [
      {
        name: 'nsg-${resourceLocation}-hs-${namePrefix}-${serviceShort}-1'
        location: resourceLocation
        securityRules: [
          {
            name: 'Allow-HTTP-Inbound'
            properties: {
              priority: 100
              direction: 'Inbound'
              access: 'Allow'
              protocol: 'Tcp'
              sourcePortRange: '*'
              destinationPortRange: '80'
              sourceAddressPrefix: '*'
              destinationAddressPrefix: '*'
            }
          }
          {
            name: 'Allow-HTTPS-Inbound'
            properties: {
              priority: 110
              direction: 'Inbound'
              access: 'Allow'
              protocol: 'Tcp'
              sourcePortRange: '*'
              destinationPortRange: '443'
              sourceAddressPrefix: '*'
              destinationAddressPrefix: '*'
            }
          }
        ]
      }
    ]
    networkSecurityGroupResourceGroupName: 'rsg-${resourceLocation}-nsg-${namePrefix}-${serviceShort}'
  }
}

output createdSubId string = testDeployment.outputs.subscriptionId
output namePrefix string = namePrefix
output serviceShort string = serviceShort
output resourceLocation string = resourceLocation
