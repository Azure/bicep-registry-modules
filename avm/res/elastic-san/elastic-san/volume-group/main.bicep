metadata name = 'Elastic SAN Volume Groups'
metadata description = 'This module deploys an Elastic SAN Volume Group.'

@sys.minLength(3)
@sys.maxLength(24)
@sys.description('Conditional. The name of the parent Elastic SAN. Required if the template is used in a standalone deployment. The name can only contain lowercase letters, numbers, hyphens and underscores, and must begin and end with a letter or a number. Each hyphen and underscore must be preceded and followed by an alphanumeric character.')
param elasticSanName string

@sys.minLength(3)
@sys.maxLength(63)
@sys.description('Required. The name of the Elastic SAN Volume Group. The name can only contain lowercase letters, numbers and hyphens, and must begin and end with a letter or a number. Each hyphen must be preceded and followed by an alphanumeric character.')
param name string

@sys.minLength(1)
@sys.description('Optional. Location for all resources.')
param location string = resourceGroup().location

@sys.description('Optional. List of Elastic SAN Volumes to be created in the Elastic SAN Volume Group. Elastic SAN Volume Group can contain up to 1,000 volumes.')
param volumes volumeType[]?

@sys.description('Optional. List of Virtual Network Rules, permitting virtual network subnet to connect to the resource through service endpoint. Each Elastic SAN Volume Group supports up to 200 virtual network rules.')
param virtualNetworkRules virtualNetworkRuleType[]?

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@sys.description('Optional. The managed identity definition for this resource. The Elastic SAN Volume Group supports the following identity combinations: no identity is specified, only system-assigned identity is specified, only user-assigned identity is specified, and both system-assigned and user-assigned identities are specified. A maximum of one user-assigned identity is supported.')
param managedIdentities managedIdentityAllType?

import { customerManagedKeyType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@sys.description('Optional. The customer managed key definition. This parameter enables the encryption of Elastic SAN Volume Group using a customer-managed key. Currently, the only supported configuration is to use the same user-assigned identity for both \'managedIdentities.userAssignedResourceIds\' and \'customerManagedKey.userAssignedIdentityResourceId\'. Other configurations such as system-assigned identity are not supported. Ensure that the specified user-assigned identity has the \'Key Vault Crypto Service Encryption User\' role access to both the key vault and the key itself. The key vault must also have purge protection enabled.')
param customerManagedKey customerManagedKeyType? // This requires KV with enabled purge protection

import { privateEndpointSingleServiceType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@sys.description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointSingleServiceType[]?

@sys.description('Optional. Tags of the Elastic SAN Volume Group resource.')
param tags object?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@sys.description('Optional. The lock settings of the service.')
param lock lockType?

// ============== //
// Variables      //
// ============== //

var enableReferencedModulesTelemetry = false

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'SystemAssigned, UserAssigned' : 'SystemAssigned')
        : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : 'None')
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

var networkRules = [
  for (virtualNetworkRule, i) in (virtualNetworkRules ?? []): {
    action: 'Allow' // Deny is not allowed for Network Rule Action.
    id: virtualNetworkRule.virtualNetworkSubnetResourceId
  }
]

// ============== //
// Resources      //
// ============== //

//
// Add your resources here
//

resource elasticSan 'Microsoft.ElasticSan/elasticSans@2023-01-01' existing = {
  name: elasticSanName
}

resource cMKKeyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId)) {
  name: last(split((customerManagedKey.?keyVaultResourceId ?? 'dummyVault'), '/'))
  scope: resourceGroup(
    split((customerManagedKey.?keyVaultResourceId ?? '//'), '/')[2],
    split((customerManagedKey.?keyVaultResourceId ?? '////'), '/')[4]
  )

  resource cMKKey 'keys@2023-07-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId) && !empty(customerManagedKey.?keyName)) {
    name: customerManagedKey.?keyName ?? 'dummyKey'
  }
}

resource cMKUserAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = if (!empty(customerManagedKey.?userAssignedIdentityResourceId)) {
  name: last(split(customerManagedKey.?userAssignedIdentityResourceId ?? 'dummyMsi', '/'))
  scope: resourceGroup(
    split((customerManagedKey.?userAssignedIdentityResourceId ?? '//'), '/')[2],
    split((customerManagedKey.?userAssignedIdentityResourceId ?? '////'), '/')[4]
  )
}

