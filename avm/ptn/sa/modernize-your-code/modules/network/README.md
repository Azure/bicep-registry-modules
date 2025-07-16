# Secure Virtual Network Module `[Sa/ModernizeYourCodeModulesNetwork]`

This module creates a secure Virtual Network with optional Azure Bastion Host and Jumpbox VM. It includes NSGs for each subnet and integrates with Log Analytics for monitoring.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Automanage/configurationProfileAssignments` | [2022-05-04](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Automanage/2022-05-04/configurationProfileAssignments) |
| `Microsoft.Compute/disks` | [2024-03-02](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2024-03-02/disks) |
| `Microsoft.Compute/proximityPlacementGroups` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2022-08-01/proximityPlacementGroups) |
| `Microsoft.Compute/virtualMachines` | [2024-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2024-07-01/virtualMachines) |
| `Microsoft.Compute/virtualMachines/extensions` | [2022-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2022-11-01/virtualMachines/extensions) |
| `Microsoft.DevTestLab/schedules` | [2018-09-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevTestLab/2018-09-15/schedules) |
| `Microsoft.GuestConfiguration/guestConfigurationAssignments` | [2020-06-25](https://learn.microsoft.com/en-us/azure/templates/Microsoft.GuestConfiguration/2020-06-25/guestConfigurationAssignments) |
| `Microsoft.Insights/dataCollectionRuleAssociations` | [2023-03-11](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2023-03-11/dataCollectionRuleAssociations) |
| `Microsoft.Insights/dataCollectionRules` | [2023-03-11](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2023-03-11/dataCollectionRules) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Maintenance/configurationAssignments` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Maintenance/2023-04-01/configurationAssignments) |
| `Microsoft.Maintenance/maintenanceConfigurations` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Maintenance/2023-04-01/maintenanceConfigurations) |
| `Microsoft.Network/bastionHosts` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/bastionHosts) |
| `Microsoft.Network/networkInterfaces` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/networkInterfaces) |
| `Microsoft.Network/networkSecurityGroups` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/networkSecurityGroups) |
| `Microsoft.Network/publicIPAddresses` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/publicIPAddresses) |
| `Microsoft.Network/virtualNetworks` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/virtualNetworks) |
| `Microsoft.Network/virtualNetworks/subnets` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/virtualNetworks/subnets) |
| `Microsoft.Network/virtualNetworks/virtualNetworkPeerings` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-01-01/virtualNetworks/virtualNetworkPeerings) |
| `Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2023-01-01/vaults/backupFabrics/protectionContainers/protectedItems) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addressPrefixes`](#parameter-addressprefixes) | array | Networking address prefix for the VNET. |
| [`logAnalyticsWorkSpaceResourceId`](#parameter-loganalyticsworkspaceresourceid) | securestring | Resource ID of the Log Analytics Workspace for monitoring and diagnostics. |
| [`resourcesName`](#parameter-resourcesname) | string | Name used for naming all network resources. |
| [`subnets`](#parameter-subnets) | array | Array of subnets to be created within the VNET. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`bastionConfiguration`](#parameter-bastionconfiguration) | object | Configuration for the Azure Bastion Host. Leave null to omit Bastion creation. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`jumpboxConfiguration`](#parameter-jumpboxconfiguration) | secureObject | Configuration for the Jumpbox VM. Leave null to omit Jumpbox creation. |
| [`location`](#parameter-location) | string | Azure region for all services. |
| [`tags`](#parameter-tags) | object | Tags to be applied to the resources. |

### Parameter: `addressPrefixes`

Networking address prefix for the VNET.

- Required: Yes
- Type: array

### Parameter: `logAnalyticsWorkSpaceResourceId`

Resource ID of the Log Analytics Workspace for monitoring and diagnostics.

- Required: Yes
- Type: securestring

### Parameter: `resourcesName`

Name used for naming all network resources.

- Required: Yes
- Type: string

### Parameter: `subnets`

Array of subnets to be created within the VNET.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addressPrefixes`](#parameter-subnetsaddressprefixes) | array | Prefixes for the subnet. |
| [`name`](#parameter-subnetsname) | string | The Name of the subnet resource. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`defaultOutboundAccess`](#parameter-subnetsdefaultoutboundaccess) | bool | Set this property to false to disable default outbound connectivity for all VMs in the subnet. This property can only be set at the time of subnet creation and cannot be updated for an existing subnet. |
| [`delegation`](#parameter-subnetsdelegation) | string | The delegation to enable on the subnet. |
| [`networkSecurityGroup`](#parameter-subnetsnetworksecuritygroup) | object | Network Security Group configuration for the subnet. |
| [`privateEndpointNetworkPolicies`](#parameter-subnetsprivateendpointnetworkpolicies) | string | enable or disable apply network policies on private endpoint in the subnet. |
| [`privateLinkServiceNetworkPolicies`](#parameter-subnetsprivatelinkservicenetworkpolicies) | string | Enable or disable apply network policies on private link service in the subnet. |
| [`routeTableResourceId`](#parameter-subnetsroutetableresourceid) | string | The resource ID of the route table to assign to the subnet. |
| [`serviceEndpointPolicies`](#parameter-subnetsserviceendpointpolicies) | array | An array of service endpoint policies. |
| [`serviceEndpoints`](#parameter-subnetsserviceendpoints) | array | The service endpoints to enable on the subnet. |

### Parameter: `subnets.addressPrefixes`

Prefixes for the subnet.

- Required: Yes
- Type: array

### Parameter: `subnets.name`

The Name of the subnet resource.

- Required: Yes
- Type: string

### Parameter: `subnets.defaultOutboundAccess`

Set this property to false to disable default outbound connectivity for all VMs in the subnet. This property can only be set at the time of subnet creation and cannot be updated for an existing subnet.

- Required: No
- Type: bool

### Parameter: `subnets.delegation`

The delegation to enable on the subnet.

- Required: No
- Type: string

### Parameter: `subnets.networkSecurityGroup`

Network Security Group configuration for the subnet.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-subnetsnetworksecuritygroupname) | string | The name of the network security group. |
| [`securityRules`](#parameter-subnetsnetworksecuritygroupsecurityrules) | array | The security rules for the network security group. |

### Parameter: `subnets.networkSecurityGroup.name`

The name of the network security group.

- Required: Yes
- Type: string

### Parameter: `subnets.networkSecurityGroup.securityRules`

The security rules for the network security group.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-subnetsnetworksecuritygroupsecurityrulesname) | string | The name of the security rule. |
| [`properties`](#parameter-subnetsnetworksecuritygroupsecurityrulesproperties) | object | The properties of the security rule. |

### Parameter: `subnets.networkSecurityGroup.securityRules.name`

The name of the security rule.

- Required: Yes
- Type: string

### Parameter: `subnets.networkSecurityGroup.securityRules.properties`

The properties of the security rule.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`access`](#parameter-subnetsnetworksecuritygroupsecurityrulespropertiesaccess) | string | Whether network traffic is allowed or denied. |
| [`direction`](#parameter-subnetsnetworksecuritygroupsecurityrulespropertiesdirection) | string | The direction of the rule. The direction specifies if rule will be evaluated on incoming or outgoing traffic. |
| [`priority`](#parameter-subnetsnetworksecuritygroupsecurityrulespropertiespriority) | int | Required. The priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule. |
| [`protocol`](#parameter-subnetsnetworksecuritygroupsecurityrulespropertiesprotocol) | string | Network protocol this rule applies to. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-subnetsnetworksecuritygroupsecurityrulespropertiesdescription) | string | The description of the security rule. |
| [`destinationAddressPrefix`](#parameter-subnetsnetworksecuritygroupsecurityrulespropertiesdestinationaddressprefix) | string | Optional. The destination address prefix. CIDR or destination IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used. |
| [`destinationAddressPrefixes`](#parameter-subnetsnetworksecuritygroupsecurityrulespropertiesdestinationaddressprefixes) | array | The destination address prefixes. CIDR or destination IP ranges. |
| [`destinationApplicationSecurityGroupResourceIds`](#parameter-subnetsnetworksecuritygroupsecurityrulespropertiesdestinationapplicationsecuritygroupresourceids) | array | The resource IDs of the application security groups specified as destination. |
| [`destinationPortRange`](#parameter-subnetsnetworksecuritygroupsecurityrulespropertiesdestinationportrange) | string | The destination port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports. |
| [`destinationPortRanges`](#parameter-subnetsnetworksecuritygroupsecurityrulespropertiesdestinationportranges) | array | The destination port ranges. |
| [`sourceAddressPrefix`](#parameter-subnetsnetworksecuritygroupsecurityrulespropertiessourceaddressprefix) | string | The CIDR or source IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used. If this is an ingress rule, specifies where network traffic originates from. |
| [`sourceAddressPrefixes`](#parameter-subnetsnetworksecuritygroupsecurityrulespropertiessourceaddressprefixes) | array | The CIDR or source IP ranges. |
| [`sourceApplicationSecurityGroupResourceIds`](#parameter-subnetsnetworksecuritygroupsecurityrulespropertiessourceapplicationsecuritygroupresourceids) | array | The resource IDs of the application security groups specified as source. |
| [`sourcePortRange`](#parameter-subnetsnetworksecuritygroupsecurityrulespropertiessourceportrange) | string | The source port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports. |
| [`sourcePortRanges`](#parameter-subnetsnetworksecuritygroupsecurityrulespropertiessourceportranges) | array | The source port ranges. |

### Parameter: `subnets.networkSecurityGroup.securityRules.properties.access`

Whether network traffic is allowed or denied.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Allow'
    'Deny'
  ]
  ```

### Parameter: `subnets.networkSecurityGroup.securityRules.properties.direction`

The direction of the rule. The direction specifies if rule will be evaluated on incoming or outgoing traffic.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Inbound'
    'Outbound'
  ]
  ```

### Parameter: `subnets.networkSecurityGroup.securityRules.properties.priority`

Required. The priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule.

- Required: Yes
- Type: int
- MinValue: 100
- MaxValue: 4096

### Parameter: `subnets.networkSecurityGroup.securityRules.properties.protocol`

Network protocol this rule applies to.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    '*'
    'Ah'
    'Esp'
    'Icmp'
    'Tcp'
    'Udp'
  ]
  ```

### Parameter: `subnets.networkSecurityGroup.securityRules.properties.description`

The description of the security rule.

- Required: No
- Type: string

### Parameter: `subnets.networkSecurityGroup.securityRules.properties.destinationAddressPrefix`

Optional. The destination address prefix. CIDR or destination IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used.

- Required: No
- Type: string

### Parameter: `subnets.networkSecurityGroup.securityRules.properties.destinationAddressPrefixes`

The destination address prefixes. CIDR or destination IP ranges.

- Required: No
- Type: array

### Parameter: `subnets.networkSecurityGroup.securityRules.properties.destinationApplicationSecurityGroupResourceIds`

The resource IDs of the application security groups specified as destination.

- Required: No
- Type: array

### Parameter: `subnets.networkSecurityGroup.securityRules.properties.destinationPortRange`

The destination port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports.

- Required: No
- Type: string

### Parameter: `subnets.networkSecurityGroup.securityRules.properties.destinationPortRanges`

The destination port ranges.

- Required: No
- Type: array

### Parameter: `subnets.networkSecurityGroup.securityRules.properties.sourceAddressPrefix`

The CIDR or source IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used. If this is an ingress rule, specifies where network traffic originates from.

- Required: No
- Type: string

### Parameter: `subnets.networkSecurityGroup.securityRules.properties.sourceAddressPrefixes`

The CIDR or source IP ranges.

- Required: No
- Type: array

### Parameter: `subnets.networkSecurityGroup.securityRules.properties.sourceApplicationSecurityGroupResourceIds`

The resource IDs of the application security groups specified as source.

- Required: No
- Type: array

### Parameter: `subnets.networkSecurityGroup.securityRules.properties.sourcePortRange`

The source port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports.

- Required: No
- Type: string

### Parameter: `subnets.networkSecurityGroup.securityRules.properties.sourcePortRanges`

The source port ranges.

- Required: No
- Type: array

### Parameter: `subnets.privateEndpointNetworkPolicies`

enable or disable apply network policies on private endpoint in the subnet.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
    'NetworkSecurityGroupEnabled'
    'RouteTableEnabled'
  ]
  ```

### Parameter: `subnets.privateLinkServiceNetworkPolicies`

Enable or disable apply network policies on private link service in the subnet.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `subnets.routeTableResourceId`

The resource ID of the route table to assign to the subnet.

- Required: No
- Type: string

### Parameter: `subnets.serviceEndpointPolicies`

An array of service endpoint policies.

- Required: No
- Type: array

### Parameter: `subnets.serviceEndpoints`

The service endpoints to enable on the subnet.

- Required: No
- Type: array

### Parameter: `bastionConfiguration`

Configuration for the Azure Bastion Host. Leave null to omit Bastion creation.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-bastionconfigurationname) | string | The name of the Bastion Host resource. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`subnetAddressPrefixes`](#parameter-bastionconfigurationsubnetaddressprefixes) | array | List of address prefixes for the subnet. |

### Parameter: `bastionConfiguration.name`

The name of the Bastion Host resource.

- Required: Yes
- Type: string

### Parameter: `bastionConfiguration.subnetAddressPrefixes`

List of address prefixes for the subnet.

- Required: No
- Type: array

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `jumpboxConfiguration`

Configuration for the Jumpbox VM. Leave null to omit Jumpbox creation.

- Required: No
- Type: secureObject

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-jumpboxconfigurationname) | string | The name of the Virtual Machine. |
| [`password`](#parameter-jumpboxconfigurationpassword) | securestring | Password to access VM. |
| [`username`](#parameter-jumpboxconfigurationusername) | securestring | Username to access VM. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`size`](#parameter-jumpboxconfigurationsize) | string | The size of the VM. |
| [`subnet`](#parameter-jumpboxconfigurationsubnet) | object | Subnet configuration for the Jumpbox VM. |

### Parameter: `jumpboxConfiguration.name`

The name of the Virtual Machine.

- Required: Yes
- Type: string

### Parameter: `jumpboxConfiguration.password`

Password to access VM.

- Required: Yes
- Type: securestring

### Parameter: `jumpboxConfiguration.username`

Username to access VM.

- Required: Yes
- Type: securestring

### Parameter: `jumpboxConfiguration.size`

The size of the VM.

- Required: No
- Type: string

### Parameter: `jumpboxConfiguration.subnet`

Subnet configuration for the Jumpbox VM.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addressPrefixes`](#parameter-jumpboxconfigurationsubnetaddressprefixes) | array | Prefixes for the subnet. |
| [`name`](#parameter-jumpboxconfigurationsubnetname) | string | The Name of the subnet resource. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`defaultOutboundAccess`](#parameter-jumpboxconfigurationsubnetdefaultoutboundaccess) | bool | Set this property to false to disable default outbound connectivity for all VMs in the subnet. This property can only be set at the time of subnet creation and cannot be updated for an existing subnet. |
| [`delegation`](#parameter-jumpboxconfigurationsubnetdelegation) | string | The delegation to enable on the subnet. |
| [`networkSecurityGroup`](#parameter-jumpboxconfigurationsubnetnetworksecuritygroup) | object | Network Security Group configuration for the subnet. |
| [`privateEndpointNetworkPolicies`](#parameter-jumpboxconfigurationsubnetprivateendpointnetworkpolicies) | string | enable or disable apply network policies on private endpoint in the subnet. |
| [`privateLinkServiceNetworkPolicies`](#parameter-jumpboxconfigurationsubnetprivatelinkservicenetworkpolicies) | string | Enable or disable apply network policies on private link service in the subnet. |
| [`routeTableResourceId`](#parameter-jumpboxconfigurationsubnetroutetableresourceid) | string | The resource ID of the route table to assign to the subnet. |
| [`serviceEndpointPolicies`](#parameter-jumpboxconfigurationsubnetserviceendpointpolicies) | array | An array of service endpoint policies. |
| [`serviceEndpoints`](#parameter-jumpboxconfigurationsubnetserviceendpoints) | array | The service endpoints to enable on the subnet. |

### Parameter: `jumpboxConfiguration.subnet.addressPrefixes`

Prefixes for the subnet.

- Required: Yes
- Type: array

### Parameter: `jumpboxConfiguration.subnet.name`

The Name of the subnet resource.

- Required: Yes
- Type: string

### Parameter: `jumpboxConfiguration.subnet.defaultOutboundAccess`

Set this property to false to disable default outbound connectivity for all VMs in the subnet. This property can only be set at the time of subnet creation and cannot be updated for an existing subnet.

- Required: No
- Type: bool

### Parameter: `jumpboxConfiguration.subnet.delegation`

The delegation to enable on the subnet.

- Required: No
- Type: string

### Parameter: `jumpboxConfiguration.subnet.networkSecurityGroup`

Network Security Group configuration for the subnet.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-jumpboxconfigurationsubnetnetworksecuritygroupname) | string | The name of the network security group. |
| [`securityRules`](#parameter-jumpboxconfigurationsubnetnetworksecuritygroupsecurityrules) | array | The security rules for the network security group. |

### Parameter: `jumpboxConfiguration.subnet.networkSecurityGroup.name`

The name of the network security group.

- Required: Yes
- Type: string

### Parameter: `jumpboxConfiguration.subnet.networkSecurityGroup.securityRules`

The security rules for the network security group.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-jumpboxconfigurationsubnetnetworksecuritygroupsecurityrulesname) | string | The name of the security rule. |
| [`properties`](#parameter-jumpboxconfigurationsubnetnetworksecuritygroupsecurityrulesproperties) | object | The properties of the security rule. |

### Parameter: `jumpboxConfiguration.subnet.networkSecurityGroup.securityRules.name`

The name of the security rule.

- Required: Yes
- Type: string

### Parameter: `jumpboxConfiguration.subnet.networkSecurityGroup.securityRules.properties`

The properties of the security rule.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`access`](#parameter-jumpboxconfigurationsubnetnetworksecuritygroupsecurityrulespropertiesaccess) | string | Whether network traffic is allowed or denied. |
| [`direction`](#parameter-jumpboxconfigurationsubnetnetworksecuritygroupsecurityrulespropertiesdirection) | string | The direction of the rule. The direction specifies if rule will be evaluated on incoming or outgoing traffic. |
| [`priority`](#parameter-jumpboxconfigurationsubnetnetworksecuritygroupsecurityrulespropertiespriority) | int | Required. The priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule. |
| [`protocol`](#parameter-jumpboxconfigurationsubnetnetworksecuritygroupsecurityrulespropertiesprotocol) | string | Network protocol this rule applies to. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-jumpboxconfigurationsubnetnetworksecuritygroupsecurityrulespropertiesdescription) | string | The description of the security rule. |
| [`destinationAddressPrefix`](#parameter-jumpboxconfigurationsubnetnetworksecuritygroupsecurityrulespropertiesdestinationaddressprefix) | string | Optional. The destination address prefix. CIDR or destination IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used. |
| [`destinationAddressPrefixes`](#parameter-jumpboxconfigurationsubnetnetworksecuritygroupsecurityrulespropertiesdestinationaddressprefixes) | array | The destination address prefixes. CIDR or destination IP ranges. |
| [`destinationApplicationSecurityGroupResourceIds`](#parameter-jumpboxconfigurationsubnetnetworksecuritygroupsecurityrulespropertiesdestinationapplicationsecuritygroupresourceids) | array | The resource IDs of the application security groups specified as destination. |
| [`destinationPortRange`](#parameter-jumpboxconfigurationsubnetnetworksecuritygroupsecurityrulespropertiesdestinationportrange) | string | The destination port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports. |
| [`destinationPortRanges`](#parameter-jumpboxconfigurationsubnetnetworksecuritygroupsecurityrulespropertiesdestinationportranges) | array | The destination port ranges. |
| [`sourceAddressPrefix`](#parameter-jumpboxconfigurationsubnetnetworksecuritygroupsecurityrulespropertiessourceaddressprefix) | string | The CIDR or source IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used. If this is an ingress rule, specifies where network traffic originates from. |
| [`sourceAddressPrefixes`](#parameter-jumpboxconfigurationsubnetnetworksecuritygroupsecurityrulespropertiessourceaddressprefixes) | array | The CIDR or source IP ranges. |
| [`sourceApplicationSecurityGroupResourceIds`](#parameter-jumpboxconfigurationsubnetnetworksecuritygroupsecurityrulespropertiessourceapplicationsecuritygroupresourceids) | array | The resource IDs of the application security groups specified as source. |
| [`sourcePortRange`](#parameter-jumpboxconfigurationsubnetnetworksecuritygroupsecurityrulespropertiessourceportrange) | string | The source port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports. |
| [`sourcePortRanges`](#parameter-jumpboxconfigurationsubnetnetworksecuritygroupsecurityrulespropertiessourceportranges) | array | The source port ranges. |

### Parameter: `jumpboxConfiguration.subnet.networkSecurityGroup.securityRules.properties.access`

Whether network traffic is allowed or denied.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Allow'
    'Deny'
  ]
  ```

### Parameter: `jumpboxConfiguration.subnet.networkSecurityGroup.securityRules.properties.direction`

The direction of the rule. The direction specifies if rule will be evaluated on incoming or outgoing traffic.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Inbound'
    'Outbound'
  ]
  ```

### Parameter: `jumpboxConfiguration.subnet.networkSecurityGroup.securityRules.properties.priority`

Required. The priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule.

- Required: Yes
- Type: int
- MinValue: 100
- MaxValue: 4096

### Parameter: `jumpboxConfiguration.subnet.networkSecurityGroup.securityRules.properties.protocol`

Network protocol this rule applies to.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    '*'
    'Ah'
    'Esp'
    'Icmp'
    'Tcp'
    'Udp'
  ]
  ```

### Parameter: `jumpboxConfiguration.subnet.networkSecurityGroup.securityRules.properties.description`

The description of the security rule.

- Required: No
- Type: string

### Parameter: `jumpboxConfiguration.subnet.networkSecurityGroup.securityRules.properties.destinationAddressPrefix`

Optional. The destination address prefix. CIDR or destination IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used.

- Required: No
- Type: string

### Parameter: `jumpboxConfiguration.subnet.networkSecurityGroup.securityRules.properties.destinationAddressPrefixes`

The destination address prefixes. CIDR or destination IP ranges.

- Required: No
- Type: array

### Parameter: `jumpboxConfiguration.subnet.networkSecurityGroup.securityRules.properties.destinationApplicationSecurityGroupResourceIds`

The resource IDs of the application security groups specified as destination.

- Required: No
- Type: array

### Parameter: `jumpboxConfiguration.subnet.networkSecurityGroup.securityRules.properties.destinationPortRange`

The destination port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports.

- Required: No
- Type: string

### Parameter: `jumpboxConfiguration.subnet.networkSecurityGroup.securityRules.properties.destinationPortRanges`

The destination port ranges.

- Required: No
- Type: array

### Parameter: `jumpboxConfiguration.subnet.networkSecurityGroup.securityRules.properties.sourceAddressPrefix`

The CIDR or source IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used. If this is an ingress rule, specifies where network traffic originates from.

- Required: No
- Type: string

### Parameter: `jumpboxConfiguration.subnet.networkSecurityGroup.securityRules.properties.sourceAddressPrefixes`

The CIDR or source IP ranges.

- Required: No
- Type: array

### Parameter: `jumpboxConfiguration.subnet.networkSecurityGroup.securityRules.properties.sourceApplicationSecurityGroupResourceIds`

The resource IDs of the application security groups specified as source.

- Required: No
- Type: array

### Parameter: `jumpboxConfiguration.subnet.networkSecurityGroup.securityRules.properties.sourcePortRange`

The source port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports.

- Required: No
- Type: string

### Parameter: `jumpboxConfiguration.subnet.networkSecurityGroup.securityRules.properties.sourcePortRanges`

The source port ranges.

- Required: No
- Type: array

### Parameter: `jumpboxConfiguration.subnet.privateEndpointNetworkPolicies`

enable or disable apply network policies on private endpoint in the subnet.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
    'NetworkSecurityGroupEnabled'
    'RouteTableEnabled'
  ]
  ```

### Parameter: `jumpboxConfiguration.subnet.privateLinkServiceNetworkPolicies`

Enable or disable apply network policies on private link service in the subnet.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `jumpboxConfiguration.subnet.routeTableResourceId`

The resource ID of the route table to assign to the subnet.

- Required: No
- Type: string

### Parameter: `jumpboxConfiguration.subnet.serviceEndpointPolicies`

An array of service endpoint policies.

- Required: No
- Type: array

### Parameter: `jumpboxConfiguration.subnet.serviceEndpoints`

The service endpoints to enable on the subnet.

- Required: No
- Type: array

### Parameter: `location`

Azure region for all services.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `tags`

Tags to be applied to the resources.

- Required: No
- Type: object
- Default: `{}`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `bastionHostId` | string | Resource ID of the Bastion Host. |
| `bastionHostName` | string | Name of the Bastion Host. |
| `bastionSubnetId` | string | Resource ID of the Bastion subnet. |
| `bastionSubnetName` | string | Name of the Bastion subnet. |
| `jumpboxName` | string | Name of the Jumpbox VM. |
| `jumpboxResourceId` | string | Resource ID of the Jumpbox VM. |
| `jumpboxSubnetId` | string | Resource ID of the Jumpbox subnet. |
| `jumpboxSubnetName` | string | Name of the Jumpbox subnet. |
| `name` | string | Name of the Virtual Network resource. |
| `resourceGroupName` | string | The resource group the resources were deployed into. |
| `resourceId` | string | Resource ID of the Virtual Network. |
| `subnets` | array | Array of subnets created in the Virtual Network. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/network/network-security-group:0.5.1` | Remote reference |
| `br/public:avm/res/network/virtual-network:0.7.0` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
