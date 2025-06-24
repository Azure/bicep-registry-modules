metadata name = 'Azure NetApp Files Capacity Pools'
metadata description = 'This module deploys an Azure NetApp Files Capacity Pool.'

@description('Conditional. The name of the parent NetApp account. Required if the template is used in a standalone deployment.')
param netAppAccountName string

@description('Required. The name of the capacity pool.')
param name string

@description('Optional. Location of the pool volume.')
param location string = resourceGroup().location

@description('Optional. Tags for all resources.')
param tags object?

@description('Optional. The pool service level.')
@allowed([
  'Premium'
  'Standard'
  'StandardZRS'
  'Ultra'
])
param serviceLevel string = 'Standard'

@description('Required. Provisioned size of the pool in Tebibytes (TiB).')
@minValue(1)
@maxValue(2048)
param size int

@description('Optional. The qos type of the pool.')
@allowed([
  'Auto'
  'Manual'
])
param qosType string = 'Auto'

@description('Optional. List of volumes to create in the capacity pool.')
param volumes volumeType[]?

@description('Optional. If enabled (true) the pool can contain cool Access enabled volumes.')
param coolAccess bool = false

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Encryption type of the capacity pool, set encryption type for data at rest for this pool and all volumes in it. This value can only be set when creating new pool.')
@allowed([
  'Double'
  'Single'
])
param encryptionType string = 'Single'

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
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

resource netAppAccount 'Microsoft.NetApp/netAppAccounts@2025-01-01' existing = {
  name: netAppAccountName
}

resource capacityPool 'Microsoft.NetApp/netAppAccounts/capacityPools@2025-01-01' = {
  name: name
  parent: netAppAccount
  location: location
  tags: tags
  properties: {
    serviceLevel: serviceLevel
    size: tebibytesToBytes(size)
    qosType: qosType
    coolAccess: coolAccess
    encryptionType: encryptionType
  }
}

@batchSize(1)
module capacityPool_volumes 'volume/main.bicep' = [
  for (volume, index) in (volumes ?? []): {
    name: '${deployment().name}-Vol-${index}'
    params: {
      netAppAccountName: netAppAccount.name
      capacityPoolName: capacityPool.name
      name: volume.name
      location: location
      serviceLevel: serviceLevel
      creationToken: volume.?creationToken ?? volume.name
      usageThreshold: volume.usageThreshold
      protocolTypes: volume.protocolTypes
      subnetResourceId: volume.subnetResourceId
      exportPolicy: volume.?exportPolicy
      roleAssignments: volume.?roleAssignments
      networkFeatures: volume.?networkFeatures
      zone: volume.?zone
      coolAccess: volume.?coolAccess ?? false
      coolAccessRetrievalPolicy: volume.?coolAccessRetrievalPolicy
      coolnessPeriod: volume.?coolnessPeriod
      encryptionKeySource: volume.?encryptionKeySource ?? 'Microsoft.NetApp'
      keyVaultPrivateEndpointResourceId: volume.?keyVaultPrivateEndpointResourceId
      dataProtection: volume.?dataProtection
      kerberosEnabled: volume.?kerberosEnabled
      smbContinuouslyAvailable: volume.?smbContinuouslyAvailable
      smbEncryption: volume.?smbEncryption
      smbNonBrowsable: volume.?smbNonBrowsable
      volumeType: volume.?volumeType
      securityStyle: volume.?securityStyle
      unixPermissions: volume.?unixPermissions
      throughputMibps: volume.?throughputMibps
    }
  }
]

resource capacityPool_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(capacityPool.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: capacityPool
  }
]

@description('The name of the Capacity Pool.')
output name string = capacityPool.name

@description('The resource ID of the Capacity Pool.')
output resourceId string = capacityPool.id

@description('The name of the Resource Group the Capacity Pool was created in.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = capacityPool.location

@description('The resource IDs of the volume created in the capacity pool.')
output volumeResourceIds string[] = [
  for (volume, index) in (volumes ?? []): capacityPool_volumes[index].outputs.resourceId
]

// ================ //
// Definitions      //
// ================ //

import { dataProtectionType, exportPolicyType } from 'volume/main.bicep'
@export()
@description('The type for a volume in the capacity pool.')
type volumeType = {
  @description('Required. The name of the pool volume.')
  name: string

  @description('Optional. If enabled (true) the pool can contain cool Access enabled volumes.')
  coolAccess: bool?

  @description('Optional. Specifies the number of days after which data that is not accessed by clients will be tiered.')
  coolnessPeriod: int?

  @description('Optional. Determines the data retrieval behavior from the cool tier to standard storage based on the read pattern for cool access enabled volumes (Default/Never/Read).')
  coolAccessRetrievalPolicy: string?

  @description('Optional. The source of the encryption key.')
  encryptionKeySource: string?

  @description('Optional. The resource ID of the key vault private endpoint.')
  keyVaultPrivateEndpointResourceId: string?

  @description('Optional. DataProtection type volumes include an object containing details of the replication.')
  dataProtection: dataProtectionType?

  @description('Optional. Location of the pool volume.')
  location: string?

  @description('Required. The Availability Zone to place the resource in. If set to 0, then Availability Zone is not set.')
  @sys.allowed([
    0
    1
    2
    3
  ])
  zone: int

  @description('Optional. The pool service level. Must match the one of the parent capacity pool.')
  serviceLevel: ('Premium' | 'Standard' | 'StandardZRS' | 'Ultra')?

  @description('Optional. Network feature for the volume.')
  networkFeatures: ('Basic' | 'Basic_Standard' | 'Standard' | 'Standard_Basic')?

  @description('Optional. A unique file path for the volume. This is the name of the volume export. A volume is mounted using the export path. File path must start with an alphabetical character and be unique within the subscription.')
  creationToken: string?

  @description('Required. Maximum storage quota allowed for a file system in bytes.')
  usageThreshold: int

  @description('Optional. Set of protocol types. Default value is `[\'NFSv3\']`. If you are creating a dual-stack volume, set either `[\'NFSv3\',\'CIFS\']` or `[\'NFSv4.1\',\'CIFS\']`.')
  protocolTypes: ('NFSv3' | 'NFSv4.1' | 'CIFS')[]?

  @description('Required. The Azure Resource URI for a delegated subnet. Must have the delegation Microsoft.NetApp/volumes.')
  subnetResourceId: string

  @description('Optional. Export policy rules.')
  exportPolicy: exportPolicyType?

  @description('Optional. Array of role assignments to create.')
  roleAssignments: roleAssignmentType[]?

  @description('Optional. Enables SMB encryption. Only applicable for SMB/DualProtocol volume.')
  smbEncryption: bool?

  @description('Optional. Enables continuously available share property for SMB volume. Only applicable for SMB volume.')
  smbContinuouslyAvailable: bool?

  @description('Optional. Enables non-browsable property for SMB Shares. Only applicable for SMB/DualProtocol volume.')
  smbNonBrowsable: ('Enabled' | 'Disabled')?

  @description('Optional. Define if a volume is KerberosEnabled.')
  kerberosEnabled: bool?

  @description('Optional. The type of the volume. DataProtection volumes are used for replication.')
  volumeType: string?

  @description('Optional. The throughput in MiBps for the NetApp account.')
  throughputMibps: int?
}

// ================ //
// Functions        //
// ================ //

@description('Converts from tebibytes to bytes.')
func tebibytesToBytes(tebibytes int) int => tebibytes * 1024 * 1024 * 1024 * 1024
