metadata name = 'Elastic SANs'
metadata description = 'This module deploys an Elastic SAN.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the Elastic SAN.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

// TODO: Your module should support the following optional parameters. However, please review and remove any parameters that are unnecessary.

@description('Optional. The Availability Zones to place the resources in.')
@allowed([
  1
  2
  3
])
param zones int[] = [
  1
  2
  3
]

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

import { privateEndpointMultiServiceType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointMultiServiceType[]?

import { customerManagedKeyType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@description('Optional. The customer managed key definition.')
param customerManagedKey customerManagedKeyType?

@description('Optional. Tags of the Elastic SAN resource.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: take(
    '46d3xbcp.res.elasticsan-elasticsan.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}',
    64
  )
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

resource elasticSan 'Microsoft.ElasticSan/elasticSans@2023-01-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    // TODO: Add module specific properties here

    // zones: map(zones, zone => string(zone))
  }
}

@description('The resource ID of the deployed Elastic SAN.')
output resourceId string = elasticSan.id

@description('The name of the deployed Elastic SAN.')
output name string = elasticSan.name

@description('The location the resource was deployed into.')
output location string = elasticSan.location

@description('The resource group of the deployed Elastic SAN.')
output resourceGroupName string = resourceGroup().name

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string = elasticSan.?identity.?principalId ?? ''

// TODO: Add additional outputs as needed
