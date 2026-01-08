# Container App Session Pool `[Microsoft.App/sessionPools]`

> ⚠️THIS MODULE IS CURRENTLY ORPHANED.⚠️
>
> - Only security and bug fixes are being handled by the AVM core team at present.
> - If interested in becoming the module owner of this orphaned module (must be Microsoft FTE), please look for the related "orphaned module" GitHub issue [here](https://aka.ms/AVM/OrphanedModules)!

This module deploys a Container App Session Pool.

You can reference the module as follows:
```bicep
module sessionPool 'br/public:avm/res/app/session-pool:<version>' = {
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
| `Microsoft.App/sessionPools` | 2025-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.app_sessionpools.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2025-07-01/sessionPools)</li></ul> |
| `Microsoft.Authorization/locks` | 2020-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_locks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks)</li></ul> |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/app/session-pool:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/defaults]


<details>

<summary>via Bicep module</summary>

```bicep
module sessionPool 'br/public:avm/res/app/session-pool:<version>' = {
  params: {
    // Required parameters
    containerType: 'PythonLTS'
    name: 'aspmin001'
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
    "containerType": {
      "value": "PythonLTS"
    },
    "name": {
      "value": "aspmin001"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/app/session-pool:<version>'

// Required parameters
param containerType = 'PythonLTS'
param name = 'aspmin001'
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/max]


<details>

<summary>via Bicep module</summary>

```bicep
module sessionPool 'br/public:avm/res/app/session-pool:<version>' = {
  params: {
    // Required parameters
    containerType: 'PythonLTS'
    name: 'aspmax001'
    // Non-required parameters
    dynamicPoolConfiguration: {
      lifecycleConfiguration: {
        cooldownPeriodInSeconds: 350
      }
    }
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    managedIdentitySettings: [
      {
        identity: '<identity>'
        lifecycle: 'Main'
      }
    ]
    poolManagementType: 'Dynamic'
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Azure ContainerApps Session Executor'
      }
    ]
    scaleConfiguration: {
      maxConcurrentSessions: 6
      readySessionInstances: 1
    }
    sessionNetworkConfiguration: {
      status: 'EgressDisabled'
    }
    tags: {
      resourceType: 'Session Pool'
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
    "containerType": {
      "value": "PythonLTS"
    },
    "name": {
      "value": "aspmax001"
    },
    // Non-required parameters
    "dynamicPoolConfiguration": {
      "value": {
        "lifecycleConfiguration": {
          "cooldownPeriodInSeconds": 350
        }
      }
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
    "managedIdentitySettings": {
      "value": [
        {
          "identity": "<identity>",
          "lifecycle": "Main"
        }
      ]
    },
    "poolManagementType": {
      "value": "Dynamic"
    },
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Azure ContainerApps Session Executor"
        }
      ]
    },
    "scaleConfiguration": {
      "value": {
        "maxConcurrentSessions": 6,
        "readySessionInstances": 1
      }
    },
    "sessionNetworkConfiguration": {
      "value": {
        "status": "EgressDisabled"
      }
    },
    "tags": {
      "value": {
        "resourceType": "Session Pool"
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
using 'br/public:avm/res/app/session-pool:<version>'

// Required parameters
param containerType = 'PythonLTS'
param name = 'aspmax001'
// Non-required parameters
param dynamicPoolConfiguration = {
  lifecycleConfiguration: {
    cooldownPeriodInSeconds: 350
  }
}
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param managedIdentitySettings = [
  {
    identity: '<identity>'
    lifecycle: 'Main'
  }
]
param poolManagementType = 'Dynamic'
param roleAssignments = [
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'Azure ContainerApps Session Executor'
  }
]
param scaleConfiguration = {
  maxConcurrentSessions: 6
  readySessionInstances: 1
}
param sessionNetworkConfiguration = {
  status: 'EgressDisabled'
}
param tags = {
  resourceType: 'Session Pool'
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
module sessionPool 'br/public:avm/res/app/session-pool:<version>' = {
  params: {
    // Required parameters
    containerType: 'PythonLTS'
    name: 'aspwaf001'
    // Non-required parameters
    tags: {
      resourceType: 'Session Pool'
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
    "containerType": {
      "value": "PythonLTS"
    },
    "name": {
      "value": "aspwaf001"
    },
    // Non-required parameters
    "tags": {
      "value": {
        "resourceType": "Session Pool"
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
using 'br/public:avm/res/app/session-pool:<version>'

// Required parameters
param containerType = 'PythonLTS'
param name = 'aspwaf001'
// Non-required parameters
param tags = {
  resourceType: 'Session Pool'
}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`containerType`](#parameter-containertype) | string | The container type of the sessions. |
| [`name`](#parameter-name) | string | Name of the Container App Session Pool. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`customContainerTemplate`](#parameter-customcontainertemplate) | object | The custom container configuration if the containerType is CustomContainer. Only set if containerType is CustomContainer. |
| [`dynamicPoolConfiguration`](#parameter-dynamicpoolconfiguration) | object | The pool configuration if the poolManagementType is dynamic. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`environmentResourceId`](#parameter-environmentresourceid) | string | Resource ID of the session pool's environment. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`managedIdentitySettings`](#parameter-managedidentitysettings) | array | Settings for a Managed Identity that is assigned to the Session pool. |
| [`poolManagementType`](#parameter-poolmanagementtype) | string | The pool management type of the session pool. Defaults to Dynamic. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`scaleConfiguration`](#parameter-scaleconfiguration) | object | The scale configuration of the session pool. |
| [`secrets`](#parameter-secrets) | array | The secrets of the session pool. |
| [`sessionNetworkConfiguration`](#parameter-sessionnetworkconfiguration) | object | The network configuration of the sessions in the session pool. |
| [`tags`](#parameter-tags) | object | Tags of the Automation Account resource. |

### Parameter: `containerType`

The container type of the sessions.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'CustomContainer'
    'PythonLTS'
  ]
  ```

### Parameter: `name`

Name of the Container App Session Pool.

- Required: Yes
- Type: string

### Parameter: `customContainerTemplate`

The custom container configuration if the containerType is CustomContainer. Only set if containerType is CustomContainer.

- Required: No
- Type: object

### Parameter: `dynamicPoolConfiguration`

The pool configuration if the poolManagementType is dynamic.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      lifecycleConfiguration: {
        cooldownPeriodInSeconds: 300
        lifecycleType: 'Timed'
      }
  }
  ```

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `environmentResourceId`

Resource ID of the session pool's environment.

- Required: No
- Type: string

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

### Parameter: `managedIdentitySettings`

Settings for a Managed Identity that is assigned to the Session pool.

- Required: No
- Type: array

### Parameter: `poolManagementType`

The pool management type of the session pool. Defaults to Dynamic.

- Required: No
- Type: string
- Default: `'Dynamic'`
- Allowed:
  ```Bicep
  [
    'Dynamic'
    'Manual'
  ]
  ```

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Azure ContainerApps Session Executor'`
  - `'Container Apps SessionPools Contributor'`
  - `'Container Apps SessionPools Reader'`
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

### Parameter: `scaleConfiguration`

The scale configuration of the session pool.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      maxConcurrentSessions: 5
  }
  ```

### Parameter: `secrets`

The secrets of the session pool.

- Required: No
- Type: array

### Parameter: `sessionNetworkConfiguration`

The network configuration of the sessions in the session pool.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      status: 'EgressDisabled'
  }
  ```

### Parameter: `tags`

Tags of the Automation Account resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `managementEndpoint` | string | The management endpoint of the session pool. |
| `name` | string | The name of the session pool. |
| `resourceGroupName` | string | The name of the resource group in which the session pool was created. |
| `resourceId` | string | The resource ID of the deployed session pool. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.6.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
