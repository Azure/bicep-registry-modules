metadata name = 'Kusto Cluster'
metadata description = 'This module deploys a Kusto Cluster.'
metadata owner = 'Azure/module-maintainers'

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
param tier kustoTierType = 'Standard'

@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentitiesType

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

@description('Optional. The customer managed key definition.')
param customerManagedKey customerManagedKeyType

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
param virtualNetworkConfiguration virtualNetworkConfigurationType

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Enable/disable zone redundancy.')
param enableZoneRedundant bool = false

@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointType

@description('Optional. Enable/disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingType

@description('Optional. The Principal Assignments for the Kusto Cluster.')
param principalAssignments array = []

// Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }
var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
)

var identity = !empty(managedIdentities)
  ? {
      type: !empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : 'None'
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

resource kustoCluster 'Microsoft.Kusto/clusters@2023-08-15' = {
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
    keyVaultProperties: customerManagedKey
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
    virtualNetworkConfiguration: virtualNetworkConfiguration
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
  for (principalAssignment, index) in (principalAssignments): {
    name: '${uniqueString(deployment().name, location)}-KustoCluster-PrincipalAssignment-${index}'
    params: {
      kustoClusterName: kustoCluster.name
      principalId: principalAssignment.principalId
      principalType: principalAssignment.principalType
      role: principalAssignment.role
      tenantId: contains(principalAssignment, 'tenantId') ? principalAssignment.tenantId : tenant().tenantId
    }
  }
]

module kustoCluster_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.4.0' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-KustoCluster-PrivateEndpoint-${index}'
    params: {
      name: privateEndpoint.?name ?? 'pep-${last(split(kustoCluster.id, '/'))}-${privateEndpoint.service}-${index}'
      privateLinkServiceConnections: privateEndpoint.?manualPrivateLinkServiceConnections != true
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
      manualPrivateLinkServiceConnections: privateEndpoint.?manualPrivateLinkServiceConnections == true
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
      privateDnsZoneGroupName: privateEndpoint.?privateDnsZoneGroupName
      privateDnsZoneResourceIds: privateEndpoint.?privateDnsZoneResourceIds
      roleAssignments: privateEndpoint.?roleAssignments
      tags: privateEndpoint.?tags ?? tags
      customDnsConfigs: privateEndpoint.?customDnsConfigs
      ipConfigurations: privateEndpoint.?ipConfigurations
      applicationSecurityGroupResourceIds: privateEndpoint.?applicationSecurityGroupResourceIds
      customNetworkInterfaceName: privateEndpoint.?customNetworkInterfaceName
    }
  }
]

// ============ //
// Outputs      //
// ============ //

@description('The resource group the resource was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The resource id of the resource.')
output resourceId string = kustoCluster.id

@description('The name of the resource.')
output name string = kustoCluster.name

@description('The location the resource was deployed into.')
output location string = kustoCluster.location

// =============== //
//   Definitions   //
// =============== //

type acceptedAudienceType = {
  @description('Optional. GUID or valid URL representing an accepted audience.')
  value: string
}?

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

type customerManagedKeyType = {
  @description('Required. The resource ID of a key vault to reference a customer managed key for encryption from.')
  keyVaultResourceId: string

  @description('Required. The name of the customer managed key to use for encryption.')
  keyName: string

  @description('Optional. The version of the customer managed key to reference for encryption. If not provided, using \'latest\'.')
  keyVersion: string?

  @description('Required. User assigned identity to use when fetching the customer managed key.')
  userAssignedIdentityResourceId: string
}?

type kustoTierType = 'Basic' | 'Standard'

type languageExtensionCustomImageNameType =
  | 'Python3_10_8'
  | 'Python3_10_8_DL'
  | 'Python3_6_5'
  | 'PythonCustomImage'
  | 'R'

type languageExtensionNameType = 'PYTHON' | 'R'

type languageExtensionType = {
  @description('Required. The name of the language extension custom image.')
  languageExtensionCustomImageName: string

  @description('Required. The name of the language extension image.')
  languageExtensionImageName: languageExtensionCustomImageNameType

  @description('Required. The name of the language extension.')
  languageExtensionName: languageExtensionNameType
}?

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

type managedIdentitiesType = {
  @description('Optional. The resource id(s) to assign to the resource.')
  userAssignedResourceIds: string[]
}?

type privateEndpointType = {
  @description('Optional. The name of the private endpoint.')
  name: string?

  @description('Optional. The location to deploy the private endpoint to.')
  location: string?

  @description('Required. The service (sub-) type to deploy the private endpoint for. For example "vault" or "blob".')
  service: string

  @description('Required. Resource ID of the subnet where the endpoint needs to be created.')
  subnetResourceId: string

  @description('Optional. The name of the private DNS zone group to create if privateDnsZoneResourceIds were provided.')
  privateDnsZoneGroupName: string?

  @description('Optional. The private DNS zone groups to associate the private endpoint with. A DNS zone group can support up to 5 DNS zones.')
  privateDnsZoneResourceIds: string[]?

  @description('Optional. Manual PrivateLink Service Connections.')
  isManualConnection: bool?

  @description('Optional. A message passed to the owner of the remote resource with the manual connection request.')
  @maxLength(140)
  manualConnectionRequestMessage: string?

  @description('Optional. Custom DNS configurations.')
  customDnsConfigs: {
    @description('Required. Fqdn that resolves to private endpoint ip address.')
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

type trustedExternalTenantType = {
  @description('Required. GUID representing an external tenant.')
  value: string
}?

type virtualNetworkConfigurationType = {
  @description('Required. The public IP address resource id of the data management service..')
  dataManagementPublicIpId: string

  @description('Required. Enable/disable virtual network injection. When enabled, the Kusto Cluster will be deployed into the specified subnet. When disabled, the Kusto Cluster will be removed from the specified subnet.')
  enableVirtualNetworkInjection: bool

  @description('Required. The public IP address resource id of the engine service.')
  enginePublicIpId: string

  @description('Required. The resource ID of the subnet to which to deploy the Kusto Cluster.')
  subnetId: string
}?
