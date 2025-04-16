module testDeployment '../../main.bicep' = {
  name: 'test-macae'
  params: {
    solutionPrefix: 'macae004'
    solutionLocation: 'australiaeast'
  }
}
