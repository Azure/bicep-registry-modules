metadata name = 'Azure NetApp Files'
metadata description = 'This module deploys an Azure NetApp Files Account and the associated resource types such as backups, capacity pools and volumes.'

@description('Required. The name of the NetApp account.')
param name string

@description('Optional. Name of the active directory host as part of Kerberos Realm used for Kerberos authentication.')
param adName string = ''

@description('Optional. Enable AES encryption on the SMB Server.')
param aesEncryption bool = false

import { customerManagedKeyType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The customer managed key definition.')
param customerManagedKey customerManagedKeyType?

@description('Optional. Fully Qualified Active Directory DNS Domain Name (e.g. \'contoso.com\').')
param domainName string = ''

@description('Optional. Required if domainName is specified. Username of Active Directory domain administrator, with permissions to create SMB server machine account in the AD domain.')
param domainJoinUser string = ''

@description('Optional. Required if domainName is specified. Password of the user specified in domainJoinUser parameter.')
@secure()
param domainJoinPassword string = ''

@description('Optional. Used only if domainName is specified. LDAP Path for the Organization Unit (OU) where SMB Server machine accounts will be created (i.e. \'OU=SecondLevel,OU=FirstLevel\').')
param domainJoinOU string = ''

@description('Optional. Required if domainName is specified. Comma separated list of DNS server IP addresses (IPv4 only) required for the Active Directory (AD) domain join and SMB authentication operations to succeed.')
param dnsServers string = ''

@description('Optional. Specifies whether encryption should be used for communication between SMB server and domain controller (DC). SMB3 only.')
param encryptDCConnections bool = false

@description('Optional. If enabled, NFS client local users can also (in addition to LDAP users) access the NFS volumes.')
param allowLocalNfsUsersWithLdap bool = false

@description('Optional. Required if domainName is specified. NetBIOS name of the SMB server. A computer account with this prefix will be registered in the AD and used to mount volumes.')
param smbServerNamePrefix string = ''

@description('Optional. Capacity pools to create.')
param capacityPools capacityPoolType[]?

import { managedIdentityOnlyUserAssignedType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityOnlyUserAssignedType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Kerberos Key Distribution Center (KDC) as part of Kerberos Realm used for Kerberos authentication.')
param kdcIP string = ''

@description('Optional. Specifies whether to use TLS when NFS (with/without Kerberos) and SMB volumes communicate with an LDAP server. A server root CA certificate must be uploaded if enabled (serverRootCACertificate).')
param ldapOverTLS bool = false

@description('Optional. Specifies whether or not the LDAP traffic needs to be signed.')
param ldapSigning bool = false

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

@description('Optional. A server Root certificate is required of ldapOverTLS is enabled.')
param serverRootCACertificate string = ''

@description('Optional. Tags for all resources.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. The netapp backup vault to create & configure.')
param backupVault backupVaultType?

@description('Optional. The snapshot policies to create.')
param snapshotPolicies snapshotPolicyType[]?

@description('Optional. The backup policies to create.')
param backupPolicies backupPolicyType[]?

var activeDirectoryConnectionProperties = [
  {
    adName: !empty(domainName) ? adName : null
    aesEncryption: !empty(domainName) ? aesEncryption : false
    username: !empty(domainName) ? domainJoinUser : null
    password: !empty(domainName) ? domainJoinPassword : null
    domain: !empty(domainName) ? domainName : null
    dns: !empty(domainName) ? dnsServers : null
    encryptDCConnections: !empty(domainName) ? encryptDCConnections : false
    kdcIP: !empty(domainName) ? kdcIP : null
    ldapOverTLS: !empty(domainName) ? ldapOverTLS : false
    ldapSigning: !empty(domainName) ? ldapSigning : false
    serverRootCACertificate: !empty(domainName) ? serverRootCACertificate : null
    smbServerName: !empty(domainName) ? smbServerNamePrefix : null
    organizationalUnit: !empty(domainJoinOU) ? domainJoinOU : null
    allowLocalNfsUsersWithLdap: !empty(domainName) ? allowLocalNfsUsersWithLdap : false
  }
]

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: !empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : 'None'
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

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

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2023-07-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.netapp-netappaccount.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource cMKKeyVault 'Microsoft.KeyVault/vaults@2023-02-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId!)) {
  name: last(split((customerManagedKey.?keyVaultResourceId!), '/'))
  scope: resourceGroup(
    split(customerManagedKey.?keyVaultResourceId!, '/')[2],
    split(customerManagedKey.?keyVaultResourceId!, '/')[4]
  )

  resource cMKKey 'keys@2023-02-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId) && !empty(customerManagedKey.?keyName)) {
    name: customerManagedKey.?keyName!
  }
}

