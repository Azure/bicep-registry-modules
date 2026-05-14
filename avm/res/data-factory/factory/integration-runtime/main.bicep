metadata name = 'Data Factory Integration RunTimes'
metadata description = 'This module deploys a Data Factory Managed or Self-Hosted Integration Runtime.'

@description('Conditional. The name of the parent Azure Data Factory. Required if the template is used in a standalone deployment.')
param dataFactoryName string

@description('Required. The name of the Integration Runtime.')
param name string

@allowed([
  'Managed'
  'SelfHosted'
])
@description('Required. The type of Integration Runtime.')
param type string

@description('Optional. The name of the Managed Virtual Network if using type "Managed" .')
param managedVirtualNetworkName string = ''

@description('Optional. Integration Runtime type properties. Required if type is "Managed".')
param typeProperties object = {}

@description('Optional. The description of the Integration Runtime.')
param integrationRuntimeCustomDescription string = 'Managed Integration Runtime created by avm-res-datafactory-factories'

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.datafactory-factory-integrruntime.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' existing = {
  name: dataFactoryName
}

resource integrationRuntime 'Microsoft.DataFactory/factories/integrationRuntimes@2018-06-01' = {
  name: name
  parent: dataFactory
  properties: {
    #disable-next-line BCP225 // Not a key-word
    type: type
    ...(!empty(typeProperties) ? { typeProperties: typeProperties } : {})
    ...(type == 'Managed'
      ? {
          description: integrationRuntimeCustomDescription
          managedVirtualNetwork: {
            referenceName: managedVirtualNetworkName
            type: 'ManagedVirtualNetworkReference'
          }
        }
      : {})
  }
}

@description('The name of the Resource Group the Integration Runtime was created in.')
output resourceGroupName string = resourceGroup().name

@description('The name of the Integration Runtime.')
output name string = integrationRuntime.name

@description('The resource ID of the Integration Runtime.')
output resourceId string = integrationRuntime.id
