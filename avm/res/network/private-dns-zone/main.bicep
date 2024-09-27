metadata name = 'Private DNS Zones'
metadata description = 'This module deploys a Private DNS zone.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Private DNS zone name.')
param name string

@description('Optional. Array of A records.')
param a aType

@description('Optional. Array of AAAA records.')
param aaaa aaaaType

@description('Optional. Array of CNAME records.')
param cname cnameType

@description('Optional. Array of MX records.')
param mx mxType

@description('Optional. Array of PTR records.')
param ptr ptrType

@description('Optional. Array of SOA records.')
param soa soaType

@description('Optional. Array of SRV records.')
param srv srvType

@description('Optional. Array of TXT records.')
param txt txtType

@description('Optional. Array of custom objects describing vNet links of the DNS zone. Each object should contain properties \'virtualNetworkResourceId\' and \'registrationEnabled\'. The \'vnetResourceId\' is a resource ID of a vNet to link, \'registrationEnabled\' (bool) enables automatic DNS registration in the zone for the linked vNet.')
param virtualNetworkLinks virtualNetworkLinkType

@description('Optional. The location of the PrivateDNSZone. Should be global.')
param location string = 'global'

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
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
  name: '46d3xbcp.res.network-privatednszone.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: name
  location: location
  tags: tags
}

module privateDnsZone_A 'a/main.bicep' = [
  for (aRecord, index) in (a ?? []): {
    name: '${uniqueString(deployment().name, location)}-PrivateDnsZone-ARecord-${index}'
    params: {
      privateDnsZoneName: privateDnsZone.name
      name: aRecord.name
      aRecords: aRecord.?aRecords
      metadata: aRecord.?metadata
      ttl: aRecord.?ttl ?? 3600
      roleAssignments: aRecord.?roleAssignments
    }
  }
]

module privateDnsZone_AAAA 'aaaa/main.bicep' = [
  for (aaaaRecord, index) in (aaaa ?? []): {
    name: '${uniqueString(deployment().name, location)}-PrivateDnsZone-AAAARecord-${index}'
    params: {
      privateDnsZoneName: privateDnsZone.name
      name: aaaaRecord.name
      aaaaRecords: aaaaRecord.?aaaaRecords
      metadata: aaaaRecord.?metadata
      ttl: aaaaRecord.?ttl ?? 3600
      roleAssignments: aaaaRecord.?roleAssignments
    }
  }
]

module privateDnsZone_CNAME 'cname/main.bicep' = [
  for (cnameRecord, index) in (cname ?? []): {
    name: '${uniqueString(deployment().name, location)}-PrivateDnsZone-CNAMERecord-${index}'
    params: {
      privateDnsZoneName: privateDnsZone.name
      name: cnameRecord.name
      cnameRecord: cnameRecord.?cnameRecord
      metadata: cnameRecord.?metadata
      ttl: cnameRecord.?ttl ?? 3600
      roleAssignments: cnameRecord.?roleAssignments
    }
  }
]

module privateDnsZone_MX 'mx/main.bicep' = [
  for (mxRecord, index) in (mx ?? []): {
    name: '${uniqueString(deployment().name, location)}-PrivateDnsZone-MXRecord-${index}'
    params: {
      privateDnsZoneName: privateDnsZone.name
      name: mxRecord.name
      metadata: mxRecord.?metadata
      mxRecords: mxRecord.?mxRecords
      ttl: mxRecord.?ttl ?? 3600
      roleAssignments: mxRecord.?roleAssignments
    }
  }
]

module privateDnsZone_PTR 'ptr/main.bicep' = [
  for (ptrRecord, index) in (ptr ?? []): {
    name: '${uniqueString(deployment().name, location)}-PrivateDnsZone-PTRRecord-${index}'
    params: {
      privateDnsZoneName: privateDnsZone.name
      name: ptrRecord.name
      metadata: ptrRecord.?metadata
      ptrRecords: ptrRecord.?ptrRecords
      ttl: ptrRecord.?ttl ?? 3600
      roleAssignments: ptrRecord.?roleAssignments
    }
  }
]

