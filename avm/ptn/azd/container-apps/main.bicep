metadata name = 'avm/ptn/azd/container-apps'
metadata description = 'Creates an Azure Container Registry and an Azure Container Apps environment.'
metadata owner = 'Azure/module-maintainers'

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object?

@description('Required. Name of the Container Apps Managed Environment.')
param containerAppsEnvironmentName string

@description('Required. Name of the Azure Container Registry.')
param containerRegistryName string

@description('Required. Name of the Azure Container Registry Resource Group.')
param containerRegistryResourceGroupName string = ''

@description('Optional. Enable admin user that have push / pull permission to the registry.')
param acrAdminUserEnabled bool = false

@description('Required. Existing Log Analytics Workspace resource ID. Note: This value is not required as per the resource type. However, not providing it currently causes an issue that is tracked [here](https://github.com/Azure/bicep/issues/9990).')
param logAnalyticsWorkspaceResourceId string

@description('Optional. Application Insights connection string.')
@secure()
param appInsightsConnectionString string = ''

@description('Optional. Azure Monitor instrumentation key used by Dapr to export Service to Service communication telemetry.')
@secure()
param daprAIInstrumentationKey string = ''

module containerAppsEnvironment 'br/public:avm/res/app/managed-environment:0.7.0' = {
  name: take('containerAppsEnvironment-${deployment().name}-deployment', 64)
  params: {
    name: containerAppsEnvironmentName
    location: location
    tags: tags
    daprAIInstrumentationKey: daprAIInstrumentationKey
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspaceResourceId
    appInsightsConnectionString: appInsightsConnectionString
  }
}

module containerRegistry 'br/public:avm/res/container-registry/registry:0.4.0' = {
  name: take('containerRegistry-${deployment().name}-deployment', 64)
  scope: !empty(containerRegistryResourceGroupName)
    ? resourceGroup(containerRegistryResourceGroupName)
    : resourceGroup()
  params: {
    name: containerRegistryName
    location: location
    acrAdminUserEnabled: acrAdminUserEnabled
    tags: tags
  }
}

@description('The Default domain of the Managed Environment.')
output defaultDomain string = containerAppsEnvironment.outputs.defaultDomain

@description('The name of the Managed Environment.')
output environmentName string = containerAppsEnvironment.outputs.name

@description('The resource ID of the Managed Environment.')
output environmentId string = containerAppsEnvironment.outputs.resourceId

@description('The reference to the Azure container registry.')
output registryLoginServer string = containerRegistry.outputs.loginServer

@description('The Name of the Azure container registry.')
output registryName string = containerRegistry.outputs.name
