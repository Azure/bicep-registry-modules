provider microsoftGraph

@description('Required. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Azure AD group to create.')
param entraIdGroupName string

@description('Required. The name of the managed identity to create.')
param managedIdentityName string

var entraIdGroupmailNickname = replace(entraIdGroupName, ' ', '')

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: managedIdentityName
  location: location
}

resource entraIdGroup 'Microsoft.Graph/groups@v1.0' = {
  displayName: entraIdGroupName
  mailEnabled: false
  mailNickname: entraIdGroupmailNickname
  securityEnabled: true
  uniqueName: entraIdGroupName
}

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

output entraIdGroupDisplayName string = entraIdGroup.displayName
