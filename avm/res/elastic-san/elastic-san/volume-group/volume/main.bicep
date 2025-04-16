metadata name = 'Elastic SAN Volumes'
metadata description = 'This module deploys an Elastic SAN Volume.'

@sys.minLength(3)
@sys.maxLength(24)
@sys.description('Conditional. The name of the parent Elastic SAN. Required if the template is used in a standalone deployment. The name can only contain lowercase letters, numbers, hyphens and underscores, and must begin and end with a letter or a number. Each hyphen and underscore must be preceded and followed by an alphanumeric character.')
param elasticSanName string

@sys.minLength(3)
@sys.maxLength(63)
@sys.description('Conditional. The name of the parent Elastic SAN Volume Group. Required if the template is used in a standalone deployment. The name can only contain lowercase letters, numbers and hyphens, and must begin and end with a letter or a number. Each hyphen must be preceded and followed by an alphanumeric character.')
param volumeGroupName string

@sys.minLength(3)
@sys.maxLength(63)
@sys.description('Required. The name of the Elastic SAN Volume. The name can only contain lowercase letters, numbers, hyphens and underscores, and must begin and end with a letter or a number. Each hyphen and underscore must be preceded and followed by an alphanumeric character.')
param name string

@sys.minLength(1)
@sys.description('Optional. Location for all resources.')
param location string = resourceGroup().location

@sys.minValue(1) // 1 GiB
@sys.maxValue(65536) // 64 TiB
@sys.description('Required. Size of the Elastic SAN Volume in Gibibytes (GiB). The supported capacity ranges from 1 Gibibyte (GiB) to 64 Tebibyte (TiB), equating to 65536 Gibibytes (GiB).')
param sizeGiB int

@sys.description('Optional. List of Elastic SAN Volume Snapshots to be created in the Elastic SAN Volume.')
param snapshots volumeSnapshotType[]?

resource elasticSan 'Microsoft.ElasticSan/elasticSans@2023-01-01' existing = {
  name: elasticSanName

  resource volumeGroup 'volumegroups@2023-01-01' existing = {
    name: volumeGroupName
  }
}

resource volume 'Microsoft.ElasticSan/elasticSans/volumegroups/volumes@2023-01-01' = {
  name: name
  parent: elasticSan::volumeGroup
  properties: {
    sizeGiB: sizeGiB
  }
}

module volume_snapshots '../snapshot/main.bicep' = [
  for (snapshot, index) in (snapshots ?? []): {
    name: '${uniqueString(deployment().name, location)}-Volume-Snapshot-${index}'
    params: {
      elasticSanName: elasticSan.name
      volumeGroupName: elasticSan::volumeGroup.name
      volumeName: volume.name
      name: snapshot.name
      location: location
    }
  }
]

// ============ //
// Outputs      //
// ============ //

@sys.description('The resource ID of the deployed Elastic SAN Volume.')
output resourceId string = volume.id

@sys.description('The name of the deployed Elastic SAN Volume.')
output name string = volume.name

@sys.description('The location of the deployed Elastic SAN Volume.')
output location string = location

@sys.description('The resource group of the deployed Elastic SAN Volume.')
output resourceGroupName string = resourceGroup().name

@sys.description('The iSCSI Target IQN (iSCSI Qualified Name) of the deployed Elastic SAN Volume.')
output targetIqn string = volume.properties.storageTarget.targetIqn

@sys.description('The iSCSI Target Portal Host Name of the deployed Elastic SAN Volume.')
output targetPortalHostname string = volume.properties.storageTarget.targetPortalHostname

@sys.description('The iSCSI Target Portal Port of the deployed Elastic SAN Volume.')
output targetPortalPort int = volume.properties.storageTarget.targetPortalPort

@sys.description('The volume Id of the deployed Elastic SAN Volume.')
output volumeId string = volume.properties.volumeId

@sys.description('Details on the deployed Elastic SAN Volume Snapshots.')
output snapshots volumeSnapshotOutputType[] = [
  for (snapshot, i) in (snapshots ?? []): {
    resourceId: volume_snapshots[i].outputs.resourceId
    name: volume_snapshots[i].outputs.name
    location: volume_snapshots[i].outputs.location
    resourceGroupName: volume_snapshots[i].outputs.resourceGroupName
  }
]

// ================ //
// Definitions      //
// ================ //

@sys.export()
type volumeSnapshotType = {
  @sys.minLength(3)
  @sys.maxLength(63)
  @sys.description('Required. The name of the Elastic SAN Volume Snapshot. The name can only contain lowercase letters, numbers, hyphens and underscores, and must begin and end with a letter or a number. Each hyphen and underscore must be preceded and followed by an alphanumeric character.')
  name: string
}

@sys.export()
type volumeSnapshotOutputType = {
  @sys.description('The resource ID of the deployed Elastic SAN Volume Snapshot.')
  resourceId: string

  @sys.description('The name of the deployed Elastic SAN Volume Snapshot.')
  name: string

  @sys.description('The location of the deployed Elastic SAN Volume Snapshot.')
  location: string

  @sys.description('The resource group of the deployed Elastic SAN Volume Snapshot.')
  resourceGroupName: string
}
