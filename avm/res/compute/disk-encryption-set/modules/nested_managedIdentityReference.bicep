@description('Required. The name of the User Assigned Identity to fetch the principal ID from.')
param userAssignedIdentityName string

@description('Optional. Resource location.')
param location string = resourceGroup().location

resource userAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: userAssignedIdentityName
  location: location
}

output principalId string = userAssignedIdentity.properties.principalId
