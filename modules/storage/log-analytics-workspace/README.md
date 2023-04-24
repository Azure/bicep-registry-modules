# Log Analytics Workspace

This module deploys Log Analytics workspace and optionally available integrations.

## Description

[Log Analytics Workspace](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/quick-create-workspace) is a unique environment for log data from Azure Monitor and other Azure services. Log Analytics uses a powerful query language, to give you insights into the operation of your applications and resources. Each workspace has its own data repository and configuration but might combine data from multiple services. We can use a single workspace for all your data collection or create multiple workspaces based on your requirements. [Quickstart: Setup Log Analytics Workspace](https://learn.microsoft.com/en-us/azure/spring-apps/quickstart-setup-log-analytics)

## Parameters

| Name                              | Type     | Required | Description                                                                         |
| :---------------------------------| :------: | :------: | :---------------------------------------------------------------------------------- |
| `name`                            | `string` | Yes      | Name of the Log Analytics Workspace.                                                |
| `location`                        | `string` | Yes      | Define the Azure Location that the Log Analytics Workspace should be created within.|
| `tags`                            | `object` | No       | Tags for Log Analytics Workspace.                                                   |
| `skuName`                         | `string` | No       | sku of Log Analytics Workspace.                                                     |
| `retentionInDays`                 | `int`    | No       | The workspace data retention in days.                                               |
| `publicNetworkAccessForIngestion` | `string` | No       | The network access type for operating on the Log Analytics Workspace.               |
| `publicNetworkAccessForQuery`     | `string` | No       | The network access type for operating on the Log Analytics Workspace.               |
| `dailyQuotaGb`                    | `int`    | No       | The workspace daily quota for ingestion.                                            |
| `forceCmkForQuery`                | `bool`   | No       | Indicates whether customer managed storage is mandatory for query management.       |


## Outputs

| Name | Type   | Description                             |
| :--- | :----: | :-------------------------------------- |
| id   | string | Id of the Log Analytics Workspace.      |
| name | string | Name of the Log Analytics Workspace.    |

## Examples

### Example 1

```bicep
param name string = 'my-logAnalyticsWorkspace-01'
param location = 'eastus'

module logAnalyticsWorkspace 'br/public:storage/log-analytics-workspace:1.0.1' = {
  name: 'my-logAnalyticsWorkspace-01'
  params: {
    name: name
    location: location
  }
}
```