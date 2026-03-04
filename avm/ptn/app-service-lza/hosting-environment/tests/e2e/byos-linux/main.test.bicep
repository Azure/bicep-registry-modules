metadata name = 'Bring-your-own-service with Linux workloads.'
metadata description = 'This instance validates bring-your-own-service by pre-creating a Linux App Service Plan and passing it via existingAppServicePlanId, then deploying a Linux web app and a Linux container on it.'

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

@description('Optional. The password to leverage for the login.')
@secure()
param password string = newGuid()

#disable-next-line no-hardcoded-location
var enforcedLocation = 'australiaeast'

// Diagnostics
// ===========
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: diagnosticsResourceGroupName
  location: enforcedLocation
}

module diagnosticDependencies '../../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}diasa${serviceShort}03'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}01'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}01'
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

// --- BYOS + Linux web app ---
@batchSize(1)
module testDeploymentLinuxWebApp '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-lweb-${iteration}'
    params: {
      workloadName: take('${namePrefix}byolw', 10)
      logAnalyticsWorkspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
      tags: {
        environment: 'test'
        scenario: 'byos-linux-webapp'
      }

      servicePlanConfig: {
        existingPlanId: existingLinuxPlan.outputs.resourceId
        kind: 'linux'
      }
      appServiceConfig: {
        kind: 'app,linux'
      }
      spokeNetworkConfig: {
        ingressOption: 'none'
      }

      jumpboxConfig: {
        enabled: false
        adminPassword: password
      }
      location: enforcedLocation
    }
  }
]

// --- BYOS + Linux container ---
@batchSize(1)
module testDeploymentLinuxContainer '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-lctr-${iteration}'
    params: {
      workloadName: take('${namePrefix}byolc', 10)
      logAnalyticsWorkspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
      tags: {
        environment: 'test'
        scenario: 'byos-linux-container'
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
        ingressOption: 'none'
      }

      jumpboxConfig: {
        enabled: false
        adminPassword: password
      }
      location: enforcedLocation
    }
  }
]

output testDeploymentOutputs object = {
  linuxWebApp: testDeploymentLinuxWebApp[0].outputs
  linuxContainer: testDeploymentLinuxContainer[0].outputs
}
