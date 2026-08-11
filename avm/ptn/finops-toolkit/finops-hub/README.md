# avm/ptn/finops-toolkit/finops-hub `[FinopsToolkit/FinopsHub]`

This module deploys a FinOps hub from the FinOps Toolkit.

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
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |
| `Microsoft.DataFactory/factories` | 2018-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.datafactory_factories.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories)</li></ul> |
| `Microsoft.DataFactory/factories/datasets` | 2018-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.datafactory_factories_datasets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories/datasets)</li></ul> |
| `Microsoft.DataFactory/factories/integrationRuntimes` | 2018-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.datafactory_factories_integrationruntimes.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories/integrationRuntimes)</li></ul> |
| `Microsoft.DataFactory/factories/linkedservices` | 2018-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.datafactory_factories_linkedservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories/linkedservices)</li></ul> |
| `Microsoft.DataFactory/factories/managedVirtualNetworks` | 2018-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.datafactory_factories_managedvirtualnetworks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories/managedVirtualNetworks)</li></ul> |
| `Microsoft.DataFactory/factories/managedVirtualNetworks/managedPrivateEndpoints` | 2018-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.datafactory_factories_managedvirtualnetworks_managedprivateendpoints.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories/managedVirtualNetworks/managedPrivateEndpoints)</li></ul> |
| `Microsoft.DataFactory/factories/pipelines` | 2018-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.datafactory_factories_pipelines.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories/pipelines)</li></ul> |
| `Microsoft.DataFactory/factories/triggers` | 2018-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.datafactory_factories_triggers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories/triggers)</li></ul> |
| `Microsoft.KeyVault/vaults` | 2023-02-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2023-02-01/vaults)</li></ul> |
| `Microsoft.KeyVault/vaults/privateEndpointConnections` | 2023-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults_privateendpointconnections.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2023-07-01/vaults/privateEndpointConnections)</li></ul> |
| `Microsoft.KeyVault/vaults/secrets` | 2023-02-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults_secrets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2023-02-01/vaults/secrets)</li></ul> |
| `Microsoft.Kusto/clusters` | 2023-08-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.kusto_clusters.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Kusto/2023-08-15/clusters)</li></ul> |
| `Microsoft.Kusto/clusters/databases` | 2023-08-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.kusto_clusters_databases.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Kusto/2023-08-15/clusters/databases)</li></ul> |
| `Microsoft.Kusto/clusters/databases/scripts` | 2023-08-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.kusto_clusters_databases_scripts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Kusto/2023-08-15/clusters/databases/scripts)</li></ul> |
| `Microsoft.Kusto/clusters/principalAssignments` | 2023-08-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.kusto_clusters_principalassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Kusto/2023-08-15/clusters/principalAssignments)</li></ul> |
| `Microsoft.Kusto/clusters/privateEndpointConnections` | 2023-08-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.kusto_clusters_privateendpointconnections.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Kusto/2023-08-15/clusters/privateEndpointConnections)</li></ul> |
| `Microsoft.ManagedIdentity/userAssignedIdentities` | 2023-01-31 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.managedidentity_userassignedidentities.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2023-01-31/userAssignedIdentities)</li></ul> |
| `Microsoft.Network/networkSecurityGroups` | 2023-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_networksecuritygroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/networkSecurityGroups)</li></ul> |
| `Microsoft.Network/privateDnsZones` | 2024-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privatednszones.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-06-01/privateDnsZones)</li></ul> |
| `Microsoft.Network/privateDnsZones/virtualNetworkLinks` | 2024-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privatednszones_virtualnetworklinks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-06-01/privateDnsZones/virtualNetworkLinks)</li></ul> |
| `Microsoft.Network/privateEndpoints` | 2023-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints)</li></ul> |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2023-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints_privatednszonegroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints/privateDnsZoneGroups)</li></ul> |
| `Microsoft.Network/virtualNetworks` | 2023-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_virtualnetworks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/virtualNetworks)</li></ul> |
| `Microsoft.Resources/deploymentScripts` | 2023-08-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.resources_deploymentscripts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2023-08-01/deploymentScripts)</li></ul> |
| `Microsoft.Storage/storageAccounts` | 2022-09-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts)</li></ul> |
| `Microsoft.Storage/storageAccounts/blobServices` | 2022-09-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_blobservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices)</li></ul> |
| `Microsoft.Storage/storageAccounts/blobServices/containers` | 2022-09-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_blobservices_containers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices/containers)</li></ul> |
| `Microsoft.Storage/storageAccounts/privateEndpointConnections` | 2023-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_privateendpointconnections.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-04-01/storageAccounts/privateEndpointConnections)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/finops-toolkit/finops-hub:<version>`.

- [Using Azure Data Explorer](#example-1-using-azure-data-explorer)
- [Using only defaults](#example-2-using-only-defaults)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using Azure Data Explorer_

This instance deploys the module with an Azure Data Explorer cluster and databases.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/data-explorer]


<details>

<summary>via Bicep module</summary>

```bicep
module finopsHub 'br/public:avm/ptn/finops-toolkit/finops-hub:<version>' = {
  params: {
    dataExplorerName: '<dataExplorerName>'
    enableManagedExports: false
    hubName: 'finops-hub-finadx'
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
    "dataExplorerName": {
      "value": "<dataExplorerName>"
    },
    "enableManagedExports": {
      "value": false
    },
    "hubName": {
      "value": "finops-hub-finadx"
    },
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

param dataExplorerName = '<dataExplorerName>'
param enableManagedExports = false
param hubName = 'finops-hub-finadx'
param location = '<location>'
```

</details>
<p>

### Example 2: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/defaults]


<details>

<summary>via Bicep module</summary>

```bicep
module finopsHub 'br/public:avm/ptn/finops-toolkit/finops-hub:<version>' = {
  params: {
    hubName: 'finops-hub-finmin'
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
    "hubName": {
      "value": "finops-hub-finmin"
    },
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

param hubName = 'finops-hub-finmin'
param location = '<location>'
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/waf-aligned]


<details>

<summary>via Bicep module</summary>

```bicep
module finopsHub 'br/public:avm/ptn/finops-toolkit/finops-hub:<version>' = {
  params: {
    enableInfrastructureEncryption: true
    enableManagedExports: false
    enablePublicAccess: false
    enablePurgeProtection: true
    hubName: 'finops-hub-ftfhwaf'
    location: '<location>'
    storageSku: 'Premium_ZRS'
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
    "enableInfrastructureEncryption": {
      "value": true
    },
    "enableManagedExports": {
      "value": false
    },
    "enablePublicAccess": {
      "value": false
    },
    "enablePurgeProtection": {
      "value": true
    },
    "hubName": {
      "value": "finops-hub-ftfhwaf"
    },
    "location": {
      "value": "<location>"
    },
    "storageSku": {
      "value": "Premium_ZRS"
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

param enableInfrastructureEncryption = true
param enableManagedExports = false
param enablePublicAccess = false
param enablePurgeProtection = true
param hubName = 'finops-hub-ftfhwaf'
param location = '<location>'
param storageSku = 'Premium_ZRS'
```

</details>
<p>

## Parameters

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataExplorerCapacity`](#parameter-dataexplorercapacity) | int | Number of nodes to use in the cluster. Allowed values: 1 for dev/test SKUs and 2-1000 for standard SKUs. Default: 1 for dev/test SKUs, 2 for standard SKUs. |
| [`dataExplorerFinalRetentionInMonths`](#parameter-dataexplorerfinalretentioninmonths) | int | Number of months of data to retain in the Data Explorer *_final_v* tables. Default: 13. |
| [`dataExplorerName`](#parameter-dataexplorername) | string | Name of the Azure Data Explorer cluster to use for advanced analytics. If empty, Azure Data Explorer will not be deployed. Required to use with Power BI if you have more than $2-5M/mo in costs being monitored. Default: "" (do not use). |
| [`dataExplorerRawRetentionInDays`](#parameter-dataexplorerrawretentionindays) | int | Number of days of data to retain in the Data Explorer *_raw tables. Default: 0. |
| [`dataExplorerSku`](#parameter-dataexplorersku) | string | Name of the Azure Data Explorer SKU. Default: "Dev(No SLA)_Standard_D11_v2". |
| [`enableAHBRecommendations`](#parameter-enableahbrecommendations) | bool | Enable Azure Hybrid Benefit recommendations that flag VMs and SQL VMs without Azure Hybrid Benefit enabled. May generate noise if your organization does not have on-premises licenses. Requires enableRecommendations. Default: false. |
| [`enableInfrastructureEncryption`](#parameter-enableinfrastructureencryption) | bool | Enable infrastructure encryption on the storage account. Default = false. |
| [`enableManagedExports`](#parameter-enablemanagedexports) | bool | Enable managed exports where your FinOps hub instance will create and run Cost Management exports on your behalf. Not supported for Microsoft Customer Agreement (MCA) billing profiles. Requires the ability to grant Role Based Access Control Administrator to FinOps hubs. Default: true. |
| [`enablePublicAccess`](#parameter-enablepublicaccess) | bool | Enable public access to FinOps hubs resources.  Default: true. |
| [`enablePurgeProtection`](#parameter-enablepurgeprotection) | bool | Enable purge protection for the Key Vault. Default: false. |
| [`enableRecommendations`](#parameter-enablerecommendations) | bool | Enable recommendations ingested from Azure Resource Graph based on configurable queries. The Data Factory managed identity requires Reader role on management groups or subscriptions to execute Resource Graph queries. Default: false. |
| [`enableSpotRecommendations`](#parameter-enablespotrecommendations) | bool | Enable non-Spot AKS cluster recommendations that flag AKS clusters with autoscaling but not using Spot VMs. May generate noise since Spot VMs are only appropriate for interruptible workloads. Requires enableRecommendations. Default: false. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`exportRetentionInDays`](#parameter-exportretentionindays) | int | Number of days of data to retain in the msexports container. Default: 0. |
| [`exportScopes`](#parameter-exportscopes) | array | Deprecated. List of scope IDs to monitor and ingest cost for. Use scopesToMonitor instead. |
| [`fabricCapacityUnits`](#parameter-fabriccapacityunits) | int | Number of capacity units for the Microsoft Fabric capacity. This is the number in your Fabric SKU (e.g., Trial = 1, F2 = 2, F64 = 64). This is used to manage parallelization in data pipelines. If you change capacity, please redeploy the template. Allowed values: 1 for the Fabric trial and 2-2048 based on the assigned Fabric capacity (e.g., F2-F2048). Default: 2. |
| [`fabricQueryUri`](#parameter-fabricqueryuri) | string | Microsoft Fabric eventhouse query URI. Default: "" (do not use). |
| [`hubName`](#parameter-hubname) | string | Name of the hub. Used to ensure unique resource names. Default: "finops-hub". |
| [`ingestionRetentionInMonths`](#parameter-ingestionretentioninmonths) | int | Number of months of data to retain in the ingestion container. Default: 13. |
| [`location`](#parameter-location) | string | Azure location where all resources should be created. See https://aka.ms/azureregions. Default: Same as deployment. |
| [`remoteHubStorageKey`](#parameter-remotehubstoragekey) | securestring | Storage account key to use when pushing data to a remote hub. |
| [`remoteHubStorageUri`](#parameter-remotehubstorageuri) | string | Storage account to push data to for ingestion into a remote hub. |
| [`scopesToMonitor`](#parameter-scopestomonitor) | array | List of scope IDs to monitor and ingest cost for. |
| [`storageSku`](#parameter-storagesku) | string | Storage SKU to use. LRS = Lowest cost, ZRS = High availability. Note Standard SKUs are not available for Data Lake gen2 storage. Allowed: Premium_LRS, Premium_ZRS. Default: Premium_LRS. |
| [`tags`](#parameter-tags) | object | Tags to apply to all resources. We will also add the cm-resource-parent tag for improved cost roll-ups in Cost Management. |
| [`tagsByResource`](#parameter-tagsbyresource) | object | Tags to apply to resources based on their resource type. Resource type specific tags will be merged with tags for all resources. |
| [`virtualNetworkAddressPrefix`](#parameter-virtualnetworkaddressprefix) | string | Address space for the workload. Minimum /26 subnet size is required for the workload. Default: "10.20.30.0/26". |

### Parameter: `dataExplorerCapacity`

Number of nodes to use in the cluster. Allowed values: 1 for dev/test SKUs and 2-1000 for standard SKUs. Default: 1 for dev/test SKUs, 2 for standard SKUs.

- Required: No
- Type: int
- Default: `[if(startsWith(parameters('dataExplorerSku'), 'Dev(No SLA)_'), 1, 2)]`
- MinValue: 1
- MaxValue: 1000

### Parameter: `dataExplorerFinalRetentionInMonths`

Number of months of data to retain in the Data Explorer *_final_v* tables. Default: 13.

- Required: No
- Type: int
- Default: `13`

### Parameter: `dataExplorerName`

Name of the Azure Data Explorer cluster to use for advanced analytics. If empty, Azure Data Explorer will not be deployed. Required to use with Power BI if you have more than $2-5M/mo in costs being monitored. Default: "" (do not use).

- Required: No
- Type: string
- Default: `''`

### Parameter: `dataExplorerRawRetentionInDays`

Number of days of data to retain in the Data Explorer *_raw tables. Default: 0.

- Required: No
- Type: int
- Default: `0`

### Parameter: `dataExplorerSku`

Name of the Azure Data Explorer SKU. Default: "Dev(No SLA)_Standard_D11_v2".

- Required: No
- Type: string
- Default: `'Dev(No SLA)_Standard_D11_v2'`
- Allowed:
  ```Bicep
  [
    'Dev(No SLA)_Standard_D11_v2'
    'Dev(No SLA)_Standard_E2a_v4'
    'Standard_D11_v2'
    'Standard_D12_v2'
    'Standard_D13_v2'
    'Standard_D14_v2'
    'Standard_D16d_v5'
    'Standard_D32d_v4'
    'Standard_D32d_v5'
    'Standard_DS13_v2+1TB_PS'
    'Standard_DS13_v2+2TB_PS'
    'Standard_DS14_v2+3TB_PS'
    'Standard_DS14_v2+4TB_PS'
    'Standard_E16a_v4'
    'Standard_E16ads_v5'
    'Standard_E16as_v4+3TB_PS'
    'Standard_E16as_v4+4TB_PS'
    'Standard_E16as_v5+3TB_PS'
    'Standard_E16as_v5+4TB_PS'
    'Standard_E16d_v4'
    'Standard_E16d_v5'
    'Standard_E16s_v4+3TB_PS'
    'Standard_E16s_v4+4TB_PS'
    'Standard_E16s_v5+3TB_PS'
    'Standard_E16s_v5+4TB_PS'
    'Standard_E2a_v4'
    'Standard_E2ads_v5'
    'Standard_E2d_v4'
    'Standard_E2d_v5'
    'Standard_E4a_v4'
    'Standard_E4ads_v5'
    'Standard_E4d_v4'
    'Standard_E4d_v5'
    'Standard_E64i_v3'
    'Standard_E80ids_v4'
    'Standard_E8a_v4'
    'Standard_E8ads_v5'
    'Standard_E8as_v4+1TB_PS'
    'Standard_E8as_v4+2TB_PS'
    'Standard_E8as_v5+1TB_PS'
    'Standard_E8as_v5+2TB_PS'
    'Standard_E8d_v4'
    'Standard_E8d_v5'
    'Standard_E8s_v4+1TB_PS'
    'Standard_E8s_v4+2TB_PS'
    'Standard_E8s_v5+1TB_PS'
    'Standard_E8s_v5+2TB_PS'
    'Standard_EC16ads_v5'
    'Standard_EC16as_v5+3TB_PS'
    'Standard_EC16as_v5+4TB_PS'
    'Standard_EC8ads_v5'
    'Standard_EC8as_v5+1TB_PS'
    'Standard_EC8as_v5+2TB_PS'
    'Standard_L16as_v3'
    'Standard_L16s'
    'Standard_L16s_v2'
    'Standard_L16s_v3'
    'Standard_L32as_v3'
    'Standard_L32s_v3'
    'Standard_L4s'
    'Standard_L8as_v3'
    'Standard_L8s'
    'Standard_L8s_v2'
    'Standard_L8s_v3'
  ]
  ```

### Parameter: `enableAHBRecommendations`

Enable Azure Hybrid Benefit recommendations that flag VMs and SQL VMs without Azure Hybrid Benefit enabled. May generate noise if your organization does not have on-premises licenses. Requires enableRecommendations. Default: false.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableInfrastructureEncryption`

Enable infrastructure encryption on the storage account. Default = false.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableManagedExports`

Enable managed exports where your FinOps hub instance will create and run Cost Management exports on your behalf. Not supported for Microsoft Customer Agreement (MCA) billing profiles. Requires the ability to grant Role Based Access Control Administrator to FinOps hubs. Default: true.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enablePublicAccess`

Enable public access to FinOps hubs resources.  Default: true.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enablePurgeProtection`

Enable purge protection for the Key Vault. Default: false.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableRecommendations`

Enable recommendations ingested from Azure Resource Graph based on configurable queries. The Data Factory managed identity requires Reader role on management groups or subscriptions to execute Resource Graph queries. Default: false.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableSpotRecommendations`

Enable non-Spot AKS cluster recommendations that flag AKS clusters with autoscaling but not using Spot VMs. May generate noise since Spot VMs are only appropriate for interruptible workloads. Requires enableRecommendations. Default: false.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `exportRetentionInDays`

Number of days of data to retain in the msexports container. Default: 0.

- Required: No
- Type: int
- Default: `0`

### Parameter: `exportScopes`

Deprecated. List of scope IDs to monitor and ingest cost for. Use scopesToMonitor instead.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `fabricCapacityUnits`

Number of capacity units for the Microsoft Fabric capacity. This is the number in your Fabric SKU (e.g., Trial = 1, F2 = 2, F64 = 64). This is used to manage parallelization in data pipelines. If you change capacity, please redeploy the template. Allowed values: 1 for the Fabric trial and 2-2048 based on the assigned Fabric capacity (e.g., F2-F2048). Default: 2.

- Required: No
- Type: int
- Default: `2`
- MinValue: 1
- MaxValue: 2048

### Parameter: `fabricQueryUri`

Microsoft Fabric eventhouse query URI. Default: "" (do not use).

- Required: No
- Type: string
- Default: `''`

### Parameter: `hubName`

Name of the hub. Used to ensure unique resource names. Default: "finops-hub".

- Required: No
- Type: string
- Default: `'finops-hub'`

### Parameter: `ingestionRetentionInMonths`

Number of months of data to retain in the ingestion container. Default: 13.

- Required: No
- Type: int
- Default: `13`

### Parameter: `location`

Azure location where all resources should be created. See https://aka.ms/azureregions. Default: Same as deployment.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `remoteHubStorageKey`

Storage account key to use when pushing data to a remote hub.

- Required: No
- Type: securestring
- Default: `''`

### Parameter: `remoteHubStorageUri`

Storage account to push data to for ingestion into a remote hub.

- Required: No
- Type: string
- Default: `''`

### Parameter: `scopesToMonitor`

List of scope IDs to monitor and ingest cost for.

- Required: No
- Type: array
- Default: `[]`

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
- Default: `{}`

### Parameter: `tagsByResource`

Tags to apply to resources based on their resource type. Resource type specific tags will be merged with tags for all resources.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `virtualNetworkAddressPrefix`

Address space for the workload. Minimum /26 subnet size is required for the workload. Default: "10.20.30.0/26".

- Required: No
- Type: string
- Default: `'10.20.30.0/26'`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `clusterId` | string | Resource ID of the Data Explorer cluster. |
| `clusterUri` | string | URI of the Data Explorer cluster. |
| `dataFactoryName` | string | Name of the Data Factory instance. |
| `hubDbName` | string | Name of the Data Explorer database used for querying data. |
| `ingestionDbName` | string | Name of the Data Explorer database used for ingesting data. |
| `location` | string | Azure resource location resources were deployed to. |
| `managedIdentityId` | string | Object ID of the Data Factory managed identity. This will be needed when configuring managed exports. |
| `managedIdentityTenantId` | string | Azure AD tenant ID. This will be needed when configuring managed exports. |
| `name` | string | Name of the resource group. |
| `resourceGroupName` | string | The resource group the FinOps hub was deployed into. |
| `storageAccountId` | string | Resource ID of the deployed storage account. |
| `storageAccountName` | string | Name of the storage account created for the hub instance. This must be used when connecting FinOps toolkit Power BI reports to your data. |
| `storageUrlForPowerBi` | string | URL to use when connecting custom Power BI reports to your data. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
