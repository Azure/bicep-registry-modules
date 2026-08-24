metadata name = 'Elastic SAN Volume Snapshots'
metadata description = 'This module deploys an Elastic SAN Volume Snapshot.'

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
@sys.description('Conditional. The name of the parent Elastic SAN Volume. Required if the template is used in a standalone deployment. The name can only contain lowercase letters, numbers, hyphens and underscores, and must begin and end with a letter or a number. Each hyphen and underscore must be preceded and followed by an alphanumeric character.')
param volumeName string

@sys.minLength(3)
@sys.maxLength(63)
@sys.description('Required. The name of the Elastic SAN Volume Snapshot. The name can only contain lowercase letters, numbers, hyphens and underscores, and must begin and end with a letter or a number. Each hyphen and underscore must be preceded and followed by an alphanumeric character.')
param name string

@sys.minLength(1)
@sys.description('Optional. Location for all resources.')
param location string = resourceGroup().location

@sys.description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.elsan-elsan-volumegroupsnapshot.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource elasticSan 'Microsoft.ElasticSan/elasticSans@2024-05-01' existing = {
  name: elasticSanName

  resource volumeGroup 'volumegroups@2024-05-01' existing = {
    name: volumeGroupName

    resource volume 'volumes@2024-05-01' existing = {
      name: volumeName
    }
  }
}

resource volumeSnapshot 'Microsoft.ElasticSan/elasticSans/volumegroups/snapshots@2024-05-01' = {
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

@sys.description('The location of the deployed Elastic SAN Volume Snapshot.')
output location string = location

@sys.description('The resource group of the deployed Elastic SAN Volume Snapshot.')
output resourceGroupName string = resourceGroup().name
