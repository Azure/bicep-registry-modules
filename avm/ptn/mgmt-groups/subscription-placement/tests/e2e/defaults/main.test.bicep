metadata name = 'Using only defaults.'
metadata description = 'This instance deploys the module with the minimum set of required parameters.'

targetScope = 'tenant'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'subplmin'

@description('Required. The management group ID where the subscriptions will be placed.')
@secure()
param managementGroupId string = ''

@description('Required. The first subscription ID to be placed.')
param subscriptionId1 string = ''

@description('Required. The second subscription ID to be placed.')
param subscriptionId2 string = ''

// ============== //
// Test Execution //
// ============== //

resource subscription1 'Microsoft.Subscription/aliases@2024-08-01-preview' existing = {
  name: subscriptionId1
  scope: tenant()
}

resource subscription2 'Microsoft.Subscription/aliases@2024-08-01-preview' existing = {
  name: subscriptionId2
  scope: tenant()
}

module testDeployment '../../../main.bicep' = {
  name: '${namePrefix}-test-${serviceShort}'
  params: {
    parSubscriptionPlacement: [
      {
        managementGroupId: managementGroupId
        subscriptionIds: [
          subscription1.id
          subscription2.id
        ]
      }
    ]
  }
}

@description('This output retrieves the subscription placement summary from the test deployment outputs.')
output subscriptionPlacementSummary string = testDeployment.outputs.subscriptionPlacementSummary
