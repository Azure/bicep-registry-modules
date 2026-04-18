metadata name = 'Recovery Services Vault Replication Fabrics'
metadata description = '''This module deploys a Replication Fabric for Azure to Azure disaster recovery scenario of Azure Site Recovery.

> Note: this module currently support only the `instanceType: 'Azure'` scenario.'''

@description('Conditional. The name of the parent Azure Recovery Service Vault. Required if the template is used in a standalone deployment.')
param recoveryVaultName string

@description('Optional. The recovery location the fabric represents.')
param location string = resourceGroup().location

@description('Optional. The name of the fabric.')
param name string = location

@description('Optional. Replication containers to create.')
param replicationContainers containerType[]?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var enableReferencedModulesTelemetry = false

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.recsvcs-vault-repfab.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource recoveryServicesVault 'Microsoft.RecoveryServices/vaults@2024-10-01' existing = {
  name: recoveryVaultName
}

resource replicationFabric 'Microsoft.RecoveryServices/vaults/replicationFabrics@2022-10-01' = {
  name: name
  parent: recoveryServicesVault
  properties: {
    customDetails: {
      instanceType: 'Azure'
      location: location
    }
  }
}

module fabric_replicationContainers 'replication-protection-container/main.bicep' = [
  for (container, index) in (replicationContainers ?? []): {
    name: '${deployment().name}-RCont-${index}'
    params: {
      name: container.name
      recoveryVaultName: recoveryVaultName
      replicationFabricName: name
      mappings: container.?mappings
      enableTelemetry: enableReferencedModulesTelemetry
    }
    dependsOn: [
      replicationFabric
    ]
  }
]

@description('The name of the replication fabric.')
output name string = replicationFabric.name

@description('The resource ID of the replication fabric.')
output resourceId string = replicationFabric.id

@description('The name of the resource group the replication fabric was created in.')
output resourceGroupName string = resourceGroup().name

// =============== //
//   Definitions   //
// =============== //

import { mappingType } from 'replication-protection-container/main.bicep'
@export()
@description('The type for a replication protection container.')
type containerType = {
  @description('Required. The name of the replication container.')
  name: string

  @description('Optional. Replication containers mappings to create.')
  mappings: mappingType[]?
}
