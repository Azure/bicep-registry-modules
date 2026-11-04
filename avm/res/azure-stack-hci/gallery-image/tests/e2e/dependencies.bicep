@description('Required. Name of the identity used to test image role assignments.')
param name string

@description('Required. Location of the identity.')
param location string

resource identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: name
  location: location
}

@description('The principal ID of the test identity.')
output principalId string = identity.properties.principalId
