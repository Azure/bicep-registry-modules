module testDeployment '../../main.bicep' = {
  name: 'test-macae-sandbox'
  params: {
    solutionPrefix: 'macaesbx001'
    solutionLocation: 'australiaeast'
    virtualNetworkConfiguration: {
      enabled: false
    }
  }
}
