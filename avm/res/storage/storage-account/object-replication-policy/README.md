# Storage Account Object Replication Policy `[Microsoft.Storage/storageAccounts/objectReplicationPolicies]`

This module deploys a Storage Account Object Replication Policy for both the source account and destination account.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Storage/storageAccounts/objectReplicationPolicies` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_objectreplicationpolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-01-01/storageAccounts/objectReplicationPolicies)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`destinationAccountResourceId`](#parameter-destinationaccountresourceid) | string | Resource ID of the destination storage account for replication. |
| [`rules`](#parameter-rules) | array | Rules for the object replication policy. |
| [`storageAccountName`](#parameter-storageaccountname) | string | The name of the parent Storage Account. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableMetrics`](#parameter-enablemetrics) | bool | Whether metrics are enabled for the object replication policy. |
| [`name`](#parameter-name) | string | Name of the policy. |

### Parameter: `destinationAccountResourceId`

Resource ID of the destination storage account for replication.

- Required: Yes
- Type: string

### Parameter: `rules`

Rules for the object replication policy.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`containerName`](#parameter-rulescontainername) | string | The name of the source container. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`destinationContainerName`](#parameter-rulesdestinationcontainername) | string | The name of the destination container. If not provided, the same name as the source container will be used. |
| [`filters`](#parameter-rulesfilters) | object | The filters for the object replication policy rule. |
| [`ruleId`](#parameter-rulesruleid) | string | The ID of the rule. Auto-generated on destination account. Required for source account. |

### Parameter: `rules.containerName`

The name of the source container.

- Required: Yes
- Type: string

### Parameter: `rules.destinationContainerName`

The name of the destination container. If not provided, the same name as the source container will be used.

- Required: No
- Type: string

### Parameter: `rules.filters`

The filters for the object replication policy rule.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`minCreationTime`](#parameter-rulesfiltersmincreationtime) | string | The minimum creation time to match for the replication policy rule. |
| [`prefixMatch`](#parameter-rulesfiltersprefixmatch) | array | The prefix to match for the replication policy rule. |

### Parameter: `rules.filters.minCreationTime`

The minimum creation time to match for the replication policy rule.

- Required: No
- Type: string

### Parameter: `rules.filters.prefixMatch`

The prefix to match for the replication policy rule.

- Required: No
- Type: array

### Parameter: `rules.ruleId`

The ID of the rule. Auto-generated on destination account. Required for source account.

- Required: No
- Type: string

### Parameter: `storageAccountName`

The name of the parent Storage Account.

- Required: Yes
- Type: string

### Parameter: `enableMetrics`

Whether metrics are enabled for the object replication policy.

- Required: No
- Type: bool

### Parameter: `name`

Name of the policy.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `objectReplicationPolicyId` | string | Resource ID of the created Object Replication Policy in the source account. |
| `policyId` | string | Policy ID of the created Object Replication Policy in the source account. |
| `resourceGroupName` | string | Resource group name of the provisioned resources. |
