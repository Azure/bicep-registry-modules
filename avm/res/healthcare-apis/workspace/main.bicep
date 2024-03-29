metadata name = 'Healthcare API Workspaces'
metadata description = 'This module deploys a Healthcare API Workspace.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the Health Data Services Workspace service.')
@maxLength(50)
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

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. Deploy DICOM services.')
param dicomservices array = []

@description('Optional. Deploy FHIR services.')
param fhirservices array = []

@description('Optional. Deploy IOT connectors.')
param iotconnectors array = []

var enableReferencedModulesTelemetry = false

// =========== //
// Deployments //
// =========== //
var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'DICOM Data Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '58a3b984-7adf-4c20-983a-32417c86fbc8')
  'DICOM Data Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'e89c7a3c-2f64-4fa1-a847-3e4c9ba4283a')
  'FHIR Data Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '5a1fc7df-4bf1-4951-a576-89034ee01acd')
  'FHIR Data Converter': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a1705bd2-3a8f-45a5-8683-466fcfd5cc24')
  'FHIR Data Exporter': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3db33094-8700-4567-8da5-1501d4e7e843')
  'FHIR Data Importer': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4465e953-8ced-4406-a58e-0f6e3f3b530b')
  'FHIR Data Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4c8d0bbc-75d3-4935-991f-5f3c56d81508')
  'FHIR Data Writer': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3f88fce4-5892-4214-ae73-ba5294559913')
  'FHIR SMART User': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4ba50f17-9666-485c-a643-ff00808643f0')
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
    notes: lock.?kind == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot delete or modify the resource or child resources.'
  }
  scope: workspace
}

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

module workspace_fhirservices 'fhirservice/main.bicep' = [for (fhir, index) in fhirservices: {
  name: '${uniqueString(deployment().name, location)}-Health-FHIR-${index}'
  params: {
    name: fhir.name
    location: location
    workspaceName: workspace.name
    kind: fhir.kind
    tags: fhir.?tags ?? tags
    publicNetworkAccess: contains(fhir, 'publicNetworkAccess') ? fhir.publicNetworkAccess : 'Disabled'
    managedIdentities: contains(fhir, 'managedIdentities') ? fhir.managedIdentities : null
    roleAssignments: contains(fhir, 'roleAssignments') ? fhir.roleAssignments : []
    accessPolicyObjectIds: contains(fhir, 'accessPolicyObjectIds') ? fhir.accessPolicyObjectIds : []
    acrLoginServers: contains(fhir, 'acrLoginServers') ? fhir.acrLoginServers : []
    acrOciArtifacts: contains(fhir, 'acrOciArtifacts') ? fhir.acrOciArtifacts : []
    authenticationAuthority: contains(fhir, 'authenticationAuthority') ? fhir.authenticationAuthority : uri(environment().authentication.loginEndpoint, subscription().tenantId)
    authenticationAudience: contains(fhir, 'authenticationAudience') ? fhir.authenticationAudience : 'https://${workspace.name}-${fhir.name}.fhir.azurehealthcareapis.com'
    corsOrigins: contains(fhir, 'corsOrigins') ? fhir.corsOrigins : []
    corsHeaders: contains(fhir, 'corsHeaders') ? fhir.corsHeaders : []
    corsMethods: contains(fhir, 'corsMethods') ? fhir.corsMethods : []
    corsMaxAge: contains(fhir, 'corsMaxAge') ? fhir.corsMaxAge : -1
    corsAllowCredentials: contains(fhir, 'corsAllowCredentials') ? fhir.corsAllowCredentials : false
    diagnosticSettings: fhir.?diagnosticSettings
    exportStorageAccountName: contains(fhir, 'exportStorageAccountName') ? fhir.exportStorageAccountName : ''
    importStorageAccountName: contains(fhir, 'importStorageAccountName') ? fhir.importStorageAccountName : ''
    importEnabled: contains(fhir, 'importEnabled') ? fhir.importEnabled : false
    initialImportMode: contains(fhir, 'initialImportMode') ? fhir.initialImportMode : false
    lock: fhir.?lock ?? lock
    resourceVersionPolicy: contains(fhir, 'resourceVersionPolicy') ? fhir.resourceVersionPolicy : 'versioned'
    resourceVersionOverrides: contains(fhir, 'resourceVersionOverrides') ? fhir.resourceVersionOverrides : {}
    smartProxyEnabled: contains(fhir, 'smartProxyEnabled') ? fhir.smartProxyEnabled : false
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module workspace_dicomservices 'dicomservice/main.bicep' = [for (dicom, index) in dicomservices: {
  name: '${uniqueString(deployment().name, location)}-Health-DICOM-${index}'
  params: {
    name: dicom.name
    location: location
    workspaceName: workspace.name
    tags: dicom.?tags ?? tags
    publicNetworkAccess: contains(dicom, 'publicNetworkAccess') ? dicom.publicNetworkAccess : 'Disabled'
    managedIdentities: contains(dicom, 'managedIdentities') ? dicom.managedIdentities : null
    corsOrigins: contains(dicom, 'corsOrigins') ? dicom.corsOrigins : []
    corsHeaders: contains(dicom, 'corsHeaders') ? dicom.corsHeaders : []
    corsMethods: contains(dicom, 'corsMethods') ? dicom.corsMethods : []
    corsMaxAge: contains(dicom, 'corsMaxAge') ? dicom.corsMaxAge : -1
    corsAllowCredentials: contains(dicom, 'corsAllowCredentials') ? dicom.corsAllowCredentials : false
    diagnosticSettings: dicom.?diagnosticSettings
    lock: dicom.?lock ?? lock
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module workspace_iotconnector 'iotconnector/main.bicep' = [for (iotConnector, index) in iotconnectors: {
  name: '${uniqueString(deployment().name, location)}-Health-IOMT-${index}'
  params: {
    name: iotConnector.name
    location: location
    workspaceName: workspace.name
    tags: iotConnector.?tags ?? tags
    eventHubName: iotConnector.eventHubName
    eventHubNamespaceName: iotConnector.eventHubNamespaceName
    deviceMapping: contains(iotConnector, 'deviceMapping') ? iotConnector.deviceMapping : {
      templateType: 'CollectionContent'
      template: []
    }
    fhirdestination: contains(iotConnector, 'fhirdestination') ? iotConnector.fhirdestination : {}
    consumerGroup: contains(iotConnector, 'consumerGroup') ? iotConnector.consumerGroup : iotConnector.name
    managedIdentities: contains(iotConnector, 'managedIdentities') ? iotConnector.managedIdentities : null
    diagnosticSettings: iotConnector.?diagnosticSettings
    lock: iotConnector.?lock ?? lock
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

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
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

type roleAssignmentType = {
  @description('Required. The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
  roleDefinitionIdOrName: string

  @description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
  principalId: string

  @description('Optional. The principal type of the assigned principal ID.')
  principalType: ('ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup' | 'Device')?

  @description('Optional. The description of the role assignment.')
  description: string?

  @description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container"')
  condition: string?

  @description('Optional. Version of the condition.')
  conditionVersion: '2.0'?

  @description('Optional. The Resource Id of the delegated managed identity resource.')
  delegatedManagedIdentityResourceId: string?
}[]?
