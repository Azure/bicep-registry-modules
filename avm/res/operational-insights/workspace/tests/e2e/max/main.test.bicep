targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-operationalinsights.workspaces-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'oiwmax'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    location: resourceLocation
    storageAccountName: 'dep${namePrefix}sa${serviceShort}'
    automationAccountName: 'dep-${namePrefix}-auto-${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}diasa${serviceShort}01'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}'
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
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      location: resourceLocation
      dailyQuotaGb: 10
      dataSources: [
        {
          eventLogName: 'Application'
          eventTypes: [
            {
              eventType: 'Error'
            }
            {
              eventType: 'Warning'
            }
            {
              eventType: 'Information'
            }
          ]
          kind: 'WindowsEvent'
          name: 'applicationEvent'
        }
        {
          counterName: '% Processor Time'
          instanceName: '*'
          intervalSeconds: 60
          kind: 'WindowsPerformanceCounter'
          name: 'windowsPerfCounter1'
          objectName: 'Processor'
        }
        {
          kind: 'IISLogs'
          name: 'sampleIISLog1'
          state: 'OnPremiseEnabled'
        }
        {
          kind: 'LinuxSyslog'
          name: 'sampleSyslog1'
          syslogName: 'kern'
          syslogSeverities: [
            {
              severity: 'emerg'
            }
            {
              severity: 'alert'
            }
            {
              severity: 'crit'
            }
            {
              severity: 'err'
            }
            {
              severity: 'warning'
            }
          ]
        }
        {
          kind: 'LinuxSyslogCollection'
          name: 'sampleSyslogCollection1'
          state: 'Enabled'
        }
        {
          instanceName: '*'
          intervalSeconds: 10
          kind: 'LinuxPerformanceObject'
          name: 'sampleLinuxPerf1'
          objectName: 'Logical Disk'
          syslogSeverities: [
            {
              counterName: '% Used Inodes'
            }
            {
              counterName: 'Free Megabytes'
            }
            {
              counterName: '% Used Space'
            }
            {
              counterName: 'Disk Transfers/sec'
            }
            {
              counterName: 'Disk Reads/sec'
            }
            {
              counterName: 'Disk Writes/sec'
            }
          ]
        }
        {
          kind: 'LinuxPerformanceCollection'
          name: 'sampleLinuxPerfCollection1'
          state: 'Enabled'
        }
      ]
      diagnosticSettings: [
        {
          name: 'customSetting'
          metricCategories: [
            {
              category: 'AllMetrics'
            }
          ]
          eventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
          eventHubAuthorizationRuleResourceId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
          storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
          workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
        }
      ]
      gallerySolutions: [
        {
          name: 'AzureAutomation(${namePrefix}${serviceShort}001)'
          plan: {
            product: 'OMSGallery/AzureAutomation'
          }
        }
        {
          name: 'SecurityInsights(${namePrefix}${serviceShort}001)'
          plan: {
            product: 'OMSGallery/SecurityInsights'
            publisher: 'Microsoft'
          }
        }
        {
          name: 'SQLAuditing(${namePrefix}${serviceShort}001)'
          plan: {
            name: 'SQLAuditing(${namePrefix}${serviceShort}001)'
            product: 'SQLAuditing'
            publisher: 'Microsoft'
          }
        }
      ]
      onboardWorkspaceToSentinel: true
      linkedServices: [
        {
          name: 'Automation'
          resourceId: nestedDependencies.outputs.automationAccountResourceId
        }
      ]
      linkedStorageAccounts: [
        {
          name: 'Query'
          storageAccountIds: [
            nestedDependencies.outputs.storageAccountResourceId
          ]
        }
      ]
      tables: [
        {
          name: 'CustomTableBasic_CL'
          schema: {
            name: 'CustomTableBasic_CL'
            columns: [
              {
                name: 'TimeGenerated'
                type: 'dateTime'
              }
              {
                name: 'RawData'
                type: 'string'
              }
            ]
          }
          totalRetentionInDays: 90
          retentionInDays: 60
          roleAssignments: [
            {
              roleDefinitionIdOrName: 'Owner'
              principalId: nestedDependencies.outputs.managedIdentityPrincipalId
              principalType: 'ServicePrincipal'
            }
            {
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
        }
        {
          name: 'CustomTableAdvanced_CL'
          schema: {
            name: 'CustomTableAdvanced_CL'
            columns: [
              {
                name: 'TimeGenerated'
                type: 'dateTime'
              }
              {
                name: 'EventTime'
                type: 'dateTime'
              }
              {
                name: 'EventLevel'
                type: 'string'
              }
              {
                name: 'EventCode'
                type: 'int'
              }
              {
                name: 'Message'
                type: 'string'
              }
              {
                name: 'RawData'
                type: 'string'
              }
            ]
          }
          roleAssignments: [
            {
              roleDefinitionIdOrName: 'Owner'
              principalId: nestedDependencies.outputs.managedIdentityPrincipalId
              principalType: 'ServicePrincipal'
            }
            {
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
        }
      ]
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
      publicNetworkAccessForIngestion: 'Disabled'
      publicNetworkAccessForQuery: 'Disabled'
      savedSearches: [
        {
          category: 'VDC Saved Searches'
          displayName: 'VMSS Instance Count2'
          name: 'VMSSQueries'
          query: 'Event | where Source == ServiceFabricNodeBootstrapAgent | summarize AggregatedValue = count() by Computer'
          tags: [
            {
              Name: 'Environment'
              Value: 'Non-Prod'
            }
            {
              Name: 'Role'
              Value: 'DeploymentValidation'
            }
          ]
        }
      ]
      storageInsightsConfigs: [
        {
          storageAccountResourceId: nestedDependencies.outputs.storageAccountResourceId
          tables: [
            'LinuxsyslogVer2v0'
            'WADETWEventTable'
            'WADServiceFabric*EventTable'
            'WADWindowsEventLogsTable'
          ]
        }
      ]
      useResourcePermissions: true
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
      managedIdentities: {
        systemAssigned: true
      }
      roleAssignments: [
        {
          name: 'c3d53092-840c-4025-9c02-9bcb7895789c'
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
    }
    dependsOn: [
      nestedDependencies
      diagnosticDependencies
    ]
  }
]
