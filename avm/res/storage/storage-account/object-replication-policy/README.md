# Storage Account Object Replication Policy `[Microsoft.Storage/storageAccounts/objectReplicationPolicies]`

This module deploys a Storage Account Object Replication Policy for both the source account and destination account.

You can reference the module as follows:
```bicep
module storageAccount 'br/public:avm/res/storage/storage-account/object-replication-policy:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

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
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
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

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

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

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
