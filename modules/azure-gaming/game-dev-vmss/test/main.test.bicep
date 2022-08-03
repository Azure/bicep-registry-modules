param location                   string = resourceGroup().location
param vmssName                   string = concat('vmss',take(uniqueString(newGuid()),9))
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
