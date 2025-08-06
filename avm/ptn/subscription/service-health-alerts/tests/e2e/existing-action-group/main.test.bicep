targetScope = 'subscription'

metadata name = 'Deploying multiple service health alerts with an existing action group.'
metadata description = 'This instance deploys the module with the maximum set of required parameters.'

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
param serviceShort string = 'ashact'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

module dependencies './dependencies.bicep' = {
  scope: subscription(subscriptionId)
  params: {
    resourceGroupName: resourceGroupName
    actionGroupName: 'dep-${serviceShort}-${namePrefix}-action-group'
    location: resourceLocation
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../main.bicep' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${namePrefix}'
  params: {
    subscriptionId: subscriptionId
    location: resourceLocation
    serviceHealthAlertsResourceGroupName: dependencies.outputs.resourceGroupName
    serviceHealthAlerts: [
      {
        serviceHealthAlert: 'Service Health Advisory'
        alertDescription: 'Service Health Advisory'
        isEnabled: true
        actionGroup: {
          enabled: true
          existingActionGroupResourceId: dependencies.outputs.actionGroupResourceId
        }
      }
      {
        serviceHealthAlert: 'Service Health Incident'
        alertDescription: 'Service Health Incident'
        isEnabled: true
        actionGroup: {
          enabled: true
          existingActionGroupResourceId: dependencies.outputs.actionGroupResourceId
        }
      }
    ]
    enableTelemetry: true
  }
}
