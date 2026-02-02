@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Log Analytics Cluster to create.')
param logAnalyticsClusterName string

@description('Required. The name of the Key Vault to create.')
param keyVaultName string

@description('Required. The name of the deployment script that waits for a role assignment to propagate.')
param waitDeploymentScriptName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: managedIdentityName
  location: location
}

resource keyVault 'Microsoft.KeyVault/vaults@2025-05-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenant().tenantId
    enablePurgeProtection: true // Required for encryption to work
    softDeleteRetentionInDays: 7
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    enabledForDeployment: true
    enableRbacAuthorization: true
    accessPolicies: []
  }

  resource key 'keys@2025-05-01' = {
    name: 'keyEncryptionKey'
    properties: {
      kty: 'RSA'
    }
  }
}

resource keyPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('msi-${keyVault::key.id}-${location}-${managedIdentity.id}-Key-Key-Vault-Crypto-User-RoleAssignment')
  scope: keyVault::key
  properties: {
    principalId: managedIdentity.properties.principalId
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'e147488a-f6f5-4113-8e2d-b22465e65bf6'
    ) // Key Vault Crypto Service Encryption User
    principalType: 'ServicePrincipal'
  }
}

// Waiting for the role assignment to propagate
resource waitForDeployment 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  dependsOn: [keyPermissions]
  name: waitDeploymentScriptName
  location: location
  kind: 'AzurePowerShell'
  properties: {
    retentionInterval: 'PT1H'
    azPowerShellVersion: '11.0'
    cleanupPreference: 'Always'
    scriptContent: 'write-output "Sleeping for 30"; start-sleep -Seconds 30'
  }
}

resource cluster 'Microsoft.OperationalInsights/clusters@2025-07-01' = {
  name: logAnalyticsClusterName
  location: location
  sku: {
    name: 'CapacityReservation'
    capacity: 100
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {
    billingType: 'Cluster'
    keyVaultProperties: {
      keyName: keyVault::key.name
      keyVaultUri: keyVault.properties.vaultUri
      keyVersion: '' // Using auto-rotation
    }
  }
  dependsOn: [
    waitForDeployment
  ]
}

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The resource ID of the created Log Analytics Cluster.')
output logAnalyticsClusterResourceId string = cluster.id
