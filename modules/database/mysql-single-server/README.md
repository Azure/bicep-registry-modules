# Azure MySQL Database

This module deploys a MySQL database in Azure.

## Description

This Bicep Module is used for the deployment of MySQL DB with reusable set of parameters and resources.It allows for the creation of a new MySQL DB or use of an existing one and offets support for adding private endpoints.
The MySQL Server bicep module is a piece of infrastructure as code (IaC) that defines and deploys a MySQL database server in Microsoft Azure using the Bicep language. Bicep is a domain-specific language that simplifies the process of deploying and managing cloud resources in Azure.
The MySQL Server bicep module includes the necessary code to create a MySQL server, along with the associated resources required to support the server, such as a virtual network, a subnet, and a private endpoint. The module also allows for the configuration of additional settings, such as the server's admin username and password, and the server's location.
By using the MySQL Server bicep module, users can easily deploy a MySQL database server to Azure without the need to manually provision and configure resources. This can save time and reduce the risk of errors, while also providing a consistent and repeatable deployment process.

## Parameters

| Name                               | Type           | Required | Description                                                                                                                                                                                                                                                                           |
| :--------------------------------- | :------------: | :------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `location`                         | `string`       | No       | Deployment region name. Default is the location of the resource group.                                                                                                                                                                                                                |
| `tags`                             | `object`       | No       | Deployment tags. Default is empty map.                                                                                                                                                                                                                                                |
| `administratorLogin`               | `string`       | Yes      | Required. The administrator username of the server. Can only be specified when the server is being created.                                                                                                                                                                           |
| `administratorLoginPassword`       | `securestring` | Yes      | Required. The administrator password of the server. Can only be specified when the server is being created.                                                                                                                                                                           |
| `backupRetentionDays`              | `int`          | No       | Optional. The number of days a backup is retained.                                                                                                                                                                                                                                    |
| `createMode`                       | `string`       | No       | Optional. The mode to create a new server.                                                                                                                                                                                                                                            |
| `databases`                        | `array`        | No       | Optional. List of databases to create on server.                                                                                                                                                                                                                                      |
| `serverConfigurations`             | `array`        | No       | Optional. List of server configurations to create on server.                                                                                                                                                                                                                          |
| `infrastructureEncryption`         | `string`       | No       | Optional. Status showing whether the server enabled infrastructure encryption..                                                                                                                                                                                                       |
| `firewallRules`                    | `array`        | No       | Optional. List of firewall rules to create on server.                                                                                                                                                                                                                                 |
| `privateEndpoints`                 | `array`        | No       | Optional. List of privateEndpoints to create on server.                                                                                                                                                                                                                               |
| `geoRedundantBackup`               | `string`       | No       | Optional. Enable or disable geo-redundant backups.                                                                                                                                                                                                                                    |
| `minimalTlsVersion`                | `string`       | No       | Optional. Enforce a minimal Tls version for the server.                                                                                                                                                                                                                               |
| `restorePointInTime`               | `string`       | No       | Optional. Restore point creation time (ISO8601 format), specifying the time to restore from.                                                                                                                                                                                          |
| `publicNetworkAccess`              | `string`       | No       | Optional. Whether or not public network access is allowed for this server.                                                                                                                                                                                                            |
| `serverName`                       | `string`       | Yes      | Required. The name of the server.                                                                                                                                                                                                                                                     |
| `skuName`                          | `string`       | No       | Optional.	The name of the sku, typically, tier + family + cores, e.g. B_Gen4_1, GP_Gen5_8.                                                                                                                                                                                            |
| `sourceServerResourceId`           | `string`       | No       | Optional. The source server resource id to restore from, e.g. "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg1/providers/Microsoft.DBforMySQL/flexibleServers/server1" . It's required when "createMode" is "GeoRestore" or "Replica" or "PointInTimeRestore". |
| `sslEnforcement`                   | `string`       | No       | Optional. Enable ssl enforcement or not when connect to server.                                                                                                                                                                                                                       |
| `storageAutogrow`                  | `string`       | No       | Optional. Auto grow of storage.                                                                                                                                                                                                                                                       |
| `storageSizeGB`                    | `int`          | No       | Optional. The storage size of the server.                                                                                                                                                                                                                                             |
| `version`                          | `string`       | No       | Optional. The version of the MySQL server.                                                                                                                                                                                                                                            |
| `virtualNetworkName`               | `string`       | No       | Optional. Virtual Network Name                                                                                                                                                                                                                                                        |
| `subnetName`                       | `string`       | No       | Optional. Subnet Name                                                                                                                                                                                                                                                                 |
| `virtualNetworkRuleName`           | `string`       | No       | Optional. Virtual Network RuleName                                                                                                                                                                                                                                                    |
| `vnetAddressPrefix`                | `string`       | No       | Optional. Virtual Network Address Prefix                                                                                                                                                                                                                                              |
| `subnetPrefix`                     | `string`       | No       | Optional. Subnet Address Prefix                                                                                                                                                                                                                                                       |
| `ignoreMissingVnetServiceEndpoint` | `bool`         | No       | Optional. Create firewall rule before the virtual network has vnet service endpoint enabled                                                                                                                                                                                           |
| `privateDnsZoneName`               | `string`       | No       | Optional. Private DNS zone name for the private endpoint. Default is privatelink.mysql.database.azure.com                                                                                                                                                                             |

## Outputs

| Name | Type   | Description                       |
| :--- | :----: | :-------------------------------- |
| id   | string | MySQL server Resource id          |
| fqdn | string | MySQL fully Qualified Domain Name |

## Examples

### Example 1

This example deploys a MySQL database.

```
targetScope = 'resourceGroup'
param location string = 'canadacentral'
var serverName = uniqueString(resourceGroup().id, deployment().name, location)

module test01 '../main.bicep' = {
  name: 'test01-${serverName}'
  params: {
    location: location
    name: 'test01-${serverName}'
  }
}

```

### Example 2

This example deploys a MySQL database with login and password with the sku name and firewall rules , server configurations and private endpoints.

```
targetScope = 'resourceGroup'
param location string = 'canadacentral'
var serverName = uniqueString(resourceGroup().id, deployment().name, location)
@secure()
param administratorLogin string
@secure()
param administratorLoginPassword string
param resourceId string = ''
param resourceName string = 'mysqlserver'
param skuName string = 'B_Gen5_1'
param databases array = [{
    name: 'testdb'
    charset: 'UTF8'
    collation: 'en_US.UTF8'
  }
]
param firewallRules array = [{
    name: 'AllowAll'
    startIpAddress: '10.0.0.0'
    endIpAddress: '10.255.255.255'
  }
]
param privateDnsZoneName string = 'privatelink.mysql.database.azure.com'
param serverConfigurations array = [ {
    name: 'flush_time'
    value: '100'
  }
  {
    name: 'innodb_compression_level'
    value: '7'
  }
]
param privateEndpoints array = [{
    name: 'pep-${resourceName}-${uniqueString(resourceGroup().id)}'
    id: resourceId
    description: 'Auto-approved by Bicep module'
    status: 'Approved'
  }
]

module test02 '../main.bicep' = {
  name: 'test02-${serverName}'
  params: {
    location: location
    serverName: 'test02-${serverName}'
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    databases: databases
    skuName: skuName
    firewallRules: firewallRules
    privateDnsZoneName: privateDnsZoneName
    serverConfigurations: serverConfigurations
    privateEndpoints: privateEndpoints
  }
}
```
