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

@sys.description('Optional. The API sources to create in the workspace for importing APIs from external sources.')
param apiSources apiSourceType[]?

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
    name: '${uniqueString(workspace.id)}-Workspace-Environment-${index}'
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
    name: '${uniqueString(workspace.id)}-Workspace-Api-${index}'
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
    dependsOn: [
      workspace_environments
    ]
  }
]

module workspace_apiSources 'api-source/main.bicep' = [
  for (apiSource, index) in (apiSources ?? []): {
    name: '${uniqueString(workspace.id)}-Workspace-ApiSource-${index}'
    params: {
      serviceName: serviceName
      workspaceName: workspace.name
      name: apiSource.name
      importSpecification: apiSource.?importSpecification
      targetEnvironment: apiSource.?targetEnvironment
      targetLifecycleStage: apiSource.?targetLifecycleStage
      azureApiManagementSource: apiSource.?azureApiManagementSource
    }
    dependsOn: [
      workspace_environments
    ]
  }
]

@sys.description('The name of the workspace.')
output name string = workspace.name

@sys.description('The resource ID of the workspace.')
output resourceId string = workspace.id

@sys.description('The name of the resource group the workspace was created in.')
output resourceGroupName string = resourceGroup().name

import { environmentServerType } from 'environment/main.bicep'
import { environmentOnboardingType } from 'environment/main.bicep'

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

  @sys.description('Optional. The custom metadata defined for API catalog entities.')
  customProperties: resourceInput<'Microsoft.ApiCenter/services/workspaces/environments@2024-03-01'>.properties.customProperties?

  @sys.description('Optional. Server information of the environment.')
  server: environmentServerType?

  @sys.description('Optional. Onboarding information for the environment.')
  onboarding: environmentOnboardingType?
}

import { externalDocumentationType, contactType, licenseType, termsOfServiceType, versionType, deploymentType } from 'api/main.bicep'

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

  @sys.description('Optional. The custom metadata defined for API catalog entities.')
  customProperties: resourceInput<'Microsoft.ApiCenter/services/workspaces/apis@2024-03-01'>.properties.customProperties?

  @sys.description('Optional. External documentation for the API.')
  externalDocumentation: externalDocumentationType[]?

  @sys.description('Optional. The contacts for the API.')
  contacts: contactType[]?

  @sys.description('Optional. The license information for the API.')
  license: licenseType?

  @sys.description('Optional. The terms of service for the API.')
  termsOfService: termsOfServiceType?

  @sys.description('Optional. The versions for the API.')
  versions: versionType[]?

  @sys.description('Optional. The deployments for the API.')
  deployments: deploymentType[]?
}

import { azureApiManagementSourceType } from 'api-source/main.bicep'

@export()
type apiSourceType = {
  @sys.description('Required. The name of the API source.')
  @minLength(3)
  @maxLength(90)
  name: string

  @sys.description('Optional. Indicates if the specification should be imported along with metadata.')
  importSpecification: ('never' | 'ondemand' | 'always')?

  @sys.description('Optional. The target environment name. If not provided a new environment will be created.')
  targetEnvironment: string?

  @sys.description('Optional. The target lifecycle stage for imported APIs.')
  targetLifecycleStage: ('design' | 'development' | 'testing' | 'preview' | 'production' | 'deprecated' | 'retired')?

  @sys.description('Required. Configuration for importing APIs from Azure API Management.')
  azureApiManagementSource: azureApiManagementSourceType
}
