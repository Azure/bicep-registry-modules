# DocumentDB Mongo Clusters Config FireWall Rules `[Microsoft.DocumentDB/mongoClusters]`

This module config firewall rules for DocumentDB Mongo Cluster.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DocumentDB/mongoClusters/firewallRules` | [2024-02-15-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-02-15-preview/mongoClusters/firewallRules) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`mongoClusterName`](#parameter-mongoclustername) | string | Name of the Mongo Cluster. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowAllIPsFirewall`](#parameter-allowallipsfirewall) | bool | Whether to allow all IPs or not. Warning: No IP addresses will be blocked and any host on the Internet can access the coordinator in this server group. It is strongly recommended to use this rule only temporarily and only on test clusters that do not contain sensitive data. |
| [`allowAzureIPsFirewall`](#parameter-allowazureipsfirewall) | bool | Whether to allow Azure internal IPs or not. |
| [`allowedSingleIPs`](#parameter-allowedsingleips) | array | IP addresses to allow access to the cluster from. |

### Parameter: `mongoClusterName`

Name of the Mongo Cluster.

- Required: Yes
- Type: string

### Parameter: `allowAllIPsFirewall`

Whether to allow all IPs or not. Warning: No IP addresses will be blocked and any host on the Internet can access the coordinator in this server group. It is strongly recommended to use this rule only temporarily and only on test clusters that do not contain sensitive data.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `allowAzureIPsFirewall`

Whether to allow Azure internal IPs or not.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `allowedSingleIPs`

IP addresses to allow access to the cluster from.

- Required: No
- Type: array
- Default: `[]`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `resourceGroupName` | string | The name of the resource group the mongo cluster was created in. |
