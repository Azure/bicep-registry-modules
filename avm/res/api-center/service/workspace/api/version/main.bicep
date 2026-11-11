metadata name = 'API Center Service Workspace API Versions'
metadata description = 'This module deploys an API Center Service Workspace API Version.'

@sys.description('Conditional. The name of the parent API Center service. Required if the template is used in a standalone deployment.')
param serviceName string

@sys.description('Conditional. The name of the parent workspace. Required if the template is used in a standalone deployment.')
param workspaceName string

@sys.description('Conditional. The name of the parent API. Required if the template is used in a standalone deployment.')
param apiName string

@sys.description('Required. The name of the API version.')
@minLength(3)
@maxLength(90)
param name string

@sys.description('Required. The title of the API version.')
@minLength(1)
@maxLength(50)
param title string

@sys.description('Required. The lifecycle stage of the API version.')
param lifecycleStage ('design' | 'development' | 'testing' | 'preview' | 'production' | 'deprecated' | 'retired')

@sys.description('Optional. The definitions to create for the API version.')
param definitions definitionType[]?

resource service 'Microsoft.ApiCenter/services@2024-03-01' existing = {
  name: serviceName

  resource workspace 'workspaces' existing = {
    name: workspaceName

    resource api 'apis' existing = {
      name: apiName
    }
  }
}

resource version 'Microsoft.ApiCenter/services/workspaces/apis/versions@2024-03-01' = {
  name: name
  parent: service::workspace::api
  properties: {
    title: title
    lifecycleStage: lifecycleStage
  }
}

module version_definitions 'definition/main.bicep' = [
  for (definition, index) in (definitions ?? []): {
    name: '${uniqueString(version.id)}-Version-Definition-${index}'
    params: {
      serviceName: serviceName
      workspaceName: workspaceName
      apiName: apiName
      versionName: version.name
      name: definition.name
      title: definition.title
      description: definition.?description
    }
  }
]

@sys.description('The name of the API version.')
output name string = version.name

@sys.description('The resource ID of the API version.')
output resourceId string = version.id

@sys.description('The name of the resource group the API version was created in.')
output resourceGroupName string = resourceGroup().name

type definitionType = {
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
}
