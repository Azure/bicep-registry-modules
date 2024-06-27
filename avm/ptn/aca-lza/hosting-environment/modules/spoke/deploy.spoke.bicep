targetScope = 'subscription'

// ------------------
//    PARAMETERS
// ------------------

// @description('The ID of the subscription to deploy the spoke resources to.')
// param subscriptionId string

@description('The name of the workload that is being deployed. Up to 10 characters long.')
@minLength(2)
@maxLength(10)
param workloadName string

@description('The name of the environment (e.g. "dev", "test", "prod", "uat", "dr", "qa"). Up to 8 characters long.')
@maxLength(8)
param environment string

@description('The location where the resources will be created. This should be the same region as the hub.')
param location string = deployment().location

@description('Optional. The name of the resource group to create the resources in. If set, it overrides the name generated by the template.')
param spokeResourceGroupName string

@description('Optional. The tags to be assigned to the created resources.')
param tags object = {}

// Hub
@description('The resource ID of the existing hub virtual network.')
param hubVNetId string

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

@description('The IP address of the network appliance (e.g. firewall) that will be used to route traffic to the internet.')
param networkApplianceIpAddress string

@description('The size of the jump box virtual machine to create. See https://learn.microsoft.com/azure/virtual-machines/sizes for more information.')
param vmSize string

@description('Optional. The zone to create the jump box in. Defaults to 0.')
param vmZone int = 0

@description('Optional. The storage account type to use for the jump box. Defaults to Standard_LRS.')
param storageAccountType string = 'Standard_LRS'

@description('The username to use for the jump box.')
param vmAdminUsername string

@description('The password to use for the jump box.')
@secure()
param vmAdminPassword string

@description('The SSH public key to use for the jump box. Only relevant for Linux.')
@secure()
param vmLinuxSshAuthorizedKey string

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

// load as text (and not as Json) to replace <location> placeholder in the nsg rules
var nsgCaeRules = json(replace(loadTextContent('./nsgContainerAppsEnvironment.jsonc'), '<location>', locationVar))
var nsgAppGwRules = loadJsonContent('./nsgAppGwRules.jsonc', 'securityRules')
var namingRules = json(loadTextContent('../naming/naming-rules.jsonc'))

var rgSpokeName = !empty(spokeResourceGroupName)
  ? spokeResourceGroupName
  : '${namingRules.resourceTypeAbbreviations.resourceGroup}-${workloadName}-${environment}-${namingRules.regionAbbreviations[toLower(location)]}-spoke'
var hubVNetResourceIdTokens = !empty(hubVNetId) ? split(hubVNetId, '/') : array('')

@description('The ID of the subscription containing the hub virtual network.')
var hubSubscriptionId = !empty(hubVNetId) ? hubVNetResourceIdTokens[2] : ''

@description('The name of the resource group containing the hub virtual network.')
var hubResourceGroupName = !empty(hubVNetId) ? hubVNetResourceIdTokens[4] : ''

@description('The name of the hub virtual network.')
var hubVNetName = !empty(hubVNetId) ? hubVNetResourceIdTokens[8] : ''

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

module spokeResourceGroup 'br/public:avm/res/resources/resource-group:0.2.3' = {
  name: take('rg-${deployment().name}', 64)
  params: {
    name: rgSpokeName
    location: location
    tags: tags
  }
}

@description('User-configured naming rules')
module naming '../naming/naming.module.bicep' = {
  scope: resourceGroup(rgSpokeName)
  name: take('spokeNamingDeployment-${deployment().name}', 64)
  params: {
    uniqueId: uniqueString(spokeResourceGroup.outputs.resourceId)
    environment: environment
    workloadName: workloadName
    location: location
  }
}

@description('The spoke virtual network in which the workload will run from. This virtual network would normally already be provisioned by your subscription vending process, and only the subnets would need to be configured.')
module vnetSpoke 'br/public:avm/res/network/virtual-network:0.1.6' = {
  name: take('vnetSpoke-${deployment().name}', 64)
  scope: resourceGroup(rgSpokeName)
  params: {
    name: naming.outputs.resourcesNames.vnetSpoke
    location: location
    tags: tags
    addressPrefixes: spokeVNetAddressPrefixes
    subnets: spokeSubnets
  }
}

@description('The log sink for Azure Diagnostics')
module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.3.4' = {
  name: take('logAnalyticsWs-${deployment().name}', 64)
  scope: resourceGroup(rgSpokeName)
  params: {
    name: naming.outputs.resourcesNames.logAnalyticsWorkspace
    location: location
    tags: tags
  }
}

@description('Network security group rules for the Container Apps cluster.')
module nsgContainerAppsEnvironment 'br/public:avm/res/network/network-security-group:0.2.0' = {
  name: take('nsgContainerAppsEnvironment-${deployment().name}', 64)
  scope: resourceGroup(rgSpokeName)
  params: {
    name: naming.outputs.resourcesNames.containerAppsEnvironmentNsg
    location: location
    tags: tags
    securityRules: nsgCaeRules.securityRules
    diagnosticSettings: [
      {
        name: 'logAnalyticsSettings'
        workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
      }
    ]
  }
}

