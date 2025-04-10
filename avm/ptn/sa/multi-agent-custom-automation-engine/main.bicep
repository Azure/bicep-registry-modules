metadata name = '<Add module name>'
metadata description = '<Add description>'

@description('Required. Name of the resource to create.')
param solutionPrefix string

@description('Optional. Location for all Resources.')
param solutionLocation string = resourceGroup().location

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. The tags to apply to all deployed Azure resources.')
param tags object = {
  app: solutionPrefix
  location: solutionLocation
}

//
// Add your parameters here
//

// ============== //
// Resources      //
// ============== //

/* #disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.[[REPLACE WITH TELEMETRY IDENTIFIER]].${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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
} */

// ========== Log Analytics Workspace ========== //
module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.11.1' = {
  name: 'avm.ptn.sa.macae.operational-insights-workspace'
  params: {
    name: '${solutionPrefix}laws'
    tags: tags
    location: solutionLocation
    enableTelemetry: enableTelemetry
    skuName: 'PerGB2018'
    dataRetention: 30
  }
}

// ========== Application Insights ========== //
module avmInsightsComponent 'br/public:avm/res/insights/component:0.6.0' = {
  name: 'avm.ptn.sa.macae.insights-component'
  params: {
    name: '${solutionPrefix}appi'
    workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
    tags: tags
    location: solutionLocation
    enableTelemetry: enableTelemetry
    diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }]
    kind: 'web'
    disableIpMasking: false
    flowType: 'Bluefield'
    requestSource: 'rest'
  }
}

// ========== User assigned identity ========== //

module userAssignedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.1' = {
  name: 'avm.ptn.sa.macae.managed-identity-assigned-identity'
  params: {
    name: '${solutionPrefix}uaid'
    tags: tags
    location: solutionLocation
    enableTelemetry: enableTelemetry
  }
}

// AI Foundry: AI Services
// NOTE: Required version 'Microsoft.CognitiveServices/accounts@2024-04-01-preview' not available in AVM
module avmCognitiveServicesAccounts 'br/public:avm/res/cognitive-services/account:0.10.2' = {
  name: 'avm.ptn.sa.macae.cognitive-services-account'
  params: {
    name: '${solutionPrefix}aisv'
    tags: tags
    location: solutionLocation
    enableTelemetry: enableTelemetry
    diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }]
    sku: 'S0'
    kind: 'AIServices'
    disableLocalAuth: true
    customSubDomainName: '${solutionPrefix}aisv'
    apiProperties: {
      staticsEnabled: false
    }
    publicNetworkAccess: 'Enabled' //TODO: block and connect to vnet
    roleAssignments: [
      {
        principalId: userAssignedIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Cognitive Services OpenAI User'
      }
    ]
    deployments: [
      {
        name: 'gpt-4o'
        model: {
          format: 'OpenAI'
          name: 'gpt-4o'
          version: '2024-08-06'
        }
        sku: {
          name: 'GlobalStandard'
          capacity: 50
        }
      }
    ]
  }
}

// ============ //
// Outputs      //
// ============ //

// Add your outputs here

// @description('The resource ID of the resource.')
// output resourceId string = <Resource>.id

// @description('The name of the resource.')
// output name string = <Resource>.name

// @description('The location the resource was deployed into.')
// output location string = <Resource>.location

// ================ //
// Definitions      //
// ================ //
//
// Add your User-defined-types here, if any
//
