metadata name = 'Static Web App Site Custom Domains'
metadata description = 'This module deploys a Static Web App Site Custom Domain.'

@description('Required. The custom domain name.')
param name string

@description('Conditional. The name of the parent Static Web App. Required if the template is used in a standalone deployment.')
param staticSiteName string

@description('Optional. Validation method for adding a custom domain.')
param validationMethod string = 'cname-delegation'

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.web-staticsite-customdomain.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource staticSite 'Microsoft.Web/staticSites@2025-03-01' existing = {
  name: staticSiteName
}

resource customDomain 'Microsoft.Web/staticSites/customDomains@2025-03-01' = {
  name: name
  parent: staticSite
  properties: {
    validationMethod: validationMethod
  }
}

@description('The name of the static site custom domain.')
output name string = customDomain.name

@description('The resource ID of the static site custom domain.')
output resourceId string = customDomain.id

@description('The resource group the static site custom domain was deployed into.')
output resourceGroupName string = resourceGroup().name
