metadata name = 'avm/ptn/network/private-link-private-dns-zones'
metadata description = 'Private Link Private DNS Zones'

@description('Optional. Azure region where the each of the Private Link Private DNS Zones created will be deployed, default to Resource Group location if not specified.')
param location string = resourceGroup().location

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.6.0'
@description('Optional. The lock settings for the Private Link Private DNS Zones created.')
param lock lockType?

@description('Optional. Tags of the Private Link Private DNS Zones created.')
param tags object?

@description('''
Optional. An array of Private Link Private DNS Zones to create. Each item must be a valid DNS zone name.

**NOTE:**

- Private Link Private DNS Zones that have `{{regionCode}}` in the name will be replaced with the Geo Code of the Region you specified in the `location` parameter, if available, as documented [here](https://learn.microsoft.com/azure/private-link/private-endpoint-dns#:~:text=Note-,In%20the%20above%20text%2C%20%7BregionCode%7D%20refers%20to%20the%20region%20code%20(for%20example%2C%20eus%20for%20East%20US%20and%20ne%20for%20North%20Europe).%20Refer%20to%20the%20following%20lists%20for%20regions%20codes%3A,-All%20public%20clouds).
  - e.g. If `UK South` or `uksouth` was specified as the region in the `location` parameter, `{{regionCode}}` would be replaced with `uks` in the Private DNS Zone name.
- Private Link Private DNS Zones that have `{{regionName}}` in the name will be replaced with the short name of the Region you specified in the `location` parameter, if available, as documented [here](https://learn.microsoft.com/azure/private-link/private-endpoint-dns).
  - e.g. If `UK South` or `uksouth` was specified as the region in the `location` parameter, `{{regionName}}` would be replaced with `uksouth` in the Private DNS Zone name.

**IMPORTANT:**

The folowing Private Link Private DNS Zones have been removed from the default value for this parameter as they require additional placeholders to be replaced that will only be known by the caller of the module at runtime and cannot be determined by the module itself. If you have a requirement to create these Private Link Private DNS Zones, you must provide the full list of Private Link Private DNS Zones to create as an array in the `privateLinkPrivateDnsZones` parameter, using the default value as a reference. The list of Private Link Private DNS Zones that have been removed are:

- `{subzone}.privatelink.{regionName}.azmk8s.io`
- `privatelink.{dnsPrefix}.database.windows.net`
- `privatelink.{partitionId}.azurestaticapps.net`

We have also removed the following Private Link Private DNS Zones from the default value for this parameter as they should only be created and used with in specific scenarios:

- `privatelink.azure.com`.
''')
param privateLinkPrivateDnsZones array = [
  'privatelink.{regionName}.azurecontainerapps.io'
  'privatelink.api.azureml.ms'
  'privatelink.notebooks.azure.net'
  'privatelink.cognitiveservices.azure.com'
  'privatelink.openai.azure.com'
  'privatelink.services.ai.azure.com'
  'privatelink.directline.botframework.com'
  'privatelink.token.botframework.com'
  'privatelink.servicebus.windows.net'
  'privatelink.datafactory.azure.net'
  'privatelink.adf.azure.com'
  'privatelink.azurehdinsight.net'
  'privatelink.{regionName}.kusto.windows.net'
  #disable-next-line no-hardcoded-env-urls
  'privatelink.blob.core.windows.net'
  #disable-next-line no-hardcoded-env-urls
  'privatelink.queue.core.windows.net'
  #disable-next-line no-hardcoded-env-urls
  'privatelink.table.core.windows.net'
  #disable-next-line no-hardcoded-env-urls
  'privatelink.file.core.windows.net'
  #disable-next-line no-hardcoded-env-urls
  'privatelink.web.core.windows.net'
  #disable-next-line no-hardcoded-env-urls
  'privatelink.dfs.core.windows.net'
  'privatelink.afs.azure.net'
  'privatelink.analysis.windows.net'
  'privatelink.pbidedicated.windows.net'
  'privatelink.tip1.powerquery.microsoft.com'
  'privatelink.azuredatabricks.net'
  'privatelink.batch.azure.com'
  'privatelink-global.wvd.microsoft.com'
  'privatelink.wvd.microsoft.com'
  'privatelink.{regionName}.azmk8s.io'
  'privatelink.azurecr.io'
  #disable-next-line no-hardcoded-env-urls
  'privatelink.database.windows.net'
  'privatelink.documents.azure.com'
  'privatelink.mongo.cosmos.azure.com'
  'privatelink.mongocluster.cosmos.azure.com'
  'privatelink.cassandra.cosmos.azure.com'
  'privatelink.gremlin.cosmos.azure.com'
  'privatelink.table.cosmos.azure.com'
  'privatelink.analytics.cosmos.azure.com'
  'privatelink.postgres.cosmos.azure.com'
  'privatelink.mariadb.database.azure.com'
  'privatelink.postgres.database.azure.com'
  'privatelink.mysql.database.azure.com'
  'privatelink.redis.cache.windows.net'
  'privatelink.redisenterprise.cache.azure.net'
  'privatelink.his.arc.azure.com'
  'privatelink.guestconfiguration.azure.com'
  'privatelink.dp.kubernetesconfiguration.azure.com'
  'privatelink.eventgrid.azure.net'
  'privatelink.azure-api.net'
  'privatelink.azurehealthcareapis.com'
  'privatelink.workspace.azurehealthcareapis.com'
  'privatelink.fhir.azurehealthcareapis.com'
  'privatelink.dicom.azurehealthcareapis.com'
  'privatelink.azure-devices.net'
  'privatelink.azure-devices-provisioning.net'
  'privatelink.api.adu.microsoft.com'
  'privatelink.azureiotcentral.com'
  'privatelink.digitaltwins.azure.net'
  'privatelink.media.azure.net'
  'privatelink.azure-automation.net'
  'privatelink.{regionCode}.backup.windowsazure.com'
  'privatelink.siterecovery.windowsazure.com'
  'privatelink.monitor.azure.com'
  'privatelink.{regionName}.prometheus.monitor.azure.com'
  'privatelink.oms.opinsights.azure.com'
  'privatelink.ods.opinsights.azure.com'
  'privatelink.agentsvc.azure-automation.net'
  'privatelink.purview.azure.com'
  'privatelink.purviewstudio.azure.com'
  'privatelink.prod.migration.windowsazure.com'
  'privatelink.grafana.azure.com'
  'privatelink.vaultcore.azure.net'
  'privatelink.managedhsm.azure.net'
  'privatelink.azconfig.io'
  'privatelink.attest.azure.net'
  'privatelink.search.windows.net'
  'privatelink.azurewebsites.net'
  'privatelink.service.signalr.net'
  'privatelink.azurestaticapps.net'
  'privatelink.azuresynapse.net'
  'privatelink.dev.azuresynapse.net'
  'privatelink.sql.azuresynapse.net'
  'privatelink.webpubsub.azure.com'
]

