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

@description('Optional. Model-provider attestation required for GA partner models such as Anthropic Claude.')
param modelProviderData modelProviderDataType?

@description('Optional. Enable or disable usage telemetry for the module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.cognitiveservices-account-deployment.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

resource cognitiveServiceAccount 'Microsoft.CognitiveServices/accounts@2025-06-01' existing = {
  name: accountName
}

// 2026-05-01 is the minimum GA API version that supports modelProviderData.
#disable-next-line BCP081
resource cognitiveServiceDeployment 'Microsoft.CognitiveServices/accounts/deployments@2026-05-01' = {
  parent: cognitiveServiceAccount
  name: name
  properties: {
    model: model
    raiPolicyName: raiPolicyName
    versionUpgradeOption: versionUpgradeOption
    modelProviderData: modelProviderData
  }
  sku: sku
}

@description('The name of the Cognitive Services account deployment.')
output name string = cognitiveServiceDeployment.name

@description('The resource ID of the Cognitive Services account deployment.')
output resourceId string = cognitiveServiceDeployment.id

@description('The name of the resource group in which the deployment was created.')
output resourceGroupName string = resourceGroup().name

// =============== //
//   Definitions   //
// =============== //

@export()
@description('Model-provider attestation information.')
type modelProviderDataType = {
  @description('Required. Legal entity name of the organization deploying the model.')
  organizationName: string

  @description('Required. Two-letter ISO 3166-1 alpha-2 country or region code.')
  countryCode: string

  @description('Required. The organization industry accepted by the resource provider.')
  industry: string
}

@export()
@description('The type for a Cognitive Services account deployment.')
type deploymentType = {
  @description('Optional. The name of the Cognitive Services account deployment.')
  name: string?

  @description('Required. Properties of the deployment model.')
  model: resourceInput<'Microsoft.CognitiveServices/accounts/deployments@2025-06-01'>.properties.model

  @description('Optional. The resource model definition representing the SKU.')
  sku: resourceInput<'Microsoft.CognitiveServices/accounts/deployments@2025-06-01'>.sku?

  @description('Optional. The name of the RAI policy.')
  raiPolicyName: string?

  @description('Optional. The version upgrade option.')
  versionUpgradeOption: string?

  @description('Optional. Model-provider attestation required for GA partner models.')
  modelProviderData: modelProviderDataType?
}
