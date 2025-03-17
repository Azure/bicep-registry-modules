targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-azd-aks-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'paamax'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. The name (as GUID) of the role assignment. If not provided, a GUID will be generated.')
param containerRegistryRoleName string = newGuid()

@description('Optional. The name (as GUID) of the role assignment. If not provided, a GUID will be generated.')
param aksClusterRoleAssignmentName string = newGuid()

// Enforced location als not all regions have quota available
#disable-next-line no-hardcoded-location
var enforcedLocation = 'northeurope'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

module nestedDependencies 'dependencies.bicep' = {
  name: '${uniqueString(deployment().name, enforcedLocation)}-test-dependencies'
  scope: resourceGroup
  params: {
    location: enforcedLocation
    appName: 'dep-${namePrefix}-app-${serviceShort}'
    appServicePlanName: 'dep-${namePrefix}-apps-${serviceShort}'
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
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: 'mc${uniqueString(deployment().name)}-${serviceShort}'
      containerRegistryName: '${uniqueString(deployment().name, enforcedLocation)}testcontainerregistry${serviceShort}'
      skuTier: 'Free'
      webApplicationRoutingEnabled: true
      monitoringWorkspaceResourceId: nestedDependencies.outputs.logAnalyticsResourceId
      keyVaultName: 'kv${uniqueString(deployment().name)}-${serviceShort}'
      location: enforcedLocation
      principalId: nestedDependencies.outputs.identityPrincipalId
      acrSku: 'Basic'
      dnsPrefix: 'dep-${namePrefix}-dns-${serviceShort}'
      principalType: 'ServicePrincipal'
      containerRegistryRoleName: containerRegistryRoleName
      aksClusterRoleAssignmentName: aksClusterRoleAssignmentName
      agentPoolConfig: [
        {
          name: 'npuserpool'
          mode: 'User'
          osType: 'Linux'
          maxPods: 30
          type: 'VirtualMachineScaleSets'
          maxSurge: '33%'
          vmSize: 'Standard_DS2_v2'
        }
      ]
      agentPoolSize: 'Standard'
      aadProfile: null
      disableLocalAccounts: false
      systemPoolConfig: [
        {
          name: 'npsystem'
          mode: 'System'
          vmSize: 'Standard_DS2_v2'
          count: 3
          minCount: 3
          maxCount: 5
          enableAutoScaling: true
          availabilityZones: [
            1
            2
            3
          ]
        }
      ]
    }
  }
]
