metadata name = 'Automation Accounts'
metadata description = 'This module deploys an Azure Automation Account.'

@description('Required. Name of the Automation Account.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. SKU name of the account.')
@allowed([
  'Free'
  'Basic'
])
param skuName string = 'Basic'

import { customerManagedKeyType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. The customer managed key definition.')
param customerManagedKey customerManagedKeyType?

@description('Optional. List of credentials to be created in the automation account.')
param credentials credentialType[]?

@description('Optional. List of modules to be created in the automation account.')
param modules array = []

@description('Optional. List of runbooks to be created in the automation account.')
param runbooks array = []

@description('Optional. List of schedules to be created in the automation account.')
param schedules array = []

@description('Optional. List of jobSchedules to be created in the automation account.')
param jobSchedules array = []

@description('Optional. List of variables to be created in the automation account.')
param variables array = []

@description('Optional. ID of the log analytics workspace to be linked to the deployed automation account.')
param linkedWorkspaceResourceId string = ''

@description('Optional. List of gallerySolutions to be created in the linked log analytics workspace.')
param gallerySolutions gallerySolutionType[]?

@description('Optional. List of softwareUpdateConfigurations to be created in the automation account.')
param softwareUpdateConfigurations array = []

@description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set.')
@allowed([
  ''
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = ''

@description('Optional. Disable local authentication profile used within the resource.')
param disableLocalAuth bool = true

import { privateEndpointMultiServiceType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointMultiServiceType[]?

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Tags of the Automation Account resource.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'SystemAssigned, UserAssigned' : 'SystemAssigned')
        : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : 'None')
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

var builtInRoleNames = {
  'Automation Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f353d9bd-d4a6-484e-a77a-8050b599b867'
  )
  'Automation Job Operator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '4fe576fe-1146-4730-92eb-48519fa6bf9f'
  )
  'Automation Operator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'd3881f73-407a-4167-8283-e981cbba0404'
  )
  'Automation Runbook Operator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '5fb5aef8-1081-4b8e-bb16-9d5d0385bab5'
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
  name: '46d3xbcp.res.automation-automationaccount.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource automationAccount 'Microsoft.Automation/automationAccounts@2022-08-08' = {
  name: name
  location: location
  tags: tags
  identity: identity
  properties: {
    sku: {
      name: skuName
    }
    encryption: !empty(customerManagedKey)
      ? {
          keySource: 'Microsoft.Keyvault'
          identity: !empty(customerManagedKey.?userAssignedIdentityResourceId)
            ? {
                userAssignedIdentity: cMKUserAssignedIdentity.id
              }
            : null
          keyVaultProperties: {
            keyName: customerManagedKey!.keyName
            keyvaultUri: cMKKeyVault.properties.vaultUri
            keyVersion: !empty(customerManagedKey.?keyVersion ?? '')
              ? customerManagedKey!.keyVersion
              : last(split(cMKKeyVault::cMKKey.properties.keyUriWithVersion, '/'))
          }
        }
      : null
    publicNetworkAccess: !empty(publicNetworkAccess)
      ? (publicNetworkAccess == 'Disabled' ? false : true)
      : (!empty(privateEndpoints) ? false : null)
    disableLocalAuth: disableLocalAuth
  }
}

module automationAccount_credentials 'credential/main.bicep' = [
  for (credential, index) in (credentials ?? []): {
    name: '${uniqueString(deployment().name, location)}-AutomationAccount-Credential-${index}'
    params: {
      automationAccountName: automationAccount.name
      name: credential.name
      password: credential.password
      userName: credential.userName
      description: credential.?description
    }
  }
]

module automationAccount_modules 'module/main.bicep' = [
  for (module, index) in modules: {
    name: '${uniqueString(deployment().name, location)}-AutoAccount-Module-${index}'
    params: {
      name: module.name
      automationAccountName: automationAccount.name
      version: module.version
      uri: module.uri
      location: location
      tags: module.?tags ?? tags
    }
  }
]

module automationAccount_schedules 'schedule/main.bicep' = [
  for (schedule, index) in schedules: {
    name: '${uniqueString(deployment().name, location)}-AutoAccount-Schedule-${index}'
    params: {
      name: schedule.name
      automationAccountName: automationAccount.name
      advancedSchedule: schedule.?advancedSchedule
      description: schedule.?description
      expiryTime: schedule.?expiryTime
      frequency: schedule.?frequency
      interval: schedule.?interval
      startTime: schedule.?startTime
      timeZone: schedule.?timeZone
    }
  }
]

