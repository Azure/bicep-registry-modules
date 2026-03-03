# App Service Landing Zone Accelerator `[AppServiceLza/HostingEnvironment]`

This Azure App Service pattern module represents an Azure App Service deployment aligned with the cloud adoption framework

You can reference the module as follows:
```bicep
module hostingEnvironment 'br/public:avm/ptn/app-service-lza/hosting-environment:<version>' = {
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
| `Microsoft.Cdn/profiles` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cdn_profiles.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2025-06-01/profiles)</li></ul> |
| `Microsoft.Cdn/profiles/afdEndpoints` | 2025-04-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cdn_profiles_afdendpoints.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2025-04-15/profiles/afdEndpoints)</li></ul> |
| `Microsoft.Cdn/profiles/afdEndpoints/routes` | 2025-04-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cdn_profiles_afdendpoints_routes.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2025-04-15/profiles/afdEndpoints/routes)</li></ul> |
| `Microsoft.Cdn/profiles/customDomains` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cdn_profiles_customdomains.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2025-06-01/profiles/customDomains)</li></ul> |
| `Microsoft.Cdn/profiles/endpoints` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cdn_profiles_endpoints.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2025-06-01/profiles/endpoints)</li></ul> |
| `Microsoft.Cdn/profiles/endpoints/origins` | 2025-04-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cdn_profiles_endpoints_origins.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2025-04-15/profiles/endpoints/origins)</li></ul> |
| `Microsoft.Cdn/profiles/originGroups` | 2025-04-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cdn_profiles_origingroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2025-04-15/profiles/originGroups)</li></ul> |
| `Microsoft.Cdn/profiles/originGroups/origins` | 2025-04-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cdn_profiles_origingroups_origins.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2025-04-15/profiles/originGroups/origins)</li></ul> |
| `Microsoft.Cdn/profiles/ruleSets` | 2025-04-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cdn_profiles_rulesets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2025-04-15/profiles/ruleSets)</li></ul> |
| `Microsoft.Cdn/profiles/ruleSets/rules` | 2025-04-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cdn_profiles_rulesets_rules.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2025-04-15/profiles/ruleSets/rules)</li></ul> |
| `Microsoft.Cdn/profiles/secrets` | 2025-04-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cdn_profiles_secrets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2025-04-15/profiles/secrets)</li></ul> |
| `Microsoft.Cdn/profiles/securityPolicies` | 2025-04-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cdn_profiles_securitypolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2025-04-15/profiles/securityPolicies)</li></ul> |
| `Microsoft.Compute/disks` | 2024-03-02 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.compute_disks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2024-03-02/disks)</li></ul> |
| `Microsoft.Compute/sshPublicKeys` | 2024-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.compute_sshpublickeys.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2024-03-01/sshPublicKeys)</li></ul> |
| `Microsoft.Compute/virtualMachines` | 2024-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.compute_virtualmachines.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2024-07-01/virtualMachines)</li></ul> |
| `Microsoft.Compute/virtualMachines/extensions` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.compute_virtualmachines_extensions.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2024-11-01/virtualMachines/extensions)</li></ul> |
| `Microsoft.DevTestLab/schedules` | 2018-09-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.devtestlab_schedules.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevTestLab/2018-09-15/schedules)</li></ul> |
| `Microsoft.GuestConfiguration/guestConfigurationAssignments` | 2024-04-05 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.guestconfiguration_guestconfigurationassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.GuestConfiguration/2024-04-05/guestConfigurationAssignments)</li></ul> |
| `Microsoft.Insights/components` | 2020-02-02 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_components.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2020-02-02/components)</li></ul> |
| `microsoft.insights/components/linkedStorageAccounts` | 2020-03-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_components_linkedstorageaccounts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/microsoft.insights/2020-03-01-preview/components/linkedStorageAccounts)</li></ul> |
| `Microsoft.Insights/dataCollectionRuleAssociations` | 2024-03-11 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_datacollectionruleassociations.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2024-03-11/dataCollectionRuleAssociations)</li></ul> |
| `Microsoft.Insights/dataCollectionRules` | 2024-03-11 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_datacollectionrules.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2024-03-11/dataCollectionRules)</li></ul> |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_diagnosticsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)</li></ul> |
| `Microsoft.KeyVault/vaults` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2024-11-01/vaults)</li></ul> |
| `Microsoft.KeyVault/vaults/accessPolicies` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults_accesspolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2024-11-01/vaults/accessPolicies)</li></ul> |
| `Microsoft.KeyVault/vaults/keys` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults_keys.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2024-11-01/vaults/keys)</li></ul> |
| `Microsoft.KeyVault/vaults/secrets` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults_secrets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2024-11-01/vaults/secrets)</li></ul> |
| `Microsoft.Maintenance/configurationAssignments` | 2023-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.maintenance_configurationassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Maintenance/2023-04-01/configurationAssignments)</li></ul> |
| `Microsoft.Maintenance/maintenanceConfigurations` | 2023-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.maintenance_maintenanceconfigurations.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Maintenance/2023-04-01/maintenanceConfigurations)</li></ul> |
| `Microsoft.ManagedIdentity/userAssignedIdentities` | 2024-11-30 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.managedidentity_userassignedidentities.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2024-11-30/userAssignedIdentities)</li></ul> |
| `Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials` | 2024-11-30 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.managedidentity_userassignedidentities_federatedidentitycredentials.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2024-11-30/userAssignedIdentities/federatedIdentityCredentials)</li></ul> |
| `Microsoft.Network/applicationGateways` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_applicationgateways.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-01-01/applicationGateways)</li></ul> |
| `Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_applicationgatewaywebapplicationfirewallpolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-01-01/ApplicationGatewayWebApplicationFirewallPolicies)</li></ul> |
| `Microsoft.Network/FrontDoorWebApplicationFirewallPolicies` | 2024-02-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_frontdoorwebapplicationfirewallpolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-02-01/FrontDoorWebApplicationFirewallPolicies)</li></ul> |
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
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints_privatednszonegroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/privateEndpoints/privateDnsZoneGroups)</li></ul> |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2024-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints_privatednszonegroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-10-01/privateEndpoints/privateDnsZoneGroups)</li></ul> |
| `Microsoft.Network/publicIPAddresses` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_publicipaddresses.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/publicIPAddresses)</li></ul> |
| `Microsoft.Network/publicIPAddresses` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_publicipaddresses.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-01-01/publicIPAddresses)</li></ul> |
| `Microsoft.Network/routeTables` | 2024-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_routetables.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-07-01/routeTables)</li></ul> |
| `Microsoft.Network/virtualNetworks` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_virtualnetworks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/virtualNetworks)</li></ul> |
| `Microsoft.Network/virtualNetworks/subnets` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_virtualnetworks_subnets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/virtualNetworks/subnets)</li></ul> |
| `Microsoft.Network/virtualNetworks/virtualNetworkPeerings` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_virtualnetworks_virtualnetworkpeerings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-01-01/virtualNetworks/virtualNetworkPeerings)</li></ul> |
| `Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems` | 2025-02-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.recoveryservices_vaults_backupfabrics_protectioncontainers_protecteditems.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2025-02-01/vaults/backupFabrics/protectionContainers/protectedItems)</li></ul> |
| `Microsoft.Resources/deploymentScripts` | 2023-08-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.resources_deploymentscripts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2023-08-01/deploymentScripts)</li></ul> |
| `Microsoft.Resources/resourceGroups` | 2025-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.resources_resourcegroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2025-04-01/resourceGroups)</li></ul> |
| `Microsoft.Web/hostingEnvironments` | 2025-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.web_hostingenvironments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2025-03-01/hostingEnvironments)</li></ul> |
| `Microsoft.Web/hostingEnvironments/configurations` | 2025-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.web_hostingenvironments_configurations.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2025-03-01/hostingEnvironments/configurations)</li></ul> |
| `Microsoft.Web/serverfarms` | 2025-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.web_serverfarms.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2025-03-01/serverfarms)</li></ul> |
| `Microsoft.Web/sites` | 2025-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.web_sites.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2025-03-01/sites)</li></ul> |
| `Microsoft.Web/sites/basicPublishingCredentialsPolicies` | 2025-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.web_sites_basicpublishingcredentialspolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2025-03-01/sites/basicPublishingCredentialsPolicies)</li></ul> |
| `Microsoft.Web/sites/config` | 2025-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.web_sites_config.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2025-03-01/sites/config)</li></ul> |
| `Microsoft.Web/sites/extensions` | 2025-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.web_sites_extensions.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2025-03-01/sites/extensions)</li></ul> |
| `Microsoft.Web/sites/hybridConnectionNamespaces/relays` | 2025-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.web_sites_hybridconnectionnamespaces_relays.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2025-03-01/sites/hybridConnectionNamespaces/relays)</li></ul> |
| `Microsoft.Web/sites/slots` | 2025-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.web_sites_slots.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2025-03-01/sites/slots)</li></ul> |
| `Microsoft.Web/sites/slots/basicPublishingCredentialsPolicies` | 2025-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.web_sites_slots_basicpublishingcredentialspolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2025-03-01/sites/slots/basicPublishingCredentialsPolicies)</li></ul> |
| `Microsoft.Web/sites/slots/config` | 2025-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.web_sites_slots_config.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2025-03-01/sites/slots/config)</li></ul> |
| `Microsoft.Web/sites/slots/extensions` | 2024-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.web_sites_slots_extensions.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-04-01/sites/slots/extensions)</li></ul> |
| `Microsoft.Web/sites/slots/hybridConnectionNamespaces/relays` | 2024-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.web_sites_slots_hybridconnectionnamespaces_relays.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-04-01/sites/slots/hybridConnectionNamespaces/relays)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/app-service-lza/hosting-environment:<version>`.

- [ASE v3 with Linux workloads.](#example-1-ase-v3-with-linux-workloads)
- [ASE v3 with Windows workloads and Bastion integration.](#example-2-ase-v3-with-windows-workloads-and-bastion-integration)
- [Bring-your-own-service with Linux workloads.](#example-3-bring-your-own-service-with-linux-workloads)
- [Bring-your-own-service with Windows workloads.](#example-4-bring-your-own-service-with-windows-workloads)
- [Using only defaults.](#example-5-using-only-defaults)
- [Using all parameters.](#example-6-using-all-parameters)
- [Multi-region with Azure Front Door.](#example-7-multi-region-with-azure-front-door)
- [WAF-aligned](#example-8-waf-aligned)

### Example 1: _ASE v3 with Linux workloads._

This instance deploys ASE v3 with both a Linux web app and a Linux container workload to validate the ASE + Linux matrix.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/ase-linux-matrix]


<details>

<summary>via Bicep module</summary>

```bicep
metadata name = 'ASE v3 with Linux workloads.'
metadata description = 'This instance deploys ASE v3 with both a Linux web app and a Linux container workload to validate the ASE + Linux matrix.'

targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for diagnostics settings.')
@maxLength(90)
param diagnosticsResourceGroupName string = 'diag-appservicelza-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'appaselnx'

@description('Optional. Test name prefix.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. The password to leverage for the login.')
@secure()
param password string = newGuid()

#disable-next-line no-hardcoded-location
var enforcedLocation = 'australiaeast'

// Diagnostics
// ===========
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: diagnosticsResourceGroupName
  location: enforcedLocation
}

module diagnosticDependencies '../../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}diasa${serviceShort}03'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}01'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}01'
    location: enforcedLocation
  }
}

// ============== //
// Test Execution //
// ============== //

// --- ASE v3 + Linux web app ---
@batchSize(1)
module testDeploymentLinuxWebApp '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-lweb-${iteration}'
    params: {
      workloadName: take('${namePrefix}aselw', 10)
      logAnalyticsWorkspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
      tags: {
        environment: 'test'
        scenario: 'ase-linux-webapp'
      }

      deployAseV3: true
      webAppBaseOs: 'linux'
      webAppKind: 'app,linux'
      webAppPlanSku: 'I1v2'
      networkingOption: 'none'

      // ASE needs a /24 for the app-svc subnet
      subnetSpokeAppSvcAddressSpace: '10.240.0.0/24'

      deployJumpHost: false
      vmSize: 'Standard_D2s_v4'
      adminUsername: 'azureuser'
      adminPassword: password
      location: enforcedLocation
    }
  }
]

// --- ASE v3 + Linux container ---
@batchSize(1)
module testDeploymentLinuxContainer '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-lctr-${iteration}'
    params: {
      workloadName: take('${namePrefix}aselc', 10)
      logAnalyticsWorkspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
      tags: {
        environment: 'test'
        scenario: 'ase-linux-container'
      }

      deployAseV3: true
      webAppBaseOs: 'linux'
      webAppKind: 'app,linux,container'
      containerImageName: 'mcr.microsoft.com/appsvc/staticsite:latest'
      webAppPlanSku: 'I1v2'
      networkingOption: 'none'

      subnetSpokeAppSvcAddressSpace: '10.240.0.0/24'

      deployJumpHost: false
      vmSize: 'Standard_D2s_v4'
      adminUsername: 'azureuser'
      adminPassword: password
      location: enforcedLocation
    }
  }
]

