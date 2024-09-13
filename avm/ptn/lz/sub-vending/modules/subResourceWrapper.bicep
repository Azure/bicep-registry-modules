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
param virtualNetworkDdosPlanResourceId string = ''

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

@sys.description('Indicates whether routing intent is enabled on the Virtual HUB within the virtual WAN.')
param vHubRoutingIntentEnabled bool = false

@sys.description('Whether to create role assignments or not. If true, supply the array of role assignment objects in the parameter called `roleAssignments`.')
param roleAssignmentEnabled bool = false

@sys.description('Supply an array of objects containing the details of the role assignments to create.')
param roleAssignments array = []

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
  'Microsoft.TimeSeriesInsights': []
  'Microsoft.Web': []
}

@sys.description('The name of the user managed identity for the resource providers registration deployment script.')
param deploymentScriptManagedIdentityName string

@sys.description('The name of the storage account for the deployment script.')
param deploymentScriptStorageAccountName string

// VARIABLES

// Deployment name variables
// LIMITS: Tenant = 64, Management Group = 64, Subscription = 64, Resource Group = 64
var deploymentNames = {
  moveSubscriptionToManagementGroup: take(
    'lz-vend-move-sub-${uniqueString(subscriptionId, subscriptionManagementGroupId, deployment().name)}',
    64
  )
  tagSubscription: take('lz-vend-tag-sub-${uniqueString(subscriptionId, deployment().name)}', 64)
  createResourceGroupForLzNetworking: take(
    'lz-vend-rsg-create-${uniqueString(subscriptionId, virtualNetworkResourceGroupName, virtualNetworkLocation, deployment().name)}',
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
  createLzRoleAssignmentsSub: take('lz-vend-rbac-sub-create-${uniqueString(subscriptionId, deployment().name)}', 64)
  createLzRoleAssignmentsRsgsSelf: take(
    'lz-vend-rbac-rsg-self-create-${uniqueString(subscriptionId, deployment().name)}',
    64
  )
  createLzRoleAssignmentsRsgsNotSelf: take(
    'lz-vend-rbac-rsg-nself-create-${uniqueString(subscriptionId, deployment().name)}',
    64
  )
  createResourceGroupForDeploymentScript: take(
    'lz-vend-rsg-ds-create-${uniqueString(subscriptionId, deploymentScriptResourceGroupName, deploymentScriptLocation, deployment().name)}',
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

// RESOURCES & MODULES

module moveSubscriptionToManagementGroup './managementGroupSubscription.bicep' = if (subscriptionManagementGroupAssociationEnabled && !empty(subscriptionManagementGroupId)) {
  scope: managementGroup(subscriptionManagementGroupId)
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
module createResourceGroupForLzNetworking 'br/public:avm/res/resources/resource-group:0.2.4' = if (virtualNetworkEnabled && !empty(virtualNetworkLocation) && !empty(virtualNetworkResourceGroupName)) {
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

module createLzVnet 'br/public:avm/res/network/virtual-network:0.1.7' = if (virtualNetworkEnabled && !empty(virtualNetworkName) && !empty(virtualNetworkAddressSpace) && !empty(virtualNetworkLocation) && !empty(virtualNetworkResourceGroupName)) {
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
    ddosProtectionPlanResourceId: virtualNetworkDdosPlanResourceId
    peerings: (virtualNetworkEnabled && virtualNetworkPeeringEnabled && !empty(hubVirtualNetworkResourceIdChecked) && !empty(virtualNetworkName) && !empty(virtualNetworkAddressSpace) && !empty(virtualNetworkLocation) && !empty(virtualNetworkResourceGroupName))
      ? [
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
        ]
      : []
    enableTelemetry: enableTelemetry
  }
}

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

module createLzRoleAssignmentsSub 'br/public:avm/ptn/authorization/role-assignment:0.1.0' = [
  for assignment in roleAssignmentsSubscription: if (roleAssignmentEnabled && !empty(roleAssignmentsSubscription)) {
    name: take(
      '${deploymentNames.createLzRoleAssignmentsSub}-${uniqueString(assignment.principalId, assignment.definition, assignment.relativeScope)}',
      64
    )
    params: {
      location: virtualNetworkLocation
      principalId: assignment.principalId
      roleDefinitionIdOrName: assignment.definition
      subscriptionId: subscriptionId
    }
  }
]

module createLzRoleAssignmentsRsgsSelf 'br/public:avm/ptn/authorization/role-assignment:0.1.0' = [
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
      subscriptionId: subscriptionId
      resourceGroupName: split(assignment.relativeScope, '/')[2]
    }
  }
]

module createLzRoleAssignmentsRsgsNotSelf 'br/public:avm/ptn/authorization/role-assignment:0.1.0' = [
  for assignment in roleAssignmentsResourceGroupNotSelf: if (roleAssignmentEnabled && !empty(roleAssignmentsResourceGroupNotSelf)) {
    name: take(
      '${deploymentNames.createLzRoleAssignmentsRsgsNotSelf}-${uniqueString(assignment.principalId, assignment.definition, assignment.relativeScope)}',
      64
    )
    params: {
      location: virtualNetworkLocation
      principalId: assignment.principalId
      roleDefinitionIdOrName: assignment.definition
      subscriptionId: subscriptionId
      resourceGroupName: split(assignment.relativeScope, '/')[2]
    }
  }
]

module createResourceGroupForDeploymentScript 'br/public:avm/res/resources/resource-group:0.2.4' = if (!empty(resourceProviders)) {
  scope: subscription(subscriptionId)
  name: deploymentNames.createResourceGroupForDeploymentScript
  params: {
    name: deploymentScriptResourceGroupName
    location: deploymentScriptLocation
    enableTelemetry: enableTelemetry
  }
}

module createManagedIdentityForDeploymentScript 'br/public:avm/res/managed-identity/user-assigned-identity:0.2.2' = if (!empty(resourceProviders)) {
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

module createRoleAssignmentsDeploymentScript 'br/public:avm/ptn/authorization/role-assignment:0.1.0' = if (!empty(resourceProviders)) {
  name: take('${deploymentNames.createRoleAssignmentsDeploymentScript}', 64)
  params: {
    location: deploymentScriptLocation
    principalId: !empty(resourceProviders) ? createManagedIdentityForDeploymentScript.outputs.principalId : ''
    roleDefinitionIdOrName: 'Contributor'
    subscriptionId: subscriptionId
  }
}

module createRoleAssignmentsDeploymentScriptStorageAccount 'br/public:avm/ptn/authorization/role-assignment:0.1.0' = if (!empty(resourceProviders)) {
  name: take('${deploymentNames.createRoleAssignmentsDeploymentScriptStorageAccount}', 64)
  params: {
    location: deploymentScriptLocation
    principalId: !empty(resourceProviders) ? createManagedIdentityForDeploymentScript.outputs.principalId : ''
    roleDefinitionIdOrName: '/providers/Microsoft.Authorization/roleDefinitions/69566ab7-960f-475b-8e7c-b3118f30c6bd'
    subscriptionId: subscriptionId
    resourceGroupName: deploymentScriptResourceGroupName
  }
}

module createDsNsg 'br/public:avm/res/network/network-security-group:0.3.0' = if (!empty(resourceProviders)) {
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

module createDsStorageAccount 'br/public:avm/res/storage/storage-account:0.9.1' = if (!empty(resourceProviders)) {
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
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      virtualNetworkRules: [
        {
          action: 'Allow'
          id: !empty(resourceProviders) ? createDsVnet.outputs.subnetResourceIds[0] : null
        }
      ]
    }
    enableTelemetry: enableTelemetry
  }
}

module createDsVnet 'br/public:avm/res/network/virtual-network:0.1.7' = if (!empty(resourceProviders)) {
  scope: resourceGroup(subscriptionId, deploymentScriptResourceGroupName)
  name: deploymentNames.createdsVnet
  params: {
    name: deploymentScriptVirtualNetworkName
    location: deploymentScriptLocation
    addressPrefixes: [
      virtualNetworkDeploymentScriptAddressPrefix
    ]
    subnets: [
      {
        addressPrefix: !empty(resourceProviders) ? cidrSubnet(virtualNetworkDeploymentScriptAddressPrefix, 24, 0) : null
        name: 'ds-subnet-001'
        networkSecurityGroupResourceId: !empty(resourceProviders) ? createDsNsg.outputs.resourceId : null
        serviceEndpoints: [
          {
            service: 'Microsoft.Storage'
          }
        ]
        delegations: [
          {
            name: 'Microsoft.ContainerInstance.containerGroups'
            properties: {
              serviceName: 'Microsoft.ContainerInstance/containerGroups'
            }
          }
        ]
      }
    ]
    enableTelemetry: enableTelemetry
  }
}

module registerResourceProviders 'br/public:avm/res/resources/deployment-script:0.2.3' = if (!empty(resourceProviders)) {
  scope: resourceGroup(subscriptionId, deploymentScriptResourceGroupName)
  name: deploymentNames.registerResourceProviders
  params: {
    name: deploymentScriptName
    kind: 'AzurePowerShell'
    azPowerShellVersion: '3.0'
    cleanupPreference: 'Always'
    enableTelemetry: enableTelemetry
    location: deploymentScriptLocation
    retentionInterval: 'P1D'
    timeout: 'PT1H'
    runOnce: true
    managedIdentities: !(empty(resourceProviders))
      ? {
          userAssignedResourcesIds: [
            createManagedIdentityForDeploymentScript.outputs.resourceId
          ]
        }
      : null
    storageAccountResourceId: !(empty(resourceProviders)) ? createDsStorageAccount.outputs.resourceId : null
    subnetResourceIds: !(empty(resourceProviders)) ? createDsVnet.outputs.subnetResourceIds : null
    arguments: '-resourceProviders \'${resourceProvidersFormatted}\' -resourceProvidersFeatures -subscriptionId ${subscriptionId}'
    scriptContent: loadTextContent('../scripts/Register-SubscriptionResourceProviderList.ps1')
  }
}

// OUTPUTS
output failedProviders string = !empty(resourceProviders)
  ? registerResourceProviders.outputs.outputs.failedProvidersRegistrations
  : ''
output failedFeatures string = !empty(resourceProviders)
  ? registerResourceProviders.outputs.outputs.failedFeaturesRegistrations
  : ''