resource cMKUserAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = if (!empty(customerManagedKey.?userAssignedIdentityResourceId)) {
  name: last(split(customerManagedKey.?userAssignedIdentityResourceId!, '/'))
  scope: resourceGroup(
    split(customerManagedKey.?userAssignedIdentityResourceId!, '/')[2],
    split(customerManagedKey.?userAssignedIdentityResourceId!, '/')[4]
  )
}

resource netAppAccount 'Microsoft.NetApp/netAppAccounts@2025-01-01' = {
  name: name
  tags: tags
  identity: identity
  location: location
  properties: {
    activeDirectories: !empty(domainName) ? activeDirectoryConnectionProperties : null
    encryption: !empty(customerManagedKey)
      ? {
          identity: !empty(customerManagedKey.?userAssignedIdentityResourceId)
            ? {
                userAssignedIdentity: cMKUserAssignedIdentity.id
              }
            : null
          keySource: 'Microsoft.KeyVault'
          keyVaultProperties: {
            keyName: customerManagedKey!.keyName
            keyVaultResourceId: cMKKeyVault.id
            keyVaultUri: cMKKeyVault.properties.vaultUri
          }
        }
      : null
  }
}

resource netAppAccount_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: netAppAccount
}

resource netAppAccount_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(netAppAccount.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: netAppAccount
  }
]

module netAppAccount_backupPolicies 'backup-policy/main.bicep' = [
  for (backupPolicy, index) in (backupPolicies ?? []): {
    name: '${uniqueString(deployment().name, location)}-ANFAccount-backupPolicy-${index}'
    params: {
      netAppAccountName: netAppAccount.name
      name: backupPolicy.?name
      dailyBackupsToKeep: backupPolicy.?dailyBackupsToKeep
      monthlyBackupsToKeep: backupPolicy.?monthlyBackupsToKeep
      weeklyBackupsToKeep: backupPolicy.?weeklyBackupsToKeep
      enabled: backupPolicy.?enabled
      location: backupPolicy.?location ?? location
    }
  }
]

module netAppAccount_snapshotPolicies 'snapshot-policy/main.bicep' = [
  for (snapshotPolicy, index) in (snapshotPolicies ?? []): {
    name: '${uniqueString(deployment().name, location)}-ANFAccount-snapshotPolicy-${index}'
    params: {
      netAppAccountName: netAppAccount.name
      name: snapshotPolicy.?name
      location: snapshotPolicy.?location ?? location
      snapEnabled: snapshotPolicy.?snapEnabled
      dailySchedule: snapshotPolicy.?dailySchedule
      hourlySchedule: snapshotPolicy.?hourlySchedule
      monthlySchedule: snapshotPolicy.?monthlySchedule
      weeklySchedule: snapshotPolicy.?weeklySchedule
    }
  }
]

module netAppAccount_backupVault 'backup-vault/main.bicep' = if (!empty(backupVault)) {
  name: '${uniqueString(deployment().name, location)}-ANFAccount-BackupVault'
  params: {
    netAppAccountName: netAppAccount.name
    name: backupVault.?name
    location: backupVault.?location ?? location
  }
}

module netAppAccount_capacityPools 'capacity-pool/main.bicep' = [
  for (capacityPool, index) in (capacityPools ?? []): {
    name: '${uniqueString(deployment().name, location)}-ANFAccount-CapPool-${index}'
    params: {
      netAppAccountName: netAppAccount.name
      name: capacityPool.name
      size: capacityPool.size
      location: capacityPool.?location ?? location
      serviceLevel: capacityPool.?serviceLevel ?? 'Standard'
      qosType: capacityPool.?qosType ?? 'Auto'
      volumes: capacityPool.?volumes ?? []
      coolAccess: capacityPool.?coolAccess ?? false
      roleAssignments: capacityPool.?roleAssignments ?? []
      encryptionType: capacityPool.?encryptionType ?? 'Single'
      tags: capacityPool.?tags ?? tags
    }
    dependsOn: [
      netAppAccount_backupPolicies
      netAppAccount_snapshotPolicies
      netAppAccount_backupVault
    ]
  }
]