@description('Optional. An array of Private Link Private DNS Zones to exclude from the deployment. The DNS zone names must match what is provided as the default values or any input to the `privateLinkPrivateDnsZones` parameter e.g. `privatelink.api.azureml.ms` or `privatelink.{regionCode}.backup.windowsazure.com` or `privatelink.{regionName}.azmk8s.io` .')
param privateLinkPrivateDnsZonesToExclude string[]?

@description('Optional. An array of additional Private Link Private DNS Zones to include in the deployment on top of the defaults set in the parameter `privateLinkPrivateDnsZones`.')
param additionalPrivateLinkPrivateDnsZonesToInclude string[]?

@description('Optional. ***DEPRECATED, PLEASE USE `virtualNetworkLinks` INSTEAD AS MORE VIRTUAL NETWORK LINK PROPERTIES ARE EXPOSED. IF INPUT IS PROVIDED TO `virtualNetworkLinks` THIS PARAMETERS INPUT WILL BE PROCESSED AND INPUT AND FORMATTED BY THE MODULE AND UNIOND WITH THE INPUT TO `virtualNetworkLinks`. THIS PARAMETER WILL BE REMOVED IN A FUTURE RELEASE.*** An array of Virtual Network Resource IDs to link to the Private Link Private DNS Zones. Each item must be a valid Virtual Network Resource ID.')
param virtualNetworkResourceIdsToLinkTo array = []

import { virtualNetworkLinkType } from 'modules/virtual-network-link.bicep'
@description('Optional. Array of custom objects describing vNet links of the DNS zone. Each object should contain properties \'virtualNetworkResourceId\'. The \'vnetResourceId\' is a resource ID of a vNet to link.')
param virtualNetworkLinks virtualNetworkLinkType[]?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var combinedPrivateLinkPrivateDnsZonesProvided = union(
  privateLinkPrivateDnsZones,
  additionalPrivateLinkPrivateDnsZonesToInclude ?? []
)

var privateLinkPrivateDnsZonesWithExclusions = filter(
  combinedPrivateLinkPrivateDnsZonesProvided,
  zone => !contains(privateLinkPrivateDnsZonesToExclude ?? [], zone)
)

