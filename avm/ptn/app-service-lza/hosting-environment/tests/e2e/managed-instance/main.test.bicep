metadata name = 'Managed Instance with Application Gateway and Bastion.'
metadata description = 'This instance deploys a Windows Managed Instance App Service Plan with Application Gateway for single-region ingress and a jumpbox VM via Bastion.'

targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for diagnostics settings.')
@maxLength(90)
param diagnosticsResourceGroupName string = 'diag-appservicelza-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'appmgins'

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

// --- Windows Managed Instance + Application Gateway + Bastion ---
@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-${iteration}'
    params: {
      workloadName: take('${namePrefix}${serviceShort}', 10)
      logAnalyticsWorkspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
      tags: {
        environment: 'test'
        scenario: 'managed-instance-appgw-bastion'
      }

      servicePlanConfig: {
        kind: 'windows'
        sku: 'P1V4'
        isCustomMode: true
        rdpEnabled: true
      }
      appServiceConfig: {
        kind: 'app'
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

// ================================= //
// Example: Deploy a jumpbox VM      //
// ================================= //
// Demonstrates deploying a jumpbox into the spoke VNet for RDP access via Bastion.

var spokeResourceGroupName = 'rg-spoke-${take('${namePrefix}${serviceShort}', 10)}-test-${enforcedLocation}'

var bastionPlaceholderResourceId = '/subscriptions/${subscription().subscriptionId}/resourceGroups/rg-hub-bastion/providers/Microsoft.Network/bastionHosts/bst-appsvc-lza'

module jumpbox '../ase-windows/dependencies.bicep' = {
  name: '${uniqueString(deployment().name, enforcedLocation)}-jumpbox'
  scope: az.resourceGroup(spokeResourceGroupName)
  dependsOn: [
    testDeployment
  ]
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
      scenario: 'managed-instance-jumpbox'
    }
  }
}
