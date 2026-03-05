metadata name = 'Front Door secondary region with Linux.'
metadata description = 'This instance deploys a secondary regional stamp behind Front Door with a Linux web app to validate multi-region topology.'

targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for diagnostics settings.')
@maxLength(90)
param diagnosticsResourceGroupName string = 'diag-appservicelza-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'appfdsec'

@description('Optional. Test name prefix.')
param namePrefix string = '#_namePrefix_#'

// Hardcoded to 'australiaeast' because App Service PV3 plans are not available in all regions
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
      workloadName: take('${namePrefix}${serviceShort}', 10)
      logAnalyticsWorkspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
      tags: {
        environment: 'test'
        scenario: 'front-door-secondary-linux'
      }

      spokeNetworkConfig: {
        ingressOption: 'frontDoor'
      }

      servicePlanConfig: {
        kind: 'linux'
      }
      appServiceConfig: {
        kind: 'app,linux'
      }

      location: enforcedLocation
    }
  }
]

output testDeploymentOutputs object = testDeployment[0].outputs
