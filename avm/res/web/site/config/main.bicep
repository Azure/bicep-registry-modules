metadata name = 'Site App Settings'
metadata description = 'This module deploys a Site App Setting.'

@description('Conditional. The name of the parent site resource. Required if the template is used in a standalone deployment.')
param appName string

// @description('Required. The name of the config.')
// @allowed([
//   'appsettings'
//   'authsettings'
//   'authsettingsV2'
//   'azurestorageaccounts'
//   'backup'
//   'connectionstrings'
//   'logs'
//   'metadata'
//   'pushsettings'
//   'slotConfigNames'
//   'web'
// ])
// param name string

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

param siteConfig siteConfigType

@description('Optional. The current app settings.')
var currentAppSettings = !empty(app.id) ? list('${app.id}/config/appsettings', '2023-12-01').properties : {}

var azureWebJobsValues = !empty(siteConfig.?storageAccountResourceId) && !siteConfig.?storageAccountUseIdentityAuthentication
  ? {
      AzureWebJobsStorage: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${storageAccount.listKeys().keys[0].value};EndpointSuffix=${environment().suffixes.storage}'
    }
  : !empty(siteConfig.?storageAccountResourceId) && siteConfig.?storageAccountUseIdentityAuthentication
      ? {
          AzureWebJobsStorage__accountName: storageAccount.name
          AzureWebJobsStorage__blobServiceUri: storageAccount.properties.primaryEndpoints.blob
          AzureWebJobsStorage__queueServiceUri: storageAccount.properties.primaryEndpoints.queue
          AzureWebJobsStorage__tableServiceUri: storageAccount.properties.primaryEndpoints.table
        }
      : {}

var appInsightsValues = !empty(siteConfig.?applicationInsightResourceId)
  ? {
      APPLICATIONINSIGHTS_CONNECTION_STRING: applicationInsights.properties.ConnectionString
    }
  : {}

var expandedSettings = union(
  currentAppSettings,
  siteConfig.?additionalProperties,
  siteConfig.?properties ?? {},
  azureWebJobsValues,
  appInsightsValues
)

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' existing = if (!empty(siteConfig.?applicationInsightResourceId)) {
  name: last(split(siteConfig.?applicationInsightResourceId!, '/'))
  scope: resourceGroup(
    split(siteConfig.?applicationInsightResourceId!, '/')[2],
    split(siteConfig.?applicationInsightResourceId!, '/')[4]
  )
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' existing = if (!empty(siteConfig.?storageAccountResourceId)) {
  name: last(split(siteConfig.?storageAccountResourceId!, '/'))
  scope: resourceGroup(
    split(siteConfig.?storageAccountResourceId!, '/')[2],
    split(siteConfig.?storageAccountResourceId!, '/')[4]
  )
}

resource app 'Microsoft.Web/sites@2023-12-01' existing = {
  name: appName
}

resource config 'Microsoft.Web/sites/config@2024-04-01' = {
  parent: app
  name: siteConfig.name
  kind: siteConfig.kind
  properties: expandedSettings
}

@description('The name of the site config.')
output name string = config.name

@description('The resource ID of the site config.')
output resourceId string = config.id

@description('The resource group the site config was deployed into.')
output resourceGroupName string = resourceGroup().name

@export()
@description('The type of a site config.')
@discriminator('name')
type siteConfigType = appSettingsType | authSettingsType | authSettingsV2Type | logsType | webType

type appSettingsType = {
  name: 'appsettings'
  // kind: resourceInput<'Microsoft.Web/sites/config@2024-04-01'>.kind

  @description('Optional. If the provided storage account requires Identity based authentication (\'allowSharedKeyAccess\' is set to false). When set to true, the minimum role assignment required for the App Service Managed Identity to the storage account is \'Storage Blob Data Owner\'.')
  storageAccountUseIdentityAuthentication: bool?

  @description('Optional. Required if app of kind functionapp. Resource ID of the storage account to manage triggers and logging function executions.')
  storageAccountResourceId: string?

  @description('Optional. Resource ID of the application insight to leverage for this resource.')
  applicationInsightResourceId: string?

  additionalProperties: {
    *: string
  }?
}

type authSettingsType = {
  name: 'authsettings'

  additionalProperties: {
    *: string
  }?

  @description('Optional. The config settings.')
  properties: resourceInput<'Microsoft.Web/sites/config@2024-04-01'>.properties?
}

type authSettingsV2Type = {
  name: 'authsettingsV2'

  additionalProperties: {
    *: string
  }?

  @description('Optional. The config settings.')
  properties: resourceInput<'Microsoft.Web/sites/config@2024-04-01'>.properties?
}

type logsType = {
  name: 'logs'

  additionalProperties: {
    *: string
  }?

  @description('Optional. The config settings.')
  properties: resourceInput<'Microsoft.Web/sites/config@2024-04-01'>.properties?
}

type webType = {
  name: 'web'

  additionalProperties: {
    *: string
  }?

  @description('Optional. The config settings.')
  properties: resourceInput<'Microsoft.Web/sites/config@2024-04-01'>.properties?
}
