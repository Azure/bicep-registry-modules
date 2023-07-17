# mysql-single-server

This Bicep Module is used for the deployment of MySQL DB  Single Server with reusable set of parameters and resources.

## Description

The MySQL Server bicep module is a piece of infrastructure as code (IaC) that defines and deploys a MySQL database server in Microsoft Azure using the Bicep language.
Bicep is a domain-specific language that simplifies the process of deploying and managing cloud resources in Azure.
It allows for the creation of a new MySQL DB or use of an existing one and offets support for adding private endpoints.

The MySQL Server bicep module includes the necessary code to create a MySQL server, along with the associated resources required to support the server, such as a virtual network, a subnet, and a private endpoint.
The module also allows for the configuration of additional settings, such as the server's admin username and password, and the server's location.

By using the MySQL Server bicep module, users can easily deploy a MySQL database server to Azure without the need to manually provision and configure resources.
This can save time and reduce the risk of errors, while also providing a consistent and repeatable deployment process.

This module requires the namespace 'Microsoft.DBforMySQL' to be registered  for your subscription manually before deployment.

## Parameters

| Name                           | Type           | Required | Description                                                                                                                                                     |
| :----------------------------- | :------------: | :------: | :-------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `location`                     | `string`       | No       | Optional. Deployment region name. Default is the location of the resource group.                                                                                |
| `prefix`                       | `string`       | No       | Optional. Prefix of mysql resource name. Not used if name is provided.                                                                                          |
| `name`                         | `string`       | No       | Optional. The name of the Mysql DB resources. Character limit: 3-44, valid characters: lowercase letters, numbers, and hyphens. It must me unique across Azure. |
| `serverName`                   | `string`       | No       | Optional. Override the name of the server.                                                                                                                      |
| `tags`                         | `object`       | No       | Optional. Deployment tags.                                                                                                                                      |
| `administratorLogin`           | `string`       | Yes      | Required. The administrator username of the server. Can only be specified when createMode is 'Default'.                                                         |
| `administratorLoginPassword`   | `securestring` | Yes      | Required. The administrator password of the server. Can only be specified when the server is being created.                                                     |
| `backupRetentionDays`          | `int`          | No       | Optional. The number of days a backup is retained.                                                                                                              |
| `createMode`                   | `string`       | No       | Optional. The mode to create a new server.                                                                                                                      |
| `databases`                    | `array`        | No       | Optional. List of databases to create on server.                                                                                                                |
| `serverConfigurations`         | `array`        | No       | Optional. List of server configurations to create on server.                                                                                                    |
| `infrastructureEncryption`     | `string`       | No       | Optional. Status showing whether the server enabled infrastructure encryption..                                                                                 |
| `firewallRules`                | `array`        | No       | Optional. List of firewall rules to create on server.                                                                                                           |
| `virtualNetworkRules`          | `array`        | No       | Optional. List of virtualNetworkRules to create on mysql server.                                                                                                |
| `privateEndpoints`             | `array`        | No       | Optional. List of privateEndpoints to create on mysql server.                                                                                                   |
| `geoRedundantBackup`           | `string`       | No       | Optional. Enable or disable geo-redundant backups. It requires at least a GeneralPurpose or MemoryOptimized skuTier.                                            |
| `minimalTlsVersion`            | `string`       | No       | Optional. Enforce a minimal Tls version for the server.                                                                                                         |
| `restorePointInTime`           | `string`       | No       | Optional. Restore point creation time (ISO8601 format), specifying the time to restore from.                                                                    |
| `publicNetworkAccess`          | `string`       | No       | Optional. Whether or not public network access is allowed for this server.                                                                                      |
| `skuName`                      | `string`       | No       | Optional. The name of the sku, typically, tier + family + cores, e.g. B_Gen4_1, GP_Gen5_8.                                                                      |
| `skuCapacity`                  | `int`          | No       | Optional. Azure database for MySQL compute capacity in vCores (2,4,8,16,32)                                                                                     |
| `SkuSizeMB`                    | `int`          | No       | Optional. Azure database for MySQL Sku Size                                                                                                                     |
| `SkuTier`                      | `string`       | No       | Optional. Azure database for MySQL pricing tier                                                                                                                 |
| `skuFamily`                    | `string`       | No       | Optional. Azure database for MySQL sku family                                                                                                                   |
| `sourceServerResourceId`       | `string`       | No       | Optional. The source server resource id to restore from. It's required when "createMode" is "GeoRestore" or "Replica" or "PointInTimeRestore".                  |
| `enableStorageAutogrow`        | `bool`         | No       | Optional. Auto grow of storage.                                                                                                                                 |
| `storageSizeGB`                | `int`          | No       | Optional. The storage size of the server.                                                                                                                       |
| `version`                      | `string`       | No       | Optional. The version of the MySQL server.                                                                                                                      |
| `roleAssignments`              | `array`        | No       | Optional. Array of role assignment objects that contain the "roleDefinitionIdOrName" and "principalId" to define RBAC role assignments on this resource.        |
| `diagnosticSettingsProperties` | `object`       | No       | Provide mysql diagnostic settings properties.                                                                                                                   |

