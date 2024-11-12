@description('Location for all resources.')
param location string = resourceGroup().location

@description('Name for DNS Private Zone')
param dnsZoneName string

@description('Fully Qualified DNS Private Zone')
param dnsZoneFqdn string = '${dnsZoneName}.private.mysql.database.azure.com'

@description('Virtual Network Name')
param virtualNetworkName string = 'azure_mysql_vnet'

@description('Subnet Name')
param subnetName string = 'azure_mysql_subnet'

@description('Virtual Network Address Prefix')
param vnetAddressPrefix string = '10.0.0.0/24'

@description('Subnet Address Prefix')
param mySqlSubnetPrefix string = '10.0.0.0/28'

@description('Composing the subnetId')
var mysqlSubnetId = '${vnetLink.properties.virtualNetwork.id}/subnets/${subnetName}'

resource vnet 'Microsoft.Network/virtualNetworks@2024-01-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
  }

  resource subnet 'subnets@2024-01-01' = {
    name: subnetName
    properties: {
      addressPrefix: mySqlSubnetPrefix
      delegations: [
        {
          name: 'dlg-Microsoft.DBforMySQL-flexibleServers'
          properties: {
            serviceName: 'Microsoft.DBforMySQL/flexibleServers'
          }
        }
      ]
      privateEndpointNetworkPolicies: 'Enabled'
      privateLinkServiceNetworkPolicies: 'Enabled'
    }
  }
}

resource dnszone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: dnsZoneFqdn
  location: 'global'
  properties: {}
}

resource vnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: vnet.name
  parent: dnszone
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnet.id
    }
  }
}

output mysqlSubnetId string = mysqlSubnetId
output dnszoneid string = dnszone.id
