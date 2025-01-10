# App Service Landing Zone Accelerator `[AppServiceLza/HostingEnvironment]`

This Azure App Service pattern module represents an Azure App Service deployment aligned with the cloud adoption framework

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Authorization/roleAssignments` | [2020-04-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-04-01-preview/roleAssignments) |
| `Microsoft.Automanage/configurationProfileAssignments` | [2022-05-04](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Automanage/2022-05-04/configurationProfileAssignments) |
| `Microsoft.Cdn/profiles` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2023-05-01/profiles) |
| `Microsoft.Cdn/profiles/afdEndpoints` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2023-05-01/profiles/afdEndpoints) |
| `Microsoft.Cdn/profiles/afdEndpoints/routes` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2023-05-01/profiles/afdEndpoints/routes) |
| `Microsoft.Cdn/profiles/customDomains` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2023-05-01/profiles/customDomains) |
| `Microsoft.Cdn/profiles/endpoints` | [2021-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2021-06-01/profiles/endpoints) |
| `Microsoft.Cdn/profiles/endpoints/origins` | [2021-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2021-06-01/profiles/endpoints/origins) |
| `Microsoft.Cdn/profiles/originGroups` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2023-05-01/profiles/originGroups) |
| `Microsoft.Cdn/profiles/originGroups/origins` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2023-05-01/profiles/originGroups/origins) |
| `Microsoft.Cdn/profiles/ruleSets` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2023-05-01/profiles/ruleSets) |
| `Microsoft.Cdn/profiles/ruleSets/rules` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2023-05-01/profiles/ruleSets/rules) |
| `Microsoft.Cdn/profiles/secrets` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2023-05-01/profiles/secrets) |
| `Microsoft.Cdn/profiles/securityPolicies` | [2024-02-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2024-02-01/profiles/securityPolicies) |
| `Microsoft.Compute/sshPublicKeys` | [2022-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2022-03-01/sshPublicKeys) |
| `Microsoft.Compute/virtualMachines` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2023-09-01/virtualMachines) |
| `Microsoft.Compute/virtualMachines/extensions` | [2022-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2022-11-01/virtualMachines/extensions) |
| `Microsoft.DevTestLab/schedules` | [2018-09-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevTestLab/2018-09-15/schedules) |
| `Microsoft.GuestConfiguration/guestConfigurationAssignments` | [2020-06-25](https://learn.microsoft.com/en-us/azure/templates/Microsoft.GuestConfiguration/2020-06-25/guestConfigurationAssignments) |
| `Microsoft.Insights/components` | [2020-02-02](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2020-02-02/components) |
| `microsoft.insights/components/linkedStorageAccounts` | [2020-03-01-preview](https://learn.microsoft.com/en-us/azure/templates/microsoft.insights/2020-03-01-preview/components/linkedStorageAccounts) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.KeyVault/vaults` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults) |
| `Microsoft.KeyVault/vaults/accessPolicies` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/accessPolicies) |
| `Microsoft.KeyVault/vaults/keys` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/keys) |
| `Microsoft.KeyVault/vaults/secrets` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/secrets) |
| `Microsoft.Maintenance/configurationAssignments` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Maintenance/2023-04-01/configurationAssignments) |
| `Microsoft.Maintenance/maintenanceConfigurations` | [2023-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Maintenance/2023-10-01-preview/maintenanceConfigurations) |
| `Microsoft.ManagedIdentity/userAssignedIdentities` | [2023-01-31](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2023-01-31/userAssignedIdentities) |
| `Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials` | [2023-01-31](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2023-01-31/userAssignedIdentities/federatedIdentityCredentials) |
| `Microsoft.Network/FrontDoorWebApplicationFirewallPolicies` | [2022-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-05-01/FrontDoorWebApplicationFirewallPolicies) |
| `Microsoft.Network/networkInterfaces` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/networkInterfaces) |
| `Microsoft.Network/networkSecurityGroups` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/networkSecurityGroups) |
| `Microsoft.Network/networkSecurityGroups/securityRules` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/networkSecurityGroups/securityRules) |
| `Microsoft.Network/privateDnsZones` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones) |
| `Microsoft.Network/privateDnsZones/A` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/A) |
| `Microsoft.Network/privateDnsZones/AAAA` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/AAAA) |
| `Microsoft.Network/privateDnsZones/CNAME` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/CNAME) |
| `Microsoft.Network/privateDnsZones/MX` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/MX) |
| `Microsoft.Network/privateDnsZones/PTR` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/PTR) |
| `Microsoft.Network/privateDnsZones/SOA` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/SOA) |
| `Microsoft.Network/privateDnsZones/SRV` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/SRV) |
| `Microsoft.Network/privateDnsZones/TXT` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/TXT) |
| `Microsoft.Network/privateDnsZones/virtualNetworkLinks` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/virtualNetworkLinks) |
| `Microsoft.Network/privateEndpoints` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.Network/publicIPAddresses` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-09-01/publicIPAddresses) |
| `Microsoft.Network/routeTables` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/routeTables) |
| `Microsoft.Network/virtualNetworks` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-01-01/virtualNetworks) |
| `Microsoft.Network/virtualNetworks/subnets` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/virtualNetworks/subnets) |
| `Microsoft.Network/virtualNetworks/subnets` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-01-01/virtualNetworks/subnets) |
| `Microsoft.Network/virtualNetworks/virtualNetworkPeerings` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-01-01/virtualNetworks/virtualNetworkPeerings) |
| `Microsoft.OperationalInsights/workspaces` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2022-10-01/workspaces) |
| `Microsoft.OperationalInsights/workspaces/dataExports` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/dataExports) |
| `Microsoft.OperationalInsights/workspaces/dataSources` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/dataSources) |
| `Microsoft.OperationalInsights/workspaces/linkedServices` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/linkedServices) |
| `Microsoft.OperationalInsights/workspaces/linkedStorageAccounts` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/linkedStorageAccounts) |
| `Microsoft.OperationalInsights/workspaces/savedSearches` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/savedSearches) |
| `Microsoft.OperationalInsights/workspaces/storageInsightConfigs` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/storageInsightConfigs) |
| `Microsoft.OperationalInsights/workspaces/tables` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2022-10-01/workspaces/tables) |
| `Microsoft.OperationsManagement/solutions` | [2015-11-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationsManagement/2015-11-01-preview/solutions) |
| `Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2023-01-01/vaults/backupFabrics/protectionContainers/protectedItems) |
| `Microsoft.Resources/deploymentScripts` | [2023-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2023-08-01/deploymentScripts) |
| `Microsoft.Resources/deploymentScripts` | [2020-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2020-10-01/deploymentScripts) |
| `Microsoft.Resources/resourceGroups` | [2021-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2021-04-01/resourceGroups) |
| `Microsoft.Web/hostingEnvironments` | [2022-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2022-03-01/hostingEnvironments) |
| `Microsoft.Web/hostingEnvironments/configurations` | [2022-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2022-03-01/hostingEnvironments/configurations) |
| `Microsoft.Web/serverfarms` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2022-09-01/serverfarms) |
| `Microsoft.Web/sites` | [2023-12-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2023-12-01/sites) |
| `Microsoft.Web/sites/basicPublishingCredentialsPolicies` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2022-09-01/sites/basicPublishingCredentialsPolicies) |
| `Microsoft.Web/sites/config` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2022-09-01/sites/config) |
| `Microsoft.Web/sites/config` | [2023-12-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2023-12-01/sites/config) |
| `Microsoft.Web/sites/extensions` | [2023-12-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2023-12-01/sites/extensions) |
| `Microsoft.Web/sites/hybridConnectionNamespaces/relays` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2022-09-01/sites/hybridConnectionNamespaces/relays) |
| `Microsoft.Web/sites/slots` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2022-09-01/sites/slots) |
| `Microsoft.Web/sites/slots/basicPublishingCredentialsPolicies` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2022-09-01/sites/slots/basicPublishingCredentialsPolicies) |
| `Microsoft.Web/sites/slots/config` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2022-09-01/sites/slots/config) |
| `Microsoft.Web/sites/slots/hybridConnectionNamespaces/relays` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2022-09-01/sites/slots/hybridConnectionNamespaces/relays) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/app-service-lza/hosting-environment:<version>`.

- [Using only defaults.](#example-1-using-only-defaults)
- [Using defaults with hub](#example-2-using-defaults-with-hub)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults._

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module hostingEnvironment 'br/public:avm/ptn/app-service-lza/hosting-environment:<version>' = {
  name: 'hostingEnvironmentDeployment'
  params: {
    adminPassword: '<adminPassword>'
    adminUsername: 'azureuser'
    autoApproveAfdPrivateEndpoint: true
    deployAseV3: false
    deployJumpHost: true
    enableEgressLockdown: false
    location: '<location>'
    subnetSpokeAppSvcAddressSpace: '10.240.0.0/26'
    subnetSpokeDevOpsAddressSpace: '10.240.10.128/26'
    subnetSpokePrivateEndpointAddressSpace: '10.240.11.0/24'
    tags: {
      environment: 'test'
    }
    vmSize: 'Standard_D2s_v4'
    vnetSpokeAddressSpace: '10.240.0.0/20'
    webAppBaseOs: 'linux'
    webAppPlanSku: 'P1V3'
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
    "adminPassword": {
      "value": "<adminPassword>"
    },
    "adminUsername": {
      "value": "azureuser"
    },
    "autoApproveAfdPrivateEndpoint": {
      "value": true
    },
    "deployAseV3": {
      "value": false
    },
    "deployJumpHost": {
      "value": true
    },
    "enableEgressLockdown": {
      "value": false
    },
    "location": {
      "value": "<location>"
    },
    "subnetSpokeAppSvcAddressSpace": {
      "value": "10.240.0.0/26"
    },
    "subnetSpokeDevOpsAddressSpace": {
      "value": "10.240.10.128/26"
    },
    "subnetSpokePrivateEndpointAddressSpace": {
      "value": "10.240.11.0/24"
    },
    "tags": {
      "value": {
        "environment": "test"
      }
    },
    "vmSize": {
      "value": "Standard_D2s_v4"
    },
    "vnetSpokeAddressSpace": {
      "value": "10.240.0.0/20"
    },
    "webAppBaseOs": {
      "value": "linux"
    },
    "webAppPlanSku": {
      "value": "P1V3"
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

param adminPassword = '<adminPassword>'
param adminUsername = 'azureuser'
param autoApproveAfdPrivateEndpoint = true
deployAseV3: false
param deployJumpHost = true
param enableEgressLockdown = false
param location = '<location>'
param subnetSpokeAppSvcAddressSpace = '10.240.0.0/26'
param subnetSpokeDevOpsAddressSpace = '10.240.10.128/26'
param subnetSpokePrivateEndpointAddressSpace = '10.240.11.0/24'
param tags = {
  environment: 'test'
}
param vmSize = 'Standard_D2s_v4'
param vnetSpokeAddressSpace = '10.240.0.0/20'
param webAppBaseOs = 'linux'
param webAppPlanSku = 'P1V3'
param workloadName = '<workloadName>'
```

