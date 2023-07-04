@description('Prefix of Resource Name. Not used if name is provided')
param prefix string = 'bng'

@description('The location into which your Azure resources should be deployed.')
param location string = resourceGroup().location

@minLength(2)
@maxLength(64)
// Must contain only lowercase letters, hyphens and numbers
// Must contain at least 2 through 64 characters
// Can't start or end with hyphen
@description('The name of the Bing Service.')
param name string = take('${prefix}-${kind}-${uniqueString(resourceGroup().id, location)}', 64)

@description('Optional. This parameter will define Bing search kind.')
@allowed(
  [
    'Bing.Search.v7'
    'Bing.CustomSearch'
  ]
)
param kind string = 'Bing.Search.v7'

@description('Optional. The name of the SKU, F* (free) and S* (standard). Supported SKUs will differ based on search kind')
@allowed(
  [
    'F0'
    'F1'
    'S1'
    'S2'
    'S3'
    'S4'
    'S5'
    'S6'
    'S7'
    'S8'
    'S9'
  ]
)
param skuName string = 'F1'

@description('Optional. Enable or disable Bing statistics.')
param statisticsEnabled bool = false

@description('Optional. Tags of the resource.')
param tags object = {}

resource BingAccount 'Microsoft.Bing/accounts@2020-06-10' = {
  name: name
  location: location
  tags: tags

  kind: kind
  properties: {
    statisticsEnabled: statisticsEnabled
  }
  sku: {
    name: skuName
  }
}

@description('Bing account ID')
output id string = BingAccount.id
@description('Bing Endpoint')
output endpoint string = BingAccount.properties.endpoint
