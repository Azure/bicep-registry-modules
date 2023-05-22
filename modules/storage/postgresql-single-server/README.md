# PostgreSQL Single Server

This module deploys PostgreSQL Single Server (Microsoft.DBforPostgreSQL/servers) and optionally available integrations.

## Description

This Bicep module deploys a PostgreSQL Single Server instance in Azure with configurable options such as backup retention, firewall rules, private endpoints, and SSL enforcement.

It also supports role-based access control, storage autogrow, and infrastructure encryption.

## Parameters

| Name                           | Type           | Required | Description                                                                                                                                                                                                                                                                                                                                                                                  |
| :----------------------------- | :------------: | :------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `location`                     | `string`       | No       | Optional.  The location into which your Azure resources should be deployed.                                                                                                                                                                                                                                                                                                                  |
| `prefix`                       | `string`       | No       | Optional. Prefix of postgres resource name. Not used if name is provided.                                                                                                                                                                                                                                                                                                                    |
| `name`                         | `string`       | No       | Optional. The name of the Postgresql DB resources. Character limit: 3-44, valid characters: lowercase letters, numbers, and hyphens. It must me unique across Azure.                                                                                                                                                                                                                         |
| `serverName`                   | `string`       | No       | Optional. Override the name of the server.                                                                                                                                                                                                                                                                                                                                                   |
| `tags`                         | `object`       | No       | Optional. Deployment tags.                                                                                                                                                                                                                                                                                                                                                                   |
| `administratorLogin`           | `string`       | Yes      | Required. The administrator username of the server. Can only be specified when createMode is 'Default'.                                                                                                                                                                                                                                                                                      |
| `administratorLoginPassword`   | `securestring` | Yes      | Required. The administrator login password for the SQL server. Can only be specified when the server is being created.                                                                                                                                                                                                                                                                       |
| `backupRetentionDays`          | `int`          | No       | Optional. The number of days a backup is retained.                                                                                                                                                                                                                                                                                                                                           |
| `createMode`                   | `string`       | No       | Optional. The mode to create a new server.                                                                                                                                                                                                                                                                                                                                                   |
| `databases`                    | `array`        | No       | Optional. List of databases to create on server.                                                                                                                                                                                                                                                                                                                                             |
| `firewallRules`                | `array`        | No       | Optional. List of firewall rules to create on server.                                                                                                                                                                                                                                                                                                                                        |
| `virtualNetworkRules`          | `array`        | No       | Optional. List of virtualNetworkRules to create on postgres server.                                                                                                                                                                                                                                                                                                                          |
| `infrastructureEncryption`     | `string`       | No       | Optional. Status showing whether the server enabled infrastructure encryption.                                                                                                                                                                                                                                                                                                               |
| `minimalTlsVersion`            | `string`       | No       | Optional. Enforce a minimal Tls version for the server.                                                                                                                                                                                                                                                                                                                                      |
| `publicNetworkAccess`          | `string`       | No       | Optional. Whether or not public network access is allowed for this server.                                                                                                                                                                                                                                                                                                                   |
| `version`                      | `string`       | No       | Optional. The version of the PostgreSQL server.                                                                                                                                                                                                                                                                                                                                              |
| `privateEndpoints`             | `array`        | No       | Optional. List of privateEndpoints to create on postgres server.                                                                                                                                                                                                                                                                                                                             |
| `geoRedundantBackup`           | `string`       | No       | Optional. Enable or disable geo-redundant backups. It requires at least a GeneralPurpose or MemoryOptimized skuTier.                                                                                                                                                                                                                                                                         |
| `restorePointInTime`           | `string`       | No       | Optional. Restore point creation time (ISO8601 format), specifying the time to restore from.                                                                                                                                                                                                                                                                                                 |
| `serverConfigurations`         | `array`        | No       | Optional. List of server configurations to create on server.                                                                                                                                                                                                                                                                                                                                 |
| `skuName`                      | `string`       | No       | Optional. The name of the sku, typically, tier + family + cores, e.g. B_Gen4_1, GP_Gen5_8.                                                                                                                                                                                                                                                                                                   |
| `skuCapacity`                  | `int`          | No       | Optional. Azure database for Postgres compute capacity in vCores (2,4,8,16,32)                                                                                                                                                                                                                                                                                                               |
| `SkuSizeMB`                    | `int`          | No       | Optional. Azure database for Postgres Sku Size                                                                                                                                                                                                                                                                                                                                               |
| `SkuTier`                      | `string`       | No       | Optional. Azure database for Postgres pricing tier                                                                                                                                                                                                                                                                                                                                           |
| `skuFamily`                    | `string`       | No       | Optional. Azure database for Postgres sku family                                                                                                                                                                                                                                                                                                                                             |
| `storageSizeGB`                | `int`          | No       | Optional. Storage size for Postgresql Single Server. Expressed in Mebibytes. Cannot be scaled down.                                                                                                                                                                                                                                                                                          |
| `sourceServerResourceId`       | `string`       | No       | Optional. The source server resource id to restore from. It's required when "createMode" is "GeoRestore" or "Replica" or "PointInTimeRestore".                                                                                                                                                                                                                                               |
| `enableStorageAutogrow`        | `bool`         | No       | Optional. Auto grow of storage.                                                                                                                                                                                                                                                                                                                                                              |
| `roleAssignments`              | `array`        | No       | Array of role assignment objects that contain the "roleDefinitionIdOrName" and "principalId" to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, provide either the display name of the role definition, or its fully qualified ID in the following format: "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11" |
| `diagnosticSettingsProperties` | `object`       | No       | Provide postgres diagnostic settings properties.                                                                                                                                                                                                                                                                                                                                             |

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

module postgresqlSingleServer 'br/public:storage/postgresql-single-server:1.1.0' = {
  name: 'postgresqlSingleServer'
  params: {
    prefix: 'postgresql-test01'
    administratorLogin: 'testlogin'
    administratorLoginPassword: administratorLoginPassword
  }
}
```

### Example 2

Deploy a Postgresql Single Server primary + replica set

```bicep
@secure
param administratorLoginPassword string

module primaryPostgresqlServer 'br/public:storage/postgresql-single-server:1.1.0' = {
  name: 'primary-server'
  params: {
    prefix: 'primary-server'
    location: location
    administratorLogin: 'testlogin'
    administratorLoginPassword: administratorLoginPassword
  }
}

module replicaPostgresqlServer 'br/public:storage/postgresql-single-server:1.1.0' = {
  name: 'replica-server'
  dependsOn: [
    primaryPostgresqlServer
  ]
  params: {
    prefix: 'replica-server'
    location: location
    createMode: 'Replica'
    sourceServerResourceId: primaryPostgresqlServer.outputs.id
    administratorLogin: 'testlogin'
    administratorLoginPassword: administratorLoginPassword
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

var serverConfigurations = [
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

module postgresqlSingleServer 'br/public:storage/postgresql-single-server:1.1.0' = {
  name: 'postgresqlSingleServer'
  params: {
    prefix: 'postgresql-test02'
    location: location
    publicNetworkAccess: 'Enabled'
    tags: tags
    administratorLogin: 'testlogin'
    administratorLoginPassword: administratorLoginPassword
    databases: databases
    firewallRules: firewallRules
    serverConfigurations: serverConfigurations
  }
}
```
