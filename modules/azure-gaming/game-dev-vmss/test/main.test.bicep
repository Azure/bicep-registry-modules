param location string = resourceGroup().location
param vmssName string = 'bicep'
param administratorLogin string = 'dcibadmin'
@secure()
param passwordAdministratorLogin string = newGuid()

module testMain '../main.bicep' = {
  name: 'testMain'
  params: {
    location                  : location
    vmssName                  : vmssName
    administratorLogin        : administratorLogin
    passwordAdministratorLogin: passwordAdministratorLogin
  }
}
