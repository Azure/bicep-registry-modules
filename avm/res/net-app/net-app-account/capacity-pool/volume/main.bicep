metadata name = 'Azure NetApp Files Capacity Pool Volumes'
metadata description = 'This module deploys an Azure NetApp Files Capacity Pool Volume.'

@description('Conditional. The name of the parent NetApp account. Required if the template is used in a standalone deployment.')
param netAppAccountName string

@description('Conditional. The name of the parent capacity pool. Required if the template is used in a standalone deployment.')
param capacityPoolName string

@description('Required. The name of the pool volume.')
param name string

@description('Optional. Location of the pool volume.')
param location string = resourceGroup().location

@description('Required. If enabled (true) the pool can contain cool Access enabled volumes.')
param coolAccess bool

@description('Optional. Specifies the number of days after which data that is not accessed by clients will be tiered.')
param coolnessPeriod int?

@description('Optional. Determines the data retrieval behavior from the cool tier to standard storage based on the read pattern for cool access enabled volumes (Default/Never/Read).')
param coolAccessRetrievalPolicy string?

@description('Required. The source of the encryption key.')
param encryptionKeySource string

@description('Optional. The resource ID of the key vault private endpoint.')
param keyVaultPrivateEndpointResourceId string?

@description('Optional. The type of the volume. DataProtection volumes are used for replication.')
param volumeType string?

@description('Required. The Availability Zone to place the resource in. If set to 0, then Availability Zone is not set.')
@allowed([
  0
  1
  2
  3
])
param zone int

@description('Optional. The pool service level. Must match the one of the parent capacity pool.')
@allowed([
  'Premium'
  'Standard'
  'StandardZRS'
  'Ultra'
])
param serviceLevel string = 'Standard'

@description('Optional. Network feature for the volume.')
@allowed([
  'Basic'
  'Basic_Standard'
  'Standard'
  'Standard_Basic'
])
param networkFeatures string = 'Standard'

@description('Optional. A unique file path for the volume. This is the name of the volume export. A volume is mounted using the export path. File path must start with an alphabetical character and be unique within the subscription.')
param creationToken string = name

@description('Required. Maximum storage quota allowed for a file system in bytes.')
param usageThreshold int

@description('Optional. Set of protocol types. Default value is `[\'NFSv3\']`. If you are creating a dual-stack volume, set either `[\'NFSv3\',\'CIFS\']` or `[\'NFSv4.1\',\'CIFS\']`.')
@allowed([
  'NFSv3'
  'NFSv4.1'
  'CIFS'
])
param protocolTypes string[] = ['NFSv3']

@description('Required. The Azure Resource URI for a delegated subnet. Must have the delegation Microsoft.NetApp/volumes.')
param subnetResourceId string

@description('Optional. The export policy rules.')
param exportPolicy exportPolicyType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. DataProtection type volumes include an object containing details of the replication.')
param dataProtection dataProtectionType?

@description('Optional. Enables SMB encryption. Only applicable for SMB/DualProtocol volume.')
param smbEncryption bool = false

@description('Optional. Enables continuously available share property for SMB volume. Only applicable for SMB volume.')
param smbContinuouslyAvailable bool = false

@description('Optional. Enables non-browsable property for SMB Shares. Only applicable for SMB/DualProtocol volume.')
@allowed([
  'Enabled'
  'Disabled'
])
param smbNonBrowsable string = 'Disabled'

@description('Optional. Define if a volume is KerberosEnabled.')
param kerberosEnabled bool = false

@allowed([
  'ntfs'
  'unix'
])
@description('Optional. Defines the security style of the Volume.')
param securityStyle string?

@description('Optional. Unix Permissions for NFS volume.')
param unixPermissions string?

@description('Optional. The throughput in MiBps for the NetApp account.')
param throughputMibps int?

var remoteCapacityPoolName = !empty(dataProtection.?replication.?remoteVolumeResourceId)
  ? split(dataProtection.?replication.?remoteVolumeResourceId!, '/')[10]
  : ''
