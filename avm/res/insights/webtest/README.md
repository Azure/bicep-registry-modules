# Web Tests `[Microsoft.Insights/webtests]`

This module deploys a Web Test.

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
| `Microsoft.Insights/webtests` | [2022-06-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2022-06-15/webtests) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/insights/webtest:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module webtest 'br/public:avm/res/insights/webtest:<version>' = {
  name: 'webtestDeployment'
  params: {
    // Required parameters
    appInsightResourceId: '<appInsightResourceId>'
    name: 'iwtmin001'
    request: {
      HttpVerb: 'GET'
      RequestUrl: 'https://learn.microsoft.com/en-us/'
    }
    webTestName: 'wt$iwtmin001'
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
    "appInsightResourceId": {
      "value": "<appInsightResourceId>"
    },
    "name": {
      "value": "iwtmin001"
    },
    "request": {
      "value": {
        "HttpVerb": "GET",
        "RequestUrl": "https://learn.microsoft.com/en-us/"
      }
    },
    "webTestName": {
      "value": "wt$iwtmin001"
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
module webtest 'br/public:avm/res/insights/webtest:<version>' = {
  name: 'webtestDeployment'
  params: {
    // Required parameters
    appInsightResourceId: '<appInsightResourceId>'
    name: 'iwtmax001'
    request: {
      HttpVerb: 'GET'
      RequestUrl: 'https://learn.microsoft.com/en-us/'
    }
    webTestName: 'wt$iwtmax001'
    // Non-required parameters
    location: '<location>'
    locations: [
      {
        Id: 'emea-nl-ams-azr'
      }
    ]
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
    syntheticMonitorId: 'iwtmax001'
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

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "appInsightResourceId": {
      "value": "<appInsightResourceId>"
    },
    "name": {
      "value": "iwtmax001"
    },
    "request": {
      "value": {
        "HttpVerb": "GET",
        "RequestUrl": "https://learn.microsoft.com/en-us/"
      }
    },
    "webTestName": {
      "value": "wt$iwtmax001"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "locations": {
      "value": [
        {
          "Id": "emea-nl-ams-azr"
        }
      ]
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
    "syntheticMonitorId": {
      "value": "iwtmax001"
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

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module webtest 'br/public:avm/res/insights/webtest:<version>' = {
  name: 'webtestDeployment'
  params: {
    // Required parameters
    appInsightResourceId: '<appInsightResourceId>'
    name: 'iwtwaf001'
    request: {
      HttpVerb: 'GET'
      RequestUrl: 'https://learn.microsoft.com/en-us/'
    }
    webTestName: 'wt$iwtwaf001'
    // Non-required parameters
    location: '<location>'
    locations: [
      {
        Id: 'emea-nl-ams-azr'
      }
    ]
    syntheticMonitorId: 'iwtwaf001'
    tags: {
      'hidden-title': 'This is visible in the resource name'
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
    "appInsightResourceId": {
      "value": "<appInsightResourceId>"
    },
    "name": {
      "value": "iwtwaf001"
    },
    "request": {
      "value": {
        "HttpVerb": "GET",
        "RequestUrl": "https://learn.microsoft.com/en-us/"
      }
    },
    "webTestName": {
      "value": "wt$iwtwaf001"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "locations": {
      "value": [
        {
          "Id": "emea-nl-ams-azr"
        }
      ]
    },
    "syntheticMonitorId": {
      "value": "iwtwaf001"
    },
    "tags": {
      "value": {
        "hidden-title": "This is visible in the resource name"
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
| [`appInsightResourceId`](#parameter-appinsightresourceid) | string | Resource ID of the App Insights resource to link with this webtest. |
| [`name`](#parameter-name) | string | Name of the webtest. |
| [`request`](#parameter-request) | object | The collection of request properties. |
| [`webTestName`](#parameter-webtestname) | string | User defined name if this WebTest. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`configuration`](#parameter-configuration) | object | An XML configuration specification for a WebTest. |
| [`description`](#parameter-description) | string | User defined description for this WebTest. |
| [`enabled`](#parameter-enabled) | bool | Is the test actively being monitored. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`frequency`](#parameter-frequency) | int | Interval in seconds between test runs for this WebTest. |
| [`kind`](#parameter-kind) | string | The kind of WebTest that this web test watches. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`locations`](#parameter-locations) | array | List of where to physically run the tests from to give global coverage for accessibility of your application. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`retryEnabled`](#parameter-retryenabled) | bool | Allow for retries should this WebTest fail. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`syntheticMonitorId`](#parameter-syntheticmonitorid) | string | Unique ID of this WebTest. |
| [`tags`](#parameter-tags) | object | Resource tags. Note: a mandatory tag 'hidden-link' based on the 'appInsightResourceId' parameter will be automatically added to the tags defined here. |
| [`timeout`](#parameter-timeout) | int | Seconds until this WebTest will timeout and fail. |
| [`validationRules`](#parameter-validationrules) | object | The collection of validation rule properties. |

### Parameter: `appInsightResourceId`

Resource ID of the App Insights resource to link with this webtest.

- Required: Yes
- Type: string

### Parameter: `name`

Name of the webtest.

- Required: Yes
- Type: string

### Parameter: `request`

The collection of request properties.

- Required: Yes
- Type: object

### Parameter: `webTestName`

User defined name if this WebTest.

- Required: Yes
- Type: string

### Parameter: `configuration`

An XML configuration specification for a WebTest.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `description`

User defined description for this WebTest.

- Required: No
- Type: string
- Default: `''`

### Parameter: `enabled`

Is the test actively being monitored.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `frequency`

Interval in seconds between test runs for this WebTest.

- Required: No
- Type: int
- Default: `300`

### Parameter: `kind`

The kind of WebTest that this web test watches.

- Required: No
- Type: string
- Default: `'standard'`
- Allowed:
  ```Bicep
  [
    'multistep'
    'ping'
    'standard'
  ]
  ```

### Parameter: `location`

Location for all Resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `locations`

List of where to physically run the tests from to give global coverage for accessibility of your application.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    {
      Id: 'us-il-ch1-azr'
    }
    {
      Id: 'us-fl-mia-edge'
    }
    {
      Id: 'latam-br-gru-edge'
    }
    {
      Id: 'apac-sg-sin-azr'
    }
    {
      Id: 'emea-nl-ams-azr'
    }
  ]
  ```

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

### Parameter: `retryEnabled`

Allow for retries should this WebTest fail.

- Required: No
- Type: bool
- Default: `True`

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

### Parameter: `syntheticMonitorId`

Unique ID of this WebTest.

- Required: No
- Type: string
- Default: `[parameters('name')]`

### Parameter: `tags`

Resource tags. Note: a mandatory tag 'hidden-link' based on the 'appInsightResourceId' parameter will be automatically added to the tags defined here.

- Required: No
- Type: object

### Parameter: `timeout`

Seconds until this WebTest will timeout and fail.

- Required: No
- Type: int
- Default: `30`

### Parameter: `validationRules`

The collection of validation rule properties.

- Required: No
- Type: object
- Default: `{}`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the webtest. |
| `resourceGroupName` | string | The resource group the resource was deployed into. |
| `resourceId` | string | The resource ID of the webtest. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
