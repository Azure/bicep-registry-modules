targetScope = 'managementGroup'

// METADATA - Used by PSDocs

metadata name = '`/subResourcesWrapper/deploy.bicep` Parameters'

metadata description = 'This module is used by the [`bicep-lz-vending`](https://aka.ms/sub-vending/bicep) module to help orchestrate the deployment'

metadata details = '''These are the input parameters for the Bicep module: [`deploy.bicep`](./deploy.bicep)

This is the sub-orchestration module that is used and called by the [`main.bicep`](../../../main.bicep)  module to deploy the resources into the subscription that has been created (or an existing one provided), based on the parameter input values that are provided to it at deployment time from the `main.bicep` orchestration module.

> ⚠️ It is not intended for this module to be called outside of being a sub-orchestration module for the `main.bicep` module ⚠️'''

// PARAMETERS

@maxLength(36)
param subscriptionId string

@sys.description('Whether to move the subscription to the specified management group supplied in the pararmeter subscriptionManagementGroupId.')
param subscriptionManagementGroupAssociationEnabled bool = true

@sys.description('The destination management group ID for the new subscription. Note: Do not supply the display name. The management group ID forms part of the Azure resource ID. e.g., `/providers/Microsoft.Management/managementGroups/{managementGroupId}`.')
param subscriptionManagementGroupId string = ''

@sys.description('An object of tag key/value pairs to be appended to a subscription. NOTE: Tags will only be overwriten if existing tag exists with same key; values provided here win.')
param subscriptionTags object = {}

@sys.description('Whether to create a virtual network or not.')
param virtualNetworkEnabled bool = false

@maxLength(90)
@sys.description('The name of the resource group to create the virtual network in.')
param virtualNetworkResourceGroupName string = ''

@sys.description('Enables the deployment of a `CanNotDelete` resource locks to the virtual networks resource group.')
param virtualNetworkResourceGroupLockEnabled bool = true

@sys.description('An object of tag key/value pairs to be appended to the Resource Group that the Virtual Network is created in. NOTE: Tags will only be overwriten if existing tag exists with same key; values provided here win.')
param virtualNetworkResourceGroupTags object = {}

@sys.description('The location of the virtual network. Use region shortnames e.g. uksouth, eastus, etc.')
param virtualNetworkLocation string = deployment().location

@maxLength(64)
@sys.description('The name of the virtual network. The string must consist of a-z, A-Z, 0-9, -, _, and . (period) and be between 2 and 64 characters in length.')
param virtualNetworkName string = ''

@sys.description('An object of tag key/value pairs to be set on the Virtual Network that is created. NOTE: Tags will be overwritten on resoruce if any exist already.')
param virtualNetworkTags object = {}

@sys.description('The address space of the virtual network, supplied as multiple CIDR blocks, e.g. `["10.0.0.0/16","172.16.0.0/12"]`')
param virtualNetworkAddressSpace array = []

@sys.description('The custom DNS servers to use on the virtual network, e.g. `["10.4.1.4", "10.2.1.5"]. If left empty (default) then Azure DNS will be used for the virtual network.`')
param virtualNetworkDnsServers array = []

@sys.description('The resoruce ID of an existing DDoS Network Protection Plan that you wish to link to this virtual network.')
param virtualNetworkDdosPlanId string = ''

@sys.description('Whether to enable peering/connection with the supplied hub virtual network or virtual hub.')
param virtualNetworkPeeringEnabled bool = false

@sys.description('The resource ID of the virtual network or virtual wan hub in the hub to which the created virtual network will be peered/connected to via vitrual network peering or a vitrual hub connection.')
param hubNetworkResourceId string = ''

@sys.description('Enables the use of remote gateways in the spefcified hub virtual network. If no gateways exsit in the hub virtual network, set this to `false`, otherwise peering will fail to create. Set this to `false` for virtual wan hub connections.')
param virtualNetworkUseRemoteGateways bool = true

@sys.description('Enables the ability for the Virtual WAN Hub Connection to learn the default route 0.0.0.0/0 from the Hub.')
param virtualNetworkVwanEnableInternetSecurity bool = true

@sys.description('The resource ID of the virtual hub route table to associate to the virtual hub connection (this virtual network). If left blank/empty default route table will be associated.')
param virtualNetworkVwanAssociatedRouteTableResourceId string = ''

@sys.description('An array of virtual hub route table resource IDs to propogate routes to. If left blank/empty default route table will be propogated to only.')
param virtualNetworkVwanPropagatedRouteTablesResourceIds array = []

