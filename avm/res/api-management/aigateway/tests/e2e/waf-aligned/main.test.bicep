targetScope = 'subscription'

metadata name = 'WAF-aligned governance configuration'
metadata description = 'Demonstrates managed identity upstream access, model routing, budgets, content safety and metadata-only telemetry. Not a WAF certification.'

@description('Optional. Test resource group name.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-apimanagement.aigateway-${serviceShort}-rg'
@description('Optional. A region with AI Gateway preview availability.')
param resourceLocation string = deployment().location
@description('Optional. Short test scenario identifier.')
param serviceShort string = 'aigwwaf'
@description('Optional. Resource-name token substituted by the test harness.')
param namePrefix string = '#_namePrefix_#'
@description('Required. Existing Foundry account with the specified deployments.')
param foundryAccountName string
@description('Required. Resource group of the Foundry account.')
param foundryResourceGroupName string
@description('Optional. Subscription of the Foundry account.')
param foundrySubscriptionId string = subscription().subscriptionId
@description('Required. Foundry endpoint including its trailing slash.')
param foundryEndpoint string
@description('Optional. Two existing Foundry deployment names, in primary/secondary order.')
@minLength(2)
@maxLength(2)
param foundryDeploymentNames string[] = [
  'gpt-6.1-sol'
  'gpt-5-mini'
]

resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}
module dependencies '../dependencies/main.bicep' = {
  name: '${uniqueString(deployment().name)}-Dependencies'
  scope: resourceGroup
  params: {
    namePrefix: namePrefix
    location: resourceLocation
  }
}
module foundryAccess '../dependencies/foundry-role-assignment.bicep' = {
  name: '${uniqueString(deployment().name)}-FoundryAccess'
  scope: az.resourceGroup(foundrySubscriptionId, foundryResourceGroupName)
  params: {
    accountName: foundryAccountName
    principalId: dependencies.outputs.identityPrincipalId
  }
}

var foundryAccountId = resourceId(
  foundrySubscriptionId,
  foundryResourceGroupName,
  'Microsoft.CognitiveServices/accounts',
  foundryAccountName
)

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    scope: resourceGroup
    params: {
      name: '${namePrefix}${serviceShort}001'
      managedIdentities: {
        systemAssigned: false
        userAssignedResourceIds: [
          dependencies.outputs.identityResourceId
        ]
      }
      tags: {
        workload: 'aigateway'
        scenario: 'waf-aligned'
      }
      lock: {
        kind: 'CanNotDelete'
      }
      apiKeys: []
      workspaces: [
        {
          name: 'default'
          policies: [
            {
              type: 'tokenLimit'
              scope: 'workspace'
              count: 5000
              period: 'minute'
              counterKey: [
                'identity'
              ]
            }
            {
              type: 'costLimit'
              scope: 'workspace'
              id: 'default'
              amount: 25
              period: 'month'
              counterKey: [
                'identity'
              ]
            }
          ]
          modelProviders: [
            {
              name: 'foundry'
              properties: {
                kind: 'Foundry'
                displayName: 'Foundry'
                foundry: {
                  endpoint: foundryEndpoint
                  resourceIds: [
                    foundryAccountId
                  ]
                  authentication: {
                    kind: 'ManagedIdentity'
                    managedIdentity: {
                      resource: 'https://cognitiveservices.azure.com/'
                      clientId: dependencies.outputs.identityClientId
                    }
                  }
                }
              }
              models: [
                for (deploymentName, index) in foundryDeploymentNames: {
                  name: 'chat-${index}'
                  properties: {
                    displayName: deploymentName
                    apiFormat: 'OpenAIChatCompletions'
                    supportedEndpoints: [
                      '/openai/v1/chat/completions'
                    ]
                    deployment: {
                      resourceId: '${foundryAccountId}/deployments/${deploymentName}'
                      modelName: deploymentName
                    }
                    policies: [
                      {
                        type: 'contentSafety'
                        hateSeverity: 'Medium'
                        selfHarmSeverity: 'Medium'
                        sexualSeverity: 'Medium'
                        violenceSeverity: 'Medium'
                      }
                    ]
                  }
                }
              ]
            }
          ]
          aliases: [
            {
              name: 'chat'
              properties: {
                displayName: 'Chat'
                routes: [
                  {
                    providerName: 'foundry'
                    modelName: 'chat-0'
                    priority: 0
                    weight: 80
                  }
                  {
                    providerName: 'foundry'
                    modelName: 'chat-1'
                    priority: 0
                    weight: 20
                  }
                ]
              }
            }
          ]
          telemetryExporters: [
            {
              name: 'appinsights'
              properties: {
                kind: 'ApplicationInsights'
                payloadCapture: false
                applicationInsights: {
                  connectionStringSecretName: 'appInsights'
                  resourceId: dependencies.outputs.appInsightsResourceId
                }
              }
            }
          ]
        }
      ]
      secrets: {
        appInsights: dependencies.outputs.appInsightsConnectionString
      }
    }
    dependsOn: [
      foundryAccess
    ]
  }
]
