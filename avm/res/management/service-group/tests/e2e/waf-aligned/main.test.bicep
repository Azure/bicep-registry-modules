targetScope = 'tenant'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'msgwaf'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    name: '${uniqueString(deployment().name, deployment().location)}-test-${serviceShort}-${iteration}'
    params: {
      name: 'sg-${namePrefix}-${serviceShort}-${uniqueString(tenant().tenantId)}-001'
      displayName: 'Service Group E2E Test WAF Aligned'
    }
  }
]
