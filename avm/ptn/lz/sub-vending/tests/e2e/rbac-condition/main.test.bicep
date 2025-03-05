metadata name = 'Using RBAC conditions.'
metadata description = 'This instance deploys the module with RBAC conditions for the role assignments.'

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
param serviceShort string = 'ssarb'

@description('Optional. A short guid for the subscription name.')
param subscriptionGuid string = toLower(substring(newGuid(), 0, 4))

@description('Required. Principle ID of the user. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'CI-testUserObjectId\'.')
@secure()
param testUserObjectId string = ''
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
    roleAssignmentEnabled: true
    roleAssignments: [
      {
        principalId: testUserObjectId
        definition: '/providers/Microsoft.Authorization/roleDefinitions/f58310d9-a9f6-439a-9e8d-f62e7b41a168'
        relativeScope: ''
        principalType: 'User'
        roleAssignmentCondition: {
          roleConditionType: {
            principleTypesToAssign: [
              'Group'
              'ServicePrincipal'
            ]
            rolesToAssign: [
              'b24988ac-6180-42a0-ab88-20f7382dd24c'
            ]
            templateName: 'constrainRolesAndPrincipalTypes'
          }
        }
      }
    ]
  }
}

output createdSubId string = testDeployment.outputs.subscriptionId
output namePrefix string = namePrefix
output serviceShort string = serviceShort
output resourceLocation string = resourceLocation
