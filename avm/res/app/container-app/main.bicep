metadata name = 'Container Apps'
metadata description = 'This module deploys a Container App.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the Container App.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Bool indicating if the App exposes an external HTTP endpoint.')
param ingressExternal bool = true

@allowed([
  'accept'
  'ignore'
  'require'
])
@description('Optional. Client certificate mode for mTLS.')
param clientCertificateMode string = 'ignore'

@description('Optional. Object userd to configure CORS policy.')
param corsPolicy corsPolicyType

@allowed([
  'none'
  'sticky'
])
@description('Optional. Bool indicating if the Container App should enable session affinity.')
param stickySessionsAffinity string = 'none'

@allowed([
  'auto'
  'http'
  'http2'
  'tcp'
])
@description('Optional. Ingress transport protocol.')
param ingressTransport string = 'auto'

@description('Optional. Bool indicating if HTTP connections to is allowed. If set to false HTTP connections are automatically redirected to HTTPS connections.')
param ingressAllowInsecure bool = true

@description('Optional. Target Port in containers for traffic from ingress.')
param ingressTargetPort int = 80

@description('Optional. Maximum number of container replicas. Defaults to 10 if not set.')
param scaleMaxReplicas int = 10

@description('Optional. Minimum number of container replicas. Defaults to 3 if not set.')
param scaleMinReplicas int = 3

@description('Optional. Scaling rules.')
param scaleRules array = []

@allowed([
  'Multiple'
  'Single'
])
@description('Optional. Controls how active revisions are handled for the Container app.')
param activeRevisionsMode string = 'Single'

@description('Required. Resource ID of environment.')
param environmentId string

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Collection of private container registry credentials for containers used by the Container app.')
param registries array = []

@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentitiesType

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Custom domain bindings for Container App hostnames.')
param customDomains array = []

@description('Optional. Exposed Port in containers for TCP traffic from ingress.')
param exposedPort int = 0

@description('Optional. Rules to restrict incoming IP address.')
param ipSecurityRestrictions array = []

@description('Optional. Associates a traffic label with a revision. Label name should be consist of lower case alphanumeric characters or dashes.')
param trafficLabel string = 'label-1'

@description('Optional. Indicates that the traffic weight belongs to a latest stable revision.')
param trafficLatestRevision bool = true

@description('Optional. Name of a revision.')
param trafficRevisionName string = ''

@description('Optional. Traffic weight assigned to a revision.')
param trafficWeight int = 100

@description('Optional. Dapr configuration for the Container App.')
param dapr object = {}

@description('Optional. Max inactive revisions a Container App can have.')
param maxInactiveRevisions int = 0

@description('Required. List of container definitions for the Container App.')
param containers container[]

@description('Optional. List of specialized containers that run before app containers.')
param initContainersTemplate array = []

@description('Optional. The secrets of the Container App.')
@secure()
param secrets object = {}

@description('Optional. User friendly suffix that is appended to the revision name.')
param revisionSuffix string = ''

@description('Optional. List of volume definitions for the Container App.')
param volumes array = []

@description('Optional. Workload profile name to pin for container app execution.')
param workloadProfileName string = ''

var secretList = !empty(secrets) ? secrets.secureList : []

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

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.app-containerapp.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource containerApp 'Microsoft.App/containerApps@2023-05-01' = {
  name: name
  tags: tags
  location: location
  identity: identity
  properties: {
    environmentId: environmentId
    configuration: {
      activeRevisionsMode: activeRevisionsMode
      dapr: !empty(dapr) ? dapr : null
      ingress: {
        allowInsecure: ingressAllowInsecure
        customDomains: !empty(customDomains) ? customDomains : null
        corsPolicy: corsPolicy != null ? {
          allowCredentials: corsPolicy.?allowCredentials ?? false
          allowedHeaders: corsPolicy.?allowedHeaders ?? []
          allowedMethods: corsPolicy.?allowedMethods ?? []
          allowedOrigins: corsPolicy.?allowedOrigins ?? []
          exposeHeaders: corsPolicy.?exposeHeaders ?? []
          maxAge: corsPolicy.?maxAge
        } : null
        clientCertificateMode: clientCertificateMode
        exposedPort: exposedPort
        external: ingressExternal
        ipSecurityRestrictions: !empty(ipSecurityRestrictions) ? ipSecurityRestrictions : null
        targetPort: ingressTargetPort
        stickySessions: {
          affinity: stickySessionsAffinity
        }
        traffic: [
          {
            label: trafficLabel
            latestRevision: trafficLatestRevision
            revisionName: trafficRevisionName
            weight: trafficWeight
          }
        ]
        transport: ingressTransport
      }
      maxInactiveRevisions: maxInactiveRevisions
      registries: !empty(registries) ? registries : null
      secrets: secretList
    }
    template: {
      containers: containers
      initContainers: !empty(initContainersTemplate) ? initContainersTemplate : null
      revisionSuffix: revisionSuffix
      scale: {
        maxReplicas: scaleMaxReplicas
        minReplicas: scaleMinReplicas
        rules: !empty(scaleRules) ? scaleRules : null
      }
      volumes: !empty(volumes) ? volumes : null
    }
    workloadProfileName: workloadProfileName
  }
}

resource containerApp_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: containerApp
}

