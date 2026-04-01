// ============================================================================
// FinOps Hub - Managed Network Module
// ============================================================================
// Creates a self-contained VNet with private endpoints and DNS zones using AVM.
// This is the RECOMMENDED approach - enables clean upgrades without customization.
// ============================================================================

metadata name = 'FinOps Hub Managed Network'
metadata description = 'Deploys a self-contained VNet with private endpoints and DNS zones for FinOps Hub.'

// ============================================================================
// PARAMETERS
// ============================================================================

@description('Required. Name of the FinOps Hub (used for resource naming).')
param hubName string

@description('Required. Azure region for network resources.')
param location string

@description('Optional. Address prefix for the VNet. Default: 10.0.0.0/24.')
param vnetAddressPrefix string = '10.0.0.0/24'

@description('Optional. Address prefix for the private endpoints subnet. Default: 10.0.0.0/26 (62 usable IPs).')
param subnetAddressPrefix string = '10.0.0.0/26'

@description('Optional. Tags to apply to network resources.')
param tags object = {}

@description('Optional. Enable AVM telemetry.')
param enableTelemetry bool = false

// ============================================================================
// VARIABLES
// ============================================================================

var uniqueSuffix = uniqueString(resourceGroup().id, hubName)
var vnetName = 'vnet-${hubName}-${take(uniqueSuffix, 6)}'
var subnetName = 'snet-private-endpoints'
var nsgName = 'nsg-${hubName}-pe'

// Private DNS zone names for Azure services
var dnsZoneNames = {
  blob: 'privatelink.blob.${environment().suffixes.storage}'
  dfs: 'privatelink.dfs.${environment().suffixes.storage}'
  vault: replace(environment().suffixes.keyvaultDns, '.', 'privatelink.')
  dataFactory: 'privatelink.datafactory.azure.net'
  kusto: 'privatelink.${location}.kusto.windows.net'
}

// ============================================================================
// RESOURCES - Using Azure Verified Modules
// ============================================================================

// --- Network Security Group for Private Endpoints ---
// Private endpoints only need inbound traffic from the VNet
module nsg 'br/public:avm/res/network/network-security-group:0.5.2' = {
  name: '${uniqueString(deployment().name, location)}-nsg'
  params: {
    name: nsgName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    securityRules: [
      // Allow all inbound from VNet (required for private endpoint access)
      {
        name: 'AllowVnetInbound'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: 'VirtualNetwork'
          destinationPortRange: '*'
        }
      }
      // Deny all other inbound traffic
      {
        name: 'DenyAllInbound'
        properties: {
          priority: 4096
          direction: 'Inbound'
          access: 'Deny'
          protocol: '*'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
        }
      }
    ]
  }
}

// --- Virtual Network with Private Endpoint Subnet ---
module vnet 'br/public:avm/res/network/virtual-network:0.7.2' = {
  name: '${uniqueString(deployment().name, location)}-vnet'
  params: {
    name: vnetName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    addressPrefixes: [
      vnetAddressPrefix
    ]
    subnets: [
      {
        name: subnetName
        addressPrefix: subnetAddressPrefix
        networkSecurityGroupResourceId: nsg.outputs.resourceId
        // Private endpoints don't need service endpoints or delegation
        privateEndpointNetworkPolicies: 'Disabled' // Required for private endpoints
      }
    ]
  }
}

// --- Private DNS Zones for Private Link ---
// Creating individual DNS zones using the AVM resource module

module blobDnsZone 'br/public:avm/res/network/private-dns-zone:0.8.0' = {
  name: '${uniqueString(deployment().name, location)}-dns-blob'
  params: {
    name: dnsZoneNames.blob
    tags: tags
    enableTelemetry: enableTelemetry
    virtualNetworkLinks: [
      {
        virtualNetworkResourceId: vnet.outputs.resourceId
        registrationEnabled: false
      }
    ]
  }
}

module dfsDnsZone 'br/public:avm/res/network/private-dns-zone:0.8.0' = {
  name: '${uniqueString(deployment().name, location)}-dns-dfs'
  params: {
    name: dnsZoneNames.dfs
    tags: tags
    enableTelemetry: enableTelemetry
    virtualNetworkLinks: [
      {
        virtualNetworkResourceId: vnet.outputs.resourceId
        registrationEnabled: false
      }
    ]
  }
}

module vaultDnsZone 'br/public:avm/res/network/private-dns-zone:0.8.0' = {
  name: '${uniqueString(deployment().name, location)}-dns-vault'
  params: {
    name: dnsZoneNames.vault
    tags: tags
    enableTelemetry: enableTelemetry
    virtualNetworkLinks: [
      {
        virtualNetworkResourceId: vnet.outputs.resourceId
        registrationEnabled: false
      }
    ]
  }
}

module dataFactoryDnsZone 'br/public:avm/res/network/private-dns-zone:0.8.0' = {
  name: '${uniqueString(deployment().name, location)}-dns-adf'
  params: {
    name: dnsZoneNames.dataFactory
    tags: tags
    enableTelemetry: enableTelemetry
    virtualNetworkLinks: [
      {
        virtualNetworkResourceId: vnet.outputs.resourceId
        registrationEnabled: false
      }
    ]
  }
}

module kustoDnsZone 'br/public:avm/res/network/private-dns-zone:0.8.0' = {
  name: '${uniqueString(deployment().name, location)}-dns-kusto'
  params: {
    name: dnsZoneNames.kusto
    tags: tags
    enableTelemetry: enableTelemetry
    virtualNetworkLinks: [
      {
        virtualNetworkResourceId: vnet.outputs.resourceId
        registrationEnabled: false
      }
    ]
  }
}

// ============================================================================
// OUTPUTS
// ============================================================================

@description('Resource ID of the created VNet.')
output vnetResourceId string = vnet.outputs.resourceId

@description('Name of the created VNet.')
output vnetName string = vnet.outputs.name

@description('Resource ID of the private endpoints subnet.')
output subnetResourceId string = vnet.outputs.subnetResourceIds[0]

@description('Name of the private endpoints subnet.')
output subnetName string = subnetName

@description('Resource ID of the NSG.')
output nsgResourceId string = nsg.outputs.resourceId

@description('Resource ID of the blob private DNS zone.')
output blobDnsZoneId string = blobDnsZone.outputs.resourceId

@description('Resource ID of the DFS private DNS zone.')
output dfsDnsZoneId string = dfsDnsZone.outputs.resourceId

@description('Resource ID of the Key Vault private DNS zone.')
output vaultDnsZoneId string = vaultDnsZone.outputs.resourceId

@description('Resource ID of the Data Factory private DNS zone.')
output dataFactoryDnsZoneId string = dataFactoryDnsZone.outputs.resourceId

@description('Resource ID of the Kusto private DNS zone.')
output kustoDnsZoneId string = kustoDnsZone.outputs.resourceId