resource volumeGroup 'Microsoft.ElasticSan/elasticSans/volumegroups@2023-01-01' = {
  name: name
  parent: elasticSan
  identity: identity
  properties: {
    encryption: !empty(customerManagedKey)
      ? 'EncryptionAtRestWithCustomerManagedKey'
      : 'EncryptionAtRestWithPlatformKey'
    encryptionProperties: !empty(customerManagedKey)
      ? {
          identity: !empty(customerManagedKey.?userAssignedIdentityResourceId)
            ? {
                userAssignedIdentity: cMKUserAssignedIdentity.id
              }
            : null
          keyVaultProperties: !empty(customerManagedKey)
            ? {
                keyName: customerManagedKey!.keyName
                keyVaultUri: cMKKeyVault.properties.vaultUri
                keyVersion: !empty(customerManagedKey.?keyVersion ?? '')
                  ? customerManagedKey!.?keyVersion
                  : last(split(cMKKeyVault::cMKKey.properties.keyUriWithVersion, '/'))
              }
            : null
        }
      : null
    networkAcls: !empty(networkRules) ? { virtualNetworkRules: networkRules } : null
    protocolType: 'Iscsi'
  }
}

module volumeGroup_volumes 'volume/main.bicep' = [
  for (volume, index) in (volumes ?? []): {
    name: '${uniqueString(deployment().name, location)}-VolumeGroup-Volume-${index}'
    params: {
      elasticSanName: elasticSan.name
      volumeGroupName: volumeGroup.name
      name: volume.name
      location: location
      sizeGiB: volume.sizeGiB
      snapshots: volume.?snapshots
    }
  }
]

module volumeGroup_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.10.1' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-ElasticSan-PrivateEndpoint-${index}'
    scope: resourceGroup(
      split(privateEndpoint.?resourceGroupResourceId ?? resourceGroup().id, '/')[2],
      split(privateEndpoint.?resourceGroupResourceId ?? resourceGroup().id, '/')[4]
    )
    params: {
      name: privateEndpoint.?name ?? 'pep-${last(split(elasticSan.id, '/'))}-${privateEndpoint.?service ?? volumeGroup.name}-${index}'
      privateLinkServiceConnections: privateEndpoint.?isManualConnection != true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(elasticSan.id, '/'))}-${privateEndpoint.?service ?? volumeGroup.name}-${index}'
              properties: {
                privateLinkServiceId: elasticSan.id
                groupIds: [
                  privateEndpoint.?service ?? volumeGroup.name
                ]
              }
            }
          ]
        : null
      manualPrivateLinkServiceConnections: privateEndpoint.?isManualConnection == true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(elasticSan.id, '/'))}-${privateEndpoint.?service ?? volumeGroup.name}-${index}'
              properties: {
                privateLinkServiceId: elasticSan.id
                groupIds: [
                  privateEndpoint.?service ?? volumeGroup.name
                ]
                requestMessage: privateEndpoint.?manualConnectionRequestMessage ?? 'Manual approval required.'
              }
            }
          ]
        : null
      subnetResourceId: privateEndpoint.subnetResourceId
      enableTelemetry: enableReferencedModulesTelemetry
      location: privateEndpoint.?location ?? reference(
        split(privateEndpoint.subnetResourceId, '/subnets/')[0],
        '2020-06-01',
        'Full'
      ).location
      lock: privateEndpoint.?lock ?? lock
      privateDnsZoneGroup: privateEndpoint.?privateDnsZoneGroup
      roleAssignments: privateEndpoint.?roleAssignments
      tags: privateEndpoint.?tags ?? tags
      customDnsConfigs: privateEndpoint.?customDnsConfigs
      ipConfigurations: privateEndpoint.?ipConfigurations
      applicationSecurityGroupResourceIds: privateEndpoint.?applicationSecurityGroupResourceIds
      customNetworkInterfaceName: privateEndpoint.?customNetworkInterfaceName
    }
  }
]

// ============ //
// Outputs      //
// ============ //

@sys.description('The resource ID of the deployed Elastic SAN Volume Group.')
output resourceId string = volumeGroup.id

@sys.description('The name of the deployed Elastic SAN Volume Group.')
output name string = volumeGroup.name

@sys.description('The location of the deployed Elastic SAN Volume Group.')
output location string = location

@sys.description('The resource group of the deployed Elastic SAN Volume Group.')
output resourceGroupName string = resourceGroup().name

@sys.description('The principal ID of the system assigned identity of the deployed Elastic SAN Volume Group.')
output systemAssignedMIPrincipalId string? = volumeGroup.?identity.?principalId

