# Container App Session Pool `[Microsoft.App/sessionPools]`

This module deploys a Container App Session Pool.

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
| `Microsoft.App/sessionPools` | [2024-10-02-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2024-10-02-preview/sessionPools) |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/app/session-pool:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module sessionPool 'br/public:avm/res/app/session-pool:<version>' = {
  name: 'sessionPoolDeployment'
  params: {
    // Required parameters
    containerType: 'PythonLTS'
    name: 'aspmin001'
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
    "containerType": {
      "value": "PythonLTS"
    },
    "name": {
      "value": "aspmin001"
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
using 'br/public:avm/res/app/session-pool:<version>'

// Required parameters
param containerType = 'PythonLTS'
param name = 'aspmin001'
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
module sessionPool 'br/public:avm/res/app/session-pool:<version>' = {
  name: 'sessionPoolDeployment'
  params: {
    // Required parameters
    containerType: 'PythonLTS'
    name: 'aspmax001'
    // Non-required parameters
    cooldownPeriodInSeconds: 350
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
    maxConcurrentSessions: 6
    poolManagementType: 'Dynamic'
    readySessionInstances: 1
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Azure ContainerApps Session Executor'
      }
    ]
    sessionNetworkStatus: 'EgressDisabled'
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
    "cooldownPeriodInSeconds": {
      "value": 350
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
    "maxConcurrentSessions": {
      "value": 6
    },
    "poolManagementType": {
      "value": "Dynamic"
    },
    "readySessionInstances": {
      "value": 1
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
    "sessionNetworkStatus": {
      "value": "EgressDisabled"
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
param cooldownPeriodInSeconds = 350
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
param maxConcurrentSessions = 6
param poolManagementType = 'Dynamic'
param readySessionInstances = 1
param roleAssignments = [
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'Azure ContainerApps Session Executor'
  }
]
param sessionNetworkStatus = 'EgressDisabled'
param tags = {
  resourceType: 'Session Pool'
}
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module sessionPool 'br/public:avm/res/app/session-pool:<version>' = {
  name: 'sessionPoolDeployment'
  params: {
    // Required parameters
    containerType: 'PythonLTS'
    name: 'aspwaf001'
    // Non-required parameters
    location: '<location>'
    sessionNetworkStatus: 'EgressDisabled'
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
    "location": {
      "value": "<location>"
    },
    "sessionNetworkStatus": {
      "value": "EgressDisabled"
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
param name = 'aspwaf001'
// Non-required parameters
param location = '<location>'
param sessionNetworkStatus = 'EgressDisabled'
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
| [`containers`](#parameter-containers) | array | Custom container definitions. Only required if containerType is CustomContainer. |
| [`cooldownPeriodInSeconds`](#parameter-cooldownperiodinseconds) | int | The cooldown period of a session in seconds. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`environmentId`](#parameter-environmentid) | string | Resource ID of the session pool's environment. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`managedIdentitySettings`](#parameter-managedidentitysettings) | array | Settings for a Managed Identity that is assigned to the Session pool. |
| [`maxConcurrentSessions`](#parameter-maxconcurrentsessions) | int | The maximum count of sessions at the same time. |
| [`poolManagementType`](#parameter-poolmanagementtype) | string | The pool management type of the session pool. Defaults to Dynamic. |
| [`readySessionInstances`](#parameter-readysessioninstances) | int | The minimum count of ready session instances. |
| [`registryCredentials`](#parameter-registrycredentials) | object | Container registry credentials. Only required if containerType is CustomContainer and the container registry requires authentication. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`sessionNetworkStatus`](#parameter-sessionnetworkstatus) | string | Network status for the sessions. Defaults to EgressDisabled. |
| [`tags`](#parameter-tags) | object | Tags of the Automation Account resource. |
| [`targetIngressPort`](#parameter-targetingressport) | int | Required if containerType == 'CustomContainer'. Target port in containers for traffic from ingress. Only required if containerType is CustomContainer. |

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

### Parameter: `containers`

Custom container definitions. Only required if containerType is CustomContainer.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`image`](#parameter-containersimage) | string | Container image tag. |
| [`name`](#parameter-containersname) | string | Custom container name. |
| [`resources`](#parameter-containersresources) | object | Container resource requirements. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`args`](#parameter-containersargs) | array | Container start command arguments. |
| [`command`](#parameter-containerscommand) | array | Container start command. |
| [`env`](#parameter-containersenv) | array | Container environment variables. |

### Parameter: `containers.image`

Container image tag.

- Required: Yes
- Type: string

### Parameter: `containers.name`

Custom container name.

- Required: Yes
- Type: string

### Parameter: `containers.resources`

Container resource requirements.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`cpu`](#parameter-containersresourcescpu) | string | Required CPU in cores, e.g. 0.5. |
| [`memory`](#parameter-containersresourcesmemory) | string | Required memory, e.g. "1.25Gi". |

### Parameter: `containers.resources.cpu`

Required CPU in cores, e.g. 0.5.

- Required: Yes
- Type: string

### Parameter: `containers.resources.memory`

Required memory, e.g. "1.25Gi".

- Required: Yes
- Type: string

### Parameter: `containers.args`

Container start command arguments.

- Required: No
- Type: array

### Parameter: `containers.command`

Container start command.

- Required: No
- Type: array

### Parameter: `containers.env`

Container environment variables.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-containersenvname) | string | Environment variable name. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`secretRef`](#parameter-containersenvsecretref) | string | Required if value is not set. Name of the Container App secret from which to pull the environment variable value. |
| [`value`](#parameter-containersenvvalue) | string | Required if secretRef is not set. Non-secret environment variable value. |

### Parameter: `containers.env.name`

Environment variable name.

- Required: Yes
- Type: string

### Parameter: `containers.env.secretRef`

Required if value is not set. Name of the Container App secret from which to pull the environment variable value.

- Required: No
- Type: string

### Parameter: `containers.env.value`

Required if secretRef is not set. Non-secret environment variable value.

- Required: No
- Type: string

### Parameter: `cooldownPeriodInSeconds`

The cooldown period of a session in seconds.

- Required: No
- Type: int
- Default: `300`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `environmentId`

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

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`identity`](#parameter-managedidentitysettingsidentity) | string | The resource ID of a user-assigned managed identity that is assigned to the Session Pool, or "system" for system-assigned identity. |
| [`lifecycle`](#parameter-managedidentitysettingslifecycle) | string | Use to select the lifecycle stages of a Session Pool during which the Managed Identity should be available. Valid values: "All", "Init", "Main", "None". |

### Parameter: `managedIdentitySettings.identity`

The resource ID of a user-assigned managed identity that is assigned to the Session Pool, or "system" for system-assigned identity.

- Required: Yes
- Type: string

### Parameter: `managedIdentitySettings.lifecycle`

Use to select the lifecycle stages of a Session Pool during which the Managed Identity should be available. Valid values: "All", "Init", "Main", "None".

- Required: Yes
- Type: string

### Parameter: `maxConcurrentSessions`

The maximum count of sessions at the same time.

- Required: No
- Type: int
- Default: `5`

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

### Parameter: `readySessionInstances`

The minimum count of ready session instances.

- Required: No
- Type: int

### Parameter: `registryCredentials`

Container registry credentials. Only required if containerType is CustomContainer and the container registry requires authentication.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`server`](#parameter-registrycredentialsserver) | string | Container registry server. |
| [`username`](#parameter-registrycredentialsusername) | string | Container registry username. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`identity`](#parameter-registrycredentialsidentity) | string | A Managed Identity to use to authenticate with Azure Container Registry. For user-assigned identities, use the full user-assigned identity Resource ID. For system-assigned identities, use "system". |
| [`passwordSecretRef`](#parameter-registrycredentialspasswordsecretref) | string | The name of the secret that contains the registry login password. Not used if identity is specified. |

### Parameter: `registryCredentials.server`

Container registry server.

- Required: Yes
- Type: string

### Parameter: `registryCredentials.username`

Container registry username.

- Required: Yes
- Type: string

### Parameter: `registryCredentials.identity`

A Managed Identity to use to authenticate with Azure Container Registry. For user-assigned identities, use the full user-assigned identity Resource ID. For system-assigned identities, use "system".

- Required: No
- Type: string

### Parameter: `registryCredentials.passwordSecretRef`

The name of the secret that contains the registry login password. Not used if identity is specified.

- Required: No
- Type: string

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

### Parameter: `sessionNetworkStatus`

Network status for the sessions. Defaults to EgressDisabled.

- Required: No
- Type: string
- Default: `'EgressDisabled'`
- Allowed:
  ```Bicep
  [
    'EgressDisabled'
    'EgressEnabled'
  ]
  ```

### Parameter: `tags`

Tags of the Automation Account resource.

- Required: No
- Type: object

### Parameter: `targetIngressPort`

Required if containerType == 'CustomContainer'. Target port in containers for traffic from ingress. Only required if containerType is CustomContainer.

- Required: No
- Type: int

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
| `br/public:avm/utl/types/avm-common-types:0.2.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
