param namespaceName string
param name string
param rights array = []

resource namespace 'Microsoft.EventHub/namespaces@2021-11-01' existing = {
  name: namespaceName
}

resource authorizationRule 'Microsoft.EventHub/namespaces/AuthorizationRules@2021-11-01' = {
  name: name
  parent: namespace
  properties: {
    rights: rights
  }
}
