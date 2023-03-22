@description('Deployment Location')
param location string

@description('Prefix of Cosmos DB Resource Name')
param prefix string = 'kv'

@description('Name of the Key Vault')
param name string = '${prefix}-${uniqueString(resourceGroup().id)}'

@description('Subnet ID for the Key Vault')
param subnetID string = ''

@description('The tenant ID where the Key Vault is deployed')
param tenantId string = subscription().tenantId

@description('Enable VNet Service Endpoints for Key Vault')
param enableVNet bool = false

@description('List of RBAC policies to assign to the Key Vault')
param rbacPolicies array = []

@description('RBAC Role Assignments to apply to each RBAC policy')
param roleAssignments array = [
  '4633458b-17de-408a-b874-0445c86b69e6' // rbacSecretsReaderRole
  'a4417e6f-fecd-4de8-b567-7b0420556985' // rbacCertificateOfficerRole
]

@allowed([ 'new', 'existing' ])
@description('Whether to create a new Key Vault or use an existing one')
param newOrExisting string = 'new'

@description('List of secrets to create in the Key Vault [ { secretName: string, secretValue: string }]')
param secrets array = []

@description('For an existing Managed Identity, the Subscription Id it is located in')
param existingSubscriptionId string = subscription().subscriptionId

@description('For an existing Managed Identity, the Resource Group it is located in')
param existingResourceGroupName string = resourceGroup().name

@description('Specifies whether soft delete should be enabled for the Key Vault.')
param enableSoftDelete bool = true

@description('The number of days to retain deleted data in the Key Vault.')
param softDeleteRetentionInDays int = 7

@allowed(['standard', 'premium'])
@description('The SKU name of the Key Vault.')
param skuName string = 'standard'

@allowed(['A', 'B'])
@description('The SKU family of the Key Vault.')
param skuFamily string = 'A'

@description('Specifies whether RBAC authorization should be enabled for the Key Vault.')
param enableRbacAuthorization bool = true

var networkAcls = enableVNet ? {
  defaultAction: 'Deny'
  virtualNetworkRules: [
    {
      action: 'Allow'
      id: subnetID
    }
  ]
} : {}

resource newKeyVault 'Microsoft.KeyVault/vaults@2022-07-01' = if (newOrExisting == 'new') {
  name: take(name, 24)
  location: location
  properties: {
    enableSoftDelete: enableSoftDelete
    softDeleteRetentionInDays: softDeleteRetentionInDays
    sku: {
      family: skuFamily
      name: skuName
    }
    enableRbacAuthorization: enableRbacAuthorization
    tenantId: tenantId
    networkAcls: networkAcls
  }
}

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: take(name, 24)
  scope: resourceGroup(existingSubscriptionId, existingResourceGroupName)
}

module rbacRoleAssignments 'modules/roleAssignment.bicep' = [for rbacRole in roleAssignments: {
  name: guid(keyVault.name, rbacRole)
  params: {
    keyVaultName: keyVault.name
    rbacPolicies: rbacPolicies
    rbacRole: rbacRole
  }
}]

module secret 'modules/secrets.bicep' = {
  name: guid(keyVault.name, 'secrets')
  params: {
    keyVaultName: keyVault.name
    secrets: secrets
  }
}

@description('Key Vault Id')
output id string = keyVault.id

@description('Key Vault Name')
output name string = keyVault.name
