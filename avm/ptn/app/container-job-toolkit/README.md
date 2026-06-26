# Container job toolkit `[App/ContainerJobToolkit]`

This module deploys a container to run as a job.

You can reference the module as follows:
```bicep
module containerJobToolkit 'br/public:avm/ptn/app/container-job-toolkit:<version>' = {
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
| `Microsoft.App/jobs` | 2025-02-02-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.app_jobs.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2025-02-02-preview/jobs)</li></ul> |
| `Microsoft.App/managedEnvironments` | 2025-10-02-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.app_managedenvironments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2025-10-02-preview/managedEnvironments)</li></ul> |
| `Microsoft.App/managedEnvironments/certificates` | 2025-10-02-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.app_managedenvironments_certificates.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2025-10-02-preview/managedEnvironments/certificates)</li></ul> |
| `Microsoft.App/managedEnvironments/storages` | 2025-10-02-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.app_managedenvironments_storages.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2025-10-02-preview/managedEnvironments/storages)</li></ul> |
| `Microsoft.Authorization/locks` | 2020-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_locks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks)</li></ul> |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |
| `Microsoft.ContainerRegistry/registries` | 2025-06-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerregistry_registries.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2025-06-01-preview/registries)</li></ul> |
| `Microsoft.ContainerRegistry/registries/cacheRules` | 2025-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerregistry_registries_cacherules.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2025-11-01/registries/cacheRules)</li></ul> |
| `Microsoft.ContainerRegistry/registries/credentialSets` | 2025-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerregistry_registries_credentialsets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2025-11-01/registries/credentialSets)</li></ul> |
| `Microsoft.ContainerRegistry/registries/replications` | 2025-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerregistry_registries_replications.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2025-11-01/registries/replications)</li></ul> |
| `Microsoft.ContainerRegistry/registries/scopeMaps` | 2025-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerregistry_registries_scopemaps.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2025-11-01/registries/scopeMaps)</li></ul> |
| `Microsoft.ContainerRegistry/registries/tasks` | 2025-03-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerregistry_registries_tasks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2025-03-01-preview/registries/tasks)</li></ul> |
| `Microsoft.ContainerRegistry/registries/tokens` | 2025-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerregistry_registries_tokens.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2025-11-01/registries/tokens)</li></ul> |
| `Microsoft.ContainerRegistry/registries/webhooks` | 2025-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerregistry_registries_webhooks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2025-11-01/registries/webhooks)</li></ul> |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_diagnosticsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)</li></ul> |
| `Microsoft.KeyVault/vaults` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2024-11-01/vaults)</li></ul> |
| `Microsoft.KeyVault/vaults/accessPolicies` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults_accesspolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2024-11-01/vaults/accessPolicies)</li></ul> |
| `Microsoft.KeyVault/vaults/keys` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults_keys.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2024-11-01/vaults/keys)</li></ul> |
| `Microsoft.KeyVault/vaults/secrets` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults_secrets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2024-11-01/vaults/secrets)</li></ul> |
| `Microsoft.ManagedIdentity/userAssignedIdentities` | 2024-11-30 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.managedidentity_userassignedidentities.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2024-11-30/userAssignedIdentities)</li></ul> |
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
| `Microsoft.Network/privateEndpoints` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/privateEndpoints)</li></ul> |
| `Microsoft.Network/privateEndpoints` | 2024-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-10-01/privateEndpoints)</li></ul> |
| `Microsoft.Network/privateEndpoints` | 2025-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-05-01/privateEndpoints)</li></ul> |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2024-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints_privatednszonegroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-10-01/privateEndpoints/privateDnsZoneGroups)</li></ul> |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints_privatednszonegroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/privateEndpoints/privateDnsZoneGroups)</li></ul> |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2025-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints_privatednszonegroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-05-01/privateEndpoints/privateDnsZoneGroups)</li></ul> |
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
| `Microsoft.Resources/deploymentScripts` | 2023-08-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.resources_deploymentscripts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2023-08-01/deploymentScripts)</li></ul> |
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

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/app/container-job-toolkit:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [Align to WAF](#example-3-align-to-waf)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters in a consumption plan.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/defaults]


<details>

<summary>via Bicep module</summary>

```bicep
module containerJobToolkit 'br/public:avm/ptn/app/container-job-toolkit:<version>' = {
  params: {
    // Required parameters
    containerImageSource: 'mcr.microsoft.com/k8se/quickstart-jobs:latest'
    name: 'acjmin001'
    // Non-required parameters
    location: '<location>'
    logAnalyticsWorkspaceResourceId: '<logAnalyticsWorkspaceResourceId>'
    overwriteExistingImage: true
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
    "containerImageSource": {
      "value": "mcr.microsoft.com/k8se/quickstart-jobs:latest"
    },
    "name": {
      "value": "acjmin001"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "logAnalyticsWorkspaceResourceId": {
      "value": "<logAnalyticsWorkspaceResourceId>"
    },
    "overwriteExistingImage": {
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
using 'br/public:avm/ptn/app/container-job-toolkit:<version>'

// Required parameters
param containerImageSource = 'mcr.microsoft.com/k8se/quickstart-jobs:latest'
param name = 'acjmin001'
// Non-required parameters
param location = '<location>'
param logAnalyticsWorkspaceResourceId = '<logAnalyticsWorkspaceResourceId>'
param overwriteExistingImage = true
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/max]


<details>

<summary>via Bicep module</summary>

```bicep
module containerJobToolkit 'br/public:avm/ptn/app/container-job-toolkit:<version>' = {
  params: {
    // Required parameters
    containerImageSource: 'mcr.microsoft.com/k8se/quickstart-jobs:latest'
    name: 'acjmax001'
    // Non-required parameters
    addressPrefix: '192.168.0.0/16'
    appInsightsConnectionString: '<appInsightsConnectionString>'
    cpu: '2'
    cronExpression: '0 * * * *'
    customNetworkSecurityGroups: [
      {
        name: 'nsg1'
        properties: {
          access: 'Allow'
          destinationAddressPrefix: '192.168.0.0/16'
          destinationPortRange: '80'
          direction: 'Outbound'
          priority: 300
          protocol: 'Tcp'
          sourceAddressPrefixes: [
            '10.10.10.0/24'
          ]
          sourcePortRange: '*'
        }
      }
    ]
    deployDnsZoneContainerRegistry: false
    deployDnsZoneKeyVault: false
    deployInVnet: true
    environmentVariables: [
      {
        name: 'key1'
        value: 'value1'
      }
      {
        name: 'key2'
        secretRef: 'secretkey1'
      }
    ]
    keyVaultName: '<keyVaultName>'
    keyVaultRoleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Key Vault Secrets Officer'
      }
    ]
    location: '<location>'
    lock: {
      kind: 'None'
      name: 'No lock for testing'
    }
    logAnalyticsWorkspaceResourceId: '<logAnalyticsWorkspaceResourceId>'
    managedIdentityName: 'acjmaxmi'
    managedIdentityResourceId: '<managedIdentityResourceId>'
    memory: '8Gi'
    newContainerImageName: 'application/frontend:latest'
    overwriteExistingImage: true
    registryRoleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'AcrImageSigner'
      }
    ]
    secrets: [
      {
        identity: '<identity>'
        keyVaultUrl: '<keyVaultUrl>'
        name: 'secretkey1'
      }
    ]
    tags: {
      environment: 'test'
    }
    workloadProfileName: 'CAW01'
    workloadProfiles: [
      {
        maximumCount: 1
        minimumCount: 0
        name: 'CAW01'
        workloadProfileType: 'D4'
      }
    ]
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
    "containerImageSource": {
      "value": "mcr.microsoft.com/k8se/quickstart-jobs:latest"
    },
    "name": {
      "value": "acjmax001"
    },
    // Non-required parameters
    "addressPrefix": {
      "value": "192.168.0.0/16"
    },
    "appInsightsConnectionString": {
      "value": "<appInsightsConnectionString>"
    },
    "cpu": {
      "value": "2"
    },
    "cronExpression": {
      "value": "0 * * * *"
    },
    "customNetworkSecurityGroups": {
      "value": [
        {
          "name": "nsg1",
          "properties": {
            "access": "Allow",
            "destinationAddressPrefix": "192.168.0.0/16",
            "destinationPortRange": "80",
            "direction": "Outbound",
            "priority": 300,
            "protocol": "Tcp",
            "sourceAddressPrefixes": [
              "10.10.10.0/24"
            ],
            "sourcePortRange": "*"
          }
        }
      ]
    },
    "deployDnsZoneContainerRegistry": {
      "value": false
    },
    "deployDnsZoneKeyVault": {
      "value": false
    },
    "deployInVnet": {
      "value": true
    },
    "environmentVariables": {
      "value": [
        {
          "name": "key1",
          "value": "value1"
        },
        {
          "name": "key2",
          "secretRef": "secretkey1"
        }
      ]
    },
    "keyVaultName": {
      "value": "<keyVaultName>"
    },
    "keyVaultRoleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Key Vault Secrets Officer"
        }
      ]
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": {
        "kind": "None",
        "name": "No lock for testing"
      }
    },
    "logAnalyticsWorkspaceResourceId": {
      "value": "<logAnalyticsWorkspaceResourceId>"
    },
    "managedIdentityName": {
      "value": "acjmaxmi"
    },
    "managedIdentityResourceId": {
      "value": "<managedIdentityResourceId>"
    },
    "memory": {
      "value": "8Gi"
    },
    "newContainerImageName": {
      "value": "application/frontend:latest"
    },
    "overwriteExistingImage": {
      "value": true
    },
    "registryRoleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "AcrImageSigner"
        }
      ]
    },
    "secrets": {
      "value": [
        {
          "identity": "<identity>",
          "keyVaultUrl": "<keyVaultUrl>",
          "name": "secretkey1"
        }
      ]
    },
    "tags": {
      "value": {
        "environment": "test"
      }
    },
    "workloadProfileName": {
      "value": "CAW01"
    },
    "workloadProfiles": {
      "value": [
        {
          "maximumCount": 1,
          "minimumCount": 0,
          "name": "CAW01",
          "workloadProfileType": "D4"
        }
      ]
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/app/container-job-toolkit:<version>'

// Required parameters
param containerImageSource = 'mcr.microsoft.com/k8se/quickstart-jobs:latest'
param name = 'acjmax001'
// Non-required parameters
param addressPrefix = '192.168.0.0/16'
param appInsightsConnectionString = '<appInsightsConnectionString>'
param cpu = '2'
param cronExpression = '0 * * * *'
param customNetworkSecurityGroups = [
  {
    name: 'nsg1'
    properties: {
      access: 'Allow'
      destinationAddressPrefix: '192.168.0.0/16'
      destinationPortRange: '80'
      direction: 'Outbound'
      priority: 300
      protocol: 'Tcp'
      sourceAddressPrefixes: [
        '10.10.10.0/24'
      ]
      sourcePortRange: '*'
    }
  }
]
param deployDnsZoneContainerRegistry = false
param deployDnsZoneKeyVault = false
param deployInVnet = true
param environmentVariables = [
  {
    name: 'key1'
    value: 'value1'
  }
  {
    name: 'key2'
    secretRef: 'secretkey1'
  }
]
param keyVaultName = '<keyVaultName>'
param keyVaultRoleAssignments = [
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'Key Vault Secrets Officer'
  }
]
param location = '<location>'
param lock = {
  kind: 'None'
  name: 'No lock for testing'
}
param logAnalyticsWorkspaceResourceId = '<logAnalyticsWorkspaceResourceId>'
param managedIdentityName = 'acjmaxmi'
param managedIdentityResourceId = '<managedIdentityResourceId>'
param memory = '8Gi'
param newContainerImageName = 'application/frontend:latest'
param overwriteExistingImage = true
param registryRoleAssignments = [
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'AcrImageSigner'
  }
]
param secrets = [
  {
    identity: '<identity>'
    keyVaultUrl: '<keyVaultUrl>'
    name: 'secretkey1'
  }
]
param tags = {
  environment: 'test'
}
param workloadProfileName = 'CAW01'
param workloadProfiles = [
  {
    maximumCount: 1
    minimumCount: 0
    name: 'CAW01'
    workloadProfileType: 'D4'
  }
]
```

</details>
<p>

### Example 3: _Align to WAF_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/waf-aligned]


<details>

<summary>via Bicep module</summary>

```bicep
module containerJobToolkit 'br/public:avm/ptn/app/container-job-toolkit:<version>' = {
  params: {
    // Required parameters
    containerImageSource: 'mcr.microsoft.com/k8se/quickstart-jobs:latest'
    name: 'acjwaf001'
    // Non-required parameters
    appInsightsConnectionString: '<appInsightsConnectionString>'
    deployInVnet: true
    location: '<location>'
    logAnalyticsWorkspaceResourceId: '<logAnalyticsWorkspaceResourceId>'
    managedIdentityResourceId: '<managedIdentityResourceId>'
    overwriteExistingImage: true
    tags: {
      Env: 'test'
      'hidden-title': 'This is visible in the resource name'
    }
    workloadProfileName: 'CAW01'
    workloadProfiles: [
      {
        maximumCount: 6
        minimumCount: 3
        name: 'CAW01'
        workloadProfileType: 'D4'
      }
    ]
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
    "containerImageSource": {
      "value": "mcr.microsoft.com/k8se/quickstart-jobs:latest"
    },
    "name": {
      "value": "acjwaf001"
    },
    // Non-required parameters
    "appInsightsConnectionString": {
      "value": "<appInsightsConnectionString>"
    },
    "deployInVnet": {
      "value": true
    },
    "location": {
      "value": "<location>"
    },
    "logAnalyticsWorkspaceResourceId": {
      "value": "<logAnalyticsWorkspaceResourceId>"
    },
    "managedIdentityResourceId": {
      "value": "<managedIdentityResourceId>"
    },
    "overwriteExistingImage": {
      "value": true
    },
    "tags": {
      "value": {
        "Env": "test",
        "hidden-title": "This is visible in the resource name"
      }
    },
    "workloadProfileName": {
      "value": "CAW01"
    },
    "workloadProfiles": {
      "value": [
        {
          "maximumCount": 6,
          "minimumCount": 3,
          "name": "CAW01",
          "workloadProfileType": "D4"
        }
      ]
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/app/container-job-toolkit:<version>'

// Required parameters
param containerImageSource = 'mcr.microsoft.com/k8se/quickstart-jobs:latest'
param name = 'acjwaf001'
// Non-required parameters
param appInsightsConnectionString = '<appInsightsConnectionString>'
param deployInVnet = true
param location = '<location>'
param logAnalyticsWorkspaceResourceId = '<logAnalyticsWorkspaceResourceId>'
param managedIdentityResourceId = '<managedIdentityResourceId>'
param overwriteExistingImage = true
param tags = {
  Env: 'test'
  'hidden-title': 'This is visible in the resource name'
}
param workloadProfileName = 'CAW01'
param workloadProfiles = [
  {
    maximumCount: 6
    minimumCount: 3
    name: 'CAW01'
    workloadProfileType: 'D4'
  }
]
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`containerImageSource`](#parameter-containerimagesource) | string | The container image source that will be copied to the Container Registry and used to provision the job. |
| [`name`](#parameter-name) | string | Name of the resource to create. Will be used for naming the job and other resources. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addressPrefix`](#parameter-addressprefix) | string | The address prefix for the virtual network needs to be at least a /16. Three subnets will be created (the first /24 will be used for private endpoints, the second /24 for service endpoints and the second /23 is used for the workload). Required if `zoneRedundant` for consumption plan is desired or `deployInVnet` is `true`. |
| [`deployDnsZoneContainerRegistry`](#parameter-deploydnszonecontainerregistry) | bool | A new private DNS Zone will be created. Setting to `false` requires an existing private DNS zone `privatelink.azurecr.io`. Required if `deployInVnet` is `true`. |
| [`deployDnsZoneKeyVault`](#parameter-deploydnszonekeyvault) | bool | A new private DNS Zone will be created. Setting to `false` requires an existing private DNS zone `privatelink.vaultcore.azure.net`. Required if `deployInVnet` is `true`. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appInsightsConnectionString`](#parameter-appinsightsconnectionstring) | string | The connection string for the Application Insights instance that will be added to Key Vault as `applicationinsights-connection-string` and can be used by the Job. |
| [`cpu`](#parameter-cpu) | string | The CPU resources that will be allocated to the Container Apps Job. |
| [`cronExpression`](#parameter-cronexpression) | string | The cron expression that will be used to schedule the job. |
| [`customNetworkSecurityGroups`](#parameter-customnetworksecuritygroups) | array | Network security group, that will be added to the workload subnet. |
| [`deployInVnet`](#parameter-deployinvnet) | bool | Deploy resources in a virtual network and use it for private endpoints. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`environmentVariables`](#parameter-environmentvariables) | array | The environment variables that will be added to the Container Apps Job. |
| [`keyVaultName`](#parameter-keyvaultname) | string | The name of the Key Vault that will be created to store the Application Insights connection string and be used for your secrets. |
| [`keyVaultRoleAssignments`](#parameter-keyvaultroleassignments) | array | The permissions that will be assigned to the Key Vault. The managed Identity will be assigned the permissions to get and list secrets. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`logAnalyticsWorkspaceResourceId`](#parameter-loganalyticsworkspaceresourceid) | string | The Log Analytics Resource ID for the Container Apps Environment to use for the job. If not provided, a new Log Analytics workspace will be created. |
| [`managedIdentityName`](#parameter-managedidentityname) | string | The name of the managed identity to create. If not provided, a name will be generated automatically as `jobsUserIdentity-$\{name\}`. |
| [`managedIdentityResourceId`](#parameter-managedidentityresourceid) | string | Use an existing managed identity to import the container image and run the job. If not provided, a new managed identity will be created. |
| [`memory`](#parameter-memory) | string | The memory resources that will be allocated to the Container Apps Job. |
| [`newContainerImageName`](#parameter-newcontainerimagename) | string | The new image name in the ACR. You can use this to import a publically available image with a custom name for later updating from e.g., your build pipeline. You should skip the registry name when specifying a custom value, as it is added automatically. If you leave this empty, the original name will be used (with the new registry name). |
| [`overwriteExistingImage`](#parameter-overwriteexistingimage) | bool | The flag that indicates whether the existing image in the Container Registry should be overwritten. |
| [`registryRoleAssignments`](#parameter-registryroleassignments) | array | The permissions that will be assigned to the Container Registry. The managed Identity will be assigned the permissions to get and list images. |
| [`secrets`](#parameter-secrets) | array | The secrets of the Container App. They will be added to Key Vault and configured as secrets in the Container App Job. The application insights connection string will be added automatically as `applicationinsightsconnectionstring`, if `appInsightsConnectionString` is set. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`workloadProfileName`](#parameter-workloadprofilename) | string | The name of the workload profile to use. Leave empty to use a consumption based profile. |
| [`workloadProfiles`](#parameter-workloadprofiles) | array | Workload profiles for the managed environment. Leave empty to use a consumption based profile. |

### Parameter: `containerImageSource`

The container image source that will be copied to the Container Registry and used to provision the job.

- Required: Yes
- Type: string
- Example: `mcr.microsoft.com/k8se/quickstart-jobs:latest`

### Parameter: `name`

Name of the resource to create. Will be used for naming the job and other resources.

- Required: Yes
- Type: string

### Parameter: `addressPrefix`

The address prefix for the virtual network needs to be at least a /16. Three subnets will be created (the first /24 will be used for private endpoints, the second /24 for service endpoints and the second /23 is used for the workload). Required if `zoneRedundant` for consumption plan is desired or `deployInVnet` is `true`.

- Required: No
- Type: string
- Default: `'10.50.0.0/16'`

### Parameter: `deployDnsZoneContainerRegistry`

A new private DNS Zone will be created. Setting to `false` requires an existing private DNS zone `privatelink.azurecr.io`. Required if `deployInVnet` is `true`.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `deployDnsZoneKeyVault`

A new private DNS Zone will be created. Setting to `false` requires an existing private DNS zone `privatelink.vaultcore.azure.net`. Required if `deployInVnet` is `true`.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `appInsightsConnectionString`

The connection string for the Application Insights instance that will be added to Key Vault as `applicationinsights-connection-string` and can be used by the Job.

- Required: No
- Type: string
- Example: `InstrumentationKey=<00000000-0000-0000-0000-000000000000>;IngestionEndpoint=https://germanywestcentral-1.in.applicationinsights.azure.com/;LiveEndpoint=https://germanywestcentral.livediagnostics.monitor.azure.com/;ApplicationId=<00000000-0000-0000-0000-000000000000>`

### Parameter: `cpu`

The CPU resources that will be allocated to the Container Apps Job.

- Required: No
- Type: string
- Default: `'1'`

### Parameter: `cronExpression`

The cron expression that will be used to schedule the job.

- Required: No
- Type: string
- Default: `'0 0 * * *'`

### Parameter: `customNetworkSecurityGroups`

Network security group, that will be added to the workload subnet.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-customnetworksecuritygroupsname) | string | The name of the security rule. |
| [`properties`](#parameter-customnetworksecuritygroupsproperties) | object | The properties of the security rule. |

### Parameter: `customNetworkSecurityGroups.name`

The name of the security rule.

- Required: Yes
- Type: string

### Parameter: `customNetworkSecurityGroups.properties`

The properties of the security rule.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`access`](#parameter-customnetworksecuritygroupspropertiesaccess) | string | Whether network traffic is allowed or denied. |
| [`direction`](#parameter-customnetworksecuritygroupspropertiesdirection) | string | The direction of the rule. The direction specifies if rule will be evaluated on incoming or outgoing traffic. |
| [`priority`](#parameter-customnetworksecuritygroupspropertiespriority) | int | The priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule. |
| [`protocol`](#parameter-customnetworksecuritygroupspropertiesprotocol) | string | Network protocol this rule applies to. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-customnetworksecuritygroupspropertiesdescription) | string | The description of the security rule. |
| [`destinationAddressPrefix`](#parameter-customnetworksecuritygroupspropertiesdestinationaddressprefix) | string | The destination address prefix. CIDR or destination IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used. |
| [`destinationAddressPrefixes`](#parameter-customnetworksecuritygroupspropertiesdestinationaddressprefixes) | array | The destination address prefixes. CIDR or destination IP ranges. |
| [`destinationApplicationSecurityGroupResourceIds`](#parameter-customnetworksecuritygroupspropertiesdestinationapplicationsecuritygroupresourceids) | array | The resource IDs of the application security groups specified as destination. |
| [`destinationPortRange`](#parameter-customnetworksecuritygroupspropertiesdestinationportrange) | string | The destination port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports. |
| [`destinationPortRanges`](#parameter-customnetworksecuritygroupspropertiesdestinationportranges) | array | The destination port ranges. |
| [`sourceAddressPrefix`](#parameter-customnetworksecuritygroupspropertiessourceaddressprefix) | string | The CIDR or source IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used. If this is an ingress rule, specifies where network traffic originates from. |
| [`sourceAddressPrefixes`](#parameter-customnetworksecuritygroupspropertiessourceaddressprefixes) | array | The CIDR or source IP ranges. |
| [`sourceApplicationSecurityGroupResourceIds`](#parameter-customnetworksecuritygroupspropertiessourceapplicationsecuritygroupresourceids) | array | The resource IDs of the application security groups specified as source. |
| [`sourcePortRange`](#parameter-customnetworksecuritygroupspropertiessourceportrange) | string | The source port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports. |
| [`sourcePortRanges`](#parameter-customnetworksecuritygroupspropertiessourceportranges) | array | The source port ranges. |

### Parameter: `customNetworkSecurityGroups.properties.access`

Whether network traffic is allowed or denied.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Allow'
    'Deny'
  ]
  ```

### Parameter: `customNetworkSecurityGroups.properties.direction`

The direction of the rule. The direction specifies if rule will be evaluated on incoming or outgoing traffic.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Inbound'
    'Outbound'
  ]
  ```

### Parameter: `customNetworkSecurityGroups.properties.priority`

The priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule.

- Required: Yes
- Type: int
- MinValue: 100
- MaxValue: 4096

### Parameter: `customNetworkSecurityGroups.properties.protocol`

Network protocol this rule applies to.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    '*'
    'Ah'
    'Esp'
    'Icmp'
    'Tcp'
    'Udp'
  ]
  ```

### Parameter: `customNetworkSecurityGroups.properties.description`

The description of the security rule.

- Required: No
- Type: string

### Parameter: `customNetworkSecurityGroups.properties.destinationAddressPrefix`

The destination address prefix. CIDR or destination IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used.

- Required: No
- Type: string

### Parameter: `customNetworkSecurityGroups.properties.destinationAddressPrefixes`

The destination address prefixes. CIDR or destination IP ranges.

- Required: No
- Type: array

### Parameter: `customNetworkSecurityGroups.properties.destinationApplicationSecurityGroupResourceIds`

The resource IDs of the application security groups specified as destination.

- Required: No
- Type: array

### Parameter: `customNetworkSecurityGroups.properties.destinationPortRange`

The destination port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports.

- Required: No
- Type: string

### Parameter: `customNetworkSecurityGroups.properties.destinationPortRanges`

The destination port ranges.

- Required: No
- Type: array

### Parameter: `customNetworkSecurityGroups.properties.sourceAddressPrefix`

The CIDR or source IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used. If this is an ingress rule, specifies where network traffic originates from.

- Required: No
- Type: string

### Parameter: `customNetworkSecurityGroups.properties.sourceAddressPrefixes`

The CIDR or source IP ranges.

- Required: No
- Type: array

### Parameter: `customNetworkSecurityGroups.properties.sourceApplicationSecurityGroupResourceIds`

The resource IDs of the application security groups specified as source.

- Required: No
- Type: array

### Parameter: `customNetworkSecurityGroups.properties.sourcePortRange`

The source port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports.

- Required: No
- Type: string

### Parameter: `customNetworkSecurityGroups.properties.sourcePortRanges`

The source port ranges.

- Required: No
- Type: array

### Parameter: `deployInVnet`

Deploy resources in a virtual network and use it for private endpoints.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `environmentVariables`

The environment variables that will be added to the Container Apps Job.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-environmentvariablesname) | string | The environment variable name. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`secretRef`](#parameter-environmentvariablessecretref) | string | The name of the Container App secret from which to pull the environment variable value. Required if `value` is null. |
| [`value`](#parameter-environmentvariablesvalue) | string | The environment variable value. Required if `secretRef` is null. |

### Parameter: `environmentVariables.name`

The environment variable name.

- Required: Yes
- Type: string

### Parameter: `environmentVariables.secretRef`

The name of the Container App secret from which to pull the environment variable value. Required if `value` is null.

- Required: No
- Type: string

### Parameter: `environmentVariables.value`

The environment variable value. Required if `secretRef` is null.

- Required: No
- Type: string

### Parameter: `keyVaultName`

The name of the Key Vault that will be created to store the Application Insights connection string and be used for your secrets.

- Required: No
- Type: string
- Default: `[format('kv{0}', uniqueString(parameters('name'), parameters('location'), resourceGroup().name))]`
- Example: `kv${uniqueString(name, location, resourceGroup().name)})`

### Parameter: `keyVaultRoleAssignments`

The permissions that will be assigned to the Key Vault. The managed Identity will be assigned the permissions to get and list secrets.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-keyvaultroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-keyvaultroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-keyvaultroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-keyvaultroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-keyvaultroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-keyvaultroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-keyvaultroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-keyvaultroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `keyVaultRoleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `keyVaultRoleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `keyVaultRoleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `keyVaultRoleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `keyVaultRoleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `keyVaultRoleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `keyVaultRoleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `keyVaultRoleAssignments.principalType`

The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Device'
    'ForeignGroup'
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `location`

Location for all Resources.

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

### Parameter: `logAnalyticsWorkspaceResourceId`

The Log Analytics Resource ID for the Container Apps Environment to use for the job. If not provided, a new Log Analytics workspace will be created.

- Required: No
- Type: string
- Example: `/subscriptions/<00000000-0000-0000-0000-000000000000>/resourceGroups/<rg-name>/providers/Microsoft.OperationalInsights/workspaces/<workspace-name>`

### Parameter: `managedIdentityName`

The name of the managed identity to create. If not provided, a name will be generated automatically as `jobsUserIdentity-$\{name\}`.

- Required: No
- Type: string

### Parameter: `managedIdentityResourceId`

Use an existing managed identity to import the container image and run the job. If not provided, a new managed identity will be created.

- Required: No
- Type: string
- Example: `/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myManagedIdentity`

### Parameter: `memory`

The memory resources that will be allocated to the Container Apps Job.

- Required: No
- Type: string
- Default: `'2Gi'`

### Parameter: `newContainerImageName`

The new image name in the ACR. You can use this to import a publically available image with a custom name for later updating from e.g., your build pipeline. You should skip the registry name when specifying a custom value, as it is added automatically. If you leave this empty, the original name will be used (with the new registry name).

- Required: No
- Type: string
- Example: `application/frontend:latest`

### Parameter: `overwriteExistingImage`

The flag that indicates whether the existing image in the Container Registry should be overwritten.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `registryRoleAssignments`

The permissions that will be assigned to the Container Registry. The managed Identity will be assigned the permissions to get and list images.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-registryroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-registryroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-registryroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-registryroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-registryroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-registryroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-registryroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-registryroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `registryRoleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `registryRoleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `registryRoleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `registryRoleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `registryRoleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `registryRoleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `registryRoleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `registryRoleAssignments.principalType`

The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Device'
    'ForeignGroup'
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `secrets`

The secrets of the Container App. They will be added to Key Vault and configured as secrets in the Container App Job. The application insights connection string will be added automatically as `applicationinsightsconnectionstring`, if `appInsightsConnectionString` is set.

- Required: No
- Type: array
- Example:
  ```Bicep
  [
    {
      name: 'mysecret'
      identity: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myManagedIdentity'
      keyVaultUrl: 'https://myvault${environment().suffixes.keyvaultDns}/secrets/mysecret'
    }
    {
      name: 'mysecret'
      identity: 'system'
      keyVaultUrl: 'https://myvault${environment().suffixes.keyvaultDns}/secrets/mysecret'
    }
    {
      // You can do this, but you shouldn't. Use a secret reference instead.
      name: 'mysecret'
      value: 'mysecretvalue'
    }
    {
      name: 'connection-string'
      value: listKeys('/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.Storage/storageAccounts/myStorageAccount', '2023-04-01').keys[0].value
    }
  ]
  ```

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyVaultUrl`](#parameter-secretskeyvaulturl) | string | Azure Key Vault URL pointing to the secret referenced by the Container App Job. Required if `value` is null. |
| [`value`](#parameter-secretsvalue) | securestring | The secret value, if not fetched from Key Vault. Required if `keyVaultUrl` is null. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`identity`](#parameter-secretsidentity) | string | Resource ID of a managed identity to authenticate with Azure Key Vault, or System to use a system-assigned identity. |
| [`name`](#parameter-secretsname) | string | The name of the secret. |

### Parameter: `secrets.keyVaultUrl`

Azure Key Vault URL pointing to the secret referenced by the Container App Job. Required if `value` is null.

- Required: No
- Type: string
- Example: `https://myvault${environment().suffixes.keyvaultDns}/secrets/mysecret`

### Parameter: `secrets.value`

The secret value, if not fetched from Key Vault. Required if `keyVaultUrl` is null.

- Required: No
- Type: securestring

### Parameter: `secrets.identity`

Resource ID of a managed identity to authenticate with Azure Key Vault, or System to use a system-assigned identity.

- Required: No
- Type: string

### Parameter: `secrets.name`

The name of the secret.

- Required: No
- Type: string

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object
- Example:
  ```Bicep
  {
      key1: 'value1'
      key2: 'value2'
  }
  ```

### Parameter: `workloadProfileName`

The name of the workload profile to use. Leave empty to use a consumption based profile.

- Required: No
- Type: string
- Example: `CAW01`

### Parameter: `workloadProfiles`

Workload profiles for the managed environment. Leave empty to use a consumption based profile.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`maximumCount`](#parameter-workloadprofilesmaximumcount) | int | The maximum number of instances for the workload profile. |
| [`minimumCount`](#parameter-workloadprofilesminimumcount) | int | The minimum number of instances for the workload profile. |
| [`name`](#parameter-workloadprofilesname) | string | The name of the workload profile. |
| [`workloadProfileType`](#parameter-workloadprofilesworkloadprofiletype) | string | The type of the workload profile. |

### Parameter: `workloadProfiles.maximumCount`

The maximum number of instances for the workload profile.

- Required: Yes
- Type: int

### Parameter: `workloadProfiles.minimumCount`

The minimum number of instances for the workload profile.

- Required: Yes
- Type: int

### Parameter: `workloadProfiles.name`

The name of the workload profile.

- Required: Yes
- Type: string

### Parameter: `workloadProfiles.workloadProfileType`

The type of the workload profile.

- Required: Yes
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `deploymentscriptSubnetAddressPrefix` | string | Conditional. The address prefix for the service endpoint subnet, if a virtual network was deployed. If `deployInVnet` is `false`, this output will be empty. |
| `logAnalyticsResourceId` | string | The resouce ID of the Log Analytics Workspace (passed as parameter value or from the newly created Log Analytics Workspace). |
| `name` | string | The name of the container job. |
| `privateEndpointSubnetAddressPrefix` | string | Conditional. The address prefix for the private endpoint subnet, if a virtual network was deployed. If `deployInVnet` is `false`, this output will be empty. |
| `resourceGroupName` | string | The name of the Resource Group the resource was deployed into. |
| `resourceId` | string | The resource ID of the container job. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the user assigned managed identity. |
| `vnetResourceId` | string | Conditional. The virtual network resourceId, if a virtual network was deployed. If `deployInVnet` is `false`, this output will be empty. |
| `workloadSubnetAddressPrefix` | string | Conditional. The address prefix for the workload subnet, if a virtual network was deployed. If `addressPrefix` is empty, this output will be empty. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/ptn/authorization/resource-role-assignment:0.1.2` | Remote reference |
| `br/public:avm/ptn/deployment-script/import-image-to-acr:0.4.4` | Remote reference |
| `br/public:avm/res/app/job:0.7.1` | Remote reference |
| `br/public:avm/res/app/managed-environment:0.13.3` | Remote reference |
| `br/public:avm/res/container-registry/registry:0.12.1` | Remote reference |
| `br/public:avm/res/key-vault/vault:0.13.3` | Remote reference |
| `br/public:avm/res/network/network-security-group:0.5.3` | Remote reference |
| `br/public:avm/res/network/private-dns-zone:0.8.1` | Remote reference |
| `br/public:avm/res/network/private-endpoint:0.12.1` | Remote reference |
| `br/public:avm/res/network/virtual-network:0.9.0` | Remote reference |
| `br/public:avm/res/operational-insights/workspace:0.15.1` | Remote reference |
| `br/public:avm/res/storage/storage-account:0.32.1` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.2.1` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.4.0` | Remote reference |

## Notes

The use of Private Endpoints can be activated by setting the `deployInVnet` parameter to `true`. In order to have Private Endpoints enabled, the Azure Container Registry requires the 'Premium' tier, which will be set automatically.

### Configuration

Environment variables and secrets can be deployed by specifying the corresponding parameters. Each secret that is specified in the `secrets` parameter will be added to:

- Key Vault (if `keyVaultUrl` is set) and as secret to the container app secrets
- container app secrets if the `value` has been set

> If a value for the `appInsightsConnectionString` parameter is passed, a secret `applicationinsightsconnectionstring` is automatically added to the container app secrets and as `applicationinsights-connection-string` to Key Vault.

#### Zone Redundancy

[Zone Redundant configuration](https://learn.microsoft.com/en-us/azure/reliability/reliability-azure-container-apps) will be configured automatically if

1. `deployInVnet`has been enabled
2. No `workloadProfile` has been specified, which will deploy the Managed Environment with a Consumption Plan, _and_ an `addressPrefix` has been specified.

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
