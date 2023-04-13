param scriptExecutorRoleId string
param functionAppName string
param uaiPrincipalId string

resource site 'Microsoft.Web/sites@2022-03-01' existing = {
  name: functionAppName
}

@description('Assign executor role to identity')
resource grantExecutorRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('${resourceGroup().name}${site.name}${uaiPrincipalId}${scriptExecutorRoleId}')
  scope: site
  properties: {
    roleDefinitionId: scriptExecutorRoleId
    principalId: uaiPrincipalId
    principalType: 'ServicePrincipal'
  }
}
