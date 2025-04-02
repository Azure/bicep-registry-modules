#  `[Alz/EmptyModulesPolicyDefinitions]`


## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/policyDefinitions` | [2025-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2025-01-01/policyDefinitions) |

## Parameters

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`managementGroupCustomPolicyDefinitions`](#parameter-managementgroupcustompolicydefinitions) | array | Policy definitions to create on the management group. |

### Parameter: `managementGroupCustomPolicyDefinitions`

Policy definitions to create on the management group.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-managementgroupcustompolicydefinitionsname) | string | Specifies the name of the policy definition. Maximum length is 128 characters for management group scope. |
| [`properties`](#parameter-managementgroupcustompolicydefinitionsproperties) | object | The properties of the policy definition. |

### Parameter: `managementGroupCustomPolicyDefinitions.name`

Specifies the name of the policy definition. Maximum length is 128 characters for management group scope.

- Required: Yes
- Type: string

### Parameter: `managementGroupCustomPolicyDefinitions.properties`

The properties of the policy definition.

- Required: Yes
- Type: object

## Outputs

_None_
