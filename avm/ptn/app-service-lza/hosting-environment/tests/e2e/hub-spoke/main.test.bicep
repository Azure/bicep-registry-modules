metadata name = 'Using defaults with hub'
metadata description = 'This instance deploys the module with the minimum set of required parameters and a hub.'

targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'applzamin'

@description('Optional. Test name prefix.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. The password to leverage for the login.')
@secure()
param password string = newGuid()

param environment string = 'test'

param workloadName string = 'applzahub'

// ============ //
// Dependencies //
// ============ //

module hubDeployment 'deploy.hub.bicep' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-hub-${serviceShort}'
  params: {
    location: resourceLocation
    resourceGroupName: 'rg-hub-${workloadName}-${environment}-${resourceLocation}'
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../main.bicep' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}'
  params: {
    workloadName: serviceShort
    tags: {
      environment: 'test'
    }
    location: resourceLocation
    deployAseV3: false
    deployJumpHost: true
    vmSize: 'Standard_D2s_v4'
    adminUsername: 'azureuser'
    adminPassword: password
    enableEgressLockdown: false
    autoApproveAfdPrivateEndpoint: true
    vnetHubResourceId: hubDeployment.outputs.vnetHubResourceId
    vnetSpokeAddressSpace: '10.240.0.0/20'
    subnetSpokeAppSvcAddressSpace: '10.240.0.0/26'
    subnetSpokeDevOpsAddressSpace: '10.240.10.128/26'
    subnetSpokePrivateEndpointAddressSpace: '10.240.11.0/24'
    webAppPlanSku: 'P1V3'
    webAppBaseOs: 'linux'
  }
}

output testDeploymentOutputs object = testDeployment.outputs
