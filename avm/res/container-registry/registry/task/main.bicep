metadata name = 'Container Registries Tasks'
metadata description = 'Deploys an Azure Container Registry (ACR) Task that can be used to automate container image builds and other workflows ([ref](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-tasks-overview)).'

@description('Conditional. The name of the parent registry. Required if the template is used in a standalone deployment.')
param registryName string

@description('Required. The name of the task.')
@minLength(5)
@maxLength(50)
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags resourceInput<'Microsoft.ContainerRegistry/registries/tasks@2025-03-01-preview'>.tags?

@description('Optional. The platform properties against which the task has to run.')
param platform resourceInput<'Microsoft.ContainerRegistry/registries/tasks@2025-03-01-preview'>.properties.platform?

@description('Optional. The task step properties. Exactly one of dockerBuildStep, encodedTaskStep, or fileTaskStep must be provided.')
param step resourceInput<'Microsoft.ContainerRegistry/registries/tasks@2025-03-01-preview'>.properties.step?

@description('Optional. The properties that describe all triggers for the task.')
param trigger resourceInput<'Microsoft.ContainerRegistry/registries/tasks@2025-03-01-preview'>.properties.trigger?

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
param agentConfiguration resourceInput<'Microsoft.ContainerRegistry/registries/tasks@2025-03-01-preview'>.properties.agentConfiguration?

@description('Optional. The dedicated agent pool for the task.')
param agentPoolName string?

@description('Optional. The properties that describe the credentials that will be used when the task is invoked.')
param credentials resourceInput<'Microsoft.ContainerRegistry/registries/tasks@2025-03-01-preview'>.properties.credentials?

@description('Optional. The value of this property indicates whether the task resource is system task or not.')
param isSystemTask bool?

@description('Optional. The template that describes the repository and tag information for run log artifact.')
param logTemplate string?

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.7.0'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

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

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.containerregistry-registry-task.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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
    step: step
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
