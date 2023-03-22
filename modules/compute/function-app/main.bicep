/*param section*/
@description('Required. Name for the Azure Function App.')
param name string

@description('Required. Location for all resources.')
param location string

@description('Optional. Tags for all resources within Azure Function App module.')
param tags object = {}

@description('Required. Defines the name, tier, size, family and capacity of the app service plan.')
param sku object


@description('Optional. Kind of server OS.')
@allowed([
  'Windows'
  'Linux'
])

param serverOS string = 'Windows'

@description('Optional. If true, apps assigned to this app service plan can be scaled independently. If false, apps assigned to this app service plan will scale to all instances of the plan.')
param perSiteScaling bool = false

@description('Optional. Maximum number of total workers allowed for this ElasticScaleEnabled app service plan.')
param maximumElasticWorkerCount int = 0

@description('Optional. Scaling worker count.')
param targetWorkerCount int = 0

@description('Optional. The instance size of the hosting plan (small, medium, or large).')
@allowed([
  0
  1
  2
])
param targetWorkerSizeId int = 0

@allowed([
  'None'
  'SystemAssigned'
  'UserAssigned'
  'SystemAssigned, UserAssigned'
])
@description('Optional. The type of identity used for the virtual machine. The type \'SystemAssigned, UserAssigned\' includes both an implicitly created identity and a set of user assigned identities. The type \'None\' will remove any identities from the sites ( app or functionapp).')
param identityType string = 'SystemAssigned'

@description('Optional. Specify the resource ID of the user assigned Managed Identity, if \'identity\' is set as \'UserAssigned\'.')
param userAssignedIdentityId string = ''

@description('Optional. Configures a site to accept only HTTPS requests. Issues redirect for HTTP requests.')
param httpsOnly bool = true

@description('Optional. The resource ID of the app service environment to use for this resource.')
param appServiceEnvironmentId string = ''

@description('Optional. If client affinity is enabled.')
param clientAffinityEnabled bool = true

@description('Required. Type of site to deploy.')
@allowed([
  'functionapp'
  'app'
])
param kind string = 'functionapp'

@description('Optional. Version of the function extension.')
param functionsExtensionVersion string = '~4'

@description('Optional. Runtime of the function worker.')
@allowed([
  'dotnet'
  'node'
  'python'
  'java'
  'powershell'
  ''
])
param functionsWorkerRuntime string = ''

@description('Optional. NodeJS version.')
param functionsDefaultNodeversion string = '~14'

@allowed([
  'Disabled'
  'Enabled'
])
@description('Optional. The network access type for accessing Application Insights ingestion. - Enabled or Disabled.')
param publicNetworkAccessForIngestion string = 'Enabled'

@allowed([
  'Disabled'
  'Enabled'
])
@description('Optional. The network access type for accessing Application Insights query. - Enabled or Disabled.')
param publicNetworkAccessForQuery string = 'Enabled'

@description('Optional. Application type.')
@allowed([
  'web'
  'other'
])
param appInsightsType string = 'web'

@description('Optional. The kind of application that this component refers to, used to customize UI.')
param appInsightsKind string = 'azfunc'

@description('Optional. Enabled or Disable Insights for Azure functions')
param enableInsights bool = false

@description('Optional. Resource ID of the log analytics workspace which the data will be ingested to, if enableaInsights is false.')
param workspaceResourceId string = ''

@description('Optional. List of Azure function (Actual object where our code resides).')
param functions array = []

@description('Optional. Enable Vnet Integration or not.')
param enableVnetIntegration bool = false

@description('Optional. The subnet that will be integrated to enable vnet Integration.')
param subnetId string = ''

@description('Optional. Enable Source control for the function.')
param enableSourceControl bool = false

@description('Optional. Repository or source control URL.')
param repoUrl string = ''

@description('Optional. Name of branch to use for deployment.')
param branch string = ''

@description('Required. Name of the storage account used by function app.')
param storgeAccountName string

@description('Optional. to limit to manual integration; to enable continuous integration (which configures webhooks into online repos like GitHub).')
param isManualIntegration bool = true

@description('Optional. true for a Mercurial repository; false for a Git repository.')
param isMercurial bool = false

@description('Required. Resource Group of storage account used by function app.')
param storgeAccountResourceGroup string

@description('Optional. True to deploy functions from zip package. "functionPackageUri" must be specified if enabled. The package option and sourcecontrol option should not be enabled at the same time.')
param enablePackageDeploy bool = false

@description('Optional. URI to the function source code zip package, must be accessible by the deployer. E.g. A zip file on Azure storage in the same resource group.')
param functionPackageUri string = ''

@description('''Optional. Extra app settings that should be provisioned while creating the function app. Note! Settings below should not be included unless absolutely necessary, because settings in this param will override the ones added by the module:
AzureWebJobsStorage
AzureWebJobsDashboard
WEBSITE_CONTENTSHARE
WEBSITE_CONTENTAZUREFILECONNECTIONSTRING
FUNCTIONS_EXTENSION_VERSION
FUNCTIONS_WORKER_RUNTIME
WEBSITE_NODE_DEFAULT_VERSION
APPINSIGHTS_INSTRUMENTATIONKEY
APPLICATIONINSIGHTS_CONNECTION_STRING''')
param extraAppSettings object = {}

//Variables

var maxNameLength = 24
var uniqueStoragename = length(uniqueString(storgeAccountName)) > maxNameLength ? substring(uniqueString(storgeAccountName), 0, maxNameLength) : uniqueString(storgeAccountName)
var storageAccountName = 'sa${uniqueStoragename}'



