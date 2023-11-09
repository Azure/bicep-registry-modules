@sys.description('Required. Name of the Host Pool.')
@minLength(1)
param name string

@sys.description('Optional. Location for all resources.')
param location string = resourceGroup().location

@sys.description('Optional. The friendly name of the Host Pool to be created.')
param friendlyName string = ''

@sys.description('Optional. The description of the Host Pool to be created.')
param description string = ''

@sys.description('Optional. Set this parameter to Personal if you would like to enable Persistent Desktop experience. Defaults to Pooled.')
@allowed([
  'Personal'
  'Pooled'
])
param type string = 'Pooled'

@sys.description('Optional. Set the type of assignment for a Personal Host Pool type.')
@allowed([
  'Automatic'
  'Direct'
  ''
])
param personalDesktopAssignmentType string = ''

@sys.description('Optional. Type of load balancer algorithm.')
@allowed([
  'BreadthFirst'
  'DepthFirst'
  'Persistent'
])
param loadBalancerType string = 'BreadthFirst'

@sys.description('Optional. Maximum number of sessions.')
param maxSessionLimit int = 99999

@sys.description('Optional. Host Pool RDP properties.')
param customRdpProperty string = 'audiocapturemode:i:1;audiomode:i:0;drivestoredirect:s:;redirectclipboard:i:1;redirectcomports:i:1;redirectprinters:i:1;redirectsmartcards:i:1;screen mode id:i:2;'

@sys.description('Optional. Validation host pools allows you to test service changes before they are deployed to production. When set to true, the Host Pool will be deployed in a validation \'ring\' (environment) that receives all the new features (might be less stable). Defaults to false that stands for the stable, production-ready environment.')
param validationEnvironment bool = false

@sys.description('Optional. The necessary information for adding more VMs to this Host Pool.')
param vmTemplate object = {}

@sys.description('Optional. Host Pool token validity length. Usage: \'PT8H\' - valid for 8 hours; \'P5D\' - valid for 5 days; \'P1Y\' - valid for 1 year. When not provided, the token will be valid for 8 hours.')
param tokenValidityLength string = 'PT8H'

@sys.description('Generated. Do not provide a value! This date value is used to generate a registration token.')
param baseTime string = utcNow('u')

// @sys.description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
// @minValue(0)
// @maxValue(365)
// param diagnosticLogsRetentionInDays int = 365

@sys.description('Optional. Resource ID of the diagnostic storage account.')
param diagnosticStorageAccountId string = ''

@sys.description('Optional. Resource ID of the diagnostic log analytics workspace.')
param diagnosticWorkspaceId string = ''

@sys.description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param diagnosticEventHubAuthorizationRuleId string = ''

@sys.description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param diagnosticEventHubName string = ''

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@sys.description('Optional. Specify the type of lock.')
param lock string = ''

@sys.description('Optional. Tags of the resource.')
param tags object = {}

@sys.description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@sys.description('Optional. The type of preferred application group type, default to Desktop Application Group.')
@allowed([
  'Desktop'
  'None'
  'RailApplications'
])
param preferredAppGroupType string = 'Desktop'

@sys.description('Optional. Enable Start VM on connect to allow users to start the virtual machine from a deallocated state. Important: Custom RBAC role required to power manage VMs.')
param startVMOnConnect bool = false

@sys.description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalIds\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@sys.description('Optional. The session host configuration for updating agent, monitoring agent, and stack component.')
param agentUpdate object = {
  useSessionHostLocalTime: true
}

@sys.description('Optional. The ring number of HostPool.')
param ring int = -1

@sys.description('Optional. URL to customer ADFS server for signing WVD SSO certificates.')
param ssoadfsAuthority string = ''

@sys.description('Optional. ClientId for the registered Relying Party used to issue WVD SSO certificates.')
param ssoClientId string = ''

@sys.description('Optional. Path to Azure KeyVault storing the secret used for communication to ADFS.')
#disable-next-line secure-secrets-in-params
param ssoClientSecretKeyVaultPath string = ''

@sys.description('Optional. The type of single sign on Secret Type.')
@allowed([
  ''
  'Certificate'
  'CertificateInKeyVault'
  'SharedKey'
  'SharedKeyInKeyVault'
])
#disable-next-line secure-secrets-in-params
param ssoSecretType string = ''

@sys.description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource.')
@allowed([
  'allLogs'
  'Checkpoint'
  'Error'
  'Management'
  'Connection'
  'HostRegistration'
  'AgentHealthStatus'
])
param diagnosticLogCategoriesToEnable array = [
  'allLogs'
]

@sys.description('Optional. The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings".')
param diagnosticSettingsName string = ''

var diagnosticsLogsSpecified = [for category in filter(diagnosticLogCategoriesToEnable, item => item != 'allLogs'): {
  category: category
  enabled: true
  /*retentionPolicy: {
      enabled: true
      days: diagnosticLogsRetentionInDays
  }*/
}]