var remoteNetAppName = !empty(dataProtection.?replication.?remoteVolumeResourceId)
  ? split(dataProtection.?replication.?remoteVolumeResourceId!, '/')[8]
  : ''

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

  //cp-na-anfs-swc-y01
  resource capacityPool 'capacityPools@2025-01-01' existing = {
    name: capacityPoolName
  }

  resource backupVault 'backupVaults@2025-01-01' existing = if (!empty(dataProtection.?backup)) {
    name: dataProtection.?backup!.backupVaultName
  }

  resource backupPolicy 'backupPolicies@2025-01-01' existing = if (!empty(dataProtection.?backup)) {
    name: dataProtection.?backup!.backupPolicyName
  }

  resource snapshotPolicy 'snapshotPolicies@2025-01-01' existing = if (!empty(dataProtection.?snapshot)) {
    name: dataProtection.?snapshot!.snapshotPolicyName
  }
}

resource keyVaultPrivateEndpoint 'Microsoft.Network/privateEndpoints@2024-03-01' existing = if (encryptionKeySource != 'Microsoft.NetApp') {
  name: last(split(keyVaultPrivateEndpointResourceId!, '/'))
  scope: resourceGroup(
    split(keyVaultPrivateEndpointResourceId!, '/')[2],
    split(keyVaultPrivateEndpointResourceId!, '/')[4]
  )
}

resource remoteNetAppAccount 'Microsoft.NetApp/netAppAccounts@2025-01-01' existing = if (!empty(dataProtection.?replication.?remoteVolumeResourceId) && (remoteNetAppName != netAppAccountName)) {
  name: split(dataProtection.?replication.?remoteVolumeResourceId!, '/')[8]
  scope: resourceGroup(
    split(dataProtection.?replication.?remoteVolumeResourceId!, '/')[2],
    split(dataProtection.?replication.?remoteVolumeResourceId!, '/')[4]
  )

  //cp-na-anfs-swc-y01
  resource remoteCapacityPool 'capacityPools@2025-01-01' existing = if (!empty(dataProtection.?replication.?remoteVolumeResourceId) && (remoteCapacityPoolName != capacityPoolName)) {
    name: split(dataProtection.?replication.?remoteVolumeResourceId!, '/')[10]

    resource remoteVolume 'volumes@2025-01-01' existing = if (!empty(dataProtection.?replication)) {
      name: last(split(dataProtection.?replication.?remoteVolumeResourceId!, '/'))
    }
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2024-03-01' existing = {
  name: split(subnetResourceId, '/')[8]
  scope: resourceGroup(split(subnetResourceId, '/')[2], split(subnetResourceId, '/')[4])

  resource subnet 'subnets@2024-03-01' existing = {
    name: last(split(subnetResourceId, '/'))
  }
}

resource volume 'Microsoft.NetApp/netAppAccounts/capacityPools/volumes@2025-01-01' = {
  name: name
  parent: netAppAccount::capacityPool
  location: location
  properties: {
    coolAccess: coolAccess
    coolAccessRetrievalPolicy: coolAccessRetrievalPolicy
    coolnessPeriod: coolnessPeriod
    securityStyle: securityStyle
    unixPermissions: unixPermissions
    encryptionKeySource: encryptionKeySource
    ...(encryptionKeySource != 'Microsoft.NetApp'
      ? {
          keyVaultPrivateEndpointResourceId: keyVaultPrivateEndpoint.id
        }
      : {})
    ...(!empty(volumeType)
      ? {
          volumeType: volumeType
        }
      : {})
    dataProtection: !empty(dataProtection)
      ? {
          replication: !empty(dataProtection.?replication)
            ? {
                endpointType: dataProtection.?replication!.endpointType
                remoteVolumeRegion: !empty(dataProtection.?replication.?remoteVolumeRegion)
                  ? dataProtection.?replication!.?remoteVolumeRegion
                  : null
                remoteVolumeResourceId: dataProtection.?replication!.?remoteVolumeResourceId
                ...(dataProtection.?replication!.?endpointType == 'dst')
                  ? {
                      replicationSchedule: dataProtection.?replication!.?replicationSchedule
                    }
                  : {}
                ...(volumeType == 'Migration')
                  ? {
                      remotePath: dataProtection.?replication!.?remotePath
                    }
                  : {}
              }
            : null
          backup: !empty(dataProtection.?backup)
            ? {
                backupPolicyId: netAppAccount::backupPolicy.id
                policyEnforced: dataProtection.?backup.policyEnforced ?? false
                backupVaultId: netAppAccount::backupVault.id
              }
            : null
          snapshot: !empty(dataProtection.?snapshot)
            ? {
                snapshotPolicyId: netAppAccount::snapshotPolicy.id
              }
            : null
        }
      : null
    networkFeatures: networkFeatures
    serviceLevel: serviceLevel
    creationToken: creationToken
    usageThreshold: usageThreshold
    protocolTypes: protocolTypes
    subnetId: vnet::subnet.id
    exportPolicy: exportPolicy ?? {
      rules: []
    }
    smbContinuouslyAvailable: smbContinuouslyAvailable
    smbEncryption: smbEncryption
    smbNonBrowsable: smbNonBrowsable
    kerberosEnabled: kerberosEnabled
    ...(throughputMibps != null
      ? {
          throughputMibps: throughputMibps
        }
      : {})
  }
  zones: zone != 0 ? [string(zone)] : null
}

resource volume_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(volume.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: volume
  }
]

