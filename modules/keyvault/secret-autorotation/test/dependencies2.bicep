targetScope = 'resourceGroup'

param location string = resourceGroup().location
param name string
param now string = utcNow()

var prefix = 'dep2'
var websiteContirbutorRoleId = resourceId('Microsoft.Authorization/roleDefinitions', 'de139f84-1756-47ae-9be6-808fbbe84772')

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

@description('CosmosDB')
resource cosmosdb 'Microsoft.DocumentDB/databaseAccounts@2022-08-15' = {
  name: '${prefix}-cosmosdb-${name}'
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
    publicNetworkAccess: 'enabled'
    accessPolicies: []
    enableSoftDelete: false
    softDeleteRetentionInDays: 7
  }

  resource secret1 'secrets' = {
    name: 'secret1'
    tags: {
      ValidityPeriodDays: '90'
      CredentialId: 'Primary'
      ProviderAddress: cosmosdb.id
    }
    properties: {
      attributes: {
        exp: dateTimeToEpoch(dateTimeAdd(now, 'P90D'))
      }
      value: 'test1'
    }
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
}

output cosmosdbName string = cosmosdb.name

output keyvaultName string = keyvault.name

output secretName string = keyvault::secret1.name

output storageAccountName string = storageAccount.name

output workspaceId string = workspace.id

output identityName string = userAssignedIdentity.name
