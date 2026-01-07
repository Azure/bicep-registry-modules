metadata name = 'API Management Workspace Named Values'
metadata description = 'This module deploys a Named Value in an API Management Workspace.'

@description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@description('Conditional. The name of the parent Workspace. Required if the template is used in a standalone deployment.')
param workspaceName string

@minLength(1)
@maxLength(256)
@description('Required. Unique name of NamedValue. It may contain only letters, digits, period, dash, and underscore characters.')
param displayName string

@description('Optional. KeyVault location details of the namedValue.')
param keyVault resourceInput<'Microsoft.ApiManagement/service/workspaces/namedValues@2024-05-01'>.properties.keyVault?

@description('Required. The name of the named value.')
param name string

@description('Optional. Tags that when provided can be used to filter the NamedValue list.')
param tags resourceInput<'Microsoft.ApiManagement/service/workspaces/namedValues@2024-05-01'>.properties.tags?

@description('Optional. Determines whether the value is a secret and should be encrypted or not.')
param secret bool = false

@description('Optional. Value of the NamedValue. Can contain policy expressions. It may not be empty or consist only of whitespace. This property will not be filled on \'GET\' operations! Use \'/listSecrets\' POST request to get the value.')
@secure()
@maxLength(4096)
param value string = newGuid()

resource service 'Microsoft.ApiManagement/service@2024-05-01' existing = {
  name: apiManagementServiceName

  resource workspace 'workspaces@2024-05-01' existing = {
    name: workspaceName
  }
}

resource namedValue 'Microsoft.ApiManagement/service/workspaces/namedValues@2024-05-01' = {
  name: name
  parent: service::workspace
  properties: {
    tags: tags
    secret: secret
    displayName: displayName
    value: empty(keyVault) ? value : null
    keyVault: keyVault
  }
}

@description('The resource ID of the workspace named value.')
output resourceId string = namedValue.id

@description('The name of the workspace named value.')
output name string = namedValue.name

@description('The resource group the workspace named value was deployed into.')
output resourceGroupName string = resourceGroup().name
