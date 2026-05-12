metadata name = 'Firewall Policy Rule Collection Groups'
metadata description = 'This module deploys a Firewall Policy Rule Collection Group.'

@description('Conditional. The name of the parent Firewall Policy. Required if the template is used in a standalone deployment.')
param firewallPolicyName string

@description('Required. The name of the rule collection group to deploy.')
param name string

@description('Required. Priority of the Firewall Policy Rule Collection Group resource.')
param priority int

@description('Optional. Group of Firewall Policy rule collections.')
param ruleCollections array?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.network-fwpolicy-rulecollection.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource firewallPolicy 'Microsoft.Network/firewallPolicies@2024-10-01' existing = {
  name: firewallPolicyName
}

resource ruleCollectionGroup 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2024-10-01' = {
  name: name
  parent: firewallPolicy
  properties: {
    priority: priority
    ruleCollections: ruleCollections ?? []
  }
}

@description('The name of the deployed rule collection group.')
output name string = ruleCollectionGroup.name

@description('The resource ID of the deployed rule collection group.')
output resourceId string = ruleCollectionGroup.id

@description('The resource group of the deployed rule collection group.')
output resourceGroupName string = resourceGroup().name
