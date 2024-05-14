# Data Factory Managed Virtual Networks `[Microsoft.DataFactory/factories/managedVirtualNetworks]`

This module deploys a Data Factory Managed Virtual Network.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Notes](#Notes)
- [Data Collection](#Data-Collection)

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

## Cross-referenced modules

_None_

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

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
