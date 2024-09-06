# DevTest Lab Virtual Networks `[Microsoft.DevTestLab/labs/virtualnetworks]`

This module deploys a DevTest Lab Virtual Network.

Lab virtual machines must be deployed into a virtual network. This resource type allows configuring the virtual network and subnet settings used for the lab virtual machines.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DevTestLab/labs/virtualnetworks` | [2018-09-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevTestLab/2018-09-15/labs/virtualnetworks) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`externalProviderResourceId`](#parameter-externalproviderresourceid) | string | The resource ID of the virtual network. |
| [`name`](#parameter-name) | string | The name of the virtual network. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`labName`](#parameter-labname) | string | The name of the parent lab. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowedSubnets`](#parameter-allowedsubnets) | array | The allowed subnets of the virtual network. |
| [`description`](#parameter-description) | string | The description of the virtual network. |
| [`subnetOverrides`](#parameter-subnetoverrides) | array | The subnet overrides of the virtual network. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `externalProviderResourceId`

The resource ID of the virtual network.

- Required: Yes
- Type: string

### Parameter: `name`

The name of the virtual network.

- Required: Yes
- Type: string

### Parameter: `labName`

The name of the parent lab. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `allowedSubnets`

The allowed subnets of the virtual network.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`labSubnetName`](#parameter-allowedsubnetslabsubnetname) | string | The name of the subnet as seen in the lab. |
| [`resourceId`](#parameter-allowedsubnetsresourceid) | string | The resource ID of the allowed subnet. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowPublicIp`](#parameter-allowedsubnetsallowpublicip) | string | The permission policy of the subnet for allowing public IP addresses (i.e. Allow, Deny)). |

### Parameter: `allowedSubnets.labSubnetName`

The name of the subnet as seen in the lab.

- Required: Yes
- Type: string

### Parameter: `allowedSubnets.resourceId`

The resource ID of the allowed subnet.

- Required: Yes
- Type: string

### Parameter: `allowedSubnets.allowPublicIp`

The permission policy of the subnet for allowing public IP addresses (i.e. Allow, Deny)).

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Allow'
    'Default'
    'Deny'
  ]
  ```

### Parameter: `description`

The description of the virtual network.

- Required: No
- Type: string

### Parameter: `subnetOverrides`

The subnet overrides of the virtual network.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`labSubnetName`](#parameter-subnetoverrideslabsubnetname) | string | The name given to the subnet within the lab. |
| [`resourceId`](#parameter-subnetoverridesresourceid) | string | The resource ID of the subnet. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`sharedPublicIpAddressConfiguration`](#parameter-subnetoverridessharedpublicipaddressconfiguration) | object | The permission policy of the subnet for allowing public IP addresses (i.e. Allow, Deny)). |
| [`useInVmCreationPermission`](#parameter-subnetoverridesuseinvmcreationpermission) | string | Indicates whether this subnet can be used during virtual machine creation (i.e. Allow, Deny). |
| [`usePublicIpAddressPermission`](#parameter-subnetoverridesusepublicipaddresspermission) | string | Indicates whether public IP addresses can be assigned to virtual machines on this subnet (i.e. Allow, Deny). |
| [`virtualNetworkPoolName`](#parameter-subnetoverridesvirtualnetworkpoolname) | string | The virtual network pool associated with this subnet. |

### Parameter: `subnetOverrides.labSubnetName`

The name given to the subnet within the lab.

- Required: Yes
- Type: string

### Parameter: `subnetOverrides.resourceId`

The resource ID of the subnet.

- Required: Yes
- Type: string

### Parameter: `subnetOverrides.sharedPublicIpAddressConfiguration`

The permission policy of the subnet for allowing public IP addresses (i.e. Allow, Deny)).

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowedPorts`](#parameter-subnetoverridessharedpublicipaddressconfigurationallowedports) | array | Backend ports that virtual machines on this subnet are allowed to expose. |

### Parameter: `subnetOverrides.sharedPublicIpAddressConfiguration.allowedPorts`

Backend ports that virtual machines on this subnet are allowed to expose.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`backendPort`](#parameter-subnetoverridessharedpublicipaddressconfigurationallowedportsbackendport) | int | Backend port of the target virtual machine. |
| [`transportProtocol`](#parameter-subnetoverridessharedpublicipaddressconfigurationallowedportstransportprotocol) | string | Protocol type of the port. |

### Parameter: `subnetOverrides.sharedPublicIpAddressConfiguration.allowedPorts.backendPort`

Backend port of the target virtual machine.

- Required: Yes
- Type: int

### Parameter: `subnetOverrides.sharedPublicIpAddressConfiguration.allowedPorts.transportProtocol`

Protocol type of the port.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Tcp'
    'Udp'
  ]
  ```

### Parameter: `subnetOverrides.useInVmCreationPermission`

Indicates whether this subnet can be used during virtual machine creation (i.e. Allow, Deny).

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Allow'
    'Default'
    'Deny'
  ]
  ```

### Parameter: `subnetOverrides.usePublicIpAddressPermission`

Indicates whether public IP addresses can be assigned to virtual machines on this subnet (i.e. Allow, Deny).

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Allow'
    'Default'
    'Deny'
  ]
  ```

### Parameter: `subnetOverrides.virtualNetworkPoolName`

The virtual network pool associated with this subnet.

- Required: No
- Type: string

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the lab virtual network. |
| `resourceGroupName` | string | The name of the resource group the lab virtual network was created in. |
| `resourceId` | string | The resource ID of the lab virtual network. |
