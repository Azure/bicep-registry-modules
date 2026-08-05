metadata name = 'Cognitive Services Account Deployment'
metadata description = 'This module deploys a Cognitive Services account model deployment.'

@description('Required. The name of the Cognitive Services account deployment.')
param name string

@description('Required. The name of the parent Cognitive Services account.')
param accountName string

@description('Required. Properties of the Cognitive Services account deployment model.')
param model resourceInput<'Microsoft.CognitiveServices/accounts/deployments@2025-06-01'>.properties.model

@description('Optional. The resource model definition representing the SKU.')
param sku resourceInput<'Microsoft.CognitiveServices/accounts/deployments@2025-06-01'>.sku = {
  name: 'Standard'
  capacity: 1
}

@description('Optional. The name of the RAI policy.')
param raiPolicyName string?

@description('Optional. The version upgrade option.')
param versionUpgradeOption string?

resource cognitiveServiceAccount 'Microsoft.CognitiveServices/accounts@2025-06-01' existing = {
  name: accountName
}

#disable-next-line BCP081
resource cognitiveServiceDeployment 'Microsoft.CognitiveServices/accounts/deployments@2026-05-01' = {
  parent: cognitiveServiceAccount
  name: name
  properties: {
    model: model
    raiPolicyName: raiPolicyName
    versionUpgradeOption: versionUpgradeOption
  }
  sku: sku
}

@description('The name of the Cognitive Services account deployment.')
output name string = cognitiveServiceDeployment.name

@description('The resource ID of the Cognitive Services account deployment.')
output resourceId string = cognitiveServiceDeployment.id

@description('The name of the resource group in which the deployment was created.')
output resourceGroupName string = resourceGroup().name
