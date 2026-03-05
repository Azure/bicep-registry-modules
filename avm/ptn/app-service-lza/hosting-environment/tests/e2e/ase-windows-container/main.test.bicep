metadata name = 'ASE v3 with Windows container workload.'
metadata description = 'This instance deploys ASE v3 with a Windows container workload to validate the ASE + Windows container path.'

targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for diagnostics settings.')
@maxLength(90)
param diagnosticsResourceGroupName string = 'diag-appservicelza-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'asewctr'

@description('Optional. Test name prefix.')
param namePrefix string = '#_namePrefix_#'

#disable-next-line no-hardcoded-location
var enforcedLocation = 'australiaeast'

// Diagnostics
// ===========
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: diagnosticsResourceGroupName
  location: enforcedLocation
}

module diagnosticDependencies './dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-diagnosticDependencies'
  params: {
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    location: enforcedLocation
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-${iteration}'
    params: {
      workloadName: take('${namePrefix}asewc', 10)
      logAnalyticsWorkspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
      tags: {
        environment: 'test'
        scenario: 'ase-windows-container'
      }

      deployAseV3: true
      servicePlanConfig: {
        kind: 'windows'
        sku: 'I1v2'
      }
      appServiceConfig: {
        kind: 'app,container,windows'
        container: {
          imageName: 'mcr.microsoft.com/appsvc/staticsite:latest'
        }
      }
      spokeNetworkConfig: {
        ingressOption: 'none'
        appSvcSubnetAddressSpace: '10.240.0.0/24'
      }

      location: enforcedLocation
    }
  }
]

output testDeploymentOutputs object = testDeployment[0].outputs
