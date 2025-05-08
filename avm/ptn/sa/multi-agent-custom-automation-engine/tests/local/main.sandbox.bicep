module testDeployment '../../main.bicep' = {
  name: 'test-macae-sandbox'
  params: {
    solutionPrefix: 'macaesbx004'
    solutionLocation: 'australiaeast'
    virtualNetworkConfiguration: {
      enabled: false
    }
  }
}
