@description('The name of the Azure Key Vault')
param akvName string

@description('The location of the Key Vault and where to deploy the module resources to')
param location string = resourceGroup().location

@description('How the deployment script should be forced to execute')
param forceUpdateTag string = utcNow()

@description('Azure RoleId that are required for the DeploymentScript resource to import images')
param rbacRoleNeeded string = 'b86a8fe4-44ce-4948-aee5-eccb2c155cd7' //Key Vault Secrets officer is needed to create secrets in the Key Vault

@description('Does the Managed Identity already exists, or should be created')
param useExistingManagedIdentity bool = false

@description('Name of the Managed Identity resource')
param managedIdentityName string = 'id-keyvault-ssh-${location}'

@description('For an existing Managed Identity, the Subscription Id it is located in')
param existingManagedIdentitySubId string = subscription().subscriptionId

@description('For an existing Managed Identity, the Resource Group it is located in')
param existingManagedIdentityResourceGroupName string = resourceGroup().name

@description('''
The name of the SSH Key to be created.
if name is my-virtual-machine-ssh then the private key will be named my-virtual-machine-sshprivate and the public key will be named my-virtual-machine-sshpublic.
''')
param sshKeyName string

@description('A delay before the script import operation starts. Primarily to allow Azure AAD Role Assignments to propagate')
param initialScriptDelay string = '30s'

@allowed([ 'OnSuccess', 'OnExpiration', 'Always' ])
@description('When the script resource is cleaned up')
param cleanupPreference string = 'OnSuccess'

var privateKeySecretName = '${sshKeyName}private'
var publicKeySecretName = '${sshKeyName}public'

resource akv 'Microsoft.KeyVault/vaults@2022-11-01' existing = {
  name: akvName
}

resource newDepScriptId 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = if (!useExistingManagedIdentity) {
  name: managedIdentityName
  location: location
}

resource existingDepScriptId 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = if (useExistingManagedIdentity) {
  name: managedIdentityName
  scope: resourceGroup(existingManagedIdentitySubId, existingManagedIdentityResourceGroupName)
}

resource rbac 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!empty(rbacRoleNeeded)) {
  name: guid(akv.id, rbacRoleNeeded, useExistingManagedIdentity ? existingDepScriptId.id : newDepScriptId.id)
  scope: akv
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', rbacRoleNeeded)
    principalId: useExistingManagedIdentity ? existingDepScriptId.properties.principalId : newDepScriptId.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

resource createSshKeyPair 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: useExistingManagedIdentity ? 'create-ssh-key-pair-${uniqueString(existingDepScriptId.id)}' : 'create-ssh-key-pair-${uniqueString(newDepScriptId.id)}'
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: { '${useExistingManagedIdentity ? existingDepScriptId.id : newDepScriptId.id}': {} }
  }
  kind: 'AzureCLI'
  dependsOn: [ rbac ]
  properties: {
    forceUpdateTag: forceUpdateTag
    azCliVersion: '2.45.0'
    timeout: 'PT15M'
    retentionInterval: 'PT1H'
    environmentVariables: [
      { name: 'keyVaultName', value: akv.name }
      { name: 'sshKeyNamePrivate', value: privateKeySecretName }
      { name: 'sshKeyNamePublic', value: publicKeySecretName }
      { name: 'initialDelay', value: initialScriptDelay }
    ]
    scriptContent: loadTextContent('scripts/create-ssh-pair.sh')
    cleanupPreference: cleanupPreference
  }
}

@description('The URI of the public key secret in the Key Vault')
output publicKeyUri string = createSshKeyPair.properties.outputs.secretUris.public
@description('The URI of the private key secret in the Key Vault')
output privateKeyUri string = createSshKeyPair.properties.outputs.secretUris.private

@description('The name of the public key secret in the Key Vault')
output publicKeySecretName string = publicKeySecretName
@description('The name of the private key secret in the Key Vault')
output privateKeySecretName string = privateKeySecretName
