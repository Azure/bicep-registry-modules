// ========================================================================== //
// Example: Deploy a jumpbox VM into the spoke VNet created by the LZA module //
// ========================================================================== //
// This dependency template demonstrates how to deploy a jumpbox VM into the
// spoke virtual network created by the App Service LZA module using Azure
// Bastion for secure access (no public IP, no password-based auth).
// Consumers can use this as a reference for deploying their own VMs alongside the LZA.

// ========== //
// Parameters //
// ========== //

@description('Required. The name of the virtual machine.')
param vmName string

@description('Required. The name of the spoke virtual network created by the LZA module.')
param spokeVnetName string

@description('Required. The admin username for the virtual machine.')
param vmAdminUsername string

@secure()
@description('Required. The admin password for the virtual machine. Used only for initial provisioning; access should be via Bastion.')
param vmAdminPassword string

@description('Optional. The VM SKU size.')
param vmSize string = 'Standard_D2s_v4'

@description('Optional. The location for the resources.')
param location string = resourceGroup().location

@description('Optional. Tags to apply to all resources.')
param tags object = {}

@description('Optional. Whether to enable deployment telemetry.')
param enableTelemetry bool = true

@description('Optional. The address prefix for the jumpbox subnet.')
param subnetAddressPrefix string = '10.240.10.128/26'

@description('Optional. The resource ID of the Bastion host. If provided, Bastion-specific NSG rules are created.')
param bastionResourceId string = ''

// ======================== //
// Resources                //
// ======================== //

// NSG with Bastion-aware rules: allow Bastion inbound, deny lateral RDP/SSH
module jumpboxNsg 'br/public:avm/res/network/network-security-group:0.5.2' = {
  name: '${uniqueString(deployment().name, location)}-jumpbox-nsg'
  params: {
    name: 'nsg-jumpbox-${vmName}'
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    securityRules: !empty(bastionResourceId)
      ? [
          {
            name: 'allow-bastion-inbound'
            properties: {
              description: 'Allow inbound traffic from Azure Bastion to the jumpbox'
              protocol: '*'
              sourceAddressPrefix: 'VirtualNetwork'
              sourcePortRange: '*'
              destinationAddressPrefix: '*'
              destinationPortRange: '*'
              access: 'Allow'
              priority: 100
              direction: 'Inbound'
            }
          }
          {
            name: 'deny-hop-outbound'
            properties: {
              description: 'Deny lateral movement via RDP/SSH from the jumpbox'
              priority: 200
              access: 'Deny'
              protocol: 'Tcp'
              direction: 'Outbound'
              sourcePortRange: '*'
              sourceAddressPrefix: 'VirtualNetwork'
              destinationAddressPrefix: '*'
              destinationPortRanges: [
                '3389'
                '22'
              ]
            }
          }
        ]
      : [
          {
            name: 'deny-hop-outbound'
            properties: {
              description: 'Deny lateral movement via RDP/SSH from the jumpbox'
              priority: 200
              access: 'Deny'
              protocol: 'Tcp'
              direction: 'Outbound'
              sourcePortRange: '*'
              sourceAddressPrefix: 'VirtualNetwork'
              destinationAddressPrefix: '*'
              destinationPortRanges: [
                '3389'
                '22'
              ]
            }
          }
        ]
  }
}

module jumpboxSubnet 'br/public:avm/res/network/virtual-network/subnet:0.1.3' = {
  name: '${uniqueString(deployment().name, location)}-jumpbox-subnet'
  params: {
    name: 'snet-jumpbox'
    virtualNetworkName: spokeVnetName
    addressPrefix: subnetAddressPrefix
    networkSecurityGroupResourceId: jumpboxNsg.outputs.resourceId
  }
}

// Deploy the VM with no public IP — access exclusively via Azure Bastion
module jumpboxVm 'br/public:avm/res/compute/virtual-machine:0.21.0' = {
  name: '${uniqueString(deployment().name, location)}-jumpbox-vm'
  params: {
    name: vmName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    osType: 'Windows'
    computerName: vmName
    adminUsername: vmAdminUsername
    adminPassword: vmAdminPassword
    encryptionAtHost: false
    availabilityZone: 1
    nicConfigurations: [
      {
        name: 'nic-${vmName}'
        enableAcceleratedNetworking: false
        ipConfigurations: [
          {
            name: 'ipconfig1'
            privateIPAllocationMethod: 'Dynamic'
            subnetResourceId: jumpboxSubnet.outputs.resourceId
          }
        ]
      }
    ]
    osDisk: {
      caching: 'ReadWrite'
      createOption: 'FromImage'
      deleteOption: 'Delete'
      diskSizeGB: 128
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    vmSize: vmSize
    imageReference: {
      publisher: 'MicrosoftWindowsServer'
      offer: 'WindowsServer'
      sku: '2025-datacenter-g2'
      version: 'latest'
    }
  }
}

// ========== //
// Outputs    //
// ========== //

@description('The resource ID of the jumpbox VM.')
output vmResourceId string = jumpboxVm.outputs.resourceId

@description('The name of the jumpbox VM.')
output vmName string = jumpboxVm.outputs.name
