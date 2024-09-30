metadata name = 'Front Door Web Application Firewall (WAF) Policies'
metadata description = 'This module deploys a Front Door Web Application Firewall (WAF) Policy.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the Front Door WAF policy.')
@minLength(1)
@maxLength(128)
param name string

@description('Optional. Location for all resources.')
param location string = 'global'

@allowed([
  'Standard_AzureFrontDoor'
  'Premium_AzureFrontDoor'
])
@description('Optional. The pricing tier of the WAF profile.')
param sku string = 'Standard_AzureFrontDoor'

@description('Optional. Resource tags.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Describes the managedRules structure.')
param managedRules managedRulesType = {
  managedRuleSets: [
    {
      ruleSetType: 'Microsoft_DefaultRuleSet'
      ruleSetVersion: '2.1'
      ruleGroupOverrides: []
      exclusions: []
      ruleSetAction: 'Block'
    }
    {
      ruleSetType: 'Microsoft_BotManagerRuleSet'
      ruleSetVersion: '1.0'
      ruleGroupOverrides: []
      exclusions: []
    }
  ]
}

@description('Optional. The custom rules inside the policy.')
param customRules customRulesType = {
  rules: [
    {
      name: 'ApplyGeoFilter'
      priority: 100
      enabledState: 'Enabled'
      ruleType: 'MatchRule'
      action: 'Block'
      matchConditions: [
        {
          matchVariable: 'RemoteAddr'
          operator: 'GeoMatch'
          negateCondition: true
          matchValue: ['ZZ']
        }
      ]
    }
  ]
}

@description('Optional. The PolicySettings for policy.')
param policySettings object = {
  enabledState: 'Enabled'
  mode: 'Prevention'
}

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
  'User Access Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  )
}

var formattedRoleAssignments = [
  for (roleAssignment, index) in (roleAssignments ?? []): union(roleAssignment, {
    roleDefinitionId: builtInRoleNames[?roleAssignment.roleDefinitionIdOrName] ?? (contains(
        roleAssignment.roleDefinitionIdOrName,
        '/providers/Microsoft.Authorization/roleDefinitions/'
      )
      ? roleAssignment.roleDefinitionIdOrName
      : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName))
  })
]

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.network-frontdoorwebappfwpolicy.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource frontDoorWAFPolicy 'Microsoft.Network/FrontDoorWebApplicationFirewallPolicies@2024-02-01' = {
  name: name
  location: location
  sku: {
    name: sku
  }
  tags: tags
  properties: {
    customRules: customRules
    managedRules: sku == 'Premium_AzureFrontDoor' ? managedRules : { managedRuleSets: [] }
    policySettings: policySettings
  }
}

resource frontDoorWAFPolicy_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: frontDoorWAFPolicy
}

resource frontDoorWAFPolicy_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(
      frontDoorWAFPolicy.id,
      roleAssignment.principalId,
      roleAssignment.roleDefinitionId
    )
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: frontDoorWAFPolicy
  }
]

@description('The name of the Front Door WAF policy.')
output name string = frontDoorWAFPolicy.name

@description('The resource ID of the Front Door WAF policy.')
output resourceId string = frontDoorWAFPolicy.id

@description('The resource group the Front Door WAF policy was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = frontDoorWAFPolicy.location

// =============== //
//   Definitions   //
// =============== //

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

type roleAssignmentType = {
  @description('Optional. The name (as GUID) of the role assignment. If not provided, a GUID will be generated.')
  name: string?

  @description('Required. The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
  roleDefinitionIdOrName: string

  @description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
  principalId: string

  @description('Optional. The principal type of the assigned principal ID.')
  principalType: ('ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup' | 'Device')?

  @description('Optional. The description of the role assignment.')
  description: string?

  @description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".')
  condition: string?

  @description('Optional. Version of the condition.')
  conditionVersion: '2.0'?

  @description('Optional. The Resource Id of the delegated managed identity resource.')
  delegatedManagedIdentityResourceId: string?
}[]?

type managedRulesType = {
  @description('Optional. List of rule sets.')
  managedRuleSets: managedRuleSetsType
}

type managedRuleSetsType = {
  @description('Required. Defines the rule set type to use.')
  ruleSetType: string

  @description('Required. Defines the version of the rule set to use.')
  ruleSetVersion: string

  @description('Optional. Defines the rule group overrides to apply to the rule set.')
  ruleGroupOverrides: array?

  @description('Optional. Describes the exclusions that are applied to all rules in the set.')
  exclusions: array?

  @description('Optional. Defines the rule set action.')
  ruleSetAction: 'Block' | 'Log' | 'Redirect' | null
}[]?

type customRulesType = {
  @description('Optional. List of rules.')
  rules: customRulesRuleType
}

type customRulesRuleType = {
  @description('Required. Describes what action to be applied when rule matches.')
  action: 'Allow' | 'Block' | 'Log' | 'Redirect'

  @description('Required. Describes if the custom rule is in enabled or disabled state.')
  enabledState: 'Enabled' | 'Disabled'

  @description('Required. List of match conditions. See https://learn.microsoft.com/en-us/azure/templates/microsoft.network/frontdoorwebapplicationfirewallpolicies#matchcondition for details.')
  matchConditions: array

  @description('Required. Describes the name of the rule.')
  name: string

  @description('Required. Describes priority of the rule. Rules with a lower value will be evaluated before rules with a higher value.')
  priority: int

  @description('Optional. Time window for resetting the rate limit count. Default is 1 minute.')
  rateLimitDurationInMinutes: int?

  @description('Optional. Number of allowed requests per client within the time window.')
  rateLimitThreshold: int?

  @description('Required. Describes type of rule.')
  ruleType: 'MatchRule' | 'RateLimitRule'
}[]?
