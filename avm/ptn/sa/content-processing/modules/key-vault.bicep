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

@description('The name of the Key Vault')
param keyvaultName string

@description('The location of the Key Vault')
param location string

@description('Tags to be applied to the Key Vault')
param tags object

@description('Role assignments for the Key Vault')
param roleAssignments array = []

@description('Enable purge protection for the Key Vault')
param enablePurgeProtection bool = false

@description('Enable soft delete for the Key Vault')
param enableSoftDelete bool = true

@description('Enable vault for disk encryption')
param enableVaultForDiskEncryption bool = true

@description('Enable vault for template deployment')
param enableVaultForTemplateDeployment bool = true

@description('Public network access setting for the Key Vault')
param publicNetworkAccess string = 'Enabled'

@description('SKU of the Key Vault')
param keyvaultsku string = 'standard'

@description('Soft delete retention period in days')
param softDeleteRetentionInDays int = 7

@description('Enable RBAC authorization for the Key Vault')
param enableRbacAuthorization bool = true

@description('Create mode for the Key Vault')
param createMode string = 'default'

@description('Enable telemetry for the Key Vault')
param enableTelemetry bool = true

@description('Network ACLs for the Key Vault')
param networkAcls object = {
  bypass: 'AzureServices'
  defaultAction: 'Deny'
}

// @description('Diagnostic settings for the Key Vault')
// param diagnosticSettings object = {
//   enabled: true
// }

@description('Log Analytics Workspace Resource ID for diagnostic settings')
@secure()
param logAnalyticsWorkspaceResourceId string = ''

module avmKeyVault 'br/public:avm/res/key-vault/vault:0.13.0' = {
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
