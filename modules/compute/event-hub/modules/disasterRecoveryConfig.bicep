param namespaceName string
param name string
param partnerNamespaceId string = ''

resource namespace 'Microsoft.EventHub/namespaces@2022-10-01-preview' existing = {
  name: namespaceName
}

resource disasterRecoveryConfig 'Microsoft.EventHub/namespaces/disasterRecoveryConfigs@2022-10-01-preview' = {
  name: name
  parent: namespace
  properties: {
    partnerNamespace: partnerNamespaceId
    alternateName: 'alternateName'
  }
}
