metadata name = 'Azure Cosmos DB for MongoDB (vCore) cluster'
metadata description = '''This module deploys a Azure Cosmos DB for MongoDB (vCore) cluster.

**Note:** This module is not intended for broad, generic use, as it was designed to cater for the requirements of the AZD CLI product. Feature requests and bug fix requests are welcome if they support the development of the AZD CLI but may not be incorporated if they aim to make this module more generic than what it needs to be for its primary use case.'''

@description('Required. Name of the Azure Cosmos DB for MongoDB (vCore) cluster.')
param name string

@description('Optional. Default to current resource group scope location. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the Database Account resource.')
param tags object?

@description('Required. Username for admin user.')
param administratorLogin string

@secure()
@description('Required. Password for admin user.')
@minLength(8)
@maxLength(128)
param administratorLoginPassword string

@description('Optional. Mode to create the Azure Cosmos DB for MongoDB (vCore) cluster.')
param createMode string = 'Default'

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Whether high availability is enabled on the node group.')
@allowed([
  'Disabled'
  'SameZone'
  'ZoneRedundantPreferred'
])
param highAvailabilityMode string = 'ZoneRedundantPreferred'

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

@description('Optional. IP addresses to allow access to the cluster from.')
param networkAcls networkAclsType?

@description('Required. Number of nodes in the node group.')
param nodeCount int

import { privateEndpointSingleServiceType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointSingleServiceType[]?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Required. SKU defines the CPU and memory that is provisioned for each node.')
param sku string

@description('Required. Disk storage size for the node group in GB.')
param storage int

@description('Optional. The type of the secrets export configuration.')
param enableMicrosoftEntraAuth bool = false

@description('Optional. The Microsoft Entra ID authentication identity assignments to be created for the cluster.')
param entraAuthIdentities authIdentityType[]?

var enableReferencedModulesTelemetry = false

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
  'User Access Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  )
}

var firewallRules = union(
  map(networkAcls.?customRules ?? [], customRule => {
    name: customRule.?firewallRuleName ?? 'allow-${replace(customRule.startIpAddress, '.', '_')}-to-${replace(customRule.endIpAddress, '.', '_')}'
    startIpAddress: customRule.startIpAddress
    endIpAddress: customRule.endIpAddress
  }),
  networkAcls.?allowAllIPs ?? false
    ? [
        {
          name: 'allow-all-IPs'
          startIpAddress: '0.0.0.0'
          endIpAddress: '255.255.255.255'
        }
      ]
    : [],
  networkAcls.?allowAzureIPs ?? false
    ? [
        {
          name: 'allow-all-azure-internal-IPs'
          startIpAddress: '0.0.0.0'
          endIpAddress: '0.0.0.0'
        }
      ]
    : []
)

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

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.documentdb-mongocluster.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource mongoCluster 'Microsoft.DocumentDB/mongoClusters@2025-04-01-preview' = {
  name: name
  tags: tags
  location: location
  properties: {
    administrator: {
      userName: administratorLogin
      password: administratorLoginPassword
    }
    createMode: createMode
    compute: {
      tier: sku
    }
    sharding: {
      shardCount: nodeCount
    }
    storage: {
      sizeGb: storage
    }
    highAvailability: {
      targetMode: highAvailabilityMode
    }
    authConfig: {
      allowedModes: union(
        [
          'NativeAuth'
        ],
        enableMicrosoftEntraAuth
          ? [
              'MicrosoftEntraID'
            ]
          : []
      )
    }
  }
}

resource mongoCluster_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
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
    scope: mongoCluster
  }
]

resource mongoCluster_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(mongoCluster.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: mongoCluster
  }
]

module mongoCluster_configFireWallRules 'firewall-rule/main.bicep' = [
  for (firewallRule, index) in firewallRules: {
    name: '${uniqueString(deployment().name, location)}-firewallRule-${index}'
    params: {
      mongoClusterName: mongoCluster.name
      name: firewallRule.name
      startIpAddress: firewallRule.startIpAddress
      endIpAddress: firewallRule.endIpAddress
    }
  }
]

module mongoCluster_users 'user/main.bicep' = [
  for (targetIdentity, index) in (entraAuthIdentities ?? []): {
    name: '${uniqueString(deployment().name, location)}-user-${index}'
    params: {
      mongoClusterName: mongoCluster.name
      location: location
      targetIdentity: {
        principalId: targetIdentity.principalId
        principalType: targetIdentity.principalType ?? 'ServicePrincipal'
      }
    }
  }
]

