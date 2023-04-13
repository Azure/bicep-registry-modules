param storageRoleId string
param storageAccountName string
param uaiPrincipalId string

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' existing = {
  name: storageAccountName
}

@description('Assign executor role to identity')
resource grantExecutorRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('${resourceGroup().name}-${storageAccountName}-${uaiPrincipalId}-${storageRoleId}')
  scope: storageAccount
  properties: {
    roleDefinitionId: storageRoleId
    principalId: uaiPrincipalId
    principalType: 'ServicePrincipal'
  }
}