@sys.description('An array of virtual hub route table labels to propogate routes to. If left blank/empty default label will be propogated to only.')
param virtualNetworkVwanPropagatedLabels array = []

@sys.description('Whether to create role assignments or not. If true, supply the array of role assignment objects in the parameter called `roleAssignments`.')
param roleAssignmentEnabled bool = false

@sys.description('Supply an array of objects containing the details of the role assignments to create.')
param roleAssignments array = []

@sys.description('Disable telemetry collection by this module. For more information on the telemetry collected by this module, that is controlled by this parameter, see this page in the wiki: [Telemetry Tracking Using Customer Usage Attribution (PID)](https://github.com/Azure/bicep-lz-vending/wiki/Telemetry)')
param disableTelemetry bool = false

// VARIABLES

// Deployment name variables
// LIMITS: Tenant = 64, Management Group = 64, Subscription = 64, Resource Group = 64
var deploymentNames = {
  moveSubscriptionToManagementGroup: take('lz-vend-move-sub-${uniqueString(subscriptionId, subscriptionManagementGroupId, deployment().name)}', 64)
  tagSubscription: take('lz-vend-tag-sub-${uniqueString(subscriptionId, deployment().name)}', 64)
  createResourceGroupForLzNetworking: take('lz-vend-rsg-create-${uniqueString(subscriptionId, virtualNetworkResourceGroupName, virtualNetworkLocation, deployment().name)}', 64)
  tagResoruceGroupForLzNetworking: take('lz-vend-tag-rsg-${uniqueString(subscriptionId, virtualNetworkResourceGroupName, virtualNetworkLocation, deployment().name)}', 64)
  createLzVnet: take('lz-vend-vnet-create-${uniqueString(subscriptionId, virtualNetworkResourceGroupName, virtualNetworkLocation, virtualNetworkName, deployment().name)}', 64)
  createLzVirtualWanConnection: take('lz-vend-vhc-create-${uniqueString(subscriptionId, virtualNetworkResourceGroupName, virtualNetworkLocation, virtualNetworkName, virtualHubResourceIdChecked, deployment().name)}', 64)
  createLzRoleAssignmentsSub: take('lz-vend-rbac-sub-create-${uniqueString(subscriptionId, deployment().name)}', 64)
  createLzRoleAssignmentsRsgsSelf: take('lz-vend-rbac-rsg-self-create-${uniqueString(subscriptionId, deployment().name)}', 64)
  createLzRoleAssignmentsRsgsNotSelf: take('lz-vend-rbac-rsg-nself-create-${uniqueString(subscriptionId, deployment().name)}', 64)
}

// Role Assignments filtering and splitting
var roleAssignmentsSubscription = filter(roleAssignments, assignment => !contains(assignment.relativeScope, '/resourceGroups/'))
var roleAssignmentsResourceGroups = filter(roleAssignments, assignment => contains(assignment.relativeScope, '/resourceGroups/'))
var roleAssignmentsResourceGroupSelf = filter(roleAssignmentsResourceGroups, assignment => contains(assignment.relativeScope, '/resourceGroups/${virtualNetworkResourceGroupName}'))
var roleAssignmentsResourceGroupNotSelf = filter(roleAssignmentsResourceGroups, assignment => !contains(assignment.relativeScope, '/resourceGroups/${virtualNetworkResourceGroupName}'))

// Check hubNetworkResourceId to see if it's a virtual WAN connection instead of normal virtual network peering
var virtualHubResourceIdChecked = (!empty(hubNetworkResourceId) && contains(hubNetworkResourceId, '/providers/Microsoft.Network/virtualHubs/') ? hubNetworkResourceId : '')
var hubVirtualNetworkResourceIdChecked = (!empty(hubNetworkResourceId) && contains(hubNetworkResourceId, '/providers/Microsoft.Network/virtualNetworks/') ? hubNetworkResourceId : '')

