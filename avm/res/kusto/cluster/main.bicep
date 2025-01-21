metadata name = 'Kusto Cluster'
metadata description = 'This module deploys a Kusto Cluster.'

@minLength(4)
@maxLength(22)
@description('Required. The name of the Kusto cluster which must be unique within Azure.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. The number of instances of the Kusto Cluster.')
param capacity int = 2

@description('Required. The SKU of the Kusto Cluster.')
param sku string

@description('Optional. The tier of the Kusto Cluster.')
@allowed([
  'Basic'
  'Standard'
])
param tier string = 'Standard'

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

@description('Optional. The Kusto Cluster\'s accepted audiences.')
param acceptedAudiences acceptedAudienceType[] = []

@description('Optional. List of allowed fully-qulified domain names (FQDNs) for egress from the Kusto Cluster.')
param allowedFqdnList string[] = []

@description('Optional. List of IP addresses in CIDR format allowed to connect to the Kusto Cluster.')
param allowedIpRangeList string[] = []

@description('Optional. Enable/disable auto-stop.')
param enableAutoStop bool = true

@description('Optional. Enable/disable disk encryption.')
param enableDiskEncryption bool = false

@description('Optional. Enable/disable double encryption.')
param enableDoubleEncryption bool = false

@description('Optional. Enable/disable purge.')
param enablePurge bool = false

@description('Optional. Enable/disable streaming ingest.')
param enableStreamingIngest bool = false

@allowed([
  'V2'
  'V3'
])
@description('Optional. The engine type of the Kusto Cluster.')
param engineType string = 'V3'

import { customerManagedKeyType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. The customer managed key definition.')
param customerManagedKey customerManagedKeyType?

@description('Optional. List of the language extensions of the Kusto Cluster.')
param languageExtensions languageExtensionType[] = []

@description('Optional. Enable/disable auto-scale.')
param enableAutoScale bool = false

@minValue(2)
@maxValue(999)
@description('Optional. When auto-scale is enabled, the minimum number of instances in the Kusto Cluster.')
param autoScaleMin int = 2

@minValue(3)
@maxValue(1000)
@description('Optional. When auto-scale is enabled, the maximum number of instances in the Kusto Cluster.')
param autoScaleMax int = 3

@allowed([
  'IPv4'
  'IPv6'
  'DualStack'
])
@description('Optional. Indicates what public IP type to create - IPv4 (default), or DualStack (both IPv4 and IPv6).')
param publicIPType string = 'DualStack'

@description('Optional. Enable/disable public network access. If disabled, only private endpoint connection is allowed to the Kusto Cluster.')
param enablePublicNetworkAccess bool = true

@description('Optional. Enable/disable restricting outbound network access.')
param enableRestrictOutboundNetworkAccess bool = false

@description('Optional. The external tenants trusted by the Kusto Cluster.')
param trustedExternalTenants trustedExternalTenantType[] = []

@secure()
@description('Optional. The virtual cluster graduation properties of the Kusto Cluster.')
param virtualClusterGraduationProperties string?

@description('Optional. The virtual network configuration of the Kusto Cluster.')
param virtualNetworkConfiguration virtualNetworkConfigurationType?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Enable/disable zone redundancy.')
param enableZoneRedundant bool = false

import { privateEndpointMultiServiceType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointMultiServiceType[]?

@description('Optional. Enable/disable usage telemetry for module.')
param enableTelemetry bool = true

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

@description('Optional. The Principal Assignments for the Kusto Cluster.')
param principalAssignments principalAssignmentType[]?

@description('Optional. The Kusto Cluster databases.')
param databases databaseType[]?

// Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }
var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
)

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned')
        : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : 'None')
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
}

var formattedRoleAssignments = [
  for (roleAssignment, index) in (roleAssignments ?? []): union(roleAssignment, {
    roleDefinitionId: builtInRoleNames[?roleAssignment.roleDefinitionIdOrName] ?? (contains(
        roleAssignment.roleDefinitionIdOrName,
        '/providers/Microsoft.Authorization/roleDefinitions/'
      )
      ? roleAssignment.roleDefinitionIdOrName
      : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName))
  })
]

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.kusto-cluster.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

resource cMKKeyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId)) {
  name: last(split((customerManagedKey.?keyVaultResourceId ?? 'dummyVault'), '/'))
  scope: resourceGroup(
    split((customerManagedKey.?keyVaultResourceId ?? '//'), '/')[2],
    split((customerManagedKey.?keyVaultResourceId ?? '////'), '/')[4]
  )

  resource cMKKey 'keys@2023-07-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId) && !empty(customerManagedKey.?keyName)) {
    name: customerManagedKey.?keyName ?? 'dummyKey'
  }
}

