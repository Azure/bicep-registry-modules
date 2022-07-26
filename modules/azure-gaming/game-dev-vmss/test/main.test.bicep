@description('Deployment Location')
param location string = resourceGroup().location

module testMain '../main.bicep' = {
  name: 'testMain'
  params: {
    location: location
    vmssName: 'GEN-UNIQUE-7'
    administratorLogin: 'GEN-UNIQUE'
    passwordAdministratorLogin: 'GEN-PASSWORD'
  }
}
