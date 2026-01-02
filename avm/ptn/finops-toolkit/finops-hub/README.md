# Finops-hub `[FinopsToolkit/FinopsHub]`

This module deploys a Finops hub from the Finops toolkit.

You can reference the module as follows:
```bicep
module finopsHub 'br/public:avm/ptn/finops-toolkit/finops-hub:<version>' = {
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
| `Microsoft.DataFactory/factories` | 2018-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.datafactory_factories.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories)</li></ul> |
| `Microsoft.DataFactory/factories/datasets` | 2018-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.datafactory_factories_datasets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories/datasets)</li></ul> |
| `Microsoft.DataFactory/factories/linkedservices` | 2018-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.datafactory_factories_linkedservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories/linkedservices)</li></ul> |
| `Microsoft.DataFactory/factories/pipelines` | 2018-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.datafactory_factories_pipelines.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories/pipelines)</li></ul> |
| `Microsoft.DataFactory/factories/triggers` | 2018-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.datafactory_factories_triggers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories/triggers)</li></ul> |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_diagnosticsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)</li></ul> |
| `Microsoft.KeyVault/vaults` | 2022-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults)</li></ul> |
| `Microsoft.KeyVault/vaults/accessPolicies` | 2022-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults_accesspolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/accessPolicies)</li></ul> |
| `Microsoft.KeyVault/vaults/keys` | 2022-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults_keys.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/keys)</li></ul> |
| `Microsoft.KeyVault/vaults/secrets` | 2022-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults_secrets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/secrets)</li></ul> |
| `Microsoft.ManagedIdentity/userAssignedIdentities` | 2023-01-31 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.managedidentity_userassignedidentities.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2023-01-31/userAssignedIdentities)</li></ul> |
| `Microsoft.Network/privateEndpoints` | 2023-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints)</li></ul> |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2023-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints_privatednszonegroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints/privateDnsZoneGroups)</li></ul> |
| `Microsoft.Resources/deploymentScripts` | 2023-08-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.resources_deploymentscripts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2023-08-01/deploymentScripts)</li></ul> |
| `Microsoft.Storage/storageAccounts` | 2022-09-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts)</li></ul> |
| `Microsoft.Storage/storageAccounts/blobServices` | 2022-09-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_blobservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices)</li></ul> |
| `Microsoft.Storage/storageAccounts/blobServices/containers` | 2022-09-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_blobservices_containers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices/containers)</li></ul> |
| `Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies` | 2022-09-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_blobservices_containers_immutabilitypolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices/containers/immutabilityPolicies)</li></ul> |
| `Microsoft.Storage/storageAccounts/fileServices` | 2021-09-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_fileservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-09-01/storageAccounts/fileServices)</li></ul> |
| `Microsoft.Storage/storageAccounts/fileServices/shares` | 2023-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_fileservices_shares.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-01-01/storageAccounts/fileServices/shares)</li></ul> |
| `Microsoft.Storage/storageAccounts/localUsers` | 2022-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_localusers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-05-01/storageAccounts/localUsers)</li></ul> |
| `Microsoft.Storage/storageAccounts/managementPolicies` | 2023-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_managementpolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-01-01/storageAccounts/managementPolicies)</li></ul> |
| `Microsoft.Storage/storageAccounts/queueServices` | 2021-09-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_queueservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-09-01/storageAccounts/queueServices)</li></ul> |
| `Microsoft.Storage/storageAccounts/queueServices/queues` | 2021-09-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_queueservices_queues.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-09-01/storageAccounts/queueServices/queues)</li></ul> |
| `Microsoft.Storage/storageAccounts/tableServices` | 2021-09-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_tableservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-09-01/storageAccounts/tableServices)</li></ul> |
| `Microsoft.Storage/storageAccounts/tableServices/tables` | 2021-09-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_tableservices_tables.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-09-01/storageAccounts/tableServices/tables)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/finops-toolkit/finops-hub:<version>`.

