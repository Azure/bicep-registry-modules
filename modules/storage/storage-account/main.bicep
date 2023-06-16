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

@description('It will be moved to the cool tier after the given amount of days.')
param daysAfterLastModification int = 30

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

@description('Prefix of destination Storage Account Resource Name. This param is ignored when name is provided.')
param destPrefix string = 'dt'

@description('Name of destination Storage Account. Must be unique within Azure.')
param destStorageAccountName string = '${destPrefix}${uniqueString(resourceGroup().id, subscription().id)}'

@description('Destination Storage Account Location.')
param destLocation string = location

@description('Allows https traffic only to storage service if sets to true.')
param destSupportHttpsTrafficOnly bool = true

@description('Allow or disallow public access to all blobs or containers in the destination storage account.')
param destAllowBlobPublicAccess bool = false

@description('Replication of objects between AAD tenants is allowed or not. For this property, the default interpretation is true.')
param destAllowCrossTenantReplication bool = false

@description('Allow or disallow public network access to Storage Account. Value is optional but if passed in, must be Enabled or Disabled.')
@allowed([
  'Enabled'
  'Disabled'
])
param destPublicNetworkAccess string = 'Disabled'

@description('Set the minimum TLS version to be permitted on requests to storage. The default interpretation is TLS 1.0 for this property.')
@allowed([
  'TLS1_0'
  'TLS1_1'
  'TLS1_2'
])
param destMinimumTlsVersion string = minimumTlsVersion

@description('It will be deleted after the given amount of days.')
param destDaysAfterLastModification int = 30

@description('Specifies the type of blob to manage the lifecycle policy.')
param destBlobType string = blobType

@description('Indicates whether change feed event logging is enabled for the Blob service.')
param destChangeFeedEnabled bool = true

@description('Versioning is enabled if set to true. To the destination storage account, set true.')
param destVersioningEnabled bool = true

@description('The SKU name to provide for account creation. Default is Standard_LRS.')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_ZRS'
  'Standard_RAGRS'
  'Standard_RAGZRS'
])
param destSkuName string = 'Standard_LRS'

@description('Rule Id is auto-generated for each new rule on destination account. It is required for put policy on source account.')
param ruleId  string = ''

@description('This is the name to provide for objectReplicationPolicies.')
param policyId string = 'default'

@description('When performing object replication, it must be true and all resources necessary for the destination storage account will be created.')
param objectReplicationPolicy bool = false

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

  resource managementpolicy 'managementPolicies@2021-04-01' = {
    name: 'default'
    properties: {
      policy: {
        rules: [
        {
          enabled: true
          name: 'move-to-cool'
          type: 'Lifecycle'
          definition: {
          actions: {
            baseBlob: {
              tierToCool: {
                daysAfterModificationGreaterThan: daysAfterLastModification
                }
            }
          }
          filters: {
            blobTypes: [
              blobType
              ]
            }
          }
        }]
      }
    }
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

resource destinationStorageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = if(objectReplicationPolicy) {
    name: destStorageAccountName
    location: destLocation
    sku: {
        name: destSkuName
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
      supportsHttpsTrafficOnly: destSupportHttpsTrafficOnly
      allowBlobPublicAccess: destAllowBlobPublicAccess
      allowCrossTenantReplication: destAllowCrossTenantReplication
      publicNetworkAccess: destPublicNetworkAccess
      minimumTlsVersion: destMinimumTlsVersion
    }

    resource destinationBlobService 'blobServices@2022-09-01' = {
      name: 'default'
      properties: {
        changeFeed: {
          enabled: destChangeFeedEnabled
        }
        isVersioningEnabled: destVersioningEnabled
      }

      resource destinationContainer 'containers@2022-09-01' = {
        name: 'destinationcontainer'
        properties: {
          publicAccess: 'None'
        }
      }
    }

    resource destinationmanagementpolicy 'managementPolicies@2021-04-01' = {
      name: 'default'
      properties: {
        policy: {
          rules: [
          {
            enabled: true
            name: 'delete'
            type: 'Lifecycle'
            definition: {
            actions: {
              baseBlob: {
                delete: {
                  daysAfterModificationGreaterThan: destDaysAfterLastModification
                }
              }
            }
            filters: {
              blobTypes: [
                destBlobType
              ]
            }
            }
          }]
        }
      }
    }
}

resource destinationOrPolicy 'Microsoft.Storage/storageAccounts/objectReplicationPolicies@2022-09-01' = if (objectReplicationPolicy) {
    name: policyId
    parent: destinationStorageAccount
    properties: {
        sourceAccount: storageAccount.id
        destinationAccount: destinationStorageAccount.id
        rules: [
            {
                destinationContainer: 'destinationcontainer'
                sourceContainer: blobContainerName
                ruleId: ((ruleId == '' ) ? null : ruleId)
            }
        ]
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
