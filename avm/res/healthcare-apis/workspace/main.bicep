metadata name = 'Healthcare API Workspaces'
metadata description = 'This module deploys a Healthcare API Workspace.'
metadata owner = 'Azure/module-maintainers'

@minLength(3)
@maxLength(24)
@description('Required. The name of the Health Data Services Workspace service.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

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

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Deploy DICOM services.')
param dicomservices array?

@description('Optional. Deploy FHIR services.')
param fhirservices array?

@description('Optional. Deploy IOT connectors.')
param iotconnectors array?

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

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.healthcareapis-workspace.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource workspace 'Microsoft.HealthcareApis/workspaces@2022-06-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    publicNetworkAccess: publicNetworkAccess
  }
}

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

module workspace_fhirservices 'fhirservice/main.bicep' = [
  for (fhir, index) in fhirservices ?? []: {
    name: '${uniqueString(deployment().name, location)}-Health-FHIR-${index}'
    params: {
      name: fhir.name
      location: location
      workspaceName: workspace.name
      kind: fhir.kind
      tags: fhir.?tags ?? tags
      publicNetworkAccess: fhir.?publicNetworkAccess
      managedIdentities: fhir.?managedIdentities
      roleAssignments: fhir.?roleAssignments
      accessPolicyObjectIds: fhir.?accessPolicyObjectIds
      acrLoginServers: fhir.?acrLoginServers
      acrOciArtifacts: fhir.?acrOciArtifacts
      authenticationAuthority: fhir.?authenticationAuthority ?? uri(
        environment().authentication.loginEndpoint,
        subscription().tenantId
      )
      authenticationAudience: fhir.?authenticationAudience ?? 'https://${workspace.name}-${fhir.name}.fhir.azurehealthcareapis.com'
      corsOrigins: fhir.?corsOrigins
      corsHeaders: fhir.?corsHeaders
      corsMethods: fhir.?corsMethods
      corsMaxAge: fhir.?corsMaxAge
      corsAllowCredentials: fhir.?corsAllowCredentials
      diagnosticSettings: fhir.?diagnosticSettings
      exportStorageAccountName: fhir.?exportStorageAccountName
      importStorageAccountName: fhir.?importStorageAccountName
      importEnabled: fhir.?importEnabled
      initialImportMode: fhir.?initialImportMode
      lock: fhir.?lock ?? lock
      resourceVersionPolicy: fhir.?resourceVersionPolicy
      resourceVersionOverrides: fhir.?resourceVersionOverrides
      smartProxyEnabled: fhir.?smartProxyEnabled
    }
  }
]

module workspace_dicomservices 'dicomservice/main.bicep' = [
  for (dicom, index) in dicomservices ?? []: {
    name: '${uniqueString(deployment().name, location)}-Health-DICOM-${index}'
    params: {
      name: dicom.name
      location: location
      workspaceName: workspace.name
      tags: dicom.?tags ?? tags
      publicNetworkAccess: dicom.?publicNetworkAccess
      managedIdentities: dicom.?managedIdentities
      corsOrigins: dicom.?corsOrigins
      corsHeaders: dicom.?corsHeaders
      corsMethods: dicom.?corsMethods
      corsMaxAge: dicom.?corsMaxAge
      corsAllowCredentials: dicom.?corsAllowCredentials
      diagnosticSettings: dicom.?diagnosticSettings
      lock: dicom.?lock ?? lock
    }
  }
]

module workspace_iotconnector 'iotconnector/main.bicep' = [
  for (iotConnector, index) in iotconnectors ?? []: {
    name: '${uniqueString(deployment().name, location)}-Health-IOMT-${index}'
    params: {
      name: iotConnector.name
      location: location
      workspaceName: workspace.name
      tags: iotConnector.?tags ?? tags
      eventHubName: iotConnector.eventHubName
      eventHubNamespaceName: iotConnector.eventHubNamespaceName
      deviceMapping: iotConnector.?deviceMapping
      fhirdestination: iotConnector.?fhirdestination
      consumerGroup: iotConnector.?consumerGroup ?? iotConnector.name
      managedIdentities: iotConnector.?managedIdentities
      diagnosticSettings: iotConnector.?diagnosticSettings
      lock: iotConnector.?lock ?? lock
    }
  }
]

@description('The name of the health data services workspace.')
output name string = workspace.name

@description('The resource ID of the health data services workspace.')
output resourceId string = workspace.id

@description('The resource group where the workspace is deployed.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = workspace.location

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
