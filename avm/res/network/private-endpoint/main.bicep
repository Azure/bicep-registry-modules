metadata name = 'Private Endpoints'
metadata description = 'This module deploys a Private Endpoint.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the private endpoint resource to create.')
param name string

@description('Required. Resource ID of the subnet where the endpoint needs to be created.')
param subnetResourceId string

@description('Optional. Application security groups in which the private endpoint IP configuration is included.')
param applicationSecurityGroupResourceIds array?

@description('Optional. The custom name of the network interface attached to the private endpoint.')
param customNetworkInterfaceName string?

@description('Optional. A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints.')
param ipConfigurations ipConfigurationsType

@description('Optional. The name of the private DNS zone group to create if `privateDnsZoneResourceIds` were provided.')
param privateDnsZoneGroupName string?

@description('Optional. The private DNS zone groups to associate the private endpoint. A DNS zone group can support up to 5 DNS zones.')
param privateDnsZoneResourceIds array?

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. Tags to be applied on all resources/resource groups in this deployment.')
param tags object?

@description('Optional. Custom DNS configurations.')
param customDnsConfigs customDnsConfigType

@description('Optional. A grouping of information about the connection to the remote resource. Used when the network admin does not have access to approve connections to the remote resource.')
param manualPrivateLinkServiceConnections manualPrivateLinkServiceConnectionsType

@description('Optional. A grouping of information about the connection to the remote resource.')
param privateLinkServiceConnections privateLinkServiceConnectionsType

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
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
}

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

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2023-04-01' = {
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

module privateEndpoint_privateDnsZoneGroup 'private-dns-zone-group/main.bicep' = if (!empty(privateDnsZoneResourceIds)) {
  name: '${uniqueString(deployment().name)}-PrivateEndpoint-PrivateDnsZoneGroup'
  params: {
    name: privateDnsZoneGroupName ?? 'default'
    privateDNSResourceIds: privateDnsZoneResourceIds ?? []
    privateEndpointName: privateEndpoint.name
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
  for (roleAssignment, index) in (roleAssignments ?? []): {
    name: guid(privateEndpoint.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
    properties: {
      roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName)
        ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName]
        : contains(roleAssignment.roleDefinitionIdOrName, '/providers/Microsoft.Authorization/roleDefinitions/')
            ? roleAssignment.roleDefinitionIdOrName
            : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName)
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

@description('The group Id for the private endpoint Group.')
output groupId string = !empty(privateEndpoint.properties.manualPrivateLinkServiceConnections)
  ? privateEndpoint.properties.manualPrivateLinkServiceConnections[0].properties.groupIds[0]
  : privateEndpoint.properties.privateLinkServiceConnections[0].properties.groupIds[0]

// ================ //
// Definitions      //
// ================ //

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

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

type ipConfigurationsType = {
  @description('Required. The name of the resource that is unique within a resource group.')
  name: string

  @description('Required. Properties of private endpoint IP configurations.')
  properties: {
    @description('Required. The ID of a group obtained from the remote resource that this private endpoint should connect to.')
    groupId: string

    @description('Required. The member name of a group obtained from the remote resource that this private endpoint should connect to.')
    memberName: string

    @description('Required. A private IP address obtained from the private endpoint\'s subnet.')
    privateIPAddress: string
  }
}[]?

type manualPrivateLinkServiceConnectionsType = {
  @description('Required. The name of the private link service connection.')
  name: string

  @description('Required. Properties of private link service connection.')
  properties: {
    @description('Required. The ID of a group obtained from the remote resource that this private endpoint should connect to.')
    groupIds: array

    @description('Required. The resource id of private link service.')
    privateLinkServiceId: string

    @description('Optional. A message passed to the owner of the remote resource with this connection request. Restricted to 140 chars.')
    requestMessage: string
  }
}[]?

type privateLinkServiceConnectionsType = {
  @description('Required. The name of the private link service connection.')
  name: string

  @description('Required. Properties of private link service connection.')
  properties: {
    @description('Required. The ID of a group obtained from the remote resource that this private endpoint should connect to.')
    groupIds: array

    @description('Required. The resource id of private link service.')
    privateLinkServiceId: string

    @description('Optional. A message passed to the owner of the remote resource with this connection request. Restricted to 140 chars.')
    requestMessage: string?
  }
}[]?

type customDnsConfigType = {
  @description('Required. Fqdn that resolves to private endpoint IP address.')
  fqdn: string

  @description('Required. A list of private IP addresses of the private endpoint.')
  ipAddresses: string[]
}[]?
