param privateLinkScopeName string
param location string

resource privateLinkScope 'Microsoft.HybridCompute/privateLinkScopes@2023-10-03-preview' = {
  name: privateLinkScopeName
  location: location
  tags: {
    'hidden-title': 'This is visible in the resource name'
    Environment: 'Non-Prod'
    Role: 'DeploymentValidation'
  }
  properties: {
    publicNetworkAccess: 'Enabled'
  }
}

output privateLinkScopeResourceId string = privateLinkScope.id
