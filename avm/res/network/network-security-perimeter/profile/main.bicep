metadata name = 'Network Security Perimeter Profile'
metadata description = 'This module deploys a Network Security Perimeter Profile.'

@description('Conditional. The name of the parent network perimeter. Required if the template is used in a standalone deployment.')
param networkPerimeterName string

@maxLength(64)
@description('Required. The name of the network security perimeter profile.')
param name string

@description('Optional. Static Members to create for the network group. Contains virtual networks to add to the network group.')
param accessRules accessRuleType[]?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var enableReferencedModulesTelemetry = false

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.network-nwsecperim-profile.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource networkSecurityPerimeter 'Microsoft.Network/networkSecurityPerimeters@2024-07-01' existing = {
  name: networkPerimeterName
}

resource networkSecurityPerimeter_profile 'Microsoft.Network/networkSecurityPerimeters/profiles@2024-07-01' = {
  name: name
  parent: networkSecurityPerimeter
}

module nsp_accessRules 'access-rule/main.bicep' = [
  for (accessRule, index) in (accessRules ?? []): {
    name: '${uniqueString(deployment().name)}-nsp-accessrule-${index}'
    params: {
      enableTelemetry: enableReferencedModulesTelemetry
      networkPerimeterName: networkPerimeterName
      networkPerimeterProfileName: name
      name: accessRule.name
      addressPrefixes: accessRule.?addressPrefixes
      direction: accessRule.direction
      emailAddresses: accessRule.?emailAddresses
      fullyQualifiedDomainNames: accessRule.?fullyQualifiedDomainNames
      phoneNumbers: accessRule.?phoneNumbers
      serviceTags: accessRule.?serviceTags
      subscriptions: accessRule.?subscriptions
    }
  }
]

@description('The resource group the network security perimeter was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the deployed profile.')
output resourceId string = networkSecurityPerimeter_profile.id

@description('The name of the deployed profile.')
output name string = networkSecurityPerimeter_profile.name

@export()
@description('The type for an access rule.')
type accessRuleType = {
  @description('Required. The name of the access rule.')
  name: string

  @description('Required. The type for an access rule.')
  direction: 'Inbound' | 'Outbound'

  @description('Optional. Inbound address prefixes (IPv4/IPv6).s.')
  addressPrefixes: string[]?

  @description('Optional. Outbound rules email address format.')
  emailAddresses: string[]?

  @description('Optional. Outbound rules fully qualified domain name format.')
  fullyQualifiedDomainNames: string[]?

  @description('Optional. Outbound rules phone number format.')
  phoneNumbers: string[]?

  @description('Optional. Inbound rules service tag names.')
  serviceTags: string[]?

  @description('Optional. List of subscription ids.')
  subscriptions: {
    @description('Required. The subscription id.')
    id: string
  }[]?

  @description('Optional. Enable/Disable usage telemetry for module.')
  enableTelemetry: bool?
}
