targetScope = 'subscription'

// ------------------
//    PARAMETERS
// ------------------

@description('The name of the workload that is being deployed. Up to 10 characters long.')
@minLength(2)
@maxLength(10)
param workloadName string

@description('The name of the environment (e.g. "dev", "test", "prod", "uat", "dr", "qa"). Up to 8 characters long.')
@maxLength(8)
param environment string = 'test'

@description('The location where the resources will be created.')
param location string = deployment().location

@description('Optional. The tags to be assigned to the created resources.')
param tags object = {}

@description('CIDR of the hub virtual network.')
param vnetAddressPrefixes array

@description('Enable or disable the creation of the Azure Bastion.')
param enableBastion bool = true

@description('Bastion sku, default is basic')
@allowed([
  'Basic'
  'Standard'
])
param bastionSku string = 'Basic'

@description('CIDR to use for the Azure Bastion subnet.')
param bastionSubnetAddressPrefix string

@description('CIDR to use for the gatewaySubnet.')
param gatewaySubnetAddressPrefix string

@description('CIDR to use for the azureFirewallSubnet.')
param azureFirewallSubnetAddressPrefix string

@description('CIDR to use for the AzureFirewallManagementSubnet, which is required by AzFW Basic.')
param azureFirewallSubnetManagementAddressPrefix string

// ------------------
// VARIABLES
// ------------------

// These cannot be another value
var gatewaySubnetName = 'GatewaySubnet'
var azureFirewallSubnetName = 'AzureFirewallSubnet'
var AzureFirewallManagementSubnetName = 'AzureFirewallManagementSubnet'
var bastionSubnetName = 'AzureBastionSubnet'

//Subnet definition taking in consideration feature flags
var defaultSubnets = [
  {
    name: gatewaySubnetName
    addressPrefix: gatewaySubnetAddressPrefix
  }
  {
    name: azureFirewallSubnetName
    addressPrefix: azureFirewallSubnetAddressPrefix
  }
  {
    name: AzureFirewallManagementSubnetName
    addressPrefix: azureFirewallSubnetManagementAddressPrefix
  }
]

// Append optional bastion subnet, if required
var vnetSubnets = enableBastion
  ? concat(defaultSubnets, [
      {
        name: bastionSubnetName
        addressPrefix: bastionSubnetAddressPrefix
      }
    ])
  : defaultSubnets

//used only to override the RG name - because it is created at the subscription level, the naming module cannot be loaded/used
var namingRules = json(loadTextContent('../../../modules/naming/naming-rules.jsonc'))
var rgHubName = '${namingRules.resourceTypeAbbreviations.resourceGroup}-${workloadName}-hub-${environment}-${namingRules.regionAbbreviations[toLower(location)]}'

// ------------------
// RESOURCES
// ------------------
@description('User-configured naming rules')
module naming '../../../modules/naming/naming.module.bicep' = {
  scope: resourceGroup(rgHubName)
  name: take('02-sharedNamingDeployment-${deployment().name}', 64)
  params: {
    uniqueId: uniqueString(hubResourceGroup.outputs.resourceId)
    environment: environment
    workloadName: workloadName
    location: location
  }
}

@description('The hub resource group. This would normally be already provisioned by your platform team.')
module hubResourceGroup 'br/public:avm/res/resources/resource-group:0.2.3' = {
  name: take('rg-${deployment().name}', 64)
  params: {
    name: rgHubName
    location: location
    tags: tags
  }
}

@description('The log sink for Azure Diagnostics')
module hubLogAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.3.4' = {
  name: take('logAnalyticsWs-${uniqueString(rgHubName)}', 64)
  scope: resourceGroup(rgHubName)
  params: {
    name: naming.outputs.resourcesNames.logAnalyticsWorkspace
    location: location
    tags: tags
  }
}

@description('The virtual network used as the stand-in for the regional hub. This would normally be already provisioned by your platform team.')
module vnetHub 'br/public:avm/res/network/virtual-network:0.1.6' = {
  name: take('vnetSpoke-${deployment().name}', 64)
  scope: resourceGroup(rgHubName)
  params: {
    name: naming.outputs.resourcesNames.vnetSpoke
    location: location
    tags: tags
    addressPrefixes: vnetAddressPrefixes
    subnets: vnetSubnets
  }
}

@description('The Azure Firewall deployment. This would normally be already provisioned by your platform team.')
module azureFirewall 'br/public:avm/res/network/azure-firewall:0.3.0' = {
  name: 'azureFirewallDeployment'
  scope: resourceGroup(rgHubName)
  params: {
    // Required parameters
    name: take('afw-${deployment().name}', 64)
    // Non-required parameters
    location: location
    tags: tags
    virtualNetworkResourceId: vnetHub.outputs.resourceId
  }
}

@description('An optional Azure Bastion deployment for jump box access. This would normally be already provisioned by your platform team.')
module bastionHost 'br/public:avm/res/network/bastion-host:0.2.1' = {
  name: take('bastion-${deployment().name}', 64)
  scope: resourceGroup(rgHubName)
  params: {
    // Required parameters
    name: naming.outputs.resourcesNames.bastion
    virtualNetworkResourceId: vnetHub.outputs.resourceId
    // Non-required parameters
    location: location
    tags: tags
    skuName: bastionSku
  }
}

// ------------------
// OUTPUTS
// ------------------

@description('The resource ID of hub virtual network.')
output hubVNetId string = vnetHub.outputs.resourceId

@description('The name of hub virtual network')
output hubVnetName string = vnetHub.outputs.name

@description('The name of the hub resource group.')
output resourceGroupName string = hubResourceGroup.outputs.name

@description('The private IP address of the Azure Firewall.')
output networkApplianceIpAddress string = azureFirewall.outputs.privateIp
