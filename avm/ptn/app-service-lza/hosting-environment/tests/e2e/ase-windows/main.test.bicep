metadata name = 'ASE v3 with Windows workloads and Bastion integration.'
metadata description = 'This instance deploys ASE v3 with Windows web app and Windows container workloads, plus a Windows jump host with Bastion-enabled NSG rules to validate the managed-instance + Bastion integration path.'

targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for diagnostics settings.')
@maxLength(90)
param diagnosticsResourceGroupName string = 'diag-appservicelza-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'appasewin'

@description('Optional. Test name prefix.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. The password to leverage for the login.')
@secure()
param password string = newGuid()

#disable-next-line no-hardcoded-location
var enforcedLocation = 'australiaeast'

// A placeholder Bastion resource ID exercises the Bastion-integration code path in jumpbox NSG rules.
// The resource does not need to exist for a validation (dry-run) deployment.
var bastionPlaceholderResourceId = '/subscriptions/${subscription().subscriptionId}/resourceGroups/rg-hub-bastion/providers/Microsoft.Network/bastionHosts/bst-appsvc-lza'

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

// --- ASE v3 + Windows web app + Bastion jump host ---
@batchSize(1)
module testDeploymentWindowsWebApp '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-wweb-${iteration}'
    params: {
      workloadName: take('${namePrefix}aseww', 10)
      logAnalyticsWorkspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
      tags: {
        environment: 'test'
        scenario: 'ase-windows-webapp-bastion'
      }

      deployAseV3: true
      servicePlanConfig: {
        kind: 'windows'
        sku: 'I1v2'
      }
      appServiceConfig: {
        kind: 'app'
      }
      spokeNetworkConfig: {
        ingressOption: 'none'
        appSvcSubnetAddressSpace: '10.240.0.0/24'
      }

      // Windows jump host with Bastion integration
      jumpboxConfig: {
        osType: 'windows'
        bastionResourceId: bastionPlaceholderResourceId
        vmSize: 'Standard_D2s_v4'
        adminUsername: 'azureuser'
        adminPassword: password
      }
      location: enforcedLocation
    }
  }
]

// --- ASE v3 + Windows container + Bastion jump host ---
@batchSize(1)
module testDeploymentWindowsContainer '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-wctr-${iteration}'
    params: {
      workloadName: take('${namePrefix}asewc', 10)
      logAnalyticsWorkspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
      tags: {
        environment: 'test'
        scenario: 'ase-windows-container-bastion'
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

      // Windows jump host with Bastion integration
      jumpboxConfig: {
        osType: 'windows'
        bastionResourceId: bastionPlaceholderResourceId
        vmSize: 'Standard_D2s_v4'
        adminUsername: 'azureuser'
        adminPassword: password
      }
      location: enforcedLocation
    }
  }
]

output testDeploymentOutputs object = {
  windowsWebApp: testDeploymentWindowsWebApp[0].outputs
  windowsContainer: testDeploymentWindowsContainer[0].outputs
}
