# Container Registries Tasks `[Microsoft.ContainerRegistry/registries/tasks]`

Deploys an Azure Container Registry (ACR) Task that can be used to automate container image builds and other workflows ([ref](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-tasks-overview)).

You can reference the module as follows:
```bicep
module registry 'br/public:avm/res/container-registry/registry/task:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.ContainerRegistry/registries/tasks` | 2025-03-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerregistry_registries_tasks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2025-03-01-preview/registries/tasks)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the task. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`registryName`](#parameter-registryname) | string | The name of the parent registry. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`agentConfiguration`](#parameter-agentconfiguration) | object | The machine configuration of the run agent. |
| [`agentPoolName`](#parameter-agentpoolname) | string | The dedicated agent pool for the task. |
| [`credentials`](#parameter-credentials) | object | The properties that describe the credentials that will be used when the task is invoked. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`isSystemTask`](#parameter-issystemtask) | bool | The value of this property indicates whether the task resource is system task or not. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`logTemplate`](#parameter-logtemplate) | string | The template that describes the repository and tag information for run log artifact. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`platform`](#parameter-platform) | object | The platform properties against which the task has to run. |
| [`status`](#parameter-status) | string | The current status of task. |
| [`step`](#parameter-step) | object | The task step properties. Exactly one of dockerBuildStep, encodedTaskStep, or fileTaskStep must be provided. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`timeout`](#parameter-timeout) | int | Run timeout in seconds. |
| [`trigger`](#parameter-trigger) | object | The properties that describe all triggers for the task. |

### Parameter: `name`

The name of the task.

- Required: Yes
- Type: string

### Parameter: `registryName`

The name of the parent registry. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `agentConfiguration`

The machine configuration of the run agent.

- Required: No
- Type: object

### Parameter: `agentPoolName`

The dedicated agent pool for the task.

- Required: No
- Type: string

### Parameter: `credentials`

The properties that describe the credentials that will be used when the task is invoked.

- Required: No
- Type: object

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `isSystemTask`

The value of this property indicates whether the task resource is system task or not.

- Required: No
- Type: bool

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `logTemplate`

The template that describes the repository and tag information for run log artifact.

- Required: No
- Type: string

### Parameter: `managedIdentities`

The managed identity definition for this resource.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`systemAssigned`](#parameter-managedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. |
| [`userAssignedResourceIds`](#parameter-managedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption. |

### Parameter: `managedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption.

- Required: No
- Type: array

### Parameter: `platform`

The platform properties against which the task has to run.

- Required: No
- Type: object

### Parameter: `status`

The current status of task.

- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `step`

The task step properties. Exactly one of dockerBuildStep, encodedTaskStep, or fileTaskStep must be provided.

- Required: No
- Type: object

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `timeout`

Run timeout in seconds.

- Required: No
- Type: int
- Default: `3600`
- MinValue: 300
- MaxValue: 28800

### Parameter: `trigger`

The properties that describe all triggers for the task.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the task. |
| `resourceGroupName` | string | The name of the resource group the task was deployed into. |
| `resourceId` | string | The resource ID of the task. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.7.0` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
