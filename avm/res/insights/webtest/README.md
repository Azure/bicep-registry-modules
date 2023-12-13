# Web Tests `[Microsoft.Insights/webtests]`

This module deploys a Web Test.

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
| `Microsoft.Insights/webtests` | [2022-06-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2022-06-15/webtests) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/insights.webtest:1.0.0`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module webtest 'br:bicep/modules/insights.webtest:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-iwtmin'
  params: {
    // Required parameters
    name: 'iwtmin001'
    request: {
      HttpVerb: 'GET'
      RequestUrl: 'https://learn.microsoft.com/en-us/'
    }
    tags: {
      'hidden-link:${nestedDependencies.outputs.appInsightResourceId}': 'Resource'
      'hidden-title': 'This is visible in the resource name'
    }
    webTestName: 'wt$iwtmin001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
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
      "value": "iwtmin001"
    },
    "request": {
      "value": {
        "HttpVerb": "GET",
        "RequestUrl": "https://learn.microsoft.com/en-us/"
      }
    },
    "tags": {
      "value": {
        "hidden-link:${nestedDependencies.outputs.appInsightResourceId}": "Resource",
        "hidden-title": "This is visible in the resource name"
      }
    },
    "webTestName": {
      "value": "wt$iwtmin001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
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
module webtest 'br:bicep/modules/insights.webtest:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-iwtmax'
  params: {
    // Required parameters
    name: 'iwtmax001'
    request: {
      HttpVerb: 'GET'
      RequestUrl: 'https://learn.microsoft.com/en-us/'
    }
    tags: {
      'hidden-link:${nestedDependencies.outputs.appInsightResourceId}': 'Resource'
      'hidden-title': 'This is visible in the resource name'
    }
    webTestName: 'wt$iwtmax001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    locations: [
      {
        Id: 'emea-nl-ams-azr'
      }
    ]
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    syntheticMonitorId: 'iwtmax001'
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
      "value": "iwtmax001"
    },
    "request": {
      "value": {
        "HttpVerb": "GET",
        "RequestUrl": "https://learn.microsoft.com/en-us/"
      }
    },
    "tags": {
      "value": {
        "hidden-link:${nestedDependencies.outputs.appInsightResourceId}": "Resource",
        "hidden-title": "This is visible in the resource name"
      }
    },
    "webTestName": {
      "value": "wt$iwtmax001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
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
    "syntheticMonitorId": {
      "value": "iwtmax001"
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
module webtest 'br:bicep/modules/insights.webtest:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-iwtwaf'
  params: {
    // Required parameters
    name: 'iwtwaf001'
    request: {
      HttpVerb: 'GET'
      RequestUrl: 'https://learn.microsoft.com/en-us/'
    }
    tags: {
      'hidden-link:${nestedDependencies.outputs.appInsightResourceId}': 'Resource'
      'hidden-title': 'This is visible in the resource name'
    }
    webTestName: 'wt$iwtwaf001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    locations: [
      {
        Id: 'emea-nl-ams-azr'
      }
    ]
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    syntheticMonitorId: 'iwtwaf001'
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
      "value": "iwtwaf001"
    },
    "request": {
      "value": {
        "HttpVerb": "GET",
        "RequestUrl": "https://learn.microsoft.com/en-us/"
      }
    },
    "tags": {
      "value": {
        "hidden-link:${nestedDependencies.outputs.appInsightResourceId}": "Resource",
        "hidden-title": "This is visible in the resource name"
      }
    },
    "webTestName": {
      "value": "wt$iwtwaf001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
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
    "syntheticMonitorId": {
      "value": "iwtwaf001"
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
| [`name`](#parameter-name) | string | Name of the webtest. |
| [`request`](#parameter-request) | object | The collection of request properties. |
| [`tags`](#parameter-tags) | object | A single hidden-link tag pointing to an existing AI component is required. |
| [`webTestName`](#parameter-webtestname) | string | User defined name if this WebTest. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`configuration`](#parameter-configuration) | object | An XML configuration specification for a WebTest. |
| [`description`](#parameter-description) | string | User defined description for this WebTest. |
| [`enabled`](#parameter-enabled) | bool | Is the test actively being monitored. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`frequency`](#parameter-frequency) | int | Interval in seconds between test runs for this WebTest. |
| [`kind`](#parameter-kind) | string | The kind of WebTest that this web test watches. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`locations`](#parameter-locations) | array | List of where to physically run the tests from to give global coverage for accessibility of your application. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`retryEnabled`](#parameter-retryenabled) | bool | Allow for retries should this WebTest fail. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`syntheticMonitorId`](#parameter-syntheticmonitorid) | string | Unique ID of this WebTest. |
| [`timeout`](#parameter-timeout) | int | Seconds until this WebTest will timeout and fail. |
| [`validationRules`](#parameter-validationrules) | object | The collection of validation rule properties. |

### Parameter: `name`

Name of the webtest.

- Required: Yes
- Type: string

### Parameter: `request`

The collection of request properties.

- Required: Yes
- Type: object

### Parameter: `tags`

A single hidden-link tag pointing to an existing AI component is required.

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

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).

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

### Parameter: `syntheticMonitorId`

Unique ID of this WebTest.

- Required: No
- Type: string
- Default: `[parameters('name')]`

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
