targetScope = 'subscription'

metadata name = 'Using maximum configuration'
metadata description = 'Exercises identity, RBAC, lock, network attachment, both provider and exporter kinds, routes, policies, API keys and tool endpoints.'

import { workspaceType } from '../../../main.bicep'

@description('Optional. Test resource group name.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-apimanagement.aigateway-${serviceShort}-rg'
@description('Optional. A region with AI Gateway preview availability.')
param resourceLocation string = deployment().location
@description('Optional. Short test scenario identifier.')
param serviceShort string = 'aigwmax'
@description('Optional. Resource-name token substituted by the test harness.')
param namePrefix string = '#_namePrefix_#'
@description('Required. Existing Foundry account name. Its two model deployments must already be provisioned.')
param foundryAccountName string
@description('Required. Resource group of the existing Foundry account.')
param foundryResourceGroupName string
@description('Optional. Subscription of the existing Foundry account.')
param foundrySubscriptionId string = subscription().subscriptionId
@description('Required. Foundry endpoint including its trailing slash.')
param foundryEndpoint string
@description('Optional. Two existing deployment names in the Foundry account, in primary/secondary order.')
@minLength(2)
@maxLength(2)
param foundryDeploymentNames string[] = [
  'gpt-6.1-sol'
  'gpt-5-mini'
]
@description('Required. Reachable custom provider base endpoint.')
param customProviderEndpoint string
@secure()
@description('Required. API key for the custom provider.')
param customProviderApiKey string
@description('Required. Reachable MCP backend URL.')
param mcpEndpoint string
@secure()
@description('Required. MCP backend header value.')
param toolHeaderValue string
@description('Required. Reachable OpenAPI document URL.')
param openApiDocumentUrl string
@description('Required. Full OTLP traces endpoint.')
param otlpTracesEndpoint string
@secure()
@description('Required. OTLP authorization header value.')
param otlpHeaderValue string
@description('Required. Object ID to receive Reader access on the gateway.')
param readerPrincipalId string
@secure()
@description('Required. Explicit primary runtime API key value.')
param runtimePrimaryKey string
@secure()
@description('Required. Explicit secondary runtime API key value.')
param runtimeSecondaryKey string

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
    enableVirtualNetwork: true
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
var workspaceConfiguration workspaceType = {
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
        description: 'Existing Foundry models accessed with the gateway user-assigned identity.'
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
      models: map(foundryDeploymentNames, (deploymentName, index) => {
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
              type: 'tokenLimit'
              count: 10000
              period: 'minute'
              counterKey: [
                'ipAddress'
              ]
            }
            {
              type: 'ipFilter'
              action: 'Allow'
              cidrRanges: [
                '10.42.0.0/16'
              ]
            }
          ]
        }
      })
    }
    {
      name: 'custom'
      properties: {
        kind: 'Custom'
        displayName: 'Custom provider'
        custom: {
          endpoint: customProviderEndpoint
          authentication: {
            kind: 'ApiKey'
            apiKey: {
              headerName: 'Authorization'
              secretName: 'customProvider'
            }
          }
        }
      }
      models: [
        {
          name: 'custom-chat'
          properties: {
            displayName: 'Custom chat'
            apiFormat: 'OpenAIChatCompletions'
            supportedEndpoints: [
              '/openai/v1/chat/completions'
            ]
            deployment: {
              modelName: 'custom-chat'
            }
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
        description: '80/20 selection at priority zero, with a custom provider at priority one.'
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
          {
            providerName: 'custom'
            modelName: 'custom-chat'
            priority: 1
            weight: 1
          }
        ]
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
  toolServers: [
    {
      name: 'tools'
      properties: {
        displayName: 'Tools'
        type: 'mcp'
        path: 'tools'
        subscriptionRequired: true
        allowList: [
          'search*'
        ]
        blocked: [
          'delete*'
        ]
        endpoints: [
          {
            id: 'search'
            namespace: 'search'
            kind: 'mcp'
            mcp: {
              url: mcpEndpoint
              transport: 'streamableHttp'
            }
            credentials: {
              type: 'header'
              headers: [
                {
                  name: 'Authorization'
                  secretName: 'toolHeader'
                }
              ]
            }
            required: true
          }
          {
            id: 'openapi'
            kind: 'openApi'
            openApi: {
              specSource: {
                type: 'url'
                url: openApiDocumentUrl
              }
            }
            credentials: {
              type: 'none'
            }
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
    {
      name: 'otlp'
      properties: {
        kind: 'OpenTelemetry'
        payloadCapture: false
        openTelemetry: {
          tracesEndpoint: otlpTracesEndpoint
          headers: [
            {
              name: 'Authorization'
              secretName: 'otlpHeader'
            }
          ]
        }
      }
    }
  ]
}

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    scope: resourceGroup
    params: {
      name: '${namePrefix}${serviceShort}001'
      location: resourceLocation
      sku: 'Premium'
      tags: {
        scenario: 'max'
        workload: 'aigateway'
      }
      managedIdentities: {
        systemAssigned: true
        userAssignedResourceIds: [
          dependencies.outputs.identityResourceId
        ]
      }
      roleAssignments: [
        {
          roleDefinitionIdOrName: 'Reader'
          principalId: readerPrincipalId
          principalType: 'User'
        }
      ]
      lock: {
        kind: 'CanNotDelete'
      }
      enableTelemetry: false
      virtualNetworkConfiguration: {
        subnetResourceId: dependencies.outputs.subnetResourceId!
      }
      apiKeys: [
        {
          name: 'runtime'
          properties: {
            displayName: 'Runtime key'
            state: 'active'
            primaryKeySecretName: 'runtimePrimary'
            secondaryKeySecretName: 'runtimeSecondary'
          }
        }
        {
          name: 'generated'
          properties: {
            displayName: 'Service-generated key'
          }
        }
      ]
      workspaces: [
        workspaceConfiguration
      ]
      secrets: {
        customProvider: customProviderApiKey
        toolHeader: toolHeaderValue
        appInsights: dependencies.outputs.appInsightsConnectionString
        otlpHeader: otlpHeaderValue
        runtimePrimary: runtimePrimaryKey
        runtimeSecondary: runtimeSecondaryKey
      }
    }
    dependsOn: [
      foundryAccess
    ]
  }
]
