metadata name = 'API Center Service Workspace APIs'
metadata description = 'This module deploys an API Center Service Workspace API.'

@sys.description('Conditional. The name of the parent API Center service. Required if the template is used in a standalone deployment.')
param serviceName string

@sys.description('Conditional. The name of the parent workspace. Required if the template is used in a standalone deployment.')
param workspaceName string

@sys.description('Required. The name of the API.')
@minLength(3)
@maxLength(90)
param name string

@sys.description('Required. The title of the API.')
@minLength(1)
@maxLength(50)
param title string

@sys.description('Required. The kind of API.')
@allowed([
  'rest'
  'graphql'
  'grpc'
  'soap'
  'webhook'
  'websocket'
])
param kind string

@sys.description('Optional. The description of the API.')
@maxLength(1000)
param description string?

@sys.description('Optional. Short description of the API.')
@maxLength(200)
param summary string?

@sys.description('Optional. The custom metadata properties for the API.')
param customProperties object?

@sys.description('Optional. The external documentation for the API.')
param externalDocumentation array?

@sys.description('Optional. The contacts for the API.')
param contacts array?

@sys.description('Optional. The license information for the API.')
param license object?

@sys.description('Optional. The terms of service for the API.')
param termsOfService object?

@sys.description('Optional. The versions to create for the API.')
param versions versionType[]?

@sys.description('Optional. The deployments to create for the API.')
param deployments deploymentType[]?

resource service 'Microsoft.ApiCenter/services@2024-03-01' existing = {
  name: serviceName

  resource workspace 'workspaces' existing = {
    name: workspaceName
  }
}

resource api 'Microsoft.ApiCenter/services/workspaces/apis@2024-03-01' = {
  name: name
  parent: service::workspace
  properties: {
    title: title
    kind: kind
    description: description
    summary: summary
    customProperties: customProperties
    externalDocumentation: externalDocumentation
    contacts: contacts
    license: license
    termsOfService: termsOfService
  }
}

module api_versions 'version/main.bicep' = [
  for (version, index) in (versions ?? []): {
    name: '${uniqueString(deployment().name)}-Api-Version-${index}'
    params: {
      serviceName: serviceName
      workspaceName: workspaceName
      apiName: api.name
      name: version.name
      title: version.title
      lifecycleStage: version.lifecycleStage
      definitions: version.?definitions
    }
  }
]

module api_deployments 'deployment/main.bicep' = [
  for (apiDeployment, index) in (deployments ?? []): {
    name: '${uniqueString(deployment().name)}-Api-Deployment-${index}'
    params: {
      serviceName: serviceName
      workspaceName: workspaceName
      apiName: api.name
      name: apiDeployment.name
      title: apiDeployment.?title
      description: apiDeployment.?description
      environmentId: apiDeployment.?environmentId
      definitionId: apiDeployment.?definitionId
      state: apiDeployment.?state
      customProperties: apiDeployment.?customProperties
      server: apiDeployment.?server
    }
  }
]

@sys.description('The name of the API.')
output name string = api.name

@sys.description('The resource ID of the API.')
output resourceId string = api.id

type versionType = {
  @sys.description('Required. The name of the version.')
  @minLength(3)
  @maxLength(90)
  name: string

  @sys.description('Required. The title of the version.')
  @minLength(1)
  @maxLength(50)
  title: string

  @sys.description('Required. The lifecycle stage of the version.')
  lifecycleStage: ('design' | 'development' | 'testing' | 'preview' | 'production' | 'deprecated' | 'retired')

  @sys.description('Optional. The definitions to create for the version.')
  definitions: {
    @sys.description('Required. The name of the definition.')
    @minLength(3)
    @maxLength(90)
    name: string

    @sys.description('Required. The title of the definition.')
    @minLength(1)
    @maxLength(50)
    title: string

    @sys.description('Optional. The description of the definition.')
    description: string?
  }[]?
}

type deploymentType = {
  @sys.description('Required. The name of the deployment.')
  @minLength(3)
  @maxLength(90)
  name: string

  @sys.description('Optional. The title of the deployment.')
  @minLength(1)
  @maxLength(50)
  title: string?

  @sys.description('Optional. The description of the deployment.')
  @maxLength(500)
  description: string?

  @sys.description('Optional. The environment ID of the deployment.')
  environmentId: string?

  @sys.description('Optional. The definition ID of the deployment.')
  definitionId: string?

  @sys.description('Optional. The state of the deployment.')
  state: ('active' | 'inactive')?

  @sys.description('Optional. The custom metadata properties for the deployment.')
  customProperties: object?

  @sys.description('Optional. The server information of the deployment.')
  server: {
    @sys.description('Optional. The runtime URIs.')
    runtimeUri: string[]?
  }?
}
