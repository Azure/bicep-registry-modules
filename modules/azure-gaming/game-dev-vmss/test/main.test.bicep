param location string = resourceGroup().location
param vmssName string = 'vmss${take(uniqueString(newGuid()), 9)}'
param administratorLogin string = 'dcibadmin'
@secure()
param passwordAdministratorLogin string = newGuid()
param subnetName string = 'sub${uniqueString(newGuid())}'

module testMain '../main.bicep' = {
  name: 'testMain'
  params: {
    location                  : location
    vmssName                  : vmssName
    administratorLogin        : administratorLogin
    passwordAdministratorLogin: passwordAdministratorLogin
    subnetName                : subnetName
  }
}
