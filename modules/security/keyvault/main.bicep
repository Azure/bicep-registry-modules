@description('Deployment Location')
param location string

@description('Name of the Key Vault')
param name string = 'keyvault-${uniqueString(resourceGroup().id)}'

@description('Subnet ID for the Key Vault')
param subnetID string = ''

@description('The tenant ID where the Key Vault is deployed')
param tenantId string = subscription().tenantId

@description('Enable VNet Service Endpoints for Key Vault')
param enableVNet bool = false

@description('List of RBAC policies to assign to the Key Vault')
param rbacPolicies array = []

@allowed([ 'new', 'existing'])
@description('Specifies whether to create a new Key Vault or use an existing one. Use "new" to create a new Key Vault or "existing" to use an existing one.')
param newOrExisting string = 'new'

@description('Enable role assignment for the Key Vault')
param assignRole bool = true

@description('RBAC Role Assignments to apply to each RBAC policy')
param roleAssignments array = [
  '4633458b-17de-408a-b874-0445c86b69e6' // rbacSecretsReaderRole
  'a4417e6f-fecd-4de8-b567-7b0420556985' // rbacCertificateOfficerRole
]

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

module rbacRoleAssignments 'modules/roleAssignment.bicep' = [for rbacRole in roleAssignments: if (assignRole) {
  name: guid(keyVault.name, rbacRole)
  params: {
    keyVaultName: keyVault.name
    rbacPolicies: rbacPolicies
    rbacRole: rbacRole
  }
}]

@description('Key Vault Id')
output id string = keyVault.id

@description('Key Vault Name')
output name string = keyVault.name

