metadata name = 'Private Endpoints'
metadata description = 'This module deploys a Private Endpoint.'

@description('Required. Name of the private endpoint resource to create.')
param name string

@description('Required. Resource ID of the subnet where the endpoint needs to be created.')
param subnetResourceId string

@description('Optional. Application security groups in which the private endpoint IP configuration is included.')
param applicationSecurityGroupResourceIds string[]?

@description('Optional. The custom name of the network interface attached to the private endpoint.')
param customNetworkInterfaceName string?

@description('Optional. A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints.')
param ipConfigurations ipConfigurationType[]?

@description('Optional. The private DNS zone group to configure for the private endpoint.')
param privateDnsZoneGroup privateDnsZoneGroupType?

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Tags to be applied on all resources/resource groups in this deployment.')
param tags object?

@description('Optional. Custom DNS configurations.')
param customDnsConfigs customDnsConfigType[]?

@description('Optional. A grouping of information about the connection to the remote resource. Used when the network admin does not have access to approve connections to the remote resource.')
param manualPrivateLinkServiceConnections manualPrivateLinkServiceConnectionType[]?

@description('Optional. A grouping of information about the connection to the remote resource.')
param privateLinkServiceConnections privateLinkServiceConnectionType[]?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'DNS Resolver Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '0f2ebee7-ffd4-4fc0-b3b7-664099fdad5d'
  )
  'DNS Zone Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'befefa01-2a29-4197-83a8-272ff33ce314'
  )
  'Domain Services Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'eeaeda52-9324-47f6-8069-5d5bade478b2'
  )
  'Domain Services Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '361898ef-9ed1-48c2-849c-a832951106bb'
  )
  'Network Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '4d97b98b-1d4f-4787-a291-c67834d212e7'
  )
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  'Private DNS Zone Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'b12aa53e-6015-4669-85d0-8515ebb3ae7f'
  )
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
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

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.network-privateendpoint.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2023-11-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    applicationSecurityGroups: [
      for applicationSecurityGroupResourceId in (applicationSecurityGroupResourceIds ?? []): {
        id: applicationSecurityGroupResourceId
      }
    ]
    customDnsConfigs: customDnsConfigs ?? []
    customNetworkInterfaceName: customNetworkInterfaceName ?? ''
    ipConfigurations: ipConfigurations ?? []
    manualPrivateLinkServiceConnections: manualPrivateLinkServiceConnections ?? []
    privateLinkServiceConnections: privateLinkServiceConnections ?? []
    subnet: {
      id: subnetResourceId
    }
  }
}

module privateEndpoint_privateDnsZoneGroup 'private-dns-zone-group/main.bicep' = if (!empty(privateDnsZoneGroup)) {
  name: '${uniqueString(deployment().name)}-PrivateEndpoint-PrivateDnsZoneGroup'
  params: {
    name: privateDnsZoneGroup.?name
    privateEndpointName: privateEndpoint.name
    privateDnsZoneConfigs: privateDnsZoneGroup!.privateDnsZoneGroupConfigs
  }
}

resource privateEndpoint_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: privateEndpoint
}

resource privateEndpoint_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(privateEndpoint.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: privateEndpoint
  }
]

@description('The resource group the private endpoint was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the private endpoint.')
output resourceId string = privateEndpoint.id

@description('The name of the private endpoint.')
output name string = privateEndpoint.name

@description('The location the resource was deployed into.')
output location string = privateEndpoint.location

@description('The custom DNS configurations of the private endpoint.')
output customDnsConfig customDnsConfigType[] = privateEndpoint.properties.customDnsConfigs

@description('The resource IDs of the network interfaces associated with the private endpoint.')
output networkInterfaceResourceIds string[] = map(privateEndpoint.properties.networkInterfaces, nic => nic.id)

@description('The group Id for the private endpoint Group.')
output groupId string? = privateEndpoint.properties.?manualPrivateLinkServiceConnections[?0].properties.?groupIds[?0] ?? privateEndpoint.properties.?privateLinkServiceConnections[?0].properties.?groupIds[?0]

// ================ //
// Definitions      //
// ================ //

import { privateDnsZoneGroupConfigType } from 'private-dns-zone-group/main.bicep'

@export()
type privateDnsZoneGroupType = {
  @description('Optional. The name of the Private DNS Zone Group.')
  name: string?

  @description('Required. The private DNS zone groups to associate the private endpoint. A DNS zone group can support up to 5 DNS zones.')
  privateDnsZoneGroupConfigs: privateDnsZoneGroupConfigType[]
}

@export()
type ipConfigurationType = {
  @description('Required. The name of the resource that is unique within a resource group.')
  name: string

  @description('Required. Properties of private endpoint IP configurations.')
  properties: {
    @description('Required. The ID of a group obtained from the remote resource that this private endpoint should connect to. If used with private link service connection, this property must be defined as empty string.')
    groupId: string

    @description('Required. The member name of a group obtained from the remote resource that this private endpoint should connect to. If used with private link service connection, this property must be defined as empty string.')
    memberName: string

    @description('Required. A private IP address obtained from the private endpoint\'s subnet.')
    privateIPAddress: string
  }
}

@export()
type manualPrivateLinkServiceConnectionType = {
  @description('Required. The name of the private link service connection.')
  name: string

  @description('Required. Properties of private link service connection.')
  properties: {
    @description('Required. The ID of a group obtained from the remote resource that this private endpoint should connect to. If used with private link service connection, this property must be defined as empty string array `[]`.')
    groupIds: string[]

    @description('Required. The resource id of private link service.')
    privateLinkServiceId: string

    @description('Optional. A message passed to the owner of the remote resource with this connection request. Restricted to 140 chars.')
    requestMessage: string?
  }
}

@export()
type privateLinkServiceConnectionType = {
  @description('Required. The name of the private link service connection.')
  name: string

  @description('Required. Properties of private link service connection.')
  properties: {
    @description('Required. The ID of a group obtained from the remote resource that this private endpoint should connect to. If used with private link service connection, this property must be defined as empty string array `[]`.')
    groupIds: string[]

    @description('Required. The resource id of private link service.')
    privateLinkServiceId: string

    @description('Optional. A message passed to the owner of the remote resource with this connection request. Restricted to 140 chars.')
    requestMessage: string?
  }
}

@export()
type customDnsConfigType = {
  @description('Optional. FQDN that resolves to private endpoint IP address.')
  fqdn: string?

  @description('Required. A list of private IP addresses of the private endpoint.')
  ipAddresses: string[]
}
