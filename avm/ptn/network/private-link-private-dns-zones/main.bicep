metadata name = 'avm/ptn/network/private-link-private-dns-zones'
metadata description = 'Private Link Private DNS Zones'

@description('Optional. Azure region where the each of the Private Link Private DNS Zones created will be deployed, default to Resource Group location if not specified.')
param location string = resourceGroup().location

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
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
  'privatelink.api.azureml.ms'
  'privatelink.notebooks.azure.net'
  'privatelink.cognitiveservices.azure.com'
  'privatelink.openai.azure.com'
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
  '{regionName}.data.privatelink.azurecr.io'
  #disable-next-line no-hardcoded-env-urls
  'privatelink.database.windows.net'
  'privatelink.documents.azure.com'
  'privatelink.mongo.cosmos.azure.com'
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
  'scm.privatelink.azurewebsites.net'
  'privatelink.service.signalr.net'
  'privatelink.azurestaticapps.net'
]

@description('Optional. An array of Virtual Network Resource IDs to link to the Private Link Private DNS Zones. Each item must be a valid Virtual Network Resource ID.')
param virtualNetworkResourceIdsToLinkTo array = []

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var azureRegionGeoCodeShortNameAsKey = {
  uaenorth: 'uan'
  northcentralus: 'ncus'
  malaysiawest: 'myw'
  eastus: 'eus'
  uksouth: 'uks'
  westcentralus: 'wcus'
  israelcentral: 'ilc'
  southeastasia: 'sea'
  malaysiasouth: 'mys'
  koreacentral: 'krc'
  northeurope: 'ne'
  australiaeast: 'ae'
  southafricanorth: 'san'
  norwaywest: 'nww'
  norwayeast: 'nwe'
  westus3: 'wus3'
  eastus2euap: 'ecy'
  centralus: 'cus'
  mexicocentral: 'mxc'
  canadacentral: 'cnc'
  japaneast: 'jpe'
  swedencentral: 'sdc'
  taiwannorth: 'twn'
  germanynorth: 'gn'
  centralindia: 'inc'
  westindia: 'inw'
  newzealandnorth: 'nzn'
  australiacentral: 'acl'
  ukwest: 'ukw'
  germanywestcentral: 'gwc'
  brazilsouth: 'brs'
  francecentral: 'frc'
  brazilsoutheast: 'bse'
  westus2: 'wus2'
  eastus2: 'eus2'
  centraluseuap: 'ccy'
  australiacentral2: 'acl2'
  francesouth: 'frs'
  southafricawest: 'saw'
  koreasouth: 'krs'
  southindia: 'ins'
  canadaeast: 'cne'
  qatarcentral: 'qac'
  spaincentral: 'spc'
  westeurope: 'we'
  japanwest: 'jpw'
  southcentralus: 'scus'
  polandcentral: 'plc'
  switzerlandwest: 'szw'
  australiasoutheast: 'ase'
  switzerlandnorth: 'szn'
  italynorth: 'itn'
  uaecentral: 'uac'
  eastasia: 'ea'
  chilecentral: 'clc'
  westus: 'wus'
  swedensouth: 'sds'
  usgovvirginia: 'ugv'
  usgovtexas: 'ugt'
  usgovarizona: 'uga'
  usdodeast: 'ude'
  usdodcentral: 'udc'
}

var azureRegionShortNameDisplayNameAsKey = {
  'australia southeast': 'australiasoutheast'
  'west central us': 'westcentralus'
  'chile central': 'chilecentral'
  'east us 2 euap': 'eastus2euap'
  'japan west': 'japanwest'
  'west us 2': 'westus2'
  'uae central': 'uaecentral'
  'france central': 'francecentral'
  'east us 2': 'eastus2'
  'malaysia west': 'malaysiawest'
  'korea south': 'koreasouth'
  'switzerland west': 'switzerlandwest'
  'west us': 'westus'
  'australia central 2': 'australiacentral2'
  'north europe': 'northeurope'
  'switzerland north': 'switzerlandnorth'
  'uae north': 'uaenorth'
  'australia east': 'australiaeast'
  'new zealand north': 'newzealandnorth'
  'japan east': 'japaneast'
  'norway east': 'norwayeast'
  'south india': 'southindia'
  'korea central': 'koreacentral'
  'malaysia south': 'malaysiasouth'
  'uk south': 'uksouth'
  'qatar central': 'qatarcentral'
  'canada east': 'canadaeast'
  'north central us': 'northcentralus'
  'east asia': 'eastasia'
  'uk west': 'ukwest'
  'brazil southeast': 'brazilsoutheast'
  'canada central': 'canadacentral'
  'germany north': 'germanynorth'
  'west india': 'westindia'
  'italy north': 'italynorth'
  'israel central': 'israelcentral'
  'brazil south': 'brazilsouth'
  'central us euap': 'centraluseuap'
  'germany west central': 'germanywestcentral'
  'south africa north': 'southafricanorth'
  'sweden south': 'swedensouth'
  'poland central': 'polandcentral'
  'spain central': 'spaincentral'
  'south central us': 'southcentralus'
  'east us': 'eastus'
  'southeast asia': 'southeastasia'
  'france south': 'francesouth'
  'australia central': 'australiacentral'
  'central us': 'centralus'
  'central india': 'centralindia'
  'norway west': 'norwaywest'
  'mexico central': 'mexicocentral'
  'west europe': 'westeurope'
  'south africa west': 'southafricawest'
  'west us 3': 'westus3'
  'taiwan north': 'taiwannorth'
  'sweden central': 'swedencentral'
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
  for zone in privateLinkPrivateDnsZones: replace(
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

var combinedPrivateLinkPrivateDnsZonesReplacedWithVnetsToLink = map(
  range(0, length(privateLinkPrivateDnsZonesReplacedWithRegionName)),
  i => {
    pdnsZoneName: privateLinkPrivateDnsZonesReplacedWithRegionName[i]
    virtualNetworkResourceIdsToLinkTo: virtualNetworkResourceIdsToLinkTo
  }
)

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2023-07-01' = if (enableTelemetry) {
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

module pdnsZones 'br/public:avm/res/network/private-dns-zone:0.6.0' = [
  for zone in combinedPrivateLinkPrivateDnsZonesReplacedWithVnetsToLink: {
    name: '${uniqueString(deployment().name, zone.pdnsZoneName, location)}-pdns-zone-deployment'
    params: {
      name: zone.pdnsZoneName
      virtualNetworkLinks: [
        for vnet in zone.virtualNetworkResourceIdsToLinkTo: {
          registrationEnabled: false
          virtualNetworkResourceId: vnet
        }
      ]
      lock: lock
      tags: tags
      enableTelemetry: enableTelemetry
    }
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
