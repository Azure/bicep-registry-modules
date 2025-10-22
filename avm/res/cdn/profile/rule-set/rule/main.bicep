metadata name = 'CDN Profiles Rules'
metadata description = 'This module deploys a CDN Profile rule.'

@description('Required. The name of the rule.')
param name string

@description('Required. The name of the profile.')
param profileName string

@description('Required. The name of the rule set.')
param ruleSetName string

@description('Required. The order in which this rule will be applied. Rules with a lower order are applied before rules with a higher order.')
param order int

@description('Optional. A list of actions that are executed when all the conditions of a rule are satisfied.')
param actions resourceInput<'Microsoft.Cdn/profiles/ruleSets/rules@2025-04-15'>.properties.actions?

@description('Optional. A list of conditions that must be matched for the actions to be executed.')
param conditions resourceInput<'Microsoft.Cdn/profiles/ruleSets/rules@2025-04-15'>.properties.conditions?

@allowed([
  'Continue'
  'Stop'
])
@description('Optional. If this rule is a match should the rules engine continue running the remaining rules or stop. If not present, defaults to Continue.')
param matchProcessingBehavior string = 'Continue'

resource profile 'Microsoft.Cdn/profiles@2025-04-15' existing = {
  name: profileName

  resource ruleSet 'ruleSets@2025-04-15' existing = {
    name: ruleSetName
  }
}

resource rule 'Microsoft.Cdn/profiles/ruleSets/rules@2025-04-15' = {
  name: name
  parent: profile::ruleSet
  properties: {
    order: order
    actions: actions
    conditions: conditions
    matchProcessingBehavior: matchProcessingBehavior
  }
}

@description('The name of the rule.')
output name string = rule.name

@description('The resource id of the rule.')
output resourceId string = rule.id

@description('The name of the resource group the custom domain was created in.')
output resourceGroupName string = resourceGroup().name
