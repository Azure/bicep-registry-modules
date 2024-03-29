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

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/dataCollectionRules` | [2021-09-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-09-01-preview/dataCollectionRules) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/insights/data-collection-rule:<version>`.

- [Collecting custom text logs with ingestion-time transformation](#example-1-collecting-custom-text-logs-with-ingestion-time-transformation)
- [Collecting custom text logs](#example-2-collecting-custom-text-logs)
- [Collecting IIS logs](#example-3-collecting-iis-logs)
- [Using only defaults](#example-4-using-only-defaults)
- [Collecting Linux-specific information](#example-5-collecting-linux-specific-information)
- [Using large parameter set](#example-6-using-large-parameter-set)
- [WAF-aligned](#example-7-waf-aligned)
- [Collecting Windows-specific information](#example-8-collecting-windows-specific-information)

### Example 1: _Collecting custom text logs with ingestion-time transformation_

This instance deploys the module to setup collection of custom logs and ingestion-time transformation.


<details>

<summary>via Bicep module</summary>

```bicep
module dataCollectionRule 'br/public:avm/res/insights/data-collection-rule:<version>' = {
  name: 'dataCollectionRuleDeployment'
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
    description: 'Collecting custom text logs with ingestion-time transformation to columns. Expected format of a log line (comma separated values): \'<DateTime>,<EventLevel>,<EventCode>,<Message>\', for example: \'2023-01-25T20:15:05Z,ERROR,404,Page not found\''
    kind: 'Windows'
    location: '<location>'
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
    "kind": {
      "value": "Windows"
    },
    "location": {
      "value": "<location>"
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

### Example 2: _Collecting custom text logs_

This instance deploys the module to setup collection of custom logs.


<details>

<summary>via Bicep module</summary>

```bicep
module dataCollectionRule 'br/public:avm/res/insights/data-collection-rule:<version>' = {
  name: 'dataCollectionRuleDeployment'
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
    kind: 'Windows'
    location: '<location>'
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
    "kind": {
      "value": "Windows"
    },
    "location": {
      "value": "<location>"
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

### Example 3: _Collecting IIS logs_

This instance deploys the module to setup the collection of IIS logs.


<details>

<summary>via Bicep module</summary>

```bicep
module dataCollectionRule 'br/public:avm/res/insights/data-collection-rule:<version>' = {
  name: 'dataCollectionRuleDeployment'
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
    kind: 'Windows'
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
    "kind": {
      "value": "Windows"
    },
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

### Example 4: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module dataCollectionRule 'br/public:avm/res/insights/data-collection-rule:<version>' = {
  name: 'dataCollectionRuleDeployment'
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
    kind: 'Windows'
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
    "kind": {
      "value": "Windows"
    },
    "location": {
      "value": "<location>"
    }
  }
}
```

</details>
<p>

### Example 5: _Collecting Linux-specific information_

This instance deploys the module to setup the collection of Linux-specific performance counters and Linux Syslog.


<details>

<summary>via Bicep module</summary>

```bicep
module dataCollectionRule 'br/public:avm/res/insights/data-collection-rule:<version>' = {
  name: 'dataCollectionRuleDeployment'
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
    kind: 'Linux'
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
    "kind": {
      "value": "Linux"
    },
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

### Example 6: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module dataCollectionRule 'br/public:avm/res/insights/data-collection-rule:<version>' = {
  name: 'dataCollectionRuleDeployment'
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
    name: 'idcrmax001'
    // Non-required parameters
    dataCollectionEndpointId: '<dataCollectionEndpointId>'
    description: 'Collecting custom text logs without ingestion-time transformation.'
    kind: 'Windows'
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
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
      "value": "idcrmax001"
    },
    // Non-required parameters
    "dataCollectionEndpointId": {
      "value": "<dataCollectionEndpointId>"
    },
    "description": {
      "value": "Collecting custom text logs without ingestion-time transformation."
    },
    "kind": {
      "value": "Windows"
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
    "roleAssignments": {
      "value": [
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

### Example 7: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module dataCollectionRule 'br/public:avm/res/insights/data-collection-rule:<version>' = {
  name: 'dataCollectionRuleDeployment'
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
            'Security!*[System[(band(Keywords,13510798882111488))]]'
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
    name: 'idcrwaf001'
    // Non-required parameters
    description: 'Collecting Windows-specific performance counters and Windows Event Logs'
    kind: 'Windows'
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
      "value": "idcrwaf001"
    },
    // Non-required parameters
    "description": {
      "value": "Collecting Windows-specific performance counters and Windows Event Logs"
    },
    "kind": {
      "value": "Windows"
    },
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

### Example 8: _Collecting Windows-specific information_

This instance deploys the module to setup the connection of Windows-specific performance counters and Windows Event Logs.


<details>

<summary>via Bicep module</summary>

```bicep
module dataCollectionRule 'br/public:avm/res/insights/data-collection-rule:<version>' = {
  name: 'dataCollectionRuleDeployment'
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
            'Security!*[System[(band(Keywords,13510798882111488))]]'
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
    kind: 'Windows'
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
    "kind": {
      "value": "Windows"
    },
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
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`kind`](#parameter-kind) | string | The kind of the resource. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
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

### Parameter: `description`

Description of the data collection rule.

- Required: No
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

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

Array of role assignments to create.

- Required: No
- Type: array

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

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
