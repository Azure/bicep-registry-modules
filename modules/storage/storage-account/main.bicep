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

// @description('Toggle to enable or disable Blob service of the Storage Account.')
// param enableBlobService bool = false

@description('Name of a blob service to be created.')
param blobName string = 'default'

@description('Properties object for a Blob service of a Storage Account.')
param blobProperties blobServiceProperties = {}

@description('Name of a blob container to be created')
param blobContainerName string = 'default'

@description('Properties object for a Blob container of a Storage Account.')
param blobContainerProperties blobServiceContainerProperties = {}

@description('Array of role assignment objects that contain the \'roleDefinitionIdOrName\', \'principalId\' and \'resourceType\' as \'storageAccount\' or \'blobContainer\' to define RBAC role assignments on that resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments roleAssignmentsArray = []

var networkAcls = enableVNET ? {
  defaultAction: 'Deny'
  virtualNetworkRules: [
    {
      action: 'Allow'
      id: subnetID
    }
  ]
} : {}

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
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: false
    networkAcls: networkAcls
    minimumTlsVersion: 'TLS1_2'
  }
  resource blobService 'blobServices' = if (blobName != '') {
    name: blobName
    properties: blobProperties
    resource container 'containers' = if (blobContainerName != '') {
      name: blobContainerName
      properties: blobContainerProperties
    }
  }
}

module storageRbac 'modules/rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: 'sa-rbac-${index}-${uniqueString(deployment().name, location)}'
  dependsOn: [
    storageAccount
  ]
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : 'role assignment'
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : 'ServicePrincipal'
    resourceType: contains(roleAssignment, 'resourceType') ? roleAssignment.resourceType : 'storageAccount'
    name: name
    blobName: blobName
    containerName: blobContainerName
  }
}]


@description('The name of the Storage Account resource')
output name string = name

@description('The ID of the Storage Account. Use this ID to reference the Storage Account in other Azure resource deployments.')
output id string = storageAccount.id


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

type roleAssignmentsArray = {
  description: string?
  roleDefinitionIdOrName: string?
  principalIds: string[]?
  principalType: string?
  resourceType: string?
}[]
