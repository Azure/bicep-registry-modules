targetScope = 'subscription'

// ------------------
//    PARAMETERS
// ------------------

// @description('The ID of the subscription to deploy the spoke resources to.')
// param subscriptionId string

@description('Required. The resource names definition')
param resourcesNames object

@description('The location where the resources will be created. This should be the same region as the hub.')
param location string = deployment().location

@description('Optional. The tags to be assigned to the created resources.')
param tags object = {}

@description('Required. Whether to enable deplotment telemetry.')
param enableTelemetry bool

// Hub
@description('The resource ID of the existing hub virtual network.')
param hubVNetId string

@description('The resource id of the bastion host.')
param bastionResourceId string

// Spoke
@description('CIDR of the spoke virtual network. For most landing zone implementations, the spoke network would have been created by your platform team.')
param spokeVNetAddressPrefixes array

@description('Optional. The name of the subnet to create for the spoke infrastructure. If set, it overrides the name generated by the template.')
param spokeInfraSubnetName string = 'snet-infra'

@description('CIDR of the spoke infrastructure subnet.')
param spokeInfraSubnetAddressPrefix string

@description('Optional. The name of the subnet to create for the spoke private endpoints. If set, it overrides the name generated by the template.')
param spokePrivateEndpointsSubnetName string = 'snet-pep'

@description('CIDR of the spoke private endpoints subnet.')
param spokePrivateEndpointsSubnetAddressPrefix string

@description('Optional. The name of the subnet to create for the spoke application gateway. If set, it overrides the name generated by the template.')
param spokeApplicationGatewaySubnetName string = 'snet-agw'

@description('CIDR of the spoke Application Gateway subnet. If the value is empty, this subnet will not be created.')
param spokeApplicationGatewaySubnetAddressPrefix string

@description('Optional. The name of the subnet to create for the deployment sctripts. If set, it overrides the name generated by the template.')
param deploymentSubnetName string = 'snet-deployment'

@description('Required. The CIDR to use for Deployment scripts subnet.')
param deploymentSubnetAddressPrefix string

@description('Optional. Define whether to route spoke-internal traffic within the spoke network. If false, traffic will be sent to the hub network. Default is false.')
param routeSpokeTrafficInternally bool

@description('The IP address of the network appliance (e.g. firewall) that will be used to route traffic to the internet.')
param networkApplianceIpAddress string

@description('The size of the jump box virtual machine to create. See https://learn.microsoft.com/azure/virtual-machines/sizes for more information.')
param vmSize string

@description('Optional. The zone to create the jump box in. Defaults to 0.')
param vmZone int = 0

@description('Optional. The storage account type to use for the jump box. Defaults to Standard_LRS.')
param storageAccountType string = 'Standard_LRS'

@description('The password to use for the jump box.')
@secure()
param vmAdminPassword string

@description('The SSH public key to use for the jump box. Only relevant for Linux.')
@secure()
param vmLinuxSshAuthorizedKey string = ''

@description('The OS of the jump box virtual machine to create. If set to "none", no jump box will be created.')
@allowed(['linux', 'windows', 'none'])
param vmJumpboxOSType string = 'none'

@description('Optional. The name of the subnet to create for the jump box. If set, it overrides the name generated by the template.')
param vmSubnetName string = 'snet-jumpbox'

@description('CIDR to use for the jump box subnet.')
param vmJumpBoxSubnetAddressPrefix string

@description('Type of authentication to use on the Virtual Machine. SSH key is recommended.')
@allowed([
  'sshPublicKey'
  'password'
])
param vmAuthenticationType string = 'password'

// ------------------
// VARIABLES
// ------------------

//Destination Service Tag for AzureCloud for Central France is centralfrance, but location is francecentral
var locationVar = location == 'francecentral' ? 'centralfrance' : location

// Subnet definition taking in consideration feature flags
var defaultSubnets = [
  {
    name: spokeInfraSubnetName
    addressPrefix: spokeInfraSubnetAddressPrefix
    networkSecurityGroupResourceId: nsgContainerAppsEnvironment.outputs.resourceId
    routeTableResourceId: (!empty(hubVNetId) && !empty(networkApplianceIpAddress))
      ? egressLockdownUdr.outputs.resourceId
      : null
    delegations: [
      {
        name: 'envdelegation'
        properties: {
          serviceName: 'Microsoft.App/environments'
        }
      }
    ]
  }
  {
    name: deploymentSubnetName
    addressPrefix: deploymentSubnetAddressPrefix
    delegations: [
      {
        name: 'containerDelegation'
        properties: {
          serviceName: 'Microsoft.ContainerInstance/containerGroups'
        }
      }
    ]
  }
  {
    name: spokePrivateEndpointsSubnetName
    addressPrefix: spokePrivateEndpointsSubnetAddressPrefix
    networkSecurityGroupResourceId: nsgPep.outputs.resourceId
  }
]