module automationAccount_runbooks 'runbook/main.bicep' = [
  for (runbook, index) in runbooks: {
    name: '${uniqueString(deployment().name, location)}-AutoAccount-Runbook-${index}'
    params: {
      name: runbook.name
      automationAccountName: automationAccount.name
      type: runbook.type
      description: runbook.?description
      uri: runbook.?uri
      version: runbook.?version
      sasTokenValidityLength: runbook.?sasTokenValidityLength
      scriptStorageAccountResourceId: runbook.?scriptStorageAccountResourceId
      location: location
      tags: runbook.?tags ?? tags
    }
  }
]

module automationAccount_jobSchedules 'job-schedule/main.bicep' = [
  for (jobSchedule, index) in jobSchedules: {
    name: '${uniqueString(deployment().name, location)}-AutoAccount-JobSchedule-${index}'
    params: {
      automationAccountName: automationAccount.name
      runbookName: jobSchedule.runbookName
      scheduleName: jobSchedule.scheduleName
      parameters: jobSchedule.?parameters
      runOn: jobSchedule.?runOn
    }
    dependsOn: [
      automationAccount_schedules
      automationAccount_runbooks
    ]
  }
]

module automationAccount_variables 'variable/main.bicep' = [
  for (variable, index) in variables: {
    name: '${uniqueString(deployment().name, location)}-AutoAccount-Variable-${index}'
    params: {
      automationAccountName: automationAccount.name
      name: variable.name
      description: variable.?description
      value: variable.value
      isEncrypted: variable.?isEncrypted
    }
  }
]

module automationAccount_linkedService 'modules/linked-service.bicep' = if (!empty(linkedWorkspaceResourceId)) {
  name: '${uniqueString(deployment().name, location)}-AutoAccount-LinkedService'
  params: {
    name: 'automation'
    logAnalyticsWorkspaceName: last(split(linkedWorkspaceResourceId, '/'))!
    resourceId: automationAccount.id
    tags: tags
  }
  // This is to support linked services to law in different subscription and resource group than the automation account.
  // The current scope is used by default if no linked service is intended to be created.
  scope: resourceGroup(
    (!empty(linkedWorkspaceResourceId)
      ? (split((!empty(linkedWorkspaceResourceId) ? linkedWorkspaceResourceId : '//'), '/')[2])
      : subscription().subscriptionId),
    !empty(linkedWorkspaceResourceId)
      ? (split((!empty(linkedWorkspaceResourceId) ? linkedWorkspaceResourceId : '////'), '/')[4])
      : resourceGroup().name
  )
}

module automationAccount_solutions 'br/public:avm/res/operations-management/solution:0.3.0' = [
  for (gallerySolution, index) in gallerySolutions ?? []: if (!empty(linkedWorkspaceResourceId)) {
    name: '${uniqueString(deployment().name, location)}-AutoAccount-Solution-${index}'
    params: {
      name: gallerySolution.name
      location: location
      logAnalyticsWorkspaceName: last(split(linkedWorkspaceResourceId, '/'))!
      plan: gallerySolution.plan
      enableTelemetry: enableTelemetry
    }
    // This is to support solution to law in different subscription and resource group than the automation account.
    // The current scope is used by default if no linked service is intended to be created.
    scope: resourceGroup(
      (!empty(linkedWorkspaceResourceId)
        ? (split((!empty(linkedWorkspaceResourceId) ? linkedWorkspaceResourceId : '//'), '/')[2])
        : subscription().subscriptionId),
      !empty(linkedWorkspaceResourceId)
        ? (split((!empty(linkedWorkspaceResourceId) ? linkedWorkspaceResourceId : '////'), '/')[4])
        : resourceGroup().name
    )
    dependsOn: [
      automationAccount_linkedService
    ]
  }
]

