# Conversation Knowledge Mining Solution Accelerator `[Sa/ConversationKnowledgeMining]`

This module deploys the [Conversation Knowledge Mining Solution Accelerator](https://github.com/microsoft/Conversation-Knowledge-Mining-Solution-Accelerator).

**Note:** This module is not intended for broad, generic use, as it was designed by the Commercial Solution Areas CTO team, as a Microsoft Solution Accelerator product. Feature requests and bug fix requests are welcome if they support the needs of this organization but may not be incorporated if they aim to make this module more generic than what it needs to be for its primary use case. This module will likely be updated to leverage AVM resource modules in the future.

This may result in breaking changes in upcoming versions when these features are implemented.


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
| `Microsoft.App/managedEnvironments` | [2024-02-02-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2024-02-02-preview/managedEnvironments) |
| `Microsoft.App/managedEnvironments/storages` | [2024-02-02-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2024-02-02-preview/managedEnvironments/storages) |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.CognitiveServices/accounts` | [2024-04-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2024-04-01-preview/accounts) |
| `Microsoft.CognitiveServices/accounts/deployments` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2023-05-01/accounts/deployments) |
| `Microsoft.ContainerRegistry/registries` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-06-01-preview/registries) |
| `Microsoft.ContainerRegistry/registries/cacheRules` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-06-01-preview/registries/cacheRules) |
| `Microsoft.ContainerRegistry/registries/credentialSets` | [2023-11-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-11-01-preview/registries/credentialSets) |
| `Microsoft.ContainerRegistry/registries/replications` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-06-01-preview/registries/replications) |
| `Microsoft.ContainerRegistry/registries/scopeMaps` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-06-01-preview/registries/scopeMaps) |
| `Microsoft.ContainerRegistry/registries/webhooks` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-06-01-preview/registries/webhooks) |
| `Microsoft.DocumentDB/databaseAccounts` | [2023-04-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2023-04-15/databaseAccounts) |
| `Microsoft.DocumentDB/databaseAccounts/gremlinDatabases` | [2023-04-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2023-04-15/databaseAccounts/gremlinDatabases) |
| `Microsoft.DocumentDB/databaseAccounts/gremlinDatabases/graphs` | [2023-04-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2023-04-15/databaseAccounts/gremlinDatabases/graphs) |
| `Microsoft.DocumentDB/databaseAccounts/mongodbDatabases` | [2023-04-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2023-04-15/databaseAccounts/mongodbDatabases) |
| `Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections` | [2023-04-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2023-04-15/databaseAccounts/mongodbDatabases/collections) |
| `Microsoft.DocumentDB/databaseAccounts/sqlDatabases` | [2023-04-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2023-04-15/databaseAccounts/sqlDatabases) |
| `Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers` | [2023-04-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2023-04-15/databaseAccounts/sqlDatabases/containers) |
| `Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments` | [2023-04-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2023-04-15/databaseAccounts/sqlRoleAssignments) |
| `Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments` | [2024-12-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-12-01-preview/databaseAccounts/sqlRoleAssignments) |
| `Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions` | [2023-04-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2023-04-15/databaseAccounts/sqlRoleDefinitions) |
| `Microsoft.DocumentDB/databaseAccounts/tables` | [2023-04-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2023-04-15/databaseAccounts/tables) |
| `Microsoft.Insights/components` | [2020-02-02](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2020-02-02/components) |
| `microsoft.insights/components/linkedStorageAccounts` | [2020-03-01-preview](https://learn.microsoft.com/en-us/azure/templates/microsoft.insights/2020-03-01-preview/components/linkedStorageAccounts) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.KeyVault/vaults` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults) |
| `Microsoft.KeyVault/vaults/accessPolicies` | [2023-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2023-07-01/vaults/accessPolicies) |
| `Microsoft.KeyVault/vaults/keys` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/keys) |
| `Microsoft.KeyVault/vaults/secrets` | [2021-11-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2021-11-01-preview/vaults/secrets) |
| `Microsoft.KeyVault/vaults/secrets` | [2023-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2023-07-01/vaults/secrets) |
| `Microsoft.KeyVault/vaults/secrets` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/secrets) |
| `Microsoft.MachineLearningServices/workspaces` | [2024-04-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.MachineLearningServices/2024-04-01-preview/workspaces) |
| `Microsoft.MachineLearningServices/workspaces/computes` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.MachineLearningServices/2022-10-01/workspaces/computes) |
| `Microsoft.MachineLearningServices/workspaces/connections` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.MachineLearningServices/2024-04-01/workspaces/connections) |
| `Microsoft.ManagedIdentity/userAssignedIdentities` | [2023-01-31](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2023-01-31/userAssignedIdentities) |
| `Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials` | [2023-01-31](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2023-01-31/userAssignedIdentities/federatedIdentityCredentials) |
| `Microsoft.Network/privateEndpoints` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.OperationalInsights/workspaces` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2022-10-01/workspaces) |
| `Microsoft.OperationalInsights/workspaces/dataExports` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/dataExports) |
| `Microsoft.OperationalInsights/workspaces/dataSources` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/dataSources) |
| `Microsoft.OperationalInsights/workspaces/linkedServices` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/linkedServices) |
| `Microsoft.OperationalInsights/workspaces/linkedStorageAccounts` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/linkedStorageAccounts) |
| `Microsoft.OperationalInsights/workspaces/savedSearches` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/savedSearches) |
| `Microsoft.OperationalInsights/workspaces/storageInsightConfigs` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/storageInsightConfigs) |
| `Microsoft.OperationalInsights/workspaces/tables` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2022-10-01/workspaces/tables) |
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
    aiFoundryAiServiceContentUnderstandingLocation: 'West US'
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
    "aiFoundryAiServiceContentUnderstandingLocation": {
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
param aiFoundryAiServiceContentUnderstandingLocation = 'West US'
param solutionPrefix = 'ckmpoc'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`aiFoundryAiServiceContentUnderstandingLocation`](#parameter-aifoundryaiservicecontentunderstandinglocation) | string | Location for the AI Foundry Content Understanding service deployment. |
| [`solutionPrefix`](#parameter-solutionprefix) | string | The prefix to add in the default names given to all deployed Azure resources. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`aiFoundryAiHubResourceName`](#parameter-aifoundryaihubresourcename) | string | The name of the AI Foundry AI Hub resource. It will override the default given name. |
| [`aiFoundryAiProjectResourceName`](#parameter-aifoundryaiprojectresourcename) | string | The name of the AI Foundry AI Project resource. It will override the default given name. |
| [`aiFoundryAiServicesContentUnderstandingResourceName`](#parameter-aifoundryaiservicescontentunderstandingresourcename) | string | The name of the AI Foundry AI Services Content Understanding resource. It will override the default given name. |
| [`aiFoundryAIServicesGptModelDeploymentCapacity`](#parameter-aifoundryaiservicesgptmodeldeploymentcapacity) | int | Capacity of the GPT deployment. You can increase this, but capacity is limited per model/region, so you will get errors if you go over. [Quotas link](https://learn.microsoft.com/en-us/azure/ai-services/openai/quotas-limits). |
| [`aiFoundryAIServicesGptModelDeploymentType`](#parameter-aifoundryaiservicesgptmodeldeploymenttype) | string | GPT model deployment type. |
| [`aiFoundryAIServicesGptModelName`](#parameter-aifoundryaiservicesgptmodelname) | string | Name of the GPT model to deploy. |
| [`aiFoundryAiServicesProjectLocation`](#parameter-aifoundryaiservicesprojectlocation) | string | The location of the AI Foundry AI Services Project. If empty, aiFoundryAiServiceContentUnderstandingLocation will be used. |
| [`aiFoundryAiServicesResourceName`](#parameter-aifoundryaiservicesresourcename) | string | The name of the AI Foundry AI Services resource. It will override the default given name. |
| [`aiFoundryAiServicesTextEmbeddingModelName`](#parameter-aifoundryaiservicestextembeddingmodelname) | string | Name of the Text Embedding model to deploy. |
| [`aiFoundryApplicationInsightsResourceName`](#parameter-aifoundryapplicationinsightsresourcename) | string | The name of the AI Foundry Application Insights resource. It will override the default given name. |
| [`aiFoundryContainerRegistryResourceName`](#parameter-aifoundrycontainerregistryresourcename) | string | The name of the AI Foundry Container Registry resource. It will override the default given name. |
| [`aiFoundrySearchServiceResourceName`](#parameter-aifoundrysearchserviceresourcename) | string | The name of the AI Foundry Search Service resource. It will override the default given name. |
| [`aiFoundryStorageAccountResourceName`](#parameter-aifoundrystorageaccountresourcename) | string | The name of the AI Foundry Storage Account resource. It will override the default given name. |
| [`cosmosDbAccountResourceName`](#parameter-cosmosdbaccountresourcename) | string | The name of the Cosmos DB Account resource. It will override the default given name. |
| [`databasesLocation`](#parameter-databaseslocation) | string | Secondary location for databases creation. |
| [`embeddingDeploymentCapacity`](#parameter-embeddingdeploymentcapacity) | int | Capacity of the Embedding Model deployment. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`functionChartsResourceName`](#parameter-functionchartsresourcename) | string | The name of the Function Charts resource. It will override the default given name. |
| [`functionRagResourceName`](#parameter-functionragresourcename) | string | The name of the Function RAG resource. It will override the default given name. |
| [`functionsManagedEnvironmentResourceName`](#parameter-functionsmanagedenvironmentresourcename) | string | The name of the Functions Managed Environment resource. It will override the default given name. |
| [`imageTag`](#parameter-imagetag) | string | Docker image version to use for all deployed containers (functions and web app). |
| [`keyVaultResourceName`](#parameter-keyvaultresourcename) | string | The name of the Key Vault resource. It will override the default given name. |
| [`logAnalyticsWorkspaceResourceName`](#parameter-loganalyticsworkspaceresourcename) | string | The name of the Log Analytics Workspace resource. It will override the default given name. |
| [`managedIdentityResourceName`](#parameter-managedidentityresourcename) | string | The name of the Managed Identity resource. It will override the default given name. |
| [`scriptCopyDataResourceName`](#parameter-scriptcopydataresourcename) | string | The name of the Script Copy Data resource. It will override the default given name. |
| [`scriptIndexDataResourceName`](#parameter-scriptindexdataresourcename) | string | The name of the Script Index Data resource. It will override the default given name. |
| [`solutionLocation`](#parameter-solutionlocation) | string | Location for the solution deployment. Defaulted to the resource group location. |
| [`sqlServerResourceName`](#parameter-sqlserverresourcename) | string | The name of the SQL Server resource. It will override the default given name. |
| [`storageAccountResourceName`](#parameter-storageaccountresourcename) | string | The name of the Storage Account resource. It will override the default given name. |
| [`webAppResourceName`](#parameter-webappresourcename) | string | The name of the Web App resource. |
| [`webAppServerFarmLocation`](#parameter-webappserverfarmlocation) | string | The location for the Web App Server Farm. If empty, aiFoundryAiServiceContentUnderstandingLocation will be used. |
| [`webAppServerFarmResourceName`](#parameter-webappserverfarmresourcename) | string | The name of the Web App Server Farm resource. It will override the default given name. |
| [`webAppServerFarmSku`](#parameter-webappserverfarmsku) | string | The SKU for the web app. If empty, aiFoundryAiServiceContentUnderstandingLocation will be used. |

### Parameter: `aiFoundryAiServiceContentUnderstandingLocation`

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

### Parameter: `aiFoundryAiHubResourceName`

The name of the AI Foundry AI Hub resource. It will override the default given name.

- Required: No
- Type: string
- Default: `''`

### Parameter: `aiFoundryAiProjectResourceName`

The name of the AI Foundry AI Project resource. It will override the default given name.

- Required: No
- Type: string
- Default: `''`

### Parameter: `aiFoundryAiServicesContentUnderstandingResourceName`

The name of the AI Foundry AI Services Content Understanding resource. It will override the default given name.

- Required: No
- Type: string
- Default: `''`

### Parameter: `aiFoundryAIServicesGptModelDeploymentCapacity`

Capacity of the GPT deployment. You can increase this, but capacity is limited per model/region, so you will get errors if you go over. [Quotas link](https://learn.microsoft.com/en-us/azure/ai-services/openai/quotas-limits).

- Required: No
- Type: int
- Default: `100`
- MinValue: 10

### Parameter: `aiFoundryAIServicesGptModelDeploymentType`

GPT model deployment type.

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
- MinValue: 10

### Parameter: `aiFoundryAIServicesGptModelName`

Name of the GPT model to deploy.

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
- MinValue: 10

### Parameter: `aiFoundryAiServicesProjectLocation`

The location of the AI Foundry AI Services Project. If empty, aiFoundryAiServiceContentUnderstandingLocation will be used.

- Required: No
- Type: string
- Default: `''`
- MinValue: 10

### Parameter: `aiFoundryAiServicesResourceName`

The name of the AI Foundry AI Services resource. It will override the default given name.

- Required: No
- Type: string
- Default: `''`
- MinValue: 10

### Parameter: `aiFoundryAiServicesTextEmbeddingModelName`

Name of the Text Embedding model to deploy.

- Required: No
- Type: string
- Default: `'text-embedding-ada-002'`
- Allowed:
  ```Bicep
  [
    'text-embedding-ada-002'
  ]
  ```
- MinValue: 10

### Parameter: `aiFoundryApplicationInsightsResourceName`

The name of the AI Foundry Application Insights resource. It will override the default given name.

- Required: No
- Type: string
- Default: `''`
- MinValue: 10

### Parameter: `aiFoundryContainerRegistryResourceName`

The name of the AI Foundry Container Registry resource. It will override the default given name.

- Required: No
- Type: string
- Default: `''`
- MinValue: 10

### Parameter: `aiFoundrySearchServiceResourceName`

The name of the AI Foundry Search Service resource. It will override the default given name.

- Required: No
- Type: string
- Default: `''`
- MinValue: 10

### Parameter: `aiFoundryStorageAccountResourceName`

The name of the AI Foundry Storage Account resource. It will override the default given name.

- Required: No
- Type: string
- Default: `''`
- MinValue: 10

### Parameter: `cosmosDbAccountResourceName`

The name of the Cosmos DB Account resource. It will override the default given name.

- Required: No
- Type: string
- Default: `''`
- MinValue: 10

### Parameter: `databasesLocation`

Secondary location for databases creation.

- Required: No
- Type: string
- Default: `'East US 2'`
- MinValue: 10

### Parameter: `embeddingDeploymentCapacity`

Capacity of the Embedding Model deployment.

- Required: No
- Type: int
- Default: `80`
- MinValue: 10

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`
- MinValue: 10

