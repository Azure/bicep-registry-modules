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

@sys.description('The name of the resource group to create the user-assigned managed identities in.')
param userAssignedIdentityResourceGroupName string = ''

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
param virtualNetworkAddressSpace string[] = []

@sys.description('The subnets of the Virtual Network that will be created by this module.')
param virtualNetworkSubnets subnetType[] = []

@sys.description('The custom DNS servers to use on the virtual network, e.g. `["10.4.1.4", "10.2.1.5"]. If left empty (default) then Azure DNS will be used for the virtual network.`')
param virtualNetworkDnsServers array = []

@sys.description('The resoruce ID of an existing DDoS Network Protection Plan that you wish to link to this virtual network.')
param virtualNetworkDdosPlanResourceId string = ''

@sys.description('Whether to enable peering/connection with the supplied hub virtual network or virtual hub.')
param virtualNetworkPeeringEnabled bool = false

@sys.description('Whether to deploy a NAT gateway to the created virtual network.')
param virtualNetworkDeployNatGateway bool = false

@sys.description('The NAT Gateway configuration object. Do not provide this object or keep it empty if you do not want to deploy a NAT Gateway.')
param virtualNetworkNatGatewayConfiguration natGatewayType?

@sys.description('Whether to deploy a Bastion host to the created virtual network.')
param virtualNetworkDeployBastion bool = false

@sys.description('The configuration object for the Bastion host. Do not provide this object or keep it empty if you do not want to deploy a Bastion host.')
param virtualNetworkBastionConfiguration bastionType?

@sys.description('The resource ID of the virtual network or virtual wan hub in the hub to which the created virtual network will be peered/connected to via virtual network peering or a virtual hub connection.')
param hubNetworkResourceId string = ''

@sys.description('Enables the use of remote gateways in the specified hub virtual network. If no gateways exist in the hub virtual network, set this to `false`, otherwise peering will fail to create. Set this to `false` for virtual wan hub connections.')
param virtualNetworkUseRemoteGateways bool = true

@sys.description('A list of additional virtual networks to create.')
param additionalVirtualNetworks virtualNetworkType[] = []

@sys.description('Flag to do mesh peering of all virtual networks deployed into the new subscription.')
param peerAllVirtualNetworks bool = false

@sys.description('Enables the ability for the Virtual WAN Hub Connection to learn the default route 0.0.0.0/0 from the Hub.')
param virtualNetworkVwanEnableInternetSecurity bool = true

@sys.description('The resource ID of the virtual hub route table to associate to the virtual hub connection (this virtual network). If left blank/empty default route table will be associated.')
param virtualNetworkVwanAssociatedRouteTableResourceId string = ''

@sys.description('An array of virtual hub route table resource IDs to propogate routes to. If left blank/empty default route table will be propogated to only.')
param virtualNetworkVwanPropagatedRouteTablesResourceIds array = []

@sys.description('An array of virtual hub route table labels to propogate routes to. If left blank/empty default label will be propogated to only.')
param virtualNetworkVwanPropagatedLabels array = []

@sys.description('Indicates whether routing intent is enabled on the Virtual HUB within the virtual WAN.')
param vHubRoutingIntentEnabled bool = false

@sys.description('Whether to create role assignments or not. If true, supply the array of role assignment objects in the parameter called `roleAssignments`.')
param roleAssignmentEnabled bool = false

@sys.description('Supply an array of objects containing the details of the role assignments to create.')
param roleAssignments roleAssignmentType[] = []

@description('Supply an array of objects containing the details of the PIM role assignments to create.')
param pimRoleAssignments pimRoleAssignmentTypeType[] = []

@sys.description('Disable telemetry collection by this module. For more information on the telemetry collected by this module, that is controlled by this parameter, see this page in the wiki: [Telemetry Tracking Using Customer Usage Attribution (PID)](https://github.com/Azure/bicep-lz-vending/wiki/Telemetry)')
param enableTelemetry bool = true

@maxLength(90)
@sys.description('The name of the resource group to create the deployment script for resource providers registration.')
param deploymentScriptResourceGroupName string

@sys.description('The location of the deployment script. Use region shortnames e.g. uksouth, eastus, etc.')
param deploymentScriptLocation string = deployment().location

@sys.description('The name of the deployment script to register resource providers')
param deploymentScriptName string

@maxLength(64)
@sys.description('The name of the private virtual network for the deployment script. The string must consist of a-z, A-Z, 0-9, -, _, and . (period) and be between 2 and 64 characters in length.')
param deploymentScriptVirtualNetworkName string = ''

@sys.description('The name of the network security group for the deployment script private subnet.')
param deploymentScriptNetworkSecurityGroupName string = ''

@sys.description('The address prefix of the private virtual network for the deployment script.')
param virtualNetworkDeploymentScriptAddressPrefix string = ''

@sys.description('''
An object of resource providers and resource providers features to register. If left blank/empty, no resource providers will be registered.
}`''')
param resourceProviders object = {
  'Microsoft.ApiManagement': []
  'Microsoft.AppPlatform': []
  'Microsoft.Authorization': []
  'Microsoft.Automation': []
  'Microsoft.AVS': []
  'Microsoft.Blueprint': []
  'Microsoft.BotService': []
  'Microsoft.Cache': []
  'Microsoft.Cdn': []
  'Microsoft.CognitiveServices': []
  'Microsoft.Compute': []
  'Microsoft.ContainerInstance': []
  'Microsoft.ContainerRegistry': []
  'Microsoft.ContainerService': []
  'Microsoft.CostManagement': []
  'Microsoft.CustomProviders': []
  'Microsoft.Databricks': []
  'Microsoft.DataLakeAnalytics': []
  'Microsoft.DataLakeStore': []
  'Microsoft.DataMigration': []
  'Microsoft.DataProtection': []
  'Microsoft.DBforMariaDB': []
  'Microsoft.DBforMySQL': []
  'Microsoft.DBforPostgreSQL': []
  'Microsoft.DesktopVirtualization': []
  'Microsoft.Devices': []
  'Microsoft.DevTestLab': []
  'Microsoft.DocumentDB': []
  'Microsoft.EventGrid': []
  'Microsoft.EventHub': []
  'Microsoft.HDInsight': []
  'Microsoft.HealthcareApis': []
  'Microsoft.GuestConfiguration': []
  'Microsoft.KeyVault': []
  'Microsoft.Kusto': []
  'microsoft.insights': []
  'Microsoft.Logic': []
  'Microsoft.MachineLearningServices': []
  'Microsoft.Maintenance': []
  'Microsoft.ManagedIdentity': []
  'Microsoft.ManagedServices': []
  'Microsoft.Management': []
  'Microsoft.Maps': []
  'Microsoft.MarketplaceOrdering': []
  'Microsoft.Media': []
  'Microsoft.MixedReality': []
  'Microsoft.Network': []
  'Microsoft.NotificationHubs': []
  'Microsoft.OperationalInsights': []
  'Microsoft.OperationsManagement': []
  'Microsoft.PolicyInsights': []
  'Microsoft.PowerBIDedicated': []
  'Microsoft.Relay': []
  'Microsoft.RecoveryServices': []
  'Microsoft.Resources': []
  'Microsoft.Search': []
  'Microsoft.Security': []
  'Microsoft.SecurityInsights': []
  'Microsoft.ServiceBus': []
  'Microsoft.ServiceFabric': []
  'Microsoft.Sql': []
  'Microsoft.Storage': []
  'Microsoft.StreamAnalytics': []
  'Microsoft.Web': []
}

@sys.description('The name of the user managed identity for the resource providers registration deployment script.')
param deploymentScriptManagedIdentityName string

@sys.description('The name of the storage account for the deployment script.')
param deploymentScriptStorageAccountName string

@sys.description('Optional. The number of blank ARM deployments to create sequentially to introduce a delay to the Subscription being moved to the target Management Group being, if set, to allow for background platform RBAC inheritance to occur.')
param managementGroupAssociationDelayCount int = 15

@sys.description('Optional. The list of user-assigned managed identities.')
param userAssignedManagedIdentities userAssignedIdentityType[] = []

@sys.description('Enables the deployment of a `CanNotDelete` resource locks to the user-assigned managed identities resource group.')
param userAssignedIdentitiesResourceGroupLockEnabled bool = true

@sys.description('The list of route tables to create.')
param routeTables routeTableType[] = []

@sys.description('The name of the resource group to create the route tables in.')
param routeTablesResourceGroupName string = ''

// VARIABLES

// Deployment name variables
// LIMITS: Tenant = 64, Management Group = 64, Subscription = 64, Resource Group = 64
var deploymentNames = {
  moveSubscriptionToManagementGroupDelay: take(
    'lz-vend-move-sub-delay-${uniqueString(subscriptionId, subscriptionManagementGroupId, deployment().name)}',
    64
  )
  moveSubscriptionToManagementGroup: take(
    'lz-vend-move-sub-${uniqueString(subscriptionId, subscriptionManagementGroupId, deployment().name)}',
    64
  )
  tagSubscription: take('lz-vend-tag-sub-${uniqueString(subscriptionId, deployment().name)}', 64)
  createResourceGroupForLzNetworking: take(
    'lz-vend-rsg-create-${uniqueString(subscriptionId, virtualNetworkResourceGroupName, virtualNetworkLocation, deployment().name)}',
    64
  )
  createResourceGroupForIdentities: take(
    'lz-vend-rsg-identity-create-${uniqueString(subscriptionId, virtualNetworkResourceGroupName, virtualNetworkLocation, deployment().name)}',
    64
  )
  tagResoruceGroupForLzNetworking: take(
    'lz-vend-tag-rsg-${uniqueString(subscriptionId, virtualNetworkResourceGroupName, virtualNetworkLocation, deployment().name)}',
    64
  )
  createLzVnet: take(
    'lz-vend-vnet-create-${uniqueString(subscriptionId, virtualNetworkResourceGroupName, virtualNetworkLocation, virtualNetworkName, deployment().name)}',
    64
  )
  createLzVirtualWanConnection: take(
    'lz-vend-vhc-create-${uniqueString(subscriptionId, virtualNetworkResourceGroupName, virtualNetworkLocation, virtualNetworkName, virtualHubResourceIdChecked, deployment().name)}',
    64
  )
  createLzNsg: take(
    'lz-vend-nsg-create-${uniqueString(subscriptionId, virtualNetworkResourceGroupName, virtualNetworkLocation, virtualNetworkName, deployment().name)}',
    64
  )
  createLzRouteTable: take(
    'lz-vend-routetable-create-${uniqueString(subscriptionId, virtualNetworkResourceGroupName, virtualNetworkLocation, virtualNetworkName, deployment().name)}',
    64
  )
  createBastionNsg: take(
    'lz-vend-bastion-nsg-create-${uniqueString(subscriptionId, virtualNetworkResourceGroupName, virtualNetworkLocation, virtualNetworkName, deployment().name)}',
    64
  )
  createBastionHost: take(
    'lz-vend-bastion-create-${uniqueString(subscriptionId, virtualNetworkResourceGroupName, virtualNetworkLocation, virtualNetworkName, deployment().name)}',
    64
  )
  createUserAssignedIdentities: take(
    'lz-vend-identity-create-${uniqueString(subscriptionId, userAssignedIdentityResourceGroupName, virtualNetworkLocation, deployment().name)}',
    64
  )
  createLzRoleAssignmentsSub: take('lz-vend-rbac-sub-create-${uniqueString(subscriptionId, deployment().name)}', 64)
  createLzRoleAssignmentsRsgsSelf: take(
    'lz-vend-rbac-rsg-self-create-${uniqueString(subscriptionId, deployment().name)}',
    64
  )
  createLzRoleAssignmentsRsgsNotSelf: take(
    'lz-vend-rbac-rsg-nself-create-${uniqueString(subscriptionId, deployment().name)}',
    64
  )
  createLzPimRoleAssignmentsSub: take(
    'lz-vend-pim-rbac-sub-create-${uniqueString(subscriptionId, deployment().name)}',
    64
  )
  createLzPimRoleAssignmentsRsgsSelf: take(
    'lz-vend-pim-rbac-rsg-self-create-${uniqueString(subscriptionId, deployment().name)}',
    64
  )
  createLzPimRoleAssignmentsRsgsNotSelf: take(
    'lz-vend-pim-rbac-rsg-nself-create-${uniqueString(subscriptionId, deployment().name)}',
    64
  )
  createLzUMIRoleAssignmentsSub: take(
    'lz-vend-umi-rbac-sub-create-${uniqueString(subscriptionId, deployment().name)}',
    64
  )
  createLzUMIRoleAssignmentsRsgsSelf: take(
    'lz-vend-umi-rbac-rsg-self-create-${uniqueString(subscriptionId, deployment().name)}',
    64
  )
  createLzUMIRoleAssignmentsRsgsNotSelf: take(
    'lz-vend-umi-rbac-rsg-nself-create-${uniqueString(subscriptionId, deployment().name)}',
    64
  )
  createResourceGroupForDeploymentScript: take(
    'lz-vend-rsg-ds-create-${uniqueString(subscriptionId, deploymentScriptResourceGroupName, deploymentScriptLocation, deployment().name)}',
    64
  )
  createResourceGroupForRouteTables: take(
    'lz-vend-rsg-rt-create-${uniqueString(subscriptionId, routeTablesResourceGroupName, virtualNetworkLocation, deployment().name)}',
    64
  )
  registerResourceProviders: take(
    'lz-vend-ds-create-${uniqueString(subscriptionId, deploymentScriptResourceGroupName, deploymentScriptName, deployment().name)}',
    64
  )
  createDeploymentScriptManagedIdentity: take(
    'lz-vend-ds-msi-create-${uniqueString(subscriptionId, deploymentScriptResourceGroupName, deployment().name)}',
    64
  )
  createRoleAssignmentsDeploymentScript: take(
    'lz-vend-ds-rbac-create-${uniqueString(subscriptionId, deploymentScriptResourceGroupName, deploymentScriptManagedIdentityName, deployment().name)}',
    64
  )
  createRoleAssignmentsDeploymentScriptStorageAccount: take(
    'lz-vend-stg-rbac-create-${uniqueString(subscriptionId, deploymentScriptResourceGroupName, deploymentScriptManagedIdentityName, deployment().name)}',
    64
  )
  createdsVnet: take(
    'lz-vend-ds-vnet-create-${uniqueString(subscriptionId, deploymentScriptResourceGroupName, deploymentScriptLocation, deploymentScriptVirtualNetworkName, deployment().name)}',
    64
  )
  createDsNsg: take(
    'lz-vend-ds-nsg-create-${uniqueString(subscriptionId, deploymentScriptResourceGroupName, deploymentScriptLocation, deploymentScriptNetworkSecurityGroupName, deployment().name)}',
    64
  )
  createDsStorageAccount: take(
    'lz-vend-ds-stg-create-${uniqueString(subscriptionId, deploymentScriptResourceGroupName, deploymentScriptLocation, deploymentScriptStorageAccountName, deployment().name)}',
    64
  )
  createNatGateway: take(
    'lz-vend-nat-gw-create-${uniqueString(subscriptionId, virtualNetworkResourceGroupName, virtualNetworkName, deployment().name)}',
    64
  )
  createDsFilePrivateDnsZone: take(
    'lz-vend-ds-pdns-create-${uniqueString(subscriptionId, deploymentScriptResourceGroupName,deploymentScriptLocation,deploymentScriptStorageAccountName, deploymentScriptVirtualNetworkName, deployment().name)}',
    64
  )
}

