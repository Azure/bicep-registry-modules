# Container Registries Tasks `[Microsoft.ContainerRegistry/registries/tasks]`

This module deploys an Azure Container Registry (ACR) Task that can be used to automate container image builds and other workflows ([ref](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-tasks-overview)).

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

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dockerBuild`](#parameter-stepdockerbuild) | object | The Docker build step properties. |
| [`encodedTask`](#parameter-stepencodedtask) | object | The encoded task step properties. |
| [`fileTask`](#parameter-stepfiletask) | object | The file task step properties. |

### Parameter: `step.dockerBuild`

The Docker build step properties.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dockerFilePath`](#parameter-stepdockerbuilddockerfilepath) | string | The Docker file path relative to the source context. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`arguments`](#parameter-stepdockerbuildarguments) | array | The collection of override arguments to be used when executing this build step. |
| [`contextAccessToken`](#parameter-stepdockerbuildcontextaccesstoken) | securestring | The token (git PAT or SAS token of storage account blob) associated with the context. |
| [`contextPath`](#parameter-stepdockerbuildcontextpath) | string | The URL (absolute or relative) of the source context for the task step. |
| [`imageNames`](#parameter-stepdockerbuildimagenames) | array | The fully qualified image names including the repository and tag. |
| [`isPushEnabled`](#parameter-stepdockerbuildispushenabled) | bool | The value of this property indicates whether the image built should be pushed to the registry or not. |
| [`noCache`](#parameter-stepdockerbuildnocache) | bool | The value of this property indicates whether the image cache is enabled or not. |
| [`target`](#parameter-stepdockerbuildtarget) | string | The name of the target build stage for the docker build. |

### Parameter: `step.dockerBuild.dockerFilePath`

The Docker file path relative to the source context.

- Required: Yes
- Type: string

### Parameter: `step.dockerBuild.arguments`

The collection of override arguments to be used when executing this build step.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-stepdockerbuildargumentsname) | string | The name of the argument. |
| [`value`](#parameter-stepdockerbuildargumentsvalue) | string | The value of the argument. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`isSecret`](#parameter-stepdockerbuildargumentsissecret) | bool | Flag to indicate whether the argument represents a secret and want to be removed from build logs. |

### Parameter: `step.dockerBuild.arguments.name`

The name of the argument.

- Required: Yes
- Type: string

### Parameter: `step.dockerBuild.arguments.value`

The value of the argument.

- Required: Yes
- Type: string

### Parameter: `step.dockerBuild.arguments.isSecret`

Flag to indicate whether the argument represents a secret and want to be removed from build logs.

- Required: No
- Type: bool

### Parameter: `step.dockerBuild.contextAccessToken`

The token (git PAT or SAS token of storage account blob) associated with the context.

- Required: No
- Type: securestring

### Parameter: `step.dockerBuild.contextPath`

The URL (absolute or relative) of the source context for the task step.

- Required: No
- Type: string

### Parameter: `step.dockerBuild.imageNames`

The fully qualified image names including the repository and tag.

- Required: No
- Type: array

### Parameter: `step.dockerBuild.isPushEnabled`

The value of this property indicates whether the image built should be pushed to the registry or not.

- Required: No
- Type: bool

### Parameter: `step.dockerBuild.noCache`

The value of this property indicates whether the image cache is enabled or not.

- Required: No
- Type: bool

### Parameter: `step.dockerBuild.target`

The name of the target build stage for the docker build.

- Required: No
- Type: string

### Parameter: `step.encodedTask`

The encoded task step properties.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`encodedTaskContent`](#parameter-stepencodedtaskencodedtaskcontent) | string | Base64 encoded value of the template/definition file content. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`contextAccessToken`](#parameter-stepencodedtaskcontextaccesstoken) | securestring | The token (git PAT or SAS token of storage account blob) associated with the context. |
| [`contextPath`](#parameter-stepencodedtaskcontextpath) | string | The URL (absolute or relative) of the source context for the task step. |
| [`encodedValuesContent`](#parameter-stepencodedtaskencodedvaluescontent) | string | Base64 encoded value of the parameters/values file content. |
| [`values`](#parameter-stepencodedtaskvalues) | array | The collection of overridable values that can be passed when running a task. |

### Parameter: `step.encodedTask.encodedTaskContent`

Base64 encoded value of the template/definition file content.

- Required: Yes
- Type: string

### Parameter: `step.encodedTask.contextAccessToken`

The token (git PAT or SAS token of storage account blob) associated with the context.

- Required: No
- Type: securestring

### Parameter: `step.encodedTask.contextPath`

The URL (absolute or relative) of the source context for the task step.

- Required: No
- Type: string

### Parameter: `step.encodedTask.encodedValuesContent`

Base64 encoded value of the parameters/values file content.

- Required: No
- Type: string

### Parameter: `step.encodedTask.values`

The collection of overridable values that can be passed when running a task.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-stepencodedtaskvaluesname) | string | The name of the overridable value. |
| [`value`](#parameter-stepencodedtaskvaluesvalue) | string | The overridable value. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`isSecret`](#parameter-stepencodedtaskvaluesissecret) | bool | Flag to indicate whether the value represents a secret or not. |

### Parameter: `step.encodedTask.values.name`

The name of the overridable value.

- Required: Yes
- Type: string

### Parameter: `step.encodedTask.values.value`

The overridable value.

- Required: Yes
- Type: string

### Parameter: `step.encodedTask.values.isSecret`

Flag to indicate whether the value represents a secret or not.

- Required: No
- Type: bool

### Parameter: `step.fileTask`

The file task step properties.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`taskFilePath`](#parameter-stepfiletasktaskfilepath) | string | The task template/definition file path relative to the source context. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`contextAccessToken`](#parameter-stepfiletaskcontextaccesstoken) | securestring | The token (git PAT or SAS token of storage account blob) associated with the context. |
| [`contextPath`](#parameter-stepfiletaskcontextpath) | string | The URL (absolute or relative) of the source context for the task step. |
| [`values`](#parameter-stepfiletaskvalues) | array | The collection of overridable values that can be passed when running a task. |
| [`valuesFilePath`](#parameter-stepfiletaskvaluesfilepath) | string | The task values/parameters file path relative to the source context. |

### Parameter: `step.fileTask.taskFilePath`

The task template/definition file path relative to the source context.

- Required: Yes
- Type: string

### Parameter: `step.fileTask.contextAccessToken`

The token (git PAT or SAS token of storage account blob) associated with the context.

- Required: No
- Type: securestring

### Parameter: `step.fileTask.contextPath`

The URL (absolute or relative) of the source context for the task step.

- Required: No
- Type: string

### Parameter: `step.fileTask.values`

The collection of overridable values that can be passed when running a task.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-stepfiletaskvaluesname) | string | The name of the overridable value. |
| [`value`](#parameter-stepfiletaskvaluesvalue) | string | The overridable value. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`isSecret`](#parameter-stepfiletaskvaluesissecret) | bool | Flag to indicate whether the value represents a secret or not. |

### Parameter: `step.fileTask.values.name`

The name of the overridable value.

- Required: Yes
- Type: string

### Parameter: `step.fileTask.values.value`

The overridable value.

- Required: Yes
- Type: string

### Parameter: `step.fileTask.values.isSecret`

Flag to indicate whether the value represents a secret or not.

- Required: No
- Type: bool

### Parameter: `step.fileTask.valuesFilePath`

The task values/parameters file path relative to the source context.

- Required: No
- Type: string

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

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`baseImageTrigger`](#parameter-triggerbaseimagetrigger) | object | The trigger based on base image dependencies. |
| [`sourceTriggers`](#parameter-triggersourcetriggers) | array | The collection of triggers based on source code repository. |
| [`timerTriggers`](#parameter-triggertimertriggers) | array | The collection of timer triggers. |

### Parameter: `trigger.baseImageTrigger`

The trigger based on base image dependencies.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`baseImageTriggerType`](#parameter-triggerbaseimagetriggerbaseimagetriggertype) | string | The type of the auto trigger for base image dependency updates. |
| [`name`](#parameter-triggerbaseimagetriggername) | string | The name of the trigger. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`status`](#parameter-triggerbaseimagetriggerstatus) | string | The current status of trigger. |

### Parameter: `trigger.baseImageTrigger.baseImageTriggerType`

The type of the auto trigger for base image dependency updates.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'All'
    'Runtime'
  ]
  ```

### Parameter: `trigger.baseImageTrigger.name`

The name of the trigger.

- Required: Yes
- Type: string

### Parameter: `trigger.baseImageTrigger.status`

The current status of trigger.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `trigger.sourceTriggers`

The collection of triggers based on source code repository.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-triggersourcetriggersname) | string | The name of the trigger. |
| [`sourceRepository`](#parameter-triggersourcetriggerssourcerepository) | object | The properties that describe the source (code) for the task. |
| [`sourceTriggerEvents`](#parameter-triggersourcetriggerssourcetriggerevents) | array | The source event corresponding to the trigger. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`status`](#parameter-triggersourcetriggersstatus) | string | The current status of trigger. |

### Parameter: `trigger.sourceTriggers.name`

The name of the trigger.

- Required: Yes
- Type: string

### Parameter: `trigger.sourceTriggers.sourceRepository`

The properties that describe the source (code) for the task.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`repositoryUrl`](#parameter-triggersourcetriggerssourcerepositoryrepositoryurl) | string | The full URL to the source code repository. |
| [`sourceControlType`](#parameter-triggersourcetriggerssourcerepositorysourcecontroltype) | string | The type of source control service. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`branch`](#parameter-triggersourcetriggerssourcerepositorybranch) | string | The branch name of the source code. |
| [`sourceControlAuthProperties`](#parameter-triggersourcetriggerssourcerepositorysourcecontrolauthproperties) | object | The authorization properties for accessing the source code repository. |

### Parameter: `trigger.sourceTriggers.sourceRepository.repositoryUrl`

The full URL to the source code repository.

- Required: Yes
- Type: string

### Parameter: `trigger.sourceTriggers.sourceRepository.sourceControlType`

The type of source control service.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Github'
    'VisualStudioTeamService'
  ]
  ```

### Parameter: `trigger.sourceTriggers.sourceRepository.branch`

The branch name of the source code.

- Required: No
- Type: string

### Parameter: `trigger.sourceTriggers.sourceRepository.sourceControlAuthProperties`

The authorization properties for accessing the source code repository.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`token`](#parameter-triggersourcetriggerssourcerepositorysourcecontrolauthpropertiestoken) | securestring | The access token used to access the source control provider. |
| [`tokenType`](#parameter-triggersourcetriggerssourcerepositorysourcecontrolauthpropertiestokentype) | string | The type of Auth token. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`expiresIn`](#parameter-triggersourcetriggerssourcerepositorysourcecontrolauthpropertiesexpiresin) | int | Time in seconds that the token remains valid. |
| [`refreshToken`](#parameter-triggersourcetriggerssourcerepositorysourcecontrolauthpropertiesrefreshtoken) | securestring | The refresh token used to refresh the access token. |
| [`scope`](#parameter-triggersourcetriggerssourcerepositorysourcecontrolauthpropertiesscope) | string | The scope of the access token. |

### Parameter: `trigger.sourceTriggers.sourceRepository.sourceControlAuthProperties.token`

The access token used to access the source control provider.

- Required: Yes
- Type: securestring

### Parameter: `trigger.sourceTriggers.sourceRepository.sourceControlAuthProperties.tokenType`

The type of Auth token.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'OAuth'
    'PAT'
  ]
  ```

### Parameter: `trigger.sourceTriggers.sourceRepository.sourceControlAuthProperties.expiresIn`

Time in seconds that the token remains valid.

- Required: No
- Type: int

### Parameter: `trigger.sourceTriggers.sourceRepository.sourceControlAuthProperties.refreshToken`

The refresh token used to refresh the access token.

- Required: No
- Type: securestring

### Parameter: `trigger.sourceTriggers.sourceRepository.sourceControlAuthProperties.scope`

The scope of the access token.

- Required: No
- Type: string

### Parameter: `trigger.sourceTriggers.sourceTriggerEvents`

The source event corresponding to the trigger.

- Required: Yes
- Type: array
- Allowed:
  ```Bicep
  [
    'commit'
    'pullrequest'
  ]
  ```

### Parameter: `trigger.sourceTriggers.status`

The current status of trigger.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `trigger.timerTriggers`

The collection of timer triggers.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-triggertimertriggersname) | string | The name of the trigger. |
| [`schedule`](#parameter-triggertimertriggersschedule) | string | The CRON expression for the task schedule. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`status`](#parameter-triggertimertriggersstatus) | string | The current status of trigger. |

### Parameter: `trigger.timerTriggers.name`

The name of the trigger.

- Required: Yes
- Type: string

### Parameter: `trigger.timerTriggers.schedule`

The CRON expression for the task schedule.

- Required: Yes
- Type: string

### Parameter: `trigger.timerTriggers.status`

The current status of trigger.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

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
