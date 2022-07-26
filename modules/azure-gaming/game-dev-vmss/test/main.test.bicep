module testMain '../main.bicep' = {
  name: 'testMain'
  params: {
    vmssName: 'GEN-UNIQUE-7'
    administratorLogin: 'GEN-UNIQUE'
    passwordAdministratorLogin: 'GEN-PASSWORD'
  }
}
