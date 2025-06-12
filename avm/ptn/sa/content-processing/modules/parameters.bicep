metadata name = 'parameters'
metadata description = 'This file defines the parameters used in the Bicep deployment scripts for the CPS solution.'

// ========== Get Parameters from bicepparam file ========== //
@minLength(3)
@maxLength(20)
@description('A unique prefix for all resources in this deployment. This should be 3-20 characters long:')
param environmentName string

@metadata({
  azd: {
    type: 'location'
  }
})
@description('Location for the content understanding service: WestUS | SwedenCentral | AustraliaEast')
param contentUnderstandingLocation string

@description('Deployment type for the GPT model: Standard | GlobalStandard')
param deploymentType string = 'GlobalStandard'

@description('Name of the GPT model to deploy: gpt-4o-mini | gpt-4o | gpt-4')
param gptModelName string = 'gpt-4o'

@minValue(10)
@description('Capacity of the GPT deployment:')
// You can increase this, but capacity is limited per model/region, so you will get errors if you go over
// https://learn.microsoft.com/en-us/azure/ai-services/openai/quotas-limits
param gptDeploymentCapacity int = 100

@minLength(1)
@description('Version of the GPT model to deploy:')
@allowed([
  '2024-08-06'
])
param gptModelVersion string = '2024-08-06'

@description('Location used for Azure Cosmos DB, Azure Container App deployment')
param secondaryLocation string = 'EastUs2'

@description('The public container image endpoint')
param publicContainerImageEndpoint string = 'cpscontainerreg.azurecr.io'

@description('The resource group location')
param resourceGroupLocation string = resourceGroup().location

@description('The resource name format string')
param resourceNameFormatString string = '{0}avm-cps'

@description('Enable WAF for the deployment')
param enableWaf bool = false

@description('Enable Private Netorking for the deployment')
param enablePrivateNetworking bool = false

@description('Enable telemetry for the deployment')
param enableTelemetry bool = true

@description('Resource naming abbreviations')
param namingAbbrs object

@description('Tags to be applied to the resources')
param tags object = {
  app: 'Content Processing Solution Accelerator'
  location: resourceGroup().location
}

// Outputs for downstream modules
output environmentName string = environmentName
output contentUnderstandingLocation string = contentUnderstandingLocation
output deploymentType string = deploymentType
output gptModelName string = gptModelName
output gptModelVersion string = gptModelVersion
output gptDeploymentCapacity int = gptDeploymentCapacity
output secondaryLocation string = secondaryLocation
output publicContainerImageEndpoint string = publicContainerImageEndpoint
output resourceGroupLocation string = resourceGroupLocation
output resourceNameFormatString string = resourceNameFormatString
output enableWaf bool = enableWaf
output enablePrivateNetworking bool = enablePrivateNetworking
output enableTelemetry bool = enableTelemetry
output namingAbbrs object = namingAbbrs
output tags object = tags