@description('Defines storageAccounts for Azure Function App.')
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' existing = {
  name: storageAccountName
  scope: resourceGroup(storgeAccountResourceGroup)
}

@description('Defines Application service plan.')
resource serverfarms 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: name
  location: location
  tags: tags
  sku: sku
  properties: {
    perSiteScaling: perSiteScaling
    maximumElasticWorkerCount: maximumElasticWorkerCount
    reserved: serverOS == 'Linux'
    targetWorkerCount: targetWorkerCount
    targetWorkerSizeId: targetWorkerSizeId
  }
}

@description('If enabled, this will help mornior the application using the log analytics workspace')
resource appInsights 'Microsoft.Insights/components@2020-02-02' = if (enableInsights) {
  name: 'ai-${name}'
  location: location
  kind: appInsightsKind
  properties: {
    Application_Type: appInsightsType
    WorkspaceResourceId: workspaceResourceId
    publicNetworkAccessForIngestion: publicNetworkAccessForIngestion
    publicNetworkAccessForQuery: publicNetworkAccessForQuery
  }
  tags: tags
}


@description('''The app or function app resource.
Note: This is not actual Azure Function App this will be container for storing multiple functions.''')
resource sites 'Microsoft.Web/sites@2022-03-01' = {
  name: name
  location: location
  tags: tags
  kind: kind
  identity: {
    type: identityType
    userAssignedIdentities: (identityType == 'UserAssigned' || identityType == 'SystemAssigned, UserAssigned') ? {
      '${userAssignedIdentityId}': {}
    } : null
  }
  properties: {
    serverFarmId: serverfarms.id
    httpsOnly: httpsOnly
    hostingEnvironmentProfile: !empty(appServiceEnvironmentId) ? {
      id: appServiceEnvironmentId
    } : null
    clientAffinityEnabled: clientAffinityEnabled
  }
}


@description('Appsettings/config for the sites (app or functionapp).')
resource config 'Microsoft.Web/sites/config@2021-02-01' = {
  parent: sites
  name: 'appsettings'
  properties: union({
      AzureWebJobsStorage: !empty(storageAccount.id) ? 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${storageAccount.listKeys().keys[0].value};' : any(null)
      AzureWebJobsDashboard: !empty(storageAccount.id) ? 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${storageAccount.listKeys().keys[0].value};' : any(null)
      WEBSITE_CONTENTSHARE: name
      WEBSITE_CONTENTAZUREFILECONNECTIONSTRING: !empty(storageAccount.id) ? 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${storageAccount.listKeys().keys[0].value};' : any(null)
      FUNCTIONS_EXTENSION_VERSION: functionsExtensionVersion
      FUNCTIONS_WORKER_RUNTIME: sites.kind == 'functionapp' && !empty(functionsWorkerRuntime) ? functionsWorkerRuntime : any(null)
      WEBSITE_NODE_DEFAULT_VERSION: sites.kind == 'functionapp' && functionsWorkerRuntime == 'node' && !empty(functionsDefaultNodeversion) ? functionsDefaultNodeversion : any(null)
      APPINSIGHTS_INSTRUMENTATIONKEY: !empty(appInsights.id) && enableInsights ? appInsights.properties.InstrumentationKey : any(null)
      APPLICATIONINSIGHTS_CONNECTION_STRING: !empty(appInsights.id) && enableInsights ? appInsights.properties.ConnectionString : any(null)
    }, extraAppSettings)
  dependsOn: enableVnetIntegration ? [ networkConfig ] : []
}


resource networkConfig 'Microsoft.Web/sites/networkConfig@2022-03-01' = if (enableVnetIntegration == true) {
  parent: sites
  name: 'virtualNetwork'
  properties: {
    subnetResourceId: subnetId
  }
}


@description('The resources actual is function where code exits')
@batchSize(1)
resource azureFunction 'Microsoft.Web/sites/functions@2021-02-01' = [for function in functions: {
  dependsOn: [
    serverfarms
    config
  ]
  parent: sites
  name: function.name
  properties: {
    language: function.language
    config: function.config
    isDisabled: function.enabled
    files: function.files
  }
}]

resource sourcecontrol 'Microsoft.Web/sites/sourcecontrols@2022-03-01' = if (enableSourceControl) {
  parent: sites
  name: 'web'
  properties: {
    repoUrl: repoUrl
    branch: branch
    isManualIntegration: isManualIntegration
    isMercurial: isMercurial
  }
}

@description('Deploy function app from zip file.')
resource extensions 'Microsoft.Web/sites/extensions@2022-03-01' = if (enablePackageDeploy) {
  parent: sites
  name: 'MSDeploy'
  properties: {
    packageUri: functionPackageUri
  }
}

/*output section*/
@description('Get resource id for app or functionapp.')
output siteId string = sites.id

@description('Get resource name for app or functionapp.')
output siteName string = sites.name

@description('Get resource ID of the app service plan.')
output serverfarmsId string = serverfarms.id

@description('Get name of the app service plan.')
output serverfarmsName string = serverfarms.name

@description('Array of functions having name , language,isDisabled and id of functions.')
output functions array = [for function in functions: {
  name: function.name
  language: function.language
  isDisabled: function.enabled
  id: '${sites.id}/functions/${function.name}'
  files: function.files
}]

@description('Principal Id of the identity assigned to the function app.')
output sitePrincipalId string = (sites.identity.type == 'SystemAssigned') ? sites.identity.principalId : ''
