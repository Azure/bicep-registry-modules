metadata name = 'Container Instances Container Groups'
metadata description = 'This module deploys a Container Instance Container Group.'

@description('Required. Name for the container group.')
param name string

@description('Required. The containers and their respective config within the container group.')
param containers containerType[]

@description('Optional. The IP address type of the container group.')
param ipAddress ipAddressType?

@description('Optional. The operating system type required by the containers in the container group. - Windows or Linux.')
param osType string = 'Linux'

@description('Optional. Restart policy for all containers within the container group. - Always: Always restart. OnFailure: Restart on failure. Never: Never restart. - Always, OnFailure, Never.')
@allowed([
  'Always'
  'OnFailure'
  'Never'
])
param restartPolicy string = 'Always'

@description('Optional. The image registry credentials by which the container group is created from.')
param imageRegistryCredentials imageRegistryCredentialType[]?

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. The log analytics diagnostic information for a container group.')
param logAnalytics logAnalyticsType?

@description('Optional. The DNS config information for a container group.')
param dnsConfig dnsConfigType?

@description('Optional. A list of container definitions which will be executed before the application container starts.')
param initContainers resourceInput<'Microsoft.ContainerInstance/containerGroups@2023-05-01'>.properties.initContainers?

@description('Optional. The subnets to use by the container group.')
param subnets containerGroupSubnetIdType[]?

@description('Optional. Specify if volumes (emptyDir, AzureFileShare or GitRepo) shall be attached to your containergroup.')
param volumes resourceInput<'Microsoft.ContainerInstance/containerGroups@2023-05-01'>.properties.volumes?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

@description('Optional. Tags of the resource.')
param tags resourceInput<'Microsoft.ContainerInstance/containerGroups@2023-05-01'>.tags?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. The container group SKU.')
@allowed([
  'Dedicated'
  'Standard'
])
param sku string = 'Standard'

import { customerManagedKeyWithAutoRotateType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The customer managed key definition.')
param customerManagedKey customerManagedKeyWithAutoRotateType?

@description('Required. If set to 1, 2 or 3, the availability zone is hardcoded to that value. If set to -1, no zone is defined. Note that the availability zone numbers here are the logical availability zone in your Azure subscription. Different subscriptions might have a different mapping of the physical zone and logical zone. To understand more, please refer to [Physical and logical availability zones](https://learn.microsoft.com/en-us/azure/reliability/availability-zones-overview?tabs=azure-cli#physical-and-logical-availability-zones).')
@allowed([
  -1
  1
  2
  3
])
param availabilityZone int

@description('Optional. The priority of the container group.')
param priority 'Regular' | 'Spot' = 'Regular'

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'SystemAssigned, UserAssigned' : 'SystemAssigned')
        : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : 'None')
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

#disable-next-line BCP081
resource law 'Microsoft.OperationalInsights/workspaces@2025-02-01' existing = if (!empty(logAnalytics)) {
  name: last(split(logAnalytics!.workspaceResourceId, '/'))
  scope: resourceGroup(
    split(logAnalytics!.workspaceResourceId, '/')[2],
    split(logAnalytics!.workspaceResourceId, '/')[4]
  )
}

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.containerinstance-containergroup.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource cMKKeyVault 'Microsoft.KeyVault/vaults@2024-11-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId)) {
  name: last(split((customerManagedKey.?keyVaultResourceId!), '/'))
  scope: resourceGroup(
    split(customerManagedKey.?keyVaultResourceId!, '/')[2],
    split(customerManagedKey.?keyVaultResourceId!, '/')[4]
  )

  resource cMKKey 'keys@2024-11-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId) && !empty(customerManagedKey.?keyName)) {
    name: customerManagedKey.?keyName!
  }
}

resource cMKUserAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' existing = if (!empty(customerManagedKey.?userAssignedIdentityResourceId)) {
  name: last(split(customerManagedKey.?userAssignedIdentityResourceId!, '/'))
  scope: resourceGroup(
    split(customerManagedKey.?userAssignedIdentityResourceId!, '/')[2],
    split(customerManagedKey.?userAssignedIdentityResourceId!, '/')[4]
  )
}

