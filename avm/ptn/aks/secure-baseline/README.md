# AKS Secure Baseline `[Aks/SecureBaseline]`

Deploys the complete AKS1P compliant IPv4 cluster foundation with separate prerequisite and cluster resource groups.

You can reference the module as follows:
```bicep
module secureBaseline 'br/public:avm/ptn/aks/secure-baseline:<version>' = {
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
| `Microsoft.ContainerRegistry/registries` | 2025-06-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerregistry_registries.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2025-06-01-preview/registries)</li></ul> |
| `Microsoft.ContainerRegistry/registries/cacheRules` | 2025-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerregistry_registries_cacherules.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2025-11-01/registries/cacheRules)</li></ul> |
| `Microsoft.ContainerRegistry/registries/credentialSets` | 2025-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerregistry_registries_credentialsets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2025-11-01/registries/credentialSets)</li></ul> |
| `Microsoft.ContainerRegistry/registries/replications` | 2025-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerregistry_registries_replications.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2025-11-01/registries/replications)</li></ul> |
| `Microsoft.ContainerRegistry/registries/scopeMaps` | 2025-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerregistry_registries_scopemaps.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2025-11-01/registries/scopeMaps)</li></ul> |
| `Microsoft.ContainerRegistry/registries/tasks` | 2025-03-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerregistry_registries_tasks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2025-03-01-preview/registries/tasks)</li></ul> |
| `Microsoft.ContainerRegistry/registries/tokens` | 2025-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerregistry_registries_tokens.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2025-11-01/registries/tokens)</li></ul> |
| `Microsoft.ContainerRegistry/registries/webhooks` | 2025-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerregistry_registries_webhooks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2025-11-01/registries/webhooks)</li></ul> |
| `Microsoft.ContainerService/managedClusters` | 2025-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerservice_managedclusters.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerService/2025-10-01/managedClusters)</li></ul> |
| `Microsoft.ContainerService/managedClusters/agentPools` | 2025-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerservice_managedclusters_agentpools.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerService/2025-10-01/managedClusters/agentPools)</li></ul> |
| `Microsoft.ContainerService/managedClusters/maintenanceConfigurations` | 2025-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerservice_managedclusters_maintenanceconfigurations.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerService/2025-10-01/managedClusters/maintenanceConfigurations)</li></ul> |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_diagnosticsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)</li></ul> |
| `Microsoft.KeyVault/vaults` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2024-11-01/vaults)</li></ul> |
| `Microsoft.KeyVault/vaults/accessPolicies` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults_accesspolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2024-11-01/vaults/accessPolicies)</li></ul> |
| `Microsoft.KeyVault/vaults/keys` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults_keys.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2024-11-01/vaults/keys)</li></ul> |
| `Microsoft.KeyVault/vaults/secrets` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults_secrets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2024-11-01/vaults/secrets)</li></ul> |
| `Microsoft.KubernetesConfiguration/extensions` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.kubernetesconfiguration_extensions.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KubernetesConfiguration/2024-11-01/extensions)</li></ul> |
| `Microsoft.KubernetesConfiguration/fluxConfigurations` | 2025-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.kubernetesconfiguration_fluxconfigurations.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KubernetesConfiguration/2025-04-01/fluxConfigurations)</li></ul> |
| `Microsoft.ManagedIdentity/userAssignedIdentities` | 2024-11-30 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.managedidentity_userassignedidentities.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2024-11-30/userAssignedIdentities)</li></ul> |
| `Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials` | 2024-11-30 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.managedidentity_userassignedidentities_federatedidentitycredentials.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2024-11-30/userAssignedIdentities/federatedIdentityCredentials)</li></ul> |
| `Microsoft.Network/bastionHosts` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_bastionhosts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-01-01/bastionHosts)</li></ul> |
| `Microsoft.Network/natGateways` | 2025-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_natgateways.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-05-01/natGateways)</li></ul> |
| `Microsoft.Network/networkSecurityGroups` | 2025-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_networksecuritygroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-05-01/networkSecurityGroups)</li></ul> |
| `Microsoft.Network/networkSecurityPerimeters` | 2024-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_networksecurityperimeters.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-07-01/networkSecurityPerimeters)</li></ul> |
| `Microsoft.Network/networkSecurityPerimeters/profiles` | 2024-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_networksecurityperimeters_profiles.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-07-01/networkSecurityPerimeters/profiles)</li></ul> |
| `Microsoft.Network/networkSecurityPerimeters/profiles/accessRules` | 2024-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_networksecurityperimeters_profiles_accessrules.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-07-01/networkSecurityPerimeters/profiles/accessRules)</li></ul> |
| `Microsoft.Network/networkSecurityPerimeters/resourceAssociations` | 2024-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_networksecurityperimeters_resourceassociations.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-07-01/networkSecurityPerimeters/resourceAssociations)</li></ul> |
| `Microsoft.Network/privateEndpoints` | 2025-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-05-01/privateEndpoints)</li></ul> |
| `Microsoft.Network/privateEndpoints` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/privateEndpoints)</li></ul> |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2025-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints_privatednszonegroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-05-01/privateEndpoints/privateDnsZoneGroups)</li></ul> |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints_privatednszonegroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/privateEndpoints/privateDnsZoneGroups)</li></ul> |
| `Microsoft.Network/publicIPAddresses` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_publicipaddresses.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-01-01/publicIPAddresses)</li></ul> |
| `Microsoft.Network/publicIPPrefixes` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_publicipprefixes.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-01-01/publicIPPrefixes)</li></ul> |
| `Microsoft.Network/virtualNetworks` | 2025-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_virtualnetworks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-05-01/virtualNetworks)</li></ul> |
| `Microsoft.Network/virtualNetworks/subnets` | 2025-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_virtualnetworks_subnets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-05-01/virtualNetworks/subnets)</li></ul> |
| `Microsoft.Network/virtualNetworks/virtualNetworkPeerings` | 2025-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_virtualnetworks_virtualnetworkpeerings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-05-01/virtualNetworks/virtualNetworkPeerings)</li></ul> |
| `Microsoft.Resources/deploymentScripts` | 2023-08-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.resources_deploymentscripts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2023-08-01/deploymentScripts)</li></ul> |
| `Microsoft.Resources/resourceGroups` | 2025-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.resources_resourcegroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2025-04-01/resourceGroups)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/aks/secure-baseline:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [WAF-aligned](#example-2-waf-aligned)

### Example 1: _Using only defaults_

Deploys the IPv4 AKS secure baseline in Auto node provisioning mode with its default networking and security configuration.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/defaults]


<details>

<summary>via Bicep module</summary>

```bicep
module secureBaseline 'br/public:avm/ptn/aks/secure-baseline:<version>' = {
  params: {
    // Required parameters
    clusterLocation: '<clusterLocation>'
    clusterName: 'aks-aksmin'
    serviceName: 'aksmin'
    // Non-required parameters
    clusterResourceGroupName: 'dep-aks-secure-baseline-aksmin-rg'
    globalResourceGroupName: 'dep-aksmin-global-rg'
    subscriptionResourceGroupName: 'dep-aksmin-sub-rg'
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
    "clusterLocation": {
      "value": "<clusterLocation>"
    },
    "clusterName": {
      "value": "aks-aksmin"
    },
    "serviceName": {
      "value": "aksmin"
    },
    // Non-required parameters
    "clusterResourceGroupName": {
      "value": "dep-aks-secure-baseline-aksmin-rg"
    },
    "globalResourceGroupName": {
      "value": "dep-aksmin-global-rg"
    },
    "subscriptionResourceGroupName": {
      "value": "dep-aksmin-sub-rg"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/aks/secure-baseline:<version>'

// Required parameters
param clusterLocation = '<clusterLocation>'
param clusterName = 'aks-aksmin'
param serviceName = 'aksmin'
// Non-required parameters
param clusterResourceGroupName = 'dep-aks-secure-baseline-aksmin-rg'
param globalResourceGroupName = 'dep-aksmin-global-rg'
param subscriptionResourceGroupName = 'dep-aksmin-sub-rg'
```

</details>
<p>

### Example 2: _WAF-aligned_

Deploys the IPv4 AKS cluster with manual user node pools and the hardened baseline capabilities enabled.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/waf-aligned]


<details>

<summary>via Bicep module</summary>

```bicep
module secureBaseline 'br/public:avm/ptn/aks/secure-baseline:<version>' = {
  params: {
    // Required parameters
    clusterLocation: '<clusterLocation>'
    clusterName: 'aks-akswaf'
    serviceName: 'akswaf'
    // Non-required parameters
    clusterResourceGroupName: 'dep-aks-secure-baseline-akswaf-rg'
    globalResourceGroupName: 'dep-akswaf-global-rg'
    nodeProvisioningMode: 'Manual'
    subscriptionResourceGroupName: 'dep-akswaf-sub-rg'
    tags: {
      environment: 'test'
      scenario: 'waf-aligned'
    }
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
    "clusterLocation": {
      "value": "<clusterLocation>"
    },
    "clusterName": {
      "value": "aks-akswaf"
    },
    "serviceName": {
      "value": "akswaf"
    },
    // Non-required parameters
    "clusterResourceGroupName": {
      "value": "dep-aks-secure-baseline-akswaf-rg"
    },
    "globalResourceGroupName": {
      "value": "dep-akswaf-global-rg"
    },
    "nodeProvisioningMode": {
      "value": "Manual"
    },
    "subscriptionResourceGroupName": {
      "value": "dep-akswaf-sub-rg"
    },
    "tags": {
      "value": {
        "environment": "test",
        "scenario": "waf-aligned"
      }
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/aks/secure-baseline:<version>'

// Required parameters
param clusterLocation = '<clusterLocation>'
param clusterName = 'aks-akswaf'
param serviceName = 'akswaf'
// Non-required parameters
param clusterResourceGroupName = 'dep-aks-secure-baseline-akswaf-rg'
param globalResourceGroupName = 'dep-akswaf-global-rg'
param nodeProvisioningMode = 'Manual'
param subscriptionResourceGroupName = 'dep-akswaf-sub-rg'
param tags = {
  environment: 'test'
  scenario: 'waf-aligned'
}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clusterLocation`](#parameter-clusterlocation) | string | The Azure region for the AKS cluster and all cluster-specific networking, identity, and Bastion resources. |
| [`clusterName`](#parameter-clustername) | string | The name of the AKS managed cluster. This value is also used as the base for dependent resource names. |
| [`serviceName`](#parameter-servicename) | string | The service or team name used to derive shared global and subscription resource names. Use the same value for clusters that share prerequisites. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`availabilityZones`](#parameter-availabilityzones) | array | The availability zones used by the AKS system node pool and public IP prefixes. |
| [`bastionSubnetAddressPrefix`](#parameter-bastionsubnetaddressprefix) | string | The IPv4 address prefix assigned to AzureBastionSubnet. |
| [`clusterResourceGroupName`](#parameter-clusterresourcegroupname) | string | The resource group for the AKS cluster and its cluster-specific identities, networking, and Bastion resources. |
| [`containerRegistryName`](#parameter-containerregistryname) | string | The name of the shared Azure Container Registry. |
| [`deployBastion`](#parameter-deploybastion) | bool | Deploy an Azure Bastion host and the required AzureBastionSubnet. |
| [`deployContainerRegistry`](#parameter-deploycontainerregistry) | bool | Deploy the shared Azure Container Registry used by the AKS1P EV2 topology. It is not consumed directly by the IPv4 cluster. |
| [`deployKeyVaultNetworkSecurityPerimeter`](#parameter-deploykeyvaultnetworksecurityperimeter) | bool | Deploy a Network Security Perimeter and associate the new or existing Key Vault. |
| [`deployResourceDeletionIdentity`](#parameter-deployresourcedeletionidentity) | bool | Deploy the resource-deletion identity and grant it Contributor at subscription scope. This is only needed by an external resource-deletion workflow. |
| [`enableKeyVaultPurgeProtection`](#parameter-enablekeyvaultpurgeprotection) | bool | Enable purge protection on a newly created Key Vault. Keep disabled for disposable test deployments; enable for production. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`globalLocation`](#parameter-globallocation) | string | The Azure region for shared global resources such as the shell identity and optional container registry. |
| [`globalResourceGroupName`](#parameter-globalresourcegroupname) | string | The resource group for global resources such as the shell identity and optional container registry. |
| [`imageCleanerIntervalHours`](#parameter-imagecleanerintervalhours) | int | The Image Cleaner scan interval in hours. |
| [`istioRev`](#parameter-istiorev) | string | The AKS Istio revision to enable. |
| [`keyVaultName`](#parameter-keyvaultname) | string | The name of a Key Vault to create in the prerequisite resource group. Ignored when keyVaultResourceId is supplied. |
| [`keyVaultNetworkSecurityPerimeterAccessMode`](#parameter-keyvaultnetworksecurityperimeteraccessmode) | string | The Key Vault Network Security Perimeter association access mode. |
| [`keyVaultNetworkSecurityPerimeterName`](#parameter-keyvaultnetworksecurityperimetername) | string | The name of the shared Network Security Perimeter. |
| [`keyVaultResourceId`](#parameter-keyvaultresourceid) | string | The resource ID of an existing Key Vault to adopt without managing its configuration. Leave empty to create keyVaultName in the prerequisite resource group. |
| [`localDNSMode`](#parameter-localdnsmode) | string | The LocalDNS mode applied to every AKS node pool. |
| [`maintenanceWindowStartTime`](#parameter-maintenancewindowstarttime) | string | The maintenance window start time in HH:mm format. |
| [`maintenanceWindowUTCOffset`](#parameter-maintenancewindowutcoffset) | string | The maintenance window UTC offset in +HH:mm or -HH:mm format. |
| [`minSystemNodeCount`](#parameter-minsystemnodecount) | int | The minimum node count for the AKS system node pool. |
| [`minUserNodeCount`](#parameter-minusernodecount) | int | The minimum node count for each user node pool when nodeProvisioningMode is Manual. |
| [`networkSku`](#parameter-networksku) | string | The SKU used by the NAT gateway and public IP prefixes. |
| [`nodePoolVmSku`](#parameter-nodepoolvmsku) | string | The VM SKU used by user node pools when nodeProvisioningMode is Manual. |
| [`nodePoolZones`](#parameter-nodepoolzones) | array | The availability zones used by user node pools when nodeProvisioningMode is Manual. |
| [`nodeProvisioningMode`](#parameter-nodeprovisioningmode) | string | Controls workload node provisioning. Auto enables Node Auto Provisioning. Manual creates user node pools managed by Cluster Autoscaler. |
| [`numberOfUserPools`](#parameter-numberofuserpools) | int | The number of user node pools to create when nodeProvisioningMode is Manual. |
| [`resourceDeletionIdentityName`](#parameter-resourcedeletionidentityname) | string | The name of the resource-deletion managed identity. |
| [`resourceDeletionIdentityResourceGroupName`](#parameter-resourcedeletionidentityresourcegroupname) | string | The resource group for the optional resource-deletion managed identity. |
| [`serviceTag`](#parameter-servicetag) | string | A FirstPartyUsage service tag applied to the public IP prefixes. Leave empty when no service tag has been assigned. |
| [`sshKeyGenerationIdentityName`](#parameter-sshkeygenerationidentityname) | string | The name of the shared user-assigned identity used to create or retrieve the SSH key pair. |
| [`sshPrivateKeySecretName`](#parameter-sshprivatekeysecretname) | string | The name of the Key Vault secret that stores the SSH private key. |
| [`sshPublicKey`](#parameter-sshpublickey) | securestring | An SSH public key for Linux node access. When omitted, the pattern creates or reuses a key pair in Key Vault. |
| [`sshPublicKeySecretName`](#parameter-sshpublickeysecretname) | string | The name of the Key Vault secret that stores the SSH public key. |
| [`subnetAddressPrefixipV4`](#parameter-subnetaddressprefixipv4) | string | The IPv4 address prefix assigned to the AKS node subnet. |
| [`subscriptionLocation`](#parameter-subscriptionlocation) | string | The Azure region for subscription prerequisites such as Key Vault, Network Security Perimeter, and SSH key generation. |
| [`subscriptionResourceGroupName`](#parameter-subscriptionresourcegroupname) | string | The resource group for subscription resources such as Key Vault, Network Security Perimeter, and SSH key generation. |
| [`systemPoolVmSku`](#parameter-systempoolvmsku) | string | The VM SKU used by the AKS system node pool. |
| [`tags`](#parameter-tags) | object | Tags supplied by the module consumer and applied to resources that support tags. The module does not add tags of its own. |
| [`tenantID`](#parameter-tenantid) | string | The tenant ID used by AKS Microsoft Entra integration. |
| [`useSuppliedSshPublicKey`](#parameter-usesuppliedsshpublickey) | bool | Use sshPublicKey instead of creating or reusing the shared Key Vault SSH key pair. |
| [`vnetAddressPrefix`](#parameter-vnetaddressprefix) | array | The address prefixes assigned to the virtual network. |

### Parameter: `clusterLocation`

The Azure region for the AKS cluster and all cluster-specific networking, identity, and Bastion resources.

- Required: Yes
- Type: string

### Parameter: `clusterName`

The name of the AKS managed cluster. This value is also used as the base for dependent resource names.

- Required: Yes
- Type: string

### Parameter: `serviceName`

The service or team name used to derive shared global and subscription resource names. Use the same value for clusters that share prerequisites.

- Required: Yes
- Type: string

### Parameter: `availabilityZones`

The availability zones used by the AKS system node pool and public IP prefixes.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    1
    2
  ]
  ```
- Allowed:
  ```Bicep
  [
    1
    2
    3
  ]
  ```

### Parameter: `bastionSubnetAddressPrefix`

The IPv4 address prefix assigned to AzureBastionSubnet.

- Required: No
- Type: string
- Default: `'10.250.0.0/26'`

### Parameter: `clusterResourceGroupName`

The resource group for the AKS cluster and its cluster-specific identities, networking, and Bastion resources.

- Required: No
- Type: string
- Default: `[format('rg-{0}', parameters('clusterName'))]`

### Parameter: `containerRegistryName`

The name of the shared Azure Container Registry.

- Required: No
- Type: string
- Default: `[format('acr{0}{1}', take(toLower(replace(parameters('serviceName'), '-', '')), 20), take(uniqueString(subscription().id, parameters('serviceName')), 6))]`

### Parameter: `deployBastion`

Deploy an Azure Bastion host and the required AzureBastionSubnet.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `deployContainerRegistry`

Deploy the shared Azure Container Registry used by the AKS1P EV2 topology. It is not consumed directly by the IPv4 cluster.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `deployKeyVaultNetworkSecurityPerimeter`

Deploy a Network Security Perimeter and associate the new or existing Key Vault.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `deployResourceDeletionIdentity`

Deploy the resource-deletion identity and grant it Contributor at subscription scope. This is only needed by an external resource-deletion workflow.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableKeyVaultPurgeProtection`

Enable purge protection on a newly created Key Vault. Keep disabled for disposable test deployments; enable for production.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `globalLocation`

The Azure region for shared global resources such as the shell identity and optional container registry.

- Required: No
- Type: string
- Default: `'eastus2'`

### Parameter: `globalResourceGroupName`

The resource group for global resources such as the shell identity and optional container registry.

- Required: No
- Type: string
- Default: `[format('rg-secure-baseline-{0}-global', parameters('serviceName'))]`

### Parameter: `imageCleanerIntervalHours`

The Image Cleaner scan interval in hours.

- Required: No
- Type: int
- Default: `168`
- MinValue: 24

### Parameter: `istioRev`

The AKS Istio revision to enable.

- Required: No
- Type: string
- Default: `'asm-1-28'`

### Parameter: `keyVaultName`

The name of a Key Vault to create in the prerequisite resource group. Ignored when keyVaultResourceId is supplied.

- Required: No
- Type: string
- Default: `[format('kv-{0}-{1}', take(toLower(replace(parameters('serviceName'), '-', '')), 10), take(uniqueString(subscription().id, parameters('serviceName')), 6))]`

### Parameter: `keyVaultNetworkSecurityPerimeterAccessMode`

The Key Vault Network Security Perimeter association access mode.

- Required: No
- Type: string
- Default: `'Learning'`
- Allowed:
  ```Bicep
  [
    'Audit'
    'Enforced'
    'Learning'
  ]
  ```

### Parameter: `keyVaultNetworkSecurityPerimeterName`

The name of the shared Network Security Perimeter.

- Required: No
- Type: string
- Default: `[format('nsp-{0}', parameters('serviceName'))]`

### Parameter: `keyVaultResourceId`

The resource ID of an existing Key Vault to adopt without managing its configuration. Leave empty to create keyVaultName in the prerequisite resource group.

- Required: No
- Type: string
- Default: `''`

### Parameter: `localDNSMode`

The LocalDNS mode applied to every AKS node pool.

- Required: No
- Type: string
- Default: `'Preferred'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Preferred'
    'Required'
  ]
  ```

### Parameter: `maintenanceWindowStartTime`

The maintenance window start time in HH:mm format.

- Required: No
- Type: string
- Default: `'01:00'`

### Parameter: `maintenanceWindowUTCOffset`

The maintenance window UTC offset in +HH:mm or -HH:mm format.

- Required: No
- Type: string
- Default: `'-07:00'`

### Parameter: `minSystemNodeCount`

The minimum node count for the AKS system node pool.

- Required: No
- Type: int
- Default: `3`
- MinValue: 3
- MaxValue: 100

### Parameter: `minUserNodeCount`

The minimum node count for each user node pool when nodeProvisioningMode is Manual.

- Required: No
- Type: int
- Default: `3`
- MinValue: 1
- MaxValue: 100

### Parameter: `networkSku`

The SKU used by the NAT gateway and public IP prefixes.

- Required: No
- Type: string
- Default: `'Standard'`
- Allowed:
  ```Bicep
  [
    'Standard'
    'StandardV2'
  ]
  ```

### Parameter: `nodePoolVmSku`

The VM SKU used by user node pools when nodeProvisioningMode is Manual.

- Required: No
- Type: string
- Default: `'Standard_D8ds_v5'`

### Parameter: `nodePoolZones`

The availability zones used by user node pools when nodeProvisioningMode is Manual.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    1
    2
  ]
  ```
- Allowed:
  ```Bicep
  [
    1
    2
    3
  ]
  ```

### Parameter: `nodeProvisioningMode`

Controls workload node provisioning. Auto enables Node Auto Provisioning. Manual creates user node pools managed by Cluster Autoscaler.

- Required: No
- Type: string
- Default: `'Auto'`
- Allowed:
  ```Bicep
  [
    'Auto'
    'Manual'
  ]
  ```

### Parameter: `numberOfUserPools`

The number of user node pools to create when nodeProvisioningMode is Manual.

- Required: No
- Type: int
- Default: `1`
- MinValue: 1
- MaxValue: 10

### Parameter: `resourceDeletionIdentityName`

The name of the resource-deletion managed identity.

- Required: No
- Type: string
- Default: `[format('id-{0}-resource-del-shell', parameters('serviceName'))]`

### Parameter: `resourceDeletionIdentityResourceGroupName`

The resource group for the optional resource-deletion managed identity.

- Required: No
- Type: string
- Default: `[format('rg-secure-baseline-{0}-delete-identity', parameters('serviceName'))]`

### Parameter: `serviceTag`

A FirstPartyUsage service tag applied to the public IP prefixes. Leave empty when no service tag has been assigned.

- Required: No
- Type: string
- Default: `''`

### Parameter: `sshKeyGenerationIdentityName`

The name of the shared user-assigned identity used to create or retrieve the SSH key pair.

- Required: No
- Type: string
- Default: `[format('id-{0}-shell', parameters('serviceName'))]`

### Parameter: `sshPrivateKeySecretName`

The name of the Key Vault secret that stores the SSH private key.

- Required: No
- Type: string
- Default: `'sshkey-private'`

### Parameter: `sshPublicKey`

An SSH public key for Linux node access. When omitted, the pattern creates or reuses a key pair in Key Vault.

- Required: No
- Type: securestring

### Parameter: `sshPublicKeySecretName`

The name of the Key Vault secret that stores the SSH public key.

- Required: No
- Type: string
- Default: `'sshkey-public'`

### Parameter: `subnetAddressPrefixipV4`

The IPv4 address prefix assigned to the AKS node subnet.

- Required: No
- Type: string
- Default: `'10.200.0.0/16'`

### Parameter: `subscriptionLocation`

The Azure region for subscription prerequisites such as Key Vault, Network Security Perimeter, and SSH key generation.

- Required: No
- Type: string
- Default: `[parameters('globalLocation')]`

### Parameter: `subscriptionResourceGroupName`

The resource group for subscription resources such as Key Vault, Network Security Perimeter, and SSH key generation.

- Required: No
- Type: string
- Default: `[format('rg-secure-baseline-{0}-sub', parameters('serviceName'))]`

### Parameter: `systemPoolVmSku`

The VM SKU used by the AKS system node pool.

- Required: No
- Type: string
- Default: `'Standard_D8ds_v5'`

### Parameter: `tags`

Tags supplied by the module consumer and applied to resources that support tags. The module does not add tags of its own.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `tenantID`

The tenant ID used by AKS Microsoft Entra integration.

- Required: No
- Type: string
- Default: `[tenant().tenantId]`

### Parameter: `useSuppliedSshPublicKey`

Use sshPublicKey instead of creating or reusing the shared Key Vault SSH key pair.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `vnetAddressPrefix`

The address prefixes assigned to the virtual network.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    '10.0.0.0/8'
  ]
  ```

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `aksClusterName` | string | The name of the deployed AKS cluster. |
| `aksClusterResourceId` | string | The resource ID of the deployed AKS cluster. |
| `aksControlPlaneFqdn` | string | The control plane FQDN of the deployed AKS cluster. |
| `aksOidcIssuerUrl` | string | The OIDC issuer URL of the deployed AKS cluster. |
| `aksSubnetResourceId` | string | The resource ID of the AKS node subnet. |
| `bastionHostResourceId` | string | The resource ID of the Azure Bastion host, when deployed. |
| `clusterIdentityResourceId` | string | The resource ID of the AKS cluster user-assigned managed identity. |
| `clusterResourceGroupName` | string | The resource group containing the AKS cluster and cluster-specific resources. |
| `containerRegistryResourceId` | string | The resource ID of the shared container registry, when deployed. |
| `globalResourceGroupName` | string | The resource group containing global resources. |
| `ingressPublicIpPrefixResourceId` | string | The resource ID of the public IP prefix reserved for ingress. |
| `keyVaultNetworkSecurityPerimeterResourceId` | string | The resource ID of the Network Security Perimeter, when deployed. |
| `keyVaultResourceId` | string | The resource ID of the new or adopted Key Vault. |
| `natGatewayResourceId` | string | The resource ID of the outbound NAT gateway. |
| `resourceDeletionIdentityResourceGroupName` | string | The resource group containing the resource-deletion identity, when deployed. |
| `resourceDeletionIdentityResourceId` | string | The resource ID of the resource-deletion identity, when deployed. |
| `shellIdentityResourceId` | string | The resource ID of the shared shell identity. |
| `sshPrivateKeySecretName` | string | The name of the Key Vault secret containing the SSH private key. |
| `sshPublicKeySecretName` | string | The name of the Key Vault secret containing the SSH public key. |
| `subscriptionResourceGroupName` | string | The resource group containing subscription prerequisites. |
| `virtualNetworkResourceId` | string | The resource ID of the virtual network. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/authorization/role-assignment/rg-scope:0.1.1` | Remote reference |
| `br/public:avm/res/container-service/managed-cluster:0.14.0` | Remote reference |
| `br/public:avm/res/managed-identity/user-assigned-identity:0.6.0` | Remote reference |
| `br/public:avm/res/network/nat-gateway:2.1.1` | Remote reference |
| `br/public:avm/res/network/network-security-group:0.5.3` | Remote reference |
| `br/public:avm/res/network/public-ip-prefix:0.8.0` | Remote reference |
| `br/public:avm/res/network/virtual-network:0.10.2` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
