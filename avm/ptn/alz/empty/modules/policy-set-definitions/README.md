#  `[Alz/EmptyModulesPolicySetDefinitions]`


## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/policySetDefinitions` | [2025-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2025-01-01/policySetDefinitions) |

## Parameters

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`managementGroupCustomPolicySetDefinitions`](#parameter-managementgroupcustompolicysetdefinitions) | array | Policy set definitions to create on the management group. |

### Parameter: `managementGroupCustomPolicySetDefinitions`

Policy set definitions to create on the management group.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-managementgroupcustompolicysetdefinitionsname) | string | Specifies the name of the policy set definition. Maximum length is 128 characters for management group scope. |
| [`properties`](#parameter-managementgroupcustompolicysetdefinitionsproperties) | object | The properties of the policy set definition. |

### Parameter: `managementGroupCustomPolicySetDefinitions.name`

Specifies the name of the policy set definition. Maximum length is 128 characters for management group scope.

- Required: Yes
- Type: string

### Parameter: `managementGroupCustomPolicySetDefinitions.properties`

The properties of the policy set definition.

- Required: Yes
- Type: object

## Outputs

_None_
