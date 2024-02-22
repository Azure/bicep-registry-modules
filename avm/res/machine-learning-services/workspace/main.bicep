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

@sys.description('Required. The resource ID of the associated Storage Account.')
param associatedStorageAccountResourceId string

@sys.description('Required. The resource ID of the associated Key Vault.')
param associatedKeyVaultResourceId string

@sys.description('Required. The resource ID of the associated Application Insights.')
param associatedApplicationInsightsResourceId string

@sys.description('Optional. The resource ID of the associated Container Registry.')
param associatedContainerRegistryResourceId string = ''

@sys.description('Optional. The lock settings of the service.')
param lock lockType

@sys.description('Optional. The flag to signal HBI data in the workspace and reduce diagnostic data collected by the service.')
param hbiWorkspace bool = false

@sys.description('Optional. The flag to indicate whether to allow public access when behind VNet.')
param allowPublicAccessWhenBehindVnet bool = false

@sys.description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments roleAssignmentType

@sys.description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointType

@sys.description('Optional. Computes to create respectively attach to the workspace.')
param computes array = []

@sys.description('Optional. Resource tags.')
param tags object?

@sys.description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@sys.description('Optional. The managed identity definition for this resource. At least one identity type is required.')
param managedIdentities managedIdentitiesType = {
  systemAssigned: true
}

// Diagnostic Settings

@sys.description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingType

@sys.description('Optional. The description of this workspace.')
param description string = ''

@sys.description('Optional. URL for the discovery service to identify regional endpoints for machine learning experimentation services.')
param discoveryUrl string = ''

@sys.description('Optional. The customer managed key definition.')
param customerManagedKey customerManagedKeyType

@sys.description('Optional. The compute name for image build.')
param imageBuildCompute string = ''

@sys.description('Conditional. The user assigned identity resource ID that represents the workspace identity. Required if \'userAssignedIdentities\' is not empty and may not be used if \'systemAssignedIdentity\' is enabled.')
param primaryUserAssignedIdentity string = ''

@sys.description('Optional. The service managed resource settings.')
param serviceManagedResourcesSettings object = {}

@sys.description('Optional. The list of shared private link resources in this workspace.')
param sharedPrivateLinkResources array = []

@sys.description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set.')
@allowed([
  ''
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = ''

// ================//
// Variables       //
// ================//
var enableReferencedModulesTelemetry = false

var formattedUserAssignedIdentities = reduce(map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }), {}, (cur, next) => union(cur, next)) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities) ? {
  type: (managedIdentities.?systemAssigned ?? false) ? (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned') : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : null)
  userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
} : null

// ================//
// Deployments     //
// ================//
var builtInRoleNames = {
  'AzureML Compute Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'e503ece1-11d0-4e8e-8e2c-7a6c3bf38815')
  'AzureML Data Scientist': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f6c7c914-8db3-469d-8ca1-694a8f32e121')
  'AzureML Metrics Writer (preview)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '635dd51f-9968-44d3-b7fb-6d9a6bd613ae')
  'AzureML Registry User': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '1823dd4f-9b8c-4ab6-ab4e-7397a3684615')
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f58310d9-a9f6-439a-9e8d-f62e7b41a168')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
}

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource cMKKeyVault 'Microsoft.KeyVault/vaults@2023-02-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId)) {
  name: last(split((customerManagedKey.?keyVaultResourceId ?? 'dummyVault'), '/'))
  scope: resourceGroup(split((customerManagedKey.?keyVaultResourceId ?? '//'), '/')[2], split((customerManagedKey.?keyVaultResourceId ?? '////'), '/')[4])

  resource cMKKey 'keys@2023-02-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId) && !empty(customerManagedKey.?keyName)) {
    name: customerManagedKey.?keyName ?? 'dummyKey'
  }
}

resource cMKUserAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = if (!empty(customerManagedKey.?userAssignedIdentityResourceId)) {
  name: last(split(customerManagedKey.?userAssignedIdentityResourceId ?? 'dummyMsi', '/'))
  scope: resourceGroup(split((customerManagedKey.?userAssignedIdentityResourceId ?? '//'), '/')[2], split((customerManagedKey.?userAssignedIdentityResourceId ?? '////'), '/')[4])
}

