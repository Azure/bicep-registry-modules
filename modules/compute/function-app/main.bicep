/*param section*/
@description('Required. Name for the Azure Function App.')
@maxLength(64)
param name string

@description('Required. Location for all resources.')
param location string

@description('Optional. Tags for all resources within Azure Function App module.')
param tags object = {}

@description('Name of Storage Account. Must be unique within Azure.')
param name string = 'func${uniqueString(resourceGroup().id, subscription().id, location)}'

@description('Name of the resource group that will contain the resources.')
param serverFarmName string = 'asp${uniqueString(resourceGroup().id, subscription().id, location)}'

@description('Enables VNET integration. Default value is false.')
param enableVNET bool = false

@description('Describes plan\'s pricing tier and instance size. Check details at https://azure.microsoft.com/en-us/pricing/details/app-service/')
@allowed([ 'F1', 'D1', 'B1', 'B2', 'B3', 'S1', 'S2', 'S3', 'P1', 'P2', 'P3', 'P4' ])
param skuName string = 'F1'

@description('Describes plan\'s instance count')
@minValue(1)
@maxValue(3)
param skuCapacity int = 1

@description('The runtime that the function app is using. Default value is node.')
@allowed([ 'node', 'dotnet', 'java' ])
param runtime string = 'node'

@description('The subnet resource ID if VNET integration is enabled. Default value is empty.')
param subnetID string = ''

@description('Required. Defines the name, tier, size, family and capacity of the app service plan.')
param sku object = {
  name: 'Y1'
  tier: 'Dynamic'
  size: 'Y1'
  family: 'Y'
  capacity: 0
}

@description('Optional. Kind of server OS.')
@allowed([ 'Windows', 'Linux' ])

param serverOS string = 'Windows'

@description('Optional. If true, apps assigned to this app service plan can be scaled independently. If false, apps assigned to this app service plan will scale to all instances of the plan.')
param perSiteScaling bool = false

@description('Optional. Maximum number of total workers allowed for this ElasticScaleEnabled app service plan.')
param maximumElasticWorkerCount int = 0

@description('Optional. Scaling worker count.')
param targetWorkerCount int = 0

@description('Optional. The instance size of the hosting plan (small, medium, or large).')
@allowed([ 0, 1, 2 ])
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
@allowed([ 'functionapp', 'app' ])
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

@allowed([ 'Disabled', 'Enabled' ])
@description('Optional. The network access type for accessing Application Insights ingestion. - Enabled or Disabled.')
param publicNetworkAccessForIngestion string = 'Enabled'

@allowed([ 'Disabled', 'Enabled' ])
@description('Optional. The network access type for accessing Application Insights query. - Enabled or Disabled.')
param publicNetworkAccessForQuery string = 'Enabled'

@description('Optional. Application type.')
@allowed([ 'web', 'other' ])
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
param storageAccountName string

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

@description('Optional. Enable docker image deployment')
param enableDockerContainer bool = false

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

@description('Specifies the minimum TLS version required for SSL requests. Default value is 1.2.')
@allowed([ '1.0', '1.1', '1.2' ])
param minTlsVersion string = '1.2'

@description('Name of Application Insights. Must be unique within Azure.')
param applicationInsightsName string = 'ai${uniqueString(resourceGroup().id, subscription().id, location)}'

@description('Name of Storage Account. Must be unique within Azure.')
param storageAccountName string = 'sa${uniqueString(resourceGroup().id, subscription().id, location)}'

@description('Storage Account type')
@allowed([ 'Standard_LRS', 'Standard_GRS', 'Standard_RAGRS' ])
param storageAccountType string = 'Standard_LRS'

var ipSecurityRestrictions = enableVNET ? [
  {
    vnetSubnetResourceId: subnetID
    action: 'Allow'
    tag: 'Default'
    priority: 1
    name: 'allowinboundonlyfromvnet'
    description: 'Allowing inbound only from VNET'
  }
  {
    ipAddress: 'AzureCognitiveSearch'
    tag: 'ServiceTag'
    action: 'Allow'
    priority: 2
    name: 'allowsearchinbound'
    description: 'allow search inbound from webapps'
  }
] : []
var scmIpSecurityRestrictions = enableVNET ? [
  {
    vnetSubnetResourceId: subnetID
    action: 'Allow'
    tag: 'Default'
    priority: 1
    name: 'allowscminboundonlyfromvnet'
    description: 'Allowing scm inbound only from VNET'
  }
  {
    ipAddress: 'AzureCognitiveSearch'
    tag: 'ServiceTag'
    action: 'Allow'
    priority: 2
    name: 'allowsearchinbound'
    description: 'allow search inbound from webapps'
  }
] : []

var linuxFxVersion = 'PYTHON|3.7'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountType
  }
  kind: 'Storage'
  properties: {
    supportsHttpsTrafficOnly: true
    defaultToOAuthAuthentication: true
  }
}

module hostingPlanName 'modules/serverfarms.bicep' = {
  name: serverFarmName
  params: {
    name: serverFarmName
    location: location
    skuName: skuName
    skuCapacity: skuCapacity
  }
}

resource function 'Microsoft.Web/sites@2020-12-01' = {
  name: name
  location: location
  kind: 'functionapp'
  identity: {
    type: 'SystemAssigned'
  }
  tags: {
    'hidden-related:${resourceGroup().id}/providers/Microsoft.Web/serverfarms/${serverFarmName}': 'Resource'
    displayName: 'Function'
  }
  properties: {
    name: serverFarmName
    serverFarmId: hostingPlanName.outputs.id
    siteConfig: {
      linuxFxVersion: linuxFxVersion
      ipSecurityRestrictions: ipSecurityRestrictions
      scmIpSecurityRestrictions: scmIpSecurityRestrictions
      minTlsVersion: minTlsVersion
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower(name)
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'WEBSITE_NODE_DEFAULT_VERSION'
          value: '~14'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: applicationInsights.properties.InstrumentationKey
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: runtime
        }
      ]
    }
    httpsOnly: httpsOnly
  }
}

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: applicationInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    Request_Source: 'rest'
  }
}

@description('Azure Function Resource ID')
output id string = function.id
