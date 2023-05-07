param namespaceName string
param name string
param partnerNamespaceId string = ''

resource namespace 'Microsoft.EventHub/namespaces@2021-11-01' existing = {
  name: namespaceName
}

resource disasterRecoveryConfig 'Microsoft.EventHub/namespaces/disasterRecoveryConfigs@2021-11-01' = {
  name: name
  parent: namespace
  properties: {
    partnerNamespace: partnerNamespaceId
  }
}
