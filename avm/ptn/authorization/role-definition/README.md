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
    roleDefinition: {
      actions: [
        '*/read'
      ]
      name: 'rbac-custom-role-reader'
    }
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
    "roleDefinition": {
      "value": {
        "actions": [
          "*/read"
        ],
        "name": "rbac-custom-role-reader"
      }
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
using 'br/public:avm/ptn/authorization/role-definition:<version>'

// Required parameters
param roleDefinition = {
  actions: [
    '*/read'
  ]
  name: 'rbac-custom-role-reader'
}
// Non-required parameters
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
    roleDefinition: {
      actions: '<actions>'
      dataActions: '<dataActions>'
      description: '<description>'
      name: '<name>'
      notActions: '<notActions>'
      notDataActions: '<notDataActions>'
      roleName: '<roleName>'
    }
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
    "roleDefinition": {
      "value": {
        "actions": "<actions>",
        "dataActions": "<dataActions>",
        "description": "<description>",
        "name": "<name>",
        "notActions": "<notActions>",
        "notDataActions": "<notDataActions>",
        "roleName": "<roleName>"
      }
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
using 'br/public:avm/ptn/authorization/role-definition:<version>'

// Required parameters
param roleDefinition = {
  actions: '<actions>'
  dataActions: '<dataActions>'
  description: '<description>'
  name: '<name>'
  notActions: '<notActions>'
  notDataActions: '<notDataActions>'
  roleName: '<roleName>'
}
// Non-required parameters
param location = '<location>'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`roleDefinition`](#parameter-roledefinition) | object | Object of custom role definition to create on the management group. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | The location of the telemetry deployment to be created. Default is location of deployment. |

### Parameter: `roleDefinition`

Object of custom role definition to create on the management group.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-roledefinitionname) | string | The name of the custom role definition. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`actions`](#parameter-roledefinitionactions) | array | The permission actions of the custom role definition. |
| [`assignableScopes`](#parameter-roledefinitionassignablescopes) | array | The assignable scopes of the custom role definition. If not specified, the management group being targeted in the parameter managementGroupName will be used. |
| [`dataActions`](#parameter-roledefinitiondataactions) | array | The permission data actions of the custom role definition. |
| [`description`](#parameter-roledefinitiondescription) | string | The description of the custom role definition. |
| [`notActions`](#parameter-roledefinitionnotactions) | array | The permission not actions of the custom role definition. |
| [`notDataActions`](#parameter-roledefinitionnotdataactions) | array | The permission not data actions of the custom role definition. |
| [`roleName`](#parameter-roledefinitionrolename) | string | The display name of the custom role definition. If not specified, the name will be used. |

### Parameter: `roleDefinition.name`

The name of the custom role definition.

- Required: Yes
- Type: string

### Parameter: `roleDefinition.actions`

The permission actions of the custom role definition.

- Required: No
- Type: array

### Parameter: `roleDefinition.assignableScopes`

The assignable scopes of the custom role definition. If not specified, the management group being targeted in the parameter managementGroupName will be used.

- Required: No
- Type: array

### Parameter: `roleDefinition.dataActions`

The permission data actions of the custom role definition.

- Required: No
- Type: array

### Parameter: `roleDefinition.description`

The description of the custom role definition.

- Required: No
- Type: string

### Parameter: `roleDefinition.notActions`

The permission not actions of the custom role definition.

- Required: No
- Type: array

### Parameter: `roleDefinition.notDataActions`

The permission not data actions of the custom role definition.

- Required: No
- Type: array

### Parameter: `roleDefinition.roleName`

The display name of the custom role definition. If not specified, the name will be used.

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

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `managementGroupCustomRoleDefinitionIds` | object | An object containing the resourceId, roleDefinitionId, and displayName of the custom role definition. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