// Role Assignments filtering and splitting
var roleAssignmentsSubscription = filter(
  roleAssignments,
  assignment => !contains(assignment.relativeScope, '/resourceGroups/')
)
var roleAssignmentsResourceGroups = filter(
  roleAssignments,
  assignment => contains(assignment.relativeScope, '/resourceGroups/')
)
var roleAssignmentsResourceGroupSelf = filter(
  roleAssignmentsResourceGroups,
  assignment => contains(assignment.relativeScope, '/resourceGroups/${virtualNetworkResourceGroupName}')
)
var roleAssignmentsResourceGroupNotSelf = filter(
  roleAssignmentsResourceGroups,
  assignment => !contains(assignment.relativeScope, '/resourceGroups/${virtualNetworkResourceGroupName}')
)

// PIM Role Assignments filtering and splitting
var pimRoleAssignmentsSubscription = filter(
  pimRoleAssignments,
  assignment => !contains(assignment.relativeScope, '/resourceGroups/')
)
var pimRoleAssignmentsResourceGroups = filter(
  pimRoleAssignments,
  assignment => contains(assignment.relativeScope, '/resourceGroups/')
)
var pimRoleAssignmentsResourceGroupSelf = filter(
  pimRoleAssignmentsResourceGroups,
  assignment => contains(assignment.relativeScope, '/resourceGroups/${virtualNetworkResourceGroupName}')
)
var pimRoleAssignmentsResourceGroupNotSelf = filter(
  pimRoleAssignmentsResourceGroups,
  assignment => !contains(assignment.relativeScope, '/resourceGroups/${virtualNetworkResourceGroupName}')
)

// UMI Role Assignments filtering and splitting
var umiRoleAssignmentsSubscription = [
  for (item, i) in userAssignedManagedIdentities: filter(
    item.?roleAssignments ?? [],
    assignment => !contains(assignment.relativeScope, '/resourceGroups/')
  )
]

var umiRoleAssignmentsSubscriptionFlattened = flatten(umiRoleAssignmentsSubscription)

var umiRoleAssignmentsResourceGroups = [
  for (item, i) in userAssignedManagedIdentities: filter(
    item.?roleAssignments ?? [],
    assignment => contains(assignment.relativeScope, '/resourceGroups/')
  )
]

var umiRoleAssignmentsResourceGroupsFlattened = flatten(umiRoleAssignmentsResourceGroups)

var umiRoleAssignmentsResourceGroupSelf = [
  for (item, i) in userAssignedManagedIdentities: filter(
    umiRoleAssignmentsResourceGroupsFlattened,
    assignment => contains(assignment.relativeScope, '/resourceGroups/${virtualNetworkResourceGroupName}')
  )
]

var umiRoleAssignmentsResourceGroupSelfFlattened = flatten(umiRoleAssignmentsResourceGroupSelf)

var umiRoleAssignmentsResourceGroupNotSelf = [
  for (item, i) in userAssignedManagedIdentities: filter(
    umiRoleAssignmentsResourceGroupsFlattened,
    assignment => !contains(assignment.relativeScope, '/resourceGroups/${virtualNetworkResourceGroupName}')
  )
]

var umiRoleAssignmentsResourceGroupNotSelfFlattened = flatten(umiRoleAssignmentsResourceGroupNotSelf)

// Check hubNetworkResourceId to see if it's a virtual WAN connection instead of normal virtual network peering
var virtualHubResourceIdChecked = (!empty(hubNetworkResourceId) && contains(
    hubNetworkResourceId,
    '/providers/Microsoft.Network/virtualHubs/'
  )
  ? hubNetworkResourceId
  : '')
var hubVirtualNetworkResourceIdChecked = (!empty(hubNetworkResourceId) && contains(
    hubNetworkResourceId,
    '/providers/Microsoft.Network/virtualNetworks/'
  )
  ? hubNetworkResourceId
  : '')

// Virtual WAN data
var virtualWanHubName = (!empty(virtualHubResourceIdChecked) ? split(virtualHubResourceIdChecked, '/')[8] : '')
var virtualWanHubSubscriptionId = (!empty(virtualHubResourceIdChecked) ? split(virtualHubResourceIdChecked, '/')[2] : '')
var virtualWanHubResourceGroupName = (!empty(virtualHubResourceIdChecked)
  ? split(virtualHubResourceIdChecked, '/')[4]
  : '')
var virtualWanHubConnectionName = 'vhc-${virtualNetworkName}-${substring(guid(virtualHubResourceIdChecked, virtualNetworkName, virtualNetworkResourceGroupName, virtualNetworkLocation, subscriptionId), 0, 5)}'
var virtualWanHubConnectionAssociatedRouteTable = !empty(virtualNetworkVwanAssociatedRouteTableResourceId)
  ? virtualNetworkVwanAssociatedRouteTableResourceId
  : '${virtualHubResourceIdChecked}/hubRouteTables/defaultRouteTable'
var virutalWanHubDefaultRouteTableId = {
  id: '${virtualHubResourceIdChecked}/hubRouteTables/defaultRouteTable'
}
var virtualWanHubConnectionPropogatedRouteTables = !empty(virtualNetworkVwanPropagatedRouteTablesResourceIds)
  ? virtualNetworkVwanPropagatedRouteTablesResourceIds
  : array(virutalWanHubDefaultRouteTableId)
var virtualWanHubConnectionPropogatedLabels = !empty(virtualNetworkVwanPropagatedLabels)
  ? virtualNetworkVwanPropagatedLabels
  : ['default']

var resourceProvidersFormatted = replace(string(resourceProviders), '"', '\\"')

var nsgArrayFormatted = !empty(additionalVirtualNetworks)
  ? flatten(map(
      additionalVirtualNetworks,
      vnet =>
        map(vnet.?subnets ?? [], subnet => {
          vnetResourceGroupName: vnet.resourceGroupName
          subnetName: subnet.name
          nsgName: subnet.?networkSecurityGroup.?name ?? 'nsg-${subnet.name}-${vnet.name}-${substring(guid(vnet.name ?? 'vnet', vnet.resourceGroupName, subnet.name), 0, 4)}'
          nsgLocation: subnet.?networkSecurityGroup.?location ?? vnet.location
          nsgRules: subnet.?networkSecurityGroup.?securityRules ?? null
          nsgTags: subnet.?networkSecurityGroup.?tags ?? null
        })
    ))
  : []

var allVirtualNetworks = (virtualNetworkEnabled && !empty(virtualNetworkName) && !empty(virtualNetworkAddressSpace) && !empty(virtualNetworkLocation) && !empty(virtualNetworkResourceGroupName))
  ? concat(
      [
        {
          name: virtualNetworkName
          resourceGroupName: virtualNetworkResourceGroupName
          location: virtualNetworkLocation
          addressPrefixes: virtualNetworkAddressSpace
        }
      ],
      additionalVirtualNetworks
    )
  : additionalVirtualNetworks

var peeringCombinations = !empty(allVirtualNetworks) && peerAllVirtualNetworks
  ? flatten(map(
      allVirtualNetworks,
      (sourceVnet, sourceIndex) =>
        map(
          filter(allVirtualNetworks, (targetVnet, targetIndex) => sourceIndex != targetIndex),
          (targetVnet, targetIndex) => {
            sourceName: sourceVnet.name
            targetName: targetVnet.name
            sourceResourceGroupName: sourceVnet.resourceGroupName
            targetResourceGroupName: targetVnet.resourceGroupName
            sourceIndex: sourceIndex
            targetIndex: indexOf(allVirtualNetworks, targetVnet)
            peeringName: 'peer-${sourceVnet.name}-to-${targetVnet.name}'
          }
        )
    ))
  : []

// RESOURCES & MODULES

@batchSize(1)
#disable-next-line no-deployments-resources
resource moveSubscriptionToManagementGroupDelay 'Microsoft.Resources/deployments@2024-03-01' = [
  for (cycle, i) in range(0, managementGroupAssociationDelayCount): if (subscriptionManagementGroupAssociationEnabled && !empty(subscriptionManagementGroupId)) {
    name: '${deploymentNames.moveSubscriptionToManagementGroupDelay}-${i}'
    location: virtualNetworkLocation
    properties: {
      mode: 'Incremental'
      template: {
        '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
        contentVersion: '1.0.0.0'
        resources: []
      }
    }
  }
]

module moveSubscriptionToManagementGroup './managementGroupSubscription.bicep' = if (subscriptionManagementGroupAssociationEnabled && !empty(subscriptionManagementGroupId)) {
  scope: managementGroup(subscriptionManagementGroupId)
  dependsOn: [
    moveSubscriptionToManagementGroupDelay
    registerResourceProviders
  ]
  name: deploymentNames.moveSubscriptionToManagementGroup
  params: {
    subscriptionManagementGroupId: subscriptionManagementGroupId
    subscriptionId: subscriptionId
  }
}

module tagSubscription 'tags.bicep' = if (!empty(subscriptionTags)) {
  scope: subscription(subscriptionId)
  name: deploymentNames.tagSubscription
  params: {
    subscriptionId: subscriptionId
    onlyUpdate: true
    tags: subscriptionTags
  }
}
module createResourceGroupForLzNetworking 'br/public:avm/res/resources/resource-group:0.4.1' = if (virtualNetworkEnabled && !empty(virtualNetworkLocation) && !empty(virtualNetworkResourceGroupName)) {
  scope: subscription(subscriptionId)
  name: deploymentNames.createResourceGroupForLzNetworking
  params: {
    name: virtualNetworkResourceGroupName
    location: virtualNetworkLocation
    lock: virtualNetworkResourceGroupLockEnabled
      ? {
          kind: 'CanNotDelete'
          name: 'CanNotDelete'
        }
      : null
    tags: virtualNetworkResourceGroupTags
    enableTelemetry: enableTelemetry
  }
}

