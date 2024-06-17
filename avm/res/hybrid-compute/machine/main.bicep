metadata name = 'Hybrid Compute Machines'
metadata description = 'This module deploys a Arc machine with one or multiple NICs and optionally one or multiple public IPs.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the Arc machine to be created. You should use a unique prefix to reduce name collisions in Active Directory.')
param name string

@description('Required. Kind of Arc machine to be created. Possible values are: HCI, SCVMM, VMware')
param kind string

// Child resources
@description('Optional. Required if name is specified. Password of the user specified in user parameter.')
@secure()
param extensionDomainJoinPassword string = ''

@description('Optional. The configuration for the [Domain Join] extension. Must at least contain the ["enabled": true] property to be executed.')
param extensionDomainJoinConfig object = {
  enabled: false
}

@description('Optional. The configuration for the [Anti Malware] extension. Must at least contain the ["enabled": true] property to be executed.')
param extensionAntiMalwareConfig object = {
  enabled: false
}

@description('Optional. The configuration for the [Monitoring Agent] extension. Must at least contain the ["enabled": true] property to be executed.')
param extensionMonitoringAgentConfig object = {
  enabled: false
}

@description('Optional. The configuration for the [Dependency Agent] extension. Must at least contain the ["enabled": true] property to be executed.')
param extensionDependencyAgentConfig object = {
  enabled: false
}

@description('Optional. The configuration for the [Desired State Configuration] extension. Must at least contain the ["enabled": true] property to be executed.')
param extensionDSCConfig object = {
  enabled: false
}

@description('Optional. The configuration for the [Custom Script] extension. Must at least contain the ["enabled": true] property to be executed.')
param extensionCustomScriptConfig object = {
  enabled: false
  fileData: []
}

@description('Optional. The configuration for the [Guest Configuration] extension. Must at least contain the ["enabled": true] property to be executed. Needs a managed identy.')
param extensionGuestConfigurationExtension object = {
  enabled: false
}

@description('Optional. The guest configuration for the Arc machine. Needs the Guest Configuration extension to be enabled.')
param guestConfiguration object = {}

@description('Optional. An object that contains the extension specific protected settings.')
@secure()
param extensionCustomScriptProtectedSetting object = {}

@description('Optional. An object that contains the extension specific protected settings.')
@secure()
param extensionGuestConfigurationExtensionProtectedSettings object = {}

@description('Conditional. The chosen OS type.')
@allowed([
  'Windows'
  'Linux'
  ''
])
param osType string = ''

// Shared parameters
@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. Tags of the resource.')
param tags object?

@description('Generated. Do not provide a value! This date value is used to generate a registration token.')
param baseTime string = utcNow('u')

@description('Optional. SAS token validity length to use to download files from storage accounts. Usage: \'PT8H\' - valid for 8 hours; \'P5D\' - valid for 5 days; \'P1Y\' - valid for 1 year. When not provided, the SAS token will be valid for 8 hours.')
param sasTokenValidityLength string = 'PT8H'

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. The configuration profile of automanage. Either \'/providers/Microsoft.Automanage/bestPractices/AzureBestPracticesProduction\', \'providers/Microsoft.Automanage/bestPractices/AzureBestPracticesDevTest\' or the resource Id of custom profile.')
param configurationProfile string = ''

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
  'Arc machine Administrator Login': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '1c0163c0-47e6-4577-8991-ea5c82e286e4'
  )
  'Arc machine Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '9980e02c-c2be-4d73-94e8-173b1dc7cf3c'
  )
  'Arc machine User Login': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'fb879df8-f326-4884-b1cf-06f3ad86be52'
  )
}

var accountSasProperties = {
  signedServices: 'b'
  signedPermission: 'r'
  signedExpiry: dateTimeAdd(baseTime, sasTokenValidityLength)
  signedResourceTypes: 'o'
  signedProtocol: 'https'
}

resource #_namePrefix_#Telemetry 'Microsoft.Resources/deployments@2023-07-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.hybridcompute-machine.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '#_moduleVersion_#.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/#_namePrefix_#/TelemetryInfo'
        }
      }
    }
  }
}

resource machine 'Microsoft.HybridCompute/machines@2023-03-15-preview' = {
  name: name
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  tags: tags
  kind: kind
  properties: {}
}

