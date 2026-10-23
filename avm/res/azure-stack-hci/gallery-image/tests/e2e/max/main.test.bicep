targetScope = 'subscription'

import { preparedHciEnvironmentType } from '../../../../../../../utilities/e2e-template-assets/module-specific/azure-stack-hci/consumer.types.bicep'

metadata name = 'Using large parameter set'
metadata description = 'This instance exercises optional GA image metadata, storage placement, tags, locks, role assignments, and disabled telemetry, with unchanged redeployment. Supply a prepared Linux Gen2 image compatible with NoCloud and an existing storage container. Run with both local VHDX and Azure Storage page-blob sources to validate both routes; no source image is built by this test.'

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-azurestackhci.galleryimage-${serviceShort}-rg'

@description('Required. Azure region of the prepared Azure Local environment.')
param resourceLocation string

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ashgimax'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

@description('Required. Existing Azure Local environment supplied by reserved-environment CI or the caller.')
param preparedHciEnvironment preparedHciEnvironmentType

@secure()
@minLength(1)
@description('Required. Prepared Linux Gen2 local VHDX path or HTTPS SAS URL for a Linux Gen2 VHD/VHDX page blob. Supply securely at deployment time.')
param imagePath string

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
      osType: 'Linux'
      hyperVGeneration: 'V2'
      cloudInitDataSource: 'NoCloud'
      containerResourceId: containerResourceId
      identifier: {
        publisher: 'ExamplePublisher'
        offer: 'ExampleLinux'
        sku: 'gen2'
      }
      version: {
        name: '1.0.0'
      }
      tags: {
        environment: 'validation'
        workload: 'customer-image'
      }
      lock: {
        kind: 'CanNotDelete'
        name: '${namePrefix}${serviceShort}-lock'
      }
      roleAssignments: [
        {
          roleDefinitionIdOrName: 'Reader'
          principalId: dependencies.outputs.principalId
          principalType: 'ServicePrincipal'
        }
        {
          roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
          principalId: dependencies.outputs.principalId
          principalType: 'ServicePrincipal'
        }
        {
          roleDefinitionIdOrName: subscriptionResourceId(
            'Microsoft.Authorization/roleDefinitions',
            '4b3fe76c-f777-4d24-a2d7-b027b0f7b273'
          )
          principalId: dependencies.outputs.principalId
          principalType: 'ServicePrincipal'
        }
      ]
      enableTelemetry: false
    }
  }
]
