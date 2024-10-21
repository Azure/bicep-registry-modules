metadata name = 'Virtual Network Subnets'
metadata description = 'This module deploys a Virtual Network Subnet.'
metadata owner = 'Azure/module-maintainers'

@description('Requird. The Name of the subnet resource.')
param name string

@description('Conditional. The name of the parent virtual network. Required if the template is used in a standalone deployment.')
param virtualNetworkName string

@description('Conditional. The address prefix for the subnet. Required if `addressPrefixes` is empty.')
param addressPrefix string?

@description('Optional. The resource ID of the network security group to assign to the subnet.')
param networkSecurityGroupResourceId string?

@description('Optional. The resource ID of the route table to assign to the subnet.')
param routeTableResourceId string?

@description('Optional. The service endpoints to enable on the subnet.')
param serviceEndpoints string[] = []

@description('Optional. The delegation to enable on the subnet.')
param delegation string?

@description('Optional. The resource ID of the NAT Gateway to use for the subnet.')
param natGatewayResourceId string?

@description('Optional. Enable or disable apply network policies on private endpoint in the subnet.')
@allowed([
  'Disabled'
  'Enabled'
  'NetworkSecurityGroupEnabled'
  'RouteTableEnabled'
])
param privateEndpointNetworkPolicies string?

@description('Optional. Enable or disable apply network policies on private link service in the subnet.')
@allowed([
  'Disabled'
  'Enabled'
])
param privateLinkServiceNetworkPolicies string?

@description('Conditional. List of address prefixes for the subnet. Required if `addressPrefix` is empty.')
param addressPrefixes string[]?

@description('Optional. Set this property to false to disable default outbound connectivity for all VMs in the subnet. This property can only be set at the time of subnet creation and cannot be updated for an existing subnet.')
param defaultOutboundAccess bool?

@description('Optional. Set this property to Tenant to allow sharing subnet with other subscriptions in your AAD tenant. This property can only be set if defaultOutboundAccess is set to false, both properties can only be set if subnet is empty.')
param sharingScope ('DelegatedServices' | 'Tenant')?

@description('Optional. Application gateway IP configurations of virtual network resource.')
param applicationGatewayIPConfigurations array = []

@description('Optional. An array of service endpoint policies.')
param serviceEndpointPolicies array = []

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.1.0'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Network Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '4d97b98b-1d4f-4787-a291-c67834d212e7'
  )
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
  'User Access Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  )
}

var formattedRoleAssignments = [
  for (roleAssignment, index) in (roleAssignments ?? []): union(roleAssignment, {
    roleDefinitionId: builtInRoleNames[?roleAssignment.roleDefinitionIdOrName] ?? (contains(
        roleAssignment.roleDefinitionIdOrName,
        '/providers/Microsoft.Authorization/roleDefinitions/'
      )
      ? roleAssignment.roleDefinitionIdOrName
      : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName))
  })
]

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-01-01' existing = {
  name: virtualNetworkName
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2024-01-01' = {
  name: name
  parent: virtualNetwork
  properties: {
    addressPrefix: addressPrefix
    addressPrefixes: addressPrefixes
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
    serviceEndpoints: [
      for endpoint in serviceEndpoints: {
        service: endpoint
      }
    ]
    delegations: !empty(delegation)
      ? [
          {
            name: delegation
            properties: {
              serviceName: delegation
            }
          }
        ]
      : []
    privateEndpointNetworkPolicies: privateEndpointNetworkPolicies
    privateLinkServiceNetworkPolicies: privateLinkServiceNetworkPolicies
    applicationGatewayIPConfigurations: applicationGatewayIPConfigurations
    serviceEndpointPolicies: serviceEndpointPolicies
    defaultOutboundAccess: defaultOutboundAccess
    sharingScope: sharingScope
  }
}

resource subnet_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(subnet.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
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
output addressPrefix string = subnet.properties.?addressPrefix ?? ''

@description('List of address prefixes for the subnet.')
output addressPrefixes array = subnet.properties.?addressPrefixes ?? []
