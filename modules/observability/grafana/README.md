# Azure Managed Grafana

Azure Managed Grafana is a data visualization platform built on top of the Grafana software by Grafana Labs.

## Description

Azure Managed Grafana is a data visualization platform built on top of the Grafana software by Grafana Labs. It’s built as a fully managed Azure service operated and supported by Microsoft. Grafana helps you bring together metrics, logs and traces into a single user interface. With its extensive support for data sources and graphing capabilities, you can view and analyze your application and infrastructure telemetry data in real-time. Azure Managed Grafana is optimized for the Azure environment.
(Overview)[https://learn.microsoft.com/en-us/azure/managed-grafana/overview]

> Note: Make sure  'Microsoft.Monitor' and 'Micrsoft.Dashboard' namespaces to be registered manually for the subscription

## Parameters

| Name                                    | Type     | Required | Description                                                                                                                                                                                                                                                                                                                                                                                          |
| :-------------------------------------- | :------: | :------: | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `location`                              | `string` | Yes      | The geo-location where the grafana resource lives.                                                                                                                                                                                                                                                                                                                                                   |
| `prefix`                                | `string` | No       | Prefix of Grafana Resource Name                                                                                                                                                                                                                                                                                                                                                                      |
| `name`                                  | `string` | No       | The grafana resource name.                                                                                                                                                                                                                                                                                                                                                                           |
| `tags`                                  | `object` | No       | The tags for grafana resource.                                                                                                                                                                                                                                                                                                                                                                       |
| `resourceSku`                           | `string` | No       | The Sku of the grafana resource.                                                                                                                                                                                                                                                                                                                                                                     |
| `apiKey`                                | `string` | No       | The api key setting of the Grafana instance. Default value is Disabled.                                                                                                                                                                                                                                                                                                                              |
| `deterministicOutboundIP`               | `string` | No       | Whether a Grafana instance uses deterministic outbound IPs. Default value is Disabled.                                                                                                                                                                                                                                                                                                               |
| `publicNetworkAccess`                   | `string` | No       | Indicate the state for enable or disable traffic over the public interface. Default value is Disabled.                                                                                                                                                                                                                                                                                               |
| `zoneRedundancy`                        | `string` | No       | The zone redundancy setting of the Grafana instance. Default value is Disabled.                                                                                                                                                                                                                                                                                                                      |
| `azureMonitorWorkspaceResourceId`       | `string` | No       | The resource Id of the connected Azure Monitor Workspace.                                                                                                                                                                                                                                                                                                                                            |
| `managedServiceIdentityType`            | `string` | No       | The managed service identity type of the Grafana instance. Default value is None.                                                                                                                                                                                                                                                                                                                    |
| `userAssignedIdentities`                | `object` | No       | The user assigned identity resource Ids of the Grafana instance.                                                                                                                                                                                                                                                                                                                                     |
| `enableDiagnostics`                     | `bool`   | No       | Enable Diagnostic Capture . default is false                                                                                                                                                                                                                                                                                                                                                         |
| `diagnosticLogsRetentionInDays`         | `int`    | No       | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. default is 365.                                                                                                                                                                                                                                                                                 |
| `diagnosticStorageAccountId`            | `string` | No       | Resource ID of the diagnostic storage account.                                                                                                                                                                                                                                                                                                                                                       |
| `diagnosticWorkspaceId`                 | `string` | No       | Resource ID of the diagnostic log analytics workspace.                                                                                                                                                                                                                                                                                                                                               |
| `diagnosticEventHubAuthorizationRuleId` | `string` | No       | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.                                                                                                                                                                                                                                                     |
| `diagnosticEventHubName`                | `string` | No       | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.                                                                                                                                                                                                                                                       |
| `logsToEnable`                          | `string` | No       | The name of logs that will be streamed. default is allLogs.                                                                                                                                                                                                                                                                                                                                          |
| `roleAssignments`                       | `array`  | No       | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `privateEndpoints`                      | `array`  | No       | Define Private Endpoints that should be created for Grafana.                                                                                                                                                                                                                                                                                                                                         |
| `privateEndpointsApprovalEnabled`       | `bool`   | No       | Toggle if Private Endpoints manual approval for Grafana should be enabled.                                                                                                                                                                                                                                                                                                                           |

## Outputs

| Name | Type   | Description           |
| :--- | :----: | :-------------------- |
| id   | string | Grafana resouce id    |
| name | string | Grafana resource name |

## Examples

### Example 1

```bicep
module test0 'br/public:observability/grafana:1.0.1' = {
  name: 'test0-${uniqueString(resourceGroup().id)}'
  params: {
    name: take('test0-${name}', 23)
    tags: {
      env: 'test'
    }
    location: location
  }
}
```

### Example 2

```bicep
module test1 'br/public:observability/grafana:1.0.1' = {
  name: 'test1-${uniqueString(resourceGroup().id)}'
  params: {
    name: take('test1-${name}', 23)
    location: location
    tags: {
      env: 'test'
    }
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Grafana Admin'
        principalIds: [ prereq.outputs.identityPrincipalIds[0] ]
      }
    ]
    azureMonitorWorkspaceResourceId: prereq.outputs.monitorId
    zoneRedundancy: 'Enabled'
    privateEndpoints: [
      {
        name: 'endpoint1'
        subnetId: prereq.outputs.subnetIds[0]
      }
      {
        name: 'endpoint2'
        subnetId: prereq.outputs.subnetIds[1]
        privateDnsZoneId: prereq.outputs.privateDNSZoneId
      }
    ]
    enableDiagnostics: true
    diagnosticWorkspaceId: prereq.outputs.workspaceId
  }
}
```