- [Using only defaults](#example-1-using-only-defaults)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/defaults]


<details>

<summary>via Bicep module</summary>

```bicep
module finopsHub 'br/public:avm/ptn/finops-toolkit/finops-hub:<version>' = {
  params: {
    // Required parameters
    hubName: 'finops-hub-finmin'
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
    "hubName": {
      "value": "finops-hub-finmin"
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
using 'br/public:avm/ptn/finops-toolkit/finops-hub:<version>'

// Required parameters
param hubName = 'finops-hub-finmin'
// Non-required parameters
param location = '<location>'
```

</details>
<p>

## Parameters

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`configContainer`](#parameter-configcontainer) | string | The name of the container used for configuration settings. |
| [`convertToParquet`](#parameter-converttoparquet) | bool | Indicates whether ingested data should be converted to Parquet. Default: true. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`exportContainer`](#parameter-exportcontainer) | string | The name of the container used for Cost Management exports. |
| [`exportScopes`](#parameter-exportscopes) | array | List of scope IDs to create exports for. |
| [`hubName`](#parameter-hubname) | string | Name of the hub. Used to ensure unique resource names. Default: "finops-hub". |
| [`ingestionContainer`](#parameter-ingestioncontainer) | string | The name of the container used for normalized data ingestion. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`storageSku`](#parameter-storagesku) | string | Storage SKU to use. LRS = Lowest cost, ZRS = High availability. Note Standard SKUs are not available for Data Lake gen2 storage. Allowed: Premium_LRS, Premium_ZRS. Default: Premium_LRS. |
| [`tags`](#parameter-tags) | object | Tags to apply to all resources. We will also add the cm-resource-parent tag for improved cost roll-ups in Cost Management. |
| [`tagsByResource`](#parameter-tagsbyresource) | object | Tags to apply to resources based on their resource type. Resource type specific tags will be merged with tags for all resources. |

### Parameter: `configContainer`

The name of the container used for configuration settings.

- Required: No
- Type: string
- Default: `'config'`

### Parameter: `convertToParquet`

Indicates whether ingested data should be converted to Parquet. Default: true.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `exportContainer`

The name of the container used for Cost Management exports.

- Required: No
- Type: string
- Default: `'exports'`

### Parameter: `exportScopes`

List of scope IDs to create exports for.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `hubName`

Name of the hub. Used to ensure unique resource names. Default: "finops-hub".

- Required: Yes
- Type: string

### Parameter: `ingestionContainer`

The name of the container used for normalized data ingestion.

- Required: No
- Type: string
- Default: `'ingestion'`

### Parameter: `location`

Location for all Resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `storageSku`

Storage SKU to use. LRS = Lowest cost, ZRS = High availability. Note Standard SKUs are not available for Data Lake gen2 storage. Allowed: Premium_LRS, Premium_ZRS. Default: Premium_LRS.

- Required: No
- Type: string
- Default: `'Premium_LRS'`
- Allowed:
  ```Bicep
  [
    'Premium_LRS'
    'Premium_ZRS'
  ]
  ```

### Parameter: `tags`

Tags to apply to all resources. We will also add the cm-resource-parent tag for improved cost roll-ups in Cost Management.

- Required: No
- Type: object

### Parameter: `tagsByResource`

Tags to apply to resources based on their resource type. Resource type specific tags will be merged with tags for all resources.

- Required: No
- Type: object
- Default: `{}`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `dataFactoryName` | string | Name of the Data Factory. |
| `location` | string | The location the resources wer deployed to. |
| `name` | string | The name of the resource group. |
| `resourceGroupName` | string | The resource group the finops hub was deployed into. |
| `storageAccountId` | string | The resource ID of the deployed storage account. |
| `storageAccountName` | string | Name of the storage account created for the hub instance. This must be used when connecting FinOps toolkit Power BI reports to your data. |
| `storageUrlForPowerBi` | string | URL to use when connecting custom Power BI reports to your data. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/key-vault/vault:0.5.1` | Remote reference |
| `br/public:avm/res/resources/deployment-script:0.2.0` | Remote reference |
| `br/public:avm/res/storage/storage-account:0.8.3` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
