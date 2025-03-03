targetScope = 'resourceGroup'

module testDeployment '../main.bicep' = {
  name: 'avm-test-ckm'
  params: {
    environmentName: 'avm-ckm'
    contentUnderstandingLocation: 'West US'
    webApServerFarmSku: 'B2'
  }
}