module createResourceGroupForIdentities 'br/public:avm/res/resources/resource-group:0.4.1' = if (!empty(userAssignedManagedIdentities)) {
  scope: subscription(subscriptionId)
  name: deploymentNames.createResourceGroupForIdentities
  params: {
    name: userAssignedIdentityResourceGroupName
    location: virtualNetworkLocation
    lock: userAssignedIdentitiesResourceGroupLockEnabled
      ? {
          kind: 'CanNotDelete'
          name: 'CanNotDelete'
        }
      : null
    tags: subscriptionTags
    enableTelemetry: enableTelemetry
  }
}

module tagResourceGroup 'tags.bicep' = if (virtualNetworkEnabled && !empty(virtualNetworkLocation) && !empty(virtualNetworkResourceGroupName) && !empty(virtualNetworkResourceGroupTags)) {
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
  }
}

module createLzVnet 'br/public:avm/res/network/virtual-network:0.7.0' = if (virtualNetworkEnabled && !empty(virtualNetworkName) && !empty(virtualNetworkAddressSpace) && !empty(virtualNetworkLocation) && !empty(virtualNetworkResourceGroupName)) {
  dependsOn: [
    createResourceGroupForLzNetworking
    createLzRouteTable
  ]
  scope: resourceGroup(subscriptionId, virtualNetworkResourceGroupName)
  name: deploymentNames.createLzVnet
  params: {
    name: virtualNetworkName
    tags: virtualNetworkTags
    location: virtualNetworkLocation
    addressPrefixes: virtualNetworkAddressSpace
    dnsServers: virtualNetworkDnsServers
    ddosProtectionPlanResourceId: virtualNetworkDdosPlanResourceId
    peerings: (virtualNetworkEnabled && virtualNetworkPeeringEnabled && !empty(hubVirtualNetworkResourceIdChecked) && !empty(virtualNetworkName) && !empty(virtualNetworkAddressSpace) && !empty(virtualNetworkLocation) && !empty(virtualNetworkResourceGroupName))
      ? [
          {
            remoteVirtualNetworkResourceId: hubVirtualNetworkResourceIdChecked
            allowForwardedTraffic: true
            allowVirtualNetworkAccess: true
            allowGatewayTransit: false
            useRemoteGateways: virtualNetworkUseRemoteGateways
            remotePeeringEnabled: virtualNetworkPeeringEnabled
            remotePeeringAllowForwardedTraffic: true
            remotePeeringAllowVirtualNetworkAccess: true
            remotePeeringAllowGatewayTransit: true
            remotePeeringUseRemoteGateways: false
          }
        ]
      : null
    subnets: [
      for (subnet, i) in virtualNetworkSubnets: (!empty(virtualNetworkSubnets))
        ? {
            name: subnet.name
            addressPrefix: subnet.?addressPrefix
            networkSecurityGroupResourceId: (virtualNetworkDeployBastion || subnet.name == 'AzureBastionSubnet')
              ? createBastionNsg.?outputs.resourceId
              : resourceId(
                  subscriptionId,
                  virtualNetworkResourceGroupName,
                  'Microsoft.Network/networkSecurityGroups',
                  '${createLzNsg[i].?outputs.name}'
                )
            routeTableResourceId: (!empty(subnet.?routeTableName) && !empty(routeTablesResourceGroupName))
              ? resourceId(
                  subscriptionId,
                  routeTablesResourceGroupName,
                  'Microsoft.Network/routeTables',
                  subnet.?routeTableName ?? ''
                )
              : null
            natGatewayResourceId: virtualNetworkDeployNatGateway && (subnet.?associateWithNatGateway ?? false)
              ? createNatGateway.?outputs.resourceId
              : null
            delegation: subnet.?delegation
          }
        : {}
    ]
    enableTelemetry: enableTelemetry
  }
}

module createBastionNsg 'br/public:avm/res/network/network-security-group:0.5.1' = if (virtualNetworkDeployBastion && !empty(virtualNetworkName) && !empty(virtualNetworkAddressSpace) && !empty(virtualNetworkLocation) && !empty(virtualNetworkResourceGroupName)) {
  scope: resourceGroup(subscriptionId, virtualNetworkResourceGroupName)
  dependsOn: [
    createResourceGroupForLzNetworking
  ]
  name: deploymentNames.createBastionNsg
  params: {
    name: 'nsg-${virtualNetworkLocation}-bastion'
    location: virtualNetworkLocation
    securityRules: [
      // Inbound Rules
      {
        name: 'AllowHttpsInbound'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          priority: 120
          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: '*'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
        }
      }
      {
        name: 'AllowGatewayManagerInbound'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          priority: 130
          sourceAddressPrefix: 'GatewayManager'
          destinationAddressPrefix: '*'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
        }
      }
      {
        name: 'AllowAzureLoadBalancerInbound'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          priority: 140
          sourceAddressPrefix: 'AzureLoadBalancer'
          destinationAddressPrefix: '*'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
        }
      }
      {
        name: 'AllowBastionHostCommunication'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          priority: 150
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'VirtualNetwork'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRanges: [
            '8080'
            '5701'
          ]
        }
      }
      {
        name: 'DenyAllInbound'
        properties: {
          access: 'Deny'
          direction: 'Inbound'
          priority: 4096
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
        }
      }
      // Outbound Rules
      {
        name: 'AllowSshRdpOutbound'
        properties: {
          access: 'Allow'
          direction: 'Outbound'
          priority: 100
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'VirtualNetwork'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRanges: ['22', '3389']
        }
      }
      {
        name: 'AllowAzureCloudOutbound'
        properties: {
          access: 'Allow'
          direction: 'Outbound'
          priority: 110
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'AzureCloud'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
        }
      }
      {
        name: 'AllowBastionCommunication'
        properties: {
          access: 'Allow'
          direction: 'Outbound'
          priority: 120
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'VirtualNetwork'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRanges: [
            '8080'
            '5701'
          ]
        }
      }
      {
        name: 'AllowGetSessionInformation'
        properties: {
          access: 'Allow'
          direction: 'Outbound'
          priority: 130
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'Internet'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '80'
        }
      }
      {
        name: 'DenyAllOutbound'
        properties: {
          access: 'Deny'
          direction: 'Outbound'
          priority: 4096
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
        }
      }
    ]
    enableTelemetry: enableTelemetry
  }
}

module createLzNsg 'br/public:avm/res/network/network-security-group:0.5.1' = [
  for (subnet, i) in virtualNetworkSubnets: if (!empty(virtualNetworkSubnets)) {
    scope: resourceGroup(subscriptionId, virtualNetworkResourceGroupName)
    dependsOn: [
      createResourceGroupForLzNetworking
    ]
    name: '${deploymentNames.createLzNsg}-${i}'
    params: {
      name: subnet.?networkSecurityGroup.name ?? 'nsg-${subnet.name}-${substring(guid(virtualNetworkName, virtualNetworkResourceGroupName, subnet.name, subscriptionId), 0, 5)}'
      location: virtualNetworkLocation
      securityRules: subnet.?networkSecurityGroup.?securityRules ?? null
      enableTelemetry: enableTelemetry
    }
  }
]

module createLzRouteTable 'br/public:avm/res/network/route-table:0.4.1' = [
  for (routeTable, i) in routeTables: if (!empty(routeTables) && !empty(routeTablesResourceGroupName)) {
    scope: resourceGroup(subscriptionId, routeTablesResourceGroupName)
    dependsOn: [
      createResourceGroupForRouteTables
    ]
    name: '${deploymentNames.createLzRouteTable}-${i}'
    params: {
      name: routeTable.name
      location: routeTable.location
      routes: routeTable.?routes ?? []
      enableTelemetry: enableTelemetry
    }
  }
]

module createAdditionalVnetNsgs 'br/public:avm/res/network/network-security-group:0.5.1' = [
  for (nsg, i) in nsgArrayFormatted: if (!empty(additionalVirtualNetworks)) {
    scope: resourceGroup(subscriptionId, nsg.vnetResourceGroupName)
    dependsOn: [
      createResourceGroupForAdditionalLzNetworking
    ]
    params: {
      name: nsg.nsgName ?? 'nsg-${nsg.subnetName}-${substring(guid(nsg.vnetResourceGroupName, nsg.subnetName), 0, 5)}'
      securityRules: nsg.?nsgRules ?? null
      location: nsg.?nsgLocation ?? additionalVirtualNetworks[i].location
      tags: nsg.?nsgTags ?? null
      enableTelemetry: enableTelemetry
    }
  }
]

module createLzVirtualWanConnection 'hubVirtualNetworkConnections.bicep' = if (virtualNetworkEnabled && virtualNetworkPeeringEnabled && !empty(virtualHubResourceIdChecked) && !empty(virtualNetworkName) && !empty(virtualNetworkAddressSpace) && !empty(virtualNetworkLocation) && !empty(virtualNetworkResourceGroupName) && !empty(virtualWanHubResourceGroupName) && !empty(virtualWanHubSubscriptionId)) {
  dependsOn: [
    createResourceGroupForLzNetworking
    createLzVnet
  ]
  scope: resourceGroup(virtualWanHubSubscriptionId, virtualWanHubResourceGroupName)
  name: deploymentNames.createLzVirtualWanConnection
  params: {
    name: virtualWanHubConnectionName
    virtualHubName: virtualWanHubName
    remoteVirtualNetworkId: '/subscriptions/${subscriptionId}/resourceGroups/${virtualNetworkResourceGroupName}/providers/Microsoft.Network/virtualNetworks/${virtualNetworkName}'
    enableInternetSecurity: virtualNetworkVwanEnableInternetSecurity
    routingConfiguration: !vHubRoutingIntentEnabled
      ? {
          associatedRouteTable: {
            id: virtualWanHubConnectionAssociatedRouteTable
          }
          propagatedRouteTables: {
            ids: virtualWanHubConnectionPropogatedRouteTables
            labels: virtualWanHubConnectionPropogatedLabels
          }
        }
      : {}
  }
}

module createLzRoleAssignmentsSub 'br/public:avm/ptn/authorization/role-assignment:0.2.2' = [
  for assignment in roleAssignmentsSubscription: if (roleAssignmentEnabled && !empty(roleAssignmentsSubscription)) {
    name: take(
      '${deploymentNames.createLzRoleAssignmentsSub}-${uniqueString(assignment.principalId, assignment.definition, assignment.relativeScope)}',
      64
    )
    params: {
      location: virtualNetworkLocation
      principalId: assignment.principalId
      roleDefinitionIdOrName: assignment.definition
      principalType: assignment.?principalType
      subscriptionId: subscriptionId
      description: assignment.?description
      conditionVersion: !(empty(assignment.?roleAssignmentCondition ?? {}))
        ? (assignment.?roleAssignmentCondition.?conditionVersion ?? '2.0')
        : null
      condition: (empty(assignment.?roleAssignmentCondition ?? {}))
        ? null
        : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'constrainRoles' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
            ? generateCodeRolesType(any(assignment.?roleAssignmentCondition.?roleConditionType))
            : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'constrainRolesAndPrincipalTypes' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
                ? generateCodeRolesAndPrincipalsTypes(any(assignment.?roleAssignmentCondition.?roleConditionType))
                : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'constrainRolesAndPrincipals' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
                    ? generateCodeRolesAndPrincipals(any(assignment.?roleAssignmentCondition.?roleConditionType))
                    : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'excludeRoles' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
                        ? generateCodeExcludeRoles(any(assignment.?roleAssignmentCondition.?roleConditionType))
                        : !(empty(assignment.?roleAssignmentCondition.?delegationCode))
                            ? assignment.?roleAssignmentCondition.?delegationCode
                            : null
    }
  }
]

