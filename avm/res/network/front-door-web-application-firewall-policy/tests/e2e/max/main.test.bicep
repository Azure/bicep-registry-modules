targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.frontdoorWebApplicationFirewallPolicies-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nagwafpmax'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    location: resourceLocation
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      location: resourceLocation
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
      sku: 'Premium_AzureFrontDoor'
      policySettings: {
        mode: 'Prevention'
        redirectUrl: 'http://www.bing.com'
        customBlockResponseStatusCode: 200
        customBlockResponseBody: 'PGh0bWw+CjxoZWFkZXI+PHRpdGxlPkhlbGxvPC90aXRsZT48L2hlYWRlcj4KPGJvZHk+CkhlbGxvIHdvcmxkCjwvYm9keT4KPC9odG1sPg=='
      }
      customRules: {
        rules: [
          {
            name: 'CustomRule1'
            priority: 2
            enabledState: 'Enabled'
            action: 'Block'
            ruleType: 'MatchRule'
            rateLimitDurationInMinutes: 1
            rateLimitThreshold: 10
            matchConditions: [
              {
                matchVariable: 'RemoteAddr'
                selector: null
                operator: 'GeoMatch'
                negateCondition: false
                transforms: []
                matchValue: [
                  'CH'
                ]
              }
              {
                matchVariable: 'RequestHeader'
                selector: 'UserAgent'
                operator: 'Contains'
                negateCondition: false
                transforms: []
                matchValue: [
                  'windows'
                ]
              }
              {
                matchVariable: 'QueryString'
                operator: 'Contains'
                negateCondition: false
                transforms: [
                  'UrlDecode'
                  'Lowercase'
                ]
                matchValue: [
                  '<?php'
                  '?>'
                ]
              }
            ]
          }
        ]
      }
      managedRules: {
        managedRuleSets: [
          {
            ruleSetType: 'Microsoft_BotManagerRuleSet'
            ruleSetVersion: '1.0'
          }
        ]
      }
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
      roleAssignments: [
        {
          roleDefinitionIdOrName: 'Owner'
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
        {
          roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
        {
          roleDefinitionIdOrName: subscriptionResourceId(
            'Microsoft.Authorization/roleDefinitions',
            'acdd72a7-3385-48ef-bd42-f606fba81ae7'
          )
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
      ]
    }
  }
]
