# Secure Virtual Network Module `[Sa/DocumentKnowledgeMiningSolutionModulesNetwork]`

This module creates a secure Virtual Network with optional Azure Bastion Host and Jumpbox VM. It includes NSGs for each subnet and integrates with Log Analytics for monitoring.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Authorization/locks` | 2020-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_locks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks)</li></ul> |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |
| `Microsoft.Automanage/configurationProfileAssignments` | 2022-05-04 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.automanage_configurationprofileassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Automanage/2022-05-04/configurationProfileAssignments)</li></ul> |
| `Microsoft.Compute/disks` | 2024-03-02 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.compute_disks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2024-03-02/disks)</li></ul> |
| `Microsoft.Compute/virtualMachines` | 2024-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.compute_virtualmachines.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2024-07-01/virtualMachines)</li></ul> |
| `Microsoft.Compute/virtualMachines/extensions` | 2022-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.compute_virtualmachines_extensions.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2022-11-01/virtualMachines/extensions)</li></ul> |
| `Microsoft.DevTestLab/schedules` | 2018-09-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.devtestlab_schedules.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevTestLab/2018-09-15/schedules)</li></ul> |
| `Microsoft.GuestConfiguration/guestConfigurationAssignments` | 2020-06-25 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.guestconfiguration_guestconfigurationassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.GuestConfiguration/2020-06-25/guestConfigurationAssignments)</li></ul> |
| `Microsoft.Insights/dataCollectionRuleAssociations` | 2023-03-11 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_datacollectionruleassociations.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2023-03-11/dataCollectionRuleAssociations)</li></ul> |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_diagnosticsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)</li></ul> |
| `Microsoft.Maintenance/configurationAssignments` | 2023-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.maintenance_configurationassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Maintenance/2023-04-01/configurationAssignments)</li></ul> |
| `Microsoft.Maintenance/maintenanceConfigurations` | 2023-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.maintenance_maintenanceconfigurations.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Maintenance/2023-04-01/maintenanceConfigurations)</li></ul> |
| `Microsoft.Network/bastionHosts` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_bastionhosts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/bastionHosts)</li></ul> |
| `Microsoft.Network/networkInterfaces` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_networkinterfaces.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/networkInterfaces)</li></ul> |
| `Microsoft.Network/networkSecurityGroups` | 2023-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_networksecuritygroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/networkSecurityGroups)</li></ul> |
| `Microsoft.Network/publicIPAddresses` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_publicipaddresses.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/publicIPAddresses)</li></ul> |
| `Microsoft.Network/virtualNetworks` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_virtualnetworks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/virtualNetworks)</li></ul> |
| `Microsoft.Network/virtualNetworks/subnets` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_virtualnetworks_subnets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/virtualNetworks/subnets)</li></ul> |
| `Microsoft.Network/virtualNetworks/virtualNetworkPeerings` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_virtualnetworks_virtualnetworkpeerings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-01-01/virtualNetworks/virtualNetworkPeerings)</li></ul> |
| `Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems` | 2023-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.recoveryservices_vaults_backupfabrics_protectioncontainers_protecteditems.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2023-01-01/vaults/backupFabrics/protectionContainers/protectedItems)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addressPrefixes`](#parameter-addressprefixes) | array | Networking address prefix for the VNET. |
| [`logAnalyticsWorkSpaceResourceId`](#parameter-loganalyticsworkspaceresourceid) | string | Resource ID of the Log Analytics Workspace for monitoring and diagnostics. |
| [`resourcesName`](#parameter-resourcesname) | string | Name used for naming all network resources. |
| [`subnets`](#parameter-subnets) | array | Array of subnets to be created within the VNET. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`bastionConfiguration`](#parameter-bastionconfiguration) | object | Configuration for the Azure Bastion Host. Leave null to omit Bastion creation. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`jumpboxConfiguration`](#parameter-jumpboxconfiguration) | object | Configuration for the Jumpbox VM. Leave null to omit Jumpbox creation. |
| [`location`](#parameter-location) | string | Azure region for all services. |
| [`tags`](#parameter-tags) | object | Tags to be applied to the resources. |

### Parameter: `addressPrefixes`

Networking address prefix for the VNET.

- Required: Yes
- Type: array

### Parameter: `logAnalyticsWorkSpaceResourceId`

Resource ID of the Log Analytics Workspace for monitoring and diagnostics.

- Required: Yes
- Type: string

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
| [`subnet`](#parameter-bastionconfigurationsubnet) | object | Subnet configuration for the Bastion Host. |

### Parameter: `bastionConfiguration.name`

The name of the Bastion Host resource.

- Required: Yes
- Type: string

### Parameter: `bastionConfiguration.subnet`

Subnet configuration for the Bastion Host.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addressPrefixes`](#parameter-bastionconfigurationsubnetaddressprefixes) | array | Prefixes for the subnet. |
| [`name`](#parameter-bastionconfigurationsubnetname) | string | The Name of the subnet resource. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`defaultOutboundAccess`](#parameter-bastionconfigurationsubnetdefaultoutboundaccess) | bool | Set this property to false to disable default outbound connectivity for all VMs in the subnet. This property can only be set at the time of subnet creation and cannot be updated for an existing subnet. |
| [`delegation`](#parameter-bastionconfigurationsubnetdelegation) | string | The delegation to enable on the subnet. |
| [`networkSecurityGroup`](#parameter-bastionconfigurationsubnetnetworksecuritygroup) | object | Network Security Group configuration for the subnet. |
| [`privateEndpointNetworkPolicies`](#parameter-bastionconfigurationsubnetprivateendpointnetworkpolicies) | string | enable or disable apply network policies on private endpoint in the subnet. |
| [`privateLinkServiceNetworkPolicies`](#parameter-bastionconfigurationsubnetprivatelinkservicenetworkpolicies) | string | Enable or disable apply network policies on private link service in the subnet. |
| [`routeTableResourceId`](#parameter-bastionconfigurationsubnetroutetableresourceid) | string | The resource ID of the route table to assign to the subnet. |
| [`serviceEndpointPolicies`](#parameter-bastionconfigurationsubnetserviceendpointpolicies) | array | An array of service endpoint policies. |
| [`serviceEndpoints`](#parameter-bastionconfigurationsubnetserviceendpoints) | array | The service endpoints to enable on the subnet. |

### Parameter: `bastionConfiguration.subnet.addressPrefixes`

Prefixes for the subnet.

- Required: Yes
- Type: array

### Parameter: `bastionConfiguration.subnet.name`

The Name of the subnet resource.

- Required: Yes
- Type: string

### Parameter: `bastionConfiguration.subnet.defaultOutboundAccess`

Set this property to false to disable default outbound connectivity for all VMs in the subnet. This property can only be set at the time of subnet creation and cannot be updated for an existing subnet.

- Required: No
- Type: bool

### Parameter: `bastionConfiguration.subnet.delegation`

The delegation to enable on the subnet.

- Required: No
- Type: string

### Parameter: `bastionConfiguration.subnet.networkSecurityGroup`

Network Security Group configuration for the subnet.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-bastionconfigurationsubnetnetworksecuritygroupname) | string | The name of the network security group. |
| [`securityRules`](#parameter-bastionconfigurationsubnetnetworksecuritygroupsecurityrules) | array | The security rules for the network security group. |

### Parameter: `bastionConfiguration.subnet.networkSecurityGroup.name`

The name of the network security group.

- Required: Yes
- Type: string

### Parameter: `bastionConfiguration.subnet.networkSecurityGroup.securityRules`

The security rules for the network security group.

- Required: Yes
- Type: array

### Parameter: `bastionConfiguration.subnet.privateEndpointNetworkPolicies`

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

### Parameter: `bastionConfiguration.subnet.privateLinkServiceNetworkPolicies`

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

### Parameter: `bastionConfiguration.subnet.routeTableResourceId`

The resource ID of the route table to assign to the subnet.

- Required: No
- Type: string

### Parameter: `bastionConfiguration.subnet.serviceEndpointPolicies`

An array of service endpoint policies.

- Required: No
- Type: array

### Parameter: `bastionConfiguration.subnet.serviceEndpoints`

The service endpoints to enable on the subnet.

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
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-jumpboxconfigurationname) | string | The name of the Virtual Machine. |
| [`password`](#parameter-jumpboxconfigurationpassword) | securestring | Password to access VM. |
| [`username`](#parameter-jumpboxconfigurationusername) | string | Username to access VM. |

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
- Type: string

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
| `bastionHostId` | string | The resource ID of the bastion host. |
| `bastionHostName` | string | The name of the bastion host. |
| `bastionSubnetId` | string | The resource ID of the bastion subnet. |
| `bastionSubnetName` | string | The name of the bastion subnet. |
| `jumpboxName` | string | The name of the jumpbox. |
| `jumpboxResourceId` | string | The resource ID of the jumpbox. |
| `jumpboxSubnetId` | string | The resource ID of the jumpbox subnet. |
| `jumpboxSubnetName` | string | The name of the jumpbox subnet. |
| `resourceGroupName` | string | The name of the resource group where the virtual network is deployed. |
| `subnets` | array | The subnet information including NSG details. |
| `vnetName` | string | The name of the virtual network. |
| `vnetResourceId` | string | The resource ID of the virtual network. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/network/network-security-group:0.5.1` | Remote reference |
| `br/public:avm/res/network/virtual-network:0.7.0` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
