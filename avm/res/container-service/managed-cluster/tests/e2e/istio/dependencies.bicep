@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Key Vault to create.')
param keyVaultName string

@description('Required. The name of the organization to which the Root Certificate is issued. It helps identify the legal entity that owns the root certificate')
param rootOrganization string

@description('Required. The name of the organization to which the Certificate Authority is issued. It helps identify the legal entity that owns the certificate authority')
param caOrganization string

@description('Required. The subject distinguished name is the name of the user of the certificate authority. The distinguished name for the certificate is a textual representation of the subject or issuer of the certificate')
param caSubjectName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Deployment Script to create for the Certificate generation.')
param cacertDeploymentScriptName string

@description('Optional. Do not provide a value. Used to force the deployment script to rerun on every redeployment.')
param utcValue string = utcNow()

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

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
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

resource cacertDeploymentScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: cacertDeploymentScriptName
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
    retentionInterval: 'P1D'
    forceUpdateTag: utcValue
    arguments: ' -KeyVaultName "${keyVault.name}" -RootOrganization "${rootOrganization}" -CAOrganization "${caOrganization}" -CertSubjectName "${caSubjectName}"'
    scriptContent: loadTextContent('scripts/Set-CertificateAuthorityInKeyVault.ps1')
  }
}

@description('The resource ID of the created Key Vault.')
output keyVaultResourceId string = keyVault.id

@description('The name of the root certificate secret.')
output rootCertSecretName string = cacertDeploymentScript.properties.outputs.rootCertSecretName

@description('The name of the certiticate authority key secret.')
output caKeySecretName string = cacertDeploymentScript.properties.outputs.caKeySecretName

@description('The name of the certificate authority cert secret.')
output caCertSecretName string = cacertDeploymentScript.properties.outputs.caCertSecretName

@description('The name of the certificate chain secret.')
output certChainSecretName string = cacertDeploymentScript.properties.outputs.certChainSecretName

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId
