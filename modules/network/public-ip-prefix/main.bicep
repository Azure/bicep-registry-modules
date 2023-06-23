@description('Required. Name of the public IP Prefix.')
param name string

@description('Required. Define the Azure Location that the Public IP Prefix should be created within.')
param location string

@description('Optional. Tags for Public IP Prefix.')
param tags object = {}

@allowed([ 'Global', 'Regional' ])
@description('Optional. tier for the Public IP Prefix, Default set to Regional')
param tier string = 'Regional'

@description('Optional. IP address version.')
@allowed([ 'IPv4', 'IPv6' ])
param publicIPAddressVersion string = 'IPv4'

@allowed([ 28, 29, 30, 31 ])
@description('Required. The Length of the Public IP Prefix.')
param prefixLength int

@description('Optional. A list of availability zones denoting the IP allocated for the resource needs to come from. Default set to []')
param availabilityZones array = []

resource publicIPPrefix 'Microsoft.Network/publicIPPrefixes@2022-09-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: 'Standard'
    tier: tier
  }
  properties: {
    publicIPAddressVersion: publicIPAddressVersion
    prefixLength: prefixLength
  }
  zones: availabilityZones
}

@description('Id of the Public IP Prefix.')
output id string = publicIPPrefix.id

@description('Name of the Public IP Prefix.')
output name string = publicIPPrefix.name

@description('The allocated IP Prefix.')
output ipPrefix string = publicIPPrefix.properties.ipPrefix
