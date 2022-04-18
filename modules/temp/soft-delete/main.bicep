resource account 'Microsoft.CognitiveServices/accounts@2022-03-01' = {
  name: 'testaccount'
  #disable-next-line no-hardcoded-location
  location: 'westus2'
  sku: {
    name: 'S0'
  }
  kind: 'CognitiveServices'
  properties: {
  }
}
