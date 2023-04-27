# PostgreSQL Single Server

This module deploys PostgreSQL Single Server (Microsoft.DBforPostgreSQL/servers) and optionally available integrations.

## Description

{{ Add detailed description for the module. }}

## Parameters

| Name                             | Type           | Required | Description                                                                                                                                                                                                                                                                                                                                                                                  |
| :------------------------------- | :------------: | :------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `location`                       | `string`       | No       | The location into which your Azure resources should be deployed.                                                                                                                                                                                                                                                                                                                             |
| `sqlServerName`                  | `string`       | Yes      | The name of the Postgresql Single Server instance.                                                                                                                                                                                                                                                                                                                                           |
| `tags`                           | `object`       | No       | The tags to apply to each resource.                                                                                                                                                                                                                                                                                                                                                          |
| `sqlServerAdministratorLogin`    | `string`       | Yes      | The administrator username of the server. Can only be specified when the server is being created.                                                                                                                                                                                                                                                                                            |
| `sqlServerAdministratorPassword` | `securestring` | Yes      | The administrator login password for the SQL server. Can only be specified when the server is being created.                                                                                                                                                                                                                                                                                 |
| `backupRetentionDays`            | `int`          | No       | Number of days a backup is retained for point-in-time restores.                                                                                                                                                                                                                                                                                                                              |
| `createMode`                     | `string`       | No       | The mode to create a new server.                                                                                                                                                                                                                                                                                                                                                             |
| `databases`                      | `array`        | No       | List of databases to create on server.                                                                                                                                                                                                                                                                                                                                                       |
| `firewallRules`                  | `array`        | No       | List of firewall rules to create on server.                                                                                                                                                                                                                                                                                                                                                  |
| `geoRedundantBackup`             | `bool`         | No       | Toggle geo-redundant backups. Cannot be changed after server creation.                                                                                                                                                                                                                                                                                                                       |
| `infrastructureEncryption`       | `bool`         | No       | Toggle infrastructure double encryption. Cannot be changed after server creation.                                                                                                                                                                                                                                                                                                            |
| `minimalTlsVersion`              | `string`       | No       | Minimal supported TLS version.                                                                                                                                                                                                                                                                                                                                                               |
| `publicNetworkAccess`            | `bool`         | No       | Toggle public network access.                                                                                                                                                                                                                                                                                                                                                                |
| `sqlServerPostgresqlVersion`     | `string`       | No       | PostgreSQL version                                                                                                                                                                                                                                                                                                                                                                           |
| `privateEndpoints`               | `array`        | No       | List of privateEndpoints to create on server.                                                                                                                                                                                                                                                                                                                                                |
| `restorePointInTime`             | `string`       | No       | The point in time (ISO8601 format) of the source server to restore from.                                                                                                                                                                                                                                                                                                                     |
| `sqlServerConfigurations`        | `array`        | No       | List of server configurations to create on server.                                                                                                                                                                                                                                                                                                                                           |
| `skuName`                        | `string`       | No       | The name of the sku, typically, tier + family + cores, e.g. B_Gen4_1.                                                                                                                                                                                                                                                                                                                        |
| `sqlServerStorageSize`           | `int`          | No       | Storage size for Postgresql Single Server. Expressed in Mebibytes. Cannot be scaled down.                                                                                                                                                                                                                                                                                                    |
| `sourceServerResourceId`         | `string`       | No       | The source server id to restore from. Leave empty if creating from scratch.                                                                                                                                                                                                                                                                                                                  |
| `sslEnforcement`                 | `bool`         | No       | Toggle SSL enforcement for incoming connections.                                                                                                                                                                                                                                                                                                                                             |
| `storageAutogrow`                | `bool`         | No       | Toggle storage autogrow.                                                                                                                                                                                                                                                                                                                                                                     |
| `roleAssignments`                | `array`        | No       | Array of role assignment objects that contain the "roleDefinitionIdOrName" and "principalId" to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, provide either the display name of the role definition, or its fully qualified ID in the following format: "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11" |

## Outputs

| Name              | Type   | Description                                                        |
| :---------------- | :----: | :----------------------------------------------------------------- |
| resourceGroupName | string | The resource group the Postgresql Single Server was deployed into. |
| fqdn              | string | FQDN of the generated Postgresql Single Server                     |
| id                | string | The resource ID of the Postgresql Single Server.                   |

## Examples

### Example 1

Deploy a Postgresql Single Server with minimal parameters

```bicep
@secure
param administratorLoginPassword string

module postgresqlSingleServer 'br/public:storage/postgresql-single-server:1.0' = {
  name: 'postgresqlSingleServer'
  params: {
    sqlServerAdministratorLogin: 'testlogin'
    sqlServerAdministratorPassword: administratorLoginPassword
    sqlServerName: 'postgresql-${uniqueString(deployment().name, location)}'
  }
}
```

### Example 2

Deploy a Postgresql Single Server primary + replica set

```bicep
@secure
param administratorLoginPassword string

module primaryPostgresqlServer 'br/public:storage/postgresql-single-server:1.0' = {
  name: 'primary-server'
  params: {
    location: location
    sqlServerAdministratorLogin: 'testlogin'
    sqlServerAdministratorPassword: administratorLoginPassword
    sqlServerName: 'primary-server-${uniqueString(deployment().name, location)}'
  }
}

module replicaPostgresqlServer 'br/public:storage/postgresql-single-server:1.0' = {
  name: 'replica-server'
  params: {
    location: location
    createMode: 'Replica'
    sourceServerResourceId: primaryPostgresqlServer.outputs.id
    sqlServerAdministratorLogin: 'testlogin'
    sqlServerAdministratorPassword: administratorLoginPassword
    sqlServerName: 'replica-server-${uniqueString(deployment().name, location)}'
  }
}
```

### Example 3

Deploy a Postgresql Single Server with databases, configurations, tags and firewalls

```bicep
@secure
param administratorLoginPassword string

var tags = {
  tag1: 'tag1value'
  tag2: 'tag2value'
}

var databases = [
  {
    name: 'contoso1'
    charset: 'UTF8'
    collation: 'en_US.UTF8'
  }
  {
    name: 'contoso2'
    charset: 'UTF8'
    collation: 'en_US.UTF8'
  }
]

var firewallRules = [
  {
    name: 'AllowAll'
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
]

var sqlServerConfigurations = [
  {
    name: 'backend_flush_after'
    value: '256'
  }
  {
    name: 'backslash_quote'
    value: 'OFF'
  }
  {
    name: 'checkpoint_warning'
    value: '45'
  }
]

module postgresqlSingleServer 'br/public:storage/postgresql-single-server:1.0' = {
  name: 'postgresqlSingleServer'
  params: {
    location: location
    publicNetworkAccess: true
    tags: tags
    sqlServerAdministratorLogin: 'testlogin'
    sqlServerAdministratorPassword: administratorLoginPassword
    sqlServerName: 'postgresql-${uniqueString(deployment().name, location)}'
    databases: databases
    firewallRules: firewallRules
    sqlServerConfigurations: sqlServerConfigurations
  }
}
```