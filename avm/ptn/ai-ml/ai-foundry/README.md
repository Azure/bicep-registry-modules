# ai-foundry `[AiMl/AiFoundry]`

Creates an AI Foundry account and project with Standard Agent Services.

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
| `Microsoft.CognitiveServices/accounts` | [2025-04-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2025-04-01-preview/accounts) |
| `Microsoft.CognitiveServices/accounts/capabilityHosts` | [2025-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2025-06-01/accounts/capabilityHosts) |
| `Microsoft.CognitiveServices/accounts/deployments` | [2025-04-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2025-04-01-preview/accounts/deployments) |
| `Microsoft.CognitiveServices/accounts/projects` | [2025-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2025-06-01/accounts/projects) |
| `Microsoft.CognitiveServices/accounts/projects/capabilityHosts` | [2025-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2025-06-01/accounts/projects/capabilityHosts) |
| `Microsoft.CognitiveServices/accounts/projects/connections` | [2025-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2025-06-01/accounts/projects/connections) |
| `Microsoft.DocumentDB/databaseAccounts` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts) |
| `Microsoft.DocumentDB/databaseAccounts/gremlinDatabases` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/gremlinDatabases) |
| `Microsoft.DocumentDB/databaseAccounts/gremlinDatabases/graphs` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/gremlinDatabases/graphs) |
| `Microsoft.DocumentDB/databaseAccounts/mongodbDatabases` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/mongodbDatabases) |
| `Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/mongodbDatabases/collections) |
| `Microsoft.DocumentDB/databaseAccounts/sqlDatabases` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/sqlDatabases) |
| `Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/sqlDatabases/containers) |
| `Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/sqlRoleAssignments) |
| `Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/sqlRoleDefinitions) |
| `Microsoft.DocumentDB/databaseAccounts/tables` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/tables) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.KeyVault/vaults` | [2024-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2024-11-01/vaults) |
| `Microsoft.KeyVault/vaults/accessPolicies` | [2023-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2023-07-01/vaults/accessPolicies) |
| `Microsoft.KeyVault/vaults/keys` | [2024-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2024-11-01/vaults/keys) |
| `Microsoft.KeyVault/vaults/secrets` | [2024-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2024-11-01/vaults/secrets) |
| `Microsoft.KeyVault/vaults/secrets` | [2023-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2023-07-01/vaults/secrets) |
| `Microsoft.Network/privateEndpoints` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.Search/searchServices` | [2025-02-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Search/2025-02-01-preview/searchServices) |
| `Microsoft.Search/searchServices/sharedPrivateLinkResources` | [2025-02-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Search/2025-02-01-preview/searchServices/sharedPrivateLinkResources) |
| `Microsoft.Storage/storageAccounts` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts) |
| `Microsoft.Storage/storageAccounts/blobServices` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/blobServices) |
| `Microsoft.Storage/storageAccounts/blobServices/containers` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/blobServices/containers) |
| `Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/blobServices/containers/immutabilityPolicies) |
| `Microsoft.Storage/storageAccounts/fileServices` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/fileServices) |
| `Microsoft.Storage/storageAccounts/fileServices/shares` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/fileServices/shares) |
| `Microsoft.Storage/storageAccounts/localUsers` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/localUsers) |
| `Microsoft.Storage/storageAccounts/managementPolicies` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/managementPolicies) |
| `Microsoft.Storage/storageAccounts/queueServices` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/queueServices) |
| `Microsoft.Storage/storageAccounts/queueServices/queues` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/queueServices/queues) |
| `Microsoft.Storage/storageAccounts/tableServices` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/tableServices) |
| `Microsoft.Storage/storageAccounts/tableServices/tables` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/tableServices/tables) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/ai-ml/ai-foundry:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [WAF-aligned](#example-2-waf-aligned)

### Example 1: _Using only defaults_

Creates an AI Foundry account and project with Basic services.


<details>

<summary>via Bicep module</summary>

```bicep
module aiFoundry 'br/public:avm/ptn/ai-ml/ai-foundry:<version>' = {
  name: 'aiFoundryDeployment'
  params: {
    name: 'fndrymin001'
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
    "name": {
      "value": "fndrymin001"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/ai-ml/ai-foundry:<version>'

param name = 'fndrymin001'
```

</details>
<p>

### Example 2: _WAF-aligned_

Creates an AI Foundry account and project with Standard Agent Services in a network.


<details>

<summary>via Bicep module</summary>

```bicep
module aiFoundry 'br/public:avm/ptn/ai-ml/ai-foundry:<version>' = {
  name: 'aiFoundryDeployment'
  params: {
    // Required parameters
    name: 'fndrywaf001'
    // Non-required parameters
    aiModelDeployments: []
    contentSafetyEnabled: true
    includeAssociatedResources: true
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
      "value": "fndrywaf001"
    },
    // Non-required parameters
    "aiModelDeployments": {
      "value": []
    },
    "contentSafetyEnabled": {
      "value": true
    },
    "includeAssociatedResources": {
      "value": true
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/ai-ml/ai-foundry:<version>'

// Required parameters
param name = 'fndrywaf001'
// Non-required parameters
param aiModelDeployments = []
param contentSafetyEnabled = true
param includeAssociatedResources = true
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | A friendly application/environment name for all resources in this deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`aiModelDeployments`](#parameter-aimodeldeployments) | array | Specifies the OpenAI deployments to create. |
| [`contentSafetyEnabled`](#parameter-contentsafetyenabled) | bool | Whether to include Azure AI Content Safety in the deployment. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`identityPrincipalId`](#parameter-identityprincipalid) | string | Specifies the princpal id of a Microsoft Entra ID managed identity (principalType: ServicePrincipal) that should be granted basic, appropriate, and applicable access to resources created. |
| [`includeAssociatedResources`](#parameter-includeassociatedresources) | bool | Whether to include associated resources: Key Vault, AI Search, Storage Account, and Cosmos DB. If true, these resources will be created. Optionally, existing resources of these types can be supplied in their respective parameters. Defaults to false. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`networking`](#parameter-networking) | object | Values to establish private networking for the AI Foundry account and project. If not specified, public endpoints will be used. |
| [`projectName`](#parameter-projectname) | string | Name of the AI Foundry project.. |
| [`tags`](#parameter-tags) | object | Specifies the resource tags for all the resources. Tag "azd-env-name" is automatically added to all resources. |
| [`uniqueNameText`](#parameter-uniquenametext) | string | A unique text value for the application/environment. This is used to ensure resource names are unique for global resources. Defaults to a 5-character substring of the unique string generated from the subscription ID, resource group name, and name. |

### Parameter: `name`

A friendly application/environment name for all resources in this deployment.

- Required: Yes
- Type: string

### Parameter: `aiModelDeployments`

Specifies the OpenAI deployments to create.

- Required: No
- Type: array
- Default: `[]`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`model`](#parameter-aimodeldeploymentsmodel) | object | Properties of Cognitive Services account deployment model. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-aimodeldeploymentsname) | string | Specify the name of cognitive service account deployment. |
| [`raiPolicyName`](#parameter-aimodeldeploymentsraipolicyname) | string | The name of RAI policy. |
| [`sku`](#parameter-aimodeldeploymentssku) | object | The resource model definition representing SKU. |
| [`versionUpgradeOption`](#parameter-aimodeldeploymentsversionupgradeoption) | string | The version upgrade option. |

### Parameter: `aiModelDeployments.model`

Properties of Cognitive Services account deployment model.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`format`](#parameter-aimodeldeploymentsmodelformat) | string | The format of Cognitive Services account deployment model. |
| [`name`](#parameter-aimodeldeploymentsmodelname) | string | The name of Cognitive Services account deployment model. |
| [`version`](#parameter-aimodeldeploymentsmodelversion) | string | The version of Cognitive Services account deployment model. |

### Parameter: `aiModelDeployments.model.format`

The format of Cognitive Services account deployment model.

- Required: Yes
- Type: string

### Parameter: `aiModelDeployments.model.name`

The name of Cognitive Services account deployment model.

- Required: Yes
- Type: string

### Parameter: `aiModelDeployments.model.version`

The version of Cognitive Services account deployment model.

- Required: Yes
- Type: string

### Parameter: `aiModelDeployments.name`

Specify the name of cognitive service account deployment.

- Required: No
- Type: string

### Parameter: `aiModelDeployments.raiPolicyName`

The name of RAI policy.

- Required: No
- Type: string

### Parameter: `aiModelDeployments.sku`

The resource model definition representing SKU.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-aimodeldeploymentsskuname) | string | The name of the resource model definition representing SKU. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`capacity`](#parameter-aimodeldeploymentsskucapacity) | int | The capacity of the resource model definition representing SKU. |
| [`family`](#parameter-aimodeldeploymentsskufamily) | string | The family of the resource model definition representing SKU. |
| [`size`](#parameter-aimodeldeploymentsskusize) | string | The size of the resource model definition representing SKU. |
| [`tier`](#parameter-aimodeldeploymentsskutier) | string | The tier of the resource model definition representing SKU. |

### Parameter: `aiModelDeployments.sku.name`

The name of the resource model definition representing SKU.

- Required: Yes
- Type: string

### Parameter: `aiModelDeployments.sku.capacity`

The capacity of the resource model definition representing SKU.

- Required: No
- Type: int

### Parameter: `aiModelDeployments.sku.family`

The family of the resource model definition representing SKU.

- Required: No
- Type: string

### Parameter: `aiModelDeployments.sku.size`

The size of the resource model definition representing SKU.

- Required: No
- Type: string

### Parameter: `aiModelDeployments.sku.tier`

The tier of the resource model definition representing SKU.

- Required: No
- Type: string

### Parameter: `aiModelDeployments.versionUpgradeOption`

The version upgrade option.

- Required: No
- Type: string

### Parameter: `contentSafetyEnabled`

Whether to include Azure AI Content Safety in the deployment.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `identityPrincipalId`

Specifies the princpal id of a Microsoft Entra ID managed identity (principalType: ServicePrincipal) that should be granted basic, appropriate, and applicable access to resources created.

- Required: No
- Type: string

### Parameter: `includeAssociatedResources`

Whether to include associated resources: Key Vault, AI Search, Storage Account, and Cosmos DB. If true, these resources will be created. Optionally, existing resources of these types can be supplied in their respective parameters. Defaults to false.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `location`

Location for all Resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `networking`

Values to establish private networking for the AI Foundry account and project. If not specified, public endpoints will be used.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`agentServiceSubnetId`](#parameter-networkingagentservicesubnetid) | string |  The Resource ID of the subnet for the Azure AI Services account. |
| [`aiServicesPrivateDnsZoneId`](#parameter-networkingaiservicesprivatednszoneid) | string | The Resource ID of the Private DNS Zone for the Azure AI Services account. |
| [`cognitiveServicesPrivateDnsZoneId`](#parameter-networkingcognitiveservicesprivatednszoneid) | string | The Resource ID of the Private DNS Zone for the Azure AI Services account. |
| [`openAiPrivateDnsZoneId`](#parameter-networkingopenaiprivatednszoneid) | string | The Resource ID of the Private DNS Zone for the OpenAI account. |
| [`privateEndpointSubnetId`](#parameter-networkingprivateendpointsubnetid) | string | The Resource ID of the subnet to establish the Private Endpoint(s). |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`associatedResourcesPrivateDnsZones`](#parameter-networkingassociatedresourcesprivatednszones) | object | Configuration for DNS zones for associated resources. This is only required if includeAssociatedResources is true. |

### Parameter: `networking.agentServiceSubnetId`

 The Resource ID of the subnet for the Azure AI Services account.

- Required: Yes
- Type: string

### Parameter: `networking.aiServicesPrivateDnsZoneId`

The Resource ID of the Private DNS Zone for the Azure AI Services account.

- Required: Yes
- Type: string

### Parameter: `networking.cognitiveServicesPrivateDnsZoneId`

The Resource ID of the Private DNS Zone for the Azure AI Services account.

- Required: Yes
- Type: string

### Parameter: `networking.openAiPrivateDnsZoneId`

The Resource ID of the Private DNS Zone for the OpenAI account.

- Required: Yes
- Type: string

### Parameter: `networking.privateEndpointSubnetId`

The Resource ID of the subnet to establish the Private Endpoint(s).

- Required: Yes
- Type: string

### Parameter: `networking.associatedResourcesPrivateDnsZones`

Configuration for DNS zones for associated resources. This is only required if includeAssociatedResources is true.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`aiSearchPrivateDnsZoneId`](#parameter-networkingassociatedresourcesprivatednszonesaisearchprivatednszoneid) | string | The Resource ID of the DNS zone for the Azure AI Search service. |
| [`cosmosDbPrivateDnsZoneId`](#parameter-networkingassociatedresourcesprivatednszonescosmosdbprivatednszoneid) | string | The Resource ID of the DNS zone for the Azure Cosmos DB account. |
| [`keyVaultPrivateDnsZoneId`](#parameter-networkingassociatedresourcesprivatednszoneskeyvaultprivatednszoneid) | string | The Resource ID of the DNS zone for the Azure Key Vault. |
| [`storageBlobPrivateDnsZoneId`](#parameter-networkingassociatedresourcesprivatednszonesstorageblobprivatednszoneid) | string | The Resource ID of the DNS zone "blob" for the Azure Storage Account. |
| [`storageFilePrivateDnsZoneId`](#parameter-networkingassociatedresourcesprivatednszonesstoragefileprivatednszoneid) | string | The Resource ID of the DNS zone "file" for the Azure Storage Account. |

### Parameter: `networking.associatedResourcesPrivateDnsZones.aiSearchPrivateDnsZoneId`

The Resource ID of the DNS zone for the Azure AI Search service.

- Required: Yes
- Type: string

### Parameter: `networking.associatedResourcesPrivateDnsZones.cosmosDbPrivateDnsZoneId`

The Resource ID of the DNS zone for the Azure Cosmos DB account.

- Required: Yes
- Type: string

### Parameter: `networking.associatedResourcesPrivateDnsZones.keyVaultPrivateDnsZoneId`

The Resource ID of the DNS zone for the Azure Key Vault.

- Required: Yes
- Type: string

### Parameter: `networking.associatedResourcesPrivateDnsZones.storageBlobPrivateDnsZoneId`

The Resource ID of the DNS zone "blob" for the Azure Storage Account.

- Required: Yes
- Type: string

### Parameter: `networking.associatedResourcesPrivateDnsZones.storageFilePrivateDnsZoneId`

The Resource ID of the DNS zone "file" for the Azure Storage Account.

- Required: Yes
- Type: string

### Parameter: `projectName`

Name of the AI Foundry project..

- Required: No
- Type: string

### Parameter: `tags`

Specifies the resource tags for all the resources. Tag "azd-env-name" is automatically added to all resources.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `uniqueNameText`

A unique text value for the application/environment. This is used to ensure resource names are unique for global resources. Defaults to a 5-character substring of the unique string generated from the subscription ID, resource group name, and name.

- Required: No
- Type: string
- Default: `[substring(uniqueString(subscription().id, resourceGroup().name, parameters('name')), 0, 5)]`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `aiProjectName` | string | Name of the deployed Azure AI Project. |
| `aiSearchName` | string | Name of the deployed Azure AI Search service. |
| `aiServicesName` | string | Name of the deployed Azure AI Services account. |
| `cosmosAccountName` | string | Name of the deployed Azure Cosmos DB account. |
| `keyVaultName` | string | Name of the deployed Azure Key Vault. |
| `resourceGroupName` | string | Name of the deployed Azure Resource Group. |
| `storageAccountName` | string | Name of the deployed Azure Storage Account. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/cognitive-services/account:0.11.0` | Remote reference |
| `br/public:avm/res/document-db/database-account:0.15.0` | Remote reference |
| `br/public:avm/res/key-vault/vault:0.13.0` | Remote reference |
| `br/public:avm/res/search/search-service:0.11.0` | Remote reference |
| `br/public:avm/res/storage/storage-account:0.25.0` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.6.0` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
