metadata name = 'Elastic SAN Volume Groups'
metadata description = 'This module deploys an Elastic SAN Volume Group.'
metadata owner = 'Azure/module-maintainers'

@sys.minLength(3)
@sys.maxLength(24)
@sys.description('Conditional. The name of the parent Elastic SAN. Required if the template is used in a standalone deployment.')
param elasticSanName string

@sys.minLength(3)
@sys.maxLength(63)
@sys.description('Required. The name of the Elastic SAN Volume Group.')
param name string

@sys.description('Optional. List of Elastic SAN Volumes to be created in the Elastic SAN Volume Group.')
param volumes volumeType[]?

@sys.description('Optional. List of Virtual Network Rules, permitting virtual network subnet to connect to the resource through service endpoint.')
param virtualNetworkRules virtualNetworkRuleType[]?

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@sys.description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

import { customerManagedKeyType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@sys.description('Optional. The customer managed key definition.')
param customerManagedKey customerManagedKeyType?

// ============== //
// Variables      //
// ============== //

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
    action: 'Allow'
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
                  ? customerManagedKey!.keyVersion
                  : last(split(cMKKeyVault::cMKKey.properties.keyUriWithVersion, '/'))
              }
            : null
        }
      : null
    networkAcls: {
      virtualNetworkRules: networkRules
    }
    protocolType: 'Iscsi'
  }
}

module volumeGroup_volumes 'volume/main.bicep' = [
  for (volume, index) in (volumes ?? []): {
    name: '${uniqueString(deployment().name)}-VolumeGroup-Volume-${index}'
    params: {
      elasticSanName: elasticSan.name
      volumeGroupName: volumeGroup.name
      name: volume.name
      sizeGiB: volume.sizeGiB
      snapshots: volume.snapshots
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

@sys.description('The resource group of the deployed Elastic SAN Volume Group.')
output resourceGroupName string = resourceGroup().name

@sys.description('The principal ID of the system assigned identity of the deployed Elastic SAN Volume Group.')
output systemAssignedMIPrincipalId string = volumeGroup.?identity.?principalId ?? ''

@sys.description('Details on the deployed Elastic SAN Volumes.')
output volumes volumeOutputType[] = [
  for (volume, i) in (volumes ?? []): {
    resourceId: volumeGroup_volumes[i].outputs.resourceId
    snapshots: volumeGroup_volumes[i].outputs.snapshots
  }
]

// ================ //
// Definitions      //
// ================ //

import { volumeSnapshotType, volumeSnapshotOutputType } from 'volume/main.bicep'

@export()
type volumeType = {
  @sys.minLength(3)
  @sys.maxLength(63)
  @sys.description('Required. The name of the Elastic SAN Volume.')
  name: string

  @sys.minValue(1) // 1 GiB
  @sys.maxValue(65536) // 64 TiB
  @sys.description('Required. Size of the Elastic SAN Volume in Gibibytes (GiB).')
  sizeGiB: int

  @sys.description('Optional. List of Elastic SAN Volume Snapshots to be created in the Elastic SAN Volume.')
  snapshots: volumeSnapshotType[]?
}

@export()
type virtualNetworkRuleType = {
  @sys.minLength(1)
  @sys.description('Required. The resource ID of the subnet in the virtual network.')
  virtualNetworkSubnetResourceId: string
}

@export()
type volumeOutputType = {
  @sys.description('The resource ID of the deployed Elastic SAN Volume.')
  resourceId: string

  @sys.description('Details on the deployed Elastic SAN Volume Snapshots.')
  snapshots: volumeSnapshotOutputType[]
}
