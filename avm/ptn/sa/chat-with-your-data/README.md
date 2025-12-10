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
| `Microsoft.Authorization/locks` | 2020-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_locks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks)</li></ul> |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |
| `Microsoft.Automanage/configurationProfileAssignments` | 2022-05-04 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.automanage_configurationprofileassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Automanage/2022-05-04/configurationProfileAssignments)</li></ul> |
| `Microsoft.CognitiveServices/accounts` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cognitiveservices_accounts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2025-06-01/accounts)</li></ul> |
| `Microsoft.CognitiveServices/accounts/commitmentPlans` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cognitiveservices_accounts_commitmentplans.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2025-06-01/accounts/commitmentPlans)</li></ul> |
| `Microsoft.CognitiveServices/accounts/deployments` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cognitiveservices_accounts_deployments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2025-06-01/accounts/deployments)</li></ul> |
| `Microsoft.Compute/disks` | 2024-03-02 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.compute_disks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2024-03-02/disks)</li></ul> |
| `Microsoft.Compute/virtualMachines` | 2024-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.compute_virtualmachines.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2024-07-01/virtualMachines)</li></ul> |
| `Microsoft.Compute/virtualMachines/extensions` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.compute_virtualmachines_extensions.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2024-11-01/virtualMachines/extensions)</li></ul> |
| `Microsoft.DBforPostgreSQL/flexibleServers` | 2025-06-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.dbforpostgresql_flexibleservers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2025-06-01-preview/flexibleServers)</li></ul> |
| `Microsoft.DBforPostgreSQL/flexibleServers/administrators` | 2025-06-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.dbforpostgresql_flexibleservers_administrators.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2025-06-01-preview/flexibleServers/administrators)</li></ul> |
| `Microsoft.DBforPostgreSQL/flexibleServers/advancedThreatProtectionSettings` | 2025-06-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.dbforpostgresql_flexibleservers_advancedthreatprotectionsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2025-06-01-preview/flexibleServers/advancedThreatProtectionSettings)</li></ul> |
| `Microsoft.DBforPostgreSQL/flexibleServers/configurations` | 2025-06-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.dbforpostgresql_flexibleservers_configurations.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2025-06-01-preview/flexibleServers/configurations)</li></ul> |
| `Microsoft.DBforPostgreSQL/flexibleServers/databases` | 2025-06-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.dbforpostgresql_flexibleservers_databases.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2025-06-01-preview/flexibleServers/databases)</li></ul> |
| `Microsoft.DBforPostgreSQL/flexibleServers/firewallRules` | 2025-06-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.dbforpostgresql_flexibleservers_firewallrules.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2025-06-01-preview/flexibleServers/firewallRules)</li></ul> |
| `Microsoft.DevTestLab/schedules` | 2018-09-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.devtestlab_schedules.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevTestLab/2018-09-15/schedules)</li></ul> |
| `Microsoft.DocumentDB/databaseAccounts` | 2024-11-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts)</li></ul> |
| `Microsoft.DocumentDB/databaseAccounts/sqlDatabases` | 2024-11-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_sqldatabases.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/sqlDatabases)</li></ul> |
| `Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers` | 2024-11-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_sqldatabases_containers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/sqlDatabases/containers)</li></ul> |
| `Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments` | 2024-11-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_sqlroleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/sqlRoleAssignments)</li></ul> |
| `Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions` | 2024-11-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.documentdb_databaseaccounts_sqlroledefinitions.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/sqlRoleDefinitions)</li></ul> |
| `Microsoft.EventGrid/systemTopics` | 2025-02-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.eventgrid_systemtopics.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventGrid/2025-02-15/systemTopics)</li></ul> |
| `Microsoft.EventGrid/systemTopics/eventSubscriptions` | 2025-02-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.eventgrid_systemtopics_eventsubscriptions.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventGrid/2025-02-15/systemTopics/eventSubscriptions)</li></ul> |
| `Microsoft.GuestConfiguration/guestConfigurationAssignments` | 2024-04-05 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.guestconfiguration_guestconfigurationassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.GuestConfiguration/2024-04-05/guestConfigurationAssignments)</li></ul> |
| `Microsoft.Insights/components` | 2020-02-02 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_components.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2020-02-02/components)</li></ul> |
| `microsoft.insights/components/linkedStorageAccounts` | 2020-03-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_components_linkedstorageaccounts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/microsoft.insights/2020-03-01-preview/components/linkedStorageAccounts)</li></ul> |
| `Microsoft.Insights/dataCollectionRuleAssociations` | 2023-03-11 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_datacollectionruleassociations.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2023-03-11/dataCollectionRuleAssociations)</li></ul> |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_diagnosticsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)</li></ul> |
| `Microsoft.KeyVault/vaults` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2024-11-01/vaults)</li></ul> |
| `Microsoft.KeyVault/vaults/secrets` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults_secrets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2024-11-01/vaults/secrets)</li></ul> |
| `Microsoft.Maintenance/configurationAssignments` | 2023-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.maintenance_configurationassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Maintenance/2023-04-01/configurationAssignments)</li></ul> |
| `Microsoft.Maintenance/maintenanceConfigurations` | 2023-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.maintenance_maintenanceconfigurations.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Maintenance/2023-04-01/maintenanceConfigurations)</li></ul> |
| `Microsoft.ManagedIdentity/userAssignedIdentities` | 2024-11-30 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.managedidentity_userassignedidentities.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2024-11-30/userAssignedIdentities)</li></ul> |
| `Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials` | 2024-11-30 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.managedidentity_userassignedidentities_federatedidentitycredentials.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2024-11-30/userAssignedIdentities/federatedIdentityCredentials)</li></ul> |
| `Microsoft.Network/bastionHosts` | 2024-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_bastionhosts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-07-01/bastionHosts)</li></ul> |
| `Microsoft.Network/networkInterfaces` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_networkinterfaces.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/networkInterfaces)</li></ul> |
| `Microsoft.Network/networkSecurityGroups` | 2023-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_networksecuritygroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/networkSecurityGroups)</li></ul> |
| `Microsoft.Network/privateDnsZones` | 2020-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privatednszones.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones)</li></ul> |
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
| `Microsoft.Portal/dashboards` | 2020-09-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.portal_dashboards.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Portal/2020-09-01-preview/dashboards)</li></ul> |
| `Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems` | 2025-02-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.recoveryservices_vaults_backupfabrics_protectioncontainers_protecteditems.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2025-02-01/vaults/backupFabrics/protectionContainers/protectedItems)</li></ul> |
| `Microsoft.Resources/deploymentScripts` | 2023-08-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.resources_deploymentscripts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2023-08-01/deploymentScripts)</li></ul> |
| `Microsoft.Resources/deploymentScripts` | 2020-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.resources_deploymentscripts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2020-10-01/deploymentScripts)</li></ul> |
| `Microsoft.Resources/tags` | 2025-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.resources_tags.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2025-04-01/tags)</li></ul> |
| `Microsoft.Search/searchServices` | 2025-02-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.search_searchservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Search/2025-02-01-preview/searchServices)</li></ul> |
| `Microsoft.Search/searchServices/sharedPrivateLinkResources` | 2025-02-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.search_searchservices_sharedprivatelinkresources.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Search/2025-02-01-preview/searchServices/sharedPrivateLinkResources)</li></ul> |
| `Microsoft.SecurityInsights/onboardingStates` | 2024-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.securityinsights_onboardingstates.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.SecurityInsights/2024-03-01/onboardingStates)</li></ul> |
| `Microsoft.Storage/storageAccounts` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts)</li></ul> |
| `Microsoft.Storage/storageAccounts/blobServices` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_blobservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/blobServices)</li></ul> |
| `Microsoft.Storage/storageAccounts/blobServices/containers` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_blobservices_containers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/blobServices/containers)</li></ul> |
| `Microsoft.Storage/storageAccounts/queueServices` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_queueservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/queueServices)</li></ul> |
| `Microsoft.Storage/storageAccounts/queueServices/queues` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_queueservices_queues.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/queueServices/queues)</li></ul> |
| `Microsoft.Web/serverfarms` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.web_serverfarms.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-11-01/serverfarms)</li></ul> |
| `Microsoft.Web/sites` | 2024-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.web_sites.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-04-01/sites)</li></ul> |
| `Microsoft.Web/sites/config` | 2024-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.web_sites_config.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-04-01/sites/config)</li></ul> |
| `Microsoft.Web/sites/host/functionKeys` | 2018-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.web_sites_host_functionkeys.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/sites)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/sa/chat-with-your-data:<version>`.

- [Sandbox With Azure Cosmos DB](#example-1-sandbox-with-azure-cosmos-db)
- [Sandbox With Azure Database for PostgreSQL flexible servers](#example-2-sandbox-with-azure-database-for-postgresql-flexible-servers)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Sandbox With Azure Cosmos DB_

This deploys the sandbox configuration for Chat with your data Solution Accelerator with database as Azure Cosmos DB.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/sandbox-cosmos]


<details>

<summary>via Bicep module</summary>

```bicep
module chatWithYourData 'br/public:avm/ptn/sa/chat-with-your-data:<version>' = {
  params: {
    azureOpenAIEmbeddingModelCapacity: 10
    azureOpenAIModelCapacity: 10
    databaseType: 'CosmosDB'
    location: '<location>'
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
    "azureOpenAIEmbeddingModelCapacity": {
      "value": 10
    },
    "azureOpenAIModelCapacity": {
      "value": 10
    },
    "databaseType": {
      "value": "CosmosDB"
    },
    "location": {
      "value": "<location>"
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
using 'br/public:avm/ptn/sa/chat-with-your-data:<version>'

param azureOpenAIEmbeddingModelCapacity = 10
param azureOpenAIModelCapacity = 10
param databaseType = 'CosmosDB'
param location = '<location>'
param solutionName = '<solutionName>'
```

</details>
<p>

### Example 2: _Sandbox With Azure Database for PostgreSQL flexible servers_

This deploys the sandbox configuration for Chat with your data Solution Accelerator with database as Azure Database for PostgreSQL flexible servers.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/sandbox]


<details>

<summary>via Bicep module</summary>

```bicep
module chatWithYourData 'br/public:avm/ptn/sa/chat-with-your-data:<version>' = {
  params: {
    azureOpenAIEmbeddingModelCapacity: 10
    azureOpenAIModelCapacity: 10
    location: '<location>'
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
    "azureOpenAIEmbeddingModelCapacity": {
      "value": 10
    },
    "azureOpenAIModelCapacity": {
      "value": 10
    },
    "location": {
      "value": "<location>"
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
using 'br/public:avm/ptn/sa/chat-with-your-data:<version>'

param azureOpenAIEmbeddingModelCapacity = 10
param azureOpenAIModelCapacity = 10
param location = '<location>'
param solutionName = '<solutionName>'
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/waf-aligned]


<details>

<summary>via Bicep module</summary>

```bicep
module chatWithYourData 'br/public:avm/ptn/sa/chat-with-your-data:<version>' = {
  params: {
    azureOpenAIEmbeddingModelCapacity: 10
    azureOpenAIModelCapacity: 10
    enableMonitoring: true
    enablePrivateNetworking: true
    enableRedundancy: true
    enableScalability: true
    enableTelemetry: true
    location: '<location>'
    solutionName: '<solutionName>'
    virtualMachineAdminPassword: '<virtualMachineAdminPassword>'
    virtualMachineAdminUsername: 'adminuser'
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
    "azureOpenAIEmbeddingModelCapacity": {
      "value": 10
    },
    "azureOpenAIModelCapacity": {
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
    "location": {
      "value": "<location>"
    },
    "solutionName": {
      "value": "<solutionName>"
    },
    "virtualMachineAdminPassword": {
      "value": "<virtualMachineAdminPassword>"
    },
    "virtualMachineAdminUsername": {
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

param azureOpenAIEmbeddingModelCapacity = 10
param azureOpenAIModelCapacity = 10
param enableMonitoring = true
param enablePrivateNetworking = true
param enableRedundancy = true
param enableScalability = true
param enableTelemetry = true
param location = '<location>'
param solutionName = '<solutionName>'
param virtualMachineAdminPassword = '<virtualMachineAdminPassword>'
param virtualMachineAdminUsername = 'adminuser'
```

</details>
<p>

## Parameters

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`advancedImageProcessingMaxImages`](#parameter-advancedimageprocessingmaximages) | int | The maximum number of images to pass to the vision model in a single request. |
| [`appEnvironment`](#parameter-appenvironment) | string | Application Environment. |
| [`appversion`](#parameter-appversion) | string | Image version tag to use. |
| [`azureOpenAIApiVersion`](#parameter-azureopenaiapiversion) | string | Azure OpenAI Api Version. |
| [`azureOpenAIEmbeddingModel`](#parameter-azureopenaiembeddingmodel) | string | Azure OpenAI Embedding Model Deployment Name. |
| [`azureOpenAIEmbeddingModelCapacity`](#parameter-azureopenaiembeddingmodelcapacity) | int | Azure OpenAI Embedding Model Capacity - See here for more info https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/quota . |
| [`azureOpenAIEmbeddingModelName`](#parameter-azureopenaiembeddingmodelname) | string | Azure OpenAI Embedding Model Name. |
| [`azureOpenAIEmbeddingModelVersion`](#parameter-azureopenaiembeddingmodelversion) | string | Azure OpenAI Embedding Model Version. |
| [`azureOpenAIMaxTokens`](#parameter-azureopenaimaxtokens) | string | Azure OpenAI Max Tokens. |
| [`azureOpenAIModel`](#parameter-azureopenaimodel) | string | Azure OpenAI Model Deployment Name. |
| [`azureOpenAIModelCapacity`](#parameter-azureopenaimodelcapacity) | int | Azure OpenAI Model Capacity - See here for more info  https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/quota. |
| [`azureOpenAIModelName`](#parameter-azureopenaimodelname) | string | Azure OpenAI Model Name. |
| [`azureOpenAIModelVersion`](#parameter-azureopenaimodelversion) | string | Azure OpenAI Model Version. |
| [`azureOpenAISkuName`](#parameter-azureopenaiskuname) | string | Name of Azure OpenAI Resource SKU. |
| [`azureOpenAIStopSequence`](#parameter-azureopenaistopsequence) | string | Azure OpenAI Stop Sequence. |
| [`azureOpenAIStream`](#parameter-azureopenaistream) | string | Whether or not to stream responses from Azure OpenAI. |
| [`azureOpenAISystemMessage`](#parameter-azureopenaisystemmessage) | string | Azure OpenAI System Message. |
| [`azureOpenAITemperature`](#parameter-azureopenaitemperature) | string | Azure OpenAI Temperature. |
| [`azureOpenAITopP`](#parameter-azureopenaitopp) | string | Azure OpenAI Top P. |
| [`azureSearchChunkColumn`](#parameter-azuresearchchunkcolumn) | string | Chunk column. |
| [`azureSearchContentColumn`](#parameter-azuresearchcontentcolumn) | string | Content columns. |
| [`azureSearchConversationLogIndex`](#parameter-azuresearchconversationlogindex) | string | Azure AI Search Conversation Log Index. |
| [`azureSearchEnableInDomain`](#parameter-azuresearchenableindomain) | string | Enable in domain. |
| [`azureSearchFieldId`](#parameter-azuresearchfieldid) | string | Id columns. |
| [`azureSearchFieldsMetadata`](#parameter-azuresearchfieldsmetadata) | string | Metadata column. |
| [`azureSearchFilenameColumn`](#parameter-azuresearchfilenamecolumn) | string | Filename column. |
| [`azureSearchFilter`](#parameter-azuresearchfilter) | string | Search filter. |
| [`azureSearchIndexIsPrechunked`](#parameter-azuresearchindexisprechunked) | string | Is the index prechunked. |
| [`azureSearchLayoutTextColumn`](#parameter-azuresearchlayouttextcolumn) | string | Layout Text column. |
| [`azureSearchOffsetColumn`](#parameter-azuresearchoffsetcolumn) | string | Offset column. |
| [`azureSearchSemanticSearchConfig`](#parameter-azuresearchsemanticsearchconfig) | string | Semantic search config. |
| [`azureSearchSku`](#parameter-azuresearchsku) | string | The SKU of the search service you want to create. E.g. free or standard. |
| [`azureSearchSourceColumn`](#parameter-azuresearchsourcecolumn) | string | Source column. |
| [`azureSearchTextColumn`](#parameter-azuresearchtextcolumn) | string | Text column. |
| [`azureSearchTitleColumn`](#parameter-azuresearchtitlecolumn) | string | Title column. |
| [`azureSearchTopK`](#parameter-azuresearchtopk) | string | Top K results. |
| [`azureSearchUrlColumn`](#parameter-azuresearchurlcolumn) | string | Url column. |
| [`azureSearchUseIntegratedVectorization`](#parameter-azuresearchuseintegratedvectorization) | bool | Whether to use Azure Search Integrated Vectorization. If the database type is PostgreSQL, set this to false. |
| [`azureSearchUseSemanticSearch`](#parameter-azuresearchusesemanticsearch) | bool | Use semantic search. |
| [`azureSearchVectorColumn`](#parameter-azuresearchvectorcolumn) | string | Vector columns. |
| [`computerVisionLocation`](#parameter-computervisionlocation) | string | Location of Computer Vision Resource (if useAdvancedImageProcessing=true). |
| [`computerVisionSkuName`](#parameter-computervisionskuname) | string | Name of Computer Vision Resource SKU (if useAdvancedImageProcessing=true). |
| [`computerVisionVectorizeImageApiVersion`](#parameter-computervisionvectorizeimageapiversion) | string | Azure Computer Vision Vectorize Image API Version. |
| [`computerVisionVectorizeImageModelVersion`](#parameter-computervisionvectorizeimagemodelversion) | string | Azure Computer Vision Vectorize Image Model Version. |
| [`conversationFlow`](#parameter-conversationflow) | string | Chat conversation type: custom or byod. If the database type is PostgreSQL, set this to custom. |
| [`createdBy`](#parameter-createdby) | string | Created by user name. |
| [`databaseType`](#parameter-databasetype) | string | The type of database to deploy (cosmos or postgres). |
| [`enableMonitoring`](#parameter-enablemonitoring) | bool | Enable monitoring applicable resources, aligned with the Well Architected Framework recommendations. This setting enables Application Insights and Log Analytics and configures all the resources applicable resources to send logs. Defaults to false. |
| [`enablePrivateNetworking`](#parameter-enableprivatenetworking) | bool | Enable private networking for applicable resources, aligned with the Well Architected Framework recommendations. Defaults to false. |
| [`enablePurgeProtection`](#parameter-enablepurgeprotection) | bool | Enable purge protection for applicable resources, aligned with the Well Architected Framework recommendations. Defaults to false. |
| [`enableRedundancy`](#parameter-enableredundancy) | bool | Enable redundancy for applicable resources, aligned with the Well Architected Framework recommendations. Defaults to false. |
| [`enableScalability`](#parameter-enablescalability) | bool | Enable scalability for applicable resources, aligned with the Well Architected Framework recommendations. Defaults to false. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`hostingModel`](#parameter-hostingmodel) | string | Hosting model for the web apps. This value is fixed as "container", which uses prebuilt containers for faster deployment. |
| [`hostingPlanSku`](#parameter-hostingplansku) | string | The pricing tier for the App Service plan. |
| [`location`](#parameter-location) | string | Azure region for all services. Regions are restricted to guarantee compatibility with paired regions and replica locations for data redundancy and failover scenarios based on articles [Azure regions list](https://learn.microsoft.com/azure/reliability/regions-list) and [Azure Database for PostgreSQL Flexible Server - Azure Regions](https://learn.microsoft.com/azure/postgresql/flexible-server/overview#azure-regions). Note: In the "Deploy to Azure" interface, you will see both "Region" and "Location" fields - "Region" is only for deployment metadata while "Location" (this parameter) determines where your actual resources are deployed. |
| [`logLevel`](#parameter-loglevel) | string | The log level for application logging. This setting controls the verbosity of logs emitted by the application. Allowed values are CRITICAL, ERROR, WARN, INFO, and DEBUG. The default value is INFO. |
| [`newGuidString`](#parameter-newguidstring) | string | A new GUID string generated for this deployment. This can be used for unique naming if needed. |
| [`orchestrationStrategy`](#parameter-orchestrationstrategy) | string | Orchestration strategy: openai_function or semantic_kernel or langchain str. If you use a old version of turbo (0301), please select langchain. If the database type is PostgreSQL, set this to sementic_kernel. |
| [`principal`](#parameter-principal) | object | Principal object to assign application roles. Format: {"id":"<object-id>", "name":"<name-or-upn>", "type":"User|Group|ServicePrincipal"}. |
| [`recognizedLanguages`](#parameter-recognizedlanguages) | string | List of comma-separated languages to recognize from the speech input. Supported languages are listed here: https://learn.microsoft.com/en-us/azure/ai-services/speech-service/language-support?tabs=stt#supported-languages. |
| [`solutionName`](#parameter-solutionname) | string | A unique application/solution name for all resources in this deployment. This should be 3-16 characters long. |
| [`solutionUniqueText`](#parameter-solutionuniquetext) | string | A unique text value for the solution. This is used to ensure resource names are unique for global resources. Defaults to a 5-character substring of the unique string generated from the subscription ID, resource group name, and solution name. |
| [`tags`](#parameter-tags) | object | The tags to apply to all deployed Azure resources. |
| [`useAdvancedImageProcessing`](#parameter-useadvancedimageprocessing) | bool | Whether to enable the use of a vision LLM and Computer Vision for embedding images. If the database type is PostgreSQL, set this to false. |
| [`virtualMachineAdminPassword`](#parameter-virtualmachineadminpassword) | securestring | The password for the administrator account of the virtual machine. Allows to customize credentials if `enablePrivateNetworking` is set to true. |
| [`virtualMachineAdminUsername`](#parameter-virtualmachineadminusername) | securestring | The user name for the administrator account of the virtual machine. Allows to customize credentials if `enablePrivateNetworking` is set to true. |
| [`vmSize`](#parameter-vmsize) | string | Size of the Jumpbox Virtual Machine when created. Set to custom value if enablePrivateNetworking is true. |

### Parameter: `advancedImageProcessingMaxImages`

The maximum number of images to pass to the vision model in a single request.

- Required: No
- Type: int
- Default: `1`

### Parameter: `appEnvironment`

Application Environment.

- Required: No
- Type: string
- Default: `'Prod'`

### Parameter: `appversion`

Image version tag to use.

- Required: No
- Type: string
- Default: `'latest_waf_2025-11-17_3662'`

### Parameter: `azureOpenAIApiVersion`

Azure OpenAI Api Version.

- Required: No
- Type: string
- Default: `'2024-02-01'`

### Parameter: `azureOpenAIEmbeddingModel`

Azure OpenAI Embedding Model Deployment Name.

- Required: No
- Type: string
- Default: `'text-embedding-ada-002'`

### Parameter: `azureOpenAIEmbeddingModelCapacity`

Azure OpenAI Embedding Model Capacity - See here for more info https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/quota .

- Required: No
- Type: int
- Default: `100`

### Parameter: `azureOpenAIEmbeddingModelName`

Azure OpenAI Embedding Model Name.

- Required: No
- Type: string
- Default: `'text-embedding-ada-002'`

### Parameter: `azureOpenAIEmbeddingModelVersion`

Azure OpenAI Embedding Model Version.

- Required: No
- Type: string
- Default: `'2'`

### Parameter: `azureOpenAIMaxTokens`

Azure OpenAI Max Tokens.

- Required: No
- Type: string
- Default: `'1000'`

### Parameter: `azureOpenAIModel`

Azure OpenAI Model Deployment Name.

- Required: No
- Type: string
- Default: `'gpt-4.1'`

### Parameter: `azureOpenAIModelCapacity`

Azure OpenAI Model Capacity - See here for more info  https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/quota.

- Required: No
- Type: int
- Default: `150`

### Parameter: `azureOpenAIModelName`

Azure OpenAI Model Name.

- Required: No
- Type: string
- Default: `'gpt-4.1'`

### Parameter: `azureOpenAIModelVersion`

Azure OpenAI Model Version.

- Required: No
- Type: string
- Default: `'2025-04-14'`

### Parameter: `azureOpenAISkuName`

Name of Azure OpenAI Resource SKU.

- Required: No
- Type: string
- Default: `'S0'`

### Parameter: `azureOpenAIStopSequence`

Azure OpenAI Stop Sequence.

- Required: No
- Type: string
- Default: `''`

### Parameter: `azureOpenAIStream`

Whether or not to stream responses from Azure OpenAI.

- Required: No
- Type: string
- Default: `'true'`

### Parameter: `azureOpenAISystemMessage`

Azure OpenAI System Message.

- Required: No
- Type: string
- Default: `'You are an AI assistant that helps people find information.'`

### Parameter: `azureOpenAITemperature`

Azure OpenAI Temperature.

- Required: No
- Type: string
- Default: `'0'`

### Parameter: `azureOpenAITopP`

Azure OpenAI Top P.

- Required: No
- Type: string
- Default: `'1'`

### Parameter: `azureSearchChunkColumn`

Chunk column.

- Required: No
- Type: string
- Default: `'chunk'`

### Parameter: `azureSearchContentColumn`

Content columns.

- Required: No
- Type: string
- Default: `'content'`

### Parameter: `azureSearchConversationLogIndex`

Azure AI Search Conversation Log Index.

- Required: No
- Type: string
- Default: `'conversations'`

### Parameter: `azureSearchEnableInDomain`

Enable in domain.

- Required: No
- Type: string
- Default: `'true'`

### Parameter: `azureSearchFieldId`

Id columns.

- Required: No
- Type: string
- Default: `'id'`

### Parameter: `azureSearchFieldsMetadata`

Metadata column.

- Required: No
- Type: string
- Default: `'metadata'`

### Parameter: `azureSearchFilenameColumn`

Filename column.

- Required: No
- Type: string
- Default: `'filename'`

### Parameter: `azureSearchFilter`

Search filter.

- Required: No
- Type: string
- Default: `''`

### Parameter: `azureSearchIndexIsPrechunked`

Is the index prechunked.

- Required: No
- Type: string
- Default: `'false'`

### Parameter: `azureSearchLayoutTextColumn`

Layout Text column.

- Required: No
- Type: string
- Default: `'layoutText'`

### Parameter: `azureSearchOffsetColumn`

Offset column.

- Required: No
- Type: string
- Default: `'offset'`

### Parameter: `azureSearchSemanticSearchConfig`

Semantic search config.

- Required: No
- Type: string
- Default: `'default'`

### Parameter: `azureSearchSku`

The SKU of the search service you want to create. E.g. free or standard.

- Required: No
- Type: string
- Default: `'standard'`
- Allowed:
  ```Bicep
  [
    'basic'
    'free'
    'standard'
    'standard2'
    'standard3'
  ]
  ```

### Parameter: `azureSearchSourceColumn`

Source column.

- Required: No
- Type: string
- Default: `'source'`

### Parameter: `azureSearchTextColumn`

Text column.

- Required: No
- Type: string
- Default: `'text'`

### Parameter: `azureSearchTitleColumn`

Title column.

- Required: No
- Type: string
- Default: `'title'`

### Parameter: `azureSearchTopK`

Top K results.

- Required: No
- Type: string
- Default: `'5'`

### Parameter: `azureSearchUrlColumn`

Url column.

- Required: No
- Type: string
- Default: `'url'`

### Parameter: `azureSearchUseIntegratedVectorization`

Whether to use Azure Search Integrated Vectorization. If the database type is PostgreSQL, set this to false.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `azureSearchUseSemanticSearch`

Use semantic search.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `azureSearchVectorColumn`

Vector columns.

- Required: No
- Type: string
- Default: `'content_vector'`

### Parameter: `computerVisionLocation`

Location of Computer Vision Resource (if useAdvancedImageProcessing=true).

- Required: No
- Type: string
- Default: `''`
- Allowed:
  ```Bicep
  [
    ''
    'eastus'
    'francecentral'
    'koreacentral'
    'northeurope'
    'southeastasia'
    'westeurope'
    'westus'
  ]
  ```

### Parameter: `computerVisionSkuName`

Name of Computer Vision Resource SKU (if useAdvancedImageProcessing=true).

- Required: No
- Type: string
- Default: `'S1'`
- Allowed:
  ```Bicep
  [
    'F0'
    'S1'
  ]
  ```

### Parameter: `computerVisionVectorizeImageApiVersion`

Azure Computer Vision Vectorize Image API Version.

- Required: No
- Type: string
- Default: `'2024-02-01'`

### Parameter: `computerVisionVectorizeImageModelVersion`

Azure Computer Vision Vectorize Image Model Version.

- Required: No
- Type: string
- Default: `'2023-04-15'`

### Parameter: `conversationFlow`

Chat conversation type: custom or byod. If the database type is PostgreSQL, set this to custom.

- Required: No
- Type: string
- Default: `'custom'`
- Allowed:
  ```Bicep
  [
    'byod'
    'custom'
  ]
  ```

### Parameter: `createdBy`

Created by user name.

- Required: No
- Type: string
- Default: `[if(contains(deployer(), 'userPrincipalName'), split(deployer().userPrincipalName, '@')[0], deployer().objectId)]`

### Parameter: `databaseType`

The type of database to deploy (cosmos or postgres).

- Required: No
- Type: string
- Default: `'PostgreSQL'`
- Allowed:
  ```Bicep
  [
    'CosmosDB'
    'PostgreSQL'
  ]
  ```

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

Enable purge protection for applicable resources, aligned with the Well Architected Framework recommendations. Defaults to false.

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

### Parameter: `hostingModel`

Hosting model for the web apps. This value is fixed as "container", which uses prebuilt containers for faster deployment.

- Required: No
- Type: string
- Default: `'container'`

### Parameter: `hostingPlanSku`

The pricing tier for the App Service plan.

- Required: No
- Type: string
- Default: `'B3'`
- Allowed:
  ```Bicep
  [
    'B2'
    'B3'
    'S2'
    'S3'
  ]
  ```

### Parameter: `location`

Azure region for all services. Regions are restricted to guarantee compatibility with paired regions and replica locations for data redundancy and failover scenarios based on articles [Azure regions list](https://learn.microsoft.com/azure/reliability/regions-list) and [Azure Database for PostgreSQL Flexible Server - Azure Regions](https://learn.microsoft.com/azure/postgresql/flexible-server/overview#azure-regions). Note: In the "Deploy to Azure" interface, you will see both "Region" and "Location" fields - "Region" is only for deployment metadata while "Location" (this parameter) determines where your actual resources are deployed.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `logLevel`

The log level for application logging. This setting controls the verbosity of logs emitted by the application. Allowed values are CRITICAL, ERROR, WARN, INFO, and DEBUG. The default value is INFO.

- Required: No
- Type: string
- Default: `'INFO'`
- Allowed:
  ```Bicep
  [
    'CRITICAL'
    'DEBUG'
    'ERROR'
    'INFO'
    'WARN'
  ]
  ```

### Parameter: `newGuidString`

A new GUID string generated for this deployment. This can be used for unique naming if needed.

- Required: No
- Type: string
- Default: `[newGuid()]`

### Parameter: `orchestrationStrategy`

Orchestration strategy: openai_function or semantic_kernel or langchain str. If you use a old version of turbo (0301), please select langchain. If the database type is PostgreSQL, set this to sementic_kernel.

- Required: No
- Type: string
- Default: `'semantic_kernel'`
- Allowed:
  ```Bicep
  [
    'langchain'
    'openai_function'
    'semantic_kernel'
  ]
  ```

### Parameter: `principal`

Principal object to assign application roles. Format: {"id":"<object-id>", "name":"<name-or-upn>", "type":"User|Group|ServicePrincipal"}.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      id: ''
      name: ''
      type: 'User'
  }
  ```

### Parameter: `recognizedLanguages`

List of comma-separated languages to recognize from the speech input. Supported languages are listed here: https://learn.microsoft.com/en-us/azure/ai-services/speech-service/language-support?tabs=stt#supported-languages.

- Required: No
- Type: string
- Default: `'en-US,fr-FR,de-DE,it-IT'`

### Parameter: `solutionName`

A unique application/solution name for all resources in this deployment. This should be 3-16 characters long.

- Required: No
- Type: string
- Default: `'cwyd'`

### Parameter: `solutionUniqueText`

A unique text value for the solution. This is used to ensure resource names are unique for global resources. Defaults to a 5-character substring of the unique string generated from the subscription ID, resource group name, and solution name.

- Required: No
- Type: string
- Default: `[take(uniqueString(subscription().id, resourceGroup().name, parameters('solutionName')), 5)]`

### Parameter: `tags`

The tags to apply to all deployed Azure resources.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `useAdvancedImageProcessing`

Whether to enable the use of a vision LLM and Computer Vision for embedding images. If the database type is PostgreSQL, set this to false.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `virtualMachineAdminPassword`

The password for the administrator account of the virtual machine. Allows to customize credentials if `enablePrivateNetworking` is set to true.

- Required: No
- Type: securestring
- Default: `''`

### Parameter: `virtualMachineAdminUsername`

The user name for the administrator account of the virtual machine. Allows to customize credentials if `enablePrivateNetworking` is set to true.

- Required: No
- Type: securestring
- Default: `''`

### Parameter: `vmSize`

Size of the Jumpbox Virtual Machine when created. Set to custom value if enablePrivateNetworking is true.

- Required: No
- Type: string
- Default: `'Standard_DS2_v2'`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `adminWebsiteUri` | string | Admin web application URI. |
| `advancedImageProcessingMaxImagesOutput` | int | Maximum number of images sent per advanced image processing request. |
| `appEnv` | string | Application environment (e.g., Prod, Dev). |
| `applicationInsightsConnectionString` | string | Connection string for the Application Insights instance. |
| `azureAppServiceHostingModel` | string | App Service hosting model used (code or container). |
| `azureBlobStorageInfoOutput` | string | Blob storage info (container and account). |
| `azureComputerVisionInfoOutput` | string | Computer Vision service information. |
| `azureContentSafetyInfoOutput` | string | Content Safety service endpoint information. |
| `azureCosmosDbInfoOutput` | string | Cosmos DB related information (account/database/container). |
| `azureFormRecognizerInfoOutput` | string | Form Recognizer service endpoint information. |
| `azureLocation` | string | Primary deployment location. |
| `azureOpenAiConfigurationInfoOutput` | string | Azure OpenAI configuration details. |
| `azureOpenAiEmbeddingModelInfoOutput` | string | Azure OpenAI embedding model information. |
| `azureOpenAiModelInfoOutput` | string | Azure OpenAI model information. |
| `azurePostgresDbInfoOutput` | string | PostgreSQL related information (host/database/user). |
| `azureResourceGroup` | string | Name of the resource group. |
| `azureSearchServiceInfoOutput` | string | Azure Cognitive Search service information (if deployed). |
| `azureSearchUseIntegratedVectorizationEnabled` | bool | Whether Azure Search is using integrated vectorization. |
| `azureSpeechServiceInfoOutput` | string | Azure Speech service information. |
| `azureTenantId` | string | Azure tenant identifier. |
| `azureWebJobsStorage` | string | Azure WebJobs Storage connection string for the Functions app. |
| `backendUrlOutput` | string | Backend URL for the function app. |
| `configuredLogLevel` | string | Configured log level for applications. |
| `conversationFlowType` | string | Conversation flow type in use (custom or byod). |
| `databaseTypeSelected` | string | Selected database type for this deployment. |
| `documentProcessingQueueName` | string | Name of the document processing queue. |
| `frontendWebsiteUri` | string | Frontend web application URI. |
| `openAiFunctionsSystemPromptOutput` | string | System prompt for OpenAI functions. |
| `orchestrationStrategyOutput` | string | Orchestration strategy selected (openai_function, semantic_kernel, etc.). |
| `resourceGroupName` | string | Name of the resource group. |
| `resourceToken` | string | Unique token for this solution deployment (short suffix). |
| `semanticKernelSystemPromptOutput` | string | System prompt used by the Semantic Kernel orchestration. |
| `useAdvancedImageProcessingEnabled` | bool | Whether advanced image processing is enabled. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/ptn/authorization/resource-role-assignment:0.1.2` | Remote reference |
| `br/public:avm/res/compute/virtual-machine:0.20.0` | Remote reference |
| `br/public:avm/res/db-for-postgre-sql/flexible-server:0.15.0` | Remote reference |
| `br/public:avm/res/event-grid/system-topic:0.6.4` | Remote reference |
| `br/public:avm/res/insights/component:0.6.0` | Remote reference |
| `br/public:avm/res/maintenance/maintenance-configuration:0.3.2` | Remote reference |
| `br/public:avm/res/managed-identity/user-assigned-identity:0.4.2` | Remote reference |
| `br/public:avm/res/network/bastion-host:0.8.0` | Remote reference |
| `br/public:avm/res/network/network-security-group:0.5.2` | Remote reference |
| `br/public:avm/res/network/private-endpoint:0.11.0` | Remote reference |
| `br/public:avm/res/network/private-endpoint:0.11.1` | Remote reference |
| `br/public:avm/res/network/virtual-network:0.7.1` | Remote reference |
| `br/public:avm/res/operational-insights/workspace:0.12.0` | Remote reference |
| `br/public:avm/res/portal/dashboard:0.3.1` | Remote reference |
| `br/public:avm/res/resources/deployment-script:0.5.1` | Remote reference |
| `br/public:avm/res/search/search-service:0.11.1` | Remote reference |
| `br/public:avm/res/web/serverfarm:0.5.0` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.6.0` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.6.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
