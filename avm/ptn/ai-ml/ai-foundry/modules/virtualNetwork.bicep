// Parameters
@description('Specifies the name of the virtual network.')
param virtualNetworkName string

@description('Specifies the address prefixes of the virtual network.')
param virtualNetworkAddressPrefixes string = '10.0.0.0/8'

@description('Specifies the name of the subnet which contains the virtual machine.')
param vmSubnetName string = 'VmSubnet'

@description('Specifies the address prefix of the subnet which contains the virtual machine.')
param vmSubnetAddressPrefix string = '10.3.1.0/24'

@description('Specifies the name of the network security group associated to the subnet hosting the virtual machine.')
param vmSubnetNsgName string = 'VmSubnetNsg'

@description('Specifies the name of the subnet which contains the Foundry agent.')
param foundryAgentSubnetName string = 'FoundryAgentSubnet'

@description('Specifies the address prefix of the subnet which contains the Foundry agent.')
param foundryAgentSubnetAddressPrefix string = '10.3.3.0/24'

@description('Specifies the name of the network security group associated to the subnet hosting the Foundry agent.')
param foundryAgentSubnetNsgName string = 'FoundryAgentSubnetNsg'

@description('Specifies the Bastion subnet IP prefix. This prefix must be within vnet IP prefix address space.')
param bastionSubnetAddressPrefix string = '10.3.2.0/24'

@description('Specifies the name of the network security group associated to the subnet hosting Azure Bastion.')
param bastionSubnetNsgName string = 'AzureBastionNsg'

@description('Specifies whether Azure Bastion should be created.')
param bastionHostEnabled bool = true

@description('Specifies the name of the Azure Bastion resource.')
param bastionHostName string

@description('Enable/Disable Copy/Paste feature of the Bastion Host resource.')
param bastionHostDisableCopyPaste bool = true

@description('Enable/Disable File Copy feature of the Bastion Host resource.')
param bastionHostEnableFileCopy bool = true

@description('Enable/Disable IP Connect feature of the Bastion Host resource.')
param bastionHostEnableIpConnect bool = true

@description('Enable/Disable Shareable Link of the Bastion Host resource.')
param bastionHostEnableShareableLink bool = true

@description('Enable/Disable Tunneling feature of the Bastion Host resource.')
param bastionHostEnableTunneling bool = true

@description('Specifies the name of the Azure Public IP Address used by the Azure Bastion Host.')
param bastionPublicIpAddressName string

@description('Specifies the name of the Azure Bastion Host SKU.')
param bastionHostSkuName string = 'Standard'

@description('Specifies the name of the Azure NAT Gateway.')
param natGatewayName string

@description('Specifies a list of availability zones denoting the zone in which Nat Gateway should be deployed.')
param natGatewayZones array = []

@description('Specifies the number of Public IPs to create for the Azure NAT Gateway.')
param natGatewayPublicIps int = 1

@description('Specifies the idle timeout in minutes for the Azure NAT Gateway.')
param natGatewayIdleTimeoutMins int = 30

@description('Optional IP address to allow access throught Bastion NSG. If not specified, all IP addresses are allowed.')
param allowedIpAddress string = ''

@description('Specifies the location.')
param location string = resourceGroup().location

@description('Specifies the resource tags.')
param tags object

// Variables
var bastionSubnetName = 'AzureBastionSubnet'

// Virtual Network
resource vnet 'Microsoft.Network/virtualNetworks@2024-03-01' = {
  name: virtualNetworkName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        virtualNetworkAddressPrefixes
      ]
    }
    subnets: [
      {
        name: vmSubnetName
        properties: {
          addressPrefix: vmSubnetAddressPrefix
          networkSecurityGroup: {
            id: vmSubnetNsg.id
          }
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Disabled'
          natGateway: {
            id: natGateway.id
          }
        }
      }
      {
        name: bastionSubnetName
        properties: {
          addressPrefix: bastionSubnetAddressPrefix
          networkSecurityGroup: {
            id: bastionSubnetNsg.id
          }
        }
      }
      {
        name: foundryAgentSubnetName
        properties: {
          addressPrefix: foundryAgentSubnetAddressPrefix
          networkSecurityGroup: {
            id: foundryAgentSubnetNsg.id
          }
        }
      }
    ]
  }
}