resource machine_configurationProfileAssignment 'Microsoft.Automanage/configurationProfileAssignments@2022-05-04' = if (!empty(configurationProfile)) {
  name: 'default'
  properties: {
    configurationProfile: configurationProfile
  }
  scope: machine
}

module machine_domainJoinExtension 'extension/main.bicep' = if (extensionDomainJoinConfig.enabled) {
  name: '${uniqueString(deployment().name, location)}-VM-DomainJoin'
  params: {
    arcMachineName: machine.name
    name: 'DomainJoin'
    location: location
    publisher: 'Microsoft.Compute'
    type: 'JsonADDomainExtension'
    typeHandlerVersion: contains(extensionDomainJoinConfig, 'typeHandlerVersion')
      ? extensionDomainJoinConfig.typeHandlerVersion
      : '1.3'
    autoUpgradeMinorVersion: contains(extensionDomainJoinConfig, 'autoUpgradeMinorVersion')
      ? extensionDomainJoinConfig.autoUpgradeMinorVersion
      : true
    enableAutomaticUpgrade: contains(extensionDomainJoinConfig, 'enableAutomaticUpgrade')
      ? extensionDomainJoinConfig.enableAutomaticUpgrade
      : false
    settings: extensionDomainJoinConfig.settings
    supressFailures: extensionDomainJoinConfig.?supressFailures ?? false
    tags: extensionDomainJoinConfig.?tags ?? tags
    protectedSettings: {
      Password: extensionDomainJoinPassword
    }
  }
}

module machine_microsoftAntiMalwareExtension 'extension/main.bicep' = if (extensionAntiMalwareConfig.enabled) {
  name: '${uniqueString(deployment().name, location)}-VM-MicrosoftAntiMalware'
  params: {
    arcMachineName: machine.name
    name: 'MicrosoftAntiMalware'
    location: location
    publisher: 'Microsoft.Azure.Security'
    type: 'IaaSAntimalware'
    typeHandlerVersion: contains(extensionAntiMalwareConfig, 'typeHandlerVersion')
      ? extensionAntiMalwareConfig.typeHandlerVersion
      : '1.3'
    autoUpgradeMinorVersion: contains(extensionAntiMalwareConfig, 'autoUpgradeMinorVersion')
      ? extensionAntiMalwareConfig.autoUpgradeMinorVersion
      : true
    enableAutomaticUpgrade: contains(extensionAntiMalwareConfig, 'enableAutomaticUpgrade')
      ? extensionAntiMalwareConfig.enableAutomaticUpgrade
      : false
    settings: extensionAntiMalwareConfig.settings
    supressFailures: extensionAntiMalwareConfig.?supressFailures ?? false
    tags: extensionAntiMalwareConfig.?tags ?? tags
  }
  dependsOn: [
    machine_domainJoinExtension
  ]
}

resource machine_logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = if (!empty(extensionMonitoringAgentConfig.?monitoringWorkspaceId)) {
  name: last(split(
    (!empty(extensionMonitoringAgentConfig.?monitoringWorkspaceId ?? '')
      ? extensionMonitoringAgentConfig.monitoringWorkspaceId
      : 'law'),
    '/'
  ))!
  scope: az.resourceGroup(
    split(
      (!empty(extensionMonitoringAgentConfig.?monitoringWorkspaceId ?? '')
        ? extensionMonitoringAgentConfig.monitoringWorkspaceId
        : '//'),
      '/'
    )[2],
    split(
      (!empty(extensionMonitoringAgentConfig.?monitoringWorkspaceId ?? '')
        ? extensionMonitoringAgentConfig.monitoringWorkspaceId
        : '////'),
      '/'
    )[4]
  )
}

