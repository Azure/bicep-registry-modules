param location string
param name string
param prefix string

resource managedIdentity_01 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: '${prefix}-${name}-01'
  location: location
}

resource managedIdentity_02 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: '${prefix}-${name}-02'
  location: location
}

output identityPrincipalIds array = [
  managedIdentity_01.properties.principalId
  managedIdentity_02.properties.principalId
]
