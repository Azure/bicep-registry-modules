//==============================================================================
// Parameters
//==============================================================================

@description('Required. Name of the hub. Used to ensure unique resource names.')
param hubName string = ''

@description('Required. Suffix to add to the KeyVault instance name to ensure uniqueness.')
param uniqueSuffix string = ''

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Array of access policies object.')
param accessPolicies array = []

@description('Required. Name of the storage account to store access keys for.')
param storageAccountName string

@description('Optional. Specifies the SKU for the vault.')
@allowed([
  'premium'
  'standard'
])
param sku string = 'premium'

@description('Optional. Resource tags.')
param tags object?

@description('Optional. Tags to apply to resources based on their resource type. Resource type specific tags will be merged with tags for all resources.')
param tagsByResource object = {}

//------------------------------------------------------------------------------
// Variables
//------------------------------------------------------------------------------

// Generate globally unique KeyVault name: 3-24 chars; letters, numbers, dashes
var keyVaultPrefix = '${replace(hubName, '_', '-')}-vault'
var keyVaultSuffix = '-${uniqueSuffix}'
var keyVaultName = replace('${take(keyVaultPrefix, 24 - length(keyVaultSuffix))}${keyVaultSuffix}', '--', '-')

var formattedAccessPolicies = [
  for accessPolicy in accessPolicies: {
    applicationId: accessPolicy.?applicationId ?? ''
    objectId: accessPolicy.?objectId ?? ''
    permissions: accessPolicy.permissions
    tenantId: accessPolicy.?tenantId ?? tenant().tenantId
  }
]

//==============================================================================
// Resources
//==============================================================================

module keyVault 'br/public:avm/res/key-vault/vault:0.5.1' = {
  name: '${uniqueString(deployment().name, location)}-keyvault'
  params: {
    name: keyVaultName
    location: location
    tags: union(tags ?? {}, tagsByResource[?'Microsoft.KeyVault/vaults'] ?? {})
    enableVaultForDeployment: true
    enableVaultForTemplateDeployment: true
    enableVaultForDiskEncryption: true
    enablePurgeProtection: false
    enableSoftDelete: true
    softDeleteRetentionInDays: 90
    enableRbacAuthorization: false
    createMode: 'default'
    sku: startsWith(location, 'china') ? 'standard' : sku
    accessPolicies: formattedAccessPolicies
    secrets: {
      secureList: [
        {
          name: storageRef.name
          value: storageRef.listKeys().keys[0].value
          attributesExp: 1702648632
          attributesNbf: 10000
        }
      ]
    }
  }
}

resource storageRef 'Microsoft.Storage/storageAccounts@2023-01-01' existing = {
  name: storageAccountName
}

//==============================================================================
// Outputs
//==============================================================================

@description('The resource ID of the key vault.')
output resourceId string = keyVault.outputs.resourceId

@description('The name of the key vault.')
output name string = keyVault.outputs.name

@description('The URI of the key vault.')
output uri string = keyVault.outputs.uri
