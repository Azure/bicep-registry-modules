targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-app.agent-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

// Enforcing location as Microsoft.App/agents is only available in limited regions
#disable-next-line no-hardcoded-location
var enforcedLocation = 'swedencentral'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'aagwaf'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// =========== //
// Deployments //
// =========== //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-paramNested'
  params: {
    location: enforcedLocation
    namePrefix: namePrefix
    serviceShort: serviceShort
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
      name: '${namePrefix}${serviceShort}001'
      location: enforcedLocation
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
      managedIdentities: {
        systemAssigned: true
        userAssignedResourceIds: [
          nestedDependencies.outputs.managedIdentityResourceId
        ]
      }
      lock: {
        kind: 'CanNotDelete'
        name: 'agentLock'
      }
      accessLevel: 'High'
      agentMode: 'Review'
      upgradeChannel: 'Stable'
      monthlyAgentUnitLimit: 10000
      incidentManagementConfigurationType: 'AzMonitor'
      knowledgeGraphIdentityResourceId: nestedDependencies.outputs.managedIdentityResourceId
      actionIdentityResourceId: nestedDependencies.outputs.managedIdentityResourceId
      applicationInsightsAppId: nestedDependencies.outputs.applicationInsightsAppId
      applicationInsightsConnectionString: nestedDependencies.outputs.applicationInsightsConnectionString
    }
  }
]
