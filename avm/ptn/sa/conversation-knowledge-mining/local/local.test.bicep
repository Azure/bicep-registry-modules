targetScope = 'resourceGroup'

module testDeployment '../main.bicep' = {
  name: 'avm-test-ckm'
  params: {
    environmentName: 'ckmlcl01'
    contentUnderstandingLocation: 'West US'
    webApServerFarmSku: 'B2'
    armDeploymentSuffix: 'local-test'
  }
}
