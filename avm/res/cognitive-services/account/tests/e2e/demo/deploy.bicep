param resourceLocation string = resourceGroup().location

module dependencies 'dependencies.bicep' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-dependncies'
  params: {
    virtualNetworkName: 'vnet'
    location: resourceLocation
  }
}

module openai '../../../main.bicep' = {
    name: '${uniqueString(deployment().name, resourceLocation)}-test'
    params: {
      name: 'openai39457345'
      kind: 'Face'
      customSubDomainName: 'oai3249874'
      location: resourceLocation
      publicNetworkAccess: 'Disabled'
      sku: 'S0'
      privateEndpoints: [
        {
          privateDnsZoneResourceIds: [
            dependencies.outputs.privateDNSZoneResourceId
          ]
          subnetResourceId: dependencies.outputs.subnetResourceId
        }
      ]
    }
  }
