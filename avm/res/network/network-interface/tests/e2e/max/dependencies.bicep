@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Application Security Group to create.')
param applicationSecurityGroupName string

@description('Required. The name of the Load Balancer to create.')
param loadBalancerName string

@description('Required. The name of the Public IP IPv4 to create.')
param publicIPNameV4 string

@description('Required. The name of the Public IP IPv6 to create.')
param publicIPNameV6 string

var addressPrefixV4 = '10.0.0.0/16'
var addressPrefixV6 = 'fd00:3291:d43d::/48'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefixV4
        addressPrefixV6
      ]
    }
    subnets: [
      {
        name: 'defaultSubnet'
        properties: {
          addressPrefixes: [
            cidrSubnet(addressPrefixV4, 16, 0)
            cidrSubnet(addressPrefixV6, 64, 0)
          ]
        }
      }
    ]
  }
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: managedIdentityName
  location: location
}

resource applicationSecurityGroup 'Microsoft.Network/applicationSecurityGroups@2024-05-01' = {
  name: applicationSecurityGroupName
  location: location
}

resource loadBalancer 'Microsoft.Network/loadBalancers@2024-05-01' = {
  name: loadBalancerName
  location: location
  sku: {
    name: 'Standard'
  }

  properties: {
    frontendIPConfigurations: [
      {
        name: 'privateIPConfig1'
        properties: {
          subnet: {
            id: virtualNetwork.properties.subnets[0].id
          }
        }
      }
    ]
  }

  resource backendPool 'backendAddressPools@2024-05-01' = {
    name: 'default'
  }

  resource inboundNatRule1 'inboundNatRules@2024-05-01' = {
    name: 'inboundNatRule1'
    properties: {
      frontendPort: 443
      backendPort: 443
      enableFloatingIP: false
      enableTcpReset: false
      frontendIPConfiguration: {
        id: loadBalancer.properties.frontendIPConfigurations[0].id
      }
      idleTimeoutInMinutes: 4
      protocol: 'Tcp'
    }
    dependsOn: [
      backendPool
    ]
  }

  resource inboundNatRule2 'inboundNatRules@2024-05-01' = {
    name: 'inboundNatRule2'
    properties: {
      frontendPort: 3389
      backendPort: 3389
      frontendIPConfiguration: {
        id: loadBalancer.properties.frontendIPConfigurations[0].id
      }
      idleTimeoutInMinutes: 4
      protocol: 'Tcp'
    }
    dependsOn: [
      backendPool
      inboundNatRule1
    ]
  }
}

resource publicIPv4 'Microsoft.Network/publicIPAddresses@2024-05-01' = {
  name: publicIPNameV4
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
  zones: [
    '1'
    '2'
    '3'
  ]
}

resource publicIPv6 'Microsoft.Network/publicIPAddresses@2024-05-01' = {
  name: publicIPNameV6
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv6'
  }
  zones: [
    '1'
    '2'
    '3'
  ]
}

@description('The resource ID of the created Virtual Network Subnet.')
output subnetResourceId string = virtualNetwork.properties.subnets[0].id

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Application Security Group.')
output applicationSecurityGroupResourceId string = applicationSecurityGroup.id

@description('The resource ID of the created Load Balancer Backend Pool.')
output loadBalancerBackendPoolResourceId string = loadBalancer::backendPool.id

@description('The resource ID of the created Public IP IPv4.')
output publicIPv4ResourceId string = publicIPv4.id

@description('The resource ID of the created Public IP IPv6.')
output publicIPv6ResourceId string = publicIPv6.id