// Append optional application gateway subnet, if required
var appGwAndDefaultSubnets = !empty(spokeApplicationGatewaySubnetAddressPrefix)
  ? concat(defaultSubnets, [
      {
        name: spokeApplicationGatewaySubnetName
        addressPrefix: spokeApplicationGatewaySubnetAddressPrefix
        networkSecurityGroupResourceId: nsgAppGw.outputs.resourceId
      }
    ])
  : defaultSubnets

//Append optional jumpbox subnet, if required
var spokeSubnets = vmJumpboxOSType != 'none'
  ? concat(appGwAndDefaultSubnets, [
      {
        name: vmSubnetName
        addressPrefix: vmJumpBoxSubnetAddressPrefix
      }
    ])
  : appGwAndDefaultSubnets

// ------------------
// RESOURCES
// ------------------

module spokeResourceGroup 'br/public:avm/res/resources/resource-group:0.4.0' = {
  name: take('rg-${deployment().name}', 64)
  params: {
    name: resourcesNames.resourceGroup
    location: location
    enableTelemetry: enableTelemetry
    tags: tags
  }
}

@description('The spoke virtual network in which the workload will run from. This virtual network would normally already be provisioned by your subscription vending process, and only the subnets would need to be configured.')
module vnetSpoke 'br/public:avm/res/network/virtual-network:0.5.2' = {
  name: take('vnetSpoke-${deployment().name}', 64)
  scope: resourceGroup(resourcesNames.resourceGroup)
  params: {
    name: resourcesNames.vnetSpoke
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    addressPrefixes: spokeVNetAddressPrefixes
    subnets: spokeSubnets
    peerings: (!empty(hubVNetId))
      ? [
          {
            allowForwardedTraffic: true
            allowGatewayTransit: false
            allowVirtualNetworkAccess: true
            remotePeeringAllowForwardedTraffic: true
            remotePeeringAllowVirtualNetworkAccess: true
            remotePeeringEnabled: true
            remotePeeringName: 'spokeToHub'
            remoteVirtualNetworkResourceId: hubVNetId
            useRemoteGateways: false
          }
        ]
      : null
  }
}

@description('The log sink for Azure Diagnostics')
module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.9.1' = {
  name: take('logAnalyticsWs-${deployment().name}', 64)
  scope: resourceGroup(resourcesNames.resourceGroup)
  params: {
    name: resourcesNames.logAnalyticsWorkspace
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

@description('Network security group rules for the Container Apps cluster.')
module nsgContainerAppsEnvironment 'br/public:avm/res/network/network-security-group:0.5.0' = {
  name: take('nsgContainerAppsEnvironment-${deployment().name}', 64)
  scope: resourceGroup(resourcesNames.resourceGroup)
  params: {
    name: resourcesNames.containerAppsEnvironmentNsg
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    securityRules: [
      {
        name: 'Allow_Internal_AKS_Connection_Between_Nodes_And_Control_Plane_UDP'
        properties: {
          description: 'internal AKS secure connection between underlying nodes and control plane..'
          protocol: 'Udp'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: 'AzureCloud.${locationVar}'
          destinationPortRange: '1194'
          access: 'Allow'
          priority: 100
          direction: 'Outbound'
        }
      }
      {
        name: 'Allow_Internal_AKS_Connection_Between_Nodes_And_Control_Plane_TCP'
        properties: {
          description: 'internal AKS secure connection between underlying nodes and control plane..'
          protocol: 'Tcp'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: 'AzureCloud.${locationVar}'
          destinationPortRange: '9000'
          access: 'Allow'
          priority: 110
          direction: 'Outbound'
        }
      }
      {
        name: 'Allow_Azure_Monitor'
        properties: {
          description: 'Allows outbound calls to Azure Monitor.'
          protocol: 'Tcp'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: 'AzureCloud.${locationVar}'
          destinationPortRange: '443'
          access: 'Allow'
          priority: 120
          direction: 'Outbound'
        }
      }
      {
        name: 'Allow_Outbound_443'
        properties: {
          description: 'Allowing all outbound on port 443 provides a way to allow all FQDN based outbound dependencies that don\'t have a static IP'
          protocol: 'Tcp'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '443'
          access: 'Allow'
          priority: 130
          direction: 'Outbound'
        }
      }
      {
        name: 'Allow_NTP_Server'
        properties: {
          description: 'NTP server'
          protocol: 'Udp'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '123'
          access: 'Allow'
          priority: 140
          direction: 'Outbound'
        }
      }
      {
        name: 'Allow_Container_Apps_control_plane'
        properties: {
          description: 'Container Apps control plane'
          protocol: 'Tcp'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRanges: [
            '5671'
            '5672'
          ]
          access: 'Allow'
          priority: 150
          direction: 'Outbound'
        }
      }
      {
        name: 'deny-hop-outbound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRanges: [
            '3389'
            '22'
          ]
          access: 'Deny'
          priority: 200
          direction: 'Outbound'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: '*'
        }
      }
    ]
    diagnosticSettings: [
      {
        name: 'logAnalyticsSettings'
        workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
      }
    ]
  }
}

