param location string

module precreateKV '../main.bicep' = {
  name: 'existing-keyvault'
  params: {
    location: location
    prefix: 'existing'
  }
}

output name string = precreateKV.outputs.name
