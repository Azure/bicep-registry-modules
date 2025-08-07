targetScope = 'resourceGroup'

metadata name = 'Using only defaults'
metadata description = 'This instance deploys the module with the minimum set of required parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The location to deploy resources to.')
param resourceLocation string = resourceGroup().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'alzamamin'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      dataCollectionRuleChangeTrackingName: 'alz-ama-dcr-ct-${namePrefix}${serviceShort}'
      dataCollectionRuleMDFCSQLName: 'alz-ama-dcr-mdfc-sql-${namePrefix}${serviceShort}'
      dataCollectionRuleVMInsightsName: 'alz-ama-dcr-vm-insights-${namePrefix}${serviceShort}'
      userAssignedIdentityName: 'alz-ama-identity-${namePrefix}${serviceShort}'
      logAnalyticsWorkspaceId: 'alz-ama-law-${namePrefix}${serviceShort}'
    }
  }
]
