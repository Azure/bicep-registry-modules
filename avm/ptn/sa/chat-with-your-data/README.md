# Chat-with-your-data-Solution-Accelerator `[Sa/ChatWithYourData]`

This module contains the resources required to deploy the [Chat-with-your-data-solution-accelerator](https://github.com/Azure-Samples/chat-with-your-data-solution-accelerator) for both Sandbox environments and WAF aligned environments.

|**Post-Deployment Step** |
|-------------|
| After completing the deployment, follow the steps in the [Post-Deployment Guide](https://github.com/Azure-Samples/chat-with-your-data-solution-accelerator/blob/main/docs/AVMPostDeploymentGuide.md) to configure and verify your environment. |

> **Note:** This module is not intended for broad, generic use, as it was designed by the Commercial Solution Areas CTO team, as a Microsoft Solution Accelerator. Feature requests and bug fix requests are welcome if they support the needs of this organization but may not be incorporated if they aim to make this module more generic than what it needs to be for its primary use case. This module will likely be updated to leverage AVM resource modules in the future. This may result in breaking changes in upcoming versions when these features are implemented.


You can reference the module as follows:
```bicep
module chatWithYourData 'br/public:avm/ptn/sa/chat-with-your-data:<version>' = {
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
| `Microsoft.App/containerApps` | 2026-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.app_containerapps.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2026-01-01/containerApps)</li></ul> |
| `Microsoft.App/containerApps/authConfigs` | 2026-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.app_containerapps_authconfigs.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2026-01-01/containerApps/authConfigs)</li></ul> |
| `Microsoft.App/managedEnvironments` | 2025-10-02-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.app_managedenvironments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2025-10-02-preview/managedEnvironments)</li></ul> |
| `Microsoft.App/managedEnvironments/certificates` | 2025-10-02-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.app_managedenvironments_certificates.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2025-10-02-preview/managedEnvironments/certificates)</li></ul> |
| `Microsoft.App/managedEnvironments/storages` | 2025-10-02-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.app_managedenvironments_storages.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2025-10-02-preview/managedEnvironments/storages)</li></ul> |
| `Microsoft.Authorization/locks` | 2020-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_locks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks)</li></ul> |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |
| `Microsoft.Automanage/configurationProfileAssignments` | 2022-05-04 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.automanage_configurationprofileassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Automanage/2022-05-04/configurationProfileAssignments)</li></ul> |
| `Microsoft.CognitiveServices/accounts` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cognitiveservices_accounts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2025-06-01/accounts)</li></ul> |
| `Microsoft.CognitiveServices/accounts/commitmentPlans` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cognitiveservices_accounts_commitmentplans.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2025-06-01/accounts/commitmentPlans)</li></ul> |
| `Microsoft.CognitiveServices/accounts/defenderForAISettings` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cognitiveservices_accounts_defenderforaisettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2025-06-01/accounts/defenderForAISettings)</li></ul> |
| `Microsoft.CognitiveServices/accounts/deployments` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cognitiveservices_accounts_deployments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2025-06-01/accounts/deployments)</li></ul> |
| `Microsoft.CognitiveServices/accounts/deployments` | 2025-12-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cognitiveservices_accounts_deployments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2025-12-01/accounts/deployments)</li></ul> |
| `Microsoft.CognitiveServices/accounts/deployments` | 2026-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cognitiveservices_accounts_deployments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2026-05-01/accounts/deployments)</li></ul> |
| `Microsoft.CognitiveServices/accounts/projects` | 2025-12-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cognitiveservices_accounts_projects.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2025-12-01/accounts/projects)</li></ul> |
| `Microsoft.CognitiveServices/accounts/projects/connections` | 2025-12-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cognitiveservices_accounts_projects_connections.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2025-12-01/accounts/projects/connections)</li></ul> |
| `Microsoft.Compute/disks` | 2025-01-02 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.compute_disks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2025-01-02/disks)</li></ul> |
| `Microsoft.Compute/proximityPlacementGroups` | 2022-08-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.compute_proximityplacementgroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2022-08-01/proximityPlacementGroups)</li></ul> |
| `Microsoft.Compute/virtualMachines` | 2024-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.compute_virtualmachines.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2024-07-01/virtualMachines)</li></ul> |
| `Microsoft.Compute/virtualMachines/extensions` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.compute_virtualmachines_extensions.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2024-11-01/virtualMachines/extensions)</li></ul> |
| `Microsoft.ContainerRegistry/registries` | 2025-06-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerregistry_registries.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2025-06-01-preview/registries)</li></ul> |
| `Microsoft.ContainerRegistry/registries/cacheRules` | 2025-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerregistry_registries_cacherules.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2025-11-01/registries/cacheRules)</li></ul> |
| `Microsoft.ContainerRegistry/registries/credentialSets` | 2025-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerregistry_registries_credentialsets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2025-11-01/registries/credentialSets)</li></ul> |
| `Microsoft.ContainerRegistry/registries/replications` | 2025-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerregistry_registries_replications.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2025-11-01/registries/replications)</li></ul> |
| `Microsoft.ContainerRegistry/registries/scopeMaps` | 2025-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerregistry_registries_scopemaps.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2025-11-01/registries/scopeMaps)</li></ul> |
| `Microsoft.ContainerRegistry/registries/tasks` | 2025-03-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerregistry_registries_tasks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2025-03-01-preview/registries/tasks)</li></ul> |
| `Microsoft.ContainerRegistry/registries/tokens` | 2025-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerregistry_registries_tokens.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2025-11-01/registries/tokens)</li></ul> |
| `Microsoft.ContainerRegistry/registries/webhooks` | 2025-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerregistry_registries_webhooks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2025-11-01/registries/webhooks)</li></ul> |
| `Microsoft.DBforPostgreSQL/flexibleServers` | 2026-01-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.dbforpostgresql_flexibleservers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2026-01-01-preview/flexibleServers)</li></ul> |
| `Microsoft.DBforPostgreSQL/flexibleServers/administrators` | 2026-01-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.dbforpostgresql_flexibleservers_administrators.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2026-01-01-preview/flexibleServers/administrators)</li></ul> |
| `Microsoft.DBforPostgreSQL/flexibleServers/advancedThreatProtectionSettings` | 2026-01-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.dbforpostgresql_flexibleservers_advancedthreatprotectionsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2026-01-01-preview/flexibleServers/advancedThreatProtectionSettings)</li></ul> |
| `Microsoft.DBforPostgreSQL/flexibleServers/configurations` | 2024-08-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.dbforpostgresql_flexibleservers_configurations.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2024-08-01/flexibleServers/configurations)</li></ul> |
| `Microsoft.DBforPostgreSQL/flexibleServers/configurations` | 2026-01-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.dbforpostgresql_flexibleservers_configurations.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2026-01-01-preview/flexibleServers/configurations)</li></ul> |
| `Microsoft.DBforPostgreSQL/flexibleServers/databases` | 2026-01-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.dbforpostgresql_flexibleservers_databases.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2026-01-01-preview/flexibleServers/databases)</li></ul> |
| `Microsoft.DBforPostgreSQL/flexibleServers/firewallRules` | 2026-01-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.dbforpostgresql_flexibleservers_firewallrules.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2026-01-01-preview/flexibleServers/firewallRules)</li></ul> |
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
| `Microsoft.EventGrid/systemTopics` | 2025-02-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.eventgrid_systemtopics.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventGrid/2025-02-15/systemTopics)</li></ul> |
| `Microsoft.EventGrid/systemTopics/eventSubscriptions` | 2025-02-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.eventgrid_systemtopics_eventsubscriptions.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventGrid/2025-02-15/systemTopics/eventSubscriptions)</li></ul> |
| `Microsoft.GuestConfiguration/guestConfigurationAssignments` | 2024-04-05 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.guestconfiguration_guestconfigurationassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.GuestConfiguration/2024-04-05/guestConfigurationAssignments)</li></ul> |
| `Microsoft.Insights/components` | 2020-02-02 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_components.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2020-02-02/components)</li></ul> |
| `microsoft.insights/components/linkedStorageAccounts` | 2020-03-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_components_linkedstorageaccounts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/microsoft.insights/2020-03-01-preview/components/linkedStorageAccounts)</li></ul> |
| `Microsoft.Insights/dataCollectionRuleAssociations` | 2024-03-11 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_datacollectionruleassociations.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2024-03-11/dataCollectionRuleAssociations)</li></ul> |
| `Microsoft.Insights/dataCollectionRules` | 2024-03-11 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_datacollectionrules.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2024-03-11/dataCollectionRules)</li></ul> |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_diagnosticsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)</li></ul> |
| `Microsoft.KeyVault/vaults/secrets` | 2025-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults_secrets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2025-05-01/vaults/secrets)</li></ul> |
| `Microsoft.KeyVault/vaults/secrets` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults_secrets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2024-11-01/vaults/secrets)</li></ul> |
| `Microsoft.Maintenance/configurationAssignments` | 2023-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.maintenance_configurationassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Maintenance/2023-04-01/configurationAssignments)</li></ul> |
| `Microsoft.Maintenance/maintenanceConfigurations` | 2023-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.maintenance_maintenanceconfigurations.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Maintenance/2023-04-01/maintenanceConfigurations)</li></ul> |
| `Microsoft.ManagedIdentity/userAssignedIdentities` | 2024-11-30 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.managedidentity_userassignedidentities.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2024-11-30/userAssignedIdentities)</li></ul> |
| `Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials` | 2024-11-30 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.managedidentity_userassignedidentities_federatedidentitycredentials.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2024-11-30/userAssignedIdentities/federatedIdentityCredentials)</li></ul> |
| `Microsoft.Network/bastionHosts` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_bastionhosts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-01-01/bastionHosts)</li></ul> |
| `Microsoft.Network/networkInterfaces` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_networkinterfaces.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/networkInterfaces)</li></ul> |
| `Microsoft.Network/networkSecurityGroups` | 2025-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_networksecuritygroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-05-01/networkSecurityGroups)</li></ul> |
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
| `Microsoft.Network/privateEndpoints` | 2025-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-05-01/privateEndpoints)</li></ul> |
| `Microsoft.Network/privateEndpoints` | 2024-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-10-01/privateEndpoints)</li></ul> |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2024-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints_privatednszonegroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-10-01/privateEndpoints/privateDnsZoneGroups)</li></ul> |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2025-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints_privatednszonegroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-05-01/privateEndpoints/privateDnsZoneGroups)</li></ul> |
| `Microsoft.Network/publicIPAddresses` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_publicipaddresses.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-01-01/publicIPAddresses)</li></ul> |
| `Microsoft.Network/virtualNetworks` | 2025-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_virtualnetworks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-05-01/virtualNetworks)</li></ul> |
| `Microsoft.Network/virtualNetworks/subnets` | 2025-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_virtualnetworks_subnets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-05-01/virtualNetworks/subnets)</li></ul> |
| `Microsoft.Network/virtualNetworks/virtualNetworkPeerings` | 2025-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_virtualnetworks_virtualnetworkpeerings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-05-01/virtualNetworks/virtualNetworkPeerings)</li></ul> |
| `Microsoft.OperationalInsights/workspaces` | 2025-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationalinsights_workspaces.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2025-07-01/workspaces)</li></ul> |
| `Microsoft.OperationalInsights/workspaces/dataExports` | 2025-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationalinsights_workspaces_dataexports.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2025-07-01/workspaces/dataExports)</li></ul> |
| `Microsoft.OperationalInsights/workspaces/dataSources` | 2025-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationalinsights_workspaces_datasources.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2025-07-01/workspaces/dataSources)</li></ul> |
| `Microsoft.OperationalInsights/workspaces/linkedServices` | 2025-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationalinsights_workspaces_linkedservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2025-07-01/workspaces/linkedServices)</li></ul> |
| `Microsoft.OperationalInsights/workspaces/linkedStorageAccounts` | 2025-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationalinsights_workspaces_linkedstorageaccounts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2025-07-01/workspaces/linkedStorageAccounts)</li></ul> |
| `Microsoft.OperationalInsights/workspaces/savedSearches` | 2025-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationalinsights_workspaces_savedsearches.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2025-07-01/workspaces/savedSearches)</li></ul> |
| `Microsoft.OperationalInsights/workspaces/storageInsightConfigs` | 2025-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationalinsights_workspaces_storageinsightconfigs.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2025-07-01/workspaces/storageInsightConfigs)</li></ul> |
| `Microsoft.OperationalInsights/workspaces/tables` | 2025-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationalinsights_workspaces_tables.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2025-07-01/workspaces/tables)</li></ul> |
| `Microsoft.OperationsManagement/solutions` | 2015-11-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationsmanagement_solutions.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationsManagement/2015-11-01-preview/solutions)</li></ul> |
| `Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems` | 2025-02-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.recoveryservices_vaults_backupfabrics_protectioncontainers_protecteditems.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2025-02-01/vaults/backupFabrics/protectionContainers/protectedItems)</li></ul> |
| `Microsoft.Resources/tags` | 2025-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.resources_tags.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2025-04-01/tags)</li></ul> |
| `Microsoft.Search/searchServices` | 2025-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.search_searchservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Search/2025-05-01/searchServices)</li></ul> |
| `Microsoft.Search/searchServices/sharedPrivateLinkResources` | 2025-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.search_searchservices_sharedprivatelinkresources.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Search/2025-05-01/searchServices/sharedPrivateLinkResources)</li></ul> |
| `Microsoft.SecurityInsights/onboardingStates` | 2025-09-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.securityinsights_onboardingstates.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.SecurityInsights/2025-09-01/onboardingStates)</li></ul> |
| `Microsoft.Storage/storageAccounts` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-06-01/storageAccounts)</li></ul> |
| `Microsoft.Storage/storageAccounts/blobServices` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_blobservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-01-01/storageAccounts/blobServices)</li></ul> |
| `Microsoft.Storage/storageAccounts/blobServices/containers` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_blobservices_containers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-01-01/storageAccounts/blobServices/containers)</li></ul> |
| `Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_blobservices_containers_immutabilitypolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-01-01/storageAccounts/blobServices/containers/immutabilityPolicies)</li></ul> |
| `Microsoft.Storage/storageAccounts/fileServices` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_fileservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-06-01/storageAccounts/fileServices)</li></ul> |
| `Microsoft.Storage/storageAccounts/fileServices/shares` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_fileservices_shares.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-01-01/storageAccounts/fileServices/shares)</li></ul> |
| `Microsoft.Storage/storageAccounts/localUsers` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_localusers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-06-01/storageAccounts/localUsers)</li></ul> |
| `Microsoft.Storage/storageAccounts/managementPolicies` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_managementpolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-06-01/storageAccounts/managementPolicies)</li></ul> |
| `Microsoft.Storage/storageAccounts/objectReplicationPolicies` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_objectreplicationpolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-01-01/storageAccounts/objectReplicationPolicies)</li></ul> |
| `Microsoft.Storage/storageAccounts/queueServices` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_queueservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-06-01/storageAccounts/queueServices)</li></ul> |
| `Microsoft.Storage/storageAccounts/queueServices/queues` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_queueservices_queues.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-06-01/storageAccounts/queueServices/queues)</li></ul> |
| `Microsoft.Storage/storageAccounts/tableServices` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_tableservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-06-01/storageAccounts/tableServices)</li></ul> |
| `Microsoft.Storage/storageAccounts/tableServices/tables` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_tableservices_tables.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-06-01/storageAccounts/tableServices/tables)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/sa/chat-with-your-data:<version>`.

- [WAF-aligned](#example-1-waf-aligned)

### Example 1: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/waf-aligned]


<details>

<summary>via Bicep module</summary>

```bicep
module chatWithYourData 'br/public:avm/ptn/sa/chat-with-your-data:<version>' = {
  params: {
    // Required parameters
    azureAiServiceLocation: '<azureAiServiceLocation>'
    // Non-required parameters
    embeddingModelCapacity: 10
    enableMonitoring: true
    enablePrivateNetworking: true
    enableRedundancy: true
    enableScalability: true
    enableTelemetry: true
    gptModelCapacity: 10
    location: '<location>'
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
    "embeddingModelCapacity": {
      "value": 10
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
    "gptModelCapacity": {
      "value": 10
    },
    "location": {
      "value": "<location>"
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
using 'br/public:avm/ptn/sa/chat-with-your-data:<version>'

// Required parameters
param azureAiServiceLocation = '<azureAiServiceLocation>'
// Non-required parameters
param embeddingModelCapacity = 10
param enableMonitoring = true
param enablePrivateNetworking = true
param enableRedundancy = true
param enableScalability = true
param enableTelemetry = true
param gptModelCapacity = 10
param location = '<location>'
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
| [`azureAiServiceLocation`](#parameter-azureaiservicelocation) | string | Region for AI Services / Foundry deployments. Restricted to regions with GPT-4.1-mini GlobalStandard availability. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`azureAiAgentApiVersion`](#parameter-azureaiagentapiversion) | string | Azure AI Agent API version (used by the Agent Framework orchestrator). |
| [`azureOpenAiApiVersion`](#parameter-azureopenaiapiversion) | string | Azure OpenAI API version exposed via the OpenAI-compatible endpoint (used by the LangGraph orchestrator). |
| [`createdBy`](#parameter-createdby) | string | Identifier of the user creating the deployment, recorded in the resource group tags. |
| [`databaseType`](#parameter-databasetype) | string | Selects both the chat-history backend and the vector index store. CosmosDB: Cosmos DB + Azure AI Search. PostgreSQL: PostgreSQL Flexible Server with pgvector (Azure AI Search is not deployed). Locked at deploy time. |
| [`deployingUserPrincipalType`](#parameter-deployinguserprincipaltype) | string | Principal type of the deploying user. Use ServicePrincipal for CI/CD pipelines with OIDC. |
| [`embeddingModelCapacity`](#parameter-embeddingmodelcapacity) | int | Token capacity for the embedding model. |
| [`embeddingModelDeploymentType`](#parameter-embeddingmodeldeploymenttype) | string | SKU for the embedding model deployment. |
| [`embeddingModelName`](#parameter-embeddingmodelname) | string | Embedding model deployment name (used by Foundry IQ and the LangGraph indexer). |
| [`embeddingModelVersion`](#parameter-embeddingmodelversion) | string | Embedding model version. |
| [`enableMonitoring`](#parameter-enablemonitoring) | bool | Deploy Log Analytics + Application Insights and wire diagnostic settings on every applicable resource. |
| [`enablePrivateNetworking`](#parameter-enableprivatenetworking) | bool | Deploy a VNet, private endpoints, and disable public network access on data-plane resources. Wires the regional VNet (`modules/virtualNetwork.bicep`), private DNS zones, private endpoints for every data-plane resource, regional VNet integration for compute, and Bastion. Setting this to true is the WAF-aligned topology and requires no follow-up tasks; flipping it back to false re-enables public endpoints with default firewall rules. |
| [`enableRedundancy`](#parameter-enableredundancy) | bool | Zone-redundant + paired-region failover on databases, App Service Plan, Container Apps, and Storage. |
| [`enableScalability`](#parameter-enablescalability) | bool | Higher SKUs and autoscaling on App Service Plan, Container Apps, Search, and PostgreSQL. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`gptModelCapacity`](#parameter-gptmodelcapacity) | int | Token capacity (thousands of TPM) for the primary chat model. |
| [`gptModelDeploymentType`](#parameter-gptmodeldeploymenttype) | string | SKU for the primary chat model deployment. |
| [`gptModelName`](#parameter-gptmodelname) | string | Primary chat model deployment name. |
| [`gptModelVersion`](#parameter-gptmodelversion) | string | Primary chat model version. |
| [`ingestionTrigger`](#parameter-ingestiontrigger) | string | How an uploaded document is picked up for indexing. direct_enqueue: the backend admin upload enqueues the doc-processing message itself (works without an Event Grid subscription). event_grid: a storage Event Grid subscription fans BlobCreated/BlobDeleted to the blob-events queue and the blob_event Function translates each (create -> ingest, delete -> de-index), so the backend writes the blob only (no double-ingest). Flip to event_grid only after the blob_event Function blueprint is deployed. |
| [`location`](#parameter-location) | string | Azure region for non-AI resources (Container Apps, App Service, Functions, Storage, Cosmos/Postgres). Restricted to the 4 regions where all three redundancy guarantees hold simultaneously: PostgreSQL Flexible Server ZoneRedundant HA (3 AZs), Cosmos DB automatic failover with paired-region replicas, and Storage GZRS. Independent of azureAiServiceLocation, which selects the model-availability region. Source: https://learn.microsoft.com/azure/reliability/regions-list and https://learn.microsoft.com/azure/postgresql/flexible-server/overview#azure-regions. |
| [`reasoningModelCapacity`](#parameter-reasoningmodelcapacity) | int | Token capacity for the reasoning model. |
| [`reasoningModelDeploymentType`](#parameter-reasoningmodeldeploymenttype) | string | SKU for the reasoning model deployment. |
| [`reasoningModelName`](#parameter-reasoningmodelname) | string | Reasoning model deployment name (surfaced via the SSE reasoning channel). |
| [`reasoningModelVersion`](#parameter-reasoningmodelversion) | string | Reasoning model version. |
| [`searchIndexName`](#parameter-searchindexname) | string | Chat index name the azure_search provider reads/writes and post_provision.py creates. Single-sourced so the backend env binding and the azd output (consumed by the postdeploy seed self-check) cannot diverge. |
| [`searchKnowledgeBaseApiVersion`](#parameter-searchknowledgebaseapiversion) | string | Foundry IQ knowledge base / knowledge source REST API version (operator-tunable so the KB protocol can advance without a new image). |
| [`searchKnowledgeBaseName`](#parameter-searchknowledgebasename) | string | Foundry IQ knowledge base name the agent_framework orchestrator grounds on (cosmosdb mode). Must match the name seeded by post_provision.py and resolved through the Project-Search connection. |
| [`searchKnowledgeSourceName`](#parameter-searchknowledgesourcename) | string | Foundry IQ knowledge source name backing the knowledge base (the search-index knowledge source seeded by post_provision.py). |
| [`solutionName`](#parameter-solutionname) | string | Unique application/solution name. Drives every resource name. Cap is 15 chars to keep PostgreSQL Flexible Server names within limits. |
| [`solutionUniqueText`](#parameter-solutionuniquetext) | string | Short unique suffix appended to global resource names. Defaults to a 5-char hash of subscription + RG + solution name. |
| [`tags`](#parameter-tags) | object | Tags applied to every deployed resource. |
| [`vmAdminPassword`](#parameter-vmadminpassword) | securestring | VM admin password (AVM-WAF only, when private networking is enabled). |
| [`vmAdminUsername`](#parameter-vmadminusername) | securestring | VM admin username (AVM-WAF only, when private networking is enabled). |
| [`vmSize`](#parameter-vmsize) | string | VM size for jumpbox (AVM-WAF only). Defaults to Standard_D2s_v3. |

### Parameter: `azureAiServiceLocation`

Region for AI Services / Foundry deployments. Restricted to regions with GPT-4.1-mini GlobalStandard availability.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'australiaeast'
    'canadaeast'
    'eastus2'
    'japaneast'
    'koreacentral'
    'polandcentral'
    'swedencentral'
    'switzerlandnorth'
    'uaenorth'
    'uksouth'
    'westus3'
  ]
  ```

### Parameter: `azureAiAgentApiVersion`

Azure AI Agent API version (used by the Agent Framework orchestrator).

- Required: No
- Type: string
- Default: `'2025-05-01'`

### Parameter: `azureOpenAiApiVersion`

Azure OpenAI API version exposed via the OpenAI-compatible endpoint (used by the LangGraph orchestrator).

- Required: No
- Type: string
- Default: `'2025-01-01-preview'`

### Parameter: `createdBy`

Identifier of the user creating the deployment, recorded in the resource group tags.

- Required: No
- Type: string
- Default: `[if(contains(deployer(), 'userPrincipalName'), split(deployer().userPrincipalName, '@')[0], deployer().objectId)]`

### Parameter: `databaseType`

Selects both the chat-history backend and the vector index store. CosmosDB: Cosmos DB + Azure AI Search. PostgreSQL: PostgreSQL Flexible Server with pgvector (Azure AI Search is not deployed). Locked at deploy time.

- Required: No
- Type: string
- Default: `'cosmosdb'`
- Allowed:
  ```Bicep
  [
    'cosmosdb'
    'postgresql'
  ]
  ```

### Parameter: `deployingUserPrincipalType`

Principal type of the deploying user. Use ServicePrincipal for CI/CD pipelines with OIDC.

- Required: No
- Type: string
- Default: `'User'`
- Allowed:
  ```Bicep
  [
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `embeddingModelCapacity`

Token capacity for the embedding model.

- Required: No
- Type: int
- Default: `100`
- MinValue: 1

### Parameter: `embeddingModelDeploymentType`

SKU for the embedding model deployment.

- Required: No
- Type: string
- Default: `'Standard'`
- Allowed:
  ```Bicep
  [
    'GlobalStandard'
    'Standard'
  ]
  ```

### Parameter: `embeddingModelName`

Embedding model deployment name (used by Foundry IQ and the LangGraph indexer).

- Required: No
- Type: string
- Default: `'text-embedding-3-small'`

### Parameter: `embeddingModelVersion`

Embedding model version.

- Required: No
- Type: string
- Default: `'1'`

### Parameter: `enableMonitoring`

Deploy Log Analytics + Application Insights and wire diagnostic settings on every applicable resource.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enablePrivateNetworking`

Deploy a VNet, private endpoints, and disable public network access on data-plane resources. Wires the regional VNet (`modules/virtualNetwork.bicep`), private DNS zones, private endpoints for every data-plane resource, regional VNet integration for compute, and Bastion. Setting this to true is the WAF-aligned topology and requires no follow-up tasks; flipping it back to false re-enables public endpoints with default firewall rules.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableRedundancy`

Zone-redundant + paired-region failover on databases, App Service Plan, Container Apps, and Storage.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableScalability`

Higher SKUs and autoscaling on App Service Plan, Container Apps, Search, and PostgreSQL.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `gptModelCapacity`

Token capacity (thousands of TPM) for the primary chat model.

- Required: No
- Type: int
- Default: `5`
- MinValue: 1

### Parameter: `gptModelDeploymentType`

SKU for the primary chat model deployment.

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

Primary chat model deployment name.

- Required: No
- Type: string
- Default: `'gpt-4.1-mini'`

### Parameter: `gptModelVersion`

Primary chat model version.

- Required: No
- Type: string
- Default: `'2025-04-14'`

### Parameter: `ingestionTrigger`

How an uploaded document is picked up for indexing. direct_enqueue: the backend admin upload enqueues the doc-processing message itself (works without an Event Grid subscription). event_grid: a storage Event Grid subscription fans BlobCreated/BlobDeleted to the blob-events queue and the blob_event Function translates each (create -> ingest, delete -> de-index), so the backend writes the blob only (no double-ingest). Flip to event_grid only after the blob_event Function blueprint is deployed.

- Required: No
- Type: string
- Default: `'direct_enqueue'`
- Allowed:
  ```Bicep
  [
    'direct_enqueue'
    'event_grid'
  ]
  ```

### Parameter: `location`

Azure region for non-AI resources (Container Apps, App Service, Functions, Storage, Cosmos/Postgres). Restricted to the 4 regions where all three redundancy guarantees hold simultaneously: PostgreSQL Flexible Server ZoneRedundant HA (3 AZs), Cosmos DB automatic failover with paired-region replicas, and Storage GZRS. Independent of azureAiServiceLocation, which selects the model-availability region. Source: https://learn.microsoft.com/azure/reliability/regions-list and https://learn.microsoft.com/azure/postgresql/flexible-server/overview#azure-regions.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `reasoningModelCapacity`

Token capacity for the reasoning model.

- Required: No
- Type: int
- Default: `10`
- MinValue: 1

### Parameter: `reasoningModelDeploymentType`

SKU for the reasoning model deployment.

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

### Parameter: `reasoningModelName`

Reasoning model deployment name (surfaced via the SSE reasoning channel).

- Required: No
- Type: string
- Default: `'gpt-4.1-mini'`

### Parameter: `reasoningModelVersion`

Reasoning model version.

- Required: No
- Type: string
- Default: `'2025-04-14'`

### Parameter: `searchIndexName`

Chat index name the azure_search provider reads/writes and post_provision.py creates. Single-sourced so the backend env binding and the azd output (consumed by the postdeploy seed self-check) cannot diverge.

- Required: No
- Type: string
- Default: `'cwyd-index'`

### Parameter: `searchKnowledgeBaseApiVersion`

Foundry IQ knowledge base / knowledge source REST API version (operator-tunable so the KB protocol can advance without a new image).

- Required: No
- Type: string
- Default: `'2025-11-01-preview'`

### Parameter: `searchKnowledgeBaseName`

Foundry IQ knowledge base name the agent_framework orchestrator grounds on (cosmosdb mode). Must match the name seeded by post_provision.py and resolved through the Project-Search connection.

- Required: No
- Type: string
- Default: `'cwyd-kb'`

### Parameter: `searchKnowledgeSourceName`

Foundry IQ knowledge source name backing the knowledge base (the search-index knowledge source seeded by post_provision.py).

- Required: No
- Type: string
- Default: `'cwyd-index-ks'`

### Parameter: `solutionName`

Unique application/solution name. Drives every resource name. Cap is 15 chars to keep PostgreSQL Flexible Server names within limits.

- Required: No
- Type: string
- Default: `'cwyd'`

### Parameter: `solutionUniqueText`

Short unique suffix appended to global resource names. Defaults to a 5-char hash of subscription + RG + solution name.

- Required: No
- Type: string
- Default: `[take(uniqueString(subscription().id, resourceGroup().name, parameters('solutionName')), 5)]`

### Parameter: `tags`

Tags applied to every deployed resource.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `vmAdminPassword`

VM admin password (AVM-WAF only, when private networking is enabled).

- Required: No
- Type: securestring
- Default: `''`

### Parameter: `vmAdminUsername`

VM admin username (AVM-WAF only, when private networking is enabled).

- Required: No
- Type: securestring
- Default: `''`

### Parameter: `vmSize`

VM size for jumpbox (AVM-WAF only). Defaults to Standard_D2s_v3.

- Required: No
- Type: string
- Default: `'Standard_D2s_v3'`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `azureAiAgentApiVersion` | string | Azure AI Agents API version pinned for the Foundry Project endpoint. |
| `azureAiProjectEndpoint` | string | Foundry Project endpoint (https://<account>.services.ai.azure.com/api/projects/<project>). Required by the Microsoft Agent Framework SDK. |
| `azureAiSearchEndpoint` | string | AI Search service endpoint. Empty in PostgreSQL mode. |
| `azureAiSearchIndex` | string | Chat index name. Exported so the postdeploy seed hook can run its index-population self-check; empty in postgresql mode (no AI Search). |
| `azureAiSearchName` | string | AI Search service name. Empty in PostgreSQL mode. |
| `azureAiServiceLocation` | string | Location of the AI Services account + model deployments (independent of AZURE_LOCATION). |
| `azureAiServicesEndpoint` | string | Unified AI Services (Cognitive Services) endpoint. Used by Document Intelligence and other non-OpenAI AI Services APIs. |
| `azureAppInsightsConnectionString` | string | Application Insights connection string. Empty when enableMonitoring=false. |
| `azureBackendUrl` | string | Public URL of the backend Container App (FastAPI + LangGraph/Agent Framework). |
| `azureBastionName` | string | Bastion host name (for `az network bastion tunnel`). Empty when enablePrivateNetworking=false. |
| `azureContainerRegistryEndpoint` | string | Container Registry login server. |
| `azureContainerRegistryName` | string | Container Registry resource name. |
| `azureContentSafetyEndpoint` | string | Content Safety account endpoint. Backend reads via ContentSafetySettings.endpoint; lifespan gates client construction on this + AZURE_CONTENT_SAFETY_ENABLED. |
| `azureContentSafetyName` | string | Content Safety account name (kind=ContentSafety). Diagnostic surface only — backend builds the client from the endpoint. |
| `azureCosmosAccountName` | string | Cosmos DB account name. Empty in PostgreSQL mode. |
| `azureCosmosEndpoint` | string | Cosmos DB account endpoint (DocumentEndpoint). Empty in PostgreSQL mode. |
| `azureDbType` | string | Selected database engine for chat history + vector index (locked at deploy). |
| `azureDocProcessingQueue` | string | Storage Queue name fed by Event Grid BlobCreated and consumed by the batch_push Function blueprint. |
| `azureDocumentsContainer` | string | Container holding documents to be indexed (Event Grid filter + batch_start source). |
| `azureFrontendUrl` | string | Public URL of the frontend Container App (React/Vite SPA proxy). Backend CORS must allow this origin. |
| `azureFunctionAppName` | string | Function App resource name (used by azd to deploy the function package). |
| `azureFunctionAppUrl` | string | Public URL of the Function App hosting the indexing pipeline. |
| `azureIndexStore` | string | Logical name of the configured vector index store: "AzureSearch" (CosmosDB mode) or "pgvector" (PostgreSQL mode). |
| `azureIngestionTrigger` | string | Ingestion trigger mode for the backend admin upload path: direct_enqueue (backend enqueues) or event_grid (Event Grid + blob_event Function own the push). |
| `azureLocation` | string | Location of the non-AI resources (Container Apps, App Service, Functions, Storage, Cosmos/Postgres). |
| `azureOpenAiApiVersion` | string | OpenAI-compatible API version pinned for the GPT + reasoning deployments. |
| `azureOpenAiEmbeddingDeployment` | string | Deployment name of the embedding model used by the indexing pipeline. |
| `azureOpenAiEndpoint` | string | Effective Azure OpenAI endpoint backends call for chat + reasoning + embedding deployments. When `existingOpenAiName` is set this points at the reused v1 OpenAI account; otherwise it equals AZURE_AI_SERVICES_ENDPOINT (deployments live on the v2 Foundry account). |
| `azureOpenAiGptDeployment` | string | Deployment name of the chat-completions GPT model. |
| `azureOpenAiReasoningDeployment` | string | Deployment name of the o-series reasoning model (output flows on the SSE `reasoning` channel). |
| `azurePostgresAdminPrincipalName` | string | UAMI principal name used by the runtime apps to connect to Postgres. Empty in CosmosDB mode. |
| `azurePostgresDeployerPrincipalName` | string | Deployer principal name registered as Postgres Entra admin (for post_provision.py). Empty in CosmosDB mode or when deployer has no UPN. |
| `azurePostgresEndpoint` | string | Full libpq connection URI for the PostgreSQL Flexible Server (no credentials — the workload supplies an Entra token; the user comes from AZURE_UAMI_CLIENT_ID). Mirrors AZURE_COSMOS_ENDPOINT shape so AzurePostgresSettings reads one var. Empty in CosmosDB mode. |
| `azurePostgresHost` | string | PostgreSQL Flexible Server FQDN (clients add :5432 themselves). Empty in CosmosDB mode. |
| `azurePostgresName` | string | PostgreSQL Flexible Server resource name. Empty in CosmosDB mode. |
| `azureSolutionSuffix` | string | Lower-cased solution suffix used in every downstream resource name. |
| `azureSpeechAccountResourceId` | string | Speech account ARM resource id. Required as the x-ms-cognitiveservices-resource-id header on the AAD-bearer STS issueToken POST. |
| `azureSpeechServiceName` | string | Speech account name (kind=SpeechServices). Backend reads via SpeechSettings.service_name; not used directly by the SDK. |
| `azureSpeechServiceRegion` | string | Speech account region. Browser SDK passes this to SpeechConfig.fromAuthorizationToken(token, region) and the backend uses it to build the regional sts/v1.0/issueToken URL. |
| `azureStorageAccountName` | string | Storage account name (shared by RAG document store, indexing queues, and the Function App deployment package). |
| `azureStorageBlobEndpoint` | string | Primary blob endpoint of the shared storage account (https URL ending in /). Hostname follows the storage cloud-specific suffix. |
| `azureTenantId` | string | Tenant ID for the deployment subscription. |
| `azureUamiClientId` | string | Client ID of the user-assigned managed identity shared by all v2 workloads. |
| `azureUamiPrincipalId` | string | Principal (object) ID of the user-assigned managed identity. |
| `azureUamiResourceId` | string | Resource ID of the user-assigned managed identity. |
| `azureVnetName` | string | VNet name. Empty when enablePrivateNetworking=false. |
| `azureVnetResourceId` | string | VNet resource ID. Empty when enablePrivateNetworking=false. |
| `resourceGroupName` | string | Resource group containing the deployment. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/ptn/authorization/resource-role-assignment:0.1.2` | Remote reference |
| `br/public:avm/res/app/container-app:0.23.0` | Remote reference |
| `br/public:avm/res/app/managed-environment:0.15.0` | Remote reference |
| `br/public:avm/res/cognitive-services/account:0.17.0` | Remote reference |
| `br/public:avm/res/cognitive-services/account:0.19.0` | Remote reference |
| `br/public:avm/res/compute/proximity-placement-group:0.4.1` | Remote reference |
| `br/public:avm/res/compute/virtual-machine:0.22.2` | Remote reference |
| `br/public:avm/res/container-registry/registry:0.12.1` | Remote reference |
| `br/public:avm/res/db-for-postgre-sql/flexible-server:0.16.0` | Remote reference |
| `br/public:avm/res/document-db/database-account:0.20.0` | Remote reference |
| `br/public:avm/res/event-grid/system-topic:0.7.0` | Remote reference |
| `br/public:avm/res/insights/component:0.8.0` | Remote reference |
| `br/public:avm/res/insights/data-collection-rule:0.11.0` | Remote reference |
| `br/public:avm/res/maintenance/maintenance-configuration:0.4.0` | Remote reference |
| `br/public:avm/res/managed-identity/user-assigned-identity:0.6.0` | Remote reference |
| `br/public:avm/res/network/bastion-host:0.8.2` | Remote reference |
| `br/public:avm/res/network/network-security-group:0.5.3` | Remote reference |
| `br/public:avm/res/network/private-dns-zone:0.8.1` | Remote reference |
| `br/public:avm/res/network/private-endpoint:0.12.1` | Remote reference |
| `br/public:avm/res/network/virtual-network:0.10.0` | Remote reference |
| `br/public:avm/res/operational-insights/workspace:0.16.0` | Remote reference |
| `br/public:avm/res/search/search-service:0.13.0` | Remote reference |
| `br/public:avm/res/storage/storage-account:0.33.0` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
