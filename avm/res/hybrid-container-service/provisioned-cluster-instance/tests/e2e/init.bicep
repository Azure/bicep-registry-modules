param customLocationResourceId string

resource identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: 'aksarc-init'
  location: resourceGroup().location
}

resource wait 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: '${deployment().name}-aksarc-wait'
  location: resourceGroup().location
  dependsOn: [
    identity
  ]
  kind: 'AzurePowerShell'
  properties: {
    azPowerShellVersion: '13.2'
    scriptContent: 'Start-Sleep -Seconds 120'
    timeout: 'PT60M'
    retentionInterval: 'PT2H'
  }
}

var AKSACRole = '5d3f1697-4507-4d08-bb4a-477695db5f82' // 'Azure Kubernetes Service Arc Contributor Role'

resource rbac 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('init', AKSACRole, resourceGroup().id)
  dependsOn: [
    wait
  ]
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', AKSACRole)
    principalId: identity.properties.principalId
  }
}

resource script 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: '${deployment().name}-aksarc-init'
  location: resourceGroup().location
  dependsOn: [
    rbac
  ]
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${identity.id}': {}
    }
  }
  properties: {
    azPowerShellVersion: '13.2'
    scriptContent: loadTextContent('./Initialize-KubernetesDefaultVersion.ps1')
    arguments: '-CustomLocationResourceId ${customLocationResourceId}'
    timeout: 'PT60M'
    retentionInterval: 'PT2H'
  }
}

resource logs 'Microsoft.Resources/deploymentScripts/logs@2023-08-01' existing = {
  parent: script
  name: 'default'
}

output logs string = logs.properties.log