module createLzRoleAssignmentsRsgsSelf 'br/public:avm/ptn/authorization/role-assignment:0.2.2' = [
  for assignment in roleAssignmentsResourceGroupSelf: if (roleAssignmentEnabled && !empty(roleAssignmentsResourceGroupSelf)) {
    dependsOn: [
      createResourceGroupForLzNetworking
    ]
    name: take(
      '${deploymentNames.createLzRoleAssignmentsRsgsSelf}-${uniqueString(assignment.principalId, assignment.definition, assignment.relativeScope)}',
      64
    )
    params: {
      location: virtualNetworkLocation
      principalId: assignment.principalId
      roleDefinitionIdOrName: assignment.definition
      principalType: assignment.?principalType
      subscriptionId: subscriptionId
      resourceGroupName: split(assignment.relativeScope, '/')[2]
      description: assignment.?description
      conditionVersion: !(empty(assignment.?roleAssignmentCondition ?? {}))
        ? (assignment.?roleAssignmentCondition.?conditionVersion ?? '2.0')
        : null
      condition: (empty(assignment.?roleAssignmentCondition ?? {}))
        ? null
        : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'constrainRoles' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
            ? generateCodeRolesType(any(assignment.?roleAssignmentCondition.?roleConditionType))
            : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'constrainRolesAndPrincipalTypes' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
                ? generateCodeRolesAndPrincipalsTypes(any(assignment.?roleAssignmentCondition.?roleConditionType))
                : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'constrainRolesAndPrincipals' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
                    ? generateCodeRolesAndPrincipals(any(assignment.?roleAssignmentCondition.?roleConditionType))
                    : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'excludeRoles' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
                        ? generateCodeExcludeRoles(any(assignment.?roleAssignmentCondition.?roleConditionType))
                        : !(empty(assignment.?roleAssignmentCondition.?delegationCode))
                            ? assignment.?roleAssignmentCondition.?delegationCode
                            : null
    }
  }
]

module createLzRoleAssignmentsRsgsNotSelf 'br/public:avm/ptn/authorization/role-assignment:0.2.2' = [
  for assignment in roleAssignmentsResourceGroupNotSelf: if (roleAssignmentEnabled && !empty(roleAssignmentsResourceGroupNotSelf)) {
    name: take(
      '${deploymentNames.createLzRoleAssignmentsRsgsNotSelf}-${uniqueString(assignment.principalId, assignment.definition, assignment.relativeScope)}',
      64
    )
    params: {
      location: virtualNetworkLocation
      principalId: assignment.principalId
      roleDefinitionIdOrName: assignment.definition
      principalType: assignment.?principalType
      subscriptionId: subscriptionId
      resourceGroupName: split(assignment.relativeScope, '/')[2]
      description: assignment.?description
      conditionVersion: !(empty(assignment.?roleAssignmentCondition ?? {}))
        ? (assignment.?roleAssignmentCondition.?conditionVersion ?? '2.0')
        : null
      condition: (empty(assignment.?roleAssignmentCondition ?? {}))
        ? null
        : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'constrainRoles' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
            ? generateCodeRolesType(any(assignment.?roleAssignmentCondition.?roleConditionType))
            : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'constrainRolesAndPrincipalTypes' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
                ? generateCodeRolesAndPrincipalsTypes(any(assignment.?roleAssignmentCondition.?roleConditionType))
                : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'constrainRolesAndPrincipals' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
                    ? generateCodeRolesAndPrincipals(any(assignment.?roleAssignmentCondition.?roleConditionType))
                    : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'excludeRoles' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
                        ? generateCodeExcludeRoles(any(assignment.?roleAssignmentCondition.?roleConditionType))
                        : !(empty(assignment.?roleAssignmentCondition.?delegationCode))
                            ? assignment.?roleAssignmentCondition.?delegationCode
                            : null
    }
  }
]
module createLzUMIRoleAssignmentsSub 'br/public:avm/ptn/authorization/role-assignment:0.2.2' = [
  for (assignment, i) in umiRoleAssignmentsSubscriptionFlattened: if (roleAssignmentEnabled && !empty(umiRoleAssignmentsSubscriptionFlattened)) {
    name: take(
      '${deploymentNames.createLzUMIRoleAssignmentsSub}-${uniqueString(createUserAssignedManagedIdentity[i].name,assignment.definition, assignment.relativeScope)}',
      64
    )
    params: {
      location: deployment().location
      principalId: createUserAssignedManagedIdentity[i].?outputs.principalId
      roleDefinitionIdOrName: assignment.definition
      principalType: 'ServicePrincipal'
      subscriptionId: subscriptionId
      description: assignment.?description
      conditionVersion: !(empty(assignment.?roleAssignmentCondition ?? {}))
        ? (assignment.?roleAssignmentCondition.?conditionVersion ?? '2.0')
        : null
      condition: (empty(assignment.?roleAssignmentCondition ?? {}))
        ? null
        : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'constrainRoles' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
            ? generateCodeRolesType(any(assignment.?roleAssignmentCondition.?roleConditionType))
            : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'constrainRolesAndPrincipalTypes' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
                ? generateCodeRolesAndPrincipalsTypes(any(assignment.?roleAssignmentCondition.?roleConditionType))
                : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'constrainRolesAndPrincipals' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
                    ? generateCodeRolesAndPrincipals(any(assignment.?roleAssignmentCondition.?roleConditionType))
                    : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'excludeRoles' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
                        ? generateCodeExcludeRoles(any(assignment.?roleAssignmentCondition.?roleConditionType))
                        : !(empty(assignment.?roleAssignmentCondition.?delegationCode))
                            ? assignment.?roleAssignmentCondition.?delegationCode
                            : null
    }
  }
]

module createLzUMIRoleAssignmentsRsgsSelf 'br/public:avm/ptn/authorization/role-assignment:0.2.2' = [
  for (assignment, i) in umiRoleAssignmentsResourceGroupSelfFlattened: if (roleAssignmentEnabled && !empty(umiRoleAssignmentsResourceGroupSelfFlattened)) {
    name: take(
      '${deploymentNames.createLzUMIRoleAssignmentsRsgsSelf}-${uniqueString(createUserAssignedManagedIdentity[i].name,assignment.definition, assignment.relativeScope)}',
      64
    )
    params: {
      location: deployment().location
      principalId: createUserAssignedManagedIdentity[i].?outputs.principalId
      roleDefinitionIdOrName: assignment.definition
      principalType: 'ServicePrincipal'
      subscriptionId: subscriptionId
      resourceGroupName: split(assignment.relativeScope, '/')[2]
      description: assignment.?description
      conditionVersion: !(empty(assignment.?roleAssignmentCondition ?? {}))
        ? (assignment.?roleAssignmentCondition.?conditionVersion ?? '2.0')
        : null
      condition: (empty(assignment.?roleAssignmentCondition ?? {}))
        ? null
        : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'constrainRoles' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
            ? generateCodeRolesType(any(assignment.?roleAssignmentCondition.?roleConditionType))
            : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'constrainRolesAndPrincipalTypes' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
                ? generateCodeRolesAndPrincipalsTypes(any(assignment.?roleAssignmentCondition.?roleConditionType))
                : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'constrainRolesAndPrincipals' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
                    ? generateCodeRolesAndPrincipals(any(assignment.?roleAssignmentCondition.?roleConditionType))
                    : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'excludeRoles' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
                        ? generateCodeExcludeRoles(any(assignment.?roleAssignmentCondition.?roleConditionType))
                        : !(empty(assignment.?roleAssignmentCondition.?delegationCode))
                            ? assignment.?roleAssignmentCondition.?delegationCode
                            : null
    }
  }
]

module createLzUMIRoleAssignmentsRsgsNotSelf 'br/public:avm/ptn/authorization/role-assignment:0.2.2' = [
  for (assignment, i) in umiRoleAssignmentsResourceGroupNotSelfFlattened: if (roleAssignmentEnabled && !empty(umiRoleAssignmentsResourceGroupNotSelfFlattened)) {
    name: take(
      '${deploymentNames.createLzUMIRoleAssignmentsRsgsNotSelf}-${uniqueString(createUserAssignedManagedIdentity[i].name,assignment.definition, assignment.relativeScope)}',
      64
    )
    params: {
      location: deployment().location
      principalId: createUserAssignedManagedIdentity[i].?outputs.principalId
      roleDefinitionIdOrName: assignment.definition
      principalType: 'ServicePrincipal'
      subscriptionId: subscriptionId
      resourceGroupName: split(assignment.relativeScope, '/')[2]
      description: assignment.?description
      conditionVersion: !(empty(assignment.?roleAssignmentCondition ?? {}))
        ? (assignment.?roleAssignmentCondition.?conditionVersion ?? '2.0')
        : null
      condition: (empty(assignment.?roleAssignmentCondition ?? {}))
        ? null
        : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'constrainRoles' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
            ? generateCodeRolesType(any(assignment.?roleAssignmentCondition.?roleConditionType))
            : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'constrainRolesAndPrincipalTypes' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
                ? generateCodeRolesAndPrincipalsTypes(any(assignment.?roleAssignmentCondition.?roleConditionType))
                : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'constrainRolesAndPrincipals' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
                    ? generateCodeRolesAndPrincipals(any(assignment.?roleAssignmentCondition.?roleConditionType))
                    : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'excludeRoles' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
                        ? generateCodeExcludeRoles(any(assignment.?roleAssignmentCondition.?roleConditionType))
                        : !(empty(assignment.?roleAssignmentCondition.?delegationCode))
                            ? assignment.?roleAssignmentCondition.?delegationCode
                            : null
    }
  }
]

module createLzPimActiveRoleAssignmentsSub 'br/public:avm/ptn/authorization/pim-role-assignment:0.1.1' = [
  for assignment in pimRoleAssignmentsSubscription: if (roleAssignmentEnabled && !empty(pimRoleAssignmentsSubscription) && assignment.roleAssignmentType == 'Active') {
    name: take(
      '${deploymentNames.createLzPimRoleAssignmentsSub}-${uniqueString(assignment.principalId, assignment.definition, assignment.relativeScope)}',
      64
    )
    params: {
      pimRoleAssignmentType: {
        roleAssignmentType: 'Active'
        scheduleInfo: assignment.scheduleInfo
      }
      principalId: assignment.principalId
      requestType: assignment.?requestType ?? 'AdminUpdate'
      roleDefinitionIdOrName: assignment.definition
      justification: assignment.?justification ?? null
      enableTelemetry: enableTelemetry
      ticketInfo: assignment.?ticketInfo ?? null
      subscriptionId: subscriptionId
      conditionVersion: !(empty(assignment.?roleAssignmentCondition ?? {}))
        ? (assignment.?roleAssignmentCondition.?conditionVersion ?? '2.0')
        : null
      condition: (empty(assignment.?roleAssignmentCondition ?? {}))
        ? null
        : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'constrainRoles' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
            ? generateCodeRolesType(any(assignment.?roleAssignmentCondition.?roleConditionType))
            : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'constrainRolesAndPrincipalTypes' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
                ? generateCodeRolesAndPrincipalsTypes(any(assignment.?roleAssignmentCondition.?roleConditionType))
                : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'constrainRolesAndPrincipals' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
                    ? generateCodeRolesAndPrincipals(any(assignment.?roleAssignmentCondition.?roleConditionType))
                    : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'excludeRoles' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
                        ? generateCodeExcludeRoles(any(assignment.?roleAssignmentCondition.?roleConditionType))
                        : !(empty(assignment.?roleAssignmentCondition.?delegationCode))
                            ? assignment.?roleAssignmentCondition.?delegationCode
                            : null
    }
  }
]

module createLzPimEligibleRoleAssignmentsSub 'br/public:avm/ptn/authorization/pim-role-assignment:0.1.1' = [
  for assignment in pimRoleAssignmentsSubscription: if (roleAssignmentEnabled && !empty(pimRoleAssignmentsSubscription) && assignment.roleAssignmentType == 'Eligible') {
    name: take(
      '${deploymentNames.createLzPimRoleAssignmentsSub}-${uniqueString(assignment.principalId, assignment.definition, assignment.relativeScope)}',
      64
    )
    params: {
      pimRoleAssignmentType: {
        roleAssignmentType: 'Eligible'
        scheduleInfo: assignment.scheduleInfo
      }
      subscriptionId: subscriptionId
      principalId: assignment.principalId
      requestType: assignment.?requestType ?? 'AdminUpdate'
      roleDefinitionIdOrName: assignment.definition
      justification: assignment.?justification ?? null
      enableTelemetry: enableTelemetry
      ticketInfo: assignment.?ticketInfo ?? null
      conditionVersion: !(empty(assignment.?roleAssignmentCondition ?? {}))
        ? (assignment.?roleAssignmentCondition.?conditionVersion ?? '2.0')
        : null
      condition: (empty(assignment.?roleAssignmentCondition ?? {}))
        ? null
        : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'constrainRoles' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
            ? generateCodeRolesType(any(assignment.?roleAssignmentCondition.?roleConditionType))
            : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'constrainRolesAndPrincipalTypes' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
                ? generateCodeRolesAndPrincipalsTypes(any(assignment.?roleAssignmentCondition.?roleConditionType))
                : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'constrainRolesAndPrincipals' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
                    ? generateCodeRolesAndPrincipals(any(assignment.?roleAssignmentCondition.?roleConditionType))
                    : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'excludeRoles' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
                        ? generateCodeExcludeRoles(any(assignment.?roleAssignmentCondition.?roleConditionType))
                        : !(empty(assignment.?roleAssignmentCondition.?delegationCode))
                            ? assignment.?roleAssignmentCondition.?delegationCode
                            : null
    }
  }
]

