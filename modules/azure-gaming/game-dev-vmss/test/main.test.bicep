param location                   string = resourceGroup().location
param vmssName                   string = take(uniqueString(newGuid()),13)
param administratorLogin         string = 'dcibadmin'
param passwordAdministratorLogin string = 'B1gD6taB1gD6ta'

module testMain '../main.bicep' = {
  name: 'testMain'
  params: {
    location                  : location
    vmssName                  : vmssName
    administratorLogin        : administratorLogin
    passwordAdministratorLogin: passwordAdministratorLogin
  }
}
