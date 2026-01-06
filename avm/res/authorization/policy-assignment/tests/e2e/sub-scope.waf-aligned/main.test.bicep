targetScope = 'subscription'

metadata name = 'Using only defaults (Subscription scope)'
metadata description = 'This instance deploys the module with the minimum set of required parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'rapasubwaf'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../sub-scope/main.bicep' = {
  name: '${uniqueString(deployment().name)}-test-${serviceShort}'
  params: {
    name: '${namePrefix}${serviceShort}001'
    //Audit VMs that do not use managed disks
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d'
    metadata: {
      assignedBy: 'Bicep'
    }
    additionalSubscriptionIDsToAssignRbacTo: [
      subscription().subscriptionId
    ]
    roleDefinitionIds: [
      '/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c' // Contributor role
    ]
  }
}