resource kustoCluster 'Microsoft.Kusto/clusters@2024-04-13' = {
  name: name
  location: location
  tags: tags
  sku: {
    capacity: capacity
    name: sku
    tier: tier
  }
  identity: identity
  properties: {
    acceptedAudiences: acceptedAudiences
    allowedFqdnList: allowedFqdnList
    allowedIpRangeList: allowedIpRangeList
    enableAutoStop: enableAutoStop
    enableDiskEncryption: enableDiskEncryption
    enableDoubleEncryption: enableDoubleEncryption
    enablePurge: enablePurge
    enableStreamingIngest: enableStreamingIngest
    engineType: engineType
    keyVaultProperties: !empty(customerManagedKey)
      ? {
          keyName: customerManagedKey!.keyName
          keyVaultUri: cMKKeyVault.properties.vaultUri
          keyVersion: !empty(customerManagedKey.?keyVersion ?? '')
            ? customerManagedKey!.keyVersion
            : last(split(cMKKeyVault::cMKKey.properties.keyUriWithVersion, '/'))
          userIdentity: !empty(customerManagedKey.?userAssignedIdentityResourceId)
            ? customerManagedKey!.userAssignedIdentityResourceId
            : null
        }
      : null
    languageExtensions: {
      value: languageExtensions
    }
    optimizedAutoscale: {
      isEnabled: enableAutoScale
      minimum: autoScaleMin
      maximum: autoScaleMax
      version: 1
    }
    publicIPType: publicIPType
    publicNetworkAccess: (enablePublicNetworkAccess && empty(privateEndpoints)) ? 'Enabled' : 'Disabled'
    restrictOutboundNetworkAccess: enableRestrictOutboundNetworkAccess ? 'Enabled' : 'Disabled'
    trustedExternalTenants: trustedExternalTenants
    virtualClusterGraduationProperties: virtualClusterGraduationProperties
    virtualNetworkConfiguration: !empty(virtualNetworkConfiguration)
      ? {
          #disable-next-line use-resource-id-functions
          dataManagementPublicIpId: virtualNetworkConfiguration!.dataManagementPublicIpResourceId
          #disable-next-line use-resource-id-functions
          enginePublicIpId: virtualNetworkConfiguration!.enginePublicIpResourceId
          #disable-next-line use-resource-id-functions
          subnetId: virtualNetworkConfiguration!.subnetResourceId
        }
      : null
  }
  zones: enableZoneRedundant
    ? [
        '1'
        '2'
        '3'
      ]
    : null
}

resource kustoCluster_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for (diagnosticSetting, index) in (diagnosticSettings ?? []): {
    name: diagnosticSetting.?name ?? '${name}-diagnosticSettings'
    properties: {
      storageAccountId: diagnosticSetting.?storageAccountResourceId
      workspaceId: diagnosticSetting.?workspaceResourceId
      eventHubAuthorizationRuleId: diagnosticSetting.?eventHubAuthorizationRuleResourceId
      eventHubName: diagnosticSetting.?eventHubName
      metrics: [
        for group in (diagnosticSetting.?metricCategories ?? [{ category: 'AllMetrics' }]): {
          category: group.category
          enabled: group.?enabled ?? true
          timeGrain: null
        }
      ]
      logs: [
        for group in (diagnosticSetting.?logCategoriesAndGroups ?? [{ categoryGroup: 'allLogs' }]): {
          categoryGroup: group.?categoryGroup
          category: group.?category
          enabled: group.?enabled ?? true
        }
      ]
      marketplacePartnerId: diagnosticSetting.?marketplacePartnerResourceId
      logAnalyticsDestinationType: diagnosticSetting.?logAnalyticsDestinationType
    }
    scope: kustoCluster
  }
]

resource kustoCluster_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: kustoCluster
}

resource kustoCluster_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(kustoCluster.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: kustoCluster
  }
]

module kustoCluster_principalAssignments 'principal-assignment/main.bicep' = [
  for (principalAssignment, index) in (principalAssignments ?? []): {
    name: '${uniqueString(deployment().name, location)}-KustoCluster-PrincipalAssignment-${index}'
    params: {
      kustoClusterName: kustoCluster.name
      principalId: principalAssignment.principalId
      principalType: principalAssignment.principalType
      role: principalAssignment.role
      tenantId: principalAssignment.?tenantId
    }
  }
]

