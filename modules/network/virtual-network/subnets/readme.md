# Virtual Network Subnets `[Microsoft.Network/virtualNetworks/subnets]`

This module deploys a virtual network subnet.

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/virtualNetworks/subnets` | 2021-05-01 |

## Parameters

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `addressPrefix` | string |  |  | Required. The address prefix for the subnet. |
| `addressPrefixes` | array | `[]` |  | Optional. List of address prefixes for the subnet. |
| `applicationGatewayIpConfigurations` | array | `[]` |  | Optional. Application gateway IP configurations of virtual network resource. |
| `delegations` | array | `[]` |  | Optional. The delegations to enable on the subnet |
| `enableDefaultTelemetry` | bool | `True` |  | Optional. Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `ipAllocations` | array | `[]` |  | Optional. Array of IpAllocation which reference this subnet |
| `name` | string |  |  | Optional. The Name of the subnet resource. |
| `natGatewayId` | string |  |  | Optional. The resource ID of the NAT Gateway to use for the subnet |
| `networkSecurityGroupId` | string |  |  | Optional. The resource ID of the network security group to assign to the subnet |
| `privateEndpointNetworkPolicies` | string |  | `[Disabled, Enabled, ]` | Optional. enable or disable apply network policies on private endpoint in the subnet. |
| `privateLinkServiceNetworkPolicies` | string |  | `[Disabled, Enabled, ]` | Optional. enable or disable apply network policies on private link service in the subnet. |
| `routeTableId` | string |  |  | Optional. The resource ID of the route table to assign to the subnet |
| `serviceEndpointPolicies` | array | `[]` |  | Optional. An array of service endpoint policies. |
| `serviceEndpoints` | array | `[]` |  | Optional. The service endpoints to enable on the subnet |
| `virtualNetworkName` | string |  |  | Required. The name of the parent virtual network |

### Parameter Usage: `delegations`

```json
"delegations": [
    {
        "name": "sqlMiDel",
        "properties": {
            "serviceName": "Microsoft.Sql/managedInstances"
        }
    }
]
```

### Parameter Usage: `serviceEndpoints`

```json
"serviceEndpoints": [
    "Microsoft.EventHub",
    "Microsoft.Sql",
    "Microsoft.Storage",
    "Microsoft.KeyVault"
]
```

## Considerations

The `privateEndpointNetworkPolicies` property must be set to disabled for subnets that contain private endpoints. It confirms that NSGs rules will not apply to private endpoints (currently not supported, [reference](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-overview#limitations)). Default Value when not specified is "Enabled".


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the virtual network peering |
| `resourceGroupName` | string | The resource group the virtual network peering was deployed into |
| `resourceId` | string | The resource ID of the virtual network peering |
| `subnetAddressPrefix` | string | The address prefix for the subnet |
| `subnetAddressPrefixes` | array | List of address prefixes for the subnet |

## Template references

- [Virtualnetworks/Subnets](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Network/2021-05-01/virtualNetworks/subnets)
