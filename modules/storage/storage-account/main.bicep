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

@description('Indicates whether change feed event logging is enabled for the Blob service.')
param changeFeedEnabled bool = false

@description('Versioning is enabled if set to true. ')
param versioningEnabled bool = false

@description('Allows https traffic only to storage service if sets to true.')
param supportHttpsTrafficOnly bool = true

@description('Allow or disallow public access to all blobs or containers in the storage account.')
param allowBlobPublicAccess bool = false

@description('Replication of objects between AAD tenants is allowed or not. For this property, the default interpretation is true.')
param allowCrossTenantReplication bool = false

@description('Allow or disallow public network access to Storage Account. Value is optional but if passed in, must be Enabled or Disabled.')
param publicNetworkAccess string = 'Disabled'

@description('Set the minimum TLS version to be permitted on requests to storage. The default interpretation is TLS 1.0 for this property.')
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
param destPublicNetworkAccess string = 'Disabled'

@description('Set the minimum TLS version to be permitted on requests to storage. The default interpretation is TLS 1.0 for this property.')
param destMinimumTlsVersion string = minimumTlsVersion

@description('It will be deleted after the given amount of days.')
param destDaysAfterLastModification int = 30

@description('Specifies the type of blob to manage the lifecycle policy.')
param destBlobType string = blobType

@description('Indicates whether change feed event logging is enabled for the Blob service.')
param destChangeFeedEnabled bool = true

@description('Versioning is enabled if set to true. To the destination storage account, set true. ')
param destVersioningEnabled bool = true

@description('The SKU name to provide for account creation. Default is Standard_LRS. ')
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

@description('This is the name to provide for objectReplicationPolicies. ')
param policyId string = 'default'

@description('When performing object replication, it must be true and all resources necessary for the destination storage account will be created.')
param objectReplicationPolicy bool = false

@description('Managed Identity name for userAssignedIdentities resource.')
param managedIdentityName string = 'MyManagedIdentity'

@description('It specifies the name or Id of the Role Definitions.')
param roleDefinitionIdOrName string

@description('Define Private Endpoints that should be created for Azure Storage Account.')
param privateEndpoints array = []

@description('Toggle if Private Endpoints manual approval for Azure Storage Account should be enabled.')
param privateEndpointsApprovalEnabled bool = false

var networkAcls = enableVNET ? {
  defaultAction: 'Deny'
  virtualNetworkRules: [
    {
      action: 'Allow'
      id: subnetID
    }
  ]
} : {}

var builtInRoleNames = {
  StorageBlobDataContributor : 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  Reader : 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
}

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

  resource blobServices 'blobServices@2022-09-01' = {
    name: 'default'
    properties: {
        changeFeed: {
            enabled: changeFeedEnabled
        }
        isVersioningEnabled: versioningEnabled
    }

    resource container 'containers@2022-09-01' = {
      name: 'sourcecontainer'
      properties: {
        publicAccess: 'None'
      }
    }
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

resource contributorRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
    scope: subscription()
    name: contains(builtInRoleNames, roleDefinitionIdOrName) ? builtInRoleNames[roleDefinitionIdOrName] : roleDefinitionIdOrName
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2022-01-31-preview' = {
    name: managedIdentityName
    location: location
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
    name: guid(resourceGroup().id, managedIdentity.id, contributorRoleDefinition.id)
    properties: {
        roleDefinitionId: contributorRoleDefinition.id
        principalId: managedIdentity.properties.principalId
        principalType: 'ServicePrincipal'
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
                sourceContainer: 'sourcecontainer'
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

@description('The name of the Storage Account resource')
output name string = name

@description('The ID of the Storage Account. Use this ID to reference the Storage Account in other Azure resource deployments.')
output id string = storageAccount.id
