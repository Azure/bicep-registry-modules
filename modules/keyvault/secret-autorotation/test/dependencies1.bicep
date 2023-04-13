targetScope = 'resourceGroup'

param location string = resourceGroup().location
param name string
param now string = utcNow()

var prefix = 'dep1'
var websiteContirbutorRoleId = resourceId('Microsoft.Authorization/roleDefinitions', 'de139f84-1756-47ae-9be6-808fbbe84772')
var blobPrivateDnsZoneName = 'privatelink.blob.${environment().suffixes.storage}'
var filePrivateDnsZoneName = 'privatelink.file.${environment().suffixes.storage}'
var redisPrivateDnsZoneName = 'privatelink.redis.cache.windows.net'

@description('User assigned identity to execute deployment script.')
resource userAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: '${prefix}-${name}-user-assigned-identity'
  location: location
}

@description('Assign executor role to identity')
resource grantExecutorRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('${prefix}${userAssignedIdentity.name}${websiteContirbutorRoleId}')
  scope: resourceGroup()
  properties: {
    roleDefinitionId: websiteContirbutorRoleId
    principalId: userAssignedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

@description('Virtual network')
resource vnet 'Microsoft.Network/virtualNetworks@2022-05-01' = {
  name: '${prefix}-vnet-${name}'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
  }

  resource kvSubnet 'subnets' = {
    name: 'kv'
    properties: {
      addressPrefix: '10.0.1.0/24'
    }
  }

  resource cosmosdbSubnet 'subnets' = {
    name: 'cosmosdb'
    dependsOn: [
      kvSubnet
    ]
    properties: {
      addressPrefix: '10.0.2.0/24'
    }
  }

  resource funcSubnet 'subnets' = {
    name: 'function-app'
    dependsOn: [
      cosmosdbSubnet
    ]
    properties: {
      addressPrefix: '10.0.3.0/24'
      delegations: [
        {
          name: 'Delegation'
          properties: {
            serviceName: 'Microsoft.Web/serverfarms'
          }
        }
      ]
      serviceEndpoints: [
        {
          service: 'Microsoft.Storage'
        }
      ]
    }
  }

  resource storageSubnet 'subnets' = {
    name: 'storage'
    dependsOn: [
      funcSubnet
    ]
    properties: {
      addressPrefix: '10.0.4.0/24'
      serviceEndpoints: [
        {
          service: 'Microsoft.Storage'
        }
      ]
    }
  }

  resource redisSubnet 'subnets' = {
    name: 'redis'
    dependsOn: [
      storageSubnet
    ]
    properties: {
      addressPrefix: '10.0.5.0/24'
    }
  }
}

@description('CosmosDB private endpoint')
resource cosmosdbPrivateEndpoint 'Microsoft.Network/privateEndpoints@2022-05-01' = {
  name: '${prefix}-${cosmosdb1.name}-pe'
  location: location
  properties: {
    subnet: {
      id: vnet::cosmosdbSubnet.id
    }
    privateLinkServiceConnections: [
      {
        name: '${prefix}-${cosmosdb1.name}-pe'
        properties: {
          privateLinkServiceId: cosmosdb1.id
          groupIds: [
            'Sql'
          ]
        }
      }
    ]
  }
}

@description('CosmosDB1')
resource cosmosdb1 'Microsoft.DocumentDB/databaseAccounts@2022-08-15' = {
  name: '${prefix}-cosmosdb-${name}-1'
  location: location
  kind: 'GlobalDocumentDB'
  properties: {
    databaseAccountOfferType: 'Standard'
    locations: [
      {
        locationName: 'East US'
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
    publicNetworkAccess: 'Enabled'
  }
}

@description('CosmosDB2')
resource cosmosdb2 'Microsoft.DocumentDB/databaseAccounts@2022-08-15' = {
  name: '${prefix}-cosmosdb-${name}-2'
  location: location
  kind: 'GlobalDocumentDB'
  properties: {
    databaseAccountOfferType: 'Standard'
    locations: [
      {
        locationName: 'East US'
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
    publicNetworkAccess: 'Disabled'
  }
}

@description('Keyvault private endpoint')
resource kvPrivateEndpoint 'Microsoft.Network/privateEndpoints@2022-05-01' = {
  name: '${prefix}-${keyvault.name}-pe'
  location: location
  properties: {
    subnet: {
      id: vnet::kvSubnet.id
    }
    privateLinkServiceConnections: [
      {
        name: '${prefix}-${keyvault.name}-pe'
        properties: {
          privateLinkServiceId: keyvault.id
          groupIds: [
            'vault'
          ]
        }
      }
    ]
  }
}

@description('Key vault')
resource keyvault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: '${prefix}-kv-${name}'
  location: location
  properties: {
    sku: {
      name: 'standard'
      family: 'A'
    }
    tenantId: tenant().tenantId
    publicNetworkAccess: 'disabled'
    accessPolicies: []
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
    }
    enableSoftDelete: false
    softDeleteRetentionInDays: 7
  }

  resource secret1 'secrets' = {
    name: 'secret1'
    tags: {
      ValidityPeriodDays: '90'
      CredentialId: 'Primary'
      ProviderAddress: cosmosdb1.id
    }
    properties: {
      attributes: {
        exp: dateTimeToEpoch(dateTimeAdd(now, 'P90D'))
      }
      value: 'test1'
    }
  }
}

resource topic 'Microsoft.EventGrid/systemTopics@2022-06-15' = {
  name: '${prefix}-kv-topic'
  location: location
  properties: {
    source: keyvault.id
    topicType: 'microsoft.keyvault.vaults'
  }
}

resource workspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: '${prefix}-workspace-${name}'
  location: location
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: '${prefix}sa${name}'
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: [
        {
          id: vnet::storageSubnet.id
          action: 'Allow'
        }
        {
          id: vnet::funcSubnet.id
          action: 'Allow'
        }
      ]
      defaultAction: 'Deny'
    }
    accessTier: 'Hot'
  }
}

