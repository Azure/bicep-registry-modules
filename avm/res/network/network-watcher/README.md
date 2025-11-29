# Network Watchers `[Microsoft.Network/networkWatchers]`

This module deploys a Network Watcher.

You can reference the module as follows:
```bicep
module networkWatcher 'br/public:avm/res/network/network-watcher:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

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
| `Microsoft.Network/networkWatchers` | 2024-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_networkwatchers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-10-01/networkWatchers)</li></ul> |
| `Microsoft.Network/networkWatchers/connectionMonitors` | 2024-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_networkwatchers_connectionmonitors.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-10-01/networkWatchers/connectionMonitors)</li></ul> |
| `Microsoft.Network/networkWatchers/flowLogs` | 2024-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_networkwatchers_flowlogs.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-10-01/networkWatchers/flowLogs)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/network/network-watcher:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/defaults]


<details>

<summary>via Bicep module</summary>

```bicep
module networkWatcher 'br/public:avm/res/network/network-watcher:<version>' = {
  params: {

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
  "parameters": {}
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/network-watcher:<version>'


```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/max]


<details>

<summary>via Bicep module</summary>

```bicep
module networkWatcher 'br/public:avm/res/network/network-watcher:<version>' = {
  params: {
    connectionMonitors: [
      {
        endpoints: [
          {
            name: '<name>'
            resourceId: '<resourceId>'
            type: 'AzureVM'
          }
          {
            address: 'www.bing.com'
            name: 'Bing'
            type: 'ExternalAddress'
          }
        ]
        name: 'nnwmax-cm-001'
        testConfigurations: [
          {
            httpConfiguration: {
              method: 'Get'
              port: 80
              preferHTTPS: false
              requestHeaders: []
              validStatusCodeRanges: [
                '200'
              ]
            }
            name: 'HTTP Bing Test'
            protocol: 'Http'
            successThreshold: {
              checksFailedPercent: 5
              roundTripTimeMs: 100
            }
            testFrequencySec: 30
          }
        ]
        testGroups: [
          {
            destinations: [
              'Bing'
            ]
            disable: false
            name: 'test-http-Bing'
            sources: [
              'subnet-001(<value>)'
            ]
            testConfigurations: [
              'HTTP Bing Test'
            ]
          }
        ]
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    flowLogs: [
      {
        enabled: false
        storageResourceId: '<storageResourceId>'
        targetResourceId: '<targetResourceId>'
      }
      {
        formatVersion: 1
        name: 'nnwmax-fl-001'
        retentionInDays: 8
        storageResourceId: '<storageResourceId>'
        targetResourceId: '<targetResourceId>'
        trafficAnalyticsInterval: 10
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    location: '<location>'
    name: '<name>'
    roleAssignments: [
      {
        name: 'e8e93fb7-f450-41d5-ae86-a32d34e72578'
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
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
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
    "connectionMonitors": {
      "value": [
        {
          "endpoints": [
            {
              "name": "<name>",
              "resourceId": "<resourceId>",
              "type": "AzureVM"
            },
            {
              "address": "www.bing.com",
              "name": "Bing",
              "type": "ExternalAddress"
            }
          ],
          "name": "nnwmax-cm-001",
          "testConfigurations": [
            {
              "httpConfiguration": {
                "method": "Get",
                "port": 80,
                "preferHTTPS": false,
                "requestHeaders": [],
                "validStatusCodeRanges": [
                  "200"
                ]
              },
              "name": "HTTP Bing Test",
              "protocol": "Http",
              "successThreshold": {
                "checksFailedPercent": 5,
                "roundTripTimeMs": 100
              },
              "testFrequencySec": 30
            }
          ],
          "testGroups": [
            {
              "destinations": [
                "Bing"
              ],
              "disable": false,
              "name": "test-http-Bing",
              "sources": [
                "subnet-001(<value>)"
              ],
              "testConfigurations": [
                "HTTP Bing Test"
              ]
            }
          ],
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "flowLogs": {
      "value": [
        {
          "enabled": false,
          "storageResourceId": "<storageResourceId>",
          "targetResourceId": "<targetResourceId>"
        },
        {
          "formatVersion": 1,
          "name": "nnwmax-fl-001",
          "retentionInDays": 8,
          "storageResourceId": "<storageResourceId>",
          "targetResourceId": "<targetResourceId>",
          "trafficAnalyticsInterval": 10,
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "location": {
      "value": "<location>"
    },
    "name": {
      "value": "<name>"
    },
    "roleAssignments": {
      "value": [
        {
          "name": "e8e93fb7-f450-41d5-ae86-a32d34e72578",
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
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
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
using 'br/public:avm/res/network/network-watcher:<version>'

param connectionMonitors = [
  {
    endpoints: [
      {
        name: '<name>'
        resourceId: '<resourceId>'
        type: 'AzureVM'
      }
      {
        address: 'www.bing.com'
        name: 'Bing'
        type: 'ExternalAddress'
      }
    ]
    name: 'nnwmax-cm-001'
    testConfigurations: [
      {
        httpConfiguration: {
          method: 'Get'
          port: 80
          preferHTTPS: false
          requestHeaders: []
          validStatusCodeRanges: [
            '200'
          ]
        }
        name: 'HTTP Bing Test'
        protocol: 'Http'
        successThreshold: {
          checksFailedPercent: 5
          roundTripTimeMs: 100
        }
        testFrequencySec: 30
      }
    ]
    testGroups: [
      {
        destinations: [
          'Bing'
        ]
        disable: false
        name: 'test-http-Bing'
        sources: [
          'subnet-001(<value>)'
        ]
        testConfigurations: [
          'HTTP Bing Test'
        ]
      }
    ]
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param flowLogs = [
  {
    enabled: false
    storageResourceId: '<storageResourceId>'
    targetResourceId: '<targetResourceId>'
  }
  {
    formatVersion: 1
    name: 'nnwmax-fl-001'
    retentionInDays: 8
    storageResourceId: '<storageResourceId>'
    targetResourceId: '<targetResourceId>'
    trafficAnalyticsInterval: 10
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param location = '<location>'
param name = '<name>'
param roleAssignments = [
  {
    name: 'e8e93fb7-f450-41d5-ae86-a32d34e72578'
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
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/waf-aligned]


<details>

<summary>via Bicep module</summary>

```bicep
module networkWatcher 'br/public:avm/res/network/network-watcher:<version>' = {
  params: {
    connectionMonitors: [
      {
        endpoints: [
          {
            name: '<name>'
            resourceId: '<resourceId>'
            type: 'AzureVM'
          }
          {
            address: 'www.bing.com'
            name: 'Bing'
            type: 'ExternalAddress'
          }
        ]
        name: 'nnwwaf-cm-001'
        testConfigurations: [
          {
            httpConfiguration: {
              method: 'Get'
              port: 80
              preferHTTPS: false
              requestHeaders: []
              validStatusCodeRanges: [
                '200'
              ]
            }
            name: 'HTTP Bing Test'
            protocol: 'Http'
            successThreshold: {
              checksFailedPercent: 5
              roundTripTimeMs: 100
            }
            testFrequencySec: 30
          }
        ]
        testGroups: [
          {
            destinations: [
              'Bing'
            ]
            disable: false
            name: 'test-http-Bing'
            sources: [
              'subnet-001(<value>)'
            ]
            testConfigurations: [
              'HTTP Bing Test'
            ]
          }
        ]
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    flowLogs: [
      {
        enabled: false
        storageResourceId: '<storageResourceId>'
        targetResourceId: '<targetResourceId>'
      }
      {
        formatVersion: 1
        name: 'nnwwaf-fl-001'
        retentionInDays: 8
        storageResourceId: '<storageResourceId>'
        targetResourceId: '<targetResourceId>'
        trafficAnalyticsInterval: 10
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    name: '<name>'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
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
    "connectionMonitors": {
      "value": [
        {
          "endpoints": [
            {
              "name": "<name>",
              "resourceId": "<resourceId>",
              "type": "AzureVM"
            },
            {
              "address": "www.bing.com",
              "name": "Bing",
              "type": "ExternalAddress"
            }
          ],
          "name": "nnwwaf-cm-001",
          "testConfigurations": [
            {
              "httpConfiguration": {
                "method": "Get",
                "port": 80,
                "preferHTTPS": false,
                "requestHeaders": [],
                "validStatusCodeRanges": [
                  "200"
                ]
              },
              "name": "HTTP Bing Test",
              "protocol": "Http",
              "successThreshold": {
                "checksFailedPercent": 5,
                "roundTripTimeMs": 100
              },
              "testFrequencySec": 30
            }
          ],
          "testGroups": [
            {
              "destinations": [
                "Bing"
              ],
              "disable": false,
              "name": "test-http-Bing",
              "sources": [
                "subnet-001(<value>)"
              ],
              "testConfigurations": [
                "HTTP Bing Test"
              ]
            }
          ],
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "flowLogs": {
      "value": [
        {
          "enabled": false,
          "storageResourceId": "<storageResourceId>",
          "targetResourceId": "<targetResourceId>"
        },
        {
          "formatVersion": 1,
          "name": "nnwwaf-fl-001",
          "retentionInDays": 8,
          "storageResourceId": "<storageResourceId>",
          "targetResourceId": "<targetResourceId>",
          "trafficAnalyticsInterval": 10,
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "name": {
      "value": "<name>"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
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
using 'br/public:avm/res/network/network-watcher:<version>'

param connectionMonitors = [
  {
    endpoints: [
      {
        name: '<name>'
        resourceId: '<resourceId>'
        type: 'AzureVM'
      }
      {
        address: 'www.bing.com'
        name: 'Bing'
        type: 'ExternalAddress'
      }
    ]
    name: 'nnwwaf-cm-001'
    testConfigurations: [
      {
        httpConfiguration: {
          method: 'Get'
          port: 80
          preferHTTPS: false
          requestHeaders: []
          validStatusCodeRanges: [
            '200'
          ]
        }
        name: 'HTTP Bing Test'
        protocol: 'Http'
        successThreshold: {
          checksFailedPercent: 5
          roundTripTimeMs: 100
        }
        testFrequencySec: 30
      }
    ]
    testGroups: [
      {
        destinations: [
          'Bing'
        ]
        disable: false
        name: 'test-http-Bing'
        sources: [
          'subnet-001(<value>)'
        ]
        testConfigurations: [
          'HTTP Bing Test'
        ]
      }
    ]
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param flowLogs = [
  {
    enabled: false
    storageResourceId: '<storageResourceId>'
    targetResourceId: '<targetResourceId>'
  }
  {
    formatVersion: 1
    name: 'nnwwaf-fl-001'
    retentionInDays: 8
    storageResourceId: '<storageResourceId>'
    targetResourceId: '<targetResourceId>'
    trafficAnalyticsInterval: 10
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param name = '<name>'
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
```

</details>
<p>

## Parameters

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`connectionMonitors`](#parameter-connectionmonitors) | array | Array that contains the Connection Monitors. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`flowLogs`](#parameter-flowlogs) | array | Array that contains the Flow Logs. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`name`](#parameter-name) | string | Name of the Network Watcher resource (hidden). |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `connectionMonitors`

Array that contains the Connection Monitors.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-connectionmonitorsname) | string | Name of the resource. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoStart`](#parameter-connectionmonitorsautostart) | bool | Determines if the connection monitor will start automatically once created. |
| [`destination`](#parameter-connectionmonitorsdestination) | object | Describes the destination of connection monitor. |
| [`endpoints`](#parameter-connectionmonitorsendpoints) | array | List of connection monitor endpoints. |
| [`location`](#parameter-connectionmonitorslocation) | string | Location for all resources. |
| [`monitoringIntervalInSeconds`](#parameter-connectionmonitorsmonitoringintervalinseconds) | int | Monitoring interval in seconds. |
| [`notes`](#parameter-connectionmonitorsnotes) | string | Notes to be associated with the connection monitor. |
| [`source`](#parameter-connectionmonitorssource) | object | Describes the source of connection monitor. |
| [`tags`](#parameter-connectionmonitorstags) | object | Tags of the resource. |
| [`testConfigurations`](#parameter-connectionmonitorstestconfigurations) | array | List of connection monitor test configurations. |
| [`testGroups`](#parameter-connectionmonitorstestgroups) | array | List of connection monitor test groups. |
| [`workspaceResourceId`](#parameter-connectionmonitorsworkspaceresourceid) | string | Specify the Log Analytics Workspace Resource ID. |

### Parameter: `connectionMonitors.name`

Name of the resource.

- Required: Yes
- Type: string

### Parameter: `connectionMonitors.autoStart`

Determines if the connection monitor will start automatically once created.

- Required: No
- Type: bool

### Parameter: `connectionMonitors.destination`

Describes the destination of connection monitor.

- Required: No
- Type: object

### Parameter: `connectionMonitors.endpoints`

List of connection monitor endpoints.

- Required: No
- Type: array

### Parameter: `connectionMonitors.location`

Location for all resources.

- Required: No
- Type: string

### Parameter: `connectionMonitors.monitoringIntervalInSeconds`

Monitoring interval in seconds.

- Required: No
- Type: int
- MinValue: 30
- MaxValue: 1800

### Parameter: `connectionMonitors.notes`

Notes to be associated with the connection monitor.

- Required: No
- Type: string

### Parameter: `connectionMonitors.source`

Describes the source of connection monitor.

- Required: No
- Type: object

### Parameter: `connectionMonitors.tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `connectionMonitors.testConfigurations`

List of connection monitor test configurations.

- Required: No
- Type: array

### Parameter: `connectionMonitors.testGroups`

List of connection monitor test groups.

- Required: No
- Type: array

### Parameter: `connectionMonitors.workspaceResourceId`

Specify the Log Analytics Workspace Resource ID.

- Required: No
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `flowLogs`

Array that contains the Flow Logs.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`storageResourceId`](#parameter-flowlogsstorageresourceid) | string | Resource ID of the diagnostic storage account. |
| [`targetResourceId`](#parameter-flowlogstargetresourceid) | string | Resource ID of the NSG that must be enabled for Flow Logs. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-flowlogsenabled) | bool | If the flow log should be enabled. |
| [`enabledFilteringCriteria`](#parameter-flowlogsenabledfilteringcriteria) | string | Field to filter network traffic logs based on SrcIP, SrcPort, DstIP, DstPort, Protocol, Encryption, Direction and Action. If not specified, all network traffic will be logged. |
| [`formatVersion`](#parameter-flowlogsformatversion) | int | The flow log format version. |
| [`location`](#parameter-flowlogslocation) | string | Location for all resources. |
| [`name`](#parameter-flowlogsname) | string | Name of the resource. |
| [`retentionInDays`](#parameter-flowlogsretentionindays) | int | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| [`tags`](#parameter-flowlogstags) | object | Tags of the resource. |
| [`trafficAnalyticsInterval`](#parameter-flowlogstrafficanalyticsinterval) | int | The interval in minutes which would decide how frequently TA service should do flow analytics. |
| [`workspaceResourceId`](#parameter-flowlogsworkspaceresourceid) | string | Specify the Log Analytics Workspace Resource ID. |

### Parameter: `flowLogs.storageResourceId`

Resource ID of the diagnostic storage account.

- Required: Yes
- Type: string

### Parameter: `flowLogs.targetResourceId`

Resource ID of the NSG that must be enabled for Flow Logs.

- Required: Yes
- Type: string

### Parameter: `flowLogs.enabled`

If the flow log should be enabled.

- Required: No
- Type: bool

### Parameter: `flowLogs.enabledFilteringCriteria`

Field to filter network traffic logs based on SrcIP, SrcPort, DstIP, DstPort, Protocol, Encryption, Direction and Action. If not specified, all network traffic will be logged.

- Required: No
- Type: string

### Parameter: `flowLogs.formatVersion`

The flow log format version.

- Required: No
- Type: int
- Allowed:
  ```Bicep
  [
    1
    2
  ]
  ```

### Parameter: `flowLogs.location`

Location for all resources.

- Required: No
- Type: string

### Parameter: `flowLogs.name`

Name of the resource.

- Required: No
- Type: string

### Parameter: `flowLogs.retentionInDays`

Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.

- Required: No
- Type: int
- MinValue: 0
- MaxValue: 365

### Parameter: `flowLogs.tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `flowLogs.trafficAnalyticsInterval`

The interval in minutes which would decide how frequently TA service should do flow analytics.

- Required: No
- Type: int
- Allowed:
  ```Bicep
  [
    10
    60
  ]
  ```

### Parameter: `flowLogs.workspaceResourceId`

Specify the Log Analytics Workspace Resource ID.

- Required: No
- Type: string

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

### Parameter: `name`

Name of the Network Watcher resource (hidden).

- Required: No
- Type: string
- Default: `[format('NetworkWatcher_{0}', parameters('location'))]`

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Network Contributor'`
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

Tags of the resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed network watcher. |
| `resourceGroupName` | string | The resource group the network watcher was deployed into. |
| `resourceId` | string | The resource ID of the deployed network watcher. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.6.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
