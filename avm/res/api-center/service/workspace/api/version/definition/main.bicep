metadata name = 'API Center Service Workspace API Version Definitions'
metadata description = 'This module deploys an API Center Service Workspace API Version Definition.'

@sys.description('Conditional. The name of the parent API Center service. Required if the template is used in a standalone deployment.')
param serviceName string

@sys.description('Conditional. The name of the parent workspace. Required if the template is used in a standalone deployment.')
param workspaceName string

@sys.description('Conditional. The name of the parent API. Required if the template is used in a standalone deployment.')
param apiName string

@sys.description('Conditional. The name of the parent API version. Required if the template is used in a standalone deployment.')
param versionName string

@sys.description('Required. The name of the API definition.')
@minLength(3)
@maxLength(90)
param name string

@sys.description('Required. The title of the API definition.')
@minLength(1)
@maxLength(50)
param title string

@sys.description('Optional. The description of the API definition.')
param description string?

resource service 'Microsoft.ApiCenter/services@2024-03-01' existing = {
  name: serviceName

  resource workspace 'workspaces' existing = {
    name: workspaceName

    resource api 'apis' existing = {
      name: apiName

      resource version 'versions' existing = {
        name: versionName
      }
    }
  }
}

resource definition 'Microsoft.ApiCenter/services/workspaces/apis/versions/definitions@2024-03-01' = {
  name: name
  parent: service::workspace::api::version
  properties: {
    title: title
    description: description
  }
}

@sys.description('The name of the API definition.')
output name string = definition.name

@sys.description('The resource ID of the API definition.')
output resourceId string = definition.id

@sys.description('The name of the resource group the API definition was created in.')
output resourceGroupName string = resourceGroup().name
