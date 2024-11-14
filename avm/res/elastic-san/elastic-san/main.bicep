metadata name = 'Elastic SANs'
metadata description = 'This module deploys an Elastic SAN.'
metadata owner = 'Azure/module-maintainers'

@sys.minLength(3)
@sys.maxLength(24)
@sys.description('Required. Name of the Elastic SAN. The name can only contain lowercase letters, numbers, hyphens and underscores, and must begin and end with a letter or a number. Each hyphen and underscore must be preceded and followed by an alphanumeric character. The name must be between 3 and 24 characters long.')
param name string

@sys.description('Optional. Location for all resources.')
param location string = resourceGroup().location

@sys.description('Optional. List of Elastic SAN Volume Groups to be created in the Elastic SAN. An Elastic SAN can have a maximum of 200 volume groups.')
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
@sys.maxValue(400) // Documentation says 400 in some regions, 100 in others
@sys.description('Optional. Size of the Elastic SAN base capacity in Tebibytes (TiB). The supported capacity ranges from 1 Tebibyte (TiB) to 400 Tebibytes (TiB).')
param baseSizeTiB int = 1

@sys.minValue(0)
@sys.maxValue(600) // Documentation says 600 in some regions, 100 in others. Portal allows only 400.
@sys.description('Optional. Size of the Elastic SAN additional capacity in Tebibytes (TiB). The supported capacity ranges from 0 Tebibyte (TiB) to 600 Tebibytes (TiB).')
param extendedCapacitySizeTiB int = 0

// By default, public access to individual volume groups is denied even if you allow it at the SAN level.
// You need to configure network rules at volume group level to allow public access.
// If you disable public access at the SAN level, access to the volume groups within that SAN is only available over private endpoints.
@sys.description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be `Disabled`, which necessitates the use of private endpoints. If not specified, public access will be `Disabled` by default when private endpoints are used without Virtual Network Rules. Setting public network access to `Disabled` while using Virtual Network Rules will result in an error.')
@sys.allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string?

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

var totalPrivateEndpoints = reduce(
  map(volumeGroups ?? [], volumeGroup => length(volumeGroup.?privateEndpoints ?? [])),
  0,
  (cur, next) => cur + next
)

// When 'publicNetworkAccess' is explicitly set we need to use that value and not to overrule it
// If user has set 'publicNetworkAccess' to 'Disabled' and they specified any virtual network rule, the deployment will fail
// (Virtual Network Rules require 'Enabled' public network access)
//
// When 'publicNetworkAccess' is NOT explicitly set and virtual network rules are NOT set and private endpoints are NOT set,
// public network access must be 'Enabled'.
// When 'publicNetworkAccess' is NOT explicitly set and any virtual network rules are set (regardless of the presence of private endpoints),
// public network access must be 'Enabled'.
// When 'publicNetworkAccess' is NOT explicitly set and virtual network rules are NOT set and private endpoints are set,
// we can configure public network access to 'Disabled'.
var calculatedPublicNetworkAccess = !empty(publicNetworkAccess)
  ? any(publicNetworkAccess)
  : (totalVirtualNetworkRules > 0 ? 'Enabled' : (totalPrivateEndpoints > 0 ? 'Disabled' : null))

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
      location: location
      volumes: volumeGroup.?volumes
      virtualNetworkRules: volumeGroup.?virtualNetworkRules
      managedIdentities: volumeGroup.?managedIdentities
      customerManagedKey: volumeGroup.?customerManagedKey
      privateEndpoints: volumeGroup.?privateEndpoints
      tags: tags
      enableTelemetry: enableTelemetry
      lock: lock
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
    name: elasticSan_volumeGroups[i].outputs.name
    resourceGroupName: elasticSan_volumeGroups[i].outputs.resourceGroupName
    systemAssignedMIPrincipalId: elasticSan_volumeGroups[i].outputs.systemAssignedMIPrincipalId
    volumes: elasticSan_volumeGroups[i].outputs.volumes
  }
]

// ================ //
// Definitions      //
// ================ //

import { managedIdentityAllType, customerManagedKeyType, privateEndpointSingleServiceType } from 'br/public:avm/utl/types/avm-common-types:0.3.0'
import { volumeType, virtualNetworkRuleType, volumeOutputType } from './volume-group/main.bicep'

@export()
type volumeGroupType = {
  @sys.minLength(3)
  @sys.maxLength(63)
  @sys.description('Required. The name of the Elastic SAN Volume Group. The name can only contain lowercase letters, numbers and hyphens, and must begin and end with a letter or a number. Each hyphen must be preceded and followed by an alphanumeric character. The name must be between 3 and 63 characters long.')
  name: string

  @sys.description('Optional. List of Elastic SAN Volumes to be created in the Elastic SAN Volume Group. Elastic SAN Volume Group can contain up to 1,000 volumes.')
  volumes: volumeType[]?

  @sys.description('Optional. List of Virtual Network Rules, permitting virtual network subnet to connect to the resource through service endpoint. Each Elastic SAN Volume Group supports up to 200 virtual network rules.')
  virtualNetworkRules: virtualNetworkRuleType[]?

  @sys.description('Optional. The managed identity definition for this resource. The Elastic SAN Volume Group supports the following identity combinations: no identity is specified, only system-assigned identity is specified, only user-assigned identity is specified, and both system-assigned and user-assigned identities are specified. A maximum of one user-assigned identity is supported.')
  managedIdentities: managedIdentityAllType?

  @sys.description('Optional. The customer managed key definition. This parameter enables the encryption of Elastic SAN Volume Group using a customer-managed key. Currently, the only supported configuration is to use the same user-assigned identity for both \'managedIdentities.userAssignedResourceIds\' and \'customerManagedKey.userAssignedIdentityResourceId\'. Other configurations such as system-assigned identity are not supported. Ensure that the specified user-assigned identity has the \'Key Vault Crypto Service Encryption User\' role access to both the key vault and the key itself. The key vault must also have purge protection enabled.')
  customerManagedKey: customerManagedKeyType?

  @sys.description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. Private endpoints are not currently supported for Elastic SANs using zone-redundant storage (ZRS).')
  privateEndpoints: privateEndpointSingleServiceType[]?
}

@export()
type volumeGroupOutputType = {
  @sys.description('The resource ID of the deployed Elastic SAN Volume Group.')
  resourceId: string

  @sys.description('The name of the deployed Elastic SAN Volume Group.')
  name: string

  @sys.description('The resource group of the deployed Elastic SAN Volume Group.')
  resourceGroupName: string

  @sys.description('The principal ID of the system assigned identity of the deployed Elastic SAN Volume Group.')
  systemAssignedMIPrincipalId: string

  @sys.description('Details on the deployed Elastic SAN Volumes.')
  volumes: volumeOutputType[]

  // TODO privateEndpoints
}

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.3.0'
@sys.description('Optional. The lock settings of the service.')
param lock lockType?

/*

TODO:
out elasticSan_volumeGroups





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

/*




import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.3.0'
@sys.description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

https://learn.microsoft.com/en-us/azure/storage/elastic-san/elastic-san-metrics
All - Every resource log offered by the resource.
Audit - All resource logs that record customer interactions with data or the settings of the service.





import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.3.0'
@sys.description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?




*/

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
