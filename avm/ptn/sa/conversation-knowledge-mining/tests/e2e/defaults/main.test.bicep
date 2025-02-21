param environmentName string = 'avm-ckm'
param solutionLocation string = 'eastus'
param contentUnderstandingLocation string = 'West US'
param secondaryLocation string = 'eastus2'
param deploymentType string = 'GlobalStandard'
param gptModelName string = 'gpt-4o-mini'
param gptDeploymentCapacity string = 100
param embeddingModel string = 'text-embedding-ada-002'
param embeddingDeploymentCapacity string = 80
param webApServerFarmSku string = 'B1' // Delete this line to use the default value
param ckmWebAppServerFarmLocation string = 'East US 2' // Delete this line to use the default value
param armDeploymentSuffix string = 'avm-test'

module testDeployment '../../../main.bicep' = {
  name: '${uniqueString(deployment().name, namePrefix)}-test-${serviceShort}'
  params: {
    environmentName: environmentName
    solutionLocation: solutionLocation
    contentUnderstandingLocation: contentUnderstandingLocation
    secondaryLocation: secondaryLocation
    deploymentType: deploymentType
    gptModelName: gptModelName
    gptDeploymentCapacity: gptDeploymentCapacity
    embeddingModel: embeddingModel
    embeddingDeploymentCapacity: embeddingDeploymentCapacity
    webApServerFarmSku: webApServerFarmSku
    ckmWebAppServerFarmLocation: ckmWebAppServerFarmLocation
    armDeploymentSuffix: armDeploymentSuffix
  }
}
