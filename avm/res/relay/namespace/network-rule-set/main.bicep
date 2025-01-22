metadata name = 'Relay Namespace Network Rules Sets'
metadata description = 'This module deploys a Relay Namespace Network Rule Set.'

@description('Conditional. The name of the parent Relay Namespace for the Relay Network Rule Set. Required if the template is used in a standalone deployment.')
@minLength(6)
@maxLength(50)
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

@description('Optional. List of IpRules. It will not be set if publicNetworkAccess is "Disabled". Otherwise, when used, defaultAction will be set to "Deny".')
param ipRules array?

resource namespace 'Microsoft.Relay/namespaces@2021-11-01' existing = {
  name: namespaceName
}

resource networkRuleSet 'Microsoft.Relay/namespaces/networkRuleSets@2021-11-01' = {
  name: 'default'
  parent: namespace
  properties: {
    publicNetworkAccess: publicNetworkAccess
    defaultAction: publicNetworkAccess == 'Disabled' ? null : (!empty(ipRules) ? 'Deny' : defaultAction)
    ipRules: publicNetworkAccess == 'Disabled' ? null : ipRules
  }
}

@description('The name of the network rule set.')
output name string = networkRuleSet.name

@description('The resource ID of the network rule set.')
output resourceId string = networkRuleSet.id

@description('The name of the resource group the network rule set was created in.')
output resourceGroupName string = resourceGroup().name
