@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Identity to use.')
param managedIdentityName string

@description('Required. The name of the Key Vault to create.')
param keyVaultName string

@description('Required. The name of the Deployment Script to create for the Certificate generation.')
param certDeploymentScriptName string

@secure()
@description('Required. The name for the SSL certificate.')
param certname string

var certPWSecretName = 'pfxCertificatePassword'
var certSecretName = 'pfxBase64Certificate'

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenant().tenantId
    enablePurgeProtection: null
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    enabledForDeployment: true
    enableRbacAuthorization: true
    accessPolicies: []
  }
}

resource keyPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('msi-${managedIdentity.name}-KeyVault-Admin-RoleAssignment')
  scope: keyVault
  properties: {
    principalId: managedIdentity.properties.principalId
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '00482a5a-887f-4fb3-b363-3b7fe8e74483'
    ) // Key Vault Administrator
    principalType: 'ServicePrincipal'
  }
}

resource certDeploymentScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
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
    azPowerShellVersion: '8.0'
    retentionInterval: 'P1D'
    arguments: '-KeyVaultName "${keyVault.name}" -CertName "${certname}" -CertSubjectName "CN=*.contoso.com"'
    scriptContent: loadTextContent('../../../../../../../utilities/e2e-template-assets/scripts/Set-CertificateInKeyVault.ps1')
  }
}

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The resource ID of the created Key Vault.')
output keyVaultResourceId string = keyVault.id

@description('The URI of the created Key Vault.')
output keyVaultUri string = keyVault.properties.vaultUri

@description('The URL of the created certificate.')
output certificateSecretUrl string = certDeploymentScript.properties.outputs.secretUrl

@description('The name of the certification password secret.')
output certPWSecretName string = certPWSecretName

@description('The name of the certification secret.')
output certSecretName string = certSecretName
