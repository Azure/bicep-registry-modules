@description('Deployment Location')
param location string

@description('Prefix of Cosmos DB Resource Name')
param prefix string = 'kv'

@description('Name of the Key Vault')
param name string = '${prefix}-${uniqueString(resourceGroup().id)}'

@description('The tenant ID where the Key Vault is deployed')
param tenantId string = subscription().tenantId

@description('For an existing Managed Identity, the Subscription Id it is located in')
param subscriptionId string = subscription().subscriptionId

@description('For an existing Managed Identity, the Resource Group it is located in')
param resourceGroupName string = resourceGroup().name

@description('Subnet ID for the Key Vault')
param subnetID string = ''

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

@description('Name of Secret to add to Key Vault')
param secretName string = 'secret${uniqueString(resourceGroup().id)}'

@secure()
@description('Value of Secret to add to Key Vault')
param secretValue string = ''

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

module keyVault 'modules/vaults.bicep' = {
  name: guid(name, 'deploy')
  scope: resourceGroup(subscriptionId, resourceGroupName)
  params: {
    location: location
    newOrExisting: newOrExisting
    enableSoftDelete: enableSoftDelete
    softDeleteRetentionInDays: softDeleteRetentionInDays
    skuFamily: skuFamily
    skuName: skuName
    enableRbacAuthorization: enableRbacAuthorization
    tenantId: tenantId
    subnetID: subnetID
    enableVNet: subnetID != ''
  }
}

module rbacRoleAssignments 'modules/roleAssignment.bicep' = [for rbacRole in roleAssignments: {
  name: guid(keyVault.name, rbacRole)
  scope: resourceGroup(subscriptionId, resourceGroupName)
  params: {
    keyVaultName: keyVault.name
    rbacPolicies: rbacPolicies
    rbacRole: rbacRole
  }
}]

module secret 'modules/secrets.bicep' = if (secretName != '' && secretValue != '') {
  name: guid(keyVault.name, 'secrets')
  scope: resourceGroup(subscriptionId, resourceGroupName)
  params: {
    keyVaultName: keyVault.name
    secretName: secretName
    secretValue: secretValue
  }
}

@description('Key Vault Id')
output id string = keyVault.outputs.id

@description('Key Vault Name')
output name string = keyVault.outputs.name
