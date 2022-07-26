param location                   string = resourceGroup().location
param vmssName                   string = 'take(crtest${uniqueString(newGuid())},7)'
param administratorLogin         string = 'stubAdmLog'
param passwordAdministratorLogin string = 'crtest${uniqueString(newGuid())}'

module testMain '../main.bicep' = {
  name: 'testMain'
  params: {
    location                  : location
    vmssName                  : vmssName
    administratorLogin        : administratorLogin
    passwordAdministratorLogin: passwordAdministratorLogin
  }
}
