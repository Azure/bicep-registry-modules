metadata name = 'Data Factory Linked Service'
metadata description = 'This module deploys a Data Factory Linked Service.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent Azure Data Factory. Required if the template is used in a standalone deployment.')
param dataFactoryName string

@description('Required. The name of the Linked Service.')
param name string

@description('Required. The type of Linked Service.')
param typeName string

@description('Optional. Used to add connection properties for your linked services.')
param typeProperties object = {}

@description('Optional. The name of the Integration Runtime to use.')
param integrationRuntimeName string

@description('Optional. Use this to add parameters for a linked service connection string.')
param customizedParameter object = {}

@description('Optional. The description of the Integration Runtime.')
param linkedServiceDescription string

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' existing = {
  name: dataFactoryName
}

resource linkedService 'Microsoft.DataFactory/factories/linkedservices@2018-06-01' = {
  name: name
  parent: dataFactory

  properties: {
    annotations: []
    description: linkedServiceDescription
    connectVia: contains(integrationRuntimeName, 'none')
      ? null
      : {
          parameters: {}
          referenceName: integrationRuntimeName
          type: 'IntegrationRuntimeReference'
        }
    type: typeName
    typeProperties: typeProperties
    parameters: customizedParameter
  }
}

@description('The name of the Resource Group the Integration Runtime was created in.')
output resourceGroupName string = resourceGroup().name

@description('The name of the Integration Runtime.')
output name string = linkedService.name

@description('The resource ID of the Integration Runtime.')
output resourceId string = linkedService.id
