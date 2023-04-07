@description('Deployment Location')
param location string

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

@description('Enforces HTTPS-only access to the function app. Default value is true.')
param httpsOnly bool = true

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
