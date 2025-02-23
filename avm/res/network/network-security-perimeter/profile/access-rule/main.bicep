metadata name = 'Network Security Perimeter Access Rule'
metadata description = 'This module deploys a Network Security Perimeter Access Rule.'

@description('Conditional. The name of the parent network perimeter. Required if the template is used in a standalone deployment.')
param networkPerimeterName string

@description('Conditional. The name of the parent network perimeter Profile. Required if the template is used in a standalone deployment.')
param networkPerimeterProfileName string

@description('Required. The name of the access rule.')
param name string

@description('Optional. Inbound address prefixes (IPv4/IPv6).s.')
param addressPrefixes string[]?

@description('Required. The type for an access rule.')
param direction 'Inbound' | 'Outbound'

@description('Optional. Outbound rules email address format.')
param emailAddresses string[]?

@description('Optional. Outbound rules fully qualified domain name format.')
param fullyQualifiedDomainNames string[]?

@description('Optional. Outbound rules phone number format.')
param phoneNumbers string[]?

@description('Optional. Inbound rules service tag names.')
param serviceTags string[]?

@description('Optional. List of subscription ids.')
param subscriptions {
  @description('Required. The subscription id.')
  id: string
}[]?

resource networkPerimeter 'Microsoft.Network/networkSecurityPerimeters@2023-08-01-preview' existing = {
  name: networkPerimeterName

  resource networkSecurityPerimeterProfile 'profiles@2023-08-01-preview' existing = {
    name: networkPerimeterProfileName
  }
}

resource nsp_accessRule 'Microsoft.Network/networkSecurityPerimeters/profiles/accessRules@2023-08-01-preview' = {
  name: name
  parent: networkPerimeter::networkSecurityPerimeterProfile
  properties: {
    addressPrefixes: addressPrefixes
    direction: direction
    emailAddresses: emailAddresses
    fullyQualifiedDomainNames: fullyQualifiedDomainNames
    phoneNumbers: phoneNumbers
    serviceTags: serviceTags
    subscriptions: subscriptions
  }
}

@description('The resource group the network security perimeter was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the deployed profile.')
output resourceId string = nsp_accessRule.id

@description('The name of the deployed profile.')
output name string = nsp_accessRule.name
