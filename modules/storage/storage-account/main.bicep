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

param changeFeedEnabled bool = false
param versioningEnabled bool = false
param supportHttpsTrafficOnly bool = true
param allowBlobPublicAccess bool = false
param allowCrossTenantReplication bool = false
param publicNetworkAccess string = 'Disabled'
param minimumTlsVersion string = 'TLS1_2'

@description('Prefix of destination Storage Account Resource Name. This param is ignored when name is provided.')
param destPrefix string = 'dt'

@description('Name of destination Storage Account. Must be unique within Azure.')
param destStorageAccountName string = '${destPrefix}${uniqueString(resourceGroup().id, subscription().id)}'

@description('Deployment Location')
param destLocation string

param destKind string
param destSupportHttpsTrafficOnly bool = true
param destAllowBlobPublicAccess bool = false
param destAllowCrossTenantReplication bool = false
param destPublicNetworkAccess string = 'Disabled'
param destMinimumTlsVersion string = 'TLS1_2'

@description('It will be deleted after the given amount of days.')
param destDaysAfterLastModification int = 30

@description('Specifies the type of blob to manage the lifecycle policy.')
param destBlobType string = 'blockBlob'

param destChangeFeedEnabled bool = true
param destVersioningEnabled bool = true
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_ZRS'
  'Standard_RAGRS'
  'Standard_RAGZRS'
])
param destSkuName string

param ruleId  string = ''
param policyId string = 'default'
param sourcePolicy bool = false
param managedIdentityName string
param managedIdentityLocation string
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
  'Storage Blob Data Contributor' : 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  'Reader' : 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
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
}

resource destinationStorageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
    name: destStorageAccountName
    location: destLocation
    sku: {
        name: destSkuName
    }
    kind: destKind
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
}

resource managementpolicy 'Microsoft.Storage/storageAccounts/managementPolicies@2021-04-01' = {
    name: 'default'
    parent: storageAccount
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
                ]}
            }
        }]
        }
    }
}

resource destinationmanagementpolicy 'Microsoft.Storage/storageAccounts/managementPolicies@2021-04-01' = {
    name: 'default'
    parent: destinationStorageAccount
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
                    ]}
                }
            }]
        }
    }
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2022-09-01' = {
    name: 'default'
    parent: storageAccount
    properties: {
        changeFeed: {
            enabled: changeFeedEnabled
        }
        isVersioningEnabled: versioningEnabled
    }
}

resource destinationBlobService 'Microsoft.Storage/storageAccounts/blobServices@2022-09-01' = {
    name: 'default'
    parent: destinationStorageAccount
    properties: {
        changeFeed: {
            enabled: destChangeFeedEnabled
        }
        isVersioningEnabled: destVersioningEnabled
    }
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
    name: 'sourcecontainer'
    parent: blobService
    properties: {
        publicAccess: 'None'
    }
}

resource destinationContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
    name: 'destinationcontainer'
    parent: destinationBlobService
    properties: {
        publicAccess: 'None'
    }
}

resource contributorRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
    scope: subscription()
    name: contains(builtInRoleNames, roleDefinitionIdOrName) ? builtInRoleNames[roleDefinitionIdOrName] : roleDefinitionIdOrName
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2022-01-31-preview' = {
    name: managedIdentityName
    location: managedIdentityLocation
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
    name: guid(resourceGroup().id, managedIdentity.id, contributorRoleDefinition.id)
    properties: {
        roleDefinitionId: contributorRoleDefinition.id
        principalId: managedIdentity.properties.principalId
        principalType: 'ServicePrincipal'
    }
}

resource destinationOrPolicy 'Microsoft.Storage/storageAccounts/objectReplicationPolicies@2022-09-01' = if (!sourcePolicy) {
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

resource sourceOrPolicy 'Microsoft.Storage/storageAccounts/objectReplicationPolicies@2022-09-01' = if (sourcePolicy) {
    name: policyId
    parent: storageAccount
    properties: {
        sourceAccount: destinationStorageAccount.id
        destinationAccount: storageAccount.id
        rules: [
            {
                destinationContainer: 'sourcecontainer'
                sourceContainer: 'destinationcontainer'
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
