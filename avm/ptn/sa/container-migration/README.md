# Container Migration Solution Accelerator `[Sa/ContainerMigration]`

This module contains the resources required to deploy the [Container Migration Solution Accelerator](https://github.com/microsoft/Container-Migration-Solution-Accelerator) for both Sandbox environments and WAF aligned environments.

|**Post-Deployment Step** |
|-------------|
| After completing the deployment, follow the steps in the [Post-Deployment Guide](https://github.com/microsoft/Container-Migration-Solution-Accelerator/blob/main/docs/AVMPostDeploymentGuide.md) to configure and verify your environment. |

> **Note:** This module is not intended for broad, generic use, as it was designed by the Commercial Solution Areas CTO team, as a Microsoft Solution Accelerator. Feature requests and bug fix requests are welcome if they support the needs of this organization but may not be incorporated if they aim to make this module more generic than what it needs to be for its primary use case. This module will likely be updated to leverage AVM resource modules in the future. This may result in breaking changes in upcoming versions when these features are implemented.


You can reference the module as follows:
```bicep
module containerMigration 'br/public:avm/ptn/sa/container-migration:<version>' = {
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
| `Microsoft.App/containerApps` | 2025-02-02-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.app_containerapps.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2025-02-02-preview/containerApps)</li></ul> |
| `Microsoft.App/containerApps/authConfigs` | 2025-02-02-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.app_containerapps_authconfigs.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2025-02-02-preview/containerApps/authConfigs)</li></ul> |
| `Microsoft.App/managedEnvironments` | 2024-10-02-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.app_managedenvironments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2024-10-02-preview/managedEnvironments)</li></ul> |
| `Microsoft.App/managedEnvironments/certificates` | 2024-10-02-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.app_managedenvironments_certificates.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2024-10-02-preview/managedEnvironments/certificates)</li></ul> |
| `Microsoft.App/managedEnvironments/storages` | 2024-10-02-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.app_managedenvironments_storages.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2024-10-02-preview/managedEnvironments/storages)</li></ul> |
| `Microsoft.AppConfiguration/configurationStores` | 2025-02-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.appconfiguration_configurationstores.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.AppConfiguration/2025-02-01-preview/configurationStores)</li></ul> |
| `Microsoft.AppConfiguration/configurationStores/keyValues` | 2025-02-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.appconfiguration_configurationstores_keyvalues.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.AppConfiguration/2025-02-01-preview/configurationStores/keyValues)</li></ul> |
| `Microsoft.AppConfiguration/configurationStores/replicas` | 2025-02-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.appconfiguration_configurationstores_replicas.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.AppConfiguration/2025-02-01-preview/configurationStores/replicas)</li></ul> |
| `Microsoft.Authorization/locks` | 2020-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_locks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks)</li></ul> |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |
| `Microsoft.Automanage/configurationProfileAssignments` | 2022-05-04 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.automanage_configurationprofileassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Automanage/2022-05-04/configurationProfileAssignments)</li></ul> |
| `Microsoft.CognitiveServices/accounts` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cognitiveservices_accounts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2025-06-01/accounts)</li></ul> |
| `Microsoft.CognitiveServices/accounts/commitmentPlans` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cognitiveservices_accounts_commitmentplans.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2025-06-01/accounts/commitmentPlans)</li></ul> |
| `Microsoft.CognitiveServices/accounts/deployments` | 2024-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cognitiveservices_accounts_deployments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2024-10-01/accounts/deployments)</li></ul> |
| `Microsoft.CognitiveServices/accounts/deployments` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cognitiveservices_accounts_deployments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2025-06-01/accounts/deployments)</li></ul> |
| `Microsoft.CognitiveServices/accounts/projects` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cognitiveservices_accounts_projects.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2025-06-01/accounts/projects)</li></ul> |
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
| `Microsoft.Insights/dataCollectionRuleAssociations` | 2023-03-11 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_datacollectionruleassociations.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2023-03-11/dataCollectionRuleAssociations)</li></ul> |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_diagnosticsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)</li></ul> |
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
| `Microsoft.Network/privateEndpoints` | 2024-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-10-01/privateEndpoints)</li></ul> |
| `Microsoft.Network/privateEndpoints` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/privateEndpoints)</li></ul> |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2024-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints_privatednszonegroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-10-01/privateEndpoints/privateDnsZoneGroups)</li></ul> |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints_privatednszonegroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/privateEndpoints/privateDnsZoneGroups)</li></ul> |
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
| `Microsoft.SecurityInsights/onboardingStates` | 2024-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.securityinsights_onboardingstates.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.SecurityInsights/2024-03-01/onboardingStates)</li></ul> |
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

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/sa/container-migration:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Sandbox configuration with default parameter values](#example-2-sandbox-configuration-with-default-parameter-values)
- [Waf-aligned configuration with default parameter values](#example-3-waf-aligned-configuration-with-default-parameter-values)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/defaults]


<details>

<summary>via Bicep module</summary>

```bicep
module containerMigration 'br/public:avm/ptn/sa/container-migration:<version>' = {
  params: {
    // Required parameters
    azureAiServiceLocation: '<azureAiServiceLocation>'
    solutionName: 'scmdmin'
    // Non-required parameters
    cosmosLocation: '<cosmosLocation>'
    enableMonitoring: false
    enablePrivateNetworking: false
    enableRedundancy: true
    enableScalability: true
    location: '<location>'
    solutionUniqueText: '<solutionUniqueText>'
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
    "solutionName": {
      "value": "scmdmin"
    },
    // Non-required parameters
    "cosmosLocation": {
      "value": "<cosmosLocation>"
    },
    "enableMonitoring": {
      "value": false
    },
    "enablePrivateNetworking": {
      "value": false
    },
    "enableRedundancy": {
      "value": true
    },
    "enableScalability": {
      "value": true
    },
    "location": {
      "value": "<location>"
    },
    "solutionUniqueText": {
      "value": "<solutionUniqueText>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/sa/container-migration:<version>'

// Required parameters
param azureAiServiceLocation = '<azureAiServiceLocation>'
param solutionName = 'scmdmin'
// Non-required parameters
param cosmosLocation = '<cosmosLocation>'
param enableMonitoring = false
param enablePrivateNetworking = false
param enableRedundancy = true
param enableScalability = true
param location = '<location>'
param solutionUniqueText = '<solutionUniqueText>'
```

</details>
<p>

### Example 2: _Sandbox configuration with default parameter values_

This instance deploys the Container Migration Solution Accelerator using only the required parameters. Optional parameters take their default values, which are designed for Sandbox environments.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/sandbox]


<details>

<summary>via Bicep module</summary>

```bicep
module containerMigration 'br/public:avm/ptn/sa/container-migration:<version>' = {
  params: {
    // Required parameters
    azureAiServiceLocation: '<azureAiServiceLocation>'
    solutionName: 'scmmin'
    // Non-required parameters
    aiEmbeddingModelCapacity: 10
    aiModelCapacity: 10
    cosmosLocation: '<cosmosLocation>'
    enableMonitoring: false
    enablePrivateNetworking: false
    enableRedundancy: false
    enableScalability: false
    enableTelemetry: true
    location: '<location>'
    solutionUniqueText: '<solutionUniqueText>'
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
    "solutionName": {
      "value": "scmmin"
    },
    // Non-required parameters
    "aiEmbeddingModelCapacity": {
      "value": 10
    },
    "aiModelCapacity": {
      "value": 10
    },
    "cosmosLocation": {
      "value": "<cosmosLocation>"
    },
    "enableMonitoring": {
      "value": false
    },
    "enablePrivateNetworking": {
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
    "location": {
      "value": "<location>"
    },
    "solutionUniqueText": {
      "value": "<solutionUniqueText>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/sa/container-migration:<version>'

// Required parameters
param azureAiServiceLocation = '<azureAiServiceLocation>'
param solutionName = 'scmmin'
// Non-required parameters
param aiEmbeddingModelCapacity = 10
param aiModelCapacity = 10
param cosmosLocation = '<cosmosLocation>'
param enableMonitoring = false
param enablePrivateNetworking = false
param enableRedundancy = false
param enableScalability = false
param enableTelemetry = true
param location = '<location>'
param solutionUniqueText = '<solutionUniqueText>'
```

</details>
<p>

### Example 3: _Waf-aligned configuration with default parameter values_

This instance deploys the Container Migration Solution Accelerator with WAF-aligned options enabled (private networking, monitoring, redundancy and scalability).

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/waf-aligned]


<details>

<summary>via Bicep module</summary>

```bicep
module containerMigration 'br/public:avm/ptn/sa/container-migration:<version>' = {
  params: {
    // Required parameters
    azureAiServiceLocation: '<azureAiServiceLocation>'
    solutionName: 'scmwaf'
    // Non-required parameters
    aiEmbeddingModelCapacity: 10
    aiModelCapacity: 10
    cosmosLocation: '<cosmosLocation>'
    enableMonitoring: true
    enablePrivateNetworking: true
    enableRedundancy: true
    enableScalability: true
    enableTelemetry: true
    location: '<location>'
    solutionUniqueText: '<solutionUniqueText>'
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
    "solutionName": {
      "value": "scmwaf"
    },
    // Non-required parameters
    "aiEmbeddingModelCapacity": {
      "value": 10
    },
    "aiModelCapacity": {
      "value": 10
    },
    "cosmosLocation": {
      "value": "<cosmosLocation>"
    },
    "enableMonitoring": {
      "value": true
    },
    "enablePrivateNetworking": {
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
    "location": {
      "value": "<location>"
    },
    "solutionUniqueText": {
      "value": "<solutionUniqueText>"
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
using 'br/public:avm/ptn/sa/container-migration:<version>'

// Required parameters
param azureAiServiceLocation = '<azureAiServiceLocation>'
param solutionName = 'scmwaf'
// Non-required parameters
param aiEmbeddingModelCapacity = 10
param aiModelCapacity = 10
param cosmosLocation = '<cosmosLocation>'
param enableMonitoring = true
param enablePrivateNetworking = true
param enableRedundancy = true
param enableScalability = true
param enableTelemetry = true
param location = '<location>'
param solutionUniqueText = '<solutionUniqueText>'
param vmAdminPassword = '<vmAdminPassword>'
param vmAdminUsername = 'adminuser'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`azureAiServiceLocation`](#parameter-azureaiservicelocation) | string | Azure region for AI services (OpenAI/AI Foundry). Must be a region that supports the gpt-5.1 model deployment. |
| [`solutionName`](#parameter-solutionname) | string | A unique application/solution name for all resources in this deployment. This should be 3-16 characters long. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`aiDeploymentType`](#parameter-aideploymenttype) | string | AI model deployment type. Defaults to GlobalStandard. |
| [`aiEmbeddingDeploymentType`](#parameter-aiembeddingdeploymenttype) | string | Embedding model deployment type. Defaults to GlobalStandard. |
| [`aiEmbeddingModelCapacity`](#parameter-aiembeddingmodelcapacity) | int | Embedding model deployment token capacity. Defaults to 500. |
| [`aiEmbeddingModelName`](#parameter-aiembeddingmodelname) | string | Name of the embedding model to deploy. Defaults to text-embedding-3-large. |
| [`aiEmbeddingModelVersion`](#parameter-aiembeddingmodelversion) | string | Version of the embedding model. Defaults to 1. |
| [`aiModelCapacity`](#parameter-aimodelcapacity) | int | AI model deployment token capacity. Lower this if initial provisioning fails due to capacity. Defaults to 500. |
| [`aiModelName`](#parameter-aimodelname) | string | Name of the AI model to deploy. Recommend using gpt-5.1. Defaults to gpt-5.1. |
| [`aiModelVersion`](#parameter-aimodelversion) | string | Version of AI model. Review available version numbers per model before setting. Defaults to 2025-11-13. |
| [`containerRegistryHost`](#parameter-containerregistryhost) | string | The host (excluding https://) of an existing container registry. This is the loginServer when using Azure Container Registry. |
| [`cosmosLocation`](#parameter-cosmoslocation) | string | Azure region used for the Cosmos DB account. Defaults to eastus2. |
| [`createdBy`](#parameter-createdby) | string | Override for the CreatedBy tag. If not provided, will auto-detect from deployment context. |
| [`enableMonitoring`](#parameter-enablemonitoring) | bool | Enable monitoring applicable resources, aligned with the Well Architected Framework recommendations. This setting enables Application Insights and Log Analytics and configures all the resources applicable resources to send logs. Defaults to false. |
| [`enablePrivateNetworking`](#parameter-enableprivatenetworking) | bool | Enable private networking for applicable resources, aligned with the Well Architected Framework recommendations. Defaults to false. |
| [`enablePurgeProtection`](#parameter-enablepurgeprotection) | bool | Enable purge protection for the App Configuration store. When false (default) cleanup can purge the store immediately on resource group teardown, which prevents soft-deleted name collisions in test/CI subscriptions. Set to true for production deployments. |
| [`enableRedundancy`](#parameter-enableredundancy) | bool | Enable redundancy for applicable resources, aligned with the Well Architected Framework recommendations. Defaults to false. |
| [`enableScalability`](#parameter-enablescalability) | bool | Enable scalability for applicable resources, aligned with the Well Architected Framework recommendations. Defaults to false. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`existingFoundryProjectResourceId`](#parameter-existingfoundryprojectresourceid) | string | Resource ID of an existing AI Foundry project. When provided, the pattern reuses the parent Cognitive Services account instead of creating a new one. |
| [`existingLogAnalyticsWorkspaceId`](#parameter-existingloganalyticsworkspaceid) | string | Resource ID of an existing Log Analytics workspace to reuse. When empty, a new workspace is created if monitoring or private networking is enabled. |
| [`imageTag`](#parameter-imagetag) | string | The image tag to use for container images. Defaults to "latest_v2". |
| [`location`](#parameter-location) | string | Azure region for container apps, storage and other services. Choose a region close to your users. Defaults to the resource group location. |
| [`solutionUniqueText`](#parameter-solutionuniquetext) | string | A unique text/token for the solution. Used to ensure resource names are unique for global resources. Defaults to a 5-character substring of the unique string generated from the subscription ID, resource group name and solution name. |
| [`tags`](#parameter-tags) | object | The tags to apply to all deployed Azure resources. |
| [`vmAdminPassword`](#parameter-vmadminpassword) | securestring | Admin password for the Jumpbox Virtual Machine. Set to a custom value when enablePrivateNetworking is true. |
| [`vmAdminUsername`](#parameter-vmadminusername) | securestring | Admin username for the Jumpbox Virtual Machine. Set to a custom value when enablePrivateNetworking is true. |
| [`vmSize`](#parameter-vmsize) | string | Size of the Jumpbox Virtual Machine when created. Set to a custom value when enablePrivateNetworking is true. |

### Parameter: `azureAiServiceLocation`

Azure region for AI services (OpenAI/AI Foundry). Must be a region that supports the gpt-5.1 model deployment.

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
    'norwayeast'
    'southindia'
    'swedencentral'
    'uksouth'
    'westus'
    'westus3'
  ]
  ```

### Parameter: `solutionName`

A unique application/solution name for all resources in this deployment. This should be 3-16 characters long.

- Required: Yes
- Type: string

### Parameter: `aiDeploymentType`

AI model deployment type. Defaults to GlobalStandard.

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

### Parameter: `aiEmbeddingDeploymentType`

Embedding model deployment type. Defaults to GlobalStandard.

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

### Parameter: `aiEmbeddingModelCapacity`

Embedding model deployment token capacity. Defaults to 500.

- Required: No
- Type: int
- Default: `500`
- MinValue: 1

### Parameter: `aiEmbeddingModelName`

Name of the embedding model to deploy. Defaults to text-embedding-3-large.

- Required: No
- Type: string
- Default: `'text-embedding-3-large'`

### Parameter: `aiEmbeddingModelVersion`

Version of the embedding model. Defaults to 1.

- Required: No
- Type: string
- Default: `'1'`

### Parameter: `aiModelCapacity`

AI model deployment token capacity. Lower this if initial provisioning fails due to capacity. Defaults to 500.

- Required: No
- Type: int
- Default: `500`
- MinValue: 1

### Parameter: `aiModelName`

Name of the AI model to deploy. Recommend using gpt-5.1. Defaults to gpt-5.1.

- Required: No
- Type: string
- Default: `'gpt-5.1'`

### Parameter: `aiModelVersion`

Version of AI model. Review available version numbers per model before setting. Defaults to 2025-11-13.

- Required: No
- Type: string
- Default: `'2025-11-13'`

### Parameter: `containerRegistryHost`

The host (excluding https://) of an existing container registry. This is the loginServer when using Azure Container Registry.

- Required: No
- Type: string
- Default: `'containermigrationacr.azurecr.io'`

### Parameter: `cosmosLocation`

Azure region used for the Cosmos DB account. Defaults to eastus2.

- Required: No
- Type: string
- Default: `'eastus2'`

### Parameter: `createdBy`

Override for the CreatedBy tag. If not provided, will auto-detect from deployment context.

- Required: No
- Type: string
- Default: `''`

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

Enable purge protection for the App Configuration store. When false (default) cleanup can purge the store immediately on resource group teardown, which prevents soft-deleted name collisions in test/CI subscriptions. Set to true for production deployments.

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

### Parameter: `existingFoundryProjectResourceId`

Resource ID of an existing AI Foundry project. When provided, the pattern reuses the parent Cognitive Services account instead of creating a new one.

- Required: No
- Type: string
- Default: `''`

### Parameter: `existingLogAnalyticsWorkspaceId`

Resource ID of an existing Log Analytics workspace to reuse. When empty, a new workspace is created if monitoring or private networking is enabled.

- Required: No
- Type: string
- Default: `''`

### Parameter: `imageTag`

The image tag to use for container images. Defaults to "latest_v2".

- Required: No
- Type: string
- Default: `'latest_v2'`

### Parameter: `location`

Azure region for container apps, storage and other services. Choose a region close to your users. Defaults to the resource group location.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `solutionUniqueText`

A unique text/token for the solution. Used to ensure resource names are unique for global resources. Defaults to a 5-character substring of the unique string generated from the subscription ID, resource group name and solution name.

- Required: No
- Type: string
- Default: `[substring(uniqueString(subscription().id, resourceGroup().name, parameters('solutionName')), 0, 5)]`

### Parameter: `tags`

The tags to apply to all deployed Azure resources.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `vmAdminPassword`

Admin password for the Jumpbox Virtual Machine. Set to a custom value when enablePrivateNetworking is true.

- Required: No
- Type: securestring

### Parameter: `vmAdminUsername`

Admin username for the Jumpbox Virtual Machine. Set to a custom value when enablePrivateNetworking is true.

- Required: No
- Type: securestring

### Parameter: `vmSize`

Size of the Jumpbox Virtual Machine when created. Set to a custom value when enablePrivateNetworking is true.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `azureResourceGroup` | string | The Azure resource group name. |
| `azureSubscriptionId` | string | The Azure subscription ID. |
| `containerApiAppFqdn` | string | The FQDN of the backend (API) container app. |
| `containerApiAppName` | string | The name of the backend (API) container app. |
| `containerAppsEnvironmentResourceId` | string | The resource ID of the deployed Container Apps environment. |
| `containerWebAppFqdn` | string | The FQDN of the frontend (web) container app. |
| `containerWebAppName` | string | The name of the frontend (web) container app. |
| `cosmosDbResourceId` | string | The resource ID of the deployed Cosmos DB account. |
| `name` | string | The name of the user-assigned managed identity for the workload. |
| `previewCreatedByTag` | string | Preview of the CreatedBy tag value derived from the deployer. |
| `resourceGroupName` | string | The name of the resource group. |
| `resourceId` | string | The resource ID of the user-assigned managed identity for the workload. |
| `storageAccountResourceId` | string | The resource ID of the deployed storage account. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/app-configuration/configuration-store:0.9.2` | Remote reference |
| `br/public:avm/res/app/container-app:0.19.0` | Remote reference |
| `br/public:avm/res/app/managed-environment:0.11.3` | Remote reference |
| `br/public:avm/res/cognitive-services/account:0.13.2` | Remote reference |
| `br/public:avm/res/compute/virtual-machine:0.20.0` | Remote reference |
| `br/public:avm/res/document-db/database-account:0.18.0` | Remote reference |
| `br/public:avm/res/insights/component:0.6.1` | Remote reference |
| `br/public:avm/res/managed-identity/user-assigned-identity:0.4.2` | Remote reference |
| `br/public:avm/res/network/bastion-host:0.8.0` | Remote reference |
| `br/public:avm/res/network/network-security-group:0.5.2` | Remote reference |
| `br/public:avm/res/network/private-dns-zone:0.8.0` | Remote reference |
| `br/public:avm/res/network/private-endpoint:0.11.1` | Remote reference |
| `br/public:avm/res/network/virtual-network:0.7.1` | Remote reference |
| `br/public:avm/res/operational-insights/workspace:0.12.0` | Remote reference |
| `br/public:avm/res/storage/storage-account:0.28.0` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
