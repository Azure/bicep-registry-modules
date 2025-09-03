targetScope = 'subscription'

metadata name = 'Deploying multiple service health alerts with an existing action group.'
metadata description = 'This instance deploys the module with a reference to an existing action group.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-ash-${namePrefix}-${serviceShort}-rg'

@description('Required. The subscription ID to deploy service health alerts to. If not provided, the current subscription will be used.')
param subscriptionId string = subscription().subscriptionId

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'asheact'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    actionGroupName: 'dep-${serviceShort}-${namePrefix}-action-group'
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../main.bicep' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${namePrefix}'
  params: {
    subscriptionId: subscriptionId
    serviceHealthAlertsResourceGroupName: resourceGroup.name
    location: resourceLocation
    serviceHealthAlerts: [
      {
        serviceHealthAlert: 'Service Health Advisory'
        alertDescription: 'Service Health Advisory'
        isEnabled: true
        actionGroup: {
          enabled: true
          existingActionGroupResourceId: nestedDependencies.outputs.actionGroupResourceId
        }
      }
      {
        serviceHealthAlert: 'Service Health Incident'
        alertDescription: 'Service Health Incident'
        isEnabled: true
        actionGroup: {
          enabled: true
          existingActionGroupResourceId: nestedDependencies.outputs.actionGroupResourceId
        }
      }
    ]
  }
}
