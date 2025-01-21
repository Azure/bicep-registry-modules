metadata name = 'Azure Container Registry (ACR) Webhooks'
metadata description = 'This module deploys an Azure Container Registry (ACR) Webhook.'

@description('Conditional. The name of the parent registry. Required if the template is used in a standalone deployment.')
param registryName string

@description('Optional. The name of the registry webhook.')
@minLength(5)
@maxLength(50)
param name string = '${registryName}webhook'

@description('Required. The service URI for the webhook to post notifications.')
param serviceUri string

@allowed([
  'disabled'
  'enabled'
])
@description('Optional. The status of the webhook at the time the operation was called.')
param status string = 'enabled'

@description('Optional. The list of actions that trigger the webhook to post notifications.')
param action array = [
  'chart_delete'
  'chart_push'
  'delete'
  'push'
  'quarantine'
]

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Custom headers that will be added to the webhook notifications.')
param customHeaders object?

@description('Optional. The scope of repositories where the event can be triggered. For example, \'foo:*\' means events for all tags under repository \'foo\'. \'foo:bar\' means events for \'foo:bar\' only. \'foo\' is equivalent to \'foo:latest\'. Empty means all events.')
param scope string?

resource registry 'Microsoft.ContainerRegistry/registries@2023-06-01-preview' existing = {
  name: registryName
}

resource webhook 'Microsoft.ContainerRegistry/registries/webhooks@2023-06-01-preview' = {
  name: name
  parent: registry
  location: location
  tags: tags
  properties: {
    actions: action
    customHeaders: customHeaders
    scope: scope
    serviceUri: serviceUri
    status: status
  }
}

@description('The resource ID of the webhook.')
output resourceId string = webhook.id

@description('The name of the webhook.')
output name string = webhook.name

@description('The name of the Azure container registry.')
output resourceGroupName string = resourceGroup().name

@description('The actions of the webhook.')
output actions array = webhook.properties.actions

@description('The status of the webhook.')
output status string = webhook.properties.status

@description('The provisioning state of the webhook.')
output provistioningState string = webhook.properties.provisioningState

@description('The location the resource was deployed into.')
output location string = webhook.location
