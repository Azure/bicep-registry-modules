# FinOps Hub `[FinopsToolkit/FinopsHub]`

Deploys a FinOps Hub for cloud cost analytics using Azure Verified Modules.

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
- [Notes](#Notes)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Authorization/locks` | 2020-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_locks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks)</li></ul> |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |
| `Microsoft.DataFactory/factories` | 2018-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.datafactory_factories.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories)</li></ul> |
| `Microsoft.DataFactory/factories/datasets` | 2018-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.datafactory_factories_datasets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories/datasets)</li></ul> |
| `Microsoft.DataFactory/factories/integrationRuntimes` | 2018-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.datafactory_factories_integrationruntimes.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories/integrationRuntimes)</li></ul> |
| `Microsoft.DataFactory/factories/linkedservices` | 2018-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.datafactory_factories_linkedservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories/linkedservices)</li></ul> |
| `Microsoft.DataFactory/factories/managedVirtualNetworks` | 2018-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.datafactory_factories_managedvirtualnetworks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories/managedVirtualNetworks)</li></ul> |
| `Microsoft.DataFactory/factories/managedVirtualNetworks/managedPrivateEndpoints` | 2018-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.datafactory_factories_managedvirtualnetworks_managedprivateendpoints.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories/managedVirtualNetworks/managedPrivateEndpoints)</li></ul> |
| `Microsoft.DataFactory/factories/pipelines` | 2018-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.datafactory_factories_pipelines.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories/pipelines)</li></ul> |
| `Microsoft.DataFactory/factories/triggers` | 2018-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.datafactory_factories_triggers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories/triggers)</li></ul> |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_diagnosticsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)</li></ul> |
| `Microsoft.KeyVault/vaults` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2024-11-01/vaults)</li></ul> |
| `Microsoft.KeyVault/vaults/accessPolicies` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults_accesspolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2024-11-01/vaults/accessPolicies)</li></ul> |
| `Microsoft.KeyVault/vaults/keys` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults_keys.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2024-11-01/vaults/keys)</li></ul> |
| `Microsoft.KeyVault/vaults/secrets` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults_secrets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2024-11-01/vaults/secrets)</li></ul> |
| `Microsoft.Kusto/clusters` | 2024-04-13 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.kusto_clusters.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Kusto/2024-04-13/clusters)</li></ul> |
| `Microsoft.Kusto/clusters/databases` | 2024-04-13 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.kusto_clusters_databases.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Kusto/2024-04-13/clusters/databases)</li></ul> |
| `Microsoft.Kusto/clusters/databases/principalAssignments` | 2024-04-13 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.kusto_clusters_databases_principalassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Kusto/2024-04-13/clusters/databases/principalAssignments)</li></ul> |
| `Microsoft.Kusto/clusters/databases/scripts` | 2023-08-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.kusto_clusters_databases_scripts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Kusto/2023-08-15/clusters/databases/scripts)</li></ul> |
| `Microsoft.Kusto/clusters/principalAssignments` | 2024-04-13 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.kusto_clusters_principalassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Kusto/2024-04-13/clusters/principalAssignments)</li></ul> |
| `Microsoft.Kusto/clusters/privateEndpointConnections` | 2023-08-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.kusto_clusters_privateendpointconnections.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Kusto/2023-08-15/clusters/privateEndpointConnections)</li></ul> |
| `Microsoft.ManagedIdentity/userAssignedIdentities` | 2024-11-30 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.managedidentity_userassignedidentities.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2024-11-30/userAssignedIdentities)</li></ul> |
| `Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials` | 2024-11-30 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.managedidentity_userassignedidentities_federatedidentitycredentials.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2024-11-30/userAssignedIdentities/federatedIdentityCredentials)</li></ul> |
| `Microsoft.Network/networkSecurityGroups` | 2023-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_networksecuritygroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/networkSecurityGroups)</li></ul> |
| `Microsoft.Network/privateDnsZones` | 2020-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privatednszones.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones)</li></ul> |
| `Microsoft.Network/privateDnsZones/A` | 2020-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privatednszones_a.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/A)</li></ul> |
| `Microsoft.Network/privateDnsZones/AAAA` | 2020-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privatednszones_aaaa.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/AAAA)</li></ul> |
| `Microsoft.Network/privateDnsZones/CNAME` | 2020-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privatednszones_cname.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/CNAME)</li></ul> |
| `Microsoft.Network/privateDnsZones/MX` | 2020-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privatednszones_mx.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/MX)</li></ul> |
| `Microsoft.Network/privateDnsZones/PTR` | 2020-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privatednszones_ptr.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/PTR)</li></ul> |
| `Microsoft.Network/privateDnsZones/SOA` | 2020-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privatednszones_soa.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/SOA)</li></ul> |
| `Microsoft.Network/privateDnsZones/SRV` | 2020-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privatednszones_srv.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/SRV)</li></ul> |
| `Microsoft.Network/privateDnsZones/TXT` | 2020-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privatednszones_txt.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/TXT)</li></ul> |
| `Microsoft.Network/privateDnsZones/virtualNetworkLinks` | 2024-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privatednszones_virtualnetworklinks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-06-01/privateDnsZones/virtualNetworkLinks)</li></ul> |
| `Microsoft.Network/privateEndpoints` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/privateEndpoints)</li></ul> |
| `Microsoft.Network/privateEndpoints` | 2024-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-10-01/privateEndpoints)</li></ul> |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints_privatednszonegroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/privateEndpoints/privateDnsZoneGroups)</li></ul> |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2024-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints_privatednszonegroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-10-01/privateEndpoints/privateDnsZoneGroups)</li></ul> |
| `Microsoft.Network/virtualNetworks` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_virtualnetworks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/virtualNetworks)</li></ul> |
| `Microsoft.Network/virtualNetworks/subnets` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_virtualnetworks_subnets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/virtualNetworks/subnets)</li></ul> |
| `Microsoft.Network/virtualNetworks/virtualNetworkPeerings` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_virtualnetworks_virtualnetworkpeerings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-01-01/virtualNetworks/virtualNetworkPeerings)</li></ul> |
| `Microsoft.Resources/deploymentScripts` | 2023-08-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.resources_deploymentscripts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2023-08-01/deploymentScripts)</li></ul> |
| `Microsoft.Storage/storageAccounts` | 2023-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-05-01/storageAccounts)</li></ul> |
| `Microsoft.Storage/storageAccounts` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-01-01/storageAccounts)</li></ul> |
| `Microsoft.Storage/storageAccounts/blobServices` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_blobservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-01-01/storageAccounts/blobServices)</li></ul> |
| `Microsoft.Storage/storageAccounts/blobServices/containers` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_blobservices_containers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-01-01/storageAccounts/blobServices/containers)</li></ul> |
| `Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_blobservices_containers_immutabilitypolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-01-01/storageAccounts/blobServices/containers/immutabilityPolicies)</li></ul> |
| `Microsoft.Storage/storageAccounts/fileServices` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_fileservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/fileServices)</li></ul> |
| `Microsoft.Storage/storageAccounts/fileServices/shares` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_fileservices_shares.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-01-01/storageAccounts/fileServices/shares)</li></ul> |
| `Microsoft.Storage/storageAccounts/localUsers` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_localusers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/localUsers)</li></ul> |
| `Microsoft.Storage/storageAccounts/managementPolicies` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_managementpolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/managementPolicies)</li></ul> |
| `Microsoft.Storage/storageAccounts/objectReplicationPolicies` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_objectreplicationpolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-01-01/storageAccounts/objectReplicationPolicies)</li></ul> |
| `Microsoft.Storage/storageAccounts/queueServices` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_queueservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/queueServices)</li></ul> |
| `Microsoft.Storage/storageAccounts/queueServices/queues` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_queueservices_queues.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/queueServices/queues)</li></ul> |
| `Microsoft.Storage/storageAccounts/tableServices` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_tableservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/tableServices)</li></ul> |
| `Microsoft.Storage/storageAccounts/tableServices/tables` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_tableservices_tables.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/tableServices/tables)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/finops-toolkit/finops-hub:<version>`.

