metadata name = 'Multi-region with Azure Front Door.'
metadata description = 'This instance deploys two regional stamps behind Front Door to validate the multi-region topology with Linux and Windows workloads.'

targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for diagnostics settings.')
@maxLength(90)
param diagnosticsResourceGroupName string = 'diag-appservicelza-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'appmrfd'

@description('Optional. Test name prefix.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. The password to leverage for the login.')
@secure()
param password string = newGuid()

// Hardcoded regions where App Service Premium plans are available
#disable-next-line no-hardcoded-location
var primaryLocation = 'australiaeast'
#disable-next-line no-hardcoded-location
var secondaryLocation = 'australiasoutheast'

// Diagnostics
// ===========
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: diagnosticsResourceGroupName
  location: primaryLocation
}

module diagnosticDependencies '../../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, primaryLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}diasa${serviceShort}03'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}01'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}01'
    location: primaryLocation
  }
}

// ============== //
// Test Execution //
// ============== //

// --- Primary region: Windows web app behind Front Door ---
@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    name: '${uniqueString(deployment().name, primaryLocation)}-test-${serviceShort}-pri-${iteration}'
    params: {
      workloadName: take('${namePrefix}${serviceShort}p', 10)
      logAnalyticsWorkspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
      tags: {
        environment: 'test'
        scenario: 'multi-region-front-door-primary'
      }

      // Front Door ingress
      spokeNetworkConfig: {
        ingressOption: 'frontDoor'
      }

      // Windows web app
      servicePlanConfig: {
        kind: 'windows'
      }
      appServiceConfig: {
        kind: 'app'
      }

      // No jump host for speed
      jumpboxConfig: {
        enabled: false
        adminPassword: password
      }
      location: primaryLocation
    }
  }
]

// --- Secondary region: Linux web app behind Front Door ---
@batchSize(1)
module testDeploymentSecondary '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    name: '${uniqueString(deployment().name, secondaryLocation)}-test-${serviceShort}-sec-${iteration}'
    params: {
      workloadName: take('${namePrefix}${serviceShort}s', 10)
      logAnalyticsWorkspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
      tags: {
        environment: 'test'
        scenario: 'multi-region-front-door-secondary'
      }

      // Front Door ingress
      spokeNetworkConfig: {
        ingressOption: 'frontDoor'
      }

      // Linux web app
      servicePlanConfig: {
        kind: 'linux'
      }
      appServiceConfig: {
        kind: 'app,linux'
      }

      // No jump host for speed
      jumpboxConfig: {
        enabled: false
        adminPassword: password
      }
      location: secondaryLocation
    }
  }
]

output testDeploymentOutputs object = {
  primary: testDeployment[0].outputs
  secondary: testDeploymentSecondary[0].outputs
}
