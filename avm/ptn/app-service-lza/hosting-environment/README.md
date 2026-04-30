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
| `Microsoft.Cdn/profiles` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cdn_profiles.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2025-06-01/profiles)</li></ul> |
| `Microsoft.Cdn/profiles/afdEndpoints` | 2025-04-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cdn_profiles_afdendpoints.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2025-04-15/profiles/afdEndpoints)</li></ul> |
| `Microsoft.Cdn/profiles/afdEndpoints/routes` | 2025-04-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cdn_profiles_afdendpoints_routes.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2025-04-15/profiles/afdEndpoints/routes)</li></ul> |
| `Microsoft.Cdn/profiles/customDomains` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cdn_profiles_customdomains.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2025-06-01/profiles/customDomains)</li></ul> |
| `Microsoft.Cdn/profiles/endpoints` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cdn_profiles_endpoints.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2025-06-01/profiles/endpoints)</li></ul> |
| `Microsoft.Cdn/profiles/endpoints/origins` | 2025-04-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cdn_profiles_endpoints_origins.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2025-04-15/profiles/endpoints/origins)</li></ul> |
| `Microsoft.Cdn/profiles/originGroups` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cdn_profiles_origingroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2025-06-01/profiles/originGroups)</li></ul> |
| `Microsoft.Cdn/profiles/originGroups/origins` | 2025-04-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cdn_profiles_origingroups_origins.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2025-04-15/profiles/originGroups/origins)</li></ul> |
| `Microsoft.Cdn/profiles/ruleSets` | 2025-04-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cdn_profiles_rulesets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2025-04-15/profiles/ruleSets)</li></ul> |
| `Microsoft.Cdn/profiles/ruleSets/rules` | 2025-04-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cdn_profiles_rulesets_rules.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2025-04-15/profiles/ruleSets/rules)</li></ul> |
| `Microsoft.Cdn/profiles/secrets` | 2025-04-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cdn_profiles_secrets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2025-04-15/profiles/secrets)</li></ul> |
| `Microsoft.Cdn/profiles/securityPolicies` | 2025-04-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cdn_profiles_securitypolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2025-04-15/profiles/securityPolicies)</li></ul> |
| `Microsoft.Insights/components` | 2020-02-02 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_components.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2020-02-02/components)</li></ul> |
| `microsoft.insights/components/linkedStorageAccounts` | 2020-03-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_components_linkedstorageaccounts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/microsoft.insights/2020-03-01-preview/components/linkedStorageAccounts)</li></ul> |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_diagnosticsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)</li></ul> |
| `Microsoft.KeyVault/vaults` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2024-11-01/vaults)</li></ul> |
| `Microsoft.KeyVault/vaults/accessPolicies` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults_accesspolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2024-11-01/vaults/accessPolicies)</li></ul> |
| `Microsoft.KeyVault/vaults/keys` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults_keys.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2024-11-01/vaults/keys)</li></ul> |
| `Microsoft.KeyVault/vaults/secrets` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults_secrets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2024-11-01/vaults/secrets)</li></ul> |
| `Microsoft.ManagedIdentity/userAssignedIdentities` | 2024-11-30 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.managedidentity_userassignedidentities.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2024-11-30/userAssignedIdentities)</li></ul> |
| `Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials` | 2024-11-30 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.managedidentity_userassignedidentities_federatedidentitycredentials.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2024-11-30/userAssignedIdentities/federatedIdentityCredentials)</li></ul> |
| `Microsoft.Network/applicationGateways` | 2025-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_applicationgateways.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-05-01/applicationGateways)</li></ul> |
| `Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies` | 2025-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_applicationgatewaywebapplicationfirewallpolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-05-01/ApplicationGatewayWebApplicationFirewallPolicies)</li></ul> |
| `Microsoft.Network/FrontDoorWebApplicationFirewallPolicies` | 2024-02-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_frontdoorwebapplicationfirewallpolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-02-01/FrontDoorWebApplicationFirewallPolicies)</li></ul> |
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
| `Microsoft.Network/privateEndpoints` | 2025-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-05-01/privateEndpoints)</li></ul> |
| `Microsoft.Network/privateEndpoints` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/privateEndpoints)</li></ul> |
| `Microsoft.Network/privateEndpoints` | 2024-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-10-01/privateEndpoints)</li></ul> |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2024-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints_privatednszonegroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-10-01/privateEndpoints/privateDnsZoneGroups)</li></ul> |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2025-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints_privatednszonegroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-05-01/privateEndpoints/privateDnsZoneGroups)</li></ul> |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints_privatednszonegroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/privateEndpoints/privateDnsZoneGroups)</li></ul> |
| `Microsoft.Network/publicIPAddresses` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_publicipaddresses.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-01-01/publicIPAddresses)</li></ul> |
| `Microsoft.Network/routeTables` | 2024-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_routetables.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-07-01/routeTables)</li></ul> |
| `Microsoft.Network/virtualNetworks` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_virtualnetworks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/virtualNetworks)</li></ul> |
| `Microsoft.Network/virtualNetworks/subnets` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_virtualnetworks_subnets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/virtualNetworks/subnets)</li></ul> |
| `Microsoft.Network/virtualNetworks/virtualNetworkPeerings` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_virtualnetworks_virtualnetworkpeerings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-01-01/virtualNetworks/virtualNetworkPeerings)</li></ul> |
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

- [App Service Environment](#example-1-app-service-environment)
- [Bring Your Own Storage](#example-2-bring-your-own-storage)
- [Application Gateway with Linux container and egress lockdown](#example-3-application-gateway-with-linux-container-and-egress-lockdown)
- [Existing App Service Plan](#example-4-existing-app-service-plan)
- [Front Door](#example-5-front-door)
- [Managed Instance](#example-6-managed-instance)

### Example 1: _App Service Environment_

This instance deploys ASE v3 with a Linux container workload behind Application Gateway.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/ase]


<details>

<summary>via Bicep module</summary>

```bicep
module hostingEnvironment 'br/public:avm/ptn/app-service-lza/hosting-environment:<version>' = {
  params: {
    // Required parameters
    logAnalyticsWorkspaceResourceId: '<logAnalyticsWorkspaceResourceId>'
    // Non-required parameters
    appServiceConfig: {
      container: {
        imageName: 'mcr.microsoft.com/appsvc/staticsite:latest'
      }
      kind: 'app,linux,container'
    }
    deployAseV3: true
    location: '<location>'
    servicePlanConfig: {
      kind: 'linux'
      sku: 'I1v2'
    }
    spokeNetworkConfig: {
      appGwSubnetAddressSpace: '10.240.12.0/24'
      appSvcSubnetAddressSpace: '10.240.0.0/24'
      ingressOption: 'applicationGateway'
      resourceGroupName: '<resourceGroupName>'
    }
    tags: {
      environment: 'test'
      scenario: 'ase'
    }
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
    "appServiceConfig": {
      "value": {
        "container": {
          "imageName": "mcr.microsoft.com/appsvc/staticsite:latest"
        },
        "kind": "app,linux,container"
      }
    },
    "deployAseV3": {
      "value": true
    },
    "location": {
      "value": "<location>"
    },
    "servicePlanConfig": {
      "value": {
        "kind": "linux",
        "sku": "I1v2"
      }
    },
    "spokeNetworkConfig": {
      "value": {
        "appGwSubnetAddressSpace": "10.240.12.0/24",
        "appSvcSubnetAddressSpace": "10.240.0.0/24",
        "ingressOption": "applicationGateway",
        "resourceGroupName": "<resourceGroupName>"
      }
    },
    "tags": {
      "value": {
        "environment": "test",
        "scenario": "ase"
      }
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
param appServiceConfig = {
  container: {
    imageName: 'mcr.microsoft.com/appsvc/staticsite:latest'
  }
  kind: 'app,linux,container'
}
deployAseV3: true
param location = '<location>'
param servicePlanConfig = {
  kind: 'linux'
  sku: 'I1v2'
}
param spokeNetworkConfig = {
  appGwSubnetAddressSpace: '10.240.12.0/24'
  appSvcSubnetAddressSpace: '10.240.0.0/24'
  ingressOption: 'applicationGateway'
  resourceGroupName: '<resourceGroupName>'
}
param tags = {
  environment: 'test'
  scenario: 'ase'
}
param workloadName = '<workloadName>'
```

</details>
<p>

### Example 2: _Bring Your Own Storage_

This instance deploys the module with Azure Files mounted as custom storage (BYOS) on a Linux web app behind Application Gateway.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/byos]


<details>

<summary>via Bicep module</summary>

```bicep
module hostingEnvironment 'br/public:avm/ptn/app-service-lza/hosting-environment:<version>' = {
  params: {
    // Required parameters
    logAnalyticsWorkspaceResourceId: '<logAnalyticsWorkspaceResourceId>'
    // Non-required parameters
    appServiceConfig: {
      kind: 'app,linux'
      storageAccounts: {
        appdata: {
          accessKey: '<accessKey>'
          accountName: '<accountName>'
          mountPath: '/mnt/appdata'
          protocol: 'Smb'
          shareName: '<shareName>'
          type: 'AzureFiles'
        }
      }
    }
    location: '<location>'
    servicePlanConfig: {
      kind: 'linux'
    }
    spokeNetworkConfig: {
      appGwSubnetAddressSpace: '10.240.12.0/24'
      ingressOption: 'applicationGateway'
      resourceGroupName: '<resourceGroupName>'
    }
    tags: {
      environment: 'test'
      scenario: 'byos'
    }
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
    "appServiceConfig": {
      "value": {
        "kind": "app,linux",
        "storageAccounts": {
          "appdata": {
            "accessKey": "<accessKey>",
            "accountName": "<accountName>",
            "mountPath": "/mnt/appdata",
            "protocol": "Smb",
            "shareName": "<shareName>",
            "type": "AzureFiles"
          }
        }
      }
    },
    "location": {
      "value": "<location>"
    },
    "servicePlanConfig": {
      "value": {
        "kind": "linux"
      }
    },
    "spokeNetworkConfig": {
      "value": {
        "appGwSubnetAddressSpace": "10.240.12.0/24",
        "ingressOption": "applicationGateway",
        "resourceGroupName": "<resourceGroupName>"
      }
    },
    "tags": {
      "value": {
        "environment": "test",
        "scenario": "byos"
      }
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
param appServiceConfig = {
  kind: 'app,linux'
  storageAccounts: {
    appdata: {
      accessKey: '<accessKey>'
      accountName: '<accountName>'
      mountPath: '/mnt/appdata'
      protocol: 'Smb'
      shareName: '<shareName>'
      type: 'AzureFiles'
    }
  }
}
param location = '<location>'
param servicePlanConfig = {
  kind: 'linux'
}
param spokeNetworkConfig = {
  appGwSubnetAddressSpace: '10.240.12.0/24'
  ingressOption: 'applicationGateway'
  resourceGroupName: '<resourceGroupName>'
}
param tags = {
  environment: 'test'
  scenario: 'byos'
}
param workloadName = '<workloadName>'
```

</details>
<p>

### Example 3: _Application Gateway with Linux container and egress lockdown_

This instance deploys the module with Application Gateway ingress, Linux container workload, egress lockdown via Azure Firewall UDR, jumpbox VM, and custom diagnostic settings across all resources.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/container]


<details>

<summary>via Bicep module</summary>

```bicep
module hostingEnvironment 'br/public:avm/ptn/app-service-lza/hosting-environment:<version>' = {
  params: {
    // Required parameters
    logAnalyticsWorkspaceResourceId: '<logAnalyticsWorkspaceResourceId>'
    // Non-required parameters
    appGatewayConfig: {
      diagnosticSettings: [
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
    }
    appServiceConfig: {
      container: {
        imageName: 'mcr.microsoft.com/appsvc/staticsite:latest'
      }
      diagnosticSettings: [
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
      kind: 'app,linux,container'
    }
    aseConfig: {
      diagnosticSettings: [
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
    }
    keyVaultConfig: {
      diagnosticSettings: [
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
    }
    location: '<location>'
    servicePlanConfig: {
      diagnosticSettings: [
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
      kind: 'linux'
    }
    spokeNetworkConfig: {
      appGwSubnetAddressSpace: '10.240.12.0/24'
      enableEgressLockdown: true
      ingressOption: 'applicationGateway'
      resourceGroupName: '<resourceGroupName>'
    }
    tags: {
      environment: 'test'
      scenario: 'app-gateway'
    }
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
    "appGatewayConfig": {
      "value": {
        "diagnosticSettings": [
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
      }
    },
    "appServiceConfig": {
      "value": {
        "container": {
          "imageName": "mcr.microsoft.com/appsvc/staticsite:latest"
        },
        "diagnosticSettings": [
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
        ],
        "kind": "app,linux,container"
      }
    },
    "aseConfig": {
      "value": {
        "diagnosticSettings": [
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
      }
    },
    "keyVaultConfig": {
      "value": {
        "diagnosticSettings": [
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
      }
    },
    "location": {
      "value": "<location>"
    },
    "servicePlanConfig": {
      "value": {
        "diagnosticSettings": [
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
        ],
        "kind": "linux"
      }
    },
    "spokeNetworkConfig": {
      "value": {
        "appGwSubnetAddressSpace": "10.240.12.0/24",
        "enableEgressLockdown": true,
        "ingressOption": "applicationGateway",
        "resourceGroupName": "<resourceGroupName>"
      }
    },
    "tags": {
      "value": {
        "environment": "test",
        "scenario": "app-gateway"
      }
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
param appGatewayConfig = {
  diagnosticSettings: [
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
}
param appServiceConfig = {
  container: {
    imageName: 'mcr.microsoft.com/appsvc/staticsite:latest'
  }
  diagnosticSettings: [
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
  kind: 'app,linux,container'
}
param aseConfig = {
  diagnosticSettings: [
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
}
param keyVaultConfig = {
  diagnosticSettings: [
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
}
param location = '<location>'
param servicePlanConfig = {
  diagnosticSettings: [
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
  kind: 'linux'
}
param spokeNetworkConfig = {
  appGwSubnetAddressSpace: '10.240.12.0/24'
  enableEgressLockdown: true
  ingressOption: 'applicationGateway'
  resourceGroupName: '<resourceGroupName>'
}
param tags = {
  environment: 'test'
  scenario: 'app-gateway'
}
param workloadName = '<workloadName>'
```

</details>
<p>

### Example 4: _Existing App Service Plan_

This instance validates using a pre-created App Service Plan with a Linux container workload behind Application Gateway.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/existing-plan]


<details>

<summary>via Bicep module</summary>

```bicep
module hostingEnvironment 'br/public:avm/ptn/app-service-lza/hosting-environment:<version>' = {
  params: {
    // Required parameters
    logAnalyticsWorkspaceResourceId: '<logAnalyticsWorkspaceResourceId>'
    // Non-required parameters
    appServiceConfig: {
      container: {
        imageName: 'mcr.microsoft.com/appsvc/staticsite:latest'
      }
      kind: 'app,linux,container'
    }
    location: '<location>'
    servicePlanConfig: {
      existingPlanId: '<existingPlanId>'
      kind: 'linux'
    }
    spokeNetworkConfig: {
      appGwSubnetAddressSpace: '10.240.12.0/24'
      ingressOption: 'applicationGateway'
      resourceGroupName: '<resourceGroupName>'
    }
    tags: {
      environment: 'test'
      scenario: 'existing-plan'
    }
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
    "appServiceConfig": {
      "value": {
        "container": {
          "imageName": "mcr.microsoft.com/appsvc/staticsite:latest"
        },
        "kind": "app,linux,container"
      }
    },
    "location": {
      "value": "<location>"
    },
    "servicePlanConfig": {
      "value": {
        "existingPlanId": "<existingPlanId>",
        "kind": "linux"
      }
    },
    "spokeNetworkConfig": {
      "value": {
        "appGwSubnetAddressSpace": "10.240.12.0/24",
        "ingressOption": "applicationGateway",
        "resourceGroupName": "<resourceGroupName>"
      }
    },
    "tags": {
      "value": {
        "environment": "test",
        "scenario": "existing-plan"
      }
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
param appServiceConfig = {
  container: {
    imageName: 'mcr.microsoft.com/appsvc/staticsite:latest'
  }
  kind: 'app,linux,container'
}
param location = '<location>'
param servicePlanConfig = {
  existingPlanId: '<existingPlanId>'
  kind: 'linux'
}
param spokeNetworkConfig = {
  appGwSubnetAddressSpace: '10.240.12.0/24'
  ingressOption: 'applicationGateway'
  resourceGroupName: '<resourceGroupName>'
}
param tags = {
  environment: 'test'
  scenario: 'existing-plan'
}
param workloadName = '<workloadName>'
```

</details>
<p>

### Example 5: _Front Door_

This instance deploys the module with Azure Front Door as the public ingress and a Linux web app.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/front-door]


<details>

<summary>via Bicep module</summary>

```bicep
module hostingEnvironment 'br/public:avm/ptn/app-service-lza/hosting-environment:<version>' = {
  params: {
    // Required parameters
    logAnalyticsWorkspaceResourceId: '<logAnalyticsWorkspaceResourceId>'
    // Non-required parameters
    appServiceConfig: {
      kind: 'app,linux'
    }
    location: '<location>'
    servicePlanConfig: {
      kind: 'linux'
    }
    spokeNetworkConfig: {
      ingressOption: 'frontDoor'
      resourceGroupName: '<resourceGroupName>'
    }
    tags: {
      environment: 'test'
      scenario: 'front-door'
    }
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
    "appServiceConfig": {
      "value": {
        "kind": "app,linux"
      }
    },
    "location": {
      "value": "<location>"
    },
    "servicePlanConfig": {
      "value": {
        "kind": "linux"
      }
    },
    "spokeNetworkConfig": {
      "value": {
        "ingressOption": "frontDoor",
        "resourceGroupName": "<resourceGroupName>"
      }
    },
    "tags": {
      "value": {
        "environment": "test",
        "scenario": "front-door"
      }
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
param appServiceConfig = {
  kind: 'app,linux'
}
param location = '<location>'
param servicePlanConfig = {
  kind: 'linux'
}
param spokeNetworkConfig = {
  ingressOption: 'frontDoor'
  resourceGroupName: '<resourceGroupName>'
}
param tags = {
  environment: 'test'
  scenario: 'front-door'
}
param workloadName = '<workloadName>'
```

</details>
<p>

### Example 6: _Managed Instance_

This instance deploys a Managed Instance (Custom Mode) App Service Plan with Application Gateway and a jumpbox VM.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/managed-instance]


