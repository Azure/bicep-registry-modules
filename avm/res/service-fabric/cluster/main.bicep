metadata name = 'Service Fabric Clusters'
metadata description = 'This module deploys a Service Fabric Cluster.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the Service Fabric cluster.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. The lock settings of the service.')
param lock lockType

@allowed([
  'BackupRestoreService'
  'DnsService'
  'RepairManager'
  'ResourceMonitorService'
])
@description('Optional. The list of add-on features to enable in the cluster.')
param addOnFeatures array = []

@description('Optional. Number of unused versions per application type to keep.')
param maxUnusedVersionsToKeep int = 3

@description('Optional. The settings to enable AAD authentication on the cluster.')
param azureActiveDirectory object = {}

@description('Conditional. The certificate to use for securing the cluster. The certificate provided will be used for node to node security within the cluster, SSL certificate for cluster management endpoint and default admin client. Required if the certificateCommonNames parameter is not used.')
param certificate certificateType

@description('Conditional. Describes a list of server certificates referenced by common name that are used to secure the cluster. Required if the certificate parameter is not used.')
param certificateCommonNames certificateCommonNameType

@description('Optional. The list of client certificates referenced by common name that are allowed to manage the cluster. Cannot be used if the clientCertificateThumbprints parameter is used.')
param clientCertificateCommonNames clientCertificateCommonNameType

@description('Optional. The list of client certificates referenced by thumbprint that are allowed to manage the cluster. Cannot be used if the clientCertificateCommonNames parameter is used.')
param clientCertificateThumbprints clientCertificateThumbprintType

@description('Optional. The Service Fabric runtime version of the cluster. This property can only by set the user when upgradeMode is set to "Manual". To get list of available Service Fabric versions for new clusters use ClusterVersion API. To get the list of available version for existing clusters use availableClusterVersions.')
param clusterCodeVersion string?

@description('Optional. The storage account information for storing Service Fabric diagnostic logs.')
param diagnosticsStorageAccountConfig object = {}

@description('Optional. Indicates if the event store service is enabled.')
param eventStoreServiceEnabled bool = false

@description('Optional. The list of custom fabric settings to configure the cluster.')
param fabricSettings array = []

@description('Optional. Indicates if infrastructure service manager is enabled.')
param infrastructureServiceManager bool = false

@description('Required. The http management endpoint of the cluster.')
param managementEndpoint string

@description('Required. The list of node types in the cluster.')
param nodeTypes array

@description('Optional. Indicates a list of notification channels for cluster events.')
param notifications array = []

@allowed([
  'Bronze'
  'Gold'
  'None'
  'Platinum'
  'Silver'
])
@description('Required. The reliability level sets the replica set size of system services. Learn about ReliabilityLevel (https://learn.microsoft.com/en-us/azure/service-fabric/service-fabric-cluster-capacity). - None - Run the System services with a target replica set count of 1. This should only be used for test clusters. - Bronze - Run the System services with a target replica set count of 3. This should only be used for test clusters. - Silver - Run the System services with a target replica set count of 5. - Gold - Run the System services with a target replica set count of 7. - Platinum - Run the System services with a target replica set count of 9.')
param reliabilityLevel string

@description('Optional. Describes the certificate details.')
param reverseProxyCertificate object = {}

@description('Optional. Describes a list of server certificates referenced by common name that are used to secure the cluster.')
param reverseProxyCertificateCommonNames object = {}

@allowed([
  'Hierarchical'
  'Parallel'
])
@description('Optional. This property controls the logical grouping of VMs in upgrade domains (UDs). This property cannot be modified if a node type with multiple Availability Zones is already present in the cluster.')
param sfZonalUpgradeMode string = 'Hierarchical'

@description('Optional. Describes the policy used when upgrading the cluster.')
param upgradeDescription object = {}

@allowed([
  'Automatic'
  'Manual'
])
@description('Optional. The upgrade mode of the cluster when new Service Fabric runtime version is available.')
param upgradeMode string = 'Automatic'

@description('Optional. Indicates the end date and time to pause automatic runtime version upgrades on the cluster for an specific period of time on the cluster (UTC).')
param upgradePauseEndTimestampUtc string?

@description('Optional. Indicates the start date and time to pause automatic runtime version upgrades on the cluster for an specific period of time on the cluster (UTC).')
param upgradePauseStartTimestampUtc string?

@allowed([
  'Wave0'
  'Wave1'
  'Wave2'
])
@description('Optional. Indicates when new cluster runtime version upgrades will be applied after they are released. By default is Wave0.')
param upgradeWave string = 'Wave0'

@description('Optional. The VM image VMSS has been configured with. Generic names such as Windows or Linux can be used.')
param vmImage string?

@allowed([
  'Hierarchical'
  'Parallel'
])
@description('Optional. This property defines the upgrade mode for the virtual machine scale set, it is mandatory if a node type with multiple Availability Zones is added.')
param vmssZonalUpgradeMode string = 'Hierarchical'

@description('Optional. Boolean to pause automatic runtime version upgrades to the cluster.')
param waveUpgradePaused bool = false

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. Array of Service Fabric cluster application types.')
param applicationTypes array = []

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var clientCertificateCommonNamesVar = [
  for (clientCertificateCommonName, index) in (clientCertificateCommonNames ?? []): {
    certificateCommonName: clientCertificateCommonName.certificateCommonName
    certificateIssuerThumbprint: clientCertificateCommonName.certificateIssuerThumbprint
    isAdmin: clientCertificateCommonName.isAdmin
  }
]

var clientCertificateThumbprintsVar = [
  for (clientCertificateThumbprint, index) in (clientCertificateThumbprints ?? []): {
    certificateThumbprint: clientCertificateThumbprint.certificateThumbprint
    isAdmin: clientCertificateThumbprint.isAdmin
  }
]

var fabricSettingsVar = [
  for fabricSetting in fabricSettings: {
    name: contains(fabricSetting, 'name') ? fabricSetting.name : null
    parameters: contains(fabricSetting, 'parameters') ? fabricSetting.parameters : null
  }
]

var fnodeTypesVar = [
  for nodeType in nodeTypes: {
    applicationPorts: contains(nodeType, 'applicationPorts')
      ? {
          endPort: contains(nodeType.applicationPorts, 'endPort') ? nodeType.applicationPorts.endPort : null
          startPort: contains(nodeType.applicationPorts, 'startPort') ? nodeType.applicationPorts.startPort : null
        }
      : null
    capacities: contains(nodeType, 'capacities') ? nodeType.capacities : null
    clientConnectionEndpointPort: contains(nodeType, 'clientConnectionEndpointPort')
      ? nodeType.clientConnectionEndpointPort
      : null
    durabilityLevel: contains(nodeType, 'durabilityLevel') ? nodeType.durabilityLevel : null
    ephemeralPorts: contains(nodeType, 'ephemeralPorts')
      ? {
          endPort: contains(nodeType.ephemeralPorts, 'endPort') ? nodeType.ephemeralPorts.endPort : null
          startPort: contains(nodeType.ephemeralPorts, 'startPort') ? nodeType.ephemeralPorts.startPort : null
        }
      : null
    httpGatewayEndpointPort: contains(nodeType, 'httpGatewayEndpointPort') ? nodeType.httpGatewayEndpointPort : null
    isPrimary: contains(nodeType, 'isPrimary') ? nodeType.isPrimary : null
    isStateless: contains(nodeType, 'isStateless') ? nodeType.isStateless : null
    multipleAvailabilityZones: contains(nodeType, 'multipleAvailabilityZones')
      ? nodeType.multipleAvailabilityZones
      : null
    name: contains(nodeType, 'name') ? nodeType.name : 'Node00'
    placementProperties: contains(nodeType, 'placementProperties') ? nodeType.placementProperties : null
    reverseProxyEndpointPort: contains(nodeType, 'reverseProxyEndpointPort') ? nodeType.reverseProxyEndpointPort : null
    vmInstanceCount: contains(nodeType, 'vmInstanceCount') ? nodeType.vmInstanceCount : 1
  }
]