### Parameter: `functionChartsResourceName`

The name of the Function Charts resource. It will override the default given name.

- Required: No
- Type: string
- Default: `''`
- MinValue: 10

### Parameter: `functionRagResourceName`

The name of the Function RAG resource. It will override the default given name.

- Required: No
- Type: string
- Default: `''`
- MinValue: 10

### Parameter: `functionsManagedEnvironmentResourceName`

The name of the Functions Managed Environment resource. It will override the default given name.

- Required: No
- Type: string
- Default: `''`
- MinValue: 10

### Parameter: `imageTag`

Docker image version to use for all deployed containers (functions and web app).

- Required: No
- Type: string
- Default: `'latest'`
- MinValue: 10

### Parameter: `keyVaultResourceName`

The name of the Key Vault resource. It will override the default given name.

- Required: No
- Type: string
- Default: `''`
- MinValue: 10

### Parameter: `logAnalyticsWorkspaceResourceName`

The name of the Log Analytics Workspace resource. It will override the default given name.

- Required: No
- Type: string
- Default: `''`
- MinValue: 10

### Parameter: `managedIdentityResourceName`

The name of the Managed Identity resource. It will override the default given name.

- Required: No
- Type: string
- Default: `''`
- MinValue: 10

### Parameter: `scriptCopyDataResourceName`

