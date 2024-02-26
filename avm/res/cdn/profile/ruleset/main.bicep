metadata name = 'CDN Profiles Rule Sets'
metadata description = 'This module deploys a CDN Profile rule set.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the rule set.')
param name string

@description('Required. The name of the CDN profile.')
param profileName string

@description('Optinal. The rules to apply to the rule set.')
param rules array = []

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true
var enableReferencedModulesTelemetry = false

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
}

resource rule_set 'Microsoft.Cdn/profiles/ruleSets@2023-05-01' = {
  name: name
  parent: profile
}

module rule 'rule/main.bicep' = [for (rule, index) in rules: {
  name: '${uniqueString(deployment().name)}-RuleSet-Rule-${rule.name}-${index}'
  params: {
    profileName: profileName
    ruleSetName: name
    name: rule.name
    order: rule.order
    actions: rule.actions
    conditions: contains(rule, 'conditions') ? rule.conditions : []
    matchProcessingBehavior: contains(rule, 'matchProcessingBehavior') ? rule.matchProcessingBehavior : 'Continue'
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

@description('The name of the rule set.')
output name string = rule_set.name

@description('The resource id of the rule set.')
output resourceId string = rule_set.id

@description('The name of the resource group the custom domain was created in.')
output resourceGroupName string = resourceGroup().name