resource containerApp_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [ for (roleAssignment, index) in (roleAssignments ?? []): {
    name: guid(containerApp.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
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
    scope: containerApp
  }
]

@description('The resource ID of the Container App.')
output resourceId string = containerApp.id

@description('The configuration of ingress fqdn.')
output fqdn string = containerApp.properties.configuration.ingress.fqdn

@description('The name of the resource group the Container App was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the Container App.')
output name string = containerApp.name

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string = containerApp.?identity.?principalId ?? ''

@description('The location the resource was deployed into.')
output location string = containerApp.location

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

type container = {
  @description('Optional. Container start command arguments.')
  args: string[]?

  @description('Optional. Container start command.')
  command: string[]?

  @description('Optional. Container environment variables.')
  env: environmentVar[]?

  @description('Required. Container image tag.')
  image: string

  @description('Optional. Custom container name.')
  name: string?

  @description('Optional. List of probes for the container.')
  probes: containerAppProbe[]?

  @description('Required. Container resource requirements.')
  resources: object

  @description('Optional. Container volume mounts.')
  volumeMounts: volumeMount[]?
}

type environmentVar = {
  @description('Required. Environment variable name.')
  name: string

  @description('Optional. Name of the Container App secret from which to pull the environment variable value.')
  secretRef: string?

  @description('Optional. Non-secret environment variable value.')
  value: string?
}

type containerAppProbe = {
  @description('Optional. Minimum consecutive failures for the probe to be considered failed after having succeeded. Defaults to 3.')
  @minValue(1)
  @maxValue(10)
  failureThreshold: int?

  @description('Optional. HTTPGet specifies the http request to perform.')
  httpGet: containerAppProbeHttpGet?

  @description('Optional. Number of seconds after the container has started before liveness probes are initiated.')
  @minValue(1)
  @maxValue(60)
  initialDelaySeconds: int?

  @description('Optional. How often (in seconds) to perform the probe. Default to 10 seconds.')
  @minValue(1)
  @maxValue(240)
  periodSeconds: int?

  @description('Optional. Minimum consecutive successes for the probe to be considered successful after having failed. Defaults to 1. Must be 1 for liveness and startup.')
  @minValue(1)
  @maxValue(10)
  successThreshold: int?

  @description('Optional. TCPSocket specifies an action involving a TCP port. TCP hooks not yet supported.')
  tcpSocket: containerAppProbeTcpSocket?

  @description('Optional. Optional duration in seconds the pod needs to terminate gracefully upon probe failure. The grace period is the duration in seconds after the processes running in the pod are sent a termination signal and the time when the processes are forcibly halted with a kill signal. Set this value longer than the expected cleanup time for your process. If this value is nil, the pod\'s terminationGracePeriodSeconds will be used. Otherwise, this value overrides the value provided by the pod spec. Value must be non-negative integer. The value zero indicates stop immediately via the kill signal (no opportunity to shut down). This is an alpha field and requires enabling ProbeTerminationGracePeriod feature gate. Maximum value is 3600 seconds (1 hour).')
  terminationGracePeriodSeconds: int?

  @description('Optional. Number of seconds after which the probe times out. Defaults to 1 second.')
  @minValue(1)
  @maxValue(240)
  timeoutSeconds: int?

  @description('Optional. The type of probe.')
  type: ('Liveness' | 'Startup' | 'Readiness')?
}

type corsPolicyType = {
  @description('Optional. Switch to determine whether the resource allows credentials.')
  allowCredentials: bool?

  @description('Optional. Specifies the content for the access-control-allow-headers header.')
  allowedHeaders: string[]?

  @description('Optional. Specifies the content for the access-control-allow-methods header.')
  allowedMethods: string[]?

  @description('Optional. Specifies the content for the access-control-allow-origins header.')
  allowedOrigins: string[]?

  @description('Optional. Specifies the content for the access-control-expose-headers header.')
  exposeHeaders: string[]?

  @description('Optional. Specifies the content for the access-control-max-age header.')
  maxAge: int?
}?

type containerAppProbeHttpGet = {
  @description('Optional. Host name to connect to. Defaults to the pod IP.')
  host: string?

  @description('Optional. HTTP headers to set in the request.')
  httpHeaders: containerAppProbeHttpGetHeadersItem[]?

  @description('Required. Path to access on the HTTP server.')
  path: string

  @description('Required. Name or number of the port to access on the container.')
  port: int

  @description('Optional. Scheme to use for connecting to the host. Defaults to HTTP.')
  scheme: ('HTTP' | 'HTTPS')?
}

type containerAppProbeHttpGetHeadersItem = {
  @description('Required. Name of the header.')
  name: string

  @description('Required. Value of the header.')
  value: string
}

type containerAppProbeTcpSocket = {
  @description('Optional. Host name to connect to, defaults to the pod IP.')
  host: string?

  @description('Required. Number of the port to access on the container. Name must be an IANA_SVC_NAME.')
  @minValue(1)
  @maxValue(65535)
  port: int
}

type volumeMount = {
  @description('Required. Path within the container at which the volume should be mounted.Must not contain \':\'.')
  mountPath: string

  @description('Optional. Path within the volume from which the container\'s volume should be mounted. Defaults to "" (volume\'s root).')
  subPath: string?

  @description('Required. This must match the Name of a Volume.')
  volumeName: string
}
