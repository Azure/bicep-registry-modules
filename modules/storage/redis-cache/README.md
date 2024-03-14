<h1 style="color: steelblue;">⚠️ Upcoming changes ⚠️</h1>

This module has been replaced by the following equivalent module in Azure Verified Modules (AVM): [avm/res/cache/redis](https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/cache/redis).

For more information, see the informational notice [here](https://github.com/Azure/bicep-registry-modules?tab=readme-ov-file#%EF%B8%8F-upcoming-changes-%EF%B8%8F).

# Azure Cache for Redis

This module deploys Azure Cache for Redis(Microsoft.Cache/redis) and optionally available integrations.

## Details

[Azure Cache for Redis](https://azure.microsoft.com/en-us/pricing/details/cache/)  Azure Cache for Redis gives you the ability to use a secure open source Redis cache. It's a dedicated offering managed by Microsoft, to build highly scalable and responsive applications by providing you super-fast access to your data. You get to leverage the rich feature set and ecosystem provided by Redis

## Parameters

| Name                              | Type     | Required | Description                                                                                                                                                                                                                                                                                                          |
| :-------------------------------- | :------: | :------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `prefix`                          | `string` | No       | Optional. The prefix of the Redis cache resource name.                                                                                                                                                                                                                                                               |
| `name`                            | `string` | No       | Optional. The name of the Redis cache resource.                                                                                                                                                                                                                                                                      |
| `serverName`                      | `string` | No       | Optional. Override the name of the server.                                                                                                                                                                                                                                                                           |
| `location`                        | `string` | Yes      | Required. The location to deploy the Redis cache service.                                                                                                                                                                                                                                                            |
| `tags`                            | `object` | No       | Optional. Tags of the resource.                                                                                                                                                                                                                                                                                      |
| `skuName`                         | `string` | No       | Optional. The type of Redis cache to deploy.                                                                                                                                                                                                                                                                         |
| `enableNonSslPort`                | `bool`   | No       | Optional. Specifies whether the non-ssl Redis server port (6379) is enabled.                                                                                                                                                                                                                                         |
| `minimumTlsVersion`               | `string` | No       | Optional. Requires clients to use a specified TLS version (or higher) to connect.                                                                                                                                                                                                                                    |
| `publicNetworkAccess`             | `string` | No       | Optional. Whether or not public network access is allowed for this resource.                                                                                                                                                                                                                                         |
| `redisConfiguration`              | `object` | No       | Optional. All Redis Settings.                                                                                                                                                                                                                                                                                        |
| `redisVersion`                    | `string` | No       | Optional. Redis version. Only major version will be used in PUT/PATCH request with current valid values: (4, 6).                                                                                                                                                                                                     |
| `capacity`                        | `int`    | No       | Optional. The size of the Redis cache to deploy. Valid values: for C (Basic/Standard) family (0, 1, 2, 3, 4, 5, 6), for P (Premium) family (1, 2, 3, 4).                                                                                                                                                             |
| `shardCount`                      | `int`    | No       | Optional. The number of shards to be created on a Premium Cluster Cache. Set 0 to disable this feature.                                                                                                                                                                                                              |
| `replicasPerMaster`               | `int`    | No       | Optional. Amount of replicas to create per master for this Redis Cache.                                                                                                                                                                                                                                              |
| `replicasPerPrimary`              | `int`    | No       | Optional. Amount of replicas to create per primary for this Redis Cache.                                                                                                                                                                                                                                             |
| `staticIP`                        | `string` | No       | Optional. Static IP address. Optionally, may be specified when deploying a Redis cache inside an existing Azure Virtual Network; auto assigned by default.                                                                                                                                                           |
| `subnetId`                        | `string` | No       | Optional. The full resource ID of a subnet in a virtual network to deploy the Redis cache in. Example format: /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/Microsoft.{Network|ClassicNetwork}/VirtualNetworks/vnet1/subnets/subnet1.                                                           |
| `tenantSettings`                  | `object` | No       | Optional. A dictionary of tenant settings.                                                                                                                                                                                                                                                                           |
| `zoneRedundancyEnabled`           | `bool`   | No       | Should Zone Redundancy be enabled for this Redis Cache? The target Region must support availability zones, therefore even if this is set true, it will only activate zone redudancy in a supported region. Set this false to disable zone redundancy completely, regardless if a region supports availability zones. |
| `numberOfZones`                   | `int`    | No       | The number of logical zones to enable for the Redis Cache. The default is 3. The number must be a positive integer from 1 to 3. Use 1 for single-zoned resources. For multi-zoned resources, the value must be less than or equal to the number of supported zones.                                                  |
| `zoneOffset`                      | `int`    | No       | The offset from the starting logical availability zone. An error will be returned if zoneOffset plus numberOfZones exceeds the number of supported zones in the target Region.                                                                                                                                       |
| `roleAssignments`                 | `array`  | No       | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID                                    |
| `firewallRules`                   | `array`  | No       | Optional. List of firewall rules to create on server.                                                                                                                                                                                                                                                                |
| `privateEndpoints`                | `array`  | No       | Define Private Endpoints that should be created for Azure Redis Cache.                                                                                                                                                                                                                                               |
| `privateEndpointsApprovalEnabled` | `bool`   | No       | Toggle if Private Endpoints manual approval for Azure Redis Cache should be enabled.                                                                                                                                                                                                                                 |
| `redisPatchSchedule`              | `array`  | No       | The predefined schedule for patching redis server. The Patch Window lasts for 5 hours from the start_hour_utc.<br />If schedule is not specified, the update can happen at any time. See https://docs.microsoft.com/en-us/azure/azure-cache-for-redis/cache-administration#schedule-updates-faq                      |
| `diagnosticSettingsProperties`    | `object` | No       | Provide mysql diagnostic settings properties.                                                                                                                                                                                                                                                                        |

## Outputs

| Name                | Type     | Description                                                    |
| :------------------ | :------: | :------------------------------------------------------------- |
| `name`              | `string` | The resource name.                                             |
| `resourceId`        | `string` | The resource ID.                                               |
| `resourceGroupName` | `string` | The name of the resource group the Redis cache was created in. |
| `hostName`          | `string` | Redis hostname.                                                |
| `sslPort`           | `int`    | Redis SSL port.                                                |
| `location`          | `string` | The location the resource was deployed into.                   |

## Examples

### Example 1

```bicep
module redisCache 'br/public:storage/redis-cache:2.0.1' = {
  name: '${uniqueString(deployment().name, 'eastus')}-redis-cache'
  params: {
    location: 'eastus'
    name: 'redis-${uniqueString(resourceGroup().id, location)}'
  }
}
```

### Example 2

```bicep
module redisCache 'br/public:storage/redis-cache:2.0.1' = {
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