module machine_azureMonitorAgentExtension 'extension/main.bicep' = if (extensionMonitoringAgentConfig.enabled) {
  name: '${uniqueString(deployment().name, location)}-VM-AzureMonitorAgent'
  params: {
    arcMachineName: machine.name
    name: 'AzureMonitorAgent'
    location: location
    publisher: 'Microsoft.Azure.Monitor'
    type: osType == 'Windows' ? 'AzureMonitorWindowsAgent' : 'AzureMonitorLinuxAgent'
    typeHandlerVersion: extensionMonitoringAgentConfig.?typeHandlerVersion ?? (osType == 'Windows' ? '1.22' : '1.29')
    autoUpgradeMinorVersion: extensionMonitoringAgentConfig.?autoUpgradeMinorVersion ?? true
    enableAutomaticUpgrade: extensionMonitoringAgentConfig.?enableAutomaticUpgrade ?? false
    settings: {
      workspaceId: !empty(extensionMonitoringAgentConfig.?monitoringWorkspaceId ?? '')
        ? machine_logAnalyticsWorkspace.properties.customerId
        : ''
      GCS_AUTO_CONFIG: osType == 'Linux' ? true : null
    }
    supressFailures: extensionMonitoringAgentConfig.?supressFailures ?? false
    tags: extensionMonitoringAgentConfig.?tags ?? tags
    protectedSettings: {
      workspaceKey: !empty(extensionMonitoringAgentConfig.?monitoringWorkspaceId ?? '')
        ? machine_logAnalyticsWorkspace.listKeys().primarySharedKey
        : ''
    }
  }
  dependsOn: [
    machine_microsoftAntiMalwareExtension
  ]
}

module machine_dependencyAgentExtension 'extension/main.bicep' = if (extensionDependencyAgentConfig.enabled) {
  name: '${uniqueString(deployment().name, location)}-VM-DependencyAgent'
  params: {
    arcMachineName: machine.name
    name: 'DependencyAgent'
    location: location
    publisher: 'Microsoft.Azure.Monitoring.DependencyAgent'
    type: osType == 'Windows' ? 'DependencyAgentWindows' : 'DependencyAgentLinux'
    typeHandlerVersion: contains(extensionDependencyAgentConfig, 'typeHandlerVersion')
      ? extensionDependencyAgentConfig.typeHandlerVersion
      : '9.10'
    autoUpgradeMinorVersion: contains(extensionDependencyAgentConfig, 'autoUpgradeMinorVersion')
      ? extensionDependencyAgentConfig.autoUpgradeMinorVersion
      : true
    enableAutomaticUpgrade: contains(extensionDependencyAgentConfig, 'enableAutomaticUpgrade')
      ? extensionDependencyAgentConfig.enableAutomaticUpgrade
      : true
    settings: {
      enableAMA: contains(extensionDependencyAgentConfig, 'enableAMA') ? extensionDependencyAgentConfig.enableAMA : true
    }
    supressFailures: extensionDependencyAgentConfig.?supressFailures ?? false
    tags: extensionDependencyAgentConfig.?tags ?? tags
  }
  dependsOn: [
    machine_azureMonitorAgentExtension
  ]
}

module machine_desiredStateConfigurationExtension 'extension/main.bicep' = if (extensionDSCConfig.enabled) {
  name: '${uniqueString(deployment().name, location)}-VM-DesiredStateConfiguration'
  params: {
    arcMachineName: machine.name
    name: 'DesiredStateConfiguration'
    location: location
    publisher: 'Microsoft.Powershell'
    type: 'DSC'
    typeHandlerVersion: contains(extensionDSCConfig, 'typeHandlerVersion')
      ? extensionDSCConfig.typeHandlerVersion
      : '2.77'
    autoUpgradeMinorVersion: contains(extensionDSCConfig, 'autoUpgradeMinorVersion')
      ? extensionDSCConfig.autoUpgradeMinorVersion
      : true
    enableAutomaticUpgrade: contains(extensionDSCConfig, 'enableAutomaticUpgrade')
      ? extensionDSCConfig.enableAutomaticUpgrade
      : false
    settings: contains(extensionDSCConfig, 'settings') ? extensionDSCConfig.settings : {}
    supressFailures: extensionDSCConfig.?supressFailures ?? false
    tags: extensionDSCConfig.?tags ?? tags
    protectedSettings: contains(extensionDSCConfig, 'protectedSettings') ? extensionDSCConfig.protectedSettings : {}
  }
}

