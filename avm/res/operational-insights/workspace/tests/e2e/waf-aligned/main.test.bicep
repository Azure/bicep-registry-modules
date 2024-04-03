targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-operationalinsights.workspaces-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'oiwwaf'

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
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
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
          eventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
          eventHubAuthorizationRuleResourceId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
          storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
          workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
        }
      ]
      gallerySolutions: [
        {
          name: 'AzureAutomation'
          product: 'OMSGallery'
          publisher: 'Microsoft'
        }
      ]
      linkedServices: [
        {
          name: 'Automation'
          resourceId: nestedDependencies.outputs.automationAccountResourceId
        }
      ]
      linkedStorageAccounts: [
        {
          name: 'Query'
          resourceId: nestedDependencies.outputs.storageAccountResourceId
        }
      ]
      publicNetworkAccessForIngestion: 'Disabled'
      publicNetworkAccessForQuery: 'Disabled'
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
    }
    dependsOn: [
      nestedDependencies
      diagnosticDependencies
    ]
  }
]