// Network Security Groups
resource bastionSubnetNsg 'Microsoft.Network/networkSecurityGroups@2024-03-01' = if (bastionHostEnabled) {
  name: bastionSubnetNsgName
  location: location
  tags: tags
  properties: {
    securityRules: [
      {
        name: 'AllowHttpsInBound'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: empty(allowedIpAddress) ? 'Internet' : allowedIpAddress
          destinationPortRange: '443'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowGatewayManagerInBound'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: 'GatewayManager'
          destinationPortRange: '443'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 110
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowLoadBalancerInBound'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: 'AzureLoadBalancer'
          destinationPortRange: '443'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 120
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowBastionHostCommunicationInBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationPortRanges: [
            '8080'
            '5701'
          ]
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 130
          direction: 'Inbound'
        }
      }
      {
        name: 'DenyAllInBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationPortRange: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 1000
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowSshRdpOutBound'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationPortRanges: [
            '22'
            '3389'
          ]
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 100
          direction: 'Outbound'
        }
      }
      {
        name: 'AllowAzureCloudCommunicationOutBound'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationPortRange: '443'
          destinationAddressPrefix: 'AzureCloud'
          access: 'Allow'
          priority: 110
          direction: 'Outbound'
        }
      }
      {
        name: 'AllowBastionHostCommunicationOutBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationPortRanges: [
            '8080'
            '5701'
          ]
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 120
          direction: 'Outbound'
        }
      }
      {
        name: 'AllowGetSessionInformationOutBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'Internet'
          destinationPortRanges: [
            '80'
            '443'
          ]
          access: 'Allow'
          priority: 130
          direction: 'Outbound'
        }
      }
      {
        name: 'DenyAllOutBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 1000
          direction: 'Outbound'
        }
      }
    ]
  }
}

resource vmSubnetNsg 'Microsoft.Network/networkSecurityGroups@2024-03-01' = {
  name: vmSubnetNsgName
  location: location
  tags: tags
  properties: {
    securityRules: [
      {
        name: 'AllowVNetInBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowAzureLoadBalancerInBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: 'AzureLoadBalancer'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 110
          direction: 'Inbound'
        }
      }
      {
        name: 'DenyAllInBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 4096
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowVNetOutBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 100
          direction: 'Outbound'
        }
      }
      {
        name: 'AllowInternetOutBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'Internet'
          access: 'Allow'
          priority: 110
          direction: 'Outbound'
        }
      }
      {
        name: 'DenyAllOutBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 4096
          direction: 'Outbound'
        }
      }
    ]
  }
}

resource foundryAgentSubnetNsg 'Microsoft.Network/networkSecurityGroups@2024-03-01' = {
  name: foundryAgentSubnetNsgName
  location: location
  tags: tags
  properties: {
    securityRules: [
      {
        name: 'AllowVNetInBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowAzureLoadBalancerInBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: 'AzureLoadBalancer'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 110
          direction: 'Inbound'
        }
      }
      {
        name: 'DenyAllInBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 4096
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowVNetOutBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 100
          direction: 'Outbound'
        }
      }
      {
        name: 'AllowInternetOutBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'Internet'
          access: 'Allow'
          priority: 110
          direction: 'Outbound'
        }
      }
      {
        name: 'DenyAllOutBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 4096
          direction: 'Outbound'
        }
      }
    ]
  }
}

// NAT Gateway
resource natGatewayPublicIp 'Microsoft.Network/publicIPAddresses@2024-03-01' = [
  for i in range(0, natGatewayPublicIps): {
    name: natGatewayPublicIps == 1 ? '${natGatewayName}PublicIp' : '${natGatewayName}PublicIp${i + 1}'
    location: location
    sku: {
      name: 'Standard'
    }
    zones: ['1', '2', '3'] // Use all supported zones for high availability
    properties: {
      publicIPAllocationMethod: 'Static'
    }
  }
]

