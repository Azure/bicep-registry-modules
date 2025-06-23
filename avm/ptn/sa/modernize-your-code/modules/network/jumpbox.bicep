// /****************************************************************************************************************************/
// Create Jumpbox NSG and Jumpbox Subnet, then create Jumpbox VM
// /****************************************************************************************************************************/

@description('Required. Name of the Jumpbox Virtual Machine.')
param name string

@description('Optional. Azure region to deploy resources.')
param location string = resourceGroup().location

@description('Required. Name of the Virtual Network where the Jumpbox VM will be deployed.')
param vnetName string

@description('Required. Size of the Jumpbox Virtual Machine.')
param size string

import { subnetType } from 'virtualNetwork.bicep'
@description('Optional. Subnet configuration for the Jumpbox VM.')
param subnet subnetType?

@secure()
@description('Required. Username to access the Jumpbox VM.')
param username string

@secure()
@description('Required. Password to access the Jumpbox VM.')
param password string

@description('Optional. Tags to apply to the resources.')
param tags object = {}

@description('Required. Log Analytics Workspace Resource ID for VM diagnostics.')
param logAnalyticsWorkspaceId string

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

// 1. Create Jumpbox NSG
// using AVM Network Security Group module
// https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/network/network-security-group
module nsg 'br/public:avm/res/network/network-security-group:0.5.1' = if (!empty(subnet)) {
  name: '${vnetName}-${subnet.?networkSecurityGroup.name}'
  params: {
    name: '${vnetName}-${subnet.?networkSecurityGroup.name}'
    location: location
    securityRules: subnet.?networkSecurityGroup.securityRules
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

// 2. Create Jumpbox subnet as part of the existing VNet
// using AVM Virtual Network Subnet module
// https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/network/virtual-network/subnet
module subnetResource 'br/public:avm/res/network/virtual-network/subnet:0.1.2' = if (!empty(subnet)) {
  name: subnet.?name ?? '${vnetName}-jumpbox-subnet'
  params: {
    virtualNetworkName: vnetName
    name: subnet.?name ?? ''
    addressPrefixes: subnet.?addressPrefixes
    networkSecurityGroupResourceId: nsg.outputs.resourceId
    enableTelemetry: enableTelemetry
  }
}

// 3. Create Jumpbox VM
// using AVM Virtual Machine module
// https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/compute/virtual-machine
var vmName = take(name, 15) // Shorten VM name to 15 characters to avoid Azure limits

module vm 'br/public:avm/res/compute/virtual-machine:0.15.0' = {
  name: take('${vmName}-jumpbox', 64)
  params: {
    name: vmName
    vmSize: size
    location: location
    adminUsername: username
    adminPassword: password
    tags: tags
    zone: 2
    imageReference: {
      offer: 'WindowsServer'
      publisher: 'MicrosoftWindowsServer'
      sku: '2019-datacenter'
      version: 'latest'
    }
    osType: 'Windows'
    osDisk: {
      managedDisk: {
        storageAccountType: 'Standard_LRS'
      }
    }
    encryptionAtHost: false // Some Azure subscriptions do not support encryption at host
    nicConfigurations: [
      {
        name: '${vmName}-nic'
        ipConfigurations: [
          {
            name: 'ipconfig1'
            subnetResourceId: subnetResource.outputs.resourceId
          }
        ]
        networkSecurityGroupResourceId: nsg.outputs.resourceId
        diagnosticSettings: [
          {
            name: 'jumpboxDiagnostics'
            workspaceResourceId: logAnalyticsWorkspaceId
            logCategoriesAndGroups: [
              {
                categoryGroup: 'allLogs'
                enabled: true
              }
            ]
            metricCategories: [
              {
                category: 'AllMetrics'
                enabled: true
              }
            ]
          }
        ]
      }
    ]
    enableTelemetry: enableTelemetry
  }
}

@description('Name of the Jumpbox Virtual Machine.')
output name string = vm.outputs.name

@description('Resource ID of the Jumpbox Virtual Machine.')
output resourceId string = vm.outputs.resourceId

@description('Location of the Jumpbox Virtual Machine.')
output location string = vm.outputs.location

@description('Resource ID of the Jumpbox Subnet.')
output subnetId string = subnetResource.outputs.resourceId

@description('Name of the Jumpbox Subnet.')
output subnetName string = subnetResource.outputs.name

@description('Resource ID of the Jumpbox Network Security Group.')
output nsgId string = nsg.outputs.resourceId

@description('Name of the Jumpbox Network Security Group.')
output nsgName string = nsg.outputs.name

@export()
@description('Custom type definition for establishing Jumpbox Virtual Machine and its associated resources.')
type jumpBoxConfigurationType = {
  @description('Required. The name of the Virtual Machine.')
  name: string

  @description('Optional. The size of the VM.')
  size: string?

  @secure()
  @description('Required. Username to access VM.')
  username: string

  @secure()
  @description('Required. Password to access VM.')
  password: string

  @description('Optional. Subnet configuration for the Jumpbox VM.')
  subnet: subnetType?
}
