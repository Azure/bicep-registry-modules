# Container Apps Landing Zone Accelerator `[Microsoft.acalza/hostingenvironment]`

This Azure Container Apps pattern module represents an Azure Container Apps deployment aligned with the cloud adoption framework

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
| `Microsoft.App/containerApps` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2023-05-01/containerApps) |
| `Microsoft.App/managedEnvironments` | [2023-11-02-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2023-11-02-preview/managedEnvironments) |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/policyAssignments` | [2022-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-06-01/policyAssignments) |
| `Microsoft.Authorization/policyDefinitions` | [2021-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2021-06-01/policyDefinitions) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Automanage/configurationProfileAssignments` | [2022-05-04](https://learn.microsoft.com/en-us/azure/templates) |
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
| `Microsoft.Compute/virtualMachines` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2023-09-01/virtualMachines) |
| `Microsoft.Compute/virtualMachines/extensions` | [2022-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2022-11-01/virtualMachines/extensions) |
| `Microsoft.ContainerRegistry/registries` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries) |
| `Microsoft.ContainerRegistry/registries/cacheRules` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/cacheRules) |
| `Microsoft.ContainerRegistry/registries/replications` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/replications) |
| `Microsoft.ContainerRegistry/registries/webhooks` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/webhooks) |
| `Microsoft.DevTestLab/schedules` | [2018-09-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevTestLab/2018-09-15/schedules) |
| `Microsoft.GuestConfiguration/guestConfigurationAssignments` | [2020-06-25](https://learn.microsoft.com/en-us/azure/templates/Microsoft.GuestConfiguration/2020-06-25/guestConfigurationAssignments) |
| `Microsoft.Insights/components` | [2020-02-02](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2020-02-02/components) |
| `microsoft.insights/components/linkedStorageAccounts` | [2020-03-01-preview](https://learn.microsoft.com/en-us/azure/templates/microsoft.insights/2020-03-01-preview/components/linkedStorageAccounts) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.KeyVault/vaults` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults) |
| `Microsoft.KeyVault/vaults/accessPolicies` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/accessPolicies) |
| `Microsoft.KeyVault/vaults/keys` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/keys) |
| `Microsoft.KeyVault/vaults/secrets` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/secrets) |
| `Microsoft.KeyVault/vaults/secrets` | [2023-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2023-07-01/vaults/secrets) |
| `Microsoft.ManagedIdentity/userAssignedIdentities` | [2023-01-31](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2023-01-31/userAssignedIdentities) |
| `Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials` | [2023-01-31](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2023-01-31/userAssignedIdentities/federatedIdentityCredentials) |
| `Microsoft.Network/applicationGateways` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/applicationGateways) |
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
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.Network/privateLinkServices` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateLinkServices) |
| `Microsoft.Network/publicIPAddresses` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-09-01/publicIPAddresses) |
| `Microsoft.Network/routeTables` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/routeTables) |
| `Microsoft.Network/virtualNetworks` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/virtualNetworks) |
| `Microsoft.Network/virtualNetworks/subnets` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/virtualNetworks/subnets) |
| `Microsoft.Network/virtualNetworks/subnets` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/virtualNetworks/subnets) |
| `Microsoft.Network/virtualNetworks/virtualNetworkPeerings` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/virtualNetworks/virtualNetworkPeerings) |
| `Microsoft.Network/virtualNetworks/virtualNetworkPeerings` | [2021-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-08-01/virtualNetworks/virtualNetworkPeerings) |
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
| `Microsoft.Resources/resourceGroups` | [2021-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2021-04-01/resourceGroups) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/aca-lza/hosting-environment:<version>`.

