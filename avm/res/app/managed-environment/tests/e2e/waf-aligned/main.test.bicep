targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-app.managedenvironments-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'amewaf'

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableTelemetry bool = true

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// =========== //
// Deployments //
// =========== //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-paramNested'
  params: {
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    location: location
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [for iteration in [ 'init', 'idem' ]: {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}-${iteration}'
  params: {
    enableTelemetry: enableTelemetry
    name: '${namePrefix}${serviceShort}001'
    logAnalyticsWorkspaceResourceId: nestedDependencies.outputs.logAnalyticsWorkspaceResourceId
    location: location
    workloadProfiles: [
      {
        workloadProfileType: 'D4'
        name: 'CAW01'
        minimumCount: 0
        maximumCount: 3
      }
    ]
    internal: true
    dockerBridgeCidr: '172.16.0.1/28'
    platformReservedCidr: '172.17.17.0/24'
    platformReservedDnsIP: '172.17.17.17'
    infrastructureSubnetId: nestedDependencies.outputs.subnetResourceId
    infrastructureResourceGroupName: 'me-dep-${namePrefix}-app.managedenvironments-${serviceShort}-rg'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    tags: {
      'hidden-title': 'This is visible in the resource name'
      Env: 'test'
    }
  }
}]
