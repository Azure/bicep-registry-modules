metadata name = 'Machine Learning Services Workspaces'
metadata description = 'This module deploys a Machine Learning Services Workspace.'
metadata owner = 'Azure/module-maintainers'

// ================ //
// Parameters       //
// ================ //
@sys.description('Required. The name of the machine learning workspace.')
param name string

@sys.description('Optional. Location for all resources.')
param location string = resourceGroup().location

@sys.description('Required. Specifies the SKU, also referred as \'edition\' of the Azure Machine Learning workspace.')
@allowed([
  'Free'
  'Basic'
  'Standard'
  'Premium'
])
param sku string

@sys.description('Optional. The type of Azure Machine Learning workspace to create.')
@allowed([
  'Default'
  'Project'
  'Hub'
  'FeatureStore'
])
param kind string = 'Default'

@sys.description('Conditional. The resource ID of the associated Storage Account. Required if \'kind\' is \'Default\', \'FeatureStore\' or \'Hub\'.')
param associatedStorageAccountResourceId string?

@sys.description('Conditional. The resource ID of the associated Key Vault. Required if \'kind\' is \'Default\', \'FeatureStore\' or \'Hub\'.')
param associatedKeyVaultResourceId string?

@sys.description('Conditional. The resource ID of the associated Application Insights. Required if \'kind\' is \'Default\' or \'FeatureStore\'.')
param associatedApplicationInsightsResourceId string?

@sys.description('Optional. The resource ID of the associated Container Registry.')
param associatedContainerRegistryResourceId string?

@sys.description('Optional. The lock settings of the service.')
param lock lockType

@sys.description('Optional. The flag to signal HBI data in the workspace and reduce diagnostic data collected by the service.')
param hbiWorkspace bool = false

@sys.description('Conditional. The resource ID of the hub to associate with the workspace. Required if \'kind\' is set to \'Project\'.')
param hubResourceId string?

@sys.description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@sys.description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointType

@sys.description('Optional. Computes to create respectively attach to the workspace.')
param computes array?

@sys.description('Optional. Connections to create in the workspace.')
param connections connectionType[] = []

@sys.description('Optional. Resource tags.')
param tags object?

@sys.description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@sys.description('Optional. The managed identity definition for this resource. At least one identity type is required.')
param managedIdentities managedIdentitiesType = {
  systemAssigned: true
}

@sys.description('Conditional. Settings for feature store type workspaces. Required if \'kind\' is set to \'FeatureStore\'.')
param featureStoreSettings featureStoreSettingType

@sys.description('Optional. Managed Network settings for a machine learning workspace.')
param managedNetworkSettings managedNetworkSettingType

@sys.description('Optional. Settings for serverless compute created in the workspace.')
param serverlessComputeSettings serverlessComputeSettingType

@sys.description('Optional. The authentication mode used by the workspace when connecting to the default storage account.')
@allowed([
  'accessKey'
  'identity'
])
param systemDatastoresAuthMode string?

@sys.description('Optional. Configuration for workspace hub settings.')
param workspaceHubConfig workspaceHubConfigType

// Diagnostic Settings

@sys.description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingType

@sys.description('Optional. The description of this workspace.')
param description string?

@sys.description('Optional. URL for the discovery service to identify regional endpoints for machine learning experimentation services.')
param discoveryUrl string?

@sys.description('Optional. The customer managed key definition.')
param customerManagedKey customerManagedKeyType

@sys.description('Optional. The compute name for image build.')
param imageBuildCompute string?

@sys.description('Conditional. The user assigned identity resource ID that represents the workspace identity. Required if \'userAssignedIdentities\' is not empty and may not be used if \'systemAssignedIdentity\' is enabled.')
param primaryUserAssignedIdentity string?

@sys.description('Optional. The service managed resource settings.')
param serviceManagedResourcesSettings object?

@sys.description('Optional. The list of shared private link resources in this workspace. Note: This property is not idempotent.')
param sharedPrivateLinkResources array?

@sys.description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Disabled'

// ================//
// Variables       //
// ================//

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned')
        : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : 'None')
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

