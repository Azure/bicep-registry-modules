metadata name = 'Healthcare API Workspace FHIR Services'
metadata description = 'This module deploys a Healthcare API Workspace FHIR Service.'
metadata owner = 'Azure/module-maintainers'

@minLength(3)
@maxLength(24)
@description('Required. The name of the FHIR service.')
param name string

@allowed([
  'fhir-R4'
  'fhir-Stu3'
])
@description('Optional. The kind of the service. Defaults to R4.')
param kind string = 'fhir-R4'

@description('Conditional. The name of the parent health data services workspace. Required if the template is used in a standalone deployment.')
param workspaceName string

@description('Optional. List of Azure AD object IDs (User or Apps) that is allowed access to the FHIR service.')
param accessPolicyObjectIds array?

@description('Optional. The list of the Azure container registry login servers.')
param acrLoginServers array?

@description('Optional. The list of Open Container Initiative (OCI) artifacts.')
param acrOciArtifacts array?

@description('Optional. The authority url for the service.')
param authenticationAuthority string = uri(environment().authentication.loginEndpoint, subscription().tenantId)

@description('Optional. The audience url for the service.')
param authenticationAudience string = 'https://${workspaceName}-${name}.fhir.azurehealthcareapis.com'

@description('Optional. Specify URLs of origin sites that can access this API, or use "*" to allow access from any site.')
param corsOrigins array?

@description('Optional. Specify HTTP headers which can be used during the request. Use "*" for any header.')
param corsHeaders array?

@allowed([
  'DELETE'
  'GET'
  'OPTIONS'
  'PATCH'
  'POST'
  'PUT'
])
@description('Optional. Specify the allowed HTTP methods.')
param corsMethods array?

@description('Optional. Specify how long a result from a request can be cached in seconds. Example: 600 means 10 minutes.')
param corsMaxAge int?

@description('Optional. Use this setting to indicate that cookies should be included in CORS requests.')
param corsAllowCredentials bool = false

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingType

@description('Optional. The name of the default export storage account.')
param exportStorageAccountName string?

@description('Optional. The name of the default integration storage account.')
param importStorageAccountName string = ''

@description('Optional. If the import operation is enabled.')
param importEnabled bool = false

@description('Optional. If the FHIR service is in InitialImportMode.')
param initialImportMode bool = false

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@allowed([
  'Disabled'
  'Enabled'
])
@description('Optional. Control permission for data plane traffic coming from public networks while private endpoint is enabled.')
param publicNetworkAccess string = 'Disabled'

@allowed([
  'no-version'
  'versioned'
  'versioned-update'
])
@description('Optional. The default value for tracking history across all resources.')
param resourceVersionPolicy string = 'versioned'

@description('Optional. A list of FHIR Resources and their version policy overrides.')
param resourceVersionOverrides object?

@description('Optional. If the SMART on FHIR proxy is enabled.')
param smartProxyEnabled bool = false

@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentitiesType

@description('Optional. Tags of the resource.')
param tags object?

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

var exportConfiguration = {
  storageAccountName: exportStorageAccountName
}

// =========== //
// Deployments //
// =========== //
var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'DICOM Data Owner': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '58a3b984-7adf-4c20-983a-32417c86fbc8'
  )
  'DICOM Data Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'e89c7a3c-2f64-4fa1-a847-3e4c9ba4283a'
  )
  'FHIR Data Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '5a1fc7df-4bf1-4951-a576-89034ee01acd'
  )
  'FHIR Data Converter': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'a1705bd2-3a8f-45a5-8683-466fcfd5cc24'
  )
  'FHIR Data Exporter': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '3db33094-8700-4567-8da5-1501d4e7e843'
  )
  'FHIR Data Importer': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '4465e953-8ced-4406-a58e-0f6e3f3b530b'
  )
  'FHIR Data Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '4c8d0bbc-75d3-4935-991f-5f3c56d81508'
  )
  'FHIR Data Writer': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '3f88fce4-5892-4214-ae73-ba5294559913'
  )
  'FHIR SMART User': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '4ba50f17-9666-485c-a643-ff00808643f0'
  )
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

resource workspace 'Microsoft.HealthcareApis/workspaces@2022-06-01' existing = {
  name: workspaceName
}

resource fhir 'Microsoft.HealthcareApis/workspaces/fhirservices@2022-06-01' = {
  name: name
  parent: workspace
  location: location
  kind: kind
  tags: tags
  identity: identity
  properties: {
    accessPolicies: [
      for id in accessPolicyObjectIds ?? []: {
        objectId: id
      }
    ]
    authenticationConfiguration: {
      authority: authenticationAuthority
      audience: authenticationAudience
      smartProxyEnabled: smartProxyEnabled
    }
    corsConfiguration: {
      allowCredentials: corsAllowCredentials
      headers: corsHeaders
      maxAge: corsMaxAge
      methods: corsMethods
      origins: corsOrigins
    }
    publicNetworkAccess: publicNetworkAccess
    exportConfiguration: empty(exportStorageAccountName) ? {} : exportConfiguration
    importConfiguration: {
      enabled: importEnabled
      initialImportMode: initialImportMode
      integrationDataStore: importStorageAccountName
    }
    resourceVersionPolicyConfiguration: {
      default: resourceVersionPolicy
      resourceTypeOverrides: resourceVersionOverrides
    }
    acrConfiguration: {
      loginServers: acrLoginServers
      ociArtifacts: acrOciArtifacts
    }
  }
}

resource fhir_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: fhir
}

resource fhir_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
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
    scope: fhir
  }
]

resource fhir_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(fhir.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: fhir
  }
]

@description('The name of the fhir service.')
output name string = fhir.name

@description('The resource ID of the fhir service.')
output resourceId string = fhir.id

@description('The resource group where the namespace is deployed.')
output resourceGroupName string = resourceGroup().name

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string = (managedIdentities.?systemAssigned ?? false) && contains(
    fhir.identity,
    'principalId'
  )
  ? fhir.identity.principalId
  : ''

@description('The location the resource was deployed into.')
output location string = fhir.location

@description('The name of the fhir workspace.')
output workspaceName string = workspace.name

// =============== //
//   Definitions   //
// =============== //

type managedIdentitiesType = {
  @description('Optional. Enables system assigned managed identity on the resource.')
  systemAssigned: bool?

  @description('Optional. The resource ID(s) to assign to the resource.')
  userAssignedResourceIds: string[]?
}?

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

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
