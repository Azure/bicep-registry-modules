metadata name = 'Healthcare API Workspace IoT Connector FHIR Destinations'
metadata description = 'This module deploys a Healthcare API Workspace IoT Connector FHIR Destination.'

@description('Required. The name of the FHIR destination.')
@maxLength(24)
param name string

@description('Optional. The mapping JSON that determines how normalized data is converted to FHIR Observations.')
param destinationMapping object = {
  templateType: 'CollectionFhir'
  template: []
}

@description('Conditional. The name of the MedTech service to add this destination to. Required if the template is used in a standalone deployment.')
param iotConnectorName string

@description('Conditional. The name of the parent health data services workspace. Required if the template is used in a standalone deployment.')
param workspaceName string

@description('Required. The resource identifier of the FHIR Service to connect to.')
param fhirServiceResourceId string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@allowed([
  'Create'
  'Lookup'
])
@description('Optional. Determines how resource identity is resolved on the destination.')
param resourceIdentityResolutionType string = 'Lookup'

// =========== //
// Deployments //
// =========== //
resource workspace 'Microsoft.HealthcareApis/workspaces@2022-06-01' existing = {
  name: workspaceName

  resource iotConnector 'iotconnectors@2022-06-01' existing = {
    name: iotConnectorName
  }
}

resource fhirDestination 'Microsoft.HealthcareApis/workspaces/iotconnectors/fhirdestinations@2022-06-01' = {
  name: name
  parent: workspace::iotConnector
  location: location
  properties: {
    resourceIdentityResolutionType: resourceIdentityResolutionType
    fhirServiceResourceId: fhirServiceResourceId
    fhirMapping: {
      content: destinationMapping
    }
  }
}

@description('The name of the FHIR destination.')
output name string = fhirDestination.name

@description('The resource ID of the FHIR destination.')
output resourceId string = fhirDestination.id

@description('The resource group where the namespace is deployed.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = fhirDestination.location

@description('The name of the medtech service.')
output iotConnectorName string = workspace::iotConnector.name
