# Logic App Integration Account `[Microsoft.Logic/integrationAccounts]`

This module deploys a Logic App Integration Account.

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
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_diagnosticsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)</li></ul> |
| `Microsoft.Logic/integrationAccounts` | 2019-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.logic_integrationaccounts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Logic/2019-05-01/integrationAccounts)</li></ul> |
| `Microsoft.Logic/integrationAccounts/maps` | 2019-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.logic_integrationaccounts_maps.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Logic/2019-05-01/integrationAccounts/maps)</li></ul> |
| `Microsoft.Logic/integrationAccounts/partners` | 2019-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.logic_integrationaccounts_partners.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Logic/2019-05-01/integrationAccounts/partners)</li></ul> |
| `Microsoft.Logic/integrationAccounts/schemas` | 2019-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.logic_integrationaccounts_schemas.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Logic/2019-05-01/integrationAccounts/schemas)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/logic/integration-account:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module integrationAccount 'br/public:avm/res/logic/integration-account:<version>' = {
  name: 'integrationAccountDeployment'
  params: {
    // Required parameters
    name: 'iamin001'
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
    "name": {
      "value": "iamin001"
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
using 'br/public:avm/res/logic/integration-account:<version>'

// Required parameters
param name = 'iamin001'
// Non-required parameters
param location = '<location>'
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module integrationAccount 'br/public:avm/res/logic/integration-account:<version>' = {
  name: 'integrationAccountDeployment'
  params: {
    // Required parameters
    name: 'iamax001'
    // Non-required parameters
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        logCategoriesAndGroups: [
          {
            categoryGroup: 'allLogs'
            enabled: true
          }
        ]
        metricCategories: []
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    maps: [
      {
        content: '<content>'
        metadata: {
          key1: 'value1'
          key2: 'value2'
        }
        name: 'map1'
        parametersSchema: {
          properties: {
            discountRate: {
              type: 'number'
            }
          }
          required: [
            'discountRate'
          ]
          type: 'object'
        }
        tags: {
          tag1: 'value1'
          tag2: 'value2'
        }
      }
    ]
    partners: [
      {
        b2bPartnerContent: {
          businessIdentities: [
            {
              qualifier: 'ZZ'
              value: '1234567890'
            }
            {
              qualifier: 'ZZZ'
              value: '0987654321'
            }
          ]
          partnerClassification: 'Distributor'
          partnerContact: {
            emailAddress: 'john.doe@example.com'
            faxNumber: '123-456-7891'
            name: 'John Doe'
            supplyChainCode: 'SC123'
            telephoneNumber: '123-456-7890'
          }
        }
        metadata: {
          key1: 'value1'
          key2: 'value2'
        }
        name: 'partner1'
        tags: {
          tag1: 'value1'
          tag2: 'value2'
        }
      }
      {
        b2bPartnerContent: {
          businessIdentities: []
        }
        metadata: {
          key1: 'value1'
          key2: 'value2'
        }
        name: 'partner2'
        tags: {
          tag1: 'value1'
          tag2: 'value2'
        }
      }
    ]
    roleAssignments: [
      {
        name: '1f98c16b-ea00-4686-8b81-05353b594ea3'
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
    schemas: [
      {
        content: '<content>'
        metadata: {
          key1: 'value1'
          key2: 'value2'
        }
        name: 'schema1'
        schemaType: 'Xml'
        tags: {
          tag1: 'value1'
          tag2: 'value2'
        }
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
    // Required parameters
    "name": {
      "value": "iamax001"
    },
    // Non-required parameters
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "logCategoriesAndGroups": [
            {
              "categoryGroup": "allLogs",
              "enabled": true
            }
          ],
          "metricCategories": [],
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
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
    "maps": {
      "value": [
        {
          "content": "<content>",
          "metadata": {
            "key1": "value1",
            "key2": "value2"
          },
          "name": "map1",
          "parametersSchema": {
            "properties": {
              "discountRate": {
                "type": "number"
              }
            },
            "required": [
              "discountRate"
            ],
            "type": "object"
          },
          "tags": {
            "tag1": "value1",
            "tag2": "value2"
          }
        }
      ]
    },
    "partners": {
      "value": [
        {
          "b2bPartnerContent": {
            "businessIdentities": [
              {
                "qualifier": "ZZ",
                "value": "1234567890"
              },
              {
                "qualifier": "ZZZ",
                "value": "0987654321"
              }
            ],
            "partnerClassification": "Distributor",
            "partnerContact": {
              "emailAddress": "john.doe@example.com",
              "faxNumber": "123-456-7891",
              "name": "John Doe",
              "supplyChainCode": "SC123",
              "telephoneNumber": "123-456-7890"
            }
          },
          "metadata": {
            "key1": "value1",
            "key2": "value2"
          },
          "name": "partner1",
          "tags": {
            "tag1": "value1",
            "tag2": "value2"
          }
        },
        {
          "b2bPartnerContent": {
            "businessIdentities": []
          },
          "metadata": {
            "key1": "value1",
            "key2": "value2"
          },
          "name": "partner2",
          "tags": {
            "tag1": "value1",
            "tag2": "value2"
          }
        }
      ]
    },
    "roleAssignments": {
      "value": [
        {
          "name": "1f98c16b-ea00-4686-8b81-05353b594ea3",
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
    "schemas": {
      "value": [
        {
          "content": "<content>",
          "metadata": {
            "key1": "value1",
            "key2": "value2"
          },
          "name": "schema1",
          "schemaType": "Xml",
          "tags": {
            "tag1": "value1",
            "tag2": "value2"
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
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/logic/integration-account:<version>'

// Required parameters
param name = 'iamax001'
// Non-required parameters
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    logCategoriesAndGroups: [
      {
        categoryGroup: 'allLogs'
        enabled: true
      }
    ]
    metricCategories: []
    name: 'customSetting'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param maps = [
  {
    content: '<content>'
    metadata: {
      key1: 'value1'
      key2: 'value2'
    }
    name: 'map1'
    parametersSchema: {
      properties: {
        discountRate: {
          type: 'number'
        }
      }
      required: [
        'discountRate'
      ]
      type: 'object'
    }
    tags: {
      tag1: 'value1'
      tag2: 'value2'
    }
  }
]
param partners = [
  {
    b2bPartnerContent: {
      businessIdentities: [
        {
          qualifier: 'ZZ'
          value: '1234567890'
        }
        {
          qualifier: 'ZZZ'
          value: '0987654321'
        }
      ]
      partnerClassification: 'Distributor'
      partnerContact: {
        emailAddress: 'john.doe@example.com'
        faxNumber: '123-456-7891'
        name: 'John Doe'
        supplyChainCode: 'SC123'
        telephoneNumber: '123-456-7890'
      }
    }
    metadata: {
      key1: 'value1'
      key2: 'value2'
    }
    name: 'partner1'
    tags: {
      tag1: 'value1'
      tag2: 'value2'
    }
  }
  {
    b2bPartnerContent: {
      businessIdentities: []
    }
    metadata: {
      key1: 'value1'
      key2: 'value2'
    }
    name: 'partner2'
    tags: {
      tag1: 'value1'
      tag2: 'value2'
    }
  }
]
param roleAssignments = [
  {
    name: '1f98c16b-ea00-4686-8b81-05353b594ea3'
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
param schemas = [
  {
    content: '<content>'
    metadata: {
      key1: 'value1'
      key2: 'value2'
    }
    name: 'schema1'
    schemaType: 'Xml'
    tags: {
      tag1: 'value1'
      tag2: 'value2'
    }
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


<details>

<summary>via Bicep module</summary>

```bicep
module integrationAccount 'br/public:avm/res/logic/integration-account:<version>' = {
  name: 'integrationAccountDeployment'
  params: {
    // Required parameters
    name: 'liawaf001'
    // Non-required parameters
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        logCategoriesAndGroups: [
          {
            categoryGroup: 'allLogs'
            enabled: true
          }
        ]
        metricCategories: []
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    roleAssignments: [
      {
        name: '1f98c16b-ea00-4686-8b81-05353b594ea3'
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
    // Required parameters
    "name": {
      "value": "liawaf001"
    },
    // Non-required parameters
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "logCategoriesAndGroups": [
            {
              "categoryGroup": "allLogs",
              "enabled": true
            }
          ],
          "metricCategories": [],
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
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
    "roleAssignments": {
      "value": [
        {
          "name": "1f98c16b-ea00-4686-8b81-05353b594ea3",
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
using 'br/public:avm/res/logic/integration-account:<version>'

// Required parameters
param name = 'liawaf001'
// Non-required parameters
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    logCategoriesAndGroups: [
      {
        categoryGroup: 'allLogs'
        enabled: true
      }
    ]
    metricCategories: []
    name: 'customSetting'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param roleAssignments = [
  {
    name: '1f98c16b-ea00-4686-8b81-05353b594ea3'
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

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the integration account to create. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`maps`](#parameter-maps) | array | All maps to create. |
| [`partners`](#parameter-partners) | array | All partners to create. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`schemas`](#parameter-schemas) | array | All schemas to create. |
| [`sku`](#parameter-sku) | string | Integration account sku name. |
| [`state`](#parameter-state) | string | The state. - Completed, Deleted, Disabled, Enabled, NotSpecified, Suspended. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `name`

Name of the integration account to create.

- Required: Yes
- Type: string

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
| [`name`](#parameter-diagnosticsettingsname) | string | The name of the diagnostic setting. |
| [`storageAccountResourceId`](#parameter-diagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
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

The name of the diagnostic setting.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
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

### Parameter: `maps`

All maps to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`content`](#parameter-mapscontent) | string | The content of the map. |
| [`name`](#parameter-mapsname) | string | The name of the map resource. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`contentType`](#parameter-mapscontenttype) | string | The content type of the map. |
| [`mapType`](#parameter-mapsmaptype) | string | The map type. Default is "Xslt". |
| [`metadata`](#parameter-mapsmetadata) | object | The map metadata. |
| [`parametersSchema`](#parameter-mapsparametersschema) | object | The parameters schema of integration account map. |
| [`tags`](#parameter-mapstags) | object | Resource tags. |

### Parameter: `maps.content`

The content of the map.

- Required: Yes
- Type: string

### Parameter: `maps.name`

The name of the map resource.

- Required: Yes
- Type: string

### Parameter: `maps.contentType`

The content type of the map.

- Required: No
- Type: string

### Parameter: `maps.mapType`

The map type. Default is "Xslt".

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Liquid'
    'NotSpecified'
    'Xslt'
    'Xslt20'
    'Xslt30'
  ]
  ```

### Parameter: `maps.metadata`

The map metadata.

- Required: No
- Type: object

### Parameter: `maps.parametersSchema`

The parameters schema of integration account map.

- Required: No
- Type: object

### Parameter: `maps.tags`

Resource tags.

- Required: No
- Type: object

### Parameter: `partners`

All partners to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-partnersname) | string | The Name of the partner resource. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`b2bPartnerContent`](#parameter-partnersb2bpartnercontent) | object | The B2B partner content settings. |
| [`metadata`](#parameter-partnersmetadata) | object | The partner metadata. |
| [`tags`](#parameter-partnerstags) | object | Resource tags. |

### Parameter: `partners.name`

The Name of the partner resource.

- Required: Yes
- Type: string

### Parameter: `partners.b2bPartnerContent`

The B2B partner content settings.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`businessIdentities`](#parameter-partnersb2bpartnercontentbusinessidentities) | array | The list of partner business identities. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`partnerClassification`](#parameter-partnersb2bpartnercontentpartnerclassification) | string | The partner classification. |
| [`partnerContact`](#parameter-partnersb2bpartnercontentpartnercontact) | object | The RosettaNet partner properties. |

### Parameter: `partners.b2bPartnerContent.businessIdentities`

The list of partner business identities.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`qualifier`](#parameter-partnersb2bpartnercontentbusinessidentitiesqualifier) | string | The business identity qualifier e.g. as2identity, ZZ, ZZZ, 31, 32. |
| [`value`](#parameter-partnersb2bpartnercontentbusinessidentitiesvalue) | string | The user defined business identity value. |

### Parameter: `partners.b2bPartnerContent.businessIdentities.qualifier`

The business identity qualifier e.g. as2identity, ZZ, ZZZ, 31, 32.

- Required: Yes
- Type: string

### Parameter: `partners.b2bPartnerContent.businessIdentities.value`

The user defined business identity value.

- Required: Yes
- Type: string

### Parameter: `partners.b2bPartnerContent.partnerClassification`

The partner classification.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Carrier'
    'Distributor'
    'EndUser'
    'EndUserGovernment'
    'Financier'
    'FreightForwarder'
    'Manufacturer'
    'MarketPlace'
    'Retailer'
    'Shopper'
  ]
  ```

### Parameter: `partners.b2bPartnerContent.partnerContact`

The RosettaNet partner properties.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`emailAddress`](#parameter-partnersb2bpartnercontentpartnercontactemailaddress) | string | The email address of the partner. |
| [`faxNumber`](#parameter-partnersb2bpartnercontentpartnercontactfaxnumber) | string | The fax number of the partner. |
| [`name`](#parameter-partnersb2bpartnercontentpartnercontactname) | string | The name of the contact person. |
| [`supplyChainCode`](#parameter-partnersb2bpartnercontentpartnercontactsupplychaincode) | string | The supply chain code of the partner. |
| [`telephoneNumber`](#parameter-partnersb2bpartnercontentpartnercontacttelephonenumber) | string | The phone number of the partner. |

### Parameter: `partners.b2bPartnerContent.partnerContact.emailAddress`

The email address of the partner.

- Required: No
- Type: string

### Parameter: `partners.b2bPartnerContent.partnerContact.faxNumber`

The fax number of the partner.

- Required: No
- Type: string

### Parameter: `partners.b2bPartnerContent.partnerContact.name`

The name of the contact person.

- Required: No
- Type: string

### Parameter: `partners.b2bPartnerContent.partnerContact.supplyChainCode`

The supply chain code of the partner.

- Required: No
- Type: string

### Parameter: `partners.b2bPartnerContent.partnerContact.telephoneNumber`

The phone number of the partner.

- Required: No
- Type: string

### Parameter: `partners.metadata`

The partner metadata.

- Required: No
- Type: object

### Parameter: `partners.tags`

Resource tags.

- Required: No
- Type: object

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'App Compliance Automation Administrator'`
  - `'App Compliance Automation Reader'`
  - `'Contributor'`
  - `'Log Analytics Contributor'`
  - `'Log Analytics Reader'`
  - `'Logic App Contributor'`
  - `'Logic App Operator'`
  - `'Managed Application Contributor Role'`
  - `'Managed Application Operator Role'`
  - `'Managed Application Publisher Operator'`
  - `'Monitoring Contributor'`
  - `'Monitoring Metrics Publisher'`
  - `'Monitoring Reader'`
  - `'Resource Policy Contributor'`
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

### Parameter: `schemas`

All schemas to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`content`](#parameter-schemascontent) | string | The schema content. |
| [`name`](#parameter-schemasname) | string | The Name of the schema resource. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`contentType`](#parameter-schemascontenttype) | string | The schema content type. |
| [`documentName`](#parameter-schemasdocumentname) | string | The document name. |
| [`metadata`](#parameter-schemasmetadata) | object | The schema metadata. |
| [`schemaType`](#parameter-schemasschematype) | string | The schema type. |
| [`tags`](#parameter-schemastags) | object | Resource tags. |
| [`targetNamespace`](#parameter-schemastargetnamespace) | string | The target namespace of the schema. |

### Parameter: `schemas.content`

The schema content.

- Required: Yes
- Type: string

### Parameter: `schemas.name`

The Name of the schema resource.

- Required: Yes
- Type: string

### Parameter: `schemas.contentType`

The schema content type.

- Required: No
- Type: string

### Parameter: `schemas.documentName`

The document name.

- Required: No
- Type: string

### Parameter: `schemas.metadata`

The schema metadata.

- Required: No
- Type: object

### Parameter: `schemas.schemaType`

The schema type.

- Required: No
- Type: string

### Parameter: `schemas.tags`

Resource tags.

- Required: No
- Type: object

### Parameter: `schemas.targetNamespace`

The target namespace of the schema.

- Required: No
- Type: string

### Parameter: `sku`

Integration account sku name.

- Required: No
- Type: string
- Default: `'Standard'`
- Allowed:
  ```Bicep
  [
    'Basic'
    'Free'
    'NotSpecified'
    'Standard'
  ]
  ```

### Parameter: `state`

The state. - Completed, Deleted, Disabled, Enabled, NotSpecified, Suspended.

- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed:
  ```Bicep
  [
    'Completed'
    'Deleted'
    'Disabled'
    'Enabled'
    'NotSpecified'
    'Suspended'
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
| `name` | string | The name of the integration account. |
| `resourceGroupName` | string | The resource group the integration account was deployed into. |
| `resourceId` | string | The resource ID of the integration account. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.2.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
