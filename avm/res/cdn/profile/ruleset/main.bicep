metadata name = 'CDN Profiles Rule Sets'
metadata description = 'This module deploys a CDN Profile rule set.'

@description('Required. The name of the rule set.')
param name string

@description('Required. The name of the CDN profile.')
param profileName string

@description('Optinal. The rules to apply to the rule set.')
param rules ruleType[]?

resource profile 'Microsoft.Cdn/profiles@2023-05-01' existing = {
  name: profileName
}

resource ruleSet 'Microsoft.Cdn/profiles/ruleSets@2023-05-01' = {
  name: name
  parent: profile
}

module ruleSet_rules 'rule/main.bicep' = [
  for (rule, index) in (rules ?? []): {
    name: '${uniqueString(deployment().name)}-RuleSet-Rule-${rule.name}-${index}'
    params: {
      profileName: profileName
      ruleSetName: name
      name: rule.name
      order: rule.order
      actions: rule.?actions
      conditions: rule.?conditions
      matchProcessingBehavior: rule.?matchProcessingBehavior
    }
  }
]

import { ruleType } from './rule/main.bicep'

@export()
type ruleSetType = {
  @description('Required. Name of the rule set.')
  name: string

  @description('Optional. Array of rules.')
  rules: ruleType[]?
}

@description('The name of the rule set.')
output name string = ruleSet.name

@description('The resource id of the rule set.')
output resourceId string = ruleSet.id

@description('The name of the resource group the custom domain was created in.')
output resourceGroupName string = resourceGroup().name
