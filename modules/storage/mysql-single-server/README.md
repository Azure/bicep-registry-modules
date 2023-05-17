# Azure MySQL Single Server Database

This module deploys a MySQL Single Server database.

## Description

This Bicep Module is used for the deployment of MySQL DB  Single Server with reusable set of parameters and resources.It allows for the creation of a new MySQL DB or use of an existing one and offets support for adding private endpoints.
The MySQL Server bicep module is a piece of infrastructure as code (IaC) that defines and deploys a MySQL database server in Microsoft Azure using the Bicep language. Bicep is a domain-specific language that simplifies the process of deploying and managing cloud resources in Azure.
The MySQL Server bicep module includes the necessary code to create a MySQL server, along with the associated resources required to support the server, such as a virtual network, a subnet, and a private endpoint. The module also allows for the configuration of additional settings, such as the server's admin username and password, and the server's location.
By using the MySQL Server bicep module, users can easily deploy a MySQL database server to Azure without the need to manually provision and configure resources. This can save time and reduce the risk of errors, while also providing a consistent and repeatable deployment process.
This module requires the namespace 'Microsoft.DBforMySQL' to be registered  for your subscription manually before deployment.

## Parameters

| Name                         | Type           | Required | Description                                                                                                                                                                                                                                                                                                                                                                                  |
| :--------------------------- | :------------: | :------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `location`                   | `string`       | No       | Deployment region name. Default is the location of the resource group.                                                                                                                                                                                                                                                                                                                       |
| `tags`                       | `object`       | No       | Deployment tags. Default is empty map.                                                                                                                                                                                                                                                                                                                                                       |
| `administratorLogin`         | `string`       | Yes      | Required. The administrator username of the server. Can only be specified when the server is being created.                                                                                                                                                                                                                                                                                  |
| `administratorLoginPassword` | `securestring` | Yes      | Required. The administrator password of the server. Can only be specified when the server is being created.                                                                                                                                                                                                                                                                                  |
| `backupRetentionDays`        | `int`          | No       | Optional. The number of days a backup is retained.                                                                                                                                                                                                                                                                                                                                           |
| `createMode`                 | `string`       | No       | Optional. The mode to create a new server.                                                                                                                                                                                                                                                                                                                                                   |
| `databases`                  | `array`        | No       | Optional. List of databases to create on server.                                                                                                                                                                                                                                                                                                                                             |
| `serverConfigurations`       | `array`        | No       | Optional. List of server configurations to create on server.                                                                                                                                                                                                                                                                                                                                 |
| `infrastructureEncryption`   | `string`       | No       | Optional. Status showing whether the server enabled infrastructure encryption..                                                                                                                                                                                                                                                                                                              |
| `firewallRules`              | `array`        | No       | Optional. List of firewall rules to create on server.                                                                                                                                                                                                                                                                                                                                        |
| `privateEndpoints`           | `array`        | No       | Optional. List of privateEndpoints to create on mysql server.                                                                                                                                                                                                                                                                                                                                |
| `geoRedundantBackup`         | `string`       | No       | Optional. Enable or disable geo-redundant backups.                                                                                                                                                                                                                                                                                                                                           |
| `minimalTlsVersion`          | `string`       | No       | Optional. Enforce a minimal Tls version for the server.                                                                                                                                                                                                                                                                                                                                      |
| `restorePointInTime`         | `string`       | No       | Optional. Restore point creation time (ISO8601 format), specifying the time to restore from.                                                                                                                                                                                                                                                                                                 |
| `publicNetworkAccess`        | `string`       | No       | Optional. Whether or not public network access is allowed for this server.                                                                                                                                                                                                                                                                                                                   |
| `serverName`                 | `string`       | Yes      | Required. The name of the server.                                                                                                                                                                                                                                                                                                                                                            |
| `skuName`                    | `string`       | No       | Optional.	The name of the sku, typically, tier + family + cores, e.g. B_Gen4_1, GP_Gen5_8.                                                                                                                                                                                                                                                                                                   |
| `sourceServerResourceId`     | `string`       | No       | Optional. The source server resource id to restore from, e.g. "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg1/providers/Microsoft.DBforMySQL/flexibleServers/server1" . It's required when "createMode" is "GeoRestore" or "Replica" or "PointInTimeRestore".                                                                                                        |
| `sslEnforcement`             | `string`       | No       | Optional. Enable ssl enforcement or not when connect to server.                                                                                                                                                                                                                                                                                                                              |
| `storageAutogrow`            | `bool`         | No       | Optional. Auto grow of storage.                                                                                                                                                                                                                                                                                                                                                              |
| `storageSizeGB`              | `int`          | No       | Optional. The storage size of the server.                                                                                                                                                                                                                                                                                                                                                    |
| `version`                    | `string`       | No       | Optional. The version of the MySQL server.                                                                                                                                                                                                                                                                                                                                                   |
| `roleAssignments`            | `array`        | No       | Array of role assignment objects that contain the "roleDefinitionIdOrName" and "principalId" to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, provide either the display name of the role definition, or its fully qualified ID in the following format: "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11" |

## Outputs

| Name | Type   | Description                                     |
| :--- | :----: | :---------------------------------------------- |
| id   | string | MySQL Single Server Resource id                 |
| fqdn | string | MySQL Single Server fully Qualified Domain Name |

## Examples

### Example 1

This example deploys a MySQL Single Server database.

```
module test01 'br/public:database/mysql-single-server:1.0' = {
  name: 'test01-${serverName}'
  params: {
    location: location
    name: 'test01-${serverName}'
  }
}

```

### Example 2

This example deploys a MySQL Single Server database with login and password with the sku name and firewall rules , server configurations and private endpoints.

```
module test02 'br/public:database/mysql-single-server:1.0' = {
  name: 'mysqldb-${uniqueString(deployment().name, location)}-deployment'
  params: {
    location: 'westus'
    createMode : 'default'
    serverName: 'mysqldb-${uniqueString(deployment().name, location)}'
    administratorLogin: 'testlogin'
    administratorLoginPassword: 'test@passw0rd123'
    skuName: 'GP_Gen5_2'
    publicNetworkAccess: 'Enabled'
    privateEndpoints: [
      {
        name: 'endpoint1'
        subnetId: /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}"
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

```
module test03 'br/public:database/mysql-single-server:1.0' = {
  name: 'mysqldb-${uniqueString(deployment().name, location)}-deployment'
  params: {
    location: 'westus'
    createMode : 'default'
    serverName: 'mysqldb-${uniqueString(deployment().name, location)}'
    administratorLogin: 'testlogin'
    administratorLoginPassword: 'test@passw0rd123'
    skuName: 'GP_Gen5_2'
    publicNetworkAccess: 'Enabled'
    roleAssignments: [
       {
         roleDefinitionIdOrName: 'SQL DB Contributor'
         principalIds: [ dependencies.outputs.identityPrincipalIds[0] ]
       }
       {
         roleDefinitionIdOrName: 'Log Analytics Reader'
          principalIds: [ dependencies.outputs.identityPrincipalIds[1] ]
       }
    ]
    privateEndpoints: [
      {
        name: 'endpoint1'
        subnetId: /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}"
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