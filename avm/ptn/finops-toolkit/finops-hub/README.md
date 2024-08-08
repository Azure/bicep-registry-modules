# Finops-hub `[FinopsToolkit/FinopsHub]`

This module deploys a Finops hub from the Finops toolkit.

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
| `Microsoft.DataFactory/factories` | [2018-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories) |
| `Microsoft.DataFactory/factories/datasets` | [2018-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories/datasets) |
| `Microsoft.DataFactory/factories/linkedservices` | [2018-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories/linkedservices) |
| `Microsoft.DataFactory/factories/pipelines` | [2018-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories/pipelines) |
| `Microsoft.DataFactory/factories/triggers` | [2018-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories/triggers) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.KeyVault/vaults` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults) |
| `Microsoft.KeyVault/vaults/accessPolicies` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/accessPolicies) |
| `Microsoft.KeyVault/vaults/keys` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/keys) |
| `Microsoft.KeyVault/vaults/secrets` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/secrets) |
| `Microsoft.ManagedIdentity/userAssignedIdentities` | [2023-01-31](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2023-01-31/userAssignedIdentities) |
| `Microsoft.Network/privateEndpoints` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.Resources/deploymentScripts` | [2023-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2023-08-01/deploymentScripts) |
| `Microsoft.Storage/storageAccounts` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts) |
| `Microsoft.Storage/storageAccounts/blobServices` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices) |
| `Microsoft.Storage/storageAccounts/blobServices/containers` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices/containers) |
| `Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices/containers/immutabilityPolicies) |
| `Microsoft.Storage/storageAccounts/fileServices` | [2021-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-09-01/storageAccounts/fileServices) |
| `Microsoft.Storage/storageAccounts/fileServices/shares` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-01-01/storageAccounts/fileServices/shares) |
| `Microsoft.Storage/storageAccounts/localUsers` | [2022-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-05-01/storageAccounts/localUsers) |
| `Microsoft.Storage/storageAccounts/managementPolicies` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-01-01/storageAccounts/managementPolicies) |
| `Microsoft.Storage/storageAccounts/queueServices` | [2021-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-09-01/storageAccounts/queueServices) |
| `Microsoft.Storage/storageAccounts/queueServices/queues` | [2021-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-09-01/storageAccounts/queueServices/queues) |
| `Microsoft.Storage/storageAccounts/tableServices` | [2021-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-09-01/storageAccounts/tableServices) |
| `Microsoft.Storage/storageAccounts/tableServices/tables` | [2021-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-09-01/storageAccounts/tableServices/tables) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/finops-toolkit/finops-hub:<version>`.

- [Using only defaults](#example-1-using-only-defaults)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module finopsHub 'br/public:avm/ptn/finops-toolkit/finops-hub:<version>' = {
  name: 'finopsHubDeployment'
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

<summary>via JSON Parameter file</summary>

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

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
