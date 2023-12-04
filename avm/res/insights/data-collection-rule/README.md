# Data Collection Rules `[Microsoft.Insights/dataCollectionRules]`

This module deploys a Data Collection Rule.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/dataCollectionRules` | [2021-09-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-09-01-preview/dataCollectionRules) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/insights.data-collection-rule:1.0.0`.

- [Customadv](#example-1-customadv)
- [Custombasic](#example-2-custombasic)
- [Customiis](#example-3-customiis)
- [Using only defaults](#example-4-using-only-defaults)
- [Linux](#example-5-linux)
- [Windows](#example-6-windows)

### Example 1: _Customadv_

<details>

<summary>via Bicep module</summary>

```bicep
module dataCollectionRule 'br:bicep/modules/insights.data-collection-rule:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-idcrcusadv'
  params: {
    // Required parameters
    dataFlows: [
      {
        destinations: [
          '<logAnalyticsWorkspaceName>'
        ]
        outputStream: 'Custom-CustomTableAdvanced_CL'
        streams: [
          'Custom-CustomTableAdvanced_CL'
        ]
        transformKql: 'source | extend LogFields = split(RawData \'\') | extend EventTime = todatetime(LogFields[0]) | extend EventLevel = tostring(LogFields[1]) | extend EventCode = toint(LogFields[2]) | extend Message = tostring(LogFields[3]) | project TimeGenerated EventTime EventLevel EventCode Message'
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
    destinations: {
      logAnalytics: [
        {
          name: '<name>'
          workspaceResourceId: '<workspaceResourceId>'
        }
      ]
    }
    name: 'idcrcusadv001'
    // Non-required parameters
    dataCollectionEndpointId: '<dataCollectionEndpointId>'
    description: 'Collecting custom text logs with ingestion-time transformation to columns. Expected format of a log line (comma separated values): \'<DateTime><EventLevel><EventCode><Message>\' for example: \'2023-01-25T20:15:05ZERROR404Page not found\''
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    kind: 'Windows'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
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

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "dataFlows": {
      "value": [
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
      ]
    },
    "dataSources": {
      "value": {
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
      }
    },
    "destinations": {
      "value": {
        "logAnalytics": [
          {
            "name": "<name>",
            "workspaceResourceId": "<workspaceResourceId>"
          }
        ]
      }
    },
    "name": {
      "value": "idcrcusadv001"
    },
    // Non-required parameters
    "dataCollectionEndpointId": {
      "value": "<dataCollectionEndpointId>"
    },
    "description": {
      "value": "Collecting custom text logs with ingestion-time transformation to columns. Expected format of a log line (comma separated values): \"<DateTime>,<EventLevel>,<EventCode>,<Message>\", for example: \"2023-01-25T20:15:05Z,ERROR,404,Page not found\""
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "kind": {
      "value": "Windows"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    },
    "streamDeclarations": {
      "value": {
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

### Example 2: _Custombasic_

<details>

<summary>via Bicep module</summary>

```bicep
module dataCollectionRule 'br:bicep/modules/insights.data-collection-rule:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-idcrcusbas'
  params: {
    // Required parameters
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
    destinations: {
      logAnalytics: [
        {
          name: '<name>'
          workspaceResourceId: '<workspaceResourceId>'
        }
      ]
    }
    name: 'idcrcusbas001'
    // Non-required parameters
    dataCollectionEndpointId: '<dataCollectionEndpointId>'
    description: 'Collecting custom text logs without ingestion-time transformation.'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    kind: 'Windows'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
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

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "dataFlows": {
      "value": [
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
      ]
    },
    "dataSources": {
      "value": {
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
      }
    },
    "destinations": {
      "value": {
        "logAnalytics": [
          {
            "name": "<name>",
            "workspaceResourceId": "<workspaceResourceId>"
          }
        ]
      }
    },
    "name": {
      "value": "idcrcusbas001"
    },
    // Non-required parameters
    "dataCollectionEndpointId": {
      "value": "<dataCollectionEndpointId>"
    },
    "description": {
      "value": "Collecting custom text logs without ingestion-time transformation."
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "kind": {
      "value": "Windows"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    },
    "streamDeclarations": {
      "value": {
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

### Example 3: _Customiis_

<details>

<summary>via Bicep module</summary>

```bicep
module dataCollectionRule 'br:bicep/modules/insights.data-collection-rule:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-idcrcusiis'
  params: {
    // Required parameters
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
    destinations: {
      logAnalytics: [
        {
          name: '<name>'
          workspaceResourceId: '<workspaceResourceId>'
        }
      ]
    }
    name: 'idcrcusiis001'
    // Non-required parameters
    dataCollectionEndpointId: '<dataCollectionEndpointId>'
    description: 'Collecting IIS logs.'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    kind: 'Windows'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
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

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "dataFlows": {
      "value": [
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
      ]
    },
    "dataSources": {
      "value": {
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
      }
    },
    "destinations": {
      "value": {
        "logAnalytics": [
          {
            "name": "<name>",
            "workspaceResourceId": "<workspaceResourceId>"
          }
        ]
      }
    },
    "name": {
      "value": "idcrcusiis001"
    },
    // Non-required parameters
    "dataCollectionEndpointId": {
      "value": "<dataCollectionEndpointId>"
    },
    "description": {
      "value": "Collecting IIS logs."
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "kind": {
      "value": "Windows"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Reader"
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

### Example 4: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module dataCollectionRule 'br:bicep/modules/insights.data-collection-rule:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-idcrmin'
  params: {
    // Required parameters
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
    name: 'idcrmin001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    kind: 'Windows'
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
    "dataFlows": {
      "value": [
        {
          "destinations": [
            "azureMonitorMetrics-default"
          ],
          "streams": [
            "Microsoft-InsightsMetrics"
          ]
        }
      ]
    },
    "dataSources": {
      "value": {
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
      }
    },
    "destinations": {
      "value": {
        "azureMonitorMetrics": {
          "name": "azureMonitorMetrics-default"
        }
      }
    },
    "name": {
      "value": "idcrmin001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "kind": {
      "value": "Windows"
    }
  }
}
```

</details>
<p>

### Example 5: _Linux_

<details>

<summary>via Bicep module</summary>

```bicep
module dataCollectionRule 'br:bicep/modules/insights.data-collection-rule:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-idcrlin'
  params: {
    // Required parameters
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
    name: 'idcrlin001'
    // Non-required parameters
    description: 'Collecting Linux-specific performance counters and Linux Syslog'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    kind: 'Linux'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
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

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "dataFlows": {
      "value": [
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
      ]
    },
    "dataSources": {
      "value": {
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
      }
    },
    "destinations": {
      "value": {
        "azureMonitorMetrics": {
          "name": "azureMonitorMetrics-default"
        },
        "logAnalytics": [
          {
            "name": "<name>",
            "workspaceResourceId": "<workspaceResourceId>"
          }
        ]
      }
    },
    "name": {
      "value": "idcrlin001"
    },
    // Non-required parameters
    "description": {
      "value": "Collecting Linux-specific performance counters and Linux Syslog"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "kind": {
      "value": "Linux"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Reader"
        }
      ]
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

### Example 6: _Windows_

<details>

<summary>via Bicep module</summary>

```bicep
module dataCollectionRule 'br:bicep/modules/insights.data-collection-rule:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-idcrwin'
  params: {
    // Required parameters
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
            'Security!*[System[(band(Keywords13510798882111488))]]'
            'System!*[System[(Level=1 or Level=2 or Level=3 or Level=4 or Level=0 or Level=5)]]'
          ]
        }
      ]
    }
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
    name: 'idcrwin001'
    // Non-required parameters
    description: 'Collecting Windows-specific performance counters and Windows Event Logs'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    kind: 'Windows'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
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

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "dataFlows": {
      "value": [
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
      ]
    },
    "dataSources": {
      "value": {
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
      }
    },
    "destinations": {
      "value": {
        "azureMonitorMetrics": {
          "name": "azureMonitorMetrics-default"
        },
        "logAnalytics": [
          {
            "name": "<name>",
            "workspaceResourceId": "<workspaceResourceId>"
          }
        ]
      }
    },
    "name": {
      "value": "idcrwin001"
    },
    // Non-required parameters
    "description": {
      "value": "Collecting Windows-specific performance counters and Windows Event Logs"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "kind": {
      "value": "Windows"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Reader"
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


## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataFlows`](#parameter-dataflows) | array | The specification of data flows. |
| [`dataSources`](#parameter-datasources) | object | Specification of data sources that will be collected. |
| [`destinations`](#parameter-destinations) | object | Specification of destinations that can be used in data flows. |
| [`name`](#parameter-name) | string | The name of the data collection rule. The name is case insensitive. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataCollectionEndpointId`](#parameter-datacollectionendpointid) | string | The resource ID of the data collection endpoint that this rule can be used with. |
| [`description`](#parameter-description) | string | Description of the data collection rule. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| [`kind`](#parameter-kind) | string | The kind of the resource. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`streamDeclarations`](#parameter-streamdeclarations) | object | Declaration of custom streams used in this rule. |
| [`tags`](#parameter-tags) | object | Resource tags. |

### Parameter: `dataFlows`

The specification of data flows.

- Required: Yes
- Type: array

### Parameter: `dataSources`

Specification of data sources that will be collected.

- Required: Yes
- Type: object

### Parameter: `destinations`

Specification of destinations that can be used in data flows.

- Required: Yes
- Type: object

### Parameter: `name`

The name of the data collection rule. The name is case insensitive.

- Required: Yes
- Type: string

### Parameter: `dataCollectionEndpointId`

The resource ID of the data collection endpoint that this rule can be used with.

- Required: No
- Type: string
- Default: `''`

### Parameter: `description`

Description of the data collection rule.

- Required: No
- Type: string
- Default: `''`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via the Customer Usage Attribution ID (GUID).

- Required: No
- Type: bool
- Default: `True`

### Parameter: `kind`

The kind of the resource.

- Required: No
- Type: string
- Default: `'Linux'`
- Allowed:
  ```Bicep
  [
    'Linux'
    'Windows'
  ]
  ```

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

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-roleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | string | The name of the role to assign. If it cannot be found you can specify the role definition ID instead. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-roleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container" |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | string | The description of the role assignment. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.roleDefinitionIdOrName`

The name of the role to assign. If it cannot be found you can specify the role definition ID instead.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container"

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

### Parameter: `streamDeclarations`

Declaration of custom streams used in this rule.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `tags`

Resource tags.

- Required: No
- Type: object


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the dataCollectionRule. |
| `resourceGroupName` | string | The name of the resource group the dataCollectionRule was created in. |
| `resourceId` | string | The resource ID of the dataCollectionRule. |

## Cross-referenced modules

_None_