## Outputs

| Name | Type   | Description                                     |
| :--- | :----: | :---------------------------------------------- |
| id   | string | MySQL Single Server Resource id                 |
| fqdn | string | MySQL Single Server fully Qualified Domain Name |

## Examples

### Example 1

This example deploys a MySQL Single Server database.

```bicep
module test01 'br/public:database/mysql-single-server:1.0.2' = {
  name: 'test01-${serverName}'
  params: {
    prefix: 'mysql-test01'
    location: location
    administratorLogin: 'testlogin'
    administratorLoginPassword: 'test@passw0rd123'
  }
}
```

### Example 2

This example deploys a MySQL Single Server database with login and password with the sku name and firewall rules , server configurations and private endpoints.

```bicep
module test02 'br/public:database/mysql-single-server:1.0.2' = {
  name: 'mysqldb-${uniqueString(deployment().name, location)}-deployment'
  params: {
    prefix: 'mysql-test02'
    location: location
    createMode : 'Default'
    administratorLogin: 'testlogin'
    administratorLoginPassword: 'test@passw0rd123'
    publicNetworkAccess: 'Enabled'
    privateEndpoints: [
      {
        name: 'endpoint1'
        subnetId: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}'
        manualApprovalEnabled: true
        groupId: 'mysqlServer'
      }
    ]
    databases: [
    {
        name: 'testdb'
        charset: 'UTF8'
        collation: 'utf8_bin'
     }
    ]
    firewallRules: [
    {
        name: 'allowip'
        startIpAddress: '10.0.0.1'
        endIpAddress: '10.0.0.1'
    }
    ]
    serverConfigurations: [
    {
        name: 'flush_time'
        value: '100'
    }
    {
        name: 'innodb_compression_level'
        value: '7'
    }
    ]
  }
}
```

### Example 3

This example deploys a MySQL Single Server database with Role Assignments.

```bicep
module test03 'br/public:database/mysql-single-server:1.0.2' = {
  name: 'mysqldb-${uniqueString(deployment().name, location)}-deployment'
  params: {
    prefix: 'mysql-test04'
    location: location
    createMode : 'Default'
    administratorLogin: 'testlogin'
    administratorLoginPassword: 'test@passw0rd123'
    publicNetworkAccess: 'Enabled'
    roleAssignments: [
       {
         roleDefinitionIdOrName: 'SQL DB Contributor'
         principalIds: [ 'principal ID' ]
       }
       {
         roleDefinitionIdOrName: 'Log Analytics Reader'
         principalIds: [ 'principal ID' ]
       }
    ]
    privateEndpoints: [
      {
        name: 'endpoint1'
        subnetId: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}'
        manualApprovalEnabled: false
        groupId: 'mysqlServer'
      }
    ]
    databases: [
    {
        name: 'testdb'
        charset: 'UTF8'
        collation: 'utf8_bin'
     }
    ]
    firewallRules: [
    {
        name: 'allowip'
        startIpAddress: '10.0.0.1'
        endIpAddress: '10.0.0.254'
    }
    ]
    serverConfigurations: [
    {
        name: 'flush_time'
        value: '100'
    }
    {
        name: 'innodb_compression_level'
        value: '7'
    }
    ]
  }
}
```
