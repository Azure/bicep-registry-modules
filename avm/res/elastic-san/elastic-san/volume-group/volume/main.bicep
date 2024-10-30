metadata name = 'Elastic SAN Volumes'
metadata description = 'This module deploys an Elastic SAN Volume.'
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
@sys.description('Required. The name of the Elastic SAN Volume.')
param name string

@sys.minValue(1) // 1 GiB
@sys.maxValue(65536) // 64 TiB
@sys.description('Required. Size of the Elastic SAN Volume in Gibibytes (GiB).')
param sizeGiB int

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

// ============ //
// Outputs      //
// ============ //

@sys.description('The resource ID of the deployed Elastic SAN Volume.')
output resourceId string = volume.id

@sys.description('The name of the deployed Elastic SAN Volume.')
output name string = volume.name

@sys.description('The resource group of the deployed Elastic SAN Volume.')
output resourceGroupName string = resourceGroup().name

// ================ //
// Definitions      //
// ================ //
