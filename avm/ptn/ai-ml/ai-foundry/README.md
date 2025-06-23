# ai-foundry `[AiMl/AiFoundry]`

Creates an AI Foundry account and project with Standard Agent Services.

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
| `Microsoft.CognitiveServices/accounts` | [2025-04-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2025-04-01-preview/accounts) |
| `Microsoft.CognitiveServices/accounts/capabilityHosts` | [2025-04-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2025-04-01-preview/accounts/capabilityHosts) |
| `Microsoft.CognitiveServices/accounts/deployments` | [2025-04-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2025-04-01-preview/accounts/deployments) |
| `Microsoft.CognitiveServices/accounts/projects` | [2025-04-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2025-04-01-preview/accounts/projects) |
| `Microsoft.CognitiveServices/accounts/projects/capabilityHosts` | [2025-04-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2025-04-01-preview/accounts/projects/capabilityHosts) |
| `Microsoft.CognitiveServices/accounts/projects/connections` | [2025-04-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2025-04-01-preview/accounts/projects/connections) |
| `Microsoft.Compute/virtualMachines` | [2024-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2024-07-01/virtualMachines) |
| `Microsoft.Compute/virtualMachines/extensions` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2023-09-01/virtualMachines/extensions) |
| `Microsoft.ContainerRegistry/registries` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-06-01-preview/registries) |
| `Microsoft.ContainerRegistry/registries/cacheRules` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-06-01-preview/registries/cacheRules) |
| `Microsoft.ContainerRegistry/registries/credentialSets` | [2023-11-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-11-01-preview/registries/credentialSets) |
| `Microsoft.ContainerRegistry/registries/replications` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-06-01-preview/registries/replications) |
| `Microsoft.ContainerRegistry/registries/scopeMaps` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-06-01-preview/registries/scopeMaps) |
| `Microsoft.ContainerRegistry/registries/webhooks` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-06-01-preview/registries/webhooks) |
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
| `Microsoft.Insights/dataCollectionRuleAssociations` | [2023-03-11](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2023-03-11/dataCollectionRuleAssociations) |
| `Microsoft.Insights/dataCollectionRules` | [2023-03-11](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2023-03-11/dataCollectionRules) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `microsoft.insights/diagnosticSettings` | [2016-09-01](https://learn.microsoft.com/en-us/azure/templates/microsoft.insights/2016-09-01/diagnosticSettings) |
| `Microsoft.KeyVault/vaults` | [2024-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2024-11-01/vaults) |
| `Microsoft.KeyVault/vaults/accessPolicies` | [2023-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2023-07-01/vaults/accessPolicies) |
| `Microsoft.KeyVault/vaults/keys` | [2024-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2024-11-01/vaults/keys) |
| `Microsoft.KeyVault/vaults/secrets` | [2024-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2024-11-01/vaults/secrets) |
| `Microsoft.KeyVault/vaults/secrets` | [2023-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2023-07-01/vaults/secrets) |
| `Microsoft.Maintenance/configurationAssignments` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Maintenance/2023-04-01/configurationAssignments) |
| `Microsoft.Maintenance/maintenanceConfigurations` | [2023-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Maintenance/2023-10-01-preview/maintenanceConfigurations) |
| `Microsoft.Network/bastionHosts` | [2024-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-07-01/bastionHosts) |
| `Microsoft.Network/natGateways` | [2024-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-03-01/natGateways) |
| `Microsoft.Network/networkInterfaces` | [2024-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-07-01/networkInterfaces) |
| `Microsoft.Network/networkSecurityGroups` | [2024-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-03-01/networkSecurityGroups) |
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
| `Microsoft.Network/publicIPAddresses` | [2024-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-03-01/publicIPAddresses) |
| `Microsoft.Network/publicIPAddresses` | [2024-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-07-01/publicIPAddresses) |
| `Microsoft.Network/virtualNetworks` | [2024-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-03-01/virtualNetworks) |
| `Microsoft.Search/searchServices` | [2025-02-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Search/2025-02-01-preview/searchServices) |
| `Microsoft.Search/searchServices/sharedPrivateLinkResources` | [2025-02-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Search/2025-02-01-preview/searchServices/sharedPrivateLinkResources) |
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

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/ai-ml/ai-foundry:<version>`.

- [ai-foundry](#example-1-ai-foundry)
- [ai-foundry](#example-2-ai-foundry)

### Example 1: _ai-foundry_

Creates an AI Foundry account and project with Basic services.


<details>

<summary>via Bicep module</summary>

```bicep
module aiFoundry 'br/public:avm/ptn/ai-ml/ai-foundry:<version>' = {
  name: 'aiFoundryDeployment'
  params: {
    // Required parameters
    aiFoundryType: 'Basic'
    contentSafetyEnabled: false
    name: '<name>'
    vmAdminPasswordOrKey: '$tart12345'
    // Non-required parameters
    location: '<location>'
    userObjectId: '00000000-0000-0000-0000-000000000000'
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
    "aiFoundryType": {
      "value": "Basic"
    },
    "contentSafetyEnabled": {
      "value": false
    },
    "name": {
      "value": "<name>"
    },
    "vmAdminPasswordOrKey": {
      "value": "$tart12345"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "userObjectId": {
      "value": "00000000-0000-0000-0000-000000000000"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/ai-ml/ai-foundry:<version>'

// Required parameters
param aiFoundryType = 'Basic'
param contentSafetyEnabled = false
param name = '<name>'
param vmAdminPasswordOrKey = '$tart12345'
// Non-required parameters
param location = '<location>'
param userObjectId = '00000000-0000-0000-0000-000000000000'
```

</details>
<p>

### Example 2: _ai-foundry_

Creates an AI Foundry account and project with Standard Agent Services in a network.


<details>

<summary>via Bicep module</summary>

```bicep
module aiFoundry 'br/public:avm/ptn/ai-ml/ai-foundry:<version>' = {
  name: 'aiFoundryDeployment'
  params: {
    // Required parameters
    aiFoundryType: 'StandardPrivate'
    contentSafetyEnabled: true
    name: '<name>'
    vmAdminPasswordOrKey: '$tart12345'
    // Non-required parameters
    aiModelDeployments: []
    location: '<location>'
    userObjectId: '00000000-0000-0000-0000-000000000000'
    vmSize: 'Standard_DS4_v2'
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
    "aiFoundryType": {
      "value": "StandardPrivate"
    },
    "contentSafetyEnabled": {
      "value": true
    },
    "name": {
      "value": "<name>"
    },
    "vmAdminPasswordOrKey": {
      "value": "$tart12345"
    },
    // Non-required parameters
    "aiModelDeployments": {
      "value": []
    },
    "location": {
      "value": "<location>"
    },
    "userObjectId": {
      "value": "00000000-0000-0000-0000-000000000000"
    },
    "vmSize": {
      "value": "Standard_DS4_v2"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/ai-ml/ai-foundry:<version>'

// Required parameters
param aiFoundryType = 'StandardPrivate'
param contentSafetyEnabled = true
param name = '<name>'
param vmAdminPasswordOrKey = '$tart12345'
// Non-required parameters
param aiModelDeployments = []
param location = '<location>'
param userObjectId = '00000000-0000-0000-0000-000000000000'
param vmSize = 'Standard_DS4_v2'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`aiFoundryType`](#parameter-aifoundrytype) | string | Specifies the AI Foundry deployment type. Allowed values are Basic, StandardPublic, and StandardPrivate. |
| [`contentSafetyEnabled`](#parameter-contentsafetyenabled) | bool | Whether to include Azure AI Content Safety in the deployment. |
| [`name`](#parameter-name) | string | Name of the resource to create. |
| [`vmAdminPasswordOrKey`](#parameter-vmadminpasswordorkey) | securestring | Specifies the password for the jump-box virtual machine. This is necessary to provide secure access to the private VNET via a jump-box VM with Bastion. Value should be meet 3 of the following: uppercase character, lowercase character, numberic digit, special character, and NO control characters. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`aiModelDeployments`](#parameter-aimodeldeployments) | array | Specifies the OpenAI deployments to create. |
| [`allowedIpAddress`](#parameter-allowedipaddress) | string | IP address to allow access to the jump-box VM. This is necessary to provide secure access to the private VNET via a jump-box VM with Bastion. If not specified, all IP addresses are allowed. |
| [`cosmosDatabases`](#parameter-cosmosdatabases) | array | List of Cosmos DB databases to create. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`networkAcls`](#parameter-networkacls) | object | A collection of rules governing the accessibility from specific network locations. |
| [`projectName`](#parameter-projectname) | string | Name of the AI Foundry project. |
| [`tags`](#parameter-tags) | object | Specifies the resource tags for all the resources. Tag "azd-env-name" is automatically added to all resources. |
| [`userObjectId`](#parameter-userobjectid) | string | Specifies the object id of a Microsoft Entra ID user. In general, this the object id of the system administrator who deploys the Azure resources. This defaults to the deploying user. |
| [`vmAdminUsername`](#parameter-vmadminusername) | string | Specifies the name of the administrator account for the jump-box virtual machine. Defaults to "[name]vmuser". This is necessary to provide secure access to the private VNET via a jump-box VM with Bastion. |
| [`vmSize`](#parameter-vmsize) | string | Specifies the size of the jump-box Virtual Machine. |

### Parameter: `aiFoundryType`

Specifies the AI Foundry deployment type. Allowed values are Basic, StandardPublic, and StandardPrivate.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Basic'
    'StandardPrivate'
    'StandardPublic'
  ]
  ```

### Parameter: `contentSafetyEnabled`

Whether to include Azure AI Content Safety in the deployment.

- Required: Yes
- Type: bool

### Parameter: `name`

Name of the resource to create.

- Required: Yes
- Type: string

### Parameter: `vmAdminPasswordOrKey`

Specifies the password for the jump-box virtual machine. This is necessary to provide secure access to the private VNET via a jump-box VM with Bastion. Value should be meet 3 of the following: uppercase character, lowercase character, numberic digit, special character, and NO control characters.

- Required: Yes
- Type: securestring

### Parameter: `aiModelDeployments`

Specifies the OpenAI deployments to create.

- Required: No
- Type: array
- Default: `[]`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`model`](#parameter-aimodeldeploymentsmodel) | object | Properties of Cognitive Services account deployment model. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-aimodeldeploymentsname) | string | Specify the name of cognitive service account deployment. |
| [`raiPolicyName`](#parameter-aimodeldeploymentsraipolicyname) | string | The name of RAI policy. |
| [`sku`](#parameter-aimodeldeploymentssku) | object | The resource model definition representing SKU. |
| [`versionUpgradeOption`](#parameter-aimodeldeploymentsversionupgradeoption) | string | The version upgrade option. |

### Parameter: `aiModelDeployments.model`

Properties of Cognitive Services account deployment model.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`format`](#parameter-aimodeldeploymentsmodelformat) | string | The format of Cognitive Services account deployment model. |
| [`name`](#parameter-aimodeldeploymentsmodelname) | string | The name of Cognitive Services account deployment model. |
| [`version`](#parameter-aimodeldeploymentsmodelversion) | string | The version of Cognitive Services account deployment model. |

### Parameter: `aiModelDeployments.model.format`

The format of Cognitive Services account deployment model.

- Required: Yes
- Type: string

### Parameter: `aiModelDeployments.model.name`

The name of Cognitive Services account deployment model.

- Required: Yes
- Type: string

### Parameter: `aiModelDeployments.model.version`

The version of Cognitive Services account deployment model.

- Required: Yes
- Type: string

### Parameter: `aiModelDeployments.name`

Specify the name of cognitive service account deployment.

- Required: No
- Type: string

### Parameter: `aiModelDeployments.raiPolicyName`

The name of RAI policy.

- Required: No
- Type: string

### Parameter: `aiModelDeployments.sku`

The resource model definition representing SKU.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-aimodeldeploymentsskuname) | string | The name of the resource model definition representing SKU. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`capacity`](#parameter-aimodeldeploymentsskucapacity) | int | The capacity of the resource model definition representing SKU. |
| [`family`](#parameter-aimodeldeploymentsskufamily) | string | The family of the resource model definition representing SKU. |
| [`size`](#parameter-aimodeldeploymentsskusize) | string | The size of the resource model definition representing SKU. |
| [`tier`](#parameter-aimodeldeploymentsskutier) | string | The tier of the resource model definition representing SKU. |

### Parameter: `aiModelDeployments.sku.name`

The name of the resource model definition representing SKU.

- Required: Yes
- Type: string

### Parameter: `aiModelDeployments.sku.capacity`

The capacity of the resource model definition representing SKU.

- Required: No
- Type: int

### Parameter: `aiModelDeployments.sku.family`

The family of the resource model definition representing SKU.

- Required: No
- Type: string

### Parameter: `aiModelDeployments.sku.size`

The size of the resource model definition representing SKU.

- Required: No
- Type: string

### Parameter: `aiModelDeployments.sku.tier`

The tier of the resource model definition representing SKU.

- Required: No
- Type: string

### Parameter: `aiModelDeployments.versionUpgradeOption`

The version upgrade option.

- Required: No
- Type: string

### Parameter: `allowedIpAddress`

IP address to allow access to the jump-box VM. This is necessary to provide secure access to the private VNET via a jump-box VM with Bastion. If not specified, all IP addresses are allowed.

- Required: No
- Type: string
- Default: `''`

### Parameter: `cosmosDatabases`

List of Cosmos DB databases to create.

- Required: No
- Type: array
- Default: `[]`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-cosmosdatabasesname) | string | Name of the SQL database . |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoscaleSettingsMaxThroughput`](#parameter-cosmosdatabasesautoscalesettingsmaxthroughput) | int | Specifies the Autoscale settings and represents maximum throughput, the resource can scale up to. The autoscale throughput should have valid throughput values between 1000 and 1000000 inclusive in increments of 1000. If value is set to null, then autoscale will be disabled. Setting throughput at the database level is only recommended for development/test or when workload across all containers in the shared throughput database is uniform. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the container level and not at the database level. |
| [`containers`](#parameter-cosmosdatabasescontainers) | array | Array of containers to deploy in the SQL database. |
| [`throughput`](#parameter-cosmosdatabasesthroughput) | int | Default to 400. Request units per second. Will be ignored if autoscaleSettingsMaxThroughput is used. Setting throughput at the database level is only recommended for development/test or when workload across all containers in the shared throughput database is uniform. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the container level and not at the database level. |

### Parameter: `cosmosDatabases.name`

Name of the SQL database .

- Required: Yes
- Type: string

### Parameter: `cosmosDatabases.autoscaleSettingsMaxThroughput`

Specifies the Autoscale settings and represents maximum throughput, the resource can scale up to. The autoscale throughput should have valid throughput values between 1000 and 1000000 inclusive in increments of 1000. If value is set to null, then autoscale will be disabled. Setting throughput at the database level is only recommended for development/test or when workload across all containers in the shared throughput database is uniform. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the container level and not at the database level.

- Required: No
- Type: int

### Parameter: `cosmosDatabases.containers`

Array of containers to deploy in the SQL database.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-cosmosdatabasescontainersname) | string | Name of the container. |
| [`paths`](#parameter-cosmosdatabasescontainerspaths) | array | List of paths using which data within the container can be partitioned. For kind=MultiHash it can be up to 3. For anything else it needs to be exactly 1. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`analyticalStorageTtl`](#parameter-cosmosdatabasescontainersanalyticalstoragettl) | int | Default to 0. Indicates how long data should be retained in the analytical store, for a container. Analytical store is enabled when ATTL is set with a value other than 0. If the value is set to -1, the analytical store retains all historical data, irrespective of the retention of the data in the transactional store. |
| [`autoscaleSettingsMaxThroughput`](#parameter-cosmosdatabasescontainersautoscalesettingsmaxthroughput) | int | Specifies the Autoscale settings and represents maximum throughput, the resource can scale up to. The autoscale throughput should have valid throughput values between 1000 and 1000000 inclusive in increments of 1000. If value is set to null, then autoscale will be disabled. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the container level. |
| [`conflictResolutionPolicy`](#parameter-cosmosdatabasescontainersconflictresolutionpolicy) | object | The conflict resolution policy for the container. Conflicts and conflict resolution policies are applicable if the Azure Cosmos DB account is configured with multiple write regions. |
| [`defaultTtl`](#parameter-cosmosdatabasescontainersdefaultttl) | int | Default to -1. Default time to live (in seconds). With Time to Live or TTL, Azure Cosmos DB provides the ability to delete items automatically from a container after a certain time period. If the value is set to "-1", it is equal to infinity, and items don't expire by default. |
| [`indexingPolicy`](#parameter-cosmosdatabasescontainersindexingpolicy) | object | Indexing policy of the container. |
| [`kind`](#parameter-cosmosdatabasescontainerskind) | string | Default to Hash. Indicates the kind of algorithm used for partitioning. |
| [`throughput`](#parameter-cosmosdatabasescontainersthroughput) | int | Default to 400. Request Units per second. Will be ignored if autoscaleSettingsMaxThroughput is used. |
| [`uniqueKeyPolicyKeys`](#parameter-cosmosdatabasescontainersuniquekeypolicykeys) | array | The unique key policy configuration containing a list of unique keys that enforces uniqueness constraint on documents in the collection in the Azure Cosmos DB service. |
| [`version`](#parameter-cosmosdatabasescontainersversion) | int | Default to 1 for Hash and 2 for MultiHash - 1 is not allowed for MultiHash. Version of the partition key definition. |

### Parameter: `cosmosDatabases.containers.name`

Name of the container.

- Required: Yes
- Type: string

### Parameter: `cosmosDatabases.containers.paths`

List of paths using which data within the container can be partitioned. For kind=MultiHash it can be up to 3. For anything else it needs to be exactly 1.

- Required: Yes
- Type: array

### Parameter: `cosmosDatabases.containers.analyticalStorageTtl`

Default to 0. Indicates how long data should be retained in the analytical store, for a container. Analytical store is enabled when ATTL is set with a value other than 0. If the value is set to -1, the analytical store retains all historical data, irrespective of the retention of the data in the transactional store.

- Required: No
- Type: int

### Parameter: `cosmosDatabases.containers.autoscaleSettingsMaxThroughput`

Specifies the Autoscale settings and represents maximum throughput, the resource can scale up to. The autoscale throughput should have valid throughput values between 1000 and 1000000 inclusive in increments of 1000. If value is set to null, then autoscale will be disabled. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the container level.

- Required: No
- Type: int
- MaxValue: 1000000

### Parameter: `cosmosDatabases.containers.conflictResolutionPolicy`

The conflict resolution policy for the container. Conflicts and conflict resolution policies are applicable if the Azure Cosmos DB account is configured with multiple write regions.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`mode`](#parameter-cosmosdatabasescontainersconflictresolutionpolicymode) | string | Indicates the conflict resolution mode. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`conflictResolutionPath`](#parameter-cosmosdatabasescontainersconflictresolutionpolicyconflictresolutionpath) | string | The conflict resolution path in the case of LastWriterWins mode. Required if `mode` is set to 'LastWriterWins'. |
| [`conflictResolutionProcedure`](#parameter-cosmosdatabasescontainersconflictresolutionpolicyconflictresolutionprocedure) | string | The procedure to resolve conflicts in the case of custom mode. Required if `mode` is set to 'Custom'. |

### Parameter: `cosmosDatabases.containers.conflictResolutionPolicy.mode`

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

### Parameter: `cosmosDatabases.containers.conflictResolutionPolicy.conflictResolutionPath`

The conflict resolution path in the case of LastWriterWins mode. Required if `mode` is set to 'LastWriterWins'.

- Required: No
- Type: string

### Parameter: `cosmosDatabases.containers.conflictResolutionPolicy.conflictResolutionProcedure`

The procedure to resolve conflicts in the case of custom mode. Required if `mode` is set to 'Custom'.

- Required: No
- Type: string

### Parameter: `cosmosDatabases.containers.defaultTtl`

Default to -1. Default time to live (in seconds). With Time to Live or TTL, Azure Cosmos DB provides the ability to delete items automatically from a container after a certain time period. If the value is set to "-1", it is equal to infinity, and items don't expire by default.

- Required: No
- Type: int
- MinValue: -1
- MaxValue: 2147483647

### Parameter: `cosmosDatabases.containers.indexingPolicy`

Indexing policy of the container.

- Required: No
- Type: object

### Parameter: `cosmosDatabases.containers.kind`

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

### Parameter: `cosmosDatabases.containers.throughput`

Default to 400. Request Units per second. Will be ignored if autoscaleSettingsMaxThroughput is used.

- Required: No
- Type: int

### Parameter: `cosmosDatabases.containers.uniqueKeyPolicyKeys`

The unique key policy configuration containing a list of unique keys that enforces uniqueness constraint on documents in the collection in the Azure Cosmos DB service.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`paths`](#parameter-cosmosdatabasescontainersuniquekeypolicykeyspaths) | array | List of paths must be unique for each document in the Azure Cosmos DB service. |

### Parameter: `cosmosDatabases.containers.uniqueKeyPolicyKeys.paths`

List of paths must be unique for each document in the Azure Cosmos DB service.

- Required: Yes
- Type: array

### Parameter: `cosmosDatabases.containers.version`

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

### Parameter: `cosmosDatabases.throughput`

Default to 400. Request units per second. Will be ignored if autoscaleSettingsMaxThroughput is used. Setting throughput at the database level is only recommended for development/test or when workload across all containers in the shared throughput database is uniform. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the container level and not at the database level.

- Required: No
- Type: int

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location for all Resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `networkAcls`

A collection of rules governing the accessibility from specific network locations.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
  }
  ```

### Parameter: `projectName`

Name of the AI Foundry project.

- Required: No
- Type: string
- Default: `[format('{0}proj', parameters('name'))]`

### Parameter: `tags`

Specifies the resource tags for all the resources. Tag "azd-env-name" is automatically added to all resources.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `userObjectId`

Specifies the object id of a Microsoft Entra ID user. In general, this the object id of the system administrator who deploys the Azure resources. This defaults to the deploying user.

- Required: No
- Type: string
- Default: `[deployer().objectId]`

### Parameter: `vmAdminUsername`

Specifies the name of the administrator account for the jump-box virtual machine. Defaults to "[name]vmuser". This is necessary to provide secure access to the private VNET via a jump-box VM with Bastion.

- Required: No
- Type: string
- Default: `[take(format('{0}vmuser', parameters('name')), 20)]`

### Parameter: `vmSize`

Specifies the size of the jump-box Virtual Machine.

- Required: No
- Type: string
- Default: `'Standard_DS4_v2'`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `azureAiProjectName` | string | Name of the deployed Azure AI Project. |
| `azureAiSearchName` | string | Name of the deployed Azure AI Search service. |
| `azureAiServicesName` | string | Name of the deployed Azure AI Services account. |
| `azureBastionName` | string | Name of the deployed Azure Bastion host. |
| `azureContainerRegistryName` | string | Name of the deployed Azure Container Registry. |
| `azureCosmosAccountName` | string | Name of the deployed Azure Cosmos DB account. |
| `azureKeyVaultName` | string | Name of the deployed Azure Key Vault. |
| `azureStorageAccountName` | string | Name of the deployed Azure Storage Account. |
| `azureVirtualNetworkName` | string | Name of the deployed Azure Virtual Network. |
| `azureVirtualNetworkSubnetName` | string | Name of the deployed Azure Virtual Network Subnet. |
| `azureVmResourceId` | string | Resource ID of the deployed Azure VM. |
| `azureVmUsername` | string | Username for the deployed Azure VM. |
| `resourceGroupName` | string | Name of the deployed Azure Resource Group. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/cognitive-services/account:0.11.0` | Remote reference |
| `br/public:avm/res/container-registry/registry:0.9.1` | Remote reference |
| `br/public:avm/res/document-db/database-account:0.15.0` | Remote reference |
| `br/public:avm/res/key-vault/vault:0.13.0` | Remote reference |
| `br/public:avm/res/network/private-dns-zone:0.7.1` | Remote reference |
| `br/public:avm/res/search/search-service:0.10.0` | Remote reference |
| `br/public:avm/res/storage/storage-account:0.20.0` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
