# avm/ptn/network/private-link-private-dns-zones `[Network/PrivateLinkPrivateDnsZones]`

Private Link Private DNS Zones

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Network/privateDnsZones` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones) |
| `Microsoft.Network/privateDnsZones/A` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/A) |
| `Microsoft.Network/privateDnsZones/AAAA` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/AAAA) |
| `Microsoft.Network/privateDnsZones/CNAME` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/CNAME) |
| `Microsoft.Network/privateDnsZones/MX` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/MX) |
| `Microsoft.Network/privateDnsZones/PTR` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/PTR) |
| `Microsoft.Network/privateDnsZones/SOA` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/SOA) |
| `Microsoft.Network/privateDnsZones/SRV` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/SRV) |
| `Microsoft.Network/privateDnsZones/TXT` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/TXT) |
| `Microsoft.Network/privateDnsZones/virtualNetworkLinks` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/virtualNetworkLinks) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/network/private-link-private-dns-zones:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module privateLinkPrivateDnsZones 'br/public:avm/ptn/network/private-link-private-dns-zones:<version>' = {
  name: 'privateLinkPrivateDnsZonesDeployment'
  params: {

  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {}
}
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module privateLinkPrivateDnsZones 'br/public:avm/ptn/network/private-link-private-dns-zones:<version>' = {
  name: 'privateLinkPrivateDnsZonesDeployment'
  params: {
    location: '<location>'
    privateLinkPrivateDnsZones: [
      'testpdnszone1.int'
      'testpdnszone2.local'
    ]
    virtualNetworkResourceIdsToLinkTo: [
      '<vnetResourceId>'
    ]
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "location": {
      "value": "<location>"
    },
    "privateLinkPrivateDnsZones": {
      "value": [
        "testpdnszone1.int",
        "testpdnszone2.local"
      ]
    },
    "virtualNetworkResourceIdsToLinkTo": {
      "value": [
        "<vnetResourceId>"
      ]
    }
  }
}
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module privateLinkPrivateDnsZones 'br/public:avm/ptn/network/private-link-private-dns-zones:<version>' = {
  name: 'privateLinkPrivateDnsZonesDeployment'
  params: {
    virtualNetworkResourceIdsToLinkTo: [
      '<vnetResourceId>'
    ]
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "virtualNetworkResourceIdsToLinkTo": {
      "value": [
        "<vnetResourceId>"
      ]
    }
  }
}
```

</details>
<p>

