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

var managedVirtualNetworkVar = {
  referenceName: type == 'Managed' ? managedVirtualNetworkName : null
  type: type == 'Managed' ? 'ManagedVirtualNetworkReference' : null
}

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' existing = {
  name: dataFactoryName
}

resource integrationRuntime 'Microsoft.DataFactory/factories/integrationRuntimes@2018-06-01' = {
  name: name
  parent: dataFactory
  properties: type == 'Managed'
    ? {
        description: integrationRuntimeCustomDescription
        type: type
        managedVirtualNetwork: managedVirtualNetworkVar
        typeProperties: typeProperties
      }
    : {
        type: type
      }
}

@description('The name of the Resource Group the Integration Runtime was created in.')
output resourceGroupName string = resourceGroup().name

@description('The name of the Integration Runtime.')
output name string = integrationRuntime.name

@description('The resource ID of the Integration Runtime.')
output resourceId string = integrationRuntime.id