- [Defaults](#example-1-defaults)
- [Waf-Aligned](#example-2-waf-aligned)

### Example 1: _Defaults_

<details>

<summary>via Bicep module</summary>

```bicep
module hostingEnvironment 'br/public:avm/ptn/aca-lza/hosting-environment:<version>' = {
  name: 'hostingEnvironmentDeployment'
  params: {
    // Required parameters
    location: '<location>'
    name: 'alhedef001'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "location": {
      "value": "<location>"
    },
    "name": {
      "value": "alhedef001"
    }
  }
}
```

</details>
<p>

### Example 2: _Waf-Aligned_

<details>

<summary>via Bicep module</summary>

```bicep
module hostingEnvironment 'br/public:avm/ptn/aca-lza/hosting-environment:<version>' = {
  name: 'hostingEnvironmentDeployment'
  params: {
    // Required parameters
    location: '<location>'
    name: 'alhewaf001'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "location": {
      "value": "<location>"
    },
    "name": {
      "value": "alhewaf001"
    }
  }
}
```

</details>
<p>


## Parameters

**OptionalThe id of the subscription to create the Azure Container Apps deployment The name of the workload that is being deployed Tags related to the Azure Container Apps deployment The name of the environment (e The size of the virtual machine to create The username to use for the virtual machine The password to use for the virtual machine The SSH public key to use for the virtual machine Type of authentication to use on the Virtual Machine CIDR to use for the virtual machine subnet CIDR of the Spoke Virtual Network CIDR of the Spoke Infrastructure Subnet CIDR of the Spoke Private Endpoints Subnet CIDR of the Spoke Application Gateway Subnet Enable or disable the createion of Application Insights Enable or disable Dapr Application Instrumentation Key used for Dapr telemetry The FQDN of the Application Gateway The base64 encoded certificate to use for Application Gateway certificate The name of the certificate key to use for Application Gateway certificate Optional, default value is true Specify the way container apps is going to be exposed parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `applicationGatewayFqdn` | string | The FQDN of the Azure Application Gateway. |
| `applicationGatewayId` | string | The FQDN of the Azure Application Gateway. |
| `applicationGatewayPublicIp` | string | The public IP address of the Azure Application Gateway. |
| `applicationInsightsName` | string |  The name of application Insights instance. |
| `containerAppsEnvironmentId` | string | The resource ID of the container apps environment. |
| `containerAppsEnvironmentName` | string | The name of the container apps environment. |
| `containerRegistryId` | string | The resource ID of the container registry. |
| `containerRegistryLoginServer` | string | The name of the container registry login server. |
| `containerRegistryName` | string | The name of the container registry. |
| `containerRegistryUserAssignedIdentityId` | string | The resource ID of the user assigned managed identity for the container registry to be able to pull images from it. |
| `keyVaultId` | string | The resource ID of the key vault. |
| `keyVaultName` | string | The name of the key vault. |
| `logAnalyticsWorkspaceId` | string | The resource ID of the Log Analytics workspace created in the spoke vnet. |
| `spokeApplicationGatewaySubnetId` | string | The resource ID of the Spoke Application Gateway Subnet. If "spokeApplicationGatewaySubnetAddressPrefix" is empty, the subnet will not be created and the value returned is empty. |
| `spokeApplicationGatewaySubnetName` | string | The name of the Spoke Application Gateway Subnet.  If "spokeApplicationGatewaySubnetAddressPrefix" is empty, the subnet will not be created and the value returned is empty. |
| `spokeInfraSubnetId` | string | The resource ID of the Spoke Infrastructure Subnet. |
| `spokeInfraSubnetName` | string | The name of the Spoke Infrastructure Subnet. |
| `spokePrivateEndpointsSubnetName` | string | The name of the Spoke Private Endpoints Subnet. |
| `spokeResourceGroupName` | string | The name of the Spoke resource group. |
| `spokeVNetId` | string | The  resource ID of the Spoke Virtual Network. |
| `spokeVnetName` | string | The name of the Spoke Virtual Network. |
| `vmJumpBoxName` | string | The name of the jump box virtual machine |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/ptn/authorization/policy-assignment:0.1.0` | Remote reference |
| `br/public:avm/res/app/container-app:0.4.0` | Remote reference |
| `br/public:avm/res/app/managed-environment:0.5.1` | Remote reference |
| `br/public:avm/res/cdn/profile:0.3.0` | Remote reference |
| `br/public:avm/res/compute/virtual-machine:0.5.0` | Remote reference |
| `br/public:avm/res/container-registry/registry:0.3.0` | Remote reference |
| `br/public:avm/res/insights/component:0.3.0` | Remote reference |
| `br/public:avm/res/key-vault/vault:0.6.1` | Remote reference |
| `br/public:avm/res/managed-identity/user-assigned-identity:0.2.1` | Remote reference |
| `br/public:avm/res/network/application-gateway:0.1.0` | Remote reference |
| `br/public:avm/res/network/network-security-group:0.2.0` | Remote reference |
| `br/public:avm/res/network/private-dns-zone:0.3.0` | Remote reference |
| `br/public:avm/res/network/public-ip-address:0.4.1` | Remote reference |
| `br/public:avm/res/network/route-table:0.2.2` | Remote reference |
| `br/public:avm/res/network/virtual-network:0.1.6` | Remote reference |
| `br/public:avm/res/operational-insights/workspace:0.3.4` | Remote reference |
| `br/public:avm/res/resources/resource-group:0.2.3` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