var notificationsVar = [
  for notification in notifications: {
    isEnabled: contains(notification, 'isEnabled') ? notification.isEnabled : false
    notificationCategory: contains(notification, 'notificationCategory')
      ? notification.notificationCategory
      : 'WaveProgress'
    notificationLevel: contains(notification, 'notificationLevel') ? notification.notificationLevel : 'All'
    notificationTargets: contains(notification, 'notificationTargets') ? notification.notificationTargets : []
  }
]

var upgradeDescriptionVar = union(
  {
    deltaHealthPolicy: {
      applicationDeltaHealthPolicies: upgradeDescription.?applicationDeltaHealthPolicies ?? {}
      maxPercentDeltaUnhealthyApplications: upgradeDescription.?maxPercentDeltaUnhealthyApplications ?? 0
      maxPercentDeltaUnhealthyNodes: upgradeDescription.?maxPercentDeltaUnhealthyNodes ?? 0
      maxPercentUpgradeDomainDeltaUnhealthyNodes: upgradeDescription.?maxPercentUpgradeDomainDeltaUnhealthyNodes ?? 0
    }
    forceRestart: contains(upgradeDescription, 'forceRestart') ? upgradeDescription.forceRestart : false
    healthCheckRetryTimeout: contains(upgradeDescription, 'healthCheckRetryTimeout')
      ? upgradeDescription.healthCheckRetryTimeout
      : '00:45:00'
    healthCheckStableDuration: contains(upgradeDescription, 'healthCheckStableDuration')
      ? upgradeDescription.healthCheckStableDuration
      : '00:01:00'
    healthCheckWaitDuration: contains(upgradeDescription, 'healthCheckWaitDuration')
      ? upgradeDescription.healthCheckWaitDuration
      : '00:00:30'
    upgradeDomainTimeout: contains(upgradeDescription, 'upgradeDomainTimeout')
      ? upgradeDescription.upgradeDomainTimeout
      : '02:00:00'
    upgradeReplicaSetCheckTimeout: contains(upgradeDescription, 'upgradeReplicaSetCheckTimeout')
      ? upgradeDescription.upgradeReplicaSetCheckTimeout
      : '1.00:00:00'
    upgradeTimeout: contains(upgradeDescription, 'upgradeTimeout') ? upgradeDescription.upgradeTimeout : '02:00:00'
  },
  contains(upgradeDescription, 'healthPolicy')
    ? {
        healthPolicy: {
          applicationHealthPolicies: contains(upgradeDescription.healthPolicy, 'applicationHealthPolicies')
            ? upgradeDescription.healthPolicy.applicationHealthPolicies
            : {}
          maxPercentUnhealthyApplications: contains(upgradeDescription.healthPolicy, 'maxPercentUnhealthyApplications')
            ? upgradeDescription.healthPolicy.maxPercentUnhealthyApplications
            : 0
          maxPercentUnhealthyNodes: contains(upgradeDescription.healthPolicy, 'maxPercentUnhealthyNodes')
            ? upgradeDescription.healthPolicy.maxPercentUnhealthyNodes
            : 0
        }
      }
    : {}
)

