metadata name = 'Secure Virtual Network Module'
metadata description = 'This module creates a secure Virtual Network with optional Azure Bastion Host and Jumpbox VM. It includes NSGs for each subnet and integrates with Log Analytics for monitoring.'

@minLength(6)
@maxLength(25)
@description('Required. Name used for naming all network resources.')
param resourcesName string

@minLength(3)
@description('Optional. Azure region for all services.')
param location string = resourceGroup().location

@description('Required. Resource ID of the Log Analytics Workspace for monitoring and diagnostics.')
param logAnalyticsWorkSpaceResourceId string

@description('Required. Networking address prefix for the VNET.')
param addressPrefixes array

import { subnetType } from 'virtualNetwork.bicep'
@description('Required. Array of subnets to be created within the VNET.')
param subnets subnetType[]

import { jumpBoxConfigurationType } from 'jumpbox.bicep'
@description('Optional. Configuration for the Jumpbox VM. Leave null to omit Jumpbox creation.')
param jumpboxConfiguration jumpBoxConfigurationType?

import { bastionHostConfigurationType } from 'bastionHost.bicep'
@description('Optional. Configuration for the Azure Bastion Host. Leave null to omit Bastion creation.')
param bastionConfiguration bastionHostConfigurationType?

@description('Optional. Tags to be applied to the resources.')
param tags object = {}

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

// /****************************************************************************************************************************/
// Networking - NSGs, VNET and Subnets. Each subnet has its own NSG
// /****************************************************************************************************************************/

module virtualNetwork 'virtualNetwork.bicep' = {
  name: '${resourcesName}-virtualNetwork'
  params: {
    name: 'vnet-${resourcesName}'
    addressPrefixes: addressPrefixes
    subnets: subnets
    location: location
    tags: tags
    logAnalyticsWorkspaceId: logAnalyticsWorkSpaceResourceId
    enableTelemetry: enableTelemetry
  }
}

// /****************************************************************************************************************************/
// // Create Azure Bastion Subnet and Azure Bastion Host
// /****************************************************************************************************************************/

module bastionHost 'bastionHost.bicep' = if (!empty(bastionConfiguration)) {
  name: '${resourcesName}-bastionHost'
  params: {
    name: bastionConfiguration.?name ?? 'bas-${resourcesName}'
    vnetId: virtualNetwork.outputs.resourceId
    vnetName: virtualNetwork.outputs.name
    location: location
    logAnalyticsWorkspaceId: logAnalyticsWorkSpaceResourceId
    subnet: bastionConfiguration.?subnet
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

// /****************************************************************************************************************************/
// // create Jumpbox NSG and Jumpbox Subnet, then create Jumpbox VM
// /****************************************************************************************************************************/

module jumpbox 'jumpbox.bicep' = if (!empty(jumpboxConfiguration)) {
  name: '${resourcesName}-jumpbox'
  params: {
    name: jumpboxConfiguration.?name ?? 'vm-jumpbox-${resourcesName}'
    vnetName: virtualNetwork.outputs.name
    size: jumpboxConfiguration.?size ?? 'Standard_D2s_v3'
    logAnalyticsWorkspaceId: logAnalyticsWorkSpaceResourceId
    location: location
    subnet: jumpboxConfiguration.?subnet
    username: jumpboxConfiguration.?username ?? '' // required
    password: jumpboxConfiguration.?password ?? '' // required
    enableTelemetry: enableTelemetry
    tags: tags
  }
}

@description('Name of the deployed virtual network.')
output vnetName string = virtualNetwork.outputs.name

@description('Resource ID of the deployed virtual network.')
output vnetResourceId string = virtualNetwork.outputs.resourceId

import { subnetOutputType } from 'virtualNetwork.bicep'
@description('Array of subnet objects including names, resource IDs, NSG associations, and related metadata.')
output subnets subnetOutputType[] = virtualNetwork.outputs.subnets // This one holds critical info for subnets, including NSGs

@description('ID of bastion subnet, if created.')
output bastionSubnetId string = bastionHost!.outputs.subnetId

@description('Subnet name of bastion host, if created.')
output bastionSubnetName string = bastionHost!.outputs.subnetName

@description('Host id of bastion host, if created.')
output bastionHostId string = bastionHost!.outputs.resourceId

@description('Host name of bastion host, if created.')
output bastionHostName string = bastionHost!.outputs.name

@description('Subnet name of jumpbox, if created.')
output jumpboxSubnetName string = jumpbox!.outputs.subnetName

@description('Subnet ID of jumpbox, if created.')
output jumpboxSubnetId string = jumpbox!.outputs.subnetId

@description('Jumpbox name, if created.')
output jumpboxName string = jumpbox!.outputs.name

@description('Jumpbox resource ID, if created.')
output jumpboxResourceId string = jumpbox!.outputs.resourceId

@description('Name of the resource group.')
output resourceGroupName string = resourceGroup().name
