metadata name = 'Bring-your-own-service with Windows container.'
metadata description = 'This instance validates bring-your-own-service by pre-creating a Windows App Service Plan and deploying a Windows container workload on it.'

targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for diagnostics settings.')
@maxLength(90)
param diagnosticsResourceGroupName string = 'diag-appservicelza-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'byowctr'

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

// Pre-create a Windows App Service Plan with Hyper-V for container support
module existingWindowsPlan 'br/public:avm/res/web/serverfarm:0.7.0' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-existingWindowsPlan'
  params: {
    name: take('asp-${namePrefix}-${serviceShort}-win', 40)
    location: enforcedLocation
    skuName: 'P1V3'
    kind: 'Windows'
    reserved: false
    hyperV: true
    enableTelemetry: true
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
      workloadName: take('${namePrefix}byowc', 10)
      logAnalyticsWorkspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
      tags: {
        environment: 'test'
        scenario: 'byos-windows-container'
      }

      servicePlanConfig: {
        existingPlanId: existingWindowsPlan.outputs.resourceId
        kind: 'windows'
      }
      appServiceConfig: {
        kind: 'app,container,windows'
        container: {
          imageName: 'mcr.microsoft.com/appsvc/staticsite:latest'
        }
      }
      spokeNetworkConfig: {
        ingressOption: 'none'
      }

      location: enforcedLocation
    }
  }
]

output testDeploymentOutputs object = testDeployment[0].outputs
