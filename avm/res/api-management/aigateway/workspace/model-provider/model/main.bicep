metadata name = 'AI Gateway Model'
metadata description = 'Registers a provider model and applies inline governance policies.'

@description('Required. Parent gateway name.')
param aiGatewayName string
@description('Required. Parent workspace name.')
param workspaceName string
@description('Required. Parent model provider name.')
param modelProviderName string
@description('Required. Model resource name.')
param name string
@description('Required. Model deployment and runtime configuration.')
param properties modelPropertiesType

#disable-next-line BCP081
resource provider 'Microsoft.ApiManagement/aigateways/workspaces/modelProviders@2025-09-01-preview' existing = {
  name: '${aiGatewayName}/${workspaceName}/${modelProviderName}'
}
#disable-next-line BCP081
resource model 'Microsoft.ApiManagement/aigateways/workspaces/modelProviders/models@2025-09-01-preview' = {
  name: name
  parent: provider
  properties: properties
}

@description('The model resource ID.')
output resourceId string = model.id
@description('The model name.')
output name string = model.name
@description('The resource group name.')
output resourceGroupName string = resourceGroup().name

@export()
@sealed()
@description('Catalog model configuration.')
type modelType = {
  name: string
  properties: modelPropertiesType
}
@export()
@sealed()
@description('Model wire properties.')
type modelPropertiesType = {
  displayName: string
  description: string?
  apiFormat: string
  @minLength(1)
  supportedEndpoints: string[]
  deployment: {
    resourceId: string?
    modelName: string
    modelVersion: string?
  }
  policies: policyType[]?
}
@export()
@discriminator('type')
@description('Typed inline governance policies supported by this draft.')
type policyType = tokenLimitPolicyType | costLimitPolicyType | contentSafetyPolicyType
@export()
@sealed()
@description('Token limit policy with public counter dimensions.')
type tokenLimitPolicyType = {
  type: 'tokenLimit'
  scope: ('resource' | 'workspace')?
  @minValue(1)
  count: int
  period: 'minute' | 'hour' | 'day'
  @minLength(1)
  @maxLength(2)
  counterKey: ('identity' | 'ipAddress')[]
}
@export()
@sealed()
@description('Cost limit policy. Amounts are whole USD in this draft.')
type costLimitPolicyType = {
  type: 'costLimit'
  id: string
  scope: ('resource' | 'workspace')?
  @minValue(1)
  amount: int
  period: 'hour' | 'day' | 'week' | 'month' | 'year'
  @minLength(1)
  @maxLength(2)
  counterKey: ('identity' | 'ipAddress')[]
}
@export()
@sealed()
@description('Content safety policy thresholds.')
type contentSafetyPolicyType = {
  type: 'contentSafety'
  hateSeverity: ('Low' | 'Medium' | 'High' | 'None')?
  selfHarmSeverity: ('Low' | 'Medium' | 'High' | 'None')?
  sexualSeverity: ('Low' | 'Medium' | 'High' | 'None')?
  violenceSeverity: ('Low' | 'Medium' | 'High' | 'None')?
}
