metadata name = 'Hosting Environment Custom DNS Suffix Configuration'
metadata description = 'This module deploys a Hosting Environment Custom DNS Suffix Configuration.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent Hosting Environment. Required if the template is used in a standalone deployment.')
param hostingEnvironmentName string

@description('Required. Enable the default custom domain suffix to use for all sites deployed on the ASE.')
param dnsSuffix string

@description('Required. The URL referencing the Azure Key Vault certificate secret that should be used as the default SSL/TLS certificate for sites with the custom domain suffix.')
param certificateUrl string

@description('Required. The user-assigned identity to use for resolving the key vault certificate reference. If not specified, the system-assigned ASE identity will be used if available.')
param keyVaultReferenceIdentity string

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource appServiceEnvironment 'Microsoft.Web/hostingEnvironments@2022-03-01' existing = {
  name: hostingEnvironmentName
}

resource configuration 'Microsoft.Web/hostingEnvironments/configurations@2022-03-01' = {
  name: 'customdnssuffix'
  parent: appServiceEnvironment
  properties: {
    certificateUrl: certificateUrl
    keyVaultReferenceIdentity: keyVaultReferenceIdentity
    dnsSuffix: dnsSuffix
  }
}

@description('The name of the configuration.')
output name string = configuration.name

@description('The resource ID of the deployed configuration.')
output resourceId string = configuration.id

@description('The resource group of the deployed configuration.')
output resourceGroupName string = resourceGroup().name
