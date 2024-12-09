@description('Required. The name of the Private Link Scope to create.')
param privateLinkScopeName string

@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

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

@description('The resource ID of the created Private Link Scope.')
output privateLinkScopeResourceId string = privateLinkScope.id
