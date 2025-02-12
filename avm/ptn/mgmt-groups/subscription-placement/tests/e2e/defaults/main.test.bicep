metadata name = 'Using only defaults.'
metadata description = 'This instance deploys the module with the minimum set of required parameters.'

targetScope = 'tenant'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'subplmin'

@description('Required. The root management group resource ID where the subscriptions will be placed. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'CI-RootManagementGroupResourceId\'.')
@secure()
param rootManagementGroupResourceId string = ''

@description('Required. The scope of the subscription billing. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'CI-SubscriptionBillingScope\'.')
@secure()
param subscriptionBillingScope string = ''

var rootManagementGroupId = split('/', rootManagementGroupResourceId)[4]

// =============== //
//   Dependencies  //
// =============== //

module dependencies './dependencies.bicep' = {
  name: '${uniqueString(deployment().name, namePrefix)}-dependencies-${serviceShort}'
  scope: tenant()
  params: {
    subscriptionBillingScope: subscriptionBillingScope
    rootManagementGroupResourceId: rootManagementGroupResourceId
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../main.bicep' = {
  name: '${uniqueString(deployment().name, namePrefix)}-test-${serviceShort}'
  params: {
    parSubscriptionPlacement: [
      {
        managementGroupId: dependencies.outputs.managementGroupName
        subscriptionIds: [
          dependencies.outputs.subVendingSubscriptionId
        ]
      }
    ]
  }
}

// =============== //
//      Clean Up   //
// =============== //

module cleanup '../../../main.bicep' = {
  name: '${uniqueString(deployment().name, namePrefix)}-test-${serviceShort}'
  dependsOn: [
    testDeployment
  ]
  params: {
    parSubscriptionPlacement: [
      {
        managementGroupId: rootManagementGroupId
        subscriptionIds: [
          dependencies.outputs.subVendingSubscriptionId
        ]
      }
    ]
  }
}

@description('This output retrieves the subscription placement summary from the test deployment outputs.')
output subscriptionPlacementSummary string = testDeployment.outputs.subscriptionPlacementSummary
