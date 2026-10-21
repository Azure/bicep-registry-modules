targetScope = 'subscription'

extension microsoftGraphV1

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled and grants the Azure Virtual Desktop service principal subscription-level autoscale permissions.'

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-desktopvirtualization.scalingplans-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dvspmax'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================

var azureVirtualDesktopAppId = '9cdead84-a844-4324-93f2-b2e6bb768d07'
var autoscaleRoleDefinitionId = subscriptionResourceId(
  'Microsoft.Authorization/roleDefinitions',
  '40c5ff49-9181-41f8-ae61-143b0e78555e'
)

// The deployment identity needs Microsoft Graph Application.Read.All to resolve this tenant-specific principal.
resource azureVirtualDesktop 'Microsoft.Graph/servicePrincipals@v1.0' existing = {
  appId: azureVirtualDesktopAppId
}

// Autoscale requires this assignment at subscription scope, not on the scaling plan.
resource autoscaleRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(subscription().id, azureVirtualDesktopAppId, autoscaleRoleDefinitionId)
  properties: {
    roleDefinitionId: autoscaleRoleDefinitionId
    principalId: azureVirtualDesktop.id
    principalType: 'ServicePrincipal'
  }
}

resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
  }
}

// Diagnostics
// ===========

module diagnosticDependencies '../../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}diasa${serviceShort}03'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}01'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}01'
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
      name: '${namePrefix}${serviceShort}002'
      location: resourceLocation
      friendlyName: 'friendlyName'
      description: 'myDescription'
      schedules: [
        {
          daysOfWeek: [
            'Monday'
            'Wednesday'
            'Thursday'
            'Friday'
          ]
          name: 'WeekdaySchedule'
          offPeakLoadBalancingAlgorithm: 'DepthFirst'
          offPeakStartTime: {
            hour: 20
            minute: 0
          }
          peakLoadBalancingAlgorithm: 'DepthFirst'
          peakStartTime: {
            hour: 9
            minute: 0
          }
          rampDownCapacityThresholdPct: 90
          rampDownForceLogoffUsers: true
          rampDownLoadBalancingAlgorithm: 'DepthFirst'
          rampDownMinimumHostsPct: 0
          rampDownNotificationMessage: 'You will be logged off in 30 min. Make sure to save your work.'
          rampDownStartTime: {
            hour: 18
            minute: 0
          }
          rampDownStopHostsWhen: 'ZeroActiveSessions'
          rampDownWaitTimeMinutes: 30
          rampUpCapacityThresholdPct: 80
          rampUpLoadBalancingAlgorithm: 'BreadthFirst'
          rampUpMinimumHostsPct: 20
          rampUpStartTime: {
            hour: 7
            minute: 0
          }
        }
        {
          daysOfWeek: [
            'Tuesday'
          ]
          name: 'weekdaysSchedule-agent-updates'
          offPeakLoadBalancingAlgorithm: 'DepthFirst'
          offPeakStartTime: {
            hour: 20
            minute: 0
          }
          peakLoadBalancingAlgorithm: 'DepthFirst'
          peakStartTime: {
            hour: 9
            minute: 0
          }
          rampDownCapacityThresholdPct: 90
          rampDownForceLogoffUsers: true
          rampDownLoadBalancingAlgorithm: 'DepthFirst'
          rampDownMinimumHostsPct: 0
          rampDownNotificationMessage: 'You will be logged off in 30 min. Make sure to save your work.'
          rampDownStartTime: {
            hour: 19
            minute: 0
          }
          rampDownStopHostsWhen: 'ZeroActiveSessions'
          rampDownWaitTimeMinutes: 30
          rampUpCapacityThresholdPct: 80
          rampUpLoadBalancingAlgorithm: 'BreadthFirst'
          rampUpMinimumHostsPct: 20
          rampUpStartTime: {
            hour: 7
            minute: 0
          }
        }
        {
          daysOfWeek: [
            'Saturday'
            'Sunday'
          ]
          name: 'WeekendSchedule'
          offPeakLoadBalancingAlgorithm: 'DepthFirst'
          offPeakStartTime: {
            hour: 18
            minute: 0
          }
          peakLoadBalancingAlgorithm: 'DepthFirst'
          peakStartTime: {
            hour: 10
            minute: 0
          }
          rampDownCapacityThresholdPct: 90
          rampDownForceLogoffUsers: true
          rampDownLoadBalancingAlgorithm: 'DepthFirst'
          rampDownMinimumHostsPct: 0
          rampDownNotificationMessage: 'You will be logged off in 30 min. Make sure to save your work.'
          rampDownStartTime: {
            hour: 16
            minute: 0
          }
          rampDownStopHostsWhen: 'ZeroActiveSessions'
          rampDownWaitTimeMinutes: 30
          rampUpCapacityThresholdPct: 90
          rampUpLoadBalancingAlgorithm: 'DepthFirst'
          rampUpMinimumHostsPct: 0
          rampUpStartTime: {
            hour: 9
            minute: 0
          }
        }
      ]
      hostPoolReferences: [
        {
          hostPoolResourceId: nestedDependencies.outputs.hostPoolResourceId
          scalingPlanEnabled: true
        }
      ]
      diagnosticSettings: [
        {
          name: 'customSetting'
          logCategoriesAndGroups: [
            {
              categoryGroup: 'allLogs'
            }
          ]
          eventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
          eventHubAuthorizationRuleResourceId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
          storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
          workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
        }
      ]
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
      roleAssignments: [
        {
          name: 'c2c1c560-2169-405a-a8dc-7427e403e5ac'
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
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
    dependsOn: [
      autoscaleRoleAssignment
    ]
  }
]
