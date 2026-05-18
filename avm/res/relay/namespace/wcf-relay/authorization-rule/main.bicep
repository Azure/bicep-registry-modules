metadata name = 'WCF Relay Authorization Rules'
metadata description = 'This module deploys a WCF Relay Authorization Rule.'

@description('Required. The name of the authorization rule.')
param name string

@description('Conditional. The name of the parent Relay Namespace. Required if the template is used in a standalone deployment.')
param namespaceName string

@description('Conditional. The name of the parent Relay Namespace WCF Relay. Required if the template is used in a standalone deployment.')
param wcfRelayName string

@description('Optional. The rights associated with the rule.')
@allowed([
  'Listen'
  'Manage'
  'Send'
])
param rights array = []

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.relay-namespace-wcfrelayauthzrule.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

resource namespace 'Microsoft.Relay/namespaces@2021-11-01' existing = {
  name: namespaceName

  resource wcfRelay 'wcfRelays@2021-11-01' existing = {
    name: wcfRelayName
  }
}

resource authorizationRule 'Microsoft.Relay/namespaces/wcfRelays/authorizationRules@2021-11-01' = {
  name: name
  parent: namespace::wcfRelay
  properties: {
    rights: rights
  }
}

@description('The name of the authorization rule.')
output name string = authorizationRule.name

@description('The Resource ID of the authorization rule.')
output resourceId string = authorizationRule.id

@description('The name of the Resource Group the authorization rule was created in.')
output resourceGroupName string = resourceGroup().name
