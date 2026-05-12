metadata name = 'API Center Service Metadata Schemas'
metadata description = 'This module deploys an API Center Service Metadata Schema.'

@sys.description('Conditional. The name of the parent API Center service. Required if the template is used in a standalone deployment.')
param serviceName string

@sys.description('Required. The name of the metadata schema.')
@minLength(3)
@maxLength(90)
param name string

@sys.description('Required. The JSON schema defining the metadata type.')
param schema string

@sys.description('Optional. The entities the metadata schema is assigned to.')
param assignedTo metadataSchemaAssignedToType[]?

resource service 'Microsoft.ApiCenter/services@2024-03-01' existing = {
  name: serviceName
}

resource metadataSchema 'Microsoft.ApiCenter/services/metadataSchemas@2024-03-01' = {
  name: name
  parent: service
  properties: {
    schema: schema
    assignedTo: assignedTo
  }
}

@sys.description('The name of the metadata schema.')
output name string = metadataSchema.name

@sys.description('The resource ID of the metadata schema.')
output resourceId string = metadataSchema.id

@sys.description('The name of the resource group the metadata schema was created in.')
output resourceGroupName string = resourceGroup().name

@export()
type metadataSchemaAssignedToType = {
  @sys.description('Optional. The entity the metadata schema is assigned to.')
  entity: ('api' | 'deployment' | 'environment')?

  @sys.description('Optional. Whether the metadata is required for the entity.')
  required: bool?

  @sys.description('Optional. Whether the assignment is deprecated.')
  deprecated: bool?
}

@export()
type metadataSchemaType = {
  @sys.description('Required. The name of the metadata schema.')
  @minLength(3)
  @maxLength(90)
  name: string

  @sys.description('Required. The JSON schema defining the metadata type.')
  schema: string

  @sys.description('Optional. The entities the metadata schema is assigned to.')
  assignedTo: metadataSchemaAssignedToType[]?
}
