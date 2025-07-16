#  `[AiMl/AiFoundryModulesProject]`


## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.CognitiveServices/accounts/projects` | [2025-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2025-06-01/accounts/projects) |
| `Microsoft.CognitiveServices/accounts/projects/capabilityHosts` | [2025-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2025-06-01/accounts/projects/capabilityHosts) |
| `Microsoft.CognitiveServices/accounts/projects/connections` | [2025-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2025-06-01/accounts/projects/connections) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`accountName`](#parameter-accountname) | string | Name of the existing parent Foundry Account resource. |
| [`location`](#parameter-location) | string | Specifies the location for all the Azure resources. |
| [`name`](#parameter-name) | string | The name of the AI Foundry project. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`aiSearchConnections`](#parameter-aisearchconnections) | array | List of Azure Cognitive Search connections for the project. |
| [`aiServicesConnections`](#parameter-aiservicesconnections) | array | List of Azure AI Services connections for the project. |
| [`cosmosDbConnections`](#parameter-cosmosdbconnections) | array | List of Azure Cosmos DB connections for the project. |
| [`desc`](#parameter-desc) | string | The description of the AI Foundry project. |
| [`displayName`](#parameter-displayname) | string | The display name of the AI Foundry project. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`storageAccountConnections`](#parameter-storageaccountconnections) | array | List of Azure Storage Account connections for the project. |
| [`tags`](#parameter-tags) | object | Tags to be applied to the resources. |

### Parameter: `accountName`

Name of the existing parent Foundry Account resource.

- Required: Yes
- Type: string

### Parameter: `location`

Specifies the location for all the Azure resources.

- Required: Yes
- Type: string

### Parameter: `name`

The name of the AI Foundry project.

- Required: Yes
- Type: string

### Parameter: `aiSearchConnections`

List of Azure Cognitive Search connections for the project.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`resourceId`](#parameter-aisearchconnectionsresourceid) | string | The resource ID of the Azure resource for the connection. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-aisearchconnectionsname) | string | The name of the project connection. Will default to the resource name if not provided. |

### Parameter: `aiSearchConnections.resourceId`

The resource ID of the Azure resource for the connection.

- Required: Yes
- Type: string

### Parameter: `aiSearchConnections.name`

The name of the project connection. Will default to the resource name if not provided.

- Required: No
- Type: string

### Parameter: `aiServicesConnections`

List of Azure AI Services connections for the project.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`resourceId`](#parameter-aiservicesconnectionsresourceid) | string | The resource ID of the Azure resource for the connection. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-aiservicesconnectionsname) | string | The name of the project connection. Will default to the resource name if not provided. |

### Parameter: `aiServicesConnections.resourceId`

The resource ID of the Azure resource for the connection.

- Required: Yes
- Type: string

### Parameter: `aiServicesConnections.name`

The name of the project connection. Will default to the resource name if not provided.

- Required: No
- Type: string

### Parameter: `cosmosDbConnections`

List of Azure Cosmos DB connections for the project.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`resourceId`](#parameter-cosmosdbconnectionsresourceid) | string | The resource ID of the Azure resource for the connection. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-cosmosdbconnectionsname) | string | The name of the project connection. Will default to the resource name if not provided. |

### Parameter: `cosmosDbConnections.resourceId`

The resource ID of the Azure resource for the connection.

- Required: Yes
- Type: string

### Parameter: `cosmosDbConnections.name`

The name of the project connection. Will default to the resource name if not provided.

- Required: No
- Type: string

### Parameter: `desc`

The description of the AI Foundry project.

- Required: No
- Type: string

### Parameter: `displayName`

The display name of the AI Foundry project.

- Required: No
- Type: string

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

### Parameter: `storageAccountConnections`

List of Azure Storage Account connections for the project.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`containerName`](#parameter-storageaccountconnectionscontainername) | string | The name of the container in the Storage Account to use for the connection. |
| [`resourceId`](#parameter-storageaccountconnectionsresourceid) | string | The resource ID of the Storage Account for the connection. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-storageaccountconnectionsname) | string | The name of the project connection. Will default to the resource name if not provided. |

### Parameter: `storageAccountConnections.containerName`

The name of the container in the Storage Account to use for the connection.

- Required: Yes
- Type: string

### Parameter: `storageAccountConnections.resourceId`

The resource ID of the Storage Account for the connection.

- Required: Yes
- Type: string

### Parameter: `storageAccountConnections.name`

The name of the project connection. Will default to the resource name if not provided.

- Required: No
- Type: string

### Parameter: `tags`

Tags to be applied to the resources.

- Required: No
- Type: object
- Default: `{}`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `aiSearchConnections` | array |  |
| `aiServicesConnections` | array |  |
| `cosmosDbConnections` | array |  |
| `desc` | string | Description of the Project. |
| `displayName` | string | Display name of the Project. |
| `name` | string | Name of the Project. |
| `resourceId` | string | Resource ID of the Project. |
| `storageAccountConnections` | array | Resource ID of the Project. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |
