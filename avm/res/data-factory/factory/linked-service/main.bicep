metadata name = 'Data Factory Linked Service'
metadata description = 'This module deploys a Data Factory Linked Service.'
metadata owner = 'Azure/module-maintainers'

@sys.description('Conditional. The name of the parent Azure Data Factory. Required if the template is used in a standalone deployment.')
param dataFactoryName string

@sys.description('Required. The name of the Linked Service.')
param name string

@sys.description('Required. The type of Linked Service. See https://learn.microsoft.com/en-us/azure/templates/microsoft.datafactory/factories/linkedservices?pivots=deployment-language-bicep#linkedservice-objects for more information.')
param type string

@sys.description('Optional. Used to add connection properties for your linked services.')
param typeProperties object = {}

@sys.description('Optional. The name of the Integration Runtime to use.')
param integrationRuntimeName string = 'none'

@sys.description('Optional. Use this to add parameters for a linked service connection string.')
param parameters object = {}

@sys.description('Optional. The description of the Integration Runtime.')
param description string = 'Linked Service created by avm-res-datafactory-factories'

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' existing = {
  name: dataFactoryName
}

resource linkedService 'Microsoft.DataFactory/factories/linkedservices@2018-06-01' = {
  name: name
  parent: dataFactory

  properties: {
    annotations: []
    description: description
    connectVia: contains(integrationRuntimeName, 'none')
      ? null
      : {
          parameters: {}
          referenceName: integrationRuntimeName
          type: 'IntegrationRuntimeReference'
        }
    type: type
    typeProperties: typeProperties
    parameters: parameters
  }
}

@sys.description('The name of the Resource Group the Linked Service was created in.')
output resourceGroupName string = resourceGroup().name

@sys.description('The name of the Linked Service.')
output name string = linkedService.name

@sys.description('The resource ID of the Linked Service.')
output resourceId string = linkedService.id