var azureRegionGeoCodeShortNameAsKey = {
  australiacentral: 'acl'
  australiacentral2: 'acl2'
  australiaeast: 'ae'
  australiasoutheast: 'ase'
  austriaeast: 'aue'
  belgiumcentral: 'bec'
  brazilsouth: 'brs'
  brazilsoutheast: 'bse'
  canadacentral: 'cnc'
  canadaeast: 'cne'
  centralindia: 'inc'
  centralus: 'cus'
  centraluseuap: 'ccy'
  chilecentral: 'clc'
  denmarkeast: 'dke'
  eastasia: 'ea'
  eastus: 'eus'
  eastus2: 'eus2'
  eastus2euap: 'ecy'
  eastus3: 'eus3'
  francecentral: 'frc'
  francesouth: 'frs'
  germanynorth: 'gn'
  germanywestcentral: 'gwc'
  indiasouthcentral: 'insc'
  indonesiacentral: 'idc'
  israelcentral: 'ilc'
  israelnorthwest: 'iln'
  italynorth: 'itn'
  japaneast: 'jpe'
  japanwest: 'jpw'
  jioindiacentral: 'jic'
  jioindiawest: 'jiw'
  koreacentral: 'krc'
  koreasouth: 'krs'
  malaysiasouth: 'mys'
  malaysiawest: 'myw'
  mexicocentral: 'mxc'
  newzealandnorth: 'nzn'
  northcentralus: 'ncus'
  northeastus5: 'ne5s'
  northeurope: 'ne'
  norwayeast: 'nwe'
  norwaywest: 'nww'
  polandcentral: 'plc'
  qatarcentral: 'qac'
  southafricanorth: 'san'
  southafricawest: 'saw'
  southcentralus: 'scus'
  southcentralus2: 'usc2'
  southeastasia: 'sea'
  southeastus: 'use'
  southeastus3: 'use3'
  southeastus5: 'use5'
  southindia: 'ins'
  southwestus: 'swus'
  spaincentral: 'spc'
  swedencentral: 'sdc'
  swedensouth: 'sds'
  switzerlandnorth: 'szn'
  switzerlandwest: 'szw'
  taiwannorth: 'twn'
  taiwannorthwest: 'tnw'
  uaecentral: 'uac'
  uaenorth: 'uan'
  uksouth: 'uks'
  ukwest: 'ukw'
  westcentralus: 'wcus'
  westeurope: 'we'
  westindia: 'inw'
  westus: 'wus'
  westus2: 'wus2'
  westus3: 'wus3'
  usgovvirginia: 'ugv'
  usgovtexas: 'ugt'
  usgovarizona: 'uga'
  usdodeast: 'ude'
  usdodcentral: 'udc'
}

var azureRegionShortNameDisplayNameAsKey = {
  'australia central': 'australiacentral'
  'australia central 2': 'australiacentral2'
  'australia east': 'australiaeast'
  'australia southeast': 'australiasoutheast'
  'austria east': 'austriaeast'
  'belgium central': 'belgiumcentral'
  'brazil south': 'brazilsouth'
  'brazil southeast': 'brazilsoutheast'
  'canada central': 'canadacentral'
  'canada east': 'canadaeast'
  'central india': 'centralindia'
  'central us': 'centralus'
  'central us euap': 'centraluseuap'
  'chile central': 'chilecentral'
  'denmark east': 'denmarkeast'
  'east asia': 'eastasia'
  'east us': 'eastus'
  'east us 2': 'eastus2'
  'east us 2 euap': 'eastus2euap'
  'east us 3': 'eastus3'
  'france central': 'francecentral'
  'france south': 'francesouth'
  'germany north': 'germanynorth'
  'germany west central': 'germanywestcentral'
  'india south central': 'indiasouthcentral'
  'indonesia central': 'indonesiacentral'
  'israel central': 'israelcentral'
  'israel northwest': 'israelnorthwest'
  'italy north': 'italynorth'
  'japan east': 'japaneast'
  'japan west': 'japanwest'
  'jio india central': 'jioindiacentral'
  'jio india west': 'jioindiawest'
  'korea central': 'koreacentral'
  'korea south': 'koreasouth'
  'malaysia south': 'malaysiasouth'
  'malaysia west': 'malaysiawest'
  'mexico central': 'mexicocentral'
  'new zealand north': 'newzealandnorth'
  'north central us': 'northcentralus'
  'north europe': 'northeurope'
  'northeast us 5': 'northeastus5'
  'norway east': 'norwayeast'
  'norway west': 'norwaywest'
  'poland central': 'polandcentral'
  'qatar central': 'qatarcentral'
  'south africa north': 'southafricanorth'
  'south africa west': 'southafricawest'
  'south central us': 'southcentralus'
  'south central us 2': 'southcentralus2'
  'south india': 'southindia'
  'southeast asia': 'southeastasia'
  'southeast us': 'southeastus'
  'southeast us 3': 'southeastus3'
  'southeast us 5': 'southeastus5'
  'southwest us': 'southwestus'
  'spain central': 'spaincentral'
  'sweden central': 'swedencentral'
  'sweden south': 'swedensouth'
  'switzerland north': 'switzerlandnorth'
  'switzerland west': 'switzerlandwest'
  'taiwan north': 'taiwannorth'
  'taiwan northwest': 'taiwannorthwest'
  'uae central': 'uaecentral'
  'uae north': 'uaenorth'
  'uk south': 'uksouth'
  'uk west': 'ukwest'
  'west central us': 'westcentralus'
  'west europe': 'westeurope'
  'west india': 'westindia'
  'west us': 'westus'
  'west us 2': 'westus2'
  'west us 3': 'westus3'
  'usgov virginia': 'usgovvirginia'
  'usgov texas': 'usgovtexas'
  'usgov arizona': 'usgovarizona'
  'usdod east': 'usdodeast'
  'usdod central': 'usdodcentral'
}

