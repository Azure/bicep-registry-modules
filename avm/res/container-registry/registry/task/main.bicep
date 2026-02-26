metadata name = 'Container Registries Tasks'
metadata description = 'This module deploys an Azure Container Registry (ACR) Task that can be used to automate container image builds and other workflows ([ref](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-tasks-overview)).'

@description('Conditional. The name of the parent registry. Required if the template is used in a standalone deployment.')
param registryName string

@description('Required. The name of the task.')
@minLength(5)
@maxLength(50)
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. The platform properties against which the task has to run.')
param platform platformType?

@description('Optional. The task step properties. Exactly one of dockerBuildStep, encodedTaskStep, or fileTaskStep must be provided.')
param step taskStepType?

@description('Optional. The properties that describe all triggers for the task.')
param trigger triggerType?

@allowed([
  'Disabled'
  'Enabled'
])
@description('Optional. The current status of task.')
param status string = 'Enabled'

@description('Optional. Run timeout in seconds.')
@minValue(300)
@maxValue(28800)
param timeout int = 3600

@description('Optional. The machine configuration of the run agent.')
param agentConfiguration agentPropertiesType?

@description('Optional. The dedicated agent pool for the task.')
param agentPoolName string?

@description('Optional. The properties that describe the credentials that will be used when the task is invoked.')
param credentials credentialsType?

@description('Optional. The value of this property indicates whether the task resource is system task or not.')
param isSystemTask bool?

@description('Optional. The template that describes the repository and tag information for run log artifact.')
param logTemplate string?

@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentitiesType?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
)

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'SystemAssigned, UserAssigned' : 'SystemAssigned')
        : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : 'None')
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

var stepProperties = step.?dockerBuild != null
  ? {
      type: 'Docker'
      dockerFilePath: step!.dockerBuild!.dockerFilePath
      contextPath: step.?dockerBuild.?contextPath
      contextAccessToken: step.?dockerBuild.?contextAccessToken
      imageNames: step.?dockerBuild.?imageNames
      isPushEnabled: step.?dockerBuild.?isPushEnabled
      noCache: step.?dockerBuild.?noCache
      target: step.?dockerBuild.?target
      arguments: step.?dockerBuild.?arguments
    }
  : step.?encodedTask != null
      ? {
          type: 'EncodedTask'
          encodedTaskContent: step!.encodedTask!.encodedTaskContent
          encodedValuesContent: step.?encodedTask.?encodedValuesContent
          contextPath: step.?encodedTask.?contextPath
          contextAccessToken: step.?encodedTask.?contextAccessToken
          values: step.?encodedTask.?values
        }
      : step.?fileTask != null
          ? {
              type: 'FileTask'
              taskFilePath: step!.fileTask!.taskFilePath
              contextPath: step.?fileTask.?contextPath
              contextAccessToken: step.?fileTask.?contextAccessToken
              values: step.?fileTask.?values
              valuesFilePath: step.?fileTask.?valuesFilePath
            }
          : null

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.containerregistry-task.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

resource registry 'Microsoft.ContainerRegistry/registries@2025-11-01' existing = {
  name: registryName
}

resource task 'Microsoft.ContainerRegistry/registries/tasks@2025-03-01-preview' = {
  name: name
  parent: registry
  location: location
  identity: identity
  tags: tags
  properties: {
    agentConfiguration: agentConfiguration
    agentPoolName: agentPoolName
    credentials: credentials
    isSystemTask: isSystemTask
    logTemplate: logTemplate
    platform: platform
    status: status
    step: stepProperties
    timeout: timeout
    trigger: trigger
  }
}

@description('The name of the task.')
output name string = task.name

@description('The name of the resource group the task was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the task.')
output resourceId string = task.id

@description('The location the resource was deployed into.')
output location string = task.location

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string? = task.?identity.?principalId

// =============== //
//   Definitions   //
// =============== //

@export()
@description('The type for managed identities on a task.')
type managedIdentitiesType = {
  @description('Optional. Enables system assigned managed identity on the resource.')
  systemAssigned: bool?

  @description('Optional. The resource ID(s) to assign to the resource.')
  userAssignedResourceIds: string[]?
}

@export()
@description('The type for the platform properties.')
type platformType = {
  @description('Required. The operating system type required for the run.')
  os: 'Linux' | 'Windows'

  @description('Optional. The OS architecture.')
  architecture: ('amd64' | 'arm' | 'arm64' | 'x86' | '386')?

  @description('Optional. Variant of the CPU.')
  variant: ('v6' | 'v7' | 'v8')?
}

@export()
@description('The type for the task step. Exactly one of dockerBuild, encodedTask, or fileTask must be provided.')
type taskStepType = {
  @description('Optional. The Docker build step properties.')
  dockerBuild: dockerBuildStepType?

  @description('Optional. The encoded task step properties.')
  encodedTask: encodedTaskStepType?

  @description('Optional. The file task step properties.')
  fileTask: fileTaskStepType?
}

@export()
@description('The type for a Docker build step.')
type dockerBuildStepType = {
  @description('Required. The Docker file path relative to the source context.')
  dockerFilePath: string

  @description('Optional. The URL (absolute or relative) of the source context for the task step.')
  contextPath: string?

  @description('Optional. The token (git PAT or SAS token of storage account blob) associated with the context.')
  @secure()
  contextAccessToken: string?

  @description('Optional. The fully qualified image names including the repository and tag.')
  imageNames: string[]?

  @description('Optional. The value of this property indicates whether the image built should be pushed to the registry or not.')
  isPushEnabled: bool?

  @description('Optional. The value of this property indicates whether the image cache is enabled or not.')
  noCache: bool?

  @description('Optional. The name of the target build stage for the docker build.')
  target: string?

  @description('Optional. The collection of override arguments to be used when executing this build step.')
  arguments: argumentType[]?
}

