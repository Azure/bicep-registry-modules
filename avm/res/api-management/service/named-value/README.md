# API Management Service Named Values `[Microsoft.ApiManagement/service/namedValues]`

This module deploys an API Management Service Named Value.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Notes](#Notes)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service/namedValues` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2022-08-01/service/namedValues) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`displayName`](#parameter-displayname) | string | Unique name of NamedValue. It may contain only letters, digits, period, dash, and underscore characters. |
| [`name`](#parameter-name) | string | Named value Name. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiManagementServiceName`](#parameter-apimanagementservicename) | string | The name of the parent API Management service. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyVault`](#parameter-keyvault) | object | KeyVault location details of the namedValue. |
| [`secret`](#parameter-secret) | bool | Determines whether the value is a secret and should be encrypted or not. Default value is false. |
| [`tags`](#parameter-tags) | array | Tags that when provided can be used to filter the NamedValue list. - string. |
| [`value`](#parameter-value) | string | Value of the NamedValue. Can contain policy expressions. It may not be empty or consist only of whitespace. This property will not be filled on 'GET' operations! Use '/listSecrets' POST request to get the value. |

### Parameter: `displayName`

Unique name of NamedValue. It may contain only letters, digits, period, dash, and underscore characters.

- Required: Yes
- Type: string

### Parameter: `name`

Named value Name.

- Required: Yes
- Type: string

### Parameter: `apiManagementServiceName`

The name of the parent API Management service. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `keyVault`

KeyVault location details of the namedValue.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `secret`

Determines whether the value is a secret and should be encrypted or not. Default value is false.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `tags`

Tags that when provided can be used to filter the NamedValue list. - string.

- Required: No
- Type: array

### Parameter: `value`

Value of the NamedValue. Can contain policy expressions. It may not be empty or consist only of whitespace. This property will not be filled on 'GET' operations! Use '/listSecrets' POST request to get the value.

- Required: No
- Type: string
- Default: `[newGuid()]`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the named value. |
| `resourceGroupName` | string | The resource group the named value was deployed into. |
| `resourceId` | string | The resource ID of the named value. |

## Notes

### Parameter Usage: `keyVault`

<details>

<summary>Parameter JSON format</summary>

```json
"keyVault": {
    "value":{
        "secretIdentifier":"Key vault secret identifier for fetching secret.",
        "identityClientId":"SystemAssignedIdentity or UserAssignedIdentity Client ID which will be used to access key vault secret."
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
keyVault: {
    secretIdentifier:'Key vault secret identifier for fetching secret.'
    identityClientId:'SystemAssignedIdentity or UserAssignedIdentity Client ID which will be used to access key vault secret.'
}
```

</details>
<p>