- [ADX with Managed Network](#example-1-adx-with-managed-network)
- [Using Azure Data Explorer with minimal configuration](#example-2-using-azure-data-explorer-with-minimal-configuration)
- [ADX WAF-aligned](#example-3-adx-waf-aligned)
- [Using Microsoft Fabric with minimal configuration](#example-4-using-microsoft-fabric-with-minimal-configuration)
- [Fabric WAF-aligned](#example-5-fabric-waf-aligned)
- [Managed Network Isolation](#example-6-managed-network-isolation)
- [Storage Minimal](#example-7-storage-minimal)

### Example 1: _ADX with Managed Network_

This instance deploys the module with Azure Data Explorer and networkIsolationMode=Managed. This is the RECOMMENDED production configuration - ADX with full private networking, all managed by the module.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/adx-managed-network]


<details>

<summary>via Bicep module</summary>

```bicep
module finopsHub 'br/public:avm/ptn/finops-toolkit/finops-hub:<version>' = {
  params: {
    // Required parameters
    hubName: '<hubName>'
    // Non-required parameters
    adxAdminPrincipalIds: []
    dataExplorerClusterName: '<dataExplorerClusterName>'
    deployerPrincipalId: '<deployerPrincipalId>'
    deploymentConfiguration: 'waf-aligned'
    deploymentType: 'adx'
    enableTelemetry: true
    location: '<location>'
    networkIsolationMode: 'Managed'
    tags: {
      CostCenter: 'FinOps'
      Criticality: 'High'
      Environment: 'Production'
      'hidden-title': 'FinOps Hub - ADX Managed Network'
      NetworkMode: 'Managed'
      SecurityControl: 'Ignore'
    }
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
      "value": "<hubName>"
    },
    // Non-required parameters
    "adxAdminPrincipalIds": {
      "value": []
    },
    "dataExplorerClusterName": {
      "value": "<dataExplorerClusterName>"
    },
    "deployerPrincipalId": {
      "value": "<deployerPrincipalId>"
    },
    "deploymentConfiguration": {
      "value": "waf-aligned"
    },
    "deploymentType": {
      "value": "adx"
    },
    "enableTelemetry": {
      "value": true
    },
    "location": {
      "value": "<location>"
    },
    "networkIsolationMode": {
      "value": "Managed"
    },
    "tags": {
      "value": {
        "CostCenter": "FinOps",
        "Criticality": "High",
        "Environment": "Production",
        "hidden-title": "FinOps Hub - ADX Managed Network",
        "NetworkMode": "Managed",
        "SecurityControl": "Ignore"
      }
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
param hubName = '<hubName>'
// Non-required parameters
param adxAdminPrincipalIds = []
param dataExplorerClusterName = '<dataExplorerClusterName>'
param deployerPrincipalId = '<deployerPrincipalId>'
param deploymentConfiguration = 'waf-aligned'
param deploymentType = 'adx'
param enableTelemetry = true
param location = '<location>'
param networkIsolationMode = 'Managed'
param tags = {
  CostCenter: 'FinOps'
  Criticality: 'High'
  Environment: 'Production'
  'hidden-title': 'FinOps Hub - ADX Managed Network'
  NetworkMode: 'Managed'
  SecurityControl: 'Ignore'
}
```

</details>
<p>

### Example 2: _Using Azure Data Explorer with minimal configuration_

This instance deploys the module with Azure Data Explorer in a cost-effective dev/test configuration.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/adx-minimal]


<details>

<summary>via Bicep module</summary>

```bicep
module finopsHub 'br/public:avm/ptn/finops-toolkit/finops-hub:<version>' = {
  params: {
    // Required parameters
    hubName: '<hubName>'
    // Non-required parameters
    adxAdminPrincipalIds: []
    dataExplorerCapacity: 1
    dataExplorerClusterName: '<dataExplorerClusterName>'
    dataExplorerSku: 'Dev(No SLA)_Standard_E2a_v4'
    deployerPrincipalId: '<deployerPrincipalId>'
    deploymentConfiguration: 'minimal'
    deploymentType: 'adx'
    enableTelemetry: true
    location: '<location>'
    tags: {
      Environment: 'Development'
      'hidden-title': 'FinOps Hub - ADX Minimal'
      SecurityControl: 'Ignore'
    }
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
      "value": "<hubName>"
    },
    // Non-required parameters
    "adxAdminPrincipalIds": {
      "value": []
    },
    "dataExplorerCapacity": {
      "value": 1
    },
    "dataExplorerClusterName": {
      "value": "<dataExplorerClusterName>"
    },
    "dataExplorerSku": {
      "value": "Dev(No SLA)_Standard_E2a_v4"
    },
    "deployerPrincipalId": {
      "value": "<deployerPrincipalId>"
    },
    "deploymentConfiguration": {
      "value": "minimal"
    },
    "deploymentType": {
      "value": "adx"
    },
    "enableTelemetry": {
      "value": true
    },
    "location": {
      "value": "<location>"
    },
    "tags": {
      "value": {
        "Environment": "Development",
        "hidden-title": "FinOps Hub - ADX Minimal",
        "SecurityControl": "Ignore"
      }
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
param hubName = '<hubName>'
// Non-required parameters
param adxAdminPrincipalIds = []
param dataExplorerCapacity = 1
param dataExplorerClusterName = '<dataExplorerClusterName>'
param dataExplorerSku = 'Dev(No SLA)_Standard_E2a_v4'
param deployerPrincipalId = '<deployerPrincipalId>'
param deploymentConfiguration = 'minimal'
param deploymentType = 'adx'
param enableTelemetry = true
param location = '<location>'
param tags = {
  Environment: 'Development'
  'hidden-title': 'FinOps Hub - ADX Minimal'
  SecurityControl: 'Ignore'
}
```

</details>
<p>

### Example 3: _ADX WAF-aligned_

This instance deploys the module with Azure Data Explorer in alignment with the best-practices of the Azure Well-Architected Framework, including private endpoints.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/adx-waf-aligned]


<details>

<summary>via Bicep module</summary>

```bicep
module finopsHub 'br/public:avm/ptn/finops-toolkit/finops-hub:<version>' = {
  params: {
    // Required parameters
    hubName: '<hubName>'
    // Non-required parameters
    adxAdminPrincipalIds: []
    byoBlobDnsZoneId: '<byoBlobDnsZoneId>'
    byoDataFactoryDnsZoneId: '<byoDataFactoryDnsZoneId>'
    byoDfsDnsZoneId: '<byoDfsDnsZoneId>'
    byoSubnetResourceId: '<byoSubnetResourceId>'
    byoVaultDnsZoneId: '<byoVaultDnsZoneId>'
    dataExplorerClusterName: '<dataExplorerClusterName>'
    deployerPrincipalId: '<deployerPrincipalId>'
    deploymentConfiguration: 'waf-aligned'
    deploymentType: 'adx'
    enablePrivateDnsZoneGroups: true
    enableTelemetry: true
    location: '<location>'
    networkIsolationMode: 'BringYourOwn'
    tags: {
      CostCenter: 'FinOps'
      Criticality: 'High'
      Environment: 'Production'
      'hidden-title': 'FinOps Hub - ADX WAF Aligned'
      SecurityControl: 'Ignore'
    }
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
      "value": "<hubName>"
    },
    // Non-required parameters
    "adxAdminPrincipalIds": {
      "value": []
    },
    "byoBlobDnsZoneId": {
      "value": "<byoBlobDnsZoneId>"
    },
    "byoDataFactoryDnsZoneId": {
      "value": "<byoDataFactoryDnsZoneId>"
    },
    "byoDfsDnsZoneId": {
      "value": "<byoDfsDnsZoneId>"
    },
    "byoSubnetResourceId": {
      "value": "<byoSubnetResourceId>"
    },
    "byoVaultDnsZoneId": {
      "value": "<byoVaultDnsZoneId>"
    },
    "dataExplorerClusterName": {
      "value": "<dataExplorerClusterName>"
    },
    "deployerPrincipalId": {
      "value": "<deployerPrincipalId>"
    },
    "deploymentConfiguration": {
      "value": "waf-aligned"
    },
    "deploymentType": {
      "value": "adx"
    },
    "enablePrivateDnsZoneGroups": {
      "value": true
    },
    "enableTelemetry": {
      "value": true
    },
    "location": {
      "value": "<location>"
    },
    "networkIsolationMode": {
      "value": "BringYourOwn"
    },
    "tags": {
      "value": {
        "CostCenter": "FinOps",
        "Criticality": "High",
        "Environment": "Production",
        "hidden-title": "FinOps Hub - ADX WAF Aligned",
        "SecurityControl": "Ignore"
      }
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
param hubName = '<hubName>'
// Non-required parameters
param adxAdminPrincipalIds = []
param byoBlobDnsZoneId = '<byoBlobDnsZoneId>'
param byoDataFactoryDnsZoneId = '<byoDataFactoryDnsZoneId>'
param byoDfsDnsZoneId = '<byoDfsDnsZoneId>'
param byoSubnetResourceId = '<byoSubnetResourceId>'
param byoVaultDnsZoneId = '<byoVaultDnsZoneId>'
param dataExplorerClusterName = '<dataExplorerClusterName>'
param deployerPrincipalId = '<deployerPrincipalId>'
param deploymentConfiguration = 'waf-aligned'
param deploymentType = 'adx'
param enablePrivateDnsZoneGroups = true
param enableTelemetry = true
param location = '<location>'
param networkIsolationMode = 'BringYourOwn'
param tags = {
  CostCenter: 'FinOps'
  Criticality: 'High'
  Environment: 'Production'
  'hidden-title': 'FinOps Hub - ADX WAF Aligned'
  SecurityControl: 'Ignore'
}
```

</details>
<p>

### Example 4: _Using Microsoft Fabric with minimal configuration_

This instance deploys the module with Microsoft Fabric Eventhouse in a cost-effective dev/test configuration.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/fabric-minimal]


<details>

<summary>via Bicep module</summary>

```bicep
module finopsHub 'br/public:avm/ptn/finops-toolkit/finops-hub:<version>' = {
  params: {
    // Required parameters
    hubName: '<hubName>'
    // Non-required parameters
    deploymentConfiguration: 'minimal'
    deploymentType: 'fabric'
    enableTelemetry: true
    fabricDatabaseName: 'finops'
    fabricIngestionUri: '<fabricIngestionUri>'
    fabricQueryUri: '<fabricQueryUri>'
    location: '<location>'
    tags: {
      Environment: 'Development'
      'hidden-title': 'FinOps Hub - Fabric Minimal'
      SecurityControl: 'Ignore'
    }
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
      "value": "<hubName>"
    },
    // Non-required parameters
    "deploymentConfiguration": {
      "value": "minimal"
    },
    "deploymentType": {
      "value": "fabric"
    },
    "enableTelemetry": {
      "value": true
    },
    "fabricDatabaseName": {
      "value": "finops"
    },
    "fabricIngestionUri": {
      "value": "<fabricIngestionUri>"
    },
    "fabricQueryUri": {
      "value": "<fabricQueryUri>"
    },
    "location": {
      "value": "<location>"
    },
    "tags": {
      "value": {
        "Environment": "Development",
        "hidden-title": "FinOps Hub - Fabric Minimal",
        "SecurityControl": "Ignore"
      }
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
param hubName = '<hubName>'
// Non-required parameters
param deploymentConfiguration = 'minimal'
param deploymentType = 'fabric'
param enableTelemetry = true
param fabricDatabaseName = 'finops'
param fabricIngestionUri = '<fabricIngestionUri>'
param fabricQueryUri = '<fabricQueryUri>'
param location = '<location>'
param tags = {
  Environment: 'Development'
  'hidden-title': 'FinOps Hub - Fabric Minimal'
  SecurityControl: 'Ignore'
}
```

</details>
<p>

### Example 5: _Fabric WAF-aligned_

This instance deploys the module with Microsoft Fabric Eventhouse in alignment with the best-practices of the Azure Well-Architected Framework, including private endpoints.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/fabric-waf-aligned]


<details>

<summary>via Bicep module</summary>

```bicep
module finopsHub 'br/public:avm/ptn/finops-toolkit/finops-hub:<version>' = {
  params: {
    // Required parameters
    hubName: '<hubName>'
    // Non-required parameters
    dataFactoryPrivateDnsZoneId: '<dataFactoryPrivateDnsZoneId>'
    deploymentConfiguration: 'waf-aligned'
    deploymentType: 'fabric'
    enableTelemetry: true
    fabricDatabaseName: 'finops'
    fabricIngestionUri: '<fabricIngestionUri>'
    fabricQueryUri: '<fabricQueryUri>'
    keyVaultPrivateDnsZoneId: '<keyVaultPrivateDnsZoneId>'
    location: '<location>'
    privateEndpointSubnetId: '<privateEndpointSubnetId>'
    storageBlobPrivateDnsZoneId: '<storageBlobPrivateDnsZoneId>'
    storageDfsPrivateDnsZoneId: '<storageDfsPrivateDnsZoneId>'
    tags: {
      CostCenter: 'FinOps'
      Criticality: 'High'
      Environment: 'Production'
      'hidden-title': 'FinOps Hub - Fabric WAF Aligned'
      SecurityControl: 'Ignore'
    }
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
      "value": "<hubName>"
    },
    // Non-required parameters
    "dataFactoryPrivateDnsZoneId": {
      "value": "<dataFactoryPrivateDnsZoneId>"
    },
    "deploymentConfiguration": {
      "value": "waf-aligned"
    },
    "deploymentType": {
      "value": "fabric"
    },
    "enableTelemetry": {
      "value": true
    },
    "fabricDatabaseName": {
      "value": "finops"
    },
    "fabricIngestionUri": {
      "value": "<fabricIngestionUri>"
    },
    "fabricQueryUri": {
      "value": "<fabricQueryUri>"
    },
    "keyVaultPrivateDnsZoneId": {
      "value": "<keyVaultPrivateDnsZoneId>"
    },
    "location": {
      "value": "<location>"
    },
    "privateEndpointSubnetId": {
      "value": "<privateEndpointSubnetId>"
    },
    "storageBlobPrivateDnsZoneId": {
      "value": "<storageBlobPrivateDnsZoneId>"
    },
    "storageDfsPrivateDnsZoneId": {
      "value": "<storageDfsPrivateDnsZoneId>"
    },
    "tags": {
      "value": {
        "CostCenter": "FinOps",
        "Criticality": "High",
        "Environment": "Production",
        "hidden-title": "FinOps Hub - Fabric WAF Aligned",
        "SecurityControl": "Ignore"
      }
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
param hubName = '<hubName>'
// Non-required parameters
param dataFactoryPrivateDnsZoneId = '<dataFactoryPrivateDnsZoneId>'
param deploymentConfiguration = 'waf-aligned'
param deploymentType = 'fabric'
param enableTelemetry = true
param fabricDatabaseName = 'finops'
param fabricIngestionUri = '<fabricIngestionUri>'
param fabricQueryUri = '<fabricQueryUri>'
param keyVaultPrivateDnsZoneId = '<keyVaultPrivateDnsZoneId>'
param location = '<location>'
param privateEndpointSubnetId = '<privateEndpointSubnetId>'
param storageBlobPrivateDnsZoneId = '<storageBlobPrivateDnsZoneId>'
param storageDfsPrivateDnsZoneId = '<storageDfsPrivateDnsZoneId>'
param tags = {
  CostCenter: 'FinOps'
  Criticality: 'High'
  Environment: 'Production'
  'hidden-title': 'FinOps Hub - Fabric WAF Aligned'
  SecurityControl: 'Ignore'
}
```

</details>
<p>

### Example 6: _Managed Network Isolation_

This instance deploys the module with networkIsolationMode=Managed, which creates a self-contained VNet, private endpoints, and DNS zones. This is the RECOMMENDED approach for production - enables clean upgrades without customization.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/managed-network]


<details>

<summary>via Bicep module</summary>

```bicep
module finopsHub 'br/public:avm/ptn/finops-toolkit/finops-hub:<version>' = {
  params: {
    // Required parameters
    hubName: '<hubName>'
    // Non-required parameters
    deployerPrincipalId: '<deployerPrincipalId>'
    deploymentConfiguration: 'waf-aligned'
    deploymentType: 'storage-only'
    enableTelemetry: true
    location: '<location>'
    networkIsolationMode: 'Managed'
    tags: {
      CostCenter: 'FinOps'
      Criticality: 'High'
      Environment: 'Production'
      'hidden-title': 'FinOps Hub - Managed Network Isolation'
      NetworkMode: 'Managed'
      SecurityControl: 'Ignore'
    }
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
      "value": "<hubName>"
    },
    // Non-required parameters
    "deployerPrincipalId": {
      "value": "<deployerPrincipalId>"
    },
    "deploymentConfiguration": {
      "value": "waf-aligned"
    },
    "deploymentType": {
      "value": "storage-only"
    },
    "enableTelemetry": {
      "value": true
    },
    "location": {
      "value": "<location>"
    },
    "networkIsolationMode": {
      "value": "Managed"
    },
    "tags": {
      "value": {
        "CostCenter": "FinOps",
        "Criticality": "High",
        "Environment": "Production",
        "hidden-title": "FinOps Hub - Managed Network Isolation",
        "NetworkMode": "Managed",
        "SecurityControl": "Ignore"
      }
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
param hubName = '<hubName>'
// Non-required parameters
param deployerPrincipalId = '<deployerPrincipalId>'
param deploymentConfiguration = 'waf-aligned'
param deploymentType = 'storage-only'
param enableTelemetry = true
param location = '<location>'
param networkIsolationMode = 'Managed'
param tags = {
  CostCenter: 'FinOps'
  Criticality: 'High'
  Environment: 'Production'
  'hidden-title': 'FinOps Hub - Managed Network Isolation'
  NetworkMode: 'Managed'
  SecurityControl: 'Ignore'
}
```

</details>
<p>

### Example 7: _Storage Minimal_

This instance deploys the module with the minimum set of required parameters for storage-only mode.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/storage-minimal]


