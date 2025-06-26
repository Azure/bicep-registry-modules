# Modernize Your Code Solution Accelerator `[Sa/ModernizeYourCode]`

This module contains the resources required to deploy the [Modernize Your Code Solution Accelerator](https://github.com/microsoft/Modernize-your-code-solution-accelerator) for both Sandbox environments and WAF aligned environments.

> **Note:** This module is not intended for broad, generic use, as it was designed by the Commercial Solution Areas CTO team, as a Microsoft Solution Accelerator. Feature requests and bug fix requests are welcome if they support the needs of this organization but may not be incorporated if they aim to make this module more generic than what it needs to be for its primary use case. This module will likely be updated to leverage AVM resource modules in the future. This may result in breaking changes in upcoming versions when these features are implemented.


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
| `Microsoft.App/containerApps` | [2025-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2025-01-01/containerApps) |
| `Microsoft.App/containerApps/authConfigs` | [2025-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2025-01-01/containerApps/authConfigs) |
| `Microsoft.App/managedEnvironments` | [2024-10-02-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2024-10-02-preview/managedEnvironments) |
| `Microsoft.App/managedEnvironments/certificates` | [2024-10-02-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2024-10-02-preview/managedEnvironments/certificates) |
| `Microsoft.App/managedEnvironments/storages` | [2024-10-02-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2024-10-02-preview/managedEnvironments/storages) |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Automanage/configurationProfileAssignments` | [2022-05-04](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Automanage/2022-05-04/configurationProfileAssignments) |
| `Microsoft.CognitiveServices/accounts` | [2025-04-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2025-04-01-preview/accounts) |
| `Microsoft.CognitiveServices/accounts/deployments` | [2025-04-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2025-04-01-preview/accounts/deployments) |
| `Microsoft.CognitiveServices/accounts/projects` | [2025-04-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2025-04-01-preview/accounts/projects) |
| `Microsoft.Compute/disks` | [2024-03-02](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2024-03-02/disks) |
| `Microsoft.Compute/proximityPlacementGroups` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2022-08-01/proximityPlacementGroups) |
| `Microsoft.Compute/virtualMachines` | [2024-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2024-07-01/virtualMachines) |
| `Microsoft.Compute/virtualMachines/extensions` | [2022-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2022-11-01/virtualMachines/extensions) |
| `Microsoft.DevTestLab/schedules` | [2018-09-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevTestLab/2018-09-15/schedules) |
| `Microsoft.DocumentDB/databaseAccounts` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts) |
| `Microsoft.DocumentDB/databaseAccounts/gremlinDatabases` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/gremlinDatabases) |
| `Microsoft.DocumentDB/databaseAccounts/gremlinDatabases/graphs` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/gremlinDatabases/graphs) |
| `Microsoft.DocumentDB/databaseAccounts/mongodbDatabases` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/mongodbDatabases) |
| `Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/mongodbDatabases/collections) |
| `Microsoft.DocumentDB/databaseAccounts/sqlDatabases` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/sqlDatabases) |
| `Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/sqlDatabases/containers) |
| `Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/sqlRoleAssignments) |
| `Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/sqlRoleDefinitions) |
| `Microsoft.DocumentDB/databaseAccounts/tables` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/tables) |
| `Microsoft.GuestConfiguration/guestConfigurationAssignments` | [2020-06-25](https://learn.microsoft.com/en-us/azure/templates/Microsoft.GuestConfiguration/2020-06-25/guestConfigurationAssignments) |
| `Microsoft.Insights/components` | [2020-02-02](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2020-02-02/components) |
| `microsoft.insights/components/linkedStorageAccounts` | [2020-03-01-preview](https://learn.microsoft.com/en-us/azure/templates/microsoft.insights/2020-03-01-preview/components/linkedStorageAccounts) |
| `Microsoft.Insights/dataCollectionRuleAssociations` | [2023-03-11](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2023-03-11/dataCollectionRuleAssociations) |
| `Microsoft.Insights/dataCollectionRules` | [2023-03-11](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2023-03-11/dataCollectionRules) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.KeyVault/vaults/secrets` | [2024-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2024-11-01/vaults/secrets) |
| `Microsoft.KeyVault/vaults/secrets` | [2023-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2023-07-01/vaults/secrets) |
| `Microsoft.Maintenance/configurationAssignments` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Maintenance/2023-04-01/configurationAssignments) |
| `Microsoft.Maintenance/maintenanceConfigurations` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Maintenance/2023-04-01/maintenanceConfigurations) |
| `Microsoft.ManagedIdentity/userAssignedIdentities` | [2024-11-30](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2024-11-30/userAssignedIdentities) |
| `Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials` | [2024-11-30](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2024-11-30/userAssignedIdentities/federatedIdentityCredentials) |
| `Microsoft.Network/bastionHosts` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/bastionHosts) |
| `Microsoft.Network/networkInterfaces` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/networkInterfaces) |
| `Microsoft.Network/networkSecurityGroups` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/networkSecurityGroups) |
| `Microsoft.Network/privateDnsZones` | [2024-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-06-01/privateDnsZones) |
| `Microsoft.Network/privateDnsZones/virtualNetworkLinks` | [2024-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-06-01/privateDnsZones/virtualNetworkLinks) |
| `Microsoft.Network/privateEndpoints` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.Network/publicIPAddresses` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/publicIPAddresses) |
| `Microsoft.Network/virtualNetworks` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/virtualNetworks) |
| `Microsoft.Network/virtualNetworks/subnets` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/virtualNetworks/subnets) |
| `Microsoft.Network/virtualNetworks/virtualNetworkPeerings` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-01-01/virtualNetworks/virtualNetworkPeerings) |
| `Microsoft.OperationalInsights/workspaces` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces) |
| `Microsoft.OperationalInsights/workspaces/dataExports` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces/dataExports) |
| `Microsoft.OperationalInsights/workspaces/dataSources` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces/dataSources) |
| `Microsoft.OperationalInsights/workspaces/linkedServices` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces/linkedServices) |
| `Microsoft.OperationalInsights/workspaces/linkedStorageAccounts` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces/linkedStorageAccounts) |
| `Microsoft.OperationalInsights/workspaces/savedSearches` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces/savedSearches) |
| `Microsoft.OperationalInsights/workspaces/storageInsightConfigs` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces/storageInsightConfigs) |
| `Microsoft.OperationalInsights/workspaces/tables` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces/tables) |
| `Microsoft.OperationsManagement/solutions` | [2015-11-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationsManagement/2015-11-01-preview/solutions) |
| `Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2023-01-01/vaults/backupFabrics/protectionContainers/protectedItems) |
| `Microsoft.SecurityInsights/onboardingStates` | [2024-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.SecurityInsights/2024-03-01/onboardingStates) |
| `Microsoft.Storage/storageAccounts` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts) |
| `Microsoft.Storage/storageAccounts/blobServices` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/blobServices) |
| `Microsoft.Storage/storageAccounts/blobServices/containers` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/blobServices/containers) |
| `Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/blobServices/containers/immutabilityPolicies) |
| `Microsoft.Storage/storageAccounts/fileServices` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/fileServices) |
| `Microsoft.Storage/storageAccounts/fileServices/shares` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/fileServices/shares) |
| `Microsoft.Storage/storageAccounts/localUsers` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/localUsers) |
| `Microsoft.Storage/storageAccounts/managementPolicies` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/managementPolicies) |
| `Microsoft.Storage/storageAccounts/queueServices` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/queueServices) |
| `Microsoft.Storage/storageAccounts/queueServices/queues` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/queueServices/queues) |
| `Microsoft.Storage/storageAccounts/tableServices` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/tableServices) |
| `Microsoft.Storage/storageAccounts/tableServices/tables` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/tableServices/tables) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/sa/modernize-your-code:<version>`.

