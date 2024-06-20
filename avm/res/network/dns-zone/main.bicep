metadata name = 'Public DNS Zones'
metadata description = 'This module deploys a Public DNS zone.'
metadata owner = 'Azure/module-maintainers'

@description('Required. DNS zone name.')
@minLength(1)
@maxLength(63)
param name string

@description('Optional. Array of A records.')
param a aType

@description('Optional. Array of AAAA records.')
param aaaa aaaaType

@description('Optional. Array of CNAME records.')
param cname cnameType

@description('Optional. Array of CAA records.')
param caa caaType

@description('Optional. Array of MX records.')
param mx mxType

@description('Optional. Array of NS records.')
param ns nsType

@description('Optional. Array of PTR records.')
param ptr ptrType

@description('Optional. Array of SOA records.')
param soa soaType

@description('Optional. Array of SRV records.')
param srv srvType

@description('Optional. Array of TXT records.')
param txt txtType

@description('Optional. The location of the dnsZone. Should be global.')
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
  'User Access Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  )
}

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.network-dnszone.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource dnsZone 'Microsoft.Network/dnsZones@2018-05-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    zoneType: 'Public'
  }
}

module dnsZone_A 'a/main.bicep' = [
  for (aRecord, index) in (a ?? []): {
    name: '${uniqueString(deployment().name, location)}-dnsZone-ARecord-${index}'
    params: {
      dnsZoneName: dnsZone.name
      name: aRecord.name
      aRecords: aRecord.?aRecords
      metadata: aRecord.?metadata
      ttl: aRecord.?ttl ?? 3600
      targetResourceId: aRecord.?targetResourceId
      roleAssignments: aRecord.?roleAssignments
    }
  }
]

module dnsZone_AAAA 'aaaa/main.bicep' = [
  for (aaaaRecord, index) in (aaaa ?? []): {
    name: '${uniqueString(deployment().name, location)}-dnsZone-AAAARecord-${index}'
    params: {
      dnsZoneName: dnsZone.name
      name: aaaaRecord.name
      aaaaRecords: aaaaRecord.?aaaaRecords
      metadata: aaaaRecord.?metadata
      ttl: aaaaRecord.?ttl ?? 3600
      targetResourceId: aaaaRecord.?targetResourceId
      roleAssignments: aaaaRecord.?roleAssignments
    }
  }
]

module dnsZone_CNAME 'cname/main.bicep' = [
  for (cnameRecord, index) in (cname ?? []): {
    name: '${uniqueString(deployment().name, location)}-dnsZone-CNAMERecord-${index}'
    params: {
      dnsZoneName: dnsZone.name
      name: cnameRecord.name
      cnameRecord: cnameRecord.?cnameRecord
      metadata: cnameRecord.?metadata
      ttl: cnameRecord.?ttl ?? 3600
      targetResourceId: cnameRecord.?targetResourceId
      roleAssignments: cnameRecord.?roleAssignments
    }
  }
]

module dnsZone_CAA 'caa/main.bicep' = [
  for (caaRecord, index) in (caa ?? []): {
    name: '${uniqueString(deployment().name, location)}-dnsZone-CAARecord-${index}'
    params: {
      dnsZoneName: dnsZone.name
      name: caaRecord.name
      metadata: caaRecord.?metadata
      caaRecords: caaRecord.?caaRecords
      ttl: caaRecord.?ttl ?? 3600
      roleAssignments: caaRecord.?roleAssignments
    }
  }
]

module dnsZone_MX 'mx/main.bicep' = [
  for (mxRecord, index) in (mx ?? []): {
    name: '${uniqueString(deployment().name, location)}-dnsZone-MXRecord-${index}'
    params: {
      dnsZoneName: dnsZone.name
      name: mxRecord.name
      metadata: mxRecord.?metadata
      mxRecords: mxRecord.?mxRecords
      ttl: mxRecord.?ttl ?? 3600
      roleAssignments: mxRecord.?roleAssignments
    }
  }
]

module dnsZone_NS 'ns/main.bicep' = [
  for (nsRecord, index) in (ns ?? []): {
    name: '${uniqueString(deployment().name, location)}-dnsZone-NSRecord-${index}'
    params: {
      dnsZoneName: dnsZone.name
      name: nsRecord.name
      metadata: nsRecord.?metadata
      nsRecords: nsRecord.?nsRecords
      ttl: nsRecord.?ttl ?? 3600
      roleAssignments: nsRecord.?roleAssignments
    }
  }
]

module dnsZone_PTR 'ptr/main.bicep' = [
  for (ptrRecord, index) in (ptr ?? []): {
    name: '${uniqueString(deployment().name, location)}-dnsZone-PTRRecord-${index}'
    params: {
      dnsZoneName: dnsZone.name
      name: ptrRecord.name
      metadata: ptrRecord.?metadata
      ptrRecords: ptrRecord.?ptrRecords
      ttl: ptrRecord.?ttl ?? 3600
      roleAssignments: ptrRecord.?roleAssignments
    }
  }
]

