metadata name = 'API Center Service Workspace API Deployments'
metadata description = 'This module deploys an API Center Service Workspace API Deployment.'

@sys.description('Conditional. The name of the parent API Center service. Required if the template is used in a standalone deployment.')
param serviceName string

@sys.description('Conditional. The name of the parent workspace. Required if the template is used in a standalone deployment.')
param workspaceName string

@sys.description('Conditional. The name of the parent API. Required if the template is used in a standalone deployment.')
param apiName string

@sys.description('Required. The name of the deployment.')
@minLength(3)
@maxLength(90)
param name string

@sys.description('Optional. The title of the deployment.')
@minLength(1)
@maxLength(50)
param title string?

@sys.description('Optional. The description of the deployment.')
@maxLength(500)
param description string?

@sys.description('Required. The target environment name of the deployment.')
param environment string

@sys.description('Required. The deployed version name.')
param version string

@sys.description('Required. The deployed definition name.')
param definition string

@sys.description('Optional. The state of the API deployment.')
param state ('active' | 'inactive')?

@sys.description('Optional. The custom metadata defined for API catalog entities.')
param customProperties resourceInput<'Microsoft.ApiCenter/services/workspaces/apis/deployments@2024-03-01'>.properties.customProperties?

@sys.description('Optional. The server information of the deployment.')
param server deploymentServerType?

resource service 'Microsoft.ApiCenter/services@2024-03-01' existing = {
  name: serviceName

  resource workspace 'workspaces' existing = {
    name: workspaceName

    resource api 'apis' existing = {
      name: apiName
    }
  }
}

resource apiDeployment 'Microsoft.ApiCenter/services/workspaces/apis/deployments@2024-03-01' = {
  name: name
  parent: service::workspace::api
  properties: {
    title: title
    description: description
    environmentId: '/workspaces/${workspaceName}/environments/${environment}'
    definitionId: '/workspaces/${workspaceName}/apis/${apiName}/versions/${version}/definitions/${definition}'
    state: state
    customProperties: customProperties
    server: server == null || server.?runtimeUri == null ? { runtimeUri: [] } : server
  }
}

@sys.description('The name of the API deployment.')
output name string = apiDeployment.name

@sys.description('The resource ID of the API deployment.')
output resourceId string = apiDeployment.id

@sys.description('The name of the resource group the API deployment was created in.')
output resourceGroupName string = resourceGroup().name

@export()
type deploymentServerType = {
  @sys.description('Optional. The base runtime URIs for this deployment.')
  runtimeUri: string[]?
}