</details>
<p>

### Example 2: _Using defaults with hub_

This instance deploys the module with the minimum set of required parameters and a hub.


<details>

<summary>via Bicep module</summary>

```bicep
module hostingEnvironment 'br/public:avm/ptn/app-service-lza/hosting-environment:<version>' = {
  name: 'hostingEnvironmentDeployment'
  params: {
    adminPassword: '<adminPassword>'
    adminUsername: 'azureuser'
    autoApproveAfdPrivateEndpoint: true
    deployAseV3: false
    deployJumpHost: true
    enableEgressLockdown: false
    location: '<location>'
    subnetSpokeAppSvcAddressSpace: '10.240.0.0/26'
    subnetSpokeDevOpsAddressSpace: '10.240.10.128/26'
    subnetSpokePrivateEndpointAddressSpace: '10.240.11.0/24'
    tags: {
      environment: 'test'
    }
    vmSize: 'Standard_D2s_v4'
    vnetHubResourceId: '<vnetHubResourceId>'
    vnetSpokeAddressSpace: '10.240.0.0/20'
    webAppBaseOs: 'linux'
    webAppPlanSku: 'P1V3'
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
    "adminPassword": {
      "value": "<adminPassword>"
    },
    "adminUsername": {
      "value": "azureuser"
    },
    "autoApproveAfdPrivateEndpoint": {
      "value": true
    },
    "deployAseV3": {
      "value": false
    },
    "deployJumpHost": {
      "value": true
    },
    "enableEgressLockdown": {
      "value": false
    },
    "location": {
      "value": "<location>"
    },
    "subnetSpokeAppSvcAddressSpace": {
      "value": "10.240.0.0/26"
    },
    "subnetSpokeDevOpsAddressSpace": {
      "value": "10.240.10.128/26"
    },
    "subnetSpokePrivateEndpointAddressSpace": {
      "value": "10.240.11.0/24"
    },
    "tags": {
      "value": {
        "environment": "test"
      }
    },
    "vmSize": {
      "value": "Standard_D2s_v4"
    },
    "vnetHubResourceId": {
      "value": "<vnetHubResourceId>"
    },
    "vnetSpokeAddressSpace": {
      "value": "10.240.0.0/20"
    },
    "webAppBaseOs": {
      "value": "linux"
    },
    "webAppPlanSku": {
      "value": "P1V3"
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

param adminPassword = '<adminPassword>'
param adminUsername = 'azureuser'
param autoApproveAfdPrivateEndpoint = true
deployAseV3: false
param deployJumpHost = true
param enableEgressLockdown = false
param location = '<location>'
param subnetSpokeAppSvcAddressSpace = '10.240.0.0/26'
param subnetSpokeDevOpsAddressSpace = '10.240.10.128/26'
param subnetSpokePrivateEndpointAddressSpace = '10.240.11.0/24'
param tags = {
  environment: 'test'
}
param vmSize = 'Standard_D2s_v4'
param vnetHubResourceId = '<vnetHubResourceId>'
param vnetSpokeAddressSpace = '10.240.0.0/20'
param webAppBaseOs = 'linux'
param webAppPlanSku = 'P1V3'
param workloadName = '<workloadName>'
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance deploys the module with WAF aligned settings.


<details>

<summary>via Bicep module</summary>

```bicep
module hostingEnvironment 'br/public:avm/ptn/app-service-lza/hosting-environment:<version>' = {
  name: 'hostingEnvironmentDeployment'
  params: {
    adminPassword: '<adminPassword>'
    adminUsername: 'azureuser'
    autoApproveAfdPrivateEndpoint: true
    deployAseV3: false
    deployJumpHost: true
    enableEgressLockdown: true
    firewallInternalIp: '<firewallInternalIp>'
    location: '<location>'
    subnetSpokeAppSvcAddressSpace: '10.240.0.0/26'
    subnetSpokeDevOpsAddressSpace: '10.240.10.128/26'
    subnetSpokePrivateEndpointAddressSpace: '10.240.11.0/24'
    tags: {
      environment: 'test'
    }
    vmAuthenticationType: 'sshPublicKey'
    vmSize: 'Standard_D2s_v4'
    vnetSpokeAddressSpace: '10.240.0.0/20'
    webAppBaseOs: 'linux'
    webAppPlanSku: 'P1V3'
    workloadName: '<workloadName>'
    zoneRedundant: true
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
    "adminPassword": {
      "value": "<adminPassword>"
    },
    "adminUsername": {
      "value": "azureuser"
    },
    "autoApproveAfdPrivateEndpoint": {
      "value": true
    },
    "deployAseV3": {
      "value": false
    },
    "deployJumpHost": {
      "value": true
    },
    "enableEgressLockdown": {
      "value": true
    },
    "firewallInternalIp": {
      "value": "<firewallInternalIp>"
    },
    "location": {
      "value": "<location>"
    },
    "subnetSpokeAppSvcAddressSpace": {
      "value": "10.240.0.0/26"
    },
    "subnetSpokeDevOpsAddressSpace": {
      "value": "10.240.10.128/26"
    },
    "subnetSpokePrivateEndpointAddressSpace": {
      "value": "10.240.11.0/24"
    },
    "tags": {
      "value": {
        "environment": "test"
      }
    },
    "vmAuthenticationType": {
      "value": "sshPublicKey"
    },
    "vmSize": {
      "value": "Standard_D2s_v4"
    },
    "vnetSpokeAddressSpace": {
      "value": "10.240.0.0/20"
    },
    "webAppBaseOs": {
      "value": "linux"
    },
    "webAppPlanSku": {
      "value": "P1V3"
    },
    "workloadName": {
      "value": "<workloadName>"
    },
    "zoneRedundant": {
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
using 'br/public:avm/ptn/app-service-lza/hosting-environment:<version>'

param adminPassword = '<adminPassword>'
param adminUsername = 'azureuser'
param autoApproveAfdPrivateEndpoint = true
deployAseV3: false
param deployJumpHost = true
param enableEgressLockdown = true
param firewallInternalIp = '<firewallInternalIp>'
param location = '<location>'
param subnetSpokeAppSvcAddressSpace = '10.240.0.0/26'
param subnetSpokeDevOpsAddressSpace = '10.240.10.128/26'
param subnetSpokePrivateEndpointAddressSpace = '10.240.11.0/24'
param tags = {
  environment: 'test'
}
param vmAuthenticationType = 'sshPublicKey'
param vmSize = 'Standard_D2s_v4'
param vnetSpokeAddressSpace = '10.240.0.0/20'
param webAppBaseOs = 'linux'
param webAppPlanSku = 'P1V3'
param workloadName = '<workloadName>'
param zoneRedundant = true
```

</details>
<p>

## Parameters

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`adminPassword`](#parameter-adminpassword) | securestring | Required if jumpbox deployed and not using SSH key. The password of the admin user of the jumpbox VM. |
| [`adminUsername`](#parameter-adminusername) | string | Required if jumpbox deployed. The username of the admin user of the jumpbox VM. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoApproveAfdPrivateEndpoint`](#parameter-autoapproveafdprivateendpoint) | bool | Set to true if you want to auto-approve the private endpoint connection to the Azure Front Door. |
| [`bastionResourceId`](#parameter-bastionresourceid) | string | The resource ID of the bastion host. If set, the spoke virtual network will be peered with the hub virtual network and the bastion host will be allowed to connect to the jump box. Default is empty. |
| [`deployAseV3`](#parameter-deployasev3) | bool | Default is false. Set to true if you want to deploy ASE v3 instead of Multitenant App Service Plan. |
| [`deployJumpHost`](#parameter-deployjumphost) | bool | Set to true if you want to deploy a jumpbox/devops VM. |
| [`enableEgressLockdown`](#parameter-enableegresslockdown) | bool | Set to true if you want to intercept all outbound traffic with azure firewall. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`environmentName`](#parameter-environmentname) | string | The name of the environmentName (e.g. "dev", "test", "prod", "preprod", "staging", "uat", "dr", "qa"). Up to 8 characters long. |
| [`firewallInternalIp`](#parameter-firewallinternalip) | string | Internal IP of the Azure firewall deployed in Hub. Used for creating UDR to route all vnet egress traffic through Firewall. If empty no UDR. |
| [`location`](#parameter-location) | string | Azure region where the resources will be deployed in. |
| [`subnetSpokeAppSvcAddressSpace`](#parameter-subnetspokeappsvcaddressspace) | string | CIDR of the subnet that will hold the app services plan. ATTENTION: ASEv3 needs a /24 network. |
| [`subnetSpokeDevOpsAddressSpace`](#parameter-subnetspokedevopsaddressspace) | string | CIDR of the subnet that will hold devOps agents etc. |
| [`subnetSpokePrivateEndpointAddressSpace`](#parameter-subnetspokeprivateendpointaddressspace) | string | CIDR of the subnet that will hold the private endpoints of the supporting services. |
| [`tags`](#parameter-tags) | object | Tags to apply to all resources. |
| [`vmAuthenticationType`](#parameter-vmauthenticationtype) | string | Type of authentication to use on the Virtual Machine. SSH key is recommended. Default is "password". |
| [`vmSize`](#parameter-vmsize) | string | The size of the jump box virtual machine to create. See https://learn.microsoft.com/azure/virtual-machines/sizes for more information. |
| [`vnetHubResourceId`](#parameter-vnethubresourceid) | string | Default is empty. If given, peering between spoke and and existing hub vnet will be created. |
| [`vnetSpokeAddressSpace`](#parameter-vnetspokeaddressspace) | string | CIDR of the SPOKE vnet i.e. 192.168.0.0/24. |
| [`webAppBaseOs`](#parameter-webappbaseos) | string | Kind of server OS of the App Service Plan. Default is "windows". |
| [`webAppPlanSku`](#parameter-webappplansku) | string | Defines the name, tier, size, family and capacity of the App Service Plan. EP* is only for functions. |
| [`workloadName`](#parameter-workloadname) | string | suffix (max 10 characters long) that will be used to name the resources in a pattern like <resourceAbbreviation>-<workloadName>. |
| [`zoneRedundant`](#parameter-zoneredundant) | bool | Set to true if you want to deploy the App Service Plan in a zone redundant manner. Defult is true. |

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

### Parameter: `autoApproveAfdPrivateEndpoint`

Set to true if you want to auto-approve the private endpoint connection to the Azure Front Door.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `bastionResourceId`

The resource ID of the bastion host. If set, the spoke virtual network will be peered with the hub virtual network and the bastion host will be allowed to connect to the jump box. Default is empty.

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

### Parameter: `environmentName`

The name of the environmentName (e.g. "dev", "test", "prod", "preprod", "staging", "uat", "dr", "qa"). Up to 8 characters long.

- Required: No
- Type: string
- Default: `'test'`

### Parameter: `firewallInternalIp`

Internal IP of the Azure firewall deployed in Hub. Used for creating UDR to route all vnet egress traffic through Firewall. If empty no UDR.

- Required: No
- Type: string
- Default: `''`

### Parameter: `location`

Azure region where the resources will be deployed in.

- Required: No
- Type: string
- Default: `[deployment().location]`

### Parameter: `subnetSpokeAppSvcAddressSpace`

CIDR of the subnet that will hold the app services plan. ATTENTION: ASEv3 needs a /24 network.

- Required: No
- Type: string
- Default: `'10.240.0.0/26'`

### Parameter: `subnetSpokeDevOpsAddressSpace`

CIDR of the subnet that will hold devOps agents etc.

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

### Parameter: `vmSize`

The size of the jump box virtual machine to create. See https://learn.microsoft.com/azure/virtual-machines/sizes for more information.

- Required: No
- Type: string
- Default: `'Standard_D2s_v4'`

### Parameter: `vnetHubResourceId`

Default is empty. If given, peering between spoke and and existing hub vnet will be created.

- Required: No
- Type: string
- Default: `''`

### Parameter: `vnetSpokeAddressSpace`

CIDR of the SPOKE vnet i.e. 192.168.0.0/24.

- Required: No
- Type: string
- Default: `'10.240.0.0/20'`

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

### Parameter: `webAppPlanSku`

Defines the name, tier, size, family and capacity of the App Service Plan. EP* is only for functions.

- Required: No
- Type: string
- Default: `'P1V3'`
- Allowed:
  ```Bicep
  [
    'ASE_I1V2'
    'ASE_I2V2'
    'ASE_I3V2'
    'EP1'
    'EP2'
    'EP3'
    'P1V3'
    'P2V3'
    'P3V3'
    'S1'
    'S2'
    'S3'
  ]
  ```

### Parameter: `workloadName`

suffix (max 10 characters long) that will be used to name the resources in a pattern like <resourceAbbreviation>-<workloadName>.

- Required: No
- Type: string
- Default: `[format('appsvc{0}', take(uniqueString(subscription().id), 4))]`

### Parameter: `zoneRedundant`

Set to true if you want to deploy the App Service Plan in a zone redundant manner. Defult is true.

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
| `spokeVNetResourceId` | string | The  resource ID of the Spoke Virtual Network. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/cdn/profile:0.11.0` | Remote reference |
| `br/public:avm/res/compute/virtual-machine:0.5.1` | Remote reference |
| `br/public:avm/res/insights/component:0.4.1` | Remote reference |
| `br/public:avm/res/key-vault/vault:0.6.1` | Remote reference |
| `br/public:avm/res/managed-identity/user-assigned-identity:0.4.0` | Remote reference |
| `br/public:avm/res/network/front-door-web-application-firewall-policy:0.3.0` | Remote reference |
| `br/public:avm/res/network/network-security-group:0.2.0` | Remote reference |
| `br/public:avm/res/network/network-security-group:0.5.0` | Remote reference |
| `br/public:avm/res/network/private-dns-zone:0.3.0` | Remote reference |
| `br/public:avm/res/network/private-dns-zone:0.6.0` | Remote reference |
| `br/public:avm/res/network/private-endpoint:0.9.0` | Remote reference |
| `br/public:avm/res/network/route-table:0.4.0` | Remote reference |
| `br/public:avm/res/network/virtual-network:0.5.1` | Remote reference |
| `br/public:avm/res/operational-insights/workspace:0.7.1` | Remote reference |
| `br/public:avm/res/resources/resource-group:0.4.0` | Remote reference |
| `br/public:avm/res/web/hosting-environment:0.1.1` | Remote reference |
| `br/public:avm/res/web/serverfarm:0.2.4` | Remote reference |
| `br/public:avm/res/web/site:0.9.0` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
