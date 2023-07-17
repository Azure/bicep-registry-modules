param namespaceName string
param name string
param rights array

resource namespace 'Microsoft.EventHub/namespaces@2022-10-01-preview' existing = {
  name: namespaceName
}

resource namespaceAuthorizationRule 'Microsoft.EventHub/namespaces/authorizationRules@2022-10-01-preview' = {
  name: name
  parent: namespace
  properties: {
    rights: rights
  }
}
