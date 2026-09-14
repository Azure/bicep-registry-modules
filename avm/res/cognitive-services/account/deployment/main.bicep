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

@description('Optional. Model-provider attestation required by the Cognitive Services resource provider for partner models such as Anthropic Claude, used to auto-accept the provider\'s Azure Marketplace offer. Documented in [Deploy and use Claude on Microsoft Foundry](https://learn.microsoft.com/en-us/azure/developer/ai/how-to/deploy-claude-foundry#terms-of-use). This property is not yet reflected in the published `Microsoft.CognitiveServices/accounts/deployments` OpenAPI spec (tracked in [Azure/azure-rest-api-specs#43610](https://github.com/Azure/azure-rest-api-specs/issues/43610)), so its exact shape may still change once the spec is updated.')
param modelProviderData modelProviderDataType?

resource cognitiveServiceAccount 'Microsoft.CognitiveServices/accounts@2025-06-01' existing = {
  name: accountName
}

// modelProviderData is required by the RP for Anthropic Claude deployments and is documented at
// https://learn.microsoft.com/en-us/azure/developer/ai/how-to/deploy-claude-foundry#terms-of-use,
// but is still absent from the OpenAPI spec - see https://github.com/Azure/azure-rest-api-specs/issues/43610
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
  industry:
    | 'technology'
    | 'finance'
    | 'healthcare'
    | 'education'
    | 'retail'
    | 'manufacturing'
    | 'government'
    | 'media'
    | 'other'
}
