metadata name = 'CDN Profiles Rules'
metadata description = 'This module deploys a CDN Profile rule.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the rule.')
param name string

@description('Required. The name of the profile.')
param profileName string

@description('Required. The name of the rule set.')
param ruleSetName string

@description('Required. The order in which this rule will be applied. Rules with a lower order are applied before rules with a higher order.')
param order int

@description('Optional. A list of actions that are executed when all the conditions of a rule are satisfied.')
param actions array = []

@description('Optional. A list of conditions that must be matched for the actions to be executed.')
param conditions array = []

@allowed([
  'Continue'
  'Stop'
])
@description('Required. If this rule is a match should the rules engine continue running the remaining rules or stop. If not present, defaults to Continue.')
param matchProcessingBehavior string

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource profile 'Microsoft.Cdn/profiles@2023-05-01' existing = {
  name: profileName

  resource rule_set 'ruleSets@2023-05-01' existing = {
    name: ruleSetName
  }
}

resource rule_set_rule 'Microsoft.Cdn/profiles/ruleSets/rules@2023-05-01' = {
  name: name
  parent: profile::rule_set
  properties: {
    order: order
    actions: actions
    conditions: conditions
    matchProcessingBehavior: matchProcessingBehavior
  }
}

@description('The name of the rule.')
output name string = rule_set_rule.name

@description('The resource id of the rule.')
output resourceId string = rule_set_rule.id

@description('The name of the resource group the custom domain was created in.')
output resourceGroupName string = resourceGroup().name