<details>

<summary>via Bicep module</summary>

```bicep
module finopsHub 'br/public:avm/ptn/finops-toolkit/finops-hub:<version>' = {
  params: {
    // Required parameters
    hubName: '<hubName>'
    // Non-required parameters
    deploymentConfiguration: 'minimal'
    deploymentType: 'storage-only'
    enableTelemetry: true
    location: '<location>'
    tags: {
      Environment: 'Development'
      'hidden-title': 'FinOps Hub - Storage Only Test'
      SecurityControl: 'Ignore'
    }
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
      "value": "<hubName>"
    },
    // Non-required parameters
    "deploymentConfiguration": {
      "value": "minimal"
    },
    "deploymentType": {
      "value": "storage-only"
    },
    "enableTelemetry": {
      "value": true
    },
    "location": {
      "value": "<location>"
    },
    "tags": {
      "value": {
        "Environment": "Development",
        "hidden-title": "FinOps Hub - Storage Only Test",
        "SecurityControl": "Ignore"
      }
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
param hubName = '<hubName>'
// Non-required parameters
param deploymentConfiguration = 'minimal'
param deploymentType = 'storage-only'
param enableTelemetry = true
param location = '<location>'
param tags = {
  Environment: 'Development'
  'hidden-title': 'FinOps Hub - Storage Only Test'
  SecurityControl: 'Ignore'
}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`hubName`](#parameter-hubname) | string | Name of the FinOps Hub instance. Used for resource naming. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`byoBlobDnsZoneId`](#parameter-byoblobdnszoneid) | string | Resource ID of the private DNS zone for blob storage (privatelink.blob.core.windows.net). Required if networkIsolationMode is "BringYourOwn" and enablePrivateDnsZoneGroups is true. |
| [`byoDataFactoryDnsZoneId`](#parameter-byodatafactorydnszoneid) | string | Resource ID of the private DNS zone for Data Factory (privatelink.datafactory.azure.net). Required if networkIsolationMode is "BringYourOwn" and enablePrivateDnsZoneGroups is true. |
| [`byoDfsDnsZoneId`](#parameter-byodfsdnszoneid) | string | Resource ID of the private DNS zone for DFS storage (privatelink.dfs.core.windows.net). Required if networkIsolationMode is "BringYourOwn" and enablePrivateDnsZoneGroups is true. |
| [`byoKustoDnsZoneId`](#parameter-byokustodnszoneid) | string | Resource ID of the private DNS zone for Kusto/ADX (privatelink.<region>.kusto.windows.net). Required if networkIsolationMode is "BringYourOwn", deploymentType is "adx", and enablePrivateDnsZoneGroups is true. |
| [`byoSubnetResourceId`](#parameter-byosubnetresourceid) | string | Subnet resource ID for private endpoints. Required if networkIsolationMode is "BringYourOwn". |
| [`byoVaultDnsZoneId`](#parameter-byovaultdnszoneid) | string | Resource ID of the private DNS zone for Key Vault (privatelink.vaultcore.azure.net). Required if networkIsolationMode is "BringYourOwn" and enablePrivateDnsZoneGroups is true. |
| [`dataExplorerClusterName`](#parameter-dataexplorerclustername) | string | Azure Data Explorer cluster name. Required if deploymentType is "adx" and not using existing cluster. |
| [`fabricQueryUri`](#parameter-fabricqueryuri) | string | Microsoft Fabric eventhouse Query URI. Required if deploymentType is "fabric". |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`adxAdminPrincipalIds`](#parameter-adxadminprincipalids) | array | Array of additional ADX admin principal IDs (users or groups) to grant AllDatabasesAdmin role. |
| [`billingAccountId`](#parameter-billingaccountid) | string | Billing account ID for MACC tracking. Requires ADF MI to have Billing Account Reader role. |
| [`billingAccountType`](#parameter-billingaccounttype) | string | Billing type hint: "ea", "mca", "mpa" support exports; "paygo", "csp" use demo mode. See README for export support matrix. |
| [`dataExplorerCapacity`](#parameter-dataexplorercapacity) | int | Number of instances in the Data Explorer cluster. Set to 0 to use configuration default (minimal: 1, waf-aligned: 2). |
| [`dataExplorerSku`](#parameter-dataexplorersku) | string | Azure Data Explorer SKU. Leave empty to use configuration default (minimal: Dev SKU, waf-aligned: Standard SKU). |
| [`dataFactoryPrivateDnsZoneId`](#parameter-datafactoryprivatednszoneid) | string | Note: This is a deprecated property, please use `byoDataFactoryDnsZoneId` instead. |
| [`deployerPrincipalId`](#parameter-deployerprincipalid) | string | Principal ID of the deployer. Grants Storage Blob Data Contributor (for test data upload) and ADX AllDatabasesAdmin (for cluster management and troubleshooting). |
| [`deploymentConfiguration`](#parameter-deploymentconfiguration) | string | Deployment configuration profile. "minimal" for lowest cost dev/test, "waf-aligned" for production with HA/DR. |
| [`deploymentType`](#parameter-deploymenttype) | string | Deployment type: "adx" for Azure Data Explorer, "fabric" for Microsoft Fabric, "storage-only" for basic deployment. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. Applies to Storage Account and Key Vault. |
| [`enableAdfManagedVnet`](#parameter-enableadfmanagedvnet) | bool | Enable Data Factory Managed Virtual Network with Managed Integration Runtime. Required for accessing private endpoints from ADF pipelines. Automatically enabled when networkIsolationMode is "Managed" or "BringYourOwn". See enableManagedPeAutoApproval parameter for PE approval options. |
| [`enableManagedPeAutoApproval`](#parameter-enablemanagedpeautoapproval) | bool | Enable automatic approval of ADF Managed Private Endpoints. When true (Option A), grants ADF control-plane permissions to auto-approve its PE connections to Storage and Key Vault. When false (Option B), PE connections require manual approval via Azure Portal or CLI. Default: true for streamlined deployments. |
| [`enablePrivateDnsZoneGroups`](#parameter-enableprivatednszonegroups) | bool | Create DNS zone groups for private endpoints. Set false when Azure Policy manages DNS records (ESLZ pattern). |
| [`enablePublicAccess`](#parameter-enablepublicaccess) | bool | Enable public network access. Automatically disabled for waf-aligned. |
| [`enablePurgeProtection`](#parameter-enablepurgeprotection) | bool | Enable Key Vault purge protection. Automatically enabled for waf-aligned. |
| [`enableRbacAuthorization`](#parameter-enablerbacauthorization) | bool | Enable RBAC authorization for Key Vault (recommended). |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`enableTriggerManagement`](#parameter-enabletriggermanagement) | bool | Enable automatic trigger start/stop for idempotent redeployments. Requires shared key access on storage. |
| [`existingDataExplorerClusterId`](#parameter-existingdataexplorerclusterid) | string | Resource ID of an existing Azure Data Explorer cluster to use. When provided, no new cluster is created. |
| [`existingManagedIdentityResourceId`](#parameter-existingmanagedidentityresourceid) | string | Resource ID of an existing user-assigned managed identity. When provided, no new identity is created. Use this for strict security policies where identities must be pre-created. |
| [`fabricDatabaseName`](#parameter-fabricdatabasename) | string | Microsoft Fabric database name in the eventhouse. |
| [`fabricIngestionUri`](#parameter-fabricingestionuri) | string | Microsoft Fabric eventhouse ingestion URI. Used for data ingestion pipelines. |
| [`keyVaultPrivateDnsZoneId`](#parameter-keyvaultprivatednszoneid) | string | Note: This is a deprecated property, please use `byoVaultDnsZoneId` instead. |
| [`location`](#parameter-location) | string | Azure region for all resources. Default: resource group location. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedSubnetAddressPrefix`](#parameter-managedsubnetaddressprefix) | string | Address prefix for the private endpoints subnet. Only used when networkIsolationMode is "Managed". Default: 10.0.0.0/26. |
| [`managedVnetAddressPrefix`](#parameter-managedvnetaddressprefix) | string | Address prefix for the managed VNet. Only used when networkIsolationMode is "Managed". Default: 10.0.0.0/24. |
| [`networkIsolationMode`](#parameter-networkisolationmode) | string | Network isolation: "None" (public), "Managed" (module creates VNet/PEs), or "BringYourOwn" (you provide subnet/DNS). |
| [`privateEndpointSubnetId`](#parameter-privateendpointsubnetid) | string | Note: This is a deprecated property, please use `networkIsolationMode="BringYourOwn"` with `byoSubnetResourceId` instead. Resource ID of the subnet for private endpoints. |
| [`scopesToMonitor`](#parameter-scopestomonitor) | array | Billing scopes to monitor. See README for scope types and export support matrix. |
| [`storageBlobPrivateDnsZoneId`](#parameter-storageblobprivatednszoneid) | string | Note: This is a deprecated property, please use `byoBlobDnsZoneId` instead. |
| [`storageDfsPrivateDnsZoneId`](#parameter-storagedfsprivatednszoneid) | string | Note: This is a deprecated property, please use `byoDfsDnsZoneId` instead. |
| [`tags`](#parameter-tags) | object | Tags to apply to all resources. |
| [`tagsByResource`](#parameter-tagsbyresource) | object | Resource-specific tags by resource type. |

### Parameter: `hubName`

Name of the FinOps Hub instance. Used for resource naming.

- Required: Yes
- Type: string

### Parameter: `byoBlobDnsZoneId`

Resource ID of the private DNS zone for blob storage (privatelink.blob.core.windows.net). Required if networkIsolationMode is "BringYourOwn" and enablePrivateDnsZoneGroups is true.

- Required: No
- Type: string
- Default: `''`

### Parameter: `byoDataFactoryDnsZoneId`

Resource ID of the private DNS zone for Data Factory (privatelink.datafactory.azure.net). Required if networkIsolationMode is "BringYourOwn" and enablePrivateDnsZoneGroups is true.

- Required: No
- Type: string
- Default: `''`

### Parameter: `byoDfsDnsZoneId`

Resource ID of the private DNS zone for DFS storage (privatelink.dfs.core.windows.net). Required if networkIsolationMode is "BringYourOwn" and enablePrivateDnsZoneGroups is true.

- Required: No
- Type: string
- Default: `''`

### Parameter: `byoKustoDnsZoneId`

Resource ID of the private DNS zone for Kusto/ADX (privatelink.<region>.kusto.windows.net). Required if networkIsolationMode is "BringYourOwn", deploymentType is "adx", and enablePrivateDnsZoneGroups is true.

- Required: No
- Type: string
- Default: `''`

### Parameter: `byoSubnetResourceId`

Subnet resource ID for private endpoints. Required if networkIsolationMode is "BringYourOwn".

- Required: No
- Type: string
- Default: `''`

### Parameter: `byoVaultDnsZoneId`

Resource ID of the private DNS zone for Key Vault (privatelink.vaultcore.azure.net). Required if networkIsolationMode is "BringYourOwn" and enablePrivateDnsZoneGroups is true.

- Required: No
- Type: string
- Default: `''`

### Parameter: `dataExplorerClusterName`

Azure Data Explorer cluster name. Required if deploymentType is "adx" and not using existing cluster.

- Required: No
- Type: string
- Default: `''`

### Parameter: `fabricQueryUri`

Microsoft Fabric eventhouse Query URI. Required if deploymentType is "fabric".

- Required: No
- Type: string
- Default: `''`

### Parameter: `adxAdminPrincipalIds`

Array of additional ADX admin principal IDs (users or groups) to grant AllDatabasesAdmin role.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `billingAccountId`

Billing account ID for MACC tracking. Requires ADF MI to have Billing Account Reader role.

- Required: No
- Type: string
- Default: `''`

### Parameter: `billingAccountType`

Billing type hint: "ea", "mca", "mpa" support exports; "paygo", "csp" use demo mode. See README for export support matrix.

- Required: No
- Type: string
- Default: `'auto'`
- Allowed:
  ```Bicep
  [
    'auto'
    'csp'
    'ea'
    'mca'
    'mpa'
    'paygo'
  ]
  ```

### Parameter: `dataExplorerCapacity`

Number of instances in the Data Explorer cluster. Set to 0 to use configuration default (minimal: 1, waf-aligned: 2).

- Required: No
- Type: int
- Default: `0`

### Parameter: `dataExplorerSku`

Azure Data Explorer SKU. Leave empty to use configuration default (minimal: Dev SKU, waf-aligned: Standard SKU).

- Required: No
- Type: string
- Default: `''`

### Parameter: `dataFactoryPrivateDnsZoneId`

Note: This is a deprecated property, please use `byoDataFactoryDnsZoneId` instead.

- Required: No
- Type: string
- Default: `''`

### Parameter: `deployerPrincipalId`

Principal ID of the deployer. Grants Storage Blob Data Contributor (for test data upload) and ADX AllDatabasesAdmin (for cluster management and troubleshooting).

- Required: No
- Type: string
- Default: `''`

### Parameter: `deploymentConfiguration`

Deployment configuration profile. "minimal" for lowest cost dev/test, "waf-aligned" for production with HA/DR.

- Required: No
- Type: string
- Default: `'minimal'`
- Allowed:
  ```Bicep
  [
    'minimal'
    'waf-aligned'
  ]
  ```

### Parameter: `deploymentType`

Deployment type: "adx" for Azure Data Explorer, "fabric" for Microsoft Fabric, "storage-only" for basic deployment.

- Required: No
- Type: string
- Default: `'storage-only'`
- Allowed:
  ```Bicep
  [
    'adx'
    'fabric'
    'storage-only'
  ]
  ```

### Parameter: `diagnosticSettings`

The diagnostic settings of the service. Applies to Storage Account and Key Vault.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-diagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-diagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-diagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-diagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-diagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-diagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-diagnosticsettingsname) | string | The name of the diagnostic setting. |
| [`storageAccountResourceId`](#parameter-diagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-diagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logAnalyticsDestinationType`

A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureDiagnostics'
    'Dedicated'
  ]
  ```

### Parameter: `diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-diagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-diagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-diagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-diagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-diagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `diagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `diagnosticSettings.name`

The name of the diagnostic setting.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `enableAdfManagedVnet`

Enable Data Factory Managed Virtual Network with Managed Integration Runtime. Required for accessing private endpoints from ADF pipelines. Automatically enabled when networkIsolationMode is "Managed" or "BringYourOwn". See enableManagedPeAutoApproval parameter for PE approval options.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableManagedPeAutoApproval`

Enable automatic approval of ADF Managed Private Endpoints. When true (Option A), grants ADF control-plane permissions to auto-approve its PE connections to Storage and Key Vault. When false (Option B), PE connections require manual approval via Azure Portal or CLI. Default: true for streamlined deployments.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enablePrivateDnsZoneGroups`

Create DNS zone groups for private endpoints. Set false when Azure Policy manages DNS records (ESLZ pattern).

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enablePublicAccess`

Enable public network access. Automatically disabled for waf-aligned.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enablePurgeProtection`

Enable Key Vault purge protection. Automatically enabled for waf-aligned.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableRbacAuthorization`

Enable RBAC authorization for Key Vault (recommended).

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableTriggerManagement`

Enable automatic trigger start/stop for idempotent redeployments. Requires shared key access on storage.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `existingDataExplorerClusterId`

Resource ID of an existing Azure Data Explorer cluster to use. When provided, no new cluster is created.

- Required: No
- Type: string
- Default: `''`

### Parameter: `existingManagedIdentityResourceId`

Resource ID of an existing user-assigned managed identity. When provided, no new identity is created. Use this for strict security policies where identities must be pre-created.

- Required: No
- Type: string
- Default: `''`

### Parameter: `fabricDatabaseName`

Microsoft Fabric database name in the eventhouse.

- Required: No
- Type: string
- Default: `'finops'`

### Parameter: `fabricIngestionUri`

Microsoft Fabric eventhouse ingestion URI. Used for data ingestion pipelines.

- Required: No
- Type: string
- Default: `''`

### Parameter: `keyVaultPrivateDnsZoneId`

Note: This is a deprecated property, please use `byoVaultDnsZoneId` instead.

- Required: No
- Type: string
- Default: `''`

### Parameter: `location`

Azure region for all resources. Default: resource group location.

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
| [`notes`](#parameter-locknotes) | string | Specify the notes of the lock. |

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

### Parameter: `lock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `managedSubnetAddressPrefix`

Address prefix for the private endpoints subnet. Only used when networkIsolationMode is "Managed". Default: 10.0.0.0/26.

- Required: No
- Type: string
- Default: `'10.0.0.0/26'`

### Parameter: `managedVnetAddressPrefix`

Address prefix for the managed VNet. Only used when networkIsolationMode is "Managed". Default: 10.0.0.0/24.

- Required: No
- Type: string
- Default: `'10.0.0.0/24'`

### Parameter: `networkIsolationMode`

Network isolation: "None" (public), "Managed" (module creates VNet/PEs), or "BringYourOwn" (you provide subnet/DNS).

- Required: No
- Type: string
- Default: `'None'`
- Allowed:
  ```Bicep
  [
    'BringYourOwn'
    'Managed'
    'None'
  ]
  ```

### Parameter: `privateEndpointSubnetId`

Note: This is a deprecated property, please use `networkIsolationMode="BringYourOwn"` with `byoSubnetResourceId` instead. Resource ID of the subnet for private endpoints.

- Required: No
- Type: string
- Default: `''`

### Parameter: `scopesToMonitor`

Billing scopes to monitor. See README for scope types and export support matrix.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `storageBlobPrivateDnsZoneId`

Note: This is a deprecated property, please use `byoBlobDnsZoneId` instead.

- Required: No
- Type: string
- Default: `''`

### Parameter: `storageDfsPrivateDnsZoneId`

Note: This is a deprecated property, please use `byoDfsDnsZoneId` instead.

- Required: No
- Type: string
- Default: `''`

### Parameter: `tags`

Tags to apply to all resources.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `tagsByResource`

Resource-specific tags by resource type.

- Required: No
- Type: object
- Default: `{}`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `adxSchemaComponents` | array | List of schema components deployed to ADX. Empty if schema not deployed. |
| `adxSchemaDeployed` | bool | Indicates whether ADX schema was deployed. |
| `analyticsPlatform` | string | Analytics platform configured (adx, fabric, or none). |
| `billingAccountTypeHint` | string | Billing account type. Use to determine export support. |
| `configuredScopes` | array | Scopes configured for monitoring. |
| `dataExplorerEndpoint` | string | Data Explorer cluster endpoint. For Fabric, returns the Eventhouse query URI. |
| `dataExplorerName` | string | Data Explorer cluster name. Returns existing cluster name if using existing, or new cluster name if created. |
| `dataExplorerResourceId` | string | Data Explorer cluster resource ID. Returns existing cluster ID if using existing. |
| `dataFactoryId` | string | Data Factory resource ID. |
| `dataFactoryName` | string | Data Factory name. |
| `dataFactoryPipelines` | array | List of core Data Factory pipelines (msexports, ingestion). |
| `dataFactoryPrincipalId` | string | Data Factory managed identity principal ID (for configuring managed exports). |
| `dataFactoryTriggers` | array | List of core Data Factory triggers. |
| `deploymentMode` | string | Deployment mode: enterprise, demo, or hybrid. |
| `exportConfiguration` | object | Cost Management export configuration. |
| `exportSupported` | bool | Whether Cost Management exports are supported. |
| `fabricDatabase` | string | Fabric database name. Empty if not using Fabric. |
| `fabricEventhouseIngestionUri` | string | Fabric eventhouse ingestion URI. Empty if not using Fabric. |
| `fabricEventhouseQueryUri` | string | Fabric eventhouse query URI. Empty if not using Fabric. |
| `gettingStartedGuide` | object | Getting started guide based on deployment mode. |
| `hubName` | string | Name of the deployed FinOps Hub. |
| `keyVaultId` | string | Key Vault resource ID. |
| `keyVaultName` | string | Key Vault name. |
| `keyVaultUri` | string | Key Vault URI. |
| `location` | string | Azure region where resources were deployed. |
| `maccEnabled` | bool | Indicates whether MACC (Microsoft Azure Consumption Commitment) tracking is enabled. |
| `managedExportsEnabled` | bool | Indicates whether managed export pipelines are deployed. Only true for EA/MCA/MPA with scopes. |
| `managedExportsPipelines` | array | List of managed export pipelines. Empty if not using managed exports. |
| `managedExportsTriggers` | array | List of managed export triggers. Empty if not using managed exports. |
| `managedIdentityName` | string | User-assigned managed identity name. |
| `managedIdentityPrincipalId` | string | User-assigned managed identity principal ID. |
| `managedIdentityResourceId` | string | User-assigned managed identity resource ID. |
| `networkIsolationMode` | string | Network isolation mode used for this deployment. |
| `privateEndpointSubnetResourceId` | string | Private endpoint subnet resource ID. Empty when networkIsolationMode is "None". |
| `resourceGroupName` | string | Resource group name. |
| `scopeCount` | int | Number of scopes configured for monitoring. |
| `settingsJson` | object | Settings.json content for the config container. |
| `storageAccountId` | string | Storage account resource ID. |
| `storageAccountName` | string | Storage account name. |
| `storageBlobEndpoint` | string | Storage account primary blob endpoint. |
| `storageUrlForPowerBI` | string | URL for Power BI connection to ingestion container. |
| `tenantId` | string | Azure AD tenant ID (for configuring managed exports). |
| `vnetResourceId` | string | VNet resource ID. Only populated when networkIsolationMode is "Managed". |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/ptn/authorization/resource-role-assignment:0.1.2` | Remote reference |
| `br/public:avm/res/data-factory/factory:0.11.0` | Remote reference |
| `br/public:avm/res/key-vault/vault:0.13.3` | Remote reference |
| `br/public:avm/res/kusto/cluster:0.9.0` | Remote reference |
| `br/public:avm/res/managed-identity/user-assigned-identity:0.5.0` | Remote reference |
| `br/public:avm/res/network/network-security-group:0.5.2` | Remote reference |
| `br/public:avm/res/network/private-dns-zone:0.8.0` | Remote reference |
| `br/public:avm/res/network/virtual-network:0.7.2` | Remote reference |
| `br/public:avm/res/storage/storage-account:0.31.0` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.6.1` | Remote reference |

## Notes

> **📚 Full Documentation**: For comprehensive documentation, see [Microsoft Learn - FinOps Hubs](https://learn.microsoft.com/cloud-computing/finops/toolkit/hubs/finops-hubs-overview).

### Architecture Decision Records

For detailed information about the design decisions, FinOps Foundation alignment, and engineering rationale, see [ADR.md](./ADR.md).

### FinOps Toolkit Alignment

This AVM module is aligned with **[FinOps Toolkit](https://aka.ms/finops/toolkit) v0.7** and the **[FOCUS Specification](https://focus.finops.org/) 1.0r2**.

| Documentation | Link |
|--------------|------|
| Deploy FinOps Hub | [learn.microsoft.com/...deploy-hub](https://learn.microsoft.com/cloud-computing/finops/toolkit/hubs/deploy-hub) |
| Configure Exports | [learn.microsoft.com/...configure-exports](https://learn.microsoft.com/cloud-computing/finops/toolkit/hubs/configure-exports) |
| Power BI Reports | [learn.microsoft.com/...powerbi](https://learn.microsoft.com/cloud-computing/finops/toolkit/powerbi) |
| KQL Functions | [modules/scripts/README.md](./modules/scripts/README.md) |
| ADX Dashboard | [dashboards/README.md](./dashboards/README.md) |

### Deployment Modes

| Mode | Billing Types | Use Case | Documentation |
|------|---------------|----------|---------------|
| **Enterprise** | EA, MCA, MPA | Production with Cost Management exports | [Configure Exports](https://learn.microsoft.com/cloud-computing/finops/toolkit/hubs/configure-exports) |
| **Demo** | PAYGO, CSP, Dev | POCs and demos with test data | [src/README.md](./src/README.md) |

### Cost Estimation

> **⚠️ Disclaimer**: All estimates are based on **Azure PAYGO (Pay-As-You-Go) public pricing** as of January 2025. Your actual costs may be **significantly lower** with:
> - **Enterprise Agreement (EA)** discounts (typically 10-40% off)
> - **Azure Reserved Instances** for ADX clusters (up to 65% savings)
> - **Azure Hybrid Benefit** for Windows-based workloads
> - **Dev/Test pricing** for non-production environments
> - **Regional pricing variations**
>
> Use the [Azure Pricing Calculator](https://azure.microsoft.com/pricing/calculator/) for precise quotes based on your agreement.

#### Infrastructure Costs by Deployment Type

| Deployment Type | Configuration | Monthly Cost | Annual Cost | Best For |
|----------------|---------------|--------------|-------------|----------|
| **storage-only** | minimal | ~$5-15 | ~$60-180 | Basic cost data storage, Power BI only |
| **storage-only** | waf-aligned | ~$20-40 | ~$240-480 | Production storage with ZRS |
| **adx** (Dev SKU) | minimal | ~$50-100 | ~$600-1,200 | Dev/test, POCs, small orgs |
| **adx** (Standard) | minimal | ~$400-550 | ~$4,800-6,600 | Production, medium orgs |
| **adx** (Standard) | waf-aligned | ~$550-800 | ~$6,600-9,600 | Enterprise, HA required |
| **fabric** | minimal | ~$5-15 + Fabric | ~$60-180 + Fabric | Existing Fabric capacity |

#### Cost Breakdown by Resource

| Resource | Minimal Config | WAF-Aligned Config | Notes |
|----------|---------------|-------------------|-------|
| **Storage Account** | ~$2-10/mo | ~$15-50/mo | LRS vs ZRS, depends on data volume |
| **Key Vault** | ~$0.50/mo | ~$0.50/mo | Minimal operations |
| **Data Factory** | ~$5-20/mo | ~$10-30/mo | Based on pipeline runs |
| **ADX Dev SKU** | ~$45/mo* | N/A | *With auto-stop (8 hrs/day) |
| **ADX Standard (2 nodes)** | ~$380/mo | ~$500/mo | E2d_v5, always-on |
| **Private Endpoints** | N/A | ~$7-10/mo | Per endpoint ($0.01/hr) |
| **Managed VNet** | N/A | ~$5/mo | VNet + DNS zones |

> *ADX Dev SKU with `enableAutoStop: true` runs ~8 hours/day on average, reducing costs by ~65%.

#### Data Storage Costs

Storage costs scale with your organization's cloud spend. Data volume correlates with the number of cost line items (resources, services, tags) rather than dollar amounts directly.

| Monthly Cloud Spend | Est. Line Items/Month | Est. Data/Month | Storage Cost/Month | Storage Cost/Year |
|--------------------|----------------------|-----------------|-------------------|-------------------|
| **$200K** | 50K-100K | 2-5 GB | $0.10-0.25 | $1.20-3 |
| **$500K** | 100K-250K | 5-12 GB | $0.25-0.60 | $3-7 |
| **$800K** | 150K-400K | 8-20 GB | $0.40-1 | $5-12 |
| **$1M** | 200K-500K | 10-25 GB | $0.50-1.25 | $6-15 |
| **$2M** | 400K-1M | 20-50 GB | $1-2.50 | $12-30 |
| **$5M** | 1M-2.5M | 50-125 GB | $2.50-6.25 | $30-75 |
| **$10M** | 2M-5M | 100-250 GB | $5-12.50 | $60-150 |

> Storage pricing: Standard_LRS ~$0.02/GB, Premium_ZRS ~$0.15/GB for hot tier. Estimates assume daily FOCUS exports with 13 months retention.

#### ADX Data Ingestion & Retention Costs

| Monthly Cloud Spend | Data Volume | Ingestion/Month | 1-Year ADX Storage | 3-Year ADX Storage |
|--------------------|-------------|-----------------|-------------------|-------------------|
| **$200K** | ~3 GB/mo | ~$0.15 | ~$0.75 | ~$2.25 |
| **$500K** | ~8 GB/mo | ~$0.40 | ~$2 | ~$6 |
| **$800K** | ~14 GB/mo | ~$0.70 | ~$3.50 | ~$10.50 |
| **$1M** | ~18 GB/mo | ~$0.90 | ~$4.50 | ~$13.50 |
| **$2M** | ~35 GB/mo | ~$1.75 | ~$8.75 | ~$26 |
| **$5M** | ~85 GB/mo | ~$4.25 | ~$21 | ~$64 |
| **$10M** | ~175 GB/mo | ~$8.75 | ~$44 | ~$131 |

> ADX pricing: ~$0.05/GB ingestion, ~$0.02/GB/month hot cache storage. Estimates assume FOCUS daily exports.

#### Total Cost Examples by Cloud Spend

**Key insight: FinOps Hub costs are ~95% fixed infrastructure (ADX cluster), not variable with your cloud spend.**

| Component | Monthly Cost | What Drives It |
|-----------|--------------|----------------|
| **ADX Cluster** (Standard 2-node) | ~$380 | Fixed - cluster size, not data |
| **Data Factory** | ~$10-15 | Fixed - pipeline runs |
| **Storage + Key Vault** | ~$5-10 | Mostly fixed, tiny data cost |
| **Data ingestion/storage** | ~$1-5 | Variable - scales with data |
| **Total** | **~$400-410/mo** | ~95% fixed |

#### Real-World Example: $1M/mo Cloud Spend with 10% MoM Growth

Starting at $1M/mo cloud spend, growing 10% month-over-month:

| Period | Cloud Spend Range | Data Generated | FinOps Hub Cost | Cumulative Hub Cost |
|--------|-------------------|----------------|-----------------|---------------------|
| **Year 1** | $1M → $3.1M/mo | ~350 GB total | ~$405/mo | **~$4,860** |
| **Year 2** | $3.1M → $9.8M/mo | ~1.1 TB total | ~$415/mo | **~$9,840** |
| **Year 3** | $9.8M → $31M/mo | ~3.5 TB total | ~$450/mo | **~$15,240** |

> **3-Year Total: ~$15,240** for FinOps Hub infrastructure

#### Cost vs. Value Comparison

| Metric | Year 1 | Year 2 | Year 3 | 3-Year Total |
|--------|--------|--------|--------|--------------|
| **Total Cloud Spend** | ~$21M | ~$66M | ~$207M | **~$294M** |
| **FinOps Hub Cost** | ~$4,860 | ~$4,980 | ~$5,400 | **~$15,240** |
| **Hub as % of Spend** | 0.023% | 0.008% | 0.003% | **0.005%** |
| **10% Savings Opportunity** | $2.1M | $6.6M | $20.7M | **$29.4M** |

> **ROI**: Even achieving just 1% cloud savings through FinOps visibility = **$2.94M saved** vs **$15K** Hub cost (196:1 return)

#### Why Doesn't Cost Scale With Cloud Spend?

The ADX cluster processes cost **line items** (rows), not dollars. A $10M/mo enterprise with simple architecture may have fewer line items than a $500K startup with microservices. The cluster is sized for query performance, not data volume.

| Cloud Spend | Typical Line Items/Month | Data Volume | Variable Cost Impact |
|-------------|-------------------------|-------------|---------------------|
| $200K - $2M | 50K - 1M | 2-50 GB | +$0 - $2/mo |
| $2M - $10M | 1M - 5M | 50-250 GB | +$2 - $10/mo |
| $10M+ | 5M+ | 250+ GB | +$10 - $50/mo |

> The variable data costs are negligible compared to the ~$400/mo fixed cluster cost.

#### Cost Optimization Tips

1. **Use Dev SKU for non-production**: Dev(No SLA) SKUs are ~90% cheaper than Standard
2. **Enable auto-stop**: Reduces Dev SKU costs by ~65% when cluster is idle
3. **Start with storage-only**: Upgrade to ADX later when analytics needs grow
4. **Use minimal config for dev/test**: WAF-aligned adds ~30-50% for HA features
5. **Tune retention policies**: Reduce ADX hot cache retention for older data
6. **Pause when not in use**: See below for dramatic savings

#### Pause/Resume: Pay Only When You Need Analytics

**If you don't need real-time analytics 24/7**, you can pause ADX or Fabric and save 80-95% on compute costs. Your data remains safe in storage - pause only stops the analytics engine.

| Usage Pattern | Hours/Month | ADX Standard Cost | ADX Dev Cost | Fabric F2 Cost |
|---------------|-------------|-------------------|--------------|----------------|
| **Always-on** | 730 hrs | ~$380/mo | ~$130/mo | ~$263/mo |
| **Business hours** (8x5) | 160 hrs | ~$85/mo | ~$30/mo | ~$58/mo |
| **Weekly review** (4 hrs/wk) | 16 hrs | ~$10/mo | ~$3/mo | ~$6/mo |
| **Monthly review** (8 hrs/mo) | 8 hrs | ~$5/mo | ~$2/mo | ~$3/mo |

> **Weekly reviewer example**: ~$20-25/mo total (Storage + KV + ADF + 16 hrs ADX Dev)

**Use the helper script** to safely pause and resume:

```powershell
# Pause the hub (stop incurring compute charges)
.\src\Manage-FinOpsHubState.ps1 -ResourceGroupName "finops-rg" -HubName "myfinopshub" -Operation Pause

# Resume the hub (when ready to review - processes any backlog)
.\src\Manage-FinOpsHubState.ps1 -ResourceGroupName "finops-rg" -HubName "myfinopshub" -Operation Resume
```

The script handles the correct order (stop triggers before cluster, start cluster before triggers) and waits for resources to be ready. See [src/Manage-FinOpsHubState.ps1](./src/Manage-FinOpsHubState.ps1) for details.

> **⚠️ Backlog Processing**: If paused for days/weeks, expect 30 min to several hours for ADF to process accumulated data when resumed.

### Getting Started

Helper scripts in the [src/](./src/) folder simplify deployment and testing:

| Script | Purpose |
|--------|---------|
| `Deploy-FinOpsHub.ps1` | Interactive deployment with validation |
| `Generate-MultiCloudTestData.ps1` | Generate FOCUS 1.0-1.3 test data (Azure/AWS/GCP/DC) |
| `Get-BestAdxSku.ps1` | Find available ADX SKUs by region |
| `Manage-FinOpsHubState.ps1` | Pause/resume hub to optimize costs |

See [src/README.md](./src/README.md) for detailed usage, or use the `gettingStartedGuide` output from deployment.

### Visualization Options

| Option | Included | Best For | Documentation |
|--------|----------|----------|---------------|
| **ADX Dashboard** | ✅ Yes | Central FinOps team, real-time analysis | [dashboards/README.md](./dashboards/README.md) |
| **Power BI Reports** | External | Department distribution, RLS, mobile | [aka.ms/finops/toolkit/powerbi](https://aka.ms/finops/toolkit/powerbi) |

### Folder Structure

For module architecture details, see [modules/README.md](./modules/README.md).

### Upgrade Safety & Data Protection

**This module is designed for safe upgrades that preserve existing data.** When upgrading to new versions (e.g., FOCUS 1.2 → 1.3 → 1.4), your historical cost data is protected:

| Resource | Protection Mechanism | Behavior During Upgrade |
|----------|---------------------|------------------------|
| **Storage Account** | ARM incremental deployment | Containers only created if missing; existing blobs **never deleted** |
| **ADX Tables** | `.create-merge table` command | New columns **added** without deleting existing data |
| **ADX Functions** | `.create-or-alter function` | Logic updated; underlying data **untouched** |
| **Key Vault** | Soft delete (90 days) + Purge protection | Secrets recoverable even if accidentally deleted |

#### Recommended Protection Settings

For production environments with years of cost data, we recommend:

```bicep
module finopsHub 'br/public:avm/ptn/finops-toolkit/finops-hub:<version>' = {
  params: {
    hubName: 'prodfinopshub'
    
    // Enable resource lock to prevent accidental deletion
    lock: {
      kind: 'CanNotDelete'
      name: 'finops-hub-data-protection'
    }
    
    // WAF-aligned enables purge protection and geo-redundant storage
    deploymentConfiguration: 'waf-aligned'
  }
}
```

#### What Happens During FOCUS Version Upgrades

| Upgrade Path | Data Impact | Action Required |
|-------------|-------------|-----------------|
| **FOCUS 1.0 → 1.2** | None - existing data preserved | Re-run pipeline to transform with new columns |
| **FOCUS 1.2 → 1.3** | None - schema extended | New optional columns added to existing tables |
| **FOCUS 1.3 → 1.4** | None - backward compatible | New functions deployed alongside existing |

#### Backup Recommendations

For critical production data:

1. **Azure Backup**: Enable blob versioning on storage account
2. **ADX Export**: Use `.export` command to backup historical data periodically
3. **Cross-region**: Use `waf-aligned` for Zone-Redundant Storage (ZRS)

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