output testDeploymentOutputs object = {
  linuxWebApp: testDeploymentLinuxWebApp[0].outputs
  linuxContainer: testDeploymentLinuxContainer[0].outputs
}
```

</details>
<p>

### Example 2: _ASE v3 with Windows workloads and Bastion integration._

This instance deploys ASE v3 with Windows web app and Windows container workloads, plus a Windows jump host with Bastion-enabled NSG rules to validate the managed-instance + Bastion integration path.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/ase-windows-matrix]


<details>

<summary>via Bicep module</summary>

```bicep
metadata name = 'ASE v3 with Windows workloads and Bastion integration.'
metadata description = 'This instance deploys ASE v3 with Windows web app and Windows container workloads, plus a Windows jump host with Bastion-enabled NSG rules to validate the managed-instance + Bastion integration path.'

targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for diagnostics settings.')
@maxLength(90)
param diagnosticsResourceGroupName string = 'diag-appservicelza-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'appasewin'

@description('Optional. Test name prefix.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. The password to leverage for the login.')
@secure()
param password string = newGuid()

#disable-next-line no-hardcoded-location
var enforcedLocation = 'australiaeast'

// A placeholder Bastion resource ID exercises the Bastion-integration code path in jumpbox NSG rules.
// The resource does not need to exist for a validation (dry-run) deployment.
var bastionPlaceholderResourceId = '/subscriptions/${subscription().subscriptionId}/resourceGroups/rg-hub-bastion/providers/Microsoft.Network/bastionHosts/bst-appsvc-lza'

// Diagnostics
// ===========
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: diagnosticsResourceGroupName
  location: enforcedLocation
}

module diagnosticDependencies '../../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}diasa${serviceShort}03'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}01'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}01'
    location: enforcedLocation
  }
}

// ============== //
// Test Execution //
// ============== //

// --- ASE v3 + Windows web app + Bastion jump host ---
@batchSize(1)
module testDeploymentWindowsWebApp '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-wweb-${iteration}'
    params: {
      workloadName: take('${namePrefix}aseww', 10)
      logAnalyticsWorkspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
      tags: {
        environment: 'test'
        scenario: 'ase-windows-webapp-bastion'
      }

      deployAseV3: true
      webAppBaseOs: 'windows'
      webAppKind: 'app'
      webAppPlanSku: 'I1v2'
      networkingOption: 'none'

      subnetSpokeAppSvcAddressSpace: '10.240.0.0/24'

      // Windows jump host with Bastion integration
      vmJumpboxOSType: 'windows'
      bastionResourceId: bastionPlaceholderResourceId
      vmSize: 'Standard_D2s_v4'
      adminUsername: 'azureuser'
      adminPassword: password
      location: enforcedLocation
    }
  }
]

// --- ASE v3 + Windows container + Bastion jump host ---
@batchSize(1)
module testDeploymentWindowsContainer '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-wctr-${iteration}'
    params: {
      workloadName: take('${namePrefix}asewc', 10)
      logAnalyticsWorkspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
      tags: {
        environment: 'test'
        scenario: 'ase-windows-container-bastion'
      }

      deployAseV3: true
      webAppBaseOs: 'windows'
      webAppKind: 'app,container,windows'
      containerImageName: 'mcr.microsoft.com/appsvc/staticsite:latest'
      webAppPlanSku: 'I1v2'
      networkingOption: 'none'

      subnetSpokeAppSvcAddressSpace: '10.240.0.0/24'

      // Windows jump host with Bastion integration
      vmJumpboxOSType: 'windows'
      bastionResourceId: bastionPlaceholderResourceId
      vmSize: 'Standard_D2s_v4'
      adminUsername: 'azureuser'
      adminPassword: password
      location: enforcedLocation
    }
  }
]

output testDeploymentOutputs object = {
  windowsWebApp: testDeploymentWindowsWebApp[0].outputs
  windowsContainer: testDeploymentWindowsContainer[0].outputs
}
```

</details>
<p>

### Example 3: _Bring-your-own-service with Linux workloads._

This instance validates bring-your-own-service by pre-creating a Linux App Service Plan and passing it via existingAppServicePlanId, then deploying a Linux web app and a Linux container on it.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/byos-linux-matrix]


<details>

<summary>via Bicep module</summary>

```bicep
metadata name = 'Bring-your-own-service with Linux workloads.'
metadata description = 'This instance validates bring-your-own-service by pre-creating a Linux App Service Plan and passing it via existingAppServicePlanId, then deploying a Linux web app and a Linux container on it.'

targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for diagnostics settings.')
@maxLength(90)
param diagnosticsResourceGroupName string = 'diag-appservicelza-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'appbyolnx'

@description('Optional. Test name prefix.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. The password to leverage for the login.')
@secure()
param password string = newGuid()

#disable-next-line no-hardcoded-location
var enforcedLocation = 'australiaeast'

// Diagnostics
// ===========
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: diagnosticsResourceGroupName
  location: enforcedLocation
}

module diagnosticDependencies '../../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}diasa${serviceShort}03'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}01'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}01'
    location: enforcedLocation
  }
}

// Pre-create a Linux App Service Plan to exercise bring-your-own-service
module existingLinuxPlan 'br/public:avm/res/web/serverfarm:0.7.0' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-existingLinuxPlan'
  params: {
    name: take('asp-${namePrefix}-${serviceShort}-lnx', 40)
    location: enforcedLocation
    skuName: 'P1V3'
    kind: 'Linux'
    reserved: true
    enableTelemetry: true
  }
}

// ============== //
// Test Execution //
// ============== //

// --- BYOS + Linux web app ---
@batchSize(1)
module testDeploymentLinuxWebApp '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-lweb-${iteration}'
    params: {
      workloadName: take('${namePrefix}byolw', 10)
      logAnalyticsWorkspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
      tags: {
        environment: 'test'
        scenario: 'byos-linux-webapp'
      }

      existingAppServicePlanId: existingLinuxPlan.outputs.resourceId
      webAppBaseOs: 'linux'
      webAppKind: 'app,linux'
      networkingOption: 'none'

      deployJumpHost: false
      vmSize: 'Standard_D2s_v4'
      adminUsername: 'azureuser'
      adminPassword: password
      location: enforcedLocation
    }
  }
]

// --- BYOS + Linux container ---
@batchSize(1)
module testDeploymentLinuxContainer '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-lctr-${iteration}'
    params: {
      workloadName: take('${namePrefix}byolc', 10)
      logAnalyticsWorkspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
      tags: {
        environment: 'test'
        scenario: 'byos-linux-container'
      }

      existingAppServicePlanId: existingLinuxPlan.outputs.resourceId
      webAppBaseOs: 'linux'
      webAppKind: 'app,linux,container'
      containerImageName: 'mcr.microsoft.com/appsvc/staticsite:latest'
      networkingOption: 'none'

      deployJumpHost: false
      vmSize: 'Standard_D2s_v4'
      adminUsername: 'azureuser'
      adminPassword: password
      location: enforcedLocation
    }
  }
]

output testDeploymentOutputs object = {
  linuxWebApp: testDeploymentLinuxWebApp[0].outputs
  linuxContainer: testDeploymentLinuxContainer[0].outputs
}
```

</details>
<p>

### Example 4: _Bring-your-own-service with Windows workloads._

This instance validates bring-your-own-service by pre-creating a Windows App Service Plan and passing it via existingAppServicePlanId, then deploying a Windows web app and a Windows container on it.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/byos-windows-matrix]


<details>

<summary>via Bicep module</summary>

```bicep
metadata name = 'Bring-your-own-service with Windows workloads.'
metadata description = 'This instance validates bring-your-own-service by pre-creating a Windows App Service Plan and passing it via existingAppServicePlanId, then deploying a Windows web app and a Windows container on it.'

targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for diagnostics settings.')
@maxLength(90)
param diagnosticsResourceGroupName string = 'diag-appservicelza-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'appbyowin'

@description('Optional. Test name prefix.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. The password to leverage for the login.')
@secure()
param password string = newGuid()

#disable-next-line no-hardcoded-location
var enforcedLocation = 'australiaeast'

// Diagnostics
// ===========
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: diagnosticsResourceGroupName
  location: enforcedLocation
}

module diagnosticDependencies '../../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}diasa${serviceShort}03'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}01'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}01'
    location: enforcedLocation
  }
}

// Pre-create a Windows App Service Plan to exercise bring-your-own-service
module existingWindowsPlan 'br/public:avm/res/web/serverfarm:0.7.0' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-existingWindowsPlan'
  params: {
    name: take('asp-${namePrefix}-${serviceShort}-win', 40)
    location: enforcedLocation
    skuName: 'P1V3'
    kind: 'Windows'
    reserved: false
    enableTelemetry: true
  }
}

// ============== //
// Test Execution //
// ============== //

// --- BYOS + Windows web app ---
@batchSize(1)
module testDeploymentWindowsWebApp '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-wweb-${iteration}'
    params: {
      workloadName: take('${namePrefix}byoww', 10)
      logAnalyticsWorkspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
      tags: {
        environment: 'test'
        scenario: 'byos-windows-webapp'
      }

      existingAppServicePlanId: existingWindowsPlan.outputs.resourceId
      webAppBaseOs: 'windows'
      webAppKind: 'app'
      networkingOption: 'none'

      deployJumpHost: false
      vmSize: 'Standard_D2s_v4'
      adminUsername: 'azureuser'
      adminPassword: password
      location: enforcedLocation
    }
  }
]

// --- BYOS + Windows container ---
@batchSize(1)
module testDeploymentWindowsContainer '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-wctr-${iteration}'
    params: {
      workloadName: take('${namePrefix}byowc', 10)
      logAnalyticsWorkspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
      tags: {
        environment: 'test'
        scenario: 'byos-windows-container'
      }

      existingAppServicePlanId: existingWindowsPlan.outputs.resourceId
      webAppBaseOs: 'windows'
      webAppKind: 'app,container,windows'
      containerImageName: 'mcr.microsoft.com/appsvc/staticsite:latest'
      networkingOption: 'none'

      deployJumpHost: false
      vmSize: 'Standard_D2s_v4'
      adminUsername: 'azureuser'
      adminPassword: password
      location: enforcedLocation
    }
  }
]

