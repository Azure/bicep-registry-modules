metadata name = 'API Management Service Portal Settings'
metadata description = 'This module deploys an API Management Service Portal Setting.'

@description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@description('Required. Portal setting name.')
@allowed([
  'delegation'
  'signin'
  'signup'
])
param name string

@description('Required. Portal setting properties.')
param properties portalSettingPropertiesType

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

resource service 'Microsoft.ApiManagement/service@2024-05-01' existing = {
  name: apiManagementServiceName
}

var telemetryIdPrefix = loadJsonContent('metadata.json', 'telemetryIdPrefix')

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '${telemetryIdPrefix}.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource portalSetting 'Microsoft.ApiManagement/service/portalsettings@2024-05-01' = {
  name: any(name)
  parent: service
  properties: properties
}

@description('The resource ID of the API Management service portal setting.')
output resourceId string = portalSetting.id

@description('The name of the API Management service portal setting.')
output name string = portalSetting.name

@description('The resource group the API Management service portal setting was deployed into.')
output resourceGroupName string = resourceGroup().name

@export()
@description('The properties for sign-in, sign-up, or delegation portal settings.')
type portalSettingPropertiesType = {
  @description('Optional. Redirect anonymous users to the sign-in page, or allow users to sign up on the developer portal.')
  enabled: bool?

  @description('Optional. Terms of service contract properties for sign-up settings.')
  termsOfService: {
    @description('Optional. Ask the user for consent to the terms of service.')
    consentRequired: bool?

    @description('Optional. Display terms of service during sign-up.')
    enabled: bool?

    @description('Optional. Terms of service text.')
    text: string?
  }?

  @description('Optional. Subscription delegation settings.')
  subscriptions: {
    @description('Optional. Enable or disable delegation for subscriptions.')
    enabled: bool?
  }?

  @description('Optional. The delegation URL.')
  url: string?

  @description('Optional. User registration delegation settings.')
  userRegistration: {
    @description('Optional. Enable or disable delegation for user registration.')
    enabled: bool?
  }?

  @secure()
  @description('Optional. A base64-encoded validation key to validate that a request comes from Azure API Management.')
  validationKey: string?
}
