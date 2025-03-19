# Conversation Knowledge Mining Solution Accelerator `[Sa/ConversationKnowledgeMining]`

This module deploys the [Conversation Knowledge Mining Solution Accelerator](https://github.com/microsoft/Conversation-Knowledge-Mining-Solution-Accelerator).

> **Note:** This module is not intended for broad, generic use, as it was designed by the Commercial Solution Areas CTO team, as a Microsoft Solution Accelerator product. Feature requests and bug fix requests are welcome if they support the needs of this organization but may not be incorporated if they aim to make this module more generic than what it needs to be for its primary use case. This module will likely be updated to leverage AVM resource modules in the future. This may result in breaking changes in upcoming versions when these features are implemented.


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
| `Microsoft.App/managedEnvironments` | [2024-10-02-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2024-10-02-preview/managedEnvironments) |
| `Microsoft.App/managedEnvironments/storages` | [2024-10-02-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2024-10-02-preview/managedEnvironments/storages) |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.CognitiveServices/accounts` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2023-05-01/accounts) |
| `Microsoft.CognitiveServices/accounts/deployments` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2023-05-01/accounts/deployments) |
| `Microsoft.ContainerRegistry/registries` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-06-01-preview/registries) |
| `Microsoft.ContainerRegistry/registries/cacheRules` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-06-01-preview/registries/cacheRules) |
| `Microsoft.ContainerRegistry/registries/credentialSets` | [2023-11-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-11-01-preview/registries/credentialSets) |
| `Microsoft.ContainerRegistry/registries/replications` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-06-01-preview/registries/replications) |
| `Microsoft.ContainerRegistry/registries/scopeMaps` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-06-01-preview/registries/scopeMaps) |
| `Microsoft.ContainerRegistry/registries/webhooks` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-06-01-preview/registries/webhooks) |
| `Microsoft.DocumentDB/databaseAccounts` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts) |
| `Microsoft.DocumentDB/databaseAccounts/gremlinDatabases` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/gremlinDatabases) |
| `Microsoft.DocumentDB/databaseAccounts/gremlinDatabases/graphs` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/gremlinDatabases/graphs) |
| `Microsoft.DocumentDB/databaseAccounts/mongodbDatabases` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/mongodbDatabases) |
| `Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/mongodbDatabases/collections) |
| `Microsoft.DocumentDB/databaseAccounts/sqlDatabases` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/sqlDatabases) |
| `Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/sqlDatabases/containers) |
| `Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/sqlRoleAssignments) |
| `Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments` | [2024-12-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-12-01-preview/databaseAccounts/sqlRoleAssignments) |
| `Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/sqlRoleDefinitions) |
| `Microsoft.DocumentDB/databaseAccounts/tables` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/tables) |
| `Microsoft.Insights/components` | [2020-02-02](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2020-02-02/components) |
| `microsoft.insights/components/linkedStorageAccounts` | [2020-03-01-preview](https://learn.microsoft.com/en-us/azure/templates/microsoft.insights/2020-03-01-preview/components/linkedStorageAccounts) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.KeyVault/vaults` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults) |
| `Microsoft.KeyVault/vaults/accessPolicies` | [2023-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2023-07-01/vaults/accessPolicies) |
| `Microsoft.KeyVault/vaults/keys` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/keys) |
| `Microsoft.KeyVault/vaults/secrets` | [2021-11-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2021-11-01-preview/vaults/secrets) |
| `Microsoft.KeyVault/vaults/secrets` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/secrets) |
| `Microsoft.KeyVault/vaults/secrets` | [2023-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2023-07-01/vaults/secrets) |
| `Microsoft.MachineLearningServices/workspaces` | [2024-04-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.MachineLearningServices/2024-04-01-preview/workspaces) |
| `Microsoft.MachineLearningServices/workspaces/computes` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.MachineLearningServices/2022-10-01/workspaces/computes) |
| `Microsoft.MachineLearningServices/workspaces/connections` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.MachineLearningServices/2024-04-01/workspaces/connections) |
| `Microsoft.ManagedIdentity/userAssignedIdentities` | [2023-01-31](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2023-01-31/userAssignedIdentities) |
| `Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials` | [2023-01-31](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2023-01-31/userAssignedIdentities/federatedIdentityCredentials) |
| `Microsoft.Network/privateEndpoints` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.OperationalInsights/workspaces` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces) |
| `Microsoft.OperationalInsights/workspaces/dataExports` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces/dataExports) |
| `Microsoft.OperationalInsights/workspaces/dataSources` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces/dataSources) |
| `Microsoft.OperationalInsights/workspaces/linkedServices` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces/linkedServices) |
| `Microsoft.OperationalInsights/workspaces/linkedStorageAccounts` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces/linkedStorageAccounts) |
| `Microsoft.OperationalInsights/workspaces/savedSearches` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces/savedSearches) |
| `Microsoft.OperationalInsights/workspaces/storageInsightConfigs` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces/storageInsightConfigs) |
| `Microsoft.OperationalInsights/workspaces/tables` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces/tables) |
| `Microsoft.OperationsManagement/solutions` | [2015-11-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationsManagement/2015-11-01-preview/solutions) |
| `Microsoft.Resources/deploymentScripts` | [2023-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2023-08-01/deploymentScripts) |
| `Microsoft.Search/searchServices` | [2024-03-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Search/2024-03-01-preview/searchServices) |
| `Microsoft.Search/searchServices/sharedPrivateLinkResources` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Search/2023-11-01/searchServices/sharedPrivateLinkResources) |
| `Microsoft.SecurityInsights/onboardingStates` | [2024-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.SecurityInsights/2024-03-01/onboardingStates) |
| `Microsoft.Sql/servers` | [2023-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2023-08-01-preview/servers) |
| `Microsoft.Sql/servers/auditingSettings` | [2023-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2023-08-01-preview/servers/auditingSettings) |
| `Microsoft.Sql/servers/databases` | [2023-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2023-08-01-preview/servers/databases) |
| `Microsoft.Sql/servers/databases/backupLongTermRetentionPolicies` | [2023-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2023-05-01-preview/servers/databases/backupLongTermRetentionPolicies) |
| `Microsoft.Sql/servers/databases/backupShortTermRetentionPolicies` | [2023-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2023-08-01-preview/servers/databases/backupShortTermRetentionPolicies) |
| `Microsoft.Sql/servers/elasticPools` | [2023-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2023-08-01-preview/servers/elasticPools) |
| `Microsoft.Sql/servers/encryptionProtector` | [2023-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2023-08-01-preview/servers/encryptionProtector) |
| `Microsoft.Sql/servers/failoverGroups` | [2024-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2024-05-01-preview/servers/failoverGroups) |
| `Microsoft.Sql/servers/firewallRules` | [2023-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2023-08-01-preview/servers/firewallRules) |
| `Microsoft.Sql/servers/keys` | [2023-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2023-08-01-preview/servers/keys) |
| `Microsoft.Sql/servers/securityAlertPolicies` | [2023-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2023-08-01-preview/servers/securityAlertPolicies) |
| `Microsoft.Sql/servers/virtualNetworkRules` | [2023-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2023-08-01-preview/servers/virtualNetworkRules) |
| `Microsoft.Sql/servers/vulnerabilityAssessments` | [2023-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2023-08-01-preview/servers/vulnerabilityAssessments) |
| `Microsoft.Storage/storageAccounts` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-05-01/storageAccounts) |
| `Microsoft.Storage/storageAccounts/blobServices` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices) |
| `Microsoft.Storage/storageAccounts/blobServices/containers` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices/containers) |
| `Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices/containers/immutabilityPolicies) |
| `Microsoft.Storage/storageAccounts/fileServices` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-04-01/storageAccounts/fileServices) |
| `Microsoft.Storage/storageAccounts/fileServices/shares` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-01-01/storageAccounts/fileServices/shares) |
| `Microsoft.Storage/storageAccounts/localUsers` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-04-01/storageAccounts/localUsers) |
| `Microsoft.Storage/storageAccounts/managementPolicies` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-01-01/storageAccounts/managementPolicies) |
| `Microsoft.Storage/storageAccounts/queueServices` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-04-01/storageAccounts/queueServices) |
| `Microsoft.Storage/storageAccounts/queueServices/queues` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-04-01/storageAccounts/queueServices/queues) |
| `Microsoft.Storage/storageAccounts/tableServices` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-04-01/storageAccounts/tableServices) |
| `Microsoft.Storage/storageAccounts/tableServices/tables` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-04-01/storageAccounts/tableServices/tables) |
| `Microsoft.Web/serverfarms` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2022-09-01/serverfarms) |
| `Microsoft.Web/sites` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-04-01/sites) |
| `Microsoft.Web/sites` | [2023-12-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2023-12-01/sites) |
| `Microsoft.Web/sites/basicPublishingCredentialsPolicies` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-04-01/sites/basicPublishingCredentialsPolicies) |
| `Microsoft.Web/sites/config` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-04-01/sites/config) |
| `Microsoft.Web/sites/extensions` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-04-01/sites/extensions) |
| `Microsoft.Web/sites/hybridConnectionNamespaces/relays` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-04-01/sites/hybridConnectionNamespaces/relays) |
| `Microsoft.Web/sites/slots` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-04-01/sites/slots) |
| `Microsoft.Web/sites/slots/basicPublishingCredentialsPolicies` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-04-01/sites/slots/basicPublishingCredentialsPolicies) |
| `Microsoft.Web/sites/slots/config` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-04-01/sites/slots/config) |
| `Microsoft.Web/sites/slots/hybridConnectionNamespaces/relays` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-04-01/sites/slots/hybridConnectionNamespaces/relays) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/sa/conversation-knowledge-mining:<version>`.

- [Using Proof of Concept parameter set](#example-1-using-proof-of-concept-parameter-set)

### Example 1: _Using Proof of Concept parameter set_

This module deploys the [Conversation Knowledge Mining Solution Accelerator](https://github.com/microsoft/Conversation-Knowledge-Mining-Solution-Accelerator) using the configuration for Proof of Concept scenarios


<details>

<summary>via Bicep module</summary>

```bicep
module conversationKnowledgeMining 'br/public:avm/ptn/sa/conversation-knowledge-mining:<version>' = {
  name: 'conversationKnowledgeMiningDeployment'
  params: {
    // Required parameters
    aiFoundryAiServicesContentUnderstandingLocation: 'West US'
    solutionPrefix: 'ckmpoc'
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
    "aiFoundryAiServicesContentUnderstandingLocation": {
      "value": "West US"
    },
    "solutionPrefix": {
      "value": "ckmpoc"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/sa/conversation-knowledge-mining:<version>'

// Required parameters
param aiFoundryAiServicesContentUnderstandingLocation = 'West US'
param solutionPrefix = 'ckmpoc'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`aiFoundryAiServicesContentUnderstandingLocation`](#parameter-aifoundryaiservicescontentunderstandinglocation) | string | Location for the AI Foundry Content Understanding service deployment. |
| [`solutionPrefix`](#parameter-solutionprefix) | string | The prefix to add in the default names given to all deployed Azure resources. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`aiFoundryAiHubLocation`](#parameter-aifoundryaihublocation) | string | Location for the AI Foundry AI Hub resource deployment. |
| [`aiFoundryAiHubResourceName`](#parameter-aifoundryaihubresourcename) | string | The name of the AI Foundry AI Hub resource. It will override the default given name. |
| [`aiFoundryAiHubSkuName`](#parameter-aifoundryaihubskuname) | string | The SKU of the AI Foundry AI Hub account. |
| [`aiFoundryAiProjectLocation`](#parameter-aifoundryaiprojectlocation) | string | Location for the AI Foundry AI Project resource deployment. |
| [`aiFoundryAiProjectResourceName`](#parameter-aifoundryaiprojectresourcename) | string | The name of the AI Foundry AI Project resource. It will override the default given name. |
| [`aiFoundryAiProjectSkuName`](#parameter-aifoundryaiprojectskuname) | string | The SKU of the AI Foundry AI project. |
| [`aiFoundryAiServicesContentUnderstandingResourceName`](#parameter-aifoundryaiservicescontentunderstandingresourcename) | string | The name of the AI Foundry AI Services Content Understanding resource. It will override the default given name. |
| [`aiFoundryAiServicesContentUnderstandingSkuName`](#parameter-aifoundryaiservicescontentunderstandingskuname) | string | The SKU of the AI Foundry AI Services account. Use 'Get-AzCognitiveServicesAccountSku' to determine a valid combinations of 'kind' and 'SKU' for your Azure region. |
| [`aiFoundryAIServicesGptModelDeploymentCapacity`](#parameter-aifoundryaiservicesgptmodeldeploymentcapacity) | int | Capacity of the GPT model to deploy in the AI Foundry AI Services account. Capacity is limited per model/region, so you will get errors if you go over. [Quotas link](https://learn.microsoft.com/azure/ai-services/openai/quotas-limits). |
| [`aiFoundryAIServicesGptModelDeploymentType`](#parameter-aifoundryaiservicesgptmodeldeploymenttype) | string | GPT model deployment type of the AI Foundry AI Services account. |
| [`aiFoundryAIServicesGptModelName`](#parameter-aifoundryaiservicesgptmodelname) | string | Name of the GPT model to deploy in the AI Foundry AI Services account. |
| [`aiFoundryAiServicesLocation`](#parameter-aifoundryaiserviceslocation) | string | Location for the AI Foundry AI Service resource deployment. |
| [`aiFoundryAiServicesResourceName`](#parameter-aifoundryaiservicesresourcename) | string | The name of the AI Foundry AI Services resource. It will override the default given name. |
| [`aiFoundryAiServicesSkuName`](#parameter-aifoundryaiservicesskuname) | string | The SKU of the AI Foundry AI Services account. Use 'Get-AzCognitiveServicesAccountSku' to determine a valid combinations of 'kind' and 'SKU' for your Azure region. |
| [`aiFoundryAiServicesTextEmbeddingModelCapacity`](#parameter-aifoundryaiservicestextembeddingmodelcapacity) | int | Capacity of the Text Embedding model to deploy in the AI Foundry AI Services account. Capacity is limited per model/region, so you will get errors if you go over. [Quotas link](https://learn.microsoft.com/azure/ai-services/openai/quotas-limits). |
| [`aiFoundryAiServicesTextEmbeddingModelName`](#parameter-aifoundryaiservicestextembeddingmodelname) | string | Name of the Text Embedding model to deploy in the AI Foundry AI Services account. |
| [`aiFoundryApplicationInsightsLocation`](#parameter-aifoundryapplicationinsightslocation) | string | Location for the AI Foundry Application Insights resource deployment. |
| [`aiFoundryApplicationInsightsResourceName`](#parameter-aifoundryapplicationinsightsresourcename) | string | The name of the AI Foundry Application Insights resource. It will override the default given name. |
| [`aiFoundryApplicationInsightsRetentionInDays`](#parameter-aifoundryapplicationinsightsretentionindays) | int | The retention of Application Insights data in days. If empty, Standard will be used. |
| [`aiFoundryContainerRegistryLocation`](#parameter-aifoundrycontainerregistrylocation) | string | Location for the AI Foundry Container Registry resource deployment. |
| [`aiFoundryContainerRegistryResourceName`](#parameter-aifoundrycontainerregistryresourcename) | string | The name of the AI Foundry Container Registry resource. It will override the default given name. |
| [`aiFoundryContainerRegistrySkuName`](#parameter-aifoundrycontainerregistryskuname) | string | The SKU for the AI Foundry Container Registry. If empty, Premium will be used. |
| [`aiFoundrySearchServiceLocation`](#parameter-aifoundrysearchservicelocation) | string | Location for the AI Foundry Search Service resource deployment. |
| [`aiFoundrySearchServiceResourceName`](#parameter-aifoundrysearchserviceresourcename) | string | The name of the AI Foundry Search Service resource. It will override the default given name. |
| [`aiFoundrySearchServiceSkuName`](#parameter-aifoundrysearchserviceskuname) | string | The SKU of the AI Foundry Search Service account. |
| [`aiFoundryStorageAccountLocation`](#parameter-aifoundrystorageaccountlocation) | string | Location for the AI Foundry Storage Account resource deployment. |
| [`aiFoundryStorageAccountResourceName`](#parameter-aifoundrystorageaccountresourcename) | string | The name of the AI Foundry Storage Account resource. It will override the default given name. |
| [`aiFoundryStorageAccountSkuName`](#parameter-aifoundrystorageaccountskuname) | string | The SKU for the AI Foundry Storage Account. If empty, Standard_LRS will be used. |
| [`cosmosDbAccountLocation`](#parameter-cosmosdbaccountlocation) | string | Location for the Cosmos DB Account resource deployment. |
| [`cosmosDbAccountResourceName`](#parameter-cosmosdbaccountresourcename) | string | The name of the Cosmos DB Account resource. It will override the default given name. |
| [`databasesLocation`](#parameter-databaseslocation) | string | Location for all the deployed databases Azure resources. Defaulted to East US 2. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`functionChartAppScaleLimit`](#parameter-functionchartappscalelimit) | int | The maximum number of workers that the Charts function can scale out. |
| [`functionChartCpu`](#parameter-functionchartcpu) | int | The required CPU in cores of the Charts function. |
| [`functionChartDockerImageContainerRegistryUrl`](#parameter-functionchartdockerimagecontainerregistryurl) | string | The url of the Container Registry where the docker image for the Charts function is located. |
| [`functionChartDockerImageName`](#parameter-functionchartdockerimagename) | string | The name of the docker image for the Charts function. |
| [`functionChartDockerImageTag`](#parameter-functionchartdockerimagetag) | string | The tag of the docker image for the Charts function. |
| [`functionChartMemory`](#parameter-functionchartmemory) | string | The required memory in GiB of the Charts function. |
| [`functionChartsFunctionName`](#parameter-functionchartsfunctionname) | string | The name of the function to be used to get the metrics in the Charts function. |
| [`functionChartsLocation`](#parameter-functionchartslocation) | string | Location for the Function Charts resource deployment. |
| [`functionChartsResourceName`](#parameter-functionchartsresourcename) | string | The name of the Function Charts resource. It will override the default given name. |
| [`functionRagAppScaleLimit`](#parameter-functionragappscalelimit) | int | The maximum number of workers that the Rag function can scale out. |
| [`functionRagCpu`](#parameter-functionragcpu) | int | The required CPU in cores of the Rag function. |
| [`functionRagDockerImageContainerRegistryUrl`](#parameter-functionragdockerimagecontainerregistryurl) | string | The url of the Container Registry where the docker image for the Rag function is located. |
| [`functionRagDockerImageName`](#parameter-functionragdockerimagename) | string | The name of the docker image for the Rag function. |
| [`functionRagDockerImageTag`](#parameter-functionragdockerimagetag) | string | The tag of the docker image for the Rag function. |
| [`functionRagFunctionName`](#parameter-functionragfunctionname) | string | The name of the function to be used to stream text in the Rag function. |
| [`functionRagLocation`](#parameter-functionraglocation) | string | Location for the Function RAG resource deployment. |
| [`functionRagMemory`](#parameter-functionragmemory) | string | The required memory in GiB of the Rag function. |
| [`functionRagResourceName`](#parameter-functionragresourcename) | string | The name of the Function RAG resource. It will override the default given name. |
| [`functionsManagedEnvironmentLocation`](#parameter-functionsmanagedenvironmentlocation) | string | Location for the Functions Managed Environment resource deployment. |
| [`functionsManagedEnvironmentResourceName`](#parameter-functionsmanagedenvironmentresourcename) | string | The name of the Functions Managed Environment resource. It will override the default given name. |
| [`keyVaultCreateMode`](#parameter-keyvaultcreatemode) | string | The Key Vault create mode. Indicates whether the vault need to be recovered from purge or not. If empty, default will be used. |
| [`keyVaultLocation`](#parameter-keyvaultlocation) | string | Location for the Key Vault resource deployment. |
| [`keyVaultPurgeProtectionEnabled`](#parameter-keyvaultpurgeprotectionenabled) | bool | If set to true, The Key Vault purge protection will be enabled. If empty, it will be set to false. |
| [`keyVaultResourceName`](#parameter-keyvaultresourcename) | string | The name of the Key Vault resource. It will override the default given name. |
| [`keyVaultRoleAssignments`](#parameter-keyvaultroleassignments) | array | Array of role assignments to include in the Key Vault. |
| [`keyVaultSku`](#parameter-keyvaultsku) | string | The SKU for the Key Vault. If empty, standard will be used. |
| [`keyVaultSoftDeleteEnabled`](#parameter-keyvaultsoftdeleteenabled) | bool | If set to true, The Key Vault soft delete will be enabled. |
| [`keyVaultSoftDeleteRetentionInDays`](#parameter-keyvaultsoftdeleteretentionindays) | int | The number of days to retain the soft deleted vault. If empty, it will be set to 7. |
| [`logAnalyticsWorkspaceDataRetentionInDays`](#parameter-loganalyticsworkspacedataretentionindays) | int | The number of days to retain the data in the Log Analytics Workspace. If empty, it will be set to 30 days. |
| [`logAnalyticsWorkspaceLocation`](#parameter-loganalyticsworkspacelocation) | string | Location for the Log Analytics Workspace resource deployment. |
| [`logAnalyticsWorkspaceResourceName`](#parameter-loganalyticsworkspaceresourcename) | string | The name of the Log Analytics Workspace resource. It will override the default given name. |
| [`logAnalyticsWorkspaceSkuName`](#parameter-loganalyticsworkspaceskuname) | string | The SKU for the Log Analytics Workspace. If empty, PerGB2018 will be used. |
| [`managedIdentityLocation`](#parameter-managedidentitylocation) | string | Location for the Managed Identity resource deployment. |
| [`managedIdentityResourceName`](#parameter-managedidentityresourcename) | string | The name of the Managed Identity resource. It will override the default given name. |
| [`scriptCopyDataLocation`](#parameter-scriptcopydatalocation) | string | Location for the Script Copy Data resource deployment. |
| [`scriptCopyDataResourceName`](#parameter-scriptcopydataresourcename) | string | The name of the Script Copy Data resource. It will override the default given name. |
| [`scriptIndexDataLocation`](#parameter-scriptindexdatalocation) | string | Location for the Script Index Data resource deployment. |
| [`scriptIndexDataResourceName`](#parameter-scriptindexdataresourcename) | string | The name of the Script Index Data resource. It will override the default given name. |
| [`solutionLocation`](#parameter-solutionlocation) | string | Location for all the deployed Azure resources except databases. Defaulted to East US. |
| [`sqlServerAdministratorLogin`](#parameter-sqlserveradministratorlogin) | securestring | The administrator login credential for the SQL Server. |
| [`sqlServerAdministratorPassword`](#parameter-sqlserveradministratorpassword) | securestring | The administrator password credential for the SQL Server. |
| [`sqlServerDatabaseName`](#parameter-sqlserverdatabasename) | string | The name of the SQL Server database. |
| [`sqlServerDatabaseSkuCapacity`](#parameter-sqlserverdatabaseskucapacity) | int | The SKU capacity of the SQL Server database. If empty, it will be set to 2. Find available options: Database.[Sku property](https://learn.microsoft.com/dotnet/api/microsoft.azure.management.sql.models.database.sku). |
| [`sqlServerDatabaseSkuFamily`](#parameter-sqlserverdatabaseskufamily) | string | The SKU Family of the SQL Server database. If empty, it will be set to Gen5. Find available options: Database.[Sku property](https://learn.microsoft.com/dotnet/api/microsoft.azure.management.sql.models.database.sku). |
| [`sqlServerDatabaseSkuName`](#parameter-sqlserverdatabaseskuname) | string | The SKU name of the SQL Server database. If empty, it will be set to GP_Gen5_2. Find available options: Database.[Sku property](https://learn.microsoft.com/dotnet/api/microsoft.azure.management.sql.models.database.sku). |
| [`sqlServerDatabaseSkuTier`](#parameter-sqlserverdatabaseskutier) | string | The SKU tier of the SQL Server database. If empty, it will be set to GeneralPurpose. Find available options: Database.[Sku property](https://learn.microsoft.com/dotnet/api/microsoft.azure.management.sql.models.database.sku). |
| [`sqlServerLocation`](#parameter-sqlserverlocation) | string | Location for the SQL Server resource deployment. |
| [`sqlServerResourceName`](#parameter-sqlserverresourcename) | string | The name of the SQL Server resource. It will override the default given name. |
| [`storageAccountLocation`](#parameter-storageaccountlocation) | string | Location for the Storage Account resource deployment. |
| [`storageAccountResourceName`](#parameter-storageaccountresourcename) | string | The name of the Storage Account resource. It will override the default given name. |
| [`storageAccountSkuName`](#parameter-storageaccountskuname) | string | The SKU for the Storage Account. If empty, Standard_LRS will be used. |
| [`tags`](#parameter-tags) | object | The tags to apply to all deployed Azure resources. |
| [`webAppDockerImageContainerRegistryUrl`](#parameter-webappdockerimagecontainerregistryurl) | string | The url of the Container Registry where the docker image for Conversation Knowledge Mining webapp is located. |
| [`webAppDockerImageName`](#parameter-webappdockerimagename) | string | The name of the docker image for the Rag function. |
| [`webAppDockerImageTag`](#parameter-webappdockerimagetag) | string | The tag of the docker image for the Rag function. |
| [`webAppLocation`](#parameter-webapplocation) | string | Location for the Web App resource deployment. |
| [`webAppResourceName`](#parameter-webappresourcename) | string | The name of the Web App resource. |
| [`webAppServerFarmLocation`](#parameter-webappserverfarmlocation) | string | The location for the Web App Server Farm. Defaulted to the solution location. |
| [`webAppServerFarmResourceName`](#parameter-webappserverfarmresourcename) | string | The name of the Web App Server Farm resource. It will override the default given name. |
| [`webAppServerFarmSku`](#parameter-webappserverfarmsku) | string | The SKU for the web app. If empty it will be set to B2. |

### Parameter: `aiFoundryAiServicesContentUnderstandingLocation`

Location for the AI Foundry Content Understanding service deployment.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Australia East'
    'Sweden Central'
    'West US'
  ]
  ```

### Parameter: `solutionPrefix`

The prefix to add in the default names given to all deployed Azure resources.

- Required: Yes
- Type: string

### Parameter: `aiFoundryAiHubLocation`

Location for the AI Foundry AI Hub resource deployment.

- Required: No
- Type: string
- Default: `[parameters('solutionLocation')]`

### Parameter: `aiFoundryAiHubResourceName`

The name of the AI Foundry AI Hub resource. It will override the default given name.

- Required: No
- Type: string
- Default: `[format('{0}-aifd-aihb', parameters('solutionPrefix'))]`

### Parameter: `aiFoundryAiHubSkuName`

The SKU of the AI Foundry AI Hub account.

- Required: No
- Type: string
- Default: `'Basic'`
- Allowed:
  ```Bicep
  [
    'Basic'
    'Free'
    'Premium'
    'Standard'
  ]
  ```

### Parameter: `aiFoundryAiProjectLocation`

Location for the AI Foundry AI Project resource deployment.

- Required: No
- Type: string
- Default: `[parameters('solutionLocation')]`

### Parameter: `aiFoundryAiProjectResourceName`

The name of the AI Foundry AI Project resource. It will override the default given name.

- Required: No
- Type: string
- Default: `[format('{0}-aifd-aipj', parameters('solutionPrefix'))]`

### Parameter: `aiFoundryAiProjectSkuName`

The SKU of the AI Foundry AI project.

- Required: No
- Type: string
- Default: `'Standard'`
- Allowed:
  ```Bicep
  [
    'Basic'
    'Free'
    'Premium'
    'Standard'
  ]
  ```

### Parameter: `aiFoundryAiServicesContentUnderstandingResourceName`

The name of the AI Foundry AI Services Content Understanding resource. It will override the default given name.

- Required: No
- Type: string
- Default: `[format('{0}-aifd-aisr-cu', parameters('solutionPrefix'))]`

### Parameter: `aiFoundryAiServicesContentUnderstandingSkuName`

The SKU of the AI Foundry AI Services account. Use 'Get-AzCognitiveServicesAccountSku' to determine a valid combinations of 'kind' and 'SKU' for your Azure region.

- Required: No
- Type: string
- Default: `'S0'`
- Allowed:
  ```Bicep
  [
    'C2'
    'C3'
    'C4'
    'F0'
    'F1'
    'S'
    'S0'
    'S1'
    'S10'
    'S2'
    'S3'
    'S4'
    'S5'
    'S6'
    'S7'
    'S8'
    'S9'
  ]
  ```

### Parameter: `aiFoundryAIServicesGptModelDeploymentCapacity`

Capacity of the GPT model to deploy in the AI Foundry AI Services account. Capacity is limited per model/region, so you will get errors if you go over. [Quotas link](https://learn.microsoft.com/azure/ai-services/openai/quotas-limits).

- Required: No
- Type: int
- Default: `100`
- MinValue: 10

### Parameter: `aiFoundryAIServicesGptModelDeploymentType`

GPT model deployment type of the AI Foundry AI Services account.

- Required: No
- Type: string
- Default: `'GlobalStandard'`
- Allowed:
  ```Bicep
  [
    'GlobalStandard'
    'Standard'
  ]
  ```

### Parameter: `aiFoundryAIServicesGptModelName`

Name of the GPT model to deploy in the AI Foundry AI Services account.

- Required: No
- Type: string
- Default: `'gpt-4o-mini'`
- Allowed:
  ```Bicep
  [
    'gpt-4'
    'gpt-4o'
    'gpt-4o-mini'
  ]
  ```

### Parameter: `aiFoundryAiServicesLocation`

Location for the AI Foundry AI Service resource deployment.

- Required: No
- Type: string
- Default: `[parameters('solutionLocation')]`

### Parameter: `aiFoundryAiServicesResourceName`

The name of the AI Foundry AI Services resource. It will override the default given name.

- Required: No
- Type: string
- Default: `[format('{0}-aifd-aisr', parameters('solutionPrefix'))]`

### Parameter: `aiFoundryAiServicesSkuName`

The SKU of the AI Foundry AI Services account. Use 'Get-AzCognitiveServicesAccountSku' to determine a valid combinations of 'kind' and 'SKU' for your Azure region.

- Required: No
- Type: string
- Default: `'S0'`
- Allowed:
  ```Bicep
  [
    'C2'
    'C3'
    'C4'
    'F0'
    'F1'
    'S'
    'S0'
    'S1'
    'S10'
    'S2'
    'S3'
    'S4'
    'S5'
    'S6'
    'S7'
    'S8'
    'S9'
  ]
  ```

### Parameter: `aiFoundryAiServicesTextEmbeddingModelCapacity`

Capacity of the Text Embedding model to deploy in the AI Foundry AI Services account. Capacity is limited per model/region, so you will get errors if you go over. [Quotas link](https://learn.microsoft.com/azure/ai-services/openai/quotas-limits).

- Required: No
- Type: int
- Default: `80`
- MinValue: 10

### Parameter: `aiFoundryAiServicesTextEmbeddingModelName`

Name of the Text Embedding model to deploy in the AI Foundry AI Services account.

- Required: No
- Type: string
- Default: `'text-embedding-ada-002'`
- Allowed:
  ```Bicep
  [
    'text-embedding-ada-002'
  ]
  ```

### Parameter: `aiFoundryApplicationInsightsLocation`

Location for the AI Foundry Application Insights resource deployment.

- Required: No
- Type: string
- Default: `[parameters('solutionLocation')]`

### Parameter: `aiFoundryApplicationInsightsResourceName`

The name of the AI Foundry Application Insights resource. It will override the default given name.

- Required: No
- Type: string
- Default: `[format('{0}-aifd-appi', parameters('solutionPrefix'))]`

### Parameter: `aiFoundryApplicationInsightsRetentionInDays`

The retention of Application Insights data in days. If empty, Standard will be used.

- Required: No
- Type: int
- Default: `30`
- Allowed:
  ```Bicep
  [
    30
    60
    90
    120
    180
    270
    365
    550
    730
  ]
  ```

### Parameter: `aiFoundryContainerRegistryLocation`

Location for the AI Foundry Container Registry resource deployment.

- Required: No
- Type: string
- Default: `[parameters('solutionLocation')]`

### Parameter: `aiFoundryContainerRegistryResourceName`

The name of the AI Foundry Container Registry resource. It will override the default given name.

- Required: No
- Type: string
- Default: `[replace(format('{0}-aifd-creg', parameters('solutionPrefix')), '-', '')]`

### Parameter: `aiFoundryContainerRegistrySkuName`

The SKU for the AI Foundry Container Registry. If empty, Premium will be used.

- Required: No
- Type: string
- Default: `'Premium'`
- Allowed:
  ```Bicep
  [
    'Basic'
    'Premium'
    'Standard'
  ]
  ```

### Parameter: `aiFoundrySearchServiceLocation`

Location for the AI Foundry Search Service resource deployment.

- Required: No
- Type: string
- Default: `[parameters('solutionLocation')]`

### Parameter: `aiFoundrySearchServiceResourceName`

The name of the AI Foundry Search Service resource. It will override the default given name.

- Required: No
- Type: string
- Default: `[format('{0}-aifd-srch', parameters('solutionPrefix'))]`

### Parameter: `aiFoundrySearchServiceSkuName`

The SKU of the AI Foundry Search Service account.

- Required: No
- Type: string
- Default: `'basic'`
- Allowed:
  ```Bicep
  [
    'basic'
    'free'
    'standard'
    'standard2'
    'standard3'
    'storage_optimized_l1'
    'storage_optimized_l2'
  ]
  ```

### Parameter: `aiFoundryStorageAccountLocation`

Location for the AI Foundry Storage Account resource deployment.

- Required: No
- Type: string
- Default: `[parameters('solutionLocation')]`

### Parameter: `aiFoundryStorageAccountResourceName`

The name of the AI Foundry Storage Account resource. It will override the default given name.

- Required: No
- Type: string
- Default: `[replace(format('{0}-aifd-strg', parameters('solutionPrefix')), '-', '')]`

### Parameter: `aiFoundryStorageAccountSkuName`

The SKU for the AI Foundry Storage Account. If empty, Standard_LRS will be used.

- Required: No
- Type: string
- Default: `'Standard_LRS'`
- Allowed:
  ```Bicep
  [
    'Premium_LRS'
    'Premium_ZRS'
    'Standard_GRS'
    'Standard_LRS'
    'Standard_RAGRS'
    'Standard_ZRS'
  ]
  ```

### Parameter: `cosmosDbAccountLocation`

Location for the Cosmos DB Account resource deployment.

- Required: No
- Type: string
- Default: `[parameters('databasesLocation')]`

### Parameter: `cosmosDbAccountResourceName`

The name of the Cosmos DB Account resource. It will override the default given name.

- Required: No
- Type: string
- Default: `[format('{0}-cmdb', parameters('solutionPrefix'))]`

### Parameter: `databasesLocation`

Location for all the deployed databases Azure resources. Defaulted to East US 2.

- Required: No
- Type: string
- Default: `'East US 2'`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `functionChartAppScaleLimit`

The maximum number of workers that the Charts function can scale out.

- Required: No
- Type: int
- Default: `10`

### Parameter: `functionChartCpu`

The required CPU in cores of the Charts function.

- Required: No
- Type: int
- Default: `1`

### Parameter: `functionChartDockerImageContainerRegistryUrl`

The url of the Container Registry where the docker image for the Charts function is located.

- Required: No
- Type: string
- Default: `'kmcontainerreg.azurecr.io'`

### Parameter: `functionChartDockerImageName`

The name of the docker image for the Charts function.

- Required: No
- Type: string
- Default: `'km-charts-function'`

### Parameter: `functionChartDockerImageTag`

The tag of the docker image for the Charts function.

- Required: No
- Type: string
- Default: `'latest'`

### Parameter: `functionChartMemory`

The required memory in GiB of the Charts function.

- Required: No
- Type: string
- Default: `'2Gi'`

### Parameter: `functionChartsFunctionName`

The name of the function to be used to get the metrics in the Charts function.

- Required: No
- Type: string
- Default: `'get_metrics'`

### Parameter: `functionChartsLocation`

Location for the Function Charts resource deployment.

- Required: No
- Type: string
- Default: `[parameters('solutionLocation')]`

### Parameter: `functionChartsResourceName`

The name of the Function Charts resource. It will override the default given name.

- Required: No
- Type: string
- Default: `[format('{0}-fchr-azfn', parameters('solutionPrefix'))]`

### Parameter: `functionRagAppScaleLimit`

The maximum number of workers that the Rag function can scale out.

- Required: No
- Type: int
- Default: `10`

### Parameter: `functionRagCpu`

The required CPU in cores of the Rag function.

- Required: No
- Type: int
- Default: `1`

### Parameter: `functionRagDockerImageContainerRegistryUrl`

The url of the Container Registry where the docker image for the Rag function is located.

- Required: No
- Type: string
- Default: `'kmcontainerreg.azurecr.io'`

### Parameter: `functionRagDockerImageName`

The name of the docker image for the Rag function.

- Required: No
- Type: string
- Default: `'km-rag-function'`

### Parameter: `functionRagDockerImageTag`

The tag of the docker image for the Rag function.

- Required: No
- Type: string
- Default: `'latest'`

### Parameter: `functionRagFunctionName`

The name of the function to be used to stream text in the Rag function.

- Required: No
- Type: string
- Default: `'stream_openai_text'`

### Parameter: `functionRagLocation`

Location for the Function RAG resource deployment.

- Required: No
- Type: string
- Default: `[parameters('solutionLocation')]`

### Parameter: `functionRagMemory`

The required memory in GiB of the Rag function.

- Required: No
- Type: string
- Default: `'2Gi'`

### Parameter: `functionRagResourceName`

The name of the Function RAG resource. It will override the default given name.

- Required: No
- Type: string
- Default: `[format('{0}-frag-azfn', parameters('solutionPrefix'))]`

### Parameter: `functionsManagedEnvironmentLocation`

Location for the Functions Managed Environment resource deployment.

- Required: No
- Type: string
- Default: `[parameters('solutionLocation')]`

### Parameter: `functionsManagedEnvironmentResourceName`

The name of the Functions Managed Environment resource. It will override the default given name.

- Required: No
- Type: string
- Default: `[format('{0}-ftme', parameters('solutionPrefix'))]`

### Parameter: `keyVaultCreateMode`

The Key Vault create mode. Indicates whether the vault need to be recovered from purge or not. If empty, default will be used.

- Required: No
- Type: string
- Default: `'default'`
- Allowed:
  ```Bicep
  [
    'default'
    'recover'
  ]
  ```

### Parameter: `keyVaultLocation`

Location for the Key Vault resource deployment.

- Required: No
- Type: string
- Default: `[parameters('solutionLocation')]`

### Parameter: `keyVaultPurgeProtectionEnabled`

If set to true, The Key Vault purge protection will be enabled. If empty, it will be set to false.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `keyVaultResourceName`

The name of the Key Vault resource. It will override the default given name.

- Required: No
- Type: string
- Default: `[format('{0}-keyv', parameters('solutionPrefix'))]`

### Parameter: `keyVaultRoleAssignments`

Array of role assignments to include in the Key Vault.

- Required: No
- Type: array
- Default: `[]`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-keyvaultroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-keyvaultroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-keyvaultroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-keyvaultroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-keyvaultroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-keyvaultroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-keyvaultroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-keyvaultroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `keyVaultRoleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `keyVaultRoleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `keyVaultRoleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `keyVaultRoleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `keyVaultRoleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `keyVaultRoleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `keyVaultRoleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `keyVaultRoleAssignments.principalType`

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

### Parameter: `keyVaultSku`

The SKU for the Key Vault. If empty, standard will be used.

- Required: No
- Type: string
- Default: `'standard'`
- Allowed:
  ```Bicep
  [
    'premium'
    'standard'
  ]
  ```

### Parameter: `keyVaultSoftDeleteEnabled`

If set to true, The Key Vault soft delete will be enabled.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `keyVaultSoftDeleteRetentionInDays`

The number of days to retain the soft deleted vault. If empty, it will be set to 7.

- Required: No
- Type: int
- Default: `7`
- MinValue: 7
- MaxValue: 90

### Parameter: `logAnalyticsWorkspaceDataRetentionInDays`

The number of days to retain the data in the Log Analytics Workspace. If empty, it will be set to 30 days.

- Required: No
- Type: int
- Default: `30`
- MinValue: 0
- MaxValue: 730

### Parameter: `logAnalyticsWorkspaceLocation`

Location for the Log Analytics Workspace resource deployment.

- Required: No
- Type: string
- Default: `[parameters('solutionLocation')]`

### Parameter: `logAnalyticsWorkspaceResourceName`

The name of the Log Analytics Workspace resource. It will override the default given name.

- Required: No
- Type: string
- Default: `[format('{0}-laws', parameters('solutionPrefix'))]`

### Parameter: `logAnalyticsWorkspaceSkuName`

The SKU for the Log Analytics Workspace. If empty, PerGB2018 will be used.

- Required: No
- Type: string
- Default: `'PerGB2018'`
- Allowed:
  ```Bicep
  [
    'CapacityReservation'
    'Free'
    'LACluster'
    'PerGB2018'
    'PerNode'
    'Premium'
    'Standalone'
    'Standard'
  ]
  ```

### Parameter: `managedIdentityLocation`

Location for the Managed Identity resource deployment.

- Required: No
- Type: string
- Default: `[parameters('solutionLocation')]`

### Parameter: `managedIdentityResourceName`

The name of the Managed Identity resource. It will override the default given name.

- Required: No
- Type: string
- Default: `[format('{0}-mgid', parameters('solutionPrefix'))]`

### Parameter: `scriptCopyDataLocation`

Location for the Script Copy Data resource deployment.

- Required: No
- Type: string
- Default: `[parameters('solutionLocation')]`

### Parameter: `scriptCopyDataResourceName`

The name of the Script Copy Data resource. It will override the default given name.

- Required: No
- Type: string
- Default: `[format('{0}-scrp-cpdt', parameters('solutionPrefix'))]`

### Parameter: `scriptIndexDataLocation`

Location for the Script Index Data resource deployment.

- Required: No
- Type: string
- Default: `[parameters('solutionLocation')]`

### Parameter: `scriptIndexDataResourceName`

The name of the Script Index Data resource. It will override the default given name.

- Required: No
- Type: string
- Default: `[format('{0}-scrp-idxd', parameters('solutionPrefix'))]`

### Parameter: `solutionLocation`

Location for all the deployed Azure resources except databases. Defaulted to East US.

- Required: No
- Type: string
- Default: `'East US'`

### Parameter: `sqlServerAdministratorLogin`

The administrator login credential for the SQL Server.

- Required: No
- Type: securestring
- Default: `'sqladmin'`

### Parameter: `sqlServerAdministratorPassword`

The administrator password credential for the SQL Server.

- Required: No
- Type: securestring
- Default: `'TestPassword_1234'`

### Parameter: `sqlServerDatabaseName`

The name of the SQL Server database.

- Required: No
- Type: string
- Default: `[format('{0}-ckmdb', parameters('sqlServerResourceName'))]`

### Parameter: `sqlServerDatabaseSkuCapacity`

The SKU capacity of the SQL Server database. If empty, it will be set to 2. Find available options: Database.[Sku property](https://learn.microsoft.com/dotnet/api/microsoft.azure.management.sql.models.database.sku).

- Required: No
- Type: int
- Default: `2`

### Parameter: `sqlServerDatabaseSkuFamily`

The SKU Family of the SQL Server database. If empty, it will be set to Gen5. Find available options: Database.[Sku property](https://learn.microsoft.com/dotnet/api/microsoft.azure.management.sql.models.database.sku).

- Required: No
- Type: string
- Default: `'Gen5'`

### Parameter: `sqlServerDatabaseSkuName`

The SKU name of the SQL Server database. If empty, it will be set to GP_Gen5_2. Find available options: Database.[Sku property](https://learn.microsoft.com/dotnet/api/microsoft.azure.management.sql.models.database.sku).

- Required: No
- Type: string
- Default: `'GP_Gen5_2'`

### Parameter: `sqlServerDatabaseSkuTier`

The SKU tier of the SQL Server database. If empty, it will be set to GeneralPurpose. Find available options: Database.[Sku property](https://learn.microsoft.com/dotnet/api/microsoft.azure.management.sql.models.database.sku).

- Required: No
- Type: string
- Default: `'GeneralPurpose'`

### Parameter: `sqlServerLocation`

Location for the SQL Server resource deployment.

- Required: No
- Type: string
- Default: `[parameters('databasesLocation')]`

### Parameter: `sqlServerResourceName`

The name of the SQL Server resource. It will override the default given name.

- Required: No
- Type: string
- Default: `[format('{0}-sqls', parameters('solutionPrefix'))]`

### Parameter: `storageAccountLocation`

Location for the Storage Account resource deployment.

- Required: No
- Type: string
- Default: `[parameters('solutionLocation')]`

### Parameter: `storageAccountResourceName`

The name of the Storage Account resource. It will override the default given name.

- Required: No
- Type: string
- Default: `[replace(format('{0}-strg', parameters('solutionPrefix')), '-', '')]`

### Parameter: `storageAccountSkuName`

The SKU for the Storage Account. If empty, Standard_LRS will be used.

- Required: No
- Type: string
- Default: `'Standard_LRS'`
- Allowed:
  ```Bicep
  [
    'Premium_LRS'
    'Premium_ZRS'
    'Standard_GRS'
    'Standard_LRS'
    'Standard_RAGRS'
    'Standard_ZRS'
  ]
  ```

### Parameter: `tags`

The tags to apply to all deployed Azure resources.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      app: '[parameters(\'solutionPrefix\')]'
      location: '[parameters(\'solutionLocation\')]'
  }
  ```

### Parameter: `webAppDockerImageContainerRegistryUrl`

The url of the Container Registry where the docker image for Conversation Knowledge Mining webapp is located.

- Required: No
- Type: string
- Default: `'kmcontainerreg.azurecr.io'`

### Parameter: `webAppDockerImageName`

The name of the docker image for the Rag function.

- Required: No
- Type: string
- Default: `'km-app'`

### Parameter: `webAppDockerImageTag`

The tag of the docker image for the Rag function.

- Required: No
- Type: string
- Default: `'latest'`

### Parameter: `webAppLocation`

Location for the Web App resource deployment.

- Required: No
- Type: string
- Default: `[parameters('solutionLocation')]`

### Parameter: `webAppResourceName`

The name of the Web App resource.

- Required: No
- Type: string
- Default: `[format('{0}-wapp-wapp', parameters('solutionPrefix'))]`

### Parameter: `webAppServerFarmLocation`

The location for the Web App Server Farm. Defaulted to the solution location.

- Required: No
- Type: string
- Default: `[parameters('solutionLocation')]`

### Parameter: `webAppServerFarmResourceName`

The name of the Web App Server Farm resource. It will override the default given name.

- Required: No
- Type: string
- Default: `[format('{0}-waoo-srvf', parameters('solutionPrefix'))]`

### Parameter: `webAppServerFarmSku`

The SKU for the web app. If empty it will be set to B2.

- Required: No
- Type: string
- Default: `'B2'`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `resourceGroupName` | string | The resource group the resources were deployed into. |
| `webAppUrl` | string | The url of the webapp where the deployed Conversation Knowledge Mining solution can be accessed. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/app/managed-environment:0.10.0` | Remote reference |
| `br/public:avm/res/cognitive-services/account:0.10.1` | Remote reference |
| `br/public:avm/res/container-registry/registry:0.9.1` | Remote reference |
| `br/public:avm/res/document-db/database-account:0.11.2` | Remote reference |
| `br/public:avm/res/insights/component:0.6.0` | Remote reference |
| `br/public:avm/res/key-vault/vault:0.12.1` | Remote reference |
| `br/public:avm/res/machine-learning-services/workspace:0.10.1` | Remote reference |
| `br/public:avm/res/managed-identity/user-assigned-identity:0.4.0` | Remote reference |
| `br/public:avm/res/operational-insights/workspace:0.11.1` | Remote reference |
| `br/public:avm/res/resources/deployment-script:0.5.1` | Remote reference |
| `br/public:avm/res/search/search-service:0.9.1` | Remote reference |
| `br/public:avm/res/sql/server:0.13.1` | Remote reference |
| `br/public:avm/res/storage/storage-account:0.18.2` | Remote reference |
| `br/public:avm/res/web/serverfarm:0.4.1` | Remote reference |
| `br/public:avm/res/web/site:0.13.3` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
