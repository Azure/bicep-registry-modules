targetScope = 'subscription'

metadata name = 'Enable public access'
metadata description = 'This instance deploys the module with public access enabled.'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-app.managedenvironments-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'amepa'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// =========== //
// Deployments //
// =========== //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-paramNested'
  params: {
    location: resourceLocation
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      appLogsConfiguration: {
        destination: 'log-analytics'
        logAnalyticsConfiguration: {
          customerId: nestedDependencies.outputs.logAnalyticsWorkspaceCustomerId
          sharedKey: listKeys(
            '${resourceGroup.id}/providers/Microsoft.OperationalInsights/workspaces/dep-${namePrefix}-law-${serviceShort}',
            '2023-09-01'
          ).primarySharedKey
        }
      }
      location: resourceLocation
      workloadProfiles: [
        {
          workloadProfileType: 'D4'
          name: 'CAW01'
          minimumCount: 0
          maximumCount: 3
        }
      ]
      dockerBridgeCidr: '172.16.0.1/28'
      platformReservedCidr: '172.17.17.0/24'
      platformReservedDnsIP: '172.17.17.17'
      publicNetworkAccess: 'Enabled'
      infrastructureSubnetResourceId: nestedDependencies.outputs.subnetResourceId
      infrastructureResourceGroupName: 'me-${resourceGroupName}'
    }
  }
]
