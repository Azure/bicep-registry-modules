@description('Deployment Location')
param location string

@description('Prefix of Storage Account Resource Name. This param is ignored when name is provided.')
param prefix string = 'st'

@description('Name of Storage Account. Must be unique within Azure.')
param name string = '${prefix}${uniqueString(resourceGroup().id, subscription().id)}'

@description('ID of the subnet where the Storage Account will be deployed, if virtual network access is enabled.')
param subnetID string = ''

@description('Toggle to enable or disable virtual network access for the Storage Account.')
param enableVNET bool = false

@description('Toggle to enable or disable zone redundancy for the Storage Account.')
param isZoneRedundant bool = false

@description('Storage Account Type. Use Zonal Redundant Storage when able.')
param storageAccountType string = isZoneRedundant ? 'Standard_ZRS' : 'Standard_LRS'

@description('Specifies the type of blob to manage the lifecycle policy.')
param blobType string = 'blockBlob'

@description('Allows https traffic only to storage service if sets to true.')
param supportHttpsTrafficOnly bool = true

@description('Allow or disallow public access to all blobs or containers in the storage account.')
param allowBlobPublicAccess bool = false

@description('Replication of objects between AAD tenants is allowed or not. For this property, the default interpretation is true.')
param allowCrossTenantReplication bool = false

@description('Allow or disallow public network access to Storage Account. Value is optional but if passed in, must be Enabled or Disabled.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Disabled'

@description('Set the minimum TLS version to be permitted on requests to storage. The default interpretation is TLS 1.0 for this property.')
@allowed([
  'TLS1_0'
  'TLS1_1'
  'TLS1_2'
])
param minimumTlsVersion string = 'TLS1_2'

@description('Lifecycle Management Policy Rules, should contain: \'moveToCool\' bool to enable blob to be moved to cool tier after \'moveToCoolAfterLastModificationDays\', \'deleteBlob\' bool to enable blob to be deleted after \'deleteBlobAfterLastModificationDays\' and delete the snapshot after \'deleteSnapshotAfterLastModificationDays\' ')
param lifecycleManagementPolicy lifecycleManagementPolicyObj = {
  moveToCool: false
  moveToCoolAfterLastModificationDays: 30
  deleteBlob: false
  deleteBlobAfterLastModificationDays: 30
  deleteSnapshotAfterLastModificationDays: 30
}

@description('When performing object replication, it should be enabled and contain: \'sourceSaName\', \'destinationSaName\', \'sourceSaId\', \'destinationSaId\', \'policyId\' & \'objReplicationRules\' which is array of objReplicationRules object that contains sourceContainer, destinationContainer and ruleId')
param objectReplicationPolicy objectReplicationPolicyObj = {
  enabled: false
  sourcePolicy: false
  policyId: 'default'
  sourceSaId: 'sourceSaId'
  destinationSaId: 'destinationSaId'
  sourceSaName: 'sourceSaName'
  destinationSaName: 'destinationSaName'
  objReplicationRules: [
    {
      destinationContainer: 'destContainer'
      sourceContainer: 'sourceContainer'
      ruleId: null
    }
  ]
}

@description('Define Private Endpoints that should be created for Azure Storage Account.')
param privateEndpoints array = []

@description('Toggle if Private Endpoints manual approval for Azure Storage Account should be enabled.')
param privateEndpointsApprovalEnabled bool = false

// @description('Toggle to enable or disable Blob service of the Storage Account.')
// param enableBlobService bool = false

@description('Name of a blob service to be created.')
param blobName string = 'default'

@description('Properties object for a Blob service of a Storage Account.')
param blobProperties blobServiceProperties = {}

@description('Array of "name" & "properties" object for a Blob containers to be created for blobServices of Storage Account.')
param blobContainers blobContainersArray = []

@description('Array of role assignment objects with Storage Account scope that contain the \'roleDefinitionIdOrName\', \'principalId\' and \'principalType\' to define RBAC role assignments on that resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param storageRoleAssignments storageRoleAssignmentsArray = []

@description('Array of role assignment objects with blobServices/containers scope that contain the \'containerName\', \'roleDefinitionIdOrName\', \'principalId\' and \'principalType\' to define RBAC role assignments on that resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param containerRoleAssignments containerRoleAssignmentsArray = []

var networkAcls = enableVNET ? {
  defaultAction: 'Deny'
  virtualNetworkRules: [
    {
      action: 'Allow'
      id: subnetID
    }
  ]
} : {}

var varPrivateEndpoints = [for privateEndpoint in privateEndpoints: {
  name: '${privateEndpoint.name}-${storageAccount.name}'
  privateLinkServiceId: storageAccount.id
  groupIds: [
    'blob'
  ]
  subnetId: privateEndpoint.subnetId
  privateDnsZones: contains(privateEndpoint, 'privateDnsZoneId') ? [
    {
      name: 'default'
      zoneId: privateEndpoint.privateDnsZoneId
    }
  ] : []
}]

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: name
  location: location
  sku: {
    name: storageAccountType
  }
  kind: 'StorageV2'
  properties: {
    encryption: {
      keySource: 'Microsoft.Storage'
      services: {
        blob: {
          enabled: true
        }
        file: {
          enabled: true
        }
      }
    }
    networkAcls: networkAcls
    supportsHttpsTrafficOnly: supportHttpsTrafficOnly
    allowBlobPublicAccess: allowBlobPublicAccess
    allowCrossTenantReplication: allowCrossTenantReplication
    publicNetworkAccess: publicNetworkAccess
    minimumTlsVersion: minimumTlsVersion
  }
}

resource managementpolicy 'Microsoft.Storage/storageAccounts/managementPolicies@2021-04-01' = {
  name: 'default'
  parent: storageAccount
  properties: {
    policy: {
      rules: [
        {
          enabled: lifecycleManagementPolicy.moveToCool
          name: 'move-to-cool'
          type: 'Lifecycle'
          definition: {
            actions: {
              baseBlob: {
                tierToCool: {
                  daysAfterModificationGreaterThan: lifecycleManagementPolicy.moveToCoolAfterLastModificationDays
                }
              }
            }
            filters: {
              blobTypes: [
                blobType
              ]
            }
          }
        }
        {
          enabled: lifecycleManagementPolicy.deleteBlob
          name: 'delete'
          type: 'Lifecycle'
          definition: {
            actions: {
              baseBlob: {
                delete: {
                  daysAfterModificationGreaterThan: lifecycleManagementPolicy.deleteBlobAfterLastModificationDays
                }
              }
              snapshot: {
                delete: {
                  daysAfterCreationGreaterThan: lifecycleManagementPolicy.deleteSnapshotAfterLastModificationDays
                }
              }
            }
            filters: {
              blobTypes: [
                'blockBlob'
              ]
            }
          }
        }
      ]
    }
  }
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2021-04-01' = if (blobName != '') {
  name: blobName
  parent: storageAccount
  properties: blobProperties
}

resource blobContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-04-01' = [for blobContainer in blobContainers: {
  name: blobContainer.name
  parent: blobService
  properties: contains(blobContainer, 'properties') ? blobContainer.properties : {}
}]

