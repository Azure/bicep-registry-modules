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

module flexibleServer 'br/public:avm/res/db-for-postgre-sql/flexible-server:0.13.2' = {
  name: '${uniqueString(deployment().name, location)}-flexibleServer'
  params: {
    name: primaryServerName
    location: location
    tier: 'GeneralPurpose'
    skuName: 'Standard_D2s_v3'
    version: '17'
    administrators: [
      {
        objectId: managedIdentity.properties.clientId
        principalName: managedIdentity.name
        principalType: 'ServicePrincipal'
      }
    ]
    storageSizeGB: 512
    autoGrow: 'Enabled'
    backupRetentionDays: 7
    geoRedundantBackup: 'Disabled'
    availabilityZone: -1
  }
}

@description('The client ID of the created Managed Identity.')
output managedIdentityClientId string = managedIdentity.properties.clientId

@description('The name of the created Managed Identity.')
output managedIdentityName string = managedIdentity.name

@description('The resource ID of the primary server.')
output serverResourceId string = flexibleServer.outputs.resourceId

@description('The principal ID of the managed identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId
