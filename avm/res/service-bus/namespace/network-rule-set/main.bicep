metadata name = 'Service Bus Namespace Network Rule Sets'
metadata description = 'This module deploys a ServiceBus Namespace Network Rule Set.'

@description('Conditional. The name of the parent Service Bus Namespace for the Service Bus Network Rule Set. Required if the template is used in a standalone deployment.')
@minLength(1)
@maxLength(260)
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

@description('Optional. Value that indicates whether Trusted Service Access is enabled or not. Default is "true". It will not be set if publicNetworkAccess is "Disabled".')
param trustedServiceAccessEnabled bool = true

@description('Optional. List virtual network rules. It will not be set if publicNetworkAccess is "Disabled". Otherwise, when used, defaultAction will be set to "Deny".')
param virtualNetworkRules array = []

@description('Optional. List of IpRules. It will not be set if publicNetworkAccess is "Disabled". Otherwise, when used, defaultAction will be set to "Deny".')
param ipRules array = []

var networkRules = [
  for (virtualNetworkRule, index) in virtualNetworkRules: {
    ignoreMissingVnetServiceEndpoint: virtualNetworkRule.?ignoreMissingVnetServiceEndpoint
    subnet: contains(virtualNetworkRule, 'subnetResourceId')
      ? {
          id: virtualNetworkRule.subnetResourceId
        }
      : null
  }
]

resource namespace 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' existing = {
  name: namespaceName
}

resource networkRuleSet 'Microsoft.ServiceBus/namespaces/networkRuleSets@2022-10-01-preview' = {
  name: 'default'
  parent: namespace
  properties: {
    publicNetworkAccess: publicNetworkAccess
    defaultAction: publicNetworkAccess == 'Enabled'
      ? (!empty(ipRules) || !empty(virtualNetworkRules) ? 'Deny' : defaultAction)
      : null
    trustedServiceAccessEnabled: publicNetworkAccess == 'Enabled' ? trustedServiceAccessEnabled : null
    ipRules: publicNetworkAccess == 'Enabled' ? ipRules : null
    virtualNetworkRules: publicNetworkAccess == 'Enabled' ? networkRules : null
  }
}

@description('The name of the network rule set.')
output name string = networkRuleSet.name

@description('The resource ID of the network rule set.')
output resourceId string = networkRuleSet.id

@description('The name of the resource group the network rule set was created in.')
output resourceGroupName string = resourceGroup().name