module orPolicy 'modules/or-policy.bicep' = if (objectReplicationPolicy.enabled) {
  name: '${uniqueString(deployment().name, location)}-storageaccount-or-policy'
  params: {
    objectReplicationPolicy: objectReplicationPolicy
  }
}

module storageaccount_privateEndpoint 'modules/privateEndpoint.bicep' = {
  name: '${uniqueString(deployment().name, location)}-storageaccount-private-endpoints'
  params: {
    location: location
    privateEndpoints: varPrivateEndpoints
    manualApprovalEnabled: privateEndpointsApprovalEnabled
  }
}

module storageRbac 'modules/rbac-storage.bicep' = [for (roleAssignment, index) in storageRoleAssignments: {
  name: 'sa-rbac-${index}-${uniqueString(deployment().name, location)}'
  dependsOn: [
    storageAccount
  ]
  params: {
    description: roleAssignment.description!
    principalIds: roleAssignment.principalIds!
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName!
    principalType: roleAssignment.principalType!
    name: name
  }
}]

module containerRbac 'modules/rbac-container.bicep' = [for (roleAssignment, index) in containerRoleAssignments: {
  name: 'sa-container-rbac-${index}-${uniqueString(deployment().name, location)}'
  dependsOn: [
    blobContainer
  ]
  params: {
    description: roleAssignment.description!
    principalIds: roleAssignment.principalIds!
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName!
    principalType: roleAssignment.principalType!
    name: name
    blobName: blobName
    containerName: roleAssignment.containerName!
  }
}]

