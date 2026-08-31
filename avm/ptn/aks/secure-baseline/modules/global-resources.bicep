metadata name = 'AKS Secure Baseline Global Resources'
metadata description = 'Deploys the shared shell identity and optional Azure Container Registry from the AKS1P global resource stage.'

param location string
param sshKeyGenerationIdentityName string
param deployContainerRegistry bool
param containerRegistryName string
param tags resourceInput<'Microsoft.Resources/resourceGroups@2025-04-01'>.tags
param enableTelemetry bool

var shellIdentityResourceId = resourceId(
  'Microsoft.ManagedIdentity/userAssignedIdentities',
  sshKeyGenerationIdentityName
)

module shellIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.6.0' = {
  name: '${uniqueString(shellIdentityResourceId, location)}-ShellIdentity'
  params: {
    name: sshKeyGenerationIdentityName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

module containerRegistry 'br/public:avm/res/container-registry/registry:0.13.0' = if (deployContainerRegistry) {
  name: '${uniqueString(containerRegistryName, location)}-ContainerRegistry'
  params: {
    name: containerRegistryName
    location: location
    acrAdminUserEnabled: false
    acrSku: 'Standard'
    roleAssignmentMode: 'AbacRepositoryPermissions'
    quarantinePolicyStatus: 'disabled'
    trustPolicyStatus: 'disabled'
    retentionPolicyStatus: 'disabled'
    exportPolicyStatus: 'enabled'
    azureADAuthenticationAsArmPolicyStatus: 'enabled'
    dataEndpointEnabled: false
    publicNetworkAccess: 'Enabled'
    networkRuleBypassOptions: 'AzureServices'
    networkRuleBypassAllowedForTasks: false
    networkRuleSetDefaultAction: 'Allow'
    anonymousPullEnabled: false
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

output shellIdentityResourceId string = shellIdentity.outputs.resourceId
output shellIdentityPrincipalId string = shellIdentity.outputs.principalId
output shellIdentityClientId string = shellIdentity.outputs.clientId
output containerRegistryResourceId string? = deployContainerRegistry ? containerRegistry!.outputs.resourceId : null
output containerRegistryLoginServer string? = deployContainerRegistry ? containerRegistry!.outputs.loginServer : null
