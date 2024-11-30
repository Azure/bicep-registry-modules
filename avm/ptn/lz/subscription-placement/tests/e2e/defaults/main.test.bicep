targetScope = 'tenant'

// ============== //
// Test Execution //
// ============== //

module testSubPlacement '../../../main.bicep' = {
  name: 'testSubPlacement'
  params: {
    parSubscriptionPlacement: [
      {
        managementGroupId: ''
        subscriptionIds: []
      }
    ]
  }
}
