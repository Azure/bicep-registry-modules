param location string = resourceGroup().location
param vmssName string = 'vmss${take(uniqueString(deployment().name, location), 9)}'
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