output testDeploymentOutputs object = {
  windowsWebApp: testDeploymentWindowsWebApp[0].outputs
  windowsContainer: testDeploymentWindowsContainer[0].outputs
}
```

</details>
<p>

### Example 5: _Using only defaults._

This instance deploys the module with the minimum set of required parameters.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/defaults]


<details>

<summary>via Bicep module</summary>

```bicep
module hostingEnvironment 'br/public:avm/ptn/app-service-lza/hosting-environment:<version>' = {
  params: {
    // Required parameters
    logAnalyticsWorkspaceResourceId: '<logAnalyticsWorkspaceResourceId>'
    // Non-required parameters
    adminPassword: '<adminPassword>'
    adminUsername: 'azureuser'
    location: '<location>'
    vmSize: 'Standard_D2s_v4'
    workloadName: '<workloadName>'
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
    "logAnalyticsWorkspaceResourceId": {
      "value": "<logAnalyticsWorkspaceResourceId>"
    },
    // Non-required parameters
    "adminPassword": {
      "value": "<adminPassword>"
    },
    "adminUsername": {
      "value": "azureuser"
    },
    "location": {
      "value": "<location>"
    },
    "vmSize": {
      "value": "Standard_D2s_v4"
    },
    "workloadName": {
      "value": "<workloadName>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/app-service-lza/hosting-environment:<version>'

// Required parameters
param logAnalyticsWorkspaceResourceId = '<logAnalyticsWorkspaceResourceId>'
// Non-required parameters
param adminPassword = '<adminPassword>'
param adminUsername = 'azureuser'
param location = '<location>'
param vmSize = 'Standard_D2s_v4'
param workloadName = '<workloadName>'
```

</details>
<p>

### Example 6: _Using all parameters._

This instance deploys the module with the maximum set of parameters, exercising the Application Gateway networking option and Linux container workload.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/max]


<details>

<summary>via Bicep module</summary>

```bicep
module hostingEnvironment 'br/public:avm/ptn/app-service-lza/hosting-environment:<version>' = {
  params: {
    // Required parameters
    logAnalyticsWorkspaceResourceId: '<logAnalyticsWorkspaceResourceId>'
    // Non-required parameters
    adminPassword: '<adminPassword>'
    adminUsername: 'azureuser'
    appGatewayDiagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        logCategoriesAndGroups: [
          {
            categoryGroup: 'allLogs'
          }
        ]
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    appserviceDiagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        logCategoriesAndGroups: [
          {
            categoryGroup: 'allLogs'
          }
        ]
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    aseDiagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        logCategoriesAndGroups: [
          {
            categoryGroup: 'allLogs'
          }
        ]
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    containerImageName: 'mcr.microsoft.com/appsvc/staticsite:latest'
    enableEgressLockdown: true
    keyVaultDiagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        logCategoriesAndGroups: [
          {
            categoryGroup: 'allLogs'
          }
        ]
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    location: '<location>'
    networkingOption: 'applicationGateway'
    servicePlanDiagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    subnetSpokeAppGwAddressSpace: '10.240.12.0/24'
    tags: {
      environment: 'test'
      scenario: 'max'
    }
    vmJumpboxOSType: 'linux'
    vmSize: 'Standard_D2s_v4'
    webAppBaseOs: 'linux'
    webAppKind: 'app,linux,container'
    workloadName: '<workloadName>'
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
    "logAnalyticsWorkspaceResourceId": {
      "value": "<logAnalyticsWorkspaceResourceId>"
    },
    // Non-required parameters
    "adminPassword": {
      "value": "<adminPassword>"
    },
    "adminUsername": {
      "value": "azureuser"
    },
    "appGatewayDiagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "logCategoriesAndGroups": [
            {
              "categoryGroup": "allLogs"
            }
          ],
          "metricCategories": [
            {
              "category": "AllMetrics"
            }
          ],
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "appserviceDiagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "logCategoriesAndGroups": [
            {
              "categoryGroup": "allLogs"
            }
          ],
          "metricCategories": [
            {
              "category": "AllMetrics"
            }
          ],
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "aseDiagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "logCategoriesAndGroups": [
            {
              "categoryGroup": "allLogs"
            }
          ],
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "containerImageName": {
      "value": "mcr.microsoft.com/appsvc/staticsite:latest"
    },
    "enableEgressLockdown": {
      "value": true
    },
    "keyVaultDiagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "logCategoriesAndGroups": [
            {
              "categoryGroup": "allLogs"
            }
          ],
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "location": {
      "value": "<location>"
    },
    "networkingOption": {
      "value": "applicationGateway"
    },
    "servicePlanDiagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "metricCategories": [
            {
              "category": "AllMetrics"
            }
          ],
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "subnetSpokeAppGwAddressSpace": {
      "value": "10.240.12.0/24"
    },
    "tags": {
      "value": {
        "environment": "test",
        "scenario": "max"
      }
    },
    "vmJumpboxOSType": {
      "value": "linux"
    },
    "vmSize": {
      "value": "Standard_D2s_v4"
    },
    "webAppBaseOs": {
      "value": "linux"
    },
    "webAppKind": {
      "value": "app,linux,container"
    },
    "workloadName": {
      "value": "<workloadName>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/app-service-lza/hosting-environment:<version>'

// Required parameters
param logAnalyticsWorkspaceResourceId = '<logAnalyticsWorkspaceResourceId>'
// Non-required parameters
param adminPassword = '<adminPassword>'
param adminUsername = 'azureuser'
param appGatewayDiagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    logCategoriesAndGroups: [
      {
        categoryGroup: 'allLogs'
      }
    ]
    metricCategories: [
      {
        category: 'AllMetrics'
      }
    ]
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param appserviceDiagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    logCategoriesAndGroups: [
      {
        categoryGroup: 'allLogs'
      }
    ]
    metricCategories: [
      {
        category: 'AllMetrics'
      }
    ]
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param aseDiagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    logCategoriesAndGroups: [
      {
        categoryGroup: 'allLogs'
      }
    ]
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param containerImageName = 'mcr.microsoft.com/appsvc/staticsite:latest'
param enableEgressLockdown = true
param keyVaultDiagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    logCategoriesAndGroups: [
      {
        categoryGroup: 'allLogs'
      }
    ]
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param location = '<location>'
param networkingOption = 'applicationGateway'
param servicePlanDiagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    metricCategories: [
      {
        category: 'AllMetrics'
      }
    ]
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param subnetSpokeAppGwAddressSpace = '10.240.12.0/24'
param tags = {
  environment: 'test'
  scenario: 'max'
}
param vmJumpboxOSType = 'linux'
param vmSize = 'Standard_D2s_v4'
param webAppBaseOs = 'linux'
param webAppKind = 'app,linux,container'
param workloadName = '<workloadName>'
```

</details>
<p>

### Example 7: _Multi-region with Azure Front Door._

This instance deploys two regional stamps behind Front Door to validate the multi-region topology with Linux and Windows workloads.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/multi-region-front-door]


<details>

<summary>via Bicep module</summary>

```bicep
metadata name = 'Multi-region with Azure Front Door.'
metadata description = 'This instance deploys two regional stamps behind Front Door to validate the multi-region topology with Linux and Windows workloads.'

targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for diagnostics settings.')
@maxLength(90)
param diagnosticsResourceGroupName string = 'diag-appservicelza-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'appmrfd'

@description('Optional. Test name prefix.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. The password to leverage for the login.')
@secure()
param password string = newGuid()

// Hardcoded regions where App Service Premium plans are available
#disable-next-line no-hardcoded-location
var primaryLocation = 'australiaeast'
#disable-next-line no-hardcoded-location
var secondaryLocation = 'australiasoutheast'

// Diagnostics
// ===========
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: diagnosticsResourceGroupName
  location: primaryLocation
}

module diagnosticDependencies '../../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, primaryLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}diasa${serviceShort}03'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}01'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}01'
    location: primaryLocation
  }
}

// ============== //
// Test Execution //
// ============== //

// --- Primary region: Windows web app behind Front Door ---
@batchSize(1)
module testDeploymentPrimary '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    name: '${uniqueString(deployment().name, primaryLocation)}-test-${serviceShort}-pri-${iteration}'
    params: {
      workloadName: take('${namePrefix}${serviceShort}p', 10)
      logAnalyticsWorkspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
      tags: {
        environment: 'test'
        scenario: 'multi-region-front-door-primary'
      }

      // Front Door ingress
      networkingOption: 'frontDoor'

      // Windows web app
      webAppBaseOs: 'windows'
      webAppKind: 'app'

      // No jump host for speed
      deployJumpHost: false

      // VM params still required by the module interface
      vmSize: 'Standard_D2s_v4'
      adminUsername: 'azureuser'
      adminPassword: password
      location: primaryLocation
    }
  }
]

// --- Secondary region: Linux web app behind Front Door ---
@batchSize(1)
module testDeploymentSecondary '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    name: '${uniqueString(deployment().name, secondaryLocation)}-test-${serviceShort}-sec-${iteration}'
    params: {
      workloadName: take('${namePrefix}${serviceShort}s', 10)
      logAnalyticsWorkspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
      tags: {
        environment: 'test'
        scenario: 'multi-region-front-door-secondary'
      }

      // Front Door ingress
      networkingOption: 'frontDoor'

      // Linux web app
      webAppBaseOs: 'linux'
      webAppKind: 'app,linux'

      // No jump host for speed
      deployJumpHost: false

      vmSize: 'Standard_D2s_v4'
      adminUsername: 'azureuser'
      adminPassword: password
      location: secondaryLocation
    }
  }
]