// Virtual WAN data
var virtualWanHubName = (!empty(virtualHubResourceIdChecked) ? split(virtualHubResourceIdChecked, '/')[8] : '')
var virtualWanHubSubscriptionId = (!empty(virtualHubResourceIdChecked) ? split(virtualHubResourceIdChecked, '/')[2] : '')
var virtualWanHubResourceGroupName = (!empty(virtualHubResourceIdChecked) ? split(virtualHubResourceIdChecked, '/')[4] : '')
var virtualWanHubConnectionName = 'vhc-${guid(virtualHubResourceIdChecked, virtualNetworkName, virtualNetworkResourceGroupName, virtualNetworkLocation, subscriptionId)}'
var virtualWanHubConnectionAssociatedRouteTable = !empty(virtualNetworkVwanAssociatedRouteTableResourceId) ? virtualNetworkVwanAssociatedRouteTableResourceId : '${virtualHubResourceIdChecked}/hubRouteTables/defaultRouteTable'
var virutalWanHubDefaultRouteTableId = {
  id: '${virtualHubResourceIdChecked}/hubRouteTables/defaultRouteTable'
}
var virtualWanHubConnectionPropogatedRouteTables = !empty(virtualNetworkVwanPropagatedRouteTablesResourceIds) ? virtualNetworkVwanPropagatedRouteTablesResourceIds : array(virutalWanHubDefaultRouteTableId)
var virtualWanHubConnectionPropogatedLabels = !empty(virtualNetworkVwanPropagatedLabels) ? virtualNetworkVwanPropagatedLabels : [ 'default' ]

// Telemetry for CARML flip
var enableTelemetryForCarml = !disableTelemetry

// RESOURCES & MODULES

module moveSubscriptionToManagementGroup '../Microsoft.Management/managementGroups/subscriptions/deploy.bicep' = if (subscriptionManagementGroupAssociationEnabled && !empty(subscriptionManagementGroupId)) {
  scope: managementGroup(subscriptionManagementGroupId)
  name: deploymentNames.moveSubscriptionToManagementGroup
  params: {
    subscriptionManagementGroupId: subscriptionManagementGroupId
    subscriptionId: subscriptionId
  }
}

module tagSubscription '../../carml/v0.6.0/Microsoft.Resources/tags/deploy.bicep' = if (!empty(subscriptionTags)) {
  scope: subscription(subscriptionId)
  name: deploymentNames.tagSubscription
  params: {
    subscriptionId: subscriptionId
    location: virtualNetworkLocation
    onlyUpdate: true
    tags: subscriptionTags
    enableDefaultTelemetry: enableTelemetryForCarml
  }
}

module createResourceGroupForLzNetworking '../../carml/v0.6.0/Microsoft.Resources/resourceGroups/deploy.bicep' = if (virtualNetworkEnabled && !empty(virtualNetworkLocation) && !empty(virtualNetworkResourceGroupName)) {
  scope: subscription(subscriptionId)
  name: deploymentNames.createResourceGroupForLzNetworking
  params: {
    name: virtualNetworkResourceGroupName
    location: virtualNetworkLocation
    lock: virtualNetworkResourceGroupLockEnabled ? 'CanNotDelete' : ''
    enableDefaultTelemetry: enableTelemetryForCarml
  }
}

module tagResourceGroup '../../carml/v0.6.0/Microsoft.Resources/tags/deploy.bicep' = if (virtualNetworkEnabled && !empty(virtualNetworkLocation) && !empty(virtualNetworkResourceGroupName) && !empty(virtualNetworkResourceGroupTags)) {
  dependsOn: [
    createResourceGroupForLzNetworking
  ]
  scope: subscription(subscriptionId)
  name: deploymentNames.tagResoruceGroupForLzNetworking
  params: {
    subscriptionId: subscriptionId
    resourceGroupName: virtualNetworkResourceGroupName
    onlyUpdate: true
    tags: virtualNetworkResourceGroupTags
    enableDefaultTelemetry: enableTelemetryForCarml
  }
}

module createLzVnet '../../carml/v0.6.0/Microsoft.Network/virtualNetworks/deploy.bicep' = if (virtualNetworkEnabled && !empty(virtualNetworkName) && !empty(virtualNetworkAddressSpace) && !empty(virtualNetworkLocation) && !empty(virtualNetworkResourceGroupName)) {
  dependsOn: [
    createResourceGroupForLzNetworking
  ]
  scope: resourceGroup(subscriptionId, virtualNetworkResourceGroupName)
  name: deploymentNames.createLzVnet
  params: {
    name: virtualNetworkName
    tags: virtualNetworkTags
    location: virtualNetworkLocation
    addressPrefixes: virtualNetworkAddressSpace
    dnsServers: virtualNetworkDnsServers
    ddosProtectionPlanId: virtualNetworkDdosPlanId
    virtualNetworkPeerings: (virtualNetworkEnabled && virtualNetworkPeeringEnabled && !empty(hubVirtualNetworkResourceIdChecked) && !empty(virtualNetworkName) && !empty(virtualNetworkAddressSpace) && !empty(virtualNetworkLocation) && !empty(virtualNetworkResourceGroupName)) ? [
      {
        allowForwardedTraffic: true
        allowVirtualNetworkAccess: true
        allowGatewayTransit: false
        useRemoteGateways: virtualNetworkUseRemoteGateways
        remotePeeringEnabled: virtualNetworkPeeringEnabled
        remoteVirtualNetworkId: hubVirtualNetworkResourceIdChecked
        remotePeeringAllowForwardedTraffic: true
        remotePeeringAllowVirtualNetworkAccess: true
        remotePeeringAllowGatewayTransit: true
        remotePeeringUseRemoteGateways: false
      }
    ] : []
    enableDefaultTelemetry: enableTelemetryForCarml
  }
}

