# Security Insights Settings `[Microsoft.SecurityInsights/settings]`

This module deploys a Security Insights Setting.

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
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.SecurityInsights/settings` | [2024-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.SecurityInsights/2024-10-01-preview/settings) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/security-insights/setting:<version>`.

- [Using defaults](#example-1-using-defaults)
- [Using maximum parameters](#example-2-using-maximum-parameters)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using defaults_

This instance deploys the module with minimal required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module setting 'br/public:avm/res/security-insights/setting:<version>' = {
  name: 'settingDeployment'
  params: {
    // Required parameters
    name: 'Anomalies'
    settingsType: 'Anomalies'
    workspaceResourceId: '<workspaceResourceId>'
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
    "name": {
      "value": "Anomalies"
    },
    "settingsType": {
      "value": "Anomalies"
    },
    "workspaceResourceId": {
      "value": "<workspaceResourceId>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/security-insights/setting:<version>'

// Required parameters
param name = 'Anomalies'
param settingsType = 'Anomalies'
param workspaceResourceId = '<workspaceResourceId>'
```

</details>
<p>

### Example 2: _Using maximum parameters_

This instance deploys the module with all possible parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module setting 'br/public:avm/res/security-insights/setting:<version>' = {
  name: 'settingDeployment'
  params: {
    // Required parameters
    name: 'Anomalies'
    settingsType: 'Anomalies'
    workspaceResourceId: '<workspaceResourceId>'
    // Non-required parameters
    properties: {}
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
    "name": {
      "value": "Anomalies"
    },
    "settingsType": {
      "value": "Anomalies"
    },
    "workspaceResourceId": {
      "value": "<workspaceResourceId>"
    },
    // Non-required parameters
    "properties": {
      "value": {}
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/security-insights/setting:<version>'

// Required parameters
param name = 'Anomalies'
param settingsType = 'Anomalies'
param workspaceResourceId = '<workspaceResourceId>'
// Non-required parameters
param properties = {}
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module setting 'br/public:avm/res/security-insights/setting:<version>' = {
  name: 'settingDeployment'
  params: {
    // Required parameters
    name: 'Anomalies'
    settingsType: 'Anomalies'
    workspaceResourceId: '<workspaceResourceId>'
    // Non-required parameters
    properties: {}
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
    "name": {
      "value": "Anomalies"
    },
    "settingsType": {
      "value": "Anomalies"
    },
    "workspaceResourceId": {
      "value": "<workspaceResourceId>"
    },
    // Non-required parameters
    "properties": {
      "value": {}
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/security-insights/setting:<version>'

// Required parameters
param name = 'Anomalies'
param settingsType = 'Anomalies'
param workspaceResourceId = '<workspaceResourceId>'
// Non-required parameters
param properties = {}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Security Insights Setting. |
| [`settingsType`](#parameter-settingstype) | string | Kind of the setting. Must be one of: [Anomalies, EntityAnalytics, EyesOn, Ueba]. |
| [`workspaceResourceId`](#parameter-workspaceresourceid) | string | The resource ID of the Log Analytics workspace. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`properties`](#parameter-properties) | object | Properties for the Security Insights Setting based on kind. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |

### Parameter: `name`

Name of the Security Insights Setting.

- Required: Yes
- Type: string

### Parameter: `settingsType`

Kind of the setting. Must be one of: [Anomalies, EntityAnalytics, EyesOn, Ueba].

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Anomalies'
    'EntityAnalytics'
    'EyesOn'
    'Ueba'
  ]
  ```

### Parameter: `workspaceResourceId`

The resource ID of the Log Analytics workspace.

- Required: Yes
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `properties`

Properties for the Security Insights Setting based on kind.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Security Administrator'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-roleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-roleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-roleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `roleAssignments.principalType`

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

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the Security Insights Setting. |
| `resourceGroupName` | string | The resource group where the Security Insights Setting is deployed. |
| `resourceId` | string | The resource ID of the Security Insights Setting. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
