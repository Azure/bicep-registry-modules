@description('Required. The name of the Bing Search account.')
param accountName string

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
  name: accountName
  location: 'global'
  tags: tags

  kind: kind
  properties: {
    statisticsEnabled: statisticsEnabled
  }
  sku: {
    name: skuName
  }
}

@description( 'Bing account ID')
output id string = BingAccount.id
@description( 'Bing Endpoint')
output endpoint string = BingAccount.properties.endpoint
