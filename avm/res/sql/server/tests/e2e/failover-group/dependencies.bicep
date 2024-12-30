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
}

@description('The name of the deployed secondary server.')
output secondaryServerName string = server.name
