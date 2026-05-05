metadata name = 'Container App Auth Configs'
metadata description = 'This module deploys Container App Auth Configs.'

@description('Conditional. The name of the parent Container App. Required if the template is used in a standalone deployment.')
param containerAppName string

@description('Optional. The configuration settings of the secrets references of encryption key and signing key for ContainerApp Service Authentication/Authorization.')
param encryptionSettings resourceInput<'Microsoft.App/containerApps/authConfigs@2026-01-01'>.properties.encryptionSettings?

@description('Optional. The configuration settings that determines the validation flow of users using Service Authentication and/or Authorization.')
param globalValidation resourceInput<'Microsoft.App/containerApps/authConfigs@2026-01-01'>.properties.globalValidation?

@description('Optional. The configuration settings of the HTTP requests for authentication and authorization requests made against ContainerApp Service Authentication/Authorization.')
param httpSettings resourceInput<'Microsoft.App/containerApps/authConfigs@2026-01-01'>.properties.httpSettings?

@description('Optional. The configuration settings of each of the identity providers used to configure ContainerApp Service Authentication/Authorization.')
param identityProviders resourceInput<'Microsoft.App/containerApps/authConfigs@2026-01-01'>.properties.identityProviders?

@description('Optional. The configuration settings of the login flow of users using ContainerApp Service Authentication/Authorization.')
param login resourceInput<'Microsoft.App/containerApps/authConfigs@2026-01-01'>.properties.login?

@description('Optional. The configuration settings of the platform of ContainerApp Service Authentication/Authorization.')
param platform resourceInput<'Microsoft.App/containerApps/authConfigs@2026-01-01'>.properties.platform?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

// =============== //
//    Resources    //
// =============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.app-containerapp-authconfig.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource containerApp 'Microsoft.App/containerApps@2026-01-01' existing = {
  name: containerAppName
}

resource containerAppAuthConfigs 'Microsoft.App/containerApps/authConfigs@2026-01-01' = {
  name: 'current'
  parent: containerApp
  properties: {
    encryptionSettings: encryptionSettings
    globalValidation: globalValidation
    httpSettings: httpSettings
    identityProviders: identityProviders
    login: login
    platform: platform
  }
}

// =============== //
//     Outputs     //
// =============== //

@description('The name of the set of Container App Auth configs.')
output name string = containerAppAuthConfigs.name

@description('The resource ID of the set of Container App Auth configs.')
output resourceId string = containerAppAuthConfigs.id

@description('The resource group containing the set of Container App Auth configs.')
output resourceGroupName string = resourceGroup().name
