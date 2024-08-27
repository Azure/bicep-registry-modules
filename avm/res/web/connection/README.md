# API Connections `[Microsoft.Web/connections]`

> ⚠️THIS MODULE IS CURRENTLY ORPHANED.⚠️
> 
> - Only security and bug fixes are being handled by the AVM core team at present.
> - If interested in becoming the module owner of this orphaned module (must be Microsoft FTE), please look for the related "orphaned module" GitHub issue [here](https://aka.ms/AVM/OrphanedModules)!

This module deploys an Azure API Connection.

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
| `Microsoft.Web/connections` | [2016-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2016-06-01/connections) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/web/connection:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module connection 'br/public:avm/res/web/connection:<version>' = {
  name: 'connectionDeployment'
  params: {
    // Required parameters
    displayName: 'azuremonitorlogs'
    name: 'azuremonitor'
    // Non-required parameters
    api: {
      id: '<id>'
    }
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
    "displayName": {
      "value": "azuremonitorlogs"
    },
    "name": {
      "value": "azuremonitor"
    },
    // Non-required parameters
    "api": {
      "value": {
        "id": "<id>"
      }
    },
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
module connection 'br/public:avm/res/web/connection:<version>' = {
  name: 'connectionDeployment'
  params: {
    // Required parameters
    displayName: 'azuremonitorlogs'
    name: 'azuremonitor'
    // Non-required parameters
    api: {
      id: '<id>'
    }
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    roleAssignments: [
      {
        name: '396667c8-de54-4dcb-916a-72af71359f34'
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

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "displayName": {
      "value": "azuremonitorlogs"
    },
    "name": {
      "value": "azuremonitor"
    },
    // Non-required parameters
    "api": {
      "value": {
        "id": "<id>"
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
    "roleAssignments": {
      "value": [
        {
          "name": "396667c8-de54-4dcb-916a-72af71359f34",
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

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module connection 'br/public:avm/res/web/connection:<version>' = {
  name: 'connectionDeployment'
  params: {
    // Required parameters
    displayName: 'azuremonitorlogs'
    name: 'azuremonitor'
    // Non-required parameters
    api: {
      id: '<id>'
    }
    location: '<location>'
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
    "displayName": {
      "value": "azuremonitorlogs"
    },
    "name": {
      "value": "azuremonitor"
    },
    // Non-required parameters
    "api": {
      "value": {
        "id": "<id>"
      }
    },
    "location": {
      "value": "<location>"
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


## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`displayName`](#parameter-displayname) | string | Display name connection. Example: `blobconnection` when using blobs. It can change depending on the resource. |
| [`name`](#parameter-name) | string | Connection name for connection. It can change depending on the resource. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`api`](#parameter-api) | object | Specific values for some API connections. |
| [`customParameterValues`](#parameter-customparametervalues) | object | Dictionary of custom parameter values for specific connections. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location of the deployment. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`nonSecretParameterValues`](#parameter-nonsecretparametervalues) | object | Dictionary of nonsecret parameter values. |
| [`parameterValues`](#parameter-parametervalues) | secureObject | Connection strings or access keys for connection. Example: `accountName` and `accessKey` when using blobs. It can change depending on the resource. |
| [`parameterValueSet`](#parameter-parametervalueset) | object | Additional parameter value set used for authentication settings. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`statuses`](#parameter-statuses) | array | The status of the connection. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`testLinks`](#parameter-testlinks) | array | Links to test the API connection. |

### Parameter: `displayName`

Display name connection. Example: `blobconnection` when using blobs. It can change depending on the resource.

- Required: Yes
- Type: string

### Parameter: `name`

Connection name for connection. It can change depending on the resource.

- Required: Yes
- Type: string

### Parameter: `api`

Specific values for some API connections.

- Required: No
- Type: object
- Example:
  ```Bicep
  // for a Service Bus connection
  {
    type: 'Microsoft.Web/locations/managedApis'
    id: subscriptionResourceId('Microsoft.Web/locations/managedApis', '${resourceLocation}', 'servicebus')
  }
  ```

### Parameter: `customParameterValues`

Dictionary of custom parameter values for specific connections.

- Required: No
- Type: object

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location of the deployment.

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

### Parameter: `nonSecretParameterValues`

Dictionary of nonsecret parameter values.

- Required: No
- Type: object

### Parameter: `parameterValues`

Connection strings or access keys for connection. Example: `accountName` and `accessKey` when using blobs. It can change depending on the resource.

- Required: No
- Type: secureObject
- Example:
  ```Bicep
  {
    connectionString: 'listKeys('/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/Microsoft.ServiceBus/namespaces/AuthorizationRules/<serviceBusName>/RootManagedSharedAccessKey', '2023-01-01').primaryConnectionString'
  }
  {
    rootfolder: fileshareConnection.rootfolder
    authType: fileshareConnection.authType
    // to add an object, use the any() function
    gateway: any({
      name: fileshareConnection.odgw.name
      id: resourceId(fileshareConnection.odgw.resourceGroup, 'Microsoft.Web/connectionGateways', fileshareConnection.odgw.name)
      type: 'Microsoft.Web/connectionGateways'
    })
    username: username
    password: password
  }
  ```

### Parameter: `parameterValueSet`

Additional parameter value set used for authentication settings.

- Required: No
- Type: object
- Example:
  ```Bicep
  // for a Service Bus connection
  {
    name: 'managedIdentityAuth'
    values: {
      namespaceEndpoint: {
        value: 'sb://${dependency.outputs.serviceBusEndpoint}'
      }
    }
  }
  ```

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

### Parameter: `statuses`

The status of the connection.

- Required: No
- Type: array

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object
- Example:
  ```Bicep
  {
      key1: 'value1'
      key2: 'value2'
  }
  ```

### Parameter: `testLinks`

Links to test the API connection.

- Required: No
- Type: array


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the connection. |
| `resourceGroupName` | string | The resource group the connection was deployed into. |
| `resourceId` | string | The resource ID of the connection. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
