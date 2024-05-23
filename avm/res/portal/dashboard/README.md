# Portal Dashboards `[Microsoft.Portal/dashboards]`

This module deploys a Portal Dashboard.

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
| `Microsoft.Portal/dashboards` | [2020-09-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Portal/2020-09-01-preview/dashboards) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/portal/dashboard:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module dashboard 'br/public:avm/res/portal/dashboard:<version>' = {
  name: 'dashboardDeployment'
  params: {
    // Required parameters
    name: 'pdmin001'
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
      "value": "pdmin001"
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

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module dashboard 'br/public:avm/res/portal/dashboard:<version>' = {
  name: 'dashboardDeployment'
  params: {
    // Required parameters
    name: 'pdmax001'
    // Non-required parameters
    lenses: [
      {
        order: 0
        parts: [
          {
            metadata: {
              inputs: []
              type: 'Extension/Microsoft_Azure_Security/PartType/SecurityMetricGalleryTileViewModel'
            }
            position: {
              colSpan: 2
              rowSpan: 3
              x: 0
              y: 0
            }
          }
          {
            metadata: {
              inputs: [
                {
                  isOptional: true
                  name: 'isShared'
                }
                {
                  isOptional: true
                  name: 'queryId'
                }
                {
                  isOptional: true
                  name: 'formatResults'
                }
                {
                  isOptional: true
                  name: 'partTitle'
                  value: 'Query 1'
                }
                {
                  isOptional: true
                  name: 'chartType'
                  value: 1
                }
                {
                  isOptional: true
                  name: 'queryScope'
                  value: {
                    scope: 0
                    values: []
                  }
                }
                {
                  isOptional: true
                  name: 'query'
                  value: 'summarize ResourceCount=count() by type\n| order by ResourceCount desc\n| take 5\n| project [\'Resource Type\']=type, [\'Resource Count\']=ResourceCount'
                }
              ]
              partHeader: {
                subtitle: ''
                title: 'Top 5 resource types'
              }
              settings: {}
              type: 'Extension/HubsExtension/PartType/ArgQueryChartTile'
            }
            position: {
              colSpan: 9
              rowSpan: 3
              x: 2
              y: 0
            }
          }
        ]
      }
    ]
    location: '<location>'
    metadata: {
      model: {
        filterLocale: {
          value: 'en-us'
        }
        filters: {
          value: {
            MsPortalFx_TimeRange: {
              displayCache: {
                name: 'UTC Time'
                value: 'Past 24 hours'
              }
              filteredPartIds: []
              model: {
                format: 'utc'
                granularity: 'auto'
                relative: '24h'
              }
            }
          }
        }
        timeRange: {
          type: 'MsPortalFx.Composition.Configuration.ValueTypes.TimeRange'
          value: {
            relative: {
              duration: 24
              timeUnit: 1
            }
          }
        }
      }
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
    "name": {
      "value": "pdmax001"
    },
    // Non-required parameters
    "lenses": {
      "value": [
        {
          "order": 0,
          "parts": [
            {
              "metadata": {
                "inputs": [],
                "type": "Extension/Microsoft_Azure_Security/PartType/SecurityMetricGalleryTileViewModel"
              },
              "position": {
                "colSpan": 2,
                "rowSpan": 3,
                "x": 0,
                "y": 0
              }
            },
            {
              "metadata": {
                "inputs": [
                  {
                    "isOptional": true,
                    "name": "isShared"
                  },
                  {
                    "isOptional": true,
                    "name": "queryId"
                  },
                  {
                    "isOptional": true,
                    "name": "formatResults"
                  },
                  {
                    "isOptional": true,
                    "name": "partTitle",
                    "value": "Query 1"
                  },
                  {
                    "isOptional": true,
                    "name": "chartType",
                    "value": 1
                  },
                  {
                    "isOptional": true,
                    "name": "queryScope",
                    "value": {
                      "scope": 0,
                      "values": []
                    }
                  },
                  {
                    "isOptional": true,
                    "name": "query",
                    "value": "summarize ResourceCount=count() by type\n| order by ResourceCount desc\n| take 5\n| project [\"Resource Type\"]=type, [\"Resource Count\"]=ResourceCount"
                  }
                ],
                "partHeader": {
                  "subtitle": "",
                  "title": "Top 5 resource types"
                },
                "settings": {},
                "type": "Extension/HubsExtension/PartType/ArgQueryChartTile"
              },
              "position": {
                "colSpan": 9,
                "rowSpan": 3,
                "x": 2,
                "y": 0
              }
            }
          ]
        }
      ]
    },
    "location": {
      "value": "<location>"
    },
    "metadata": {
      "value": {
        "model": {
          "filterLocale": {
            "value": "en-us"
          },
          "filters": {
            "value": {
              "MsPortalFx_TimeRange": {
                "displayCache": {
                  "name": "UTC Time",
                  "value": "Past 24 hours"
                },
                "filteredPartIds": [],
                "model": {
                  "format": "utc",
                  "granularity": "auto",
                  "relative": "24h"
                }
              }
            }
          },
          "timeRange": {
            "type": "MsPortalFx.Composition.Configuration.ValueTypes.TimeRange",
            "value": {
              "relative": {
                "duration": 24,
                "timeUnit": 1
              }
            }
          }
        }
      }
    }
  }
}
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module dashboard 'br/public:avm/res/portal/dashboard:<version>' = {
  name: 'dashboardDeployment'
  params: {
    // Required parameters
    name: 'pdwaf001'
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
      "value": "pdwaf001"
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


## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the dashboard to create. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`lenses`](#parameter-lenses) | array | The dashboard lenses. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`metadata`](#parameter-metadata) | object | The dashboard metadata. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `name`

Name of the dashboard to create.

- Required: Yes
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `lenses`

The dashboard lenses.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `location`

Location for all Resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `metadata`

The dashboard metadata.

- Required: No
- Type: object

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the dashboard was deployed into. |
| `name` | string | The name of the dashboard. |
| `resourceId` | string | The resource ID of the dashboard. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
