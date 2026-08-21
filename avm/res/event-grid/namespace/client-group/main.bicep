metadata name = 'Eventgrid Namespace Client Groups'
metadata description = 'This module deploys an Eventgrid Namespace Client Group.'

@sys.description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@sys.description('Conditional. The name of the parent EventGrid namespace. Required if the template is used in a standalone deployment.')
param namespaceName string

@sys.description('Required. Name of the Client Group.')
param name string

@sys.description('Required. The grouping query for the clients.')
param query string

@sys.description('Optional. Description of the Client Group.')
param description string?

// ============== //
// Resources      //
// ============== //

resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.eventgrid-namespace-clientgroup.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, 'eastus'), 0, 4)}'
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

resource namespace 'Microsoft.EventGrid/namespaces@2023-12-15-preview' existing = {
  name: namespaceName
}

resource clientGroup 'Microsoft.EventGrid/namespaces/clientGroups@2023-12-15-preview' = {
  name: name
  parent: namespace
  properties: {
    description: description
    query: query
  }
}

// ============ //
// Outputs      //
// ============ //

@sys.description('The resource ID of the Client Group.')
output resourceId string = clientGroup.id

@sys.description('The name of the Client Group.')
output name string = clientGroup.name

@sys.description('The name of the resource group the Client Group was created in.')
output resourceGroupName string = resourceGroup().name

// ================ //
// Definitions      //
// ================ //
//
// Add your User-defined-types here, if any
//
