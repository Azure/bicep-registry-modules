using './main.bicep'

param environmentName = 'avm-ckm'
param solutionLocation = 'eastus'
param contentUnderstandingLocation = 'West US'
param secondaryLocation = 'eastus2'
param deploymentType = 'GlobalStandard'
param gptModelName = 'gpt-4o-mini'
param gptDeploymentCapacity = 100
param embeddingModel = 'text-embedding-ada-002'
param embeddingDeploymentCapacity = 80
param webApServerFarmSku = 'B1' // Delete this line to use the default value
param ckmWebAppServerFarmLocation = 'East US 2' // Delete this line to use the default value
param armDeploymentSuffix = 'avm-test'
