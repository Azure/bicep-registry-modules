targetScope = 'resourceGroup'

// ------------------
//    PARAMETERS
// ------------------
@description('The name of the key vault where the certificate will be stored.')
param keyVaultName string

@description('The subnet resource ID of the subnet where the key vault is deployed.')
param keyVaultSubnetResourceId string

@description('The name of the location where the resources will be deployed.')
param location string

@description('Optional. The tags to be assigned to the created resources.')
param tags object = {}

param appGatewayUserAssignedIdentityPrincipalId string

param appGatewayCertificateKeyName string

@secure()
param appGatewayCertificateData string

// ------------------
// VARIABLES
// ------------------

var keyVaultSecretUserRoleGuid = '4633458b-17de-408a-b874-0445c86b69e6'
var selfSignedCertificateSubject = 'CN=contoso.com'
var useSelfSignedCert = empty(appGatewayCertificateData)

// ------------------
// RESOURCES
// ------------------

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: keyVaultName
}

// Create a managed identity to write to KV a self signed cert if the appGatewayCertificateData is not provided
resource selfSignedCertManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = if (empty(appGatewayCertificateData)) {
  name: '${uniqueString(deployment().name, location)}-selfSignedCertManagedIdentity'
  location: location
  tags: tags
}

// Assign the managed identity the contributor role on the KV to write the self signed cert
resource selfSignedCertManagedIdentityRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (empty(appGatewayCertificateData)) {
  name: guid(resourceGroup().id, 'Contributor', selfSignedCertManagedIdentity.id)
  scope: keyVault
  properties: {
    principalId: selfSignedCertManagedIdentity.properties.principalId
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '00482a5a-887f-4fb3-b363-3b7fe8e74483'
    ) // Key Vault Administrator
    principalType: 'ServicePrincipal'
  }
}

// Create a deployment script to generate a self signed cert and write it to the KV
// script needs to run from within the virtual network to be able to access the key vault

resource selfSignedCertificate 'Microsoft.Resources/deploymentScripts@2023-08-01' = if (empty(appGatewayCertificateData)) {
  name: '${take(uniqueString(deployment().name, 'self-signed-cert', location),4)}-certDeploymentScript'
  location: location
  tags: tags
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${selfSignedCertManagedIdentity.id}': {}
    }
  }
  properties: {
    azPowerShellVersion: '9.0'
    retentionInterval: 'P1D'
    arguments: '-KeyVaultName "${keyVault.name}" -CertName "${appGatewayCertificateKeyName}" -CertSubjectName "${selfSignedCertificateSubject}"'
    scriptContent: loadTextContent('../../../../../../utilities/e2e-template-assets/scripts/Set-CertificateInKeyVault.ps1')
    containerSettings: {
      subnetIds: [
        {
          id: keyVaultSubnetResourceId
        }
      ]
    }
  }
  dependsOn: [
    keyvaultSecretUserRoleAssignment
  ]
}

//TODO: this needs to be updated to use the AVM module when it is available
resource sslCertSecret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = if (!empty(appGatewayCertificateData)) {
  parent: keyVault
  name: appGatewayCertificateKeyName
  tags: tags
  properties: {
    value: appGatewayCertificateData
    contentType: 'application/x-pkcs12'
    attributes: {
      enabled: true
    }
  }
}

// Assign the App Gateway user assigned identity the role to read the secret
resource keyvaultSecretUserRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(subscription().id, keyVault.id, appGatewayUserAssignedIdentityPrincipalId, 'KeyVaultSecretUser')
  scope: sslCertSecret
  properties: {
    principalId: appGatewayUserAssignedIdentityPrincipalId
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', keyVaultSecretUserRoleGuid)
    principalType: 'ServicePrincipal'
  }
}

// Using SecretUri instead of SecretUriWithVersion to avoid having to update the App Gateway configuration when the secret version changes
output SecretUri string = (!useSelfSignedCert)
  ? sslCertSecret.properties.secretUri
  : selfSignedCertificate.properties.outputs.secretUrl
