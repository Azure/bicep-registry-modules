targetScope = 'subscription'

import { preparedHciEnvironmentType } from '../../../../../../../utilities/e2e-template-assets/module-specific/azure-stack-hci/consumer.types.bicep'

metadata name = 'Using only defaults'
metadata description = 'This instance imports a prepared customer image with the minimum required parameters and tests unchanged redeployment. Supply an existing Azure Local environment, its Azure region, the source OS type, and a secure image path. Preparing or uploading the source is outside this module.'

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-azurestackhci.galleryimage-${serviceShort}-rg'

@description('Required. Azure region of the prepared Azure Local environment.')
param resourceLocation string

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ashgimin'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

@description('Required. Existing Azure Local environment supplied by reserved-environment CI or the caller.')
param preparedHciEnvironment preparedHciEnvironmentType

@secure()
@minLength(1)
@description('Required. Prepared local VHDX path or HTTPS SAS URL for a VHD/VHDX page blob. Supply securely at deployment time; do not commit or log the value.')
param imagePath string

@description('Required. Operating system of the prepared Gen2 source image.')
@allowed([
  'Windows'
  'Linux'
])
param osType string

resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      customLocationResourceId: preparedHciEnvironment.customLocationResourceId
      imagePath: imagePath
      osType: osType
    }
  }
]