module machine_customScriptExtension 'extension/main.bicep' = if (extensionCustomScriptConfig.enabled) {
  name: '${uniqueString(deployment().name, location)}-VM-CustomScriptExtension'
  params: {
    arcMachineName: machine.name
    name: 'CustomScriptExtension'
    location: location
    publisher: osType == 'Windows' ? 'Microsoft.Compute' : 'Microsoft.Azure.Extensions'
    type: osType == 'Windows' ? 'CustomScriptExtension' : 'CustomScript'
    typeHandlerVersion: contains(extensionCustomScriptConfig, 'typeHandlerVersion')
      ? extensionCustomScriptConfig.typeHandlerVersion
      : (osType == 'Windows' ? '1.10' : '2.1')
    autoUpgradeMinorVersion: contains(extensionCustomScriptConfig, 'autoUpgradeMinorVersion')
      ? extensionCustomScriptConfig.autoUpgradeMinorVersion
      : true
    enableAutomaticUpgrade: contains(extensionCustomScriptConfig, 'enableAutomaticUpgrade')
      ? extensionCustomScriptConfig.enableAutomaticUpgrade
      : false
    settings: {
      fileUris: [
        for fileData in extensionCustomScriptConfig.fileData: contains(fileData, 'storageAccountId')
          ? '${fileData.uri}?${listAccountSas(fileData.storageAccountId, '2019-04-01', accountSasProperties).accountSasToken}'
          : fileData.uri
      ]
    }
    supressFailures: extensionCustomScriptConfig.?supressFailures ?? false
    tags: extensionCustomScriptConfig.?tags ?? tags
    protectedSettings: extensionCustomScriptProtectedSetting
  }
  dependsOn: [
    machine_desiredStateConfigurationExtension
  ]
}

module machine_azureGuestConfigurationExtension 'extension/main.bicep' = if (extensionGuestConfigurationExtension.enabled) {
  name: '${uniqueString(deployment().name, location)}-VM-GuestConfiguration'
  params: {
    arcMachineName: machine.name
    name: osType == 'Windows' ? 'AzurePolicyforWindows' : 'AzurePolicyforLinux'
    location: location
    publisher: 'Microsoft.GuestConfiguration'
    type: osType == 'Windows' ? 'ConfigurationforWindows' : 'ConfigurationForLinux'
    typeHandlerVersion: contains(extensionGuestConfigurationExtension, 'typeHandlerVersion')
      ? extensionGuestConfigurationExtension.typeHandlerVersion
      : (osType == 'Windows' ? '1.0' : '1.0')
    autoUpgradeMinorVersion: contains(extensionGuestConfigurationExtension, 'autoUpgradeMinorVersion')
      ? extensionGuestConfigurationExtension.autoUpgradeMinorVersion
      : true
    enableAutomaticUpgrade: contains(extensionGuestConfigurationExtension, 'enableAutomaticUpgrade')
      ? extensionGuestConfigurationExtension.enableAutomaticUpgrade
      : true
    forceUpdateTag: contains(extensionGuestConfigurationExtension, 'forceUpdateTag')
      ? extensionGuestConfigurationExtension.forceUpdateTag
      : '1.0'
    settings: contains(extensionGuestConfigurationExtension, 'settings')
      ? extensionGuestConfigurationExtension.settings
      : {}
    supressFailures: extensionGuestConfigurationExtension.?supressFailures ?? false
    protectedSettings: extensionGuestConfigurationExtensionProtectedSettings
    tags: extensionGuestConfigurationExtension.?tags ?? tags
  }
  dependsOn: []
}

resource AzureWindowsBaseline 'Microsoft.GuestConfiguration/guestConfigurationAssignments@2020-06-25' = if (!empty(guestConfiguration)) {
  name: 'AzureWindowsBaseline'
  scope: machine
  dependsOn: [
    machine_azureGuestConfigurationExtension
  ]
  location: location
  properties: {
    guestConfiguration: guestConfiguration
  }
}

resource machine_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: machine
}

resource machine_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (roleAssignments ?? []): {
    name: guid(machine.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
    properties: {
      roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName)
        ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName]
        : contains(roleAssignment.roleDefinitionIdOrName, '/providers/Microsoft.Authorization/roleDefinitions/')
            ? roleAssignment.roleDefinitionIdOrName
            : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName)
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: machine
  }
]

@description('The name of the machine.')
output name string = machine.name

@description('The resource ID of the machine.')
output resourceId string = machine.id

@description('The name of the resource group the VM was created in.')
output resourceGroupName string = resourceGroup().name

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string = machine.?identity.?principalId ?? ''

@description('The location the resource was deployed into.')
output location string = machine.location

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
