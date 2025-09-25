targetScope = 'tenant'

// ========== //
// Parameters //
// ========== //

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'msgwaf'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

resource serviceGroupDependency 'Microsoft.Management/serviceGroups@2024-02-01-preview' = {
  name: 'sg-${namePrefix}-${serviceShort}-dep-001'
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
      displayName: 'Service Group E2E Test WAF Aligned'
      parentResourceId: serviceGroupDependency.id
      tags: {
        environment: 'e2e'
        module: 'service-group'
        'test-scenario': 'waf-aligned'
      }
    }
  }
]
