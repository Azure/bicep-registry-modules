targetScope = 'resourceGroup'

module testDeployment '../../main.bicep' = {
  name: 'avm-test-ckm'
  params: {
    environmentName: 'ckmlcl04'
    contentUnderstandingLocation: 'West US'
    webApServerFarmSku: 'B2'
    armDeploymentSuffix: 'local-test'
  }
}
