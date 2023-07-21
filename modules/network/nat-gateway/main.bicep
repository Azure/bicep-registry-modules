@description('Required. Prefix of NAT Gateway Resource Name. This param is ignored when name is provided.')
param prefix string = 'ng'

@description('Optional. The name of the NAT Gateway resource.')
param name string = '${prefix}${uniqueString(resourceGroup().id, subscription().id)}'

@description('Required. Location(region) for NAT Gateway will be deployed.')
param location string

@description('Optional. Tags for natGateways resource.')
param tags object = {}

@minValue(4)
@maxValue(120)
@description('Optional. The idle timeout of the NAT Gateway.')
param idleTimeoutInMinutes int = 4

@description('Optional. An array of public ip addresses associated with the nat gateway resource.')
param publicIpAddresses array = []
/*Example:
publicIpAddresses: [{
        id: '/subscriptions/XXX-XXX-XXX-XXX/resourceGroups/nat-test3/providers/Microsoft.Network/publicIPAddresses/nat-public-ip1-jgqel5bzokle6'
      }]
*/

@description('Optional. An array of public ip prefixes associated with the nat gateway resource.')
param publicIpPrefixes array = []
/*Example:
publicIPPrefixes: [{
        id: '/subscriptions/XXX-XXX-XXX-XXX/resourceGroups/nat-test3/providers/Microsoft.Network/publicIPPrefixes/nat-public-ip-prefix-jgqel5bzokle6'
      }]
*/

@description('Toggle to enable or disable zone redundance.')
param isZoneRedundant bool = false

@description('Optional. Specify Azure Availability Zone IDs when zone redundance is enabled.')
param zones array = [ '1', '2', '3' ]

resource natGateway 'Microsoft.Network/natGateways@2022-09-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: 'Standard'
  }
  properties: {
    idleTimeoutInMinutes: idleTimeoutInMinutes
    publicIpAddresses: publicIpAddresses
    publicIpPrefixes: publicIpPrefixes
  }
  zones: isZoneRedundant ? zones : []
}

@description('Id of the NAT Gateway resource created.')
output id string = natGateway.id

@description('Name of the NAT Gateway Resource.')
output name string = name
