metadata name = 'Eventgrid Namespace CA Certificates'
metadata description = 'This module deploys an Eventgrid Namespace CA Certificate.'

@sys.description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@sys.description('Conditional. The name of the parent EventGrid namespace. Required if the template is used in a standalone deployment.')
param namespaceName string

@sys.description('Required. Name of the CA certificate.')
param name string

@sys.description('Optional. Description for the CA Certificate resource.')
param description string?

@sys.description('Required. Base64 encoded PEM (Privacy Enhanced Mail) format certificate data.')
param encodedCertificate string

// ============== //
// Resources      //
// ============== //

resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.eventgrid-namespace-cacertificate.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, 'eastus'), 0, 4)}'
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

resource caCertificate 'Microsoft.EventGrid/namespaces/caCertificates@2023-12-15-preview' = {
  name: name
  parent: namespace
  properties: {
    description: description
    encodedCertificate: encodedCertificate
  }
}

// ============ //
// Outputs      //
// ============ //

@sys.description('The resource ID of the CA certificate.')
output resourceId string = caCertificate.id

@sys.description('The name of the CA certificate.')
output name string = caCertificate.name

@sys.description('The name of the resource group the CA certificate was created in.')
output resourceGroupName string = resourceGroup().name

// ================ //
// Definitions      //
// ================ //
//
// Add your User-defined-types here, if any
//
