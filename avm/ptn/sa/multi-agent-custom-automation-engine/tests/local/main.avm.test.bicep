module testDeployment '../../main.bicep' = {
  name: 'test-macae.avm'
  params: {
    solutionPrefix: 'macae005'
    solutionLocation: 'australiaeast'
  }
}
