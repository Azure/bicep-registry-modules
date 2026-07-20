metadata name = 'Managed Instance'
metadata description = 'This instance deploys a Managed Instance (Custom Mode) App Service Plan with Application Gateway and a jumpbox VM.'

targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-ptn.appsvclza-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'apmgi'

@description('Optional. Test name prefix.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. The password to leverage for the jumpbox VM.')
@secure()
param password string = newGuid()

#disable-next-line no-hardcoded-location
var enforcedLocation = 'australiaeast'

// Dependencies
// ===========
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.15.0' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-law'
  params: {
    name: 'dep-${namePrefix}-law-${serviceShort}'
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
      logAnalyticsWorkspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
      tags: {
        environment: 'test'
        scenario: 'managed-instance'
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
        resourceGroupName: resourceGroupName
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

var spokeResourceGroupName = resourceGroupName

var bastionPlaceholderResourceId = '/subscriptions/${subscription().subscriptionId}/resourceGroups/rg-hub-bastion/providers/Microsoft.Network/bastionHosts/bst-appsvc-lza'

module jumpbox './dependencies.bicep' = {
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
