targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-alertsmanagement.actionrule-${serviceShort}-rg'

@description('Optional. The location to deploy resource group to.')
param resourceLocation string = deployment().location

@description('Optional. Location to deploy alert processing rule to.')
param location string = 'global'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'aprmax'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    actionGroupName: 'dep-${namePrefix}-ag-${serviceShort}'
    actvityLogAlertName: 'dep-${namePrefix}-ala-${serviceShort}'
    location: resourceLocation
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, location)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      aprDescription: 'Test deployment of the module with the max set of parameters.'
      location: location
      enabled: true
      scopes: [
        resourceGroup.id
      ]
      conditions: [
        {
          field: 'AlertContext'
          operator: 'NotEquals'
          values: [
            'myAlertContext'
          ]
        }
        {
          field: 'AlertRuleId'
          operator: 'Equals'
          values: [
            nestedDependencies.outputs.activityLogAlertResourceId
          ]
        }
        {
          field: 'AlertRuleName'
          operator: 'Equals'
          values: [
            nestedDependencies.outputs.activityLogAlertResourceName
          ]
        }
        {
          field: 'Description'
          operator: 'Contains'
          values: [
            'myAlertRuleDescription'
          ]
        }
        {
          field: 'MonitorService'
          operator: 'Equals'
          values: [
            'ActivityLog Administrative'
          ]
        }
        {
          field: 'MonitorCondition'
          operator: 'Equals'
          values: [
            'Fired'
          ]
        }
        {
          field: 'TargetResourceType'
          operator: 'DoesNotContain'
          values: [
            'myAlertResourceType'
          ]
        }
        {
          field: 'TargetResource'
          operator: 'Equals'
          values: [
            'myAlertResource1'
            'myAlertResource2'
          ]
        }
        {
          field: 'TargetResourceGroup'
          operator: 'Equals'
          values: [
            resourceGroup.id
          ]
        }
        {
          field: 'Severity'
          operator: 'Equals'
          values: [
            'Sev0'
            'Sev1'
            'Sev2'
            'Sev3'
            'Sev4'
          ]
        }
        {
          field: 'SignalType'
          operator: 'Equals'
          values: [
            'Metric'
            'Log'
            'Unknown'
            'Health'
          ]
        }
      ]
      actions: [
        {
          actionGroupIds: [
            nestedDependencies.outputs.actionGroupResourceId
          ]
          actionType: 'AddActionGroups'
        }
      ]
      roleAssignments: [
        {
          name: 'a66da6bc-b3ee-484e-9bdb-9294938bb327'
          roleDefinitionIdOrName: 'Owner'
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
        {
          name: guid('Custom seed ${namePrefix}${serviceShort}')
          roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
        {
          roleDefinitionIdOrName: subscriptionResourceId(
            'Microsoft.Authorization/roleDefinitions',
            'acdd72a7-3385-48ef-bd42-f606fba81ae7'
          )
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
      ]
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
  }
]