module privateDnsZone_SOA 'soa/main.bicep' = [
  for (soaRecord, index) in (soa ?? []): {
    name: '${uniqueString(deployment().name, location)}-PrivateDnsZone-SOARecord-${index}'
    params: {
      privateDnsZoneName: privateDnsZone.name
      name: soaRecord.name
      metadata: soaRecord.?metadata
      soaRecord: soaRecord.?soaRecord
      ttl: soaRecord.?ttl ?? 3600
      roleAssignments: soaRecord.?roleAssignments
    }
  }
]

module privateDnsZone_SRV 'srv/main.bicep' = [
  for (srvRecord, index) in (srv ?? []): {
    name: '${uniqueString(deployment().name, location)}-PrivateDnsZone-SRVRecord-${index}'
    params: {
      privateDnsZoneName: privateDnsZone.name
      name: srvRecord.name
      metadata: srvRecord.?metadata
      srvRecords: srvRecord.?srvRecords
      ttl: srvRecord.?ttl ?? 3600
      roleAssignments: srvRecord.?roleAssignments
    }
  }
]

module privateDnsZone_TXT 'txt/main.bicep' = [
  for (txtRecord, index) in (txt ?? []): {
    name: '${uniqueString(deployment().name, location)}-PrivateDnsZone-TXTRecord-${index}'
    params: {
      privateDnsZoneName: privateDnsZone.name
      name: txtRecord.name
      metadata: txtRecord.?metadata
      txtRecords: txtRecord.?txtRecords
      ttl: txtRecord.?ttl ?? 3600
      roleAssignments: txtRecord.?roleAssignments
    }
  }
]

module privateDnsZone_virtualNetworkLinks 'virtual-network-link/main.bicep' = [
  for (virtualNetworkLink, index) in (virtualNetworkLinks ?? []): {
    name: '${uniqueString(deployment().name, location)}-PrivateDnsZone-VirtualNetworkLink-${index}'
    params: {
      privateDnsZoneName: privateDnsZone.name
      name: virtualNetworkLink.?name ?? '${last(split(virtualNetworkLink.virtualNetworkResourceId, '/'))}-vnetlink'
      virtualNetworkResourceId: virtualNetworkLink.virtualNetworkResourceId
      location: virtualNetworkLink.?location ?? 'global'
      registrationEnabled: virtualNetworkLink.?registrationEnabled ?? false
      tags: virtualNetworkLink.?tags ?? tags
    }
  }
]

resource privateDnsZone_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: privateDnsZone
}

resource privateDnsZone_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(privateDnsZone.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: privateDnsZone
  }
]

@description('The resource group the private DNS zone was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the private DNS zone.')
output name string = privateDnsZone.name

@description('The resource ID of the private DNS zone.')
output resourceId string = privateDnsZone.id

@description('The location the resource was deployed into.')
output location string = privateDnsZone.location

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

type aType = {
  @description('Required. The name of the record.')
  name: string

  @description('Optional. The metadata of the record.')
  metadata: object?

  @description('Optional. The TTL of the record.')
  ttl: int?

  @description('Optional. Array of role assignments to create.')
  roleAssignments: roleAssignmentType

  @description('Optional. The list of A records in the record set.')
  aRecords: {
    @description('Required. The IPv4 address of this A record.')
    ipv4Address: string
  }[]?
}[]?

type aaaaType = {
  @description('Required. The name of the record.')
  name: string

  @description('Optional. The metadata of the record.')
  metadata: object?

  @description('Optional. The TTL of the record.')
  ttl: int?

  @description('Optional. Array of role assignments to create.')
  roleAssignments: roleAssignmentType

  @description('Optional. The list of AAAA records in the record set.')
  aaaaRecords: {
    @description('Required. The IPv6 address of this AAAA record.')
    ipv6Address: string
  }[]?
}[]?

