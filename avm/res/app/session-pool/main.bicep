metadata name = 'Container App Session Pool'
metadata description = 'This module deploys a Container App Session Pool.'

@description('Required. Name of the Container App Session Pool.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Required. The container type of the sessions.')
@allowed(['PythonLTS', 'CustomContainer'])
param containerType string

@description('Optional. Custom container definitions. Only required if containerType is CustomContainer.')
param containers sessionContainerType[]?

@description('Optional. Required if containerType == \'CustomContainer\'. Target port in containers for traffic from ingress. Only required if containerType is CustomContainer.')
param targetIngressPort int?

@description('Optional. Container registry credentials. Only required if containerType is CustomContainer and the container registry requires authentication.')
param registryCredentials sessionRegistryCredentialsType?

@description('Optional. The cooldown period of a session in seconds.')
param cooldownPeriodInSeconds int = 300

@description('Optional. The maximum count of sessions at the same time.')
param maxConcurrentSessions int = 5

@description('Optional. The minimum count of ready session instances.')
param readySessionInstances int?

@description('Optional. Network status for the sessions. Defaults to EgressDisabled.')
@allowed(['EgressEnabled', 'EgressDisabled'])
param sessionNetworkStatus string = 'EgressDisabled'

@description('Optional. The pool management type of the session pool. Defaults to Dynamic.')
@allowed(['Dynamic', 'Manual'])
param poolManagementType string = 'Dynamic'

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

@description('Optional. Settings for a Managed Identity that is assigned to the Session pool.')
param managedIdentitySettings managedIdentitySettingType[]?

@description('Optional. Resource ID of the session pool\'s environment.')
param environmentId string?

@description('Optional. Tags of the Automation Account resource.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

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
  'Azure ContainerApps Session Executor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '0fb8eba5-a2bb-4abe-b1c1-49dfad359bb0'
  )
  'Container Apps SessionPools Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f7669afb-68b2-44b4-9c5f-6d2a47fddda0'
  )
  'Container Apps SessionPools Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'af61e8fc-2633-4b95-bed3-421ad6826515'
  )
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
  'User Access Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  )
}

var formattedRoleAssignments = [
  for (roleAssignment, index) in (roleAssignments ?? []): union(roleAssignment, {
    roleDefinitionId: builtInRoleNames[?roleAssignment.roleDefinitionIdOrName] ?? (contains(
        roleAssignment.roleDefinitionIdOrName,
        '/providers/Microsoft.Authorization/roleDefinitions/'
      )
      ? roleAssignment.roleDefinitionIdOrName
      : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName))
  })
]

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.app-sessionpool.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '#_moduleVersion_#.0'
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

resource sessionPool 'Microsoft.App/sessionPools@2024-10-02-preview' = {
  name: name
  location: location
  identity: identity
  properties: {
    containerType: containerType
    environmentId: environmentId
    customContainerTemplate: containerType == 'CustomContainer'
      ? {
          containers: containers
          ingress: {
            targetPort: targetIngressPort
          }
          registryCredentials: registryCredentials
        }
      : null
    dynamicPoolConfiguration: {
      cooldownPeriodInSeconds: cooldownPeriodInSeconds
      executionType: 'Timed'
    }
    managedIdentitySettings: managedIdentitySettings
    scaleConfiguration: {
      maxConcurrentSessions: maxConcurrentSessions
      readySessionInstances: readySessionInstances
    }
    sessionNetworkConfiguration: {
      status: sessionNetworkStatus
    }
    poolManagementType: poolManagementType
  }
  tags: tags
}

resource sessionPool_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: sessionPool
}

resource sessionPool_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(sessionPool.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: sessionPool
  }
]

@description('The name of the session pool.')
output name string = sessionPool.name

@description('The resource ID of the deployed session pool.')
output resourceId string = sessionPool.id

@description('The name of the resource group in which the session pool was created.')
output resourceGroupName string = resourceGroup().name

@description('The management endpoint of the session pool.')
output managementEndpoint string = sessionPool.properties.poolManagementEndpoint

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string = sessionPool.?identity.?principalId ?? ''

// =============== //
//   Definitions   //
// =============== //

@export()
@description('Optional. Custom container definition.')
type sessionContainerType = {
  @description('Optional. Container start command arguments.')
  args: string[]?

  @description('Optional. Container start command.')
  command: string[]?

  @description('Optional. Container environment variables.')
  env: sessionContainerEnvType[]?

  @description('Required. Container image tag.')
  image: string

  @description('Required. Custom container name.')
  name: string

  @description('Required. Container resource requirements.')
  resources: sessionContainerResourceType
}

@description('Optional. Environment variable definition for a container. Only used with custom containers.')
type sessionContainerEnvType = {
  @description('Required. Environment variable name.')
  name: string

  @description('Optional. Required if value is not set. Name of the Container App secret from which to pull the environment variable value.')
  secretRef: string?

  @description('Optional. Required if secretRef is not set. Non-secret environment variable value.')
  value: string?
}

@export()
@description('Optional. Container resource requirements. Only used with custom containers.')
type sessionContainerResourceType = {
  @description('Required. Required CPU in cores, e.g. 0.5.')
  cpu: string

  @description('Required. Required memory, e.g. "1.25Gi".')
  memory: string
}

@description('Optional. Container registry credentials. Only used with custom containers.')
type sessionRegistryCredentialsType = {
  @description('Optional. A Managed Identity to use to authenticate with Azure Container Registry. For user-assigned identities, use the full user-assigned identity Resource ID. For system-assigned identities, use "system".')
  identity: string?

  @description('Optional. The name of the secret that contains the registry login password. Not used if identity is specified.')
  passwordSecretRef: string?

  @description('Required. Container registry server.')
  server: string

  @description('Required. Container registry username.')
  username: string
}

@description('Optional. Managed Identity settings for the session pool.')
type managedIdentitySettingType = {
  @description('Required. The resource ID of a user-assigned managed identity that is assigned to the Session Pool, or "system" for system-assigned identity.')
  identity: string

  @description('Required. Use to select the lifecycle stages of a Session Pool during which the Managed Identity should be available. Valid values: "All", "Init", "Main", "None".')
  lifecycle: string
}