The name of the Script Copy Data resource. It will override the default given name.

- Required: No
- Type: string
- Default: `''`
- MinValue: 10

### Parameter: `scriptIndexDataResourceName`

The name of the Script Index Data resource. It will override the default given name.

- Required: No
- Type: string
- Default: `''`
- MinValue: 10

### Parameter: `solutionLocation`

Location for the solution deployment. Defaulted to the resource group location.

- Required: No
- Type: string
- Default: `'East US'`
- MinValue: 10

### Parameter: `sqlServerResourceName`

The name of the SQL Server resource. It will override the default given name.

- Required: No
- Type: string
- Default: `''`
- MinValue: 10

### Parameter: `storageAccountResourceName`

The name of the Storage Account resource. It will override the default given name.

- Required: No
- Type: string
- Default: `''`
- MinValue: 10

### Parameter: `webAppResourceName`

The name of the Web App resource.

- Required: No
- Type: string
- Default: `''`
- MinValue: 10

### Parameter: `webAppServerFarmLocation`

The location for the Web App Server Farm. If empty, aiFoundryAiServiceContentUnderstandingLocation will be used.

- Required: No
- Type: string
- Default: `''`
- MinValue: 10

### Parameter: `webAppServerFarmResourceName`

The name of the Web App Server Farm resource. It will override the default given name.