module createLzPimEligibleRoleAssignmentsRsgsSelf 'br/public:avm/ptn/authorization/pim-role-assignment:0.1.1' = [
  for assignment in pimRoleAssignmentsResourceGroupSelf: if (roleAssignmentEnabled && !empty(pimRoleAssignmentsResourceGroupSelf) && assignment.roleAssignmentType == 'Eligible') {
    dependsOn: [
      createResourceGroupForLzNetworking
    ]
    name: take(
      '${deploymentNames.createLzPimRoleAssignmentsRsgsSelf}-${uniqueString(assignment.principalId, assignment.definition, assignment.relativeScope)}',
      64
    )
    params: {
      pimRoleAssignmentType: {
        roleAssignmentType: 'Eligible'
        scheduleInfo: assignment.scheduleInfo
      }
      subscriptionId: subscriptionId
      requestType: assignment.?requestType ?? 'AdminUpdate'
      resourceGroupName: split(assignment.relativeScope, '/')[2]
      principalId: assignment.principalId
      roleDefinitionIdOrName: assignment.definition
      justification: assignment.?justification ?? null
      enableTelemetry: enableTelemetry
      ticketInfo: assignment.?ticketInfo ?? null
      conditionVersion: !(empty(assignment.?roleAssignmentCondition ?? {}))
        ? (assignment.?roleAssignmentCondition.?conditionVersion ?? '2.0')
        : null
      condition: (empty(assignment.?roleAssignmentCondition ?? {}))
        ? null
        : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'constrainRoles' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
            ? generateCodeRolesType(any(assignment.?roleAssignmentCondition.?roleConditionType))
            : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'constrainRolesAndPrincipalTypes' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
                ? generateCodeRolesAndPrincipalsTypes(any(assignment.?roleAssignmentCondition.?roleConditionType))
                : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'constrainRolesAndPrincipals' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
                    ? generateCodeRolesAndPrincipals(any(assignment.?roleAssignmentCondition.?roleConditionType))
                    : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'excludeRoles' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
                        ? generateCodeExcludeRoles(any(assignment.?roleAssignmentCondition.?roleConditionType))
                        : !(empty(assignment.?roleAssignmentCondition.?delegationCode))
                            ? assignment.?roleAssignmentCondition.?delegationCode
                            : null
    }
  }
]

module createLzPimActiveRoleAssignmentsRsgsSelf 'br/public:avm/ptn/authorization/pim-role-assignment:0.1.1' = [
  for assignment in pimRoleAssignmentsResourceGroupSelf: if (roleAssignmentEnabled && !empty(pimRoleAssignmentsResourceGroupSelf) && assignment.roleAssignmentType == 'Active') {
    dependsOn: [
      createResourceGroupForLzNetworking
    ]
    name: take(
      '${deploymentNames.createLzPimRoleAssignmentsRsgsSelf}-${uniqueString(assignment.principalId, assignment.definition, assignment.relativeScope)}',
      64
    )
    params: {
      pimRoleAssignmentType: {
        roleAssignmentType: 'Active'
        scheduleInfo: assignment.scheduleInfo
      }
      subscriptionId: subscriptionId
      requestType: assignment.?requestType ?? 'AdminUpdate'
      resourceGroupName: split(assignment.relativeScope, '/')[2]
      principalId: assignment.principalId
      roleDefinitionIdOrName: assignment.definition
      justification: assignment.?justification ?? null
      enableTelemetry: enableTelemetry
      ticketInfo: assignment.?ticketInfo ?? null
      conditionVersion: !(empty(assignment.?roleAssignmentCondition ?? {}))
        ? (assignment.?roleAssignmentCondition.?conditionVersion ?? '2.0')
        : null
      condition: (empty(assignment.?roleAssignmentCondition ?? {}))
        ? null
        : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'constrainRoles' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
            ? generateCodeRolesType(any(assignment.?roleAssignmentCondition.?roleConditionType))
            : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'constrainRolesAndPrincipalTypes' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
                ? generateCodeRolesAndPrincipalsTypes(any(assignment.?roleAssignmentCondition.?roleConditionType))
                : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'constrainRolesAndPrincipals' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
                    ? generateCodeRolesAndPrincipals(any(assignment.?roleAssignmentCondition.?roleConditionType))
                    : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'excludeRoles' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
                        ? generateCodeExcludeRoles(any(assignment.?roleAssignmentCondition.?roleConditionType))
                        : !(empty(assignment.?roleAssignmentCondition.?delegationCode))
                            ? assignment.?roleAssignmentCondition.?delegationCode
                            : null
    }
  }
]

module createLzEliglblePimRoleAssignmentsRsgsNotSelf 'br/public:avm/ptn/authorization/pim-role-assignment:0.1.1' = [
  for assignment in pimRoleAssignmentsResourceGroupNotSelf: if (roleAssignmentEnabled && !empty(pimRoleAssignmentsResourceGroupNotSelf) && assignment.roleAssignmentType == 'Eligible') {
    name: take(
      '${deploymentNames.createLzPimRoleAssignmentsRsgsNotSelf}-${uniqueString(assignment.principalId, assignment.definition, assignment.relativeScope)}',
      64
    )
    params: {
      pimRoleAssignmentType: {
        roleAssignmentType: 'Eligible'
        scheduleInfo: assignment.scheduleInfo
      }
      subscriptionId: subscriptionId
      principalId: assignment.principalId
      requestType: assignment.?requestType ?? 'AdminUpdate'
      roleDefinitionIdOrName: assignment.definition
      justification: assignment.?justification ?? null
      enableTelemetry: enableTelemetry
      ticketInfo: assignment.?ticketInfo ?? null
      conditionVersion: !(empty(assignment.?roleAssignmentCondition ?? {}))
        ? (assignment.?roleAssignmentCondition.?conditionVersion ?? '2.0')
        : null
      condition: (empty(assignment.?roleAssignmentCondition ?? {}))
        ? null
        : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'constrainRoles' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
            ? generateCodeRolesType(any(assignment.?roleAssignmentCondition.?roleConditionType))
            : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'constrainRolesAndPrincipalTypes' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
                ? generateCodeRolesAndPrincipalsTypes(any(assignment.?roleAssignmentCondition.?roleConditionType))
                : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'constrainRolesAndPrincipals' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
                    ? generateCodeRolesAndPrincipals(any(assignment.?roleAssignmentCondition.?roleConditionType))
                    : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'excludeRoles' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
                        ? generateCodeExcludeRoles(any(assignment.?roleAssignmentCondition.?roleConditionType))
                        : !(empty(assignment.?roleAssignmentCondition.?delegationCode))
                            ? assignment.?roleAssignmentCondition.?delegationCode
                            : null
    }
  }
]

module createLzActivePimRoleAssignmentsRsgsNotSelf 'br/public:avm/ptn/authorization/pim-role-assignment:0.1.1' = [
  for assignment in pimRoleAssignmentsResourceGroupNotSelf: if (roleAssignmentEnabled && !empty(pimRoleAssignmentsResourceGroupNotSelf) && assignment.roleAssignmentType == 'Active') {
    name: take(
      '${deploymentNames.createLzPimRoleAssignmentsRsgsNotSelf}-${uniqueString(assignment.principalId, assignment.definition, assignment.relativeScope)}',
      64
    )
    params: {
      pimRoleAssignmentType: {
        roleAssignmentType: 'Active'
        scheduleInfo: assignment.scheduleInfo
      }
      subscriptionId: subscriptionId
      principalId: assignment.principalId
      requestType: assignment.?requestType ?? 'AdminUpdate'
      roleDefinitionIdOrName: assignment.definition
      justification: assignment.?justification ?? null
      enableTelemetry: enableTelemetry
      ticketInfo: assignment.?ticketInfo ?? null
      conditionVersion: !(empty(assignment.?roleAssignmentCondition ?? {}))
        ? (assignment.?roleAssignmentCondition.?conditionVersion ?? '2.0')
        : null
      condition: (empty(assignment.?roleAssignmentCondition ?? {}))
        ? null
        : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'constrainRoles' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
            ? generateCodeRolesType(any(assignment.?roleAssignmentCondition.?roleConditionType))
            : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'constrainRolesAndPrincipalTypes' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
                ? generateCodeRolesAndPrincipalsTypes(any(assignment.?roleAssignmentCondition.?roleConditionType))
                : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'constrainRolesAndPrincipals' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
                    ? generateCodeRolesAndPrincipals(any(assignment.?roleAssignmentCondition.?roleConditionType))
                    : assignment.?roleAssignmentCondition.?roleConditionType.templateName == 'excludeRoles' && (empty(assignment.?roleAssignmentCondition.?delegationCode))
                        ? generateCodeExcludeRoles(any(assignment.?roleAssignmentCondition.?roleConditionType))
                        : !(empty(assignment.?roleAssignmentCondition.?delegationCode))
                            ? assignment.?roleAssignmentCondition.?delegationCode
                            : null
    }
  }
]

module createResourceGroupForDeploymentScript 'br/public:avm/res/resources/resource-group:0.4.1' = if (!empty(resourceProviders)) {
  scope: subscription(subscriptionId)
  name: deploymentNames.createResourceGroupForDeploymentScript
  params: {
    name: deploymentScriptResourceGroupName
    location: deploymentScriptLocation
    tags: subscriptionTags
    enableTelemetry: enableTelemetry
  }
}

module createResourceGroupForRouteTables 'br/public:avm/res/resources/resource-group:0.4.1' = if (!empty(routeTablesResourceGroupName) && !empty(routeTables)) {
  scope: subscription(subscriptionId)
  name: deploymentNames.createResourceGroupForRouteTables
  params: {
    name: routeTablesResourceGroupName
    location: virtualNetworkLocation ?? deployment().location
    tags: virtualNetworkResourceGroupTags
    enableTelemetry: enableTelemetry
  }
}

module createManagedIdentityForDeploymentScript 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.1' = if (!empty(resourceProviders)) {
  scope: resourceGroup(subscriptionId, deploymentScriptResourceGroupName)
  name: deploymentNames.createDeploymentScriptManagedIdentity
  dependsOn: [
    createResourceGroupForDeploymentScript
  ]
  params: {
    location: deploymentScriptLocation
    name: deploymentScriptManagedIdentityName
    enableTelemetry: enableTelemetry
  }
}

module createRoleAssignmentsDeploymentScript 'br/public:avm/ptn/authorization/role-assignment:0.2.2' = if (!empty(resourceProviders)) {
  name: take('${deploymentNames.createRoleAssignmentsDeploymentScript}', 64)
  params: {
    location: deploymentScriptLocation
    principalId: !empty(resourceProviders) ? createManagedIdentityForDeploymentScript.?outputs.principalId ?? '' : ''
    roleDefinitionIdOrName: 'Contributor'
    subscriptionId: subscriptionId
    principalType: 'ServicePrincipal'
  }
}

module createRoleAssignmentsDeploymentScriptStorageAccount 'br/public:avm/ptn/authorization/role-assignment:0.2.2' = if (!empty(resourceProviders)) {
  name: take('${deploymentNames.createRoleAssignmentsDeploymentScriptStorageAccount}', 64)
  params: {
    location: deploymentScriptLocation
    principalId: !empty(resourceProviders) ? createManagedIdentityForDeploymentScript.?outputs.principalId ?? '' : ''
    roleDefinitionIdOrName: '/providers/Microsoft.Authorization/roleDefinitions/69566ab7-960f-475b-8e7c-b3118f30c6bd'
    subscriptionId: subscriptionId
    resourceGroupName: deploymentScriptResourceGroupName
    principalType: 'ServicePrincipal'
    description: 'Storage File Data Privileged Contributor'
  }
}

module createDsNsg 'br/public:avm/res/network/network-security-group:0.5.1' = if (!empty(resourceProviders)) {
  scope: resourceGroup(subscriptionId, deploymentScriptResourceGroupName)
  dependsOn: [
    createResourceGroupForDeploymentScript
  ]
  name: deploymentNames.createDsNsg
  params: {
    name: deploymentScriptNetworkSecurityGroupName
    location: deploymentScriptLocation
    enableTelemetry: enableTelemetry
  }
}

