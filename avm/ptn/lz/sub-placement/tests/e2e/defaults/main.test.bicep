metadata name = 'Using only defaults.'
metadata description = 'This instance deploys the module with the minimum set of required parameters.'

targetScope = 'tenant'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. A short guid for the subscription name.')
param subscriptionGuid string = ' '

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'subpl'

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../main.bicep' = {
  name: '${namePrefix}-test-${serviceShort}'
  params: {
    parSubscriptionPlacement: [
      {
        managementGroupId: namePrefix
        subscriptionIds: ['${subscriptionGuid}']
      }
    ]
  }
}

@description('This output retrieves the subscription placement summary from the test deployment outputs.')
output subscriptionPlacementSummary string = testDeployment.outputs.subscriptionPlacementSummary