var builtInRoleNames = {
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
  name: '46d3xbcp.res.servicefabric-cluster.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

// Service Fabric cluster resource
resource serviceFabricCluster 'Microsoft.ServiceFabric/clusters@2021-06-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    addOnFeatures: addOnFeatures
    applicationTypeVersionsCleanupPolicy: {
      maxUnusedVersionsToKeep: maxUnusedVersionsToKeep
    }
    azureActiveDirectory: !empty(azureActiveDirectory)
      ? {
          clientApplication: contains(azureActiveDirectory, 'clientApplication')
            ? azureActiveDirectory.clientApplication
            : null
          clusterApplication: contains(azureActiveDirectory, 'clusterApplication')
            ? azureActiveDirectory.clusterApplication
            : null
          tenantId: contains(azureActiveDirectory, 'tenantId') ? azureActiveDirectory.tenantId : null
        }
      : null
    certificate: !empty(certificate)
      ? {
          thumbprint: certificate.?thumbprint ?? ''
          thumbprintSecondary: certificate.?thumbprintSecondary ?? null
          x509StoreName: certificate.?x509StoreName ?? null
        }
      : null
    certificateCommonNames: !empty(certificateCommonNames)
      ? {
          commonNames: certificateCommonNames.?commonNames ?? []
          x509StoreName: certificateCommonNames.?x509StoreName ?? null
        }
      : null
    clientCertificateCommonNames: clientCertificateCommonNamesVar
    clientCertificateThumbprints: clientCertificateThumbprintsVar
    clusterCodeVersion: clusterCodeVersion
    diagnosticsStorageAccountConfig: !empty(diagnosticsStorageAccountConfig)
      ? {
          blobEndpoint: contains(diagnosticsStorageAccountConfig, 'blobEndpoint')
            ? diagnosticsStorageAccountConfig.blobEndpoint
            : null
          protectedAccountKeyName: contains(diagnosticsStorageAccountConfig, 'protectedAccountKeyName')
            ? diagnosticsStorageAccountConfig.protectedAccountKeyName
            : null
          protectedAccountKeyName2: contains(diagnosticsStorageAccountConfig, 'protectedAccountKeyName2')
            ? diagnosticsStorageAccountConfig.protectedAccountKeyName2
            : null
          queueEndpoint: contains(diagnosticsStorageAccountConfig, 'queueEndpoint')
            ? diagnosticsStorageAccountConfig.queueEndpoint
            : null
          storageAccountName: contains(diagnosticsStorageAccountConfig, 'storageAccountName')
            ? diagnosticsStorageAccountConfig.storageAccountName
            : null
          tableEndpoint: contains(diagnosticsStorageAccountConfig, 'tableEndpoint')
            ? diagnosticsStorageAccountConfig.tableEndpoint
            : null
        }
      : null
    eventStoreServiceEnabled: eventStoreServiceEnabled
    fabricSettings: !empty(fabricSettings) ? fabricSettingsVar : null
    infrastructureServiceManager: infrastructureServiceManager
    managementEndpoint: managementEndpoint
    nodeTypes: !empty(nodeTypes) ? fnodeTypesVar : []
    notifications: !empty(notifications) ? notificationsVar : null
    reliabilityLevel: !empty(reliabilityLevel) ? reliabilityLevel : 'None'
    reverseProxyCertificate: !empty(reverseProxyCertificate)
      ? {
          thumbprint: contains(reverseProxyCertificate, 'thumbprint') ? reverseProxyCertificate.thumbprint : null
          thumbprintSecondary: contains(reverseProxyCertificate, 'thumbprintSecondary')
            ? reverseProxyCertificate.thumbprintSecondary
            : null
          x509StoreName: contains(reverseProxyCertificate, 'x509StoreName')
            ? reverseProxyCertificate.x509StoreName
            : null
        }
      : null
    reverseProxyCertificateCommonNames: !empty(reverseProxyCertificateCommonNames)
      ? {
          commonNames: contains(reverseProxyCertificateCommonNames, 'commonNames')
            ? reverseProxyCertificateCommonNames.commonNames
            : null
          x509StoreName: contains(reverseProxyCertificateCommonNames, 'x509StoreName')
            ? reverseProxyCertificateCommonNames.x509StoreName
            : null
        }
      : null
    sfZonalUpgradeMode: !empty(sfZonalUpgradeMode) ? sfZonalUpgradeMode : null
    upgradeDescription: !empty(upgradeDescription) ? upgradeDescriptionVar : null
    upgradeMode: !empty(upgradeMode) ? upgradeMode : null
    upgradePauseEndTimestampUtc: upgradePauseEndTimestampUtc
    upgradePauseStartTimestampUtc: upgradePauseStartTimestampUtc
    upgradeWave: !empty(upgradeWave) ? upgradeWave : null
    vmImage: vmImage
    vmssZonalUpgradeMode: !empty(vmssZonalUpgradeMode) ? vmssZonalUpgradeMode : null
    waveUpgradePaused: waveUpgradePaused
  }
}

