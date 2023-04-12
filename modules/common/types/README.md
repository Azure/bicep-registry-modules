# Common Types for Azure Resources

This module provides common user-defined types for Azure resources based on the Resource Provider specification.

## Description

{{ Add detailed description for the module. }}

## Parameters

| Name | Type | Required | Description |
| :--- | :--: | :------: | :---------- |

## Outputs

| Name | Type | Description |
| :--- | :--: | :---------- |

## Examples

### Example 1

```bicep
import 'br/public:common/types:1.0.1' as types
import types.cosmosdb as resourceTypes

from types.resource import AzurePublicCloudLocations as Location

param location Location
param name resourceTypes.name
param properties resourceTypes.properties

module deployResource 'br/public:storage/cosmos-db:1.0.1' = {
    name: 'DeployCosmosDB-${guid(location, name)}'
    params: {
        location : location
        name: name
        properties: properties
    }
}

output name resourceTypes.name = name
output id resourceTypes.id = deployResource.outputs.id
```

### Example 2

```bicep
import 'br/public:common/types:1.0.1' as types
import types.storage as resourceTypes

from types.resource import AzurePublicCloudLocations as Location

param location Location
param name resourceTypes.name
param properties resourceTypes.properties

module deployResource 'br/public:storage/storage-account:1.0.1' = {
    name: 'DeployStorageAccount-${guid(location, name)}'
    params: {
        location : location
        name: name
        properties: properties
    }
}

output name resourceTypes.name = name
output id resourceTypes.id = deployResource.outputs.id
```

### Example 3

```bicep
import 'br/public:common/types:1.0.1' as types
import types.storage as storageTypes
import types.cosmosdb as cosmosTypes

from types.resource import AzurePublicCloudLocations as Location, ResourceId

param location Location

param storageName storageTypes.name
param storageProperties storageTypes.properties

param cosmosName cosmosTypes.name
param cosmosProperties comosTypes.properties

module deployStorageAccount 'br/public:storage/storage-account:1.0.1' = {
    name: 'DeployStorageAccount-${guid(location, name)}'
    params: {
        location : location
        name: name
        properties: properties
    }
}

module deployNoSQL 'br/public:storage/cosmos-db:1.0.1' = {
    name: 'DeployCosmosDB-${guid(location, name)}'
    params: {
        location : location
        name: name
        properties: properties
    }
}

output storageName storageTypes.name = storageName
output storageId ResourceId = deployStorageAccount.outputs.id

output cosmosName cosmosTypes.name = cosmosName
output cosmosId ResourceId = deployCosmos.outputs.id
```