@description('NSG Rules for the Application Gateway.')
module nsgAppGw 'br/public:avm/res/network/network-security-group:0.5.0' = if (!empty(spokeApplicationGatewaySubnetAddressPrefix)) {
  name: take('nsgAppGw-${deployment().name}', 64)
  scope: resourceGroup(resourcesNames.resourceGroup)
  params: {
    name: resourcesNames.applicationGatewayNsg
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    securityRules: [
      {
        name: 'HealthProbes'
        properties: {
          description: 'allow HealthProbes from gateway Manager.'
          protocol: '*'
          sourceAddressPrefix: 'GatewayManager'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '65200-65535'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        name: 'Allow_TLS'
        properties: {
          description: 'allow https incoming connections'
          protocol: '*'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '443'
          access: 'Allow'
          priority: 110
          direction: 'Inbound'
        }
      }
      {
        name: 'Allow_HTTP'
        properties: {
          description: 'allow http incoming connections'
          protocol: '*'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '80'
          access: 'Allow'
          priority: 120
          direction: 'Inbound'
        }
      }
      {
        name: 'Allow_AzureLoadBalancer'
        properties: {
          description: 'allow AzureLoadBalancer incoming connections'
          protocol: '*'
          sourceAddressPrefix: 'AzureLoadBalancer'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '80'
          access: 'Allow'
          priority: 130
          direction: 'Inbound'
        }
      }
      {
        name: 'allow-all-outbound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          access: 'Allow'
          priority: 210
          direction: 'Outbound'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: '*'
        }
      }
    ]
    diagnosticSettings: [
      {
        name: 'logAnalyticsSettings'
        workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
      }
    ]
  }
}

@description('NSG Rules for the private enpoint subnet.')
module nsgPep 'br/public:avm/res/network/network-security-group:0.5.0' = {
  name: take('nsgPep-${deployment().name}', 64)
  scope: resourceGroup(resourcesNames.resourceGroup)
  params: {
    name: resourcesNames.pepNsg
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    securityRules: [
      {
        name: 'deny-hop-outbound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRanges: [
            '3389'
            '22'
          ]
          access: 'Deny'
          priority: 200
          direction: 'Outbound'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: '*'
        }
      }
    ]
    diagnosticSettings: [
      {
        name: 'logAnalyticsSettings'
        workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
      }
    ]
  }
}

@description('The Route Table deployment')
module egressLockdownUdr 'br/public:avm/res/network/route-table:0.4.0' = if (!empty(hubVNetId) && !empty(networkApplianceIpAddress)) {
  name: take('egressLockdownUdr-${deployment().name}', 64)
  scope: resourceGroup(resourcesNames.resourceGroup)
  params: {
    name: resourcesNames.routeTable
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    routes: concat(
      [
        {
          name: 'defaultEgressLockdown'
          properties: {
            addressPrefix: '0.0.0.0/0'
            nextHopType: 'VirtualAppliance'
            nextHopIpAddress: networkApplianceIpAddress
          }
        }
      ],
      routeSpokeTrafficInternally
        ? map(spokeVNetAddressPrefixes, (prefix, i) => {
            name: 'spokeInternalTraffic-${i}'
            properties: {
              addressPrefix: prefix
              nextHopType: 'VnetLocal'
            }
          })
        : []
    )
  }
}

