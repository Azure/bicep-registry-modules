metadata name = 'Site App Settings'
metadata description = 'This module deploys a Site App Setting.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent site resource. Required if the template is used in a standalone deployment.')
param appName string

@description('Required. Type of site to deploy.')
@allowed([
  'functionapp' // function app windows os
  'functionapp,linux' // function app linux os
  'functionapp,workflowapp' // logic app workflow
  'functionapp,workflowapp,linux' // logic app docker container
  'functionapp,linux,container' // function app linux container
  'functionapp,linux,container,azurecontainerapps' // function app linux container azure container apps
  'app,linux' // linux web app
  'app' // windows web app
  'linux,api' // linux api app
  'api' // windows api app
  'app,linux,container' // linux container app
  'app,container,windows' // windows container app
])
param kind string

@description('Optional. Required if app of kind functionapp. Resource ID of the storage account to manage triggers and logging function executions.')
param storageAccountResourceId string?

@description('Optional. If the provided storage account requires Identity based authentication (\'allowSharedKeyAccess\' is set to false). When set to true, the minimum role assignment required for the App Service Managed Identity to the storage account is \'Storage Blob Data Owner\'.')
param storageAccountUseIdentityAuthentication bool = false

@description('Optional. Resource ID of the app insight to leverage for this resource.')
param appInsightResourceId string?

@description('Optional. The app settings key-value pairs except for AzureWebJobsStorage, AzureWebJobsDashboard, APPINSIGHTS_INSTRUMENTATIONKEY and APPLICATIONINSIGHTS_CONNECTION_STRING.')
param appSettingsKeyValuePairs object?

var azureWebJobsValues = !empty(storageAccountResourceId) && !(storageAccountUseIdentityAuthentication)
  ? {
      AzureWebJobsStorage: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${storageAccount.listKeys().keys[0].value};EndpointSuffix=${environment().suffixes.storage}'
    }
  : !empty(storageAccountResourceId) && storageAccountUseIdentityAuthentication
      ? union(
          { AzureWebJobsStorage__accountName: storageAccount.name },
          { AzureWebJobsStorage__blobServiceUri: storageAccount.properties.primaryEndpoints.blob }
        )
      : {}

var appInsightsValues = !empty(appInsightResourceId)
  ? {
      APPLICATIONINSIGHTS_CONNECTION_STRING: appInsight.properties.ConnectionString
    }
  : {}

var expandedAppSettings = union(appSettingsKeyValuePairs ?? {}, azureWebJobsValues, appInsightsValues)

resource app 'Microsoft.Web/sites@2022-09-01' existing = {
  name: appName
}

resource appInsight 'Microsoft.Insights/components@2020-02-02' existing = if (!empty(appInsightResourceId)) {
  name: last(split(appInsightResourceId ?? 'dummyName', '/'))
  scope: resourceGroup(split(appInsightResourceId ?? '//', '/')[2], split(appInsightResourceId ?? '////', '/')[4])
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' existing = if (!empty(storageAccountResourceId)) {
  name: last(split(storageAccountResourceId ?? 'dummyName', '/'))
  scope: resourceGroup(
    split(storageAccountResourceId ?? '//', '/')[2],
    split(storageAccountResourceId ?? '////', '/')[4]
  )
}

resource appSettings 'Microsoft.Web/sites/config@2022-09-01' = {
  name: 'appsettings'
  kind: kind
  parent: app
  properties: expandedAppSettings
}

@description('The name of the site config.')
output name string = appSettings.name

@description('The resource ID of the site config.')
output resourceId string = appSettings.id

@description('The resource group the site config was deployed into.')
output resourceGroupName string = resourceGroup().name