resource containergroup 'Microsoft.ContainerInstance/containerGroups@2023-05-01' = {
  name: name
  location: location
  identity: identity
  tags: tags
  zones: availabilityZone != -1 ? array(string(availabilityZone)) : null
  properties: {
    // We could have assigned `containers` prop directly
    // if the memoryInGB would accept fractional numbers for int...
    // so the only option is the json() function for memoryInGB,
    // and it means to copy everything else prop by prop
    containers: [
      for (container, index) in containers: {
        name: container.name
        properties: {
          command: container.properties.?command
          environmentVariables: container.properties.?environmentVariables
          image: container.properties.?image
          livenessProbe: container.properties.?livenessProbe
          ports: container.properties.?ports
          readinessProbe: container.properties.?readinessProbe
          resources: {
            requests: {
              cpu: container.properties.resources.requests.cpu
              gpu: container.properties.resources.requests.?gpu
              memoryInGB: json(container.properties.resources.requests.?memoryInGB)
            }
            limits: !empty(container.properties.resources.?limits)
              ? {
                  cpu: container.properties.resources.?limits.?cpu
                  gpu: container.properties.resources.?limits.?gpu
                  memoryInGB: !empty(container.properties.resources.?limits.?memoryInGB)
                    ? json(container.properties.resources.?limits.?memoryInGB!)
                    : null
                }
              : null
          }
          securityContext: container.properties.?securityContext
          volumeMounts: container.properties.?volumeMounts
        }
      }
    ]
    diagnostics: !empty(logAnalytics)
      ? {
          logAnalytics: {
            logType: logAnalytics!.logType
            workspaceId: law.properties.customerId
            workspaceKey: law.listKeys().primarySharedKey
            #disable-next-line use-secure-value-for-secure-inputs use-resource-id-functions // Not a secret
            workspaceResourceId: logAnalytics!.?workspaceResourceId
            metadata: logAnalytics!.?metadata
          }
        }
      : null
    encryptionProperties: !empty(customerManagedKey)
      ? {
          identity: !empty(customerManagedKey.?userAssignedIdentityResourceId) ? cMKUserAssignedIdentity.id : null
          vaultBaseUrl: cMKKeyVault.properties.vaultUri
          keyName: customerManagedKey!.keyName
          // FYI: Key Rotation is not (yet) supported by the RP
          keyVersion: !empty(customerManagedKey.?keyVersion ?? '')
            ? customerManagedKey!.keyVersion!
            : last(split(cMKKeyVault::cMKKey.properties.keyUriWithVersion, '/'))
        }
      : null
    imageRegistryCredentials: imageRegistryCredentials
    initContainers: initContainers
    restartPolicy: restartPolicy
    osType: osType
    ipAddress: !empty(ipAddress)
      ? {
          autoGeneratedDomainNameLabelScope: !empty(dnsConfig.?nameServers)
            ? ipAddress.?autoGeneratedDomainNameLabelScope
            : null
          dnsNameLabel: ipAddress.?dnsNameLabel
          ip: ipAddress.?ip
          ports: ipAddress.?ports ?? []
          type: ipAddress.?type ?? 'Public'
        }
      : null
    sku: sku
    subnetIds: [
      for subnet in subnets ?? []: {
        id: subnet.subnetResourceId
        name: subnet.?name
      }
    ]
    volumes: volumes
    dnsConfig: dnsConfig
    priority: priority

    // TODO Add support for the following properties:
    // confidentialComputeProperties:
    // extensions:
  }
}

resource containergroup_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: containergroup
}

@description('The name of the container group.')
output name string = containergroup.name

@description('The resource ID of the container group.')
output resourceId string = containergroup.id

@description('The resource group the container group was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The IPv4 address of the container group.')
output iPv4Address string = containergroup.properties.ipAddress.ip

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string? = containergroup.?identity.?principalId

@description('The location the resource was deployed into.')
output location string = containergroup.location

// =============== //
//   Definitions   //
// =============== //

@export()
@description('The type for a container probe.')
type containerProbeType = {
  @description('Optional. The execution command to probe.')
  exec: {
    @description('Required. The commands to execute within the container.')
    command: string[]
  }?

  @description('Optional. The failure threshold.')
  failureThreshold: int?

  @description('Optional. The HTTP request to perform.')
  httpGet: {
    @description('Optional. The HTTP headers.')
    httpHeaders: {
      @description('Required. The name of the header.')
      name: string

      @description('Required. The value of the header.')
      value: string
    }[]?

    @description('Optional. The path to probe.')
    path: string?

    @description('Required. The port number to probe.')
    port: int

    @description('Optional. The scheme.')
    scheme: ('HTTP' | 'HTTPS')?
  }?

  @description('Optional. The initial delay seconds.')
  initialDelaySeconds: int?

  @description('Optional. The period seconds.')
  periodSeconds: int?

  @description('Optional. The success threshold.')
  successThreshold: int?

  @description('Optional. The timeout seconds.')
  timeoutSeconds: int?
}