@description('The name of the Storage Account resource')
output name string = name

@description('The ID of the Storage Account. Use this ID to reference the Storage Account in other Azure resource deployments.')
output id string = storageAccount.id

@description('Object Replication Policy ID for destination OR Policy, to be used as input for creating source OR Policy')
output orpId string = objectReplicationPolicy.enabled == true ? orPolicy.outputs.orpId : ''

@description('Object Replication Rules for the destination OR Policy, to be used as an input for source OR Policy')
output orpIdRules array = objectReplicationPolicy.enabled == true ? orPolicy.outputs.orpIdRules : []

@description('The properties of a storage account’s Blob service.')
type blobServiceProperties = {
  changeFeed: changeFeed?
  containerDeleteRetentionPolicy: containerDeleteRetentionPolicy?
  cors: cors?
  deleteRetentionPolicy: deleteRetentionPolicy?
  isVersioningEnabled: isVersioningEnabled?
  lastAccessTimeTrackingPolicy: lastAccessTimeTrackingPolicy?
  restorePolicy: restorePolicy?
}

@description('The blob service properties for change feed events.')
type changeFeed = {
  enabled: bool
  @minValue(1)
  @maxValue(146000)
  retentionInDays: int?
}

@description('The blob service properties for container soft delete.')
type containerDeleteRetentionPolicy = {
  allowPermanentDelete: bool
  @minValue(1)
  @maxValue(365)
  days: int?
  enabled: bool
}

@description('Specifies CORS rules for the Blob service. You can include up to five CorsRule elements in the request. If no CorsRule elements are included in the request body, all CORS rules will be deleted, and CORS will be disabled for the Blob service.')
type cors = {
  corsRules: [
    {
      allowedHeaders: [
        'string'
      ]
      allowedMethods: [
        'string'
      ]
      allowedOrigins: [
        'string'
      ]
      exposedHeaders: [
        'string'
      ]
      maxAgeInSeconds: int
    }
  ]
}

@description('The blob service properties for blob soft delete.')
type deleteRetentionPolicy = {
  allowPermanentDelete: bool
  @minValue(1)
  @maxValue(365)
  days: int?
  enabled: bool
}

@description('Toggle to enable or disable versioning for Blob service of the Storage Account. Used only if enableBlobService is set to true.')
type isVersioningEnabled = bool

@description('The blob service property to configure last access time based tracking policy.')
type lastAccessTimeTrackingPolicy = {
  blobType: [
    'string'
  ]
  enable: bool
  name: 'AccessTimeTracking'
  trackingGranularityInDays: 1?
}

@description('The blob service property to configure last access time based tracking policy.')
type restorePolicy = {
  @minValue(1)
  @maxValue(365)
  days: int?
  enabled: bool
}

type blobServiceContainerProperties = {
  defaultEncryptionScope: string?
  denyEncryptionScopeOverride: string?
  immutableStorageWithVersioning: {
    enabled: bool
  }?
  publicAccess: ('Blob' | 'Container' | 'None')?
}

type containerRoleAssignmentsArray = {
  description: string?
  roleDefinitionIdOrName: string?
  principalIds: string[]?
  principalType: string?
  containerName: string?
}[]

type storageRoleAssignmentsArray = {
  description: string?
  roleDefinitionIdOrName: string?
  principalIds: string[]?
  principalType: string?
  containerName: string?
}[]

type objReplicationRuelsArray = {
  destinationContainer: string
  sourceContainer: string
  ruleId: string?
}[]

type blobContainersArray = {
  name: string
  properties: blobServiceContainerProperties?
}[]

type objectReplicationPolicyObj = {
  enabled: bool
  policyId: string
  sourceSaId: string
  destinationSaId: string
  sourceSaName: string
  destinationSaName: string
  objReplicationRules: objReplicationRuelsArray
  sourcePolicy: bool
}

type lifecycleManagementPolicyObj = {
  moveToCool: bool
  moveToCoolAfterLastModificationDays: int
  deleteBlob: bool
  deleteBlobAfterLastModificationDays: int
  deleteSnapshotAfterLastModificationDays: int
}
