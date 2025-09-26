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

// ============ //
// Dependencies //
// ============ //

resource serviceGroupDependency 'Microsoft.Management/serviceGroups@2024-02-01-preview' = {
  name: 'sg-${namePrefix}-${serviceShort}-dep-001'
  properties: {
    displayName: 'Service Group E2E Test Maximum Dependency'
    parent: {
      resourceId: '/providers/Microsoft.Management/serviceGroups/${tenant().tenantId}'
    }
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
      name: 'sg-${namePrefix}-${serviceShort}-001'
      displayName: 'Service Group E2E Test Maximum Configuration'
      parentResourceId: serviceGroupDependency.id
      roleAssignments: [
        {
          principalId: deployer().objectId
          roleDefinitionIdOrName: 'Service Group Reader'
        }
      ]
    }
  }
]
