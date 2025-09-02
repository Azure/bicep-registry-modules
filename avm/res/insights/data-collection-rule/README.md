# Data Collection Rules `[Microsoft.Insights/dataCollectionRules]`

This module deploys a Data Collection Rule.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Authorization/locks` | 2020-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_locks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks)</li></ul> |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |
| `Microsoft.Insights/dataCollectionRules` | 2023-03-11 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_datacollectionrules.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2023-03-11/dataCollectionRules)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/insights/data-collection-rule:<version>`.

- [Agent Settings](#example-1-agent-settings)
- [Collecting custom text logs with ingestion-time transformation](#example-2-collecting-custom-text-logs-with-ingestion-time-transformation)
- [Collecting custom text logs](#example-3-collecting-custom-text-logs)
- [Collecting IIS logs](#example-4-collecting-iis-logs)
- [Using only defaults](#example-5-using-only-defaults)
- [Send data to Azure Monitor Logs with Logs ingestion API](#example-6-send-data-to-azure-monitor-logs-with-logs-ingestion-api)
- [Collecting Linux-specific information](#example-7-collecting-linux-specific-information)
- [Using large parameter set](#example-8-using-large-parameter-set)
- [WAF-aligned](#example-9-waf-aligned)
- [Collecting Windows-specific information](#example-10-collecting-windows-specific-information)

### Example 1: _Agent Settings_

This instance deploys the module AMA (Azure Monitor Agent) Settings DCR.


<details>

<summary>via Bicep module</summary>

```bicep
module dataCollectionRule 'br/public:avm/res/insights/data-collection-rule:<version>' = {
  name: 'dataCollectionRuleDeployment'
  params: {
    // Required parameters
    dataCollectionRuleProperties: {
      agentSettings: {
        logs: [
          {
            name: 'MaxDiskQuotaInMB'
            value: '5000'
          }
        ]
      }
      description: 'Agent Settings'
      kind: 'AgentSettings'
    }
    name: 'idcrags001'
    // Non-required parameters
    location: '<location>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "dataCollectionRuleProperties": {
      "value": {
        "agentSettings": {
          "logs": [
            {
              "name": "MaxDiskQuotaInMB",
              "value": "5000"
            }
          ]
        },
        "description": "Agent Settings",
        "kind": "AgentSettings"
      }
    },
    "name": {
      "value": "idcrags001"
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/insights/data-collection-rule:<version>'

// Required parameters
param dataCollectionRuleProperties = {
  agentSettings: {
    logs: [
      {
        name: 'MaxDiskQuotaInMB'
        value: '5000'
      }
    ]
  }
  description: 'Agent Settings'
  kind: 'AgentSettings'
}
param name = 'idcrags001'
// Non-required parameters
param location = '<location>'
```

</details>
<p>

### Example 2: _Collecting custom text logs with ingestion-time transformation_

This instance deploys the module to setup collection of custom logs and ingestion-time transformation.


<details>

<summary>via Bicep module</summary>

```bicep
module dataCollectionRule 'br/public:avm/res/insights/data-collection-rule:<version>' = {
  name: 'dataCollectionRuleDeployment'
  params: {
    // Required parameters
    dataCollectionRuleProperties: {
      dataCollectionEndpointResourceId: '<dataCollectionEndpointResourceId>'
      dataFlows: [
        {
          destinations: [
            '<logAnalyticsWorkspaceName>'
          ]
          outputStream: 'Custom-CustomTableAdvanced_CL'
          streams: [
            'Custom-CustomTableAdvanced_CL'
          ]
          transformKql: 'source | extend LogFields = split(RawData, \',\') | extend EventTime = todatetime(LogFields[0]) | extend EventLevel = tostring(LogFields[1]) | extend EventCode = toint(LogFields[2]) | extend Message = tostring(LogFields[3]) | project TimeGenerated, EventTime, EventLevel, EventCode, Message'
        }
      ]
      dataSources: {
        logFiles: [
          {
            filePatterns: [
              'C:\\TestLogsAdvanced\\TestLog*.log'
            ]
            format: 'text'
            name: 'CustomTableAdvanced_CL'
            samplingFrequencyInSeconds: 60
            settings: {
              text: {
                recordStartTimestampFormat: 'ISO 8601'
              }
            }
            streams: [
              'Custom-CustomTableAdvanced_CL'
            ]
          }
        ]
      }
      description: 'Collecting custom text logs with ingestion-time transformation to columns. Expected format of a log line (comma separated values): \'<DateTime>,<EventLevel>,<EventCode>,<Message>\', for example: \'2023-01-25T20:15:05Z,ERROR,404,Page not found\''
      destinations: {
        logAnalytics: [
          {
            name: '<name>'
            workspaceResourceId: '<workspaceResourceId>'
          }
        ]
      }
      kind: 'Windows'
      streamDeclarations: {
        'Custom-CustomTableAdvanced_CL': {
          columns: [
            {
              name: 'TimeGenerated'
              type: 'datetime'
            }
            {
              name: 'EventTime'
              type: 'datetime'
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
      }
    }
    name: 'idcrcusadv001'
    // Non-required parameters
    location: '<location>'
    managedIdentities: {
      systemAssigned: true
    }
    tags: {
      'hidden-title': 'This is visible in the resource name'
      kind: 'Windows'
      resourceType: 'Data Collection Rules'
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "dataCollectionRuleProperties": {
      "value": {
        "dataCollectionEndpointResourceId": "<dataCollectionEndpointResourceId>",
        "dataFlows": [
          {
            "destinations": [
              "<logAnalyticsWorkspaceName>"
            ],
            "outputStream": "Custom-CustomTableAdvanced_CL",
            "streams": [
              "Custom-CustomTableAdvanced_CL"
            ],
            "transformKql": "source | extend LogFields = split(RawData, \",\") | extend EventTime = todatetime(LogFields[0]) | extend EventLevel = tostring(LogFields[1]) | extend EventCode = toint(LogFields[2]) | extend Message = tostring(LogFields[3]) | project TimeGenerated, EventTime, EventLevel, EventCode, Message"
          }
        ],
        "dataSources": {
          "logFiles": [
            {
              "filePatterns": [
                "C:\\TestLogsAdvanced\\TestLog*.log"
              ],
              "format": "text",
              "name": "CustomTableAdvanced_CL",
              "samplingFrequencyInSeconds": 60,
              "settings": {
                "text": {
                  "recordStartTimestampFormat": "ISO 8601"
                }
              },
              "streams": [
                "Custom-CustomTableAdvanced_CL"
              ]
            }
          ]
        },
        "description": "Collecting custom text logs with ingestion-time transformation to columns. Expected format of a log line (comma separated values): \"<DateTime>,<EventLevel>,<EventCode>,<Message>\", for example: \"2023-01-25T20:15:05Z,ERROR,404,Page not found\"",
        "destinations": {
          "logAnalytics": [
            {
              "name": "<name>",
              "workspaceResourceId": "<workspaceResourceId>"
            }
          ]
        },
        "kind": "Windows",
        "streamDeclarations": {
          "Custom-CustomTableAdvanced_CL": {
            "columns": [
              {
                "name": "TimeGenerated",
                "type": "datetime"
              },
              {
                "name": "EventTime",
                "type": "datetime"
              },
              {
                "name": "EventLevel",
                "type": "string"
              },
              {
                "name": "EventCode",
                "type": "int"
              },
              {
                "name": "Message",
                "type": "string"
              },
              {
                "name": "RawData",
                "type": "string"
              }
            ]
          }
        }
      }
    },
    "name": {
      "value": "idcrcusadv001"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": true
      }
    },
    "tags": {
      "value": {
        "hidden-title": "This is visible in the resource name",
        "kind": "Windows",
        "resourceType": "Data Collection Rules"
      }
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/insights/data-collection-rule:<version>'

// Required parameters
param dataCollectionRuleProperties = {
  dataCollectionEndpointResourceId: '<dataCollectionEndpointResourceId>'
  dataFlows: [
    {
      destinations: [
        '<logAnalyticsWorkspaceName>'
      ]
      outputStream: 'Custom-CustomTableAdvanced_CL'
      streams: [
        'Custom-CustomTableAdvanced_CL'
      ]
      transformKql: 'source | extend LogFields = split(RawData, \',\') | extend EventTime = todatetime(LogFields[0]) | extend EventLevel = tostring(LogFields[1]) | extend EventCode = toint(LogFields[2]) | extend Message = tostring(LogFields[3]) | project TimeGenerated, EventTime, EventLevel, EventCode, Message'
    }
  ]
  dataSources: {
    logFiles: [
      {
        filePatterns: [
          'C:\\TestLogsAdvanced\\TestLog*.log'
        ]
        format: 'text'
        name: 'CustomTableAdvanced_CL'
        samplingFrequencyInSeconds: 60
        settings: {
          text: {
            recordStartTimestampFormat: 'ISO 8601'
          }
        }
        streams: [
          'Custom-CustomTableAdvanced_CL'
        ]
      }
    ]
  }
  description: 'Collecting custom text logs with ingestion-time transformation to columns. Expected format of a log line (comma separated values): \'<DateTime>,<EventLevel>,<EventCode>,<Message>\', for example: \'2023-01-25T20:15:05Z,ERROR,404,Page not found\''
  destinations: {
    logAnalytics: [
      {
        name: '<name>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
  }
  kind: 'Windows'
  streamDeclarations: {
    'Custom-CustomTableAdvanced_CL': {
      columns: [
        {
          name: 'TimeGenerated'
          type: 'datetime'
        }
        {
          name: 'EventTime'
          type: 'datetime'
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
  }
}
param name = 'idcrcusadv001'
// Non-required parameters
param location = '<location>'
param managedIdentities = {
  systemAssigned: true
}
param tags = {
  'hidden-title': 'This is visible in the resource name'
  kind: 'Windows'
  resourceType: 'Data Collection Rules'
}
```

</details>
<p>

### Example 3: _Collecting custom text logs_

This instance deploys the module to setup collection of custom logs.


<details>

<summary>via Bicep module</summary>

```bicep
module dataCollectionRule 'br/public:avm/res/insights/data-collection-rule:<version>' = {
  name: 'dataCollectionRuleDeployment'
  params: {
    // Required parameters
    dataCollectionRuleProperties: {
      dataCollectionEndpointResourceId: '<dataCollectionEndpointResourceId>'
      dataFlows: [
        {
          destinations: [
            '<logAnalyticsWorkspaceName>'
          ]
          outputStream: 'Custom-CustomTableBasic_CL'
          streams: [
            'Custom-CustomTableBasic_CL'
          ]
          transformKql: 'source'
        }
      ]
      dataSources: {
        logFiles: [
          {
            filePatterns: [
              'C:\\TestLogsBasic\\TestLog*.log'
            ]
            format: 'text'
            name: 'CustomTableBasic_CL'
            samplingFrequencyInSeconds: 60
            settings: {
              text: {
                recordStartTimestampFormat: 'ISO 8601'
              }
            }
            streams: [
              'Custom-CustomTableBasic_CL'
            ]
          }
        ]
      }
      description: 'Collecting custom text logs without ingestion-time transformation.'
      destinations: {
        logAnalytics: [
          {
            name: '<name>'
            workspaceResourceId: '<workspaceResourceId>'
          }
        ]
      }
      kind: 'All'
      streamDeclarations: {
        'Custom-CustomTableBasic_CL': {
          columns: [
            {
              name: 'TimeGenerated'
              type: 'datetime'
            }
            {
              name: 'RawData'
              type: 'string'
            }
          ]
        }
      }
    }
    name: 'idcrcusbas001'
    // Non-required parameters
    location: '<location>'
    tags: {
      'hidden-title': 'This is visible in the resource name'
      kind: 'Windows'
      resourceType: 'Data Collection Rules'
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "dataCollectionRuleProperties": {
      "value": {
        "dataCollectionEndpointResourceId": "<dataCollectionEndpointResourceId>",
        "dataFlows": [
          {
            "destinations": [
              "<logAnalyticsWorkspaceName>"
            ],
            "outputStream": "Custom-CustomTableBasic_CL",
            "streams": [
              "Custom-CustomTableBasic_CL"
            ],
            "transformKql": "source"
          }
        ],
        "dataSources": {
          "logFiles": [
            {
              "filePatterns": [
                "C:\\TestLogsBasic\\TestLog*.log"
              ],
              "format": "text",
              "name": "CustomTableBasic_CL",
              "samplingFrequencyInSeconds": 60,
              "settings": {
                "text": {
                  "recordStartTimestampFormat": "ISO 8601"
                }
              },
              "streams": [
                "Custom-CustomTableBasic_CL"
              ]
            }
          ]
        },
        "description": "Collecting custom text logs without ingestion-time transformation.",
        "destinations": {
          "logAnalytics": [
            {
              "name": "<name>",
              "workspaceResourceId": "<workspaceResourceId>"
            }
          ]
        },
        "kind": "All",
        "streamDeclarations": {
          "Custom-CustomTableBasic_CL": {
            "columns": [
              {
                "name": "TimeGenerated",
                "type": "datetime"
              },
              {
                "name": "RawData",
                "type": "string"
              }
            ]
          }
        }
      }
    },
    "name": {
      "value": "idcrcusbas001"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "tags": {
      "value": {
        "hidden-title": "This is visible in the resource name",
        "kind": "Windows",
        "resourceType": "Data Collection Rules"
      }
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/insights/data-collection-rule:<version>'

// Required parameters
param dataCollectionRuleProperties = {
  dataCollectionEndpointResourceId: '<dataCollectionEndpointResourceId>'
  dataFlows: [
    {
      destinations: [
        '<logAnalyticsWorkspaceName>'
      ]
      outputStream: 'Custom-CustomTableBasic_CL'
      streams: [
        'Custom-CustomTableBasic_CL'
      ]
      transformKql: 'source'
    }
  ]
  dataSources: {
    logFiles: [
      {
        filePatterns: [
          'C:\\TestLogsBasic\\TestLog*.log'
        ]
        format: 'text'
        name: 'CustomTableBasic_CL'
        samplingFrequencyInSeconds: 60
        settings: {
          text: {
            recordStartTimestampFormat: 'ISO 8601'
          }
        }
        streams: [
          'Custom-CustomTableBasic_CL'
        ]
      }
    ]
  }
  description: 'Collecting custom text logs without ingestion-time transformation.'
  destinations: {
    logAnalytics: [
      {
        name: '<name>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
  }
  kind: 'All'
  streamDeclarations: {
    'Custom-CustomTableBasic_CL': {
      columns: [
        {
          name: 'TimeGenerated'
          type: 'datetime'
        }
        {
          name: 'RawData'
          type: 'string'
        }
      ]
    }
  }
}
param name = 'idcrcusbas001'
// Non-required parameters
param location = '<location>'
param tags = {
  'hidden-title': 'This is visible in the resource name'
  kind: 'Windows'
  resourceType: 'Data Collection Rules'
}
```

</details>
<p>

### Example 4: _Collecting IIS logs_

This instance deploys the module to setup the collection of IIS logs.


<details>

<summary>via Bicep module</summary>

```bicep
module dataCollectionRule 'br/public:avm/res/insights/data-collection-rule:<version>' = {
  name: 'dataCollectionRuleDeployment'
  params: {
    // Required parameters
    dataCollectionRuleProperties: {
      dataCollectionEndpointResourceId: '<dataCollectionEndpointResourceId>'
      dataFlows: [
        {
          destinations: [
            '<logAnalyticsWorkspaceName>'
          ]
          outputStream: 'Microsoft-W3CIISLog'
          streams: [
            'Microsoft-W3CIISLog'
          ]
          transformKql: 'source'
        }
      ]
      dataSources: {
        iisLogs: [
          {
            logDirectories: [
              'C:\\inetpub\\logs\\LogFiles\\W3SVC1'
            ]
            name: 'iisLogsDataSource'
            streams: [
              'Microsoft-W3CIISLog'
            ]
          }
        ]
      }
      description: 'Collecting IIS logs.'
      destinations: {
        logAnalytics: [
          {
            name: '<name>'
            workspaceResourceId: '<workspaceResourceId>'
          }
        ]
      }
      kind: 'Windows'
    }
    name: 'idcrcusiis001'
    // Non-required parameters
    location: '<location>'
    tags: {
      'hidden-title': 'This is visible in the resource name'
      kind: 'Windows'
      resourceType: 'Data Collection Rules'
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "dataCollectionRuleProperties": {
      "value": {
        "dataCollectionEndpointResourceId": "<dataCollectionEndpointResourceId>",
        "dataFlows": [
          {
            "destinations": [
              "<logAnalyticsWorkspaceName>"
            ],
            "outputStream": "Microsoft-W3CIISLog",
            "streams": [
              "Microsoft-W3CIISLog"
            ],
            "transformKql": "source"
          }
        ],
        "dataSources": {
          "iisLogs": [
            {
              "logDirectories": [
                "C:\\inetpub\\logs\\LogFiles\\W3SVC1"
              ],
              "name": "iisLogsDataSource",
              "streams": [
                "Microsoft-W3CIISLog"
              ]
            }
          ]
        },
        "description": "Collecting IIS logs.",
        "destinations": {
          "logAnalytics": [
            {
              "name": "<name>",
              "workspaceResourceId": "<workspaceResourceId>"
            }
          ]
        },
        "kind": "Windows"
      }
    },
    "name": {
      "value": "idcrcusiis001"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "tags": {
      "value": {
        "hidden-title": "This is visible in the resource name",
        "kind": "Windows",
        "resourceType": "Data Collection Rules"
      }
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/insights/data-collection-rule:<version>'

// Required parameters
param dataCollectionRuleProperties = {
  dataCollectionEndpointResourceId: '<dataCollectionEndpointResourceId>'
  dataFlows: [
    {
      destinations: [
        '<logAnalyticsWorkspaceName>'
      ]
      outputStream: 'Microsoft-W3CIISLog'
      streams: [
        'Microsoft-W3CIISLog'
      ]
      transformKql: 'source'
    }
  ]
  dataSources: {
    iisLogs: [
      {
        logDirectories: [
          'C:\\inetpub\\logs\\LogFiles\\W3SVC1'
        ]
        name: 'iisLogsDataSource'
        streams: [
          'Microsoft-W3CIISLog'
        ]
      }
    ]
  }
  description: 'Collecting IIS logs.'
  destinations: {
    logAnalytics: [
      {
        name: '<name>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
  }
  kind: 'Windows'
}
param name = 'idcrcusiis001'
// Non-required parameters
param location = '<location>'
param tags = {
  'hidden-title': 'This is visible in the resource name'
  kind: 'Windows'
  resourceType: 'Data Collection Rules'
}
```

</details>
<p>

### Example 5: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module dataCollectionRule 'br/public:avm/res/insights/data-collection-rule:<version>' = {
  name: 'dataCollectionRuleDeployment'
  params: {
    // Required parameters
    dataCollectionRuleProperties: {
      dataFlows: [
        {
          destinations: [
            'azureMonitorMetrics-default'
          ]
          streams: [
            'Microsoft-InsightsMetrics'
          ]
        }
      ]
      dataSources: {
        performanceCounters: [
          {
            counterSpecifiers: [
              '\\Process(_Total)\\Handle Count'
              '\\Process(_Total)\\Thread Count'
              '\\Processor Information(_Total)\\% Privileged Time'
              '\\Processor Information(_Total)\\% Processor Time'
              '\\Processor Information(_Total)\\% User Time'
              '\\Processor Information(_Total)\\Processor Frequency'
              '\\System\\Context Switches/sec'
              '\\System\\Processes'
              '\\System\\Processor Queue Length'
              '\\System\\System Up Time'
            ]
            name: 'perfCounterDataSource60'
            samplingFrequencyInSeconds: 60
            streams: [
              'Microsoft-InsightsMetrics'
            ]
          }
        ]
      }
      destinations: {
        azureMonitorMetrics: {
          name: 'azureMonitorMetrics-default'
        }
      }
      kind: 'Windows'
    }
    name: 'idcrmin001'
    // Non-required parameters
    location: '<location>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "dataCollectionRuleProperties": {
      "value": {
        "dataFlows": [
          {
            "destinations": [
              "azureMonitorMetrics-default"
            ],
            "streams": [
              "Microsoft-InsightsMetrics"
            ]
          }
        ],
        "dataSources": {
          "performanceCounters": [
            {
              "counterSpecifiers": [
                "\\Process(_Total)\\Handle Count",
                "\\Process(_Total)\\Thread Count",
                "\\Processor Information(_Total)\\% Privileged Time",
                "\\Processor Information(_Total)\\% Processor Time",
                "\\Processor Information(_Total)\\% User Time",
                "\\Processor Information(_Total)\\Processor Frequency",
                "\\System\\Context Switches/sec",
                "\\System\\Processes",
                "\\System\\Processor Queue Length",
                "\\System\\System Up Time"
              ],
              "name": "perfCounterDataSource60",
              "samplingFrequencyInSeconds": 60,
              "streams": [
                "Microsoft-InsightsMetrics"
              ]
            }
          ]
        },
        "destinations": {
          "azureMonitorMetrics": {
            "name": "azureMonitorMetrics-default"
          }
        },
        "kind": "Windows"
      }
    },
    "name": {
      "value": "idcrmin001"
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/insights/data-collection-rule:<version>'

// Required parameters
param dataCollectionRuleProperties = {
  dataFlows: [
    {
      destinations: [
        'azureMonitorMetrics-default'
      ]
      streams: [
        'Microsoft-InsightsMetrics'
      ]
    }
  ]
  dataSources: {
    performanceCounters: [
      {
        counterSpecifiers: [
          '\\Process(_Total)\\Handle Count'
          '\\Process(_Total)\\Thread Count'
          '\\Processor Information(_Total)\\% Privileged Time'
          '\\Processor Information(_Total)\\% Processor Time'
          '\\Processor Information(_Total)\\% User Time'
          '\\Processor Information(_Total)\\Processor Frequency'
          '\\System\\Context Switches/sec'
          '\\System\\Processes'
          '\\System\\Processor Queue Length'
          '\\System\\System Up Time'
        ]
        name: 'perfCounterDataSource60'
        samplingFrequencyInSeconds: 60
        streams: [
          'Microsoft-InsightsMetrics'
        ]
      }
    ]
  }
  destinations: {
    azureMonitorMetrics: {
      name: 'azureMonitorMetrics-default'
    }
  }
  kind: 'Windows'
}
param name = 'idcrmin001'
// Non-required parameters
param location = '<location>'
```

</details>
<p>

### Example 6: _Send data to Azure Monitor Logs with Logs ingestion API_

This instance deploys the module to setup sending data to Azure Monitor Logs with Logs ingestion API.


<details>

<summary>via Bicep module</summary>

```bicep
module dataCollectionRule 'br/public:avm/res/insights/data-collection-rule:<version>' = {
  name: 'dataCollectionRuleDeployment'
  params: {
    // Required parameters
    dataCollectionRuleProperties: {
      dataCollectionEndpointResourceId: '<dataCollectionEndpointResourceId>'
      dataFlows: [
        {
          destinations: [
            '<logAnalyticsWorkspaceName>'
          ]
          outputStream: 'Custom-ApacheAccess_CL'
          streams: [
            'Custom-ApacheAccess_CL'
          ]
          transformKql: 'source\n| extend TimeGenerated = todatetime(Time)\n| parse RawData with \nClientIP:string\n\' \' *\n\' \' *\n\' [\' * \'] \'\' RequestType:string\n\' \' Resource:string\n\' \' *\n\'\' \' ResponseCode:int\n\' \' *\n| project-away Time, RawData\n| where ResponseCode != 200\n'
        }
      ]
      description: 'Send data to Azure Monitor Logs with Logs ingestion API. Based on the example at https://learn.microsoft.com/en-us/azure/azure-monitor/logs/tutorial-logs-ingestion-portal'
      destinations: {
        logAnalytics: [
          {
            name: '<name>'
            workspaceResourceId: '<workspaceResourceId>'
          }
        ]
      }
      kind: 'Direct'
      streamDeclarations: {
        'Custom-ApacheAccess_CL': {
          columns: [
            {
              name: 'RawData'
              type: 'string'
            }
            {
              name: 'Time'
              type: 'datetime'
            }
            {
              name: 'Application'
              type: 'string'
            }
          ]
        }
      }
    }
    name: 'idcrdir001'
    // Non-required parameters
    location: '<location>'
    tags: {
      'hidden-title': 'This is visible in the resource name'
      kind: 'Direct'
      resourceType: 'Data Collection Rules'
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "dataCollectionRuleProperties": {
      "value": {
        "dataCollectionEndpointResourceId": "<dataCollectionEndpointResourceId>",
        "dataFlows": [
          {
            "destinations": [
              "<logAnalyticsWorkspaceName>"
            ],
            "outputStream": "Custom-ApacheAccess_CL",
            "streams": [
              "Custom-ApacheAccess_CL"
            ],
            "transformKql": "source\n| extend TimeGenerated = todatetime(Time)\n| parse RawData with \nClientIP:string\n\" \" *\n\" \" *\n\" [\" * \"] \"\" RequestType:string\n\" \" Resource:string\n\" \" *\n\"\" \" ResponseCode:int\n\" \" *\n| project-away Time, RawData\n| where ResponseCode != 200\n"
          }
        ],
        "description": "Send data to Azure Monitor Logs with Logs ingestion API. Based on the example at https://learn.microsoft.com/en-us/azure/azure-monitor/logs/tutorial-logs-ingestion-portal",
        "destinations": {
          "logAnalytics": [
            {
              "name": "<name>",
              "workspaceResourceId": "<workspaceResourceId>"
            }
          ]
        },
        "kind": "Direct",
        "streamDeclarations": {
          "Custom-ApacheAccess_CL": {
            "columns": [
              {
                "name": "RawData",
                "type": "string"
              },
              {
                "name": "Time",
                "type": "datetime"
              },
              {
                "name": "Application",
                "type": "string"
              }
            ]
          }
        }
      }
    },
    "name": {
      "value": "idcrdir001"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "tags": {
      "value": {
        "hidden-title": "This is visible in the resource name",
        "kind": "Direct",
        "resourceType": "Data Collection Rules"
      }
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/insights/data-collection-rule:<version>'

// Required parameters
param dataCollectionRuleProperties = {
  dataCollectionEndpointResourceId: '<dataCollectionEndpointResourceId>'
  dataFlows: [
    {
      destinations: [
        '<logAnalyticsWorkspaceName>'
      ]
      outputStream: 'Custom-ApacheAccess_CL'
      streams: [
        'Custom-ApacheAccess_CL'
      ]
      transformKql: 'source\n| extend TimeGenerated = todatetime(Time)\n| parse RawData with \nClientIP:string\n\' \' *\n\' \' *\n\' [\' * \'] \'\' RequestType:string\n\' \' Resource:string\n\' \' *\n\'\' \' ResponseCode:int\n\' \' *\n| project-away Time, RawData\n| where ResponseCode != 200\n'
    }
  ]
  description: 'Send data to Azure Monitor Logs with Logs ingestion API. Based on the example at https://learn.microsoft.com/en-us/azure/azure-monitor/logs/tutorial-logs-ingestion-portal'
  destinations: {
    logAnalytics: [
      {
        name: '<name>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
  }
  kind: 'Direct'
  streamDeclarations: {
    'Custom-ApacheAccess_CL': {
      columns: [
        {
          name: 'RawData'
          type: 'string'
        }
        {
          name: 'Time'
          type: 'datetime'
        }
        {
          name: 'Application'
          type: 'string'
        }
      ]
    }
  }
}
param name = 'idcrdir001'
// Non-required parameters
param location = '<location>'
param tags = {
  'hidden-title': 'This is visible in the resource name'
  kind: 'Direct'
  resourceType: 'Data Collection Rules'
}
```

</details>
<p>

### Example 7: _Collecting Linux-specific information_

This instance deploys the module to setup the collection of Linux-specific performance counters and Linux Syslog.


<details>

<summary>via Bicep module</summary>

```bicep
module dataCollectionRule 'br/public:avm/res/insights/data-collection-rule:<version>' = {
  name: 'dataCollectionRuleDeployment'
  params: {
    // Required parameters
    dataCollectionRuleProperties: {
      dataFlows: [
        {
          destinations: [
            'azureMonitorMetrics-default'
          ]
          streams: [
            'Microsoft-InsightsMetrics'
          ]
        }
        {
          destinations: [
            '<logAnalyticsWorkspaceName>'
          ]
          streams: [
            'Microsoft-Syslog'
          ]
        }
      ]
      dataSources: {
        performanceCounters: [
          {
            counterSpecifiers: [
              'Logical Disk(*)\\% Free Inodes'
              'Logical Disk(*)\\% Free Space'
              'Logical Disk(*)\\% Used Inodes'
              'Logical Disk(*)\\% Used Space'
              'Logical Disk(*)\\Disk Read Bytes/sec'
              'Logical Disk(*)\\Disk Reads/sec'
              'Logical Disk(*)\\Disk Transfers/sec'
              'Logical Disk(*)\\Disk Write Bytes/sec'
              'Logical Disk(*)\\Disk Writes/sec'
              'Logical Disk(*)\\Free Megabytes'
              'Logical Disk(*)\\Logical Disk Bytes/sec'
              'Memory(*)\\% Available Memory'
              'Memory(*)\\% Available Swap Space'
              'Memory(*)\\% Used Memory'
              'Memory(*)\\% Used Swap Space'
              'Memory(*)\\Available MBytes Memory'
              'Memory(*)\\Available MBytes Swap'
              'Memory(*)\\Page Reads/sec'
              'Memory(*)\\Page Writes/sec'
              'Memory(*)\\Pages/sec'
              'Memory(*)\\Used MBytes Swap Space'
              'Memory(*)\\Used Memory MBytes'
              'Network(*)\\Total Bytes'
              'Network(*)\\Total Bytes Received'
              'Network(*)\\Total Bytes Transmitted'
              'Network(*)\\Total Collisions'
              'Network(*)\\Total Packets Received'
              'Network(*)\\Total Packets Transmitted'
              'Network(*)\\Total Rx Errors'
              'Network(*)\\Total Tx Errors'
              'Processor(*)\\% DPC Time'
              'Processor(*)\\% Idle Time'
              'Processor(*)\\% Interrupt Time'
              'Processor(*)\\% IO Wait Time'
              'Processor(*)\\% Nice Time'
              'Processor(*)\\% Privileged Time'
              'Processor(*)\\% Processor Time'
              'Processor(*)\\% User Time'
            ]
            name: 'perfCounterDataSource60'
            samplingFrequencyInSeconds: 60
            streams: [
              'Microsoft-InsightsMetrics'
            ]
          }
        ]
        syslog: [
          {
            facilityNames: [
              'auth'
              'authpriv'
            ]
            logLevels: [
              'Alert'
              'Critical'
              'Debug'
              'Emergency'
              'Error'
              'Info'
              'Notice'
              'Warning'
            ]
            name: 'sysLogsDataSource-debugLevel'
            streams: [
              'Microsoft-Syslog'
            ]
          }
          {
            facilityNames: [
              'cron'
              'daemon'
              'kern'
              'local0'
              'mark'
            ]
            logLevels: [
              'Alert'
              'Critical'
              'Emergency'
              'Error'
              'Warning'
            ]
            name: 'sysLogsDataSource-warningLevel'
            streams: [
              'Microsoft-Syslog'
            ]
          }
          {
            facilityNames: [
              'local1'
              'local2'
              'local3'
              'local4'
              'local5'
              'local6'
              'local7'
              'lpr'
              'mail'
              'news'
              'syslog'
            ]
            logLevels: [
              'Alert'
              'Critical'
              'Emergency'
              'Error'
            ]
            name: 'sysLogsDataSource-errLevel'
            streams: [
              'Microsoft-Syslog'
            ]
          }
        ]
      }
      description: 'Collecting Linux-specific performance counters and Linux Syslog'
      destinations: {
        azureMonitorMetrics: {
          name: 'azureMonitorMetrics-default'
        }
        logAnalytics: [
          {
            name: '<name>'
            workspaceResourceId: '<workspaceResourceId>'
          }
        ]
      }
      kind: 'Linux'
    }
    name: 'idcrlin001'
    // Non-required parameters
    location: '<location>'
    tags: {
      'hidden-title': 'This is visible in the resource name'
      kind: 'Linux'
      resourceType: 'Data Collection Rules'
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "dataCollectionRuleProperties": {
      "value": {
        "dataFlows": [
          {
            "destinations": [
              "azureMonitorMetrics-default"
            ],
            "streams": [
              "Microsoft-InsightsMetrics"
            ]
          },
          {
            "destinations": [
              "<logAnalyticsWorkspaceName>"
            ],
            "streams": [
              "Microsoft-Syslog"
            ]
          }
        ],
        "dataSources": {
          "performanceCounters": [
            {
              "counterSpecifiers": [
                "Logical Disk(*)\\% Free Inodes",
                "Logical Disk(*)\\% Free Space",
                "Logical Disk(*)\\% Used Inodes",
                "Logical Disk(*)\\% Used Space",
                "Logical Disk(*)\\Disk Read Bytes/sec",
                "Logical Disk(*)\\Disk Reads/sec",
                "Logical Disk(*)\\Disk Transfers/sec",
                "Logical Disk(*)\\Disk Write Bytes/sec",
                "Logical Disk(*)\\Disk Writes/sec",
                "Logical Disk(*)\\Free Megabytes",
                "Logical Disk(*)\\Logical Disk Bytes/sec",
                "Memory(*)\\% Available Memory",
                "Memory(*)\\% Available Swap Space",
                "Memory(*)\\% Used Memory",
                "Memory(*)\\% Used Swap Space",
                "Memory(*)\\Available MBytes Memory",
                "Memory(*)\\Available MBytes Swap",
                "Memory(*)\\Page Reads/sec",
                "Memory(*)\\Page Writes/sec",
                "Memory(*)\\Pages/sec",
                "Memory(*)\\Used MBytes Swap Space",
                "Memory(*)\\Used Memory MBytes",
                "Network(*)\\Total Bytes",
                "Network(*)\\Total Bytes Received",
                "Network(*)\\Total Bytes Transmitted",
                "Network(*)\\Total Collisions",
                "Network(*)\\Total Packets Received",
                "Network(*)\\Total Packets Transmitted",
                "Network(*)\\Total Rx Errors",
                "Network(*)\\Total Tx Errors",
                "Processor(*)\\% DPC Time",
                "Processor(*)\\% Idle Time",
                "Processor(*)\\% Interrupt Time",
                "Processor(*)\\% IO Wait Time",
                "Processor(*)\\% Nice Time",
                "Processor(*)\\% Privileged Time",
                "Processor(*)\\% Processor Time",
                "Processor(*)\\% User Time"
              ],
              "name": "perfCounterDataSource60",
              "samplingFrequencyInSeconds": 60,
              "streams": [
                "Microsoft-InsightsMetrics"
              ]
            }
          ],
          "syslog": [
            {
              "facilityNames": [
                "auth",
                "authpriv"
              ],
              "logLevels": [
                "Alert",
                "Critical",
                "Debug",
                "Emergency",
                "Error",
                "Info",
                "Notice",
                "Warning"
              ],
              "name": "sysLogsDataSource-debugLevel",
              "streams": [
                "Microsoft-Syslog"
              ]
            },
            {
              "facilityNames": [
                "cron",
                "daemon",
                "kern",
                "local0",
                "mark"
              ],
              "logLevels": [
                "Alert",
                "Critical",
                "Emergency",
                "Error",
                "Warning"
              ],
              "name": "sysLogsDataSource-warningLevel",
              "streams": [
                "Microsoft-Syslog"
              ]
            },
            {
              "facilityNames": [
                "local1",
                "local2",
                "local3",
                "local4",
                "local5",
                "local6",
                "local7",
                "lpr",
                "mail",
                "news",
                "syslog"
              ],
              "logLevels": [
                "Alert",
                "Critical",
                "Emergency",
                "Error"
              ],
              "name": "sysLogsDataSource-errLevel",
              "streams": [
                "Microsoft-Syslog"
              ]
            }
          ]
        },
        "description": "Collecting Linux-specific performance counters and Linux Syslog",
        "destinations": {
          "azureMonitorMetrics": {
            "name": "azureMonitorMetrics-default"
          },
          "logAnalytics": [
            {
              "name": "<name>",
              "workspaceResourceId": "<workspaceResourceId>"
            }
          ]
        },
        "kind": "Linux"
      }
    },
    "name": {
      "value": "idcrlin001"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "tags": {
      "value": {
        "hidden-title": "This is visible in the resource name",
        "kind": "Linux",
        "resourceType": "Data Collection Rules"
      }
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/insights/data-collection-rule:<version>'

// Required parameters
param dataCollectionRuleProperties = {
  dataFlows: [
    {
      destinations: [
        'azureMonitorMetrics-default'
      ]
      streams: [
        'Microsoft-InsightsMetrics'
      ]
    }
    {
      destinations: [
        '<logAnalyticsWorkspaceName>'
      ]
      streams: [
        'Microsoft-Syslog'
      ]
    }
  ]
  dataSources: {
    performanceCounters: [
      {
        counterSpecifiers: [
          'Logical Disk(*)\\% Free Inodes'
          'Logical Disk(*)\\% Free Space'
          'Logical Disk(*)\\% Used Inodes'
          'Logical Disk(*)\\% Used Space'
          'Logical Disk(*)\\Disk Read Bytes/sec'
          'Logical Disk(*)\\Disk Reads/sec'
          'Logical Disk(*)\\Disk Transfers/sec'
          'Logical Disk(*)\\Disk Write Bytes/sec'
          'Logical Disk(*)\\Disk Writes/sec'
          'Logical Disk(*)\\Free Megabytes'
          'Logical Disk(*)\\Logical Disk Bytes/sec'
          'Memory(*)\\% Available Memory'
          'Memory(*)\\% Available Swap Space'
          'Memory(*)\\% Used Memory'
          'Memory(*)\\% Used Swap Space'
          'Memory(*)\\Available MBytes Memory'
          'Memory(*)\\Available MBytes Swap'
          'Memory(*)\\Page Reads/sec'
          'Memory(*)\\Page Writes/sec'
          'Memory(*)\\Pages/sec'
          'Memory(*)\\Used MBytes Swap Space'
          'Memory(*)\\Used Memory MBytes'
          'Network(*)\\Total Bytes'
          'Network(*)\\Total Bytes Received'
          'Network(*)\\Total Bytes Transmitted'
          'Network(*)\\Total Collisions'
          'Network(*)\\Total Packets Received'
          'Network(*)\\Total Packets Transmitted'
          'Network(*)\\Total Rx Errors'
          'Network(*)\\Total Tx Errors'
          'Processor(*)\\% DPC Time'
          'Processor(*)\\% Idle Time'
          'Processor(*)\\% Interrupt Time'
          'Processor(*)\\% IO Wait Time'
          'Processor(*)\\% Nice Time'
          'Processor(*)\\% Privileged Time'
          'Processor(*)\\% Processor Time'
          'Processor(*)\\% User Time'
        ]
        name: 'perfCounterDataSource60'
        samplingFrequencyInSeconds: 60
        streams: [
          'Microsoft-InsightsMetrics'
        ]
      }
    ]
    syslog: [
      {
        facilityNames: [
          'auth'
          'authpriv'
        ]
        logLevels: [
          'Alert'
          'Critical'
          'Debug'
          'Emergency'
          'Error'
          'Info'
          'Notice'
          'Warning'
        ]
        name: 'sysLogsDataSource-debugLevel'
        streams: [
          'Microsoft-Syslog'
        ]
      }
      {
        facilityNames: [
          'cron'
          'daemon'
          'kern'
          'local0'
          'mark'
        ]
        logLevels: [
          'Alert'
          'Critical'
          'Emergency'
          'Error'
          'Warning'
        ]
        name: 'sysLogsDataSource-warningLevel'
        streams: [
          'Microsoft-Syslog'
        ]
      }
      {
        facilityNames: [
          'local1'
          'local2'
          'local3'
          'local4'
          'local5'
          'local6'
          'local7'
          'lpr'
          'mail'
          'news'
          'syslog'
        ]
        logLevels: [
          'Alert'
          'Critical'
          'Emergency'
          'Error'
        ]
        name: 'sysLogsDataSource-errLevel'
        streams: [
          'Microsoft-Syslog'
        ]
      }
    ]
  }
  description: 'Collecting Linux-specific performance counters and Linux Syslog'
  destinations: {
    azureMonitorMetrics: {
      name: 'azureMonitorMetrics-default'
    }
    logAnalytics: [
      {
        name: '<name>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
  }
  kind: 'Linux'
}
param name = 'idcrlin001'
// Non-required parameters
param location = '<location>'
param tags = {
  'hidden-title': 'This is visible in the resource name'
  kind: 'Linux'
  resourceType: 'Data Collection Rules'
}
```

</details>
<p>

### Example 8: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module dataCollectionRule 'br/public:avm/res/insights/data-collection-rule:<version>' = {
  name: 'dataCollectionRuleDeployment'
  params: {
    // Required parameters
    dataCollectionRuleProperties: {
      dataCollectionEndpointResourceId: '<dataCollectionEndpointResourceId>'
      dataFlows: [
        {
          destinations: [
            '<logAnalyticsWorkspaceName>'
          ]
          outputStream: 'Custom-CustomTableBasic_CL'
          streams: [
            'Custom-CustomTableBasic_CL'
          ]
          transformKql: 'source'
        }
      ]
      dataSources: {
        logFiles: [
          {
            filePatterns: [
              'C:\\TestLogsBasic\\TestLog*.log'
            ]
            format: 'text'
            name: 'CustomTableBasic_CL'
            samplingFrequencyInSeconds: 60
            settings: {
              text: {
                recordStartTimestampFormat: 'ISO 8601'
              }
            }
            streams: [
              'Custom-CustomTableBasic_CL'
            ]
          }
        ]
      }
      description: 'Collecting custom text logs without ingestion-time transformation.'
      destinations: {
        logAnalytics: [
          {
            name: '<name>'
            workspaceResourceId: '<workspaceResourceId>'
          }
        ]
      }
      kind: 'Windows'
      streamDeclarations: {
        'Custom-CustomTableBasic_CL': {
          columns: [
            {
              name: 'TimeGenerated'
              type: 'datetime'
            }
            {
              name: 'RawData'
              type: 'string'
            }
          ]
        }
      }
    }
    name: 'idcrmax001'
    // Non-required parameters
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    managedIdentities: {
      systemAssigned: false
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    roleAssignments: [
      {
        name: '89a4d6fa-defb-4099-9196-173d94b91d67'
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
    tags: {
      'hidden-title': 'This is visible in the resource name'
      kind: 'Windows'
      resourceType: 'Data Collection Rules'
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "dataCollectionRuleProperties": {
      "value": {
        "dataCollectionEndpointResourceId": "<dataCollectionEndpointResourceId>",
        "dataFlows": [
          {
            "destinations": [
              "<logAnalyticsWorkspaceName>"
            ],
            "outputStream": "Custom-CustomTableBasic_CL",
            "streams": [
              "Custom-CustomTableBasic_CL"
            ],
            "transformKql": "source"
          }
        ],
        "dataSources": {
          "logFiles": [
            {
              "filePatterns": [
                "C:\\TestLogsBasic\\TestLog*.log"
              ],
              "format": "text",
              "name": "CustomTableBasic_CL",
              "samplingFrequencyInSeconds": 60,
              "settings": {
                "text": {
                  "recordStartTimestampFormat": "ISO 8601"
                }
              },
              "streams": [
                "Custom-CustomTableBasic_CL"
              ]
            }
          ]
        },
        "description": "Collecting custom text logs without ingestion-time transformation.",
        "destinations": {
          "logAnalytics": [
            {
              "name": "<name>",
              "workspaceResourceId": "<workspaceResourceId>"
            }
          ]
        },
        "kind": "Windows",
        "streamDeclarations": {
          "Custom-CustomTableBasic_CL": {
            "columns": [
              {
                "name": "TimeGenerated",
                "type": "datetime"
              },
              {
                "name": "RawData",
                "type": "string"
              }
            ]
          }
        }
      }
    },
    "name": {
      "value": "idcrmax001"
    },
    // Non-required parameters
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
        "systemAssigned": false,
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "roleAssignments": {
      "value": [
        {
          "name": "89a4d6fa-defb-4099-9196-173d94b91d67",
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
    "tags": {
      "value": {
        "hidden-title": "This is visible in the resource name",
        "kind": "Windows",
        "resourceType": "Data Collection Rules"
      }
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/insights/data-collection-rule:<version>'

// Required parameters
param dataCollectionRuleProperties = {
  dataCollectionEndpointResourceId: '<dataCollectionEndpointResourceId>'
  dataFlows: [
    {
      destinations: [
        '<logAnalyticsWorkspaceName>'
      ]
      outputStream: 'Custom-CustomTableBasic_CL'
      streams: [
        'Custom-CustomTableBasic_CL'
      ]
      transformKql: 'source'
    }
  ]
  dataSources: {
    logFiles: [
      {
        filePatterns: [
          'C:\\TestLogsBasic\\TestLog*.log'
        ]
        format: 'text'
        name: 'CustomTableBasic_CL'
        samplingFrequencyInSeconds: 60
        settings: {
          text: {
            recordStartTimestampFormat: 'ISO 8601'
          }
        }
        streams: [
          'Custom-CustomTableBasic_CL'
        ]
      }
    ]
  }
  description: 'Collecting custom text logs without ingestion-time transformation.'
  destinations: {
    logAnalytics: [
      {
        name: '<name>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
  }
  kind: 'Windows'
  streamDeclarations: {
    'Custom-CustomTableBasic_CL': {
      columns: [
        {
          name: 'TimeGenerated'
          type: 'datetime'
        }
        {
          name: 'RawData'
          type: 'string'
        }
      ]
    }
  }
}
param name = 'idcrmax001'
// Non-required parameters
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param managedIdentities = {
  systemAssigned: false
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param roleAssignments = [
  {
    name: '89a4d6fa-defb-4099-9196-173d94b91d67'
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
param tags = {
  'hidden-title': 'This is visible in the resource name'
  kind: 'Windows'
  resourceType: 'Data Collection Rules'
}
```

</details>
<p>

### Example 9: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module dataCollectionRule 'br/public:avm/res/insights/data-collection-rule:<version>' = {
  name: 'dataCollectionRuleDeployment'
  params: {
    // Required parameters
    dataCollectionRuleProperties: {
      dataFlows: [
        {
          destinations: [
            'azureMonitorMetrics-default'
          ]
          streams: [
            'Microsoft-InsightsMetrics'
          ]
        }
        {
          destinations: [
            '<logAnalyticsWorkspaceName>'
          ]
          streams: [
            'Microsoft-Event'
          ]
        }
      ]
      dataSources: {
        performanceCounters: [
          {
            counterSpecifiers: [
              '\\LogicalDisk(_Total)\\% Disk Read Time'
              '\\LogicalDisk(_Total)\\% Disk Time'
              '\\LogicalDisk(_Total)\\% Disk Write Time'
              '\\LogicalDisk(_Total)\\% Free Space'
              '\\LogicalDisk(_Total)\\% Idle Time'
              '\\LogicalDisk(_Total)\\Avg. Disk Queue Length'
              '\\LogicalDisk(_Total)\\Avg. Disk Read Queue Length'
              '\\LogicalDisk(_Total)\\Avg. Disk sec/Read'
              '\\LogicalDisk(_Total)\\Avg. Disk sec/Transfer'
              '\\LogicalDisk(_Total)\\Avg. Disk sec/Write'
              '\\LogicalDisk(_Total)\\Avg. Disk Write Queue Length'
              '\\LogicalDisk(_Total)\\Disk Bytes/sec'
              '\\LogicalDisk(_Total)\\Disk Read Bytes/sec'
              '\\LogicalDisk(_Total)\\Disk Reads/sec'
              '\\LogicalDisk(_Total)\\Disk Transfers/sec'
              '\\LogicalDisk(_Total)\\Disk Write Bytes/sec'
              '\\LogicalDisk(_Total)\\Disk Writes/sec'
              '\\LogicalDisk(_Total)\\Free Megabytes'
              '\\Memory\\% Committed Bytes In Use'
              '\\Memory\\Available Bytes'
              '\\Memory\\Cache Bytes'
              '\\Memory\\Committed Bytes'
              '\\Memory\\Page Faults/sec'
              '\\Memory\\Pages/sec'
              '\\Memory\\Pool Nonpaged Bytes'
              '\\Memory\\Pool Paged Bytes'
              '\\Network Interface(*)\\Bytes Received/sec'
              '\\Network Interface(*)\\Bytes Sent/sec'
              '\\Network Interface(*)\\Bytes Total/sec'
              '\\Network Interface(*)\\Packets Outbound Errors'
              '\\Network Interface(*)\\Packets Received Errors'
              '\\Network Interface(*)\\Packets Received/sec'
              '\\Network Interface(*)\\Packets Sent/sec'
              '\\Network Interface(*)\\Packets/sec'
              '\\Process(_Total)\\Handle Count'
              '\\Process(_Total)\\Thread Count'
              '\\Process(_Total)\\Working Set'
              '\\Process(_Total)\\Working Set - Private'
              '\\Processor Information(_Total)\\% Privileged Time'
              '\\Processor Information(_Total)\\% Processor Time'
              '\\Processor Information(_Total)\\% User Time'
              '\\Processor Information(_Total)\\Processor Frequency'
              '\\System\\Context Switches/sec'
              '\\System\\Processes'
              '\\System\\Processor Queue Length'
              '\\System\\System Up Time'
            ]
            name: 'perfCounterDataSource60'
            samplingFrequencyInSeconds: 60
            streams: [
              'Microsoft-InsightsMetrics'
            ]
          }
        ]
        windowsEventLogs: [
          {
            name: 'eventLogsDataSource'
            streams: [
              'Microsoft-Event'
            ]
            xPathQueries: [
              'Application!*[System[(Level=1 or Level=2 or Level=3 or Level=4 or Level=0 or Level=5)]]'
              'Security!*[System[(band(Keywords,13510798882111488))]]'
              'System!*[System[(Level=1 or Level=2 or Level=3 or Level=4 or Level=0 or Level=5)]]'
            ]
          }
        ]
      }
      description: 'Collecting Windows-specific performance counters and Windows Event Logs'
      destinations: {
        azureMonitorMetrics: {
          name: 'azureMonitorMetrics-default'
        }
        logAnalytics: [
          {
            name: '<name>'
            workspaceResourceId: '<workspaceResourceId>'
          }
        ]
      }
      kind: 'Windows'
    }
    name: 'idcrwaf001'
    // Non-required parameters
    location: '<location>'
    tags: {
      'hidden-title': 'This is visible in the resource name'
      kind: 'Windows'
      resourceType: 'Data Collection Rules'
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "dataCollectionRuleProperties": {
      "value": {
        "dataFlows": [
          {
            "destinations": [
              "azureMonitorMetrics-default"
            ],
            "streams": [
              "Microsoft-InsightsMetrics"
            ]
          },
          {
            "destinations": [
              "<logAnalyticsWorkspaceName>"
            ],
            "streams": [
              "Microsoft-Event"
            ]
          }
        ],
        "dataSources": {
          "performanceCounters": [
            {
              "counterSpecifiers": [
                "\\LogicalDisk(_Total)\\% Disk Read Time",
                "\\LogicalDisk(_Total)\\% Disk Time",
                "\\LogicalDisk(_Total)\\% Disk Write Time",
                "\\LogicalDisk(_Total)\\% Free Space",
                "\\LogicalDisk(_Total)\\% Idle Time",
                "\\LogicalDisk(_Total)\\Avg. Disk Queue Length",
                "\\LogicalDisk(_Total)\\Avg. Disk Read Queue Length",
                "\\LogicalDisk(_Total)\\Avg. Disk sec/Read",
                "\\LogicalDisk(_Total)\\Avg. Disk sec/Transfer",
                "\\LogicalDisk(_Total)\\Avg. Disk sec/Write",
                "\\LogicalDisk(_Total)\\Avg. Disk Write Queue Length",
                "\\LogicalDisk(_Total)\\Disk Bytes/sec",
                "\\LogicalDisk(_Total)\\Disk Read Bytes/sec",
                "\\LogicalDisk(_Total)\\Disk Reads/sec",
                "\\LogicalDisk(_Total)\\Disk Transfers/sec",
                "\\LogicalDisk(_Total)\\Disk Write Bytes/sec",
                "\\LogicalDisk(_Total)\\Disk Writes/sec",
                "\\LogicalDisk(_Total)\\Free Megabytes",
                "\\Memory\\% Committed Bytes In Use",
                "\\Memory\\Available Bytes",
                "\\Memory\\Cache Bytes",
                "\\Memory\\Committed Bytes",
                "\\Memory\\Page Faults/sec",
                "\\Memory\\Pages/sec",
                "\\Memory\\Pool Nonpaged Bytes",
                "\\Memory\\Pool Paged Bytes",
                "\\Network Interface(*)\\Bytes Received/sec",
                "\\Network Interface(*)\\Bytes Sent/sec",
                "\\Network Interface(*)\\Bytes Total/sec",
                "\\Network Interface(*)\\Packets Outbound Errors",
                "\\Network Interface(*)\\Packets Received Errors",
                "\\Network Interface(*)\\Packets Received/sec",
                "\\Network Interface(*)\\Packets Sent/sec",
                "\\Network Interface(*)\\Packets/sec",
                "\\Process(_Total)\\Handle Count",
                "\\Process(_Total)\\Thread Count",
                "\\Process(_Total)\\Working Set",
                "\\Process(_Total)\\Working Set - Private",
                "\\Processor Information(_Total)\\% Privileged Time",
                "\\Processor Information(_Total)\\% Processor Time",
                "\\Processor Information(_Total)\\% User Time",
                "\\Processor Information(_Total)\\Processor Frequency",
                "\\System\\Context Switches/sec",
                "\\System\\Processes",
                "\\System\\Processor Queue Length",
                "\\System\\System Up Time"
              ],
              "name": "perfCounterDataSource60",
              "samplingFrequencyInSeconds": 60,
              "streams": [
                "Microsoft-InsightsMetrics"
              ]
            }
          ],
          "windowsEventLogs": [
            {
              "name": "eventLogsDataSource",
              "streams": [
                "Microsoft-Event"
              ],
              "xPathQueries": [
                "Application!*[System[(Level=1 or Level=2 or Level=3 or Level=4 or Level=0 or Level=5)]]",
                "Security!*[System[(band(Keywords,13510798882111488))]]",
                "System!*[System[(Level=1 or Level=2 or Level=3 or Level=4 or Level=0 or Level=5)]]"
              ]
            }
          ]
        },
        "description": "Collecting Windows-specific performance counters and Windows Event Logs",
        "destinations": {
          "azureMonitorMetrics": {
            "name": "azureMonitorMetrics-default"
          },
          "logAnalytics": [
            {
              "name": "<name>",
              "workspaceResourceId": "<workspaceResourceId>"
            }
          ]
        },
        "kind": "Windows"
      }
    },
    "name": {
      "value": "idcrwaf001"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "tags": {
      "value": {
        "hidden-title": "This is visible in the resource name",
        "kind": "Windows",
        "resourceType": "Data Collection Rules"
      }
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/insights/data-collection-rule:<version>'

// Required parameters
param dataCollectionRuleProperties = {
  dataFlows: [
    {
      destinations: [
        'azureMonitorMetrics-default'
      ]
      streams: [
        'Microsoft-InsightsMetrics'
      ]
    }
    {
      destinations: [
        '<logAnalyticsWorkspaceName>'
      ]
      streams: [
        'Microsoft-Event'
      ]
    }
  ]
  dataSources: {
    performanceCounters: [
      {
        counterSpecifiers: [
          '\\LogicalDisk(_Total)\\% Disk Read Time'
          '\\LogicalDisk(_Total)\\% Disk Time'
          '\\LogicalDisk(_Total)\\% Disk Write Time'
          '\\LogicalDisk(_Total)\\% Free Space'
          '\\LogicalDisk(_Total)\\% Idle Time'
          '\\LogicalDisk(_Total)\\Avg. Disk Queue Length'
          '\\LogicalDisk(_Total)\\Avg. Disk Read Queue Length'
          '\\LogicalDisk(_Total)\\Avg. Disk sec/Read'
          '\\LogicalDisk(_Total)\\Avg. Disk sec/Transfer'
          '\\LogicalDisk(_Total)\\Avg. Disk sec/Write'
          '\\LogicalDisk(_Total)\\Avg. Disk Write Queue Length'
          '\\LogicalDisk(_Total)\\Disk Bytes/sec'
          '\\LogicalDisk(_Total)\\Disk Read Bytes/sec'
          '\\LogicalDisk(_Total)\\Disk Reads/sec'
          '\\LogicalDisk(_Total)\\Disk Transfers/sec'
          '\\LogicalDisk(_Total)\\Disk Write Bytes/sec'
          '\\LogicalDisk(_Total)\\Disk Writes/sec'
          '\\LogicalDisk(_Total)\\Free Megabytes'
          '\\Memory\\% Committed Bytes In Use'
          '\\Memory\\Available Bytes'
          '\\Memory\\Cache Bytes'
          '\\Memory\\Committed Bytes'
          '\\Memory\\Page Faults/sec'
          '\\Memory\\Pages/sec'
          '\\Memory\\Pool Nonpaged Bytes'
          '\\Memory\\Pool Paged Bytes'
          '\\Network Interface(*)\\Bytes Received/sec'
          '\\Network Interface(*)\\Bytes Sent/sec'
          '\\Network Interface(*)\\Bytes Total/sec'
          '\\Network Interface(*)\\Packets Outbound Errors'
          '\\Network Interface(*)\\Packets Received Errors'
          '\\Network Interface(*)\\Packets Received/sec'
          '\\Network Interface(*)\\Packets Sent/sec'
          '\\Network Interface(*)\\Packets/sec'
          '\\Process(_Total)\\Handle Count'
          '\\Process(_Total)\\Thread Count'
          '\\Process(_Total)\\Working Set'
          '\\Process(_Total)\\Working Set - Private'
          '\\Processor Information(_Total)\\% Privileged Time'
          '\\Processor Information(_Total)\\% Processor Time'
          '\\Processor Information(_Total)\\% User Time'
          '\\Processor Information(_Total)\\Processor Frequency'
          '\\System\\Context Switches/sec'
          '\\System\\Processes'
          '\\System\\Processor Queue Length'
          '\\System\\System Up Time'
        ]
        name: 'perfCounterDataSource60'
        samplingFrequencyInSeconds: 60
        streams: [
          'Microsoft-InsightsMetrics'
        ]
      }
    ]
    windowsEventLogs: [
      {
        name: 'eventLogsDataSource'
        streams: [
          'Microsoft-Event'
        ]
        xPathQueries: [
          'Application!*[System[(Level=1 or Level=2 or Level=3 or Level=4 or Level=0 or Level=5)]]'
          'Security!*[System[(band(Keywords,13510798882111488))]]'
          'System!*[System[(Level=1 or Level=2 or Level=3 or Level=4 or Level=0 or Level=5)]]'
        ]
      }
    ]
  }
  description: 'Collecting Windows-specific performance counters and Windows Event Logs'
  destinations: {
    azureMonitorMetrics: {
      name: 'azureMonitorMetrics-default'
    }
    logAnalytics: [
      {
        name: '<name>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
  }
  kind: 'Windows'
}
param name = 'idcrwaf001'
// Non-required parameters
param location = '<location>'
param tags = {
  'hidden-title': 'This is visible in the resource name'
  kind: 'Windows'
  resourceType: 'Data Collection Rules'
}
```

</details>
<p>

### Example 10: _Collecting Windows-specific information_

This instance deploys the module to setup the connection of Windows-specific performance counters and Windows Event Logs.


<details>

<summary>via Bicep module</summary>

```bicep
module dataCollectionRule 'br/public:avm/res/insights/data-collection-rule:<version>' = {
  name: 'dataCollectionRuleDeployment'
  params: {
    // Required parameters
    dataCollectionRuleProperties: {
      dataFlows: [
        {
          destinations: [
            'azureMonitorMetrics-default'
          ]
          streams: [
            'Microsoft-InsightsMetrics'
          ]
        }
        {
          destinations: [
            '<logAnalyticsWorkspaceName>'
          ]
          streams: [
            'Microsoft-Event'
          ]
        }
      ]
      dataSources: {
        performanceCounters: [
          {
            counterSpecifiers: [
              '\\LogicalDisk(_Total)\\% Disk Read Time'
              '\\LogicalDisk(_Total)\\% Disk Time'
              '\\LogicalDisk(_Total)\\% Disk Write Time'
              '\\LogicalDisk(_Total)\\% Free Space'
              '\\LogicalDisk(_Total)\\% Idle Time'
              '\\LogicalDisk(_Total)\\Avg. Disk Queue Length'
              '\\LogicalDisk(_Total)\\Avg. Disk Read Queue Length'
              '\\LogicalDisk(_Total)\\Avg. Disk sec/Read'
              '\\LogicalDisk(_Total)\\Avg. Disk sec/Transfer'
              '\\LogicalDisk(_Total)\\Avg. Disk sec/Write'
              '\\LogicalDisk(_Total)\\Avg. Disk Write Queue Length'
              '\\LogicalDisk(_Total)\\Disk Bytes/sec'
              '\\LogicalDisk(_Total)\\Disk Read Bytes/sec'
              '\\LogicalDisk(_Total)\\Disk Reads/sec'
              '\\LogicalDisk(_Total)\\Disk Transfers/sec'
              '\\LogicalDisk(_Total)\\Disk Write Bytes/sec'
              '\\LogicalDisk(_Total)\\Disk Writes/sec'
              '\\LogicalDisk(_Total)\\Free Megabytes'
              '\\Memory\\% Committed Bytes In Use'
              '\\Memory\\Available Bytes'
              '\\Memory\\Cache Bytes'
              '\\Memory\\Committed Bytes'
              '\\Memory\\Page Faults/sec'
              '\\Memory\\Pages/sec'
              '\\Memory\\Pool Nonpaged Bytes'
              '\\Memory\\Pool Paged Bytes'
              '\\Network Interface(*)\\Bytes Received/sec'
              '\\Network Interface(*)\\Bytes Sent/sec'
              '\\Network Interface(*)\\Bytes Total/sec'
              '\\Network Interface(*)\\Packets Outbound Errors'
              '\\Network Interface(*)\\Packets Received Errors'
              '\\Network Interface(*)\\Packets Received/sec'
              '\\Network Interface(*)\\Packets Sent/sec'
              '\\Network Interface(*)\\Packets/sec'
              '\\Process(_Total)\\Handle Count'
              '\\Process(_Total)\\Thread Count'
              '\\Process(_Total)\\Working Set'
              '\\Process(_Total)\\Working Set - Private'
              '\\Processor Information(_Total)\\% Privileged Time'
              '\\Processor Information(_Total)\\% Processor Time'
              '\\Processor Information(_Total)\\% User Time'
              '\\Processor Information(_Total)\\Processor Frequency'
              '\\System\\Context Switches/sec'
              '\\System\\Processes'
              '\\System\\Processor Queue Length'
              '\\System\\System Up Time'
            ]
            name: 'perfCounterDataSource60'
            samplingFrequencyInSeconds: 60
            streams: [
              'Microsoft-InsightsMetrics'
            ]
          }
        ]
        windowsEventLogs: [
          {
            name: 'eventLogsDataSource'
            streams: [
              'Microsoft-Event'
            ]
            xPathQueries: [
              'Application!*[System[(Level=1 or Level=2 or Level=3 or Level=4 or Level=0 or Level=5)]]'
              'Security!*[System[(band(Keywords,13510798882111488))]]'
              'System!*[System[(Level=1 or Level=2 or Level=3 or Level=4 or Level=0 or Level=5)]]'
            ]
          }
        ]
      }
      description: 'Collecting Windows-specific performance counters and Windows Event Logs'
      destinations: {
        azureMonitorMetrics: {
          name: 'azureMonitorMetrics-default'
        }
        logAnalytics: [
          {
            name: '<name>'
            workspaceResourceId: '<workspaceResourceId>'
          }
        ]
      }
      kind: 'Windows'
    }
    name: 'idcrwin001'
    // Non-required parameters
    location: '<location>'
    tags: {
      'hidden-title': 'This is visible in the resource name'
      kind: 'Windows'
      resourceType: 'Data Collection Rules'
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "dataCollectionRuleProperties": {
      "value": {
        "dataFlows": [
          {
            "destinations": [
              "azureMonitorMetrics-default"
            ],
            "streams": [
              "Microsoft-InsightsMetrics"
            ]
          },
          {
            "destinations": [
              "<logAnalyticsWorkspaceName>"
            ],
            "streams": [
              "Microsoft-Event"
            ]
          }
        ],
        "dataSources": {
          "performanceCounters": [
            {
              "counterSpecifiers": [
                "\\LogicalDisk(_Total)\\% Disk Read Time",
                "\\LogicalDisk(_Total)\\% Disk Time",
                "\\LogicalDisk(_Total)\\% Disk Write Time",
                "\\LogicalDisk(_Total)\\% Free Space",
                "\\LogicalDisk(_Total)\\% Idle Time",
                "\\LogicalDisk(_Total)\\Avg. Disk Queue Length",
                "\\LogicalDisk(_Total)\\Avg. Disk Read Queue Length",
                "\\LogicalDisk(_Total)\\Avg. Disk sec/Read",
                "\\LogicalDisk(_Total)\\Avg. Disk sec/Transfer",
                "\\LogicalDisk(_Total)\\Avg. Disk sec/Write",
                "\\LogicalDisk(_Total)\\Avg. Disk Write Queue Length",
                "\\LogicalDisk(_Total)\\Disk Bytes/sec",
                "\\LogicalDisk(_Total)\\Disk Read Bytes/sec",
                "\\LogicalDisk(_Total)\\Disk Reads/sec",
                "\\LogicalDisk(_Total)\\Disk Transfers/sec",
                "\\LogicalDisk(_Total)\\Disk Write Bytes/sec",
                "\\LogicalDisk(_Total)\\Disk Writes/sec",
                "\\LogicalDisk(_Total)\\Free Megabytes",
                "\\Memory\\% Committed Bytes In Use",
                "\\Memory\\Available Bytes",
                "\\Memory\\Cache Bytes",
                "\\Memory\\Committed Bytes",
                "\\Memory\\Page Faults/sec",
                "\\Memory\\Pages/sec",
                "\\Memory\\Pool Nonpaged Bytes",
                "\\Memory\\Pool Paged Bytes",
                "\\Network Interface(*)\\Bytes Received/sec",
                "\\Network Interface(*)\\Bytes Sent/sec",
                "\\Network Interface(*)\\Bytes Total/sec",
                "\\Network Interface(*)\\Packets Outbound Errors",
                "\\Network Interface(*)\\Packets Received Errors",
                "\\Network Interface(*)\\Packets Received/sec",
                "\\Network Interface(*)\\Packets Sent/sec",
                "\\Network Interface(*)\\Packets/sec",
                "\\Process(_Total)\\Handle Count",
                "\\Process(_Total)\\Thread Count",
                "\\Process(_Total)\\Working Set",
                "\\Process(_Total)\\Working Set - Private",
                "\\Processor Information(_Total)\\% Privileged Time",
                "\\Processor Information(_Total)\\% Processor Time",
                "\\Processor Information(_Total)\\% User Time",
                "\\Processor Information(_Total)\\Processor Frequency",
                "\\System\\Context Switches/sec",
                "\\System\\Processes",
                "\\System\\Processor Queue Length",
                "\\System\\System Up Time"
              ],
              "name": "perfCounterDataSource60",
              "samplingFrequencyInSeconds": 60,
              "streams": [
                "Microsoft-InsightsMetrics"
              ]
            }
          ],
          "windowsEventLogs": [
            {
              "name": "eventLogsDataSource",
              "streams": [
                "Microsoft-Event"
              ],
              "xPathQueries": [
                "Application!*[System[(Level=1 or Level=2 or Level=3 or Level=4 or Level=0 or Level=5)]]",
                "Security!*[System[(band(Keywords,13510798882111488))]]",
                "System!*[System[(Level=1 or Level=2 or Level=3 or Level=4 or Level=0 or Level=5)]]"
              ]
            }
          ]
        },
        "description": "Collecting Windows-specific performance counters and Windows Event Logs",
        "destinations": {
          "azureMonitorMetrics": {
            "name": "azureMonitorMetrics-default"
          },
          "logAnalytics": [
            {
              "name": "<name>",
              "workspaceResourceId": "<workspaceResourceId>"
            }
          ]
        },
        "kind": "Windows"
      }
    },
    "name": {
      "value": "idcrwin001"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "tags": {
      "value": {
        "hidden-title": "This is visible in the resource name",
        "kind": "Windows",
        "resourceType": "Data Collection Rules"
      }
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/insights/data-collection-rule:<version>'

// Required parameters
param dataCollectionRuleProperties = {
  dataFlows: [
    {
      destinations: [
        'azureMonitorMetrics-default'
      ]
      streams: [
        'Microsoft-InsightsMetrics'
      ]
    }
    {
      destinations: [
        '<logAnalyticsWorkspaceName>'
      ]
      streams: [
        'Microsoft-Event'
      ]
    }
  ]
  dataSources: {
    performanceCounters: [
      {
        counterSpecifiers: [
          '\\LogicalDisk(_Total)\\% Disk Read Time'
          '\\LogicalDisk(_Total)\\% Disk Time'
          '\\LogicalDisk(_Total)\\% Disk Write Time'
          '\\LogicalDisk(_Total)\\% Free Space'
          '\\LogicalDisk(_Total)\\% Idle Time'
          '\\LogicalDisk(_Total)\\Avg. Disk Queue Length'
          '\\LogicalDisk(_Total)\\Avg. Disk Read Queue Length'
          '\\LogicalDisk(_Total)\\Avg. Disk sec/Read'
          '\\LogicalDisk(_Total)\\Avg. Disk sec/Transfer'
          '\\LogicalDisk(_Total)\\Avg. Disk sec/Write'
          '\\LogicalDisk(_Total)\\Avg. Disk Write Queue Length'
          '\\LogicalDisk(_Total)\\Disk Bytes/sec'
          '\\LogicalDisk(_Total)\\Disk Read Bytes/sec'
          '\\LogicalDisk(_Total)\\Disk Reads/sec'
          '\\LogicalDisk(_Total)\\Disk Transfers/sec'
          '\\LogicalDisk(_Total)\\Disk Write Bytes/sec'
          '\\LogicalDisk(_Total)\\Disk Writes/sec'
          '\\LogicalDisk(_Total)\\Free Megabytes'
          '\\Memory\\% Committed Bytes In Use'
          '\\Memory\\Available Bytes'
          '\\Memory\\Cache Bytes'
          '\\Memory\\Committed Bytes'
          '\\Memory\\Page Faults/sec'
          '\\Memory\\Pages/sec'
          '\\Memory\\Pool Nonpaged Bytes'
          '\\Memory\\Pool Paged Bytes'
          '\\Network Interface(*)\\Bytes Received/sec'
          '\\Network Interface(*)\\Bytes Sent/sec'
          '\\Network Interface(*)\\Bytes Total/sec'
          '\\Network Interface(*)\\Packets Outbound Errors'
          '\\Network Interface(*)\\Packets Received Errors'
          '\\Network Interface(*)\\Packets Received/sec'
          '\\Network Interface(*)\\Packets Sent/sec'
          '\\Network Interface(*)\\Packets/sec'
          '\\Process(_Total)\\Handle Count'
          '\\Process(_Total)\\Thread Count'
          '\\Process(_Total)\\Working Set'
          '\\Process(_Total)\\Working Set - Private'
          '\\Processor Information(_Total)\\% Privileged Time'
          '\\Processor Information(_Total)\\% Processor Time'
          '\\Processor Information(_Total)\\% User Time'
          '\\Processor Information(_Total)\\Processor Frequency'
          '\\System\\Context Switches/sec'
          '\\System\\Processes'
          '\\System\\Processor Queue Length'
          '\\System\\System Up Time'
        ]
        name: 'perfCounterDataSource60'
        samplingFrequencyInSeconds: 60
        streams: [
          'Microsoft-InsightsMetrics'
        ]
      }
    ]
    windowsEventLogs: [
      {
        name: 'eventLogsDataSource'
        streams: [
          'Microsoft-Event'
        ]
        xPathQueries: [
          'Application!*[System[(Level=1 or Level=2 or Level=3 or Level=4 or Level=0 or Level=5)]]'
          'Security!*[System[(band(Keywords,13510798882111488))]]'
          'System!*[System[(Level=1 or Level=2 or Level=3 or Level=4 or Level=0 or Level=5)]]'
        ]
      }
    ]
  }
  description: 'Collecting Windows-specific performance counters and Windows Event Logs'
  destinations: {
    azureMonitorMetrics: {
      name: 'azureMonitorMetrics-default'
    }
    logAnalytics: [
      {
        name: '<name>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
  }
  kind: 'Windows'
}
param name = 'idcrwin001'
// Non-required parameters
param location = '<location>'
param tags = {
  'hidden-title': 'This is visible in the resource name'
  kind: 'Windows'
  resourceType: 'Data Collection Rules'
}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataCollectionRuleProperties`](#parameter-datacollectionruleproperties) | object | The kind of data collection rule. |
| [`name`](#parameter-name) | string | The name of the data collection rule. The name is case insensitive. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-tags) | object | Resource tags. |

### Parameter: `dataCollectionRuleProperties`

The kind of data collection rule.

- Required: Yes
- Type: object
- Discriminator: `kind`

<h4>The available variants are:</h4>

| Variant | Description |
| :-- | :-- |
| [`Linux`](#variant-datacollectionrulepropertieskind-linux) | The type for the properties of the 'Linux' data collection rule. |
| [`Windows`](#variant-datacollectionrulepropertieskind-windows) | The type for the properties of the 'Windows' data collection rule. |
| [`All`](#variant-datacollectionrulepropertieskind-all) | The type for the properties of the data collection rule of the kind 'All'. |
| [`AgentSettings`](#variant-datacollectionrulepropertieskind-agentsettings) | The type for the properties of the 'AgentSettings' data collection rule. |
| [`Direct`](#variant-datacollectionrulepropertieskind-direct) | The type for the properties of the 'Direct' data collection rule. |

### Variant: `dataCollectionRuleProperties.kind-Linux`
The type for the properties of the 'Linux' data collection rule.

To use this variant, set the property `kind` to `Linux`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataFlows`](#parameter-datacollectionrulepropertieskind-linuxdataflows) | array | The specification of data flows. |
| [`dataSources`](#parameter-datacollectionrulepropertieskind-linuxdatasources) | object | Specification of data sources that will be collected. |
| [`destinations`](#parameter-datacollectionrulepropertieskind-linuxdestinations) | object | Specification of destinations that can be used in data flows. |
| [`kind`](#parameter-datacollectionrulepropertieskind-linuxkind) | string | The platform type specifies the type of resources this rule can apply to. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataCollectionEndpointResourceId`](#parameter-datacollectionrulepropertieskind-linuxdatacollectionendpointresourceid) | string | The resource ID of the data collection endpoint that this rule can be used with. |
| [`description`](#parameter-datacollectionrulepropertieskind-linuxdescription) | string | Description of the data collection rule. |
| [`streamDeclarations`](#parameter-datacollectionrulepropertieskind-linuxstreamdeclarations) | object | Declaration of custom streams used in this rule. |

### Parameter: `dataCollectionRuleProperties.kind-Linux.dataFlows`

The specification of data flows.

- Required: Yes
- Type: array

### Parameter: `dataCollectionRuleProperties.kind-Linux.dataSources`

Specification of data sources that will be collected.

- Required: Yes
- Type: object

### Parameter: `dataCollectionRuleProperties.kind-Linux.destinations`

Specification of destinations that can be used in data flows.

- Required: Yes
- Type: object

### Parameter: `dataCollectionRuleProperties.kind-Linux.kind`

The platform type specifies the type of resources this rule can apply to.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Linux'
  ]
  ```

### Parameter: `dataCollectionRuleProperties.kind-Linux.dataCollectionEndpointResourceId`

The resource ID of the data collection endpoint that this rule can be used with.

- Required: No
- Type: string

### Parameter: `dataCollectionRuleProperties.kind-Linux.description`

Description of the data collection rule.

- Required: No
- Type: string

### Parameter: `dataCollectionRuleProperties.kind-Linux.streamDeclarations`

Declaration of custom streams used in this rule.

- Required: No
- Type: object

### Variant: `dataCollectionRuleProperties.kind-Windows`
The type for the properties of the 'Windows' data collection rule.

To use this variant, set the property `kind` to `Windows`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataFlows`](#parameter-datacollectionrulepropertieskind-windowsdataflows) | array | The specification of data flows. |
| [`dataSources`](#parameter-datacollectionrulepropertieskind-windowsdatasources) | object | Specification of data sources that will be collected. |
| [`destinations`](#parameter-datacollectionrulepropertieskind-windowsdestinations) | object | Specification of destinations that can be used in data flows. |
| [`kind`](#parameter-datacollectionrulepropertieskind-windowskind) | string | The platform type specifies the type of resources this rule can apply to. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataCollectionEndpointResourceId`](#parameter-datacollectionrulepropertieskind-windowsdatacollectionendpointresourceid) | string | The resource ID of the data collection endpoint that this rule can be used with. |
| [`description`](#parameter-datacollectionrulepropertieskind-windowsdescription) | string | Description of the data collection rule. |
| [`streamDeclarations`](#parameter-datacollectionrulepropertieskind-windowsstreamdeclarations) | object | Declaration of custom streams used in this rule. |

### Parameter: `dataCollectionRuleProperties.kind-Windows.dataFlows`

The specification of data flows.

- Required: Yes
- Type: array

### Parameter: `dataCollectionRuleProperties.kind-Windows.dataSources`

Specification of data sources that will be collected.

- Required: Yes
- Type: object

### Parameter: `dataCollectionRuleProperties.kind-Windows.destinations`

Specification of destinations that can be used in data flows.

- Required: Yes
- Type: object

### Parameter: `dataCollectionRuleProperties.kind-Windows.kind`

The platform type specifies the type of resources this rule can apply to.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Windows'
  ]
  ```

### Parameter: `dataCollectionRuleProperties.kind-Windows.dataCollectionEndpointResourceId`

The resource ID of the data collection endpoint that this rule can be used with.

- Required: No
- Type: string

### Parameter: `dataCollectionRuleProperties.kind-Windows.description`

Description of the data collection rule.

- Required: No
- Type: string

### Parameter: `dataCollectionRuleProperties.kind-Windows.streamDeclarations`

Declaration of custom streams used in this rule.

- Required: No
- Type: object

### Variant: `dataCollectionRuleProperties.kind-All`
The type for the properties of the data collection rule of the kind 'All'.

To use this variant, set the property `kind` to `All`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataFlows`](#parameter-datacollectionrulepropertieskind-alldataflows) | array | The specification of data flows. |
| [`dataSources`](#parameter-datacollectionrulepropertieskind-alldatasources) | object | Specification of data sources that will be collected. |
| [`destinations`](#parameter-datacollectionrulepropertieskind-alldestinations) | object | Specification of destinations that can be used in data flows. |
| [`kind`](#parameter-datacollectionrulepropertieskind-allkind) | string | The platform type specifies the type of resources this rule can apply to. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataCollectionEndpointResourceId`](#parameter-datacollectionrulepropertieskind-alldatacollectionendpointresourceid) | string | The resource ID of the data collection endpoint that this rule can be used with. |
| [`description`](#parameter-datacollectionrulepropertieskind-alldescription) | string | Description of the data collection rule. |
| [`streamDeclarations`](#parameter-datacollectionrulepropertieskind-allstreamdeclarations) | object | Declaration of custom streams used in this rule. |

### Parameter: `dataCollectionRuleProperties.kind-All.dataFlows`

The specification of data flows.

- Required: Yes
- Type: array

### Parameter: `dataCollectionRuleProperties.kind-All.dataSources`

Specification of data sources that will be collected.

- Required: Yes
- Type: object

### Parameter: `dataCollectionRuleProperties.kind-All.destinations`

Specification of destinations that can be used in data flows.

- Required: Yes
- Type: object

### Parameter: `dataCollectionRuleProperties.kind-All.kind`

The platform type specifies the type of resources this rule can apply to.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'All'
  ]
  ```

### Parameter: `dataCollectionRuleProperties.kind-All.dataCollectionEndpointResourceId`

The resource ID of the data collection endpoint that this rule can be used with.

- Required: No
- Type: string

### Parameter: `dataCollectionRuleProperties.kind-All.description`

Description of the data collection rule.

- Required: No
- Type: string

### Parameter: `dataCollectionRuleProperties.kind-All.streamDeclarations`

Declaration of custom streams used in this rule.

- Required: No
- Type: object

### Variant: `dataCollectionRuleProperties.kind-AgentSettings`
The type for the properties of the 'AgentSettings' data collection rule.

To use this variant, set the property `kind` to `AgentSettings`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`agentSettings`](#parameter-datacollectionrulepropertieskind-agentsettingsagentsettings) | object | Agent settings used to modify agent behavior on a given host. |
| [`kind`](#parameter-datacollectionrulepropertieskind-agentsettingskind) | string | The platform type specifies the type of resources this rule can apply to. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-datacollectionrulepropertieskind-agentsettingsdescription) | string | Description of the data collection rule. |

### Parameter: `dataCollectionRuleProperties.kind-AgentSettings.agentSettings`

Agent settings used to modify agent behavior on a given host.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`logs`](#parameter-datacollectionrulepropertieskind-agentsettingsagentsettingslogs) | array | All the settings that are applicable to the logs agent (AMA). |

### Parameter: `dataCollectionRuleProperties.kind-AgentSettings.agentSettings.logs`

All the settings that are applicable to the logs agent (AMA).

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-datacollectionrulepropertieskind-agentsettingsagentsettingslogsname) | string | The name of the agent setting. |
| [`value`](#parameter-datacollectionrulepropertieskind-agentsettingsagentsettingslogsvalue) | string | The value of the agent setting. |

### Parameter: `dataCollectionRuleProperties.kind-AgentSettings.agentSettings.logs.name`

The name of the agent setting.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'MaxDiskQuotaInMB'
    'UseTimeReceivedForForwardedEvents'
  ]
  ```

### Parameter: `dataCollectionRuleProperties.kind-AgentSettings.agentSettings.logs.value`

The value of the agent setting.

- Required: Yes
- Type: string

### Parameter: `dataCollectionRuleProperties.kind-AgentSettings.kind`

The platform type specifies the type of resources this rule can apply to.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AgentSettings'
  ]
  ```

### Parameter: `dataCollectionRuleProperties.kind-AgentSettings.description`

Description of the data collection rule.

- Required: No
- Type: string

### Variant: `dataCollectionRuleProperties.kind-Direct`
The type for the properties of the 'Direct' data collection rule.

To use this variant, set the property `kind` to `Direct`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataFlows`](#parameter-datacollectionrulepropertieskind-directdataflows) | array | The specification of data flows. |
| [`destinations`](#parameter-datacollectionrulepropertieskind-directdestinations) | object | Specification of destinations that can be used in data flows. |
| [`kind`](#parameter-datacollectionrulepropertieskind-directkind) | string | The platform type specifies the type of resources this rule can apply to. |
| [`streamDeclarations`](#parameter-datacollectionrulepropertieskind-directstreamdeclarations) | object | Declaration of custom streams used in this rule. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataCollectionEndpointResourceId`](#parameter-datacollectionrulepropertieskind-directdatacollectionendpointresourceid) | string | The resource ID of the data collection endpoint that this rule can be used with. |
| [`description`](#parameter-datacollectionrulepropertieskind-directdescription) | string | Description of the data collection rule. |

### Parameter: `dataCollectionRuleProperties.kind-Direct.dataFlows`

The specification of data flows.

- Required: Yes
- Type: array

### Parameter: `dataCollectionRuleProperties.kind-Direct.destinations`

Specification of destinations that can be used in data flows.

- Required: Yes
- Type: object

### Parameter: `dataCollectionRuleProperties.kind-Direct.kind`

The platform type specifies the type of resources this rule can apply to.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Direct'
  ]
  ```

### Parameter: `dataCollectionRuleProperties.kind-Direct.streamDeclarations`

Declaration of custom streams used in this rule.

- Required: Yes
- Type: object

### Parameter: `dataCollectionRuleProperties.kind-Direct.dataCollectionEndpointResourceId`

The resource ID of the data collection endpoint that this rule can be used with.

- Required: No
- Type: string

### Parameter: `dataCollectionRuleProperties.kind-Direct.description`

Description of the data collection rule.

- Required: No
- Type: string

### Parameter: `name`

The name of the data collection rule. The name is case insensitive.

- Required: Yes
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location for all Resources.

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
| [`notes`](#parameter-locknotes) | string | Specify the notes of the lock. |

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

### Parameter: `lock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `managedIdentities`

The managed identity definition for this resource.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`systemAssigned`](#parameter-managedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. |
| [`userAssignedResourceIds`](#parameter-managedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption. |

### Parameter: `managedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption.

- Required: No
- Type: array

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
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

### Parameter: `tags`

Resource tags.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `endpoints` | object | The endpoints of the dataCollectionRule, if created. |
| `immutableId` | string | The ImmutableId of the dataCollectionRule. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the dataCollectionRule. |
| `resourceGroupName` | string | The name of the resource group the dataCollectionRule was created in. |
| `resourceId` | string | The resource ID of the dataCollectionRule. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.6.0` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
