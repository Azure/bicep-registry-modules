@description('Specifies the location for resources.')
param location string = 'westus'

module testMain '../main.bicep' = {
  name: 'testMain'
  params: {
    location: location
  }
}