- [Sandbox configuration with default parameter values](#example-1-sandbox-configuration-with-default-parameter-values)
- [Default configuration with WAF aligned parameter values](#example-2-default-configuration-with-waf-aligned-parameter-values)

### Example 1: _Sandbox configuration with default parameter values_

This instance deploys the [Modernize Your Code Solution Accelerator](https://github.com/microsoft/Modernize-Your-Code-Solution-Accelerator) using only the required parameters. Optional parameters will take the default values, which are designed for Sandbox environments.


<details>

<summary>via Bicep module</summary>

```bicep
module modernizeYourCode 'br/public:avm/ptn/sa/modernize-your-code:<version>' = {
  name: 'modernizeYourCodeDeployment'
  params: {
    // Required parameters
    solutionName: 'samycmin001'
    // Non-required parameters
    location: '<location>'
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
    "solutionName": {
      "value": "samycmin001"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/sa/modernize-your-code:<version>'

// Required parameters
param solutionName = 'samycmin001'
// Non-required parameters
param location = '<location>'
```

</details>
<p>

### Example 2: _Default configuration with WAF aligned parameter values_

This instance deploys the [Modernize Your Code Solution Accelerator](https://github.com/microsoft/Modernize-Your-Code-Solution-Accelerator) using parameters that deploy the WAF aligned configuration.


<details>

<summary>via Bicep module</summary>

```bicep
module modernizeYourCode 'br/public:avm/ptn/sa/modernize-your-code:<version>' = {
  name: 'modernizeYourCodeDeployment'
  params: {
    // Required parameters
    solutionName: 'samycwaf001'
    // Non-required parameters
    azureAiServiceLocation: '<azureAiServiceLocation>'
    enableMonitoring: true
    enablePrivateNetworking: true
    enableRedundancy: true
    enableScaling: true
    location: '<location>'
    vmAdminPassword: 'a#aoWui1fgha%sjna2sdf%h'
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
    "solutionName": {
      "value": "samycwaf001"
    },
    // Non-required parameters
    "azureAiServiceLocation": {
      "value": "<azureAiServiceLocation>"
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
    "enableScaling": {
      "value": true
    },
    "location": {
      "value": "<location>"
    },
    "vmAdminPassword": {
      "value": "a#aoWui1fgha%sjna2sdf%h"
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
using 'br/public:avm/ptn/sa/modernize-your-code:<version>'

// Required parameters
param solutionName = 'samycwaf001'
// Non-required parameters
param azureAiServiceLocation = '<azureAiServiceLocation>'
param enableMonitoring = true
param enablePrivateNetworking = true
param enableRedundancy = true
param enableScaling = true
param location = '<location>'
param vmAdminPassword = 'a#aoWui1fgha%sjna2sdf%h'
param vmAdminUsername = 'adminuser'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`solutionName`](#parameter-solutionname) | securestring | A unique application/solution name for all resources in this deployment. This should be 3-16 characters long. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`azureAiServiceLocation`](#parameter-azureaiservicelocation) | string | Location for all AI service resources. This location can be different from the resource group location. |
| [`backendContainerImageName`](#parameter-backendcontainerimagename) | string | The Container Image Name to deploy on the backend. |
| [`backendContainerImageTag`](#parameter-backendcontainerimagetag) | string | The Container Image Tag to deploy on the backend. |
| [`backendContainerRegistryHostname`](#parameter-backendcontainerregistryhostname) | string | The Container Registry hostname where the docker images for the backend are located. |
| [`capacity`](#parameter-capacity) | int | AI model deployment token capacity. Defaults to 5K tokens per minute. |
| [`enableMonitoring`](#parameter-enablemonitoring) | bool | Enable monitoring for the resources. This will enable Application Insights and Log Analytics. Defaults to false. |
| [`enablePrivateNetworking`](#parameter-enableprivatenetworking) | bool | Enable private networking for the resources. Set to true to enable private networking. Defaults to false. |
| [`enableRedundancy`](#parameter-enableredundancy) | bool | Enable redundancy for applicable resources. Defaults to false. |
| [`enableScaling`](#parameter-enablescaling) | bool | Enable scaling for the container apps. Defaults to false. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`frontendContainerImageName`](#parameter-frontendcontainerimagename) | string | The Container Image Name to deploy on the frontend. |
| [`frontendContainerImageTag`](#parameter-frontendcontainerimagetag) | string | The Container Image Tag to deploy on the frontend. |
| [`frontendContainerRegistryHostname`](#parameter-frontendcontainerregistryhostname) | string | The Container Registry hostname where the docker images for the frontend are located. |
| [`location`](#parameter-location) | string | Azure region for all services. Defaults to the resource group location. |
| [`secondaryLocation`](#parameter-secondarylocation) | string | The secondary location for the Cosmos DB account if redundancy is enabled. Defaults to false. |
| [`solutionUniqueToken`](#parameter-solutionuniquetoken) | securestring | A unique token for the solution. This is used to ensure resource names are unique for global resources. Defaults to a 5-character substring of the unique string generated from the subscription ID, resource group name, and solution name. |
| [`tags`](#parameter-tags) | object | Specifies the resource tags for all the resources. Tag "azd-env-name" is automatically added to all resources. |
| [`vmAdminPassword`](#parameter-vmadminpassword) | securestring | Admin password for the Jumpbox Virtual Machine. Set to custom value if enablePrivateNetworking is true. |
| [`vmAdminUsername`](#parameter-vmadminusername) | securestring | Admin username for the Jumpbox Virtual Machine. Set to custom value if enablePrivateNetworking is true. |

### Parameter: `solutionName`

A unique application/solution name for all resources in this deployment. This should be 3-16 characters long.

- Required: Yes
- Type: securestring

### Parameter: `azureAiServiceLocation`

Location for all AI service resources. This location can be different from the resource group location.

- Required: No
- Type: string
- Default: `[parameters('location')]`
- Allowed:
  ```Bicep
  [
    'australiaeast'
    'brazilsouth'
    'canadacentral'
    'canadaeast'
    'eastus'
    'eastus2'
    'francecentral'
    'germanywestcentral'
    'japaneast'
    'koreacentral'
    'northcentralus'
    'norwayeast'
    'polandcentral'
    'southafricanorth'
    'southcentralus'
    'southindia'
    'swedencentral'
    'switzerlandnorth'
    'uaenorth'
    'uksouth'
    'westeurope'
    'westus'
    'westus3'
  ]
  ```

### Parameter: `backendContainerImageName`

The Container Image Name to deploy on the backend.

- Required: No
- Type: string
- Default: `'cmsabackend'`

### Parameter: `backendContainerImageTag`

The Container Image Tag to deploy on the backend.

- Required: No
- Type: string
- Default: `'latest_2025-06-24_249'`

### Parameter: `backendContainerRegistryHostname`

The Container Registry hostname where the docker images for the backend are located.

- Required: No
- Type: string
- Default: `'cmsacontainerreg.azurecr.io'`

### Parameter: `capacity`

AI model deployment token capacity. Defaults to 5K tokens per minute.

- Required: No
- Type: int
- Default: `5`

### Parameter: `enableMonitoring`

Enable monitoring for the resources. This will enable Application Insights and Log Analytics. Defaults to false.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enablePrivateNetworking`

Enable private networking for the resources. Set to true to enable private networking. Defaults to false.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableRedundancy`

Enable redundancy for applicable resources. Defaults to false.

- Required: No
- Type: bool
- Default: `False`

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

### Parameter: `frontendContainerImageName`

The Container Image Name to deploy on the frontend.

- Required: No
- Type: string
- Default: `'cmsafrontend'`

### Parameter: `frontendContainerImageTag`

The Container Image Tag to deploy on the frontend.

- Required: No
- Type: string
- Default: `'latest_2025-06-24_249'`

### Parameter: `frontendContainerRegistryHostname`

The Container Registry hostname where the docker images for the frontend are located.

- Required: No
- Type: string
- Default: `'cmsacontainerreg.azurecr.io'`

### Parameter: `location`

Azure region for all services. Defaults to the resource group location.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `secondaryLocation`

The secondary location for the Cosmos DB account if redundancy is enabled. Defaults to false.

- Required: No
- Type: string

### Parameter: `solutionUniqueToken`

A unique token for the solution. This is used to ensure resource names are unique for global resources. Defaults to a 5-character substring of the unique string generated from the subscription ID, resource group name, and solution name.

- Required: No
- Type: securestring
- Default: `[substring(uniqueString(subscription().id, resourceGroup().name, parameters('solutionName')), 0, 5)]`

### Parameter: `tags`

Specifies the resource tags for all the resources. Tag "azd-env-name" is automatically added to all resources.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `vmAdminPassword`

Admin password for the Jumpbox Virtual Machine. Set to custom value if enablePrivateNetworking is true.

- Required: No
- Type: securestring
- Default: `[newGuid()]`

### Parameter: `vmAdminUsername`

Admin username for the Jumpbox Virtual Machine. Set to custom value if enablePrivateNetworking is true.

- Required: No
- Type: securestring
- Default: `[take(newGuid(), 20)]`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `resourceGroupName` | string | The resource group the resources were deployed into. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/ptn/authorization/resource-role-assignment:0.1.2` | Remote reference |
| `br/public:avm/res/app/container-app:0.17.0` | Remote reference |
| `br/public:avm/res/app/managed-environment:0.11.2` | Remote reference |
| `br/public:avm/res/cognitive-services/account:0.10.2` | Remote reference |
| `br/public:avm/res/cognitive-services/account:0.11.0` | Remote reference |
| `br/public:avm/res/compute/proximity-placement-group:0.3.2` | Remote reference |
| `br/public:avm/res/compute/virtual-machine:0.15.0` | Remote reference |
| `br/public:avm/res/document-db/database-account:0.15.0` | Remote reference |
| `br/public:avm/res/insights/component:0.6.0` | Remote reference |
| `br/public:avm/res/insights/data-collection-rule:0.6.0` | Remote reference |
| `br/public:avm/res/maintenance/maintenance-configuration:0.3.1` | Remote reference |
| `br/public:avm/res/managed-identity/user-assigned-identity:0.4.1` | Remote reference |
| `br/public:avm/res/network/bastion-host:0.6.1` | Remote reference |
| `br/public:avm/res/network/network-security-group:0.5.1` | Remote reference |
| `br/public:avm/res/network/virtual-network:0.7.0` | Remote reference |
| `br/public:avm/res/network/virtual-network/subnet:0.1.2` | Remote reference |
| `br/public:avm/res/operational-insights/workspace:0.11.2` | Remote reference |
| `br/public:avm/res/storage/storage-account:0.22.1` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
