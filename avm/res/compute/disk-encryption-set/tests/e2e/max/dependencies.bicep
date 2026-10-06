@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Key Vault to create.')
param keyVaultName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the deployment script used to wait for RBAC propagation.')
param waitDeploymentScriptName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: managedIdentityName
  location: location
}

resource keyVault 'Microsoft.KeyVault/vaults@2026-02-01' = {
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

  resource key 'keys@2026-02-01' = {
    name: 'keyEncryptionKey'
    properties: {
      kty: 'RSA'
    }
  }
}

// Replicates the role assignment the Disk Encryption Set module itself creates (nested_keyVaultPermissions.bicep),
// so a bounded wait can be added below for RBAC propagation before the module re-creates (and reads) the same assignment.
resource keyVaultKeyRBAC 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('msi-${keyVault::key.id}-${location}-${managedIdentity.id}-Key-Reader-RoleAssignment')
  scope: keyVault::key
  properties: {
    principalId: managedIdentity.properties.principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'e147488a-f6f5-4113-8e2d-b22465e65bf6') // Key Vault Crypto Service Encryption User
    principalType: 'ServicePrincipal'
  }
}

// Azure RBAC role assignments can take several minutes to propagate to the data plane.
// Without this bounded probe, the Disk Encryption Set deployment can fail with `KeyVaultAccessForbidden`
// even though the equivalent role assignment above has just been created. Rather than a fixed sleep,
// this script actively probes the data plane (authenticated as the same UAMI/role the module itself uses)
// until a `Get-AzKeyVaultKey` call succeeds, bounded by a maximum number of attempts.
resource waitForKeyPermissionsPropagation 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: waitDeploymentScriptName
  location: location
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {
    azPowerShellVersion: '11.0'
    retentionInterval: 'PT1H'
    cleanupPreference: 'Always'
    environmentVariables: [
      {
        name: 'KEY_VAULT_NAME'
        value: keyVault.name
      }
      {
        name: 'KEY_NAME'
        value: keyVault::key.name
      }
    ]
    scriptContent: '''
      $maxAttempts = 10
      $delaySeconds = 10
      $lastError = $null

      for ($attempt = 1; $attempt -le $maxAttempts; $attempt++) {
        try {
          $null = Get-AzKeyVaultKey -VaultName $env:KEY_VAULT_NAME -Name $env:KEY_NAME -ErrorAction Stop
          Write-Output "Key Vault Crypto Service Encryption User role has propagated after $attempt attempt(s)."
          $DeploymentScriptOutputs = @{ attempts = $attempt }
          return
        } catch {
          $lastError = $_
          Write-Output "Attempt $attempt/$maxAttempts failed (role propagation pending or transient error): $($_.Exception.Message)"
          if ($attempt -lt $maxAttempts) {
            Start-Sleep -Seconds $delaySeconds
          }
        }
      }

      throw "Key Vault Crypto Service Encryption User role did not propagate within $($maxAttempts * $delaySeconds) seconds. Last error: $($lastError.Exception.Message)"
    '''
  }
  dependsOn: [
    keyVaultKeyRBAC
  ]
}

@description('The resource ID of the created Key Vault.')
output keyVaultResourceId string = keyVault.id

@description('The name of the created encryption key.')
output keyName string = keyVault::key.name

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id
