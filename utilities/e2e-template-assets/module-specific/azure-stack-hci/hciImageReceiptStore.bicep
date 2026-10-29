targetScope = 'resourceGroup'

@description('Required. Object ID of the existing HCI CI workload identity.')
param principalId string

@description('Required. Client ID of the existing HCI CI workload identity.')
param clientId string

var accountName = 'sthcircp${uniqueString(toLower(resourceGroup().id), 'hci-image-receipts')}'
var containerName = 'hci-operation-receipts'
var blobContributorRoleId = subscriptionResourceId(
  'Microsoft.Authorization/roleDefinitions',
  'ba92f5b4-2d11-453d-a403-e96b0029c9fe'
)

resource receiptAccount 'Microsoft.Storage/storageAccounts@2025-06-01' = {
  name: accountName
  location: resourceGroup().location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  tags: {
    lifecycle: 'tenant-persistent'
    'avm-owner': 'Azure/bicep-registry-modules'
    'avm-environment': 'azure-local'
    'avm-purpose': 'image-operation-receipts'
    'avm-receipt-version': '1'
    'avm-tenant': tenant().tenantId
    'avm-subscription': subscription().subscriptionId
    'avm-ci-client': clientId
    'avm-ci-principal': principalId
  }
  properties: {
    accessTier: 'Hot'
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: false
    allowSharedKeyAccess: false
    allowCrossTenantReplication: false
    defaultToOAuthAuthentication: true
    publicNetworkAccess: 'Enabled'
    networkAcls: {
      bypass: 'None'
      defaultAction: 'Allow'
    }
    encryption: {
      keySource: 'Microsoft.Storage'
      services: {
        blob: {
          enabled: true
          keyType: 'Account'
        }
      }
    }
  }
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2025-06-01' = {
  parent: receiptAccount
  name: 'default'
  properties: {
    isVersioningEnabled: false
    deleteRetentionPolicy: {
      enabled: false
    }
    containerDeleteRetentionPolicy: {
      enabled: false
    }
  }
}

resource receiptContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2025-06-01' = {
  parent: blobService
  name: containerName
  properties: {
    publicAccess: 'None'
  }
}

resource receiptAccess 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: receiptContainer
  name: guid(receiptContainer.id, principalId, blobContributorRoleId)
  properties: {
    principalId: principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: blobContributorRoleId
  }
}

@description('The separate HCI_IMAGE_RECEIPT_STORAGE_ACCOUNT workflow variable value.')
output storageAccountName string = receiptAccount.name

@description('The exact persistent receipt account resource ID.')
output storageAccountResourceId string = receiptAccount.id

@description('The exact private container resource ID.')
output containerResourceId string = receiptContainer.id

@description('The container-scoped assignment for the existing CI identity.')
output roleAssignmentResourceId string = receiptAccess.id
