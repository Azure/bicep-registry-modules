param nameseed string

@description('Specifies the name of the container app environment.')
param containerAppEnvName string = 'env-${nameseed}'

@description('Specifies the name of the log analytics workspace.')
param containerAppLogAnalyticsName string = 'log-${nameseed}'

param logRetentionDays int = 30

@description('Specifies the location for all resources.')
param location string //cannot use resourceGroup().location since it's not available in most of regions

param infraSubnetId string = ''
param runtimeSubnetId string = ''

@description('Sets the environment to only have a internal load balancer')
param internalVirtualIp bool = false

resource containerAppEnv 'Microsoft.App/managedEnvironments@2022-01-01-preview' = {
  name: containerAppEnvName
  location: location
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logAnalytics.properties.customerId
        sharedKey: logAnalytics.listKeys().primarySharedKey
      }
    }
    vnetConfiguration: {
      infrastructureSubnetId: infraSubnetId
      runtimeSubnetId: runtimeSubnetId
      internal: internalVirtualIp
    }
  }
}
output containerAppEnvironmentName string = containerAppEnv.name



resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2020-10-01' = {
  name: containerAppLogAnalyticsName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: logRetentionDays
  }
}
