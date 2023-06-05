# Azure Cache for Redis

This module deploys Azure Cache for Redis(Microsoft.Cache/redis) and optionally available integrations.

## Description

[Azure Cache for Redis](https://azure.microsoft.com/en-us/pricing/details/cache/)  Azure Cache for Redis gives you the ability to use a secure open source Redis cache. It's a dedicated offering managed by Microsoft, to build highly scalable and responsive applications by providing you super-fast access to your data. You get to leverage the rich feature set and ecosystem provided by Redis

## Parameters

| Name                                    | Type     | Required | Description                                                                                                                                                                                                                                                                                                                                                                                                          |
| :-------------------------------------- | :------: | :------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `prefix`                                | `string` | No       | Optional. The prefix of the Redis cache resource name.                                                                                                                                                                                                                                                                                                                                                               |
| `name`                                  | `string` | No       | Optional. The name of the Redis cache resource.                                                                                                                                                                                                                                                                                                                                                                      |
| `location`                              | `string` | Yes      | Required. The location to deploy the Redis cache service.                                                                                                                                                                                                                                                                                                                                                            |
| `tags`                                  | `object` | No       | Optional. Tags of the resource.                                                                                                                                                                                                                                                                                                                                                                                      |
| `skuName`                               | `string` | No       | Optional. The type of Redis cache to deploy.                                                                                                                                                                                                                                                                                                                                                                         |
| `enableNonSslPort`                      | `bool`   | No       | Optional. Specifies whether the non-ssl Redis server port (6379) is enabled.                                                                                                                                                                                                                                                                                                                                         |
| `minimumTlsVersion`                     | `string` | No       | Optional. Requires clients to use a specified TLS version (or higher) to connect.                                                                                                                                                                                                                                                                                                                                    |
| `publicNetworkAccess`                   | `string` | No       | Optional. Whether or not public network access is allowed for this resource.                                                                                                                                                                                                                                                                                                                                         |
| `redisConfiguration`                    | `object` | No       | Optional. All Redis Settings. Few possible keys: rdb-backup-enabled,rdb-storage-connection-string,rdb-backup-frequency,maxmemory-delta,maxmemory-policy,notify-keyspace-events,maxmemory-samples,slowlog-log-slower-than,slowlog-max-len,list-max-ziplist-entries,list-max-ziplist-value,hash-max-ziplist-entries,hash-max-ziplist-value,set-max-intset-entries,zset-max-ziplist-entries,zset-max-ziplist-value etc. |
| `redisVersion`                          | `string` | No       | Optional. Redis version. Only major version will be used in PUT/PATCH request with current valid values: (4, 6).                                                                                                                                                                                                                                                                                                     |
| `capacity`                              | `int`    | No       | Optional. The size of the Redis cache to deploy. Valid values: for C (Basic/Standard) family (0, 1, 2, 3, 4, 5, 6), for P (Premium) family (1, 2, 3, 4).                                                                                                                                                                                                                                                             |
| `shardCount`                            | `int`    | No       | Optional. The number of shards to be created on a Premium Cluster Cache.                                                                                                                                                                                                                                                                                                                                             |
| `replicasPerMaster`                     | `int`    | No       | Optional. Amount of replicas to create per master for this Redis Cache.                                                                                                                                                                                                                                                                                                                                              |
| `replicasPerPrimary`                    | `int`    | No       | Optional. Amount of replicas to create per primary for this Redis Cache.                                                                                                                                                                                                                                                                                                                                             |
| `staticIP`                              | `string` | No       | Optional. Static IP address. Optionally, may be specified when deploying a Redis cache inside an existing Azure Virtual Network; auto assigned by default.                                                                                                                                                                                                                                                           |
| `subnetId`                              | `string` | No       | Optional. The full resource ID of a subnet in a virtual network to deploy the Redis cache in. Example format: /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/Microsoft.{Network|ClassicNetwork}/VirtualNetworks/vnet1/subnets/subnet1.                                                                                                                                                           |
| `tenantSettings`                        | `object` | No       | Optional. A dictionary of tenant settings.                                                                                                                                                                                                                                                                                                                                                                           |
| `diagnosticLogsRetentionInDays`         | `int`    | No       | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.                                                                                                                                                                                                                                                                                                                 |
| `diagnosticStorageAccountId`            | `string` | No       | Resource ID of the diagnostic storage account.                                                                                                                                                                                                                                                                                                                                                                       |
| `diagnosticWorkspaceId`                 | `string` | No       | Resource ID of the diagnostic log analytics workspace.                                                                                                                                                                                                                                                                                                                                                               |
| `diagnosticEventHubAuthorizationRuleId` | `string` | No       | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.                                                                                                                                                                                                                                                                     |
| `diagnosticEventHubName`                | `string` | No       | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.                                                                                                                                                                                                                                                                       |
| `logsToEnable`                          | `array`  | No       | The name of logs that will be streamed.                                                                                                                                                                                                                                                                                                                                                                              |
| `metricsToEnable`                       | `array`  | No       | The name of metrics that will be streamed.                                                                                                                                                                                                                                                                                                                                                                           |
| `roleAssignments`                       | `array`  | No       | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID                                                                                                                                    |
| `redisFirewallRules`                    | `object` | No       | Optional.  Firewall rule for the redis cache                                                                                                                                                                                                                                                                                                                                                                         |
| `privateEndpoints`                      | `array`  | No       | Define Private Endpoints that should be created for Azure Redis Cache.                                                                                                                                                                                                                                                                                                                                               |
| `privateEndpointsApprovalEnabled`       | `bool`   | No       | Toggle if Private Endpoints manual approval for Azure Redis Cache should be enabled.                                                                                                                                                                                                                                                                                                                                 |

## Outputs

| Name              | Type   | Description                                                    |
| :---------------- | :----: | :------------------------------------------------------------- |
| name              | string | The resource name.                                             |
| resourceId        | string | The resource ID.                                               |
| resourceGroupName | string | The name of the resource group the Redis cache was created in. |
| hostName          | string | Redis hostname.                                                |
| sslPort           | int    | Redis SSL port.                                                |
| location          | string | The location the resource was deployed into.                   |

## Examples

### Example 1

```bicep
module redisCache 'br/public:data/redis-cache:1.0.0' = {
  name: '${uniqueString(deployment().name, 'eastus')}-redis-cache'
  params: {
    location: 'eastus'
    name: 'redis-${uniqueString(resourceGroup().id, location)}'
  }
}
```

### Example 2

```
module redisCache 'br/public:data/redis-cache:1.0.0' = {
  name: '${uniqueString(deployment().name, 'eastus')}-redis-cache'
  params: {
    location: 'eastus'
    name: 'redis-${uniqueString(resourceGroup().id, location)}'
    skuName: 'Premium'
    capacity: 1
    privateEndpoints: [
      {
        name: 'endpoint1'
        subnetId: subnetId
        privateDnsZoneId: privateDnsZoneId
      }
    ]
  }
}
```