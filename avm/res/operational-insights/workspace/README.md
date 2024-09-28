# Log Analytics Workspaces `[Microsoft.OperationalInsights/workspaces]`

This module deploys a Log Analytics Workspace.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.OperationalInsights/workspaces` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2022-10-01/workspaces) |
| `Microsoft.OperationalInsights/workspaces/dataExports` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/dataExports) |
| `Microsoft.OperationalInsights/workspaces/dataSources` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/dataSources) |
| `Microsoft.OperationalInsights/workspaces/linkedServices` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/linkedServices) |
| `Microsoft.OperationalInsights/workspaces/linkedStorageAccounts` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/linkedStorageAccounts) |
| `Microsoft.OperationalInsights/workspaces/savedSearches` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/savedSearches) |
| `Microsoft.OperationalInsights/workspaces/storageInsightConfigs` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/storageInsightConfigs) |
| `Microsoft.OperationalInsights/workspaces/tables` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2022-10-01/workspaces/tables) |
| `Microsoft.OperationsManagement/solutions` | [2015-11-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationsManagement/2015-11-01-preview/solutions) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/operational-insights/workspace:<version>`.

- [Advanced features](#example-1-advanced-features)
- [Using only defaults](#example-2-using-only-defaults)
- [Using large parameter set](#example-3-using-large-parameter-set)
- [WAF-aligned](#example-4-waf-aligned)

### Example 1: _Advanced features_

This instance deploys the module with advanced features like custom tables and data exports.


<details>

<summary>via Bicep module</summary>

```bicep
module workspace 'br/public:avm/res/operational-insights/workspace:<version>' = {
  name: 'workspaceDeployment'
  params: {
    // Required parameters
    name: 'oiwadv001'
    // Non-required parameters
    dailyQuotaGb: 10
    dataExports: [
      {
        destination: {
          metaData: {
            eventHubName: '<eventHubName>'
          }
          resourceId: '<resourceId>'
        }
        enable: true
        name: 'eventHubExport'
        tableNames: [
          'Alert'
          'InsightsMetrics'
        ]
      }
      {
        destination: {
          resourceId: '<resourceId>'
        }
        enable: true
        name: 'storageAccountExport'
        tableNames: [
          'Operation'
        ]
      }
    ]
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
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
      {
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'sendingDiagnosticSettingsToSelf'
        useThisWorkspace: true
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
        resourceId: '<resourceId>'
      }
    ]
    linkedStorageAccounts: [
      {
        name: 'Query'
        resourceId: '<resourceId>'
      }
    ]
    location: '<location>'
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    publicNetworkAccessForIngestion: 'Disabled'
    publicNetworkAccessForQuery: 'Disabled'
    savedSearches: [
      {
        category: 'VDC Saved Searches'
        displayName: 'VMSS Instance Count2'
        name: 'VMSSQueries'
        query: 'Event | where Source == ServiceFabricNodeBootstrapAgent | summarize AggregatedValue = count() by Computer'
      }
    ]
    storageInsightsConfigs: [
      {
        storageAccountResourceId: '<storageAccountResourceId>'
        tables: [
          'LinuxsyslogVer2v0'
          'WADETWEventTable'
          'WADServiceFabric*EventTable'
          'WADWindowsEventLogsTable'
        ]
      }
    ]
    tables: [
      {
        name: 'CustomTableBasic_CL'
        retentionInDays: 60
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Owner'
          }
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
          }
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
          }
        ]
        schema: {
          columns: [
            {
              name: 'TimeGenerated'
              type: 'DateTime'
            }
            {
              name: 'RawData'
              type: 'String'
            }
          ]
          name: 'CustomTableBasic_CL'
        }
        totalRetentionInDays: 90
      }
      {
        name: 'CustomTableAdvanced_CL'
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Owner'
          }
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
          }
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
          }
        ]
        schema: {
          columns: [
            {
              name: 'TimeGenerated'
              type: 'DateTime'
            }
            {
              name: 'EventTime'
              type: 'DateTime'
            }
            {
              name: 'EventLevel'
              type: 'String'
            }
            {
              name: 'EventCode'
              type: 'Int'
            }
            {
              name: 'Message'
              type: 'String'
            }
            {
              name: 'RawData'
              type: 'String'
            }
          ]
          name: 'CustomTableAdvanced_CL'
        }
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    useResourcePermissions: true
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "oiwadv001"
    },
    // Non-required parameters
    "dailyQuotaGb": {
      "value": 10
    },
    "dataExports": {
      "value": [
        {
          "destination": {
            "metaData": {
              "eventHubName": "<eventHubName>"
            },
            "resourceId": "<resourceId>"
          },
          "enable": true,
          "name": "eventHubExport",
          "tableNames": [
            "Alert",
            "InsightsMetrics"
          ]
        },
        {
          "destination": {
            "resourceId": "<resourceId>"
          },
          "enable": true,
          "name": "storageAccountExport",
          "tableNames": [
            "Operation"
          ]
        }
      ]
    },
    "dataSources": {
      "value": [
        {
          "eventLogName": "Application",
          "eventTypes": [
            {
              "eventType": "Error"
            },
            {
              "eventType": "Warning"
            },
            {
              "eventType": "Information"
            }
          ],
          "kind": "WindowsEvent",
          "name": "applicationEvent"
        },
        {
          "counterName": "% Processor Time",
          "instanceName": "*",
          "intervalSeconds": 60,
          "kind": "WindowsPerformanceCounter",
          "name": "windowsPerfCounter1",
          "objectName": "Processor"
        },
        {
          "kind": "IISLogs",
          "name": "sampleIISLog1",
          "state": "OnPremiseEnabled"
        },
        {
          "kind": "LinuxSyslog",
          "name": "sampleSyslog1",
          "syslogName": "kern",
          "syslogSeverities": [
            {
              "severity": "emerg"
            },
            {
              "severity": "alert"
            },
            {
              "severity": "crit"
            },
            {
              "severity": "err"
            },
            {
              "severity": "warning"
            }
          ]
        },
        {
          "kind": "LinuxSyslogCollection",
          "name": "sampleSyslogCollection1",
          "state": "Enabled"
        },
        {
          "instanceName": "*",
          "intervalSeconds": 10,
          "kind": "LinuxPerformanceObject",
          "name": "sampleLinuxPerf1",
          "objectName": "Logical Disk",
          "syslogSeverities": [
            {
              "counterName": "% Used Inodes"
            },
            {
              "counterName": "Free Megabytes"
            },
            {
              "counterName": "% Used Space"
            },
            {
              "counterName": "Disk Transfers/sec"
            },
            {
              "counterName": "Disk Reads/sec"
            },
            {
              "counterName": "Disk Writes/sec"
            }
          ]
        },
        {
          "kind": "LinuxPerformanceCollection",
          "name": "sampleLinuxPerfCollection1",
          "state": "Enabled"
        }
      ]
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "metricCategories": [
            {
              "category": "AllMetrics"
            }
          ],
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        },
        {
          "metricCategories": [
            {
              "category": "AllMetrics"
            }
          ],
          "name": "sendingDiagnosticSettingsToSelf",
          "useThisWorkspace": true
        }
      ]
    },
    "gallerySolutions": {
      "value": [
        {
          "name": "AzureAutomation",
          "product": "OMSGallery",
          "publisher": "Microsoft"
        }
      ]
    },
    "linkedServices": {
      "value": [
        {
          "name": "Automation",
          "resourceId": "<resourceId>"
        }
      ]
    },
    "linkedStorageAccounts": {
      "value": [
        {
          "name": "Query",
          "resourceId": "<resourceId>"
        }
      ]
    },
    "location": {
      "value": "<location>"
    },
    "managedIdentities": {
      "value": {
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "publicNetworkAccessForIngestion": {
      "value": "Disabled"
    },
    "publicNetworkAccessForQuery": {
      "value": "Disabled"
    },
    "savedSearches": {
      "value": [
        {
          "category": "VDC Saved Searches",
          "displayName": "VMSS Instance Count2",
          "name": "VMSSQueries",
          "query": "Event | where Source == ServiceFabricNodeBootstrapAgent | summarize AggregatedValue = count() by Computer"
        }
      ]
    },
    "storageInsightsConfigs": {
      "value": [
        {
          "storageAccountResourceId": "<storageAccountResourceId>",
          "tables": [
            "LinuxsyslogVer2v0",
            "WADETWEventTable",
            "WADServiceFabric*EventTable",
            "WADWindowsEventLogsTable"
          ]
        }
      ]
    },
    "tables": {
      "value": [
        {
          "name": "CustomTableBasic_CL",
          "retentionInDays": 60,
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Owner"
            },
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "b24988ac-6180-42a0-ab88-20f7382dd24c"
            },
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "<roleDefinitionIdOrName>"
            }
          ],
          "schema": {
            "columns": [
              {
                "name": "TimeGenerated",
                "type": "DateTime"
              },
              {
                "name": "RawData",
                "type": "String"
              }
            ],
            "name": "CustomTableBasic_CL"
          },
          "totalRetentionInDays": 90
        },
        {
          "name": "CustomTableAdvanced_CL",
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Owner"
            },
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "b24988ac-6180-42a0-ab88-20f7382dd24c"
            },
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "<roleDefinitionIdOrName>"
            }
          ],
          "schema": {
            "columns": [
              {
                "name": "TimeGenerated",
                "type": "DateTime"
              },
              {
                "name": "EventTime",
                "type": "DateTime"
              },
              {
                "name": "EventLevel",
                "type": "String"
              },
              {
                "name": "EventCode",
                "type": "Int"
              },
              {
                "name": "Message",
                "type": "String"
              },
              {
                "name": "RawData",
                "type": "String"
              }
            ],
            "name": "CustomTableAdvanced_CL"
          }
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "useResourcePermissions": {
      "value": true
    }
  }
}
```

</details>
<p>

### Example 2: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module workspace 'br/public:avm/res/operational-insights/workspace:<version>' = {
  name: 'workspaceDeployment'
  params: {
    // Required parameters
    name: 'oiwmin001'
    // Non-required parameters
    location: '<location>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "oiwmin001"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    }
  }
}
```

</details>
<p>

### Example 3: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module workspace 'br/public:avm/res/operational-insights/workspace:<version>' = {
  name: 'workspaceDeployment'
  params: {
    // Required parameters
    name: 'oiwmax001'
    // Non-required parameters
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
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
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
        resourceId: '<resourceId>'
      }
    ]
    linkedStorageAccounts: [
      {
        name: 'Query'
        resourceId: '<resourceId>'
      }
    ]
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    managedIdentities: {
      systemAssigned: true
    }
    publicNetworkAccessForIngestion: 'Disabled'
    publicNetworkAccessForQuery: 'Disabled'
    roleAssignments: [
      {
        name: 'c3d53092-840c-4025-9c02-9bcb7895789c'
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Owner'
      }
      {
        name: '<name>'
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
      }
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
      }
    ]
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
        storageAccountResourceId: '<storageAccountResourceId>'
        tables: [
          'LinuxsyslogVer2v0'
          'WADETWEventTable'
          'WADServiceFabric*EventTable'
          'WADWindowsEventLogsTable'
        ]
      }
    ]
    tables: [
      {
        name: 'CustomTableBasic_CL'
        retentionInDays: 60
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Owner'
          }
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
          }
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
          }
        ]
        schema: {
          columns: [
            {
              name: 'TimeGenerated'
              type: 'DateTime'
            }
            {
              name: 'RawData'
              type: 'String'
            }
          ]
          name: 'CustomTableBasic_CL'
        }
        totalRetentionInDays: 90
      }
      {
        name: 'CustomTableAdvanced_CL'
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Owner'
          }
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
          }
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
          }
        ]
        schema: {
          columns: [
            {
              name: 'TimeGenerated'
              type: 'DateTime'
            }
            {
              name: 'EventTime'
              type: 'DateTime'
            }
            {
              name: 'EventLevel'
              type: 'String'
            }
            {
              name: 'EventCode'
              type: 'Int'
            }
            {
              name: 'Message'
              type: 'String'
            }
            {
              name: 'RawData'
              type: 'String'
            }
          ]
          name: 'CustomTableAdvanced_CL'
        }
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    useResourcePermissions: true
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "oiwmax001"
    },
    // Non-required parameters
    "dailyQuotaGb": {
      "value": 10
    },
    "dataSources": {
      "value": [
        {
          "eventLogName": "Application",
          "eventTypes": [
            {
              "eventType": "Error"
            },
            {
              "eventType": "Warning"
            },
            {
              "eventType": "Information"
            }
          ],
          "kind": "WindowsEvent",
          "name": "applicationEvent"
        },
        {
          "counterName": "% Processor Time",
          "instanceName": "*",
          "intervalSeconds": 60,
          "kind": "WindowsPerformanceCounter",
          "name": "windowsPerfCounter1",
          "objectName": "Processor"
        },
        {
          "kind": "IISLogs",
          "name": "sampleIISLog1",
          "state": "OnPremiseEnabled"
        },
        {
          "kind": "LinuxSyslog",
          "name": "sampleSyslog1",
          "syslogName": "kern",
          "syslogSeverities": [
            {
              "severity": "emerg"
            },
            {
              "severity": "alert"
            },
            {
              "severity": "crit"
            },
            {
              "severity": "err"
            },
            {
              "severity": "warning"
            }
          ]
        },
        {
          "kind": "LinuxSyslogCollection",
          "name": "sampleSyslogCollection1",
          "state": "Enabled"
        },
        {
          "instanceName": "*",
          "intervalSeconds": 10,
          "kind": "LinuxPerformanceObject",
          "name": "sampleLinuxPerf1",
          "objectName": "Logical Disk",
          "syslogSeverities": [
            {
              "counterName": "% Used Inodes"
            },
            {
              "counterName": "Free Megabytes"
            },
            {
              "counterName": "% Used Space"
            },
            {
              "counterName": "Disk Transfers/sec"
            },
            {
              "counterName": "Disk Reads/sec"
            },
            {
              "counterName": "Disk Writes/sec"
            }
          ]
        },
        {
          "kind": "LinuxPerformanceCollection",
          "name": "sampleLinuxPerfCollection1",
          "state": "Enabled"
        }
      ]
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "metricCategories": [
            {
              "category": "AllMetrics"
            }
          ],
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "gallerySolutions": {
      "value": [
        {
          "name": "AzureAutomation",
          "product": "OMSGallery",
          "publisher": "Microsoft"
        }
      ]
    },
    "linkedServices": {
      "value": [
        {
          "name": "Automation",
          "resourceId": "<resourceId>"
        }
      ]
    },
    "linkedStorageAccounts": {
      "value": [
        {
          "name": "Query",
          "resourceId": "<resourceId>"
        }
      ]
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": true
      }
    },
    "publicNetworkAccessForIngestion": {
      "value": "Disabled"
    },
    "publicNetworkAccessForQuery": {
      "value": "Disabled"
    },
    "roleAssignments": {
      "value": [
        {
          "name": "c3d53092-840c-4025-9c02-9bcb7895789c",
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Owner"
        },
        {
          "name": "<name>",
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "b24988ac-6180-42a0-ab88-20f7382dd24c"
        },
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "<roleDefinitionIdOrName>"
        }
      ]
    },
    "savedSearches": {
      "value": [
        {
          "category": "VDC Saved Searches",
          "displayName": "VMSS Instance Count2",
          "name": "VMSSQueries",
          "query": "Event | where Source == ServiceFabricNodeBootstrapAgent | summarize AggregatedValue = count() by Computer",
          "tags": [
            {
              "Name": "Environment",
              "Value": "Non-Prod"
            },
            {
              "Name": "Role",
              "Value": "DeploymentValidation"
            }
          ]
        }
      ]
    },
    "storageInsightsConfigs": {
      "value": [
        {
          "storageAccountResourceId": "<storageAccountResourceId>",
          "tables": [
            "LinuxsyslogVer2v0",
            "WADETWEventTable",
            "WADServiceFabric*EventTable",
            "WADWindowsEventLogsTable"
          ]
        }
      ]
    },
    "tables": {
      "value": [
        {
          "name": "CustomTableBasic_CL",
          "retentionInDays": 60,
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Owner"
            },
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "b24988ac-6180-42a0-ab88-20f7382dd24c"
            },
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "<roleDefinitionIdOrName>"
            }
          ],
          "schema": {
            "columns": [
              {
                "name": "TimeGenerated",
                "type": "DateTime"
              },
              {
                "name": "RawData",
                "type": "String"
              }
            ],
            "name": "CustomTableBasic_CL"
          },
          "totalRetentionInDays": 90
        },
        {
          "name": "CustomTableAdvanced_CL",
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Owner"
            },
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "b24988ac-6180-42a0-ab88-20f7382dd24c"
            },
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "<roleDefinitionIdOrName>"
            }
          ],
          "schema": {
            "columns": [
              {
                "name": "TimeGenerated",
                "type": "DateTime"
              },
              {
                "name": "EventTime",
                "type": "DateTime"
              },
              {
                "name": "EventLevel",
                "type": "String"
              },
              {
                "name": "EventCode",
                "type": "Int"
              },
              {
                "name": "Message",
                "type": "String"
              },
              {
                "name": "RawData",
                "type": "String"
              }
            ],
            "name": "CustomTableAdvanced_CL"
          }
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "useResourcePermissions": {
      "value": true
    }
  }
}
```

</details>
<p>

### Example 4: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module workspace 'br/public:avm/res/operational-insights/workspace:<version>' = {
  name: 'workspaceDeployment'
  params: {
    // Required parameters
    name: 'oiwwaf001'
    // Non-required parameters
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
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
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
        resourceId: '<resourceId>'
      }
    ]
    linkedStorageAccounts: [
      {
        name: 'Query'
        resourceId: '<resourceId>'
      }
    ]
    location: '<location>'
    managedIdentities: {
      systemAssigned: true
    }
    publicNetworkAccessForIngestion: 'Disabled'
    publicNetworkAccessForQuery: 'Disabled'
    storageInsightsConfigs: [
      {
        storageAccountResourceId: '<storageAccountResourceId>'
        tables: [
          'LinuxsyslogVer2v0'
          'WADETWEventTable'
          'WADServiceFabric*EventTable'
          'WADWindowsEventLogsTable'
        ]
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    useResourcePermissions: true
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "oiwwaf001"
    },
    // Non-required parameters
    "dailyQuotaGb": {
      "value": 10
    },
    "dataSources": {
      "value": [
        {
          "eventLogName": "Application",
          "eventTypes": [
            {
              "eventType": "Error"
            },
            {
              "eventType": "Warning"
            },
            {
              "eventType": "Information"
            }
          ],
          "kind": "WindowsEvent",
          "name": "applicationEvent"
        },
        {
          "counterName": "% Processor Time",
          "instanceName": "*",
          "intervalSeconds": 60,
          "kind": "WindowsPerformanceCounter",
          "name": "windowsPerfCounter1",
          "objectName": "Processor"
        },
        {
          "kind": "IISLogs",
          "name": "sampleIISLog1",
          "state": "OnPremiseEnabled"
        },
        {
          "kind": "LinuxSyslog",
          "name": "sampleSyslog1",
          "syslogName": "kern",
          "syslogSeverities": [
            {
              "severity": "emerg"
            },
            {
              "severity": "alert"
            },
            {
              "severity": "crit"
            },
            {
              "severity": "err"
            },
            {
              "severity": "warning"
            }
          ]
        },
        {
          "kind": "LinuxSyslogCollection",
          "name": "sampleSyslogCollection1",
          "state": "Enabled"
        },
        {
          "instanceName": "*",
          "intervalSeconds": 10,
          "kind": "LinuxPerformanceObject",
          "name": "sampleLinuxPerf1",
          "objectName": "Logical Disk",
          "syslogSeverities": [
            {
              "counterName": "% Used Inodes"
            },
            {
              "counterName": "Free Megabytes"
            },
            {
              "counterName": "% Used Space"
            },
            {
              "counterName": "Disk Transfers/sec"
            },
            {
              "counterName": "Disk Reads/sec"
            },
            {
              "counterName": "Disk Writes/sec"
            }
          ]
        },
        {
          "kind": "LinuxPerformanceCollection",
          "name": "sampleLinuxPerfCollection1",
          "state": "Enabled"
        }
      ]
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "gallerySolutions": {
      "value": [
        {
          "name": "AzureAutomation",
          "product": "OMSGallery",
          "publisher": "Microsoft"
        }
      ]
    },
    "linkedServices": {
      "value": [
        {
          "name": "Automation",
          "resourceId": "<resourceId>"
        }
      ]
    },
    "linkedStorageAccounts": {
      "value": [
        {
          "name": "Query",
          "resourceId": "<resourceId>"
        }
      ]
    },
    "location": {
      "value": "<location>"
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": true
      }
    },
    "publicNetworkAccessForIngestion": {
      "value": "Disabled"
    },
    "publicNetworkAccessForQuery": {
      "value": "Disabled"
    },
    "storageInsightsConfigs": {
      "value": [
        {
          "storageAccountResourceId": "<storageAccountResourceId>",
          "tables": [
            "LinuxsyslogVer2v0",
            "WADETWEventTable",
            "WADServiceFabric*EventTable",
            "WADWindowsEventLogsTable"
          ]
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "useResourcePermissions": {
      "value": true
    }
  }
}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Log Analytics workspace. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`linkedStorageAccounts`](#parameter-linkedstorageaccounts) | array | List of Storage Accounts to be linked. Required if 'forceCmkForQuery' is set to 'true' and 'savedSearches' is not empty. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dailyQuotaGb`](#parameter-dailyquotagb) | int | The workspace daily quota for ingestion. |
| [`dataExports`](#parameter-dataexports) | array | LAW data export instances to be deployed. |
| [`dataRetention`](#parameter-dataretention) | int | Number of days data will be retained for. |
| [`dataSources`](#parameter-datasources) | array | LAW data sources to configure. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`forceCmkForQuery`](#parameter-forcecmkforquery) | bool | Indicates whether customer managed storage is mandatory for query management. |
| [`gallerySolutions`](#parameter-gallerysolutions) | array | List of gallerySolutions to be created in the log analytics workspace. |
| [`linkedServices`](#parameter-linkedservices) | array | List of services to be linked. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. Only one type of identity is supported: system-assigned or user-assigned, but not both. |
| [`publicNetworkAccessForIngestion`](#parameter-publicnetworkaccessforingestion) | string | The network access type for accessing Log Analytics ingestion. |
| [`publicNetworkAccessForQuery`](#parameter-publicnetworkaccessforquery) | string | The network access type for accessing Log Analytics query. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`savedSearches`](#parameter-savedsearches) | array | Kusto Query Language searches to save. |
| [`skuCapacityReservationLevel`](#parameter-skucapacityreservationlevel) | int | The capacity reservation level in GB for this workspace, when CapacityReservation sku is selected. Must be in increments of 100 between 100 and 5000. |
| [`skuName`](#parameter-skuname) | string | The name of the SKU. |
| [`storageInsightsConfigs`](#parameter-storageinsightsconfigs) | array | List of storage accounts to be read by the workspace. |
| [`tables`](#parameter-tables) | array | LAW custom tables to be deployed. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`useResourcePermissions`](#parameter-useresourcepermissions) | bool | Set to 'true' to use resource or workspace permissions and 'false' (or leave empty) to require workspace permissions. |

### Parameter: `name`

Name of the Log Analytics workspace.

- Required: Yes
- Type: string

### Parameter: `linkedStorageAccounts`

List of Storage Accounts to be linked. Required if 'forceCmkForQuery' is set to 'true' and 'savedSearches' is not empty.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `dailyQuotaGb`

The workspace daily quota for ingestion.

- Required: No
- Type: int
- Default: `-1`

### Parameter: `dataExports`

LAW data export instances to be deployed.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `dataRetention`

Number of days data will be retained for.

- Required: No
- Type: int
- Default: `365`

### Parameter: `dataSources`

LAW data sources to configure.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `diagnosticSettings`

The diagnostic settings of the service.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-diagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-diagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-diagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-diagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-diagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-diagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-diagnosticsettingsname) | string | The name of diagnostic setting. |
| [`storageAccountResourceId`](#parameter-diagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`useThisWorkspace`](#parameter-diagnosticsettingsusethisworkspace) | bool | Instead of using an external reference, use the deployed instance as the target for its diagnostic settings. If set to `true`, the `workspaceResourceId` property is ignored. |
| [`workspaceResourceId`](#parameter-diagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logAnalyticsDestinationType`

A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureDiagnostics'
    'Dedicated'
  ]
  ```

### Parameter: `diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-diagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-diagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-diagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-diagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-diagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `diagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `diagnosticSettings.name`

The name of diagnostic setting.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.useThisWorkspace`

Instead of using an external reference, use the deployed instance as the target for its diagnostic settings. If set to `true`, the `workspaceResourceId` property is ignored.

- Required: No
- Type: bool

### Parameter: `diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `forceCmkForQuery`

Indicates whether customer managed storage is mandatory for query management.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `gallerySolutions`

List of gallerySolutions to be created in the log analytics workspace.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `linkedServices`

List of services to be linked.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

The lock settings of the service.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-lockkind) | string | Specify the type of lock. |
| [`name`](#parameter-lockname) | string | Specify the name of lock. |

### Parameter: `lock.kind`

Specify the type of lock.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'CanNotDelete'
    'None'
    'ReadOnly'
  ]
  ```

### Parameter: `lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `managedIdentities`

The managed identity definition for this resource. Only one type of identity is supported: system-assigned or user-assigned, but not both.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`systemAssigned`](#parameter-managedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. |
| [`userAssignedResourceIds`](#parameter-managedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. |

### Parameter: `managedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource.

- Required: No
- Type: array

### Parameter: `publicNetworkAccessForIngestion`

The network access type for accessing Log Analytics ingestion.

- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `publicNetworkAccessForQuery`

The network access type for accessing Log Analytics query.

- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Log Analytics Contributor'`
  - `'Log Analytics Reader'`
  - `'Monitoring Contributor'`
  - `'Monitoring Reader'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'Security Admin'`
  - `'Security Reader'`
  - `'User Access Administrator'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-roleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-roleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-roleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `roleAssignments.principalType`

The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Device'
    'ForeignGroup'
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `savedSearches`

Kusto Query Language searches to save.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `skuCapacityReservationLevel`

The capacity reservation level in GB for this workspace, when CapacityReservation sku is selected. Must be in increments of 100 between 100 and 5000.

- Required: No
- Type: int
- Default: `100`

### Parameter: `skuName`

The name of the SKU.

- Required: No
- Type: string
- Default: `'PerGB2018'`
- Allowed:
  ```Bicep
  [
    'CapacityReservation'
    'Free'
    'LACluster'
    'PerGB2018'
    'PerNode'
    'Premium'
    'Standalone'
    'Standard'
  ]
  ```

### Parameter: `storageInsightsConfigs`

List of storage accounts to be read by the workspace.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `tables`

LAW custom tables to be deployed.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `useResourcePermissions`

Set to 'true' to use resource or workspace permissions and 'false' (or leave empty) to require workspace permissions.

- Required: No
- Type: bool
- Default: `False`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `logAnalyticsWorkspaceId` | string | The ID associated with the workspace. |
| `name` | string | The name of the deployed log analytics workspace. |
| `resourceGroupName` | string | The resource group of the deployed log analytics workspace. |
| `resourceId` | string | The resource ID of the deployed log analytics workspace. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/operations-management/solution:0.1.0` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
