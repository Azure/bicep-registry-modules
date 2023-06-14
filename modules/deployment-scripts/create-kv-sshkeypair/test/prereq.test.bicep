param akvName string
param name string
param location string = resourceGroup().location

//Prerequisites
resource akv 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: akvName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    enableSoftDelete: false
    enableRbacAuthorization: true
    accessPolicies: []
  }
}

module uai 'br/public:identity/user-assigned-identity:1.0.1' = {
  name: 'userAssignedIdentity-${uniqueString(resourceGroup().id)}-${location}'
  params: {
    location: location
    name: replace('uai-${name}-${uniqueString(resourceGroup().id)}-${location}', '.', '-')
  }
}

output principalId string = uai.outputs.principalId
output identityName string = uai.outputs.name

output akvName string = akv.name
