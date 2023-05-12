param namespaceName string
param eventHubName string
param name string
param userMetadata string = ''

resource namespace 'Microsoft.EventHub/namespaces@2021-11-01' existing = {
  name: namespaceName

  resource eventhub 'eventHubs@2021-11-01' existing = {
    name: eventHubName
  }
}

resource consumerGroup 'Microsoft.EventHub/namespaces/eventhubs/consumergroups@2021-11-01' = {
  name: name
  parent: namespace::eventhub
  properties: {
    userMetadata: !empty(userMetadata) ? userMetadata : null
  }
}
