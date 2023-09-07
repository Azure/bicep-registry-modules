metadata name = 'Azure Cognitive Search'
metadata description = 'Bicep module for simplified deployment of Azure Cognitive Search.'
metadata owner = 'jong'

@description('Prefix of Azure Cognitive Search Resource Name')
param prefix string = 'srch'

@description('Name of the Azure Cognitive Search Resource')
@minLength(3)
@maxLength(24)
param name string = take('${prefix}-${uniqueString(resourceGroup().id)}', 24)

@description('Location of the Azure Cognitive Search Resource')
param location string = resourceGroup().location

@description('Tags of the Azure Cognitive Search Resource')
param tags object = {}

@description('SKU of the Azure Cognitive Search Resource')
param sku object = {
  name: 'standard'
}

@description('AuthOptions of the Azure Cognitive Search Resource')
param authOptions object = {}

@description('DisableLocalAuth of the Azure Cognitive Search Resource')
param disableLocalAuth bool = false

@description('DisabledDataExfiltrationOptions of the Azure Cognitive Search Resource')
param disabledDataExfiltrationOptions array = []

@description('EncryptionWithCmk of the Azure Cognitive Search Resource')
param encryptionWithCmk object = {
  enforcement: 'Unspecified'
}

@description('HostingMode of the Azure Cognitive Search Resource')
@allowed([
  'default'
  'highDensity'
])
param hostingMode string = 'default'

@description('NetworkRuleSet of the Azure Cognitive Search Resource')
param networkRuleSet object = {
  bypass: 'None'
  ipRules: []
}

@description('PartitionCount of the Azure Cognitive Search Resource')
param partitionCount int = 1
@allowed([
  'enabled'
  'disabled'
])

@description('PublicNetworkAccess of the Azure Cognitive Search Resource')
param publicNetworkAccess string = 'enabled'

@description('ReplicaCount of the Azure Cognitive Search Resource')
param replicaCount int = 1
@allowed([
  'disabled'
  'free'
  'standard'
])

@description('SemanticSearch of the Azure Cognitive Search Resource')
param semanticSearch string = 'disabled'

resource search 'Microsoft.Search/searchServices@2021-04-01-preview' = {
  name: name
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    authOptions: authOptions
    disableLocalAuth: disableLocalAuth
    disabledDataExfiltrationOptions: disabledDataExfiltrationOptions
    encryptionWithCmk: encryptionWithCmk
    hostingMode: hostingMode
    networkRuleSet: networkRuleSet
    partitionCount: partitionCount
    publicNetworkAccess: publicNetworkAccess
    replicaCount: replicaCount
    semanticSearch: semanticSearch
  }
  sku: sku
}

@description('ID of the Azure Cognitive Search Resource')
output id string = search.id

@description('Endpoint of the Azure Cognitive Search Resource')
output endpoint string = 'https://${name}.search.windows.net/'

@description('Name of the Azure Cognitive Search Resource')
output name string = search.name
