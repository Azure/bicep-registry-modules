metadata name = 'Azure Virtual Desktop Application Group'
metadata description = 'This module deploys an Azure Virtual Desktop Application Group.'
metadata owner = 'Azure/module-maintainers'

@sys.description('Required. Name of the Application Group to create this application in.')
@minLength(3)
param name string

@sys.description('Optional. Location for all resources.')
param location string = resourceGroup().location

@sys.description('Required. The type of the Application Group to be created. Allowed values: RemoteApp or Desktop.')
@allowed([
  'RemoteApp'
  'Desktop'
])
param applicationGroupType string

@sys.description('Required. Name of the Host Pool to be linked to this Application Group.')
param hostpoolName string

@sys.description('Optional. The friendly name of the Application Group to be created.')
param friendlyName string = name

@sys.description('Optional. Description of the application group')
param description string = ''

@sys.description('Optional. List of applications to be created in the Application Group.')
param applications array = []

@sys.description('Optional. Tags of the application group.')
param tags object = {}

@sys.description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments roleAssignmentType

@sys.description('Optional. Lock settings of the application group.')
param lock lockType

@sys.description('Optional. Enable telemetry.')
param enableTelemetry bool = true

@sys.description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingType

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

resource avmTelemetry 'Microsoft.Resources/deployments@2023-07-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.destopvirtualization-ag.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource appGroup_hostpool 'Microsoft.DesktopVirtualization/hostPools@2022-09-09' existing = {
  name: hostpoolName
}

resource appGroup 'Microsoft.DesktopVirtualization/applicationGroups@2023-09-05' = {
  name: name
  location: location
  tags: tags
  properties: {
    hostPoolArmPath: appGroup_hostpool.id
    friendlyName: friendlyName
    description: description
    applicationGroupType: applicationGroupType
  }
}

module appGroup_applications 'applications/main.bicep' = [for (application, index) in applications: {
  name: '${uniqueString(deployment().name, location)}-AppGroup-App-${index}'
  params: {
    name: application.name
    applicationGroupName: appGroup.name
    description: contains(application, 'description') ? application.description : ''
    friendlyName: contains(application, 'friendlyName') ? application.friendlyName : appGroup.name
    filePath: application.filePath
    commandLineSetting: contains(application, 'commandLineSetting') ? application.commandLineSetting : 'DoNotAllow'
    commandLineArguments: contains(application, 'commandLineArguments') ? application.commandLineArguments : ''
    showInPortal: contains(application, 'showInPortal') ? application.showInPortal : false
    iconPath: contains(application, 'iconPath') ? application.iconPath : application.filePath
    iconIndex: contains(application, 'iconIndex') ? application.iconIndex : 0
    enableTelemetry: enableTelemetry
  }
}]

resource appGroup_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot delete or modify the resource or child resources.'
  }
  scope: appGroup
}

resource appGroup_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (roleAssignment, index) in (roleAssignments ?? []): {
  name: guid(appGroup.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName
    principalId: roleAssignment.principalId
    description: roleAssignment.?description
    principalType: roleAssignment.?principalType
    condition: roleAssignment.?condition
    conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null
    delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
  }
  scope: appGroup
}]

resource appGroup_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [for (diagnosticSetting, index) in (diagnosticSettings ?? []): {
  name: diagnosticSetting.?name ?? '${name}-diagnosticSettings'
  properties: {
    storageAccountId: diagnosticSetting.?storageAccountResourceId
    workspaceId: diagnosticSetting.?workspaceResourceId
    eventHubAuthorizationRuleId: diagnosticSetting.?eventHubAuthorizationRuleResourceId
    eventHubName: diagnosticSetting.?eventHubName
    logs: diagnosticSetting.?logCategoriesAndGroups ?? [
      {
        categoryGroup: 'allLogs'
        enabled: true
      }
    ]
    marketplacePartnerId: diagnosticSetting.?marketplacePartnerResourceId
    logAnalyticsDestinationType: diagnosticSetting.?logAnalyticsDestinationType
  }
  scope: appGroup
}]

@sys.description('The resource ID of the scaling plan.')
output resourceId string = appGroup.id

@sys.description('The name of the resource group the scaling plan was created in.')
output resourceGroupName string = resourceGroup().name

@sys.description('The name of the scaling plan.')
output name string = appGroup.name

@sys.description('The location of the scaling plan.')
output location string = appGroup.location

// ================ //
// Definitions      //
// ================ //

type lockType = {
  @sys.description('Optional. Specify the name of lock.')
  name: string?

  @sys.description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

type roleAssignmentType = {
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

  @sys.description('Optional. The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to \'\' to disable metric collection.')
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