resource natGateway 'Microsoft.Network/natGateways@2024-03-01' = {
  name: natGatewayName
  location: location
  sku: {
    name: 'Standard'
  }
  zones: !empty(natGatewayZones) ? natGatewayZones : []
  properties: {
    publicIpAddresses: [
      for i in range(0, natGatewayPublicIps): {
        id: natGatewayPublicIp[i].id
      }
    ]
    idleTimeoutInMinutes: natGatewayIdleTimeoutMins
  }
  dependsOn: [
    natGatewayPublicIp
  ]
}

// Azure Bastion Host
resource bastionPublicIpAddress 'Microsoft.Network/publicIPAddresses@2024-07-01' = if (bastionHostEnabled) {
  name: bastionPublicIpAddressName
  location: location
  tags: union(tags, {
    'resource-usage': 'azure-bastion'
  })
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource bastionHost 'Microsoft.Network/bastionHosts@2024-07-01' = if (bastionHostEnabled) {
  name: bastionHostName
  location: location
  tags: tags
  sku: {
    name: bastionHostSkuName
  }
  properties: {
    disableCopyPaste: bastionHostDisableCopyPaste
    enableFileCopy: bastionHostEnableFileCopy
    enableIpConnect: bastionHostEnableIpConnect
    enableShareableLink: bastionHostEnableShareableLink
    enableTunneling: bastionHostEnableTunneling
    ipConfigurations: [
      {
        name: 'IpConf'
        properties: {
          subnet: {
            id: '${vnet.id}/subnets/${bastionSubnetName}'
          }
          publicIPAddress: {
            id: bastionPublicIpAddress.id
          }
        }
      }
    ]
  }
}

// Diagnostic Settings
// Note: In production we would need to provide at least one proper destination (storage account, log analytics, or event hub)
// but this is sufficient for our current implementation since we're not actually configuring diagnostics destinations
// Each resource would need to be updated with actual destinations when deploying

resource vmSubnetNsgDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2016-09-01' = {
  name: 'service'
  location: location
  properties: {
    storageAccountId: null // Required as at least one destination needs to be specified for Microsoft.Insights/diagnosticSettings
    serviceBusRuleId: null
    metrics: []
    logs: []
  }
  scope: vmSubnetNsg
}

resource bastionSubnetNsgDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2016-09-01' = if (bastionHostEnabled) {
  name: 'service'
  location: location
  properties: {
    storageAccountId: null
    serviceBusRuleId: null
    metrics: []
    logs: []
  }
  scope: bastionSubnetNsg
}

resource vnetDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2016-09-01' = {
  name: 'service'
  location: location
  properties: {
    storageAccountId: null
    serviceBusRuleId: null
    metrics: []
    logs: []
  }
  scope: vnet
}

resource bastionDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2016-09-01' = if (bastionHostEnabled) {
  name: 'service'
  location: location
  properties: {
    storageAccountId: null
    serviceBusRuleId: null
    metrics: []
    logs: []
  }
  scope: bastionHost
}

resource foundryAgentSubnetNsgDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2016-09-01' = {
  name: 'service'
  location: location
  properties: {
    storageAccountId: null
    serviceBusRuleId: null
    metrics: []
    logs: []
  }
  scope: foundryAgentSubnetNsg
}

// Outputs
output virtualNetworkId string = vnet.id
output virtualNetworkName string = vnet.name
output vmSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets', vnet.name, vmSubnetName)
output bastionSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets', vnet.name, bastionSubnetName)
output foundryAgentSubnetId string = resourceId(
  'Microsoft.Network/virtualNetworks/subnets',
  vnet.name,
  foundryAgentSubnetName
)
output vmSubnetName string = vmSubnetName
output bastionSubnetName string = bastionSubnetName
output foundryAgentSubnetName string = foundryAgentSubnetName
output bastionName string = bastionHost.name
