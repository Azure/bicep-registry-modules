metadata name = 'Bring-your-own-service with Linux container and Application Gateway.'
metadata description = 'This instance validates bring-your-own-service by pre-creating a Linux App Service Plan and deploying a Linux container workload behind Application Gateway.'

targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for diagnostics settings.')
@maxLength(90)
param diagnosticsResourceGroupName string = 'diag-appservicelza-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'appbyolnx'

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

// Pre-create a Linux App Service Plan to exercise bring-your-own-service
module existingLinuxPlan 'br/public:avm/res/web/serverfarm:0.7.0' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-existingLinuxPlan'
  params: {
    name: take('asp-${namePrefix}-${serviceShort}-lnx', 40)
    location: enforcedLocation
    skuName: 'P1V3'
    kind: 'Linux'
    reserved: true
    enableTelemetry: true
  }
}

// ============== //
// Test Execution //
// ============== //

// --- BYOS + Linux container + Application Gateway ---
@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-${iteration}'
    params: {
      workloadName: take('${namePrefix}byolw', 10)
      logAnalyticsWorkspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
      tags: {
        environment: 'test'
        scenario: 'byos-linux-container-appgw'
      }

      servicePlanConfig: {
        existingPlanId: existingLinuxPlan.outputs.resourceId
        kind: 'linux'
      }
      appServiceConfig: {
        kind: 'app,linux,container'
        container: {
          imageName: 'mcr.microsoft.com/appsvc/staticsite:latest'
        }
      }
      spokeNetworkConfig: {
        ingressOption: 'applicationGateway'
        appGwSubnetAddressSpace: '10.240.12.0/24'
      }

      location: enforcedLocation
    }
  }
]

output testDeploymentOutputs object = testDeployment[0].outputs
