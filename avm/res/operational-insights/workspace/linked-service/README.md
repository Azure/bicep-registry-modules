# Log Analytics Workspace Linked Services `[Microsoft.OperationalInsights/workspaces/linkedServices]`

This module deploys a Log Analytics Workspace Linked Service.

You can reference the module as follows:
```bicep
module workspace 'br/public:avm/res/operational-insights/workspace/linked-service:<version>' = {
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
| `Microsoft.OperationalInsights/workspaces/linkedServices` | 2025-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationalinsights_workspaces_linkedservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2025-07-01/workspaces/linkedServices)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the link. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`logAnalyticsWorkspaceName`](#parameter-loganalyticsworkspacename) | string | The name of the parent Log Analytics workspace. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`resourceId`](#parameter-resourceid) | string | The resource ID of the resource that will be linked to the workspace. This should be used for linking resources which require read access. |
| [`tags`](#parameter-tags) | object | Tags to configure in the resource. |
| [`writeAccessResourceId`](#parameter-writeaccessresourceid) | string | The resource ID of the resource that will be linked to the workspace. This should be used for linking resources which require write access. |

### Parameter: `name`

Name of the link.

- Required: Yes
- Type: string

### Parameter: `logAnalyticsWorkspaceName`

The name of the parent Log Analytics workspace. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `resourceId`

The resource ID of the resource that will be linked to the workspace. This should be used for linking resources which require read access.

- Required: No
- Type: string

### Parameter: `tags`

Tags to configure in the resource.

- Required: No
- Type: object

### Parameter: `writeAccessResourceId`

The resource ID of the resource that will be linked to the workspace. This should be used for linking resources which require write access.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed linked service. |
| `resourceGroupName` | string | The resource group where the linked service is deployed. |
| `resourceId` | string | The resource ID of the deployed linked service. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