module mongoCluster_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.11.0' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-databaseAccount-PE-${index}'
    scope: resourceGroup(
      split(privateEndpoint.?resourceGroupResourceId ?? resourceGroup().id, '/')[2],
      split(privateEndpoint.?resourceGroupResourceId ?? resourceGroup().id, '/')[4]
    )
    params: {
      name: privateEndpoint.?name ?? 'pep-${last(split(mongoCluster.id, '/'))}-${privateEndpoint.?service ?? 'mongoCluster'}-${index}'
      privateLinkServiceConnections: privateEndpoint.?isManualConnection != true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(mongoCluster.id, '/'))}-${privateEndpoint.?service ?? 'mongoCluster'}-${index}'
              properties: {
                privateLinkServiceId: mongoCluster.id
                groupIds: [
                  privateEndpoint.?service ?? 'mongoCluster'
                ]
              }
            }
          ]
        : null
      manualPrivateLinkServiceConnections: privateEndpoint.?isManualConnection == true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(mongoCluster.id, '/'))}-${privateEndpoint.?service ?? 'mongoCluster'}-${index}'
              properties: {
                privateLinkServiceId: mongoCluster.id
                groupIds: [
                  privateEndpoint.?service ?? 'mongoCluster'
                ]
                requestMessage: privateEndpoint.?manualConnectionRequestMessage ?? 'Manual approval required.'
              }
            }
          ]
        : null
      subnetResourceId: privateEndpoint.subnetResourceId
      enableTelemetry: enableReferencedModulesTelemetry
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

@description('The name of the Azure Cosmos DB for MongoDB (vCore) cluster.')
output name string = mongoCluster.name

@description('The resource ID of the Azure Cosmos DB for MongoDB (vCore) cluster.')
output mongoClusterResourceId string = mongoCluster.id

@description('The resource ID of the resource group the firewall rule was created in.')
output resourceId string = resourceGroup().id

@description('The name of the resource group the firewall rule was created in.')
output resourceGroupName string = resourceGroup().name

@description('The name and resource ID of firewall rule.')
output firewallRules firewallSetOutputType[] = [
  for index in range(0, length(firewallRules ?? [])): {
    name: mongoCluster_configFireWallRules[index].outputs.name
    resourceId: mongoCluster_configFireWallRules[index].outputs.resourceId
  }
]

@description('The private endpoints of the database account.')
output privateEndpoints privateEndpointOutputType[] = [
  for (item, index) in (privateEndpoints ?? []): {
    name: mongoCluster_privateEndpoints[index].outputs.name
    resourceId: mongoCluster_privateEndpoints[index].outputs.resourceId
    groupId: mongoCluster_privateEndpoints[index].outputs.?groupId!
    customDnsConfigs: mongoCluster_privateEndpoints[index].outputs.customDnsConfigs
    networkInterfaceResourceIds: mongoCluster_privateEndpoints[index].outputs.networkInterfaceResourceIds
  }
]

@secure()
@description('The connection string of the Azure Cosmos DB for MongoDB (vCore) cluster with the username and password obscured. This variant contains the `<user>` and `<password>` placeholders in place of the actual credentials.')
output obscuredConnectionString string = mongoCluster.properties.connectionString

@secure()
@description('The connection string of the Azure Cosmos DB for MongoDB (vCore) cluster. This variant contains the actual username and password credentials.')
output connectionString string = replace(
  replace(mongoCluster.properties.connectionString, '<user>', administratorLogin),
  '<password>',
  administratorLoginPassword
)

// =============== //
//   Definitions   //
// =============== //

@export()
type privateEndpointOutputType = {
  @description('The name of the private endpoint.')
  name: string

  @description('The resource ID of the private endpoint.')
  resourceId: string

  @description('The group Id for the private endpoint Group.')
  groupId: string?

  @description('The custom DNS configurations of the private endpoint.')
  customDnsConfigs: {
    @description('FQDN that resolves to private endpoint IP address.')
    fqdn: string?

    @description('A list of private IP addresses of the private endpoint.')
    ipAddresses: string[]
  }[]

  @description('The IDs of the network interfaces associated with the private endpoint.')
  networkInterfaceResourceIds: string[]
}

@export()
@description('The type for a firewall set output')
type firewallSetOutputType = {
  @description('The name of the created firewall rule.')
  name: string

  @description('The resource ID of the created firewall rule.')
  resourceId: string
}

@export()
@description('The type for a network ACLs configuration')
type networkAclsType = {
  @description('Optional. List of custom firewall rules.')
  customRules: [
    {
      @description('Optional. The name of the custom firewall rule. Must match the pattern `^[a-zA-Z0-9][-_a-zA-Z0-9]*`.')
      firewallRuleName: string?

      @description('Required. The starting IP address for the custom firewall rule.')
      startIpAddress: string

      @description('Required. The ending IP address for the custom firewall rule.')
      endIpAddress: string
    }
  ]?

  @description('Required. Indicates whether to allow all IP addresses.')
  allowAllIPs: bool

  @description('Required. Indicates whether to allow all Azure internal IP addresses.')
  allowAzureIPs: bool
}

@export()
@description('The type for identities that can be used for Microsoft Entra ID authentication.')
type authIdentityType = {
  @description('Required. The principal (object) ID of the identity to create as a user on the cluster.')
  principalId: string

  @description('Optional. The type of principal to be used for the identity provider. Defaults to "ServicePrincipal".')
  principalType: 'ServicePrincipal' | 'User'?
}