module automationAccount_softwareUpdateConfigurations 'software-update-configuration/main.bicep' = [
  for (softwareUpdateConfiguration, index) in softwareUpdateConfigurations: {
    name: '${uniqueString(deployment().name, location)}-AutoAccount-SwUpdateConfig-${index}'
    params: {
      name: softwareUpdateConfiguration.name
      automationAccountName: automationAccount.name
      frequency: softwareUpdateConfiguration.frequency
      operatingSystem: softwareUpdateConfiguration.operatingSystem
      rebootSetting: softwareUpdateConfiguration.rebootSetting
      azureVirtualMachines: softwareUpdateConfiguration.?azureVirtualMachines
      excludeUpdates: softwareUpdateConfiguration.?excludeUpdates
      expiryTime: softwareUpdateConfiguration.?expiryTime
      expiryTimeOffsetMinutes: softwareUpdateConfiguration.?expiryTimeOffsetMinute
      includeUpdates: softwareUpdateConfiguration.?includeUpdates
      interval: softwareUpdateConfiguration.?interval
      isEnabled: softwareUpdateConfiguration.?isEnabled
      maintenanceWindow: softwareUpdateConfiguration.?maintenanceWindow
      monthDays: softwareUpdateConfiguration.?monthDays
      monthlyOccurrences: softwareUpdateConfiguration.?monthlyOccurrences
      nextRun: softwareUpdateConfiguration.?nextRun
      nextRunOffsetMinutes: softwareUpdateConfiguration.?nextRunOffsetMinutes
      nonAzureComputerNames: softwareUpdateConfiguration.?nonAzureComputerNames
      nonAzureQueries: softwareUpdateConfiguration.?nonAzureQueries
      postTaskParameters: softwareUpdateConfiguration.?postTaskParameters
      postTaskSource: softwareUpdateConfiguration.?postTaskSource
      preTaskParameters: softwareUpdateConfiguration.?preTaskParameters
      preTaskSource: softwareUpdateConfiguration.?preTaskSource
      scheduleDescription: softwareUpdateConfiguration.?scheduleDescription
      scopeByLocations: softwareUpdateConfiguration.?scopeByLocations
      scopeByResources: softwareUpdateConfiguration.?scopeByResources
      scopeByTags: softwareUpdateConfiguration.?scopeByTags
      scopeByTagsOperation: softwareUpdateConfiguration.?scopeByTagsOperation
      startTime: softwareUpdateConfiguration.?startTime
      timeZone: softwareUpdateConfiguration.?timeZone
      updateClassifications: softwareUpdateConfiguration.?updateClassifications
      weekDays: softwareUpdateConfiguration.?weekDays
    }
    dependsOn: [
      automationAccount_solutions
    ]
  }
]

resource automationAccount_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: automationAccount
}

resource automationAccount_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
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
    scope: automationAccount
  }
]

module automationAccount_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.7.1' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-automationAccount-PrivateEndpoint-${index}'
    scope: resourceGroup(privateEndpoint.?resourceGroupName ?? '')
    params: {
      name: privateEndpoint.?name ?? 'pep-${last(split(automationAccount.id, '/'))}-${privateEndpoint.service}-${index}'
      privateLinkServiceConnections: privateEndpoint.?isManualConnection != true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(automationAccount.id, '/'))}-${privateEndpoint.service}-${index}'
              properties: {
                privateLinkServiceId: automationAccount.id
                groupIds: [
                  privateEndpoint.service
                ]
              }
            }
          ]
        : null
      manualPrivateLinkServiceConnections: privateEndpoint.?isManualConnection == true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(automationAccount.id, '/'))}-${privateEndpoint.service}-${index}'
              properties: {
                privateLinkServiceId: automationAccount.id
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

resource automationAccount_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(
      automationAccount.id,
      roleAssignment.principalId,
      roleAssignment.roleDefinitionId
    )
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: automationAccount
  }
]

@description('The name of the deployed automation account.')
output name string = automationAccount.name

@description('The resource ID of the deployed automation account.')
output resourceId string = automationAccount.id

@description('The resource group of the deployed automation account.')
output resourceGroupName string = resourceGroup().name

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string? = automationAccount.?identity.?principalId

@description('The location the resource was deployed into.')
output location string = automationAccount.location

@description('The private endpoints of the automation account.')
output privateEndpoints array = [
  for (pe, i) in (!empty(privateEndpoints) ? array(privateEndpoints) : []): {
    name: automationAccount_privateEndpoints[i].outputs.name
    resourceId: automationAccount_privateEndpoints[i].outputs.resourceId
    groupId: automationAccount_privateEndpoints[i].outputs.groupId
    customDnsConfig: automationAccount_privateEndpoints[i].outputs.customDnsConfig
    networkInterfaceIds: automationAccount_privateEndpoints[i].outputs.networkInterfaceIds
  }
]

// =============== //
//   Definitions   //
// =============== //

@export()
type credentialType = {
  @sys.description('Required. Name of the Automation Account credential.')
  name: string

  @sys.description('Required. The user name associated to the credential.')
  userName: string

  @sys.description('Required. Password of the credential.')
  @secure()
  password: string

  @sys.description('Optional. Description of the credential.')
  description: string?
}

import { solutionPlanType } from 'br/public:avm/res/operations-management/solution:0.3.0'

@export()
type gallerySolutionType = {
  @description('''Required. Name of the solution.
  For solutions authored by Microsoft, the name must be in the pattern: `SolutionType(WorkspaceName)`, for example: `AntiMalware(contoso-Logs)`.
  For solutions authored by third parties, the name should be in the pattern: `SolutionType[WorkspaceName]`, for example `MySolution[contoso-Logs]`.
  The solution type is case-sensitive.''')
  name: string

  @description('Required. Plan for solution object supported by the OperationsManagement resource provider.')
  plan: solutionPlanType
}