resource workspace 'Microsoft.MachineLearningServices/workspaces@2022-10-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: sku
    tier: sku
  }
  identity: identity
  properties: {
    friendlyName: name
    storageAccount: associatedStorageAccountResourceId
    keyVault: associatedKeyVaultResourceId
    applicationInsights: associatedApplicationInsightsResourceId
    containerRegistry: !empty(associatedContainerRegistryResourceId) ? associatedContainerRegistryResourceId : null
    hbiWorkspace: hbiWorkspace
    allowPublicAccessWhenBehindVnet: allowPublicAccessWhenBehindVnet
    description: description
    discoveryUrl: discoveryUrl
    encryption: !empty(customerManagedKey) ? {
      status: 'Enabled'
      identity: !empty(customerManagedKey.?userAssignedIdentityResourceId) ? {
        userAssignedIdentity: cMKUserAssignedIdentity.id
      } : null
      keyVaultProperties: {
        keyVaultArmId: cMKKeyVault.id
        keyIdentifier: !empty(customerManagedKey.?keyVersion ?? '') ? '${cMKKeyVault::cMKKey.properties.keyUri}/${customerManagedKey!.keyVersion}' : cMKKeyVault::cMKKey.properties.keyUriWithVersion
      }
    } : null
    imageBuildCompute: imageBuildCompute
    primaryUserAssignedIdentity: primaryUserAssignedIdentity
    publicNetworkAccess: !empty(publicNetworkAccess) ? any(publicNetworkAccess) : (!empty(privateEndpoints) ? 'Disabled' : 'Enabled')
    serviceManagedResourcesSettings: serviceManagedResourcesSettings
    sharedPrivateLinkResources: sharedPrivateLinkResources // Note: This property is not idempotent. Neither with [] or `null`
  }
}

module workspace_computes 'compute/main.bicep' = [for compute in computes: {
  name: '${workspace.name}-${compute.name}-compute'
  params: {
    machineLearningWorkspaceName: workspace.name
    name: compute.name
    location: compute.location
    sku: contains(compute, 'sku') ? compute.sku : ''
    managedIdentities: contains(compute, 'managedIdentities') ? compute.managedIdentities : null
    tags: contains(compute, 'tags') ? compute.tags : {}
    deployCompute: contains(compute, 'deployCompute') ? compute.deployCompute : true
    computeLocation: contains(compute, 'computeLocation') ? compute.computeLocation : ''
    description: contains(compute, 'description') ? compute.description : ''
    disableLocalAuth: compute.disableLocalAuth
    resourceId: contains(compute, 'resourceId') ? compute.resourceId : ''
    computeType: compute.computeType
    properties: contains(compute, 'properties') ? compute.properties : {}
  }
  dependsOn: [
    workspace_privateEndpoints
  ]
}]

resource workspace_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot delete or modify the resource or child resources.'
  }
  scope: workspace
}

resource workspace_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [for (diagnosticSetting, index) in (diagnosticSettings ?? []): {
  name: diagnosticSetting.?name ?? '${name}-diagnosticSettings'
  properties: {
    storageAccountId: diagnosticSetting.?storageAccountResourceId
    workspaceId: diagnosticSetting.?workspaceResourceId
    eventHubAuthorizationRuleId: diagnosticSetting.?eventHubAuthorizationRuleResourceId
    eventHubName: diagnosticSetting.?eventHubName
    metrics: diagnosticSetting.?metricCategories ?? [
      {
        category: 'AllMetrics'
        timeGrain: null
        enabled: true
      }
    ]
    logs: diagnosticSetting.?logCategoriesAndGroups ?? [
      {
        categoryGroup: 'AllLogs'
        enabled: true
      }
    ]
    marketplacePartnerId: diagnosticSetting.?marketplacePartnerResourceId
    logAnalyticsDestinationType: diagnosticSetting.?logAnalyticsDestinationType
  }
  scope: workspace
}]

