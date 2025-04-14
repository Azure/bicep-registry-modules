module testDeployment '../../main.waf-aligned.bicep' = {
  name: 'test-macae'
  params: {
    solutionPrefix: 'macaewaf005'
    solutionLocation: 'australiaeast'
  }
}