@export()
@description('The type for an encoded task step.')
type encodedTaskStepType = {
  @description('Required. Base64 encoded value of the template/definition file content.')
  encodedTaskContent: string

  @description('Optional. Base64 encoded value of the parameters/values file content.')
  encodedValuesContent: string?

  @description('Optional. The URL (absolute or relative) of the source context for the task step.')
  contextPath: string?

  @description('Optional. The token (git PAT or SAS token of storage account blob) associated with the context.')
  @secure()
  contextAccessToken: string?

  @description('Optional. The collection of overridable values that can be passed when running a task.')
  values: setValueType[]?
}

@export()
@description('The type for a file task step.')
type fileTaskStepType = {
  @description('Required. The task template/definition file path relative to the source context.')
  taskFilePath: string

  @description('Optional. The URL (absolute or relative) of the source context for the task step.')
  contextPath: string?

  @description('Optional. The token (git PAT or SAS token of storage account blob) associated with the context.')
  @secure()
  contextAccessToken: string?

  @description('Optional. The collection of overridable values that can be passed when running a task.')
  values: setValueType[]?

  @description('Optional. The task values/parameters file path relative to the source context.')
  valuesFilePath: string?
}

@export()
@description('The type for the trigger properties of a task.')
type triggerType = {
  @description('Optional. The trigger based on base image dependencies.')
  baseImageTrigger: baseImageTriggerType?

  @description('Optional. The collection of triggers based on source code repository.')
  sourceTriggers: sourceTriggerType[]?

  @description('Optional. The collection of timer triggers.')
  timerTriggers: timerTriggerType[]?
}

@export()
@description('The type for a base image trigger.')
type baseImageTriggerType = {
  @description('Required. The name of the trigger.')
  name: string

  @description('Required. The type of the auto trigger for base image dependency updates.')
  baseImageTriggerType: 'All' | 'Runtime'

  @description('Optional. The current status of trigger.')
  status: ('Disabled' | 'Enabled')?
}

@export()
@description('The type for a source trigger.')
type sourceTriggerType = {
  @description('Required. The name of the trigger.')
  name: string

  @description('Required. The properties that describe the source (code) for the task.')
  sourceRepository: sourcePropertiesType

  @description('Required. The source event corresponding to the trigger.')
  sourceTriggerEvents: ('commit' | 'pullrequest')[]

  @description('Optional. The current status of trigger.')
  status: ('Disabled' | 'Enabled')?
}

@export()
@description('The type for the source properties of a task trigger.')
type sourcePropertiesType = {
  @description('Required. The full URL to the source code repository.')
  repositoryUrl: string

  @description('Required. The type of source control service.')
  sourceControlType: 'Github' | 'VisualStudioTeamService'

  @description('Optional. The branch name of the source code.')
  branch: string?

  @description('Optional. The authorization properties for accessing the source code repository.')
  sourceControlAuthProperties: authInfoType?
}

@export()
@description('The type for the auth info of source control.')
type authInfoType = {
  @description('Required. The access token used to access the source control provider.')
  @secure()
  token: string

  @description('Required. The type of Auth token.')
  tokenType: 'OAuth' | 'PAT'

  @description('Optional. Time in seconds that the token remains valid.')
  expiresIn: int?

  @description('Optional. The refresh token used to refresh the access token.')
  @secure()
  refreshToken: string?

  @description('Optional. The scope of the access token.')
  scope: string?
}

@export()
@description('The type for a timer trigger.')
type timerTriggerType = {
  @description('Required. The name of the trigger.')
  name: string

  @description('Required. The CRON expression for the task schedule.')
  schedule: string

  @description('Optional. The current status of trigger.')
  status: ('Disabled' | 'Enabled')?
}

@export()
@description('The type for a build argument.')
type argumentType = {
  @description('Required. The name of the argument.')
  name: string

  @description('Required. The value of the argument.')
  value: string

  @description('Optional. Flag to indicate whether the argument represents a secret and want to be removed from build logs.')
  isSecret: bool?
}

@export()
@description('The type for an overridable value.')
type setValueType = {
  @description('Required. The name of the overridable value.')
  name: string

  @description('Required. The overridable value.')
  value: string

  @description('Optional. Flag to indicate whether the value represents a secret or not.')
  isSecret: bool?
}

@export()
@description('The type for the agent properties.')
type agentPropertiesType = {
  @description('Optional. The CPU configuration in terms of number of cores required for the run.')
  cpu: int?
}

@export()
@description('The type for the credentials used during task invocation.')
type credentialsType = {
  @description('Optional. Describes the credential parameters for accessing the source registry.')
  sourceRegistry: sourceRegistryCredentialsType?

  @description('Optional. Describes the credential parameters for accessing other custom registries.')
  customRegistries: object?
}

@export()
@description('The type for source registry credentials.')
type sourceRegistryCredentialsType = {
  @description('Optional. The authentication mode which determines the source registry login scope.')
  loginMode: ('Default' | 'None')?
}
