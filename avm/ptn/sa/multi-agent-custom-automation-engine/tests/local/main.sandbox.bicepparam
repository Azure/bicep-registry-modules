using '../..//main.bicep'

param solutionPrefix = 'macaewaf100'
param solutionLocation = 'australiaeast'
param azureOpenAILocation = 'australiaeast'
param logAnalyticsWorkspaceConfiguration = {
  dataRetentionInDays: 30
}
param applicationInsightsConfiguration = {
  retentionInDays: 30
}
param virtualNetworkConfiguration = {
  enabled: false
}
param aiFoundryStorageAccountConfiguration = {
  sku: 'Standard_LRS'
}
param webServerFarmConfiguration = {
  skuCapacity: 1
  skuName: 'B2'
}