module dnsZone_SOA 'soa/main.bicep' = [
  for (soaRecord, index) in (soa ?? []): {
    name: '${uniqueString(deployment().name, location)}-dnsZone-SOARecord-${index}'
    params: {
      dnsZoneName: dnsZone.name
      name: soaRecord.name
      metadata: soaRecord.?metadata
      soaRecord: soaRecord.?soaRecord
      ttl: soaRecord.?ttl ?? 3600
      roleAssignments: soaRecord.?roleAssignments
    }
  }
]

module dnsZone_SRV 'srv/main.bicep' = [
  for (srvRecord, index) in (srv ?? []): {
    name: '${uniqueString(deployment().name, location)}-dnsZone-SRVRecord-${index}'
    params: {
      dnsZoneName: dnsZone.name
      name: srvRecord.name
      metadata: srvRecord.?metadata
      srvRecords: srvRecord.?srvRecords
      ttl: srvRecord.?ttl ?? 3600
      roleAssignments: srvRecord.?roleAssignments
    }
  }
]

module dnsZone_TXT 'txt/main.bicep' = [
  for (txtRecord, index) in (txt ?? []): {
    name: '${uniqueString(deployment().name, location)}-dnsZone-TXTRecord-${index}'
    params: {
      dnsZoneName: dnsZone.name
      name: txtRecord.name
      metadata: txtRecord.?metadata
      txtRecords: txtRecord.?txtRecords
      ttl: txtRecord.?ttl ?? 3600
      roleAssignments: txtRecord.?roleAssignments
    }
  }
]

resource dnsZone_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: dnsZone
}

resource dnsZone_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (roleAssignments ?? []): {
    name: guid(dnsZone.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
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
    scope: dnsZone
  }
]

@description('The resource group the DNS zone was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the DNS zone.')
output name string = dnsZone.name

@description('The resource ID of the DNS zone.')
output resourceId string = dnsZone.id

@description('The location the resource was deployed into.')
output location string = dnsZone.location

// =============== //
//   Definitions   //
// =============== //

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

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

type aType = {
  @description('Required. The name of the record.')
  name: string

  @description('Optional. The metadata of the record.')
  metadata: object?

  @description('Optional. The TTL of the record.')
  ttl: int?

  @description('Optional. Array of role assignments to create.')
  roleAssignments: roleAssignmentType

  @description('Optional. A reference to an azure resource from where the dns resource value is taken. Also known as an alias record sets and are only supported for record types A, AAAA and CNAME. A resource ID can be an Azure Traffic Manager, Azure CDN, Front Door, Static Web App, or a resource ID of a record set of the same type in the DNS zone (i.e. A, AAAA or CNAME). Cannot be used in conjuction with the "aRecords" property.')
  targetResourceId: string?

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

  @description('Optional. A reference to an azure resource from where the dns resource value is taken. Also known as an alias record sets and are only supported for record types A, AAAA and CNAME. A resource ID can be an Azure Traffic Manager, Azure CDN, Front Door, Static Web App, or a resource ID of a record set of the same type in the DNS zone (i.e. A, AAAA or CNAME). Cannot be used in conjuction with the "aRecords" property.')
  targetResourceId: string?

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

  @description('Optional. A reference to an azure resource from where the dns resource value is taken. Also known as an alias record sets and are only supported for record types A, AAAA and CNAME. A resource ID can be an Azure Traffic Manager, Azure CDN, Front Door, Static Web App, or a resource ID of a record set of the same type in the DNS zone (i.e. A, AAAA or CNAME). Cannot be used in conjuction with the "aRecords" property.')
  targetResourceId: string?

  @description('Optional. The CNAME record in the record set.')
  cnameRecord: {
    @description('Required. The canonical name of the CNAME record.')
    cname: string
  }?
}[]?

type caaType = {
  @description('Required. The name of the record.')
  name: string

  @description('Optional. The metadata of the record.')
  metadata: object?

  @description('Optional. The TTL of the record.')
  ttl: int?

  @description('Optional. Array of role assignments to create.')
  roleAssignments: roleAssignmentType

  @description('Optional. The list of CAA records in the record set.')
  caaRecords: {
    @description('Required. The flags for this CAA record as an integer between 0 and 255.')
    @minValue(0)
    @maxValue(255)
    flags: int

    @description('Required. The tag for this CAA record..')
    tag: string

    @description('Required. The value for this CAA record.')
    value: string
  }[]?
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

type nsType = {
  @description('Required. The name of the record.')
  name: string

  @description('Optional. The metadata of the record.')
  metadata: object?

  @description('Optional. The TTL of the record.')
  ttl: int?

  @description('Optional. Array of role assignments to create.')
  roleAssignments: roleAssignmentType

  @description('Optional. The list of NS records in the record set.')
  nsRecords: {
    @description('Required. The name server name for this NS record.')
    nsdname: string
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
