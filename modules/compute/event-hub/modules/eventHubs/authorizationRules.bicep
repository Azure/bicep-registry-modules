param namespaceName string
param eventHubName string
param name string
param rights array = []


resource namespace 'Microsoft.EventHub/namespaces@2021-11-01' existing = {
  name: namespaceName

  resource eventhub 'eventHubs@2021-11-01' existing = {
    name: eventHubName
  }
}

resource authorizationRule 'Microsoft.EventHub/namespaces/eventhubs/authorizationRules@2021-11-01' = {
  name: name
  parent: namespace::eventhub
  properties: {
    rights: rights
  }
}