resource filePrivateEndpoint 'Microsoft.Network/privateEndpoints@2022-07-01' = {
  name: '${prefix}-${storageAccount.name}-file-pep'
  location: location
  properties: {
    subnet: {
      id: vnet::storageSubnet.id
    }
    privateLinkServiceConnections: [
      {
        name: '${prefix}-${storageAccount.name}-file-pep'
        properties: {
          groupIds: [
            'file'
          ]
          privateLinkServiceId: storageAccount.id
          privateLinkServiceConnectionState: {
            status: 'Approved'
            description: 'Auto-Approved'
            actionsRequired: 'None'
          }
        }
      }
    ]
  }
}

resource blobPrivateEndpoint 'Microsoft.Network/privateEndpoints@2022-07-01' = {
  name: '${prefix}-${storageAccount.name}-blob-pep'
  location: location
  properties: {
    subnet: {
      id: vnet::storageSubnet.id
    }
    privateLinkServiceConnections: [
      {
        name: '${prefix}-${storageAccount.name}-blob-pep'
        properties: {
          groupIds: [
            'blob'
          ]
          privateLinkServiceId: storageAccount.id
          privateLinkServiceConnectionState: {
            status: 'Approved'
            description: 'Auto-Approved'
            actionsRequired: 'None'
          }
        }
      }
    ]
  }
}

resource blobPrivateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: blobPrivateDnsZoneName
  location: 'global'
}

resource privateEndpointDns 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2022-01-01' = {
  parent: blobPrivateEndpoint
  name: 'blob-PrivateDnsZoneGroup'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: blobPrivateDnsZoneName
        properties: {
          privateDnsZoneId: blobPrivateDnsZone.id
        }
      }
    ]
  }
}

resource blobPrivateDnsZoneVnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: blobPrivateDnsZone
  name: uniqueString(storageAccount.id)
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnet.id
    }
  }
}

resource filePrivateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: filePrivateDnsZoneName
  location: 'global'
}

resource filePrivateEndpointDns 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2022-01-01' = {
  parent: filePrivateEndpoint
  name: 'flie-PrivateDnsZoneGroup'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: filePrivateDnsZoneName
        properties: {
          privateDnsZoneId: filePrivateDnsZone.id
        }
      }
    ]
  }
}

resource filePrivateDnsZoneVnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: filePrivateDnsZone
  name: uniqueString(storageAccount.id)
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnet.id
    }
  }
}

resource redis 'Microsoft.Cache/redis@2022-06-01' = {
  name: '${prefix}-redis-${name}'
  location: location
  properties: {
    sku: {
      name: 'Basic'
      family: 'C'
      capacity: 1
    }
  }
}

resource redisPrivateEndpoint 'Microsoft.Network/privateEndpoints@2022-07-01' = {
  name: '${prefix}-${redis.name}-pep'
  location: location
  properties: {
    subnet: {
      id: vnet::redisSubnet.id
    }
    privateLinkServiceConnections: [
      {
        name: '${prefix}-${redis.name}-pep'
        properties: {
          groupIds: [
            'redisCache'
          ]
          privateLinkServiceId: redis.id
          privateLinkServiceConnectionState: {
            status: 'Approved'
            description: 'Auto-Approved'
            actionsRequired: 'None'
          }
        }
      }
    ]
  }
}

resource redisPrivateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: redisPrivateDnsZoneName
  location: 'global'
}

resource redisEndpointDns 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2022-01-01' = {
  parent: redisPrivateEndpoint
  name: 'redis-PrivateDnsZoneGroup'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: redisPrivateDnsZoneName
        properties: {
          privateDnsZoneId: redisPrivateDnsZone.id
        }
      }
    ]
  }
}

resource redisPrivateDnsZoneVnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: redisPrivateDnsZone
  name: uniqueString(redis.id)
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnet.id
    }
  }
}

output cosmosdbName1 string = cosmosdb1.name

output cosmosdbName2 string = cosmosdb2.name

output keyvaultName string = keyvault.name

output secretName1 string = keyvault::secret1.name

output functionAppSubnetId string = vnet::funcSubnet.id

output storageAccountName string = storageAccount.name

output workspaceId string = workspace.id

output identityName string = userAssignedIdentity.name

output topicName string = topic.name

output redisName string = redis.name