type cnameType = {
  @description('Required. The name of the record.')
  name: string

  @description('Optional. The metadata of the record.')
  metadata: object?

  @description('Optional. The TTL of the record.')
  ttl: int?

  @description('Optional. Array of role assignments to create.')
  roleAssignments: roleAssignmentType

  @description('Optional. The CNAME record in the record set.')
  cnameRecord: {
    @description('Required. The canonical name of the CNAME record.')
    cname: string
  }?
}[]?

type mxType = {
  @description('Required. The name of the record.')
  name: string

  @description('Optional. The metadata of the record.')
  metadata: object?

  @description('Optional. The TTL of the record.')
  ttl: int?

  @description('Optional. Array of role assignments to create.')
  roleAssignments: roleAssignmentType

  @description('Optional. The list of MX records in the record set.')
  mxRecords: {
    @description('Required. The domain name of the mail host for this MX record.')
    exchange: string

    @description('Required. The preference value for this MX record.')
    preference: int
  }[]?
}[]?

type ptrType = {
  @description('Required. The name of the record.')
  name: string

  @description('Optional. The metadata of the record.')
  metadata: object?

  @description('Optional. The TTL of the record.')
  ttl: int?

  @description('Optional. Array of role assignments to create.')
  roleAssignments: roleAssignmentType

  @description('Optional. The list of PTR records in the record set.')
  ptrRecords: {
    @description('Required. The PTR target domain name for this PTR record.')
    ptrdname: string
  }[]?
}[]?

type soaType = {
  @description('Required. The name of the record.')
  name: string

  @description('Optional. The metadata of the record.')
  metadata: object?

  @description('Optional. The TTL of the record.')
  ttl: int?

  @description('Optional. Array of role assignments to create.')
  roleAssignments: roleAssignmentType

  @description('Optional. The SOA record in the record set.')
  soaRecord: {
    @description('Required. The email contact for this SOA record.')
    email: string

    @description('Required. The expire time for this SOA record.')
    expireTime: int

    @description('Required. The domain name of the authoritative name server for this SOA record.')
    host: string

    @description('Required. The minimum value for this SOA record. By convention this is used to determine the negative caching duration.')
    minimumTtl: int

    @description('Required. The refresh value for this SOA record.')
    refreshTime: int

    @description('Required. The retry time for this SOA record.')
    retryTime: int

    @description('Required. The serial number for this SOA record.')
    serialNumber: int
  }?
}[]?

type srvType = {
  @description('Required. The name of the record.')
  name: string

  @description('Optional. The metadata of the record.')
  metadata: object?

  @description('Optional. The TTL of the record.')
  ttl: int?

  @description('Optional. Array of role assignments to create.')
  roleAssignments: roleAssignmentType

  @description('Optional. The list of SRV records in the record set.')
  srvRecords: {
    @description('Required. The priority value for this SRV record.')
    priority: int

    @description('Required. The weight value for this SRV record.')
    weight: int

    @description('Required. The port value for this SRV record.')
    port: int

    @description('Required. The target domain name for this SRV record.')
    target: string
  }[]?
}[]?

type txtType = {
  @description('Required. The name of the record.')
  name: string

  @description('Optional. The metadata of the record.')
  metadata: object?

  @description('Optional. The TTL of the record.')
  ttl: int?

  @description('Optional. Array of role assignments to create.')
  roleAssignments: roleAssignmentType

  @description('Optional. The list of TXT records in the record set.')
  txtRecords: {
    @description('Required. The text value of this TXT record.')
    value: string[]
  }[]?
}[]?

type virtualNetworkLinkType = {
  @description('Optional. The resource name.')
  @minLength(1)
  @maxLength(80)
  name: string?

  @description('Required. The resource ID of the virtual network to link.')
  virtualNetworkResourceId: string

  @description('Optional. The Azure Region where the resource lives.')
  location: string?

  @description('Optional. Is auto-registration of virtual machine records in the virtual network in the Private DNS zone enabled?.')
  registrationEnabled: bool?

  @description('Optional. Resource tags.')
  tags: object?
}[]?
