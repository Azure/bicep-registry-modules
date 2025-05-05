module testDeployment '../../main.bicep' = {
  name: 'test-macae-sandbox'
  params: {
    solutionPrefix: 'macaesbx002'
    solutionLocation: 'australiaeast'
    virtualNetworkConfiguration: {
      enabled: false
    }
  }
}
