@description('The name of the Azure Key Vault')
param akvName string

@description('The location to deploy the resources to')
param location string

@description('How the deployment script should be forced to execute')
param forceUpdateTag  string = utcNow()

@description('The RoleDefinitionId required for the DeploymentScript resource to interact with KeyVault')
param rbacRolesNeededOnKV string = 'a4417e6f-fecd-4de8-b567-7b0420556985' //KeyVault Certificate Officer

@description('Does the Managed Identity already exists, or should be created')
param useExistingManagedIdentity bool = false

@description('Name of the Managed Identity resource')
param managedIdentityName string = 'id-KeyVaultCertificateCreator-${location}'

@description('For an existing Managed Identity, the Subscription Id it is located in')
param existingManagedIdentitySubId string = subscription().subscriptionId

@description('For an existing Managed Identity, the Resource Group it is located in')
param existingManagedIdentityResourceGroupName string = resourceGroup().name

@description('The name of the certificate to create. Use when creating a single certificate.')
param certificateName string

@description('The names of the certificate to create. Use when creating many certificates.')
param certificateNames array = [certificateName]

@description('The common name of the certificate to create. Use when creating a single certificate.')
param certificateCommonName string = certificateName

@description('The common names of the certificate to create. Use when creating many certificates.')
param certificateCommonNames array = [certificateCommonName]

@description('A delay before the script import operation starts. Primarily to allow Azure AAD Role Assignments to propagate')
param initialScriptDelay string = '0'

@allowed([
  'OnSuccess'
  'OnExpiration'
  'Always'
])
@description('When the script resource is cleaned up')
param cleanupPreference string = 'OnSuccess'

@description('Self, or user defined {IssuerName} for certificate signing')
param issuerName string = 'Self'

@description('Certificate Issuer Provider, DigiCert, GlobalSign, or internal options may be used.')
param issuerProvider string = ''

@description('Account ID of Certificate Issuer Account')
param accountId string = ''

@description('Password of Certificate Issuer Account')
@secure()
param issuerPassword string = ''

@description('Organization ID of Certificate Issuer Account')
param organizationId string = ''

@description('Override this parameter if using this in cross tenant scenarios')
param isCrossTenant bool = false

resource akv 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: akvName
}

@description('A new managed identity that will be created in this Resource Group, this is the default option')
resource newDepScriptId 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = if (!useExistingManagedIdentity) {
  name: managedIdentityName
  location: location
}

@description('An existing managed identity that could exist in another sub/rg')
resource existingDepScriptId 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = if (useExistingManagedIdentity ) {
  name: managedIdentityName
  scope: resourceGroup(existingManagedIdentitySubId, existingManagedIdentityResourceGroupName)
}

var delegatedManagedIdentityResourceId = useExistingManagedIdentity ? existingDepScriptId.id : newDepScriptId.id

resource rbacKv 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(akv.id, rbacRolesNeededOnKV, managedIdentityName, string(useExistingManagedIdentity))
  scope: akv
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', rbacRolesNeededOnKV)
    principalId: useExistingManagedIdentity ? existingDepScriptId.properties.principalId : newDepScriptId.properties.principalId
    principalType: 'ServicePrincipal'
    delegatedManagedIdentityResourceId: isCrossTenant ? delegatedManagedIdentityResourceId : null 
  }
}

resource createImportCert 'Microsoft.Resources/deploymentScripts@2020-10-01' = [for (certificateName, index) in certificateNames
  name: 'AKV-Cert-${akv.name}-${replace(replace(certificateName,':',''),'/','-')}'
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${useExistingManagedIdentity ? existingDepScriptId.id : newDepScriptId.id}': {}
    }
  }
  kind: 'AzureCLI'
  dependsOn: [
    rbacKv
  ]
  properties: {
    forceUpdateTag: forceUpdateTag
    azCliVersion: '2.35.0'
    timeout: 'PT10M'
    retentionInterval: 'P1D'
    environmentVariables: [
      { name: 'akvName', value: akvName }
      { name: 'certName', value: certificateName }
      { name: 'certCommonName', value: certificateCommonNames[index] }
      { name: 'initialDelay', value: initialScriptDelay }
      { name: 'issuerName', value: issuerName }
      { name: 'issuerProvider', value: issuerProvider }
      { name: 'retryMax', value: '10' }
      { name: 'retrySleep', value: '5s' }
      { name: 'accountId', value: accountId }
      { name: 'issuerPassword', secureValue: issuerPassword }
      { name: 'organizationId', value: organizationId }
    ]
    scriptContent: loadTextContent('create-kv-cert.sh')
    cleanupPreference: cleanupPreference
  }
}

@description('Certificate name')
output certificateName string = createImportCerts[0].properties.outputs.name

@description('KeyVault secret id to the created version')
output certificateSecretId string = contains(createImportCerts[0].properties.outputs, 'certSecretId') ? createImportCerts[0].properties.outputs.certSecretId.versioned : ''

@description('KeyVault secret id which uses the unversioned uri')
output certificateSecretIdUnversioned string = contains(createImportCerts[0].properties.outputs, 'certSecretId') ? createImportCerts[0].properties.outputs.certSecretId.unversioned : ''

@description('Certificate Thumbprint')
output certificateThumbprint string = contains(createImportCerts[0].properties.outputs, 'thumbprint') ? createImportCerts[0].properties.outputs.thumbprint : ''

@description('Certificate Thumbprint (in hex)')
output certificateThumbprintHex string = contains(createImportCerts[0].properties.outputs, 'thumbprintHex') ? createImportCerts[0].properties.outputs.thumbprintHex : ''

@description('Certificate names')
output certificateNames array = [for certificateName in certificateNames: {
  createImportCert[index].properties.outputs.name
}]

@description('KeyVault secret ids to the created version')
output certificateSecretIds array = [for certificateName in certificateNames: {
  createImportCert[index].properties.outputs.certSecretId.versioned
}]

@description('KeyVault secret ids which uses the unversioned uri')
output certificateSecretIdUnversioneds array = [for certificateName in certificateNames: {
  createImportCert[index].properties.outputs.certSecretId.unversioned
}]

@description('Certificate Thumbprints')
output certificateThumbprints array = [for certificateName in certificateNames: {
  createImportCert[index].properties.outputs.thumbprint
}]

@description('Certificate Thumbprints (in hex)')
output certificateThumbprintHexs array = [for certificateName in certificateNames: {
  createImportCert[index].properties.outputs.thumbprintHex
}]
