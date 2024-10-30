metadata name = 'Elastic SAN Volume Snapshots'
metadata description = 'This module deploys an Elastic SAN Volume Snapshot.'
metadata owner = 'Azure/module-maintainers'

@sys.minLength(3)
@sys.maxLength(24)
@sys.description('Conditional. The name of the parent Elastic SAN. Required if the template is used in a standalone deployment.')
param elasticSanName string

@sys.minLength(3)
@sys.maxLength(63)
@sys.description('Conditional. The name of the parent Elastic SAN Volume Group. Required if the template is used in a standalone deployment.')
param volumeGroupName string

@sys.minLength(3)
@sys.maxLength(63)
@sys.description('Conditional. The name of the parent Elastic SAN Volume. Required if the template is used in a standalone deployment.')
param volumeName string

@sys.minLength(3)
@sys.maxLength(63)
@sys.description('Required. The name of the Elastic SAN Volume Snapshot.')
param name string

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

    resource volume 'volumes@2023-01-01' existing = {
      name: volumeName
    }
  }
}

resource volumeSnapshot 'Microsoft.ElasticSan/elasticSans/volumegroups/snapshots@2023-01-01' = {
  name: name
  parent: elasticSan::volumeGroup
  properties: {
    creationData: {
      sourceId: elasticSan::volumeGroup::volume.id
    }
  }
}

// ============ //
// Outputs      //
// ============ //

@sys.description('The resource ID of the deployed Elastic SAN Volume Snapshot.')
output resourceId string = volumeSnapshot.id

@sys.description('The name of the deployed Elastic SAN Volume Snapshot.')
output name string = volumeSnapshot.name

@sys.description('The resource group of the deployed Elastic SAN Volume Snapshot.')
output resourceGroupName string = resourceGroup().name

// ================ //
// Definitions      //
// ================ //
