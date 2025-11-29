# Content Processing Solution Accelerator `[Sa/ContentProcessing]`

This module contains the resources required to deploy the [Content Processing solution accelerator](https://github.com/microsoft/content-processing-solution-accelerator) for both Sandbox environments and WAF aligned environments.
> **Note:** This module is not intended for broad, generic use, as it was designed by the Commercial Solution Areas CTO team, as a Microsoft Solution Accelerator. Feature requests and bug fix requests are welcome if they support the needs of this organization but may not be incorporated if they aim to make this module more generic than what it needs to be for its primary use case. This module will likely be updated to leverage AVM resource modules in the future. This may result in breaking changes in upcoming versions when these features are implemented.


You can reference the module as follows:
```bicep
module contentProcessing 'br/public:avm/ptn/sa/content-processing:<version>' = {
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
| `Microsoft.App/containerApps` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.app_containerapps.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2025-01-01/containerApps)</li></ul> |
| `Microsoft.App/containerApps/authConfigs` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.app_containerapps_authconfigs.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2025-01-01/containerApps/authConfigs)</li></ul> |
| `Microsoft.App/managedEnvironments` | 2024-10-02-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.app_managedenvironments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2024-10-02-preview/managedEnvironments)</li></ul> |
| `Microsoft.App/managedEnvironments/certificates` | 2024-10-02-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.app_managedenvironments_certificates.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2024-10-02-preview/managedEnvironments/certificates)</li></ul> |
| `Microsoft.App/managedEnvironments/storages` | 2024-10-02-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.app_managedenvironments_storages.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2024-10-02-preview/managedEnvironments/storages)</li></ul> |
| `Microsoft.AppConfiguration/configurationStores` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.appconfiguration_configurationstores.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.AppConfiguration/2024-05-01/configurationStores)</li></ul> |
| `Microsoft.AppConfiguration/configurationStores/keyValues` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.appconfiguration_configurationstores_keyvalues.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.AppConfiguration/2024-05-01/configurationStores/keyValues)</li></ul> |
| `Microsoft.AppConfiguration/configurationStores/replicas` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.appconfiguration_configurationstores_replicas.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.AppConfiguration/2024-05-01/configurationStores/replicas)</li></ul> |
| `Microsoft.Authorization/locks` | 2020-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_locks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks)</li></ul> |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |
| `Microsoft.CognitiveServices/accounts` | 2025-04-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cognitiveservices_accounts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2025-04-01-preview/accounts)</li></ul> |
| `Microsoft.CognitiveServices/accounts/deployments` | 2025-04-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cognitiveservices_accounts_deployments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2025-04-01-preview/accounts/deployments)</li></ul> |
| `Microsoft.ContainerRegistry/registries` | 2023-06-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerregistry_registries.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-06-01-preview/registries)</li></ul> |
| `Microsoft.ContainerRegistry/registries/cacheRules` | 2023-06-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerregistry_registries_cacherules.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-06-01-preview/registries/cacheRules)</li></ul> |
| `Microsoft.ContainerRegistry/registries/credentialSets` | 2023-11-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerregistry_registries_credentialsets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-11-01-preview/registries/credentialSets)</li></ul> |
| `Microsoft.ContainerRegistry/registries/replications` | 2023-06-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerregistry_registries_replications.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-06-01-preview/registries/replications)</li></ul> |
| `Microsoft.ContainerRegistry/registries/scopeMaps` | 2023-06-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerregistry_registries_scopemaps.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-06-01-preview/registries/scopeMaps)</li></ul> |
| `Microsoft.ContainerRegistry/registries/webhooks` | 2023-06-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerregistry_registries_webhooks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-06-01-preview/registries/webhooks)</li></ul> |
| `Microsoft.DocumentDB/databaseAccounts` | 2024-11-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts)</li></ul> |
| `Microsoft.DocumentDB/databaseAccounts/gremlinDatabases` | 2024-11-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_gremlindatabases.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/gremlinDatabases)</li></ul> |
| `Microsoft.DocumentDB/databaseAccounts/gremlinDatabases/graphs` | 2024-11-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_gremlindatabases_graphs.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/gremlinDatabases/graphs)</li></ul> |
| `Microsoft.DocumentDB/databaseAccounts/mongodbDatabases` | 2024-11-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_mongodbdatabases.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/mongodbDatabases)</li></ul> |
| `Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections` | 2024-11-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_mongodbdatabases_collections.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/mongodbDatabases/collections)</li></ul> |
| `Microsoft.DocumentDB/databaseAccounts/sqlDatabases` | 2024-11-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_sqldatabases.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/sqlDatabases)</li></ul> |
| `Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers` | 2024-11-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_sqldatabases_containers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/sqlDatabases/containers)</li></ul> |
| `Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments` | 2024-11-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_sqlroleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/sqlRoleAssignments)</li></ul> |
| `Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions` | 2024-11-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_sqlroledefinitions.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/sqlRoleDefinitions)</li></ul> |
| `Microsoft.DocumentDB/databaseAccounts/tables` | 2024-11-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_tables.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/tables)</li></ul> |
| `Microsoft.Insights/components` | 2020-02-02 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_components.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2020-02-02/components)</li></ul> |
| `microsoft.insights/components/linkedStorageAccounts` | 2020-03-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_components_linkedstorageaccounts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/microsoft.insights/2020-03-01-preview/components/linkedStorageAccounts)</li></ul> |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_diagnosticsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)</li></ul> |
| `Microsoft.KeyVault/vaults` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2024-11-01/vaults)</li></ul> |
| `Microsoft.KeyVault/vaults/accessPolicies` | 2023-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults_accesspolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2023-07-01/vaults/accessPolicies)</li></ul> |
| `Microsoft.KeyVault/vaults/keys` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults_keys.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2024-11-01/vaults/keys)</li></ul> |
| `Microsoft.KeyVault/vaults/secrets` | 2023-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults_secrets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2023-07-01/vaults/secrets)</li></ul> |
| `Microsoft.KeyVault/vaults/secrets` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults_secrets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2024-11-01/vaults/secrets)</li></ul> |
| `Microsoft.MachineLearningServices/workspaces` | 2024-10-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.machinelearningservices_workspaces.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.MachineLearningServices/2024-10-01-preview/workspaces)</li></ul> |
| `Microsoft.MachineLearningServices/workspaces/computes` | 2024-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.machinelearningservices_workspaces_computes.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.MachineLearningServices/2024-10-01/workspaces/computes)</li></ul> |
| `Microsoft.MachineLearningServices/workspaces/connections` | 2024-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.machinelearningservices_workspaces_connections.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.MachineLearningServices/2024-10-01/workspaces/connections)</li></ul> |
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
| `Microsoft.Network/privateEndpoints` | 2023-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints)</li></ul> |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2023-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints_privatednszonegroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints/privateDnsZoneGroups)</li></ul> |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints_privatednszonegroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/privateEndpoints/privateDnsZoneGroups)</li></ul> |
| `Microsoft.Network/virtualNetworks` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_virtualnetworks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/virtualNetworks)</li></ul> |
| `Microsoft.Network/virtualNetworks/subnets` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_virtualnetworks_subnets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/virtualNetworks/subnets)</li></ul> |
| `Microsoft.Network/virtualNetworks/virtualNetworkPeerings` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_virtualnetworks_virtualnetworkpeerings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-01-01/virtualNetworks/virtualNetworkPeerings)</li></ul> |
| `Microsoft.OperationalInsights/workspaces` | 2023-09-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationalinsights_workspaces.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces)</li></ul> |
| `Microsoft.OperationalInsights/workspaces/dataExports` | 2023-09-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationalinsights_workspaces_dataexports.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces/dataExports)</li></ul> |
| `Microsoft.OperationalInsights/workspaces/dataSources` | 2023-09-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationalinsights_workspaces_datasources.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces/dataSources)</li></ul> |
| `Microsoft.OperationalInsights/workspaces/linkedServices` | 2023-09-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationalinsights_workspaces_linkedservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces/linkedServices)</li></ul> |
| `Microsoft.OperationalInsights/workspaces/linkedStorageAccounts` | 2023-09-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationalinsights_workspaces_linkedstorageaccounts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces/linkedStorageAccounts)</li></ul> |
| `Microsoft.OperationalInsights/workspaces/savedSearches` | 2023-09-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationalinsights_workspaces_savedsearches.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces/savedSearches)</li></ul> |
| `Microsoft.OperationalInsights/workspaces/storageInsightConfigs` | 2023-09-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationalinsights_workspaces_storageinsightconfigs.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces/storageInsightConfigs)</li></ul> |
| `Microsoft.OperationalInsights/workspaces/tables` | 2023-09-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationalinsights_workspaces_tables.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces/tables)</li></ul> |
| `Microsoft.OperationsManagement/solutions` | 2015-11-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationsmanagement_solutions.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationsManagement/2015-11-01-preview/solutions)</li></ul> |
| `Microsoft.SecurityInsights/onboardingStates` | 2024-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.securityinsights_onboardingstates.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.SecurityInsights/2024-03-01/onboardingStates)</li></ul> |
| `Microsoft.Storage/storageAccounts` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts)</li></ul> |
| `Microsoft.Storage/storageAccounts/blobServices` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_blobservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/blobServices)</li></ul> |
| `Microsoft.Storage/storageAccounts/blobServices/containers` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_blobservices_containers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/blobServices/containers)</li></ul> |
| `Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_blobservices_containers_immutabilitypolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/blobServices/containers/immutabilityPolicies)</li></ul> |
| `Microsoft.Storage/storageAccounts/fileServices` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_fileservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/fileServices)</li></ul> |
| `Microsoft.Storage/storageAccounts/fileServices/shares` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_fileservices_shares.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/fileServices/shares)</li></ul> |
| `Microsoft.Storage/storageAccounts/localUsers` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_localusers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/localUsers)</li></ul> |
| `Microsoft.Storage/storageAccounts/managementPolicies` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_managementpolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/managementPolicies)</li></ul> |
| `Microsoft.Storage/storageAccounts/queueServices` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_queueservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/queueServices)</li></ul> |
| `Microsoft.Storage/storageAccounts/queueServices/queues` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_queueservices_queues.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/queueServices/queues)</li></ul> |
| `Microsoft.Storage/storageAccounts/tableServices` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_tableservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/tableServices)</li></ul> |
| `Microsoft.Storage/storageAccounts/tableServices/tables` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_tableservices_tables.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/tableServices/tables)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/sa/content-processing:<version>`.

- [Waf-aligned configuration with default parameter values](#example-1-waf-aligned-configuration-with-default-parameter-values)
- [Sandbox configuration with default parameter values](#example-2-sandbox-configuration-with-default-parameter-values)

### Example 1: _Waf-aligned configuration with default parameter values_

This instance deploys the Content Processing Solution Accelerator

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/enterprise-grade]


<details>

<summary>via Bicep module</summary>

```bicep
module contentProcessing 'br/public:avm/ptn/sa/content-processing:<version>' = {
  params: {
    // Required parameters
    contentUnderstandingLocation: '<contentUnderstandingLocation>'
    environmentName: 'scpeg'
    gptDeploymentCapacity: 1
    // Non-required parameters
    enablePrivateNetworking: true
    enableScaling: true
    enableTelemetry: true
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
    "contentUnderstandingLocation": {
      "value": "<contentUnderstandingLocation>"
    },
    "environmentName": {
      "value": "scpeg"
    },
    "gptDeploymentCapacity": {
      "value": 1
    },
    // Non-required parameters
    "enablePrivateNetworking": {
      "value": true
    },
    "enableScaling": {
      "value": true
    },
    "enableTelemetry": {
      "value": true
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/sa/content-processing:<version>'

// Required parameters
param contentUnderstandingLocation = '<contentUnderstandingLocation>'
param environmentName = 'scpeg'
param gptDeploymentCapacity = 1
// Non-required parameters
param enablePrivateNetworking = true
param enableScaling = true
param enableTelemetry = true
```

</details>
<p>

### Example 2: _Sandbox configuration with default parameter values_

This instance deploys the Content Processing Solution Accelerator using only the required parameters. Optional parameters will take the default values, which are designed for Sandbox environments.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/sandbox]


<details>

<summary>via Bicep module</summary>

```bicep
module contentProcessing 'br/public:avm/ptn/sa/content-processing:<version>' = {
  params: {
    // Required parameters
    contentUnderstandingLocation: '<contentUnderstandingLocation>'
    environmentName: 'scpmin'
    gptDeploymentCapacity: 1
    // Non-required parameters
    enablePrivateNetworking: false
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
    "contentUnderstandingLocation": {
      "value": "<contentUnderstandingLocation>"
    },
    "environmentName": {
      "value": "scpmin"
    },
    "gptDeploymentCapacity": {
      "value": 1
    },
    // Non-required parameters
    "enablePrivateNetworking": {
      "value": false
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/sa/content-processing:<version>'

// Required parameters
param contentUnderstandingLocation = '<contentUnderstandingLocation>'
param environmentName = 'scpmin'
param gptDeploymentCapacity = 1
// Non-required parameters
param enablePrivateNetworking = false
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`contentUnderstandingLocation`](#parameter-contentunderstandinglocation) | string | Location for the content understanding service: WestUS | SwedenCentral | AustraliaEast. |
| [`environmentName`](#parameter-environmentname) | string | Name of the environment to deploy the solution into. |
| [`gptDeploymentCapacity`](#parameter-gptdeploymentcapacity) | int | Capacity of the GPT deployment: (minimum 10). |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiContainerImageName`](#parameter-apicontainerimagename) | string | The Container Image Name to deploy on the Api Container App. |
| [`apiContainerImageTag`](#parameter-apicontainerimagetag) | string | The Container Image Tag to deploy on the backend. |
| [`appContainerImageName`](#parameter-appcontainerimagename) | string | The Container Image Name to deploy on the App Container App. |
| [`appContainerImageTag`](#parameter-appcontainerimagetag) | string | The Container Image Tag to deploy on the backend. |
| [`deploymentTimestamp`](#parameter-deploymenttimestamp) | string | A unique deployment timestamp for solution prefix generation. |
| [`deploymentType`](#parameter-deploymenttype) | string | Type of GPT deployment to use: Standard | GlobalStandard. |
| [`enablePrivateNetworking`](#parameter-enableprivatenetworking) | bool | Enable WAF for the deployment. |
| [`enableScaling`](#parameter-enablescaling) | bool | Enable scaling for the container apps. Defaults to false. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`gptModelName`](#parameter-gptmodelname) | string | Name of the GPT model to deploy: gpt-4o-mini | gpt-4o | gpt-4. |
| [`gptModelVersion`](#parameter-gptmodelversion) | string | Version of the GPT model to deploy:. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`publicContainerImageEndpoint`](#parameter-publiccontainerimageendpoint) | string | The public container image endpoint. |
| [`resourceGroupLocation`](#parameter-resourcegrouplocation) | string | The resource group location. |
| [`resourceNameFormatString`](#parameter-resourcenameformatstring) | string | The resource name format string. |
| [`secondaryLocation`](#parameter-secondarylocation) | string | Location used for Azure Cosmos DB, Azure Container App deployment. |
| [`tags`](#parameter-tags) | object | Tags to be applied to the resources. |
| [`useLocalBuild`](#parameter-uselocalbuild) | bool | Set to true to use local build for container app images, otherwise use container registry images. |
| [`webContainerImageName`](#parameter-webcontainerimagename) | string | The Container Image Name to deploy on the Web Container App. |
| [`webContainerImageTag`](#parameter-webcontainerimagetag) | string | The Container Image Tag to deploy on the Web Container App. |

### Parameter: `contentUnderstandingLocation`

Location for the content understanding service: WestUS | SwedenCentral | AustraliaEast.

- Required: Yes
- Type: string

### Parameter: `environmentName`

Name of the environment to deploy the solution into.

- Required: Yes
- Type: string

### Parameter: `gptDeploymentCapacity`

Capacity of the GPT deployment: (minimum 10).

- Required: Yes
- Type: int
- MinValue: 1

### Parameter: `apiContainerImageName`

The Container Image Name to deploy on the Api Container App.

- Required: No
- Type: string
- Default: `'contentprocessorapi'`

### Parameter: `apiContainerImageTag`

The Container Image Tag to deploy on the backend.

- Required: No
- Type: string
- Default: `'latest'`

### Parameter: `appContainerImageName`

The Container Image Name to deploy on the App Container App.

- Required: No
- Type: string
- Default: `'contentprocessor'`

### Parameter: `appContainerImageTag`

The Container Image Tag to deploy on the backend.

- Required: No
- Type: string
- Default: `'latest'`

### Parameter: `deploymentTimestamp`

A unique deployment timestamp for solution prefix generation.

- Required: No
- Type: string
- Default: `[utcNow()]`

### Parameter: `deploymentType`

Type of GPT deployment to use: Standard | GlobalStandard.

- Required: No
- Type: string
- Default: `'GlobalStandard'`

### Parameter: `enablePrivateNetworking`

Enable WAF for the deployment.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableScaling`

Enable scaling for the container apps. Defaults to false.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `gptModelName`

Name of the GPT model to deploy: gpt-4o-mini | gpt-4o | gpt-4.

- Required: No
- Type: string
- Default: `'gpt-4o'`

### Parameter: `gptModelVersion`

Version of the GPT model to deploy:.

- Required: No
- Type: string
- Default: `'2024-08-06'`
- Allowed:
  ```Bicep
  [
    '2024-08-06'
  ]
  ```

### Parameter: `location`

Location for all Resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `publicContainerImageEndpoint`

The public container image endpoint.

- Required: No
- Type: string
- Default: `'cpscontainerreg.azurecr.io'`

### Parameter: `resourceGroupLocation`

The resource group location.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `resourceNameFormatString`

The resource name format string.

- Required: No
- Type: string
- Default: `'{0}avm-cps'`

### Parameter: `secondaryLocation`

Location used for Azure Cosmos DB, Azure Container App deployment.

- Required: No
- Type: string
- Default: `[if(equals(parameters('location'), 'eastus2'), 'westus2', 'eastus2')]`

### Parameter: `tags`

Tags to be applied to the resources.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      app: 'Content Processing Solution Accelerator'
      location: '[resourceGroup().location]'
  }
  ```

### Parameter: `useLocalBuild`

Set to true to use local build for container app images, otherwise use container registry images.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `webContainerImageName`

The Container Image Name to deploy on the Web Container App.

- Required: No
- Type: string
- Default: `'contentprocessorweb'`

### Parameter: `webContainerImageTag`

The Container Image Tag to deploy on the Web Container App.

- Required: No
- Type: string
- Default: `'latest'`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `containerApiAppFqdn` | string | The resource ID of the Container App API. |
| `containerApiAppName` | string | The resource ID of the Container App API. |
| `containerWebAppFqdn` | string | The resource ID of the Container App Environment. |
| `containerWebAppName` | string | The resource ID of the Container App Environment. |
| `resourceGroupName` | string | The resource group the resources were deployed into. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/app-configuration/configuration-store:0.6.3` | Remote reference |
| `br/public:avm/res/app/container-app:0.17.0` | Remote reference |
| `br/public:avm/res/app/managed-environment:0.11.2` | Remote reference |
| `br/public:avm/res/cognitive-services/account:0.11.0` | Remote reference |
| `br/public:avm/res/container-registry/registry:0.9.1` | Remote reference |
| `br/public:avm/res/document-db/database-account:0.15.0` | Remote reference |
| `br/public:avm/res/insights/component:0.6.0` | Remote reference |
| `br/public:avm/res/key-vault/vault:0.13.0` | Remote reference |
| `br/public:avm/res/machine-learning-services/workspace:0.12.1` | Remote reference |
| `br/public:avm/res/managed-identity/user-assigned-identity:0.4.1` | Remote reference |
| `br/public:avm/res/network/network-security-group:0.5.1` | Remote reference |
| `br/public:avm/res/network/private-dns-zone:0.7.1` | Remote reference |
| `br/public:avm/res/network/virtual-network:0.7.0` | Remote reference |
| `br/public:avm/res/operational-insights/workspace:0.11.2` | Remote reference |
| `br/public:avm/res/storage/storage-account:0.20.0` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