<details>

<summary>via Bicep module</summary>

```bicep
module hostingEnvironment 'br/public:avm/ptn/app-service-lza/hosting-environment:<version>' = {
  params: {
    // Required parameters
    logAnalyticsWorkspaceResourceId: '<logAnalyticsWorkspaceResourceId>'
    // Non-required parameters
    appServiceConfig: {
      kind: 'app'
    }
    location: '<location>'
    servicePlanConfig: {
      isCustomMode: true
      kind: 'windows'
      rdpEnabled: true
      sku: 'P1V4'
    }
    spokeNetworkConfig: {
      appGwSubnetAddressSpace: '10.240.12.0/24'
      ingressOption: 'applicationGateway'
      resourceGroupName: '<resourceGroupName>'
    }
    tags: {
      environment: 'test'
      scenario: 'managed-instance'
    }
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
    "appServiceConfig": {
      "value": {
        "kind": "app"
      }
    },
    "location": {
      "value": "<location>"
    },
    "servicePlanConfig": {
      "value": {
        "isCustomMode": true,
        "kind": "windows",
        "rdpEnabled": true,
        "sku": "P1V4"
      }
    },
    "spokeNetworkConfig": {
      "value": {
        "appGwSubnetAddressSpace": "10.240.12.0/24",
        "ingressOption": "applicationGateway",
        "resourceGroupName": "<resourceGroupName>"
      }
    },
    "tags": {
      "value": {
        "environment": "test",
        "scenario": "managed-instance"
      }
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
param appServiceConfig = {
  kind: 'app'
}
param location = '<location>'
param servicePlanConfig = {
  isCustomMode: true
  kind: 'windows'
  rdpEnabled: true
  sku: 'P1V4'
}
param spokeNetworkConfig = {
  appGwSubnetAddressSpace: '10.240.12.0/24'
  ingressOption: 'applicationGateway'
  resourceGroupName: '<resourceGroupName>'
}
param tags = {
  environment: 'test'
  scenario: 'managed-instance'
}
param workloadName = '<workloadName>'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`logAnalyticsWorkspaceResourceId`](#parameter-loganalyticsworkspaceresourceid) | string | The resource ID of the Log Analytics workspace managed by the Platform Landing Zone. All diagnostic settings will be configured to send logs and metrics to this workspace. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appGatewayConfig`](#parameter-appgatewayconfig) | object | Configuration for the Application Gateway. Only used when spokeNetworkConfig.ingressOption is "applicationGateway". |
| [`appInsightsConfig`](#parameter-appinsightsconfig) | object | Configuration for Application Insights. |
| [`appServiceConfig`](#parameter-appserviceconfig) | object | Configuration for the Web App. |
| [`aseConfig`](#parameter-aseconfig) | object | Configuration for the App Service Environment v3. Only used when deployAseV3 is true. |
| [`deployAseV3`](#parameter-deployasev3) | bool | Default is false. Set to true if you want to deploy ASE v3 instead of Multitenant App Service Plan. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`environmentName`](#parameter-environmentname) | string | The name of the environmentName (e.g. "dev", "test", "prod", "preprod", "staging", "uat", "dr", "qa"). Up to 8 characters long. |
| [`frontDoorConfig`](#parameter-frontdoorconfig) | object | Configuration for Azure Front Door. Only used when spokeNetworkConfig.ingressOption is "frontDoor". |
| [`keyVaultConfig`](#parameter-keyvaultconfig) | object | Configuration for the Key Vault. |
| [`location`](#parameter-location) | string | Azure region where the resources will be deployed in. |
| [`servicePlanConfig`](#parameter-serviceplanconfig) | object | Configuration for the App Service Plan. |
| [`spokeNetworkConfig`](#parameter-spokenetworkconfig) | object | Configuration for the spoke virtual network and ingress networking. |
| [`tags`](#parameter-tags) | object | Tags to apply to all resources. |
| [`workloadName`](#parameter-workloadname) | string | suffix (max 10 characters long) that will be used to name the resources in a pattern like <resourceAbbreviation>-<workloadName>. |

### Parameter: `logAnalyticsWorkspaceResourceId`

The resource ID of the Log Analytics workspace managed by the Platform Landing Zone. All diagnostic settings will be configured to send logs and metrics to this workspace.

- Required: Yes
- Type: string

### Parameter: `appGatewayConfig`

Configuration for the Application Gateway. Only used when spokeNetworkConfig.ingressOption is "applicationGateway".

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authenticationCertificates`](#parameter-appgatewayconfigauthenticationcertificates) | array | Authentication certificates for backend auth. |
| [`backendSettingsCollection`](#parameter-appgatewayconfigbackendsettingscollection) | array | Backend settings collection (v2). |
| [`customErrorConfigurations`](#parameter-appgatewayconfigcustomerrorconfigurations) | array | Custom error configurations. |
| [`diagnosticSettings`](#parameter-appgatewayconfigdiagnosticsettings) | array | Diagnostic settings for the Application Gateway. |
| [`enableFips`](#parameter-appgatewayconfigenablefips) | bool | Whether FIPS mode is enabled. |
| [`enableHttp2`](#parameter-appgatewayconfigenablehttp2) | bool | Whether HTTP/2 is enabled. Defaults to true. |
| [`enableRequestBuffering`](#parameter-appgatewayconfigenablerequestbuffering) | bool | Whether request buffering is enabled. |
| [`enableResponseBuffering`](#parameter-appgatewayconfigenableresponsebuffering) | bool | Whether response buffering is enabled. |
| [`healthProbePath`](#parameter-appgatewayconfighealthprobepath) | string | Health probe path for backend health checks. Defaults to "/". |
| [`listeners`](#parameter-appgatewayconfiglisteners) | array | Listeners (v2). |
| [`loadDistributionPolicies`](#parameter-appgatewayconfigloaddistributionpolicies) | array | Load distribution policies. |
| [`lock`](#parameter-appgatewayconfiglock) | object | Resource lock for the Application Gateway. |
| [`managedIdentities`](#parameter-appgatewayconfigmanagedidentities) | object | Managed identities for Key Vault-referenced SSL certificates. |
| [`name`](#parameter-appgatewayconfigname) | string | Custom name for the Application Gateway. Falls back to naming-module default. |
| [`privateEndpoints`](#parameter-appgatewayconfigprivateendpoints) | array | Private endpoints for the Application Gateway. |
| [`privateLinkConfigurations`](#parameter-appgatewayconfigprivatelinkconfigurations) | array | Private link configurations. |
| [`redirectConfigurations`](#parameter-appgatewayconfigredirectconfigurations) | array | Redirect configurations. |
| [`rewriteRuleSets`](#parameter-appgatewayconfigrewriterulesets) | array | Rewrite rule sets. |
| [`roleAssignments`](#parameter-appgatewayconfigroleassignments) | array | Role assignments for the Application Gateway. |
| [`routingRules`](#parameter-appgatewayconfigroutingrules) | array | Routing rules (v2). |
| [`sslCertificates`](#parameter-appgatewayconfigsslcertificates) | array | SSL certificates for HTTPS termination. |
| [`sslPolicyCipherSuites`](#parameter-appgatewayconfigsslpolicyciphersuites) | array | SSL cipher suites. |
| [`sslPolicyMinProtocolVersion`](#parameter-appgatewayconfigsslpolicyminprotocolversion) | string | Minimum TLS protocol version. |
| [`sslPolicyName`](#parameter-appgatewayconfigsslpolicyname) | string | Predefined SSL policy name. |
| [`sslPolicyType`](#parameter-appgatewayconfigsslpolicytype) | string | SSL policy type. |
| [`sslProfiles`](#parameter-appgatewayconfigsslprofiles) | array | SSL profiles. |
| [`trustedClientCertificates`](#parameter-appgatewayconfigtrustedclientcertificates) | array | Trusted client certificates for mTLS. |
| [`trustedRootCertificates`](#parameter-appgatewayconfigtrustedrootcertificates) | array | Trusted root certificates for end-to-end SSL. |
| [`urlPathMaps`](#parameter-appgatewayconfigurlpathmaps) | array | URL path maps for path-based routing. |

### Parameter: `appGatewayConfig.authenticationCertificates`

Authentication certificates for backend auth.

- Required: No
- Type: array

### Parameter: `appGatewayConfig.backendSettingsCollection`

Backend settings collection (v2).

- Required: No
- Type: array

### Parameter: `appGatewayConfig.customErrorConfigurations`

Custom error configurations.

- Required: No
- Type: array

### Parameter: `appGatewayConfig.diagnosticSettings`

Diagnostic settings for the Application Gateway.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-appgatewayconfigdiagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-appgatewayconfigdiagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-appgatewayconfigdiagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-appgatewayconfigdiagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-appgatewayconfigdiagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-appgatewayconfigdiagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-appgatewayconfigdiagnosticsettingsname) | string | The name of the diagnostic setting. |
| [`storageAccountResourceId`](#parameter-appgatewayconfigdiagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-appgatewayconfigdiagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `appGatewayConfig.diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `appGatewayConfig.diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `appGatewayConfig.diagnosticSettings.logAnalyticsDestinationType`

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

### Parameter: `appGatewayConfig.diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-appgatewayconfigdiagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-appgatewayconfigdiagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-appgatewayconfigdiagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `appGatewayConfig.diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `appGatewayConfig.diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `appGatewayConfig.diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `appGatewayConfig.diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `appGatewayConfig.diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-appgatewayconfigdiagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-appgatewayconfigdiagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `appGatewayConfig.diagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `appGatewayConfig.diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `appGatewayConfig.diagnosticSettings.name`

The name of the diagnostic setting.

- Required: No
- Type: string

### Parameter: `appGatewayConfig.diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `appGatewayConfig.diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `appGatewayConfig.enableFips`

Whether FIPS mode is enabled.

- Required: No
- Type: bool

### Parameter: `appGatewayConfig.enableHttp2`

Whether HTTP/2 is enabled. Defaults to true.

- Required: No
- Type: bool

### Parameter: `appGatewayConfig.enableRequestBuffering`

Whether request buffering is enabled.

- Required: No
- Type: bool

### Parameter: `appGatewayConfig.enableResponseBuffering`

Whether response buffering is enabled.

- Required: No
- Type: bool

### Parameter: `appGatewayConfig.healthProbePath`

Health probe path for backend health checks. Defaults to "/".

- Required: No
- Type: string

### Parameter: `appGatewayConfig.listeners`

Listeners (v2).

- Required: No
- Type: array

### Parameter: `appGatewayConfig.loadDistributionPolicies`

Load distribution policies.

- Required: No
- Type: array

### Parameter: `appGatewayConfig.lock`

Resource lock for the Application Gateway.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-appgatewayconfiglockkind) | string | Specify the type of lock. |
| [`name`](#parameter-appgatewayconfiglockname) | string | Specify the name of lock. |
| [`notes`](#parameter-appgatewayconfiglocknotes) | string | Specify the notes of the lock. |

### Parameter: `appGatewayConfig.lock.kind`

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

### Parameter: `appGatewayConfig.lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `appGatewayConfig.lock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `appGatewayConfig.managedIdentities`

Managed identities for Key Vault-referenced SSL certificates.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`systemAssigned`](#parameter-appgatewayconfigmanagedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. |
| [`userAssignedResourceIds`](#parameter-appgatewayconfigmanagedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption. |

### Parameter: `appGatewayConfig.managedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `appGatewayConfig.managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption.

- Required: No
- Type: array

### Parameter: `appGatewayConfig.name`

Custom name for the Application Gateway. Falls back to naming-module default.

- Required: No
- Type: string

### Parameter: `appGatewayConfig.privateEndpoints`

Private endpoints for the Application Gateway.

- Required: No
- Type: array

### Parameter: `appGatewayConfig.privateLinkConfigurations`

Private link configurations.

- Required: No
- Type: array

### Parameter: `appGatewayConfig.redirectConfigurations`

Redirect configurations.

- Required: No
- Type: array

### Parameter: `appGatewayConfig.rewriteRuleSets`

Rewrite rule sets.

- Required: No
- Type: array

### Parameter: `appGatewayConfig.roleAssignments`

Role assignments for the Application Gateway.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-appgatewayconfigroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-appgatewayconfigroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-appgatewayconfigroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-appgatewayconfigroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-appgatewayconfigroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-appgatewayconfigroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-appgatewayconfigroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-appgatewayconfigroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `appGatewayConfig.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `appGatewayConfig.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `appGatewayConfig.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `appGatewayConfig.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `appGatewayConfig.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `appGatewayConfig.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `appGatewayConfig.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `appGatewayConfig.roleAssignments.principalType`

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

### Parameter: `appGatewayConfig.routingRules`

Routing rules (v2).

- Required: No
- Type: array

### Parameter: `appGatewayConfig.sslCertificates`

SSL certificates for HTTPS termination.

- Required: No
- Type: array

### Parameter: `appGatewayConfig.sslPolicyCipherSuites`

SSL cipher suites.

- Required: No
- Type: array

### Parameter: `appGatewayConfig.sslPolicyMinProtocolVersion`

Minimum TLS protocol version.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'TLSv1_2'
    'TLSv1_3'
  ]
  ```

### Parameter: `appGatewayConfig.sslPolicyName`

Predefined SSL policy name.

- Required: No
- Type: string

### Parameter: `appGatewayConfig.sslPolicyType`

SSL policy type.

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

### Parameter: `appGatewayConfig.sslProfiles`

SSL profiles.

- Required: No
- Type: array

### Parameter: `appGatewayConfig.trustedClientCertificates`

Trusted client certificates for mTLS.

- Required: No
- Type: array

### Parameter: `appGatewayConfig.trustedRootCertificates`

Trusted root certificates for end-to-end SSL.

- Required: No
- Type: array

### Parameter: `appGatewayConfig.urlPathMaps`

URL path maps for path-based routing.

- Required: No
- Type: array

### Parameter: `appInsightsConfig`

Configuration for Application Insights.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`diagnosticSettings`](#parameter-appinsightsconfigdiagnosticsettings) | array | Diagnostic settings for App Insights. |
| [`disableIpMasking`](#parameter-appinsightsconfigdisableipmasking) | bool | Disable IP masking (false = mask IPs for privacy). |
| [`disableLocalAuth`](#parameter-appinsightsconfigdisablelocalauth) | bool | Disable non-AAD based auth. |
| [`flowType`](#parameter-appinsightsconfigflowtype) | string | Flow type. |
| [`forceCustomerStorageForProfiler`](#parameter-appinsightsconfigforcecustomerstorageforprofiler) | bool | Force customer storage for profiler. |
| [`immediatePurgeDataOn30Days`](#parameter-appinsightsconfigimmediatepurgedataon30days) | bool | Purge data immediately after 30 days. |
| [`ingestionMode`](#parameter-appinsightsconfigingestionmode) | string | Ingestion mode. |
| [`kind`](#parameter-appinsightsconfigkind) | string | Kind of App Insights resource. |
| [`linkedStorageAccountResourceId`](#parameter-appinsightsconfiglinkedstorageaccountresourceid) | string | Linked storage account resource ID. |
| [`lock`](#parameter-appinsightsconfiglock) | object | Resource lock for App Insights. |
| [`publicNetworkAccessForIngestion`](#parameter-appinsightsconfigpublicnetworkaccessforingestion) | string | Public network access for ingestion. |
| [`publicNetworkAccessForQuery`](#parameter-appinsightsconfigpublicnetworkaccessforquery) | string | Public network access for query. |
| [`requestSource`](#parameter-appinsightsconfigrequestsource) | string | Request source. |
| [`retentionInDays`](#parameter-appinsightsconfigretentionindays) | int | Data retention in days. |
| [`roleAssignments`](#parameter-appinsightsconfigroleassignments) | array | Role assignments for App Insights. |
| [`samplingPercentage`](#parameter-appinsightsconfigsamplingpercentage) | int | Sampling percentage (1-100). |

### Parameter: `appInsightsConfig.diagnosticSettings`

Diagnostic settings for App Insights.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-appinsightsconfigdiagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-appinsightsconfigdiagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-appinsightsconfigdiagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-appinsightsconfigdiagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-appinsightsconfigdiagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-appinsightsconfigdiagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-appinsightsconfigdiagnosticsettingsname) | string | The name of the diagnostic setting. |
| [`storageAccountResourceId`](#parameter-appinsightsconfigdiagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-appinsightsconfigdiagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `appInsightsConfig.diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `appInsightsConfig.diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `appInsightsConfig.diagnosticSettings.logAnalyticsDestinationType`

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

### Parameter: `appInsightsConfig.diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-appinsightsconfigdiagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-appinsightsconfigdiagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-appinsightsconfigdiagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `appInsightsConfig.diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `appInsightsConfig.diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `appInsightsConfig.diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `appInsightsConfig.diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `appInsightsConfig.diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-appinsightsconfigdiagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-appinsightsconfigdiagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `appInsightsConfig.diagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `appInsightsConfig.diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `appInsightsConfig.diagnosticSettings.name`

The name of the diagnostic setting.

- Required: No
- Type: string

### Parameter: `appInsightsConfig.diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `appInsightsConfig.diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `appInsightsConfig.disableIpMasking`

Disable IP masking (false = mask IPs for privacy).

- Required: No
- Type: bool

### Parameter: `appInsightsConfig.disableLocalAuth`

Disable non-AAD based auth.

- Required: No
- Type: bool

### Parameter: `appInsightsConfig.flowType`

Flow type.

- Required: No
- Type: string

### Parameter: `appInsightsConfig.forceCustomerStorageForProfiler`

Force customer storage for profiler.

- Required: No
- Type: bool

### Parameter: `appInsightsConfig.immediatePurgeDataOn30Days`

Purge data immediately after 30 days.

- Required: No
- Type: bool

### Parameter: `appInsightsConfig.ingestionMode`

Ingestion mode.

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

### Parameter: `appInsightsConfig.kind`

Kind of App Insights resource.

- Required: No
- Type: string

### Parameter: `appInsightsConfig.linkedStorageAccountResourceId`

Linked storage account resource ID.

- Required: No
- Type: string

### Parameter: `appInsightsConfig.lock`

Resource lock for App Insights.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-appinsightsconfiglockkind) | string | Specify the type of lock. |
| [`name`](#parameter-appinsightsconfiglockname) | string | Specify the name of lock. |
| [`notes`](#parameter-appinsightsconfiglocknotes) | string | Specify the notes of the lock. |

### Parameter: `appInsightsConfig.lock.kind`

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

### Parameter: `appInsightsConfig.lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `appInsightsConfig.lock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `appInsightsConfig.publicNetworkAccessForIngestion`

Public network access for ingestion.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `appInsightsConfig.publicNetworkAccessForQuery`

Public network access for query.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `appInsightsConfig.requestSource`

Request source.

- Required: No
- Type: string

### Parameter: `appInsightsConfig.retentionInDays`

Data retention in days.

- Required: No
- Type: int
- Allowed:
  ```Bicep
  [
    30
    60
    90
    120
    180
    270
    365
    550
    730
  ]
  ```

### Parameter: `appInsightsConfig.roleAssignments`

Role assignments for App Insights.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-appinsightsconfigroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-appinsightsconfigroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-appinsightsconfigroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-appinsightsconfigroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-appinsightsconfigroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-appinsightsconfigroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-appinsightsconfigroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-appinsightsconfigroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `appInsightsConfig.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `appInsightsConfig.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `appInsightsConfig.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `appInsightsConfig.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `appInsightsConfig.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `appInsightsConfig.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `appInsightsConfig.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `appInsightsConfig.roleAssignments.principalType`

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

### Parameter: `appInsightsConfig.samplingPercentage`

Sampling percentage (1-100).

- Required: No
- Type: int

### Parameter: `appServiceConfig`

Configuration for the Web App.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoGeneratedDomainNameLabelScope`](#parameter-appserviceconfigautogenerateddomainnamelabelscope) | string | Default hostname uniqueness scope. |
| [`clientAffinityEnabled`](#parameter-appserviceconfigclientaffinityenabled) | bool | Enable client affinity on the web app. |
| [`clientAffinityPartitioningEnabled`](#parameter-appserviceconfigclientaffinitypartitioningenabled) | bool | Partitioned client affinity using CHIPS cookies. |
| [`clientAffinityProxyEnabled`](#parameter-appserviceconfigclientaffinityproxyenabled) | bool | Proxy-based client affinity. |
| [`clientCertEnabled`](#parameter-appserviceconfigclientcertenabled) | bool | Enable client certificate authentication (mTLS). |
| [`clientCertExclusionPaths`](#parameter-appserviceconfigclientcertexclusionpaths) | string | Client certificate exclusion paths (comma-separated). |
| [`clientCertMode`](#parameter-appserviceconfigclientcertmode) | string | Client certificate mode. Only used when clientCertEnabled is true. |
| [`cloningInfo`](#parameter-appserviceconfigcloninginfo) | object | Cloning info for creating from a source app. |
| [`container`](#parameter-appserviceconfigcontainer) | object | Container configuration for container-based deployments. |
| [`containerSize`](#parameter-appserviceconfigcontainersize) | int | Size of the function container. |
| [`dailyMemoryTimeQuota`](#parameter-appserviceconfigdailymemorytimequota) | int | Maximum allowed daily memory-time quota. |
| [`daprConfig`](#parameter-appserviceconfigdaprconfig) | object | Dapr configuration (Container Apps). |
| [`diagnosticSettings`](#parameter-appserviceconfigdiagnosticsettings) | array | Diagnostic settings for the Web App. |
| [`disableBasicPublishingCredentials`](#parameter-appserviceconfigdisablebasicpublishingcredentials) | bool | Disable basic publishing credentials (FTP/SCM). Defaults to true. |
| [`dnsConfiguration`](#parameter-appserviceconfigdnsconfiguration) | object | DNS-related settings for the site. |
| [`e2eEncryptionEnabled`](#parameter-appserviceconfige2eencryptionenabled) | bool | Enable end-to-end encryption (used with ASE). |
| [`enabled`](#parameter-appserviceconfigenabled) | bool | Setting to false disables the app (takes it offline). |
| [`extendedLocation`](#parameter-appserviceconfigextendedlocation) | object | Extended location of the web app resource. |
| [`extensions`](#parameter-appserviceconfigextensions) | array | Extensions configuration for the web app. |
| [`functionAppConfig`](#parameter-appserviceconfigfunctionappconfig) | object | Function App configuration object. |
| [`hostNamesDisabled`](#parameter-appserviceconfighostnamesdisabled) | bool | Disable public hostnames of the app. |
| [`hostNameSslStates`](#parameter-appserviceconfighostnamesslstates) | array | Hostname SSL states for managing SSL bindings. |
| [`httpsOnly`](#parameter-appserviceconfighttpsonly) | bool | Require HTTPS only. |
| [`hybridConnectionRelays`](#parameter-appserviceconfighybridconnectionrelays) | array | Hybrid connection relays to connect the app with. |
| [`ipMode`](#parameter-appserviceconfigipmode) | string | IP mode of the app. |
| [`keyVaultAccessIdentityResourceId`](#parameter-appserviceconfigkeyvaultaccessidentityresourceid) | string | Resource ID of the identity for Key Vault references. |
| [`kind`](#parameter-appserviceconfigkind) | string | Kind of web app (e.g. "app", "app,linux", "app,linux,container", "functionapp"). |
| [`lock`](#parameter-appserviceconfiglock) | object | Resource lock for the Web App. |
| [`managedEnvironmentResourceId`](#parameter-appserviceconfigmanagedenvironmentresourceid) | string | Managed environment resource ID for Azure Container Apps. |
| [`managedIdentityName`](#parameter-appserviceconfigmanagedidentityname) | string | Custom name for the App Service managed identity. Falls back to naming-module default. |
| [`name`](#parameter-appserviceconfigname) | string | Custom name for the Web App. Falls back to naming-module default. |
| [`outboundVnetRouting`](#parameter-appserviceconfigoutboundvnetrouting) | object | Outbound VNet routing configuration. |
| [`publicNetworkAccess`](#parameter-appserviceconfigpublicnetworkaccess) | string | Public network access for the web app. |
| [`redundancyMode`](#parameter-appserviceconfigredundancymode) | string | Site redundancy mode. |
| [`reserved`](#parameter-appserviceconfigreserved) | bool | True if reserved (Linux). Overrides auto-detection. |
| [`resourceConfig`](#parameter-appserviceconfigresourceconfig) | object | Function app resource requirements. |
| [`roleAssignments`](#parameter-appserviceconfigroleassignments) | array | Role assignments for the Web App. |
| [`scmSiteAlsoStopped`](#parameter-appserviceconfigscmsitealsostopped) | bool | Stop SCM (Kudu) site when the app is stopped. |
| [`siteConfig`](#parameter-appserviceconfigsiteconfig) | object | The site configuration object. |
| [`sshEnabled`](#parameter-appserviceconfigsshenabled) | bool | Whether to enable SSH access. |
| [`storageAccountRequired`](#parameter-appserviceconfigstorageaccountrequired) | bool | Whether customer-provided storage account is required. |
| [`storageAccounts`](#parameter-appserviceconfigstorageaccounts) | object | Azure Storage account mounts (BYOS). Each key is a mount name; value specifies accountName, shareName, mountPath, accessKey, type (AzureFiles|AzureBlob), and protocol (Smb|Nfs|Http). |
| [`workloadProfileName`](#parameter-appserviceconfigworkloadprofilename) | string | Workload profile name for function app. |

### Parameter: `appServiceConfig.autoGeneratedDomainNameLabelScope`

Default hostname uniqueness scope.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'NoReuse'
    'ResourceGroupReuse'
    'SubscriptionReuse'
    'TenantReuse'
  ]
  ```

### Parameter: `appServiceConfig.clientAffinityEnabled`

Enable client affinity on the web app.

- Required: No
- Type: bool

### Parameter: `appServiceConfig.clientAffinityPartitioningEnabled`

Partitioned client affinity using CHIPS cookies.

- Required: No
- Type: bool

### Parameter: `appServiceConfig.clientAffinityProxyEnabled`

Proxy-based client affinity.

- Required: No
- Type: bool

### Parameter: `appServiceConfig.clientCertEnabled`

Enable client certificate authentication (mTLS).

- Required: No
- Type: bool

### Parameter: `appServiceConfig.clientCertExclusionPaths`

Client certificate exclusion paths (comma-separated).

- Required: No
- Type: string

### Parameter: `appServiceConfig.clientCertMode`

Client certificate mode. Only used when clientCertEnabled is true.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Optional'
    'OptionalInteractiveUser'
    'Required'
  ]
  ```

### Parameter: `appServiceConfig.cloningInfo`

Cloning info for creating from a source app.

- Required: No
- Type: object

### Parameter: `appServiceConfig.container`

Container configuration for container-based deployments.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`imageName`](#parameter-appserviceconfigcontainerimagename) | string | The container image name (e.g. "mcr.microsoft.com/appsvc/staticsite:latest"). |
| [`registryPassword`](#parameter-appserviceconfigcontainerregistrypassword) | securestring | The container registry password. |
| [`registryUrl`](#parameter-appserviceconfigcontainerregistryurl) | string | The container registry URL (e.g. "https://myregistry.azurecr.io"). |
| [`registryUsername`](#parameter-appserviceconfigcontainerregistryusername) | string | The container registry username. |

### Parameter: `appServiceConfig.container.imageName`

The container image name (e.g. "mcr.microsoft.com/appsvc/staticsite:latest").

- Required: No
- Type: string

### Parameter: `appServiceConfig.container.registryPassword`

The container registry password.

- Required: No
- Type: securestring

### Parameter: `appServiceConfig.container.registryUrl`

The container registry URL (e.g. "https://myregistry.azurecr.io").

- Required: No
- Type: string

### Parameter: `appServiceConfig.container.registryUsername`

The container registry username.

- Required: No
- Type: string

### Parameter: `appServiceConfig.containerSize`

Size of the function container.

- Required: No
- Type: int

### Parameter: `appServiceConfig.dailyMemoryTimeQuota`

Maximum allowed daily memory-time quota.

- Required: No
- Type: int

### Parameter: `appServiceConfig.daprConfig`

Dapr configuration (Container Apps).

- Required: No
- Type: object

### Parameter: `appServiceConfig.diagnosticSettings`

Diagnostic settings for the Web App.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-appserviceconfigdiagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-appserviceconfigdiagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-appserviceconfigdiagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-appserviceconfigdiagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-appserviceconfigdiagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-appserviceconfigdiagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-appserviceconfigdiagnosticsettingsname) | string | The name of the diagnostic setting. |
| [`storageAccountResourceId`](#parameter-appserviceconfigdiagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-appserviceconfigdiagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `appServiceConfig.diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `appServiceConfig.diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `appServiceConfig.diagnosticSettings.logAnalyticsDestinationType`

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

### Parameter: `appServiceConfig.diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-appserviceconfigdiagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-appserviceconfigdiagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-appserviceconfigdiagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `appServiceConfig.diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `appServiceConfig.diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `appServiceConfig.diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `appServiceConfig.diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `appServiceConfig.diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-appserviceconfigdiagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-appserviceconfigdiagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `appServiceConfig.diagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `appServiceConfig.diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `appServiceConfig.diagnosticSettings.name`

The name of the diagnostic setting.

- Required: No
- Type: string

### Parameter: `appServiceConfig.diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `appServiceConfig.diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `appServiceConfig.disableBasicPublishingCredentials`

Disable basic publishing credentials (FTP/SCM). Defaults to true.

- Required: No
- Type: bool

### Parameter: `appServiceConfig.dnsConfiguration`

DNS-related settings for the site.

- Required: No
- Type: object

### Parameter: `appServiceConfig.e2eEncryptionEnabled`

Enable end-to-end encryption (used with ASE).

- Required: No
- Type: bool

### Parameter: `appServiceConfig.enabled`

Setting to false disables the app (takes it offline).

- Required: No
- Type: bool

### Parameter: `appServiceConfig.extendedLocation`

Extended location of the web app resource.

- Required: No
- Type: object

### Parameter: `appServiceConfig.extensions`

Extensions configuration for the web app.

- Required: No
- Type: array

### Parameter: `appServiceConfig.functionAppConfig`

Function App configuration object.

- Required: No
- Type: object

### Parameter: `appServiceConfig.hostNamesDisabled`

Disable public hostnames of the app.

- Required: No
- Type: bool

### Parameter: `appServiceConfig.hostNameSslStates`

Hostname SSL states for managing SSL bindings.

- Required: No
- Type: array

### Parameter: `appServiceConfig.httpsOnly`

Require HTTPS only.

- Required: No
- Type: bool

### Parameter: `appServiceConfig.hybridConnectionRelays`

Hybrid connection relays to connect the app with.

- Required: No
- Type: array

### Parameter: `appServiceConfig.ipMode`

IP mode of the app.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'IPv4'
    'IPv4AndIPv6'
    'IPv6'
  ]
  ```

### Parameter: `appServiceConfig.keyVaultAccessIdentityResourceId`

Resource ID of the identity for Key Vault references.

- Required: No
- Type: string

### Parameter: `appServiceConfig.kind`

Kind of web app (e.g. "app", "app,linux", "app,linux,container", "functionapp").

- Required: No
- Type: string
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

### Parameter: `appServiceConfig.lock`

Resource lock for the Web App.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-appserviceconfiglockkind) | string | Specify the type of lock. |
| [`name`](#parameter-appserviceconfiglockname) | string | Specify the name of lock. |
| [`notes`](#parameter-appserviceconfiglocknotes) | string | Specify the notes of the lock. |

### Parameter: `appServiceConfig.lock.kind`

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

### Parameter: `appServiceConfig.lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `appServiceConfig.lock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `appServiceConfig.managedEnvironmentResourceId`

Managed environment resource ID for Azure Container Apps.

- Required: No
- Type: string

### Parameter: `appServiceConfig.managedIdentityName`

Custom name for the App Service managed identity. Falls back to naming-module default.

- Required: No
- Type: string

### Parameter: `appServiceConfig.name`

Custom name for the Web App. Falls back to naming-module default.

- Required: No
- Type: string

### Parameter: `appServiceConfig.outboundVnetRouting`

Outbound VNet routing configuration.

- Required: No
- Type: object

### Parameter: `appServiceConfig.publicNetworkAccess`

Public network access for the web app.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    ''
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `appServiceConfig.redundancyMode`

Site redundancy mode.

- Required: No
- Type: string
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

### Parameter: `appServiceConfig.reserved`

True if reserved (Linux). Overrides auto-detection.

- Required: No
- Type: bool

### Parameter: `appServiceConfig.resourceConfig`

Function app resource requirements.

- Required: No
- Type: object

### Parameter: `appServiceConfig.roleAssignments`

Role assignments for the Web App.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-appserviceconfigroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-appserviceconfigroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-appserviceconfigroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-appserviceconfigroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-appserviceconfigroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-appserviceconfigroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-appserviceconfigroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-appserviceconfigroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `appServiceConfig.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `appServiceConfig.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `appServiceConfig.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `appServiceConfig.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `appServiceConfig.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `appServiceConfig.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `appServiceConfig.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `appServiceConfig.roleAssignments.principalType`

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

### Parameter: `appServiceConfig.scmSiteAlsoStopped`

Stop SCM (Kudu) site when the app is stopped.

- Required: No
- Type: bool

### Parameter: `appServiceConfig.siteConfig`

The site configuration object.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`alwaysOn`](#parameter-appserviceconfigsiteconfigalwayson) | bool | Whether the web app should always be loaded. |
| [`ftpsState`](#parameter-appserviceconfigsiteconfigftpsstate) | string | State of FTP / FTPS service. |
| [`healthCheckPath`](#parameter-appserviceconfigsiteconfighealthcheckpath) | string | Health check path. Used by App Service load balancers to determine instance health. |
| [`http20Enabled`](#parameter-appserviceconfigsiteconfighttp20enabled) | bool | Whether HTTP 2.0 is enabled. |
| [`linuxFxVersion`](#parameter-appserviceconfigsiteconfiglinuxfxversion) | string | Linux app framework and version string for container deployments (e.g. "DOCKER|image:tag"). |
| [`minTlsVersion`](#parameter-appserviceconfigsiteconfigmintlsversion) | string | Configures the minimum version of TLS required for SSL requests. |
| [`windowsFxVersion`](#parameter-appserviceconfigsiteconfigwindowsfxversion) | string | Windows app framework and version string for container deployments (e.g. "DOCKER|image:tag"). |

### Parameter: `appServiceConfig.siteConfig.alwaysOn`

Whether the web app should always be loaded.

- Required: No
- Type: bool

### Parameter: `appServiceConfig.siteConfig.ftpsState`

State of FTP / FTPS service.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AllAllowed'
    'Disabled'
    'FtpsOnly'
  ]
  ```

### Parameter: `appServiceConfig.siteConfig.healthCheckPath`

Health check path. Used by App Service load balancers to determine instance health.

- Required: No
- Type: string

### Parameter: `appServiceConfig.siteConfig.http20Enabled`

Whether HTTP 2.0 is enabled.

- Required: No
- Type: bool

### Parameter: `appServiceConfig.siteConfig.linuxFxVersion`

Linux app framework and version string for container deployments (e.g. "DOCKER|image:tag").

- Required: No
- Type: string

### Parameter: `appServiceConfig.siteConfig.minTlsVersion`

Configures the minimum version of TLS required for SSL requests.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '1.0'
    '1.1'
    '1.2'
    '1.3'
  ]
  ```

### Parameter: `appServiceConfig.siteConfig.windowsFxVersion`

Windows app framework and version string for container deployments (e.g. "DOCKER|image:tag").

- Required: No
- Type: string

### Parameter: `appServiceConfig.sshEnabled`

Whether to enable SSH access.

- Required: No
- Type: bool

### Parameter: `appServiceConfig.storageAccountRequired`

Whether customer-provided storage account is required.

- Required: No
- Type: bool

### Parameter: `appServiceConfig.storageAccounts`

Azure Storage account mounts (BYOS). Each key is a mount name; value specifies accountName, shareName, mountPath, accessKey, type (AzureFiles|AzureBlob), and protocol (Smb|Nfs|Http).

- Required: No
- Type: object

### Parameter: `appServiceConfig.workloadProfileName`

Workload profile name for function app.

- Required: No
- Type: string

### Parameter: `aseConfig`

Configuration for the App Service Environment v3. Only used when deployAseV3 is true.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowNewPrivateEndpointConnections`](#parameter-aseconfigallownewprivateendpointconnections) | bool | Allow new private endpoint connections on the ASE. |
| [`clusterSettings`](#parameter-aseconfigclustersettings) | array | Custom settings for ASE behavior. |
| [`customDnsSuffix`](#parameter-aseconfigcustomdnssuffix) | string | Custom DNS suffix for the ASE. |
| [`customDnsSuffixCertificateUrl`](#parameter-aseconfigcustomdnssuffixcertificateurl) | string | Key Vault certificate URL for the custom DNS suffix. |
| [`customDnsSuffixKeyVaultReferenceIdentity`](#parameter-aseconfigcustomdnssuffixkeyvaultreferenceidentity) | string | User-assigned identity for resolving the ASE Key Vault certificate. |
| [`dedicatedHostCount`](#parameter-aseconfigdedicatedhostcount) | int | Dedicated Host Count. Set to 2 for physical isolation when zoneRedundant is false. |
| [`diagnosticSettings`](#parameter-aseconfigdiagnosticsettings) | array | Diagnostic settings for the ASE. |
| [`dnsSuffix`](#parameter-aseconfigdnssuffix) | string | DNS suffix of the ASE. |
| [`frontEndScaleFactor`](#parameter-aseconfigfrontendscalefactor) | int | Scale factor for ASE frontends. |
| [`ftpEnabled`](#parameter-aseconfigftpenabled) | bool | Enable FTP on the ASE. |
| [`inboundIpAddressOverride`](#parameter-aseconfiginboundipaddressoverride) | string | Customer-provided inbound IP address. |
| [`internalLoadBalancingMode`](#parameter-aseconfiginternalloadbalancingmode) | string | Which endpoints to serve internally in the VNet. |
| [`ipsslAddressCount`](#parameter-aseconfigipssladdresscount) | int | Number of IP SSL addresses reserved. |
| [`lock`](#parameter-aseconfiglock) | object | Resource lock for the ASE. |
| [`managedIdentities`](#parameter-aseconfigmanagedidentities) | object | Managed identities for the ASE. |
| [`multiSize`](#parameter-aseconfigmultisize) | string | Front-end VM size. |
| [`name`](#parameter-aseconfigname) | string | Custom name for the App Service Environment. Falls back to naming-module default. |
| [`remoteDebugEnabled`](#parameter-aseconfigremotedebugenabled) | bool | Enable remote debug on the ASE. |
| [`roleAssignments`](#parameter-aseconfigroleassignments) | array | Role assignments for the ASE. |
| [`upgradePreference`](#parameter-aseconfigupgradepreference) | string | Maintenance upgrade preference. |

### Parameter: `aseConfig.allowNewPrivateEndpointConnections`

Allow new private endpoint connections on the ASE.

- Required: No
- Type: bool

### Parameter: `aseConfig.clusterSettings`

Custom settings for ASE behavior.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-aseconfigclustersettingsname) | string | The name of the cluster setting. |
| [`value`](#parameter-aseconfigclustersettingsvalue) | string | The value of the cluster setting. |

### Parameter: `aseConfig.clusterSettings.name`

The name of the cluster setting.

- Required: Yes
- Type: string

### Parameter: `aseConfig.clusterSettings.value`

The value of the cluster setting.

- Required: Yes
- Type: string

### Parameter: `aseConfig.customDnsSuffix`

Custom DNS suffix for the ASE.

- Required: No
- Type: string

### Parameter: `aseConfig.customDnsSuffixCertificateUrl`

Key Vault certificate URL for the custom DNS suffix.

- Required: No
- Type: string

### Parameter: `aseConfig.customDnsSuffixKeyVaultReferenceIdentity`

User-assigned identity for resolving the ASE Key Vault certificate.

- Required: No
- Type: string

### Parameter: `aseConfig.dedicatedHostCount`

Dedicated Host Count. Set to 2 for physical isolation when zoneRedundant is false.

- Required: No
- Type: int

### Parameter: `aseConfig.diagnosticSettings`

Diagnostic settings for the ASE.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-aseconfigdiagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-aseconfigdiagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-aseconfigdiagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-aseconfigdiagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-aseconfigdiagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`name`](#parameter-aseconfigdiagnosticsettingsname) | string | The name of diagnostic setting. |
| [`storageAccountResourceId`](#parameter-aseconfigdiagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-aseconfigdiagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `aseConfig.diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `aseConfig.diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `aseConfig.diagnosticSettings.logAnalyticsDestinationType`

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

### Parameter: `aseConfig.diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-aseconfigdiagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-aseconfigdiagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-aseconfigdiagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `aseConfig.diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `aseConfig.diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `aseConfig.diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `aseConfig.diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `aseConfig.diagnosticSettings.name`

The name of diagnostic setting.

- Required: No
- Type: string

### Parameter: `aseConfig.diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `aseConfig.diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `aseConfig.dnsSuffix`

DNS suffix of the ASE.

- Required: No
- Type: string

### Parameter: `aseConfig.frontEndScaleFactor`

Scale factor for ASE frontends.

- Required: No
- Type: int

### Parameter: `aseConfig.ftpEnabled`

Enable FTP on the ASE.

- Required: No
- Type: bool

### Parameter: `aseConfig.inboundIpAddressOverride`

Customer-provided inbound IP address.

- Required: No
- Type: string

### Parameter: `aseConfig.internalLoadBalancingMode`

Which endpoints to serve internally in the VNet.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'None'
    'Publishing'
    'Web'
    'Web, Publishing'
  ]
  ```

### Parameter: `aseConfig.ipsslAddressCount`

Number of IP SSL addresses reserved.

- Required: No
- Type: int

### Parameter: `aseConfig.lock`

Resource lock for the ASE.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-aseconfiglockkind) | string | Specify the type of lock. |
| [`name`](#parameter-aseconfiglockname) | string | Specify the name of lock. |
| [`notes`](#parameter-aseconfiglocknotes) | string | Specify the notes of the lock. |

### Parameter: `aseConfig.lock.kind`

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

### Parameter: `aseConfig.lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `aseConfig.lock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `aseConfig.managedIdentities`

Managed identities for the ASE.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`systemAssigned`](#parameter-aseconfigmanagedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. |
| [`userAssignedResourceIds`](#parameter-aseconfigmanagedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption. |

### Parameter: `aseConfig.managedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `aseConfig.managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption.

- Required: No
- Type: array

### Parameter: `aseConfig.multiSize`

Front-end VM size.

- Required: No
- Type: string

### Parameter: `aseConfig.name`

Custom name for the App Service Environment. Falls back to naming-module default.

- Required: No
- Type: string

### Parameter: `aseConfig.remoteDebugEnabled`

Enable remote debug on the ASE.

- Required: No
- Type: bool

### Parameter: `aseConfig.roleAssignments`

Role assignments for the ASE.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-aseconfigroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-aseconfigroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-aseconfigroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-aseconfigroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-aseconfigroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-aseconfigroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-aseconfigroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-aseconfigroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `aseConfig.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `aseConfig.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `aseConfig.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `aseConfig.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `aseConfig.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `aseConfig.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `aseConfig.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `aseConfig.roleAssignments.principalType`

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

### Parameter: `aseConfig.upgradePreference`

Maintenance upgrade preference.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Early'
    'Late'
    'Manual'
    'None'
  ]
  ```

### Parameter: `deployAseV3`

Default is false. Set to true if you want to deploy ASE v3 instead of Multitenant App Service Plan.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `environmentName`

The name of the environmentName (e.g. "dev", "test", "prod", "preprod", "staging", "uat", "dr", "qa"). Up to 8 characters long.

- Required: No
- Type: string
- Default: `'test'`

### Parameter: `frontDoorConfig`

Configuration for Azure Front Door. Only used when spokeNetworkConfig.ingressOption is "frontDoor".

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`afdPeAutoApproverName`](#parameter-frontdoorconfigafdpeautoapprovername) | string | Custom name for the AFD private-endpoint auto-approver managed identity. Falls back to naming-module default. |
| [`autoApprovePrivateEndpoint`](#parameter-frontdoorconfigautoapproveprivateendpoint) | bool | Auto-approve the private endpoint connection to AFD. |
| [`customDomains`](#parameter-frontdoorconfigcustomdomains) | array | Custom domains for the Front Door profile. |
| [`diagnosticSettings`](#parameter-frontdoorconfigdiagnosticsettings) | array | Diagnostic settings for Front Door. |
| [`enableDefaultWafMethodBlock`](#parameter-frontdoorconfigenabledefaultwafmethodblock) | bool | Deploy the default WAF rule that blocks non-GET/HEAD/OPTIONS methods. |
| [`endpointName`](#parameter-frontdoorconfigendpointname) | string | Custom name for the Front Door endpoint. Falls back to naming-module default. |
| [`healthProbeIntervalInSeconds`](#parameter-frontdoorconfighealthprobeintervalinseconds) | int | Health probe interval in seconds. |
| [`healthProbePath`](#parameter-frontdoorconfighealthprobepath) | string | Health probe path for the origin group. |
| [`lock`](#parameter-frontdoorconfiglock) | object | Resource lock for the Front Door profile. |
| [`name`](#parameter-frontdoorconfigname) | string | Custom name for the Front Door profile. Falls back to naming-module default. |
| [`originGroupName`](#parameter-frontdoorconfigorigingroupname) | string | Custom name for the Front Door origin group. Falls back to naming-module default. |
| [`originResponseTimeoutSeconds`](#parameter-frontdoorconfigoriginresponsetimeoutseconds) | int | Origin response timeout in seconds. Defaults to 120. |
| [`roleAssignments`](#parameter-frontdoorconfigroleassignments) | array | Role assignments for the Front Door profile. |
| [`ruleSets`](#parameter-frontdoorconfigrulesets) | array | Rule sets for the Front Door profile. |
| [`secrets`](#parameter-frontdoorconfigsecrets) | array | Secrets for the Front Door profile (e.g. BYOC certificates). |
| [`wafCustomRules`](#parameter-frontdoorconfigwafcustomrules) | object | Custom WAF rules. Only used when enableDefaultWafMethodBlock is false. |
| [`wafName`](#parameter-frontdoorconfigwafname) | string | Custom name for the Front Door WAF policy. Falls back to naming-module default. |

### Parameter: `frontDoorConfig.afdPeAutoApproverName`

Custom name for the AFD private-endpoint auto-approver managed identity. Falls back to naming-module default.

- Required: No
- Type: string

### Parameter: `frontDoorConfig.autoApprovePrivateEndpoint`

Auto-approve the private endpoint connection to AFD.

- Required: No
- Type: bool

### Parameter: `frontDoorConfig.customDomains`

Custom domains for the Front Door profile.

- Required: No
- Type: array

### Parameter: `frontDoorConfig.diagnosticSettings`

Diagnostic settings for Front Door.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-frontdoorconfigdiagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-frontdoorconfigdiagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-frontdoorconfigdiagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-frontdoorconfigdiagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-frontdoorconfigdiagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-frontdoorconfigdiagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-frontdoorconfigdiagnosticsettingsname) | string | The name of the diagnostic setting. |
| [`storageAccountResourceId`](#parameter-frontdoorconfigdiagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-frontdoorconfigdiagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `frontDoorConfig.diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `frontDoorConfig.diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `frontDoorConfig.diagnosticSettings.logAnalyticsDestinationType`

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

### Parameter: `frontDoorConfig.diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-frontdoorconfigdiagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-frontdoorconfigdiagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-frontdoorconfigdiagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `frontDoorConfig.diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `frontDoorConfig.diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `frontDoorConfig.diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `frontDoorConfig.diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `frontDoorConfig.diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-frontdoorconfigdiagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-frontdoorconfigdiagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `frontDoorConfig.diagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `frontDoorConfig.diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `frontDoorConfig.diagnosticSettings.name`

The name of the diagnostic setting.

- Required: No
- Type: string

### Parameter: `frontDoorConfig.diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `frontDoorConfig.diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `frontDoorConfig.enableDefaultWafMethodBlock`

Deploy the default WAF rule that blocks non-GET/HEAD/OPTIONS methods.

- Required: No
- Type: bool

### Parameter: `frontDoorConfig.endpointName`

Custom name for the Front Door endpoint. Falls back to naming-module default.

- Required: No
- Type: string

### Parameter: `frontDoorConfig.healthProbeIntervalInSeconds`

Health probe interval in seconds.

- Required: No
- Type: int

### Parameter: `frontDoorConfig.healthProbePath`

Health probe path for the origin group.

- Required: No
- Type: string

### Parameter: `frontDoorConfig.lock`

Resource lock for the Front Door profile.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-frontdoorconfiglockkind) | string | Specify the type of lock. |
| [`name`](#parameter-frontdoorconfiglockname) | string | Specify the name of lock. |
| [`notes`](#parameter-frontdoorconfiglocknotes) | string | Specify the notes of the lock. |

### Parameter: `frontDoorConfig.lock.kind`

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

### Parameter: `frontDoorConfig.lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `frontDoorConfig.lock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `frontDoorConfig.name`

Custom name for the Front Door profile. Falls back to naming-module default.

- Required: No
- Type: string

### Parameter: `frontDoorConfig.originGroupName`

Custom name for the Front Door origin group. Falls back to naming-module default.

- Required: No
- Type: string

### Parameter: `frontDoorConfig.originResponseTimeoutSeconds`

Origin response timeout in seconds. Defaults to 120.

- Required: No
- Type: int

### Parameter: `frontDoorConfig.roleAssignments`

Role assignments for the Front Door profile.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-frontdoorconfigroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-frontdoorconfigroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-frontdoorconfigroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-frontdoorconfigroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-frontdoorconfigroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-frontdoorconfigroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-frontdoorconfigroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-frontdoorconfigroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `frontDoorConfig.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `frontDoorConfig.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `frontDoorConfig.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `frontDoorConfig.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `frontDoorConfig.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `frontDoorConfig.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `frontDoorConfig.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `frontDoorConfig.roleAssignments.principalType`

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

### Parameter: `frontDoorConfig.ruleSets`

Rule sets for the Front Door profile.

- Required: No
- Type: array

### Parameter: `frontDoorConfig.secrets`

Secrets for the Front Door profile (e.g. BYOC certificates).

- Required: No
- Type: array

### Parameter: `frontDoorConfig.wafCustomRules`

Custom WAF rules. Only used when enableDefaultWafMethodBlock is false.

- Required: No
- Type: object

### Parameter: `frontDoorConfig.wafName`

Custom name for the Front Door WAF policy. Falls back to naming-module default.

- Required: No
- Type: string

### Parameter: `keyVaultConfig`

Configuration for the Key Vault.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`accessPolicies`](#parameter-keyvaultconfigaccesspolicies) | array | Access policies (non-RBAC mode). |
| [`additionalRoleAssignments`](#parameter-keyvaultconfigadditionalroleassignments) | array | Additional role assignments beyond the default App Service identity. |
| [`createMode`](#parameter-keyvaultconfigcreatemode) | string | Create mode: "default" or "recover". |
| [`diagnosticSettings`](#parameter-keyvaultconfigdiagnosticsettings) | array | Diagnostic settings for the Key Vault. |
| [`enablePurgeProtection`](#parameter-keyvaultconfigenablepurgeprotection) | bool | Enable purge protection. Defaults to true. |
| [`enableRbacAuthorization`](#parameter-keyvaultconfigenablerbacauthorization) | bool | Enable RBAC authorization. Defaults to true. |
| [`enableVaultForDeployment`](#parameter-keyvaultconfigenablevaultfordeployment) | bool | Enable for deployment. |
| [`enableVaultForDiskEncryption`](#parameter-keyvaultconfigenablevaultfordiskencryption) | bool | Enable for disk encryption. |
| [`enableVaultForTemplateDeployment`](#parameter-keyvaultconfigenablevaultfortemplatedeployment) | bool | Enable for template deployment. |
| [`keys`](#parameter-keyvaultconfigkeys) | array | Keys to create. |
| [`lock`](#parameter-keyvaultconfiglock) | object | Resource lock for the Key Vault. |
| [`name`](#parameter-keyvaultconfigname) | string | Custom name for the Key Vault. Falls back to naming-module default. |
| [`networkAcls`](#parameter-keyvaultconfignetworkacls) | object | Network ACLs for the Key Vault. |
| [`publicNetworkAccess`](#parameter-keyvaultconfigpublicnetworkaccess) | string | Public network access for the Key Vault. |
| [`secrets`](#parameter-keyvaultconfigsecrets) | array | Secrets to create. |
| [`sku`](#parameter-keyvaultconfigsku) | string | The SKU: "standard" or "premium". |
| [`softDeleteRetentionInDays`](#parameter-keyvaultconfigsoftdeleteretentionindays) | int | Soft delete retention in days. Defaults to 90. |

### Parameter: `keyVaultConfig.accessPolicies`

Access policies (non-RBAC mode).

- Required: No
- Type: array

### Parameter: `keyVaultConfig.additionalRoleAssignments`

Additional role assignments beyond the default App Service identity.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-keyvaultconfigadditionalroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-keyvaultconfigadditionalroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-keyvaultconfigadditionalroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-keyvaultconfigadditionalroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-keyvaultconfigadditionalroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-keyvaultconfigadditionalroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-keyvaultconfigadditionalroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-keyvaultconfigadditionalroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `keyVaultConfig.additionalRoleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `keyVaultConfig.additionalRoleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `keyVaultConfig.additionalRoleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `keyVaultConfig.additionalRoleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `keyVaultConfig.additionalRoleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `keyVaultConfig.additionalRoleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `keyVaultConfig.additionalRoleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `keyVaultConfig.additionalRoleAssignments.principalType`

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

### Parameter: `keyVaultConfig.createMode`

Create mode: "default" or "recover".

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'default'
    'recover'
  ]
  ```

### Parameter: `keyVaultConfig.diagnosticSettings`

Diagnostic settings for the Key Vault.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-keyvaultconfigdiagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-keyvaultconfigdiagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-keyvaultconfigdiagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-keyvaultconfigdiagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-keyvaultconfigdiagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-keyvaultconfigdiagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-keyvaultconfigdiagnosticsettingsname) | string | The name of the diagnostic setting. |
| [`storageAccountResourceId`](#parameter-keyvaultconfigdiagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-keyvaultconfigdiagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `keyVaultConfig.diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `keyVaultConfig.diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `keyVaultConfig.diagnosticSettings.logAnalyticsDestinationType`

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

### Parameter: `keyVaultConfig.diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-keyvaultconfigdiagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-keyvaultconfigdiagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-keyvaultconfigdiagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `keyVaultConfig.diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `keyVaultConfig.diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `keyVaultConfig.diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `keyVaultConfig.diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `keyVaultConfig.diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-keyvaultconfigdiagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-keyvaultconfigdiagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `keyVaultConfig.diagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `keyVaultConfig.diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `keyVaultConfig.diagnosticSettings.name`

The name of the diagnostic setting.

- Required: No
- Type: string

### Parameter: `keyVaultConfig.diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `keyVaultConfig.diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `keyVaultConfig.enablePurgeProtection`

Enable purge protection. Defaults to true.

- Required: No
- Type: bool

### Parameter: `keyVaultConfig.enableRbacAuthorization`

Enable RBAC authorization. Defaults to true.

- Required: No
- Type: bool

### Parameter: `keyVaultConfig.enableVaultForDeployment`

Enable for deployment.

- Required: No
- Type: bool

### Parameter: `keyVaultConfig.enableVaultForDiskEncryption`

Enable for disk encryption.

- Required: No
- Type: bool

### Parameter: `keyVaultConfig.enableVaultForTemplateDeployment`

Enable for template deployment.

- Required: No
- Type: bool

### Parameter: `keyVaultConfig.keys`

Keys to create.

- Required: No
- Type: array

### Parameter: `keyVaultConfig.lock`

Resource lock for the Key Vault.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-keyvaultconfiglockkind) | string | Specify the type of lock. |
| [`name`](#parameter-keyvaultconfiglockname) | string | Specify the name of lock. |
| [`notes`](#parameter-keyvaultconfiglocknotes) | string | Specify the notes of the lock. |

### Parameter: `keyVaultConfig.lock.kind`

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

### Parameter: `keyVaultConfig.lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `keyVaultConfig.lock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `keyVaultConfig.name`

Custom name for the Key Vault. Falls back to naming-module default.

- Required: No
- Type: string

### Parameter: `keyVaultConfig.networkAcls`

Network ACLs for the Key Vault.

- Required: No
- Type: object

### Parameter: `keyVaultConfig.publicNetworkAccess`

Public network access for the Key Vault.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    ''
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `keyVaultConfig.secrets`

Secrets to create.

- Required: No
- Type: array

### Parameter: `keyVaultConfig.sku`

The SKU: "standard" or "premium".

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'premium'
    'standard'
  ]
  ```

### Parameter: `keyVaultConfig.softDeleteRetentionInDays`

Soft delete retention in days. Defaults to 90.

- Required: No
- Type: int

### Parameter: `location`

Azure region where the resources will be deployed in.

- Required: No
- Type: string
- Default: `[deployment().location]`

### Parameter: `servicePlanConfig`

Configuration for the App Service Plan.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`diagnosticSettings`](#parameter-serviceplanconfigdiagnosticsettings) | array | Diagnostic settings for the App Service Plan. |
| [`elasticScaleEnabled`](#parameter-serviceplanconfigelasticscaleenabled) | bool | Whether elastic scale is enabled. |
| [`existingPlanId`](#parameter-serviceplanconfigexistingplanid) | string | Resource ID of an existing App Service Plan. Skips creating a new plan if provided. |
| [`installScripts`](#parameter-serviceplanconfiginstallscripts) | array | Install scripts for the App Service Plan. |
| [`isCustomMode`](#parameter-serviceplanconfigiscustommode) | bool | Whether the App Service Plan uses custom mode. |
| [`kind`](#parameter-serviceplanconfigkind) | string | Kind of server OS: "windows" or "linux". |
| [`lock`](#parameter-serviceplanconfiglock) | object | Resource lock for the App Service Plan. |
| [`managedIdentities`](#parameter-serviceplanconfigmanagedidentities) | object | Managed identities for the App Service Plan. |
| [`maximumElasticWorkerCount`](#parameter-serviceplanconfigmaximumelasticworkercount) | int | Maximum number of total workers for ElasticScaleEnabled plans. |
| [`name`](#parameter-serviceplanconfigname) | string | Custom name for the App Service Plan. Falls back to naming-module default. |
| [`perSiteScaling`](#parameter-serviceplanconfigpersitescaling) | bool | If true, apps can be scaled independently. |
| [`planDefaultIdentity`](#parameter-serviceplanconfigplandefaultidentity) | string | The default identity for the App Service Plan. |
| [`rdpEnabled`](#parameter-serviceplanconfigrdpenabled) | bool | Whether RDP is enabled. |
| [`registryAdapters`](#parameter-serviceplanconfigregistryadapters) | array | Registry adapter configuration. |
| [`roleAssignments`](#parameter-serviceplanconfigroleassignments) | array | Role assignments for the App Service Plan. |
| [`sku`](#parameter-serviceplanconfigsku) | string | The SKU name for the App Service Plan (e.g. "P1V3"). |
| [`skuCapacity`](#parameter-serviceplanconfigskucapacity) | int | The SKU capacity (number of workers). |
| [`storageMounts`](#parameter-serviceplanconfigstoragemounts) | array | Storage mount configuration. |
| [`targetWorkerCount`](#parameter-serviceplanconfigtargetworkercount) | int | Scaling worker count. |
| [`targetWorkerSize`](#parameter-serviceplanconfigtargetworkersize) | int | The instance size of the hosting plan (0=small, 1=medium, 2=large). |
| [`virtualNetworkSubnetId`](#parameter-serviceplanconfigvirtualnetworksubnetid) | string | Resource ID of a subnet for App Service Plan VNet integration. |
| [`workerTierName`](#parameter-serviceplanconfigworkertiername) | string | Target worker tier name. |
| [`zoneRedundant`](#parameter-serviceplanconfigzoneredundant) | bool | Deploy the plan in a zone redundant manner. |

### Parameter: `servicePlanConfig.diagnosticSettings`

Diagnostic settings for the App Service Plan.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-serviceplanconfigdiagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-serviceplanconfigdiagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-serviceplanconfigdiagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`marketplacePartnerResourceId`](#parameter-serviceplanconfigdiagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-serviceplanconfigdiagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-serviceplanconfigdiagnosticsettingsname) | string | The name of diagnostic setting. |
| [`storageAccountResourceId`](#parameter-serviceplanconfigdiagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-serviceplanconfigdiagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `servicePlanConfig.diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `servicePlanConfig.diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `servicePlanConfig.diagnosticSettings.logAnalyticsDestinationType`

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

### Parameter: `servicePlanConfig.diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `servicePlanConfig.diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-serviceplanconfigdiagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-serviceplanconfigdiagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `servicePlanConfig.diagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `servicePlanConfig.diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `servicePlanConfig.diagnosticSettings.name`

The name of diagnostic setting.

- Required: No
- Type: string

### Parameter: `servicePlanConfig.diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `servicePlanConfig.diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `servicePlanConfig.elasticScaleEnabled`

Whether elastic scale is enabled.

- Required: No
- Type: bool

### Parameter: `servicePlanConfig.existingPlanId`

Resource ID of an existing App Service Plan. Skips creating a new plan if provided.

- Required: No
- Type: string

### Parameter: `servicePlanConfig.installScripts`

Install scripts for the App Service Plan.

- Required: No
- Type: array

### Parameter: `servicePlanConfig.isCustomMode`

Whether the App Service Plan uses custom mode.

- Required: No
- Type: bool

### Parameter: `servicePlanConfig.kind`

Kind of server OS: "windows" or "linux".

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'linux'
    'windows'
  ]
  ```

### Parameter: `servicePlanConfig.lock`

Resource lock for the App Service Plan.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-serviceplanconfiglockkind) | string | Specify the type of lock. |
| [`name`](#parameter-serviceplanconfiglockname) | string | Specify the name of lock. |
| [`notes`](#parameter-serviceplanconfiglocknotes) | string | Specify the notes of the lock. |

### Parameter: `servicePlanConfig.lock.kind`

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

### Parameter: `servicePlanConfig.lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `servicePlanConfig.lock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `servicePlanConfig.managedIdentities`

Managed identities for the App Service Plan.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`systemAssigned`](#parameter-serviceplanconfigmanagedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. |
| [`userAssignedResourceIds`](#parameter-serviceplanconfigmanagedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption. |

### Parameter: `servicePlanConfig.managedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `servicePlanConfig.managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption.

- Required: No
- Type: array

### Parameter: `servicePlanConfig.maximumElasticWorkerCount`

Maximum number of total workers for ElasticScaleEnabled plans.

- Required: No
- Type: int

### Parameter: `servicePlanConfig.name`

Custom name for the App Service Plan. Falls back to naming-module default.

- Required: No
- Type: string

### Parameter: `servicePlanConfig.perSiteScaling`

If true, apps can be scaled independently.

- Required: No
- Type: bool

### Parameter: `servicePlanConfig.planDefaultIdentity`

The default identity for the App Service Plan.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'DefaultIdentity'
  ]
  ```

### Parameter: `servicePlanConfig.rdpEnabled`

Whether RDP is enabled.

- Required: No
- Type: bool

### Parameter: `servicePlanConfig.registryAdapters`

Registry adapter configuration.

- Required: No
- Type: array

### Parameter: `servicePlanConfig.roleAssignments`

Role assignments for the App Service Plan.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-serviceplanconfigroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-serviceplanconfigroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-serviceplanconfigroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-serviceplanconfigroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-serviceplanconfigroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-serviceplanconfigroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-serviceplanconfigroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-serviceplanconfigroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `servicePlanConfig.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `servicePlanConfig.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `servicePlanConfig.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `servicePlanConfig.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `servicePlanConfig.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `servicePlanConfig.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `servicePlanConfig.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `servicePlanConfig.roleAssignments.principalType`

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

### Parameter: `servicePlanConfig.sku`

The SKU name for the App Service Plan (e.g. "P1V3").

- Required: No
- Type: string

### Parameter: `servicePlanConfig.skuCapacity`

The SKU capacity (number of workers).

- Required: No
- Type: int

### Parameter: `servicePlanConfig.storageMounts`

Storage mount configuration.

- Required: No
- Type: array

### Parameter: `servicePlanConfig.targetWorkerCount`

Scaling worker count.

- Required: No
- Type: int

### Parameter: `servicePlanConfig.targetWorkerSize`

The instance size of the hosting plan (0=small, 1=medium, 2=large).

- Required: No
- Type: int
- Allowed:
  ```Bicep
  [
    0
    1
    2
  ]
  ```

### Parameter: `servicePlanConfig.virtualNetworkSubnetId`

Resource ID of a subnet for App Service Plan VNet integration.

- Required: No
- Type: string

### Parameter: `servicePlanConfig.workerTierName`

Target worker tier name.

- Required: No
- Type: string

### Parameter: `servicePlanConfig.zoneRedundant`

Deploy the plan in a zone redundant manner.

- Required: No
- Type: bool

### Parameter: `spokeNetworkConfig`

Configuration for the spoke virtual network and ingress networking.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appGwSubnetAddressSpace`](#parameter-spokenetworkconfigappgwsubnetaddressspace) | string | CIDR of the Application Gateway subnet. Required when ingressOption is "applicationGateway". |
| [`appSvcSubnetAddressSpace`](#parameter-spokenetworkconfigappsvcsubnetaddressspace) | string | CIDR of the App Service / ASE subnet. ASEv3 needs a /24. |
| [`bgpCommunity`](#parameter-spokenetworkconfigbgpcommunity) | string | The BGP community for the VNet. |
| [`ddosProtectionPlanResourceId`](#parameter-spokenetworkconfigddosprotectionplanresourceid) | string | Resource ID of a DDoS Protection Plan to associate with the spoke VNet. |
| [`diagnosticSettings`](#parameter-spokenetworkconfigdiagnosticsettings) | array | Diagnostic settings for the spoke virtual network. |
| [`disableBgpRoutePropagation`](#parameter-spokenetworkconfigdisablebgproutepropagation) | bool | Whether to disable BGP route propagation on the route table. |
| [`dnsServers`](#parameter-spokenetworkconfigdnsservers) | array | Custom DNS servers for the spoke VNet. If empty, Azure-provided DNS is used. |
| [`enableEgressLockdown`](#parameter-spokenetworkconfigenableegresslockdown) | bool | Set to true to route all egress traffic through the firewall. |
| [`enableVmProtection`](#parameter-spokenetworkconfigenablevmprotection) | bool | Enable VM protection for the VNet. |
| [`encryption`](#parameter-spokenetworkconfigencryption) | bool | Enable VNet encryption. |
| [`encryptionEnforcement`](#parameter-spokenetworkconfigencryptionenforcement) | string | VNet encryption enforcement policy. |
| [`firewallInternalIp`](#parameter-spokenetworkconfigfirewallinternalip) | string | Internal IP of the Azure Firewall in the hub. If set, a UDR is created for egress. |
| [`flowTimeoutInMinutes`](#parameter-spokenetworkconfigflowtimeoutinminutes) | int | The flow timeout in minutes for the VNet (max 30). 0 = disabled. |
| [`hubVnetResourceId`](#parameter-spokenetworkconfighubvnetresourceid) | string | Resource ID of an existing hub VNet to peer with. If empty, no peering is created. |
| [`ingressOption`](#parameter-spokenetworkconfigingressoption) | string | Ingress option: "frontDoor", "applicationGateway", or "none". |
| [`lock`](#parameter-spokenetworkconfiglock) | object | Resource lock for the spoke virtual network. |
| [`privateEndpointSubnetAddressSpace`](#parameter-spokenetworkconfigprivateendpointsubnetaddressspace) | string | CIDR of the private endpoint subnet. |
| [`resourceGroupName`](#parameter-spokenetworkconfigresourcegroupname) | string | Custom name for the spoke resource group. Falls back to naming-module default. |
| [`roleAssignments`](#parameter-spokenetworkconfigroleassignments) | array | Role assignments for the spoke virtual network. |
| [`vnetAddressSpace`](#parameter-spokenetworkconfigvnetaddressspace) | string | CIDR of the spoke VNet (e.g. "10.240.0.0/20"). |

### Parameter: `spokeNetworkConfig.appGwSubnetAddressSpace`

CIDR of the Application Gateway subnet. Required when ingressOption is "applicationGateway".

- Required: No
- Type: string

### Parameter: `spokeNetworkConfig.appSvcSubnetAddressSpace`

CIDR of the App Service / ASE subnet. ASEv3 needs a /24.

- Required: No
- Type: string

### Parameter: `spokeNetworkConfig.bgpCommunity`

The BGP community for the VNet.

- Required: No
- Type: string

### Parameter: `spokeNetworkConfig.ddosProtectionPlanResourceId`

Resource ID of a DDoS Protection Plan to associate with the spoke VNet.

- Required: No
- Type: string

### Parameter: `spokeNetworkConfig.diagnosticSettings`

Diagnostic settings for the spoke virtual network.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-spokenetworkconfigdiagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-spokenetworkconfigdiagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-spokenetworkconfigdiagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-spokenetworkconfigdiagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-spokenetworkconfigdiagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-spokenetworkconfigdiagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-spokenetworkconfigdiagnosticsettingsname) | string | The name of the diagnostic setting. |
| [`storageAccountResourceId`](#parameter-spokenetworkconfigdiagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-spokenetworkconfigdiagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `spokeNetworkConfig.diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `spokeNetworkConfig.diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `spokeNetworkConfig.diagnosticSettings.logAnalyticsDestinationType`

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

### Parameter: `spokeNetworkConfig.diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-spokenetworkconfigdiagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-spokenetworkconfigdiagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-spokenetworkconfigdiagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `spokeNetworkConfig.diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `spokeNetworkConfig.diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `spokeNetworkConfig.diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `spokeNetworkConfig.diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `spokeNetworkConfig.diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-spokenetworkconfigdiagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-spokenetworkconfigdiagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `spokeNetworkConfig.diagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `spokeNetworkConfig.diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `spokeNetworkConfig.diagnosticSettings.name`

The name of the diagnostic setting.

- Required: No
- Type: string

### Parameter: `spokeNetworkConfig.diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `spokeNetworkConfig.diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `spokeNetworkConfig.disableBgpRoutePropagation`

Whether to disable BGP route propagation on the route table.

- Required: No
- Type: bool

### Parameter: `spokeNetworkConfig.dnsServers`

Custom DNS servers for the spoke VNet. If empty, Azure-provided DNS is used.

- Required: No
- Type: array

### Parameter: `spokeNetworkConfig.enableEgressLockdown`

Set to true to route all egress traffic through the firewall.

- Required: No
- Type: bool

### Parameter: `spokeNetworkConfig.enableVmProtection`

Enable VM protection for the VNet.

- Required: No
- Type: bool

### Parameter: `spokeNetworkConfig.encryption`

Enable VNet encryption.

- Required: No
- Type: bool

### Parameter: `spokeNetworkConfig.encryptionEnforcement`

VNet encryption enforcement policy.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AllowUnencrypted'
    'DropUnencrypted'
  ]
  ```

### Parameter: `spokeNetworkConfig.firewallInternalIp`

Internal IP of the Azure Firewall in the hub. If set, a UDR is created for egress.

- Required: No
- Type: string

### Parameter: `spokeNetworkConfig.flowTimeoutInMinutes`

The flow timeout in minutes for the VNet (max 30). 0 = disabled.

- Required: No
- Type: int

### Parameter: `spokeNetworkConfig.hubVnetResourceId`

Resource ID of an existing hub VNet to peer with. If empty, no peering is created.

- Required: No
- Type: string

### Parameter: `spokeNetworkConfig.ingressOption`

Ingress option: "frontDoor", "applicationGateway", or "none".

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'applicationGateway'
    'frontDoor'
    'none'
  ]
  ```

### Parameter: `spokeNetworkConfig.lock`

Resource lock for the spoke virtual network.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-spokenetworkconfiglockkind) | string | Specify the type of lock. |
| [`name`](#parameter-spokenetworkconfiglockname) | string | Specify the name of lock. |
| [`notes`](#parameter-spokenetworkconfiglocknotes) | string | Specify the notes of the lock. |

### Parameter: `spokeNetworkConfig.lock.kind`

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

### Parameter: `spokeNetworkConfig.lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `spokeNetworkConfig.lock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `spokeNetworkConfig.privateEndpointSubnetAddressSpace`

CIDR of the private endpoint subnet.

- Required: No
- Type: string

### Parameter: `spokeNetworkConfig.resourceGroupName`

Custom name for the spoke resource group. Falls back to naming-module default.

- Required: No
- Type: string

### Parameter: `spokeNetworkConfig.roleAssignments`

Role assignments for the spoke virtual network.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-spokenetworkconfigroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-spokenetworkconfigroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-spokenetworkconfigroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-spokenetworkconfigroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-spokenetworkconfigroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-spokenetworkconfigroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-spokenetworkconfigroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-spokenetworkconfigroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `spokeNetworkConfig.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `spokeNetworkConfig.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `spokeNetworkConfig.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `spokeNetworkConfig.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `spokeNetworkConfig.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `spokeNetworkConfig.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `spokeNetworkConfig.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `spokeNetworkConfig.roleAssignments.principalType`

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

### Parameter: `spokeNetworkConfig.vnetAddressSpace`

CIDR of the spoke VNet (e.g. "10.240.0.0/20").

- Required: No
- Type: string

### Parameter: `tags`

Tags to apply to all resources.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `workloadName`

suffix (max 10 characters long) that will be used to name the resources in a pattern like <resourceAbbreviation>-<workloadName>.

- Required: No
- Type: string
- Default: `[format('appsvc{0}', take(uniqueString(subscription().id), 4))]`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `appServicePlanResourceId` | string | The resource ID of the App Service Plan used (either created or pre-existing). |
| `aseName` | string | The name of the ASE. |
| `internalInboundIpAddress` | string | The Internal ingress IP of the ASE. |
| `keyVaultName` | string | The name of the Azure key vault. |
| `keyVaultResourceId` | string | The resource ID of the key vault. |
| `spokeResourceGroupName` | string | The name of the Spoke resource group. |
| `spokeVnetName` | string | The name of the Spoke Virtual Network. |
| `spokeVNetResourceId` | string | The resource ID of the Spoke Virtual Network. |
| `webAppHostName` | string | The default hostname of the web app. |
| `webAppLocation` | string | The location of the web app. |
| `webAppManagedIdentityPrincipalId` | string | The principal ID of the user-assigned managed identity for the web app. |
| `webAppName` | string | The name of the web app. |
| `webAppResourceId` | string | The resource ID of the web app. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/cdn/profile:0.19.0` | Remote reference |
| `br/public:avm/res/insights/component:0.7.1` | Remote reference |
| `br/public:avm/res/key-vault/vault:0.13.3` | Remote reference |
| `br/public:avm/res/managed-identity/user-assigned-identity:0.5.0` | Remote reference |
| `br/public:avm/res/network/application-gateway-web-application-firewall-policy:0.3.0` | Remote reference |
| `br/public:avm/res/network/application-gateway:0.9.0` | Remote reference |
| `br/public:avm/res/network/front-door-web-application-firewall-policy:0.3.3` | Remote reference |
| `br/public:avm/res/network/network-security-group:0.5.2` | Remote reference |
| `br/public:avm/res/network/private-dns-zone:0.8.1` | Remote reference |
| `br/public:avm/res/network/private-endpoint:0.12.0` | Remote reference |
| `br/public:avm/res/network/public-ip-address:0.12.0` | Remote reference |
| `br/public:avm/res/network/route-table:0.5.0` | Remote reference |
| `br/public:avm/res/network/virtual-network:0.7.2` | Remote reference |
| `br/public:avm/res/resources/deployment-script:0.5.2` | Remote reference |
| `br/public:avm/res/resources/resource-group:0.4.3` | Remote reference |
| `br/public:avm/res/web/hosting-environment:0.5.0` | Remote reference |
| `br/public:avm/res/web/serverfarm:0.7.0` | Remote reference |
| `br/public:avm/res/web/site:0.22.0` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
