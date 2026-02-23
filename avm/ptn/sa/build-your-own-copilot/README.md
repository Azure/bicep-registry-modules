# Build Your Own Copilot Solution Accelerator `[Sa/BuildYourOwnCopilot]`

> ⚠️THIS MODULE IS DEPRECATED.⚠️
> 
> - It will no longer receive any updates.
> - If the underlying Azure service is not deprecated/retired, this module may still be used as is (references to any existing versions will keep working), but it is not recommended for new deployments.
> - It is recommended to migrate to a replacement/alternative version of the module, if available.

This module deploys a comprehensive Build Your Own Copilot solution accelerator with Azure AI Services, CosmosDB, SQL Database, Key Vault, Storage Account, Azure AI Search, and a containerized web application. The solution includes AI Foundry services for GPT and embedding models, supporting both private and public networking configurations with optional WAF-aligned features for monitoring, scalability, and redundancy.

|**Post-Deployment Step** |
|-------------|
| After completing the deployment, follow the steps in the [Post-Deployment Guide](https://github.com/microsoft/Build-your-own-copilot-Solution-Accelerator/blob/main/docs/AVMPostDeploymentGuide.md) to configure and verify your environment. |

> **Note:** This module is not intended for broad, generic use, as it was designed by the Commercial Solution Areas CTO team, as a Microsoft Solution Accelerator. Feature requests and bug fix requests are welcome if they support the needs of this organization but may not be incorporated if they aim to make this module more generic than what it needs to be for its primary use case. This module will likely be updated to leverage AVM resource modules in the future. This may result in breaking changes in upcoming versions when these features are implemented.


You can reference the module as follows:
```bicep
module buildYourOwnCopilot 'br/public:avm/ptn/sa/build-your-own-copilot:<version>' = {
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
| `Microsoft.Automanage/configurationProfileAssignments` | 2022-05-04 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.automanage_configurationprofileassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Automanage/2022-05-04/configurationProfileAssignments)</li></ul> |
| `Microsoft.CognitiveServices/accounts` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cognitiveservices_accounts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2025-06-01/accounts)</li></ul> |
| `Microsoft.CognitiveServices/accounts/deployments` | 2024-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cognitiveservices_accounts_deployments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2024-10-01/accounts/deployments)</li></ul> |
| `Microsoft.CognitiveServices/accounts/projects` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cognitiveservices_accounts_projects.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2025-06-01/accounts/projects)</li></ul> |
| `Microsoft.CognitiveServices/accounts/projects/connections` | 2025-07-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cognitiveservices_accounts_projects_connections.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2025-07-01-preview/accounts/projects/connections)</li></ul> |
| `Microsoft.Compute/disks` | 2024-03-02 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.compute_disks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2024-03-02/disks)</li></ul> |
| `Microsoft.Compute/virtualMachines` | 2024-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.compute_virtualmachines.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2024-07-01/virtualMachines)</li></ul> |
| `Microsoft.Compute/virtualMachines/extensions` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.compute_virtualmachines_extensions.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2024-11-01/virtualMachines/extensions)</li></ul> |
| `Microsoft.DevTestLab/schedules` | 2018-09-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.devtestlab_schedules.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevTestLab/2018-09-15/schedules)</li></ul> |
| `Microsoft.DocumentDB/databaseAccounts` | 2025-04-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2025-04-15/databaseAccounts)</li></ul> |
| `Microsoft.DocumentDB/databaseAccounts/cassandraKeyspaces` | 2024-11-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_cassandrakeyspaces.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/cassandraKeyspaces)</li></ul> |
| `Microsoft.DocumentDB/databaseAccounts/cassandraKeyspaces/tables` | 2024-11-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_cassandrakeyspaces_tables.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/cassandraKeyspaces/tables)</li></ul> |
| `Microsoft.DocumentDB/databaseAccounts/cassandraKeyspaces/views` | 2025-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_cassandrakeyspaces_views.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2025-05-01-preview/databaseAccounts/cassandraKeyspaces/views)</li></ul> |
| `Microsoft.DocumentDB/databaseAccounts/cassandraRoleAssignments` | 2025-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_cassandraroleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2025-05-01-preview/databaseAccounts/cassandraRoleAssignments)</li></ul> |
| `Microsoft.DocumentDB/databaseAccounts/cassandraRoleDefinitions` | 2025-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_cassandraroledefinitions.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2025-05-01-preview/databaseAccounts/cassandraRoleDefinitions)</li></ul> |
| `Microsoft.DocumentDB/databaseAccounts/gremlinDatabases` | 2025-04-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_gremlindatabases.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2025-04-15/databaseAccounts/gremlinDatabases)</li></ul> |
| `Microsoft.DocumentDB/databaseAccounts/gremlinDatabases/graphs` | 2025-04-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_gremlindatabases_graphs.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2025-04-15/databaseAccounts/gremlinDatabases/graphs)</li></ul> |
| `Microsoft.DocumentDB/databaseAccounts/mongodbDatabases` | 2025-04-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_mongodbdatabases.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2025-04-15/databaseAccounts/mongodbDatabases)</li></ul> |
| `Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections` | 2025-04-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_mongodbdatabases_collections.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2025-04-15/databaseAccounts/mongodbDatabases/collections)</li></ul> |
| `Microsoft.DocumentDB/databaseAccounts/sqlDatabases` | 2025-04-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_sqldatabases.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2025-04-15/databaseAccounts/sqlDatabases)</li></ul> |
| `Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers` | 2025-04-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_sqldatabases_containers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2025-04-15/databaseAccounts/sqlDatabases/containers)</li></ul> |
| `Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments` | 2024-11-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_sqlroleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/sqlRoleAssignments)</li></ul> |
| `Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions` | 2024-11-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_sqlroledefinitions.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/sqlRoleDefinitions)</li></ul> |
| `Microsoft.DocumentDB/databaseAccounts/tables` | 2025-04-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_tables.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2025-04-15/databaseAccounts/tables)</li></ul> |
| `Microsoft.GuestConfiguration/guestConfigurationAssignments` | 2024-04-05 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.guestconfiguration_guestconfigurationassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.GuestConfiguration/2024-04-05/guestConfigurationAssignments)</li></ul> |
| `Microsoft.Insights/components` | 2020-02-02 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_components.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2020-02-02/components)</li></ul> |
| `microsoft.insights/components/linkedStorageAccounts` | 2020-03-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_components_linkedstorageaccounts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/microsoft.insights/2020-03-01-preview/components/linkedStorageAccounts)</li></ul> |
| `Microsoft.Insights/dataCollectionRuleAssociations` | 2024-03-11 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_datacollectionruleassociations.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2024-03-11/dataCollectionRuleAssociations)</li></ul> |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_diagnosticsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)</li></ul> |
| `Microsoft.KeyVault/vaults` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2024-11-01/vaults)</li></ul> |
| `Microsoft.KeyVault/vaults/accessPolicies` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults_accesspolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2024-11-01/vaults/accessPolicies)</li></ul> |
| `Microsoft.KeyVault/vaults/keys` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults_keys.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2024-11-01/vaults/keys)</li></ul> |
| `Microsoft.KeyVault/vaults/secrets` | 2025-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults_secrets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2025-05-01/vaults/secrets)</li></ul> |
| `Microsoft.KeyVault/vaults/secrets` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults_secrets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2024-11-01/vaults/secrets)</li></ul> |
| `Microsoft.Maintenance/configurationAssignments` | 2023-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.maintenance_configurationassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Maintenance/2023-04-01/configurationAssignments)</li></ul> |
| `Microsoft.Maintenance/maintenanceConfigurations` | 2023-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.maintenance_maintenanceconfigurations.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Maintenance/2023-04-01/maintenanceConfigurations)</li></ul> |
| `Microsoft.ManagedIdentity/userAssignedIdentities` | 2024-11-30 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.managedidentity_userassignedidentities.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2024-11-30/userAssignedIdentities)</li></ul> |
| `Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials` | 2024-11-30 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.managedidentity_userassignedidentities_federatedidentitycredentials.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2024-11-30/userAssignedIdentities/federatedIdentityCredentials)</li></ul> |
| `Microsoft.Network/bastionHosts` | 2024-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_bastionhosts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-07-01/bastionHosts)</li></ul> |
| `Microsoft.Network/networkInterfaces` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_networkinterfaces.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/networkInterfaces)</li></ul> |
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
| `Microsoft.Network/publicIPAddresses` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_publicipaddresses.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/publicIPAddresses)</li></ul> |
| `Microsoft.Network/virtualNetworks` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_virtualnetworks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/virtualNetworks)</li></ul> |
| `Microsoft.Network/virtualNetworks/subnets` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_virtualnetworks_subnets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/virtualNetworks/subnets)</li></ul> |
| `Microsoft.Network/virtualNetworks/virtualNetworkPeerings` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_virtualnetworks_virtualnetworkpeerings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-01-01/virtualNetworks/virtualNetworkPeerings)</li></ul> |
| `Microsoft.OperationalInsights/workspaces` | 2025-02-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationalinsights_workspaces.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2025-02-01/workspaces)</li></ul> |
| `Microsoft.OperationalInsights/workspaces/dataExports` | 2025-02-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationalinsights_workspaces_dataexports.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2025-02-01/workspaces/dataExports)</li></ul> |
| `Microsoft.OperationalInsights/workspaces/dataSources` | 2025-02-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationalinsights_workspaces_datasources.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2025-02-01/workspaces/dataSources)</li></ul> |
| `Microsoft.OperationalInsights/workspaces/linkedServices` | 2025-02-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationalinsights_workspaces_linkedservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2025-02-01/workspaces/linkedServices)</li></ul> |
| `Microsoft.OperationalInsights/workspaces/linkedStorageAccounts` | 2025-02-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationalinsights_workspaces_linkedstorageaccounts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2025-02-01/workspaces/linkedStorageAccounts)</li></ul> |
| `Microsoft.OperationalInsights/workspaces/savedSearches` | 2025-02-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationalinsights_workspaces_savedsearches.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2025-02-01/workspaces/savedSearches)</li></ul> |
| `Microsoft.OperationalInsights/workspaces/storageInsightConfigs` | 2025-02-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationalinsights_workspaces_storageinsightconfigs.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2025-02-01/workspaces/storageInsightConfigs)</li></ul> |
| `Microsoft.OperationalInsights/workspaces/tables` | 2025-02-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationalinsights_workspaces_tables.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2025-02-01/workspaces/tables)</li></ul> |
| `Microsoft.OperationsManagement/solutions` | 2015-11-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationsmanagement_solutions.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationsManagement/2015-11-01-preview/solutions)</li></ul> |
| `Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems` | 2025-02-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.recoveryservices_vaults_backupfabrics_protectioncontainers_protecteditems.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2025-02-01/vaults/backupFabrics/protectionContainers/protectedItems)</li></ul> |
| `Microsoft.Resources/tags` | 2025-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.resources_tags.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2025-04-01/tags)</li></ul> |
| `Microsoft.Search/searchServices` | 2025-02-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.search_searchservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Search/2025-02-01-preview/searchServices)</li></ul> |
| `Microsoft.Search/searchServices/sharedPrivateLinkResources` | 2025-02-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.search_searchservices_sharedprivatelinkresources.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Search/2025-02-01-preview/searchServices/sharedPrivateLinkResources)</li></ul> |
| `Microsoft.SecurityInsights/onboardingStates` | 2024-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.securityinsights_onboardingstates.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.SecurityInsights/2024-03-01/onboardingStates)</li></ul> |
| `Microsoft.Sql/servers` | 2023-08-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.sql_servers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2023-08-01/servers)</li></ul> |
| `Microsoft.Sql/servers/auditingSettings` | 2023-08-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.sql_servers_auditingsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2023-08-01/servers/auditingSettings)</li></ul> |
| `Microsoft.Sql/servers/connectionPolicies` | 2023-08-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.sql_servers_connectionpolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2023-08-01/servers/connectionPolicies)</li></ul> |
| `Microsoft.Sql/servers/databases` | 2023-08-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.sql_servers_databases.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2023-08-01/servers/databases)</li></ul> |
| `Microsoft.Sql/servers/databases/backupLongTermRetentionPolicies` | 2023-08-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.sql_servers_databases_backuplongtermretentionpolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2023-08-01/servers/databases/backupLongTermRetentionPolicies)</li></ul> |
| `Microsoft.Sql/servers/databases/backupShortTermRetentionPolicies` | 2023-08-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.sql_servers_databases_backupshorttermretentionpolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2023-08-01/servers/databases/backupShortTermRetentionPolicies)</li></ul> |
| `Microsoft.Sql/servers/elasticPools` | 2023-08-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.sql_servers_elasticpools.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2023-08-01/servers/elasticPools)</li></ul> |
| `Microsoft.Sql/servers/encryptionProtector` | 2023-08-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.sql_servers_encryptionprotector.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2023-08-01/servers/encryptionProtector)</li></ul> |
| `Microsoft.Sql/servers/failoverGroups` | 2024-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.sql_servers_failovergroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2024-05-01-preview/servers/failoverGroups)</li></ul> |
| `Microsoft.Sql/servers/firewallRules` | 2023-08-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.sql_servers_firewallrules.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2023-08-01/servers/firewallRules)</li></ul> |
| `Microsoft.Sql/servers/keys` | 2023-08-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.sql_servers_keys.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2023-08-01/servers/keys)</li></ul> |
| `Microsoft.Sql/servers/securityAlertPolicies` | 2023-08-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.sql_servers_securityalertpolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2023-08-01/servers/securityAlertPolicies)</li></ul> |
| `Microsoft.Sql/servers/virtualNetworkRules` | 2023-08-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.sql_servers_virtualnetworkrules.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2023-08-01/servers/virtualNetworkRules)</li></ul> |
| `Microsoft.Sql/servers/vulnerabilityAssessments` | 2023-08-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.sql_servers_vulnerabilityassessments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2023-08-01/servers/vulnerabilityAssessments)</li></ul> |
| `Microsoft.Storage/storageAccounts` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-01-01/storageAccounts)</li></ul> |
| `Microsoft.Storage/storageAccounts/blobServices` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_blobservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-01-01/storageAccounts/blobServices)</li></ul> |
| `Microsoft.Storage/storageAccounts/blobServices/containers` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_blobservices_containers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-01-01/storageAccounts/blobServices/containers)</li></ul> |
| `Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_blobservices_containers_immutabilitypolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-01-01/storageAccounts/blobServices/containers/immutabilityPolicies)</li></ul> |
| `Microsoft.Storage/storageAccounts/fileServices` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_fileservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/fileServices)</li></ul> |
| `Microsoft.Storage/storageAccounts/fileServices/shares` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_fileservices_shares.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/fileServices/shares)</li></ul> |
| `Microsoft.Storage/storageAccounts/localUsers` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_localusers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/localUsers)</li></ul> |
| `Microsoft.Storage/storageAccounts/managementPolicies` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_managementpolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/managementPolicies)</li></ul> |
| `Microsoft.Storage/storageAccounts/objectReplicationPolicies` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_objectreplicationpolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-01-01/storageAccounts/objectReplicationPolicies)</li></ul> |
| `Microsoft.Storage/storageAccounts/queueServices` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_queueservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/queueServices)</li></ul> |
| `Microsoft.Storage/storageAccounts/queueServices/queues` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_queueservices_queues.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/queueServices/queues)</li></ul> |
| `Microsoft.Storage/storageAccounts/tableServices` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_tableservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/tableServices)</li></ul> |
| `Microsoft.Storage/storageAccounts/tableServices/tables` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_tableservices_tables.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/tableServices/tables)</li></ul> |
| `Microsoft.Web/serverfarms` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.web_serverfarms.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-11-01/serverfarms)</li></ul> |
| `Microsoft.Web/sites` | 2024-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.web_sites.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-04-01/sites)</li></ul> |
| `Microsoft.Web/sites/config` | 2024-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.web_sites_config.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-04-01/sites/config)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/sa/build-your-own-copilot:<version>`.

- [Sandbox configuration with default parameter values](#example-1-sandbox-configuration-with-default-parameter-values)
- [Waf-aligned configuration with default parameter values](#example-2-waf-aligned-configuration-with-default-parameter-values)

### Example 1: _Sandbox configuration with default parameter values_

This instance deploys the Build Your Own Copilot Solution Accelerator using only the required parameters. Optional parameters will take the default values, which are designed for Sandbox environments.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/sandbox]


<details>

<summary>via Bicep module</summary>

```bicep
module buildYourOwnCopilot 'br/public:avm/ptn/sa/build-your-own-copilot:<version>' = {
  params: {
    // Required parameters
    azureAiServiceLocation: '<azureAiServiceLocation>'
    // Non-required parameters
    enableMonitoring: false
    enablePrivateNetworking: false
    enablePurgeProtection: false
    enableRedundancy: false
    enableScalability: false
    enableTelemetry: true
    solutionName: '<solutionName>'
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
    "azureAiServiceLocation": {
      "value": "<azureAiServiceLocation>"
    },
    // Non-required parameters
    "enableMonitoring": {
      "value": false
    },
    "enablePrivateNetworking": {
      "value": false
    },
    "enablePurgeProtection": {
      "value": false
    },
    "enableRedundancy": {
      "value": false
    },
    "enableScalability": {
      "value": false
    },
    "enableTelemetry": {
      "value": true
    },
    "solutionName": {
      "value": "<solutionName>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/sa/build-your-own-copilot:<version>'

// Required parameters
param azureAiServiceLocation = '<azureAiServiceLocation>'
// Non-required parameters
param enableMonitoring = false
param enablePrivateNetworking = false
param enablePurgeProtection = false
param enableRedundancy = false
param enableScalability = false
param enableTelemetry = true
param solutionName = '<solutionName>'
```

</details>
<p>

### Example 2: _Waf-aligned configuration with default parameter values_

This instance deploys the Build Your Own Copilot Solution Accelerator

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/waf-aligned]


<details>

<summary>via Bicep module</summary>

```bicep
module buildYourOwnCopilot 'br/public:avm/ptn/sa/build-your-own-copilot:<version>' = {
  params: {
    // Required parameters
    azureAiServiceLocation: '<azureAiServiceLocation>'
    // Non-required parameters
    cosmosLocation: '<cosmosLocation>'
    cosmosReplicaLocation: '<cosmosReplicaLocation>'
    enableMonitoring: true
    enablePrivateNetworking: true
    enablePurgeProtection: true
    enableRedundancy: true
    enableScalability: true
    enableTelemetry: true
    solutionName: '<solutionName>'
    vmAdminPassword: '<vmAdminPassword>'
    vmAdminUsername: 'adminuser'
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
    "azureAiServiceLocation": {
      "value": "<azureAiServiceLocation>"
    },
    // Non-required parameters
    "cosmosLocation": {
      "value": "<cosmosLocation>"
    },
    "cosmosReplicaLocation": {
      "value": "<cosmosReplicaLocation>"
    },
    "enableMonitoring": {
      "value": true
    },
    "enablePrivateNetworking": {
      "value": true
    },
    "enablePurgeProtection": {
      "value": true
    },
    "enableRedundancy": {
      "value": true
    },
    "enableScalability": {
      "value": true
    },
    "enableTelemetry": {
      "value": true
    },
    "solutionName": {
      "value": "<solutionName>"
    },
    "vmAdminPassword": {
      "value": "<vmAdminPassword>"
    },
    "vmAdminUsername": {
      "value": "adminuser"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/sa/build-your-own-copilot:<version>'

// Required parameters
param azureAiServiceLocation = '<azureAiServiceLocation>'
// Non-required parameters
param cosmosLocation = '<cosmosLocation>'
param cosmosReplicaLocation = '<cosmosReplicaLocation>'
param enableMonitoring = true
param enablePrivateNetworking = true
param enablePurgeProtection = true
param enableRedundancy = true
param enableScalability = true
param enableTelemetry = true
param solutionName = '<solutionName>'
param vmAdminPassword = '<vmAdminPassword>'
param vmAdminUsername = 'adminuser'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`azureAiServiceLocation`](#parameter-azureaiservicelocation) | string | Location for AI Foundry deployment. This is the location where the AI Foundry resources will be deployed. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`azureOpenaiAPIVersion`](#parameter-azureopenaiapiversion) | string | API version for the Azure OpenAI service. |
| [`containerImageName`](#parameter-containerimagename) | string | The Container Image Name to deploy on the webapp. |
| [`containerRegistryHostname`](#parameter-containerregistryhostname) | string | The Container Registry hostname where the docker images for the frontend are located. |
| [`cosmosLocation`](#parameter-cosmoslocation) | string | CosmosDB Location. |
| [`cosmosReplicaLocation`](#parameter-cosmosreplicalocation) | string | CosmosDB Replica Location. |
| [`createdBy`](#parameter-createdby) | string | Tag, Created by user name. |
| [`embeddingDeploymentCapacity`](#parameter-embeddingdeploymentcapacity) | int | Capacity of the Embedding Model deployment. |
| [`embeddingModel`](#parameter-embeddingmodel) | string | Name of the Text Embedding model to deploy. |
| [`embeddingModelVersion`](#parameter-embeddingmodelversion) | string | Version of the GPT model to deploy. |
| [`enableMonitoring`](#parameter-enablemonitoring) | bool | Enable monitoring applicable resources, aligned with the Well Architected Framework recommendations. This setting enables Application Insights and Log Analytics and configures all the resources applicable resources to send logs. Defaults to false. |
| [`enablePrivateNetworking`](#parameter-enableprivatenetworking) | bool | Enable private networking for applicable resources, aligned with the Well Architected Framework recommendations. Defaults to false. |
| [`enablePurgeProtection`](#parameter-enablepurgeprotection) | bool | Enable purge protection for the Key Vault. |
| [`enableRedundancy`](#parameter-enableredundancy) | bool | Enable redundancy for applicable resources, aligned with the Well Architected Framework recommendations. Defaults to false. |
| [`enableScalability`](#parameter-enablescalability) | bool | Enable scalability for applicable resources, aligned with the Well Architected Framework recommendations. Defaults to false. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`gptModelCapacity`](#parameter-gptmodelcapacity) | int | Capacity of the GPT deployment. |
| [`gptModelDeploymentType`](#parameter-gptmodeldeploymenttype) | string | GPT model deployment type. |
| [`gptModelName`](#parameter-gptmodelname) | string | Name of the GPT model to deploy. |
| [`gptModelVersion`](#parameter-gptmodelversion) | string | Version of the GPT model to deploy. |
| [`imageTag`](#parameter-imagetag) | string | The Container Image Tag to deploy on the webapp. |
| [`location`](#parameter-location) | string | Azure region for all services. Regions are restricted to guarantee compatibility with paired regions and replica locations for data redundancy and failover scenarios based on articles [Azure regions list](https://learn.microsoft.com/azure/reliability/regions-list) and [Azure Database for MySQL Flexible Server - Azure Regions](https://learn.microsoft.com/azure/mysql/flexible-server/overview#azure-regions). |
| [`solutionName`](#parameter-solutionname) | string | A unique prefix for all resources in this deployment. This should be 3-20 characters long. |
| [`solutionUniqueToken`](#parameter-solutionuniquetoken) | securestring | A unique token for the solution. This is used to ensure resource names are unique for global resources. Defaults to a 5-character substring of the unique string generated from the subscription ID, resource group name, and solution name. |
| [`tags`](#parameter-tags) | object | The tags to apply to all deployed Azure resources. |
| [`vmAdminPassword`](#parameter-vmadminpassword) | securestring | Admin password for the Jumpbox Virtual Machine. Set to custom value if enablePrivateNetworking is true. |
| [`vmAdminUsername`](#parameter-vmadminusername) | securestring | Admin username for the Jumpbox Virtual Machine. Set to custom value if enablePrivateNetworking is true. |
| [`vmSize`](#parameter-vmsize) | string | Size of the Jumpbox Virtual Machine when created. Set to custom value if enablePrivateNetworking is true. |

### Parameter: `azureAiServiceLocation`

Location for AI Foundry deployment. This is the location where the AI Foundry resources will be deployed.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'australiaeast'
    'eastus'
    'eastus2'
    'francecentral'
    'japaneast'
    'swedencentral'
    'uksouth'
    'westus'
    'westus3'
  ]
  ```

### Parameter: `azureOpenaiAPIVersion`

API version for the Azure OpenAI service.

- Required: No
- Type: string
- Default: `'2025-04-01-preview'`

### Parameter: `containerImageName`

The Container Image Name to deploy on the webapp.

- Required: No
- Type: string
- Default: `'byc-wa-app'`

### Parameter: `containerRegistryHostname`

The Container Registry hostname where the docker images for the frontend are located.

- Required: No
- Type: string
- Default: `'bycwacontainerreg.azurecr.io'`

### Parameter: `cosmosLocation`

CosmosDB Location.

- Required: No
- Type: string
- Default: `'eastus2'`

### Parameter: `cosmosReplicaLocation`

CosmosDB Replica Location.

- Required: No
- Type: string
- Default: `'canadacentral'`

### Parameter: `createdBy`

Tag, Created by user name.

- Required: No
- Type: string
- Default: `[if(contains(deployer(), 'userPrincipalName'), split(deployer().userPrincipalName, '@')[0], deployer().objectId)]`

### Parameter: `embeddingDeploymentCapacity`

Capacity of the Embedding Model deployment.

- Required: No
- Type: int
- Default: `80`
- MinValue: 10

### Parameter: `embeddingModel`

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

### Parameter: `embeddingModelVersion`

Version of the GPT model to deploy.

- Required: No
- Type: string
- Default: `'2'`

### Parameter: `enableMonitoring`

Enable monitoring applicable resources, aligned with the Well Architected Framework recommendations. This setting enables Application Insights and Log Analytics and configures all the resources applicable resources to send logs. Defaults to false.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enablePrivateNetworking`

Enable private networking for applicable resources, aligned with the Well Architected Framework recommendations. Defaults to false.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enablePurgeProtection`

Enable purge protection for the Key Vault.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableRedundancy`

Enable redundancy for applicable resources, aligned with the Well Architected Framework recommendations. Defaults to false.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableScalability`

Enable scalability for applicable resources, aligned with the Well Architected Framework recommendations. Defaults to false.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `gptModelCapacity`

Capacity of the GPT deployment.

- Required: No
- Type: int
- Default: `200`
- MinValue: 10

### Parameter: `gptModelDeploymentType`

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

### Parameter: `gptModelName`

Name of the GPT model to deploy.

- Required: No
- Type: string
- Default: `'gpt-4o-mini'`
- Allowed:
  ```Bicep
  [
    'gpt-4o-mini'
  ]
  ```

### Parameter: `gptModelVersion`

Version of the GPT model to deploy.

- Required: No
- Type: string
- Default: `'2024-07-18'`

### Parameter: `imageTag`

The Container Image Tag to deploy on the webapp.

- Required: No
- Type: string
- Default: `'latest_waf_2025-11-03_914'`

### Parameter: `location`

Azure region for all services. Regions are restricted to guarantee compatibility with paired regions and replica locations for data redundancy and failover scenarios based on articles [Azure regions list](https://learn.microsoft.com/azure/reliability/regions-list) and [Azure Database for MySQL Flexible Server - Azure Regions](https://learn.microsoft.com/azure/mysql/flexible-server/overview#azure-regions).

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `solutionName`

A unique prefix for all resources in this deployment. This should be 3-20 characters long.

- Required: No
- Type: string
- Default: `'clientadvisor'`

### Parameter: `solutionUniqueToken`

A unique token for the solution. This is used to ensure resource names are unique for global resources. Defaults to a 5-character substring of the unique string generated from the subscription ID, resource group name, and solution name.

- Required: No
- Type: securestring
- Default: `[substring(uniqueString(subscription().id, resourceGroup().name, parameters('solutionName')), 0, 5)]`

### Parameter: `tags`

The tags to apply to all deployed Azure resources.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `vmAdminPassword`

Admin password for the Jumpbox Virtual Machine. Set to custom value if enablePrivateNetworking is true.

- Required: No
- Type: securestring

### Parameter: `vmAdminUsername`

Admin username for the Jumpbox Virtual Machine. Set to custom value if enablePrivateNetworking is true.

- Required: No
- Type: securestring

### Parameter: `vmSize`

Size of the Jumpbox Virtual Machine when created. Set to custom value if enablePrivateNetworking is true.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `aiFoundryResourceId` | string | The resource ID of the AI Foundry service. |
| `aiSearchServiceName` | string | The name of the Azure AI Search service. |
| `appEnv` | string | The application environment. |
| `appInsightsInstrumentationKey` | string | The Application Insights instrumentation key. |
| `applicationInsightsConnectionString` | string | The Application Insights connection string. |
| `azureAiAgentApiVersion` | string | The API version for the Azure AI Agent. |
| `azureAiAgentEndpoint` | string | The endpoint for the Azure AI Agent. |
| `azureAiAgentModelDeploymentName` | string | The model deployment name for the Azure AI Agent. |
| `azureAiSearchEndpoint` | string | The endpoint for the Azure AI Search service. |
| `azureCallTranscriptSystemPrompt` | string | The system prompt for call transcript processing in Azure Functions. |
| `azureCosmosDbAccount` | string | The Azure CosmosDB account name. |
| `azureCosmosDbConversationsContainer` | string | The Azure CosmosDB conversations container name. |
| `azureCosmosDbDatabase` | string | The Azure CosmosDB database name. |
| `azureCosmosDbEnableFeedback` | string | Indicates whether feedback is enabled for Azure CosmosDB. |
| `azureOpenAiEmbeddingEndpoint` | string | The endpoint for Azure OpenAI embedding service. |
| `azureOpenAiEmbeddingName` | string | The name of the Azure OpenAI embedding model. |
| `azureOpenAiEndpoint` | string | The endpoint for the Azure OpenAI service. |
| `azureOpenAiMaxTokens` | string | The maximum number of tokens for Azure OpenAI. |
| `azureOpenAiModel` | string | The Azure OpenAI model name. |
| `azureOpenAiPreviewApiVersion` | string | The preview API version for Azure OpenAI. |
| `azureOpenAiResource` | string | The Azure OpenAI resource name. |
| `azureOpenAiStopSequence` | string | The stop sequence for Azure OpenAI. |
| `azureOpenAiStream` | string | Indicates whether streaming is enabled for Azure OpenAI. |
| `azureOpenAiStreamTextSystemPrompt` | string | The system prompt for stream text processing in Azure Functions. |
| `azureOpenAiSystemMessage` | string | The system message for Azure OpenAI. |
| `azureOpenAiTemperature` | string | The temperature setting for Azure OpenAI. |
| `azureOpenAiTopP` | string | The top P setting for Azure OpenAI. |
| `azureSearchConnectionName` | string | The connection name for Azure AI Search. |
| `azureSearchContentColumns` | string | The content columns used in Azure AI Search. |
| `azureSearchEnableInDomain` | string | Indicates whether in-domain search is enabled for Azure AI Search. |
| `azureSearchFilenameColumn` | string | The filename column used in Azure AI Search. |
| `azureSearchIndex` | string | The index name used in Azure AI Search. |
| `azureSearchPermittedGroupsColumn` | string | The permitted groups column used in Azure AI Search. |
| `azureSearchQueryType` | string | The query type used in Azure AI Search. |
| `azureSearchSemanticSearchConfig` | string | The semantic search configuration used in Azure AI Search. |
| `azureSearchService` | string | The Azure AI Search service name. |
| `azureSearchStrictness` | string | The strictness level used in Azure AI Search. |
| `azureSearchTitleColumn` | string | The title column used in Azure AI Search. |
| `azureSearchTopK` | string | The number of top results (K) to return from Azure AI Search. |
| `azureSearchUrlColumn` | string | The URL column used in Azure AI Search. |
| `azureSearchUseSemanticSearch` | string | Indicates whether semantic search is used in Azure AI Search. |
| `azureSearchVectorColumns` | string | The vector fields used in Azure AI Search. |
| `azureSqlSystemPrompt` | string | The system prompt for SQL queries in Azure Functions. |
| `azureSubscriptionId` | string | The Azure Subscription ID where the resources are deployed. |
| `cosmosDbAccountName` | string | The name of the deployed CosmosDB Account. |
| `keyVaultName` | string | The name of the deployed Key Vault. |
| `managedIdentitySqlClientId` | string | The client ID of the managed identity for SQL Server. |
| `managedIdentitySqlName` | string | The name of the managed identity for SQL Server. |
| `managedIdentityWebAppClientId` | string | The client ID of the managed identity for the web application. |
| `managedIdentityWebAppName` | string | The name of the managed identity for the web application. |
| `resourceGroupName` | string | The name of the Resource Group. |
| `sqlDbDatabase` | string | The name of the SQL Database. |
| `sqlDbServer` | string | The fully qualified domain name (FQDN) of the Azure SQL Server. |
| `sqlDbServerName` | string | The name of the SQL Database server. |
| `sqlDbUserMid` | string | The client ID of the managed identity for the web application. |
| `storageAccountName` | string | The name of the deployed Storage Account. |
| `storageContainerName` | string | The name of the Storage Container. |
| `useAiProjectClient` | string | Indicates whether the AI Project Client should be used. |
| `useInternalStream` | string | Indicates whether the internal stream should be used. |
| `webAppName` | string | The name of the deployed web application. |
| `webAppUrl` | string | The URL of the deployed web application. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/compute/virtual-machine:0.21.0` | Remote reference |
| `br/public:avm/res/document-db/database-account:0.18.0` | Remote reference |
| `br/public:avm/res/insights/component:0.6.0` | Remote reference |
| `br/public:avm/res/key-vault/vault:0.13.3` | Remote reference |
| `br/public:avm/res/maintenance/maintenance-configuration:0.3.2` | Remote reference |
| `br/public:avm/res/managed-identity/user-assigned-identity:0.4.2` | Remote reference |
| `br/public:avm/res/network/bastion-host:0.8.0` | Remote reference |
| `br/public:avm/res/network/network-security-group:0.5.2` | Remote reference |
| `br/public:avm/res/network/private-dns-zone:0.8.0` | Remote reference |
| `br/public:avm/res/network/private-endpoint:0.11.1` | Remote reference |
| `br/public:avm/res/network/virtual-network:0.7.1` | Remote reference |
| `br/public:avm/res/operational-insights/workspace:0.13.0` | Remote reference |
| `br/public:avm/res/search/search-service:0.11.1` | Remote reference |
| `br/public:avm/res/sql/server:0.21.1` | Remote reference |
| `br/public:avm/res/storage/storage-account:0.29.0` | Remote reference |
| `br/public:avm/res/web/serverfarm:0.5.0` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
