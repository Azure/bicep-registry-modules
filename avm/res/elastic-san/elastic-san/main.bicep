metadata name = 'Elastic SANs'
metadata description = 'This module deploys an Elastic SAN.'
metadata owner = 'Azure/module-maintainers'

@sys.minLength(3)
@sys.maxLength(24)
@sys.description('Required. Name of the Elastic SAN.')
param name string

@sys.description('Optional. Location for all resources.')
param location string = resourceGroup().location

@sys.description('Optional. List of Elastic SAN Volume Groups to be created in the Elastic SAN.')
param volumeGroups volumeGroupType[]?

@sys.description('Optional. Specifies the SKU for the Elastic SAN.')
@sys.allowed([
  'Premium_LRS'
  'Premium_ZRS'
])
param sku string = 'Premium_ZRS'

@sys.description('Conditional. Configuration of the availability zone for the Elastic SAN. Required if `Sku` is `Premium_LRS`. If this parameter is not provided, the `Sku` parameter will default to Premium_ZRS. Note that the availability zone number here are the logical availability zone in your Azure subscription. Different subscriptions might have a different mapping of the physical zone and logical zone. To understand more, please refer to [Physical and logical availability zones](https://learn.microsoft.com/en-us/azure/reliability/availability-zones-overview?tabs=azure-cli#physical-and-logical-availability-zones).')
@sys.allowed([1, 2, 3])
param availabilityZone int?

@sys.minValue(1)
@sys.maxValue(400)
@sys.description('Optional. Size of the Elastic SAN base capacity (TiB).')
param baseSizeTiB int = 1

@sys.minValue(0)
@sys.maxValue(600) // Documentation says 600 in some regions, but the portal allows only 400
@sys.description('Optional. Size of the Elastic SAN additional capacity (TiB).')
param extendedCapacitySizeTiB int = 0

@sys.description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints or Virtual Network Rules are set.')
@sys.allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string?

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@sys.description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

import { customerManagedKeyType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@sys.description('Optional. The customer managed key definition.')
param customerManagedKey customerManagedKeyType?

@sys.description('Optional. Tags of the Elastic SAN resource.')
param tags object?

@sys.description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

// ============== //
// Variables      //
// ============== //

// Default to Premium_ZRS unless the user specifically chooses Premium_LRS and specifies an availability zone number.
var calculatedSku = sku == 'Premium_LRS' ? (availabilityZone != null ? 'Premium_LRS' : 'Premium_ZRS') : 'Premium_ZRS'

// For Premium_ZRS all zones are utilized - no need to specify the zone
// For Premium_LRS only one zone is utilized - needs to be specified
// ZRS is only available in France Central, North Europe, West Europe and West US 2.
var calculatedZone = sku == 'Premium_LRS' ? (availabilityZone != null ? ['${availabilityZone}'] : null) : null

// Summarize the total number of virtual network rules across all volume groups.
var totalVirtualNetworkRules = reduce(
  map(volumeGroups ?? [], volumeGroup => length(volumeGroup.?virtualNetworkRules ?? [])),
  0,
  (cur, next) => cur + next
)

// Disable by default
// Enabled only when explicitly set to 'Enabled' or
// when 'publicNetworkAccess' not explicitly set and both private endpoints and virtual network rules are empty
var calculatedPublicNetworkAccess = !empty(publicNetworkAccess)
  ? any(publicNetworkAccess)
  : (!empty(privateEndpoints) ? 'Disabled' : (totalVirtualNetworkRules > 0 ? 'Disabled' : 'Enabled'))

// ============== //
// Resources      //
// ============== //

//
// Add your resources here
//

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
    availabilityZones: calculatedZone
    baseSizeTiB: baseSizeTiB
    extendedCapacitySizeTiB: extendedCapacitySizeTiB
    publicNetworkAccess: calculatedPublicNetworkAccess
    sku: {
      name: calculatedSku
      tier: 'Premium'
    }
  }
}