// Service Fabric cluster resource lock
resource serviceFabricCluster_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: serviceFabricCluster
}

// Service Fabric cluster RBAC assignment
resource serviceFabricCluster_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(
      serviceFabricCluster.id,
      roleAssignment.principalId,
      roleAssignment.roleDefinitionId
    )
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: serviceFabricCluster
  }
]

// Service Fabric cluster application types
module serviceFabricCluster_applicationTypes 'application-type/main.bicep' = [
  for applicationType in applicationTypes: {
    name: '${uniqueString(deployment().name, location)}-SFC-${applicationType.name}'
    params: {
      name: applicationType.name
      serviceFabricClusterName: serviceFabricCluster.name
      tags: applicationType.?tags ?? tags
    }
  }
]

@description('The Service Fabric Cluster name.')
output name string = serviceFabricCluster.name

@description('The Service Fabric Cluster resource group.')
output resourceGroupName string = resourceGroup().name

@description('The Service Fabric Cluster resource ID.')
output resourceId string = serviceFabricCluster.id

@description('The Service Fabric Cluster endpoint.')
output endpoint string = serviceFabricCluster.properties.clusterEndpoint

@description('The location the resource was deployed into.')
output location string = serviceFabricCluster.location

// =============== //
//   Definitions   //
// =============== //

type certificateType = {
  @description('Required. The thumbprint of the primary certificate.')
  thumbprint: string

  @description('Optional. The thumbprint of the secondary certificate.')
  thumbprintSecondary: string?

  @description('Optional. The local certificate store location.')
  x509StoreName: (
    | 'AddressBook'
    | 'AuthRoot'
    | 'CertificateAuthority'
    | 'Disallowed'
    | 'My'
    | 'Root'
    | 'TrustedPeople'
    | 'TrustedPublisher')?
}?

type certificateCommonNameType = {
  @description('Required. The list of server certificates referenced by common name that are used to secure the cluster.')
  commonNames: serverCertificateCommonNameType

  @description('Optional. The local certificate store location.')
  x509StoreName: (
    | 'AddressBook'
    | 'AuthRoot'
    | 'CertificateAuthority'
    | 'Disallowed'
    | 'My'
    | 'Root'
    | 'TrustedPeople'
    | 'TrustedPublisher')?
}?

type serverCertificateCommonNameType = {
  @description('Required. The common name of the server certificate.')
  certificateCommonName: string

  @description('Required. The issuer thumbprint of the server certificate.')
  certificateIssuerThumbprint: string
}[]

type clientCertificateCommonNameType = {
  @description('Required. The common name of the client certificate.')
  certificateCommonName: string

  @description('Required. The issuer thumbprint of the client certificate.')
  certificateIssuerThumbprint: string

  @description('Required. Indicates if the client certificate has admin access to the cluster. Non admin clients can perform only read only operations on the cluster.')
  isAdmin: bool
}[]?

type clientCertificateThumbprintType = {
  @description('Required. The thumbprint of the client certificate.')
  certificateThumbprint: string

  @description('Required. Indicates if the client certificate has admin access to the cluster. Non admin clients can perform only read only operations on the cluster.')
  isAdmin: bool
}[]?

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

type roleAssignmentType = {
  @description('Optional. The name (as GUID) of the role assignment. If not provided, a GUID will be generated.')
  name: string?

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