@description('An optional Linux virtual machine deployment to act as a jump box.')
module jumpboxLinuxVM '../compute/linux-vm.bicep' = if (vmJumpboxOSType == 'linux') {
  name: take('vm-linux-${deployment().name}', 64)
  scope: resourceGroup(resourcesNames.resourceGroup)
  params: {
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    vmName: resourcesNames.vmJumpBox
    bastionResourceId: bastionResourceId
    vmAdminPassword: vmAdminPassword
    vmSshPublicKey: vmLinuxSshAuthorizedKey
    vmSize: vmSize
    vmZone: vmZone
    storageAccountType: storageAccountType
    vmVnetName: vnetSpoke.outputs.name
    vmSubnetName: vmSubnetName
    vmSubnetAddressPrefix: vmJumpBoxSubnetAddressPrefix
    vmNetworkInterfaceName: resourcesNames.vmJumpBoxNic
    vmNetworkSecurityGroupName: resourcesNames.vmJumpBoxNsg
    vmAuthenticationType: vmAuthenticationType
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
  }
}

@description('An optional Windows virtual machine deployment to act as a jump box.')
module jumpboxWindowsVM '../compute/windows-vm.bicep' = if (vmJumpboxOSType == 'windows') {
  name: take('vm-windows-${deployment().name}', 64)
  scope: resourceGroup(resourcesNames.resourceGroup)
  params: {
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    vmName: resourcesNames.vmJumpBox
    bastionResourceId: bastionResourceId
    vmAdminPassword: vmAdminPassword
    vmSize: vmSize
    vmZone: vmZone
    storageAccountType: storageAccountType
    vmVnetName: vnetSpoke.outputs.name
    vmSubnetName: vmSubnetName
    vmSubnetAddressPrefix: vmJumpBoxSubnetAddressPrefix
    vmNetworkInterfaceName: resourcesNames.vmJumpBoxNic
    vmNetworkSecurityGroupName: resourcesNames.vmJumpBoxNsg
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
  }
}

// ------------------
// OUTPUTS
// ------------------

resource vnetSpokeCreated 'Microsoft.Network/virtualNetworks@2024-05-01' existing = {
  name: vnetSpoke.outputs.name
  scope: resourceGroup(resourcesNames.resourceGroup)

  resource spokeInfraSubnet 'subnets' existing = {
    name: spokeInfraSubnetName
  }

  resource spokePrivateEndpointsSubnet 'subnets' existing = {
    name: spokePrivateEndpointsSubnetName
  }

  resource spokeApplicationGatewaySubnet 'subnets' existing = if (!empty(spokeApplicationGatewaySubnetAddressPrefix)) {
    name: spokeApplicationGatewaySubnetName
  }

  resource deploymentSubnet 'subnets' existing = {
    name: deploymentSubnetName
  }
}

@description('The name of the spoke resource group.')
output spokeResourceGroupName string = spokeResourceGroup.name

@description('The resource ID of the spoke virtual network.')
output spokeVNetId string = vnetSpokeCreated.id

@description('The name of the spoke virtual network.')
output spokeVNetName string = vnetSpokeCreated.name

@description('The resource ID of the spoke infrastructure subnet.')
output spokeInfraSubnetId string = vnetSpokeCreated::spokeInfraSubnet.id

@description('The name of the spoke infrastructure subnet.')
output spokeInfraSubnetName string = vnetSpokeCreated::spokeInfraSubnet.name

@description('The name of the spoke private endpoints subnet.')
output spokePrivateEndpointsSubnetName string = vnetSpokeCreated::spokePrivateEndpointsSubnet.name

@description('The resource ID of the spoke private endpoints subnet.')
output spokePrivateEndpointsSubnetResourceId string = vnetSpokeCreated::spokePrivateEndpointsSubnet.id

@description('The name of the spoke deployment subnet.')
output deploymentSubnetName string = vnetSpokeCreated::deploymentSubnet.name

@description('The resource ID of the spoke deployment subnet.')
output deploymentSubnetResourceId string = vnetSpokeCreated::deploymentSubnet.id

@description('The resource ID of the spoke Application Gateway subnet. This is \'\' if the subnet was not created.')
output spokeApplicationGatewaySubnetId string = (!empty(spokeApplicationGatewaySubnetAddressPrefix))
  ? vnetSpokeCreated::spokeApplicationGatewaySubnet.id
  : ''

@description('The name of the spoke Application Gateway subnet.  This is \'\' if the subnet was not created.')
output spokeApplicationGatewaySubnetName string = (!empty(spokeApplicationGatewaySubnetAddressPrefix))
  ? vnetSpokeCreated::spokeApplicationGatewaySubnet.name
  : ''

@description('The resource ID of the Azure Log Analytics Workspace.')
output logAnalyticsWorkspaceId string = logAnalyticsWorkspace.outputs.resourceId

@description('The name of the jump box virtual machine.')
output vmJumpBoxName string = resourcesNames.vmJumpBox
