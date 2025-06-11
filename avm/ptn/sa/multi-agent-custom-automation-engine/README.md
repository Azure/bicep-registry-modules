# Multi-Agent Custom Automation Engine `[Sa/MultiAgentCustomAutomationEngine]`

This module contains the resources required to deploy the [Multi-Agent Custom Automation Engine solution accelerator](https://github.com/microsoft/Multi-Agent-Custom-Automation-Engine-Solution-Accelerator) for both Sandbox environments and WAF aligned environments.

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
| `Microsoft.CognitiveServices/accounts/deployments` | [2024-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2024-10-01/accounts/deployments) |
| `Microsoft.Compute/disks` | [2024-03-02](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2024-03-02/disks) |
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
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.KeyVault/vaults/secrets` | [2023-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2023-07-01/vaults/secrets) |
| `Microsoft.MachineLearningServices/workspaces` | [2024-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.MachineLearningServices/2024-10-01-preview/workspaces) |
| `Microsoft.MachineLearningServices/workspaces/computes` | [2024-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.MachineLearningServices/2024-10-01/workspaces/computes) |
| `Microsoft.MachineLearningServices/workspaces/connections` | [2024-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.MachineLearningServices/2024-10-01/workspaces/connections) |
| `Microsoft.Maintenance/configurationAssignments` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Maintenance/2023-04-01/configurationAssignments) |
| `Microsoft.ManagedIdentity/userAssignedIdentities` | [2024-11-30](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2024-11-30/userAssignedIdentities) |
| `Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials` | [2024-11-30](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2024-11-30/userAssignedIdentities/federatedIdentityCredentials) |
| `Microsoft.Network/bastionHosts` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/bastionHosts) |
| `Microsoft.Network/networkInterfaces` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/networkInterfaces) |
| `Microsoft.Network/networkSecurityGroups` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/networkSecurityGroups) |
| `Microsoft.Network/privateDnsZones` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones) |
| `Microsoft.Network/privateDnsZones/A` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/A) |
| `Microsoft.Network/privateDnsZones/AAAA` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/AAAA) |
| `Microsoft.Network/privateDnsZones/CNAME` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/CNAME) |
| `Microsoft.Network/privateDnsZones/MX` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/MX) |
| `Microsoft.Network/privateDnsZones/PTR` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/PTR) |
| `Microsoft.Network/privateDnsZones/SOA` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/SOA) |
| `Microsoft.Network/privateDnsZones/SRV` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/SRV) |
| `Microsoft.Network/privateDnsZones/TXT` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/TXT) |
| `Microsoft.Network/privateDnsZones/virtualNetworkLinks` | [2024-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-06-01/privateDnsZones/virtualNetworkLinks) |
| `Microsoft.Network/privateEndpoints` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/privateEndpoints) |
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
| `Microsoft.Web/serverfarms` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2022-09-01/serverfarms) |
| `Microsoft.Web/sites` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-04-01/sites) |
| `Microsoft.Web/sites/basicPublishingCredentialsPolicies` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-04-01/sites/basicPublishingCredentialsPolicies) |
| `Microsoft.Web/sites/config` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-04-01/sites/config) |
| `Microsoft.Web/sites/extensions` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-04-01/sites/extensions) |
| `Microsoft.Web/sites/hybridConnectionNamespaces/relays` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-04-01/sites/hybridConnectionNamespaces/relays) |
| `Microsoft.Web/sites/slots` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-04-01/sites/slots) |
| `Microsoft.Web/sites/slots/basicPublishingCredentialsPolicies` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-04-01/sites/slots/basicPublishingCredentialsPolicies) |
| `Microsoft.Web/sites/slots/config` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-04-01/sites/slots/config) |
| `Microsoft.Web/sites/slots/extensions` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-04-01/sites/slots/extensions) |
| `Microsoft.Web/sites/slots/hybridConnectionNamespaces/relays` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-04-01/sites/slots/hybridConnectionNamespaces/relays) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/sa/multi-agent-custom-automation-engine:<version>`.

- [Default configuration with default parameter values](#example-1-default-configuration-with-default-parameter-values)
- [Default configuration with WAF aligned parameter values](#example-2-default-configuration-with-waf-aligned-parameter-values)

### Example 1: _Default configuration with default parameter values_

This instance deploys the [Multi-Agent Custom Automation Engine solution accelerator](https://github.com/microsoft/Multi-Agent-Custom-Automation-Engine-Solution-Accelerator) using only the required parameters. Optional parameters will take the default values, which are designed for Sandbox environments.


<details>

<summary>via Bicep module</summary>

```bicep
module multiAgentCustomAutomationEngine 'br/public:avm/ptn/sa/multi-agent-custom-automation-engine:<version>' = {
  name: 'multiAgentCustomAutomationEngineDeployment'
  params: {
    // Required parameters
    azureOpenAILocation: 'australiaeast'
    // Non-required parameters
    aiFoundryStorageAccountConfiguration: {
      sku: 'Standard_LRS'
    }
    applicationInsightsConfiguration: {
      retentionInDays: 30
    }
    logAnalyticsWorkspaceConfiguration: {
      dataRetentionInDays: 30
    }
    virtualNetworkConfiguration: {
      enabled: false
    }
    webServerFarmConfiguration: {
      skuCapacity: 1
      skuName: 'B2'
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
    "azureOpenAILocation": {
      "value": "australiaeast"
    },
    // Non-required parameters
    "aiFoundryStorageAccountConfiguration": {
      "value": {
        "sku": "Standard_LRS"
      }
    },
    "applicationInsightsConfiguration": {
      "value": {
        "retentionInDays": 30
      }
    },
    "logAnalyticsWorkspaceConfiguration": {
      "value": {
        "dataRetentionInDays": 30
      }
    },
    "virtualNetworkConfiguration": {
      "value": {
        "enabled": false
      }
    },
    "webServerFarmConfiguration": {
      "value": {
        "skuCapacity": 1,
        "skuName": "B2"
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
using 'br/public:avm/ptn/sa/multi-agent-custom-automation-engine:<version>'

// Required parameters
param azureOpenAILocation = 'australiaeast'
// Non-required parameters
param aiFoundryStorageAccountConfiguration = {
  sku: 'Standard_LRS'
}
param applicationInsightsConfiguration = {
  retentionInDays: 30
}
param logAnalyticsWorkspaceConfiguration = {
  dataRetentionInDays: 30
}
param virtualNetworkConfiguration = {
  enabled: false
}
param webServerFarmConfiguration = {
  skuCapacity: 1
  skuName: 'B2'
}
```

</details>
<p>

### Example 2: _Default configuration with WAF aligned parameter values_

This instance deploys the [Multi-Agent Custom Automation Engine solution accelerator](https://github.com/microsoft/Multi-Agent-Custom-Automation-Engine-Solution-Accelerator) using parameters that deploy the WAF aligned configuration.


<details>

<summary>via Bicep module</summary>

```bicep
module multiAgentCustomAutomationEngine 'br/public:avm/ptn/sa/multi-agent-custom-automation-engine:<version>' = {
  name: 'multiAgentCustomAutomationEngineDeployment'
  params: {
    azureOpenAILocation: 'australiaeast'
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
    "azureOpenAILocation": {
      "value": "australiaeast"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/sa/multi-agent-custom-automation-engine:<version>'

param azureOpenAILocation = 'australiaeast'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`azureOpenAILocation`](#parameter-azureopenailocation) | string | The location of OpenAI related resources. This should be one of the supported Azure OpenAI regions. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`aiFoundryAiHubConfiguration`](#parameter-aifoundryaihubconfiguration) | object | The configuration to apply for the AI Foundry AI Hub resource. |
| [`aiFoundryAiProjectConfiguration`](#parameter-aifoundryaiprojectconfiguration) | object | The configuration to apply for the AI Foundry AI Project resource. |
| [`aiFoundryAiServicesConfiguration`](#parameter-aifoundryaiservicesconfiguration) | object | The configuration to apply for the AI Foundry AI Services resource. |
| [`aiFoundryStorageAccountConfiguration`](#parameter-aifoundrystorageaccountconfiguration) | object | The configuration to apply for the AI Foundry Storage Account resource. |
| [`applicationInsightsConfiguration`](#parameter-applicationinsightsconfiguration) | object | The configuration to apply for the Multi-Agent Custom Automation Engine Application Insights resource. |
| [`bastionConfiguration`](#parameter-bastionconfiguration) | object | The configuration to apply for the Multi-Agent Custom Automation Engine bastion resource. |
| [`containerAppConfiguration`](#parameter-containerappconfiguration) | object | The configuration to apply for the Container App resource. |
| [`containerAppEnvironmentConfiguration`](#parameter-containerappenvironmentconfiguration) | object | The configuration to apply for the Container App Environment resource. |
| [`cosmosDbAccountConfiguration`](#parameter-cosmosdbaccountconfiguration) | object | The configuration to apply for the Cosmos DB Account resource. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`logAnalyticsWorkspaceConfiguration`](#parameter-loganalyticsworkspaceconfiguration) | object | The configuration to apply for the Multi-Agent Custom Automation Engine Log Analytics Workspace resource. |
| [`networkSecurityGroupAdministrationConfiguration`](#parameter-networksecuritygroupadministrationconfiguration) | object | The configuration to apply for the Multi-Agent Custom Automation Engine Network Security Group resource for the administration subnet. |
| [`networkSecurityGroupBackendConfiguration`](#parameter-networksecuritygroupbackendconfiguration) | object | The configuration to apply for the Multi-Agent Custom Automation Engine Network Security Group resource for the backend subnet. |
| [`networkSecurityGroupBastionConfiguration`](#parameter-networksecuritygroupbastionconfiguration) | object | The configuration to apply for the Multi-Agent Custom Automation Engine Network Security Group resource for the Bastion subnet. |
| [`networkSecurityGroupContainersConfiguration`](#parameter-networksecuritygroupcontainersconfiguration) | object | The configuration to apply for the Multi-Agent Custom Automation Engine Network Security Group resource for the containers subnet. |
| [`solutionLocation`](#parameter-solutionlocation) | string | Location for all Resources except AI Foundry. |
| [`solutionPrefix`](#parameter-solutionprefix) | string | The prefix to add in the default names given to all deployed Azure resources. |
| [`tags`](#parameter-tags) | object | The tags to apply to all deployed Azure resources. |
| [`userAssignedManagedIdentityConfiguration`](#parameter-userassignedmanagedidentityconfiguration) | object | The configuration to apply for the Multi-Agent Custom Automation Engine Managed Identity resource. |
| [`virtualMachineConfiguration`](#parameter-virtualmachineconfiguration) | object | Configuration for the Windows virtual machine. |
| [`virtualNetworkConfiguration`](#parameter-virtualnetworkconfiguration) | object | The configuration to apply for the Multi-Agent Custom Automation Engine virtual network resource. |
| [`webServerFarmConfiguration`](#parameter-webserverfarmconfiguration) | object | The configuration to apply for the Web Server Farm resource. |
| [`webSiteConfiguration`](#parameter-websiteconfiguration) | object | The configuration to apply for the Web Server Farm resource. |

### Parameter: `azureOpenAILocation`

The location of OpenAI related resources. This should be one of the supported Azure OpenAI regions.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'australiaeast'
    'eastus2'
    'francecentral'
    'japaneast'
    'norwayeast'
    'swedencentral'
    'uksouth'
    'westus'
  ]
  ```

### Parameter: `aiFoundryAiHubConfiguration`

The configuration to apply for the AI Foundry AI Hub resource.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      enabled: true
      location: '[parameters(\'azureOpenAILocation\')]'
      name: '[format(\'aih-{0}\', parameters(\'solutionPrefix\'))]'
      sku: 'Basic'
      subnetResourceId: null
      tags: '[parameters(\'tags\')]'
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-aifoundryaihubconfigurationenabled) | bool | If the AI Hub resource should be deployed or not. |
| [`location`](#parameter-aifoundryaihubconfigurationlocation) | string | Location for the AI Hub resource. |
| [`name`](#parameter-aifoundryaihubconfigurationname) | string | The name of the AI Hub resource. |
| [`sku`](#parameter-aifoundryaihubconfigurationsku) | string | The SKU of the AI Hub resource. |
| [`subnetResourceId`](#parameter-aifoundryaihubconfigurationsubnetresourceid) | string | The resource Id of the subnet where the AI Hub private endpoint should be created. |
| [`tags`](#parameter-aifoundryaihubconfigurationtags) | object | The tags to set for the AI Hub resource. |

### Parameter: `aiFoundryAiHubConfiguration.enabled`

If the AI Hub resource should be deployed or not.

- Required: No
- Type: bool

### Parameter: `aiFoundryAiHubConfiguration.location`

Location for the AI Hub resource.

- Required: No
- Type: string

### Parameter: `aiFoundryAiHubConfiguration.name`

The name of the AI Hub resource.

- Required: No
- Type: string

### Parameter: `aiFoundryAiHubConfiguration.sku`

The SKU of the AI Hub resource.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Basic'
    'Free'
    'Premium'
    'Standard'
  ]
  ```

### Parameter: `aiFoundryAiHubConfiguration.subnetResourceId`

The resource Id of the subnet where the AI Hub private endpoint should be created.

- Required: No
- Type: string

### Parameter: `aiFoundryAiHubConfiguration.tags`

The tags to set for the AI Hub resource.

- Required: No
- Type: object

### Parameter: `aiFoundryAiProjectConfiguration`

The configuration to apply for the AI Foundry AI Project resource.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      enabled: true
      location: '[parameters(\'azureOpenAILocation\')]'
      name: '[format(\'aihb-{0}\', parameters(\'solutionPrefix\'))]'
      sku: 'Basic'
      tags: '[parameters(\'tags\')]'
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-aifoundryaiprojectconfigurationenabled) | bool | If the AI Project resource should be deployed or not. |
| [`location`](#parameter-aifoundryaiprojectconfigurationlocation) | string | Location for the AI Project resource deployment. |
| [`name`](#parameter-aifoundryaiprojectconfigurationname) | string | The name of the AI Project resource. |
| [`sku`](#parameter-aifoundryaiprojectconfigurationsku) | string | The SKU of the AI Project resource. |
| [`tags`](#parameter-aifoundryaiprojectconfigurationtags) | object | The tags to set for the AI Project resource. |

### Parameter: `aiFoundryAiProjectConfiguration.enabled`

If the AI Project resource should be deployed or not.

- Required: No
- Type: bool

### Parameter: `aiFoundryAiProjectConfiguration.location`

Location for the AI Project resource deployment.

- Required: No
- Type: string

### Parameter: `aiFoundryAiProjectConfiguration.name`

The name of the AI Project resource.

- Required: No
- Type: string

### Parameter: `aiFoundryAiProjectConfiguration.sku`

The SKU of the AI Project resource.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Basic'
    'Free'
    'Premium'
    'Standard'
  ]
  ```

### Parameter: `aiFoundryAiProjectConfiguration.tags`

The tags to set for the AI Project resource.

- Required: No
- Type: object

### Parameter: `aiFoundryAiServicesConfiguration`

The configuration to apply for the AI Foundry AI Services resource.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      deployments: null
      enabled: true
      location: '[parameters(\'azureOpenAILocation\')]'
      modelCapacity: 140
      name: '[format(\'aisa-{0}\', parameters(\'solutionPrefix\'))]'
      sku: 'S0'
      subnetResourceId: null
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`deployments`](#parameter-aifoundryaiservicesconfigurationdeployments) | array | The model deployments to set for the AI Services resource. |
| [`enabled`](#parameter-aifoundryaiservicesconfigurationenabled) | bool | If the AI Services resource should be deployed or not. |
| [`location`](#parameter-aifoundryaiservicesconfigurationlocation) | string | Location for the AI Services resource. |
| [`modelCapacity`](#parameter-aifoundryaiservicesconfigurationmodelcapacity) | int | The capacity to set for AI Services GTP model. |
| [`name`](#parameter-aifoundryaiservicesconfigurationname) | string | The name of the AI Services resource. |
| [`sku`](#parameter-aifoundryaiservicesconfigurationsku) | string | The SKU of the AI Services resource. Use 'Get-AzCognitiveServicesAccountSku' to determine a valid combinations of 'kind' and 'SKU' for your Azure region. |
| [`subnetResourceId`](#parameter-aifoundryaiservicesconfigurationsubnetresourceid) | string | The resource Id of the subnet where the AI Services private endpoint should be created. |
| [`tags`](#parameter-aifoundryaiservicesconfigurationtags) | object | The tags to set for the AI Services resource. |

### Parameter: `aiFoundryAiServicesConfiguration.deployments`

The model deployments to set for the AI Services resource.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`model`](#parameter-aifoundryaiservicesconfigurationdeploymentsmodel) | object | Properties of Cognitive Services account deployment model. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-aifoundryaiservicesconfigurationdeploymentsname) | string | Specify the name of cognitive service account deployment. |
| [`raiPolicyName`](#parameter-aifoundryaiservicesconfigurationdeploymentsraipolicyname) | string | The name of RAI policy. |
| [`sku`](#parameter-aifoundryaiservicesconfigurationdeploymentssku) | object | The resource model definition representing SKU. |
| [`versionUpgradeOption`](#parameter-aifoundryaiservicesconfigurationdeploymentsversionupgradeoption) | string | The version upgrade option. |

### Parameter: `aiFoundryAiServicesConfiguration.deployments.model`

Properties of Cognitive Services account deployment model.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`format`](#parameter-aifoundryaiservicesconfigurationdeploymentsmodelformat) | string | The format of Cognitive Services account deployment model. |
| [`name`](#parameter-aifoundryaiservicesconfigurationdeploymentsmodelname) | string | The name of Cognitive Services account deployment model. |
| [`version`](#parameter-aifoundryaiservicesconfigurationdeploymentsmodelversion) | string | The version of Cognitive Services account deployment model. |

### Parameter: `aiFoundryAiServicesConfiguration.deployments.model.format`

The format of Cognitive Services account deployment model.

- Required: Yes
- Type: string

### Parameter: `aiFoundryAiServicesConfiguration.deployments.model.name`

The name of Cognitive Services account deployment model.

- Required: Yes
- Type: string

### Parameter: `aiFoundryAiServicesConfiguration.deployments.model.version`

The version of Cognitive Services account deployment model.

- Required: Yes
- Type: string

### Parameter: `aiFoundryAiServicesConfiguration.deployments.name`

Specify the name of cognitive service account deployment.

- Required: No
- Type: string

### Parameter: `aiFoundryAiServicesConfiguration.deployments.raiPolicyName`

The name of RAI policy.

- Required: No
- Type: string

### Parameter: `aiFoundryAiServicesConfiguration.deployments.sku`

The resource model definition representing SKU.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-aifoundryaiservicesconfigurationdeploymentsskuname) | string | The name of the resource model definition representing SKU. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`capacity`](#parameter-aifoundryaiservicesconfigurationdeploymentsskucapacity) | int | The capacity of the resource model definition representing SKU. |
| [`family`](#parameter-aifoundryaiservicesconfigurationdeploymentsskufamily) | string | The family of the resource model definition representing SKU. |
| [`size`](#parameter-aifoundryaiservicesconfigurationdeploymentsskusize) | string | The size of the resource model definition representing SKU. |
| [`tier`](#parameter-aifoundryaiservicesconfigurationdeploymentsskutier) | string | The tier of the resource model definition representing SKU. |

### Parameter: `aiFoundryAiServicesConfiguration.deployments.sku.name`

The name of the resource model definition representing SKU.

- Required: Yes
- Type: string

### Parameter: `aiFoundryAiServicesConfiguration.deployments.sku.capacity`

The capacity of the resource model definition representing SKU.

- Required: No
- Type: int

### Parameter: `aiFoundryAiServicesConfiguration.deployments.sku.family`

The family of the resource model definition representing SKU.

- Required: No
- Type: string

### Parameter: `aiFoundryAiServicesConfiguration.deployments.sku.size`

The size of the resource model definition representing SKU.

- Required: No
- Type: string

### Parameter: `aiFoundryAiServicesConfiguration.deployments.sku.tier`

The tier of the resource model definition representing SKU.

- Required: No
- Type: string

### Parameter: `aiFoundryAiServicesConfiguration.deployments.versionUpgradeOption`

The version upgrade option.

- Required: No
- Type: string

### Parameter: `aiFoundryAiServicesConfiguration.enabled`

If the AI Services resource should be deployed or not.

- Required: No
- Type: bool

### Parameter: `aiFoundryAiServicesConfiguration.location`

Location for the AI Services resource.

- Required: No
- Type: string

### Parameter: `aiFoundryAiServicesConfiguration.modelCapacity`

The capacity to set for AI Services GTP model.

- Required: No
- Type: int

### Parameter: `aiFoundryAiServicesConfiguration.name`

The name of the AI Services resource.

- Required: No
- Type: string

### Parameter: `aiFoundryAiServicesConfiguration.sku`

The SKU of the AI Services resource. Use 'Get-AzCognitiveServicesAccountSku' to determine a valid combinations of 'kind' and 'SKU' for your Azure region.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'C2'
    'C3'
    'C4'
    'F0'
    'F1'
    'S'
    'S0'
    'S1'
    'S10'
    'S2'
    'S3'
    'S4'
    'S5'
    'S6'
    'S7'
    'S8'
    'S9'
  ]
  ```

### Parameter: `aiFoundryAiServicesConfiguration.subnetResourceId`

The resource Id of the subnet where the AI Services private endpoint should be created.

- Required: No
- Type: string

### Parameter: `aiFoundryAiServicesConfiguration.tags`

The tags to set for the AI Services resource.

- Required: No
- Type: object

### Parameter: `aiFoundryStorageAccountConfiguration`

The configuration to apply for the AI Foundry Storage Account resource.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      enabled: true
      location: '[parameters(\'azureOpenAILocation\')]'
      name: '[replace(format(\'sthub{0}\', parameters(\'solutionPrefix\')), \'-\', \'\')]'
      sku: 'Standard_ZRS'
      subnetResourceId: null
      tags: '[parameters(\'tags\')]'
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-aifoundrystorageaccountconfigurationenabled) | bool | If the Storage Account resource should be deployed or not. |
| [`location`](#parameter-aifoundrystorageaccountconfigurationlocation) | string | Location for the Storage Account resource. |
| [`name`](#parameter-aifoundrystorageaccountconfigurationname) | string | The name of the Storage Account resource. |
| [`sku`](#parameter-aifoundrystorageaccountconfigurationsku) | string | The SKU for the Storage Account resource. |
| [`subnetResourceId`](#parameter-aifoundrystorageaccountconfigurationsubnetresourceid) | string | The resource Id of the subnet where the Storage Account private endpoint should be created. |
| [`tags`](#parameter-aifoundrystorageaccountconfigurationtags) | object | The tags to set for the Storage Account resource. |

### Parameter: `aiFoundryStorageAccountConfiguration.enabled`

If the Storage Account resource should be deployed or not.

- Required: No
- Type: bool

### Parameter: `aiFoundryStorageAccountConfiguration.location`

Location for the Storage Account resource.

- Required: No
- Type: string

### Parameter: `aiFoundryStorageAccountConfiguration.name`

The name of the Storage Account resource.

- Required: No
- Type: string

### Parameter: `aiFoundryStorageAccountConfiguration.sku`

The SKU for the Storage Account resource.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Premium_LRS'
    'Premium_ZRS'
    'Standard_GRS'
    'Standard_LRS'
    'Standard_RAGRS'
    'Standard_ZRS'
  ]
  ```

### Parameter: `aiFoundryStorageAccountConfiguration.subnetResourceId`

The resource Id of the subnet where the Storage Account private endpoint should be created.

- Required: No
- Type: string

### Parameter: `aiFoundryStorageAccountConfiguration.tags`

The tags to set for the Storage Account resource.

- Required: No
- Type: object

### Parameter: `applicationInsightsConfiguration`

The configuration to apply for the Multi-Agent Custom Automation Engine Application Insights resource.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      enabled: true
      location: '[parameters(\'solutionLocation\')]'
      name: '[format(\'appi-{0}\', parameters(\'solutionPrefix\'))]'
      retentionInDays: 365
      tags: '[parameters(\'tags\')]'
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-applicationinsightsconfigurationenabled) | bool | If the Application Insights resource should be deployed or not. |
| [`location`](#parameter-applicationinsightsconfigurationlocation) | string | Location for the Application Insights resource. |
| [`name`](#parameter-applicationinsightsconfigurationname) | string | The name of the Application Insights resource. |
| [`retentionInDays`](#parameter-applicationinsightsconfigurationretentionindays) | int | The retention of Application Insights data in days. If empty, Standard will be used. |
| [`tags`](#parameter-applicationinsightsconfigurationtags) | object | The tags to set for the Application Insights resource. |

### Parameter: `applicationInsightsConfiguration.enabled`

If the Application Insights resource should be deployed or not.

- Required: No
- Type: bool

### Parameter: `applicationInsightsConfiguration.location`

Location for the Application Insights resource.

- Required: No
- Type: string

### Parameter: `applicationInsightsConfiguration.name`

The name of the Application Insights resource.

- Required: No
- Type: string

### Parameter: `applicationInsightsConfiguration.retentionInDays`

The retention of Application Insights data in days. If empty, Standard will be used.

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

### Parameter: `applicationInsightsConfiguration.tags`

The tags to set for the Application Insights resource.

- Required: No
- Type: object

### Parameter: `bastionConfiguration`

The configuration to apply for the Multi-Agent Custom Automation Engine bastion resource.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      enabled: true
      location: '[parameters(\'solutionLocation\')]'
      name: '[format(\'bas-{0}\', parameters(\'solutionPrefix\'))]'
      publicIpResourceName: '[format(\'pip-bas{0}\', parameters(\'solutionPrefix\'))]'
      sku: 'Standard'
      tags: '[parameters(\'tags\')]'
      virtualNetworkResourceId: null
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-bastionconfigurationenabled) | bool | If the Bastion resource should be deployed or not. |
| [`location`](#parameter-bastionconfigurationlocation) | string | Location for the Bastion resource. |
| [`name`](#parameter-bastionconfigurationname) | string | The name of the Bastion resource. |
| [`publicIpResourceName`](#parameter-bastionconfigurationpublicipresourcename) | string | The name of the Public Ip resource created to connect to Bastion. |
| [`sku`](#parameter-bastionconfigurationsku) | string | The SKU for the Bastion resource. |
| [`tags`](#parameter-bastionconfigurationtags) | object | The tags to set for the Bastion resource. |
| [`virtualNetworkResourceId`](#parameter-bastionconfigurationvirtualnetworkresourceid) | string | The Virtual Network resource id where the Bastion resource should be deployed. |

### Parameter: `bastionConfiguration.enabled`

If the Bastion resource should be deployed or not.

- Required: No
- Type: bool

### Parameter: `bastionConfiguration.location`

Location for the Bastion resource.

- Required: No
- Type: string

### Parameter: `bastionConfiguration.name`

The name of the Bastion resource.

- Required: No
- Type: string

### Parameter: `bastionConfiguration.publicIpResourceName`

The name of the Public Ip resource created to connect to Bastion.

- Required: No
- Type: string

### Parameter: `bastionConfiguration.sku`

The SKU for the Bastion resource.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Basic'
    'Developer'
    'Premium'
    'Standard'
  ]
  ```

### Parameter: `bastionConfiguration.tags`

The tags to set for the Bastion resource.

- Required: No
- Type: object

### Parameter: `bastionConfiguration.virtualNetworkResourceId`

The Virtual Network resource id where the Bastion resource should be deployed.

- Required: No
- Type: string

### Parameter: `containerAppConfiguration`

The configuration to apply for the Container App resource.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      concurrentRequests: '100'
      containerCpu: '2.0'
      containerImageName: 'macaebackend'
      containerImageRegistryDomain: 'biabcontainerreg.azurecr.io'
      containerImageTag: 'latest'
      containerMemory: '4.0Gi'
      containerName: 'backend'
      enabled: true
      environmentResourceId: null
      ingressTargetPort: 8000
      location: '[parameters(\'solutionLocation\')]'
      maxReplicas: 1
      minReplicas: 1
      name: '[format(\'ca-{0}\', parameters(\'solutionPrefix\'))]'
      tags: '[parameters(\'tags\')]'
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`concurrentRequests`](#parameter-containerappconfigurationconcurrentrequests) | string | The concurrent requests allowed for the Container App. |
| [`containerCpu`](#parameter-containerappconfigurationcontainercpu) | string | The CPU reserved for the Container App. Defaults to 2.0. |
| [`containerImageName`](#parameter-containerappconfigurationcontainerimagename) | string | The name of the container image to be used by the Container App. |
| [`containerImageRegistryDomain`](#parameter-containerappconfigurationcontainerimageregistrydomain) | string | The container registry domain of the container image to be used by the Container App. Default to `biabcontainerreg.azurecr.io`. |
| [`containerImageTag`](#parameter-containerappconfigurationcontainerimagetag) | string | The tag of the container image to be used by the Container App. |
| [`containerMemory`](#parameter-containerappconfigurationcontainermemory) | string | The Memory reserved for the Container App. Defaults to 4.0Gi. |
| [`containerName`](#parameter-containerappconfigurationcontainername) | string | The name given to the Container App. |
| [`enabled`](#parameter-containerappconfigurationenabled) | bool | If the Container App resource should be deployed or not. |
| [`environmentResourceId`](#parameter-containerappconfigurationenvironmentresourceid) | string | The resource Id of the Container App Environment where the Container App should be created. |
| [`ingressTargetPort`](#parameter-containerappconfigurationingresstargetport) | int | The ingress target port of the Container App. |
| [`location`](#parameter-containerappconfigurationlocation) | string | Location for the Container App resource. |
| [`maxReplicas`](#parameter-containerappconfigurationmaxreplicas) | int | The maximum number of replicas of the Container App. |
| [`minReplicas`](#parameter-containerappconfigurationminreplicas) | int | The minimum number of replicas of the Container App. |
| [`name`](#parameter-containerappconfigurationname) | string | The name of the Container App resource. |
| [`tags`](#parameter-containerappconfigurationtags) | object | The tags to set for the Container App resource. |

### Parameter: `containerAppConfiguration.concurrentRequests`

The concurrent requests allowed for the Container App.

- Required: No
- Type: string

### Parameter: `containerAppConfiguration.containerCpu`

The CPU reserved for the Container App. Defaults to 2.0.

- Required: No
- Type: string

### Parameter: `containerAppConfiguration.containerImageName`

The name of the container image to be used by the Container App.

- Required: No
- Type: string

### Parameter: `containerAppConfiguration.containerImageRegistryDomain`

The container registry domain of the container image to be used by the Container App. Default to `biabcontainerreg.azurecr.io`.

- Required: No
- Type: string

### Parameter: `containerAppConfiguration.containerImageTag`

The tag of the container image to be used by the Container App.

- Required: No
- Type: string

### Parameter: `containerAppConfiguration.containerMemory`

The Memory reserved for the Container App. Defaults to 4.0Gi.

- Required: No
- Type: string

### Parameter: `containerAppConfiguration.containerName`

The name given to the Container App.

- Required: No
- Type: string

### Parameter: `containerAppConfiguration.enabled`

If the Container App resource should be deployed or not.

- Required: No
- Type: bool

### Parameter: `containerAppConfiguration.environmentResourceId`

The resource Id of the Container App Environment where the Container App should be created.

- Required: No
- Type: string

### Parameter: `containerAppConfiguration.ingressTargetPort`

The ingress target port of the Container App.

- Required: No
- Type: int

### Parameter: `containerAppConfiguration.location`

Location for the Container App resource.

- Required: No
- Type: string

### Parameter: `containerAppConfiguration.maxReplicas`

The maximum number of replicas of the Container App.

- Required: No
- Type: int

### Parameter: `containerAppConfiguration.minReplicas`

The minimum number of replicas of the Container App.

- Required: No
- Type: int

### Parameter: `containerAppConfiguration.name`

The name of the Container App resource.

- Required: No
- Type: string

### Parameter: `containerAppConfiguration.tags`

The tags to set for the Container App resource.

- Required: No
- Type: object

### Parameter: `containerAppEnvironmentConfiguration`

The configuration to apply for the Container App Environment resource.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      enabled: true
      location: '[parameters(\'solutionLocation\')]'
      name: '[format(\'cae-{0}\', parameters(\'solutionPrefix\'))]'
      subnetResourceId: null
      tags: '[parameters(\'tags\')]'
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-containerappenvironmentconfigurationenabled) | bool | If the Container App Environment resource should be deployed or not. |
| [`location`](#parameter-containerappenvironmentconfigurationlocation) | string | Location for the Container App Environment resource. |
| [`name`](#parameter-containerappenvironmentconfigurationname) | string | The name of the Container App Environment resource. |
| [`subnetResourceId`](#parameter-containerappenvironmentconfigurationsubnetresourceid) | string | The resource Id of the subnet where the Container App Environment private endpoint should be created. |
| [`tags`](#parameter-containerappenvironmentconfigurationtags) | object | The tags to set for the Container App Environment resource. |

### Parameter: `containerAppEnvironmentConfiguration.enabled`

If the Container App Environment resource should be deployed or not.

- Required: No
- Type: bool

### Parameter: `containerAppEnvironmentConfiguration.location`

Location for the Container App Environment resource.

- Required: No
- Type: string

### Parameter: `containerAppEnvironmentConfiguration.name`

The name of the Container App Environment resource.

- Required: No
- Type: string

### Parameter: `containerAppEnvironmentConfiguration.subnetResourceId`

The resource Id of the subnet where the Container App Environment private endpoint should be created.

- Required: No
- Type: string

### Parameter: `containerAppEnvironmentConfiguration.tags`

The tags to set for the Container App Environment resource.

- Required: No
- Type: object

### Parameter: `cosmosDbAccountConfiguration`

The configuration to apply for the Cosmos DB Account resource.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      enabled: true
      location: '[parameters(\'solutionLocation\')]'
      name: '[format(\'cosmos-{0}\', parameters(\'solutionPrefix\'))]'
      sqlDatabases: null
      subnetResourceId: null
      tags: '[parameters(\'tags\')]'
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-cosmosdbaccountconfigurationenabled) | bool | If the Cosmos DB Account resource should be deployed or not. |
| [`location`](#parameter-cosmosdbaccountconfigurationlocation) | string | Location for the Cosmos DB Account resource. |
| [`name`](#parameter-cosmosdbaccountconfigurationname) | string | The name of the Cosmos DB Account resource. |
| [`sqlDatabases`](#parameter-cosmosdbaccountconfigurationsqldatabases) | array | The SQL databases configuration for the Cosmos DB Account resource. |
| [`subnetResourceId`](#parameter-cosmosdbaccountconfigurationsubnetresourceid) | string | The resource Id of the subnet where the Cosmos DB Account private endpoint should be created. |
| [`tags`](#parameter-cosmosdbaccountconfigurationtags) | object | The tags to set for the Cosmos DB Account resource. |

### Parameter: `cosmosDbAccountConfiguration.enabled`

If the Cosmos DB Account resource should be deployed or not.

- Required: No
- Type: bool

### Parameter: `cosmosDbAccountConfiguration.location`

Location for the Cosmos DB Account resource.

- Required: No
- Type: string

### Parameter: `cosmosDbAccountConfiguration.name`

The name of the Cosmos DB Account resource.

- Required: No
- Type: string

### Parameter: `cosmosDbAccountConfiguration.sqlDatabases`

The SQL databases configuration for the Cosmos DB Account resource.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-cosmosdbaccountconfigurationsqldatabasesname) | string | Name of the SQL database . |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoscaleSettingsMaxThroughput`](#parameter-cosmosdbaccountconfigurationsqldatabasesautoscalesettingsmaxthroughput) | int | Specifies the Autoscale settings and represents maximum throughput, the resource can scale up to. The autoscale throughput should have valid throughput values between 1000 and 1000000 inclusive in increments of 1000. If value is set to null, then autoscale will be disabled. Setting throughput at the database level is only recommended for development/test or when workload across all containers in the shared throughput database is uniform. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the container level and not at the database level. |
| [`containers`](#parameter-cosmosdbaccountconfigurationsqldatabasescontainers) | array | Array of containers to deploy in the SQL database. |
| [`throughput`](#parameter-cosmosdbaccountconfigurationsqldatabasesthroughput) | int | Default to 400. Request units per second. Will be ignored if autoscaleSettingsMaxThroughput is used. Setting throughput at the database level is only recommended for development/test or when workload across all containers in the shared throughput database is uniform. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the container level and not at the database level. |

### Parameter: `cosmosDbAccountConfiguration.sqlDatabases.name`

Name of the SQL database .

- Required: Yes
- Type: string

### Parameter: `cosmosDbAccountConfiguration.sqlDatabases.autoscaleSettingsMaxThroughput`

Specifies the Autoscale settings and represents maximum throughput, the resource can scale up to. The autoscale throughput should have valid throughput values between 1000 and 1000000 inclusive in increments of 1000. If value is set to null, then autoscale will be disabled. Setting throughput at the database level is only recommended for development/test or when workload across all containers in the shared throughput database is uniform. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the container level and not at the database level.

- Required: No
- Type: int

### Parameter: `cosmosDbAccountConfiguration.sqlDatabases.containers`

Array of containers to deploy in the SQL database.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-cosmosdbaccountconfigurationsqldatabasescontainersname) | string | Name of the container. |
| [`paths`](#parameter-cosmosdbaccountconfigurationsqldatabasescontainerspaths) | array | List of paths using which data within the container can be partitioned. For kind=MultiHash it can be up to 3. For anything else it needs to be exactly 1. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`analyticalStorageTtl`](#parameter-cosmosdbaccountconfigurationsqldatabasescontainersanalyticalstoragettl) | int | Default to 0. Indicates how long data should be retained in the analytical store, for a container. Analytical store is enabled when ATTL is set with a value other than 0. If the value is set to -1, the analytical store retains all historical data, irrespective of the retention of the data in the transactional store. |
| [`autoscaleSettingsMaxThroughput`](#parameter-cosmosdbaccountconfigurationsqldatabasescontainersautoscalesettingsmaxthroughput) | int | Specifies the Autoscale settings and represents maximum throughput, the resource can scale up to. The autoscale throughput should have valid throughput values between 1000 and 1000000 inclusive in increments of 1000. If value is set to null, then autoscale will be disabled. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the container level. |
| [`conflictResolutionPolicy`](#parameter-cosmosdbaccountconfigurationsqldatabasescontainersconflictresolutionpolicy) | object | The conflict resolution policy for the container. Conflicts and conflict resolution policies are applicable if the Azure Cosmos DB account is configured with multiple write regions. |
| [`defaultTtl`](#parameter-cosmosdbaccountconfigurationsqldatabasescontainersdefaultttl) | int | Default to -1. Default time to live (in seconds). With Time to Live or TTL, Azure Cosmos DB provides the ability to delete items automatically from a container after a certain time period. If the value is set to "-1", it is equal to infinity, and items don't expire by default. |
| [`indexingPolicy`](#parameter-cosmosdbaccountconfigurationsqldatabasescontainersindexingpolicy) | object | Indexing policy of the container. |
| [`kind`](#parameter-cosmosdbaccountconfigurationsqldatabasescontainerskind) | string | Default to Hash. Indicates the kind of algorithm used for partitioning. |
| [`throughput`](#parameter-cosmosdbaccountconfigurationsqldatabasescontainersthroughput) | int | Default to 400. Request Units per second. Will be ignored if autoscaleSettingsMaxThroughput is used. |
| [`uniqueKeyPolicyKeys`](#parameter-cosmosdbaccountconfigurationsqldatabasescontainersuniquekeypolicykeys) | array | The unique key policy configuration containing a list of unique keys that enforces uniqueness constraint on documents in the collection in the Azure Cosmos DB service. |
| [`version`](#parameter-cosmosdbaccountconfigurationsqldatabasescontainersversion) | int | Default to 1 for Hash and 2 for MultiHash - 1 is not allowed for MultiHash. Version of the partition key definition. |

### Parameter: `cosmosDbAccountConfiguration.sqlDatabases.containers.name`

Name of the container.

- Required: Yes
- Type: string

### Parameter: `cosmosDbAccountConfiguration.sqlDatabases.containers.paths`

List of paths using which data within the container can be partitioned. For kind=MultiHash it can be up to 3. For anything else it needs to be exactly 1.

- Required: Yes
- Type: array

### Parameter: `cosmosDbAccountConfiguration.sqlDatabases.containers.analyticalStorageTtl`

Default to 0. Indicates how long data should be retained in the analytical store, for a container. Analytical store is enabled when ATTL is set with a value other than 0. If the value is set to -1, the analytical store retains all historical data, irrespective of the retention of the data in the transactional store.

- Required: No
- Type: int

### Parameter: `cosmosDbAccountConfiguration.sqlDatabases.containers.autoscaleSettingsMaxThroughput`

Specifies the Autoscale settings and represents maximum throughput, the resource can scale up to. The autoscale throughput should have valid throughput values between 1000 and 1000000 inclusive in increments of 1000. If value is set to null, then autoscale will be disabled. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the container level.

- Required: No
- Type: int
- MaxValue: 1000000

### Parameter: `cosmosDbAccountConfiguration.sqlDatabases.containers.conflictResolutionPolicy`

The conflict resolution policy for the container. Conflicts and conflict resolution policies are applicable if the Azure Cosmos DB account is configured with multiple write regions.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`mode`](#parameter-cosmosdbaccountconfigurationsqldatabasescontainersconflictresolutionpolicymode) | string | Indicates the conflict resolution mode. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`conflictResolutionPath`](#parameter-cosmosdbaccountconfigurationsqldatabasescontainersconflictresolutionpolicyconflictresolutionpath) | string | The conflict resolution path in the case of LastWriterWins mode. Required if `mode` is set to 'LastWriterWins'. |
| [`conflictResolutionProcedure`](#parameter-cosmosdbaccountconfigurationsqldatabasescontainersconflictresolutionpolicyconflictresolutionprocedure) | string | The procedure to resolve conflicts in the case of custom mode. Required if `mode` is set to 'Custom'. |

### Parameter: `cosmosDbAccountConfiguration.sqlDatabases.containers.conflictResolutionPolicy.mode`

Indicates the conflict resolution mode.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Custom'
    'LastWriterWins'
  ]
  ```

### Parameter: `cosmosDbAccountConfiguration.sqlDatabases.containers.conflictResolutionPolicy.conflictResolutionPath`

The conflict resolution path in the case of LastWriterWins mode. Required if `mode` is set to 'LastWriterWins'.

- Required: No
- Type: string

### Parameter: `cosmosDbAccountConfiguration.sqlDatabases.containers.conflictResolutionPolicy.conflictResolutionProcedure`

The procedure to resolve conflicts in the case of custom mode. Required if `mode` is set to 'Custom'.

- Required: No
- Type: string

### Parameter: `cosmosDbAccountConfiguration.sqlDatabases.containers.defaultTtl`

Default to -1. Default time to live (in seconds). With Time to Live or TTL, Azure Cosmos DB provides the ability to delete items automatically from a container after a certain time period. If the value is set to "-1", it is equal to infinity, and items don't expire by default.

- Required: No
- Type: int
- MinValue: -1
- MaxValue: 2147483647

### Parameter: `cosmosDbAccountConfiguration.sqlDatabases.containers.indexingPolicy`

Indexing policy of the container.

- Required: No
- Type: object

### Parameter: `cosmosDbAccountConfiguration.sqlDatabases.containers.kind`

Default to Hash. Indicates the kind of algorithm used for partitioning.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Hash'
    'MultiHash'
  ]
  ```

### Parameter: `cosmosDbAccountConfiguration.sqlDatabases.containers.throughput`

Default to 400. Request Units per second. Will be ignored if autoscaleSettingsMaxThroughput is used.

- Required: No
- Type: int

### Parameter: `cosmosDbAccountConfiguration.sqlDatabases.containers.uniqueKeyPolicyKeys`

The unique key policy configuration containing a list of unique keys that enforces uniqueness constraint on documents in the collection in the Azure Cosmos DB service.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`paths`](#parameter-cosmosdbaccountconfigurationsqldatabasescontainersuniquekeypolicykeyspaths) | array | List of paths must be unique for each document in the Azure Cosmos DB service. |

### Parameter: `cosmosDbAccountConfiguration.sqlDatabases.containers.uniqueKeyPolicyKeys.paths`

List of paths must be unique for each document in the Azure Cosmos DB service.

- Required: Yes
- Type: array

### Parameter: `cosmosDbAccountConfiguration.sqlDatabases.containers.version`

Default to 1 for Hash and 2 for MultiHash - 1 is not allowed for MultiHash. Version of the partition key definition.

- Required: No
- Type: int
- Allowed:
  ```Bicep
  [
    1
    2
  ]
  ```

### Parameter: `cosmosDbAccountConfiguration.sqlDatabases.throughput`

Default to 400. Request units per second. Will be ignored if autoscaleSettingsMaxThroughput is used. Setting throughput at the database level is only recommended for development/test or when workload across all containers in the shared throughput database is uniform. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the container level and not at the database level.

- Required: No
- Type: int

### Parameter: `cosmosDbAccountConfiguration.subnetResourceId`

The resource Id of the subnet where the Cosmos DB Account private endpoint should be created.

- Required: No
- Type: string

### Parameter: `cosmosDbAccountConfiguration.tags`

The tags to set for the Cosmos DB Account resource.

- Required: No
- Type: object

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `logAnalyticsWorkspaceConfiguration`

The configuration to apply for the Multi-Agent Custom Automation Engine Log Analytics Workspace resource.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      dataRetentionInDays: 365
      enabled: true
      location: '[parameters(\'solutionLocation\')]'
      name: '[format(\'log-{0}\', parameters(\'solutionPrefix\'))]'
      sku: 'PerGB2018'
      tags: '[parameters(\'tags\')]'
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataRetentionInDays`](#parameter-loganalyticsworkspaceconfigurationdataretentionindays) | int | The number of days to retain the data in the Log Analytics Workspace. If empty, it will be set to 365 days. |
| [`enabled`](#parameter-loganalyticsworkspaceconfigurationenabled) | bool | If the Log Analytics Workspace resource should be deployed or not. |
| [`location`](#parameter-loganalyticsworkspaceconfigurationlocation) | string | Location for the Log Analytics Workspace resource. |
| [`name`](#parameter-loganalyticsworkspaceconfigurationname) | string | The name of the Log Analytics Workspace resource. |
| [`sku`](#parameter-loganalyticsworkspaceconfigurationsku) | string | The SKU for the Log Analytics Workspace resource. |
| [`tags`](#parameter-loganalyticsworkspaceconfigurationtags) | object | The tags to for the Log Analytics Workspace resource. |

### Parameter: `logAnalyticsWorkspaceConfiguration.dataRetentionInDays`

The number of days to retain the data in the Log Analytics Workspace. If empty, it will be set to 365 days.

- Required: No
- Type: int
- MaxValue: 730

### Parameter: `logAnalyticsWorkspaceConfiguration.enabled`

If the Log Analytics Workspace resource should be deployed or not.

- Required: No
- Type: bool

### Parameter: `logAnalyticsWorkspaceConfiguration.location`

Location for the Log Analytics Workspace resource.

- Required: No
- Type: string

### Parameter: `logAnalyticsWorkspaceConfiguration.name`

The name of the Log Analytics Workspace resource.

- Required: No
- Type: string

### Parameter: `logAnalyticsWorkspaceConfiguration.sku`

The SKU for the Log Analytics Workspace resource.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'CapacityReservation'
    'Free'
    'LACluster'
    'PerGB2018'
    'PerNode'
    'Premium'
    'Standalone'
    'Standard'
  ]
  ```

### Parameter: `logAnalyticsWorkspaceConfiguration.tags`

The tags to for the Log Analytics Workspace resource.

- Required: No
- Type: object

### Parameter: `networkSecurityGroupAdministrationConfiguration`

The configuration to apply for the Multi-Agent Custom Automation Engine Network Security Group resource for the administration subnet.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      enabled: true
      location: '[parameters(\'solutionLocation\')]'
      name: '[format(\'nsg-administration-{0}\', parameters(\'solutionPrefix\'))]'
      securityRules: null
      tags: '[parameters(\'tags\')]'
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-networksecuritygroupadministrationconfigurationenabled) | bool | If the Network Security Group resource should be deployed or not. |
| [`location`](#parameter-networksecuritygroupadministrationconfigurationlocation) | string | Location for the Network Security Group resource. |
| [`name`](#parameter-networksecuritygroupadministrationconfigurationname) | string | The name of the Network Security Group resource. |
| [`securityRules`](#parameter-networksecuritygroupadministrationconfigurationsecurityrules) | array | The security rules to set for the Network Security Group resource. |
| [`tags`](#parameter-networksecuritygroupadministrationconfigurationtags) | object | The tags to set for the Network Security Group resource. |

### Parameter: `networkSecurityGroupAdministrationConfiguration.enabled`

If the Network Security Group resource should be deployed or not.

- Required: No
- Type: bool

### Parameter: `networkSecurityGroupAdministrationConfiguration.location`

Location for the Network Security Group resource.

- Required: No
- Type: string

### Parameter: `networkSecurityGroupAdministrationConfiguration.name`

The name of the Network Security Group resource.

- Required: No
- Type: string

### Parameter: `networkSecurityGroupAdministrationConfiguration.securityRules`

The security rules to set for the Network Security Group resource.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-networksecuritygroupadministrationconfigurationsecurityrulesname) | string | The name of the security rule. |
| [`properties`](#parameter-networksecuritygroupadministrationconfigurationsecurityrulesproperties) | object | The properties of the security rule. |

### Parameter: `networkSecurityGroupAdministrationConfiguration.securityRules.name`

The name of the security rule.

- Required: Yes
- Type: string

### Parameter: `networkSecurityGroupAdministrationConfiguration.securityRules.properties`

The properties of the security rule.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`access`](#parameter-networksecuritygroupadministrationconfigurationsecurityrulespropertiesaccess) | string | Whether network traffic is allowed or denied. |
| [`direction`](#parameter-networksecuritygroupadministrationconfigurationsecurityrulespropertiesdirection) | string | The direction of the rule. The direction specifies if rule will be evaluated on incoming or outgoing traffic. |
| [`priority`](#parameter-networksecuritygroupadministrationconfigurationsecurityrulespropertiespriority) | int | Required. The priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule. |
| [`protocol`](#parameter-networksecuritygroupadministrationconfigurationsecurityrulespropertiesprotocol) | string | Network protocol this rule applies to. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-networksecuritygroupadministrationconfigurationsecurityrulespropertiesdescription) | string | The description of the security rule. |
| [`destinationAddressPrefix`](#parameter-networksecuritygroupadministrationconfigurationsecurityrulespropertiesdestinationaddressprefix) | string | Optional. The destination address prefix. CIDR or destination IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used. |
| [`destinationAddressPrefixes`](#parameter-networksecuritygroupadministrationconfigurationsecurityrulespropertiesdestinationaddressprefixes) | array | The destination address prefixes. CIDR or destination IP ranges. |
| [`destinationApplicationSecurityGroupResourceIds`](#parameter-networksecuritygroupadministrationconfigurationsecurityrulespropertiesdestinationapplicationsecuritygroupresourceids) | array | The resource IDs of the application security groups specified as destination. |
| [`destinationPortRange`](#parameter-networksecuritygroupadministrationconfigurationsecurityrulespropertiesdestinationportrange) | string | The destination port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports. |
| [`destinationPortRanges`](#parameter-networksecuritygroupadministrationconfigurationsecurityrulespropertiesdestinationportranges) | array | The destination port ranges. |
| [`sourceAddressPrefix`](#parameter-networksecuritygroupadministrationconfigurationsecurityrulespropertiessourceaddressprefix) | string | The CIDR or source IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used. If this is an ingress rule, specifies where network traffic originates from. |
| [`sourceAddressPrefixes`](#parameter-networksecuritygroupadministrationconfigurationsecurityrulespropertiessourceaddressprefixes) | array | The CIDR or source IP ranges. |
| [`sourceApplicationSecurityGroupResourceIds`](#parameter-networksecuritygroupadministrationconfigurationsecurityrulespropertiessourceapplicationsecuritygroupresourceids) | array | The resource IDs of the application security groups specified as source. |
| [`sourcePortRange`](#parameter-networksecuritygroupadministrationconfigurationsecurityrulespropertiessourceportrange) | string | The source port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports. |
| [`sourcePortRanges`](#parameter-networksecuritygroupadministrationconfigurationsecurityrulespropertiessourceportranges) | array | The source port ranges. |

### Parameter: `networkSecurityGroupAdministrationConfiguration.securityRules.properties.access`

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

### Parameter: `networkSecurityGroupAdministrationConfiguration.securityRules.properties.direction`

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

### Parameter: `networkSecurityGroupAdministrationConfiguration.securityRules.properties.priority`

Required. The priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule.

- Required: Yes
- Type: int
- MinValue: 100
- MaxValue: 4096

### Parameter: `networkSecurityGroupAdministrationConfiguration.securityRules.properties.protocol`

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

### Parameter: `networkSecurityGroupAdministrationConfiguration.securityRules.properties.description`

The description of the security rule.

- Required: No
- Type: string

### Parameter: `networkSecurityGroupAdministrationConfiguration.securityRules.properties.destinationAddressPrefix`

Optional. The destination address prefix. CIDR or destination IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used.

- Required: No
- Type: string

### Parameter: `networkSecurityGroupAdministrationConfiguration.securityRules.properties.destinationAddressPrefixes`

The destination address prefixes. CIDR or destination IP ranges.

- Required: No
- Type: array

### Parameter: `networkSecurityGroupAdministrationConfiguration.securityRules.properties.destinationApplicationSecurityGroupResourceIds`

The resource IDs of the application security groups specified as destination.

- Required: No
- Type: array

### Parameter: `networkSecurityGroupAdministrationConfiguration.securityRules.properties.destinationPortRange`

The destination port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports.

- Required: No
- Type: string

### Parameter: `networkSecurityGroupAdministrationConfiguration.securityRules.properties.destinationPortRanges`

The destination port ranges.

- Required: No
- Type: array

### Parameter: `networkSecurityGroupAdministrationConfiguration.securityRules.properties.sourceAddressPrefix`

The CIDR or source IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used. If this is an ingress rule, specifies where network traffic originates from.

- Required: No
- Type: string

### Parameter: `networkSecurityGroupAdministrationConfiguration.securityRules.properties.sourceAddressPrefixes`

The CIDR or source IP ranges.

- Required: No
- Type: array

### Parameter: `networkSecurityGroupAdministrationConfiguration.securityRules.properties.sourceApplicationSecurityGroupResourceIds`

The resource IDs of the application security groups specified as source.

- Required: No
- Type: array

### Parameter: `networkSecurityGroupAdministrationConfiguration.securityRules.properties.sourcePortRange`

The source port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports.

- Required: No
- Type: string

### Parameter: `networkSecurityGroupAdministrationConfiguration.securityRules.properties.sourcePortRanges`

The source port ranges.

- Required: No
- Type: array

### Parameter: `networkSecurityGroupAdministrationConfiguration.tags`

The tags to set for the Network Security Group resource.

- Required: No
- Type: object

### Parameter: `networkSecurityGroupBackendConfiguration`

The configuration to apply for the Multi-Agent Custom Automation Engine Network Security Group resource for the backend subnet.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      enabled: true
      location: '[parameters(\'solutionLocation\')]'
      name: '[format(\'nsg-backend-{0}\', parameters(\'solutionPrefix\'))]'
      securityRules: null
      tags: '[parameters(\'tags\')]'
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-networksecuritygroupbackendconfigurationenabled) | bool | If the Network Security Group resource should be deployed or not. |
| [`location`](#parameter-networksecuritygroupbackendconfigurationlocation) | string | Location for the Network Security Group resource. |
| [`name`](#parameter-networksecuritygroupbackendconfigurationname) | string | The name of the Network Security Group resource. |
| [`securityRules`](#parameter-networksecuritygroupbackendconfigurationsecurityrules) | array | The security rules to set for the Network Security Group resource. |
| [`tags`](#parameter-networksecuritygroupbackendconfigurationtags) | object | The tags to set for the Network Security Group resource. |

### Parameter: `networkSecurityGroupBackendConfiguration.enabled`

If the Network Security Group resource should be deployed or not.

- Required: No
- Type: bool

### Parameter: `networkSecurityGroupBackendConfiguration.location`

Location for the Network Security Group resource.

- Required: No
- Type: string

### Parameter: `networkSecurityGroupBackendConfiguration.name`

The name of the Network Security Group resource.

- Required: No
- Type: string

### Parameter: `networkSecurityGroupBackendConfiguration.securityRules`

The security rules to set for the Network Security Group resource.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-networksecuritygroupbackendconfigurationsecurityrulesname) | string | The name of the security rule. |
| [`properties`](#parameter-networksecuritygroupbackendconfigurationsecurityrulesproperties) | object | The properties of the security rule. |

### Parameter: `networkSecurityGroupBackendConfiguration.securityRules.name`

The name of the security rule.

- Required: Yes
- Type: string

### Parameter: `networkSecurityGroupBackendConfiguration.securityRules.properties`

The properties of the security rule.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`access`](#parameter-networksecuritygroupbackendconfigurationsecurityrulespropertiesaccess) | string | Whether network traffic is allowed or denied. |
| [`direction`](#parameter-networksecuritygroupbackendconfigurationsecurityrulespropertiesdirection) | string | The direction of the rule. The direction specifies if rule will be evaluated on incoming or outgoing traffic. |
| [`priority`](#parameter-networksecuritygroupbackendconfigurationsecurityrulespropertiespriority) | int | Required. The priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule. |
| [`protocol`](#parameter-networksecuritygroupbackendconfigurationsecurityrulespropertiesprotocol) | string | Network protocol this rule applies to. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-networksecuritygroupbackendconfigurationsecurityrulespropertiesdescription) | string | The description of the security rule. |
| [`destinationAddressPrefix`](#parameter-networksecuritygroupbackendconfigurationsecurityrulespropertiesdestinationaddressprefix) | string | Optional. The destination address prefix. CIDR or destination IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used. |
| [`destinationAddressPrefixes`](#parameter-networksecuritygroupbackendconfigurationsecurityrulespropertiesdestinationaddressprefixes) | array | The destination address prefixes. CIDR or destination IP ranges. |
| [`destinationApplicationSecurityGroupResourceIds`](#parameter-networksecuritygroupbackendconfigurationsecurityrulespropertiesdestinationapplicationsecuritygroupresourceids) | array | The resource IDs of the application security groups specified as destination. |
| [`destinationPortRange`](#parameter-networksecuritygroupbackendconfigurationsecurityrulespropertiesdestinationportrange) | string | The destination port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports. |
| [`destinationPortRanges`](#parameter-networksecuritygroupbackendconfigurationsecurityrulespropertiesdestinationportranges) | array | The destination port ranges. |
| [`sourceAddressPrefix`](#parameter-networksecuritygroupbackendconfigurationsecurityrulespropertiessourceaddressprefix) | string | The CIDR or source IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used. If this is an ingress rule, specifies where network traffic originates from. |
| [`sourceAddressPrefixes`](#parameter-networksecuritygroupbackendconfigurationsecurityrulespropertiessourceaddressprefixes) | array | The CIDR or source IP ranges. |
| [`sourceApplicationSecurityGroupResourceIds`](#parameter-networksecuritygroupbackendconfigurationsecurityrulespropertiessourceapplicationsecuritygroupresourceids) | array | The resource IDs of the application security groups specified as source. |
| [`sourcePortRange`](#parameter-networksecuritygroupbackendconfigurationsecurityrulespropertiessourceportrange) | string | The source port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports. |
| [`sourcePortRanges`](#parameter-networksecuritygroupbackendconfigurationsecurityrulespropertiessourceportranges) | array | The source port ranges. |

### Parameter: `networkSecurityGroupBackendConfiguration.securityRules.properties.access`

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

### Parameter: `networkSecurityGroupBackendConfiguration.securityRules.properties.direction`

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

### Parameter: `networkSecurityGroupBackendConfiguration.securityRules.properties.priority`

Required. The priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule.

- Required: Yes
- Type: int
- MinValue: 100
- MaxValue: 4096

### Parameter: `networkSecurityGroupBackendConfiguration.securityRules.properties.protocol`

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

### Parameter: `networkSecurityGroupBackendConfiguration.securityRules.properties.description`

The description of the security rule.

- Required: No
- Type: string

### Parameter: `networkSecurityGroupBackendConfiguration.securityRules.properties.destinationAddressPrefix`

Optional. The destination address prefix. CIDR or destination IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used.

- Required: No
- Type: string

### Parameter: `networkSecurityGroupBackendConfiguration.securityRules.properties.destinationAddressPrefixes`

The destination address prefixes. CIDR or destination IP ranges.

- Required: No
- Type: array

### Parameter: `networkSecurityGroupBackendConfiguration.securityRules.properties.destinationApplicationSecurityGroupResourceIds`

The resource IDs of the application security groups specified as destination.

- Required: No
- Type: array

### Parameter: `networkSecurityGroupBackendConfiguration.securityRules.properties.destinationPortRange`

The destination port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports.

- Required: No
- Type: string

### Parameter: `networkSecurityGroupBackendConfiguration.securityRules.properties.destinationPortRanges`

The destination port ranges.

- Required: No
- Type: array

### Parameter: `networkSecurityGroupBackendConfiguration.securityRules.properties.sourceAddressPrefix`

The CIDR or source IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used. If this is an ingress rule, specifies where network traffic originates from.

- Required: No
- Type: string

### Parameter: `networkSecurityGroupBackendConfiguration.securityRules.properties.sourceAddressPrefixes`

The CIDR or source IP ranges.

- Required: No
- Type: array

### Parameter: `networkSecurityGroupBackendConfiguration.securityRules.properties.sourceApplicationSecurityGroupResourceIds`

The resource IDs of the application security groups specified as source.

- Required: No
- Type: array

### Parameter: `networkSecurityGroupBackendConfiguration.securityRules.properties.sourcePortRange`

The source port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports.

- Required: No
- Type: string

### Parameter: `networkSecurityGroupBackendConfiguration.securityRules.properties.sourcePortRanges`

The source port ranges.

- Required: No
- Type: array

### Parameter: `networkSecurityGroupBackendConfiguration.tags`

The tags to set for the Network Security Group resource.

- Required: No
- Type: object

### Parameter: `networkSecurityGroupBastionConfiguration`

The configuration to apply for the Multi-Agent Custom Automation Engine Network Security Group resource for the Bastion subnet.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      enabled: true
      location: '[parameters(\'solutionLocation\')]'
      name: '[format(\'nsg-bastion-{0}\', parameters(\'solutionPrefix\'))]'
      securityRules: null
      tags: '[parameters(\'tags\')]'
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-networksecuritygroupbastionconfigurationenabled) | bool | If the Network Security Group resource should be deployed or not. |
| [`location`](#parameter-networksecuritygroupbastionconfigurationlocation) | string | Location for the Network Security Group resource. |
| [`name`](#parameter-networksecuritygroupbastionconfigurationname) | string | The name of the Network Security Group resource. |
| [`securityRules`](#parameter-networksecuritygroupbastionconfigurationsecurityrules) | array | The security rules to set for the Network Security Group resource. |
| [`tags`](#parameter-networksecuritygroupbastionconfigurationtags) | object | The tags to set for the Network Security Group resource. |

### Parameter: `networkSecurityGroupBastionConfiguration.enabled`

If the Network Security Group resource should be deployed or not.

- Required: No
- Type: bool

### Parameter: `networkSecurityGroupBastionConfiguration.location`

Location for the Network Security Group resource.

- Required: No
- Type: string

### Parameter: `networkSecurityGroupBastionConfiguration.name`

The name of the Network Security Group resource.

- Required: No
- Type: string

### Parameter: `networkSecurityGroupBastionConfiguration.securityRules`

The security rules to set for the Network Security Group resource.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-networksecuritygroupbastionconfigurationsecurityrulesname) | string | The name of the security rule. |
| [`properties`](#parameter-networksecuritygroupbastionconfigurationsecurityrulesproperties) | object | The properties of the security rule. |

### Parameter: `networkSecurityGroupBastionConfiguration.securityRules.name`

The name of the security rule.

- Required: Yes
- Type: string

### Parameter: `networkSecurityGroupBastionConfiguration.securityRules.properties`

The properties of the security rule.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`access`](#parameter-networksecuritygroupbastionconfigurationsecurityrulespropertiesaccess) | string | Whether network traffic is allowed or denied. |
| [`direction`](#parameter-networksecuritygroupbastionconfigurationsecurityrulespropertiesdirection) | string | The direction of the rule. The direction specifies if rule will be evaluated on incoming or outgoing traffic. |
| [`priority`](#parameter-networksecuritygroupbastionconfigurationsecurityrulespropertiespriority) | int | Required. The priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule. |
| [`protocol`](#parameter-networksecuritygroupbastionconfigurationsecurityrulespropertiesprotocol) | string | Network protocol this rule applies to. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-networksecuritygroupbastionconfigurationsecurityrulespropertiesdescription) | string | The description of the security rule. |
| [`destinationAddressPrefix`](#parameter-networksecuritygroupbastionconfigurationsecurityrulespropertiesdestinationaddressprefix) | string | Optional. The destination address prefix. CIDR or destination IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used. |
| [`destinationAddressPrefixes`](#parameter-networksecuritygroupbastionconfigurationsecurityrulespropertiesdestinationaddressprefixes) | array | The destination address prefixes. CIDR or destination IP ranges. |
| [`destinationApplicationSecurityGroupResourceIds`](#parameter-networksecuritygroupbastionconfigurationsecurityrulespropertiesdestinationapplicationsecuritygroupresourceids) | array | The resource IDs of the application security groups specified as destination. |
| [`destinationPortRange`](#parameter-networksecuritygroupbastionconfigurationsecurityrulespropertiesdestinationportrange) | string | The destination port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports. |
| [`destinationPortRanges`](#parameter-networksecuritygroupbastionconfigurationsecurityrulespropertiesdestinationportranges) | array | The destination port ranges. |
| [`sourceAddressPrefix`](#parameter-networksecuritygroupbastionconfigurationsecurityrulespropertiessourceaddressprefix) | string | The CIDR or source IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used. If this is an ingress rule, specifies where network traffic originates from. |
| [`sourceAddressPrefixes`](#parameter-networksecuritygroupbastionconfigurationsecurityrulespropertiessourceaddressprefixes) | array | The CIDR or source IP ranges. |
| [`sourceApplicationSecurityGroupResourceIds`](#parameter-networksecuritygroupbastionconfigurationsecurityrulespropertiessourceapplicationsecuritygroupresourceids) | array | The resource IDs of the application security groups specified as source. |
| [`sourcePortRange`](#parameter-networksecuritygroupbastionconfigurationsecurityrulespropertiessourceportrange) | string | The source port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports. |
| [`sourcePortRanges`](#parameter-networksecuritygroupbastionconfigurationsecurityrulespropertiessourceportranges) | array | The source port ranges. |

### Parameter: `networkSecurityGroupBastionConfiguration.securityRules.properties.access`

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

### Parameter: `networkSecurityGroupBastionConfiguration.securityRules.properties.direction`

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

### Parameter: `networkSecurityGroupBastionConfiguration.securityRules.properties.priority`

Required. The priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule.

- Required: Yes
- Type: int
- MinValue: 100
- MaxValue: 4096

### Parameter: `networkSecurityGroupBastionConfiguration.securityRules.properties.protocol`

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

### Parameter: `networkSecurityGroupBastionConfiguration.securityRules.properties.description`

The description of the security rule.

- Required: No
- Type: string

### Parameter: `networkSecurityGroupBastionConfiguration.securityRules.properties.destinationAddressPrefix`

Optional. The destination address prefix. CIDR or destination IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used.

- Required: No
- Type: string

### Parameter: `networkSecurityGroupBastionConfiguration.securityRules.properties.destinationAddressPrefixes`

The destination address prefixes. CIDR or destination IP ranges.

- Required: No
- Type: array

### Parameter: `networkSecurityGroupBastionConfiguration.securityRules.properties.destinationApplicationSecurityGroupResourceIds`

The resource IDs of the application security groups specified as destination.

- Required: No
- Type: array

### Parameter: `networkSecurityGroupBastionConfiguration.securityRules.properties.destinationPortRange`

The destination port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports.

- Required: No
- Type: string

### Parameter: `networkSecurityGroupBastionConfiguration.securityRules.properties.destinationPortRanges`

The destination port ranges.

- Required: No
- Type: array

### Parameter: `networkSecurityGroupBastionConfiguration.securityRules.properties.sourceAddressPrefix`

The CIDR or source IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used. If this is an ingress rule, specifies where network traffic originates from.

- Required: No
- Type: string

### Parameter: `networkSecurityGroupBastionConfiguration.securityRules.properties.sourceAddressPrefixes`

The CIDR or source IP ranges.

- Required: No
- Type: array

### Parameter: `networkSecurityGroupBastionConfiguration.securityRules.properties.sourceApplicationSecurityGroupResourceIds`

The resource IDs of the application security groups specified as source.

- Required: No
- Type: array

### Parameter: `networkSecurityGroupBastionConfiguration.securityRules.properties.sourcePortRange`

The source port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports.

- Required: No
- Type: string

### Parameter: `networkSecurityGroupBastionConfiguration.securityRules.properties.sourcePortRanges`

The source port ranges.

- Required: No
- Type: array

### Parameter: `networkSecurityGroupBastionConfiguration.tags`

The tags to set for the Network Security Group resource.

- Required: No
- Type: object

### Parameter: `networkSecurityGroupContainersConfiguration`

The configuration to apply for the Multi-Agent Custom Automation Engine Network Security Group resource for the containers subnet.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      enabled: true
      location: '[parameters(\'solutionLocation\')]'
      name: '[format(\'nsg-containers-{0}\', parameters(\'solutionPrefix\'))]'
      securityRules: null
      tags: '[parameters(\'tags\')]'
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-networksecuritygroupcontainersconfigurationenabled) | bool | If the Network Security Group resource should be deployed or not. |
| [`location`](#parameter-networksecuritygroupcontainersconfigurationlocation) | string | Location for the Network Security Group resource. |
| [`name`](#parameter-networksecuritygroupcontainersconfigurationname) | string | The name of the Network Security Group resource. |
| [`securityRules`](#parameter-networksecuritygroupcontainersconfigurationsecurityrules) | array | The security rules to set for the Network Security Group resource. |
| [`tags`](#parameter-networksecuritygroupcontainersconfigurationtags) | object | The tags to set for the Network Security Group resource. |

### Parameter: `networkSecurityGroupContainersConfiguration.enabled`

If the Network Security Group resource should be deployed or not.

- Required: No
- Type: bool

### Parameter: `networkSecurityGroupContainersConfiguration.location`

Location for the Network Security Group resource.

- Required: No
- Type: string

### Parameter: `networkSecurityGroupContainersConfiguration.name`

The name of the Network Security Group resource.

- Required: No
- Type: string

### Parameter: `networkSecurityGroupContainersConfiguration.securityRules`

The security rules to set for the Network Security Group resource.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-networksecuritygroupcontainersconfigurationsecurityrulesname) | string | The name of the security rule. |
| [`properties`](#parameter-networksecuritygroupcontainersconfigurationsecurityrulesproperties) | object | The properties of the security rule. |

### Parameter: `networkSecurityGroupContainersConfiguration.securityRules.name`

The name of the security rule.

- Required: Yes
- Type: string

### Parameter: `networkSecurityGroupContainersConfiguration.securityRules.properties`

The properties of the security rule.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`access`](#parameter-networksecuritygroupcontainersconfigurationsecurityrulespropertiesaccess) | string | Whether network traffic is allowed or denied. |
| [`direction`](#parameter-networksecuritygroupcontainersconfigurationsecurityrulespropertiesdirection) | string | The direction of the rule. The direction specifies if rule will be evaluated on incoming or outgoing traffic. |
| [`priority`](#parameter-networksecuritygroupcontainersconfigurationsecurityrulespropertiespriority) | int | Required. The priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule. |
| [`protocol`](#parameter-networksecuritygroupcontainersconfigurationsecurityrulespropertiesprotocol) | string | Network protocol this rule applies to. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-networksecuritygroupcontainersconfigurationsecurityrulespropertiesdescription) | string | The description of the security rule. |
| [`destinationAddressPrefix`](#parameter-networksecuritygroupcontainersconfigurationsecurityrulespropertiesdestinationaddressprefix) | string | Optional. The destination address prefix. CIDR or destination IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used. |
| [`destinationAddressPrefixes`](#parameter-networksecuritygroupcontainersconfigurationsecurityrulespropertiesdestinationaddressprefixes) | array | The destination address prefixes. CIDR or destination IP ranges. |
| [`destinationApplicationSecurityGroupResourceIds`](#parameter-networksecuritygroupcontainersconfigurationsecurityrulespropertiesdestinationapplicationsecuritygroupresourceids) | array | The resource IDs of the application security groups specified as destination. |
| [`destinationPortRange`](#parameter-networksecuritygroupcontainersconfigurationsecurityrulespropertiesdestinationportrange) | string | The destination port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports. |
| [`destinationPortRanges`](#parameter-networksecuritygroupcontainersconfigurationsecurityrulespropertiesdestinationportranges) | array | The destination port ranges. |
| [`sourceAddressPrefix`](#parameter-networksecuritygroupcontainersconfigurationsecurityrulespropertiessourceaddressprefix) | string | The CIDR or source IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used. If this is an ingress rule, specifies where network traffic originates from. |
| [`sourceAddressPrefixes`](#parameter-networksecuritygroupcontainersconfigurationsecurityrulespropertiessourceaddressprefixes) | array | The CIDR or source IP ranges. |
| [`sourceApplicationSecurityGroupResourceIds`](#parameter-networksecuritygroupcontainersconfigurationsecurityrulespropertiessourceapplicationsecuritygroupresourceids) | array | The resource IDs of the application security groups specified as source. |
| [`sourcePortRange`](#parameter-networksecuritygroupcontainersconfigurationsecurityrulespropertiessourceportrange) | string | The source port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports. |
| [`sourcePortRanges`](#parameter-networksecuritygroupcontainersconfigurationsecurityrulespropertiessourceportranges) | array | The source port ranges. |

### Parameter: `networkSecurityGroupContainersConfiguration.securityRules.properties.access`

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

### Parameter: `networkSecurityGroupContainersConfiguration.securityRules.properties.direction`

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

### Parameter: `networkSecurityGroupContainersConfiguration.securityRules.properties.priority`

Required. The priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule.

- Required: Yes
- Type: int
- MinValue: 100
- MaxValue: 4096

### Parameter: `networkSecurityGroupContainersConfiguration.securityRules.properties.protocol`

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

### Parameter: `networkSecurityGroupContainersConfiguration.securityRules.properties.description`

The description of the security rule.

- Required: No
- Type: string

### Parameter: `networkSecurityGroupContainersConfiguration.securityRules.properties.destinationAddressPrefix`

Optional. The destination address prefix. CIDR or destination IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used.

- Required: No
- Type: string

### Parameter: `networkSecurityGroupContainersConfiguration.securityRules.properties.destinationAddressPrefixes`

The destination address prefixes. CIDR or destination IP ranges.

- Required: No
- Type: array

### Parameter: `networkSecurityGroupContainersConfiguration.securityRules.properties.destinationApplicationSecurityGroupResourceIds`

The resource IDs of the application security groups specified as destination.

- Required: No
- Type: array

### Parameter: `networkSecurityGroupContainersConfiguration.securityRules.properties.destinationPortRange`

The destination port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports.

- Required: No
- Type: string

### Parameter: `networkSecurityGroupContainersConfiguration.securityRules.properties.destinationPortRanges`

The destination port ranges.

- Required: No
- Type: array

### Parameter: `networkSecurityGroupContainersConfiguration.securityRules.properties.sourceAddressPrefix`

The CIDR or source IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used. If this is an ingress rule, specifies where network traffic originates from.

- Required: No
- Type: string

### Parameter: `networkSecurityGroupContainersConfiguration.securityRules.properties.sourceAddressPrefixes`

The CIDR or source IP ranges.

- Required: No
- Type: array

### Parameter: `networkSecurityGroupContainersConfiguration.securityRules.properties.sourceApplicationSecurityGroupResourceIds`

The resource IDs of the application security groups specified as source.

- Required: No
- Type: array

### Parameter: `networkSecurityGroupContainersConfiguration.securityRules.properties.sourcePortRange`

The source port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports.

- Required: No
- Type: string

### Parameter: `networkSecurityGroupContainersConfiguration.securityRules.properties.sourcePortRanges`

The source port ranges.

- Required: No
- Type: array

### Parameter: `networkSecurityGroupContainersConfiguration.tags`

The tags to set for the Network Security Group resource.

- Required: No
- Type: object

### Parameter: `solutionLocation`

Location for all Resources except AI Foundry.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `solutionPrefix`

The prefix to add in the default names given to all deployed Azure resources.

- Required: No
- Type: string
- Default: `[format('macae{0}', uniqueString(deployer().objectId, deployer().tenantId, subscription().subscriptionId, resourceGroup().id))]`

### Parameter: `tags`

The tags to apply to all deployed Azure resources.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      app: '[parameters(\'solutionPrefix\')]'
      location: '[parameters(\'solutionLocation\')]'
  }
  ```

### Parameter: `userAssignedManagedIdentityConfiguration`

The configuration to apply for the Multi-Agent Custom Automation Engine Managed Identity resource.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      enabled: true
      location: '[parameters(\'solutionLocation\')]'
      name: '[format(\'id-{0}\', parameters(\'solutionPrefix\'))]'
      tags: '[parameters(\'tags\')]'
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-userassignedmanagedidentityconfigurationenabled) | bool | If the User Assigned Managed Identity resource should be deployed or not. |
| [`location`](#parameter-userassignedmanagedidentityconfigurationlocation) | string | Location for the User Assigned Managed Identity resource. |
| [`name`](#parameter-userassignedmanagedidentityconfigurationname) | string | The name of the User Assigned Managed Identity resource. |
| [`tags`](#parameter-userassignedmanagedidentityconfigurationtags) | object | The tags to set for the User Assigned Managed Identity resource. |

### Parameter: `userAssignedManagedIdentityConfiguration.enabled`

If the User Assigned Managed Identity resource should be deployed or not.

- Required: No
- Type: bool

### Parameter: `userAssignedManagedIdentityConfiguration.location`

Location for the User Assigned Managed Identity resource.

- Required: No
- Type: string

### Parameter: `userAssignedManagedIdentityConfiguration.name`

The name of the User Assigned Managed Identity resource.

- Required: No
- Type: string

### Parameter: `userAssignedManagedIdentityConfiguration.tags`

The tags to set for the User Assigned Managed Identity resource.

- Required: No
- Type: object

### Parameter: `virtualMachineConfiguration`

Configuration for the Windows virtual machine.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      adminPassword: '[guid(parameters(\'solutionPrefix\'), subscription().subscriptionId)]'
      adminUsername: 'adminuser'
      enabled: true
      location: '[parameters(\'solutionLocation\')]'
      name: '[format(\'vm{0}\', parameters(\'solutionPrefix\'))]'
      subnetResourceId: null
      tags: '[parameters(\'tags\')]'
      vmSize: 'Standard_D2s_v3'
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`adminPassword`](#parameter-virtualmachineconfigurationadminpassword) | securestring | The password for the administrator account on the virtual machine. Required if a virtual machine is created as part of the module. |
| [`adminUsername`](#parameter-virtualmachineconfigurationadminusername) | string | The username for the administrator account on the virtual machine. Required if a virtual machine is created as part of the module. |
| [`enabled`](#parameter-virtualmachineconfigurationenabled) | bool | If the Virtual Machine resource should be deployed or not. |
| [`location`](#parameter-virtualmachineconfigurationlocation) | string | Location for the Virtual Machine resource. |
| [`name`](#parameter-virtualmachineconfigurationname) | string | The name of the Virtual Machine resource. |
| [`subnetResourceId`](#parameter-virtualmachineconfigurationsubnetresourceid) | string | The resource ID of the subnet where the Virtual Machine resource should be deployed. |
| [`tags`](#parameter-virtualmachineconfigurationtags) | object | The tags to set for the Virtual Machine resource. |
| [`vmSize`](#parameter-virtualmachineconfigurationvmsize) | string | Specifies the size for the Virtual Machine resource. |

### Parameter: `virtualMachineConfiguration.adminPassword`

The password for the administrator account on the virtual machine. Required if a virtual machine is created as part of the module.

- Required: No
- Type: securestring

### Parameter: `virtualMachineConfiguration.adminUsername`

The username for the administrator account on the virtual machine. Required if a virtual machine is created as part of the module.

- Required: No
- Type: string

### Parameter: `virtualMachineConfiguration.enabled`

If the Virtual Machine resource should be deployed or not.

- Required: No
- Type: bool

### Parameter: `virtualMachineConfiguration.location`

Location for the Virtual Machine resource.

- Required: No
- Type: string

### Parameter: `virtualMachineConfiguration.name`

The name of the Virtual Machine resource.

- Required: No
- Type: string

### Parameter: `virtualMachineConfiguration.subnetResourceId`

The resource ID of the subnet where the Virtual Machine resource should be deployed.

- Required: No
- Type: string

### Parameter: `virtualMachineConfiguration.tags`

The tags to set for the Virtual Machine resource.

- Required: No
- Type: object

### Parameter: `virtualMachineConfiguration.vmSize`

Specifies the size for the Virtual Machine resource.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Basic_A0'
    'Basic_A1'
    'Basic_A2'
    'Basic_A3'
    'Basic_A4'
    'Standard_A0'
    'Standard_A1'
    'Standard_A1_v2'
    'Standard_A10'
    'Standard_A11'
    'Standard_A2'
    'Standard_A2_v2'
    'Standard_A2m_v2'
    'Standard_A3'
    'Standard_A4'
    'Standard_A4_v2'
    'Standard_A4m_v2'
    'Standard_A5'
    'Standard_A6'
    'Standard_A7'
    'Standard_A8'
    'Standard_A8_v2'
    'Standard_A8m_v2'
    'Standard_A9'
    'Standard_B1ms'
    'Standard_B1s'
    'Standard_B2ms'
    'Standard_B2s'
    'Standard_B4ms'
    'Standard_B8ms'
    'Standard_D1'
    'Standard_D1_v2'
    'Standard_D11'
    'Standard_D11_v2'
    'Standard_D12'
    'Standard_D12_v2'
    'Standard_D13'
    'Standard_D13_v2'
    'Standard_D14'
    'Standard_D14_v2'
    'Standard_D15_v2'
    'Standard_D16_v3'
    'Standard_D16s_v3'
    'Standard_D2'
    'Standard_D2_v2'
    'Standard_D2_v3'
    'Standard_D2s_v3'
    'Standard_D3'
    'Standard_D3_v2'
    'Standard_D32_v3'
    'Standard_D32s_v3'
    'Standard_D4'
    'Standard_D4_v2'
    'Standard_D4_v3'
    'Standard_D4s_v3'
    'Standard_D5_v2'
    'Standard_D64_v3'
    'Standard_D64s_v3'
    'Standard_D8_v3'
    'Standard_D8s_v3'
    'Standard_DS1'
    'Standard_DS1_v2'
    'Standard_DS11'
    'Standard_DS11_v2'
    'Standard_DS12'
    'Standard_DS12_v2'
    'Standard_DS13'
    'Standard_DS13_v2'
    'Standard_DS13-2_v2'
    'Standard_DS13-4_v2'
    'Standard_DS14'
    'Standard_DS14_v2'
    'Standard_DS14-4_v2'
    'Standard_DS14-8_v2'
    'Standard_DS15_v2'
    'Standard_DS2'
    'Standard_DS2_v2'
    'Standard_DS3'
    'Standard_DS3_v2'
    'Standard_DS4'
    'Standard_DS4_v2'
    'Standard_DS5_v2'
    'Standard_E16_v3'
    'Standard_E16s_v3'
    'Standard_E2_v3'
    'Standard_E2s_v3'
    'Standard_E32_v3'
    'Standard_E32-16_v3'
    'Standard_E32-8s_v3'
    'Standard_E32s_v3'
    'Standard_E4_v3'
    'Standard_E4s_v3'
    'Standard_E64_v3'
    'Standard_E64-16s_v3'
    'Standard_E64-32s_v3'
    'Standard_E64s_v3'
    'Standard_E8_v3'
    'Standard_E8s_v3'
    'Standard_F1'
    'Standard_F16'
    'Standard_F16s'
    'Standard_F16s_v2'
    'Standard_F1s'
    'Standard_F2'
    'Standard_F2s'
    'Standard_F2s_v2'
    'Standard_F32s_v2'
    'Standard_F4'
    'Standard_F4s'
    'Standard_F4s_v2'
    'Standard_F64s_v2'
    'Standard_F72s_v2'
    'Standard_F8'
    'Standard_F8s'
    'Standard_F8s_v2'
    'Standard_G1'
    'Standard_G2'
    'Standard_G3'
    'Standard_G4'
    'Standard_G5'
    'Standard_GS1'
    'Standard_GS2'
    'Standard_GS3'
    'Standard_GS4'
    'Standard_GS4-4'
    'Standard_GS4-8'
    'Standard_GS5'
    'Standard_GS5-16'
    'Standard_GS5-8'
    'Standard_H16'
    'Standard_H16m'
    'Standard_H16mr'
    'Standard_H16r'
    'Standard_H8'
    'Standard_H8m'
    'Standard_L16s'
    'Standard_L32s'
    'Standard_L4s'
    'Standard_L8s'
    'Standard_M128-32ms'
    'Standard_M128-64ms'
    'Standard_M128ms'
    'Standard_M128s'
    'Standard_M64-16ms'
    'Standard_M64-32ms'
    'Standard_M64ms'
    'Standard_M64s'
    'Standard_NC12'
    'Standard_NC12s_v2'
    'Standard_NC12s_v3'
    'Standard_NC24'
    'Standard_NC24r'
    'Standard_NC24rs_v2'
    'Standard_NC24rs_v3'
    'Standard_NC24s_v2'
    'Standard_NC24s_v3'
    'Standard_NC6'
    'Standard_NC6s_v2'
    'Standard_NC6s_v3'
    'Standard_ND12s'
    'Standard_ND24rs'
    'Standard_ND24s'
    'Standard_ND6s'
    'Standard_NV12'
    'Standard_NV24'
    'Standard_NV6'
  ]
  ```

### Parameter: `virtualNetworkConfiguration`

The configuration to apply for the Multi-Agent Custom Automation Engine virtual network resource.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      addressPrefixes: null
      enabled: true
      location: '[parameters(\'solutionLocation\')]'
      name: '[format(\'vnet-{0}\', parameters(\'solutionPrefix\'))]'
      subnets: null
      tags: '[parameters(\'tags\')]'
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addressPrefixes`](#parameter-virtualnetworkconfigurationaddressprefixes) | array | An array of 1 or more IP Addresses prefixes for the Virtual Network resource. |
| [`enabled`](#parameter-virtualnetworkconfigurationenabled) | bool | If the Virtual Network resource should be deployed or not. |
| [`location`](#parameter-virtualnetworkconfigurationlocation) | string | Location for the Virtual Network resource. |
| [`name`](#parameter-virtualnetworkconfigurationname) | string | The name of the Virtual Network resource. |
| [`subnets`](#parameter-virtualnetworkconfigurationsubnets) | array | An array of 1 or more subnets for the Virtual Network resource. |
| [`tags`](#parameter-virtualnetworkconfigurationtags) | object | The tags to set for the Virtual Network resource. |

### Parameter: `virtualNetworkConfiguration.addressPrefixes`

An array of 1 or more IP Addresses prefixes for the Virtual Network resource.

- Required: No
- Type: array

### Parameter: `virtualNetworkConfiguration.enabled`

If the Virtual Network resource should be deployed or not.

- Required: No
- Type: bool

### Parameter: `virtualNetworkConfiguration.location`

Location for the Virtual Network resource.

- Required: No
- Type: string

### Parameter: `virtualNetworkConfiguration.name`

The name of the Virtual Network resource.

- Required: No
- Type: string

### Parameter: `virtualNetworkConfiguration.subnets`

An array of 1 or more subnets for the Virtual Network resource.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-virtualnetworkconfigurationsubnetsname) | string | The Name of the subnet resource. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addressPrefix`](#parameter-virtualnetworkconfigurationsubnetsaddressprefix) | string | The address prefix for the subnet. Required if `addressPrefixes` is empty. |
| [`addressPrefixes`](#parameter-virtualnetworkconfigurationsubnetsaddressprefixes) | array | List of address prefixes for the subnet. Required if `addressPrefix` is empty. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`applicationGatewayIPConfigurations`](#parameter-virtualnetworkconfigurationsubnetsapplicationgatewayipconfigurations) | array | Application gateway IP configurations of virtual network resource. |
| [`defaultOutboundAccess`](#parameter-virtualnetworkconfigurationsubnetsdefaultoutboundaccess) | bool | Set this property to false to disable default outbound connectivity for all VMs in the subnet. This property can only be set at the time of subnet creation and cannot be updated for an existing subnet. |
| [`delegation`](#parameter-virtualnetworkconfigurationsubnetsdelegation) | string | The delegation to enable on the subnet. |
| [`natGatewayResourceId`](#parameter-virtualnetworkconfigurationsubnetsnatgatewayresourceid) | string | The resource ID of the NAT Gateway to use for the subnet. |
| [`networkSecurityGroupResourceId`](#parameter-virtualnetworkconfigurationsubnetsnetworksecuritygroupresourceid) | string | The resource ID of the network security group to assign to the subnet. |
| [`privateEndpointNetworkPolicies`](#parameter-virtualnetworkconfigurationsubnetsprivateendpointnetworkpolicies) | string | enable or disable apply network policies on private endpoint in the subnet. |
| [`privateLinkServiceNetworkPolicies`](#parameter-virtualnetworkconfigurationsubnetsprivatelinkservicenetworkpolicies) | string | enable or disable apply network policies on private link service in the subnet. |
| [`roleAssignments`](#parameter-virtualnetworkconfigurationsubnetsroleassignments) | array | Array of role assignments to create. |
| [`routeTableResourceId`](#parameter-virtualnetworkconfigurationsubnetsroutetableresourceid) | string | The resource ID of the route table to assign to the subnet. |
| [`serviceEndpointPolicies`](#parameter-virtualnetworkconfigurationsubnetsserviceendpointpolicies) | array | An array of service endpoint policies. |
| [`serviceEndpoints`](#parameter-virtualnetworkconfigurationsubnetsserviceendpoints) | array | The service endpoints to enable on the subnet. |
| [`sharingScope`](#parameter-virtualnetworkconfigurationsubnetssharingscope) | string | Set this property to Tenant to allow sharing subnet with other subscriptions in your AAD tenant. This property can only be set if defaultOutboundAccess is set to false, both properties can only be set if subnet is empty. |

### Parameter: `virtualNetworkConfiguration.subnets.name`

The Name of the subnet resource.

- Required: Yes
- Type: string

### Parameter: `virtualNetworkConfiguration.subnets.addressPrefix`

The address prefix for the subnet. Required if `addressPrefixes` is empty.

- Required: No
- Type: string

### Parameter: `virtualNetworkConfiguration.subnets.addressPrefixes`

List of address prefixes for the subnet. Required if `addressPrefix` is empty.

- Required: No
- Type: array

### Parameter: `virtualNetworkConfiguration.subnets.applicationGatewayIPConfigurations`

Application gateway IP configurations of virtual network resource.

- Required: No
- Type: array

### Parameter: `virtualNetworkConfiguration.subnets.defaultOutboundAccess`

Set this property to false to disable default outbound connectivity for all VMs in the subnet. This property can only be set at the time of subnet creation and cannot be updated for an existing subnet.

- Required: No
- Type: bool

### Parameter: `virtualNetworkConfiguration.subnets.delegation`

The delegation to enable on the subnet.

- Required: No
- Type: string

### Parameter: `virtualNetworkConfiguration.subnets.natGatewayResourceId`

The resource ID of the NAT Gateway to use for the subnet.

- Required: No
- Type: string

### Parameter: `virtualNetworkConfiguration.subnets.networkSecurityGroupResourceId`

The resource ID of the network security group to assign to the subnet.

- Required: No
- Type: string

### Parameter: `virtualNetworkConfiguration.subnets.privateEndpointNetworkPolicies`

enable or disable apply network policies on private endpoint in the subnet.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
    'NetworkSecurityGroupEnabled'
    'RouteTableEnabled'
  ]
  ```

### Parameter: `virtualNetworkConfiguration.subnets.privateLinkServiceNetworkPolicies`

enable or disable apply network policies on private link service in the subnet.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `virtualNetworkConfiguration.subnets.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-virtualnetworkconfigurationsubnetsroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-virtualnetworkconfigurationsubnetsroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-virtualnetworkconfigurationsubnetsroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-virtualnetworkconfigurationsubnetsroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-virtualnetworkconfigurationsubnetsroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-virtualnetworkconfigurationsubnetsroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-virtualnetworkconfigurationsubnetsroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-virtualnetworkconfigurationsubnetsroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `virtualNetworkConfiguration.subnets.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `virtualNetworkConfiguration.subnets.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `virtualNetworkConfiguration.subnets.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `virtualNetworkConfiguration.subnets.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `virtualNetworkConfiguration.subnets.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `virtualNetworkConfiguration.subnets.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `virtualNetworkConfiguration.subnets.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `virtualNetworkConfiguration.subnets.roleAssignments.principalType`

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

### Parameter: `virtualNetworkConfiguration.subnets.routeTableResourceId`

The resource ID of the route table to assign to the subnet.

- Required: No
- Type: string

### Parameter: `virtualNetworkConfiguration.subnets.serviceEndpointPolicies`

An array of service endpoint policies.

- Required: No
- Type: array

### Parameter: `virtualNetworkConfiguration.subnets.serviceEndpoints`

The service endpoints to enable on the subnet.

- Required: No
- Type: array

### Parameter: `virtualNetworkConfiguration.subnets.sharingScope`

Set this property to Tenant to allow sharing subnet with other subscriptions in your AAD tenant. This property can only be set if defaultOutboundAccess is set to false, both properties can only be set if subnet is empty.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'DelegatedServices'
    'Tenant'
  ]
  ```

### Parameter: `virtualNetworkConfiguration.tags`

The tags to set for the Virtual Network resource.

- Required: No
- Type: object

### Parameter: `webServerFarmConfiguration`

The configuration to apply for the Web Server Farm resource.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      enabled: true
      location: '[parameters(\'solutionLocation\')]'
      name: '[format(\'asp-{0}\', parameters(\'solutionPrefix\'))]'
      skuCapacity: 3
      skuName: 'P1v3'
      tags: '[parameters(\'tags\')]'
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-webserverfarmconfigurationenabled) | bool | If the Web Server Farm resource should be deployed or not. |
| [`location`](#parameter-webserverfarmconfigurationlocation) | string | Location for the Web Server Farm resource. |
| [`name`](#parameter-webserverfarmconfigurationname) | string | The name of the Web Server Farm resource. |
| [`skuCapacity`](#parameter-webserverfarmconfigurationskucapacity) | int | Number of workers associated with the App Service Plan. This defaults to 3, to leverage availability zones. |
| [`skuName`](#parameter-webserverfarmconfigurationskuname) | string | The name of th SKU that will determine the tier, size and family for the Web Server Farm resource. This defaults to P1v3 to leverage availability zones. |
| [`tags`](#parameter-webserverfarmconfigurationtags) | object | The tags to set for the Web Server Farm resource. |

### Parameter: `webServerFarmConfiguration.enabled`

If the Web Server Farm resource should be deployed or not.

- Required: No
- Type: bool

### Parameter: `webServerFarmConfiguration.location`

Location for the Web Server Farm resource.

- Required: No
- Type: string

### Parameter: `webServerFarmConfiguration.name`

The name of the Web Server Farm resource.

- Required: No
- Type: string

### Parameter: `webServerFarmConfiguration.skuCapacity`

Number of workers associated with the App Service Plan. This defaults to 3, to leverage availability zones.

- Required: No
- Type: int

### Parameter: `webServerFarmConfiguration.skuName`

The name of th SKU that will determine the tier, size and family for the Web Server Farm resource. This defaults to P1v3 to leverage availability zones.

- Required: No
- Type: string

### Parameter: `webServerFarmConfiguration.tags`

The tags to set for the Web Server Farm resource.

- Required: No
- Type: object

### Parameter: `webSiteConfiguration`

The configuration to apply for the Web Server Farm resource.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      containerImageName: 'macaefrontend'
      containerImageRegistryDomain: 'biabcontainerreg.azurecr.io'
      containerImageTag: 'latest'
      containerName: 'backend'
      enabled: true
      environmentResourceId: null
      location: '[parameters(\'solutionLocation\')]'
      name: '[format(\'app-{0}\', parameters(\'solutionPrefix\'))]'
      tags: '[parameters(\'tags\')]'
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`containerImageName`](#parameter-websiteconfigurationcontainerimagename) | string | The name of the container image to be used by the Web Site. |
| [`containerImageRegistryDomain`](#parameter-websiteconfigurationcontainerimageregistrydomain) | string | The container registry domain of the container image to be used by the Web Site. Default to `biabcontainerreg.azurecr.io`. |
| [`containerImageTag`](#parameter-websiteconfigurationcontainerimagetag) | string | The tag of the container image to be used by the Web Site. |
| [`containerName`](#parameter-websiteconfigurationcontainername) | string | The name given to the Container App. |
| [`enabled`](#parameter-websiteconfigurationenabled) | bool | If the Web Site resource should be deployed or not. |
| [`environmentResourceId`](#parameter-websiteconfigurationenvironmentresourceid) | string | The resource Id of the Web Site Environment where the Web Site should be created. |
| [`location`](#parameter-websiteconfigurationlocation) | string | Location for the Web Site resource deployment. |
| [`name`](#parameter-websiteconfigurationname) | string | The name of the Web Site resource. |
| [`tags`](#parameter-websiteconfigurationtags) | object | The tags to set for the Web Site resource. |

### Parameter: `webSiteConfiguration.containerImageName`

The name of the container image to be used by the Web Site.

- Required: No
- Type: string

### Parameter: `webSiteConfiguration.containerImageRegistryDomain`

The container registry domain of the container image to be used by the Web Site. Default to `biabcontainerreg.azurecr.io`.

- Required: No
- Type: string

### Parameter: `webSiteConfiguration.containerImageTag`

The tag of the container image to be used by the Web Site.

- Required: No
- Type: string

### Parameter: `webSiteConfiguration.containerName`

The name given to the Container App.

- Required: No
- Type: string

### Parameter: `webSiteConfiguration.enabled`

If the Web Site resource should be deployed or not.

- Required: No
- Type: bool

### Parameter: `webSiteConfiguration.environmentResourceId`

The resource Id of the Web Site Environment where the Web Site should be created.

- Required: No
- Type: string

### Parameter: `webSiteConfiguration.location`

Location for the Web Site resource deployment.

- Required: No
- Type: string

### Parameter: `webSiteConfiguration.name`

The name of the Web Site resource.

- Required: No
- Type: string

### Parameter: `webSiteConfiguration.tags`

The tags to set for the Web Site resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `resourceGroupName` | string | The resource group the resources were deployed into. |
| `webSiteDefaultHostname` | string | The default url of the website to connect to the Multi-Agent Custom Automation Engine solution. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/ptn/authorization/resource-role-assignment:0.1.2` | Remote reference |
| `br/public:avm/res/app/container-app:0.17.0` | Remote reference |
| `br/public:avm/res/app/managed-environment:0.11.2` | Remote reference |
| `br/public:avm/res/cognitive-services/account:0.10.2` | Remote reference |
| `br/public:avm/res/compute/virtual-machine:0.15.0` | Remote reference |
| `br/public:avm/res/document-db/database-account:0.13.0` | Remote reference |
| `br/public:avm/res/document-db/database-account:0.15.0` | Remote reference |
| `br/public:avm/res/insights/component:0.6.0` | Remote reference |
| `br/public:avm/res/machine-learning-services/workspace:0.12.1` | Remote reference |
| `br/public:avm/res/managed-identity/user-assigned-identity:0.4.1` | Remote reference |
| `br/public:avm/res/network/bastion-host:0.6.1` | Remote reference |
| `br/public:avm/res/network/network-security-group:0.5.1` | Remote reference |
| `br/public:avm/res/network/private-dns-zone:0.7.1` | Remote reference |
| `br/public:avm/res/network/private-endpoint:0.11.0` | Remote reference |
| `br/public:avm/res/network/virtual-network:0.7.0` | Remote reference |
| `br/public:avm/res/operational-insights/workspace:0.11.2` | Remote reference |
| `br/public:avm/res/storage/storage-account:0.20.0` | Remote reference |
| `br/public:avm/res/web/serverfarm:0.4.1` | Remote reference |
| `br/public:avm/res/web/site:0.16.0` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.4.0` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
