@description('The name of the Azure Key Vault')
param akvName string

@description('The location to deploy the resources to')
param location string

@description('How the deployment script should be forced to execute')
param forceUpdateTag string = utcNow()

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

@description('The names of the certificate to create. Use when creating many certificates.')
param certificateNames array

@description('The common names of the certificate to create. Use when creating many certificates.')
param certificateCommonNames array = certificateNames

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

@description('Create certificate in disabled state. Default: false')
param disabled bool = false

@description('Account ID of Certificate Issuer Account')
param accountId string = ''

@description('Password of Certificate Issuer Account')
@secure()
param issuerPassword string = ''

@description('Organization ID of Certificate Issuer Account')
param organizationId string = ''

@description('Override this parameter if using this in cross tenant scenarios')
param isCrossTenant bool = false

@description('The default policy might cause errors about CSR being used before, so set this to false if that happens')
param reuseKey bool = true

@minValue(1)
@maxValue(1200)
@description('Optional. Override default validityInMonths 12 value')
param validity int = 12

@description('Set to false to disable role assignments within this module. Default: true')
param performRoleAssignment bool = true

resource akv 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: akvName
}

@description('A new managed identity that will be created in this Resource Group, this is the default option')
resource newDepScriptId 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = if (!useExistingManagedIdentity) {
  name: managedIdentityName
  location: location
}

@description('An existing managed identity that could exist in another sub/rg')
resource existingDepScriptId 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = if (useExistingManagedIdentity) {
  name: managedIdentityName
  scope: resourceGroup(existingManagedIdentitySubId, existingManagedIdentityResourceGroupName)
}

var delegatedManagedIdentityResourceId = useExistingManagedIdentity ? existingDepScriptId.id : newDepScriptId.id

resource rbacKv 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (performRoleAssignment) {
  name: guid(akv.id, rbacRolesNeededOnKV, managedIdentityName, string(useExistingManagedIdentity))
  scope: akv
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', rbacRolesNeededOnKV)
    principalId: useExistingManagedIdentity ? existingDepScriptId.properties.principalId : newDepScriptId.properties.principalId
    principalType: 'ServicePrincipal'
    delegatedManagedIdentityResourceId: isCrossTenant ? delegatedManagedIdentityResourceId : null
  }
}

resource createImportCerts 'Microsoft.Resources/deploymentScripts@2020-10-01' = [for (certificateName, index) in certificateNames: {
  name: 'AKV-Cert-${akv.name}-${replace(replace(certificateName, ':', ''), '/', '-')}'
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
      { name: 'disabled', value: toLower(string(disabled)) }
      { name: 'retryMax', value: '10' }
      { name: 'retrySleep', value: '5s' }
      { name: 'accountId', value: accountId }
      { name: 'issuerPassword', secureValue: issuerPassword }
      { name: 'organizationId', value: organizationId }
      { name: 'reuseKey', value: toLower(string(reuseKey)) }
      { name: 'validity', value: string(validity) }
    ]
    scriptContent: loadTextContent('create-kv-cert.sh')
    cleanupPreference: cleanupPreference
  }
}]

@description('Certificate names')
output certificateNames array = [for (certificateName, index) in certificateNames: [
  createImportCerts[index].properties.outputs.name
]]

@description('KeyVault secret ids to the created version')
output certificateSecretIds array = [for (certificateName, index) in certificateNames: [
  createImportCerts[index].properties.outputs.certSecretId.versioned
]]

@description('KeyVault secret ids which uses the unversioned uri')
output certificateSecretIdUnversioneds array = [for (certificateName, index) in certificateNames: [
  createImportCerts[index].properties.outputs.certSecretId.unversioned
]]

@description('Certificate Thumbprints')
output certificateThumbpints array = [for (certificateName, index) in certificateNames: [
  createImportCerts[index].properties.outputs.thumbprint
]]

@description('Certificate Thumbprints (in hex)')
output certificateThumbprintHexs array = [for (certificateName, index) in certificateNames: [
  createImportCerts[index].properties.outputs.thumbprintHex
]]