var locationLowered = toLower(location)
var locationLoweredAndSpacesRemoved = contains(locationLowered, ' ')
  ? azureRegionShortNameDisplayNameAsKey[locationLowered]
  : locationLowered

var privateLinkPrivateDnsZonesReplacedWithRegionCode = [
  for zone in privateLinkPrivateDnsZonesWithExclusions: replace(
    zone,
    '{regionCode}',
    azureRegionGeoCodeShortNameAsKey[locationLoweredAndSpacesRemoved]
  )
]

var privateLinkPrivateDnsZonesReplacedWithRegionName = [
  for zone in privateLinkPrivateDnsZonesReplacedWithRegionCode: replace(
    zone,
    '{regionName}',
    locationLoweredAndSpacesRemoved
  )
]

var toDeprecateVirtualNetworkResourceIdsToLinkToObject = [
  for vnet in virtualNetworkResourceIdsToLinkTo: {
    virtualNetworkResourceId: vnet
  }
]

var combinedPrivateLinkPrivateDnsZonesReplacedWithVnetsToLink = map(
  range(0, length(privateLinkPrivateDnsZonesReplacedWithRegionName)),
  i => {
    pdnsZoneName: privateLinkPrivateDnsZonesReplacedWithRegionName[i]
    virtualNetworkLinks: union(toDeprecateVirtualNetworkResourceIdsToLinkToObject, (virtualNetworkLinks ?? []))
  }
)

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.network-privatelinkprivatednszones.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource pdnsZones 'Microsoft.Network/privateDnsZones@2024-06-01' = [
  for zone in combinedPrivateLinkPrivateDnsZonesReplacedWithVnetsToLink: {
    name: zone.pdnsZoneName
    location: 'global'
    tags: tags
  }
]

resource pdnsZonesLock 'Microsoft.Authorization/locks@2020-05-01' = [
  for (zone, i) in combinedPrivateLinkPrivateDnsZonesReplacedWithVnetsToLink: if (!empty(lock ?? {}) && lock.?kind != 'None') {
    name: lock.?name ?? 'lock-${zone.pdnsZoneName}'
    properties: {
      level: lock.?kind ?? ''
      notes: lock.?kind == 'CanNotDelete'
        ? 'Cannot delete resource or child resources.'
        : 'Cannot delete or modify the resource or child resources.'
    }
    scope: pdnsZones[i]
  }
]

module pdnsZoneVnetLinks 'modules/virtual-network-link.bicep' = [
  for zone in combinedPrivateLinkPrivateDnsZonesReplacedWithVnetsToLink: {
    name: '${uniqueString(subscription().id, resourceGroup().id, zone.pdnsZoneName, location)}-pdns-zone-vnet-links-loop'
    params: {
      privateDnsZoneName: zone.pdnsZoneName
      virtualNetworkLinks: zone.virtualNetworkLinks
      tags: tags
    }
    dependsOn: [
      pdnsZones
    ]
  }
]

// ============ //
// Outputs      //
// ============ //

@description('The final array of objects of private link private DNS zones to link to virtual networks including the region name replacements as required.')
output combinedPrivateLinkPrivateDnsZonesReplacedWithVnetsToLink array = combinedPrivateLinkPrivateDnsZonesReplacedWithVnetsToLink

@description('The resource ID of the resource group that the Private DNS Zones are deployed into.')
output resourceGroupResourceId string = resourceGroup().id

@description('The name of the resource group that the Private DNS Zones are deployed into.')
output resourceGroupName string = resourceGroup().name
