# CDN Profiles Rule Sets `[Microsoft.Cdn/profiles/ruleSets]`

This module deploys a CDN Profile rule set.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Cdn/profiles/ruleSets` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2023-05-01/profiles/ruleSets) |
| `Microsoft.Cdn/profiles/ruleSets/rules` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2023-05-01/profiles/ruleSets/rules) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the rule set. |
| [`profileName`](#parameter-profilename) | string | The name of the CDN profile. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |

**Optinal parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`rules`](#parameter-rules) | array | The rules to apply to the rule set. |

### Parameter: `name`

The name of the rule set.

- Required: Yes
- Type: string

### Parameter: `profileName`

The name of the CDN profile.

- Required: Yes
- Type: string

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).

- Required: No
- Type: bool
- Default: `True`

### Parameter: `rules`

The rules to apply to the rule set.

- Required: No
- Type: array
- Default: `[]`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the rule set. |
| `resourceGroupName` | string | The name of the resource group the custom domain was created in. |
| `resourceId` | string | The resource id of the rule set. |

## Cross-referenced modules

_None_
