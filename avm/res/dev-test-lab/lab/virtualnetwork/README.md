# DevTest Lab Virtual Networks `[Microsoft.DevTestLab/labs/virtualnetworks]`

This module deploys a DevTest Lab Virtual Network.

Lab virtual machines must be deployed into a virtual network. This resource type allows configuring the virtual network and subnet settings used for the lab virtual machines.

You can reference the module as follows:
```bicep
module lab 'br/public:avm/res/dev-test-lab/lab/virtualnetwork:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.DevTestLab/labs/virtualnetworks` | 2018-09-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.devtestlab_labs_virtualnetworks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevTestLab/2018-09-15/labs/virtualnetworks)</li></ul> |

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
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
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

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

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

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
