metadata name = 'Azd Azure Machine Learning Dependencies'
metadata description = '''Creates all the dependencies required for a Machine Learning Service.

**Note:** This module is not intended for broad, generic use, as it was designed to cater for the requirements of the AZD CLI product. Feature requests and bug fix requests are welcome if they support the development of the AZD CLI but may not be incorporated if they aim to make this module more generic than what it needs to be for its primary use case.'''

@description('Optional. The resource portal dashboards name.')
param applicationInsightsDashboardName string = ''

@description('Optional. The resource insights components name.')
param applicationInsightsName string = ''

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. The resource operational insights workspaces name.')
param logAnalyticsName string = ''

@description('Required. Name of the key vault.')
param keyVaultName string

@description('Required. Name of the storage account.')
param storageAccountName string

@description('Required. Name of the OpenAI cognitive services.')
param cognitiveServicesName string

@description('Optional. Name of the container registry.')
param containerRegistryName string = ''

@description('Optional. Name of the Azure Cognitive Search service.')
param searchServiceName string = ''

@description('Optional. Indicates whether public access is enabled for all blobs or containers in the storage account. For security reasons, it is recommended to set it to false.')
param allowBlobPublicAccess bool = true

@description('Optional. Allows you to specify the type of endpoint in the storage account. Set this to AzureDNSZone to create a large number of accounts in a single subscription, which creates accounts in an Azure DNS Zone and the endpoint URL will have an alphanumeric DNS Zone identifier.')
@allowed([
  ''
  'AzureDnsZone'
  'Standard'
])
param dnsEndpointType string = 'Standard'

@description('Optional. Whether or not public network access is allowed for the storage account. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and networkAcls are not set.')
@allowed([
  ''
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Enabled'

@description('Optional. Networks ACLs, this value contains IPs to whitelist and/or Subnet information. If in use, bypass needs to be supplied. For security reasons, it is recommended to set the DefaultAction Deny.')
param networkAcls object = {
  bypass: 'AzureServices'
  defaultAction: 'Allow'
}

@description('Optional. Blob service and containers to deploy.')
param blobServices object = {
  containers: [
    {
      name: 'default'
    }
  ]
  corsRules: [
    {
      allowedOrigins: [
        'https://mlworkspace.azure.ai'
        'https://ml.azure.com'
        'https://*.ml.azure.com'
        'https://ai.azure.com'
        'https://*.ai.azure.com'
        'https://mlworkspacecanary.azure.ai'
        'https://mlworkspace.azureml-test.net'
      ]
      allowedMethods: [
        'GET'
        'HEAD'
        'POST'
        'PUT'
        'DELETE'
        'OPTIONS'
        'PATCH'
      ]
      maxAgeInSeconds: 1800
      exposedHeaders: [
        '*'
      ]
      allowedHeaders: [
        '*'
      ]
    }
  ]
  deleteRetentionPolicyEnabled: true
  containerDeleteRetentionPolicyDays: 7
  deleteRetentionPolicyDays: 6
  deleteRetentionPolicyAllowPermanentDelete: true
}

@description('Optional. File service and shares to deploy.')
param fileServices object = {
  name: 'default'
}

@description('Optional. Queue service and queues to create.')
param queueServices object = {
  name: 'default'
}

@description('Optional. Table service and tables to create.')
param tableServices object = {
  name: 'default'
}

@description('Optional. Tags of the resource.')
@metadata({
  example: '''
  {
      "key1": "value1"
      "key2": "value2"
  }
  '''
})
param tags object?

@description('Optional. Kind of the Cognitive Services.')
param cognitiveServicesKind string = 'AIServices'

@description('Optional. Array of deployments about cognitive service accounts to create.')
param cognitiveServicesDeployments array = []

@description('Optional. The custom subdomain name used to access the API. Defaults to the value of the name parameter.')
param cognitiveServicesCustomSubDomainName string = cognitiveServicesName

@description('Optional. Allow only Azure AD authentication. Should be enabled for security reasons.')
param cognitiveServicesDisableLocalAuth bool = false

@description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and networkAcls are not set.')
@allowed([
  'Enabled'
  'Disabled'
])
param cognitiveServicesPublicNetworkAccess string = 'Disabled'

@description('Optional. A collection of rules governing the accessibility from specific network locations.')
param cognitiveServicesNetworkAcls object = {
  defaultAction: 'Allow'
}

@description('Optional. SKU of the Cognitive Services resource.')
param cognitiveServicesSku string = 'S0'

@description('Optional. Tier of your Azure container registry.')
@allowed([
  'Basic'
  'Premium'
  'Standard'
])
param registryAcrSku string = 'Basic'

@description('Optional. Public network access setting.')
param registryPublicNetworkAccess string = 'Enabled'

@description('Optional. Property that controls how data actions are authorized. When true, the key vault will use Role Based Access Control (RBAC) for authorization of data actions, and the access policies specified in vault properties will be ignored. When false, the key vault will use the access policies specified in vault properties, and any policy stored on Azure Resource Manager will be ignored. Note that management actions are always authorized with RBAC.')
param enableRbacAuthorization bool = false

@description('Optional. Specifies if the vault is enabled for deployment by script or compute.')
param enableVaultForDeployment bool = false

@description('Optional. Specifies if the vault is enabled for a template deployment.')
param enableVaultForTemplateDeployment bool = false

@description('Optional. Provide \'true\' to enable Key Vault\'s purge protection feature.')
param enablePurgeProtection bool = false

@description('Optional. Specifies the SKU for the vault.')
@allowed([
  'premium'
  'standard'
])
param keyVaultSku string = 'standard'

@description('Optional. The name of the SKU.')
@allowed([
  'CapacityReservation'
  'Free'
  'LACluster'
  'PerGB2018'
  'PerNode'
  'Premium'
  'Standalone'
  'Standard'
])
param logAnalyticsSkuName string = 'PerGB2018'

@description('Optional. Number of days data will be retained for.')
@minValue(0)
@maxValue(730)
param dataRetention int = 30

@description('Optional. Defines the options for how the data plane API of a Search service authenticates requests. Must remain an empty object {} if \'disableLocalAuth\' is set to true.')
param authOptions object = {}

@description('Optional. When set to true, calls to the search service will not be permitted to utilize API keys for authentication. This cannot be set to true if \'authOptions\' are defined.')
param disableLocalAuth bool = false

@description('Optional. Describes a policy that determines how resources within the search service are to be encrypted with Customer Managed Keys.')
@allowed([
  'Disabled'
  'Enabled'
  'Unspecified'
])
param cmkEnforcement string = 'Unspecified'

@description('Optional. Applicable only for the standard3 SKU. You can set this property to enable up to 3 high density partitions that allow up to 1000 indexes, which is much higher than the maximum indexes allowed for any other SKU. For the standard3 SKU, the value is either \'default\' or \'highDensity\'. For all other SKUs, this value must be \'default\'.')
@allowed([
  'default'
  'highDensity'
])
param hostingMode string = 'default'

@description('Optional. Network specific rules that determine how the Azure Cognitive Search service may be reached.')
param networkRuleSet object = {
  bypass: 'None'
  ipRules: []
}

@description('Optional. The number of partitions in the search service; if specified, it can be 1, 2, 3, 4, 6, or 12. Values greater than 1 are only valid for standard SKUs. For \'standard3\' services with hostingMode set to \'highDensity\', the allowed values are between 1 and 3.')
@minValue(1)
@maxValue(12)
param partitionCount int = 1

@description('Optional. This value can be set to \'Enabled\' to avoid breaking changes on existing customer resources and templates. If set to \'Disabled\', traffic over public interface is not allowed, and private endpoint connections would be the exclusive access method.')
@allowed([
  'Enabled'
  'Disabled'
])
param searchServicePublicNetworkAccess string = 'Enabled'

@description('Optional. The number of replicas in the search service. If specified, it must be a value between 1 and 12 inclusive for standard SKUs or between 1 and 3 inclusive for basic SKU.')
@minValue(1)
@maxValue(12)
param replicaCount int = 1

@allowed([
  'disabled'
  'free'
  'standard'
])
@description('Optional. Sets options that control the availability of semantic search. This configuration is only possible for certain search SKUs in certain locations.')
param semanticSearch string = 'disabled'

@description('Optional. Defines the SKU of an Azure Cognitive Search Service, which determines price tier and capacity limits.')
@allowed([
  'basic'
  'free'
  'standard'
  'standard2'
  'standard3'
  'storage_optimized_l1'
  'storage_optimized_l2'
])
param searchServiceSku string = 'standard'

@description('Conditional. The managed identity definition for this resource. Required if `assignRbacRole` is `true` and `managedIdentityName` is `null`.')
param managedIdentities managedIdentitiesType?

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.azd-mlhubdependencies.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

module keyVault 'br/public:avm/res/key-vault/vault:0.7.1' = {
  name: '${uniqueString(deployment().name, location)}-keyvault'
  params: {
    name: keyVaultName
    location: location
    tags: tags
    enableRbacAuthorization: enableRbacAuthorization
    enableVaultForDeployment: enableVaultForDeployment
    enableVaultForTemplateDeployment: enableVaultForTemplateDeployment
    enablePurgeProtection: enablePurgeProtection
    sku: keyVaultSku
    enableTelemetry: enableTelemetry
  }
}

module storageAccount 'br/public:avm/res/storage/storage-account:0.9.1' = {
  name: '${uniqueString(deployment().name, location)}-storage'
  params: {
    name: storageAccountName
    location: location
    tags: tags
    allowBlobPublicAccess: allowBlobPublicAccess
    dnsEndpointType: dnsEndpointType
    publicNetworkAccess: publicNetworkAccess
    networkAcls: networkAcls
    blobServices: blobServices
    fileServices: fileServices
    queueServices: queueServices
    tableServices: tableServices
    enableTelemetry: enableTelemetry
  }
}

module cognitiveServices 'br/public:avm/res/cognitive-services/account:0.7.0' = {
  name: '${uniqueString(deployment().name, location)}-cognitive'
  params: {
    name: cognitiveServicesName
    location: location
    tags: tags
    kind: cognitiveServicesKind
    customSubDomainName: cognitiveServicesCustomSubDomainName
    publicNetworkAccess: cognitiveServicesPublicNetworkAccess
    networkAcls: cognitiveServicesNetworkAcls
    disableLocalAuth: cognitiveServicesDisableLocalAuth
    sku: cognitiveServicesSku
    deployments: cognitiveServicesDeployments
    enableTelemetry: enableTelemetry
  }
}

module logAnalytics 'br/public:avm/res/operational-insights/workspace:0.6.0' = if (!empty(logAnalyticsName)) {
  name: '${uniqueString(deployment().name, location)}-loganalytics'
  params: {
    name: logAnalyticsName
    location: location
    tags: tags
    dataRetention: dataRetention
    skuName: logAnalyticsSkuName
    enableTelemetry: enableTelemetry
  }
}

module applicationInsights 'br/public:avm/ptn/azd/insights-dashboard:0.1.0' = if (!empty(applicationInsightsName) && !empty(logAnalyticsName)) {
  name: '${uniqueString(deployment().name, location)}-insights'
  params: {
    location: location
    tags: tags
    name: applicationInsightsName
    dashboardName: applicationInsightsDashboardName
    logAnalyticsWorkspaceResourceId: !empty(logAnalyticsName) ? logAnalytics.outputs.resourceId : ''
    enableTelemetry: enableTelemetry
  }
}

module containerRegistry 'br/public:avm/res/container-registry/registry:0.4.0' = if (!empty(containerRegistryName)) {
  name: '${uniqueString(deployment().name, location)}-registry'
  params: {
    name: containerRegistryName
    acrSku: registryAcrSku
    tags: tags
    location: location
    publicNetworkAccess: registryPublicNetworkAccess
    enableTelemetry: enableTelemetry
  }
}

module searchService 'br/public:avm/res/search/search-service:0.6.0' = if (!empty(searchServiceName)) {
  name: '${uniqueString(deployment().name, location)}-searchservice'
  params: {
    name: searchServiceName
    location: location
    tags: tags
    authOptions: authOptions
    disableLocalAuth: disableLocalAuth
    cmkEnforcement: cmkEnforcement
    hostingMode: hostingMode
    networkRuleSet: networkRuleSet
    partitionCount: partitionCount
    publicNetworkAccess: searchServicePublicNetworkAccess
    replicaCount: replicaCount
    semanticSearch: semanticSearch
    sku: searchServiceSku
    managedIdentities: managedIdentities
    enableTelemetry: enableTelemetry
  }
}

// ============ //
// Outputs      //
// ============ //

@description('The name of the resource group the module was deployed to.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the key vault.')
output keyVaultResourceId string = keyVault.outputs.resourceId

@description('The name of the key vault.')
output keyVaultName string = keyVault.outputs.name

@description('The endpoint of the key vault.')
output keyVaultEndpoint string = keyVault.outputs.uri

@description('The resource ID of the storage account.')
output storageAccountResourceId string = storageAccount.outputs.resourceId

@description('The name of the storage account.')
output storageAccountName string = storageAccount.outputs.name

@description('The resource ID of the container registry.')
output containerRegistryResourceId string = !empty(containerRegistryName) ? containerRegistry.outputs.resourceId : ''

@description('The name of the container registry.')
output containerRegistryName string = !empty(containerRegistryName) ? containerRegistry.outputs.name : ''

@description('The endpoint of the container registry.')
output containerRegistryEndpoint string = !empty(containerRegistryName) ? containerRegistry.outputs.loginServer : ''

@description('The resource ID of the application insights.')
output applicationInsightsResourceId string = !empty(applicationInsightsName)
  ? applicationInsights.outputs.applicationInsightsResourceId
  : ''

@description('The name of the application insights.')
output applicationInsightsName string = !empty(applicationInsightsName)
  ? applicationInsights.outputs.applicationInsightsName
  : ''

@description('The resource ID of the loganalytics workspace.')
output logAnalyticsWorkspaceResourceId string = !empty(logAnalyticsName) ? logAnalytics.outputs.resourceId : ''

@description('The name of the loganalytics workspace.')
output logAnalyticsWorkspaceName string = !empty(logAnalyticsName) ? logAnalytics.outputs.name : ''

@description('The resource ID of the cognitive services.')
output cognitiveServicesResourceId string = cognitiveServices.outputs.resourceId

@description('The name of the cognitive services.')
output cognitiveServicesName string = cognitiveServices.outputs.name

@description('The endpoint of the cognitive services.')
output cognitiveServicesEndpoint string = cognitiveServices.outputs.endpoint

@description('The resource ID of the search service.')
output searchServiceResourceId string = !empty(searchServiceName) ? searchService.outputs.resourceId : ''

@description('The name of the search service.')
output searchServiceName string = !empty(searchServiceName) ? searchService.outputs.name : ''

@description('The endpoint of the search service.')
output searchServiceEndpoint string = !empty(searchServiceName)
  ? 'https://${searchService.outputs.name}.search.windows.net/'
  : ''

@description('The connection string of the application insights.')
output applicationInsightsConnectionString string = !empty(applicationInsightsName)
  ? applicationInsights.outputs.applicationInsightsConnectionString
  : ''

@description('The instrumentation key of the application insights.')
output applicationInsightsInstrumentationKey string = !empty(applicationInsightsName)
  ? applicationInsights.outputs.applicationInsightsInstrumentationKey
  : ''

@description('The system assigned mi principal Id key of the search service.')
output systemAssignedMiPrincipalId string = !empty(searchServiceName)
  ? searchService.outputs.systemAssignedMIPrincipalId
  : ''

// ================ //
// Definitions      //
// ================ //

type managedIdentitiesType = {
  @description('Optional. Enables system assigned managed identity on the resource.')
  systemAssigned: bool?

  @description('Optional. The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption.')
  userAssignedResourceIds: string[]?
}?
