targetScope = 'resourceGroup'

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Key Vault to create.')
param keyVaultName string

@description('Required. The name of the SSH Key to create.')
param sshKeyName string

@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the certificate name.')
param certificateName string

@description('Required. The name of the certificate subject name.')
param certificateSubjectName string

var sshDeploymentScriptName = '${take(uniqueString(deployment().name, location),4)}-sshDeploymentScript'
var certDeploymentScriptName = '${take(uniqueString(deployment().name, location),4)}-certDeploymentScript'

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: '${uniqueString(deployment().name, location)}-${managedIdentityName}'
  location: location
}

resource msiRGContrRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, 'Contributor', managedIdentity.id)
  scope: resourceGroup()
  properties: {
    principalId: managedIdentity.properties.principalId
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'b24988ac-6180-42a0-ab88-20f7382dd24c'
    ) // Contributor
    principalType: 'ServicePrincipal'
  }
}

resource sshDeploymentScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: sshDeploymentScriptName
  location: location
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {
    azPowerShellVersion: '9.0'
    retentionInterval: 'P1D'
    arguments: '-SSHKeyName "${sshKeyName}" -ResourceGroupName "${resourceGroup().name}"'
    scriptContent: loadTextContent('../../../../../../utilities/e2e-template-assets/scripts/New-SSHKey.ps1')
  }
  dependsOn: [
    msiRGContrRoleAssignment
  ]
}

resource testCertificate 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: certDeploymentScriptName
  location: location
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {
    azPowerShellVersion: '9.0'
    retentionInterval: 'P1D'
    arguments: '-KeyVaultName "${keyVault.name}" -CertName "${certificateName}" -CertSubjectName "CN=${certificateSubjectName}"'
    scriptContent: loadTextContent('../../../../../../utilities/e2e-template-assets/scripts/Set-CertificateInKeyVault.ps1')
  }
  dependsOn: [
    msiRGContrRoleAssignment
  ]
}

resource sshKey 'Microsoft.Compute/sshPublicKeys@2022-03-01' = {
  name: '${take(uniqueString(deployment().name, location),4)}-${sshKeyName}'
  location: location
  properties: {
    publicKey: sshDeploymentScript.properties.outputs.publicKey
  }
}

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: '${take(uniqueString(deployment().name, location),4)}-${keyVaultName}'
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenant().tenantId
    enablePurgeProtection: null
    enableSoftDelete: true
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    enabledForDeployment: true
    enableRbacAuthorization: true
    accessPolicies: []
  }
}

output keyVaultName string = keyVault.name
output sshKey string = sshKey.properties.publicKey
output certificateSecureUrl string = testCertificate.properties.outputs.secretUrl
