metadata name = 'API Center Service Workspaces'
metadata description = 'This module deploys an API Center Service Workspace.'

@sys.description('Required. The name of the parent API Center service.')
param serviceName string

@sys.description('Required. The name of the workspace.')
@minLength(3)
@maxLength(90)
param name string

@sys.description('Required. The title of the workspace.')
@minLength(1)
@maxLength(50)
param title string

@sys.description('Optional. The description of the workspace.')
param description string?

@sys.description('Optional. The environments to create in the workspace.')
param environments environmentType[]?

@sys.description('Optional. The APIs to create in the workspace.')
param apis apiType[]?

resource service 'Microsoft.ApiCenter/services@2024-03-01' existing = {
  name: serviceName
}

resource workspace 'Microsoft.ApiCenter/services/workspaces@2024-03-01' = {
  name: name
  parent: service
  properties: {
    title: title
    description: description
  }
}

module workspace_environments 'environment/main.bicep' = [
  for (environment, index) in (environments ?? []): {
    name: '${uniqueString(deployment().name)}-Workspace-Environment-${index}'
    params: {
      serviceName: serviceName
      workspaceName: workspace.name
      name: environment.name
      title: environment.title
      kind: environment.kind
      description: environment.?description
      customProperties: environment.?customProperties
      server: environment.?server
      onboarding: environment.?onboarding
    }
  }
]

module workspace_apis 'api/main.bicep' = [
  for (api, index) in (apis ?? []): {
    name: '${uniqueString(deployment().name)}-Workspace-Api-${index}'
    params: {
      serviceName: serviceName
      workspaceName: workspace.name
      name: api.name
      title: api.title
      kind: api.kind
      description: api.?description
      summary: api.?summary
      customProperties: api.?customProperties
      externalDocumentation: api.?externalDocumentation
      contacts: api.?contacts
      license: api.?license
      termsOfService: api.?termsOfService
      versions: api.?versions
      deployments: api.?deployments
    }
  }
]

@sys.description('The name of the workspace.')
output name string = workspace.name

@sys.description('The resource ID of the workspace.')
output resourceId string = workspace.id

@export()
type environmentType = {
  @sys.description('Required. The name of the environment.')
  @minLength(3)
  @maxLength(90)
  name: string

  @sys.description('Required. The title of the environment.')
  @minLength(1)
  @maxLength(50)
  title: string

  @sys.description('Required. The kind of environment.')
  kind: ('development' | 'testing' | 'staging' | 'production')

  @sys.description('Optional. The description of the environment.')
  description: string?

  @sys.description('Optional. The custom metadata properties for the environment.')
  customProperties: object?

  @sys.description('Optional. Server information of the environment.')
  server: {
    @sys.description('Optional. The management portal URIs.')
    managementPortalUri: string[]?

    @sys.description('Optional. The type of server.')
    type: (
      | 'Azure API Management'
      | 'Azure compute service'
      | 'Apigee API Management'
      | 'AWS API Gateway'
      | 'Kong API Gateway'
      | 'Kubernetes'
      | 'MuleSoft API Management')?
  }?

  @sys.description('Optional. Onboarding information for the environment.')
  onboarding: {
    @sys.description('Optional. The developer portal URIs.')
    developerPortalUri: string[]?

    @sys.description('Optional. Onboarding instructions.')
    instructions: string?
  }?
}

@export()
type apiType = {
  @sys.description('Required. The name of the API.')
  @minLength(3)
  @maxLength(90)
  name: string

  @sys.description('Required. The title of the API.')
  @minLength(1)
  @maxLength(50)
  title: string

  @sys.description('Required. The kind of API.')
  kind: ('rest' | 'graphql' | 'grpc' | 'soap' | 'webhook' | 'websocket')

  @sys.description('Optional. The description of the API.')
  @maxLength(1000)
  description: string?

  @sys.description('Optional. Short description of the API.')
  @maxLength(200)
  summary: string?

  @sys.description('Optional. The custom metadata properties for the API.')
  customProperties: object?

  @sys.description('Optional. The external documentation for the API.')
  externalDocumentation: {
    @sys.description('Required. The URL of the documentation.')
    @maxLength(200)
    url: string

    @sys.description('Optional. The title of the documentation.')
    @maxLength(50)
    title: string?

    @sys.description('Optional. The description of the documentation.')
    @maxLength(500)
    description: string?
  }[]?

  @sys.description('Optional. The contacts for the API.')
  contacts: {
    @sys.description('Optional. The name of the contact.')
    @maxLength(100)
    name: string?

    @sys.description('Optional. The email of the contact.')
    @maxLength(100)
    email: string?

    @sys.description('Optional. The URL of the contact.')
    @maxLength(200)
    url: string?
  }[]?

  @sys.description('Optional. The license information for the API.')
  license: {
    @sys.description('Optional. SPDX license identifier.')
    @maxLength(50)
    identifier: string?

    @sys.description('Optional. The name of the license.')
    @maxLength(100)
    name: string?

    @sys.description('Optional. The URL of the license.')
    @maxLength(200)
    url: string?
  }?

  @sys.description('Optional. The terms of service for the API.')
  termsOfService: {
    @sys.description('Required. The URL of the terms of service.')
    @maxLength(200)
    url: string
  }?

  @sys.description('Optional. The versions to create for the API.')
  versions: {
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
  }[]?

  @sys.description('Optional. The deployments to create for the API.')
  deployments: {
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
  }[]?
}