module createLzVirtualWanConnection '../../carml/v0.6.0/Microsoft.Network/virtualHubs/hubVirtualNetworkConnections/deploy.bicep' = if (virtualNetworkEnabled && virtualNetworkPeeringEnabled && !empty(virtualHubResourceIdChecked) && !empty(virtualNetworkName) && !empty(virtualNetworkAddressSpace) && !empty(virtualNetworkLocation) && !empty(virtualNetworkResourceGroupName) && !empty(virtualWanHubResourceGroupName) && !empty(virtualWanHubSubscriptionId)) {
  dependsOn: [
    createResourceGroupForLzNetworking
  ]
  scope: resourceGroup(virtualWanHubSubscriptionId, virtualWanHubResourceGroupName)
  name: deploymentNames.createLzVirtualWanConnection
  params: {
    name: virtualWanHubConnectionName
    virtualHubName: virtualWanHubName
    remoteVirtualNetworkId: '/subscriptions/${subscriptionId}/resourceGroups/${virtualNetworkResourceGroupName}/providers/Microsoft.Network/virtualNetworks/${virtualNetworkName}'
    enableInternetSecurity: virtualNetworkVwanEnableInternetSecurity
    routingConfiguration: {
      associatedRouteTable: {
        id: virtualWanHubConnectionAssociatedRouteTable
      }
      propagatedRouteTables: {
        ids: virtualWanHubConnectionPropogatedRouteTables
        labels: virtualWanHubConnectionPropogatedLabels
      }
    }
    enableDefaultTelemetry: enableTelemetryForCarml
  }
}

module createLzRoleAssignmentsSub '../../carml/v0.6.0/Microsoft.Authorization/roleAssignments/deploy.bicep' = [for assignment in roleAssignmentsSubscription: if (roleAssignmentEnabled && !empty(roleAssignmentsSubscription)) {
  name: take('${deploymentNames.createLzRoleAssignmentsSub}-${uniqueString(assignment.principalId, assignment.definition, assignment.relativeScope)}', 64)
  params: {
    location: virtualNetworkLocation
    principalId: assignment.principalId
    roleDefinitionIdOrName: assignment.definition
    subscriptionId: subscriptionId
    enableDefaultTelemetry: enableTelemetryForCarml
  }
}]

module createLzRoleAssignmentsRsgsSelf '../../carml/v0.6.0/Microsoft.Authorization/roleAssignments/deploy.bicep' = [for assignment in roleAssignmentsResourceGroupSelf: if (roleAssignmentEnabled && !empty(roleAssignmentsResourceGroupSelf)) {
  dependsOn: [
    createResourceGroupForLzNetworking
  ]
  name: take('${deploymentNames.createLzRoleAssignmentsRsgsSelf}-${uniqueString(assignment.principalId, assignment.definition, assignment.relativeScope)}', 64)
  params: {
    location: virtualNetworkLocation
    principalId: assignment.principalId
    roleDefinitionIdOrName: assignment.definition
    subscriptionId: subscriptionId
    resourceGroupName: split(assignment.relativeScope, '/')[2]
    enableDefaultTelemetry: enableTelemetryForCarml
  }
}]

module createLzRoleAssignmentsRsgsNotSelf '../../carml/v0.6.0/Microsoft.Authorization/roleAssignments/deploy.bicep' = [for assignment in roleAssignmentsResourceGroupNotSelf: if (roleAssignmentEnabled && !empty(roleAssignmentsResourceGroupNotSelf)) {
  name: take('${deploymentNames.createLzRoleAssignmentsRsgsNotSelf}-${uniqueString(assignment.principalId, assignment.definition, assignment.relativeScope)}', 64)
  params: {
    location: virtualNetworkLocation
    principalId: assignment.principalId
    roleDefinitionIdOrName: assignment.definition
    subscriptionId: subscriptionId
    resourceGroupName: split(assignment.relativeScope, '/')[2]
    enableDefaultTelemetry: enableTelemetryForCarml
  }
}]

// OUTPUTS