@export()
@description('The type for a container.')
type containerType = {
  @description('Required. The name of the container instance.')
  name: string

  @description('Required. The properties of the container instance.')
  properties: {
    @description('Required. The name of the container source image.')
    image: string

    @description('Optional. The liveness probe.')
    livenessProbe: containerProbeType?

    @description('Optional. The readiness probe.')
    readinessProbe: containerProbeType?

    @description('Optional. The exposed ports on the container instance.')
    ports: {
      @description('Required. The port number exposed on the container instance.')
      port: int

      @description('Required. The protocol associated with the port number.')
      protocol: string
    }[]?

    @description('Required. The resource requirements of the container instance.')
    resources: {
      @description('Required. The resource requests of this container instance.')
      requests: {
        @description('Required. The CPU request of this container instance.')
        cpu: int

        @description('Optional. The GPU request of this container instance.')
        gpu: containerGpuType?

        @description('Required. The memory request in GB of this container instance.')
        memoryInGB: string
      }

      @description('Optional. The resource limits of this container instance.')
      limits: {
        @description('Required. The CPU limit of this container instance.')
        cpu: int

        @description('Optional. The GPU limit of this container instance.')
        gpu: containerGpuType?

        @description('Optional. The memory limit in GB of this container instance.')
        memoryInGB: string?
      }?
    }

    @description('Optional. The security context of the container instance.')
    securityContext: {
      @description('Optional. Whether privilege escalation is allowed for the container.')
      allowPrivilegeEscalation: bool?

      @description('Optional. The capabilities to add or drop for the container.')
      capabilities: {
        @description('Optional. The list of capabilities to add.')
        add: string[]?

        @description('Optional. The list of capabilities to drop.')
        drop: string[]?
      }?

      @description('Optional. Whether the container is run in privileged mode.')
      privileged: bool?

      @description('Optional. The GID to run the container as.')
      runAsGroup: int?

      @description('Optional. The UID to run the container as.')
      runAsUser: int?

      @description('Optional. The seccomp profile to use for the container.')
      seccompProfile: string?
    }?

    @description('Optional. The volume mounts within the container instance.')
    volumeMounts: {
      @description('Required. The name of the volume mount.')
      name: string

      @description('Required. The path within the container where the volume should be mounted. Must not contain colon (:).')
      mountPath: string

      @description('Optional. The flag indicating whether the volume mount is read-only.')
      readOnly: bool?
    }[]?

    @description('Optional. The command to execute within the container instance.')
    command: string[]?

    @description('Optional. The environment variables to set in the container instance.')
    environmentVariables: {
      @description('Required. The name of the environment variable.')
      name: string

      @description('Optional. The value of the secure environment variable.')
      @secure()
      secureValue: string?

      @description('Optional. The value of the environment variable.')
      value: string?
    }[]?
  }
}

@export()
@description('The type for log analytics diagnostics.')
type logAnalyticsType = {
  @description('Required. The log type to be used.')
  logType: ('ContainerInsights' | 'ContainerInstanceLogs')

  @description('Required. The workspace resource ID for log analytics.')
  workspaceResourceId: string

  @description('Optional. Metadata for log analytics.')
  metadata: resourceInput<'Microsoft.ContainerInstance/containerGroups@2023-05-01'>.properties.diagnostics.logAnalytics.metadata?
}

@export()
@description('The type for an image registry credential.')
type imageRegistryCredentialType = {
  @description('Required. The Docker image registry server without a protocol such as "http" and "https".')
  server: string

  @description('Optional. The identity for the private registry.')
  identity: string?

  @description('Optional. The identity URL for the private registry.')
  identityUrl: string?

  @description('Optional. The username for the private registry.')
  username: string?

  @description('Optional. The password for the private registry.')
  @secure()
  password: string?
}

@export()
@description('The type for an IP address port.')
type ipAddressPortsType = {
  @description('Required. The port number exposed on the container instance.')
  port: int

  @description('Required. The protocol associated with the port number.')
  protocol: string
}

@export()
@description('The type for an IP address.')
type ipAddressType = {
  @description('Optional. The value representing the security enum.')
  autoGeneratedDomainNameLabelScope:
    | 'Noreuse'
    | 'ResourceGroupReuse'
    | 'SubscriptionReuse'
    | 'TenantReuse'
    | 'Unsecure'?

  @description('Optional. The Dns name label for the IP.')
  dnsNameLabel: string?

  @description('Optional. The IP exposed to the public internet.')
  ip: string?

  @description('Required. The list of ports exposed on the container group.')
  ports: ipAddressPortsType[]

  @description('Optional. Specifies if the IP is exposed to the public internet or private VNET.')
  type: ('Public' | 'Private')?
}

@export()
@description('The type for a container group subnet.')
type containerGroupSubnetIdType = {
  @description('Required. Resource ID of virtual network and subnet.')
  subnetResourceId: string

  @description('Optional. Friendly name for the subnet.')
  name: string?
}

@export()
@description('The type for a DNS configuration.')
type dnsConfigType = {
  @description('Required. 	The DNS servers for the container group.')
  nameServers: string[]

  @description('Optional. The DNS options for the container group.')
  options: string?

  @description('Optional. The DNS search domains for hostname lookup in the container group.')
  searchDomains: string?
}

// will be removed in future. For more information see https://learn.microsoft.com/en-us/azure/container-instances/container-instances-gpu

@export()
@description('The type of a container GPU.')
type containerGpuType = {
  @description('Required. The count of the GPU resource.')
  count: int

  @description('Required. The SKU of the GPU resource.')
  sku: ('K80' | 'P100' | 'V100')
}
