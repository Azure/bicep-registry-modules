metadata name = 'AI Gateway Model Provider'
metadata description = 'Configures a Foundry or custom provider and its model catalog.'

import { modelType } from './model/main.bicep'

@description('Required. Parent gateway name.')
param aiGatewayName string
@description('Required. Parent workspace name.')
param workspaceName string
@description('Required. Model provider resource name.')
param name string
@description('Required. Typed provider configuration.')
param properties modelProviderPropertiesType
@description('Optional. Models registered under this provider.')
param models modelType[]?
@secure()
@description('Optional. Secure upstream API key values.')
param secrets { *: string } = {}

var configuration = properties.kind == 'Foundry' ? properties.foundry : properties.custom
var authentication = configuration.authentication
var wireAuthentication = authentication.kind == 'ManagedIdentity'
  ? authentication
  : {
      kind: 'ApiKey'
      apiKey: {
        headerName: authentication.apiKey.headerName
        value: secrets[authentication.apiKey.secretName]
      }
    }

#disable-next-line BCP081
resource gateway 'Microsoft.ApiManagement/aigateways@2025-09-01-preview' existing = {
  name: aiGatewayName
}
#disable-next-line BCP081
resource workspace 'Microsoft.ApiManagement/aigateways/workspaces@2025-09-01-preview' existing = {
  parent: gateway
  name: workspaceName
}

var assignUpstreamRole = properties.kind == 'Foundry' && (properties.foundry.?assignUpstreamRole ?? false)
var upstreamFoundryResourceIds = properties.kind == 'Foundry' ? properties.foundry.resourceIds : []

module upstreamRoleAssignments './foundry-role-assignment.bicep' = [
  for (foundryResourceId, index) in (assignUpstreamRole ? upstreamFoundryResourceIds : []): {
    name: '${uniqueString(deployment().name, foundryResourceId)}-FoundryRole-${index}'
    scope: az.resourceGroup(split(foundryResourceId, '/')[2], split(foundryResourceId, '/')[4])
    params: {
      foundryAccountName: last(split(foundryResourceId, '/'))
      principalId: gateway.identity.principalId
      gatewayResourceId: gateway.id
    }
  }
]

#disable-next-line BCP081
resource provider 'Microsoft.ApiManagement/aigateways/workspaces/modelProviders@2025-09-01-preview' = {
  name: name
  parent: workspace
  dependsOn: [
    upstreamRoleAssignments
  ]
  properties: union(
    {
      kind: properties.kind
      displayName: properties.displayName
      description: properties.?description
    },
    properties.kind == 'Foundry'
      ? {
          foundry: {
            endpoint: properties.foundry.endpoint
            resourceIds: properties.foundry.resourceIds
            authentication: wireAuthentication
          }
        }
      : {
          custom: {
            endpoint: properties.custom.endpoint
            authentication: wireAuthentication
          }
        }
  )
}

module provider_models './model/main.bicep' = [
  for (model, index) in (models ?? []): {
    name: '${uniqueString(deployment().name)}-Model-${index}'
    params: {
      aiGatewayName: aiGatewayName
      workspaceName: workspaceName
      modelProviderName: provider.name
      name: model.name
      properties: model.properties
    }
  }
]

@description('The provider resource ID.')
output resourceId string = provider.id
@description('The provider name.')
output name string = provider.name
@description('The resource group name.')
output resourceGroupName string = resourceGroup().name
@description('The registered model resource IDs.')
output modelResourceIds string[] = [for (model, index) in (models ?? []): provider_models[index].outputs.resourceId]

@export()
@sealed()
@description('Provider configuration and nested catalog models.')
type modelProviderType = {
  name: string
  properties: modelProviderPropertiesType
  models: modelType[]?
}
@export()
@discriminator('kind')
@description('Provider kind selects its required configuration.')
type modelProviderPropertiesType = foundryProviderPropertiesType | customProviderPropertiesType
@sealed()
type foundryProviderPropertiesType = {
  kind: 'Foundry'
  displayName: string
  description: string?
  foundry: {
    endpoint: string
    @minLength(1)
    resourceIds: string[]
    assignUpstreamRole: bool?
    authentication: authenticationType
  }
}
@sealed()
type customProviderPropertiesType = {
  kind: 'Custom'
  displayName: string
  description: string?
  custom: {
    endpoint: string
    authentication: apiKeyAuthenticationType
  }
}
@export()
@discriminator('kind')
@description('Upstream provider authentication.')
type authenticationType = managedIdentityAuthenticationType | apiKeyAuthenticationType
@sealed()
type managedIdentityAuthenticationType = {
  kind: 'ManagedIdentity'
  managedIdentity: {
    resource: string?
    clientId: string?
  }
}
@sealed()
type apiKeyAuthenticationType = {
  kind: 'ApiKey'
  apiKey: {
    headerName: string
    secretName: string
  }
}
