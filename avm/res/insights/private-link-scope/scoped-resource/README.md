# Private Link Scope Scoped Resources `[Microsoft.Insights/privateLinkScopes/scopedResources]`

This module deploys a Private Link Scope Scoped Resource.

You can reference the module as follows:
```bicep
module privateLinkScope 'br/public:avm/res/insights/private-link-scope/scoped-resource:<version>' = {
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
| `Microsoft.Insights/privateLinkScopes/scopedResources` | 2021-07-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_privatelinkscopes_scopedresources.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-07-01-preview/privateLinkScopes/scopedResources)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`linkedResourceId`](#parameter-linkedresourceid) | string | The resource ID of the scoped Azure monitor resource. |
| [`name`](#parameter-name) | string | Name of the private link scoped resource. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateLinkScopeName`](#parameter-privatelinkscopename) | string | The name of the parent private link scope. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |

### Parameter: `linkedResourceId`

The resource ID of the scoped Azure monitor resource.

- Required: Yes
- Type: string

### Parameter: `name`

Name of the private link scoped resource.

- Required: Yes
- Type: string

### Parameter: `privateLinkScopeName`

The name of the parent private link scope. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The full name of the deployed Scoped Resource. |
| `resourceGroupName` | string | The name of the resource group where the resource has been deployed. |
| `resourceId` | string | The resource ID of the deployed scopedResource. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
