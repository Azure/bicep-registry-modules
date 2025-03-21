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

- [Sandbox configuration with defaults parameter values](#example-1-sandbox-configuration-with-defaults-parameter-values)

### Example 1: _Sandbox configuration with defaults parameter values_

This instance deploys the [Conversation Knowledge Mining Solution Accelerator](https://github.com/microsoft/Conversation-Knowledge-Mining-Solution-Accelerator) using the default values, which are designed for Sandbox environments


<details>

<summary>via Bicep module</summary>

```bicep
module conversationKnowledgeMining 'br/public:avm/ptn/sa/conversation-knowledge-mining:<version>' = {
  name: 'conversationKnowledgeMiningDeployment'
  params: {
    solutionPrefix: 'sbxdft'
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
    "solutionPrefix": {
      "value": "sbxdft"
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

param solutionPrefix = 'sbxdft'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`solutionPrefix`](#parameter-solutionprefix) | string | The prefix to add in the default names given to all deployed Azure resources. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`aiFoundryAiHubConfiguration`](#parameter-aifoundryaihubconfiguration) | object | The configuration to apply for the Conversation Knowledge Mining AI Foundry AI Hub resource. |
| [`aiFoundryAiProjectConfiguration`](#parameter-aifoundryaiprojectconfiguration) | object | The configuration to apply for the Conversation Knowledge Mining AI Foundry AI Project resource. |
| [`aiFoundryAiServicesConfiguration`](#parameter-aifoundryaiservicesconfiguration) | object | The configuration to apply for the Conversation Knowledge Mining AI Foundry AI Services resource. |
| [`aiFoundryAiServicesContentUnderstandingConfiguration`](#parameter-aifoundryaiservicescontentunderstandingconfiguration) | object | The configuration to apply for the Conversation Knowledge Mining AI Foundry AI Services Content Understanding resource. |
| [`aiFoundryApplicationInsightsConfiguration`](#parameter-aifoundryapplicationinsightsconfiguration) | object | The configuration to apply for the Conversation Knowledge Mining AI Foundry Application Insights resource. |
| [`aiFoundryContainerRegistryConfiguration`](#parameter-aifoundrycontainerregistryconfiguration) | object | The configuration to apply for the Conversation Knowledge Mining AI Foundry Container Registry resource. |
| [`aiFoundrySearchServiceConfiguration`](#parameter-aifoundrysearchserviceconfiguration) | object | The configuration to apply for the Conversation Knowledge Mining AI Foundry Search Services resource. |
| [`aiFoundryStorageAccountConfiguration`](#parameter-aifoundrystorageaccountconfiguration) | object | The configuration to apply for the Conversation Knowledge Mining AI Foundry Storage Account resource. |
| [`cosmosDbAccountConfiguration`](#parameter-cosmosdbaccountconfiguration) | object | The configuration to apply for the Conversation Knowledge Mining Cosmos DB Account resource. |
| [`databasesLocation`](#parameter-databaseslocation) | string | Location for all the deployed databases Azure resources. Defaulted to East US 2. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`functionChartsConfiguration`](#parameter-functionchartsconfiguration) | object | The configuration to apply for the Conversation Knowledge Mining Charts Function resource. |
| [`functionRagConfiguration`](#parameter-functionragconfiguration) | object | The configuration to apply for the Conversation Knowledge Mining Rag Function resource. |
| [`functionsManagedEnvironmentConfiguration`](#parameter-functionsmanagedenvironmentconfiguration) | object | The configuration to apply for the Conversation Knowledge Mining Functions Managed Environment resource. |
| [`keyVaultConfiguration`](#parameter-keyvaultconfiguration) | object | The configuration to apply for the Conversation Knowledge Mining Key Vault resource. |
| [`logAnalyticsWorkspaceConfiguration`](#parameter-loganalyticsworkspaceconfiguration) | object | The configuration to apply for the Conversation Knowledge Mining Log Analytics Workspace resource. |
| [`managedIdentityConfiguration`](#parameter-managedidentityconfiguration) | object | The configuration to apply for the Conversation Knowledge Mining Managed Identity resource. |
| [`scriptCopyDataConfiguration`](#parameter-scriptcopydataconfiguration) | object | The configuration to apply for the Conversation Knowledge Mining Copy Data Script resource. |
| [`scriptIndexDataConfiguration`](#parameter-scriptindexdataconfiguration) | object | The configuration to apply for the Conversation Knowledge Mining Copy Data Script resource. |
| [`solutionLocation`](#parameter-solutionlocation) | string | Location for all the deployed Azure resources except databases. Defaulted to East US. |
| [`sqlServerConfiguration`](#parameter-sqlserverconfiguration) | object | The configuration to apply for the Conversation Knowledge Mining SQL Server resource. |
| [`storageAccountConfiguration`](#parameter-storageaccountconfiguration) | object | The configuration to apply for the Conversation Knowledge Mining Storage Account resource. |
| [`tags`](#parameter-tags) | object | The tags to apply to all deployed Azure resources. |
| [`webAppServerFarmConfiguration`](#parameter-webappserverfarmconfiguration) | object | The configuration to apply for the Conversation Knowledge Mining Web App Server Farm resource. |

### Parameter: `solutionPrefix`

The prefix to add in the default names given to all deployed Azure resources.

- Required: Yes
- Type: string

### Parameter: `aiFoundryAiHubConfiguration`

The configuration to apply for the Conversation Knowledge Mining AI Foundry AI Hub resource.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      location: '[parameters(\'solutionLocation\')]'
      name: '[format(\'{0}-aifd-aihb\', parameters(\'solutionPrefix\'))]'
      sku: 'Basic'
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`location`](#parameter-aifoundryaihubconfigurationlocation) | string | Location for the AI Foundry AI Hub resource. |
| [`name`](#parameter-aifoundryaihubconfigurationname) | string | The name of the AI Foundry AI Hub resource. |
| [`sku`](#parameter-aifoundryaihubconfigurationsku) | string | The SKU of the AI Foundry AI Hub resource. |

### Parameter: `aiFoundryAiHubConfiguration.location`

Location for the AI Foundry AI Hub resource.

- Required: No
- Type: string

### Parameter: `aiFoundryAiHubConfiguration.name`

The name of the AI Foundry AI Hub resource.

- Required: No
- Type: string

### Parameter: `aiFoundryAiHubConfiguration.sku`

The SKU of the AI Foundry AI Hub resource.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Basic'
    'Free'
    'Premium'
    'Standard'
  ]
  ```

### Parameter: `aiFoundryAiProjectConfiguration`

The configuration to apply for the Conversation Knowledge Mining AI Foundry AI Project resource.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      location: '[parameters(\'solutionLocation\')]'
      name: '[format(\'{0}-aifd-aipj\', parameters(\'solutionPrefix\'))]'
      sku: 'Standard'
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`location`](#parameter-aifoundryaiprojectconfigurationlocation) | string | Location for the AI Foundry AI Project resource deployment. |
| [`name`](#parameter-aifoundryaiprojectconfigurationname) | string | The name of the AI Foundry AI Project resource. |
| [`sku`](#parameter-aifoundryaiprojectconfigurationsku) | string | The SKU of the AI Foundry AI Project resource. |

### Parameter: `aiFoundryAiProjectConfiguration.location`

Location for the AI Foundry AI Project resource deployment.

- Required: No
- Type: string

### Parameter: `aiFoundryAiProjectConfiguration.name`

The name of the AI Foundry AI Project resource.

- Required: No
- Type: string

### Parameter: `aiFoundryAiProjectConfiguration.sku`

The SKU of the AI Foundry AI Project resource.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Basic'
    'Free'
    'Premium'
    'Standard'
  ]
  ```

### Parameter: `aiFoundryAiServicesConfiguration`

The configuration to apply for the Conversation Knowledge Mining AI Foundry AI Services resource.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      gptModelCapacity: 100
      gptModelName: 'gpt-4o-mini'
      gptModelSku: 'Standard'
      location: 'East US'
      name: '[format(\'{0}-aifd-aisr\', parameters(\'solutionPrefix\'))]'
      sku: 'S0'
      textEmbeddingModelCapacity: 80
      textEmbeddingModelName: 'text-embedding-ada-002'
      textEmbeddingModelSku: 'Standard'
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`gptModelCapacity`](#parameter-aifoundryaiservicesconfigurationgptmodelcapacity) | int | Capacity of the GPT model to deploy in the AI Foundry AI Services account. Capacity is limited per model/region, so you will get errors if you go over. [Quotas link](https://learn.microsoft.com/azure/ai-services/openai/quotas-limits). |
| [`gptModelName`](#parameter-aifoundryaiservicesconfigurationgptmodelname) | string | Name of the GPT model to deploy in the AI Foundry AI Services account. |
| [`gptModelSku`](#parameter-aifoundryaiservicesconfigurationgptmodelsku) | string | GPT model deployment type of the AI Foundry AI Services account. |
| [`location`](#parameter-aifoundryaiservicesconfigurationlocation) | string | Location for the AI Foundry AI Services resource. |
| [`name`](#parameter-aifoundryaiservicesconfigurationname) | string | The name of the AI Foundry AI Services resource. |
| [`sku`](#parameter-aifoundryaiservicesconfigurationsku) | string | The SKU of the AI Foundry AI Services resource. Use 'Get-AzCognitiveServicesAccountSku' to determine a valid combinations of 'kind' and 'SKU' for your Azure region. |
| [`textEmbeddingModelCapacity`](#parameter-aifoundryaiservicesconfigurationtextembeddingmodelcapacity) | int | Capacity of the Text Embedding model to deploy in the AI Foundry AI Services account. Capacity is limited per model/region, so you will get errors if you go over. [Quotas link](https://learn.microsoft.com/azure/ai-services/openai/quotas-limits). |
| [`textEmbeddingModelName`](#parameter-aifoundryaiservicesconfigurationtextembeddingmodelname) | string | Name of the Text Embedding model to deploy in the AI Foundry AI Services account. |
| [`textEmbeddingModelSku`](#parameter-aifoundryaiservicesconfigurationtextembeddingmodelsku) | string | GPT model deployment type of the AI Foundry AI Services account. |

### Parameter: `aiFoundryAiServicesConfiguration.gptModelCapacity`

Capacity of the GPT model to deploy in the AI Foundry AI Services account. Capacity is limited per model/region, so you will get errors if you go over. [Quotas link](https://learn.microsoft.com/azure/ai-services/openai/quotas-limits).

- Required: No
- Type: int
- MinValue: 10

### Parameter: `aiFoundryAiServicesConfiguration.gptModelName`

Name of the GPT model to deploy in the AI Foundry AI Services account.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'gpt-4'
    'gpt-4o'
    'gpt-4o-mini'
  ]
  ```

### Parameter: `aiFoundryAiServicesConfiguration.gptModelSku`

GPT model deployment type of the AI Foundry AI Services account.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'GlobalStandard'
    'Standard'
  ]
  ```

### Parameter: `aiFoundryAiServicesConfiguration.location`

Location for the AI Foundry AI Services resource.

- Required: No
- Type: string

### Parameter: `aiFoundryAiServicesConfiguration.name`

The name of the AI Foundry AI Services resource.

- Required: No
- Type: string

### Parameter: `aiFoundryAiServicesConfiguration.sku`

The SKU of the AI Foundry AI Services resource. Use 'Get-AzCognitiveServicesAccountSku' to determine a valid combinations of 'kind' and 'SKU' for your Azure region.

- Required: No
- Type: string
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

### Parameter: `aiFoundryAiServicesConfiguration.textEmbeddingModelCapacity`

Capacity of the Text Embedding model to deploy in the AI Foundry AI Services account. Capacity is limited per model/region, so you will get errors if you go over. [Quotas link](https://learn.microsoft.com/azure/ai-services/openai/quotas-limits).

- Required: No
- Type: int
- MinValue: 10

### Parameter: `aiFoundryAiServicesConfiguration.textEmbeddingModelName`

Name of the Text Embedding model to deploy in the AI Foundry AI Services account.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'text-embedding-ada-002'
  ]
  ```

### Parameter: `aiFoundryAiServicesConfiguration.textEmbeddingModelSku`

GPT model deployment type of the AI Foundry AI Services account.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Standard'
  ]
  ```

### Parameter: `aiFoundryAiServicesContentUnderstandingConfiguration`

The configuration to apply for the Conversation Knowledge Mining AI Foundry AI Services Content Understanding resource.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      location: 'West US'
      name: '[format(\'{0}-aifd-aisr-cu\', parameters(\'solutionPrefix\'))]'
      sku: 'S0'
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`location`](#parameter-aifoundryaiservicescontentunderstandingconfigurationlocation) | string | Location for the AI Foundry Content Understanding service deployment. |
| [`name`](#parameter-aifoundryaiservicescontentunderstandingconfigurationname) | string | The name of the AI Foundry AI Services Content Understanding resource. |
| [`sku`](#parameter-aifoundryaiservicescontentunderstandingconfigurationsku) | string | The SKU of the AI Foundry AI Services account. Use 'Get-AzCognitiveServicesAccountSku' to determine a valid combinations of 'kind' and 'SKU' for your Azure region. |

### Parameter: `aiFoundryAiServicesContentUnderstandingConfiguration.location`

Location for the AI Foundry Content Understanding service deployment.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Australia East'
    'Sweden Central'
    'West US'
  ]
  ```

### Parameter: `aiFoundryAiServicesContentUnderstandingConfiguration.name`

The name of the AI Foundry AI Services Content Understanding resource.

- Required: No
- Type: string

### Parameter: `aiFoundryAiServicesContentUnderstandingConfiguration.sku`

The SKU of the AI Foundry AI Services account. Use 'Get-AzCognitiveServicesAccountSku' to determine a valid combinations of 'kind' and 'SKU' for your Azure region.

- Required: No
- Type: string
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

### Parameter: `aiFoundryApplicationInsightsConfiguration`

The configuration to apply for the Conversation Knowledge Mining AI Foundry Application Insights resource.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      location: '[parameters(\'solutionLocation\')]'
      name: '[format(\'{0}-aifd-appi\', parameters(\'solutionPrefix\'))]'
      retentionInDays: 30
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`location`](#parameter-aifoundryapplicationinsightsconfigurationlocation) | string | Location for the AI Foundry Application Insights resource. |
| [`name`](#parameter-aifoundryapplicationinsightsconfigurationname) | string | The name of the AI Foundry Application Insights resource. |
| [`retentionInDays`](#parameter-aifoundryapplicationinsightsconfigurationretentionindays) | int | The retention of Application Insights data in days. If empty, Standard will be used. |

### Parameter: `aiFoundryApplicationInsightsConfiguration.location`

Location for the AI Foundry Application Insights resource.

- Required: No
- Type: string

### Parameter: `aiFoundryApplicationInsightsConfiguration.name`

The name of the AI Foundry Application Insights resource.

- Required: No
- Type: string

### Parameter: `aiFoundryApplicationInsightsConfiguration.retentionInDays`

The retention of Application Insights data in days. If empty, Standard will be used.

- Required: No
- Type: int
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

### Parameter: `aiFoundryContainerRegistryConfiguration`

The configuration to apply for the Conversation Knowledge Mining AI Foundry Container Registry resource.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      location: '[parameters(\'solutionLocation\')]'
      name: '[replace(format(\'{0}-aifd-creg\', parameters(\'solutionPrefix\')), \'-\', \'\')]'
      sku: 'Premium'
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`location`](#parameter-aifoundrycontainerregistryconfigurationlocation) | string | Location for the AI Foundry Container Registry resource. |
| [`name`](#parameter-aifoundrycontainerregistryconfigurationname) | string | The name of the AI Foundry Container Registry resource. |
| [`sku`](#parameter-aifoundrycontainerregistryconfigurationsku) | string | The SKU for the AI Foundry Container Registry resource. |

### Parameter: `aiFoundryContainerRegistryConfiguration.location`

Location for the AI Foundry Container Registry resource.

- Required: No
- Type: string

### Parameter: `aiFoundryContainerRegistryConfiguration.name`

The name of the AI Foundry Container Registry resource.

- Required: No
- Type: string

### Parameter: `aiFoundryContainerRegistryConfiguration.sku`

The SKU for the AI Foundry Container Registry resource.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Basic'
    'Premium'
    'Standard'
  ]
  ```

### Parameter: `aiFoundrySearchServiceConfiguration`

The configuration to apply for the Conversation Knowledge Mining AI Foundry Search Services resource.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      location: '[parameters(\'solutionLocation\')]'
      name: '[format(\'{0}-aifd-srch\', parameters(\'solutionPrefix\'))]'
      sku: 'basic'
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`location`](#parameter-aifoundrysearchserviceconfigurationlocation) | string | Location for the AI Foundry Search Services resource. |
| [`name`](#parameter-aifoundrysearchserviceconfigurationname) | string | The name of the AI Foundry Search Services resource. |
| [`sku`](#parameter-aifoundrysearchserviceconfigurationsku) | string | The SKU for the AI Foundry Search Services resource. |

### Parameter: `aiFoundrySearchServiceConfiguration.location`

Location for the AI Foundry Search Services resource.

- Required: No
- Type: string

### Parameter: `aiFoundrySearchServiceConfiguration.name`

The name of the AI Foundry Search Services resource.

- Required: No
- Type: string

### Parameter: `aiFoundrySearchServiceConfiguration.sku`

The SKU for the AI Foundry Search Services resource.

- Required: No
- Type: string
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

### Parameter: `aiFoundryStorageAccountConfiguration`

The configuration to apply for the Conversation Knowledge Mining AI Foundry Storage Account resource.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      location: '[parameters(\'solutionLocation\')]'
      name: '[replace(format(\'{0}-aifd-strg\', parameters(\'solutionPrefix\')), \'-\', \'\')]'
      sku: 'Standard_LRS'
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`location`](#parameter-aifoundrystorageaccountconfigurationlocation) | string | Location for the Storage Account resource. |
| [`name`](#parameter-aifoundrystorageaccountconfigurationname) | string | The name of the Storage Account resource. |
| [`sku`](#parameter-aifoundrystorageaccountconfigurationsku) | string | The SKU for the Storage Account resource. |

### Parameter: `aiFoundryStorageAccountConfiguration.location`

Location for the Storage Account resource.

- Required: No
- Type: string

### Parameter: `aiFoundryStorageAccountConfiguration.name`

The name of the Storage Account resource.

- Required: No
- Type: string

### Parameter: `aiFoundryStorageAccountConfiguration.sku`

The SKU for the Storage Account resource.

- Required: No
- Type: string
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

### Parameter: `cosmosDbAccountConfiguration`

The configuration to apply for the Conversation Knowledge Mining Cosmos DB Account resource.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      location: '[parameters(\'databasesLocation\')]'
      name: '[format(\'{0}-cmdb\', parameters(\'solutionPrefix\'))]'
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`location`](#parameter-cosmosdbaccountconfigurationlocation) | string | Location for the Cosmos DB Account resource. |
| [`name`](#parameter-cosmosdbaccountconfigurationname) | string | The name of the Cosmos DB Account resource. |

### Parameter: `cosmosDbAccountConfiguration.location`

Location for the Cosmos DB Account resource.

- Required: No
- Type: string

### Parameter: `cosmosDbAccountConfiguration.name`

The name of the Cosmos DB Account resource.

- Required: No
- Type: string

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

### Parameter: `functionChartsConfiguration`

The configuration to apply for the Conversation Knowledge Mining Charts Function resource.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      appScaleLimit: 10
      cpu: 1
      dockerImageContainerRegistryUrl: 'kmcontainerreg.azurecr.io'
      dockerImageName: 'km-charts-function'
      dockerImageTag: 'latest_2025-03-20_276'
      functionName: 'get_metrics'
      location: '[parameters(\'solutionLocation\')]'
      memory: '2Gi'
      name: '[format(\'{0}-azfn-fchr\', parameters(\'solutionPrefix\'))]'
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appScaleLimit`](#parameter-functionchartsconfigurationappscalelimit) | int | The maximum number of workers that the function can scale out. |
| [`cpu`](#parameter-functionchartsconfigurationcpu) | int | The required CPU in cores of the function. |
| [`dockerImageContainerRegistryUrl`](#parameter-functionchartsconfigurationdockerimagecontainerregistryurl) | string | The url of the Container Registry where the docker image for the function is located. |
| [`dockerImageName`](#parameter-functionchartsconfigurationdockerimagename) | string | The name of the docker image for the function. |
| [`dockerImageTag`](#parameter-functionchartsconfigurationdockerimagetag) | string | The tag of the docker image for the function. |
| [`functionName`](#parameter-functionchartsconfigurationfunctionname) | string | The name of the function to be used to get the metrics in the function. |
| [`location`](#parameter-functionchartsconfigurationlocation) | string | Location for the Function resource. |
| [`memory`](#parameter-functionchartsconfigurationmemory) | string | The required memory in GiB of the function. |
| [`name`](#parameter-functionchartsconfigurationname) | string | The name of the Function resource. |

### Parameter: `functionChartsConfiguration.appScaleLimit`

The maximum number of workers that the function can scale out.

- Required: No
- Type: int

### Parameter: `functionChartsConfiguration.cpu`

The required CPU in cores of the function.

- Required: No
- Type: int

### Parameter: `functionChartsConfiguration.dockerImageContainerRegistryUrl`

The url of the Container Registry where the docker image for the function is located.

- Required: No
- Type: string

### Parameter: `functionChartsConfiguration.dockerImageName`

The name of the docker image for the function.

- Required: No
- Type: string

### Parameter: `functionChartsConfiguration.dockerImageTag`

The tag of the docker image for the function.

- Required: No
- Type: string

### Parameter: `functionChartsConfiguration.functionName`

The name of the function to be used to get the metrics in the function.

- Required: No
- Type: string

### Parameter: `functionChartsConfiguration.location`

Location for the Function resource.

- Required: No
- Type: string

### Parameter: `functionChartsConfiguration.memory`

The required memory in GiB of the function.

- Required: No
- Type: string

### Parameter: `functionChartsConfiguration.name`

The name of the Function resource.

- Required: No
- Type: string

### Parameter: `functionRagConfiguration`

The configuration to apply for the Conversation Knowledge Mining Rag Function resource.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      appScaleLimit: 10
      cpu: 1
      dockerImageContainerRegistryUrl: 'kmcontainerreg.azurecr.io'
      dockerImageName: 'km-rag-function'
      dockerImageTag: 'latest_2025-03-20_276'
      functionName: 'stream_openai_text'
      location: '[parameters(\'solutionLocation\')]'
      memory: '2Gi'
      name: '[format(\'{0}-azfn-frag\', parameters(\'solutionPrefix\'))]'
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appScaleLimit`](#parameter-functionragconfigurationappscalelimit) | int | The maximum number of workers that the function can scale out. |
| [`cpu`](#parameter-functionragconfigurationcpu) | int | The required CPU in cores of the function. |
| [`dockerImageContainerRegistryUrl`](#parameter-functionragconfigurationdockerimagecontainerregistryurl) | string | The url of the Container Registry where the docker image for the function is located. |
| [`dockerImageName`](#parameter-functionragconfigurationdockerimagename) | string | The name of the docker image for the function. |
| [`dockerImageTag`](#parameter-functionragconfigurationdockerimagetag) | string | The tag of the docker image for the function. |
| [`functionName`](#parameter-functionragconfigurationfunctionname) | string | The name of the function to be used to get the metrics in the function. |
| [`location`](#parameter-functionragconfigurationlocation) | string | Location for the Function resource. |
| [`memory`](#parameter-functionragconfigurationmemory) | string | The required memory in GiB of the function. |
| [`name`](#parameter-functionragconfigurationname) | string | The name of the Function resource. |

### Parameter: `functionRagConfiguration.appScaleLimit`

The maximum number of workers that the function can scale out.

- Required: No
- Type: int

### Parameter: `functionRagConfiguration.cpu`

The required CPU in cores of the function.

- Required: No
- Type: int

### Parameter: `functionRagConfiguration.dockerImageContainerRegistryUrl`

The url of the Container Registry where the docker image for the function is located.

- Required: No
- Type: string

### Parameter: `functionRagConfiguration.dockerImageName`

The name of the docker image for the function.

- Required: No
- Type: string

### Parameter: `functionRagConfiguration.dockerImageTag`

The tag of the docker image for the function.

- Required: No
- Type: string

### Parameter: `functionRagConfiguration.functionName`

The name of the function to be used to get the metrics in the function.

- Required: No
- Type: string

### Parameter: `functionRagConfiguration.location`

Location for the Function resource.

- Required: No
- Type: string

### Parameter: `functionRagConfiguration.memory`

The required memory in GiB of the function.

- Required: No
- Type: string

### Parameter: `functionRagConfiguration.name`

The name of the Function resource.

- Required: No
- Type: string

### Parameter: `functionsManagedEnvironmentConfiguration`

The configuration to apply for the Conversation Knowledge Mining Functions Managed Environment resource.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      location: '[parameters(\'solutionLocation\')]'
      name: '[format(\'{0}-fnme\', parameters(\'solutionPrefix\'))]'
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`location`](#parameter-functionsmanagedenvironmentconfigurationlocation) | string | Location for the Functions Managed Environment resource. |
| [`name`](#parameter-functionsmanagedenvironmentconfigurationname) | string | The name of the Functions Managed Environment resource. |

### Parameter: `functionsManagedEnvironmentConfiguration.location`

Location for the Functions Managed Environment resource.

- Required: No
- Type: string

### Parameter: `functionsManagedEnvironmentConfiguration.name`

The name of the Functions Managed Environment resource.

- Required: No
- Type: string

### Parameter: `keyVaultConfiguration`

The configuration to apply for the Conversation Knowledge Mining Key Vault resource.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      createMode: 'default'
      location: '[parameters(\'solutionLocation\')]'
      name: '[format(\'{0}-keyv\', parameters(\'solutionPrefix\'))]'
      purgeProtectionEnabled: false
      roleAssignments: []
      sku: 'standard'
      softDeleteEnabled: true
      softDeleteRetentionInDays: 7
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`createMode`](#parameter-keyvaultconfigurationcreatemode) | string | The Key Vault create mode. Indicates whether the vault need to be recovered from purge or not. If empty, default will be used. |
| [`location`](#parameter-keyvaultconfigurationlocation) | string | Location for the Key Vault resource. |
| [`name`](#parameter-keyvaultconfigurationname) | string | The name of the Key Vault resource. |
| [`purgeProtectionEnabled`](#parameter-keyvaultconfigurationpurgeprotectionenabled) | bool | If set to true, The Key Vault purge protection will be enabled. If empty, it will be set to false. |
| [`roleAssignments`](#parameter-keyvaultconfigurationroleassignments) | array | Array of role assignments to include in the Key Vault. |
| [`sku`](#parameter-keyvaultconfigurationsku) | string | The SKU for the Key Vault resource. |
| [`softDeleteEnabled`](#parameter-keyvaultconfigurationsoftdeleteenabled) | bool | If set to true, The Key Vault soft delete will be enabled. |
| [`softDeleteRetentionInDays`](#parameter-keyvaultconfigurationsoftdeleteretentionindays) | int | The number of days to retain the soft deleted vault. If empty, it will be set to 7. |

### Parameter: `keyVaultConfiguration.createMode`

The Key Vault create mode. Indicates whether the vault need to be recovered from purge or not. If empty, default will be used.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'default'
    'recover'
  ]
  ```

### Parameter: `keyVaultConfiguration.location`

Location for the Key Vault resource.

- Required: No
- Type: string

### Parameter: `keyVaultConfiguration.name`

The name of the Key Vault resource.

- Required: No
- Type: string

### Parameter: `keyVaultConfiguration.purgeProtectionEnabled`

If set to true, The Key Vault purge protection will be enabled. If empty, it will be set to false.

- Required: No
- Type: bool

### Parameter: `keyVaultConfiguration.roleAssignments`

Array of role assignments to include in the Key Vault.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-keyvaultconfigurationroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-keyvaultconfigurationroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-keyvaultconfigurationroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-keyvaultconfigurationroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-keyvaultconfigurationroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-keyvaultconfigurationroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-keyvaultconfigurationroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-keyvaultconfigurationroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `keyVaultConfiguration.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `keyVaultConfiguration.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `keyVaultConfiguration.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `keyVaultConfiguration.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `keyVaultConfiguration.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `keyVaultConfiguration.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `keyVaultConfiguration.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `keyVaultConfiguration.roleAssignments.principalType`

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

### Parameter: `keyVaultConfiguration.sku`

The SKU for the Key Vault resource.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'premium'
    'standard'
  ]
  ```

### Parameter: `keyVaultConfiguration.softDeleteEnabled`

If set to true, The Key Vault soft delete will be enabled.

- Required: No
- Type: bool

### Parameter: `keyVaultConfiguration.softDeleteRetentionInDays`

The number of days to retain the soft deleted vault. If empty, it will be set to 7.

- Required: No
- Type: int
- MinValue: 7
- MaxValue: 90

### Parameter: `logAnalyticsWorkspaceConfiguration`

The configuration to apply for the Conversation Knowledge Mining Log Analytics Workspace resource.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      dataRetentionInDays: 30
      location: '[parameters(\'solutionLocation\')]'
      name: '[format(\'{0}-laws\', parameters(\'solutionPrefix\'))]'
      sku: 'PerGB2018'
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataRetentionInDays`](#parameter-loganalyticsworkspaceconfigurationdataretentionindays) | int | The number of days to retain the data in the Log Analytics Workspace. If empty, it will be set to 30 days. |
| [`location`](#parameter-loganalyticsworkspaceconfigurationlocation) | string | Location for the Log Analytics Workspace resource. |
| [`name`](#parameter-loganalyticsworkspaceconfigurationname) | string | The name of the Log Analytics Workspace resource. |
| [`sku`](#parameter-loganalyticsworkspaceconfigurationsku) | string | The SKU for the Log Analytics Workspace resource. |

### Parameter: `logAnalyticsWorkspaceConfiguration.dataRetentionInDays`

The number of days to retain the data in the Log Analytics Workspace. If empty, it will be set to 30 days.

- Required: No
- Type: int
- MaxValue: 730

### Parameter: `logAnalyticsWorkspaceConfiguration.location`

Location for the Log Analytics Workspace resource.

- Required: No
- Type: string

### Parameter: `logAnalyticsWorkspaceConfiguration.name`

The name of the Log Analytics Workspace resource.

- Required: No
- Type: string

### Parameter: `logAnalyticsWorkspaceConfiguration.sku`

The SKU for the Log Analytics Workspace resource.

- Required: No
- Type: string
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

### Parameter: `managedIdentityConfiguration`

The configuration to apply for the Conversation Knowledge Mining Managed Identity resource.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      location: '[parameters(\'solutionLocation\')]'
      name: '[format(\'{0}-mgid\', parameters(\'solutionPrefix\'))]'
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`location`](#parameter-managedidentityconfigurationlocation) | string | Location for the Managed Identity resource. |
| [`name`](#parameter-managedidentityconfigurationname) | string | The name of the Managed Identity resource. |

### Parameter: `managedIdentityConfiguration.location`

Location for the Managed Identity resource.

- Required: No
- Type: string

### Parameter: `managedIdentityConfiguration.name`

The name of the Managed Identity resource.

- Required: No
- Type: string

### Parameter: `scriptCopyDataConfiguration`

The configuration to apply for the Conversation Knowledge Mining Copy Data Script resource.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      githubBaseUrl: 'https://raw.githubusercontent.com/microsoft/Conversation-Knowledge-Mining-Solution-Accelerator/7e1f274415e96070fc1f0306651303ce8ea75268/'
      location: '[parameters(\'solutionLocation\')]'
      name: '[format(\'{0}-scrp-cpdt\', parameters(\'solutionPrefix\'))]'
      scriptUrl: 'https://raw.githubusercontent.com/microsoft/Conversation-Knowledge-Mining-Solution-Accelerator/7e1f274415e96070fc1f0306651303ce8ea75268/infra/scripts/copy_kb_files.sh'
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`githubBaseUrl`](#parameter-scriptcopydataconfigurationgithubbaseurl) | string | The base Raw Url of the GitHub repository where the Copy Data Script is located. |
| [`location`](#parameter-scriptcopydataconfigurationlocation) | string | Location for the Script resource. |
| [`name`](#parameter-scriptcopydataconfigurationname) | string | The name of the Script resource. |
| [`scriptUrl`](#parameter-scriptcopydataconfigurationscripturl) | string | The Url where the Copy Data Script is located. |

### Parameter: `scriptCopyDataConfiguration.githubBaseUrl`

The base Raw Url of the GitHub repository where the Copy Data Script is located.

- Required: No
- Type: string

### Parameter: `scriptCopyDataConfiguration.location`

Location for the Script resource.

- Required: No
- Type: string

### Parameter: `scriptCopyDataConfiguration.name`

The name of the Script resource.

- Required: No
- Type: string

### Parameter: `scriptCopyDataConfiguration.scriptUrl`

The Url where the Copy Data Script is located.

- Required: No
- Type: string

### Parameter: `scriptIndexDataConfiguration`

The configuration to apply for the Conversation Knowledge Mining Copy Data Script resource.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      githubBaseUrl: 'https://raw.githubusercontent.com/microsoft/Conversation-Knowledge-Mining-Solution-Accelerator/7e1f274415e96070fc1f0306651303ce8ea75268/'
      location: '[parameters(\'solutionLocation\')]'
      name: '[format(\'{0}-scrp-indt\', parameters(\'solutionPrefix\'))]'
      scriptUrl: 'https://raw.githubusercontent.com/microsoft/Conversation-Knowledge-Mining-Solution-Accelerator/7e1f274415e96070fc1f0306651303ce8ea75268/infra/scripts/run_create_index_scripts.sh'
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`githubBaseUrl`](#parameter-scriptindexdataconfigurationgithubbaseurl) | string | The base Raw Url of the GitHub repository where the Copy Data Script is located. |
| [`location`](#parameter-scriptindexdataconfigurationlocation) | string | Location for the Script resource. |
| [`name`](#parameter-scriptindexdataconfigurationname) | string | The name of the Script resource. |
| [`scriptUrl`](#parameter-scriptindexdataconfigurationscripturl) | string | The Url where the Copy Data Script is located. |

### Parameter: `scriptIndexDataConfiguration.githubBaseUrl`

The base Raw Url of the GitHub repository where the Copy Data Script is located.

- Required: No
- Type: string

### Parameter: `scriptIndexDataConfiguration.location`

Location for the Script resource.

- Required: No
- Type: string

### Parameter: `scriptIndexDataConfiguration.name`

The name of the Script resource.

- Required: No
- Type: string

### Parameter: `scriptIndexDataConfiguration.scriptUrl`

The Url where the Copy Data Script is located.

- Required: No
- Type: string

### Parameter: `solutionLocation`

Location for all the deployed Azure resources except databases. Defaulted to East US.

- Required: No
- Type: string
- Default: `'East US'`

### Parameter: `sqlServerConfiguration`

The configuration to apply for the Conversation Knowledge Mining SQL Server resource.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      administratorLogin: 'sqladmin'
      administratorPassword: 'TestPassword_1234'
      databaseName: '[format(\'{0}-ckmdb\', parameters(\'solutionPrefix\'))]'
      databaseSkuCapacity: 2
      databaseSkuFamily: 'Gen5'
      databaseSkuName: 'GP_Gen5_2'
      databaseSkuTier: 'GeneralPurpose'
      location: '[parameters(\'databasesLocation\')]'
      name: '[format(\'{0}-sqls\', parameters(\'solutionPrefix\'))]'
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`administratorLogin`](#parameter-sqlserverconfigurationadministratorlogin) | securestring | The administrator login credential for the SQL Server. |
| [`administratorPassword`](#parameter-sqlserverconfigurationadministratorpassword) | securestring | The administrator password credential for the SQL Server. |
| [`databaseName`](#parameter-sqlserverconfigurationdatabasename) | string | The name of the SQL Server database. |
| [`databaseSkuCapacity`](#parameter-sqlserverconfigurationdatabaseskucapacity) | int | The SKU capacity of the SQL Server database. If empty, it will be set to 2. Find available options: Database.[Sku property](https://learn.microsoft.com/dotnet/api/microsoft.azure.management.sql.models.database.sku). |
| [`databaseSkuFamily`](#parameter-sqlserverconfigurationdatabaseskufamily) | string | The SKU Family of the SQL Server database. If empty, it will be set to Gen5. Find available options: Database.[Sku property](https://learn.microsoft.com/dotnet/api/microsoft.azure.management.sql.models.database.sku). |
| [`databaseSkuName`](#parameter-sqlserverconfigurationdatabaseskuname) | string | The SKU name of the SQL Server database. If empty, it will be set to GP_Gen5_2. Find available options: Database.[Sku property](https://learn.microsoft.com/dotnet/api/microsoft.azure.management.sql.models.database.sku). |
| [`databaseSkuTier`](#parameter-sqlserverconfigurationdatabaseskutier) | string | The SKU tier of the SQL Server database. If empty, it will be set to GeneralPurpose. Find available options: Database.[Sku property](https://learn.microsoft.com/dotnet/api/microsoft.azure.management.sql.models.database.sku). |
| [`location`](#parameter-sqlserverconfigurationlocation) | string | Location for the SQL Server resource. |
| [`name`](#parameter-sqlserverconfigurationname) | string | The name of the SQL Server resource. |

### Parameter: `sqlServerConfiguration.administratorLogin`

The administrator login credential for the SQL Server.

- Required: No
- Type: securestring

### Parameter: `sqlServerConfiguration.administratorPassword`

The administrator password credential for the SQL Server.

- Required: No
- Type: securestring

### Parameter: `sqlServerConfiguration.databaseName`

The name of the SQL Server database.

- Required: No
- Type: string

### Parameter: `sqlServerConfiguration.databaseSkuCapacity`

The SKU capacity of the SQL Server database. If empty, it will be set to 2. Find available options: Database.[Sku property](https://learn.microsoft.com/dotnet/api/microsoft.azure.management.sql.models.database.sku).

- Required: No
- Type: int

### Parameter: `sqlServerConfiguration.databaseSkuFamily`

The SKU Family of the SQL Server database. If empty, it will be set to Gen5. Find available options: Database.[Sku property](https://learn.microsoft.com/dotnet/api/microsoft.azure.management.sql.models.database.sku).

- Required: No
- Type: string

### Parameter: `sqlServerConfiguration.databaseSkuName`

The SKU name of the SQL Server database. If empty, it will be set to GP_Gen5_2. Find available options: Database.[Sku property](https://learn.microsoft.com/dotnet/api/microsoft.azure.management.sql.models.database.sku).

- Required: No
- Type: string

### Parameter: `sqlServerConfiguration.databaseSkuTier`

The SKU tier of the SQL Server database. If empty, it will be set to GeneralPurpose. Find available options: Database.[Sku property](https://learn.microsoft.com/dotnet/api/microsoft.azure.management.sql.models.database.sku).

- Required: No
- Type: string

### Parameter: `sqlServerConfiguration.location`

Location for the SQL Server resource.

- Required: No
- Type: string

### Parameter: `sqlServerConfiguration.name`

The name of the SQL Server resource.

- Required: No
- Type: string

### Parameter: `storageAccountConfiguration`

The configuration to apply for the Conversation Knowledge Mining Storage Account resource.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      location: '[parameters(\'solutionLocation\')]'
      name: '[replace(format(\'{0}-strg\', parameters(\'solutionPrefix\')), \'-\', \'\')]'
      sku: 'Standard_LRS'
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`location`](#parameter-storageaccountconfigurationlocation) | string | Location for the Storage Account resource. |
| [`name`](#parameter-storageaccountconfigurationname) | string | The name of the Storage Account resource. |
| [`sku`](#parameter-storageaccountconfigurationsku) | string | The SKU for the Storage Account resource. |

### Parameter: `storageAccountConfiguration.location`

Location for the Storage Account resource.

- Required: No
- Type: string

### Parameter: `storageAccountConfiguration.name`

The name of the Storage Account resource.

- Required: No
- Type: string

### Parameter: `storageAccountConfiguration.sku`

The SKU for the Storage Account resource.

- Required: No
- Type: string
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

### Parameter: `webAppServerFarmConfiguration`

The configuration to apply for the Conversation Knowledge Mining Web App Server Farm resource.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      location: '[parameters(\'solutionLocation\')]'
      name: '[format(\'{0}-wsrv\', parameters(\'solutionPrefix\'))]'
      sku: 'B2'
      webAppDockerImageContainerRegistryUrl: 'kmcontainerreg.azurecr.io'
      webAppDockerImageName: 'km-app'
      webAppDockerImageTag: 'latest_2025-03-20_276'
      webAppLocation: '[parameters(\'solutionLocation\')]'
      webAppResourceName: '[format(\'{0}-app\', parameters(\'solutionPrefix\'))]'
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`location`](#parameter-webappserverfarmconfigurationlocation) | string | Location for the Web App Server Farm resource. |
| [`name`](#parameter-webappserverfarmconfigurationname) | string | The name of the Web App Server Farm resource. |
| [`sku`](#parameter-webappserverfarmconfigurationsku) | string | The SKU for the Web App Server Farm resource. |
| [`webAppDockerImageContainerRegistryUrl`](#parameter-webappserverfarmconfigurationwebappdockerimagecontainerregistryurl) | string | The url of the Container Registry where the docker image for Conversation Knowledge Mining webapp is located. |
| [`webAppDockerImageName`](#parameter-webappserverfarmconfigurationwebappdockerimagename) | string | The name of the docker image for the Rag function. |
| [`webAppDockerImageTag`](#parameter-webappserverfarmconfigurationwebappdockerimagetag) | string | The tag of the docker image for the Rag function. |
| [`webAppLocation`](#parameter-webappserverfarmconfigurationwebapplocation) | string | Location for the Web App resource deployment. |
| [`webAppResourceName`](#parameter-webappserverfarmconfigurationwebappresourcename) | string | The name of the Web App resource. |

### Parameter: `webAppServerFarmConfiguration.location`

Location for the Web App Server Farm resource.

- Required: No
- Type: string

### Parameter: `webAppServerFarmConfiguration.name`

The name of the Web App Server Farm resource.

- Required: No
- Type: string

### Parameter: `webAppServerFarmConfiguration.sku`

The SKU for the Web App Server Farm resource.

- Required: No
- Type: string

### Parameter: `webAppServerFarmConfiguration.webAppDockerImageContainerRegistryUrl`

The url of the Container Registry where the docker image for Conversation Knowledge Mining webapp is located.

- Required: No
- Type: string

### Parameter: `webAppServerFarmConfiguration.webAppDockerImageName`

The name of the docker image for the Rag function.

- Required: No
- Type: string

### Parameter: `webAppServerFarmConfiguration.webAppDockerImageTag`

The tag of the docker image for the Rag function.

- Required: No
- Type: string

### Parameter: `webAppServerFarmConfiguration.webAppLocation`

Location for the Web App resource deployment.

- Required: No
- Type: string

### Parameter: `webAppServerFarmConfiguration.webAppResourceName`

The name of the Web App resource.

- Required: No
- Type: string

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
