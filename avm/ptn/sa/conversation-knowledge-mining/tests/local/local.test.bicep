targetScope = 'resourceGroup'

module testDeployment '../../main.bicep' = {
  name: 'avm-test-ckm'
  params: {
    solutionPrefix: 'ckmlcl05'
    aiFoundryAiServiceContentUnderstandingLocation: 'West US'
  }
}
