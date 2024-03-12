metadata name = 'Dns Forwarding Rulesets Forwarding Rules'
metadata description = 'This template deploys Forwarding Rule in a Dns Forwarding Ruleset.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the Forwarding Rule.')
@minLength(1)
param name string

@description('Conditional. Name of the parent DNS Forwarding Ruleset. Required if the template is used in a standalone deployment.')
param dnsForwardingRulesetName string

@description('Required. The domain name for the forwarding rule.')
param domainName string

@description('Optional. The state of forwarding rule.')
param forwardingRuleState string?

@description('Optional. Metadata attached to the forwarding rule.')
param metadata object?

@description('Required. DNS servers to forward the DNS query to.')
param targetDnsServers array

resource dnsForwardingRuleset 'Microsoft.Network/dnsForwardingRulesets@2022-07-01' existing = {
  name: dnsForwardingRulesetName
}

resource forwardingRule 'Microsoft.Network/dnsForwardingRulesets/forwardingRules@2022-07-01' = {
  name: name
  parent: dnsForwardingRuleset
  properties: {
    domainName: domainName
    forwardingRuleState: forwardingRuleState
    metadata: metadata
    targetDnsServers: targetDnsServers
  }
}

@description('The resource group the Forwarding Rule was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the Forwarding Rule.')
output resourceId string = forwardingRule.id

@description('The name of the Forwarding Rule.')
output name string = forwardingRule.name
