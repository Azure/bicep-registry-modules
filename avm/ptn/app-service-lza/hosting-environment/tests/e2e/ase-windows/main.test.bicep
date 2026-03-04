metadata name = 'ASE v3 with Windows web app and jumpbox example.'
metadata description = 'This instance deploys ASE v3 with a Windows web app and demonstrates deploying a jumpbox VM via Bastion.'

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

@description('Optional. The password to leverage for the jumpbox VM.')
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

// --- ASE v3 + Windows web app + Bastion jump host ---
@batchSize(1)
module testDeployment '../../../main.bicep' = [
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
      location: enforcedLocation
    }
  }
]

output testDeploymentOutputs object = testDeployment[0].outputs

// ================================= //
// Example: Deploy a jumpbox VM      //
// ================================= //
// Demonstrates deploying a jumpbox into the spoke VNet after the LZA deployment.

var spokeResourceGroupName = 'rg-spoke-${take('${namePrefix}aseww', 10)}-test-${enforcedLocation}'

var bastionPlaceholderResourceId = '/subscriptions/${subscription().subscriptionId}/resourceGroups/rg-hub-bastion/providers/Microsoft.Network/bastionHosts/bst-appsvc-lza'

module jumpbox './dependencies.bicep' = {
  name: '${uniqueString(deployment().name, enforcedLocation)}-jumpbox'
  scope: az.resourceGroup(spokeResourceGroupName)
  params: {
    vmName: take('vm-${namePrefix}${serviceShort}', 15)
    spokeVnetName: testDeployment[0].outputs.spokeVnetName
    vmAdminUsername: 'azureuser'
    vmAdminPassword: password
    bastionResourceId: bastionPlaceholderResourceId
    vmSize: 'Standard_D2s_v4'
    location: enforcedLocation
    tags: {
      environment: 'test'
      scenario: 'ase-windows-jumpbox'
    }
  }
}
