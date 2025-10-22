@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the primary PostgreSQL server.')
param primaryServerName string

#disable-next-line use-recent-api-versions
resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: managedIdentityName
  location: location
}

resource flexibleServer 'Microsoft.DBforPostgreSQL/flexibleServers@2025-06-01-preview' = {
  name: primaryServerName
  location: location
  sku: {
    tier: 'GeneralPurpose'
    name: 'Standard_D2s_v3'
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {
    version: '17'
    authConfig: {
      activeDirectoryAuth: 'Enabled'
      passwordAuth: 'Disabled'
    }
    storage: {
      storageSizeGB: 512
      autoGrow: 'Enabled'
    }
    backup: {
      backupRetentionDays: 7
      geoRedundantBackup: 'Disabled'
    }
    replicationRole: 'Primary'
    availabilityZone: '1'
  }
}

// Configure Azure AD administrator for the server
resource administrator 'Microsoft.DBforPostgreSQL/flexibleServers/administrators@2025-06-01-preview' = {
  parent: flexibleServer
  name: managedIdentity.name
  properties: {
    principalType: 'ServicePrincipal'
    principalName: managedIdentity.properties.principalId
    tenantId: tenant().tenantId
  }
}

@description('The client ID of the created Managed Identity.')
output managedIdentityClientId string = managedIdentity.properties.clientId

@description('The name of the created Managed Identity.')
output managedIdentityName string = managedIdentity.name

@description('The resource ID of the primary server.')
output serverResourceId string = flexibleServer.id

@description('The principal ID of the managed identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId
