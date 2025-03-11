targetScope = 'resourceGroup'

module testDeployment '../../main.bicep' = {
  name: 'avm-test-ckm'
  params: {
    solutionPrefix: 'ckmlcl08'
    aiFoundryAiServicesContentUnderstandingLocation: 'West US'
    keyVaultSoftDeleteEnabled: true
  }
}
