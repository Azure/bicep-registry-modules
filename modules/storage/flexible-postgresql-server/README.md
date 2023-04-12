# Azure Flexible PostGres-SQL

This Bicep module creates a PostgreSQL Server with zone-redundancy, virtual network access.

## Description

PostgreSQL is a powerful, open source object-relational database system that is designed to be highly available and scalable.
It is a fully managed service that provides high availability and disaster recovery capabilities for databases.
PostgreSQL is designed to be highly available and scalable, with high availability and disaster recovery capabilities for databases.

This Bicep module allows users to create or use existing PostgreSQL Server with options to control redundancy, access, and security settings. Zone-redundancy allows data to be stored across multiple Availability Zones, increasing availability and durability. Virtual network rules can be used to restrict or allow network traffic to and from the PostgreSQL Server. Encryption and TLS settings can be configured to ensure data security.

The module supports both PostgreSQL 9.6 and 10, allowing users to choose the version that best suits their needs. The output of the module is the ID of the created or existing PostgreSQL Server, which can be used in other Azure resource deployments.

## Parameters

| Name                             | Type           | Required | Description                                                                 |
| :------------------------------- | :------------: | :------: | :-------------------------------------------------------------------------- |
| `location`                       | `string`       | Yes      | The location into which the resources should be deployed                    |
| `name`                           | `string`       | No       | The name of the PostgreSQL server                                           |
| `administratorLogin`             | `string`       | Yes      | Database administrator login name                                           |
| `administratorLoginPassword`     | `securestring` | Yes      | Database administrator password                                             |
| `postgresFlexibleServersSkuTier` | `string`       | No       | The tier of the particular SKU, e.g. Burstable                              |
| `postgresFlexibleServersSkuName` | `string`       | No       | The name of the sku, typically, tier + family + cores, e.g. Standard_D4s_v3 |
| `postgresFlexibleServersversion` | `string`       | No       | The version of a PostgreSQL server                                          |
| `createMode`                     | `string`       | No       | The mode to create a new PostgreSQL server                                  |
| `storageSizeGB`                  | `int`          | No       | The size of the storage in GB                                               |
| `backupRetentionDays`            | `int`          | No       | The number of days a backup is retained                                     |
| `geoRedundantBackup`             | `string`       | No       | The geo-redundant backup setting                                            |
| `highAvailability`               | `string`       | No       | The high availability mode                                                  |

## Outputs

| Name | Type | Description |
| :--- | :--: | :---------- |

## Examples

### Example 1

This example creates a new PostgreSQL Server with a unique name in the East US region using the default PostgreSQL Server configuration settings. The module output is the ID of the created PostgreSQL Server, which can be used in other Azure resource deployments.

```bicep
module postgresqlServer 'br/public:databases/flexible-postgresql:0.0.1' = {
  name: 'mypostgresqlserver'
  params: {
    location: 'eastus'
  }
}

output postgresqlServerID string = postgresqlServer.outputs.id
```

### Example 2

This example creates a new PostgreSQL Server with the name "mypostgresqlserver" in the "myresourcegroup" resource group located in the East US region. The PostgreSQL Server is configured to use zone-redundancy and virtual network access. The module output is the ID of the created or existing PostgreSQL Server, which can be used in other Azure resource deployments.

```bicep
param location string = 'eastus'
param name string = 'mypostgresqlserver'
param newOrExisting string = 'new'
param resourceGroupName string = 'myresourcegroup'
param isZoneRedundant bool = true

module postgresqlServer 'br/public:storage/flexible-postgresql-server:1.0.1' = {
  name: 'mypostgresqlserver'
  params: {
    location: location
    name: name
    newOrExisting: newOrExisting
    resourceGroupName: resourceGroupName
    isZoneRedundant: isZoneRedundant
  }
}

output postgresqlServerID string = postgresqlServer.outputs.id
```