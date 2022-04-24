# Storage Account Management Policies `[Microsoft.Storage/storageAccounts/managementPolicies]`

This module can be used to deploy a management policies into a storage account.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Storage/storageAccounts/managementPolicies` | 2019-06-01 |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `rules` | array | The Storage Account ManagementPolicies Rules |
| `storageAccountName` | string | Name of the Storage Account. |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `name` | string | `'default'` | The name of the storage container to deploy |


### Parameter Usage: `rules`

```json
[
    {
        "enabled": true,
        "name": "retention-policy",
        "type": "Lifecycle",
        "definition": {
            "actions": {
                "baseBlob": {
                    "tierToArchive": {
                        "daysAfterModificationGreaterThan": 30
                    },
                    "delete": {
                        "daysAfterModificationGreaterThan": 1096
                    }
                },
                "snapshot": {
                    "delete": {
                        "daysAfterCreationGreaterThan": 1096
                    }
                }
            },
            "filters": {
                "blobTypes": [
                    "blockBlob"
                ]
            }
        }
    }
]
```

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed management policy |
| `resourceGroupName` | string | The resource group of the deployed management policy |
| `resourceId` | string | The resource ID of the deployed management policy |

## Template references

- [Storageaccounts/Managementpolicies](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2019-06-01/storageAccounts/managementPolicies)
