metadata name = 'avm/ptn/alz/ama'
metadata description = 'This modules deployes resources for Azure Monitoring Agent (AMA) to be used within Azure Landing Zones'

@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@description('Optional. The lock settings for all resources in the solution.')
param lockConfig lockType?

@description('Required. The name of the User Assigned Identity utilized for Azure Monitoring Agent.')
param userAssignedIdentityName string

@description('Required. The resource ID of the Log Analytics Workspace.')
param logAnalyticsWorkspaceResourceId string

@description('Required. The name of the data collection rule for VM Insights.')
param dataCollectionRuleVMInsightsName string

@description('Optional. The experience for the VM Insights data collection rule.')
@allowed(['PerfAndMap', 'PerfOnly'])
param dataCollectionRuleVMInsightsExperience string = 'PerfAndMap'

@description('Required. The name of the data collection rule for Change Tracking.')
param dataCollectionRuleChangeTrackingName string

@description('Required. The name of the data collection rule for Microsoft Defender for SQL.')
param dataCollectionRuleMDFCSQLName string

@description('Optional. Tags for all Resources in the solution.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

// ============== //
// Resources      //
// ============== //

module userAssignedManagedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.3' = {
  name: '${uniqueString(subscription().id, resourceGroup().id, location)}-UserAssignedIdentity'
  params: {
    name: userAssignedIdentityName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

#disable-next-line use-recent-api-versions
resource dataCollectionRuleVMInsightsPerfAndMap 'Microsoft.Insights/dataCollectionRules@2021-04-01' = if (dataCollectionRuleVMInsightsExperience == 'PerfAndMap') {
  name: dataCollectionRuleVMInsightsName
  location: location
  tags: tags
  properties: {
    description: 'Data collection rule for VM Insights'
    dataSources: {
      performanceCounters: [
        {
          name: 'VMInsightsPerfCounters'
          streams: [
            'Microsoft-InsightsMetrics'
          ]
          counterSpecifiers: [
            '\\VMInsights\\DetailedMetrics'
          ]
          samplingFrequencyInSeconds: 60
        }
      ]
      extensions: [
        {
          streams: [
            'Microsoft-ServiceMap'
          ]
          extensionName: 'DependencyAgent'
          extensionSettings: {}
          name: 'DependencyAgentDataSource'
        }
      ]
    }
    destinations: {
      logAnalytics: [
        {
          workspaceResourceId: logAnalyticsWorkspaceResourceId
          name: 'VMInsightsPerf-Logs-Dest'
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          'Microsoft-InsightsMetrics'
        ]
        destinations: [
          'VMInsightsPerf-Logs-Dest'
        ]
      }
      {
        streams: [
          'Microsoft-ServiceMap'
        ]
        destinations: [
          'VMInsightsPerf-Logs-Dest'
        ]
      }
    ]
  }
}

#disable-next-line use-recent-api-versions
resource dataCollectionRuleVMInsightsPerfOnly 'Microsoft.Insights/dataCollectionRules@2021-04-01' = if (dataCollectionRuleVMInsightsExperience == 'PerfOnly') {
  name: dataCollectionRuleVMInsightsName
  location: location
  tags: tags
  properties: {
    description: 'Data collection rule for VM Insights'
    dataSources: {
      performanceCounters: [
       {
         name: 'VMInsightsPerfCounters'
         streams: [
          'Microsoft-InsightsMetrics'
         ]
         counterSpecifiers: [
          '\\VmInsights\\DetailedMetrics'
         ]
         samplingFrequencyInSeconds: 60
       }
      ]
    }
    destinations: {
      logAnalytics: [
        {
          workspaceResourceId: logAnalyticsWorkspaceResourceId
          name: 'VMInsightsPerf-Logs-Dest'
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          'Microsoft-InsightsMetrics'
        ]
        destinations: [
          'VMInsightsPerf-Logs-Dest'
        ]
      }
    ]
  }
}

resource dataCollectionRuleVMInsightsPerfandMapLock 'Microsoft.Authorization/locks@2020-05-01' = if (lockConfig.?kind != 'None' && !(empty(lockConfig.?name)) && dataCollectionRuleVMInsightsExperience == 'PerfAndMap') {
  scope: dataCollectionRuleVMInsightsPerfAndMap
  name: lockConfig.?name ?? '${dataCollectionRuleVMInsightsPerfAndMap.name}-lock'
  properties: {
    level: lockConfig.?kind ?? 'ReadOnly'
  }
}

resource dataCollectionRuleVMInsightsPerfOnlyLock 'Microsoft.Authorization/locks@2020-05-01' = if (lockConfig.?kind != 'None' && !(empty(lockConfig.?name)) && dataCollectionRuleVMInsightsExperience == 'PerfOnly') {
  scope: dataCollectionRuleVMInsightsPerfOnly
  name: lockConfig.?name ?? '${dataCollectionRuleVMInsightsPerfOnly.name}-lock'
  properties: {
    level: lockConfig.?kind ?? 'ReadOnly'
  }
}

#disable-next-line use-recent-api-versions
resource dataCollectionRuleChangeTracking 'Microsoft.Insights/dataCollectionRules@2021-04-01' = {
  name: dataCollectionRuleChangeTrackingName
  location: location
  tags: tags
  properties: {
    description: 'Data collection rule for CT.'
    dataSources: {
      extensions: [
        {
          streams: [
            'Microsoft-ConfigurationChange'
            'Microsoft-ConfigurationChangeV2'
            'Microsoft-ConfigurationData'
          ]
          extensionName: 'ChangeTracking-Windows'
          extensionSettings: {
            enableFiles: true
            enableSoftware: true
            enableRegistry: true
            enableServices: true
            enableInventory: true
            registrySettings: {
              registryCollectionFrequency: 3000
              registryInfo: [
                {
                  name: 'Registry_1'
                  groupTag: 'Recommended'
                  enabled: false
                  recurse: true
                  description: ''
                  keyName: 'HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\CurrentVersion\\Group Policy\\Scripts\\Startup'
                  valueName: ''
                }
                {
                  name: 'Registry_2'
                  groupTag: 'Recommended'
                  enabled: false
                  recurse: true
                  description: ''
                  keyName: 'HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\CurrentVersion\\Group Policy\\Scripts\\Shutdown'
                  valueName: ''
                }
                {
                  name: 'Registry_3'
                  groupTag: 'Recommended'
                  enabled: false
                  recurse: true
                  description: ''
                  keyName: 'HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Run'
                  valueName: ''
                }
                {
                  name: 'Registry_4'
                  groupTag: 'Recommended'
                  enabled: false
                  recurse: true
                  description: ''
                  keyName: 'HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Active Setup\\Installed Components'
                  valueName: ''
                }
                {
                  name: 'Registry_5'
                  groupTag: 'Recommended'
                  enabled: false
                  recurse: true
                  description: ''
                  keyName: 'HKEY_LOCAL_MACHINE\\Software\\Classes\\Directory\\ShellEx\\ContextMenuHandlers'
                  valueName: ''
                }
                {
                  name: 'Registry_6'
                  groupTag: 'Recommended'
                  enabled: false
                  recurse: true
                  description: ''
                  keyName: 'HKEY_LOCAL_MACHINE\\Software\\Classes\\Directory\\Background\\ShellEx\\ContextMenuHandlers'
                  valueName: ''
                }
                {
                  name: 'Registry_7'
                  groupTag: 'Recommended'
                  enabled: false
                  recurse: true
                  description: ''
                  keyName: 'HKEY_LOCAL_MACHINE\\Software\\Classes\\Directory\\Shellex\\CopyHookHandlers'
                  valueName: ''
                }
                {
                  name: 'Registry_8'
                  groupTag: 'Recommended'
                  enabled: false
                  recurse: true
                  description: ''
                  keyName: 'HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\ShellIconOverlayIdentifiers'
                  valueName: ''
                }
                {
                  name: 'Registry_9'
                  groupTag: 'Recommended'
                  enabled: false
                  recurse: true
                  description: ''
                  keyName: 'HKEY_LOCAL_MACHINE\\Software\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Explorer\\ShellIconOverlayIdentifiers'
                  valueName: ''
                }
                {
                  name: 'Registry_10'
                  groupTag: 'Recommended'
                  enabled: false
                  recurse: true
                  description: ''
                  keyName: 'HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Browser Helper Objects'
                  valueName: ''
                }
                {
                  name: 'Registry_11'
                  groupTag: 'Recommended'
                  enabled: false
                  recurse: true
                  description: ''
                  keyName: 'HKEY_LOCAL_MACHINE\\Software\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Browser Helper Objects'
                  valueName: ''
                }
                {
                  name: 'Registry_12'
                  groupTag: 'Recommended'
                  enabled: false
                  recurse: true
                  description: ''
                  keyName: 'HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Internet Explorer\\Extensions'
                  valueName: ''
                }
                {
                  name: 'Registry_13'
                  groupTag: 'Recommended'
                  enabled: false
                  recurse: true
                  description: ''
                  keyName: 'HKEY_LOCAL_MACHINE\\Software\\Wow6432Node\\Microsoft\\Internet Explorer\\Extensions'
                  valueName: ''
                }
                {
                  name: 'Registry_14'
                  groupTag: 'Recommended'
                  enabled: false
                  recurse: true
                  description: ''
                  keyName: 'HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows NT\\CurrentVersion\\Drivers32'
                  valueName: ''
                }
                {
                  name: 'Registry_15'
                  groupTag: 'Recommended'
                  enabled: false
                  recurse: true
                  description: ''
                  keyName: 'HKEY_LOCAL_MACHINE\\Software\\Wow6432Node\\Microsoft\\Windows NT\\CurrentVersion\\Drivers32'
                  valueName: ''
                }
                {
                  name: 'Registry_16'
                  groupTag: 'Recommended'
                  enabled: false
                  recurse: true
                  description: ''
                  keyName: 'HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Session Manager\\KnownDlls'
                  valueName: ''
                }
                {
                  name: 'Registry_17'
                  groupTag: 'Recommended'
                  enabled: false
                  recurse: true
                  description: ''
                  keyName: 'HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon\\Notify'
                  valueName: ''
                }
              ]
            }
            fileSettings: {
              fileCollectionFrequency: 2700
            }
            softwareSettings: {
              softwareCollectionFrequency: 1800
            }
            inventorySettings: {
              inventoryCollectionFrequency: 36000
            }
            serviceSettings: {
              serviceCollectionFrequency: 1800
            }
          }
          name: 'CTDataSource-Windows'
        }
        {
          streams: [
            'Microsoft-ConfigurationChange'
            'Microsoft-ConfigurationChangeV2'
            'Microsoft-ConfigurationData'
          ]
          extensionName: 'ChangeTracking-Linux'
          extensionSettings: {
            enableFiles: true
            enableSoftware: true
            enableRegistry: false
            enableServices: true
            enableInventory: true
            fileSettings: {
              fileCollectionFrequency: 900
              fileInfo: [
                {
                  name: 'ChangeTrackingLinuxPath_default'
                  enabled: true
                  destinationPath: '/etc/.*.conf'
                  useSudo: true
                  recurse: true
                  maxContentsReturnable: 5000000
                  pathType: 'File'
                  type: 'File'
                  links: 'Follow'
                  maxOutputSize: 500000
                  groupTag: 'Recommended'
                }
              ]
            }
            softwareSettings: {
              softwareCollectionFrequency: 300
            }
            inventorySettings: {
              inventoryCollectionFrequency: 36000
            }
            serviceSettings: {
              serviceCollectionFrequency: 300
            }
          }
          name: 'CTDataSource-Linux'
        }
      ]
    }
    destinations: {
      logAnalytics: [
        {
          workspaceResourceId: logAnalyticsWorkspaceResourceId
          name: 'Microsoft-CT-Dest'
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          'Microsoft-ConfigurationChange'
          'Microsoft-ConfigurationChangeV2'
          'Microsoft-ConfigurationData'
        ]
        destinations: [
          'Microsoft-CT-Dest'
        ]
      }
    ]
  }
}

resource dataCollectionRuleChangeTrackingLock 'Microsoft.Authorization/locks@2020-05-01' = if (lockConfig.?kind != 'None' && !(empty(lockConfig.?name))) {
  scope: dataCollectionRuleChangeTracking
  name: lockConfig.?name ?? '${dataCollectionRuleChangeTracking.name}-lock'
  properties: {
    level: lockConfig.?kind ?? 'ReadOnly'
  }
}

#disable-next-line use-recent-api-versions
resource resDataCollectionRuleMDFCSQL 'Microsoft.Insights/dataCollectionRules@2021-04-01' = {
  name: dataCollectionRuleMDFCSQLName
  location: location
  tags: tags
  properties: {
    description: 'Data collection rule for Defender for SQL.'
    dataSources: {
      extensions: [
        {
          extensionName: 'MicrosoftDefenderForSQL'
          name: 'MicrosoftDefenderForSQL'
          streams: [
            'Microsoft-DefenderForSqlAlerts'
            'Microsoft-DefenderForSqlLogins'
            'Microsoft-DefenderForSqlTelemetry'
            'Microsoft-DefenderForSqlScanEvents'
            'Microsoft-DefenderForSqlScanResults'
          ]
          extensionSettings: {
            enableCollectionOfSqlQueriesForSecurityResearch: true
          }
        }
      ]
    }
    destinations: {
      logAnalytics: [
        {
          workspaceResourceId: logAnalyticsWorkspaceResourceId
          name: 'Microsoft-DefenderForSQL-Dest'
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          'Microsoft-DefenderForSqlAlerts'
          'Microsoft-DefenderForSqlLogins'
          'Microsoft-DefenderForSqlTelemetry'
          'Microsoft-DefenderForSqlScanEvents'
          'Microsoft-DefenderForSqlScanResults'
        ]
        destinations: [
          'Microsoft-DefenderForSQL-Dest'
        ]
      }
    ]
  }
}

resource dataCollectionRuleMDFCSQLLock 'Microsoft.Authorization/locks@2020-05-01' = if (lockConfig.?kind != 'None' && !(empty(lockConfig.?name))) {
  scope: resDataCollectionRuleMDFCSQL
  name: lockConfig.?name ?? '${resDataCollectionRuleMDFCSQL.name}-lock'
  properties: {
    level: lockConfig.?kind ?? 'ReadOnly'
  }
}

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.alz-ama.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

// ============ //
// Outputs      //
// ============ //
@description('The resource ID of the User Assigned Managed Identity.')
output userAssignedManagedIdentityResourceId string = userAssignedManagedIdentity.outputs.resourceId

@description('The resource ID of the Data Collection Rule for VM Insights.')
output dataCollectionRuleVMInsightsResourceId string = dataCollectionRuleVMInsightsPerfAndMap.id

@description('The resource ID of the Data Collection Rule for Change Tracking.')
output dataCollectionRuleChangeTrackingResourceId string = dataCollectionRuleChangeTracking.id

@description('The resource ID of the Data Collection Rule for Microsoft Defender for SQL.')
output dataCollectionRuleMDFCSQLResourceId string = resDataCollectionRuleMDFCSQL.id

@description('The resource group the deployment script was deployed into.')
output resourceGroupName string = resourceGroup().name