module workspace_privateEndpoints '../../network/private-endpoint/main.bicep' = [for (privateEndpoint, index) in (privateEndpoints ?? []): {
  name: '${uniqueString(deployment().name, location)}-workspace-PrivateEndpoint-${index}'
  params: {
    groupIds: [
      privateEndpoint.?service ?? 'amlworkspace'
    ]
    name: privateEndpoint.?name ?? 'pep-${last(split(workspace.id, '/'))}-${privateEndpoint.?service ?? 'amlworkspace'}-${index}'
    serviceResourceId: workspace.id
    subnetResourceId: privateEndpoint.subnetResourceId
    enableDefaultTelemetry: privateEndpoint.?enableDefaultTelemetry ?? enableReferencedModulesTelemetry
    location: privateEndpoint.?location ?? reference(split(privateEndpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location
    lock: privateEndpoint.?lock ?? lock
    privateDnsZoneGroupName: privateEndpoint.?privateDnsZoneGroupName
    privateDnsZoneResourceIds: privateEndpoint.?privateDnsZoneResourceIds
    roleAssignments: privateEndpoint.?roleAssignments
    tags: privateEndpoint.?tags ?? tags
    manualPrivateLinkServiceConnections: privateEndpoint.?manualPrivateLinkServiceConnections
    customDnsConfigs: privateEndpoint.?customDnsConfigs
    ipConfigurations: privateEndpoint.?ipConfigurations
    applicationSecurityGroupResourceIds: privateEndpoint.?applicationSecurityGroupResourceIds
    customNetworkInterfaceName: privateEndpoint.?customNetworkInterfaceName
  }
}]

resource workspace_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (roleAssignment, index) in (roleAssignments ?? []): {
  name: guid(workspace.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : contains(roleAssignment.roleDefinitionIdOrName, '/providers/Microsoft.Authorization/roleDefinitions/') ? roleAssignment.roleDefinitionIdOrName : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName)
    principalId: roleAssignment.principalId
    description: roleAssignment.?description
    principalType: roleAssignment.?principalType
    condition: roleAssignment.?condition
    conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
    delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
  }
  scope: workspace
}]

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
output systemAssignedMIPrincipalId string = (managedIdentities.?systemAssigned ?? false) && contains(workspace.identity, 'principalId') ? workspace.identity.principalId : ''

@sys.description('The location the resource was deployed into.')
output location string = workspace.location

// =============== //
//   Definitions   //
// =============== //

type managedIdentitiesType = {
  @sys.description('Optional. Enables system assigned managed identity on the resource.')
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
  @sys.description('Required. The name of the role to assign. If it cannot be found you can specify the role definition ID instead.')
  roleDefinitionIdOrName: string

  @sys.description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
  principalId: string

  @sys.description('Optional. The principal type of the assigned principal ID.')
  principalType: ('ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup' | 'Device')?

  @sys.description('Optional. The description of the role assignment.')
  description: string?

  @sys.description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container"')
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

  @sys.description('Optional. The service (sub-) type to deploy the private endpoint for. For example "vault" or "blob".')
  service: string?

  @sys.description('Required. Resource ID of the subnet where the endpoint needs to be created.')
  subnetResourceId: string

  @sys.description('Optional. The name of the private DNS zone group to create if privateDnsZoneResourceIds were provided.')
  privateDnsZoneGroupName: string?

  @sys.description('Optional. The private DNS zone groups to associate the private endpoint with. A DNS zone group can support up to 5 DNS zones.')
  privateDnsZoneResourceIds: string[]?

  @sys.description('Optional. Custom DNS configurations.')
  customDnsConfigs: {
    fqdn: string?
    ipAddresses: string[]
  }[]?

  @sys.description('Optional. A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints.')
  ipConfigurations: {
    name: string
    properties: {
      groupId: string
      memberName: string
      privateIPAddress: string
    }
  }[]?

  @sys.description('Optional. Application security groups in which the private endpoint IP configuration is included.')
  applicationSecurityGroupResourceIds: string[]?

  @sys.description('Optional. The custom name of the network interface attached to the private endpoint.')
  customNetworkInterfaceName: string?

  @sys.description('Optional. Specify the type of lock.')
  lock: lockType

  @sys.description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
  roleAssignments: roleAssignmentType

  @sys.description('Optional. Tags to be applied on all resources/resource groups in this deployment.')
  tags: object?

  @sys.description('Optional. Manual PrivateLink Service Connections.')
  manualPrivateLinkServiceConnections: array?

  @sys.description('Optional. Enable/Disable usage telemetry for module.')
  enableTelemetry: bool?
}[]?

type diagnosticSettingType = {
  @sys.description('Optional. The name of diagnostic setting.')
  name: string?

  @sys.description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to \'\' to disable log collection.')
  logCategoriesAndGroups: {
    @sys.description('Optional. Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.')
    category: string?

    @sys.description('Optional. Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to \'AllLogs\' to collect all logs.')
    categoryGroup: string?
  }[]?

  @sys.description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to \'\' to disable log collection.')
  metricCategories: {
    @sys.description('Required. Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to \'AllMetrics\' to collect all metrics.')
    category: string
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
