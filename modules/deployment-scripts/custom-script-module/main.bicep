metadata name = 'TODO: <module name>'
metadata description = 'TODO: <module description>'
metadata owner = 'TODO: <GitHub username of module owner>'

@description('Deployment Location. It defaults to the location of the resource group.')
param location string = resourceGroup().location

@description('Prefix of Storage Account Resource Name. This param is ignored when name is provided.')
param prefix string = 'st'

@description('Name of Storage Account. Must be unique within Azure.')
@maxLength(24)
@minLength(3)
param name string = '${prefix}${uniqueString(resourceGroup().id, location)}'

resource resource 'Microsoft.Resource/resource@latest-version' = {
  name: name
  location: location
  properties: {
    ...
  }
}

@description('Resource Name')
output name string = name

@description('Resource Id')
output id string = resource.id
