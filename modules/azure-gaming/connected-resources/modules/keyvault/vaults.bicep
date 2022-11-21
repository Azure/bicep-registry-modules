@description('Deployment Location')
param location string
param name string = 'keyvault-${uniqueString(resourceGroup().id)}'
param subnetID string = ''
param tenantId string = subscription().tenantId
param enableVNet bool = false
param rbacPolicies array = []

@allowed([ 'new', 'existing'])
param newOrExisting string = 'new'
param assignRole bool = true

var rbacSecretsReaderRole = '4633458b-17de-408a-b874-0445c86b69e6'
var rbacCertificateOfficerRole = 'a4417e6f-fecd-4de8-b567-7b0420556985'

var networkAcls = enableVNet ? {
  defaultAction: 'Deny'
  virtualNetworkRules: [
    {
      action: 'Allow'
      id: subnetID
    }
  ]
} : {}

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = if (newOrExisting == 'new') {
  name: take(name, 24)
  location: location
  properties: {
    enableSoftDelete: true
    softDeleteRetentionInDays: 7
    sku: {
      family: 'A'
      name: 'standard'
    }
    enableRbacAuthorization: true
    tenantId: tenantId
    networkAcls: networkAcls
  }
}

resource existingKeyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = if (newOrExisting == 'existing') {
  name: name
}

resource identityRoleAssignDeployment 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for rbacPolicy in rbacPolicies: if (assignRole) {
  name: guid(rbacSecretsReaderRole, rbacPolicy.objectId)
  scope: keyVault
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', rbacSecretsReaderRole)
    principalId: rbacPolicy.objectId
    principalType: 'ServicePrincipal'
  }
}]

resource rbacCertsReader 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for rbacPolicy in rbacPolicies: if (assignRole) {
  name: guid(rbacCertificateOfficerRole, rbacPolicy.objectId)
  scope: keyVault
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', rbacCertificateOfficerRole)
    principalId: rbacPolicy.objectId
    principalType: 'ServicePrincipal'
  }
}]

@description('Key Vault Id')
output id string = newOrExisting == 'new' ? keyVault.id : existingKeyVault.id

@description('Key Vault Name')
output name string = newOrExisting == 'new' ? keyVault.name : existingKeyVault.name
