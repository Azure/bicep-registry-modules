metadata name = 'Network Security Perimeter Profile'
metadata description = 'This module deploys a Network Security Perimeter Profile.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent network perimeter. Required if the template is used in a standalone deployment.')
param networkPerimeterName string

@maxLength(64)
@description('Required. The name of the network security perimeter profile.')
param name string

@description('Optional. Static Members to create for the network group. Contains virtual networks to add to the network group.')
param accessRules accessRulesType

resource networkSecurityPerimeter 'Microsoft.Network/networkSecurityPerimeters@2023-08-01-preview' existing = {
  name: networkPerimeterName
}

resource networkSecurityPerimeter_profile 'Microsoft.Network/networkSecurityPerimeters/profiles@2023-08-01-preview' = {
  name: name
  parent: networkSecurityPerimeter
}

resource nsp_accessRules 'Microsoft.Network/networkSecurityPerimeters/profiles/accessRules@2023-08-01-preview' = [
  for (accessRule, index) in (accessRules ?? []): {
    name: accessRule.name
    parent: networkSecurityPerimeter_profile
    properties: {
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

type subscriptionIdType = {
  @description('Required. The subscription id.')
  id: string
}[]?

@export()
type accessRulesType = {
  @description('Required. The name of the access rule.')
  name: string

  @description('Required. Direction that specifies whether the access rules is inbound/outbound.')
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
  subscriptions: subscriptionIdType
}[]?