@description('NSG Rules for the Application Gateway.')
module nsgAppGw 'br/public:avm/res/network/network-security-group:0.2.0' = if (!empty(spokeApplicationGatewaySubnetAddressPrefix)) {
  name: take('nsgAppGw-${deployment().name}', 64)
  scope: resourceGroup(rgSpokeName)
  params: {
    name: naming.outputs.resourcesNames.applicationGatewayNsg
    location: location
    tags: tags
    securityRules: nsgAppGwRules
    diagnosticSettings: [
      {
        name: 'logAnalyticsSettings'
        workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
      }
    ]
  }
}

@description('NSG Rules for the private enpoint subnet.')
module nsgPep 'br/public:avm/res/network/network-security-group:0.2.0' = {
  name: take('nsgPep-${deployment().name}', 64)
  scope: resourceGroup(rgSpokeName)
  params: {
    name: naming.outputs.resourcesNames.pepNsg
    location: location
    tags: tags
    securityRules: []
    diagnosticSettings: [
      {
        name: 'logAnalyticsSettings'
        workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
      }
    ]
  }
}

//TODO: This needs to be replaced once the peering module is available in the avm modules
@description('Spoke peering to regional hub network. This peering would normally already be provisioned by your subscription vending process.')
module peerSpokeToHub '../networking/peering.bicep' = if (!empty(hubVNetId)) {
  name: take('${deployment().name}-peerSpokeToHubDeployment', 64)
  scope: resourceGroup(rgSpokeName)
  params: {
    localVnetName: vnetSpoke.outputs.name
    remoteSubscriptionId: hubSubscriptionId
    remoteRgName: hubResourceGroupName
    remoteVnetName: hubVNetName
  }
}

@description('The Route Table deployment')
module egressLockdownUdr 'br/public:avm/res/network/route-table:0.2.2' = if (!empty(hubVNetId) && !empty(networkApplianceIpAddress)) {
  name: take('egressLockdownUdr-${deployment().name}', 64)
  scope: resourceGroup(rgSpokeName)
  params: {
    name: naming.outputs.resourcesNames.routeTable
    location: location
    tags: tags
    routes: [
      {
        name: 'defaultEgressLockdown'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: networkApplianceIpAddress
        }
      }
    ]
  }
}

@description('An optional Linux virtual machine deployment to act as a jump box.')
module jumpboxLinuxVM '../compute/linux-vm.bicep' = if (vmJumpboxOSType == 'linux') {
  name: take('vm-linux-${deployment().name}', 64)
  scope: resourceGroup(rgSpokeName)
  params: {
    location: location
    tags: tags
    vmName: naming.outputs.resourcesNames.vmJumpBox
    vmAdminUsername: vmAdminUsername
    vmAdminPassword: vmAdminPassword
    vmSshPublicKey: vmLinuxSshAuthorizedKey
    vmSize: vmSize
    vmZone: vmZone
    storageAccountType: storageAccountType
    vmVnetName: vnetSpoke.outputs.name
    vmSubnetName: vmSubnetName
    vmSubnetAddressPrefix: vmJumpBoxSubnetAddressPrefix
    vmNetworkInterfaceName: naming.outputs.resourcesNames.vmJumpBoxNic
    vmNetworkSecurityGroupName: naming.outputs.resourcesNames.vmJumpBoxNsg
    vmAuthenticationType: vmAuthenticationType
  }
}

@description('An optional Windows virtual machine deployment to act as a jump box.')
module jumpboxWindowsVM '../compute/windows-vm.bicep' = if (vmJumpboxOSType == 'windows') {
  name: take('vm-windows-${deployment().name}', 64)
  scope: resourceGroup(rgSpokeName)
  params: {
    location: location
    tags: tags
    vmName: naming.outputs.resourcesNames.vmJumpBox
    vmAdminUsername: vmAdminUsername
    vmAdminPassword: vmAdminPassword
    vmSize: vmSize
    vmZone: vmZone
    storageAccountType: storageAccountType
    vmVnetName: vnetSpoke.outputs.name
    vmSubnetName: vmSubnetName
    vmSubnetAddressPrefix: vmJumpBoxSubnetAddressPrefix
    vmNetworkInterfaceName: naming.outputs.resourcesNames.vmJumpBoxNic
    vmNetworkSecurityGroupName: naming.outputs.resourcesNames.vmJumpBoxNsg
  }
}

// ------------------
// OUTPUTS
// ------------------

resource vnetSpokeCreated 'Microsoft.Network/virtualNetworks@2022-07-01' existing = {
  name: vnetSpoke.outputs.name
  scope: resourceGroup(rgSpokeName)

  resource spokeInfraSubnet 'subnets' existing = {
    name: spokeInfraSubnetName
  }

  resource spokePrivateEndpointsSubnet 'subnets' existing = {
    name: spokePrivateEndpointsSubnetName
  }

  resource spokeApplicationGatewaySubnet 'subnets' existing = if (!empty(spokeApplicationGatewaySubnetAddressPrefix)) {
    name: spokeApplicationGatewaySubnetName
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
output vmJumpBoxName string = naming.outputs.resourcesNames.vmJumpBox
