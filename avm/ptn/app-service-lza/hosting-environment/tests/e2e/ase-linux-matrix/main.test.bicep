metadata name = 'ASE v3 with Linux workloads.'
metadata description = 'This instance deploys ASE v3 with both a Linux web app and a Linux container workload to validate the ASE + Linux matrix.'

targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for diagnostics settings.')
@maxLength(90)
param diagnosticsResourceGroupName string = 'diag-appservicelza-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'appaselnx'

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

// ============== //
// Test Execution //
// ============== //

// --- ASE v3 + Linux web app ---
@batchSize(1)
module testDeploymentLinuxWebApp '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-lweb-${iteration}'
    params: {
      workloadName: take('${namePrefix}aselw', 10)
      logAnalyticsWorkspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
      tags: {
        environment: 'test'
        scenario: 'ase-linux-webapp'
      }

      deployAseV3: true
      servicePlanConfig: {
        kind: 'linux'
        sku: 'I1v2'
      }
      appServiceConfig: {
        kind: 'app,linux'
      }
      spokeNetworkConfig: {
        ingressOption: 'none'
        appSvcSubnetAddressSpace: '10.240.0.0/24'
      }

      jumpboxConfig: {
        enabled: false
        adminPassword: password
      }
      location: enforcedLocation
    }
  }
]

// --- ASE v3 + Linux container ---
@batchSize(1)
module testDeploymentLinuxContainer '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-lctr-${iteration}'
    params: {
      workloadName: take('${namePrefix}aselc', 10)
      logAnalyticsWorkspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
      tags: {
        environment: 'test'
        scenario: 'ase-linux-container'
      }

      deployAseV3: true
      servicePlanConfig: {
        kind: 'linux'
        sku: 'I1v2'
      }
      appServiceConfig: {
        kind: 'app,linux,container'
        container: {
          imageName: 'mcr.microsoft.com/appsvc/staticsite:latest'
        }
      }
      spokeNetworkConfig: {
        ingressOption: 'none'
        appSvcSubnetAddressSpace: '10.240.0.0/24'
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
