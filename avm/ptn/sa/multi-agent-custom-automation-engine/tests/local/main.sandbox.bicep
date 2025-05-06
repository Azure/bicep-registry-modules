module testDeployment '../../main.bicep' = {
  name: 'test-macae-sandbox'
  params: {
    solutionPrefix: 'macaesbx003'
    solutionLocation: 'australiaeast'
    virtualNetworkConfiguration: {
      enabled: false
    }
  }
}