module dsFilePrivateDNSZone 'br/public:avm/res/network/private-dns-zone:0.7.1' = if (!empty(resourceProviders)) {
  name: deploymentNames.createDsFilePrivateDnsZone
  scope: resourceGroup(subscriptionId, deploymentScriptResourceGroupName)
  params: {
    name: 'privatelink.file.${environment().suffixes.storage}'
    location: 'global'
    virtualNetworkLinks: [
      {
        registrationEnabled: false
        virtualNetworkResourceId: createDsVnet.?outputs.resourceId ?? ''
      }
    ]
  }
}

module createDsStorageAccount 'br/public:avm/res/storage/storage-account:0.25.1' = if (!empty(resourceProviders)) {
  dependsOn: [
    createRoleAssignmentsDeploymentScriptStorageAccount
  ]
  scope: resourceGroup(subscriptionId, deploymentScriptResourceGroupName)
  name: deploymentNames.createDsStorageAccount
  params: {
    location: deploymentScriptLocation
    name: deploymentScriptStorageAccountName
    kind: 'StorageV2'
    skuName: 'Standard_LRS'
    publicNetworkAccess: 'Disabled'
    allowSharedKeyAccess: true
    privateEndpoints: [
      {
        service: 'file'
        subnetResourceId: filter(
          createDsVnet.?outputs.subnetResourceIds ?? [],
          subnetResourceId => contains(subnetResourceId, 'ds-pe-subnet')
        )[0]
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: dsFilePrivateDNSZone.?outputs.resourceId ?? ''
            }
          ]
        }
        name: 'ds-file-pe'
      }
    ]
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
    }
    enableTelemetry: enableTelemetry
  }
}

module createDsVnet 'br/public:avm/res/network/virtual-network:0.7.0' = if (!empty(resourceProviders)) {
  scope: resourceGroup(subscriptionId, deploymentScriptResourceGroupName)
  name: deploymentNames.createdsVnet
  params: {
    name: deploymentScriptVirtualNetworkName
    location: deploymentScriptLocation
    addressPrefixes: [
      virtualNetworkDeploymentScriptAddressPrefix
    ]
    subnets: !empty(resourceProviders)
      ? [
          {
            addressPrefix: !empty(resourceProviders)
              ? cidrSubnet(virtualNetworkDeploymentScriptAddressPrefix, 25, 0)
              : null
            name: 'ds-subnet'
            networkSecurityGroupResourceId: !empty(resourceProviders) ? createDsNsg.?outputs.resourceId : null
            delegation: 'Microsoft.ContainerInstance/containerGroups'
          }
          {
            name: 'ds-pe-subnet'
            addressPrefix: !empty(resourceProviders)
              ? cidrSubnet(virtualNetworkDeploymentScriptAddressPrefix, 25, 1)
              : null
            networkSecurityGroupResourceId: !empty(resourceProviders) ? createDsNsg.?outputs.resourceId : null
          }
        ]
      : null
    enableTelemetry: enableTelemetry
  }
}
module registerResourceProviders 'br/public:avm/res/resources/deployment-script:0.2.3' = if (!empty(resourceProviders)) {
  scope: resourceGroup(subscriptionId, deploymentScriptResourceGroupName)
  name: deploymentNames.registerResourceProviders
  params: {
    name: deploymentScriptName
    kind: 'AzurePowerShell'
    azPowerShellVersion: '12.3'
    cleanupPreference: 'Always'
    enableTelemetry: enableTelemetry
    location: deploymentScriptLocation
    retentionInterval: 'P1D'
    timeout: 'PT1H'
    runOnce: true
    managedIdentities: !(empty(resourceProviders))
      ? {
          userAssignedResourcesIds: [
            createManagedIdentityForDeploymentScript.?outputs.resourceId ?? ''
          ]
        }
      : null
    storageAccountResourceId: !(empty(resourceProviders)) ? createDsStorageAccount.?outputs.resourceId : null
    subnetResourceIds: !(empty(resourceProviders))
      ? [
          filter(
            createDsVnet.?outputs.subnetResourceIds ?? [],
            subnetResourceId => contains(subnetResourceId, 'ds-subnet')
          )[0]
        ]
      : null
    arguments: '-resourceProviders \'${resourceProvidersFormatted}\' -resourceProvidersFeatures -subscriptionId ${subscriptionId}'
    scriptContent: loadTextContent('../scripts/Register-SubscriptionResourceProviderList.ps1')
  }
}

module createNatGateway 'br/public:avm/res/network/nat-gateway:1.4.0' = if (virtualNetworkDeployNatGateway && (virtualNetworkEnabled && !empty(virtualNetworkName) && !empty(virtualNetworkAddressSpace) && !empty(virtualNetworkLocation) && !empty(virtualNetworkResourceGroupName))) {
  scope: resourceGroup(subscriptionId, virtualNetworkResourceGroupName)
  dependsOn: [
    createResourceGroupForLzNetworking
    registerResourceProviders
  ]
  name: deploymentNames.createNatGateway
  params: {
    name: virtualNetworkNatGatewayConfiguration.?name ?? 'nat-gw-${virtualNetworkName}'
    availabilityZone: virtualNetworkNatGatewayConfiguration.?zones ?? -1
    location: virtualNetworkLocation
    enableTelemetry: enableTelemetry
    tags: virtualNetworkTags
    publicIPAddressObjects: [
      for publicIp in virtualNetworkNatGatewayConfiguration.?publicIPAddressProperties ?? []: {
        name: publicIp.?name ?? '${virtualNetworkNatGatewayConfiguration.?name}-pip'
        publicIPAddressSku: 'Standard'
        publicIPAddressVersion: 'IPv4'
        publicIPAllocationMethod: 'Static'
        zones: publicIp.zones ?? (virtualNetworkNatGatewayConfiguration.?zones != 0
          ? [virtualNetworkNatGatewayConfiguration.?zones]
          : null)
        skuTier: 'Regional'
        ddosSettings: !empty(virtualNetworkDdosPlanResourceId)
          ? {
              ddosProtectionPlan: {
                id: virtualNetworkDdosPlanResourceId
              }
              protectionMode: 'Enabled'
            }
          : null
        enableTelemetry: enableTelemetry
        idleTimeoutInMinutes: 4
      }
    ]
    publicIPPrefixObjects: [
      for publicIpPrefix in virtualNetworkNatGatewayConfiguration.?publicIPAddressPrefixesProperties ?? []: {
        name: publicIpPrefix.?name ?? '${virtualNetworkNatGatewayConfiguration.?name}-prefix'
        location: virtualNetworkLocation
        prefixLength: publicIpPrefix.?prefixLength
        customIPPrefix: publicIpPrefix.?customIPPrefix
        tags: virtualNetworkTags
        enableTelemetry: enableTelemetry
      }
    ]
  }
}
module createAdditonalNatGateway 'br/public:avm/res/network/nat-gateway:1.4.0' = [
  for (vnet, i) in additionalVirtualNetworks: if (!empty(vnet.?subnets ?? []) && (vnet.?deployNatGateway ?? false)) {
    scope: resourceGroup(subscriptionId, vnet.resourceGroupName)
    dependsOn: [
      createResourceGroupForAdditionalLzNetworking
      registerResourceProviders
    ]
    params: {
      name: vnet.?natGatewayConfiguration.?name ?? 'nat-gw-${vnet.name}'
      availabilityZone: vnet.?natGatewayConfiguration.?zones ?? -1
      location: vnet.location
      enableTelemetry: enableTelemetry
      tags: vnet.?tags
      publicIPAddressObjects: [
        for publicIp in vnet.?natGatewayConfiguration.?publicIPAddressProperties ?? []: {
          name: publicIp.?name ?? '${vnet.?natGatewayConfiguration.?name}-pip'
          publicIPAddressSku: 'Standard'
          publicIPAddressVersion: 'IPv4'
          publicIPAllocationMethod: 'Static'
          zones: publicIp.zones ?? (vnet.?natGatewayConfiguration.?zones != 0
            ? [vnet.?natGatewayConfiguration.?zones]
            : null)
          skuTier: 'Regional'
          ddosSettings: !empty(virtualNetworkDdosPlanResourceId)
            ? {
                ddosProtectionPlan: {
                  id: virtualNetworkDdosPlanResourceId
                }
                protectionMode: 'Enabled'
              }
            : null
          enableTelemetry: enableTelemetry
          idleTimeoutInMinutes: 4
        }
      ]
      publicIPPrefixObjects: [
        for publicIpPrefix in vnet.?natGatewayConfiguration.?publicIPAddressPrefixesProperties ?? []: {
          name: publicIpPrefix.?name ?? '${vnet.?natGatewayConfiguration.?name}-prefix'
          location: vnet.location
          prefixLength: publicIpPrefix.?prefixLength
          customIPPrefix: publicIpPrefix.?customIPPrefix
          tags: vnet.?tags
          enableTelemetry: enableTelemetry
        }
      ]
    }
  }
]

module createBastionHost 'br/public:avm/res/network/bastion-host:0.7.0' = if (virtualNetworkDeployBastion && (virtualNetworkEnabled && !empty(virtualNetworkName) && !empty(virtualNetworkAddressSpace) && !empty(virtualNetworkLocation) && !empty(virtualNetworkResourceGroupName))) {
  name: deploymentNames.createBastionHost
  scope: resourceGroup(subscriptionId, virtualNetworkResourceGroupName)
  dependsOn: [
    createResourceGroupForLzNetworking
  ]
  params: {
    name: virtualNetworkBastionConfiguration.?name ?? 'bastion-${virtualNetworkName}'
    virtualNetworkResourceId: createLzVnet.?outputs.resourceId ?? ''
    location: virtualNetworkLocation
    skuName: virtualNetworkBastionConfiguration.?bastionSku ?? 'Standard'
    disableCopyPaste: virtualNetworkBastionConfiguration.?disableCopyPaste ?? true
    enableFileCopy: virtualNetworkBastionConfiguration.?enableFileCopy ?? false
    enableIpConnect: virtualNetworkBastionConfiguration.?enableIpConnect ?? false
    enableShareableLink: virtualNetworkBastionConfiguration.?enableShareableLink ?? false
    scaleUnits: virtualNetworkBastionConfiguration.?scaleUnits ?? 2
    enablePrivateOnlyBastion: ((virtualNetworkBastionConfiguration.?bastionSku ?? 'Standard') == 'Premium')
      ? virtualNetworkBastionConfiguration.?enablePrivateOnlyBastion ?? false
      : false
    enableTelemetry: enableTelemetry
  }
}

module createUserAssignedManagedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.1' = [
  for (identity, i) in userAssignedManagedIdentities: if (!empty(userAssignedManagedIdentities)) {
    scope: resourceGroup(subscriptionId, userAssignedIdentityResourceGroupName)
    dependsOn: [
      createResourceGroupForIdentities
    ]
    name: '${deploymentNames.createUserAssignedIdentities}-${i}'
    params: {
      name: identity.?name ?? 'lz-identity-${deployment().location}-${i}'
      location: identity.?location ?? deployment().location
      tags: identity.?tags ?? {}
      federatedIdentityCredentials: identity.?federatedIdentityCredentials ?? []
      lock: identity.?lock ?? null
      enableTelemetry: enableTelemetry
    }
  }
]

module createResourceGroupForAdditionalLzNetworking 'br/public:avm/res/resources/resource-group:0.4.1' = [
  for (vnet, i) in additionalVirtualNetworks: if (virtualNetworkEnabled && !empty(additionalVirtualNetworks)) {
    scope: subscription(subscriptionId)
    params: {
      name: vnet.resourceGroupName
      location: vnet.?location ?? deployment().location
      lock: vnet.?resourceGroupLockEnabled ?? true
        ? {
            kind: 'CanNotDelete'
            name: 'CanNotDelete'
          }
        : null
      tags: virtualNetworkResourceGroupTags
      enableTelemetry: enableTelemetry
    }
  }
]

