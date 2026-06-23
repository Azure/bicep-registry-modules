@sys.description('Required. The name of the IoT Security Solution.')
param name string

@sys.description('Optional. Location for the resource.')
param location string = resourceGroup().location

@sys.description('Optional. Tags for the resource.')
param tags object?

@sys.description('Required. Security Solution properties.')
param ioTSecuritySolutionProperties resourceInput<'Microsoft.Security/iotSecuritySolutions@2019-08-01'>.properties

resource iotSecuritySolutions 'Microsoft.Security/iotSecuritySolutions@2019-08-01' = {
  name: name
  location: location
  tags: tags
  properties: ioTSecuritySolutionProperties
}

@sys.description('The resource ID of the IoT Security Solution.')
output resourceId string = iotSecuritySolutions.id

@sys.description('The name of the IoT Security Solution.')
output name string = iotSecuritySolutions.name
