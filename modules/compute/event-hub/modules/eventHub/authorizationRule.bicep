param namespaceName string
param eventHubName string
param name string
param rights array

resource namespace 'Microsoft.EventHub/namespaces@2022-10-01-preview' existing = {
  name: namespaceName
}

resource eventhub 'Microsoft.EventHub/namespaces/eventHubs@2022-10-01-preview' existing = {
  name: eventHubName
  parent: namespace
}

resource eventHubAuthorizationRule 'Microsoft.EventHub/namespaces/eventhubs/authorizationRules@2022-10-01-preview' = {
  name: name
  parent: eventhub
  properties: {
    rights: rights
  }
}
