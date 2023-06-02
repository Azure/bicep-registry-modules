param location string
param name string = take('${prefix}-${uniqueString(resourceGroup().id, subscription().id)}', 60)
param prefix string

var maxStorageAccountLength = 22

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: 't1${take(replace(toLower(name), '-', ''), maxStorageAccountLength)}'
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  location: location
  properties: {
    allowBlobPublicAccess: false
  }
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: '${prefix}-law-${name}-01'
  location: location
}

resource eventHubNamespace 'Microsoft.EventHub/namespaces@2021-11-01' = {
  name: '${prefix}-evhns-${name}-01'
  location: location
}

resource eventHub 'Microsoft.EventHub/namespaces/eventhubs@2021-11-01' = {
  name: '${prefix}-evh-${name}-01'
  parent: eventHubNamespace
}

resource authorizationRule 'Microsoft.EventHub/namespaces/authorizationRules@2022-01-01-preview' = {
  name: 'RootManageSharedAccessKey'
  properties: {
    rights: [
      'Listen'
      'Manage'
      'Send'
    ]
  }
  parent: eventHubNamespace
}

output storageAccountId string = storageAccount.id
output workspaceId string = logAnalyticsWorkspace.id
output eventHubNamespaceId string = eventHubNamespace.id
output eventHubName string = eventHub.name
output authorizationRuleId string = authorizationRule.id