@batchSize(1)
module kustoCluster_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.7.1' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-kustoCluster-PrivateEndpoint-${index}'
    scope: resourceGroup(privateEndpoint.?resourceGroupName ?? '')
    params: {
      name: privateEndpoint.?name ?? 'pep-${last(split(kustoCluster.id, '/'))}-${privateEndpoint.service}-${index}'
      privateLinkServiceConnections: privateEndpoint.?isManualConnection != true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(kustoCluster.id, '/'))}-${privateEndpoint.service}-${index}'
              properties: {
                privateLinkServiceId: kustoCluster.id
                groupIds: [
                  privateEndpoint.service
                ]
              }
            }
          ]
        : null
      manualPrivateLinkServiceConnections: privateEndpoint.?isManualConnection == true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(kustoCluster.id, '/'))}-${privateEndpoint.service}-${index}'
              properties: {
                privateLinkServiceId: kustoCluster.id
                groupIds: [
                  privateEndpoint.service
                ]
                requestMessage: privateEndpoint.?manualConnectionRequestMessage ?? 'Manual approval required.'
              }
            }
          ]
        : null
      subnetResourceId: privateEndpoint.subnetResourceId
      enableTelemetry: privateEndpoint.?enableTelemetry ?? enableTelemetry
      location: privateEndpoint.?location ?? reference(
        split(privateEndpoint.subnetResourceId, '/subnets/')[0],
        '2020-06-01',
        'Full'
      ).location
      lock: privateEndpoint.?lock ?? lock
      privateDnsZoneGroup: privateEndpoint.?privateDnsZoneGroup
      roleAssignments: privateEndpoint.?roleAssignments
      tags: privateEndpoint.?tags ?? tags
      customDnsConfigs: privateEndpoint.?customDnsConfigs
      ipConfigurations: privateEndpoint.?ipConfigurations
      applicationSecurityGroupResourceIds: privateEndpoint.?applicationSecurityGroupResourceIds
      customNetworkInterfaceName: privateEndpoint.?customNetworkInterfaceName
    }
  }
]

module kustoCluster_databases 'database/main.bicep' = [
  for (database, index) in (databases ?? []): {
    name: '${uniqueString(deployment().name, location)}-kustoCluster-database-${index}'
    params: {
      name: database.name
      kustoClusterName: kustoCluster.name
      databaseKind: database.kind
      databaseReadWriteProperties: database.kind == 'ReadWrite' ? database.readWriteProperties : null
    }
  }
]

// ============ //
// Outputs      //
// ============ //

@description('The resource group the kusto cluster was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The resource id of the kusto cluster.')
output resourceId string = kustoCluster.?id

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string? = kustoCluster.?identity.?principalId

@description('The name of the kusto cluster.')
output name string = kustoCluster.name

@description('The location the resource was deployed into.')
output location string = kustoCluster.location

@description('The private endpoints of the kusto cluster.')
output privateEndpoints array = [
  for (pe, i) in (!empty(privateEndpoints) ? array(privateEndpoints) : []): {
    name: kustoCluster_privateEndpoints[i].outputs.name
    resourceId: kustoCluster_privateEndpoints[i].outputs.resourceId
    groupId: kustoCluster_privateEndpoints[i].outputs.groupId
    customDnsConfig: kustoCluster_privateEndpoints[i].outputs.customDnsConfig
    networkInterfaceIds: kustoCluster_privateEndpoints[i].outputs.networkInterfaceIds
  }
]

@description('The databases of the kusto cluster.')
output databases array = [
  for (database, index) in (!empty(databases) ? array(databases) : []): {
    name: kustoCluster_databases[index].outputs.name
    resourceId: kustoCluster_databases[index].outputs.resourceId
  }
]

// =============== //
//   Definitions   //
// =============== //

@export()
type acceptedAudienceType = {
  @description('Required. GUID or valid URL representing an accepted audience.')
  value: string
}

@export()
type languageExtensionType = {
  @description('Required. The name of the language extension custom image.')
  languageExtensionCustomImageName: string

  @description('Required. The name of the language extension image.')
  languageExtensionImageName: 'Python3_10_8' | 'Python3_10_8_DL' | 'Python3_6_5' | 'PythonCustomImage' | 'R'

  @description('Required. The name of the language extension.')
  languageExtensionName: 'PYTHON' | 'R'
}

@export()
type trustedExternalTenantType = {
  @description('Required. GUID representing an external tenant.')
  value: string
}

@export()
type virtualNetworkConfigurationType = {
  @description('Required. The public IP address resource id of the data management service..')
  dataManagementPublicIpResourceId: string

  @description('Required. The public IP address resource id of the engine service.')
  enginePublicIpResourceId: string

  @description('Required. The resource ID of the subnet to which to deploy the Kusto Cluster.')
  subnetResourceId: string
}

@export()
type principalAssignmentType = {
  @description('Required. The principal id assigned to the Kusto Cluster principal. It can be a user email, application id, or security group name.')
  principalId: string

  @description('Required. The principal type of the principal id.')
  principalType: 'App' | 'Group' | 'User'

  @description('Required. The Kusto Cluster role to be assigned to the principal id.')
  role: 'AllDatabasesAdmin' | 'AllDatabasesViewer'

  @description('Optional. The tenant id of the principal.')
  tenantId: string?
}

import { databaseReadWriteType } from './database/main.bicep'

@export()
type databaseType = {
  @description('Required. The name of the Kusto Cluster database.')
  name: string
  @description('Required. The object type of the databse.')
  kind: 'ReadWrite' | 'ReadOnlyFollowing'
  @description('Conditional. Required if the database kind is ReadWrite. Contains the properties of the database.')
  readWriteProperties: databaseReadWriteType?
}
