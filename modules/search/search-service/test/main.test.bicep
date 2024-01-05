param location string = resourceGroup().location

//Test 0.
module test0 '../main.bicep' = {
  name: 'test0'

  params: {
    location: location
    sku: {
      name: 'standard'
    }
    authOptions: {
      aadOrApiKey: {
        aadAuthFailureMode: 'http401WithBearerChallenge'
      }
    }
    semanticSearch: 'free'
  }
}
