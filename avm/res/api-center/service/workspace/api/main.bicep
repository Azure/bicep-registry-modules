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
param kind ('rest' | 'graphql' | 'grpc' | 'soap' | 'webhook' | 'websocket')

@sys.description('Optional. The description of the API.')
@maxLength(1000)
param description string?

@sys.description('Optional. Short description of the API.')
@maxLength(200)
param summary string?

@sys.description('Optional. The custom metadata defined for API catalog entities.')
param customProperties resourceInput<'Microsoft.ApiCenter/services/workspaces/apis@2024-03-01'>.properties.customProperties?

@sys.description('Optional. The external documentation for the API.')
param externalDocumentation externalDocumentationType[]?

@sys.description('Optional. The contacts for the API.')
param contacts contactType[]?

@sys.description('Optional. The license information for the API.')
param license licenseType?

@sys.description('Optional. The terms of service for the API.')
param termsOfService termsOfServiceType?

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
    name: '${uniqueString(api.id)}-Api-Version-${index}'
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
    name: '${uniqueString(api.id)}-Api-Deployment-${index}'
    params: {
      serviceName: serviceName
      workspaceName: workspaceName
      apiName: api.name
      name: apiDeployment.name
      title: apiDeployment.?title
      description: apiDeployment.?description
      environment: apiDeployment.environment
      version: apiDeployment.version
      definition: apiDeployment.definition
      state: apiDeployment.?state
      customProperties: apiDeployment.?customProperties
      server: apiDeployment.?server
    }
    dependsOn: [
      api_versions
    ]
  }
]

@sys.description('The name of the API.')
output name string = api.name

@sys.description('The resource ID of the API.')
output resourceId string = api.id

@sys.description('The name of the resource group the API was created in.')
output resourceGroupName string = resourceGroup().name

@export()
type externalDocumentationType = {
  @sys.description('Required. The URL pointing to the documentation.')
  @maxLength(200)
  url: string

  @sys.description('Optional. The title of the documentation.')
  @maxLength(50)
  title: string?

  @sys.description('Optional. The description of the documentation.')
  @maxLength(500)
  description: string?
}

@export()
type contactType = {
  @sys.description('Optional. The name of the contact.')
  @maxLength(100)
  name: string?

  @sys.description('Optional. The email of the contact.')
  @maxLength(100)
  email: string?

  @sys.description('Optional. The URL of the contact.')
  @maxLength(200)
  url: string?
}

@export()
type licenseType = {
  @sys.description('Optional. SPDX license identifier. Mutually exclusive with url.')
  @maxLength(50)
  identifier: string?

  @sys.description('Optional. The name of the license.')
  @maxLength(100)
  name: string?

  @sys.description('Optional. URL pointing to the license details. Mutually exclusive with identifier.')
  @maxLength(200)
  url: string?
}

@export()
type termsOfServiceType = {
  @sys.description('Required. URL pointing to the terms of service.')
  @maxLength(200)
  url: string
}

import { deploymentServerType } from 'deployment/main.bicep'

@export()
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

  @sys.description('Required. The target environment name of the deployment.')
  environment: string

  @sys.description('Required. The deployed version name.')
  version: string

  @sys.description('Required. The deployed definition name.')
  definition: string

  @sys.description('Optional. The state of the deployment.')
  state: ('active' | 'inactive')?

  @sys.description('Optional. The custom metadata defined for API catalog entities.')
  customProperties: resourceInput<'Microsoft.ApiCenter/services/workspaces/apis/deployments@2024-03-01'>.properties.customProperties?

  @sys.description('Optional. The server information of the deployment.')
  server: deploymentServerType?
}

@export()
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
