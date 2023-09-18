# Key Vault Keys `[Microsoft.KeyVault/vaults/keys]`

This module deploys a Key Vault Key.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.KeyVault/vaults/keys` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/keys) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the key. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `keyVaultName` | string | The name of the parent key vault. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `attributesEnabled` | bool | `True` |  | Determines whether the object is enabled. |
| `attributesExp` | int | `-1` |  | Expiry date in seconds since 1970-01-01T00:00:00Z. For security reasons, it is recommended to set an expiration date whenever possible. |
| `attributesNbf` | int | `-1` |  | Not before date in seconds since 1970-01-01T00:00:00Z. |
| `curveName` | string | `'P-256'` | `[P-256, P-256K, P-384, P-521]` | The elliptic curve name. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via a Globally Unique Identifier (GUID). |
| `keyOps` | array | `[]` | `[decrypt, encrypt, import, sign, unwrapKey, verify, wrapKey]` | Array of JsonWebKeyOperation. |
| `keySize` | int | `-1` |  | The key size in bits. For example: 2048, 3072, or 4096 for RSA. |
| `kty` | string | `'EC'` | `[EC, EC-HSM, RSA, RSA-HSM]` | The type of the key. |
| `roleAssignments` | array | `[]` |  | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| `rotationPolicy` | object | `{object}` |  | Key rotation policy properties object. |
| `tags` | object | `{object}` |  | Resource tags. |


### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

<details>

<summary>Parameter JSON format</summary>

```json
"tags": {
    "value": {
        "Environment": "Non-Prod",
        "Contact": "test.user@testcompany.com",
        "PurchaseOrder": "1234",
        "CostCenter": "7890",
        "ServiceName": "DeploymentValidation",
        "Role": "DeploymentValidation"
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
tags: {
    Environment: 'Non-Prod'
    Contact: 'test.user@testcompany.com'
    PurchaseOrder: '1234'
    CostCenter: '7890'
    ServiceName: 'DeploymentValidation'
    Role: 'DeploymentValidation'
}
```

</details>
<p>

### Parameter Usage: `roleAssignments`

Create a role assignment for the given resource. If you want to assign a service principal / managed identity that is created in the same deployment, make sure to also specify the `'principalType'` parameter and set it to `'ServicePrincipal'`. This will ensure the role assignment waits for the principal's propagation in Azure.

<details>

<summary>Parameter JSON format</summary>

```json
"roleAssignments": {
    "value": [
        {
            "roleDefinitionIdOrName": "Reader",
            "description": "Reader Role Assignment",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
        {
            "roleDefinitionIdOrName": "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012" // object 1
            ],
            "principalType": "ServicePrincipal"
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
roleAssignments: [
    {
        roleDefinitionIdOrName: 'Reader'
        description: 'Reader Role Assignment'
        principalIds: [
            '12345678-1234-1234-1234-123456789012' // object 1
            '78945612-1234-1234-1234-123456789012' // object 2
        ]
    }
    {
        roleDefinitionIdOrName: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'
        principalIds: [
            '12345678-1234-1234-1234-123456789012' // object 1
        ]
        principalType: 'ServicePrincipal'
    }
]
```

</details>
<p>

### Parameter Usage: `rotationPolicy`

Configures a [auto-rotation policy](https://learn.microsoft.com/en-us/azure/key-vault/keys/how-to-configure-key-rotation) for the key.
Remarks:

- The times should use the ISO 8601 duration format, e.g. `P1Y` (1 year), `P2M`, (2 months), `P90D` (90 days).
- The `trigger` property of `lifetimeActions` can contain one of the following properties:
  - `timeAfterCreate` - The time duration after key creation to rotate the key. It only applies to rotate.
  - `timeBeforeExpiry` - The time duration before key expiring to rotate or notify. To use this, the key must have an expiration date configured.

<details>

<summary>Parameter JSON format</summary>

```json
"rotationPolicy": {
    "value": {
        "attributes": {
            "expiryTime": "P2Y"
        },
        "lifetimeActions": [
            {
                "trigger": {
                    "timeBeforeExpiry": "P2M"
                },
                "action": {
                    "type": "Rotate"
                }
            },
            {
                "trigger": {
                    "timeBeforeExpiry": "P30D"
                },
                "action": {
                    "type": "Notify"
                }
            }
        ]
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
rotationPolicy: {
    attributes: {
        expiryTime: 'P2Y'
    }
    lifetimeActions: [
        {
            trigger: {
                timeBeforeExpiry: 'P2M'
            }
            action: {
                type: 'Rotate'
            }
        }
        {
            trigger: {
                timeBeforeExpiry: 'P30D'
            }
            action: {
                type: 'Notify'
            }
        }
    ]
}
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the key. |
| `resourceGroupName` | string | The name of the resource group the key was created in. |
| `resourceId` | string | The resource ID of the key. |

## Cross-referenced modules

_None_
