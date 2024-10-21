metadata name = 'Container Instances Container Groups'
metadata description = 'This module deploys a Container Instance Container Group.'

@description('Required. Name for the container group.')
param name string

@description('Required. The containers and their respective config within the container group.')
param containers containerType

@description('Conditional. Ports to open on the public IP address. Must include all ports assigned on container level. Required if `ipAddressType` is set to `public`.')
param ipAddressPorts ipAddressPortsType

@description('Optional. The operating system type required by the containers in the container group. - Windows or Linux.')
param osType string = 'Linux'

@description('Optional. Restart policy for all containers within the container group. - Always: Always restart. OnFailure: Restart on failure. Never: Never restart. - Always, OnFailure, Never.')
@allowed([
  'Always'
  'OnFailure'
  'Never'
])
param restartPolicy string = 'Always'

@description('Optional. Specifies if the IP is exposed to the public internet or private VNET. - Public or Private.')
@allowed([
  'Public'
  'Private'
])
param ipAddressType string = 'Public'

@description('Optional. The image registry credentials by which the container group is created from.')
param imageRegistryCredentials imageRegistryCredentialType

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Specify level of protection of the domain name label.')
@allowed([
  'Noreuse'
  'ResourceGroupReuse'
  'SubscriptionReuse'
  'TenantReuse'
  'Unsecure'
])
param autoGeneratedDomainNameLabelScope string = 'TenantReuse'

@description('Optional. The Dns name label for the resource.')
param dnsNameLabel string?

@description('Optional. List of dns servers used by the containers for lookups.')
param dnsNameServers array?

@description('Optional. DNS search domain which will be appended to each DNS lookup.')
param dnsSearchDomains string?

@description('Optional. A list of container definitions which will be executed before the application container starts.')
param initContainers array?

@description('Optional. Resource ID of the subnet. Only specify when ipAddressType is Private.')
param subnetId string?

@description('Optional. Specify if volumes (emptyDir, AzureFileShare or GitRepo) shall be attached to your containergroup.')
param volumes array?

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentitiesType

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. The container group SKU.')
@allowed([
  'Dedicated'
  'Standard'
])
param sku string = 'Standard'

@description('Optional. The customer managed key definition.')
param customerManagedKey customerManagedKeyType

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

resource cMKKeyVault 'Microsoft.KeyVault/vaults@2023-02-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId)) {
  name: last(split((customerManagedKey.?keyVaultResourceId ?? 'dummyVault'), '/'))
  scope: resourceGroup(
    split((customerManagedKey.?keyVaultResourceId ?? '//'), '/')[2],
    split((customerManagedKey.?keyVaultResourceId ?? '////'), '/')[4]
  )

  resource cMKKey 'keys@2023-02-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId) && !empty(customerManagedKey.?keyName)) {
    name: customerManagedKey.?keyName ?? 'dummyKey'
  }
}

resource cMKUserAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = if (!empty(customerManagedKey.?userAssignedIdentityResourceId)) {
  name: last(split(customerManagedKey.?userAssignedIdentityResourceId ?? 'dummyMsi', '/'))
  scope: resourceGroup(
    split((customerManagedKey.?userAssignedIdentityResourceId ?? '//'), '/')[2],
    split((customerManagedKey.?userAssignedIdentityResourceId ?? '////'), '/')[4]
  )
}

resource containergroup 'Microsoft.ContainerInstance/containerGroups@2023-05-01' = {
  name: name
  location: location
  identity: identity
  tags: tags
  properties: union(
    {
      containers: containers
      encryptionProperties: !empty(customerManagedKey)
        ? {
            identity: !empty(customerManagedKey.?userAssignedIdentityResourceId ?? '')
              ? cMKUserAssignedIdentity.id
              : null
            keyName: customerManagedKey!.keyName
            keyVersion: !empty(customerManagedKey.?keyVersion ?? '')
              ? customerManagedKey!.keyVersion
              : last(split(cMKKeyVault::cMKKey.properties.keyUriWithVersion, '/'))
            vaultBaseUrl: cMKKeyVault.properties.vaultUri
          }
        : null
      imageRegistryCredentials: imageRegistryCredentials
      initContainers: initContainers
      restartPolicy: restartPolicy
      osType: osType
      ipAddress: {
        type: ipAddressType
        autoGeneratedDomainNameLabelScope: !empty(dnsNameServers) ? autoGeneratedDomainNameLabelScope : null
        dnsNameLabel: dnsNameLabel
        ports: ipAddressPorts
      }
      sku: sku
      subnetIds: !empty(subnetId)
        ? [
            {
              id: subnetId
            }
          ]
        : null
      volumes: volumes
    },
    !empty(dnsNameServers)
      ? {
          dnsConfig: {
            nameServers: dnsNameServers
            searchDomains: dnsSearchDomains
          }
        }
      : {}
  )
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
output systemAssignedMIPrincipalId string = containergroup.?identity.?principalId ?? ''

@description('The location the resource was deployed into.')
output location string = containergroup.location

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

type customerManagedKeyType = {
  @description('Required. The resource ID of a key vault to reference a customer managed key for encryption from.')
  keyVaultResourceId: string

  @description('Required. The name of the customer managed key to use for encryption.')
  keyName: string

  @description('Optional. The version of the customer managed key to reference for encryption. If not provided, using \'latest\'.')
  keyVersion: string?

  @description('Optional. User assigned identity to use when fetching the customer managed key. Required if no system assigned identity is available for use.')
  userAssignedIdentityResourceId: string?
}?

type containerType = {
  @description('Required. The name of the container instance.')
  name: string

  @description('Required. The properties of the container instance.')
  properties: {
    @description('Required. The name of the container source image.')
    image: string

    @description('Optional. The liveness probe.')
    livenessProbe: {}?

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

        @description('Optional. The memory request in GB of this container instance. To specify a decimal value, use the json() function.')
        memoryInGB: int?
      }

      @description('Optional. The resource limits of this container instance.')
      limits: {
        @description('Required. The CPU limit of this container instance.')
        cpu: int

        @description('Optional. The GPU limit of this container instance.')
        gpu: containerGpuType?

        @description('Optional. The memory limit in GB of this container instance. To specify a decimal value, use the json() function.')
        memoryInGB: int?
      }?

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
    }

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
}[]

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
}[]?

type ipAddressPortsType = {
  @description('Required. The port number exposed on the container instance.')
  port: int

  @description('Required. The protocol associated with the port number.')
  protocol: string
}[]

// will be removed in future. For more information see https://learn.microsoft.com/en-us/azure/container-instances/container-instances-gpu
type containerGpuType = {
  @description('Required. The count of the GPU resource.')
  count: int

  @description('Required. The SKU of the GPU resource.')
  sku: ('K80' | 'P100' | 'V100')
}?