// ================//
// Deployments     //
// ================//
var builtInRoleNames = {
  'AzureML Compute Operator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'e503ece1-11d0-4e8e-8e2c-7a6c3bf38815'
  )
  'AzureML Data Scientist': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f6c7c914-8db3-469d-8ca1-694a8f32e121'
  )
  'AzureML Metrics Writer (preview)': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '635dd51f-9968-44d3-b7fb-6d9a6bd613ae'
  )
  'AzureML Registry User': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '1823dd4f-9b8c-4ab6-ab4e-7397a3684615'
  )
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
  name: '46d3xbcp.res.machinelearningservices-workspace.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource cMKKeyVault 'Microsoft.KeyVault/vaults@2023-02-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId)) {
  name: last(split((customerManagedKey.?keyVaultResourceId ?? 'dummyVault'), '/'))
  scope: resourceGroup(
    split((customerManagedKey.?keyVaultResourceId ?? '//'), '/')[2],
    split((customerManagedKey.?keyVaultResourceId ?? '////'), '/')[4]
  )

  resource cMKKey 'keys@2023-02-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId) && !empty(customerManagedKey.?keyName)) {
    name: customerManagedKey.?keyName ?? 'dummyKey'
  }
}

resource cMKUserAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = if (!empty(customerManagedKey.?userAssignedIdentityResourceId)) {
  name: last(split(customerManagedKey.?userAssignedIdentityResourceId ?? 'dummyMsi', '/'))
  scope: resourceGroup(
    split((customerManagedKey.?userAssignedIdentityResourceId ?? '//'), '/')[2],
    split((customerManagedKey.?userAssignedIdentityResourceId ?? '////'), '/')[4]
  )
}

// Preview API version for 'systemDatastoresAuthMode'
resource workspace 'Microsoft.MachineLearningServices/workspaces@2024-04-01-preview' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: sku
    tier: sku
  }
  identity: identity
  properties: union(
    // Always added parameters
    {
      friendlyName: name
      storageAccount: associatedStorageAccountResourceId
      keyVault: associatedKeyVaultResourceId
      applicationInsights: associatedApplicationInsightsResourceId
      containerRegistry: associatedContainerRegistryResourceId
      hbiWorkspace: hbiWorkspace
      description: description
      discoveryUrl: discoveryUrl
      encryption: !empty(customerManagedKey)
        ? {
            status: 'Enabled'
            identity: !empty(customerManagedKey.?userAssignedIdentityResourceId)
              ? {
                  userAssignedIdentity: cMKUserAssignedIdentity.id
                }
              : null
            keyVaultProperties: {
              keyVaultArmId: cMKKeyVault.id
              keyIdentifier: !empty(customerManagedKey.?keyVersion ?? '')
                ? '${cMKKeyVault::cMKKey.properties.keyUri}/${customerManagedKey!.keyVersion}'
                : cMKKeyVault::cMKKey.properties.keyUriWithVersion
            }
          }
        : null
      imageBuildCompute: imageBuildCompute
      primaryUserAssignedIdentity: primaryUserAssignedIdentity
      systemDatastoresAuthMode: systemDatastoresAuthMode
      publicNetworkAccess: publicNetworkAccess
      serviceManagedResourcesSettings: serviceManagedResourcesSettings
      featureStoreSettings: featureStoreSettings
      hubResourceId: hubResourceId
      managedNetwork: managedNetworkSettings
      serverlessComputeSettings: serverlessComputeSettings
      workspaceHubConfig: workspaceHubConfig
    },
    // Parameters only added if not empty
    !empty(sharedPrivateLinkResources)
      ? {
          sharedPrivateLinkResources: sharedPrivateLinkResources
        }
      : {}
  )
  kind: kind
}

module workspace_computes 'compute/main.bicep' = [
  for compute in (computes ?? []): {
    name: '${workspace.name}-${compute.name}-compute'
    params: {
      machineLearningWorkspaceName: workspace.name
      name: compute.name
      location: compute.location
      sku: compute.?sku
      managedIdentities: compute.?managedIdentities
      tags: compute.?tags
      deployCompute: compute.?deployCompute
      computeLocation: compute.?computeLocation
      description: compute.?description
      disableLocalAuth: compute.?disableLocalAuth
      resourceId: compute.?resourceId
      computeType: compute.computeType
      properties: compute.?properties
    }
    dependsOn: [
      workspace_privateEndpoints
    ]
  }
]

