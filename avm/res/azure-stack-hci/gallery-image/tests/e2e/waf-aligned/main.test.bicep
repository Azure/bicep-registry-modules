targetScope = 'subscription'

import { preparedHciEnvironmentType } from '../../../../../../../utilities/e2e-template-assets/module-specific/azure-stack-hci/consumer.types.bicep'

metadata name = 'WAF-aligned'
metadata description = 'This instance imports a prepared Gen2 image using secure source delivery, explicit existing storage placement, and read-only image access, then tests unchanged redeployment. Supply an existing Azure Local environment, a suitable prepared image, and its storage container. Importing does not harden the guest OS.'

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-azurestackhci.galleryimage-${serviceShort}-rg'

@description('Required. Azure region of the prepared Azure Local environment.')
param resourceLocation string

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ashgiwaf'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

@description('Required. Existing Azure Local environment supplied by reserved-environment CI or the caller.')
param preparedHciEnvironment preparedHciEnvironmentType

@secure()
@minLength(1)
@description('Required. Prepared Gen2 local VHDX path or HTTPS SAS URL for a Gen2 VHD/VHDX page blob. Keep the source private and grant only the access needed for import.')
param imagePath string

@description('Required. Operating system of the prepared Gen2 source image.')
@allowed([
  'Windows'
  'Linux'
])
param osType string

@description('Required. Resource ID of an existing storage container on the same Azure Local custom location.')
param containerResourceId string

resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module dependencies '../dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-dependencies-${serviceShort}'
  params: {
    name: '${namePrefix}${serviceShort}identity'
    location: resourceLocation
  }
}

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      location: resourceLocation
      customLocationResourceId: preparedHciEnvironment.customLocationResourceId
      imagePath: imagePath
      osType: osType
      hyperVGeneration: 'V2'
      containerResourceId: containerResourceId
      roleAssignments: [
        {
          roleDefinitionIdOrName: 'Azure Stack HCI VM Reader'
          principalId: dependencies.outputs.principalId
          principalType: 'ServicePrincipal'
        }
      ]
      tags: {
        workload: 'customer-image'
      }
    }
  }
]
