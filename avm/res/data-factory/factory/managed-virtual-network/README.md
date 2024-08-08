# Data Factory Managed Virtual Networks `[Microsoft.DataFactory/factories/managedVirtualNetworks]`

This module deploys a Data Factory Managed Virtual Network.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Notes](#Notes)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DataFactory/factories/managedVirtualNetworks` | [2018-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories/managedVirtualNetworks) |
| `Microsoft.DataFactory/factories/managedVirtualNetworks/managedPrivateEndpoints` | [2018-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataFactory/2018-06-01/factories/managedVirtualNetworks/managedPrivateEndpoints) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the Managed Virtual Network. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataFactoryName`](#parameter-datafactoryname) | string | The name of the parent Azure Data Factory. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`managedPrivateEndpoints`](#parameter-managedprivateendpoints) | array | An array of managed private endpoints objects created in the Data Factory managed virtual network. |

### Parameter: `name`

The name of the Managed Virtual Network.

- Required: Yes
- Type: string

### Parameter: `dataFactoryName`

The name of the parent Azure Data Factory. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `managedPrivateEndpoints`

An array of managed private endpoints objects created in the Data Factory managed virtual network.

- Required: No
- Type: array
- Default: `[]`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Managed Virtual Network. |
| `resourceGroupName` | string | The name of the Resource Group the Managed Virtual Network was created in. |
| `resourceId` | string | The resource ID of the Managed Virtual Network. |

## Notes

### Parameter Usage: `managedPrivateEndpoints`

To use Managed Private Endpoints the following dependencies must be deployed:

- Destination private link resource must be created before and permissions allow requesting a private link connection to that resource.

<details>

<summary>Parameter JSON format</summary>

```json
"managedPrivateEndpoints": {
    "value": [
        {
            "name": "mystorageaccount-managed-privateEndpoint", // Required: The managed private endpoint resource name
            "groupId": "blob", // Required: The groupId to which the managed private endpoint is created
            "fqdns": [
                "mystorageaccount.blob.core.windows.net" // Required: Fully qualified domain names
            ],
            "privateLinkResourceId": "/subscriptions/[[subscriptionId]]/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/mystorageaccount"
            // Required: The ARM resource ID of the resource to which the managed private endpoint is created.
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
managedPrivateEndpoints:  [
    // Example showing all available fields
    {
        name: 'mystorageaccount-managed-privateEndpoint' // Required: The managed private endpoint resource name
        groupId: 'blob' // Required: The groupId to which the managed private endpoint is created
        fqdns: [
          'mystorageaccount.blob.core.windows.net' // Required: Fully qualified domain names
        ]
        privateLinkResourceId: '/subscriptions/[[subscriptionId]]/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/mystorageaccount'
    } // Required: The ARM resource ID of the resource to which the managed private endpoint is created.
]
```

</details>
<p>
