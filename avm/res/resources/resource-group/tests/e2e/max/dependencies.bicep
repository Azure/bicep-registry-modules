@description('Optional. The location to deploy to.')
param location string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
  tags: {
    Environment: 'Non-Prod'
    Role: 'DeploymentValidation'
  }
}

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId
