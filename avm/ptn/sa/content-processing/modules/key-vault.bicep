metadata name = 'Key Vault Module'
// ========== Key Vault Module ========== //
// param name string
// param location string
// param tags object
// param roleAssignments array = []
// param enablePurgeProtection bool = false
// param enableSoftDelete bool = true
// param enableVaultForDiskEncryption  bool =   true
// param enableVaultForTemplateDeployment bool = true
// param publicNetworkAccess string = 'Enabled'
// param vaultsku string = 'standard'
// param softDeleteRetentionInDays int = 7
// param enableRbacAuthorization bool = true
// param createMode string = 'default'
// param enableTelemetry bool = true

@description('Required. The name of the Key Vault.')
param keyvaultName string

@description('Required. The location of the Key Vault.')
param location string

@description('Required. Tags to be applied to the Key Vault.')
param tags object

@description('Optional. Role assignments for the Key Vault.')
param roleAssignments array = []

@description('Optional. Enable purge protection for the Key Vault.')
param enablePurgeProtection bool = false

@description('Optional. Enable soft delete for the Key Vault.')
param enableSoftDelete bool = true

@description('Optional. Enable vault for disk encryption.')
param enableVaultForDiskEncryption bool = true

@description('Optional. Enable vault for template deployment.')
param enableVaultForTemplateDeployment bool = true

@description('Optional. Public network access setting for the Key Vault.')
param publicNetworkAccess string = 'Enabled'

@description('Optional. SKU of the Key Vault.')
param keyvaultsku string = 'standard'

@description('Optional. Soft delete retention period in days.')
param softDeleteRetentionInDays int = 7

@description('Optional. Enable RBAC authorization for the Key Vault.')
param enableRbacAuthorization bool = true

@description('Optional. Create mode for the Key Vault.')
param createMode string = 'default'

@description('Optional. Enable telemetry for the Key Vault.')
param enableTelemetry bool = true

@description('Optional. Network ACLs for the Key Vault.')
param networkAcls object = {
  bypass: 'AzureServices'
  defaultAction: 'Deny'
}

// @description('Diagnostic settings for the Key Vault')
// param diagnosticSettings object = {
//   enabled: true
// }

@description('Optional. Log Analytics Workspace Resource ID for diagnostic settings.')
@secure()
param logAnalyticsWorkspaceResourceId string = ''

module avmKeyVault 'br/public:avm/res/key-vault/vault:0.13.3' = {
  name: 'deploy_keyvault'
  params: {
    name: keyvaultName
    location: location
    tags: tags
    roleAssignments: roleAssignments
    enablePurgeProtection: enablePurgeProtection
    enableSoftDelete: enableSoftDelete
    enableVaultForDiskEncryption: enableVaultForDiskEncryption
    enableVaultForTemplateDeployment: enableVaultForTemplateDeployment
    publicNetworkAccess: publicNetworkAccess
    sku: keyvaultsku
    softDeleteRetentionInDays: softDeleteRetentionInDays
    enableRbacAuthorization: enableRbacAuthorization
    createMode: createMode
    enableTelemetry: enableTelemetry
    diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspaceResourceId }]
    networkAcls: networkAcls
  }
}

// Adding additional resource deployment for WAF enabled

output resourceId string = avmKeyVault.outputs.resourceId
output vaultUri string = avmKeyVault.outputs.uri