module netAppAccount_backupVaultBackups 'backup-vault/main.bicep' = if (!empty(backupVault.?backups)) {
  name: '${uniqueString(deployment().name, location)}-ANFAccount-BackupVault-Backups'
  params: {
    netAppAccountName: netAppAccount.name
    name: backupVault.?name
    backups: backupVault.?backups
    location: backupVault.?location ?? location
  }
  dependsOn: [
    netAppAccount_capacityPools
  ]
}

@description('The name of the NetApp account.')
output name string = netAppAccount.name

@description('The Resource ID of the NetApp account.')
output resourceId string = netAppAccount.id

@description('The name of the Resource Group the NetApp account was created in.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = netAppAccount.location

@description('The resource IDs of the created capacity pools & their volumes.')
output capacityPoolResourceIds {
  resourceId: string
  volumeResourceIds: string[]
}[] = [
  for (capacityPools, index) in (capacityPools ?? []): {
    resourceId: netAppAccount_capacityPools[index].outputs.resourceId
    volumeResourceIds: netAppAccount_capacityPools[index].outputs.volumeResourceIds
  }
]

// ================ //
// Definitions      //
// ================ //

import { backupType } from 'backup-vault/main.bicep'
@export()
@description('The type for a backup vault.')
type backupVaultType = {
  @description('Optional. The name of the backup vault.')
  name: string?

  @description('Optional. The list of backups to create.')
  backups: backupType[]?

  @description('Optional. Location of the backup vault.')
  location: string?
}

import { volumeType } from 'capacity-pool/main.bicep'
@export()
@description('The type for a capacity pool.')
type capacityPoolType = {
  @description('Required. The name of the capacity pool.')
  name: string

  @description('Optional. Location of the pool volume.')
  location: string?

  @description('Optional. Tags for the capcity pool.')
  tags: object?

  @description('Optional. The pool service level.')
  serviceLevel: ('Premium' | 'Standard' | 'StandardZRS' | 'Ultra')?

  @description('Required. Provisioned size of the pool in Tebibytes (TiB).')
  @minValue(1)
  @maxValue(2048)
  size: int

  @description('Optional. The qos type of the pool.')
  qosType: ('Auto' | 'Manual')?

  @description('Optional. List of volumes to create in the capacity pool.')
  volumes: volumeType[]?

  @description('Optional. If enabled (true) the pool can contain cool Access enabled volumes.')
  coolAccess: bool?

  @description('Optional. Array of role assignments to create.')
  roleAssignments: roleAssignmentType[]?

  @description('Optional. Encryption type of the capacity pool, set encryption type for data at rest for this pool and all volumes in it. This value can only be set when creating new pool.')
  encryptionType: ('Single' | 'Double')?
}

import { dailyScheduleType, hourlyScheduleType, monthlyScheduleType, weeklyScheduleType } from 'snapshot-policy/main.bicep'
@export()
@description('The type for a snapshot policy.')
type snapshotPolicyType = {
  @description('Required. The name of the snapshot policy.')
  name: string

  @description('Optional. Location of the snapshot policy.')
  location: string?

  @description('Optional. Daily schedule for the snapshot policy.')
  dailySchedule: dailyScheduleType?

  @description('Optional. Hourly schedule for the snapshot policy.')
  hourlySchedule: hourlyScheduleType?

  @description('Optional. Monthly schedule for the snapshot policy.')
  monthlySchedule: monthlyScheduleType?

  @description('Optional. Weekly schedule for the snapshot policy.')
  weeklySchedule: weeklyScheduleType?
}

@export()
@description('The type for a backup policy.')
type backupPolicyType = {
  @description('Optional. The name of the backup policy.')
  name: string?

  @description('Optional. The location of the backup policy.')
  location: string?

  @description('Optional. The daily backups to keep. Note, the maximum hourly, daily, weekly, and monthly backup retention counts _combined_ is 1019 (this parameter\'s max).')
  @minValue(2)
  @maxValue(1019)
  dailyBackupsToKeep: int?

  @description('Optional. The monthly backups to keep. Note, the maximum hourly, daily, weekly, and monthly backup retention counts _combined_ is 1019 (this parameter\'s max).')
  @minValue(0)
  @maxValue(1019)
  monthlyBackupsToKeep: int?

  @description('Optional. The weekly backups to keep. Note, the maximum hourly, daily, weekly, and monthly backup retention counts _combined_ is 1019 (this parameter\'s max).')
  @minValue(0)
  @maxValue(1019)
  weeklyBackupsToKeep: int?

  @description('Optional. Indicates whether the backup policy is enabled.')
  enabled: bool?
}
