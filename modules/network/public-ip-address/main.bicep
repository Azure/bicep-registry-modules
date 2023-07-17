@minLength(1)
@maxLength(80)
@description('Required. Specifies the name of the publicIPAddress.')
param name string

@description('Required. Specifies the Azure location where the publicIPAddress should be created.')
param location string

@description('Optional. Tags to assign to the Azure Resource(s).')
param tags object = {}

@description('Optional. Name of a public IP address SKU.')
@allowed([
  'Basic'
  'Standard'
])
param skuName string = 'Standard'

@description('Optional. Tier of a public IP address SKU.')
@allowed([
  'Regional'
])
param skuTier string = 'Regional'

@description('Optional. A list of availability zones denoting the IP allocated for the resource needs to come from.')
param availabilityZones array = []
/*
Example:
  availabilityZones:
  [
    '1'
    '2'
    '3'
  ]
*/

@description('Optional. IP address version.')
@allowed([
  'IPv4'
  'IPv6'
])
param publicIPAddressVersion string = 'IPv4'

@description('Optional. IP address allocation method.')
@allowed([
  'Dynamic'
  'Static'
])
param publicIPAllocationMethod string = 'Static'

@description('Optional. Specify what happens to the public IP address when the VM using it is deleted.')
@allowed([
  'Delete'
  'Detach'
])
param deleteOption string = 'Detach'

@description('Optional. Reference to another subresource ID')
param publicIPPrefixId string = ''

@minLength(3)
@maxLength(63)
@description('Required. The domain name label. The concatenation of the domain name label and the regionalized DNS zone make up the fully qualified domain name associated with the public IP address. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system.')
param domainNameLabel string

@description('Optional. The idle timeout of the public IP address.')
param idleTimeoutInMinutes int = 4

resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2022-09-01' = {
  name: name
  location: location
  sku: {
    name: skuName
    tier: skuTier
  }
  zones: skuTier == 'Regional' ? availabilityZones : null
  tags: tags
  properties: {
    publicIPAddressVersion: publicIPAddressVersion
    publicIPAllocationMethod: publicIPAllocationMethod
    idleTimeoutInMinutes: idleTimeoutInMinutes
    deleteOption: deleteOption
    publicIPPrefix: length(publicIPPrefixId) > 0 ? {
      id: publicIPPrefixId
    } : null
    dnsSettings: {
      domainNameLabel: domainNameLabel
    }
  }
}

@description('Get id for publicIPAddress')
output id string = publicIPAddress.id

@description('Get name for publicIPAddress')
output name string = publicIPAddress.name

@description('Get ipAddress property from publicIPAddress resource')
output ipAddress string = publicIPAddress.properties.ipAddress

@description('Get resourceGroup name for publicIPAddress')
output resourceGroupName string = resourceGroup().name
