metadata name = 'AKS Secure Baseline Subscription Resources'
metadata description = 'Deploys the Key Vault, Network Security Perimeter, shell identity access, and SSH key pair from the AKS1P subscription resource stage.'

param serviceName string
param location string
param keyVaultName string
param keyVaultResourceId string
param enableKeyVaultPurgeProtection bool
param shellIdentityResourceId string
param shellIdentityPrincipalId string
param deployKeyVaultNetworkSecurityPerimeter bool
param keyVaultNetworkSecurityPerimeterName string
param keyVaultNetworkSecurityPerimeterAccessMode ('Enforced' | 'Audit' | 'Learning')
param sshPublicKeySecretName string
param sshPrivateKeySecretName string
param generateSshKey bool
param tags resourceInput<'Microsoft.Resources/resourceGroups@2025-04-01'>.tags
param enableTelemetry bool

var deployKeyVault = empty(keyVaultResourceId)
var effectiveKeyVaultResourceId = deployKeyVault
  ? resourceId('Microsoft.KeyVault/vaults', keyVaultName)
  : keyVaultResourceId
var effectiveKeyVaultSubscriptionId = split(effectiveKeyVaultResourceId, '/')[2]
var effectiveKeyVaultResourceGroupName = split(effectiveKeyVaultResourceId, '/')[4]
var effectiveKeyVaultName = last(split(effectiveKeyVaultResourceId, '/'))

module keyVault 'br/public:avm/res/key-vault/vault:0.14.0' = if (deployKeyVault) {
  name: '${uniqueString(effectiveKeyVaultResourceId, location)}-KeyVault'
  params: {
    name: keyVaultName
    location: location
    enableRbacAuthorization: true
    enableVaultForTemplateDeployment: true
    enablePurgeProtection: enableKeyVaultPurgeProtection
    publicNetworkAccess: 'Disabled'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
    }
    roleAssignments: generateSshKey
      ? [
          {
            principalId: shellIdentityPrincipalId
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Key Vault Secrets Officer'
          }
        ]
      : []
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

module existingKeyVaultAccess 'ssh-key-lifecycle/existing-key-vault-access.bicep' = if (!deployKeyVault && generateSshKey) {
  scope: resourceGroup(effectiveKeyVaultSubscriptionId, effectiveKeyVaultResourceGroupName)
  name: '${uniqueString(effectiveKeyVaultResourceId, shellIdentityResourceId)}-KeyVaultAccess'
  params: {
    keyVaultName: effectiveKeyVaultName
    principalId: shellIdentityPrincipalId
  }
}

module keyVaultNetworkSecurityPerimeter 'br/public:avm/res/network/network-security-perimeter:0.1.4' = if (deployKeyVaultNetworkSecurityPerimeter) {
  name: '${uniqueString(deployment().name, location, serviceName)}-KeyVaultNsp'
  params: {
    location: location
    name: keyVaultNetworkSecurityPerimeterName
    profiles: [
      {
        name: 'default'
        accessRules: [
          {
            name: 'allow-subscription-inbound'
            direction: 'Inbound'
            subscriptions: [
              {
                id: '/subscriptions/${effectiveKeyVaultSubscriptionId}'
              }
            ]
          }
        ]
      }
    ]
    resourceAssociations: [
      {
        name: 'key-vault-association'
        privateLinkResource: effectiveKeyVaultResourceId
        profile: 'default'
        accessMode: keyVaultNetworkSecurityPerimeterAccessMode
      }
    ]
    tags: tags
    enableTelemetry: enableTelemetry
  }
  dependsOn: [
    keyVault
  ]
}

module sshKeyLifecycle 'ssh-key-lifecycle/main.bicep' = if (generateSshKey) {
  name: '${uniqueString(deployment().name, location, serviceName)}-SshKeyLifecycle'
  params: {
    location: location
    keyVaultSubscriptionId: effectiveKeyVaultSubscriptionId
    keyVaultName: effectiveKeyVaultName
    scriptIdentityResourceId: shellIdentityResourceId
    sshPublicKeySecretName: sshPublicKeySecretName
    sshPrivateKeySecretName: sshPrivateKeySecretName
    tags: tags
  }
  dependsOn: [
    keyVault
    existingKeyVaultAccess
    keyVaultNetworkSecurityPerimeter
  ]
}

output keyVaultResourceId string = effectiveKeyVaultResourceId
output sshPublicKeySecretName string = generateSshKey ? sshPublicKeySecretName : ''
output sshPrivateKeySecretName string = generateSshKey ? sshPrivateKeySecretName : ''
output sshPublicKey string = generateSshKey ? sshKeyLifecycle!.outputs.sshPublicKey : ''
output keyVaultNetworkSecurityPerimeterResourceId string? = deployKeyVaultNetworkSecurityPerimeter
  ? keyVaultNetworkSecurityPerimeter!.outputs.resourceId
  : null
