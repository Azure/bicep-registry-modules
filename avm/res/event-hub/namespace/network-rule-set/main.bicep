metadata name = 'Event Hub Namespace Network Rule Sets'
metadata description = 'This module deploys an Event Hub Namespace Network Rule Set.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent event hub namespace. Required if the template is used in a standalone deployment.')
param namespaceName string

@allowed([
  'Enabled'
  'Disabled'
])
@description('Optional. This determines if traffic is allowed over public network. Default is "Enabled". If set to "Disabled", traffic to this namespace will be restricted over Private Endpoints only and network rules will not be applied.')
param publicNetworkAccess string = 'Enabled'

@allowed([
  'Allow'
  'Deny'
])
@description('Optional. Default Action for Network Rule Set. Default is "Allow". It will not be set if publicNetworkAccess is "Disabled". Otherwise, it will be set to "Deny" if ipRules or virtualNetworkRules are being used.')
param defaultAction string = 'Allow'

@description('Optional. Value that indicates whether Trusted Service Access is enabled or not.')
param trustedServiceAccessEnabled bool = true

@description('Optional. An array of subnet resource ID objects that this Event Hub Namespace is exposed to via Service Endpoints. You can enable the `ignoreMissingVnetServiceEndpoint` if you wish to add this virtual network to Event Hub Namespace but do not have an existing service endpoint. It will not be set if publicNetworkAccess is "Disabled". Otherwise, when used, defaultAction will be set to "Deny".')
param virtualNetworkRules array = []

@description('Optional. An array of objects for the public IP ranges you want to allow via the Event Hub Namespace firewall. Supports IPv4 address or CIDR. It will not be set if publicNetworkAccess is "Disabled". Otherwise, when used, defaultAction will be set to "Deny".')
param ipRules array = []

@description('Optional. The name of the network ruleset.')
param networkRuleSetName string = 'default'

var networkRules = [
  for (virtualNetworkRule, index) in virtualNetworkRules: {
    ignoreMissingVnetServiceEndpoint: contains(virtualNetworkRule, 'ignoreMissingVnetServiceEndpoint')
      ? virtualNetworkRule.ignoreMissingVnetServiceEndpoint
      : null
    subnet: contains(virtualNetworkRule, 'subnetResourceId')
      ? {
          id: virtualNetworkRule.subnetResourceId
        }
      : null
  }
]

resource namespace 'Microsoft.EventHub/namespaces@2024-01-01' existing = {
  name: namespaceName
}

resource networkRuleSet 'Microsoft.EventHub/namespaces/networkRuleSets@2024-01-01' = {
  name: networkRuleSetName
  parent: namespace
  properties: {
    publicNetworkAccess: publicNetworkAccess
    defaultAction: publicNetworkAccess == 'Disabled'
      ? null
      : (!empty(ipRules) || !empty(virtualNetworkRules) ? 'Deny' : defaultAction)
    trustedServiceAccessEnabled: trustedServiceAccessEnabled
    ipRules: publicNetworkAccess == 'Disabled' ? null : ipRules
    virtualNetworkRules: publicNetworkAccess == 'Disabled' ? null : networkRules
  }
}

@description('The name of the network rule set.')
output name string = networkRuleSet.name

@description('The resource ID of the network rule set.')
output resourceId string = networkRuleSet.id

@description('The name of the resource group the network rule set was created in.')
output resourceGroupName string = resourceGroup().name
