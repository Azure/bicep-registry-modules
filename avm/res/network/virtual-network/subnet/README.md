# Virtual Network Subnets `[Microsoft.Network/virtualNetworks/subnets]`

This module deploys a Virtual Network Subnet.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Notes](#Notes)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Network/virtualNetworks/subnets` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/virtualNetworks/subnets) |

## Parameters

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addressPrefix`](#parameter-addressprefix) | string | The address prefix for the subnet. Required if `addressPrefixes` is empty. |
| [`addressPrefixes`](#parameter-addressprefixes) | array | List of address prefixes for the subnet. Required if `addressPrefix` is empty. |
| [`virtualNetworkName`](#parameter-virtualnetworkname) | string | The name of the parent virtual network. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`applicationGatewayIPConfigurations`](#parameter-applicationgatewayipconfigurations) | array | Application gateway IP configurations of virtual network resource. |
| [`defaultOutboundAccess`](#parameter-defaultoutboundaccess) | bool | Set this property to false to disable default outbound connectivity for all VMs in the subnet. This property can only be set at the time of subnet creation and cannot be updated for an existing subnet. |
| [`delegation`](#parameter-delegation) | string | The delegation to enable on the subnet. |
| [`natGatewayResourceId`](#parameter-natgatewayresourceid) | string | The resource ID of the NAT Gateway to use for the subnet. |
| [`networkSecurityGroupResourceId`](#parameter-networksecuritygroupresourceid) | string | The resource ID of the network security group to assign to the subnet. |
| [`privateEndpointNetworkPolicies`](#parameter-privateendpointnetworkpolicies) | string | Enable or disable apply network policies on private endpoint in the subnet. |
| [`privateLinkServiceNetworkPolicies`](#parameter-privatelinkservicenetworkpolicies) | string | Enable or disable apply network policies on private link service in the subnet. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`routeTableResourceId`](#parameter-routetableresourceid) | string | The resource ID of the route table to assign to the subnet. |
| [`serviceEndpointPolicies`](#parameter-serviceendpointpolicies) | array | An array of service endpoint policies. |
| [`serviceEndpoints`](#parameter-serviceendpoints) | array | The service endpoints to enable on the subnet. |
| [`sharingScope`](#parameter-sharingscope) | string | Set this property to Tenant to allow sharing subnet with other subscriptions in your AAD tenant. This property can only be set if defaultOutboundAccess is set to false, both properties can only be set if subnet is empty. |

**Requird parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The Name of the subnet resource. |

### Parameter: `addressPrefix`

The address prefix for the subnet. Required if `addressPrefixes` is empty.

- Required: No
- Type: string

### Parameter: `addressPrefixes`

List of address prefixes for the subnet. Required if `addressPrefix` is empty.

- Required: No
- Type: array

### Parameter: `virtualNetworkName`

The name of the parent virtual network. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `applicationGatewayIPConfigurations`

Application gateway IP configurations of virtual network resource.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `defaultOutboundAccess`

Set this property to false to disable default outbound connectivity for all VMs in the subnet. This property can only be set at the time of subnet creation and cannot be updated for an existing subnet.

- Required: No
- Type: bool

### Parameter: `delegation`

The delegation to enable on the subnet.

- Required: No
- Type: string

### Parameter: `natGatewayResourceId`

The resource ID of the NAT Gateway to use for the subnet.

- Required: No
- Type: string

### Parameter: `networkSecurityGroupResourceId`

The resource ID of the network security group to assign to the subnet.

- Required: No
- Type: string

### Parameter: `privateEndpointNetworkPolicies`

Enable or disable apply network policies on private endpoint in the subnet.

- Required: No
- Type: string
- Default: `''`
- Allowed:
  ```Bicep
  [
    ''
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `privateLinkServiceNetworkPolicies`

Enable or disable apply network policies on private link service in the subnet.

- Required: No
- Type: string
- Default: `''`
- Allowed:
  ```Bicep
  [
    ''
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Network Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-roleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-roleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-roleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `roleAssignments.principalType`

The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Device'
    'ForeignGroup'
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `routeTableResourceId`

The resource ID of the route table to assign to the subnet.

- Required: No
- Type: string

### Parameter: `serviceEndpointPolicies`

An array of service endpoint policies.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `serviceEndpoints`

The service endpoints to enable on the subnet.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `sharingScope`

Set this property to Tenant to allow sharing subnet with other subscriptions in your AAD tenant. This property can only be set if defaultOutboundAccess is set to false, both properties can only be set if subnet is empty.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'DelegatedServices'
    'Tenant'
  ]
  ```

### Parameter: `name`

The Name of the subnet resource.

- Required: Yes
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `addressPrefix` | string | The address prefix for the subnet. |
| `addressPrefixes` | array | List of address prefixes for the subnet. |
| `name` | string | The name of the virtual network peering. |
| `resourceGroupName` | string | The resource group the virtual network peering was deployed into. |
| `resourceId` | string | The resource ID of the virtual network peering. |

## Notes

The `privateEndpointNetworkPolicies` property must be set to disabled for subnets that contain private endpoints. It confirms that NSGs rules will not apply to private endpoints (currently not supported, [reference](https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview#limitations)). Default Value when not specified is "Enabled".