output testDeploymentOutputs object = {
  primary: testDeploymentPrimary[0].outputs
  secondary: testDeploymentSecondary[0].outputs
}
```

</details>
<p>

### Example 8: _WAF-aligned_

This instance deploys the module with WAF aligned settings.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/waf-aligned]


<details>

<summary>via Bicep module</summary>

```bicep
module hostingEnvironment 'br/public:avm/ptn/app-service-lza/hosting-environment:<version>' = {
  params: {
    // Required parameters
    logAnalyticsWorkspaceResourceId: '<logAnalyticsWorkspaceResourceId>'
    // Non-required parameters
    adminPassword: '<adminPassword>'
    adminUsername: 'azureuser'
    appserviceDiagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        logCategoriesAndGroups: [
          {
            categoryGroup: 'allLogs'
          }
        ]
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    aseDiagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        logCategoriesAndGroups: [
          {
            categoryGroup: 'allLogs'
          }
        ]
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    enableEgressLockdown: true
    frontDoorDiagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        logCategoriesAndGroups: [
          {
            category: 'FrontdoorAccessLog'
          }
          {
            category: 'FrontdoorWebApplicationFirewallLog'
          }
        ]
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    location: '<location>'
    servicePlanDiagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    tags: {
      environment: 'test'
    }
    vmSize: 'Standard_D2s_v4'
    workloadName: '<workloadName>'
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
    "logAnalyticsWorkspaceResourceId": {
      "value": "<logAnalyticsWorkspaceResourceId>"
    },
    // Non-required parameters
    "adminPassword": {
      "value": "<adminPassword>"
    },
    "adminUsername": {
      "value": "azureuser"
    },
    "appserviceDiagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "logCategoriesAndGroups": [
            {
              "categoryGroup": "allLogs"
            }
          ],
          "metricCategories": [
            {
              "category": "AllMetrics"
            }
          ],
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "aseDiagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "logCategoriesAndGroups": [
            {
              "categoryGroup": "allLogs"
            }
          ],
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "enableEgressLockdown": {
      "value": true
    },
    "frontDoorDiagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "logCategoriesAndGroups": [
            {
              "category": "FrontdoorAccessLog"
            },
            {
              "category": "FrontdoorWebApplicationFirewallLog"
            }
          ],
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "location": {
      "value": "<location>"
    },
    "servicePlanDiagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "metricCategories": [
            {
              "category": "AllMetrics"
            }
          ],
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "tags": {
      "value": {
        "environment": "test"
      }
    },
    "vmSize": {
      "value": "Standard_D2s_v4"
    },
    "workloadName": {
      "value": "<workloadName>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/app-service-lza/hosting-environment:<version>'

// Required parameters
param logAnalyticsWorkspaceResourceId = '<logAnalyticsWorkspaceResourceId>'
// Non-required parameters
param adminPassword = '<adminPassword>'
param adminUsername = 'azureuser'
param appserviceDiagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    logCategoriesAndGroups: [
      {
        categoryGroup: 'allLogs'
      }
    ]
    metricCategories: [
      {
        category: 'AllMetrics'
      }
    ]
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param aseDiagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    logCategoriesAndGroups: [
      {
        categoryGroup: 'allLogs'
      }
    ]
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param enableEgressLockdown = true
param frontDoorDiagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    logCategoriesAndGroups: [
      {
        category: 'FrontdoorAccessLog'
      }
      {
        category: 'FrontdoorWebApplicationFirewallLog'
      }
    ]
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param location = '<location>'
param servicePlanDiagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    metricCategories: [
      {
        category: 'AllMetrics'
      }
    ]
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param tags = {
  environment: 'test'
}
param vmSize = 'Standard_D2s_v4'
param workloadName = '<workloadName>'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`logAnalyticsWorkspaceResourceId`](#parameter-loganalyticsworkspaceresourceid) | string | The resource ID of the Log Analytics workspace managed by the Platform Landing Zone. All diagnostic settings will be configured to send logs and metrics to this workspace. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`adminPassword`](#parameter-adminpassword) | securestring | Required if jumpbox deployed and not using SSH key. The password of the admin user of the jumpbox VM. |
| [`adminUsername`](#parameter-adminusername) | string | Required if jumpbox deployed. The username of the admin user of the jumpbox VM. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appGatewayAuthenticationCertificates`](#parameter-appgatewayauthenticationcertificates) | array | Authentication certificates for Application Gateway backend auth. |
| [`appGatewayBackendSettingsCollection`](#parameter-appgatewaybackendsettingscollection) | array | Backend settings collection (v2) for the Application Gateway. |
| [`appGatewayCustomErrorConfigurations`](#parameter-appgatewaycustomerrorconfigurations) | array | Custom error configurations for the Application Gateway. |
| [`appGatewayDiagnosticSettings`](#parameter-appgatewaydiagnosticsettings) | array | Diagnostic Settings for the Application Gateway. |
| [`appGatewayEnableFips`](#parameter-appgatewayenablefips) | bool | Whether FIPS mode is enabled on the Application Gateway. |
| [`appGatewayEnableHttp2`](#parameter-appgatewayenablehttp2) | bool | Whether HTTP/2 is enabled on the Application Gateway. Defaults to true. |
| [`appGatewayEnableRequestBuffering`](#parameter-appgatewayenablerequestbuffering) | bool | Whether request buffering is enabled on the Application Gateway. |
| [`appGatewayEnableResponseBuffering`](#parameter-appgatewayenableresponsebuffering) | bool | Whether response buffering is enabled on the Application Gateway. |
| [`appGatewayListeners`](#parameter-appgatewaylisteners) | array | Listeners (v2) for the Application Gateway. |
| [`appGatewayLoadDistributionPolicies`](#parameter-appgatewayloaddistributionpolicies) | array | Load distribution policies for the Application Gateway. |
| [`appGatewayLock`](#parameter-appgatewaylock) | object | Specify the type of resource lock for the Application Gateway. |
| [`appGatewayManagedIdentities`](#parameter-appgatewaymanagedidentities) | object | Managed identities for the Application Gateway. Required for Key Vault-referenced SSL certificates. |
| [`appGatewayPrivateEndpoints`](#parameter-appgatewayprivateendpoints) | array | Private endpoints for the Application Gateway. |
| [`appGatewayPrivateLinkConfigurations`](#parameter-appgatewayprivatelinkconfigurations) | array | Private link configurations for the Application Gateway. |
| [`appGatewayRedirectConfigurations`](#parameter-appgatewayredirectconfigurations) | array | Redirect configurations for the Application Gateway. |
| [`appGatewayRewriteRuleSets`](#parameter-appgatewayrewriterulesets) | array | Rewrite rule sets for the Application Gateway. |
| [`appGatewayRoleAssignments`](#parameter-appgatewayroleassignments) | array | Role assignments for the Application Gateway. |
| [`appGatewayRoutingRules`](#parameter-appgatewayroutingrules) | array | Routing rules (v2) for the Application Gateway. |
| [`appGatewaySslCertificates`](#parameter-appgatewaysslcertificates) | array | SSL certificates for the Application Gateway. Required for HTTPS termination. |
| [`appGatewaySslPolicyCipherSuites`](#parameter-appgatewaysslpolicyciphersuites) | array | SSL cipher suites for the Application Gateway. |
| [`appGatewaySslPolicyMinProtocolVersion`](#parameter-appgatewaysslpolicyminprotocolversion) | string | Minimum TLS protocol version for the Application Gateway. |
| [`appGatewaySslPolicyName`](#parameter-appgatewaysslpolicyname) | string | The predefined SSL policy name for the Application Gateway. |
| [`appGatewaySslPolicyType`](#parameter-appgatewaysslpolicytype) | string | The SSL policy type for the Application Gateway. |
| [`appGatewaySslProfiles`](#parameter-appgatewaysslprofiles) | array | SSL profiles for the Application Gateway. |
| [`appGatewayTrustedClientCertificates`](#parameter-appgatewaytrustedclientcertificates) | array | Trusted client certificates for mTLS on the Application Gateway. |
| [`appGatewayTrustedRootCertificates`](#parameter-appgatewaytrustedrootcertificates) | array | Trusted root certificates for end-to-end SSL. |
| [`appGatewayUrlPathMaps`](#parameter-appgatewayurlpathmaps) | array | URL path maps for path-based routing on the Application Gateway. |
| [`appInsightsDiagnosticSettings`](#parameter-appinsightsdiagnosticsettings) | array | Diagnostic Settings for App Insights. |
| [`appInsightsDisableIpMasking`](#parameter-appinsightsdisableipmasking) | bool | Disable IP masking in App Insights. |
| [`appInsightsDisableLocalAuth`](#parameter-appinsightsdisablelocalauth) | bool | Disable non-AAD based auth on App Insights. Defaults to true. |
| [`appInsightsFlowType`](#parameter-appinsightsflowtype) | string | Flow type for App Insights. |
| [`appInsightsForceCustomerStorageForProfiler`](#parameter-appinsightsforcecustomerstorageforprofiler) | bool | Force customer storage for profiler in App Insights. |
| [`appInsightsImmediatePurgeDataOn30Days`](#parameter-appinsightsimmediatepurgedataon30days) | bool | Purge data immediately after 30 days in App Insights. |
| [`appInsightsIngestionMode`](#parameter-appinsightsingestionmode) | string | Ingestion mode for App Insights. |
| [`appInsightsKind`](#parameter-appinsightskind) | string | Kind of App Insights resource. |
| [`appInsightsLinkedStorageAccountResourceId`](#parameter-appinsightslinkedstorageaccountresourceid) | string | Linked storage account resource ID for App Insights. |
| [`appInsightsLock`](#parameter-appinsightslock) | object | Specify the type of resource lock for App Insights. |
| [`appInsightsPublicNetworkAccessForIngestion`](#parameter-appinsightspublicnetworkaccessforingestion) | string | Public network access for App Insights ingestion. Defaults to Disabled for secure baseline. |
| [`appInsightsPublicNetworkAccessForQuery`](#parameter-appinsightspublicnetworkaccessforquery) | string | Public network access for App Insights query. Defaults to Disabled for secure baseline. |
| [`appInsightsRequestSource`](#parameter-appinsightsrequestsource) | string | Request source for App Insights. |
| [`appInsightsRetentionInDays`](#parameter-appinsightsretentionindays) | int | App Insights data retention in days. Defaults to 90. |
| [`appInsightsRoleAssignments`](#parameter-appinsightsroleassignments) | array | Role assignments for App Insights. |
| [`appInsightsSamplingPercentage`](#parameter-appinsightssamplingpercentage) | int | App Insights sampling percentage (1-100). Defaults to 100. |
| [`appserviceDiagnosticSettings`](#parameter-appservicediagnosticsettings) | array | Diagnostic Settings for the App Service. |
| [`appServicePlanLock`](#parameter-appserviceplanlock) | object | Specify the type of resource lock for the App Service Plan. |
| [`appServicePlanManagedIdentities`](#parameter-appserviceplanmanagedidentities) | object | Managed identities for the App Service Plan. |
| [`appServicePlanRoleAssignments`](#parameter-appserviceplanroleassignments) | array | Role assignments to apply to the App Service Plan. |
| [`appServicePlanVirtualNetworkSubnetId`](#parameter-appserviceplanvirtualnetworksubnetid) | string | The resource ID of a subnet for VNet integration on the App Service Plan level. |
| [`aseCustomDnsSuffix`](#parameter-asecustomdnssuffix) | string | Custom DNS suffix for the ASE. |
| [`aseDiagnosticSettings`](#parameter-asediagnosticsettings) | array | Diagnostic Settings for the ASE. |
| [`aseIpsslAddressCount`](#parameter-aseipssladdresscount) | int | Number of IP SSL addresses reserved for the ASE. |
| [`aseLock`](#parameter-aselock) | object | Specify the type of resource lock for the ASE. |
| [`aseManagedIdentities`](#parameter-asemanagedidentities) | object | Managed identities for the ASE. |
| [`aseMultiSize`](#parameter-asemultisize) | string | Front-end VM size for the ASE. |
| [`aseRoleAssignments`](#parameter-aseroleassignments) | array | Role assignments for the ASE. |
| [`autoApproveAfdPrivateEndpoint`](#parameter-autoapproveafdprivateendpoint) | bool | Set to true if you want to auto-approve the private endpoint connection to the Azure Front Door. |
| [`autoGeneratedDomainNameLabelScope`](#parameter-autogenerateddomainnamelabelscope) | string | Specifies the scope of uniqueness for the default hostname during resource creation. |
| [`bastionResourceId`](#parameter-bastionresourceid) | string | The resource ID of the bastion host. If set, the spoke virtual network will be peered with the hub virtual network and the bastion host will be allowed to connect to the jump box. Default is empty. |
| [`clientAffinityEnabled`](#parameter-clientaffinityenabled) | bool | If client affinity is enabled on the web app. |
| [`clientAffinityPartitioningEnabled`](#parameter-clientaffinitypartitioningenabled) | bool | Partitioned client affinity using CHIPS cookies. |
| [`clientAffinityProxyEnabled`](#parameter-clientaffinityproxyenabled) | bool | Proxy-based client affinity enabled on the web app. |
| [`clientCertEnabled`](#parameter-clientcertenabled) | bool | Set to true to enable client certificate authentication (mTLS) on the web app. |
| [`clientCertExclusionPaths`](#parameter-clientcertexclusionpaths) | string | Client certificate authentication exclusion paths (comma-separated). |
| [`clientCertMode`](#parameter-clientcertmode) | string | Client certificate mode. Only used when clientCertEnabled is true. |
| [`cloningInfo`](#parameter-cloninginfo) | object | If specified during app creation, the app is cloned from a source app. |
| [`containerImageName`](#parameter-containerimagename) | string | The container image name for container-based deployments (e.g. "mcr.microsoft.com/appsvc/staticsite:latest"). |
| [`containerRegistryPassword`](#parameter-containerregistrypassword) | securestring | The container registry password for private registries. |
| [`containerRegistryUrl`](#parameter-containerregistryurl) | string | The container registry URL for private registries (e.g. "https://myregistry.azurecr.io"). |
| [`containerRegistryUsername`](#parameter-containerregistryusername) | string | The container registry username for private registries. |
| [`containerSize`](#parameter-containersize) | int | Size of the function container. |
| [`customResourceNames`](#parameter-customresourcenames) | object | Custom resource names. Any property not provided falls back to the naming-module default. Use this to comply with organization-specific naming policies without overriding the naming module entirely. |
| [`dailyMemoryTimeQuota`](#parameter-dailymemorytimequota) | int | Maximum allowed daily memory-time quota (applicable on dynamic apps only). |
| [`daprConfig`](#parameter-daprconfig) | object | Dapr configuration for the app (Container Apps). |
| [`ddosProtectionPlanResourceId`](#parameter-ddosprotectionplanresourceid) | string | The resource ID of a DDoS Protection Plan to associate with the spoke VNet. |
| [`deployAseV3`](#parameter-deployasev3) | bool | Default is false. Set to true if you want to deploy ASE v3 instead of Multitenant App Service Plan. |
| [`deployJumpHost`](#parameter-deployjumphost) | bool | Set to true if you want to deploy a jumpbox/devops VM. |
| [`disableBasicPublishingCredentials`](#parameter-disablebasicpublishingcredentials) | bool | Disable basic publishing credentials (FTP/SCM) on the web app. Defaults to true for security. |
| [`disableBgpRoutePropagation`](#parameter-disablebgproutepropagation) | bool | Whether to disable BGP route propagation on the route table. Defaults to true. |
| [`dnsConfiguration`](#parameter-dnsconfiguration) | object | Property to configure DNS-related settings for the site. |
| [`dnsServers`](#parameter-dnsservers) | array | Custom DNS servers for the spoke VNet. If empty, Azure-provided DNS is used. |
| [`e2eEncryptionEnabled`](#parameter-e2eencryptionenabled) | bool | Enable end-to-end encryption (used with ASE). |
| [`elasticScaleEnabled`](#parameter-elasticscaleenabled) | bool | Whether elastic scale is enabled on the App Service Plan. |
| [`enableDefaultWafMethodBlock`](#parameter-enabledefaultwafmethodblock) | bool | Whether to deploy the default WAF custom rule that blocks non-GET/HEAD/OPTIONS methods. Set to false for API backends. |
| [`enableEgressLockdown`](#parameter-enableegresslockdown) | bool | Set to true if you want to intercept all outbound traffic with azure firewall. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`enableVmProtection`](#parameter-enablevmprotection) | bool | Enable VM protection for the VNet. |
| [`environmentName`](#parameter-environmentname) | string | The name of the environmentName (e.g. "dev", "test", "prod", "preprod", "staging", "uat", "dr", "qa"). Up to 8 characters long. |
| [`existingAppServicePlanId`](#parameter-existingappserviceplanid) | string | The resource ID of an existing App Service Plan. If provided, the module will skip creating a new plan and deploy the web app on the existing one. |
| [`extendedLocation`](#parameter-extendedlocation) | object | Extended location of the web app resource. |
| [`firewallInternalIp`](#parameter-firewallinternalip) | string | Internal IP of the Azure firewall deployed in Hub. Used for creating UDR to route all vnet egress traffic through Firewall. If empty no UDR. |
| [`flowTimeoutInMinutes`](#parameter-flowtimeoutinminutes) | int | The flow timeout in minutes for the VNet (max 30). 0 means disabled. |
| [`frontDoorCustomDomains`](#parameter-frontdoorcustomdomains) | array | Custom domains for the Front Door profile. |
| [`frontDoorDiagnosticSettings`](#parameter-frontdoordiagnosticsettings) | array | Diagnostic Settings for Front Door. |
| [`frontDoorHealthProbeIntervalInSeconds`](#parameter-frontdoorhealthprobeintervalinseconds) | int | Health probe interval in seconds for the Front Door origin group. |
| [`frontDoorHealthProbePath`](#parameter-frontdoorhealthprobepath) | string | Health probe path for the Front Door origin group. |
| [`frontDoorLock`](#parameter-frontdoorlock) | object | Specify the type of resource lock for the Front Door profile. |
| [`frontDoorOriginResponseTimeoutSeconds`](#parameter-frontdoororiginresponsetimeoutseconds) | int | The time in seconds before the Front Door origin response times out. Defaults to 120. |
| [`frontDoorRoleAssignments`](#parameter-frontdoorroleassignments) | array | Role assignments for the Front Door profile. |
| [`frontDoorRuleSets`](#parameter-frontdoorrulesets) | array | Rule sets for the Front Door profile. |
| [`frontDoorSecrets`](#parameter-frontdoorsecrets) | array | Secrets for the Front Door profile (e.g. BYOC certificates). |
| [`functionAppConfig`](#parameter-functionappconfig) | object | The Function App configuration object. |
| [`hostNamesDisabled`](#parameter-hostnamesdisabled) | bool | True to disable the public hostnames of the app. |
| [`hostNameSslStates`](#parameter-hostnamesslstates) | array | Hostname SSL states for managing SSL bindings. |
| [`httpsOnly`](#parameter-httpsonly) | bool | Configures the web app to accept only HTTPS requests. |
| [`hybridConnectionRelays`](#parameter-hybridconnectionrelays) | array | Names of hybrid connection relays to connect the app with. |
| [`installScripts`](#parameter-installscripts) | array | Install scripts for the App Service Plan. |
| [`ipMode`](#parameter-ipmode) | string | Specifies the IP mode of the app. |
| [`isCustomMode`](#parameter-iscustommode) | bool | Whether the App Service Plan uses custom mode. |
| [`keyVaultAccessIdentityResourceId`](#parameter-keyvaultaccessidentityresourceid) | string | The resource ID of the identity to use for Key Vault references. |
| [`keyVaultAccessPolicies`](#parameter-keyvaultaccesspolicies) | array | Access policies for the Key Vault (non-RBAC mode). |
| [`keyVaultAdditionalRoleAssignments`](#parameter-keyvaultadditionalroleassignments) | array | Additional role assignments for the Key Vault beyond the default App Service identity. |
| [`keyVaultCreateMode`](#parameter-keyvaultcreatemode) | string | The create mode for the Key Vault (default or recover). |
| [`keyVaultDiagnosticSettings`](#parameter-keyvaultdiagnosticsettings) | array | Diagnostic Settings for the KeyVault. |
| [`keyVaultEnablePurgeProtection`](#parameter-keyvaultenablepurgeprotection) | bool | Enable purge protection for the Key Vault. Defaults to true. |
| [`keyVaultEnableRbacAuthorization`](#parameter-keyvaultenablerbacauthorization) | bool | Enable RBAC authorization on the Key Vault. Defaults to true. |
| [`keyVaultEnableVaultForDeployment`](#parameter-keyvaultenablevaultfordeployment) | bool | Enable the Key Vault for deployment. Defaults to true. |
| [`keyVaultEnableVaultForDiskEncryption`](#parameter-keyvaultenablevaultfordiskencryption) | bool | Enable the Key Vault for disk encryption. |
| [`keyVaultEnableVaultForTemplateDeployment`](#parameter-keyvaultenablevaultfortemplatedeployment) | bool | Enable the Key Vault for template deployment. |
| [`keyVaultKeys`](#parameter-keyvaultkeys) | array | Keys to create in the Key Vault. |
| [`keyVaultLock`](#parameter-keyvaultlock) | object | Specify the type of resource lock for the Key Vault. |
| [`keyVaultNetworkAcls`](#parameter-keyvaultnetworkacls) | object | Network ACLs for the Key Vault. |
| [`keyVaultPublicNetworkAccess`](#parameter-keyvaultpublicnetworkaccess) | string | Public network access for the Key Vault. |
| [`keyVaultSecrets`](#parameter-keyvaultsecrets) | array | Secrets to create in the Key Vault. |
| [`keyVaultSku`](#parameter-keyvaultsku) | string | The SKU of the Key Vault. |
| [`keyVaultSoftDeleteRetentionInDays`](#parameter-keyvaultsoftdeleteretentionindays) | int | Soft delete retention in days for the Key Vault. Defaults to 90. |
| [`location`](#parameter-location) | string | Azure region where the resources will be deployed in. |
| [`managedEnvironmentResourceId`](#parameter-managedenvironmentresourceid) | string | The managed environment resource ID for Azure Container Apps scenarios. |
| [`networkingOption`](#parameter-networkingoption) | string | The networking option to use for ingress. Options: frontDoor (Azure Front Door with WAF), applicationGateway (Application Gateway with WAF), none. |
| [`outboundVnetRouting`](#parameter-outboundvnetrouting) | object | The outbound VNET routing configuration for the site. |
| [`planDefaultIdentity`](#parameter-plandefaultidentity) | object | The default identity for the App Service Plan. |
| [`rdpEnabled`](#parameter-rdpenabled) | bool | Whether RDP is enabled on the App Service Plan. |
| [`redundancyMode`](#parameter-redundancymode) | string | Site redundancy mode. |
| [`registryAdapters`](#parameter-registryadapters) | array | Registry adapter configuration for the App Service Plan. |
| [`resourceConfig`](#parameter-resourceconfig) | object | Function app resource requirements. |
| [`scmSiteAlsoStopped`](#parameter-scmsitealsostopped) | bool | Stop SCM (Kudu) site when the app is stopped. |
| [`servicePlanDiagnosticSettings`](#parameter-serviceplandiagnosticsettings) | array | Diagnostic Settings for the App Service Plan. |
| [`skuCapacity`](#parameter-skucapacity) | int | The SKU capacity (number of workers) for the App Service Plan. |
| [`sshEnabled`](#parameter-sshenabled) | bool | Whether to enable SSH access. |
| [`storageAccountRequired`](#parameter-storageaccountrequired) | bool | Whether customer-provided storage account is required. |
| [`storageMounts`](#parameter-storagemounts) | array | Storage mount configuration for the App Service Plan. |
| [`subnetSpokeAppGwAddressSpace`](#parameter-subnetspokeappgwaddressspace) | string | CIDR of the subnet that will hold the Application Gateway. Required if networkingOption is "applicationGateway". |
| [`subnetSpokeAppSvcAddressSpace`](#parameter-subnetspokeappsvcaddressspace) | string | CIDR of the subnet that will hold the app services plan. ATTENTION: ASEv3 needs a /24 network. |
| [`subnetSpokeJumpboxAddressSpace`](#parameter-subnetspokejumpboxaddressspace) | string | CIDR of the subnet that will hold the jumpbox. |
| [`subnetSpokePrivateEndpointAddressSpace`](#parameter-subnetspokeprivateendpointaddressspace) | string | CIDR of the subnet that will hold the private endpoints of the supporting services. |
| [`tags`](#parameter-tags) | object | Tags to apply to all resources. |
| [`virtualNetworkBgpCommunity`](#parameter-virtualnetworkbgpcommunity) | string | The BGP community for the VNet. |
| [`vmAuthenticationType`](#parameter-vmauthenticationtype) | string | Type of authentication to use on the Virtual Machine. SSH key is recommended. Default is "password". |
| [`vmJumpboxOSType`](#parameter-vmjumpboxostype) | string | Default is windows. The OS of the jump box virtual machine to create. |
| [`vmSize`](#parameter-vmsize) | string | The size of the jump box virtual machine to create. See https://learn.microsoft.com/azure/virtual-machines/sizes for more information. |
| [`vnetDiagnosticSettings`](#parameter-vnetdiagnosticsettings) | array | Diagnostic Settings for the spoke virtual network. |
| [`vnetEncryption`](#parameter-vnetencryption) | bool | Enable VNet encryption. |
| [`vnetEncryptionEnforcement`](#parameter-vnetencryptionenforcement) | string | VNet encryption enforcement. Only used when vnetEncryption is true. |
| [`vnetHubResourceId`](#parameter-vnethubresourceid) | string | Default is empty. If given, peering between spoke and and existing hub vnet will be created. |
| [`vnetLock`](#parameter-vnetlock) | object | Specify the type of resource lock for the spoke virtual network. |
| [`vnetRoleAssignments`](#parameter-vnetroleassignments) | array | Role assignments for the spoke virtual network. |
| [`vnetSpokeAddressSpace`](#parameter-vnetspokeaddressspace) | string | CIDR of the SPOKE vnet i.e. 192.168.0.0/24. |
| [`wafCustomRules`](#parameter-wafcustomrules) | object | Custom WAF rules. Only used when enableDefaultWafMethodBlock is false. |
| [`webAppBaseOs`](#parameter-webappbaseos) | string | Kind of server OS of the App Service Plan. Default is "windows". |
| [`webAppEnabled`](#parameter-webappenabled) | bool | Setting this value to false disables the app (takes the app offline). |
| [`webAppExtensions`](#parameter-webappextensions) | array | Extensions configuration for the web app. |
| [`webAppKind`](#parameter-webappkind) | string | Kind of web app to deploy. Use "app" for standard web apps, "app,linux" for Linux, "app,linux,container" for Linux containers, etc. |
| [`webAppLock`](#parameter-webapplock) | object | Specify the type of resource lock for the Web App. |
| [`webAppPlanSku`](#parameter-webappplansku) | string | The name of the SKU for the App Service Plan. Determines the tier, size, family and capacity. Defaults to P1V3 to leverage availability zones. EP* SKUs are only for Azure Functions elastic premium plans. |
| [`webAppPublicNetworkAccess`](#parameter-webapppublicnetworkaccess) | string | Property to allow or block public network access to the web app. |
| [`webAppReserved`](#parameter-webappreserved) | bool | True if reserved (Linux). Overrides auto-detection when set. |
| [`webAppRoleAssignments`](#parameter-webapproleassignments) | array | Role assignments to apply to the Web App. |
| [`workerTierName`](#parameter-workertiername) | string | Target worker tier assigned to the App Service Plan. |
| [`workloadName`](#parameter-workloadname) | string | suffix (max 10 characters long) that will be used to name the resources in a pattern like <resourceAbbreviation>-<workloadName>. |
| [`workloadProfileName`](#parameter-workloadprofilename) | string | Workload profile name for function app to execute on. |
| [`zoneRedundant`](#parameter-zoneredundant) | bool | Set to true if you want to deploy the App Service Plan in a zone redundant manner. Default is true. |

### Parameter: `logAnalyticsWorkspaceResourceId`

The resource ID of the Log Analytics workspace managed by the Platform Landing Zone. All diagnostic settings will be configured to send logs and metrics to this workspace.

- Required: Yes
- Type: string

### Parameter: `adminPassword`

Required if jumpbox deployed and not using SSH key. The password of the admin user of the jumpbox VM.

- Required: No
- Type: securestring
- Default: `''`

### Parameter: `adminUsername`

Required if jumpbox deployed. The username of the admin user of the jumpbox VM.

- Required: No
- Type: string
- Default: `'azureuser'`

### Parameter: `appGatewayAuthenticationCertificates`

Authentication certificates for Application Gateway backend auth.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `appGatewayBackendSettingsCollection`

Backend settings collection (v2) for the Application Gateway.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `appGatewayCustomErrorConfigurations`

Custom error configurations for the Application Gateway.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `appGatewayDiagnosticSettings`

Diagnostic Settings for the Application Gateway.

- Required: No
- Type: array
- Default: `[]`

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-appgatewaydiagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-appgatewaydiagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-appgatewaydiagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-appgatewaydiagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-appgatewaydiagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-appgatewaydiagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-appgatewaydiagnosticsettingsname) | string | The name of the diagnostic setting. |
| [`storageAccountResourceId`](#parameter-appgatewaydiagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-appgatewaydiagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `appGatewayDiagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `appGatewayDiagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `appGatewayDiagnosticSettings.logAnalyticsDestinationType`

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

### Parameter: `appGatewayDiagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-appgatewaydiagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-appgatewaydiagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-appgatewaydiagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `appGatewayDiagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `appGatewayDiagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `appGatewayDiagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `appGatewayDiagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `appGatewayDiagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-appgatewaydiagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-appgatewaydiagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `appGatewayDiagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `appGatewayDiagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `appGatewayDiagnosticSettings.name`

The name of the diagnostic setting.

- Required: No
- Type: string

### Parameter: `appGatewayDiagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `appGatewayDiagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `appGatewayEnableFips`

Whether FIPS mode is enabled on the Application Gateway.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `appGatewayEnableHttp2`

Whether HTTP/2 is enabled on the Application Gateway. Defaults to true.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `appGatewayEnableRequestBuffering`

Whether request buffering is enabled on the Application Gateway.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `appGatewayEnableResponseBuffering`

Whether response buffering is enabled on the Application Gateway.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `appGatewayListeners`

Listeners (v2) for the Application Gateway.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `appGatewayLoadDistributionPolicies`

Load distribution policies for the Application Gateway.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `appGatewayLock`

Specify the type of resource lock for the Application Gateway.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-appgatewaylockkind) | string | Specify the type of lock. |
| [`name`](#parameter-appgatewaylockname) | string | Specify the name of lock. |
| [`notes`](#parameter-appgatewaylocknotes) | string | Specify the notes of the lock. |

### Parameter: `appGatewayLock.kind`

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

### Parameter: `appGatewayLock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `appGatewayLock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `appGatewayManagedIdentities`

Managed identities for the Application Gateway. Required for Key Vault-referenced SSL certificates.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`systemAssigned`](#parameter-appgatewaymanagedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. |
| [`userAssignedResourceIds`](#parameter-appgatewaymanagedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption. |

### Parameter: `appGatewayManagedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `appGatewayManagedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption.

- Required: No
- Type: array

### Parameter: `appGatewayPrivateEndpoints`

Private endpoints for the Application Gateway.

- Required: No
- Type: array

### Parameter: `appGatewayPrivateLinkConfigurations`

Private link configurations for the Application Gateway.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `appGatewayRedirectConfigurations`

Redirect configurations for the Application Gateway.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `appGatewayRewriteRuleSets`

Rewrite rule sets for the Application Gateway.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `appGatewayRoleAssignments`

Role assignments for the Application Gateway.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-appgatewayroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-appgatewayroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-appgatewayroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-appgatewayroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-appgatewayroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-appgatewayroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-appgatewayroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-appgatewayroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `appGatewayRoleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `appGatewayRoleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `appGatewayRoleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `appGatewayRoleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `appGatewayRoleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `appGatewayRoleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `appGatewayRoleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `appGatewayRoleAssignments.principalType`

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

### Parameter: `appGatewayRoutingRules`

Routing rules (v2) for the Application Gateway.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `appGatewaySslCertificates`

SSL certificates for the Application Gateway. Required for HTTPS termination.

- Required: No
- Type: array

### Parameter: `appGatewaySslPolicyCipherSuites`

SSL cipher suites for the Application Gateway.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `appGatewaySslPolicyMinProtocolVersion`

Minimum TLS protocol version for the Application Gateway.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'TLSv1_2'
    'TLSv1_3'
  ]
  ```

### Parameter: `appGatewaySslPolicyName`

The predefined SSL policy name for the Application Gateway.

- Required: No
- Type: string

### Parameter: `appGatewaySslPolicyType`

The SSL policy type for the Application Gateway.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Custom'
    'CustomV2'
    'Predefined'
  ]
  ```

### Parameter: `appGatewaySslProfiles`

SSL profiles for the Application Gateway.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `appGatewayTrustedClientCertificates`

Trusted client certificates for mTLS on the Application Gateway.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `appGatewayTrustedRootCertificates`

Trusted root certificates for end-to-end SSL.

- Required: No
- Type: array

### Parameter: `appGatewayUrlPathMaps`

URL path maps for path-based routing on the Application Gateway.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `appInsightsDiagnosticSettings`

Diagnostic Settings for App Insights.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-appinsightsdiagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-appinsightsdiagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-appinsightsdiagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-appinsightsdiagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-appinsightsdiagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-appinsightsdiagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-appinsightsdiagnosticsettingsname) | string | The name of the diagnostic setting. |
| [`storageAccountResourceId`](#parameter-appinsightsdiagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-appinsightsdiagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `appInsightsDiagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `appInsightsDiagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `appInsightsDiagnosticSettings.logAnalyticsDestinationType`

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

### Parameter: `appInsightsDiagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-appinsightsdiagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-appinsightsdiagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-appinsightsdiagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `appInsightsDiagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `appInsightsDiagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `appInsightsDiagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `appInsightsDiagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `appInsightsDiagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-appinsightsdiagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-appinsightsdiagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `appInsightsDiagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `appInsightsDiagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `appInsightsDiagnosticSettings.name`

The name of the diagnostic setting.

- Required: No
- Type: string

### Parameter: `appInsightsDiagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `appInsightsDiagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `appInsightsDisableIpMasking`

Disable IP masking in App Insights.

- Required: No
- Type: bool

### Parameter: `appInsightsDisableLocalAuth`

Disable non-AAD based auth on App Insights. Defaults to true.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `appInsightsFlowType`

Flow type for App Insights.

- Required: No
- Type: string

### Parameter: `appInsightsForceCustomerStorageForProfiler`

Force customer storage for profiler in App Insights.

- Required: No
- Type: bool

### Parameter: `appInsightsImmediatePurgeDataOn30Days`

Purge data immediately after 30 days in App Insights.

- Required: No
- Type: bool

### Parameter: `appInsightsIngestionMode`

Ingestion mode for App Insights.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'ApplicationInsights'
    'ApplicationInsightsWithDiagnosticSettings'
    'LogAnalytics'
  ]
  ```

### Parameter: `appInsightsKind`

Kind of App Insights resource.

- Required: No
- Type: string

### Parameter: `appInsightsLinkedStorageAccountResourceId`

Linked storage account resource ID for App Insights.

- Required: No
- Type: string

### Parameter: `appInsightsLock`

Specify the type of resource lock for App Insights.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-appinsightslockkind) | string | Specify the type of lock. |
| [`name`](#parameter-appinsightslockname) | string | Specify the name of lock. |
| [`notes`](#parameter-appinsightslocknotes) | string | Specify the notes of the lock. |

### Parameter: `appInsightsLock.kind`

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

### Parameter: `appInsightsLock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `appInsightsLock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `appInsightsPublicNetworkAccessForIngestion`

Public network access for App Insights ingestion. Defaults to Disabled for secure baseline.

- Required: No
- Type: string
- Default: `'Disabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `appInsightsPublicNetworkAccessForQuery`

Public network access for App Insights query. Defaults to Disabled for secure baseline.

- Required: No
- Type: string
- Default: `'Disabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `appInsightsRequestSource`

Request source for App Insights.

- Required: No
- Type: string

### Parameter: `appInsightsRetentionInDays`

App Insights data retention in days. Defaults to 90.

- Required: No
- Type: int
- Default: `90`

### Parameter: `appInsightsRoleAssignments`

Role assignments for App Insights.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-appinsightsroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-appinsightsroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-appinsightsroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-appinsightsroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-appinsightsroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-appinsightsroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-appinsightsroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-appinsightsroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `appInsightsRoleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `appInsightsRoleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `appInsightsRoleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `appInsightsRoleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `appInsightsRoleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `appInsightsRoleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `appInsightsRoleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `appInsightsRoleAssignments.principalType`

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

### Parameter: `appInsightsSamplingPercentage`

App Insights sampling percentage (1-100). Defaults to 100.

- Required: No
- Type: int
- Default: `100`

### Parameter: `appserviceDiagnosticSettings`

Diagnostic Settings for the App Service.

- Required: No
- Type: array
- Default: `[]`

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-appservicediagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-appservicediagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-appservicediagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-appservicediagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-appservicediagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-appservicediagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-appservicediagnosticsettingsname) | string | The name of the diagnostic setting. |
| [`storageAccountResourceId`](#parameter-appservicediagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-appservicediagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `appserviceDiagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `appserviceDiagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `appserviceDiagnosticSettings.logAnalyticsDestinationType`

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

### Parameter: `appserviceDiagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-appservicediagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-appservicediagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-appservicediagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `appserviceDiagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `appserviceDiagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `appserviceDiagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `appserviceDiagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `appserviceDiagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-appservicediagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-appservicediagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `appserviceDiagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `appserviceDiagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `appserviceDiagnosticSettings.name`

The name of the diagnostic setting.

- Required: No
- Type: string

### Parameter: `appserviceDiagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `appserviceDiagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `appServicePlanLock`

Specify the type of resource lock for the App Service Plan.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-appserviceplanlockkind) | string | Specify the type of lock. |
| [`name`](#parameter-appserviceplanlockname) | string | Specify the name of lock. |
| [`notes`](#parameter-appserviceplanlocknotes) | string | Specify the notes of the lock. |

### Parameter: `appServicePlanLock.kind`

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

### Parameter: `appServicePlanLock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `appServicePlanLock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `appServicePlanManagedIdentities`

Managed identities for the App Service Plan.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`systemAssigned`](#parameter-appserviceplanmanagedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. |
| [`userAssignedResourceIds`](#parameter-appserviceplanmanagedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption. |

### Parameter: `appServicePlanManagedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `appServicePlanManagedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption.

- Required: No
- Type: array

### Parameter: `appServicePlanRoleAssignments`

Role assignments to apply to the App Service Plan.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-appserviceplanroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-appserviceplanroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-appserviceplanroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-appserviceplanroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-appserviceplanroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-appserviceplanroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-appserviceplanroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-appserviceplanroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `appServicePlanRoleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `appServicePlanRoleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `appServicePlanRoleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `appServicePlanRoleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `appServicePlanRoleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `appServicePlanRoleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `appServicePlanRoleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `appServicePlanRoleAssignments.principalType`

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

### Parameter: `appServicePlanVirtualNetworkSubnetId`

The resource ID of a subnet for VNet integration on the App Service Plan level.

- Required: No
- Type: string

### Parameter: `aseCustomDnsSuffix`

Custom DNS suffix for the ASE.

- Required: No
- Type: string

### Parameter: `aseDiagnosticSettings`

Diagnostic Settings for the ASE.

- Required: No
- Type: array
- Default: `[]`

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-asediagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-asediagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-asediagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-asediagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-asediagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`name`](#parameter-asediagnosticsettingsname) | string | The name of diagnostic setting. |
| [`storageAccountResourceId`](#parameter-asediagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-asediagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `aseDiagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `aseDiagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `aseDiagnosticSettings.logAnalyticsDestinationType`

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

### Parameter: `aseDiagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-asediagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-asediagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-asediagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `aseDiagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `aseDiagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `aseDiagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `aseDiagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `aseDiagnosticSettings.name`

The name of diagnostic setting.

- Required: No
- Type: string

### Parameter: `aseDiagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `aseDiagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `aseIpsslAddressCount`

Number of IP SSL addresses reserved for the ASE.

- Required: No
- Type: int

### Parameter: `aseLock`

Specify the type of resource lock for the ASE.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-aselockkind) | string | Specify the type of lock. |
| [`name`](#parameter-aselockname) | string | Specify the name of lock. |
| [`notes`](#parameter-aselocknotes) | string | Specify the notes of the lock. |

### Parameter: `aseLock.kind`

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

### Parameter: `aseLock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `aseLock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `aseManagedIdentities`

Managed identities for the ASE.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`systemAssigned`](#parameter-asemanagedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. |
| [`userAssignedResourceIds`](#parameter-asemanagedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption. |

### Parameter: `aseManagedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `aseManagedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption.

- Required: No
- Type: array

### Parameter: `aseMultiSize`

Front-end VM size for the ASE.

- Required: No
- Type: string

### Parameter: `aseRoleAssignments`

Role assignments for the ASE.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-aseroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-aseroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-aseroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-aseroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-aseroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-aseroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-aseroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-aseroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `aseRoleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `aseRoleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `aseRoleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `aseRoleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `aseRoleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `aseRoleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `aseRoleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `aseRoleAssignments.principalType`

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

### Parameter: `autoApproveAfdPrivateEndpoint`

Set to true if you want to auto-approve the private endpoint connection to the Azure Front Door.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `autoGeneratedDomainNameLabelScope`

Specifies the scope of uniqueness for the default hostname during resource creation.

- Required: No
- Type: string

### Parameter: `bastionResourceId`

The resource ID of the bastion host. If set, the spoke virtual network will be peered with the hub virtual network and the bastion host will be allowed to connect to the jump box. Default is empty.

- Required: No
- Type: string
- Default: `''`

### Parameter: `clientAffinityEnabled`

If client affinity is enabled on the web app.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `clientAffinityPartitioningEnabled`

Partitioned client affinity using CHIPS cookies.

- Required: No
- Type: bool

### Parameter: `clientAffinityProxyEnabled`

Proxy-based client affinity enabled on the web app.

- Required: No
- Type: bool

### Parameter: `clientCertEnabled`

Set to true to enable client certificate authentication (mTLS) on the web app.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `clientCertExclusionPaths`

Client certificate authentication exclusion paths (comma-separated).

- Required: No
- Type: string

### Parameter: `clientCertMode`

Client certificate mode. Only used when clientCertEnabled is true.

- Required: No
- Type: string
- Default: `'Required'`
- Allowed:
  ```Bicep
  [
    'Optional'
    'OptionalInteractiveUser'
    'Required'
  ]
  ```

### Parameter: `cloningInfo`

If specified during app creation, the app is cloned from a source app.

- Required: No
- Type: object

### Parameter: `containerImageName`

The container image name for container-based deployments (e.g. "mcr.microsoft.com/appsvc/staticsite:latest").

- Required: No
- Type: string
- Default: `''`

### Parameter: `containerRegistryPassword`

The container registry password for private registries.

- Required: No
- Type: securestring
- Default: `''`

### Parameter: `containerRegistryUrl`

The container registry URL for private registries (e.g. "https://myregistry.azurecr.io").

- Required: No
- Type: string
- Default: `''`

### Parameter: `containerRegistryUsername`

The container registry username for private registries.

- Required: No
- Type: string
- Default: `''`

### Parameter: `containerSize`

Size of the function container.

- Required: No
- Type: int

### Parameter: `customResourceNames`

Custom resource names. Any property not provided falls back to the naming-module default. Use this to comply with organization-specific naming policies without overriding the naming module entirely.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`afdPeAutoApproverName`](#parameter-customresourcenamesafdpeautoapprovername) | string | Custom name for the AFD private-endpoint auto-approver managed identity. |
| [`appServicePlanName`](#parameter-customresourcenamesappserviceplanname) | string | Custom name for the App Service Plan. |
| [`appSvcManagedIdentityName`](#parameter-customresourcenamesappsvcmanagedidentityname) | string | Custom name for the App Service managed identity. |
| [`aseName`](#parameter-customresourcenamesasename) | string | Custom name for the App Service Environment. |
| [`devOpsSubnetName`](#parameter-customresourcenamesdevopssubnetname) | string | Custom name for the DevOps subnet. |
| [`frontDoorEndpointName`](#parameter-customresourcenamesfrontdoorendpointname) | string | Custom name for the Front Door endpoint. |
| [`frontDoorName`](#parameter-customresourcenamesfrontdoorname) | string | Custom name for the Front Door profile. |
| [`frontDoorOriginGroupName`](#parameter-customresourcenamesfrontdoororigingroupname) | string | Custom name for the Front Door origin group. |
| [`frontDoorWafName`](#parameter-customresourcenamesfrontdoorwafname) | string | Custom name for the Front Door WAF policy. |
| [`jumpboxNsgName`](#parameter-customresourcenamesjumpboxnsgname) | string | Custom name for the jumpbox NSG. |
| [`resourceGroupName`](#parameter-customresourcenamesresourcegroupname) | string | Custom name for the spoke resource group. |
| [`webAppName`](#parameter-customresourcenameswebappname) | string | Custom name for the Web App. |

### Parameter: `customResourceNames.afdPeAutoApproverName`

Custom name for the AFD private-endpoint auto-approver managed identity.

- Required: No
- Type: string

### Parameter: `customResourceNames.appServicePlanName`

Custom name for the App Service Plan.

- Required: No
- Type: string

### Parameter: `customResourceNames.appSvcManagedIdentityName`

Custom name for the App Service managed identity.

- Required: No
- Type: string

### Parameter: `customResourceNames.aseName`

Custom name for the App Service Environment.

- Required: No
- Type: string

### Parameter: `customResourceNames.devOpsSubnetName`

Custom name for the DevOps subnet.

- Required: No
- Type: string

### Parameter: `customResourceNames.frontDoorEndpointName`

Custom name for the Front Door endpoint.

- Required: No
- Type: string

### Parameter: `customResourceNames.frontDoorName`

Custom name for the Front Door profile.

- Required: No
- Type: string

### Parameter: `customResourceNames.frontDoorOriginGroupName`

Custom name for the Front Door origin group.

- Required: No
- Type: string

### Parameter: `customResourceNames.frontDoorWafName`

Custom name for the Front Door WAF policy.

- Required: No
- Type: string

### Parameter: `customResourceNames.jumpboxNsgName`

Custom name for the jumpbox NSG.

- Required: No
- Type: string

### Parameter: `customResourceNames.resourceGroupName`

Custom name for the spoke resource group.

- Required: No
- Type: string

### Parameter: `customResourceNames.webAppName`

Custom name for the Web App.

- Required: No
- Type: string

### Parameter: `dailyMemoryTimeQuota`

Maximum allowed daily memory-time quota (applicable on dynamic apps only).

- Required: No
- Type: int

### Parameter: `daprConfig`

Dapr configuration for the app (Container Apps).

- Required: No
- Type: object

### Parameter: `ddosProtectionPlanResourceId`

The resource ID of a DDoS Protection Plan to associate with the spoke VNet.

- Required: No
- Type: string
- Default: `''`

### Parameter: `deployAseV3`

Default is false. Set to true if you want to deploy ASE v3 instead of Multitenant App Service Plan.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `deployJumpHost`

Set to true if you want to deploy a jumpbox/devops VM.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `disableBasicPublishingCredentials`

Disable basic publishing credentials (FTP/SCM) on the web app. Defaults to true for security.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `disableBgpRoutePropagation`

Whether to disable BGP route propagation on the route table. Defaults to true.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `dnsConfiguration`

Property to configure DNS-related settings for the site.

- Required: No
- Type: object

### Parameter: `dnsServers`

Custom DNS servers for the spoke VNet. If empty, Azure-provided DNS is used.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `e2eEncryptionEnabled`

Enable end-to-end encryption (used with ASE).

- Required: No
- Type: bool

### Parameter: `elasticScaleEnabled`

Whether elastic scale is enabled on the App Service Plan.

- Required: No
- Type: bool

### Parameter: `enableDefaultWafMethodBlock`

Whether to deploy the default WAF custom rule that blocks non-GET/HEAD/OPTIONS methods. Set to false for API backends.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableEgressLockdown`

Set to true if you want to intercept all outbound traffic with azure firewall.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableVmProtection`

Enable VM protection for the VNet.

- Required: No
- Type: bool

### Parameter: `environmentName`

The name of the environmentName (e.g. "dev", "test", "prod", "preprod", "staging", "uat", "dr", "qa"). Up to 8 characters long.

- Required: No
- Type: string
- Default: `'test'`

### Parameter: `existingAppServicePlanId`

The resource ID of an existing App Service Plan. If provided, the module will skip creating a new plan and deploy the web app on the existing one.

- Required: No
- Type: string
- Default: `''`

### Parameter: `extendedLocation`

Extended location of the web app resource.

- Required: No
- Type: object

### Parameter: `firewallInternalIp`

Internal IP of the Azure firewall deployed in Hub. Used for creating UDR to route all vnet egress traffic through Firewall. If empty no UDR.

- Required: No
- Type: string
- Default: `''`

### Parameter: `flowTimeoutInMinutes`

The flow timeout in minutes for the VNet (max 30). 0 means disabled.

- Required: No
- Type: int
- Default: `0`

### Parameter: `frontDoorCustomDomains`

Custom domains for the Front Door profile.

- Required: No
- Type: array

### Parameter: `frontDoorDiagnosticSettings`

Diagnostic Settings for Front Door.

- Required: No
- Type: array
- Default: `[]`

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-frontdoordiagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-frontdoordiagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-frontdoordiagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-frontdoordiagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-frontdoordiagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-frontdoordiagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-frontdoordiagnosticsettingsname) | string | The name of the diagnostic setting. |
| [`storageAccountResourceId`](#parameter-frontdoordiagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-frontdoordiagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `frontDoorDiagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `frontDoorDiagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `frontDoorDiagnosticSettings.logAnalyticsDestinationType`

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

### Parameter: `frontDoorDiagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-frontdoordiagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-frontdoordiagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-frontdoordiagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `frontDoorDiagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `frontDoorDiagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `frontDoorDiagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `frontDoorDiagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `frontDoorDiagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-frontdoordiagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-frontdoordiagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `frontDoorDiagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `frontDoorDiagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `frontDoorDiagnosticSettings.name`

The name of the diagnostic setting.

- Required: No
- Type: string

### Parameter: `frontDoorDiagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `frontDoorDiagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `frontDoorHealthProbeIntervalInSeconds`

Health probe interval in seconds for the Front Door origin group.

- Required: No
- Type: int
- Default: `100`

### Parameter: `frontDoorHealthProbePath`

Health probe path for the Front Door origin group.

- Required: No
- Type: string
- Default: `'/'`

### Parameter: `frontDoorLock`

Specify the type of resource lock for the Front Door profile.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-frontdoorlockkind) | string | Specify the type of lock. |
| [`name`](#parameter-frontdoorlockname) | string | Specify the name of lock. |
| [`notes`](#parameter-frontdoorlocknotes) | string | Specify the notes of the lock. |

### Parameter: `frontDoorLock.kind`

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

### Parameter: `frontDoorLock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `frontDoorLock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `frontDoorOriginResponseTimeoutSeconds`

The time in seconds before the Front Door origin response times out. Defaults to 120.

- Required: No
- Type: int
- Default: `120`

### Parameter: `frontDoorRoleAssignments`

Role assignments for the Front Door profile.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-frontdoorroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-frontdoorroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-frontdoorroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-frontdoorroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-frontdoorroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-frontdoorroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-frontdoorroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-frontdoorroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `frontDoorRoleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `frontDoorRoleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `frontDoorRoleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `frontDoorRoleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `frontDoorRoleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `frontDoorRoleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `frontDoorRoleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `frontDoorRoleAssignments.principalType`

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

### Parameter: `frontDoorRuleSets`

Rule sets for the Front Door profile.

- Required: No
- Type: array

### Parameter: `frontDoorSecrets`

Secrets for the Front Door profile (e.g. BYOC certificates).

- Required: No
- Type: array

### Parameter: `functionAppConfig`

The Function App configuration object.

- Required: No
- Type: object

### Parameter: `hostNamesDisabled`

True to disable the public hostnames of the app.

- Required: No
- Type: bool

### Parameter: `hostNameSslStates`

Hostname SSL states for managing SSL bindings.

- Required: No
- Type: array

### Parameter: `httpsOnly`

Configures the web app to accept only HTTPS requests.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `hybridConnectionRelays`

Names of hybrid connection relays to connect the app with.

- Required: No
- Type: array

### Parameter: `installScripts`

Install scripts for the App Service Plan.

- Required: No
- Type: array

### Parameter: `ipMode`

Specifies the IP mode of the app.

- Required: No
- Type: string

### Parameter: `isCustomMode`

Whether the App Service Plan uses custom mode.

- Required: No
- Type: bool

### Parameter: `keyVaultAccessIdentityResourceId`

The resource ID of the identity to use for Key Vault references.

- Required: No
- Type: string

### Parameter: `keyVaultAccessPolicies`

Access policies for the Key Vault (non-RBAC mode).

- Required: No
- Type: array

### Parameter: `keyVaultAdditionalRoleAssignments`

Additional role assignments for the Key Vault beyond the default App Service identity.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-keyvaultadditionalroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-keyvaultadditionalroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-keyvaultadditionalroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-keyvaultadditionalroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-keyvaultadditionalroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-keyvaultadditionalroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-keyvaultadditionalroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-keyvaultadditionalroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `keyVaultAdditionalRoleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `keyVaultAdditionalRoleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `keyVaultAdditionalRoleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `keyVaultAdditionalRoleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `keyVaultAdditionalRoleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `keyVaultAdditionalRoleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `keyVaultAdditionalRoleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `keyVaultAdditionalRoleAssignments.principalType`

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

### Parameter: `keyVaultCreateMode`

The create mode for the Key Vault (default or recover).

- Required: No
- Type: string
- Default: `'default'`
- Allowed:
  ```Bicep
  [
    'default'
    'recover'
  ]
  ```

### Parameter: `keyVaultDiagnosticSettings`

Diagnostic Settings for the KeyVault.

- Required: No
- Type: array
- Default: `[]`

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-keyvaultdiagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-keyvaultdiagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-keyvaultdiagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-keyvaultdiagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-keyvaultdiagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-keyvaultdiagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-keyvaultdiagnosticsettingsname) | string | The name of the diagnostic setting. |
| [`storageAccountResourceId`](#parameter-keyvaultdiagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-keyvaultdiagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `keyVaultDiagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `keyVaultDiagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `keyVaultDiagnosticSettings.logAnalyticsDestinationType`

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

### Parameter: `keyVaultDiagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-keyvaultdiagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-keyvaultdiagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-keyvaultdiagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `keyVaultDiagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `keyVaultDiagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `keyVaultDiagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `keyVaultDiagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `keyVaultDiagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-keyvaultdiagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-keyvaultdiagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `keyVaultDiagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `keyVaultDiagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `keyVaultDiagnosticSettings.name`

The name of the diagnostic setting.

- Required: No
- Type: string

### Parameter: `keyVaultDiagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `keyVaultDiagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `keyVaultEnablePurgeProtection`

Enable purge protection for the Key Vault. Defaults to true.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `keyVaultEnableRbacAuthorization`

Enable RBAC authorization on the Key Vault. Defaults to true.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `keyVaultEnableVaultForDeployment`

Enable the Key Vault for deployment. Defaults to true.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `keyVaultEnableVaultForDiskEncryption`

Enable the Key Vault for disk encryption.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `keyVaultEnableVaultForTemplateDeployment`

Enable the Key Vault for template deployment.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `keyVaultKeys`

Keys to create in the Key Vault.

- Required: No
- Type: array

### Parameter: `keyVaultLock`

Specify the type of resource lock for the Key Vault.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-keyvaultlockkind) | string | Specify the type of lock. |
| [`name`](#parameter-keyvaultlockname) | string | Specify the name of lock. |
| [`notes`](#parameter-keyvaultlocknotes) | string | Specify the notes of the lock. |

### Parameter: `keyVaultLock.kind`

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

### Parameter: `keyVaultLock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `keyVaultLock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `keyVaultNetworkAcls`

Network ACLs for the Key Vault.

- Required: No
- Type: object

### Parameter: `keyVaultPublicNetworkAccess`

Public network access for the Key Vault.

- Required: No
- Type: string
- Default: `'Disabled'`
- Allowed:
  ```Bicep
  [
    ''
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `keyVaultSecrets`

Secrets to create in the Key Vault.

- Required: No
- Type: array

### Parameter: `keyVaultSku`

The SKU of the Key Vault.

- Required: No
- Type: string
- Default: `'standard'`
- Allowed:
  ```Bicep
  [
    'premium'
    'standard'
  ]
  ```

### Parameter: `keyVaultSoftDeleteRetentionInDays`

Soft delete retention in days for the Key Vault. Defaults to 90.

- Required: No
- Type: int
- Default: `90`

### Parameter: `location`

Azure region where the resources will be deployed in.

- Required: No
- Type: string
- Default: `[deployment().location]`

### Parameter: `managedEnvironmentResourceId`

The managed environment resource ID for Azure Container Apps scenarios.

- Required: No
- Type: string

### Parameter: `networkingOption`

The networking option to use for ingress. Options: frontDoor (Azure Front Door with WAF), applicationGateway (Application Gateway with WAF), none.

- Required: No
- Type: string
- Default: `'frontDoor'`
- Allowed:
  ```Bicep
  [
    'applicationGateway'
    'frontDoor'
    'none'
  ]
  ```

### Parameter: `outboundVnetRouting`

The outbound VNET routing configuration for the site.

- Required: No
- Type: object

### Parameter: `planDefaultIdentity`

The default identity for the App Service Plan.

- Required: No
- Type: object

### Parameter: `rdpEnabled`

Whether RDP is enabled on the App Service Plan.

- Required: No
- Type: bool

### Parameter: `redundancyMode`

Site redundancy mode.

- Required: No
- Type: string
- Default: `'None'`
- Allowed:
  ```Bicep
  [
    'ActiveActive'
    'Failover'
    'GeoRedundant'
    'Manual'
    'None'
  ]
  ```

### Parameter: `registryAdapters`

Registry adapter configuration for the App Service Plan.

- Required: No
- Type: array

### Parameter: `resourceConfig`

Function app resource requirements.

- Required: No
- Type: object

### Parameter: `scmSiteAlsoStopped`

Stop SCM (Kudu) site when the app is stopped.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `servicePlanDiagnosticSettings`

Diagnostic Settings for the App Service Plan.

- Required: No
- Type: array
- Default: `[]`

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-serviceplandiagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-serviceplandiagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-serviceplandiagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`marketplacePartnerResourceId`](#parameter-serviceplandiagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-serviceplandiagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-serviceplandiagnosticsettingsname) | string | The name of diagnostic setting. |
| [`storageAccountResourceId`](#parameter-serviceplandiagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-serviceplandiagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `servicePlanDiagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `servicePlanDiagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `servicePlanDiagnosticSettings.logAnalyticsDestinationType`

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

### Parameter: `servicePlanDiagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `servicePlanDiagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-serviceplandiagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-serviceplandiagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `servicePlanDiagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `servicePlanDiagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `servicePlanDiagnosticSettings.name`

The name of diagnostic setting.

- Required: No
- Type: string

### Parameter: `servicePlanDiagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `servicePlanDiagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `skuCapacity`

The SKU capacity (number of workers) for the App Service Plan.

- Required: No
- Type: int

### Parameter: `sshEnabled`

Whether to enable SSH access.

- Required: No
- Type: bool

### Parameter: `storageAccountRequired`

Whether customer-provided storage account is required.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `storageMounts`

Storage mount configuration for the App Service Plan.

- Required: No
- Type: array

### Parameter: `subnetSpokeAppGwAddressSpace`

CIDR of the subnet that will hold the Application Gateway. Required if networkingOption is "applicationGateway".

- Required: No
- Type: string
- Default: `''`

### Parameter: `subnetSpokeAppSvcAddressSpace`

CIDR of the subnet that will hold the app services plan. ATTENTION: ASEv3 needs a /24 network.

- Required: No
- Type: string
- Default: `'10.240.0.0/26'`

### Parameter: `subnetSpokeJumpboxAddressSpace`

CIDR of the subnet that will hold the jumpbox.

- Required: No
- Type: string
- Default: `'10.240.10.128/26'`

### Parameter: `subnetSpokePrivateEndpointAddressSpace`

CIDR of the subnet that will hold the private endpoints of the supporting services.

- Required: No
- Type: string
- Default: `'10.240.11.0/24'`

### Parameter: `tags`

Tags to apply to all resources.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `virtualNetworkBgpCommunity`

The BGP community for the VNet.

- Required: No
- Type: string

### Parameter: `vmAuthenticationType`

Type of authentication to use on the Virtual Machine. SSH key is recommended. Default is "password".

- Required: No
- Type: string
- Default: `'password'`
- Allowed:
  ```Bicep
  [
    'password'
    'sshPublicKey'
  ]
  ```

### Parameter: `vmJumpboxOSType`

Default is windows. The OS of the jump box virtual machine to create.

- Required: No
- Type: string
- Default: `'windows'`
- Allowed:
  ```Bicep
  [
    'linux'
    'none'
    'windows'
  ]
  ```

### Parameter: `vmSize`

The size of the jump box virtual machine to create. See https://learn.microsoft.com/azure/virtual-machines/sizes for more information.

- Required: No
- Type: string
- Default: `'Standard_D2s_v4'`

### Parameter: `vnetDiagnosticSettings`

Diagnostic Settings for the spoke virtual network.

- Required: No
- Type: array
- Default: `[]`

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-vnetdiagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-vnetdiagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-vnetdiagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-vnetdiagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-vnetdiagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-vnetdiagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-vnetdiagnosticsettingsname) | string | The name of the diagnostic setting. |
| [`storageAccountResourceId`](#parameter-vnetdiagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-vnetdiagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `vnetDiagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `vnetDiagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `vnetDiagnosticSettings.logAnalyticsDestinationType`

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

### Parameter: `vnetDiagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-vnetdiagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-vnetdiagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-vnetdiagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `vnetDiagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `vnetDiagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `vnetDiagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `vnetDiagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `vnetDiagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-vnetdiagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-vnetdiagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `vnetDiagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `vnetDiagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `vnetDiagnosticSettings.name`

The name of the diagnostic setting.

- Required: No
- Type: string

### Parameter: `vnetDiagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `vnetDiagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `vnetEncryption`

Enable VNet encryption.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `vnetEncryptionEnforcement`

VNet encryption enforcement. Only used when vnetEncryption is true.

- Required: No
- Type: string
- Default: `'AllowUnencrypted'`
- Allowed:
  ```Bicep
  [
    'AllowUnencrypted'
    'DropUnencrypted'
  ]
  ```

### Parameter: `vnetHubResourceId`

Default is empty. If given, peering between spoke and and existing hub vnet will be created.

- Required: No
- Type: string
- Default: `''`

### Parameter: `vnetLock`

Specify the type of resource lock for the spoke virtual network.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-vnetlockkind) | string | Specify the type of lock. |
| [`name`](#parameter-vnetlockname) | string | Specify the name of lock. |
| [`notes`](#parameter-vnetlocknotes) | string | Specify the notes of the lock. |

### Parameter: `vnetLock.kind`

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

### Parameter: `vnetLock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `vnetLock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `vnetRoleAssignments`

Role assignments for the spoke virtual network.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-vnetroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-vnetroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-vnetroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-vnetroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-vnetroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-vnetroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-vnetroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-vnetroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `vnetRoleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `vnetRoleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `vnetRoleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `vnetRoleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `vnetRoleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `vnetRoleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `vnetRoleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `vnetRoleAssignments.principalType`

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

### Parameter: `vnetSpokeAddressSpace`

CIDR of the SPOKE vnet i.e. 192.168.0.0/24.

- Required: No
- Type: string
- Default: `'10.240.0.0/20'`

### Parameter: `wafCustomRules`

Custom WAF rules. Only used when enableDefaultWafMethodBlock is false.

- Required: No
- Type: object

### Parameter: `webAppBaseOs`

Kind of server OS of the App Service Plan. Default is "windows".

- Required: No
- Type: string
- Default: `'windows'`
- Allowed:
  ```Bicep
  [
    'linux'
    'windows'
  ]
  ```

### Parameter: `webAppEnabled`

Setting this value to false disables the app (takes the app offline).

- Required: No
- Type: bool
- Default: `True`

### Parameter: `webAppExtensions`

Extensions configuration for the web app.

- Required: No
- Type: array

### Parameter: `webAppKind`

Kind of web app to deploy. Use "app" for standard web apps, "app,linux" for Linux, "app,linux,container" for Linux containers, etc.

- Required: No
- Type: string
- Default: `'app'`
- Allowed:
  ```Bicep
  [
    'api'
    'app'
    'app,container,windows'
    'app,linux'
    'app,linux,container'
    'functionapp'
    'functionapp,linux'
    'functionapp,linux,container'
    'functionapp,linux,container,azurecontainerapps'
    'functionapp,workflowapp'
    'functionapp,workflowapp,linux'
    'linux,api'
  ]
  ```

### Parameter: `webAppLock`

Specify the type of resource lock for the Web App.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-webapplockkind) | string | Specify the type of lock. |
| [`name`](#parameter-webapplockname) | string | Specify the name of lock. |
| [`notes`](#parameter-webapplocknotes) | string | Specify the notes of the lock. |

### Parameter: `webAppLock.kind`

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

### Parameter: `webAppLock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `webAppLock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `webAppPlanSku`

The name of the SKU for the App Service Plan. Determines the tier, size, family and capacity. Defaults to P1V3 to leverage availability zones. EP* SKUs are only for Azure Functions elastic premium plans.

- Required: No
- Type: string
- Default: `'P1V3'`
- Example:
  ```Bicep
  // Premium v4
  'P0v4'
  'P1v4'
  'P2v4'
  'P3v4'
  // Premium Memory Optimized v4
  'P1mv4'
  'P3mv4'
  'P4mv4'
  'P5mv4'
  // Isolated v2
  'I1v2'
  'I2v2'
  'I3v2'
  'I4v2'
  'I5v2'
  'I6v2'
  // Functions Elastic Premium
  'EP1'
  'EP2'
  'EP3'
  ```

### Parameter: `webAppPublicNetworkAccess`

Property to allow or block public network access to the web app.

- Required: No
- Type: string
- Default: `''`
- Allowed:
  ```Bicep
  [
    ''
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `webAppReserved`

True if reserved (Linux). Overrides auto-detection when set.

- Required: No
- Type: bool

### Parameter: `webAppRoleAssignments`

Role assignments to apply to the Web App.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-webapproleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-webapproleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-webapproleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-webapproleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-webapproleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-webapproleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-webapproleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-webapproleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `webAppRoleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `webAppRoleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `webAppRoleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `webAppRoleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `webAppRoleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `webAppRoleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `webAppRoleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `webAppRoleAssignments.principalType`

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

### Parameter: `workerTierName`

Target worker tier assigned to the App Service Plan.

- Required: No
- Type: string

### Parameter: `workloadName`

suffix (max 10 characters long) that will be used to name the resources in a pattern like <resourceAbbreviation>-<workloadName>.

- Required: No
- Type: string
- Default: `[format('appsvc{0}', take(uniqueString(subscription().id), 4))]`

### Parameter: `workloadProfileName`

Workload profile name for function app to execute on.

- Required: No
- Type: string

### Parameter: `zoneRedundant`

Set to true if you want to deploy the App Service Plan in a zone redundant manner. Default is true.

- Required: No
- Type: bool
- Default: `True`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `keyVaultName` | string | The name of the Azure key vault. |
| `keyVaultResourceId` | string | The resource ID of the key vault. |
| `spokeResourceGroupName` | string | The name of the Spoke resource group. |
| `spokeVnetName` | string | The name of the Spoke Virtual Network. |
| `spokeVNetResourceId` | string | The resource ID of the Spoke Virtual Network. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/cdn/profile:0.17.2` | Remote reference |
| `br/public:avm/res/compute/ssh-public-key:0.4.4` | Remote reference |
| `br/public:avm/res/compute/virtual-machine:0.21.0` | Remote reference |
| `br/public:avm/res/insights/component:0.7.1` | Remote reference |
| `br/public:avm/res/insights/data-collection-rule:0.10.0` | Remote reference |
| `br/public:avm/res/key-vault/vault:0.13.3` | Remote reference |
| `br/public:avm/res/maintenance/maintenance-configuration:0.3.2` | Remote reference |
| `br/public:avm/res/managed-identity/user-assigned-identity:0.5.0` | Remote reference |
| `br/public:avm/res/network/application-gateway-web-application-firewall-policy:0.2.1` | Remote reference |
| `br/public:avm/res/network/application-gateway:0.8.0` | Remote reference |
| `br/public:avm/res/network/front-door-web-application-firewall-policy:0.3.3` | Remote reference |
| `br/public:avm/res/network/network-security-group:0.5.2` | Remote reference |
| `br/public:avm/res/network/private-dns-zone:0.8.0` | Remote reference |
| `br/public:avm/res/network/private-endpoint:0.11.1` | Remote reference |
| `br/public:avm/res/network/public-ip-address:0.12.0` | Remote reference |
| `br/public:avm/res/network/route-table:0.5.0` | Remote reference |
| `br/public:avm/res/network/virtual-network:0.7.2` | Remote reference |
| `br/public:avm/res/network/virtual-network/subnet:0.1.3` | Remote reference |
| `br/public:avm/res/resources/deployment-script:0.5.2` | Remote reference |
| `br/public:avm/res/resources/resource-group:0.4.3` | Remote reference |
| `br/public:avm/res/web/hosting-environment:0.5.0` | Remote reference |
| `br/public:avm/res/web/serverfarm:0.7.0` | Remote reference |
| `br/public:avm/res/web/site:0.22.0` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.7.0` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