var builtInRoleNames = {
  'Application Group Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ca6382a4-1721-4bcf-a114-ff0c70227b6b')
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Desktop Virtualization Application Group Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '86240b0e-9422-4c43-887b-b61143f32ba8')
  'Desktop Virtualization Application Group Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'aebf23d0-b568-4e86-b8f9-fe83a2c6ab55')
  'Desktop Virtualization Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '082f0a83-3be5-4ba1-904c-961cca79b387')
  'Desktop Virtualization Host Pool Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'e307426c-f9b6-4e81-87de-d99efb3c32bc')
  'Desktop Virtualization Host Pool Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ceadfde2-b300-400a-ab7b-6143895aa822')
  'Desktop Virtualization Power On Off Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '40c5ff49-9181-41f8-ae61-143b0e78555e')
  'Desktop Virtualization Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '49a72310-ab8d-41df-bbb0-79b649203868')
  'Desktop Virtualization Session Host Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '2ad6aaab-ead9-4eaa-8ac5-da422f562408')
  'Desktop Virtualization User': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '1d18fff3-a72a-46b5-b4a9-0b38a3cd7e63')
  'Desktop Virtualization User Session Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ea4bfff8-7fb4-485a-aadd-d4129a0ffaa6')
  'Desktop Virtualization Virtual Machine Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a959dbd1-f747-45e3-8ba6-dd80f235f97c')
  'Desktop Virtualization Workspace Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '21efdde3-836f-432b-bf3d-3e8e734d4b2b')
  'Desktop Virtualization Workspace Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '0fa44ee9-7a7d-466b-9bb2-2bf446b1204d')
  'Log Analytics Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '92aaf0da-9dab-42b6-94a3-d43ce8d16293')
  'Log Analytics Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '73c42c96-874c-492b-b04d-ab87d138a893')
  'Managed Application Contributor Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '641177b8-a67a-45b9-a033-47bc880bb21e')
  'Managed Application Operator Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c7393b34-138c-406f-901b-d8cf2b17e6ae')
  'Managed Applications Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b9331d33-8a36-4f8c-b097-4f54124fdb44')
  'Monitoring Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '749f88d5-cbae-40b8-bcfc-e573ddc772fa')
  'Monitoring Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '43d0d8ad-25c7-4714-9337-8ba259a9fe05')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Resource Policy Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '36243c78-bf99-498c-9df9-86d9f8d28608')
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f58310d9-a9f6-439a-9e8d-f62e7b41a168')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
}

var diagnosticsLogs = contains(diagnosticLogCategoriesToEnable, 'allLogs') ? [
  {
    categoryGroup: 'allLogs'
    enabled: true
    /*retentionPolicy: {
      enabled: true
      days: diagnosticLogsRetentionInDays
  }*/
  }
] : diagnosticsLogsSpecified

var tokenExpirationTime = dateTimeAdd(baseTime, tokenValidityLength)

resource avmTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
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

resource hostPool 'Microsoft.DesktopVirtualization/hostPools@2022-09-09' = {
  name: name
  location: location
  tags: tags
  properties: {
    friendlyName: friendlyName
    description: description
    hostPoolType: type
    customRdpProperty: customRdpProperty
    personalDesktopAssignmentType: any(personalDesktopAssignmentType)
    preferredAppGroupType: preferredAppGroupType
    maxSessionLimit: maxSessionLimit
    loadBalancerType: loadBalancerType
    startVMOnConnect: startVMOnConnect
    validationEnvironment: validationEnvironment
    registrationInfo: {
      expirationTime: tokenExpirationTime
      token: null
      registrationTokenOperation: 'Update'
    }
    vmTemplate: ((!empty(vmTemplate)) ? null : string(vmTemplate))
    agentUpdate: agentUpdate
    ring: ring != -1 ? ring : null
    ssoadfsAuthority: ssoadfsAuthority
    ssoClientId: ssoClientId
    ssoClientSecretKeyVaultPath: ssoClientSecretKeyVaultPath
    ssoSecretType: !empty(ssoSecretType) ? ssoSecretType : null
  }
}

resource hostPool_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${hostPool.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: hostPool
}

resource hostPool_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(diagnosticWorkspaceId)) || (!empty(diagnosticEventHubAuthorizationRuleId)) || (!empty(diagnosticEventHubName))) {
  name: !empty(diagnosticSettingsName) ? diagnosticSettingsName : '${name}-diagnosticSettings'
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    logs: diagnosticsLogs
  }
  scope: hostPool
}

resource appGroup_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (roleAssignment, index) in (roleAssignments ?? []): {
  name: guid(hostPool.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName
    principalId: roleAssignment.principalId
    description: roleAssignment.?description
    principalType: roleAssignment.?principalType
    condition: roleAssignment.?condition
    conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
    delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
  }
  scope: hostPool
}]

/*
module hostPool_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-HostPool-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: hostPool.id
  }
}]
*/

@sys.description('The resource ID of the AVD host pool.')
output resourceId string = hostPool.id

@sys.description('The resource group the AVD host pool was deployed into.')
output resourceGroupName string = resourceGroup().name

@sys.description('The name of the AVD host pool.')
output name string = hostPool.name

@sys.description('The expiration time for the registration token.')
output tokenExpirationTime string = dateTimeAdd(baseTime, tokenValidityLength)

@sys.description('The location the resource was deployed into.')
output location string = hostPool.location
