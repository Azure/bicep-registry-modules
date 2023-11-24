@description('Required. The name of the server.')
param serverName string

@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Optional. The password to leverage for the login.')
@secure()
param password string = newGuid()

resource server 'Microsoft.Sql/servers@2021-11-01' = {
  name: serverName
  location: location
  properties: {
    administratorLogin: 'adminUserName'
    administratorLoginPassword: password
  }

  resource database 'databases@2021-11-01' = {
    name: 'db1'
    location: location
    sku: {
      name: 'Basic'
      tier: 'Basic'
    }
    properties: {
      maxSizeBytes: 2147483648
    }
  }
}

@description('The resource ID of the created database.')
output databaseResourceId string = server::database.id

@description('The name of the created database.')
output databaseName string = server::database.name
