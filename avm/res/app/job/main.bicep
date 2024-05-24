metadata name = 'Container App Jobs'
metadata description = 'This module deploys a Container App Job.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the Container App.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Required. Resource ID of Container Apps Environment.')
param environmentResourceId string

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Tags of the resource.')
@metadata({
  example: '''
  {
      "key1": "value1",
      "key2": "value2"
  }
  '''
})
param tags object?

@description('Optional. Collection of private container registry credentials for containers used by the Container app.')
@metadata({
  example: '''[
  {
    "server": "myregistry.azurecr.io",
    "identity": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myManagedIdentity"
  },
  {
    "server": "myregistry2.azurecr.io",
    "identity": "system"
  }
  ,
  {
    "server": "myregistry3.azurecr.io",
    "username": "myusername",
    "passwordSecretRef": "secret-name"
  }
]'''
})
param registries registryCredentialsType?

@description('Optional. The managed identity definition for this resource.')
@metadata({
  example: '''
  {
    "systemAssigned": true,
    "userAssignedResourceIds": [
      "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myManagedIdentity"
    ]
  },
  {
    "systemAssigned": true
  }
  '''
})
param managedIdentities managedIdentitiesType

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Required. List of container definitions for the Container App.')
param containers containerType

@description('Optional. List of specialized containers that run before app containers.')
param initContainersTemplate initContainerType?

@description('Optional. Required if TriggerType is Event. Configuration of an event driven job.')
param eventTriggerConfig jobConfigurationEventTriggerConfigType?

@description('Optional. Required if TriggerType is Schedule. Configuration of a schedule based job.')
param scheduleTriggerConfig jobConfigurationScheduleTriggerconfigType?

@description('Optional. Required if TriggerType is Manual. Configuration of a manual job.')
param manualTriggerConfig jobConfigurationManualTriggerConfigType?

@description('Optional. The maximum number of times a replica can be retried.')
param replicaRetryLimit int = 0

@description('Optional. The name of the workload profile to use.')
param workloadProfileName string = 'Consumption'

@description('Optional. The secrets of the Container App.')
param secrets secretsType?

@description('Optional. List of volume definitions for the Container App.')
param volumes volumeType?

@description('Optional. Maximum number of seconds a replica is allowed to run.')
param replicaTimeout int = 1800

@allowed([
  'Event'
  'Manual'
  'Schedule'
])
@description('Required. Trigger type of the job.')
param triggerType string

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned')
        : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : 'None')
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

var builtInRoleNames = {
  'ContainerApp Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'ad2dd5fb-cd4b-4fd4-a9b6-4fed3630980b'
  )
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
  'User Access Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  )
}

resource avmTelemetry 'Microsoft.Resources/deployments@2023-07-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.app-job.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource job 'Microsoft.App/jobs@2024-03-01' = {
  name: name
  tags: tags
  location: location
  identity: identity
  properties: {
    environmentId: environmentResourceId
    configuration: {
      triggerType: triggerType
      eventTriggerConfig: triggerType == 'Event' ? eventTriggerConfig : null
      manualTriggerConfig: triggerType == 'Manual' ? manualTriggerConfig : null
      scheduleTriggerConfig: triggerType == 'Schedule' ? scheduleTriggerConfig : null
      replicaRetryLimit: replicaRetryLimit
      replicaTimeout: replicaTimeout
      registries: registries
      secrets: secrets
    }
    template: {
      containers: containers
      initContainers: initContainersTemplate
      volumes: volumes
    }
    workloadProfileName: workloadProfileName
  }
}

resource job_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: job
}

resource automationAccount_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (roleAssignments ?? []): {
    name: guid(job.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
    properties: {
      roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName)
        ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName]
        : contains(roleAssignment.roleDefinitionIdOrName, '/providers/Microsoft.Authorization/roleDefinitions/')
            ? roleAssignment.roleDefinitionIdOrName
            : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName)
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: job
  }
]

// ============ //
// Outputs      //
// ============ //

@description('The resource ID of the Container App Job.')
output resourceId string = job.id

@description('The name of the resource group the Container App Job was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the Container App Job.')
output name string = job.name

@description('The location the resource was deployed into.')
output location string = job.location

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string = job.?identity.?principalId ?? ''

// =============== //
//   Definitions   //
// =============== //

type managedIdentitiesType = {
  @description('Optional. Enables system assigned managed identity on the resource.')
  systemAssigned: bool?

  @description('Optional. The resource ID(s) to assign to the resource.')
  userAssignedResourceIds: string[]?
}?

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

type roleAssignmentType = {
  @description('Required. The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
  roleDefinitionIdOrName: string

  @description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
  principalId: string

  @description('Optional. The principal type of the assigned principal ID.')
  principalType: ('ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup' | 'Device')?

  @description('Optional. The description of the role assignment.')
  description: string?

  @description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".')
  condition: string?

  @description('Optional. Version of the condition.')
  conditionVersion: '2.0'?

  @description('Optional. The Resource Id of the delegated managed identity resource.')
  delegatedManagedIdentityResourceId: string?
}[]?

type registryCredentialsType = {
  @description('Required. The FQDN name of the container registry.')
  @metadata({ example: 'myregistry.azurecr.io' })
  server: string

  @description('Optional. The resource ID of the (user) managed identity, which is used to access the Azure Container Registry.')
  @metadata({
    example: '''
    user-assigned identity: /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myManagedIdentity
    system-assigned identity: system
    '''
  })
  identity: string?

  @description('Optional. The username for the container registry.')
  username: string?

  @description('Conditional. The name of the secret contains the login password. Required if `username` is not null.')
  passwordSecretRef: string?
}[]?

type secretsType = {
  @description('Optional. Resource ID of a managed identity to authenticate with Azure Key Vault, or System to use a system-assigned identity.')
  identity: string?

  @description('Conditional. If an identity is used, the resource ID of a user-managed identity or System for a system-assigned managed identity to authenticate with Azure Key Vault. Required if `identity` is not null.')
  keyVaultUrl: string?

  @description('Optional. The name of the secret.')
  name: string?

  @description('Conditional. If name is used to specify a username, this value holds the secret for that username. Required if `name` is not null.')
  @secure()
  value: string?
}[]?

type secretVolumeItemType = {
  @description('Required. Path to project secret to. If no path is provided, path defaults to name of secret listed in secretRef.')
  path: string

  @description('Required. Name of the Container App secret from which to pull the secret value.')
  secretRef: string
}[]?

type volumeType = {
  @description('Required. The name of the volume.')
  name: string

  @description('Conditional. Mount options used while mounting the Azure file share or NFS Azure file share. Must be a comma-separated string. Required if `storageType` is not `EmptyDir`.')
  mountOptions: string?

  @description('Optional. List of secrets to be added in volume. If no secrets are provided, all secrets in collection will be added to volume.')
  secrets: secretVolumeItemType

  @description('Conditional. The storage account name. Not needed for EmptyDir and Secret. Required if `storageType` is `AzureFile` or `NfsAzureFile`.')
  storageName: string?

  @description('Required. The container name.')
  storageType: ('AzureFile' | 'EmptyDir' | 'NfsAzureFile' | 'Secret')
}[]?

type containerEnvironmentVariablesType = {
  @description('Required. The environment variable name.')
  name: string

  @description('Conditional. The name of the Container App secret from which to pull the envrionment variable value. Required if `value` is null.')
  secretRef: string?

  @description('Conditional. The environment variable value. Required if `secretRef` is null.')
  value: string?
}[]?

type containerProbeHttpGetHttpHeadersItem = {
  @description('Required. The header field name.')
  name: string

  @description('Required. The header field value.')
  value: string
}[]?

type containerProbeHttpGetType = {
  @description('Optional. Host name to connect to, defaults to the pod IP.')
  host: string?

  @description('Optional. Custom headers to set in the request.')
  httpHeaders: containerProbeHttpGetHttpHeadersItem

  @description('Required. Path to access on the HTTP server.')
  path: string

  @description('Required. Name of the port to access on the container. If not specified, the containerPort is used.')
  @minValue(1)
  @maxValue(65535)
  port: int

  @description('Required. Scheme to use for connecting to the host. Defaults to HTTP.')
  scheme: ('HTTP' | 'HTTPS')?
}?

type containerProbeTcpSocketType = {
  @description('Optional. Host name to connect to, defaults to the pod IP.')
  host: string

  @description('Required. Name of the port to access on the container. If not specified, the containerPort is used.')
  @minValue(1)
  @maxValue(65535)
  port: int
}?

type containerProbeType = {
  @description('Optional. Minimum consecutive failures for the probe to be considered failed after having succeeded. Defaults to 3.')
  @minValue(1)
  @maxValue(10)
  failureThreshold: int?

  @description('Optional. HTTPGet specifies the http request to perform.')
  httpGet: containerProbeHttpGetType

  @description('Optional. Number of seconds after the container has started before liveness probes are initiated.')
  @minValue(1)
  @maxValue(60)
  initialDelaySeconds: int

  @description('Optional. How often (in seconds) to perform the probe. Default to 10 seconds.')
  @minValue(1)
  @maxValue(60)
  periodSeconds: int

  @description('Optional. Minimum consecutive successes for the probe to be considered successful after having failed. Defaults to 1.')
  @minValue(1)
  @maxValue(10)
  successThreshold: int?

  @description('Optional. TCPSocket specifies an action involving a TCP port.')
  tcpSocket: containerProbeTcpSocketType

  @description('Optional. Duration in seconds the pod needs to terminate gracefully upon probe failure. This is an alpha field and requires enabling ProbeTerminationGracePeriod feature gate.')
  @minValue(0)
  @maxValue(3600)
  terminationGracePeriodSeconds: int?

  @description('Optional. Number of seconds after which the probe times out. Defaults to 1 second.')
  @minValue(1)
  @maxValue(240)
  timeoutSeconds: int?

  @description('Required. The type of probe.')
  type: ('Liveness' | 'Readiness' | 'Startup')
}[]?

type containerResourceType = {
  @description('Required. The CPU limit of the container in cores.')
  @metadata({
    example: '''
    json('0.25')
    1
    '''
  })
  cpu: string

  @description('Optional. The required memory.')
  @metadata({
    example: '''
    '250Mb'
    '1.5Gi'
    '1500Mi'
    '''
  })
  memory: string
}?

type containerVolumeMountType = {
  @description('Required. The path within the container at which the volume should be mounted. Must not contain \':\'.')
  mountPath: string

  @description('Optional. Path within the volume from which the container\'s volume should be mounted.')
  subPath: string?

  @description('Required. This must match the Name of a Volume.')
  volumeName: string
}[]?

type jobConfigurationManualTriggerConfigType = {
  // Properties replicaCompletionCount and parallelism would be set to 1 by default
  @description('Optional. Number of parallel replicas of a job that can run at a given time. Defaults to 1.')
  parallelism: int?

  @description('Required. Minimum number of successful replica completions before overall job completion.')
  replicaCompletionCount: int
}

type jobConfigurationScheduleTriggerconfigType = {
  @description('Required. Cron formatted repeating schedule ("* * * * *") of a Cron Job.')
  cronExpression: string

  @description('Required. Number of parallel replicas of a job that can run at a given time.')
  parallelism: int

  @description('Optional. Number of successful completions of a job that are necessary to consider the job complete.')
  replicaCompletionCount: int
}

type jobConfigurationEventTriggerConfigType = {
  @description('Required. Number of parallel replicas of a job that can run at a given time.')
  parallelism: int

  @description('Optional. Minimum number of successful replica completions before overall job completion.')
  replicaCompletionCount: int

  @description('Required. Scaling configurations for event driven jobs.')
  scale: jobScaleType
}

type jobScaleType = {
  @description('Optional. Maximum number of job executions that are created for a trigger, default 100.')
  maxExecutions: int?

  @description('Optional. Minimum number of job executions that are created for a trigger, default 0.')
  minExecutions: int?

  @description('Optional. Interval to check each event source in seconds. Defaults to 30s.')
  pollingInterval: int?

  @description('Optional. Scaling rules for the job.')
  rules: jobScaleRuleType
}

type jobScaleRuleType = {
  @description('Required. Authentication secrets for the scale rule.')
  auth: scaleRuleAuthType

  @description('Optional. Metadata properties to describe the scale rule.')
  @metadata({
    example: '''
    {
      "// for type azure-queue
      {
        queueName: 'default'
        storageAccountResourceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.Storage/storageAccounts/myStorageAccount'
      }"
    }
    '''
  })
  'metadata': object

  @description('Required. The name of the scale rule.')
  name: string

  @description('Optional. The type of the rule.')
  @metadata({
    example: '''
    {
      "azure-servicebus"
      "azure-queue"
      "redis"
    }
    '''
  })
  'type': string
}[]

type scaleRuleAuthType = {
  @description('Required. Name of the secret from which to pull the auth params.')
  secretRef: string

  @description('Required. Trigger Parameter that uses the secret.')
  triggerParameter: string
}[]?

type initContainerType = {
  @description('Optional. Container start command arguments.')
  args: string[]

  @description('Optional. Container start command.')
  command: string[]

  @description('Optional. The environment variables to set in the container.')
  env: containerEnvironmentVariablesType

  @description('Required. The image of the container.')
  image: string

  @description('Required. The name of the container.')
  name: string

  @description('Required. Container resource requirements.')
  resources: containerResourceType

  @description('Optional. The volume mounts to attach to the container.')
  volumeMounts: containerVolumeMountType
}[]

type containerType = {
  @description('Optional. Container start command arguments.')
  args: string[]?

  @description('Optional. The command to run in the container.')
  command: string[]?

  @description('Optional. The environment variables to set in the container.')
  env: containerEnvironmentVariablesType

  @description('Required. The image of the container.')
  image: string

  @description('Required. The name of the container.')
  name: string

  @description('Optional. The probes of the container.')
  probes: containerProbeType

  @description('Optional. The resources to allocate to the container.')
  resources: containerResourceType

  @description('Optional. The volume mounts to attach to the container.')
  volumeMounts: containerVolumeMountType
}[]
