metadata name = 'Elastic SAN Volumes'
metadata description = 'This module deploys an Elastic SAN Volume.'
metadata owner = 'Azure/module-maintainers'

@sys.minLength(3)
@sys.maxLength(24)
@sys.description('Conditional. The name of the parent Elastic SAN. Required if the template is used in a standalone deployment. The name can only contain lowercase letters, numbers, hyphens and underscores, and must begin and end with a letter or a number. Each hyphen and underscore must be preceded and followed by an alphanumeric character. The name must be between 3 and 24 characters long.')
param elasticSanName string

@sys.minLength(3)
@sys.maxLength(63)
@sys.description('Conditional. The name of the parent Elastic SAN Volume Group. Required if the template is used in a standalone deployment. The name can only contain lowercase letters, numbers and hyphens, and must begin and end with a letter or a number. Each hyphen must be preceded and followed by an alphanumeric character. The name must be between 3 and 63 characters long.')
param volumeGroupName string

@sys.minLength(3)
@sys.maxLength(63)
@sys.description('Required. The name of the Elastic SAN Volume. The name can only contain lowercase letters, numbers, hyphens and underscores, and must begin and end with a letter or a number. Each hyphen and underscore must be preceded and followed by an alphanumeric character. The name must also be between 3 and 63 characters long.')
param name string

@sys.minValue(1) // 1 GiB
@sys.maxValue(65536) // 64 TiB
@sys.description('Required. Size of the Elastic SAN Volume in Gibibytes (GiB). The supported capacity ranges from 1 Gibibyte (GiB) to 64 Tebibyte (TiB), equating to 65536 Gibibytes (GiB).')
param sizeGiB int

@sys.description('Optional. List of Elastic SAN Volume Snapshots to be created in the Elastic SAN Volume.')
param snapshots volumeSnapshotType[]?

// ============== //
// Variables      //
// ============== //

// ============== //
// Resources      //
// ============== //

//
// Add your resources here
//

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
    name: '${uniqueString(deployment().name)}-Volume-Snapshot-${index}'
    params: {
      elasticSanName: elasticSan.name
      volumeGroupName: elasticSan::volumeGroup.name
      volumeName: volume.name
      name: snapshot.name
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

@sys.description('The resource group of the deployed Elastic SAN Volume.')
output resourceGroupName string = resourceGroup().name

@sys.description('Details on the deployed Elastic SAN Volume Snapshots.')
output snapshots volumeSnapshotOutputType[] = [
  for (snapshot, i) in (snapshots ?? []): {
    resourceId: volume_snapshots[i].outputs.resourceId
    name: volume_snapshots[i].outputs.name
    resourceGroupName: volume_snapshots[i].outputs.resourceGroupName
  }
]

// ================ //
// Definitions      //
// ================ //

@export()
type volumeSnapshotType = {
  @sys.minLength(3)
  @sys.maxLength(63)
  @sys.description('Required. The name of the Elastic SAN Volume Snapshot. The name can only contain lowercase letters, numbers, hyphens and underscores, and must begin and end with a letter or a number. Each hyphen and underscore must be preceded and followed by an alphanumeric character. The name must also be between 3 and 63 characters long.')
  name: string
}

@export()
type volumeSnapshotOutputType = {
  @sys.description('The resource ID of the deployed Elastic SAN Volume Snapshot.')
  resourceId: string

  @sys.description('The name of the deployed Elastic SAN Volume Snapshot.')
  name: string

  @sys.description('The resource group of the deployed Elastic SAN Volume Snapshot.')
  resourceGroupName: string
}