module elasticSan_volumeGroups 'volume-group/main.bicep' = [
  for (volumeGroup, index) in (volumeGroups ?? []): {
    name: '${uniqueString(deployment().name, location)}-ElasticSAN-VolumeGroup-${index}'
    params: {
      elasticSanName: elasticSan.name
      name: volumeGroup.name
      volumes: volumeGroup.volumes
      virtualNetworkRules: volumeGroup.virtualNetworkRules
      managedIdentities: managedIdentities
      customerManagedKey: customerManagedKey
    }
  }
]

// ============ //
// Outputs      //
// ============ //

@sys.description('The resource ID of the deployed Elastic SAN.')
output resourceId string = elasticSan.id

@sys.description('The name of the deployed Elastic SAN.')
output name string = elasticSan.name

@sys.description('The location the resource was deployed into.')
output location string = elasticSan.location

@sys.description('The resource group of the deployed Elastic SAN.')
output resourceGroupName string = resourceGroup().name

@sys.description('Details on the deployed Elastic SAN Volume Groups.')
output volumeGroups volumeGroupOutputType[] = [
  for (volumeGroup, i) in (volumeGroups ?? []): {
    resourceId: elasticSan_volumeGroups[i].outputs.resourceId
    systemAssignedMIPrincipalId: elasticSan_volumeGroups[i].outputs.systemAssignedMIPrincipalId
    volumes: elasticSan_volumeGroups[i].outputs.volumes
  }
]

// ================ //
// Definitions      //
// ================ //

import { volumeType, virtualNetworkRuleType, volumeOutputType } from './volume-group/main.bicep'

@export()
type volumeGroupType = {
  @sys.minLength(3)
  @sys.maxLength(63)
  @sys.description('Required. The name of the Elastic SAN Volume Group.')
  name: string

  @sys.description('Optional. List of Elastic SAN Volumes to be created in the Elastic SAN Volume Group.')
  volumes: volumeType[]?

  @sys.description('Optional. List of Virtual Network Rules, permitting virtual network subnet to connect to the resource through service endpoint.')
  virtualNetworkRules: virtualNetworkRuleType[]?
}

@export()
type volumeGroupOutputType = {
  @sys.description('The resource ID of the deployed Elastic SAN Volume Group.')
  resourceId: string

  @sys.description('The principal ID of the system assigned identity of the deployed Elastic SAN Volume Group.')
  systemAssignedMIPrincipalId: string

  @sys.description('Details on the deployed Elastic SAN Volumes.')
  volumes: volumeOutputType[]
}

/*

TODO:
out elasticSan_volumeGroups


@sys.description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string = elasticSan.systemData..?principalId ?? ''



@description('The private endpoints of the app configuration.')
output privateEndpoints array = [
  for (pe, i) in (!empty(privateEndpoints) ? array(privateEndpoints) : []): {
    name: configurationStore_privateEndpoints[i].outputs.name
    resourceId: configurationStore_privateEndpoints[i].outputs.resourceId
    groupId: configurationStore_privateEndpoints[i].outputs.groupId
    customDnsConfig: configurationStore_privateEndpoints[i].outputs.customDnsConfig
    networkInterfaceIds: configurationStore_privateEndpoints[i].outputs.networkInterfaceIds
  }
]

####################################









*/

// TODO: Your module should support the following optional parameters. However, please review and remove any parameters that are unnecessary.

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@sys.description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@sys.description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@sys.description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

import { privateEndpointMultiServiceType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@sys.description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointMultiServiceType[]?

// @sys.description('The resource ids of the deployed Elastic SAN Volume Groups.')
// output volumeGroupResourceIds array = [
//   for index in range(0, length(elasticSan.?volumeGroups ?? [])): elasticSan_volumeGroups[index].outputs.resourceId
// ]

// TODO: Add additional outputs as needed

/*



@export()
type elasticSanType = {
  @sys.description('Required. The name of the Elastic SAN Volume Group.')
  @minLength(3)
  name: string

  @sys.description('Optional. Elastic SAN Volume Groups to create.')
  volumeGroups: volumeGroupType[]?
}


*/
