metadata name = 'API Center Service Workspace Environments'
metadata description = 'This module deploys an API Center Service Workspace Environment.'

@sys.description('Conditional. The name of the parent API Center service. Required if the template is used in a standalone deployment.')
param serviceName string

@sys.description('Conditional. The name of the parent workspace. Required if the template is used in a standalone deployment.')
param workspaceName string

@sys.description('Required. The name of the environment.')
@minLength(3)
@maxLength(90)
param name string

@sys.description('Required. The title of the environment.')
@minLength(1)
@maxLength(50)
param title string

@sys.description('Required. The kind of environment.')
param kind ('development' | 'testing' | 'staging' | 'production')

@sys.description('Optional. The description of the environment.')
param description string?

@sys.description('Optional. The custom metadata defined for API catalog entities.')
param customProperties resourceInput<'Microsoft.ApiCenter/services/workspaces/environments@2024-03-01'>.properties.customProperties?

@sys.description('Optional. Server information of the environment.')
param server environmentServerType?

@sys.description('Optional. Onboarding information for the environment.')
param onboarding environmentOnboardingType?

resource service 'Microsoft.ApiCenter/services@2024-03-01' existing = {
  name: serviceName

  resource workspace 'workspaces' existing = {
    name: workspaceName
  }
}

resource environment 'Microsoft.ApiCenter/services/workspaces/environments@2024-03-01' = {
  name: name
  parent: service::workspace
  properties: {
    title: title
    kind: kind
    description: description
    customProperties: customProperties
    server: server
    onboarding: onboarding
  }
}

@sys.description('The name of the environment.')
output name string = environment.name

@sys.description('The resource ID of the environment.')
output resourceId string = environment.id

@sys.description('The name of the resource group the environment was created in.')
output resourceGroupName string = resourceGroup().name

@export()
type environmentServerType = {
  @sys.description('Optional. The management portal URIs.')
  managementPortalUri: string[]?

  @sys.description('Optional. The type of server that represents the environment.')
  type: string?
}

@export()
type environmentOnboardingType = {
  @sys.description('Optional. The developer portal URIs.')
  developerPortalUri: string[]?

  @sys.description('Optional. Onboarding instructions.')
  instructions: string?
}