## Parameters

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Azure region where the each of the Private Link Private DNS Zones created will be deployed, default to Resource Group location if not specified. |
| [`privateLinkPrivateDnsZones`](#parameter-privatelinkprivatednszones) | array | An array of Private Link Private DNS Zones to create. Each item must be a valid DNS zone name.<p><p>**NOTE:**<p><li>Private Link Private DNS Zones that have `{{regionCode}}` in the name will be replaced with the Geo Code of the Region you specified in the `location` parameter, if available, as documented [here](https://learn.microsoft.com/azure/private-link/private-endpoint-dns#:~:text=Note-,In%20the%20above%20text%2C%20%7BregionCode%7D%20refers%20to%20the%20region%20code%20(for%20example%2C%20eus%20for%20East%20US%20and%20ne%20for%20North%20Europe).%20Refer%20to%20the%20following%20lists%20for%20regions%20codes%3A,-All%20public%20clouds).<p>  - e.g. If `UK South` or `uksouth` was specified as the region in the `location` parameter, `{{regionCode}}` would be replaced with `uks` in the Private DNS Zone name.<li>Private Link Private DNS Zones that have `{{regionName}}` in the name will be replaced with the short name of the Region you specified in the `location` parameter, if available, as documented [here](https://learn.microsoft.com/azure/private-link/private-endpoint-dns).<p>  - e.g. If `UK South` or `uksouth` was specified as the region in the `location` parameter, `{{regionName}}` would be replaced with `uksouth` in the Private DNS Zone name.<p><p>**IMPORTANT:**<p><p>The folowing Private Link Private DNS Zones have been removed from the default value for this parameter as they require additional placeholders to be replaced that will only be known by the caller of the module at runtime and cannot be determined by the module itself. If you have a requirement to create these Private Link Private DNS Zones, you must provide the full list of Private Link Private DNS Zones to create as an array in the `privateLinkPrivateDnsZones` parameter, using the default value as a reference. The list of Private Link Private DNS Zones that have been removed are:<p><li>`{subzone}.privatelink.{regionName}.azmk8s.io`<li>`privatelink.{dnsPrefix}.database.windows.net`<li>`privatelink.{partitionId}.azurestaticapps.net`<p><p>We have also removed the following Private Link Private DNS Zones from the default value for this parameter as they should only be created and used with in specific scenarios:<p><li>`privatelink.azure.com`.<p> |
| [`virtualNetworkResourceIdsToLinkTo`](#parameter-virtualnetworkresourceidstolinkto) | array | An array of Virtual Network Resource IDs to link to the Private Link Private DNS Zones. Each item must be a valid Virtual Network Resource ID. |

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Azure region where the each of the Private Link Private DNS Zones created will be deployed, default to Resource Group location if not specified.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `privateLinkPrivateDnsZones`

An array of Private Link Private DNS Zones to create. Each item must be a valid DNS zone name.<p><p>**NOTE:**<p><li>Private Link Private DNS Zones that have `{{regionCode}}` in the name will be replaced with the Geo Code of the Region you specified in the `location` parameter, if available, as documented [here](https://learn.microsoft.com/azure/private-link/private-endpoint-dns#:~:text=Note-,In%20the%20above%20text%2C%20%7BregionCode%7D%20refers%20to%20the%20region%20code%20(for%20example%2C%20eus%20for%20East%20US%20and%20ne%20for%20North%20Europe).%20Refer%20to%20the%20following%20lists%20for%20regions%20codes%3A,-All%20public%20clouds).<p>  - e.g. If `UK South` or `uksouth` was specified as the region in the `location` parameter, `{{regionCode}}` would be replaced with `uks` in the Private DNS Zone name.<li>Private Link Private DNS Zones that have `{{regionName}}` in the name will be replaced with the short name of the Region you specified in the `location` parameter, if available, as documented [here](https://learn.microsoft.com/azure/private-link/private-endpoint-dns).<p>  - e.g. If `UK South` or `uksouth` was specified as the region in the `location` parameter, `{{regionName}}` would be replaced with `uksouth` in the Private DNS Zone name.<p><p>**IMPORTANT:**<p><p>The folowing Private Link Private DNS Zones have been removed from the default value for this parameter as they require additional placeholders to be replaced that will only be known by the caller of the module at runtime and cannot be determined by the module itself. If you have a requirement to create these Private Link Private DNS Zones, you must provide the full list of Private Link Private DNS Zones to create as an array in the `privateLinkPrivateDnsZones` parameter, using the default value as a reference. The list of Private Link Private DNS Zones that have been removed are:<p><li>`{subzone}.privatelink.{regionName}.azmk8s.io`<li>`privatelink.{dnsPrefix}.database.windows.net`<li>`privatelink.{partitionId}.azurestaticapps.net`<p><p>We have also removed the following Private Link Private DNS Zones from the default value for this parameter as they should only be created and used with in specific scenarios:<p><li>`privatelink.azure.com`.<p>

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    '{regionCode}.privatelink.backup.windowsazure.com'
    '{regionName}.data.privatelink.azurecr.io'
    '{regionName}.privatelink.batch.azure.com'
    '{regionName}.service.privatelink.batch.azure.com'
    'privatelink-global.wvd.microsoft.com'
    'privatelink.{regionName}.azmk8s.io'
    'privatelink.{regionName}.kusto.windows.net'
    'privatelink.adf.azure.com'
    'privatelink.afs.azure.net'
    'privatelink.agentsvc.azure-automation.net'
    'privatelink.analysis.windows.net'
    'privatelink.analytics.cosmos.azure.com'
    'privatelink.api.adu.microsoft.com'
    'privatelink.api.azureml.ms'
    'privatelink.attest.azure.net'
    'privatelink.azconfig.io'
    'privatelink.azure-api.net'
    'privatelink.azure-automation.net'
    'privatelink.azure-devices-provisioning.net'
    'privatelink.azure-devices.net'
    'privatelink.azurecr.io'
    'privatelink.azuredatabricks.net'
    'privatelink.azurehdinsight.net'
    'privatelink.azureiotcentral.com'
    'privatelink.azurestaticapps.net'
    'privatelink.azurewebsites.net'
    'privatelink.blob.core.windows.net'
    'privatelink.cassandra.cosmos.azure.com'
    'privatelink.cognitiveservices.azure.com'
    'privatelink.database.windows.net'
    'privatelink.datafactory.azure.net'
    'privatelink.dfs.core.windows.net'
    'privatelink.dicom.azurehealthcareapis.com'
    'privatelink.digitaltwins.azure.net'
    'privatelink.directline.botframework.com'
    'privatelink.documents.azure.com'
    'privatelink.dp.kubernetesconfiguration.azure.com'
    'privatelink.eventgrid.azure.net'
    'privatelink.fhir.azurehealthcareapis.com'
    'privatelink.file.core.windows.net'
    'privatelink.grafana.azure.com'
    'privatelink.gremlin.cosmos.azure.com'
    'privatelink.guestconfiguration.azure.com'
    'privatelink.his.arc.azure.com'
    'privatelink.managedhsm.azure.net'
    'privatelink.mariadb.database.azure.com'
    'privatelink.media.azure.net'
    'privatelink.mongo.cosmos.azure.com'
    'privatelink.monitor.azure.com'
    'privatelink.mysql.database.azure.com'
    'privatelink.notebooks.azure.net'
    'privatelink.ods.opinsights.azure.com'
    'privatelink.oms.opinsights.azure.com'
    'privatelink.openai.azure.com'
    'privatelink.pbidedicated.windows.net'
    'privatelink.postgres.cosmos.azure.com'
    'privatelink.postgres.database.azure.com'
    'privatelink.prod.migration.windowsazure.com'
    'privatelink.purview.azure.com'
    'privatelink.purviewstudio.azure.com'
    'privatelink.queue.core.windows.net'
    'privatelink.redis.cache.windows.net'
    'privatelink.redisenterprise.cache.azure.net'
    'privatelink.search.windows.net'
    'privatelink.service.signalr.net'
    'privatelink.servicebus.windows.net'
    'privatelink.siterecovery.windowsazure.com'
    'privatelink.table.core.windows.net'
    'privatelink.table.cosmos.azure.com'
    'privatelink.tip1.powerquery.microsoft.com'
    'privatelink.token.botframework.com'
    'privatelink.vaultcore.azure.net'
    'privatelink.web.core.windows.net'
    'privatelink.workspace.azurehealthcareapis.com'
    'privatelink.wvd.microsoft.com'
    'scm.privatelink.azurewebsites.net'
  ]
  ```

### Parameter: `virtualNetworkResourceIdsToLinkTo`

An array of Virtual Network Resource IDs to link to the Private Link Private DNS Zones. Each item must be a valid Virtual Network Resource ID.

- Required: No
- Type: array
- Default: `[]`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `combinedPrivateLinkPrivateDnsZonesReplacedWithVnetsToLink` | array | The final array of objects of private link private DNS zones to link to virtual networks including the region name replacements as required. |
| `resourceGroupName` | string | The name of the resource group that the Private DNS Zones are deployed into. |
| `resourceGroupResourceId` | string | The resource ID of the resource group that the Private DNS Zones are deployed into. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/network/private-dns-zone:0.3.0` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