@sys.description('Details on the deployed Elastic SAN Volumes.')
output volumes volumeOutputType[] = [
  for (volume, i) in (volumes ?? []): {
    resourceId: volumeGroup_volumes[i].outputs.resourceId
    name: volumeGroup_volumes[i].outputs.name
    location: volumeGroup_volumes[i].outputs.location
    resourceGroupName: volumeGroup_volumes[i].outputs.resourceGroupName
    targetIqn: volumeGroup_volumes[i].outputs.targetIqn
    targetPortalHostname: volumeGroup_volumes[i].outputs.targetPortalHostname
    targetPortalPort: volumeGroup_volumes[i].outputs.targetPortalPort
    volumeId: volumeGroup_volumes[i].outputs.volumeId
    snapshots: volumeGroup_volumes[i].outputs.snapshots
  }
]

@sys.description('The private endpoints of the Elastic SAN Volume Group.')
output privateEndpoints privateEndpointOutputType[] = [
  for (item, index) in (privateEndpoints ?? []): {
    name: volumeGroup_privateEndpoints[index].outputs.name
    resourceId: volumeGroup_privateEndpoints[index].outputs.resourceId
    groupId: volumeGroup_privateEndpoints[index].outputs.?groupId!
    customDnsConfigs: volumeGroup_privateEndpoints[index].outputs.customDnsConfigs
    networkInterfaceResourceIds: volumeGroup_privateEndpoints[index].outputs.networkInterfaceResourceIds
  }
]

// ================ //
// Definitions      //
// ================ //

@export()
type privateEndpointOutputType = {
  @description('The name of the private endpoint.')
  name: string

  @description('The resource ID of the private endpoint.')
  resourceId: string

  @description('The group Id for the private endpoint Group.')
  groupId: string?

  @description('The custom DNS configurations of the private endpoint.')
  customDnsConfigs: {
    @description('FQDN that resolves to private endpoint IP address.')
    fqdn: string?

    @description('A list of private IP addresses of the private endpoint.')
    ipAddresses: string[]
  }[]

  @description('The IDs of the network interfaces associated with the private endpoint.')
  networkInterfaceResourceIds: string[]
}

import { volumeSnapshotType, volumeSnapshotOutputType } from 'volume/main.bicep'

@sys.export()
type volumeType = {
  @sys.minLength(3)
  @sys.maxLength(63)
  @sys.description('Required. The name of the Elastic SAN Volume. The name can only contain lowercase letters, numbers, hyphens and underscores, and must begin and end with a letter or a number. Each hyphen and underscore must be preceded and followed by an alphanumeric character.')
  name: string

  @sys.minValue(1) // 1 GiB
  @sys.maxValue(65536) // 64 TiB
  @sys.description('Required. Size of the Elastic SAN Volume in Gibibytes (GiB). The supported capacity ranges from 1 Gibibyte (GiB) to 64 Tebibyte (TiB), equating to 65536 Gibibytes (GiB).')
  sizeGiB: int

  @sys.description('Optional. List of Elastic SAN Volume Snapshots to be created in the Elastic SAN Volume.')
  snapshots: volumeSnapshotType[]?
}

@sys.export()
type virtualNetworkRuleType = {
  @sys.minLength(1)
  @sys.description('Required. The resource ID of the subnet in the virtual network.')
  virtualNetworkSubnetResourceId: string
}

@sys.export()
type volumeOutputType = {
  @sys.description('The resource ID of the deployed Elastic SAN Volume.')
  resourceId: string

  @sys.description('The name of the deployed Elastic SAN Volume.')
  name: string

  @sys.description('The location of the deployed Elastic SAN Volume.')
  location: string

  @sys.description('The resource group of the deployed Elastic SAN Volume.')
  resourceGroupName: string

  @sys.description('The iSCSI Target IQN (iSCSI Qualified Name) of the deployed Elastic SAN Volume.')
  targetIqn: string

  @sys.description('The iSCSI Target Portal Host Name of the deployed Elastic SAN Volume.')
  targetPortalHostname: string

  @sys.description('The iSCSI Target Portal Port of the deployed Elastic SAN Volume.')
  targetPortalPort: int

  @sys.description('The volume Id of the deployed Elastic SAN Volume.')
  volumeId: string

  @sys.description('Details on the deployed Elastic SAN Volume Snapshots.')
  snapshots: volumeSnapshotOutputType[]
}
