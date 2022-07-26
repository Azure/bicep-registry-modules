@description('Specifies the location for all resources.')
param location string 

param nameseed string

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2022-02-01-preview' = {
  name: 'cr${nameseed}'
  location: location
  sku: {
    name: 'Standard'
  }
}
