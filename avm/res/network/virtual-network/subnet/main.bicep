metadata name = 'Virtual Network Subnets'
metadata description = 'This module deploys a Virtual Network Subnet.'
metadata owner = 'Azure/module-maintainers'

@description('Optional. The Name of the subnet resource.')
param name string

@description('Conditional. The name of the parent virtual network. Required if the template is used in a standalone deployment.')
param virtualNetworkName string

@description('Required. The address prefix for the subnet.')
param addressPrefix string

@description('Optional. The resource ID of the network security group to assign to the subnet.')
param networkSecurityGroupResourceId string = ''

@description('Optional. The resource ID of the route table to assign to the subnet.')
param routeTableResourceId string = ''

@description('Optional. The service endpoints to enable on the subnet.')
param serviceEndpoints array = []

@description('Optional. The delegations to enable on the subnet.')
param delegations array = []

@description('Optional. The resource ID of the NAT Gateway to use for the subnet.')
param natGatewayResourceId string = ''

@description('Optional. enable or disable apply network policies on private endpoint in the subnet.')
@allowed([
  'Disabled'
  'Enabled'
  ''
])
param privateEndpointNetworkPolicies string = ''

@description('Optional. enable or disable apply network policies on private link service in the subnet.')
@allowed([
  'Disabled'
  'Enabled'
  ''
])
param privateLinkServiceNetworkPolicies string = ''

@description('Optional. List of address prefixes for the subnet.')
param addressPrefixes array = []

@description('Optional. Application gateway IP configurations of virtual network resource.')
param applicationGatewayIPConfigurations array = []

@description('Optional. Array of IpAllocation which reference this subnet.')
param ipAllocations array = []

@description('Optional. An array of service endpoint policies.')
param serviceEndpointPolicies array = []

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Network Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '4d97b98b-1d4f-4787-a291-c67834d212e7'
  )
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
  'User Access Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  )
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-04-01' existing = {
  name: virtualNetworkName
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2023-04-01' = {
  name: name
  parent: virtualNetwork
  properties: {
    addressPrefix: addressPrefix
    networkSecurityGroup: !empty(networkSecurityGroupResourceId)
      ? {
          id: networkSecurityGroupResourceId
        }
      : null
    routeTable: !empty(routeTableResourceId)
      ? {
          id: routeTableResourceId
        }
      : null
    natGateway: !empty(natGatewayResourceId)
      ? {
          id: natGatewayResourceId
        }
      : null
    serviceEndpoints: serviceEndpoints
    delegations: delegations
    privateEndpointNetworkPolicies: !empty(privateEndpointNetworkPolicies) ? any(privateEndpointNetworkPolicies) : null
    privateLinkServiceNetworkPolicies: !empty(privateLinkServiceNetworkPolicies)
      ? any(privateLinkServiceNetworkPolicies)
      : null
    addressPrefixes: addressPrefixes
    applicationGatewayIPConfigurations: applicationGatewayIPConfigurations
    ipAllocations: ipAllocations
    serviceEndpointPolicies: serviceEndpointPolicies
  }
}

resource subnet_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (roleAssignments ?? []): {
    name: guid(subnet.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
    properties: {
      roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName)
        ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName]
        : roleAssignment.roleDefinitionIdOrName
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: subnet
  }
]

@description('The resource group the virtual network peering was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the virtual network peering.')
output name string = subnet.name

@description('The resource ID of the virtual network peering.')
output resourceId string = subnet.id

@description('The address prefix for the subnet.')
output subnetAddressPrefix string = subnet.properties.addressPrefix

@description('List of address prefixes for the subnet.')
output subnetAddressPrefixes array = !empty(addressPrefixes) ? subnet.properties.addressPrefixes : []

// =============== //
//   Definitions   //
// =============== //

type roleAssignmentType = {
  @description('Required. The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
  roleDefinitionIdOrName: string

  @description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
  principalId: string

  @description('Optional. The principal type of the assigned principal ID.')
  principalType: ('ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup' | 'Device')?

  @description('Optional. The description of the role assignment.')
  description: string?

  @description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".')
  condition: string?

  @description('Optional. Version of the condition.')
  conditionVersion: '2.0'?

  @description('Optional. The Resource Id of the delegated managed identity resource.')
  delegatedManagedIdentityResourceId: string?
}[]?
