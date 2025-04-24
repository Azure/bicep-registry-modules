module testDeployment '../../main.bicep' = {
  name: 'test-macae'
  params: {
    solutionPrefix: 'macae005'
    solutionLocation: 'australiaeast'
  }
}