- Required: No
- Type: string
- Default: `''`
- MinValue: 10

### Parameter: `webAppServerFarmSku`

The SKU for the web app. If empty, aiFoundryAiServiceContentUnderstandingLocation will be used.

- Required: No
- Type: string
- Default: `'B2'`
- MinValue: 10

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `resourceGroupName` | string | The resource group the resources were deployed into. |
| `webAppUrl` | string | The url of the webapp where the deployed Conversation Knowledge Mining solution can be accessed |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/app/managed-environment:0.9.0` | Remote reference |
| `br/public:avm/res/container-registry/registry:0.8.3` | Remote reference |
| `br/public:avm/res/document-db/database-account:0.11.0` | Remote reference |
| `br/public:avm/res/insights/component:0.5.0` | Remote reference |
| `br/public:avm/res/key-vault/vault:0.11.2` | Remote reference |
| `br/public:avm/res/machine-learning-services/workspace:0.10.0` | Remote reference |
| `br/public:avm/res/machine-learning-services/workspace:0.10.1` | Remote reference |
| `br/public:avm/res/managed-identity/user-assigned-identity:0.4.0` | Remote reference |
| `br/public:avm/res/operational-insights/workspace:0.9.1` | Remote reference |
| `br/public:avm/res/resources/deployment-script:0.5.1` | Remote reference |
| `br/public:avm/res/search/search-service:0.9.0` | Remote reference |
| `br/public:avm/res/sql/server:0.12.2` | Remote reference |
| `br/public:avm/res/storage/storage-account:0.18.1` | Remote reference |
| `br/public:avm/res/web/serverfarm:0.4.1` | Remote reference |
| `br/public:avm/res/web/site:0.13.3` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
