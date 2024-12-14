metadata name = 'Web Tests'
metadata description = 'This module deploys a Web Test.'
metadata owner = 'Azure/module-maintainers'

@sys.description('Required. Name of the webtest.')
param name string

@sys.description('Required. Resource ID of the App Insights resource to link with this webtest.')
param appInsightResourceId string

@sys.description('Required. User defined name if this WebTest.')
param webTestName string

@sys.description('Optional. Resource tags. Note: a mandatory tag \'hidden-link\' based on the \'appInsightResourceId\' parameter will be automatically added to the tags defined here.')
param tags object?

@sys.description('Required. The collection of request properties.')
param request object

@sys.description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@sys.description('Optional. User defined description for this WebTest.')
param description string = ''

@sys.description('Optional. Unique ID of this WebTest.')
param syntheticMonitorId string = name

@sys.description('Optional. The kind of WebTest that this web test watches.')
@allowed([
  'multistep'
  'ping'
  'standard'
])
param kind string = 'standard'

@sys.description('Optional. List of where to physically run the tests from to give global coverage for accessibility of your application.')
param locations array = [
  {
    Id: 'us-il-ch1-azr'
  }
  {
    Id: 'us-fl-mia-edge'
  }
  {
    Id: 'latam-br-gru-edge'
  }
  {
    Id: 'apac-sg-sin-azr'
  }
  {
    Id: 'emea-nl-ams-azr'
  }
]

@sys.description('Optional. Is the test actively being monitored.')
param enabled bool = true

@sys.description('Optional. Interval in seconds between test runs for this WebTest.')
param frequency int = 300

@sys.description('Optional. Seconds until this WebTest will timeout and fail.')
param timeout int = 30

@sys.description('Optional. Allow for retries should this WebTest fail.')
param retryEnabled bool = true

@sys.description('Optional. The collection of validation rule properties.')
param validationRules object = {}

@sys.description('Optional. An XML configuration specification for a WebTest.')
param configuration object?

@sys.description('Optional. The lock settings of the service.')
param lock lockType

@sys.description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@sys.description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var hiddenLinkTag = {
  'hidden-link:${appInsightResourceId}': 'Resource'
}

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
  name: '46d3xbcp.res.insights-webtest.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource webtest 'Microsoft.Insights/webtests@2022-06-15' = {
  name: name
  location: location
  tags: union(tags ?? {}, hiddenLinkTag)
  properties: {
    Kind: kind
    Locations: locations
    Name: webTestName
    Description: description
    SyntheticMonitorId: syntheticMonitorId
    Enabled: enabled
    Frequency: frequency
    Timeout: timeout
    RetryEnabled: retryEnabled
    Request: request
    ValidationRules: validationRules
    Configuration: configuration
  }
}

resource webtest_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: webtest
}

resource webtest_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(webtest.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: webtest
  }
]

@sys.description('The name of the webtest.')
output name string = webtest.name

@sys.description('The resource ID of the webtest.')
output resourceId string = webtest.id

@sys.description('The resource group the resource was deployed into.')
output resourceGroupName string = resourceGroup().name

@sys.description('The location the resource was deployed into.')
output location string = webtest.location

// =============== //
//   Definitions   //
// =============== //

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
