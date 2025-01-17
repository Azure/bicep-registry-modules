metadata name = 'Using only defaults.'
metadata description = 'This instance deploys the module with the minimum set of required parameters.'

targetScope = 'tenant'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'subplmin'

@description('Required. The management group ID where the subscriptions will be placed. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'CI-ManagementGroupId\'.')
@secure()
param managementGroupId string = ''

@description('Required. The first subscription ID to be placed. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'CI-SubscriptionId1\'.')
@secure()
param subscriptionId1 string = ''

@description('Required. The second subscription ID to be placed. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'CI-SubscriptionId2\'.')
@secure()
param subscriptionId2 string = ''

var subscriptionIds = [
  subscriptionId1
  subscriptionId2
]

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../main.bicep' = {
  name: '${uniqueString(deployment().name, namePrefix)}-test-${serviceShort}'
  params: {
    parSubscriptionPlacement: [
      {
        managementGroupId: managementGroupId
        subscriptionIds: subscriptionIds
      }
    ]
  }
}


@description('This output retrieves the subscription placement summary from the test deployment outputs.')
output subscriptionPlacementSummary string = testDeployment.outputs.subscriptionPlacementSummary
