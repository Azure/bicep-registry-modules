@description('Required. The name of the Synapse workspace.')
param workspaceName string

@description('Required. The name of the existing workspace key.')
param keyName string

@description('Required. The expected Key Vault key URL.')
param keyVaultUrl string

@description('Required. The location of the activation helper resources.')
param location string

@description('Optional. Tags for the activation helper resources.')
param tags resourceInput<'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30'>.tags?

@description('Optional. Recheck activation on each deployment without changing helper resource names.')
param forceUpdateTag string = utcNow()

var activationCommand = '''
  $ErrorActionPreference = 'Stop'
  $DeploymentScriptOutputs = Invoke-SynapseCmkActivation -KeyResourceId $env:WORKSPACE_KEY_RESOURCE_ID -KeyVaultUrl $env:KEY_VAULT_URL
  '''

resource workspace 'Microsoft.Synapse/workspaces@2021-06-01' existing = {
  name: workspaceName
}

resource workspaceKey 'Microsoft.Synapse/workspaces/keys@2021-06-01' existing = {
  parent: workspace
  name: keyName
}

resource activationIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: 'cmk-activation-${uniqueString(workspace.id, keyName)}'
  location: location
  tags: tags
}

resource activationRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(workspaceKey.id, activationIdentity.id, 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  scope: workspaceKey
  properties: {
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'b24988ac-6180-42a0-ab88-20f7382dd24c'
    )
    principalId: activationIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

resource activationScript 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: 'cmk-activation-${uniqueString(workspace.id, keyName)}'
  location: location
  tags: tags
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${activationIdentity.id}': {}
    }
  }
  properties: {
    azPowerShellVersion: '12.0'
    forceUpdateTag: forceUpdateTag
    timeout: 'PT15M'
    retentionInterval: 'P1D'
    cleanupPreference: 'Always'
    environmentVariables: [
      {
        name: 'WORKSPACE_KEY_RESOURCE_ID'
        value: workspaceKey.id
      }
      {
        name: 'KEY_VAULT_URL'
        value: keyVaultUrl
      }
    ]
    scriptContent: '${loadTextContent('Invoke-SynapseCmkActivation.ps1')}\n${activationCommand}'
  }
  dependsOn: [
    activationRoleAssignment
  ]
}
