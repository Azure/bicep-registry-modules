# avm/ptn/authorization/role-definition `[Authorization/RoleDefinition]`

This module deploys a custom role definition to a Management Group.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleDefinitions` | [2022-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-05-01-preview/roleDefinitions) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/authorization/role-definition:<version>`.

- [Role Definition (Management Group scope) - Required Parameters](#example-1-role-definition-management-group-scope---required-parameters)
- [Role Definition (Management Group scope) - Using loadJsonContent](#example-2-role-definition-management-group-scope---using-loadjsoncontent)

### Example 1: _Role Definition (Management Group scope) - Required Parameters_

This module deploys a Role Definition at a Management Group scope using minimal parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module roleDefinition 'br/public:avm/ptn/authorization/role-definition:<version>' = {
  name: 'roleDefinitionDeployment'
  params: {
    // Required parameters
    name: 'rbac-custom-role-reader'
    // Non-required parameters
    actions: [
      '*/read'
    ]
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
    "name": {
      "value": "rbac-custom-role-reader"
    },
    // Non-required parameters
    "actions": {
      "value": [
        "*/read"
      ]
    },
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
using 'br/public:avm/ptn/authorization/role-definition:<version>'

// Required parameters
param name = 'rbac-custom-role-reader'
// Non-required parameters
param actions = [
  '*/read'
]
param location = '<location>'
```

</details>
<p>

### Example 2: _Role Definition (Management Group scope) - Using loadJsonContent_

This module deploys a Role Definition at a Management Group scope using loadJsonContent to load a custom role definition stored in a JSON file.


<details>

<summary>via Bicep module</summary>

```bicep
module roleDefinition 'br/public:avm/ptn/authorization/role-definition:<version>' = {
  name: 'roleDefinitionDeployment'
  params: {
    // Required parameters
    name: '<name>'
    // Non-required parameters
    actions: '<actions>'
    dataActions: '<dataActions>'
    description: '<description>'
    location: '<location>'
    notActions: '<notActions>'
    notDataActions: '<notDataActions>'
    roleName: '<roleName>'
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
      "value": "<name>"
    },
    // Non-required parameters
    "actions": {
      "value": "<actions>"
    },
    "dataActions": {
      "value": "<dataActions>"
    },
    "description": {
      "value": "<description>"
    },
    "location": {
      "value": "<location>"
    },
    "notActions": {
      "value": "<notActions>"
    },
    "notDataActions": {
      "value": "<notDataActions>"
    },
    "roleName": {
      "value": "<roleName>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/authorization/role-definition:<version>'

// Required parameters
param name = '<name>'
// Non-required parameters
param actions = '<actions>'
param dataActions = '<dataActions>'
param description = '<description>'
param location = '<location>'
param notActions = '<notActions>'
param notDataActions = '<notDataActions>'
param roleName = '<roleName>'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the custom role definition. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`actions`](#parameter-actions) | array | The permission actions of the custom role definition. |
| [`assignableScopes`](#parameter-assignablescopes) | array | The assignable scopes of the custom role definition. If not specified, the management group being targeted in the parameter managementGroupName will be used. |
| [`dataActions`](#parameter-dataactions) | array | The permission data actions of the custom role definition. |
| [`description`](#parameter-description) | string | The description of the custom role definition. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | The location of the telemetry deployment to be created. Default is location of deployment. |
| [`notActions`](#parameter-notactions) | array | The permission not actions of the custom role definition. |
| [`notDataActions`](#parameter-notdataactions) | array | The permission not data actions of the custom role definition. |
| [`roleName`](#parameter-rolename) | string | The display name of the custom role definition. If not specified, the name will be used. |

### Parameter: `name`

The name of the custom role definition.

- Required: Yes
- Type: string

### Parameter: `actions`

The permission actions of the custom role definition.

- Required: No
- Type: array

### Parameter: `assignableScopes`

The assignable scopes of the custom role definition. If not specified, the management group being targeted in the parameter managementGroupName will be used.

- Required: No
- Type: array

### Parameter: `dataActions`

The permission data actions of the custom role definition.

- Required: No
- Type: array

### Parameter: `description`

The description of the custom role definition.

- Required: No
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

The location of the telemetry deployment to be created. Default is location of deployment.

- Required: No
- Type: string
- Default: `[deployment().location]`

### Parameter: `notActions`

The permission not actions of the custom role definition.

- Required: No
- Type: array

### Parameter: `notDataActions`

The permission not data actions of the custom role definition.

- Required: No
- Type: array

### Parameter: `roleName`

The display name of the custom role definition. If not specified, the name will be used.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `managementGroupCustomRoleDefinitionIds` | object | An object containing the resourceId, roleDefinitionId, and displayName of the custom role definition. |
| `roleDefinitionIdName` | string | The ID/name of the custom role definition created. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
