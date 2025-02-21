# Azd Machine Learning workspace `[Azd/MlProject]`

Create a machine learning workspace, configure the key vault access policy and assign role permissions to the machine learning instance.

**Note:** This module is not intended for broad, generic use, as it was designed to cater for the requirements of the AZD CLI product. Feature requests and bug fix requests are welcome if they support the development of the AZD CLI but may not be incorporated if they aim to make this module more generic than what it needs to be for its primary use case.

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
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.KeyVault/vaults/accessPolicies` | [2023-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2023-07-01/vaults/accessPolicies) |
| `Microsoft.MachineLearningServices/workspaces` | [2024-04-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.MachineLearningServices/2024-04-01-preview/workspaces) |
| `Microsoft.MachineLearningServices/workspaces/computes` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.MachineLearningServices/2022-10-01/workspaces/computes) |
| `Microsoft.MachineLearningServices/workspaces/connections` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.MachineLearningServices/2024-04-01/workspaces/connections) |
| `Microsoft.ManagedIdentity/userAssignedIdentities` | [2023-01-31](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2023-01-31/userAssignedIdentities) |
| `Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials` | [2023-01-31](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2023-01-31/userAssignedIdentities/federatedIdentityCredentials) |
| `Microsoft.Network/privateEndpoints` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints/privateDnsZoneGroups) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/azd/ml-project:<version>`.

- [Using only defaults](#example-1-using-only-defaults)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module mlProject 'br/public:avm/ptn/azd/ml-project:<version>' = {
  name: 'mlProjectDeployment'
  params: {
    // Required parameters
    hubResourceId: '<hubResourceId>'
    keyVaultName: '<keyVaultName>'
    name: 'mlpmin001'
    userAssignedName: 'mlpminuai001'
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
    "hubResourceId": {
      "value": "<hubResourceId>"
    },
    "keyVaultName": {
      "value": "<keyVaultName>"
    },
    "name": {
      "value": "mlpmin001"
    },
    "userAssignedName": {
      "value": "mlpminuai001"
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
using 'br/public:avm/ptn/azd/ml-project:<version>'

// Required parameters
param hubResourceId = '<hubResourceId>'
param keyVaultName = '<keyVaultName>'
param name = 'mlpmin001'
param userAssignedName = 'mlpminuai001'
// Non-required parameters
param location = '<location>'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`hubResourceId`](#parameter-hubresourceid) | string | The resource ID of the AI Studio Hub Resource where this project should be created. |
| [`keyVaultName`](#parameter-keyvaultname) | string | The name of the key vault. |
| [`name`](#parameter-name) | string | The name of the machine learning workspace. |
| [`userAssignedName`](#parameter-userassignedname) | string | The name of the user assigned identity. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`hbiWorkspace`](#parameter-hbiworkspace) | bool | The flag to signal HBI data in the workspace and reduce diagnostic data collected by the service. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`projectKind`](#parameter-projectkind) | string | The type of Azure Machine Learning workspace to create. |
| [`projectManagedIdentities`](#parameter-projectmanagedidentities) | object | The managed identity definition for the machine learning resource. At least one identity type is required. |
| [`projectSku`](#parameter-projectsku) | string | Specifies the SKU, also referred as 'edition' of the Azure Machine Learning workspace. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Whether or not public network access is allowed for this machine learning workspace. For security reasons it should be disabled. |
| [`roleDefinitionIdOrName`](#parameter-roledefinitionidorname) | array | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. Default roles: AzureML Data Scientist, Azure Machine Learning Workspace Connection Secrets Reader. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `hubResourceId`

The resource ID of the AI Studio Hub Resource where this project should be created.

- Required: Yes
- Type: string

### Parameter: `keyVaultName`

The name of the key vault.

- Required: Yes
- Type: string

### Parameter: `name`

The name of the machine learning workspace.

- Required: Yes
- Type: string

### Parameter: `userAssignedName`

The name of the user assigned identity.

- Required: Yes
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `hbiWorkspace`

The flag to signal HBI data in the workspace and reduce diagnostic data collected by the service.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `location`

Location for all Resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `projectKind`

The type of Azure Machine Learning workspace to create.

- Required: No
- Type: string
- Default: `'Project'`
- Allowed:
  ```Bicep
  [
    'Default'
    'FeatureStore'
    'Hub'
    'Project'
  ]
  ```

### Parameter: `projectManagedIdentities`

The managed identity definition for the machine learning resource. At least one identity type is required.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      systemAssigned: true
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`systemAssigned`](#parameter-projectmanagedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. Must be false if `primaryUserAssignedIdentity` is provided. |
| [`userAssignedResourceIds`](#parameter-projectmanagedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. |

### Parameter: `projectManagedIdentities.systemAssigned`

Enables system assigned managed identity on the resource. Must be false if `primaryUserAssignedIdentity` is provided.

- Required: No
- Type: bool

### Parameter: `projectManagedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource.

- Required: No
- Type: array

### Parameter: `projectSku`

Specifies the SKU, also referred as 'edition' of the Azure Machine Learning workspace.

- Required: No
- Type: string
- Default: `'Basic'`
- Allowed:
  ```Bicep
  [
    'Basic'
    'Free'
    'Premium'
    'Standard'
  ]
  ```

### Parameter: `publicNetworkAccess`

Whether or not public network access is allowed for this machine learning workspace. For security reasons it should be disabled.

- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. Default roles: AzureML Data Scientist, Azure Machine Learning Workspace Connection Secrets Reader.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    'ea01e6af-a1c1-4350-9563-ad00f8c72ec5'
    'f6c7c914-8db3-469d-8ca1-694a8f32e121'
  ]
  ```

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object
- Example:
  ```Bicep
  {
      "key1": "value1"
      "key2": "value2"
  }
  ```

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `projectName` | string | The resource name of the machine learning workspace. |
| `projectPrincipalId` | string | The principal ID of the machine learning workspace. |
| `projectResourceId` | string | The resource ID of the machine learning workspace. |
| `resourceGroupName` | string | The resource group the machine learning workspace were deployed into. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/machine-learning-services/workspace:0.7.0` | Remote reference |
| `br/public:avm/res/managed-identity/user-assigned-identity:0.4.0` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