module workspace_connections 'connection/main.bicep' = [
  for connection in connections: {
    name: '${workspace.name}-${connection.name}-connection'
    params: {
      machineLearningWorkspaceName: workspace.name
      name: connection.name
      category: connection.category
      expiryTime: connection.?expiryTime
      isSharedToAll: connection.?isSharedToAll
      metadata: connection.?metadata
      sharedUserList: connection.?sharedUserList
      target: connection.target
      value: connection.?value
      connectionProperties: connection.connectionProperties
    }
  }
]

resource workspace_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: workspace
}

resource workspace_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
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
    scope: workspace
  }
]

module workspace_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.7.0' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-workspace-PrivateEndpoint-${index}'
    scope: resourceGroup(privateEndpoint.?resourceGroupName ?? '')
    params: {
      name: privateEndpoint.?name ?? 'pep-${last(split(workspace.id, '/'))}-${privateEndpoint.?service ?? 'amlworkspace'}-${index}'
      privateLinkServiceConnections: privateEndpoint.?isManualConnection != true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(workspace.id, '/'))}-${privateEndpoint.?service ?? 'amlworkspace'}-${index}'
              properties: {
                privateLinkServiceId: workspace.id
                groupIds: [
                  privateEndpoint.?service ?? 'amlworkspace'
                ]
              }
            }
          ]
        : null
      manualPrivateLinkServiceConnections: privateEndpoint.?isManualConnection == true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(workspace.id, '/'))}-${privateEndpoint.?service ?? 'amlworkspace'}-${index}'
              properties: {
                privateLinkServiceId: workspace.id
                groupIds: [
                  privateEndpoint.?service ?? 'amlworkspace'
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

resource workspace_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(workspace.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: workspace
  }
]

// ================//
// Outputs         //
// ================//

@sys.description('The resource ID of the machine learning service.')
output resourceId string = workspace.id

@sys.description('The resource group the machine learning service was deployed into.')
output resourceGroupName string = resourceGroup().name

@sys.description('The name of the machine learning service.')
output name string = workspace.name

@sys.description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string = workspace.?identity.?principalId ?? ''

@sys.description('The location the resource was deployed into.')
output location string = workspace.location

// =============== //
//   Definitions   //
// =============== //

type managedIdentitiesType = {
  @sys.description('Optional. Enables system assigned managed identity on the resource. Must be false if `primaryUserAssignedIdentity` is provided.')
  systemAssigned: bool?

  @sys.description('Optional. The resource ID(s) to assign to the resource.')
  userAssignedResourceIds: string[]?
}

type lockType = {
  @sys.description('Optional. Specify the name of lock.')
  name: string?

  @sys.description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

type roleAssignmentType = {
  @sys.description('Optional. The name (as GUID) of the role assignment. If not provided, a GUID will be generated.')
  name: string?

  @sys.description('Required. The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
  roleDefinitionIdOrName: string

  @sys.description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
  principalId: string

  @sys.description('Optional. The principal type of the assigned principal ID.')
  principalType: ('ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup' | 'Device')?

  @sys.description('Optional. The description of the role assignment.')
  description: string?

  @sys.description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".')
  condition: string?

  @sys.description('Optional. Version of the condition.')
  conditionVersion: '2.0'?

  @sys.description('Optional. The Resource Id of the delegated managed identity resource.')
  delegatedManagedIdentityResourceId: string?
}[]?

type privateEndpointType = {
  @sys.description('Optional. The name of the private endpoint.')
  name: string?

  @sys.description('Optional. The location to deploy the private endpoint to.')
  location: string?

  @sys.description('Optional. The name of the private link connection to create.')
  privateLinkServiceConnectionName: string?

  @sys.description('Optional. The subresource to deploy the private endpoint for. For example "vault", "mysqlServer" or "dataFactory".')
  service: string?

  @sys.description('Required. Resource ID of the subnet where the endpoint needs to be created.')
  subnetResourceId: string

  @sys.description('Optional. The private DNS zone group to configure for the private endpoint.')
  privateDnsZoneGroup: {
    @sys.description('Optional. The name of the Private DNS Zone Group.')
    name: string?

    @sys.description('Required. The private DNS zone groups to associate the private endpoint. A DNS zone group can support up to 5 DNS zones.')
    privateDnsZoneGroupConfigs: {
      @sys.description('Optional. The name of the private DNS zone group config.')
      name: string?

      @sys.description('Required. The resource id of the private DNS zone.')
      privateDnsZoneResourceId: string
    }[]
  }?

  @sys.description('Optional. If Manual Private Link Connection is required.')
  isManualConnection: bool?

  @sys.description('Optional. A message passed to the owner of the remote resource with the manual connection request.')
  @maxLength(140)
  manualConnectionRequestMessage: string?

  @sys.description('Optional. Custom DNS configurations.')
  customDnsConfigs: {
    @sys.description('Required. Fqdn that resolves to private endpoint IP address.')
    fqdn: string?

    @sys.description('Required. A list of private IP addresses of the private endpoint.')
    ipAddresses: string[]
  }[]?

  @sys.description('Optional. A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints.')
  ipConfigurations: {
    @sys.description('Required. The name of the resource that is unique within a resource group.')
    name: string

    @sys.description('Required. Properties of private endpoint IP configurations.')
    properties: {
      @sys.description('Required. The ID of a group obtained from the remote resource that this private endpoint should connect to.')
      groupId: string

      @sys.description('Required. The member name of a group obtained from the remote resource that this private endpoint should connect to.')
      memberName: string

      @sys.description('Required. A private IP address obtained from the private endpoint\'s subnet.')
      privateIPAddress: string
    }
  }[]?

  @sys.description('Optional. Application security groups in which the private endpoint IP configuration is included.')
  applicationSecurityGroupResourceIds: string[]?

  @sys.description('Optional. The custom name of the network interface attached to the private endpoint.')
  customNetworkInterfaceName: string?

  @sys.description('Optional. Specify the type of lock.')
  lock: lockType

  @sys.description('Optional. Array of role assignments to create.')
  roleAssignments: roleAssignmentType

  @sys.description('Optional. Tags to be applied on all resources/resource groups in this deployment.')
  tags: object?

  @sys.description('Optional. Enable/Disable usage telemetry for module.')
  enableTelemetry: bool?

  @sys.description('Optional. Specify if you want to deploy the Private Endpoint into a different resource group than the main resource.')
  resourceGroupName: string?
}[]?

type featureStoreSettingType = {
  @sys.description('Optional. Compute runtime config for feature store type workspace.')
  computeRuntime: {
    @sys.description('Optional. The spark runtime version.')
    sparkRuntimeVersion: string?
  }?

  @sys.description('Optional. The offline store connection name.')
  offlineStoreConnectionName: string?

  @sys.description('Optional. The online store connection name.')
  onlineStoreConnectionName: string?
}?

@discriminator('type')
type OutboundRuleType = FqdnOutboundRuleType | PrivateEndpointOutboundRule | ServiceTagOutboundRule

type FqdnOutboundRuleType = {
  @sys.description('Required. Type of a managed network Outbound Rule of a machine learning workspace. Only supported when \'isolationMode\' is \'AllowOnlyApprovedOutbound\'.')
  type: 'FQDN'

  @sys.description('Required. Fully Qualified Domain Name to allow for outbound traffic.')
  destination: string

  @sys.description('Optional. Category of a managed network Outbound Rule of a machine learning workspace.')
  category: 'Dependency' | 'Recommended' | 'Required' | 'UserDefined'?
}

type PrivateEndpointOutboundRule = {
  @sys.description('Required. Type of a managed network Outbound Rule of a machine learning workspace. Only supported when \'isolationMode\' is \'AllowOnlyApprovedOutbound\' or \'AllowInternetOutbound\'.')
  type: 'PrivateEndpoint'

  @sys.description('Required. Service Tag destination for a Service Tag Outbound Rule for the managed network of a machine learning workspace.')
  destination: {
    @sys.description('Required. The resource ID of the target resource for the private endpoint.')
    serviceResourceId: string

    @sys.description('Optional. Whether the private endpoint can be used by jobs running on Spark.')
    sparkEnabled: bool?

    @sys.description('Required. The sub resource to connect for the private endpoint.')
    subresourceTarget: string
  }

  @sys.description('Optional. Category of a managed network Outbound Rule of a machine learning workspace.')
  category: 'Dependency' | 'Recommended' | 'Required' | 'UserDefined'?
}

type ServiceTagOutboundRule = {
  @sys.description('Required. Type of a managed network Outbound Rule of a machine learning workspace. Only supported when \'isolationMode\' is \'AllowOnlyApprovedOutbound\'.')
  type: 'ServiceTag'

  @sys.description('Required. Service Tag destination for a Service Tag Outbound Rule for the managed network of a machine learning workspace.')
  destination: {
    @sys.description('Required. The name of the service tag to allow.')
    portRanges: string

    @sys.description('Required. The protocol to allow. Provide an asterisk(*) to allow any protocol.')
    protocol: 'TCP' | 'UDP' | 'ICMP' | '*'

    @sys.description('Required. Which ports will be allow traffic by this rule. Provide an asterisk(*) to allow any port.')
    serviceTag: string
  }

  @sys.description('Optional. Category of a managed network Outbound Rule of a machine learning workspace.')
  category: 'Dependency' | 'Recommended' | 'Required' | 'UserDefined'?
}

type managedNetworkSettingType = {
  @sys.description('Required. Isolation mode for the managed network of a machine learning workspace.')
  isolationMode: 'AllowInternetOutbound' | 'AllowOnlyApprovedOutbound' | 'Disabled'

  @sys.description('Optional. Outbound rules for the managed network of a machine learning workspace.')
  outboundRules: {
    @sys.description('Required. The outbound rule. The name of the rule is the object key.')
    *: OutboundRuleType
  }?
}?

type serverlessComputeSettingType = {
  @sys.description('Optional. The resource ID of an existing virtual network subnet in which serverless compute nodes should be deployed.')
  serverlessComputeCustomSubnet: string?

  @sys.description('Optional. The flag to signal if serverless compute nodes deployed in custom vNet would have no public IP addresses for a workspace with private endpoint.')
  serverlessComputeNoPublicIP: bool?
}?

type workspaceHubConfigType = {
  @sys.description('Optional. The resource IDs of additional storage accounts to attach to the workspace.')
  additionalWorkspaceStorageAccounts: string[]?

  @sys.description('Optional. The resource ID of the default resource group for projects created in the workspace hub.')
  defaultWorkspaceResourceGroup: string?
}?

type diagnosticSettingType = {
  @sys.description('Optional. The name of diagnostic setting.')
  name: string?

  @sys.description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.')
  logCategoriesAndGroups: {
    @sys.description('Optional. Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.')
    category: string?

    @sys.description('Optional. Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.')
    categoryGroup: string?

    @sys.description('Optional. Enable or disable the category explicitly. Default is `true`.')
    enabled: bool?
  }[]?

  @sys.description('Optional. The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.')
  metricCategories: {
    @sys.description('Required. Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.')
    category: string

    @sys.description('Optional. Enable or disable the category explicitly. Default is `true`.')
    enabled: bool?
  }[]?

  @sys.description('Optional. A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.')
  logAnalyticsDestinationType: ('Dedicated' | 'AzureDiagnostics')?

  @sys.description('Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  workspaceResourceId: string?

  @sys.description('Optional. Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  storageAccountResourceId: string?

  @sys.description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
  eventHubAuthorizationRuleResourceId: string?

  @sys.description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  eventHubName: string?

  @sys.description('Optional. The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.')
  marketplacePartnerResourceId: string?
}[]?

type customerManagedKeyType = {
  @sys.description('Required. The resource ID of a key vault to reference a customer managed key for encryption from.')
  keyVaultResourceId: string

  @sys.description('Required. The name of the customer managed key to use for encryption.')
  keyName: string

  @sys.description('Optional. The version of the customer managed key to reference for encryption. If not provided, using \'latest\'.')
  keyVersion: string?

  @sys.description('Optional. User assigned identity to use when fetching the customer managed key. Required if no system assigned identity is available for use.')
  userAssignedIdentityResourceId: string?
}?

import { categoryType, connectionPropertyType } from 'connection/main.bicep'

type connectionType = {
  @sys.description('Required. Name of the connection to create.')
  name: string

  @sys.description('Required. Category of the connection.')
  category: categoryType

  @sys.description('Optional. The expiry time of the connection.')
  expiryTime: string?

  @sys.description('Optional. Indicates whether the connection is shared to all users in the workspace.')
  isSharedToAll: bool?

  @sys.description('Optional. User metadata for the connection.')
  metadata: {
    @sys.description('Required. The metadata key-value pairs.')
    *: string
  }?

  @sys.description('Optional. The shared user list of the connection.')
  sharedUserList: string[]?

  @sys.description('Required. The target of the connection.')
  target: string

  @sys.description('Optional. Value details of the workspace connection.')
  value: string?

  @sys.description('Required. The properties of the connection, specific to the auth type.')
  connectionProperties: connectionPropertyType
}
