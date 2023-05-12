@minLength(4)
@maxLength(63)
@description('Required. Name of the Log Analytics Workspace.')
param name string

@description('Required. Define the Azure Location that the Log Analytics Workspace should be created within.')
param location string

@description('Optional. Tags for Log Analytics Workspace.')
param tags object = {}

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
@description('Optional. sku of Log Analytics Workspace. Default set to PerGB2018')
param skuName string = 'PerGB2018'

var sku = {
  name: skuName
}

@minValue(30)
@maxValue(730)
@allowed([
  30
  31
  90
  120
  180
  270
  365
  550
  730
])
@description('Optional. The workspace data retention in days. Default set to 30')
param retentionInDays int = 30

@allowed([
  'Enabled'
  'Disabled'
])
@description('Optional. The network access type for operating on the Log Analytics Workspace. By default it is Enabled')
param publicNetworkAccessForIngestion string = 'Enabled'

@allowed([
  'Enabled'
  'Disabled'
])
@description('Optional. The network access type for operating on the Log Analytics Workspace. By default it is Enabled')
param publicNetworkAccessForQuery string = 'Enabled'

@description('Optional. The workspace daily quota for ingestion. Default set to -1')
param dailyQuotaGb int = -1

@description('Optional. Indicates whether customer managed storage is mandatory for query management.')
param forceCmkForQuery bool = false

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    sku: sku
    retentionInDays: retentionInDays
    publicNetworkAccessForIngestion: publicNetworkAccessForIngestion
    publicNetworkAccessForQuery: publicNetworkAccessForQuery
    workspaceCapping: {
      dailyQuotaGb: dailyQuotaGb
    }
    forceCmkForQuery: forceCmkForQuery
  }
}

@description('Id of the Log Analytics Workspace.')
output id string = logAnalyticsWorkspace.id

@description('Name of the Log Analytics Workspace.')
output name string = logAnalyticsWorkspace.name
