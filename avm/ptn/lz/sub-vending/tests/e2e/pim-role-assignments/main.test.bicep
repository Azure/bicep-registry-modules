metadata name = 'Using PIM Role assignments.'
metadata description = 'This instance deploys the module with PIM Role assignments.'

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
param serviceShort string = 'ssapim'

@description('Optional. A short guid for the subscription name.')
param subscriptionGuid string = toLower(substring(newGuid(), 0, 4))

@description('Optional. The start time of the the PIM role assignment.')
param pimAssignmentStartDateTime string = utcNow()

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
    virtualNetworkEnabled: true
    virtualNetworkName: 'vnet-${resourceLocation}-hs-${namePrefix}-${serviceShort}'
    virtualNetworkResourceGroupName: 'rsg-${resourceLocation}-net-hs-${namePrefix}-${serviceShort}'
    virtualNetworkLocation: resourceLocation
    roleAssignmentEnabled: true
    pimRoleAssignments: [
      {
        definition: '/providers/Microsoft.Authorization/roleDefinitions/18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
        principalId: '896b1162-be44-4b28-888a-d01acc1b4271'
        relativeScope: '/resourceGroups/rsg-${resourceLocation}-net-hs-${namePrefix}-${serviceShort}'
        scheduleInfo: {
          expiration: {
            duration: 'P10D'
            type: 'AfterDuration'
          }
          startDateTime: pimAssignmentStartDateTime
        }
      }
    ]
  }
}

output createdSubId string = testDeployment.outputs.subscriptionId
output namePrefix string = namePrefix
output serviceShort string = serviceShort
output resourceLocation string = resourceLocation
