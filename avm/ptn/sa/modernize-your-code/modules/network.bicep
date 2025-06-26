@description('Required. Named used for all resource naming.')
param resourcesName string

@description('Required. Resource ID of the Log Analytics Workspace for monitoring and diagnostics.')
param logAnalyticsWorkSpaceResourceId string

@minLength(3)
@description('Required. Azure region for all services.')
param location string

@description('Optional. Tags to be applied to the resources.')
param tags resourceInput<'Microsoft.Resources/resourceGroups@2025-04-01'>.tags = {}

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Required. Admin username for the VM.')
@secure()
param vmAdminUsername string

@description('Required. Admin password for the VM.')
@secure()
param vmAdminPassword string

var denyHopOutboundRule = {
  name: 'deny-hop-outbound'
  properties: {
    priority: 200
    access: 'Deny'
    protocol: 'Tcp'
    direction: 'Outbound'
    sourceAddressPrefix: 'VirtualNetwork'
    destinationAddressPrefix: '*'
    destinationPortRanges: [
      '3389'
      '22'
    ]
  }
}

// Subnet Classless Inter-Doman Routing (CIDR)  Sizing Reference Table (Best Practices)
// | CIDR      | # of Addresses | # of /24s | Notes                                 |
// |-----------|---------------|-----------|----------------------------------------|
// | /24       | 256           | 1         | Smallest recommended for Azure subnets |
// | /23       | 512           | 2         | Good for 1-2 workloads per subnet      |
// | /22       | 1024          | 4         | Good for 2-4 workloads per subnet      |
// | /21       | 2048          | 8         |                                        |
// | /20       | 4096          | 16        | Used for default VNet in this solution |
// | /19       | 8192          | 32        |                                        |
// | /18       | 16384         | 64        |                                        |
// | /17       | 32768         | 128       |                                        |
// | /16       | 65536         | 256       |                                        |
// | /15       | 131072        | 512       |                                        |
// | /14       | 262144        | 1024      |                                        |
// | /13       | 524288        | 2048      |                                        |
// | /12       | 1048576       | 4096      |                                        |
// | /11       | 2097152       | 8192      |                                        |
// | /10       | 4194304       | 16384     |                                        |
// | /9        | 8388608       | 32768     |                                        |
// | /8        | 16777216      | 65536     |                                        |
//
// Best Practice Notes:
// - Use /24 as the minimum subnet size for Azure (smaller subnets are not supported for most services).
// - Plan for future growth: allocate larger address spaces (e.g., /20 or /21 for VNets) to allow for new subnets.
// - Avoid overlapping address spaces with on-premises or other VNets.
// - Use contiguous, non-overlapping ranges for subnets.
// - Document subnet usage and purpose in code comments.
// - For AVM modules, ensure only one delegation per subnet and leave delegations empty if not required.

module network 'network/main.bicep' = {
  name: take('network-${resourcesName}-create', 64)
  params: {
    resourcesName: resourcesName
    location: location
    logAnalyticsWorkSpaceResourceId: logAnalyticsWorkSpaceResourceId
    tags: tags
    addressPrefixes: ['10.0.0.0/20'] // 4096 addresses (enough for 8 /23 subnets or 16 /24)
    subnets: [
      // Only one delegation per subnet is supported by the AVM module as of June 2025.
      // For subnets that do not require delegation, leave the value empty.
      {
        name: 'web'
        addressPrefixes: ['10.0.0.0/23'] // /23 (10.0.0.0 - 10.0.1.255), 512 addresses
        networkSecurityGroup: {
          name: 'web-nsg'
          securityRules: [
            {
              name: 'AllowHttpsInbound'
              properties: {
                access: 'Allow'
                direction: 'Inbound'
                priority: 100
                protocol: 'Tcp'
                sourcePortRange: '*'
                destinationPortRange: '443'
                sourceAddressPrefixes: ['0.0.0.0/0']
                destinationAddressPrefixes: ['10.0.0.0/23']
              }
            }
            denyHopOutboundRule
          ]
        }
        delegation: 'Microsoft.App/environments'
      }
      {
        name: 'peps'
        addressPrefixes: ['10.0.2.0/23'] // /23 (10.0.2.0 - 10.0.3.255), 512 addresses
        privateEndpointNetworkPolicies: 'Disabled'
        privateLinkServiceNetworkPolicies: 'Disabled'
      }
    ]
    bastionConfiguration: {
      name: 'bastion-${resourcesName}'
      subnetAddressPrefixes: ['10.0.10.0/23']
    }
    jumpboxConfiguration: {
      name: 'vm-jumpbox-${resourcesName}'
      size: 'Standard_D2s_v3'
      username: vmAdminUsername
      password: vmAdminPassword
      subnet: {
        name: 'jumpbox'
        addressPrefixes: ['10.0.12.0/23'] // /23 (10.0.12.0 - 10.0.13.255), 512 addresses
        networkSecurityGroup: {
          name: 'jumpbox-nsg'
          securityRules: [
            {
              name: 'AllowJumpboxInbound'
              properties: {
                access: 'Allow'
                direction: 'Inbound'
                priority: 100
                protocol: 'Tcp'
                sourcePortRange: '*'
                destinationPortRange: '22'
                sourceAddressPrefixes: [
                  '10.0.7.0/24' // Azure Bastion subnet as an example here. You can adjust this as needed by adding more
                ]
                destinationAddressPrefixes: ['10.0.12.0/23']
              }
            }
            denyHopOutboundRule
          ]
        }
      }
    }
    enableTelemetry: enableTelemetry
  }
}

@description('Name of the Virtual Network resource.')
output vnetName string = network.outputs.name

@description('Resource ID of the Virtual Network.')
output vnetResourceId string = network.outputs.resourceId

@description('Resource ID of the "web" subnet.')
output subnetWebResourceId string = first(filter(network.outputs.subnets, s => s.name == 'web')).?resourceId ?? ''

@description('Resource ID of the "peps" subnet for Private Endpoints.')
output subnetPrivateEndpointsResourceId string = first(filter(network.outputs.subnets, s => s.name == 'peps')).?resourceId ?? ''
