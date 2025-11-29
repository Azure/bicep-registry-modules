# Role Assignments (Subscription scope) `[Microsoft.Authorization/roleAssignments]`

This module deploys a Role Assignment at a Subscription scope.

You can reference the module as follows:
```bicep
module roleAssignment 'br/public:avm/res/authorization/role-assignment/sub-scope:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/authorization/role-assignment/sub-scope:<version>`.

- [Using only defaults (Subscription scope)](#example-1-using-only-defaults-subscription-scope)
- [Using large parameter set (Subscription scope)](#example-2-using-large-parameter-set-subscription-scope)
- [WAF-aligned (Subscription scope)](#example-3-waf-aligned-subscription-scope)

### Example 1: _Using only defaults (Subscription scope)_

This instance deploys the module with the minimum set of required parameters.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/sub-scope.defaults]


<details>

<summary>via Bicep module</summary>

```bicep
module roleAssignment 'br/public:avm/res/authorization/role-assignment/sub-scope:<version>' = {
  params: {
    // Required parameters
    principalId: '<principalId>'
    roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
    // Non-required parameters
    principalType: 'ServicePrincipal'
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
    "principalId": {
      "value": "<principalId>"
    },
    "roleDefinitionIdOrName": {
      "value": "<roleDefinitionIdOrName>"
    },
    // Non-required parameters
    "principalType": {
      "value": "ServicePrincipal"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/authorization/role-assignment/sub-scope:<version>'

// Required parameters
param principalId = '<principalId>'
param roleDefinitionIdOrName = '<roleDefinitionIdOrName>'
// Non-required parameters
param principalType = 'ServicePrincipal'
```

</details>
<p>

### Example 2: _Using large parameter set (Subscription scope)_

This instance deploys the module with most of its features enabled.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/sub-scope.max]


<details>

<summary>via Bicep module</summary>

```bicep
module roleAssignment 'br/public:avm/res/authorization/role-assignment/sub-scope:<version>' = {
  params: {
    // Required parameters
    principalId: '<principalId>'
    roleDefinitionIdOrName: 'Reader'
    // Non-required parameters
    description: 'Role Assignment (subscription scope)'
    principalType: 'ServicePrincipal'
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
    "principalId": {
      "value": "<principalId>"
    },
    "roleDefinitionIdOrName": {
      "value": "Reader"
    },
    // Non-required parameters
    "description": {
      "value": "Role Assignment (subscription scope)"
    },
    "principalType": {
      "value": "ServicePrincipal"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/authorization/role-assignment/sub-scope:<version>'

// Required parameters
param principalId = '<principalId>'
param roleDefinitionIdOrName = 'Reader'
// Non-required parameters
param description = 'Role Assignment (subscription scope)'
param principalType = 'ServicePrincipal'
```

</details>
<p>

### Example 3: _WAF-aligned (Subscription scope)_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/sub-scope.waf-aligned]


<details>

<summary>via Bicep module</summary>

```bicep
module roleAssignment 'br/public:avm/res/authorization/role-assignment/sub-scope:<version>' = {
  params: {
    // Required parameters
    principalId: '<principalId>'
    roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
    // Non-required parameters
    principalType: 'ServicePrincipal'
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
    "principalId": {
      "value": "<principalId>"
    },
    "roleDefinitionIdOrName": {
      "value": "<roleDefinitionIdOrName>"
    },
    // Non-required parameters
    "principalType": {
      "value": "ServicePrincipal"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/authorization/role-assignment/sub-scope:<version>'

// Required parameters
param principalId = '<principalId>'
param roleDefinitionIdOrName = '<roleDefinitionIdOrName>'
// Non-required parameters
param principalType = 'ServicePrincipal'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-principalid) | string | The Principal or Object ID of the Security Principal (User, Group, Service Principal, Managed Identity). |
| [`roleDefinitionIdOrName`](#parameter-roledefinitionidorname) | string | You can provide either the display name of the role definition (must be configured in the variable `builtInRoleNames`), or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-condition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. |
| [`conditionVersion`](#parameter-conditionversion) | string | The version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-delegatedmanagedidentityresourceid) | string | ID of the delegated managed identity resource. |
| [`description`](#parameter-description) | string | The description of the role assignment. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location deployment metadata. |
| [`name`](#parameter-name) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-principaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `principalId`

The Principal or Object ID of the Security Principal (User, Group, Service Principal, Managed Identity).

- Required: Yes
- Type: string

### Parameter: `roleDefinitionIdOrName`

You can provide either the display name of the role definition (must be configured in the variable `builtInRoleNames`), or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `condition`

The conditions on the role assignment. This limits the resources it can be assigned to.

- Required: No
- Type: string

### Parameter: `conditionVersion`

The version of the condition.

- Required: No
- Type: string
- Default: `'2.0'`
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `delegatedManagedIdentityResourceId`

ID of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location deployment metadata.

- Required: No
- Type: string
- Default: `[deployment().location]`

### Parameter: `name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `principalType`

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
| `name` | string | The GUID of the Role Assignment. |
| `resourceId` | string | The resource ID of the Role Assignment. |
| `scope` | string | The scope this Role Assignment applies to. |
| `subscriptionName` | string | The name of the resource group the role assignment was applied at. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
