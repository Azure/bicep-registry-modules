metadata name = 'Private DNS Zone Virtual Network Link Child Module'
metadata description = 'This module deploys a Private DNS Zone Virtual Network Link.'

// Clone and adaptation of https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/network/private-dns-zone/virtual-network-link for deployment size purposes

@description('Conditional. The name of the parent Private DNS zone. Required if the template is used in a standalone deployment.')
param privateDnsZoneName string

@description('Optional. The location of the PrivateDNSZone. Should be global.')
param location string = 'global'

@description('Optional. Tags of the Private Link Private DNS Zones created.')
param tags object?

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2024-06-01' existing = {
  name: privateDnsZoneName
}

@description('Optional. Array of custom objects describing vNet links of the DNS zone. Each object should contain properties \'virtualNetworkResourceId\' and \'registrationEnabled\'. The \'vnetResourceId\' is a resource ID of a vNet to link, \'registrationEnabled\' (bool) enables automatic DNS registration in the zone for the linked vNet.')
param virtualNetworkLinks virtualNetworkLinkType[]?

resource virtualNetworkLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = [
  for link in (virtualNetworkLinks ?? []): {
    name: link.?name ?? '${last(split(link.virtualNetworkResourceId, '/'))}-vnetlink'
    parent: privateDnsZone
    location: location
    tags: link.?tags ?? tags
    properties: {
      registrationEnabled: link.?registrationEnabled ?? false
      resolutionPolicy: link.?resolutionPolicy ?? 'Default'
      virtualNetwork: {
        id: link.virtualNetworkResourceId
      }
    }
  }
]

@export()
@description('The type for the virtual network link.')
type virtualNetworkLinkType = {
  @description('Optional. The resource name.')
  @minLength(1)
  @maxLength(80)
  name: string?

  @description('Required. The resource ID of the virtual network to link.')
  virtualNetworkResourceId: string

  @description('Optional. Is auto-registration of virtual machine records in the virtual network in the Private DNS zone enabled?.')
  registrationEnabled: bool?

  @description('Optional. Resource tags.')
  tags: object?

  @description('Optional. The resolution type of the private-dns-zone fallback mechanism.')
  resolutionPolicy: ('Default' | 'NxDomainRedirect')?
}
