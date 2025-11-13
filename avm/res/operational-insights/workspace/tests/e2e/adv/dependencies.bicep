@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Storage Account to create.')
param storageAccountName string

@description('Required. The name of the Automation Account to create.')
param automationAccountName string

@description('Required. The name of the Event Hub Namespace to create.')
param eventHubNamespaceName string

@description('Required. The name of the Event Hub to create.')
param eventHubName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Log Analytics Cluster to create.')
param logAnalyticsClusterName string

@description('Required. The name of the Key Vault to create.')
param keyVaultName string

@description('Required. The name of the deployment script that waits for a role assignment to propagate.')
param waitDeploymentScriptName string

resource storageAccount 'Microsoft.Storage/storageAccounts@2024-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

resource automationAccount 'Microsoft.Automation/automationAccounts@2024-10-23' = {
  name: automationAccountName
  location: location
  properties: {
    sku: {
      name: 'Basic'
    }
  }
}

resource eventHubNamespace 'Microsoft.EventHub/namespaces@2024-01-01' = {
  name: eventHubNamespaceName
  location: location
  sku: {
    name: 'Basic'
    tier: 'Basic'
    capacity: 1
  }
  properties: {
    minimumTlsVersion: '1.2'
    publicNetworkAccess: 'Enabled'
    disableLocalAuth: false
    isAutoInflateEnabled: false
    maximumThroughputUnits: 0
    kafkaEnabled: false
    zoneRedundant: true
  }

  resource eventHub 'eventhubs@2024-01-01' = {
    name: eventHubName
    properties: {
      messageRetentionInDays: 1
    }
  }
}

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

resource cluster 'Microsoft.OperationalInsights/clusters@2025-02-01' = {
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

@description('The resource ID of the created Storage Account.')
output storageAccountResourceId string = storageAccount.id

@description('The resource ID of the created Automation Account.')
output automationAccountResourceId string = automationAccount.id

@description('The resource ID of the created Eventhub Namespace.')
output eventHubNamespaceResourceId string = eventHubNamespace.id

@description('The name of the created Eventhub.')
output eventHubName string = eventHubNamespace::eventHub.name

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The resource ID of the created Log Analytics Cluster.')
output logAnalyticsClusterResourceId string = cluster.id
