module testDeployment '../../main.bicep' = {
  name: 'test-macae'
  params: {
    solutionPrefix: 'macae003'
    solutionLocation: 'australiaeast'
  }
}
