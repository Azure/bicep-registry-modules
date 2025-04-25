param location string

@description('Required. The name of the storage account to create as a cluster witness.')
param clusterWitnessStorageAccountName string

@description('Required. The name of the storage account to be created to collect Key Vault diagnostic logs.')
param keyVaultDiagnosticStorageAccountName string

@description('Required. The name of the Azure Key Vault to create.')
param keyVaultName string

param softDeleteRetentionDays int = 30

@description('Optional. The number of days for the retention in days. A value of 0 will retain the events indefinitely.')
@minValue(0)
@maxValue(365)
param logsRetentionInDays int = 30

param tenantId string
param deploymentUsername string = 'deployUser'
@secure()
param deploymentUserPassword string
param localAdminUsername string
@secure()
param localAdminPassword string
@secure()
param arbDeploymentAppId string
@secure()
param arbDeploymentSPObjectId string
@secure()
param arbDeploymentServicePrincipalSecret string
param vnetSubnetResourceId string?
param allowIPtoStorageAndKeyVault string?
param usingArcGW bool = false
param useSharedKeyVault bool = true

// create base64 encoded secret values to be stored in the Azure Key Vault
var deploymentUserSecretValue = base64('${deploymentUsername}:${deploymentUserPassword}')
var localAdminSecretValue = base64('${localAdminUsername}:${localAdminPassword}')
var arbDeploymentServicePrincipalValue = base64('${arbDeploymentAppId}:${arbDeploymentServicePrincipalSecret}')

var storageAccountType = 'Standard_ZRS'

module ARBDeploymentSPNSubscriptionRoleAssignmnent 'ashciARBSPRoleAssignment.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-arbroleassignment'
  scope: subscription()
  params: {
    arbDeploymentSPObjectId: arbDeploymentSPObjectId
  }
}

resource diagnosticStorageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: keyVaultDiagnosticStorageAccountName
  location: location
  sku: {
    name: storageAccountType
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      ipRules: []
      virtualNetworkRules: []
    }
  }
  resource blobService 'blobServices' = {
    name: 'default'
    properties: {
      deleteRetentionPolicy: {
        enabled: true
        days: 7
      }
      containerDeleteRetentionPolicy: {
        enabled: true
        days: 7
      }
    }
  }
}

resource witnessStorageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: clusterWitnessStorageAccountName
  location: location
  sku: {
    name: storageAccountType
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: usingArcGW ? 'Allow' : 'Deny' // we don't know the source IP when traffic is redirected through the Arc GW
      ipRules: (allowIPtoStorageAndKeyVault != null)
        ? [
            {
              value: allowIPtoStorageAndKeyVault!
            }
          ]
        : []
      virtualNetworkRules: (vnetSubnetResourceId != null)
        ? [
            {
              id: vnetSubnetResourceId!
            }
          ]
        : []
    }
  }
  resource blobService 'blobServices' = {
    name: 'default'
    properties: {
      deleteRetentionPolicy: {
        enabled: true
        days: 7
      }
      containerDeleteRetentionPolicy: {
        enabled: true
        days: 7
      }
    }
  }
}

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    enableSoftDelete: true
    softDeleteRetentionInDays: softDeleteRetentionDays
    enableRbacAuthorization: true
    publicNetworkAccess: 'Enabled'
    accessPolicies: []
    tenantId: tenantId
    sku: {
      name: 'standard'
      family: 'A'
    }
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      ipRules: (allowIPtoStorageAndKeyVault != null)
        ? [
            {
              value: allowIPtoStorageAndKeyVault!
            }
          ]
        : []
      virtualNetworkRules: (vnetSubnetResourceId != null)
        ? [
            {
              id: vnetSubnetResourceId!
            }
          ]
        : []
    }
  }
  dependsOn: [
    diagnosticStorageAccount
  ]

  resource keyVaultName_domainAdminSecret 'secrets@2023-07-01' = if (!useSharedKeyVault) {
    name: 'AzureStackLCMUserCredential'
    properties: {
      contentType: 'Secret'
      value: deploymentUserSecretValue
      attributes: {
        enabled: true
      }
    }
  }

  resource keyVaultName_localAdminSecret 'secrets@2023-07-01' = if (!useSharedKeyVault) {
    name: 'LocalAdminCredential'
    properties: {
      contentType: 'Secret'
      value: localAdminSecretValue
      attributes: {
        enabled: true
      }
    }
  }

  resource keyVaultName_arbDeploymentServicePrincipal 'secrets@2023-07-01' = if (!useSharedKeyVault) {
    name: 'DefaultARBApplication'
    properties: {
      contentType: 'Secret'
      value: arbDeploymentServicePrincipalValue
      attributes: {
        enabled: true
      }
    }
  }

  resource keyVaultName_storageWitness 'secrets@2023-07-01' = if (!useSharedKeyVault) {
    name: 'WitnessStorageKey'
    properties: {
      contentType: 'Secret'
      value: base64(witnessStorageAccount.listKeys().keys[0].value)
      attributes: {
        enabled: true
      }
    }
  }
}

resource keyVaultName_Microsoft_Insights_service 'microsoft.insights/diagnosticSettings@2016-09-01' = {
  name: 'service'
  location: location
  scope: keyVault
  properties: {
    storageAccountId: diagnosticStorageAccount.id
    logs: [
      {
        category: 'AuditEvent'
        enabled: true
        retentionPolicy: {
          enabled: true
          days: logsRetentionInDays
        }
      }
    ]
  }
}
