metadata name = 'DNS Resolver'
metadata description = 'This module deploys a DNS Resolver.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the DNS Private Resolver.')
@minLength(1)
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. Tags of the resource.')
param tags object?

@description('Required. ResourceId of the virtual network to attach the DNS Private Resolver to.')
param virtualNetworkResourceId string

@description('Optional. Outbound Endpoints for DNS Private Resolver.')
param outboundEndpoints outboundEndpointType

@description('Optional. Inbound Endpoints for DNS Private Resolver.')
param inboundEndpoints inboundEndpointType

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
  name: '46d3xbcp.res.network-dnsresolver.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource dnsResolver 'Microsoft.Network/dnsResolvers@2022-07-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    virtualNetwork: {
      id: virtualNetworkResourceId
    }
  }
}

resource dnsResolver_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: dnsResolver
}

resource dnsResolver_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(dnsResolver.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: dnsResolver
  }
]

module dnsResolver_inboundEndpoints 'inbound-endpoint/main.bicep' = [
  for (inboundEndpoint, index) in (inboundEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-dnsResolver-inbound-${index}'
    params: {
      name: inboundEndpoint.name
      tags: inboundEndpoint.?tags ?? tags
      location: inboundEndpoint.?location ?? location
      dnsResolverName: dnsResolver.name
      subnetResourceId: inboundEndpoint.subnetResourceId
      privateIpAddress: inboundEndpoint.?privateIpAddress
      privateIpAllocationMethod: inboundEndpoint.?privateIpAllocationMethod
    }
  }
]

module dnsResolver_outboundEndpoints 'outbound-endpoint/main.bicep' = [
  for (outboundEndpoint, index) in (outboundEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-dnsResolver-outbound-${index}'
    params: {
      name: outboundEndpoint.name
      tags: outboundEndpoint.?tags ?? tags
      location: outboundEndpoint.?location ?? location
      dnsResolverName: dnsResolver.name
      subnetResourceId: outboundEndpoint.subnetResourceId
    }
  }
]

@description('The resource group the DNS Private Resolver was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the DNS Private Resolver.')
output resourceId string = dnsResolver.id

@description('The name of the DNS Private Resolver.')
output name string = dnsResolver.name

@description('The location the resource was deployed into.')
output location string = dnsResolver.location

// ================ //
// Definitions      //
// ================ //

type roleAssignmentType = {
  @description('Optional. The name (as GUID) of the role assignment. If not provided, a GUID will be generated.')
  name: string?

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

type inboundEndpointType = {
  @description('Required. Name of the inbound endpoint.')
  name: string

  @description('Required. The reference to the subnet bound to the IP configuration.')
  subnetResourceId: string

  @description('Optional. Tags for the resource.')
  tags: object?

  @description('Optional. Location for all resources.')
  location: string?

  @description('Optional. Private IP address of the IP configuration.')
  privateIpAddress: string?

  @description('Optional. Private IP address allocation method.')
  privateIpAllocationMethod: ('Dynamic' | 'Static')?
}[]?

type outboundEndpointType = {
  @description('Required. Name of the outbound endpoint.')
  name: string

  @description('Required. ResourceId of the subnet to attach the outbound endpoint to.')
  subnetResourceId: string

  @description('Optional. Tags of the resource.')
  tags: object?

  @description('Optional. Location for all resources.')
  location: string?
}[]?
