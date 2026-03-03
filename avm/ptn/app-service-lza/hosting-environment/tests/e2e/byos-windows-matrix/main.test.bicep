metadata name = 'Bring-your-own-service with Windows workloads.'
metadata description = 'This instance validates bring-your-own-service by pre-creating a Windows App Service Plan and passing it via existingAppServicePlanId, then deploying a Windows web app and a Windows container on it.'

targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for diagnostics settings.')
@maxLength(90)
param diagnosticsResourceGroupName string = 'diag-appservicelza-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'appbyowin'

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

// Pre-create a Windows App Service Plan to exercise bring-your-own-service
module existingWindowsPlan 'br/public:avm/res/web/serverfarm:0.7.0' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-existingWindowsPlan'
  params: {
    name: take('asp-${namePrefix}-${serviceShort}-win', 40)
    location: enforcedLocation
    skuName: 'P1V3'
    kind: 'Windows'
    reserved: false
    enableTelemetry: true
  }
}

// ============== //
// Test Execution //
// ============== //

// --- BYOS + Windows web app ---
@batchSize(1)
module testDeploymentWindowsWebApp '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-wweb-${iteration}'
    params: {
      workloadName: take('${namePrefix}byoww', 10)
      logAnalyticsWorkspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
      tags: {
        environment: 'test'
        scenario: 'byos-windows-webapp'
      }

      existingAppServicePlanId: existingWindowsPlan.outputs.resourceId
      webAppBaseOs: 'windows'
      webAppKind: 'app'
      networkingOption: 'none'

      deployJumpHost: false
      vmSize: 'Standard_D2s_v4'
      adminUsername: 'azureuser'
      adminPassword: password
      location: enforcedLocation
    }
  }
]

// --- BYOS + Windows container ---
@batchSize(1)
module testDeploymentWindowsContainer '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-wctr-${iteration}'
    params: {
      workloadName: take('${namePrefix}byowc', 10)
      logAnalyticsWorkspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
      tags: {
        environment: 'test'
        scenario: 'byos-windows-container'
      }

      existingAppServicePlanId: existingWindowsPlan.outputs.resourceId
      webAppBaseOs: 'windows'
      webAppKind: 'app,container,windows'
      containerImageName: 'mcr.microsoft.com/appsvc/staticsite:latest'
      networkingOption: 'none'

      deployJumpHost: false
      vmSize: 'Standard_D2s_v4'
      adminUsername: 'azureuser'
      adminPassword: password
      location: enforcedLocation
    }
  }
]

output testDeploymentOutputs object = {
  windowsWebApp: testDeploymentWindowsWebApp[0].outputs
  windowsContainer: testDeploymentWindowsContainer[0].outputs
}