@description('The name of the Volume.')
output name string = volume.name

@description('The Resource ID of the Volume.')
output resourceId string = volume.id

@description('The name of the Resource Group the Volume was created in.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = volume.location

// ================ //
// Definitions      //
// ================ //
@export()
@description('The type for the data protection properties.')
type dataProtectionType = {
  @description('Optional. Replication properties.')
  replication: replicationType?

  @description('Optional. Backup properties.')
  backup: backupType?

  @description('Optional. Snapshot properties.')
  snapshot: snapshotType?
}

@description('The type for the replication properties.')
type replicationType = {
  @description('Required. Indicates whether the local volume is the source or destination for the Volume Replication.')
  endpointType: ('dst' | 'src')

  @description('Optional. The remote region for the other end of the Volume Replication.Required for Data Protection volumes.')
  remoteVolumeRegion: string?

  @description('Optional. The resource ID of the remote volume. Required for Data Protection volumes.')
  remoteVolumeResourceId: string?

  @description('Optional. The replication schedule for the volume (to only be set on the destination (dst)).')
  replicationSchedule: ('_10minutely' | 'daily' | 'hourly')?

  @description('Optional. The full path to a volume that is to be migrated into ANF. Required for Migration volumes.')
  remotePath: {
    @description('Required. The Path to a ONTAP Host.')
    externalHostName: string

    @description('Required. The name of a server on the ONTAP Host.')
    serverName: string

    @description('Required. The name of a volume on the server.')
    volumeName: string
  }?
}

@description('The type for the backup properties.')
type backupType = {
  @description('Required. The name of the backup policy to link.')
  backupPolicyName: string

  @description('Required. Enable to enforce the policy.')
  policyEnforced: bool

  @description('Required. The name of the Backup Vault.')
  backupVaultName: string
}

@description('The type for the snapshot properties.')
type snapshotType = {
  @description('Required. The name of the snapshot policy to link.')
  snapshotPolicyName: string
}

@export()
@description('The type for export policy rules.')
type exportPolicyType = {
  @description('Required. The Export policy rules.')
  rules: {
    @description('Required. Order index.')
    ruleIndex: int

    @description('Optional. Client ingress specification as comma separated string with IPv4 CIDRs, IPv4 host addresses and host names.')
    allowedClients: string?

    @description('Optional. This parameter specifies who is authorized to change the ownership of a file. restricted - Only root user can change the ownership of the file. unrestricted - Non-root users can change ownership of files that they own.')
    chownMode: ('Restricted' | 'Unrestricted')?

    @description('Optional. Allows CIFS protocol.')
    cifs: bool?

    @description('Optional. Has root access to volume.')
    hasRootAccess: bool?

    @description('Required. Kerberos5 Read only access.')
    kerberos5ReadOnly: bool

    @description('Required. Kerberos5 Read and write access.')
    kerberos5ReadWrite: bool

    @description('Required. Kerberos5i Read only access.')
    kerberos5iReadOnly: bool

    @description('Required. Kerberos5i Read and write access.')
    kerberos5iReadWrite: bool

    @description('Required. Kerberos5p Read only access.')
    kerberos5pReadOnly: bool

    @description('Required. Kerberos5p Read and write access.')
    kerberos5pReadWrite: bool

    @description('Required. Allows NFSv3 protocol. Enable only for NFSv3 type volumes.')
    nfsv3: bool

    @description('Required. Allows NFSv4.1 protocol. Enable only for NFSv4.1 type volumes.')
    nfsv41: bool

    @description('Required. Read only access.')
    unixReadOnly: bool

    @description('Required. Read and write access.')
    unixReadWrite: bool
  }[]
}
