metadata name = 'AVM Storage Account Module'

@description('The name of the Storage Account')
param storageAccountName string

@description('The location of the Storage Account')
param location string

@description('Tags to be applied to the Storage Account')
param tags object

@description('Role assignments for the Storage Account')
param roleAssignments array = []

@description('SKU for the Storage Account')
param skuName string = 'Standard_LRS'

@description('Kind of the Storage Account')
param kind string = 'StorageV2'

@description('Enable system assigned managed identity')
param enableSystemAssignedIdentity bool = true

@description('Minimum TLS version')
param minimumTlsVersion string = 'TLS1_2'

@description('Network ACLs for the Storage Account')
param networkAcls object = {
  bypass: 'AzureServices'
  defaultAction: 'Allow'
  ipRules: []
}

@description('Supports HTTPS traffic only')
param supportsHttpsTrafficOnly bool = true

@description('Access tier for the Storage Account')
param accessTier string = 'Hot'

module avmStorageAccount 'br/public:avm/res/storage/storage-account:0.18.2' = {
  name: storageAccountName
  params: {
    name: storageAccountName
    location: location
    skuName: skuName
    kind: kind
    managedIdentities: enableSystemAssignedIdentity ? { systemAssigned: true } : {}
    minimumTlsVersion: minimumTlsVersion
    roleAssignments: roleAssignments
    networkAcls: networkAcls
    supportsHttpsTrafficOnly: supportsHttpsTrafficOnly
    accessTier: accessTier
    tags: tags
    blobServices: {
      deleteRetentionPolicyEnabled: false
      deleteRetentionPolicyDays: 6
      containerDeleteRetentionPolicyDays: 7
      containerDeleteRetentionPolicyEnabled: false
    }
  }
}
