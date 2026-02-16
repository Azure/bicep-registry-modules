metadata name = 'CDN Profiles Rule Sets'
metadata description = 'This module deploys a CDN Profile rule set.'

@description('Required. The name of the rule set.')
param name string

@description('Required. The name of the CDN profile.')
param profileName string

@description('Optinal. The rules to apply to the rule set.')
param rules ruleType[]?

resource profile 'Microsoft.Cdn/profiles@2025-04-15' existing = {
  name: profileName
}

resource ruleSet 'Microsoft.Cdn/profiles/ruleSets@2025-04-15' = {
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

@description('The name of the rule set.')
output name string = ruleSet.name

@description('The resource id of the rule set.')
output resourceId string = ruleSet.id

@description('The name of the resource group the custom domain was created in.')
output resourceGroupName string = resourceGroup().name

// =============== //
//   Definitions   //
// =============== //

@export()
@description('The type of the rule.')
type ruleType = {
  @description('Required. The name of the rule.')
  name: string

  @description('Required. The order in which the rules are applied for the endpoint.')
  order: int

  @description('Optional. A list of actions that are executed when all the conditions of a rule are satisfied.')
  actions: resourceInput<'Microsoft.Cdn/profiles/ruleSets/rules@2025-04-15'>.properties.actions?

  @description('Optional. A list of conditions that must be matched for the actions to be executed.')
  conditions: resourceInput<'Microsoft.Cdn/profiles/ruleSets/rules@2025-04-15'>.properties.conditions?

  @description('Optional. If this rule is a match should the rules engine continue running the remaining rules or stop. If not present, defaults to Continue.')
  matchProcessingBehavior: 'Continue' | 'Stop' | null
}
