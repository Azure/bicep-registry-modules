# Azd Azure Machine Learning Environment `[Azd/MlAiEnvironment]`

> ⚠️THIS MODULE IS DEPRECATED.⚠️
>
> - It will no longer receive any updates.
> - The module can still be used as is (references to any existing versions will keep working), but it is not recommended for new deployments.
> - It is recommended to migrate to a replacement/alternative version of the module, if available.

DEPRECATED - Create Azure Machine Learning workspaces of type 'Hub' and 'Project' and their required dependencies.

**Note:** This module is not intended for broad, generic use, as it was designed to cater for the requirements of the AZD CLI product. Feature requests and bug fix requests are welcome if they support the development of the AZD CLI but may not be incorporated if they aim to make this module more generic than what it needs to be for its primary use case.

You can reference the module as follows:
```bicep
module mlAiEnvironment 'br/public:avm/ptn/azd/ml-ai-environment:<version>' = {
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
| `Microsoft.Authorization/locks` | 2020-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_locks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks)</li></ul> |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |
| `Microsoft.CognitiveServices/accounts` | 2023-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cognitiveservices_accounts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2023-05-01/accounts)</li></ul> |
| `Microsoft.CognitiveServices/accounts/deployments` | 2023-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cognitiveservices_accounts_deployments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2023-05-01/accounts/deployments)</li></ul> |
| `Microsoft.ContainerRegistry/registries` | 2023-06-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerregistry_registries.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-06-01-preview/registries)</li></ul> |
| `Microsoft.ContainerRegistry/registries/cacheRules` | 2023-06-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerregistry_registries_cacherules.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-06-01-preview/registries/cacheRules)</li></ul> |
| `Microsoft.ContainerRegistry/registries/credentialSets` | 2023-11-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerregistry_registries_credentialsets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-11-01-preview/registries/credentialSets)</li></ul> |
| `Microsoft.ContainerRegistry/registries/replications` | 2023-06-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerregistry_registries_replications.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-06-01-preview/registries/replications)</li></ul> |
| `Microsoft.ContainerRegistry/registries/scopeMaps` | 2023-06-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerregistry_registries_scopemaps.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-06-01-preview/registries/scopeMaps)</li></ul> |
| `Microsoft.ContainerRegistry/registries/webhooks` | 2023-06-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerregistry_registries_webhooks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-06-01-preview/registries/webhooks)</li></ul> |
| `Microsoft.Insights/components` | 2020-02-02 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_components.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2020-02-02/components)</li></ul> |
| `microsoft.insights/components/linkedStorageAccounts` | 2020-03-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_components_linkedstorageaccounts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/microsoft.insights/2020-03-01-preview/components/linkedStorageAccounts)</li></ul> |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_diagnosticsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)</li></ul> |
| `Microsoft.KeyVault/vaults` | 2022-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults)</li></ul> |
| `Microsoft.KeyVault/vaults/accessPolicies` | 2023-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults_accesspolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2023-07-01/vaults/accessPolicies)</li></ul> |
| `Microsoft.KeyVault/vaults/accessPolicies` | 2022-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults_accesspolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/accessPolicies)</li></ul> |
| `Microsoft.KeyVault/vaults/keys` | 2022-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults_keys.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/keys)</li></ul> |
| `Microsoft.KeyVault/vaults/secrets` | 2022-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults_secrets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/secrets)</li></ul> |
| `Microsoft.MachineLearningServices/workspaces` | 2024-04-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.machinelearningservices_workspaces.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.MachineLearningServices/2024-04-01-preview/workspaces)</li></ul> |
| `Microsoft.MachineLearningServices/workspaces/computes` | 2022-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.machinelearningservices_workspaces_computes.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.MachineLearningServices/2022-10-01/workspaces/computes)</li></ul> |
| `Microsoft.MachineLearningServices/workspaces/connections` | 2024-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.machinelearningservices_workspaces_connections.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.MachineLearningServices/2024-04-01/workspaces/connections)</li></ul> |
| `Microsoft.ManagedIdentity/userAssignedIdentities` | 2023-01-31 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.managedidentity_userassignedidentities.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2023-01-31/userAssignedIdentities)</li></ul> |
| `Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials` | 2023-01-31 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.managedidentity_userassignedidentities_federatedidentitycredentials.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2023-01-31/userAssignedIdentities/federatedIdentityCredentials)</li></ul> |
| `Microsoft.Network/privateEndpoints` | 2023-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints)</li></ul> |
| `Microsoft.Network/privateEndpoints` | 2023-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints)</li></ul> |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2023-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints_privatednszonegroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints/privateDnsZoneGroups)</li></ul> |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2023-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints_privatednszonegroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints/privateDnsZoneGroups)</li></ul> |
| `Microsoft.OperationalInsights/workspaces` | 2022-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationalinsights_workspaces.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2022-10-01/workspaces)</li></ul> |
| `Microsoft.OperationalInsights/workspaces/dataExports` | 2020-08-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationalinsights_workspaces_dataexports.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/dataExports)</li></ul> |
| `Microsoft.OperationalInsights/workspaces/dataSources` | 2020-08-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationalinsights_workspaces_datasources.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/dataSources)</li></ul> |
| `Microsoft.OperationalInsights/workspaces/linkedServices` | 2020-08-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationalinsights_workspaces_linkedservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/linkedServices)</li></ul> |
| `Microsoft.OperationalInsights/workspaces/linkedStorageAccounts` | 2020-08-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationalinsights_workspaces_linkedstorageaccounts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/linkedStorageAccounts)</li></ul> |
| `Microsoft.OperationalInsights/workspaces/savedSearches` | 2020-08-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationalinsights_workspaces_savedsearches.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/savedSearches)</li></ul> |
| `Microsoft.OperationalInsights/workspaces/storageInsightConfigs` | 2020-08-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationalinsights_workspaces_storageinsightconfigs.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/storageInsightConfigs)</li></ul> |
| `Microsoft.OperationalInsights/workspaces/tables` | 2022-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationalinsights_workspaces_tables.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2022-10-01/workspaces/tables)</li></ul> |
| `Microsoft.OperationsManagement/solutions` | 2015-11-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationsmanagement_solutions.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationsManagement/2015-11-01-preview/solutions)</li></ul> |
| `Microsoft.Portal/dashboards` | 2020-09-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.portal_dashboards.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Portal/2020-09-01-preview/dashboards)</li></ul> |
| `Microsoft.Search/searchServices` | 2024-03-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.search_searchservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Search/2024-03-01-preview/searchServices)</li></ul> |
| `Microsoft.Search/searchServices/sharedPrivateLinkResources` | 2023-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.search_searchservices_sharedprivatelinkresources.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Search/2023-11-01/searchServices/sharedPrivateLinkResources)</li></ul> |
| `Microsoft.Storage/storageAccounts` | 2022-09-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts)</li></ul> |
| `Microsoft.Storage/storageAccounts/blobServices` | 2022-09-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_blobservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices)</li></ul> |
| `Microsoft.Storage/storageAccounts/blobServices/containers` | 2022-09-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_blobservices_containers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices/containers)</li></ul> |
| `Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies` | 2022-09-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_blobservices_containers_immutabilitypolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices/containers/immutabilityPolicies)</li></ul> |
| `Microsoft.Storage/storageAccounts/fileServices` | 2023-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_fileservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-04-01/storageAccounts/fileServices)</li></ul> |
| `Microsoft.Storage/storageAccounts/fileServices/shares` | 2023-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_fileservices_shares.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-01-01/storageAccounts/fileServices/shares)</li></ul> |
| `Microsoft.Storage/storageAccounts/localUsers` | 2023-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_localusers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-04-01/storageAccounts/localUsers)</li></ul> |
| `Microsoft.Storage/storageAccounts/managementPolicies` | 2023-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_managementpolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-01-01/storageAccounts/managementPolicies)</li></ul> |
| `Microsoft.Storage/storageAccounts/queueServices` | 2023-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_queueservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-04-01/storageAccounts/queueServices)</li></ul> |
| `Microsoft.Storage/storageAccounts/queueServices/queues` | 2023-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_queueservices_queues.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-04-01/storageAccounts/queueServices/queues)</li></ul> |
| `Microsoft.Storage/storageAccounts/tableServices` | 2023-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_tableservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-04-01/storageAccounts/tableServices)</li></ul> |
| `Microsoft.Storage/storageAccounts/tableServices/tables` | 2023-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_tableservices_tables.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-04-01/storageAccounts/tableServices/tables)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/azd/ml-ai-environment:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/defaults]


<details>

<summary>via Bicep module</summary>

```bicep
module mlAiEnvironment 'br/public:avm/ptn/azd/ml-ai-environment:<version>' = {
  params: {
    // Required parameters
    cognitiveServicesName: 'maemincs001'
    hubName: 'maeminhub001'
    keyVaultName: 'maeminkv01'
    openAiConnectionName: 'maeminai001-connection'
    projectName: 'maeminpro001'
    searchConnectionName: 'maeminsearch001-connection'
    storageAccountName: 'maeminsa001'
    userAssignedtName: 'maeminua001'
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
    "cognitiveServicesName": {
      "value": "maemincs001"
    },
    "hubName": {
      "value": "maeminhub001"
    },
    "keyVaultName": {
      "value": "maeminkv01"
    },
    "openAiConnectionName": {
      "value": "maeminai001-connection"
    },
    "projectName": {
      "value": "maeminpro001"
    },
    "searchConnectionName": {
      "value": "maeminsearch001-connection"
    },
    "storageAccountName": {
      "value": "maeminsa001"
    },
    "userAssignedtName": {
      "value": "maeminua001"
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
using 'br/public:avm/ptn/azd/ml-ai-environment:<version>'

// Required parameters
param cognitiveServicesName = 'maemincs001'
param hubName = 'maeminhub001'
param keyVaultName = 'maeminkv01'
param openAiConnectionName = 'maeminai001-connection'
param projectName = 'maeminpro001'
param searchConnectionName = 'maeminsearch001-connection'
param storageAccountName = 'maeminsa001'
param userAssignedtName = 'maeminua001'
// Non-required parameters
param location = '<location>'
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module using large parameters.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/max]


<details>

<summary>via Bicep module</summary>

```bicep
module mlAiEnvironment 'br/public:avm/ptn/azd/ml-ai-environment:<version>' = {
  params: {
    // Required parameters
    cognitiveServicesName: 'maemaxcs001'
    hubName: 'maemaxhub001'
    keyVaultName: 'maemaxkv002'
    openAiConnectionName: 'maemaxai001-connection'
    projectName: 'maemaxpro001'
    searchConnectionName: 'maemaxsearch001-connection'
    storageAccountName: 'maemaxsta001'
    userAssignedtName: 'maemaxua001'
    // Non-required parameters
    applicationInsightsName: 'maemaxappin001'
    cognitiveServicesDeployments: [
      {
        model: {
          format: 'OpenAI'
          name: 'gpt-35-turbo'
          version: '0613'
        }
        name: 'gpt-35-turbo'
        sku: {
          capacity: 20
          name: 'Standard'
        }
      }
    ]
    containerRegistryName: 'maemaxcr001'
    location: '<location>'
    logAnalyticsName: 'maemaxla001'
    searchServiceName: 'maemaxsearch001'
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
    "cognitiveServicesName": {
      "value": "maemaxcs001"
    },
    "hubName": {
      "value": "maemaxhub001"
    },
    "keyVaultName": {
      "value": "maemaxkv002"
    },
    "openAiConnectionName": {
      "value": "maemaxai001-connection"
    },
    "projectName": {
      "value": "maemaxpro001"
    },
    "searchConnectionName": {
      "value": "maemaxsearch001-connection"
    },
    "storageAccountName": {
      "value": "maemaxsta001"
    },
    "userAssignedtName": {
      "value": "maemaxua001"
    },
    // Non-required parameters
    "applicationInsightsName": {
      "value": "maemaxappin001"
    },
    "cognitiveServicesDeployments": {
      "value": [
        {
          "model": {
            "format": "OpenAI",
            "name": "gpt-35-turbo",
            "version": "0613"
          },
          "name": "gpt-35-turbo",
          "sku": {
            "capacity": 20,
            "name": "Standard"
          }
        }
      ]
    },
    "containerRegistryName": {
      "value": "maemaxcr001"
    },
    "location": {
      "value": "<location>"
    },
    "logAnalyticsName": {
      "value": "maemaxla001"
    },
    "searchServiceName": {
      "value": "maemaxsearch001"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/azd/ml-ai-environment:<version>'

// Required parameters
param cognitiveServicesName = 'maemaxcs001'
param hubName = 'maemaxhub001'
param keyVaultName = 'maemaxkv002'
param openAiConnectionName = 'maemaxai001-connection'
param projectName = 'maemaxpro001'
param searchConnectionName = 'maemaxsearch001-connection'
param storageAccountName = 'maemaxsta001'
param userAssignedtName = 'maemaxua001'
// Non-required parameters
param applicationInsightsName = 'maemaxappin001'
param cognitiveServicesDeployments = [
  {
    model: {
      format: 'OpenAI'
      name: 'gpt-35-turbo'
      version: '0613'
    }
    name: 'gpt-35-turbo'
    sku: {
      capacity: 20
      name: 'Standard'
    }
  }
]
param containerRegistryName = 'maemaxcr001'
param location = '<location>'
param logAnalyticsName = 'maemaxla001'
param searchServiceName = 'maemaxsearch001'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`cognitiveServicesName`](#parameter-cognitiveservicesname) | string | The Cognitive Services name. |
| [`hubName`](#parameter-hubname) | string | The AI Studio Hub Resource name. |
| [`keyVaultName`](#parameter-keyvaultname) | string | The Key Vault resource name. |
| [`projectName`](#parameter-projectname) | string | The AI Project resource name. |
| [`storageAccountName`](#parameter-storageaccountname) | string | The Storage Account resource name. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`applicationInsightsName`](#parameter-applicationinsightsname) | string | The Application Insights resource name. |
| [`cognitiveServicesDeployments`](#parameter-cognitiveservicesdeployments) | array | Array of deployments about cognitive service accounts to create. |
| [`containerRegistryName`](#parameter-containerregistryname) | string | The Container Registry resource name. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`logAnalyticsName`](#parameter-loganalyticsname) | string | The Log Analytics resource name. |
| [`openAiConnectionName`](#parameter-openaiconnectionname) | string | The Open AI connection name. |
| [`replicaCount`](#parameter-replicacount) | int | The number of replicas in the search service. If specified, it must be a value between 1 and 12 inclusive for standard SKUs, or between 1 and 3 inclusive for basic SKU. |
| [`searchConnectionName`](#parameter-searchconnectionname) | string | The Azure Search connection name. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`userAssignedtName`](#parameter-userassignedtname) | string | The User Assigned Identity resource name. |

**Condition parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`searchServiceName`](#parameter-searchservicename) | string | The Azure Search resource name. Required if the parameter searchServiceName is not empty. |

### Parameter: `cognitiveServicesName`

The Cognitive Services name.

- Required: Yes
- Type: string

### Parameter: `hubName`

The AI Studio Hub Resource name.

- Required: Yes
- Type: string

### Parameter: `keyVaultName`

The Key Vault resource name.

- Required: Yes
- Type: string

### Parameter: `projectName`

The AI Project resource name.

- Required: Yes
- Type: string

### Parameter: `storageAccountName`

The Storage Account resource name.

- Required: Yes
- Type: string

### Parameter: `applicationInsightsName`

The Application Insights resource name.

- Required: No
- Type: string
- Default: `''`

### Parameter: `cognitiveServicesDeployments`

Array of deployments about cognitive service accounts to create.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `containerRegistryName`

The Container Registry resource name.

- Required: No
- Type: string
- Default: `''`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location for all Resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `logAnalyticsName`

The Log Analytics resource name.

- Required: No
- Type: string
- Default: `''`

### Parameter: `openAiConnectionName`

The Open AI connection name.

- Required: Yes
- Type: string

### Parameter: `replicaCount`

The number of replicas in the search service. If specified, it must be a value between 1 and 12 inclusive for standard SKUs, or between 1 and 3 inclusive for basic SKU.

- Required: No
- Type: int
- Default: `1`
- MinValue: 1
- MaxValue: 12

### Parameter: `searchConnectionName`

The Azure Search connection name.

- Required: Yes
- Type: string

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object
- Example:
  ```Bicep
  {
      "key1": "value1"
      "key2": "value2"
  }
  ```

### Parameter: `userAssignedtName`

The User Assigned Identity resource name.

- Required: Yes
- Type: string

### Parameter: `searchServiceName`

The Azure Search resource name. Required if the parameter searchServiceName is not empty.

- Required: No
- Type: string
- Default: `''`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `applicationInsightsName` | string | The name of the application insights. |
| `containerRegistryEndpoint` | string | The endpoint of the container registry. |
| `containerRegistryName` | string | The name of the container registry. |
| `hubName` | string | The name of the ai studio hub. |
| `hubPrincipalId` | string | The principal ID of the ai studio hub. |
| `keyVaultEndpoint` | string | The endpoint of the key vault. |
| `keyVaultName` | string | The name of the key vault. |
| `logAnalyticsWorkspaceName` | string | The name of the log analytics workspace. |
| `openAiEndpoint` | string | The endpoint of the cognitive services. |
| `openAiName` | string | The name of the cognitive services. |
| `projectName` | string | The name of the ai studio project. |
| `projectPrincipalId` | string | The principal ID of the ai studio project. |
| `resourceGroupName` | string | The name of the resource group the module was deployed to. |
| `searchServiceEndpoint` | string | The endpoint of the search service. |
| `searchServiceName` | string | The name of the search service. |
| `storageAccountName` | string | The name of the storage account. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/ptn/azd/ml-hub-dependencies:0.1.0` | Remote reference |
| `br/public:avm/ptn/azd/ml-project:0.1.1` | Remote reference |
| `br/public:avm/res/machine-learning-services/workspace:0.8.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
