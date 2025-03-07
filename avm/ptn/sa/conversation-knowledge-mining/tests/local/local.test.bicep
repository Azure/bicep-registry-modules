targetScope = 'resourceGroup'

module testDeployment '../../main.bicep' = {
  name: 'avm-test-ckm'
  params: {
    solutionPrefix: 'ckmlcl05'
    contentUnderstandingLocation: 'West US'
    webApServerFarmSku: 'B2'
    armDeploymentSuffix: 'local-test'
  }
}
