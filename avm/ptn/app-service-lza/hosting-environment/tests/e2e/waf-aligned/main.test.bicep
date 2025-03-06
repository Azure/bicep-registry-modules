metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module with WAF aligned settings.'

targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'appwaf'

@description('Optional. Test name prefix.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. The password to leverage for the login.')
@secure()
param password string = newGuid()

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
    deployJumpHost: true
    vmSize: 'Standard_D2s_v4'
    adminUsername: 'azureuser'
    adminPassword: password
    enableEgressLockdown: true
  }
}

output testDeploymentOutputs object = testDeployment.outputs
