metadata name = 'Azure Cosmos DB MongoDB vCore cluster'
metadata description = '''This module deploys a Azure Cosmos DB MongoDB vCore cluster.

**Note:** This module is not intended for broad, generic use, as it was designed to cater for the requirements of the AZD CLI product. Feature requests and bug fix requests are welcome if they support the development of the AZD CLI but may not be incorporated if they aim to make this module more generic than what it needs to be for its primary use case.'''

@description('Required. Name of the Azure Cosmos DB MongoDB vCore cluster.')
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

@description('Optional. Mode to create the azure cosmos db mongodb vCore cluster.')
param createMode string = 'Default'

@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingType

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Whether high availability is enabled on the node group.')
param highAvailabilityMode bool = false

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. IP addresses to allow access to the cluster from.')
param networkAcls networkAclsType?

@description('Required. Number of nodes in the node group.')
param nodeCount int

@description('Optional. Deployed Node type in the node group.')
param nodeType string = 'Shard'

@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointType

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. Key vault reference and secret settings for the module\'s secrets export.')
param secretsExportConfiguration secretsExportConfigurationType?

@description('Required. SKU defines the CPU and memory that is provisioned for each node.')
param sku string

@description('Required. Disk storage size for the node group in GB.')
param storage int

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId(
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
    name: customRule.?firewallRuleName ?? 'allow-${replace(customRule.startIpAddress, '.', '')}-to-${replace(customRule.endIpAddress, '.', '')}'
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

resource mongoCluster 'Microsoft.DocumentDB/mongoClusters@2024-02-15-preview' = {
  name: name
  tags: tags
  location: location
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    createMode: createMode
    nodeGroupSpecs: [
      {
        diskSizeGB: storage
        enableHa: highAvailabilityMode
        kind: nodeType
        nodeCount: nodeCount
        sku: sku
      }
    ]
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

module secretsExport 'modules/keyVaultExport.bicep' = if (secretsExportConfiguration != null) {
  name: '${uniqueString(deployment().name, location)}-secrets-kv'
  scope: resourceGroup(
    split((secretsExportConfiguration.?keyVaultResourceId ?? '//'), '/')[2],
    split((secretsExportConfiguration.?keyVaultResourceId ?? '////'), '/')[4]
  )
  params: {
    keyVaultName: last(split(secretsExportConfiguration.?keyVaultResourceId ?? '//', '/'))
    secretsToSet: union(
      [],
      contains(secretsExportConfiguration!, 'connectionStringSecretName')
        ? [
            {
              name: secretsExportConfiguration!.connectionStringSecretName
              value: mongoCluster.properties.connectionString
            }
          ]
        : []
    )
  }
}

module mongoCluster_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.7.1' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-databaseAccount-PrivateEndpoint-${index}'
    scope: resourceGroup(privateEndpoint.?resourceGroupName ?? '')
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

@description('The name of the Azure Cosmos DB MongoDB vCore cluster.')
output name string = mongoCluster.name

@description('The resource ID of the Azure Cosmos DB MongoDB vCore cluster.')
output mongoClusterResourceId string = mongoCluster.id

@description('The resource ID of the resource group the firewall rule was created in.')
output resourceId string = resourceGroup().id

@description('The name of the resource group the firewall rule was created in.')
output resourceGroupName string = resourceGroup().name

@description('The connection string key of the mongo cluster.')
output connectionStringKey string = mongoCluster.properties.connectionString

@description('The name and resource ID of firewall rule.')
output firewallRules firewallSetType[] = [
  for index in range(0, length(firewallRules ?? [])): {
    name: mongoCluster_configFireWallRules[index].outputs.name
    resourceId: mongoCluster_configFireWallRules[index].outputs.resourceId
  }
]

@description('The private endpoints of the database account.')
output privateEndpoints array = [
  for (pe, i) in (!empty(privateEndpoints) ? array(privateEndpoints) : []): {
    name: mongoCluster_privateEndpoints[i].outputs.name
    resourceId: mongoCluster_privateEndpoints[i].outputs.resourceId
    groupId: mongoCluster_privateEndpoints[i].outputs.groupId
    customDnsConfig: mongoCluster_privateEndpoints[i].outputs.customDnsConfig
    networkInterfaceIds: mongoCluster_privateEndpoints[i].outputs.networkInterfaceIds
  }
]

@description('The references to the secrets exported to the provided Key Vault.')
output exportedSecrets secretsOutputType = (secretsExportConfiguration != null)
  ? toObject(secretsExport.outputs.secretsSet, secret => last(split(secret.secretResourceId, '/')), secret => secret)
  : {}

// =============== //
//   Definitions   //
// =============== //

type diagnosticSettingType = {
  @description('Optional. The name of diagnostic setting.')
  name: string?

  @description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.')
  logCategoriesAndGroups: {
    @description('Optional. Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.')
    category: string?

    @description('Optional. Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.')
    categoryGroup: string?

    @description('Optional. Enable or disable the category explicitly. Default is `true`.')
    enabled: bool?
  }[]?

  @description('Optional. The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.')
  metricCategories: {
    @description('Required. Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.')
    category: string

    @description('Optional. Enable or disable the category explicitly. Default is `true`.')
    enabled: bool?
  }[]?

  @description('Optional. A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.')
  logAnalyticsDestinationType: ('Dedicated' | 'AzureDiagnostics')?

  @description('Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  workspaceResourceId: string?

  @description('Optional. Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  storageAccountResourceId: string?

  @description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
  eventHubAuthorizationRuleResourceId: string?

  @description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  eventHubName: string?

  @description('Optional. The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.')
  marketplacePartnerResourceId: string?
}[]?

type firewallSetType = {
  @description('The name of the created firewall rule.')
  name: string

  @description('The resource ID of the created firewall rule.')
  resourceId: string
}

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

type networkAclsType = {
  @description('Optional. List of custom firewall rules.')
  customRules: [
    {
      @description('Optional. The name of the custom firewall rule.')
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

type privateEndpointType = {
  @description('Optional. The name of the private endpoint.')
  name: string?

  @description('Optional. The location to deploy the private endpoint to.')
  location: string?

  @description('Optional. The name of the private link connection to create.')
  privateLinkServiceConnectionName: string?

  @description('Optional. The subresource to deploy the private endpoint for. For example "vault", "mysqlServer" or "dataFactory".')
  service: string?

  @description('Required. Resource ID of the subnet where the endpoint needs to be created.')
  subnetResourceId: string

  @description('Optional. The private DNS zone group to configure for the private endpoint.')
  privateDnsZoneGroup: {
    @description('Optional. The name of the Private DNS Zone Group.')
    name: string?

    @description('Required. The private DNS zone groups to associate the private endpoint. A DNS zone group can support up to 5 DNS zones.')
    privateDnsZoneGroupConfigs: {
      @description('Optional. The name of the private DNS zone group config.')
      name: string?

      @description('Required. The resource id of the private DNS zone.')
      privateDnsZoneResourceId: string
    }[]
  }?

  @description('Optional. If Manual Private Link Connection is required.')
  isManualConnection: bool?

  @description('Optional. A message passed to the owner of the remote resource with the manual connection request.')
  @maxLength(140)
  manualConnectionRequestMessage: string?

  @description('Optional. Custom DNS configurations.')
  customDnsConfigs: {
    @description('Optional. FQDN that resolves to private endpoint IP address.')
    fqdn: string?

    @description('Required. A list of private ip addresses of the private endpoint.')
    ipAddresses: string[]
  }[]?

  @description('Optional. A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints.')
  ipConfigurations: {
    @description('Required. The name of the resource that is unique within a resource group.')
    name: string

    @description('Required. Properties of private endpoint IP configurations.')
    properties: {
      @description('Required. The ID of a group obtained from the remote resource that this private endpoint should connect to.')
      groupId: string

      @description('Required. The member name of a group obtained from the remote resource that this private endpoint should connect to.')
      memberName: string

      @description('Required. A private ip address obtained from the private endpoint\'s subnet.')
      privateIPAddress: string
    }
  }[]?

  @description('Optional. Application security groups in which the private endpoint IP configuration is included.')
  applicationSecurityGroupResourceIds: string[]?

  @description('Optional. The custom name of the network interface attached to the private endpoint.')
  customNetworkInterfaceName: string?

  @description('Optional. Specify the type of lock.')
  lock: lockType

  @description('Optional. Array of role assignments to create.')
  roleAssignments: roleAssignmentType

  @description('Optional. Tags to be applied on all resources/resource groups in this deployment.')
  tags: object?

  @description('Optional. Enable/Disable usage telemetry for module.')
  enableTelemetry: bool?

  @description('Optional. Specify if you want to deploy the Private Endpoint into a different resource group than the main resource.')
  resourceGroupName: string?
}[]?

type roleAssignmentType = {
  @description('Optional. The name (as GUID) of the role assignment. If not provided, a GUID will be generated.')
  name: string?

  @description('Required. The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
  roleDefinitionIdOrName: string

  @description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
  principalId: string

  @description('Optional. The principal type of the assigned principal ID.')
  principalType: ('ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup' | 'Device')?

  @description('Optional. The description of the role assignment.')
  description: string?

  @description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".')
  condition: string?

  @description('Optional. Version of the condition.')
  conditionVersion: '2.0'?

  @description('Optional. The Resource Id of the delegated managed identity resource.')
  delegatedManagedIdentityResourceId: string?
}[]?

type secretsExportConfigurationType = {
  @description('Required. The resource ID of the key vault where to store the secrets of this module.')
  keyVaultResourceId: string

  @description('Optional. The name to use when creating the primary write connection string secret.')
  connectionStringSecretName: string?
}

import { secretSetType } from 'modules/keyVaultExport.bicep'
type secretsOutputType = {
  @description('An exported secret\'s references.')
  *: secretSetType
}
