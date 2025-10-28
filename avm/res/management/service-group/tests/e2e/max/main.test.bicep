targetScope = 'tenant'

metadata name = 'Maximum configuration'
metadata description = 'This instance deploys the module with the maximum set of parameters supported.'

// ========== //
// Parameters //
// ========== //

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'msgmax'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. Subscription ID of the subscription to add to the service group for the test execution. This is passed into the modules subscriptionIdsToAssociateToServiceGroup parameter. The deployment principal must have the necessary permissions to perform this action on the target subscription.')
param subscriptionId string = '#_subscriptionId_#'

// ============ //
// Dependencies //
// ============ //

resource serviceGroupDependency 'Microsoft.Management/serviceGroups@2024-02-01-preview' = {
  name: 'sg-${namePrefix}-${serviceShort}-${uniqueString(tenant().tenantId)}-dep-001'
  properties: {
    displayName: 'Service Group E2E Test Maximum Dependency'
    parent: {
      resourceId: '/providers/Microsoft.Management/serviceGroups/${tenant().tenantId}'
    }
  }
}

module serviceGroupDependency_resourceGroupMember 'br/public:avm/res/resources/resource-group:0.4.1' = {
  scope: subscription(subscriptionId)
  params: {
    name: 'rg-${namePrefix}-${serviceShort}-${uniqueString(tenant().tenantId)}-dep-001'
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    name: '${uniqueString(deployment().name, deployment().location)}-test-${serviceShort}-${iteration}'
    params: {
      name: 'sg-${namePrefix}-${serviceShort}-${uniqueString(tenant().tenantId)}-001'
      displayName: 'Service Group E2E Test Maximum Configuration'
      parentServiceGroupResourceId: serviceGroupDependency.id
      subscriptionIdsToAssociateToServiceGroup: [
        subscriptionId
      ]
      resourceGroupResourceIdsToAssociateToServiceGroup: [
        serviceGroupDependency_resourceGroupMember.outputs.resourceId
      ]
      roleAssignments: [
        {
          principalId: deployer().objectId
          roleDefinitionIdOrName: 'Service Group Reader'
        }
      ]
    }
  }
]