module createAdditionalVnets 'br/public:avm/res/network/virtual-network:0.7.0' = [
  for (vnet, i) in additionalVirtualNetworks: if (virtualNetworkEnabled && !empty(additionalVirtualNetworks)) {
    scope: resourceGroup(subscriptionId, vnet.resourceGroupName)
    dependsOn: [
      createResourceGroupForAdditionalLzNetworking
      createAdditionalVnetNsgs
      createLzRouteTable
    ]
    params: {
      name: vnet.name
      addressPrefixes: vnet.addressPrefixes
      subnets: [
        for subnet in (vnet.?subnets ?? []): {
          name: subnet.name
          addressPrefix: subnet.?addressPrefix
          networkSecurityGroupResourceId: ((vnet.?deployBastion ?? false) || subnet.name == 'AzureBastionSubnet')
            ? createBastionNsg.?outputs.resourceId
            : !empty(subnet.?networkSecurityGroup)
                ? resourceId(
                    subscriptionId,
                    vnet.resourceGroupName,
                    'Microsoft.Network/networkSecurityGroups',
                    filter(nsgArrayFormatted, nsg => nsg.nsgName == subnet.?networkSecurityGroup.name)[0].nsgName
                  )
                : null
          routeTableResourceId: (!empty(subnet.?routeTableName) && !empty(routeTablesResourceGroupName))
            ? resourceId(
                subscriptionId,
                routeTablesResourceGroupName,
                'Microsoft.Network/routeTables',
                subnet.?routeTableName ?? ''
              )
            : null
          natGatewayResourceId: (vnet.?deployNatGateway ?? false) && (subnet.?associateWithNatGateway ?? false)
            ? createAdditonalNatGateway[i].?outputs.resourceId
            : null
          delegation: subnet.?delegation
        }
      ]
      location: vnet.?location ?? deployment().location
      tags: vnet.?tags ?? {}
      dnsServers: vnet.?dnsServers ?? []
      ddosProtectionPlanResourceId: vnet.?ddosProtectionPlanResourceId ?? null
      peerings: vnet.?peerToHubNetwork ?? false
        ? [
            {
              remoteVirtualNetworkResourceId: vnet.?alternativeHubVnetResourceId ?? hubVirtualNetworkResourceIdChecked
              allowForwardedTraffic: true
              allowVirtualNetworkAccess: true
              allowGatewayTransit: false
              useRemoteGateways: vnet.?useRemoteGateways ?? false
              remotePeeringEnabled: true
              remotePeeringAllowForwardedTraffic: true
              remotePeeringAllowVirtualNetworkAccess: true
              remotePeeringAllowGatewayTransit: true
              remotePeeringUseRemoteGateways: false
            }
          ]
        : null
      enableTelemetry: enableTelemetry
    }
  }
]

module createAdditionalLzVirtualWanConnection 'hubVirtualNetworkConnections.bicep' = [
  for (vnet, i) in additionalVirtualNetworks: if (virtualNetworkEnabled && !empty(additionalVirtualNetworks) && (!empty(vnet.?alternativeVwanHubResourceId ?? '') || !empty(virtualHubResourceIdChecked))) {
    dependsOn: [
      createResourceGroupForAdditionalLzNetworking
      createAdditionalVnets
    ]
    scope: resourceGroup(
      split(vnet.?alternativeVwanHubResourceId ?? virtualHubResourceIdChecked, '/')[2],
      split(vnet.?alternativeVwanHubResourceId ?? virtualHubResourceIdChecked, '/')[4]
    )
    params: {
      name: 'vhc-${vnet.name}-${substring(guid(vnet.?alternativeVwanHubResourceId ?? virtualHubResourceIdChecked, vnet.name, vnet.resourceGroupName, vnet.location, subscriptionId), 0, 5)}'
      virtualHubName: split(vnet.?alternativeVwanHubResourceId ?? virtualHubResourceIdChecked, '/')[8]
      remoteVirtualNetworkId: '/subscriptions/${subscriptionId}/resourceGroups/${vnet.resourceGroupName}/providers/Microsoft.Network/virtualNetworks/${vnet.name}'
      enableInternetSecurity: virtualNetworkVwanEnableInternetSecurity
      routingConfiguration: !vHubRoutingIntentEnabled
        ? {
            associatedRouteTable: {
              id: virtualWanHubConnectionAssociatedRouteTable
            }
            propagatedRouteTables: {
              ids: virtualWanHubConnectionPropogatedRouteTables
              labels: virtualWanHubConnectionPropogatedLabels
            }
          }
        : {}
    }
  }
]

// Mesh peering for additional VNets only
module meshPeerAdditionalVnets 'peering.bicep' = [
  for (peering, i) in peeringCombinations: if (peerAllVirtualNetworks && !empty(additionalVirtualNetworks) && peering.sourceResourceGroupName != virtualNetworkResourceGroupName) {
    scope: resourceGroup(subscriptionId, peering.sourceResourceGroupName)
    dependsOn: [
      createAdditionalVnets
    ]
    params: {
      destinationVirtualNetworkName: peering.targetName
      destinationVirtualNetworkResourceGroupName: peering.targetResourceGroupName
      sourceVirtualNetworkName: peering.sourceName
    }
  }
]

// Mesh peering from primary VNet to additional VNets
module meshPeerFromPrimaryVnet 'peering.bicep' = [
  for (peering, i) in peeringCombinations: if (peerAllVirtualNetworks && (virtualNetworkEnabled && !empty(virtualNetworkName) && !empty(virtualNetworkAddressSpace) && !empty(virtualNetworkLocation) && !empty(virtualNetworkResourceGroupName)) && peering.sourceResourceGroupName == virtualNetworkResourceGroupName) {
    scope: resourceGroup(subscriptionId, peering.sourceResourceGroupName)
    dependsOn: [
      createLzVnet
      createAdditionalVnets
    ]
    params: {
      destinationVirtualNetworkName: peering.targetName
      destinationVirtualNetworkResourceGroupName: peering.targetResourceGroupName
      sourceVirtualNetworkName: peering.sourceName
    }
  }
]

// OUTPUTS
output failedProviders string = !empty(resourceProviders)
  ? registerResourceProviders.?outputs.outputs.failedProvidersRegistrations
  : ''
output failedFeatures string = !empty(resourceProviders)
  ? registerResourceProviders.?outputs.outputs.failedFeaturesRegistrations
  : ''

output virtualWanHubConnectionName string = virtualWanHubConnectionName

// ================ //
// Definitions      //
// ================ //

@export()
type natGatewayType = {
  @description('Optional. The name of the NAT gateway.')
  name: string?

  @description('Optional. The availability zones of the NAT gateway. Check the availability zone guidance for NAT gateway to understand how to map NAT gateway zone to the associated Public IP address zones (https://learn.microsoft.com/azure/nat-gateway/nat-availability-zones).')
  zones: int?

  @description('Optional. The Public IP address(es) properties to be attached to the NAT gateway.')
  publicIPAddressProperties: natGatewayPublicIpAddressPropertiesType[]?

  @description('Optional. The Public IP address(es) prefixes properties to be attached to the NAT gateway.')
  publicIPAddressPrefixesProperties: publicIPAddressPrefixesPropertiesType[]?
}

type natGatewayPublicIpAddressPropertiesType = {
  @description('Optional. The name of the Public IP address.')
  name: string?

  @description('Optional. The SKU of the Public IP address.')
  zones: (1 | 2 | 3)[]?
}

type publicIPAddressPrefixesPropertiesType = {
  @description('Optional. The name of the Public IP address prefix.')
  name: string?

  @description('Optional. The prefix length of the public IP address prefix..')
  prefixLength: int?

  @description('Optional. The custom IP prefix of the public IP address prefix.')
  customIPPrefix: string?
}

@export()
type roleAssignmentType = {
  @description('Required. The principal ID of the user, group, or service principal.')
  principalId: string

  @description('Required. The role definition ID or name.')
  definition: string

  @description('Required. The relative scope of the role assignment.')
  relativeScope: string

  @description('Optional. The condition for the role assignment.')
  roleAssignmentCondition: roleAssignmentConditionType?

  @description('Optional. The principal type of the user, group, or service principal.')
  principalType: 'User' | 'Group' | 'ServicePrincipal'?

  @description('Optional. The role assignment description.')
  description: string?
}

// "Constrain Roles" - Condition template
@export()
type constrainRolesType = {
  @description('Required. Name of the RBAC condition template.')
  templateName: 'constrainRoles'

  @description('Required. The list of roles that are allowed to be assigned by the delegate.')
  rolesToAssign: array
}

// "Constrain Roles and Principal types" - Condition template
@export()
type constrainRolesAndPrincipalTypesType = {
  @description('Required. Name of the RBAC condition template.')
  templateName: 'constrainRolesAndPrincipalTypes'

  @description('Required. The list of roles that are allowed to be assigned by the delegate.')
  rolesToAssign: array

  @description('Required. The list of principle types that are allowed to be assigned roles by the delegate.')
  principleTypesToAssign: ('User' | 'Group' | 'ServicePrincipal')[]
}

// "Constrain Roles and Principals" - Condition template
@export()
type constrainRolesAndPrincipalsType = {
  @description('Required. Name of the RBAC condition template.')
  templateName: 'constrainRolesAndPrincipals'

  @description('Required. The list of roles that are allowed to be assigned by the delegate.')
  rolesToAssign: array

  @description('Required. The list of principals that are allowed to be assigned roles by the delegate.')
  principalsToAssignTo: array
}

// "Exclude Roles" - Condition template
@export()
type excludeRolesType = {
  @description('Required. Name of the RBAC condition template.')
  templateName: 'excludeRoles'

  @description('Required. The list of roles that are not allowed to be assigned by the delegate.')
  excludedRoles: array
}

// Discriminator for the constrainedDelegationTemplatesType
@export()
@discriminator('templateName')
type constrainedDelegationTemplatesType =
  | excludeRolesType
  | constrainRolesType
  | constrainRolesAndPrincipalTypesType
  | constrainRolesAndPrincipalsType

// Role Assignment Condition type
@export()
type roleAssignmentConditionType = {
  @description('Optional. The type of template for the role assignment condition.')
  roleConditionType: constrainedDelegationTemplatesType?

  @description('Optional. The version of the condition template.')
  conditionVersion: '2.0'?

  @description('Optional. The code for a custom condition if no template is used. The user should supply their own custom code if the available templates are not matching their requirements. If a value is provided, this will overwrite any added template. All single quotes needs to be skipped using \'.')
  delegationCode: string?
}

// Functions to generate conditions' code

@description('Generates the code for the "Constrain Roles" condition template.')
@export()
func generateCodeRolesType(constrainRoles constrainRolesType) string =>
  '((!(ActionMatches{\'Microsoft.Authorization/roleAssignments/write\'})) OR (@Request[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals {${joinArray(constrainRoles.rolesToAssign)}}) AND ((!(ActionMatches{\'Microsoft.Authorization/roleAssignments/delete\'}) OR (@Resource[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals {${joinArray(constrainRoles.rolesToAssign)}}))))'

@description('Generates the code for the "Constrain Roles and Principal types" condition template.')
@export()
func generateCodeRolesAndPrincipalsTypes(constrainRolesAndPrincipalsTypes constrainRolesAndPrincipalTypesType) string =>
  '((!(ActionMatches{\'Microsoft.Authorization/roleAssignments/write\'}) OR (@Request[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals {${joinArray(constrainRolesAndPrincipalsTypes.rolesToAssign)}} AND @Request[Microsoft.Authorization/roleAssignments:PrincipalType] ForAnyOfAnyValues:StringEqualsIgnoreCase {${joinArrayIgnoreCase(constrainRolesAndPrincipalsTypes.principleTypesToAssign)}})) AND ((!(ActionMatches{\'Microsoft.Authorization/roleAssignments/delete\'})) OR (@Resource[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals {${joinArray(constrainRolesAndPrincipalsTypes.rolesToAssign)}} AND @Resource[Microsoft.Authorization/roleAssignments:PrincipalType] ForAnyOfAnyValues:StringEqualsIgnoreCase {${joinArrayIgnoreCase(constrainRolesAndPrincipalsTypes.principleTypesToAssign)}})))'

@description('Generates the code for the "Constrain Roles and Principals" condition template.')
@export()
func generateCodeRolesAndPrincipals(constrainRolesAndPrincipals constrainRolesAndPrincipalsType) string =>
  '((!(ActionMatches{\'Microsoft.Authorization/roleAssignments/write\'}) OR (@Request[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals {${joinArray(constrainRolesAndPrincipals.rolesToAssign)}} AND @Request[Microsoft.Authorization/roleAssignments:PrincipalId] ForAnyOfAnyValues:GuidEquals {${joinArray(constrainRolesAndPrincipals.principalsToAssignTo)}})) AND ((!(ActionMatches{\'Microsoft.Authorization/roleAssignments/delete\'})) OR (@Resource[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals {${joinArray(constrainRolesAndPrincipals.rolesToAssign)}} AND @Resource[Microsoft.Authorization/roleAssignments:PrincipalId] ForAnyOfAnyValues:GuidEquals {${joinArray(constrainRolesAndPrincipals.principalsToAssignTo)}})))'

