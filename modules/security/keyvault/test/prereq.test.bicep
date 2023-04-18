param location string

module precreateKV '../main.bicep' = {
  name: 'existing-keyvault'
  params: {
    location: location
    prefix: 'existing'
  }
}

@minLength(3)
@maxLength(24)
output name string = precreateKV.outputs.name
