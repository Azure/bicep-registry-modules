metadata name = 'Hosting Environment Custom DNS Suffix Configuration'
metadata description = 'This module deploys a Hosting Environment Custom DNS Suffix Configuration.'

@description('Conditional. The name of the parent Hosting Environment. Required if the template is used in a standalone deployment.')
param hostingEnvironmentName string

@description('Required. Enable the default custom domain suffix to use for all sites deployed on the ASE.')
param dnsSuffix string

@description('Required. The URL referencing the Azure Key Vault certificate secret that should be used as the default SSL/TLS certificate for sites with the custom domain suffix.')
param certificateUrl string

@description('Required. The user-assigned identity to use for resolving the key vault certificate reference. If not specified, the system-assigned ASE identity will be used if available.')
param keyVaultReferenceIdentity string

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.web-hostingenvironment-configuration.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

resource appServiceEnvironment 'Microsoft.Web/hostingEnvironments@2025-03-01' existing = {
  name: hostingEnvironmentName
}

resource configuration 'Microsoft.Web/hostingEnvironments/configurations@2025-03-01' = {
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