@description('Generates the code for the "Exclude Roles" condition template.')
@export()
func generateCodeExcludeRoles(excludeRoles excludeRolesType) string =>
  '((!(ActionMatches{\'Microsoft.Authorization/roleAssignments/write\'}) OR ( @Request[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAllValues:GuidNotEquals {${joinArray(excludeRoles.excludedRoles)}})) AND ((!(ActionMatches{\'Microsoft.Authorization/roleAssignments/delete\'}) OR (@Request[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAllValues:GuidNotEquals {${joinArray(excludeRoles.excludedRoles)}}))))'

// Helper functions
@export()
func joinArray(roles array) string => replace(join(roles, ','), '"', '')

@export()
func joinArrayIgnoreCase(principalTypes array) string =>
  '\'${replace(replace(join(principalTypes, ','),'"','\''),',','\',\'')}\''

@export()
type subnetType = {
  @description('Required. The Name of the subnet resource.')
  name: string

  @description('Conditional. The address prefix for the subnet. Required if `addressPrefixes` is empty.')
  addressPrefix: string?

  @description('Conditional. List of address prefixes for the subnet. Required if `addressPrefix` is empty.')
  addressPrefixes: string[]?

  @description('Optional. Application gateway IP configurations of virtual network resource.')
  applicationGatewayIPConfigurations: object[]?

  @description('Optional. The delegation to enable on the subnet.')
  delegation: string?

  @description('Optional. The resource ID of the NAT Gateway to use for the subnet.')
  natGatewayResourceId: string?

  @description('Optional. Option to associate the subnet with the NAT gatway deployed by this module.')
  associateWithNatGateway: bool?

  @description('Optional. The network security group to be associated with this subnet.')
  networkSecurityGroup: networkSecurityGroupType?

  @description('Optional. enable or disable apply network policies on private endpoint in the subnet.')
  privateEndpointNetworkPolicies: ('Disabled' | 'Enabled' | 'NetworkSecurityGroupEnabled' | 'RouteTableEnabled')?

  @description('Optional. enable or disable apply network policies on private link service in the subnet.')
  privateLinkServiceNetworkPolicies: ('Disabled' | 'Enabled')?

  @description('Optional. An array of service endpoint policies.')
  serviceEndpointPolicies: object[]?

  @description('Optional. The service endpoints to enable on the subnet.')
  serviceEndpoints: string[]?

  @description('Optional. Set this property to false to disable default outbound connectivity for all VMs in the subnet. This property can only be set at the time of subnet creation and cannot be updated for an existing subnet.')
  defaultOutboundAccess: bool?

  @description('Optional. Set this property to Tenant to allow sharing subnet with other subscriptions in your AAD tenant. This property can only be set if defaultOutboundAccess is set to false, both properties can only be set if subnet is empty.')
  sharingScope: ('DelegatedServices' | 'Tenant')?

  @description('Optional. The name of the route table to be associated with this subnet.')
  routeTableName: string?
}

@export()
type bastionType = {
  @description('Optional. The name of the bastion host.')
  name: string?

  @description('Optional. The SKU of the bastion host.')
  bastionSku: ('Basic' | 'Standard' | 'Premium')?

  @description('Optional. The option to allow copy and paste.')
  disableCopyPaste: bool?

  @description('Optional. The option to allow file copy.')
  enableFileCopy: bool?

  @description('Optional. The option to allow IP connect.')
  enableIpConnect: bool?

  @description('Optional. The option to allow shareable link.')
  enableShareableLink: bool?

  @description('Optional. The number of scale units. The Basic SKU only supports 2 scale units.')
  scaleUnits: int?

  @description('Optional. Option to deploy a private Bastion host with no public IP address.')
  enablePrivateOnlyBastion: bool?
}

@export()
@sys.description('Optional. The request type of the role assignment.')
type requestTypeType =
  | 'AdminAssign'
  | 'AdminExtend'
  | 'AdminRemove'
  | 'AdminRenew'
  | 'AdminUpdate'
  | 'SelfActivate'
  | 'SelfDeactivate'
  | 'SelfExtend'
  | 'SelfRenew'

@export()
type ticketInfoType = {
  @sys.description('Optional. The ticket number for the role eligibility assignment.')
  ticketNumber: string?

  @sys.description('Optional. The ticket system name for the role eligibility assignment.')
  ticketSystem: string?
}

@export()
@description('Optional. The type of the PIM role assignment whether its active or eligible.')
type pimRoleAssignmentTypeType = {
  @description('Required. The type of the role assignment.')
  roleAssignmentType: 'Active' | 'Eligible'

  @description('Optional. The type of the PIM request.')
  requestType: requestTypeType?

  @description('Required. The schedule information for the role assignment.')
  scheduleInfo: roleAssignmentScheduleType

  @description('Optional. The ticket information for the role assignment.')
  ticketInfo: ticketInfoType?

  @description('Required. The relative scope of the role assignment.')
  relativeScope: string

  @description('Required. The principal ID of the user, group, or service principal.')
  principalId: string

  @description('Required. The role definition ID or name.')
  definition: string

  @description('Optional. The justification for the role assignment.')
  justification: string?

  @description('Optional. The condition for the role assignment.')
  roleAssignmentCondition: roleAssignmentConditionType?
}

@discriminator('durationType')
@description('Optional. The schedule information for the role assignment.')
type roleAssignmentScheduleType =
  | permenantRoleAssignmentScheduleType
  | timeBoundDurationRoleAssignmentScheduleType
  | timeBoundDateTimeRoleAssignmentScheduleType

type permenantRoleAssignmentScheduleType = {
  @description('Required. The type of the duration.')
  durationType: 'NoExpiration'
}

type timeBoundDurationRoleAssignmentScheduleType = {
  @description('Required. The type of the duration.')
  durationType: 'AfterDuration'

  @description('Required. The duration for the role assignment.')
  duration: string

  @description('Required. The start time for the role assignment.')
  startTime: string
}

type timeBoundDateTimeRoleAssignmentScheduleType = {
  @description('Required. The type of the duration.')
  durationType: 'AfterDateTime'

  @description('Required. The end date and time for the role assignment.')
  endDateTime: string

  @description('Required. The start date and time for the role assignment.')
  startTime: string
}

@export()
type roleAssignmentUMIType = {
  @description('Required. The role definition ID or name.')
  definition: string

  @description('Required. The relative scope of the role assignment.')
  relativeScope: string

  @description('Optional. The condition for the role assignment.')
  roleAssignmentCondition: roleAssignmentConditionType?

  @description('Optional. The role assignment description.')
  description: string?
}

@export()
@description('Optional. The type of the user assigned managed identity.')
type userAssignedIdentityType = {
  @description('Required. The name of the user assigned managed identity.')
  name: string

  @description('Optional. The location of the user assigned managed identity.')
  location: string?

  @description('Optional. The locks for the user assigned managed identity.')
  lock: object?

  @description('Optional. The tags for the user assigned managed identity.')
  tags: object?

  @description('Optional. The role assignments for the user assigned managed identity.')
  roleAssignments: roleAssignmentUMIType[]?

  @description('Optional. The federated identity credentials for the user assigned managed identity.')
  federatedIdentityCredentials: federatedIdentityCredentialType[]?
}

@description('The type for the federated identity credential.')
type federatedIdentityCredentialType = {
  @description('Required. The name of the federated identity credential.')
  name: string

  @description('Required. The list of audiences that can appear in the issued token.')
  audiences: string[]

  @description('Required. The URL of the issuer to be trusted.')
  issuer: string

  @description('Required. The identifier of the external identity.')
  subject: string
}

@export()
@description('Optional. The type of the virtual network.')
type virtualNetworkType = {
  @description('Required. The name of the virtual network resource.')
  name: string

  @description('Required. The address prefixes for the virtual network.')
  addressPrefixes: array

  @description('Required. The location of the virtual network.')
  location: string

  @description('Optional. The tags for the virtual network.')
  tags: object?

  @description('Optional. The subnets for the virtual network.')
  subnets: subnetType[]?

  @description('Optional. The option to peer the virtual network to the hub network.')
  peerToHubNetwork: bool?

  @description('Optional. The resource ID of an alternative virtual network in the hub, opposed to what is defined in the parameter `hubNetworkResourceId`, to which the created virtual network will be peered/connected to via a virtual network peering instead of whats provided in `hubNetworkResourceId`.')
  alternativeHubVnetResourceId: string?

  @description('Optional. The resource ID of an alternative virtual wan hub in the hub, opposed to what is defined in the parameter `hubNetworkResourceId`, to which the created virtual network will be peered/connected to via a virtual hub connection instead of whats provided in `hubNetworkResourceId`.')
  alternativeVwanHubResourceId: string?

  @description('Required. The name of the virtual network resource group.')
  resourceGroupName: string

  @description('Optional. Enables the deployment of a `CanNotDelete` resource locks to the virtual networks resource group.')
  resourceGroupLockEnabled: bool?

  @description('Optional. Enables the use of remote gateways in the spefcified hub virtual network. If no gateways exsit in the hub virtual network, set this to `false`, otherwise peering will fail to create. Set this to `false` for virtual wan hub connections.')
  useRemoteGateways: bool?

  @description('Optional. The list of DNS servers for the virtual network.')
  dnsServers: array?

  @description('Optional. The resource Id of the DDOS protection plan.')
  ddosProtectionPlanResourceId: string?

  @description('Optional. The option to deploy Azure Bastion in the virtual network.')
  deployBastion: bool?

  @description('Optional. Flag to deploy a NAT gateway.')
  deployNatGateway: bool?

  @description('Optional. The configuration for deploying a NAT gateway.')
  natGatewayConfiguration: natGatewayType?
}

@export()
@description('Network security group type.')
type networkSecurityGroupType = {
  @description('Optional. The name of the network security group.')
  name: string?

  @description('Optional. The location of the network security group.')
  location: string?

  @description('Optional. The tags of the network security group.')
  tags: object?

  @description('Optional. The security rules of the network security group.')
  securityRules: nsgSecurityRuleType[]?
}

@export()
@description('The type of a security rule.')
type nsgSecurityRuleType = {
  @description('Required. The name of the security rule.')
  name: string

  @description('Required. The properties of the security rule.')
  properties: {
    @description('Required. Whether network traffic is allowed or denied.')
    access: ('Allow' | 'Deny')

    @description('Optional. The description of the security rule.')
    description: string?

    @description('Optional. Optional. The destination address prefix. CIDR or destination IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used.')
    destinationAddressPrefix: string?

    @description('Optional. The destination address prefixes. CIDR or destination IP ranges.')
    destinationAddressPrefixes: string[]?

    @description('Optional. The resource IDs of the application security groups specified as destination.')
    destinationApplicationSecurityGroupResourceIds: string[]?

    @description('Optional. The destination port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports.')
    destinationPortRange: string?

    @description('Optional. The destination port ranges.')
    destinationPortRanges: string[]?

    @description('Required. The direction of the rule. The direction specifies if rule will be evaluated on incoming or outgoing traffic.')
    direction: ('Inbound' | 'Outbound')

    @minValue(100)
    @maxValue(4096)
    @description('Required. Required. The priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule.')
    priority: int

    @description('Required. Network protocol this rule applies to.')
    protocol: ('Ah' | 'Esp' | 'Icmp' | 'Tcp' | 'Udp' | '*')

    @description('Optional. The CIDR or source IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used. If this is an ingress rule, specifies where network traffic originates from.')
    sourceAddressPrefix: string?

    @description('Optional. The CIDR or source IP ranges.')
    sourceAddressPrefixes: string[]?

    @description('Optional. The resource IDs of the application security groups specified as source.')
    sourceApplicationSecurityGroupResourceIds: string[]?

    @description('Optional. The source port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports.')
    sourcePortRange: string?

    @description('Optional. The source port ranges.')
    sourcePortRanges: string[]?
  }
}

@export()
@description('The route table type.')
type routeTableType = {
  @description('Required. The name of the route table resource.')
  name: string

  @description('Required. The location of the route table resource.')
  location: string

  @description('Optional. The tags for the route table resource.')
  tags: object?

  @description('Optional. The routes for the route table resource.')
  routes: routeType[]?
}

@description('The type for a route.')
type routeType = {
  @description('Required. Name of the route.')
  name: string

  @description('Required. Properties of the route.')
  properties: {
    @description('Required. The type of Azure hop the packet should be sent to.')
    nextHopType: ('VirtualAppliance' | 'VnetLocal' | 'Internet' | 'VirtualNetworkGateway' | 'None')

    @description('Required. The destination CIDR to which the route applies.')
    addressPrefix: string

    @description('Optional. The IP address packets should be forwarded to. Next hop values are only allowed in routes where the next hop type is VirtualAppliance.')
    nextHopIpAddress: string?
  }
}
