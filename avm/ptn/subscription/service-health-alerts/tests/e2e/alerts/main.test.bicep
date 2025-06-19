targetScope = 'subscription'

metadata name = 'Deploying multiple service health alerts.'
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
param serviceShort string = 'ashalt'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

module dependencies './dependencies.bicep' = {
  scope: subscription(subscriptionId)
  params: {
    resourceGroupName: resourceGroupName
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
        serviceHealthAlert: 'Resource Health Unhealthy'
        alertDescription: 'Resource Health Unhealthy'
        isEnabled: true
        actionGroup: {
          name: 'actionGroup-${namePrefix}-${serviceShort}'
          enabled: true
          emailReceivers: [
            {
              name: 'emailReceiver-${namePrefix}-${serviceShort}'
              emailAddress: 'admin@contoso.com'
            }
          ]
          armRoleReceivers: [
            {
              name: 'armRoleReceiverOwner-${namePrefix}-${serviceShort}'
              roleId: '8e3af657-a8ff-443c-a75c-2fe8c4bcb635' // Owner role
            }
          ]
        }
      }
    ]
    enableTelemetry: true
  }
}
