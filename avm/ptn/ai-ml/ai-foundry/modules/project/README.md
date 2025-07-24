# AI Foundry Project `[AiMl/AiFoundryModulesProject]`

Creates an AI Foundry project and any associated Azure service connections.

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
| [`includeCapabilityHost`](#parameter-includecapabilityhost) | bool | Include the capability host for the Foundry project. |
| [`name`](#parameter-name) | string | The name of the AI Foundry project. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`aiSearchConnection`](#parameter-aisearchconnection) | object | Azure Cognitive Search connection for the project. |
| [`aiServicesConnection`](#parameter-aiservicesconnection) | object | Azure AI Services connections for the project. |
| [`cosmosDbConnection`](#parameter-cosmosdbconnection) | object | Azure Cosmos DB connection for the project. |
| [`desc`](#parameter-desc) | string | The description of the AI Foundry project. |
| [`displayName`](#parameter-displayname) | string | The display name of the AI Foundry project. |
| [`location`](#parameter-location) | string | Specifies the location for all the Azure resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`storageAccountConnection`](#parameter-storageaccountconnection) | object | Azure Storage Account connection for the project. |
| [`tags`](#parameter-tags) | object | Tags to be applied to the resources. |

### Parameter: `accountName`

Name of the existing parent Foundry Account resource.

- Required: Yes
- Type: string

### Parameter: `includeCapabilityHost`

Include the capability host for the Foundry project.

- Required: Yes
- Type: bool

### Parameter: `name`

The name of the AI Foundry project.

- Required: Yes
- Type: string

### Parameter: `aiSearchConnection`

Azure Cognitive Search connection for the project.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`resourceId`](#parameter-aisearchconnectionresourceid) | string | The resource ID of the Azure resource for the connection. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-aisearchconnectionname) | string | The name of the project connection. Will default to the resource name if not provided. |

### Parameter: `aiSearchConnection.resourceId`

The resource ID of the Azure resource for the connection.

- Required: Yes
- Type: string

### Parameter: `aiSearchConnection.name`

The name of the project connection. Will default to the resource name if not provided.

- Required: No
- Type: string

### Parameter: `aiServicesConnection`

Azure AI Services connections for the project.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`resourceId`](#parameter-aiservicesconnectionresourceid) | string | The resource ID of the Azure resource for the connection. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-aiservicesconnectionname) | string | The name of the project connection. Will default to the resource name if not provided. |

### Parameter: `aiServicesConnection.resourceId`

The resource ID of the Azure resource for the connection.

- Required: Yes
- Type: string

### Parameter: `aiServicesConnection.name`

The name of the project connection. Will default to the resource name if not provided.

- Required: No
- Type: string

### Parameter: `cosmosDbConnection`

Azure Cosmos DB connection for the project.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`resourceId`](#parameter-cosmosdbconnectionresourceid) | string | The resource ID of the Azure resource for the connection. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-cosmosdbconnectionname) | string | The name of the project connection. Will default to the resource name if not provided. |

### Parameter: `cosmosDbConnection.resourceId`

The resource ID of the Azure resource for the connection.

- Required: Yes
- Type: string

### Parameter: `cosmosDbConnection.name`

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

### Parameter: `location`

Specifies the location for all the Azure resources.

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

### Parameter: `storageAccountConnection`

Azure Storage Account connection for the project.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`containers`](#parameter-storageaccountconnectioncontainers) | array | List of containers in the Storage Account to use for the connections. |
| [`resourceId`](#parameter-storageaccountconnectionresourceid) | string | The resource ID of the Azure resource for the connection. |

### Parameter: `storageAccountConnection.containers`

List of containers in the Storage Account to use for the connections.

- Required: Yes
- Type: array

### Parameter: `storageAccountConnection.resourceId`

The resource ID of the Azure resource for the connection.

- Required: Yes
- Type: string

### Parameter: `tags`

Tags to be applied to the resources.

- Required: No
- Type: object
- Default: `{}`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `desc` | string | Description of the Project. |
| `displayName` | string | Display name of the Project. |
| `name` | string | Name of the Project. |
| `resourceId` | string | Resource ID of the Project. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |
