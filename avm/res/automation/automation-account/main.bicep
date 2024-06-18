metadata name = 'Automation Accounts'
metadata description = 'This module deploys an Azure Automation Account.'
metadata owner = 'Azure/module-maintainers'

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

@description('Optional. The customer managed key definition.')
param customerManagedKey customerManagedKeyType

import { credentialType } from 'credential/main.bicep'
@description('Optional. List of credentials to be created in the automation account.')
param credentials credentialType = []

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
param gallerySolutions array = []

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

@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointType

@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingType

@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentitiesType

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

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
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
  'User Access Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  )
}

resource avmTelemetry 'Microsoft.Resources/deployments@2023-07-01' = if (enableTelemetry) {
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

module automationAccount_credentials 'credential/main.bicep' = if (!empty(credentials)) {
  name: '${uniqueString(deployment().name, location)}-AutomationAccount-Credentials'
  params: {
    automationAccountName: automationAccount.name
    credentials: credentials
  }
}

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
      advancedSchedule: contains(schedule, 'advancedSchedule') ? schedule.advancedSchedule : null
      description: contains(schedule, 'description') ? schedule.description : ''
      expiryTime: contains(schedule, 'expiryTime') ? schedule.expiryTime : ''
      frequency: contains(schedule, 'frequency') ? schedule.frequency : 'OneTime'
      interval: contains(schedule, 'interval') ? schedule.interval : 0
      startTime: contains(schedule, 'startTime') ? schedule.startTime : ''
      timeZone: contains(schedule, 'timeZone') ? schedule.timeZone : ''
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
      description: contains(runbook, 'description') ? runbook.description : ''
      uri: contains(runbook, 'uri') ? runbook.uri : ''
      version: contains(runbook, 'version') ? runbook.version : ''
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
      parameters: contains(jobSchedule, 'parameters') ? jobSchedule.parameters : {}
      runOn: contains(jobSchedule, 'runOn') ? jobSchedule.runOn : ''
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
      description: contains(variable, 'description') ? variable.description : ''
      value: variable.value
      isEncrypted: contains(variable, 'isEncrypted') ? variable.isEncrypted : true
    }
  }
]

module automationAccount_linkedService '../../operational-insights/workspace/linked-service/main.bicep' = if (!empty(linkedWorkspaceResourceId)) {
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

module automationAccount_solutions 'br/public:avm/res/operations-management/solution:0.1.0' = [
  for (gallerySolution, index) in gallerySolutions: if (!empty(linkedWorkspaceResourceId)) {
    name: '${uniqueString(deployment().name, location)}-AutoAccount-Solution-${index}'
    params: {
      name: gallerySolution.name
      location: location
      logAnalyticsWorkspaceName: last(split(linkedWorkspaceResourceId, '/'))!
      product: contains(gallerySolution, 'product') ? gallerySolution.product : 'OMSGallery'
      publisher: contains(gallerySolution, 'publisher') ? gallerySolution.publisher : 'Microsoft'
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
      azureVirtualMachines: contains(softwareUpdateConfiguration, 'azureVirtualMachines')
        ? softwareUpdateConfiguration.azureVirtualMachines
        : []
      excludeUpdates: contains(softwareUpdateConfiguration, 'excludeUpdates')
        ? softwareUpdateConfiguration.excludeUpdates
        : []
      expiryTime: contains(softwareUpdateConfiguration, 'expiryTime') ? softwareUpdateConfiguration.expiryTime : ''
      expiryTimeOffsetMinutes: contains(softwareUpdateConfiguration, 'expiryTimeOffsetMinutes')
        ? softwareUpdateConfiguration.expiryTimeOffsetMinute
        : 0
      includeUpdates: contains(softwareUpdateConfiguration, 'includeUpdates')
        ? softwareUpdateConfiguration.includeUpdates
        : []
      interval: contains(softwareUpdateConfiguration, 'interval') ? softwareUpdateConfiguration.interval : 1
      isEnabled: contains(softwareUpdateConfiguration, 'isEnabled') ? softwareUpdateConfiguration.isEnabled : true
      maintenanceWindow: contains(softwareUpdateConfiguration, 'maintenanceWindow')
        ? softwareUpdateConfiguration.maintenanceWindow
        : 'PT2H'
      monthDays: contains(softwareUpdateConfiguration, 'monthDays') ? softwareUpdateConfiguration.monthDays : []
      monthlyOccurrences: contains(softwareUpdateConfiguration, 'monthlyOccurrences')
        ? softwareUpdateConfiguration.monthlyOccurrences
        : []
      nextRun: contains(softwareUpdateConfiguration, 'nextRun') ? softwareUpdateConfiguration.nextRun : ''
      nextRunOffsetMinutes: contains(softwareUpdateConfiguration, 'nextRunOffsetMinutes')
        ? softwareUpdateConfiguration.nextRunOffsetMinutes
        : 0
      nonAzureComputerNames: contains(softwareUpdateConfiguration, 'nonAzureComputerNames')
        ? softwareUpdateConfiguration.nonAzureComputerNames
        : []
      nonAzureQueries: contains(softwareUpdateConfiguration, 'nonAzureQueries')
        ? softwareUpdateConfiguration.nonAzureQueries
        : []
      postTaskParameters: contains(softwareUpdateConfiguration, 'postTaskParameters')
        ? softwareUpdateConfiguration.postTaskParameters
        : {}
      postTaskSource: contains(softwareUpdateConfiguration, 'postTaskSource')
        ? softwareUpdateConfiguration.postTaskSource
        : ''
      preTaskParameters: contains(softwareUpdateConfiguration, 'preTaskParameters')
        ? softwareUpdateConfiguration.preTaskParameters
        : {}
      preTaskSource: contains(softwareUpdateConfiguration, 'preTaskSource')
        ? softwareUpdateConfiguration.preTaskSource
        : ''
      scheduleDescription: contains(softwareUpdateConfiguration, 'scheduleDescription')
        ? softwareUpdateConfiguration.scheduleDescription
        : ''
      scopeByLocations: contains(softwareUpdateConfiguration, 'scopeByLocations')
        ? softwareUpdateConfiguration.scopeByLocations
        : []
      scopeByResources: contains(softwareUpdateConfiguration, 'scopeByResources')
        ? softwareUpdateConfiguration.scopeByResources
        : [
            subscription().id
          ]
      scopeByTags: contains(softwareUpdateConfiguration, 'scopeByTags') ? softwareUpdateConfiguration.scopeByTags : {}
      scopeByTagsOperation: contains(softwareUpdateConfiguration, 'scopeByTagsOperation')
        ? softwareUpdateConfiguration.scopeByTagsOperation
        : 'All'
      startTime: contains(softwareUpdateConfiguration, 'startTime') ? softwareUpdateConfiguration.startTime : ''
      timeZone: contains(softwareUpdateConfiguration, 'timeZone') ? softwareUpdateConfiguration.timeZone : 'UTC'
      updateClassifications: contains(softwareUpdateConfiguration, 'updateClassifications')
        ? softwareUpdateConfiguration.updateClassifications
        : [
            'Critical'
            'Security'
          ]
      weekDays: contains(softwareUpdateConfiguration, 'weekDays') ? softwareUpdateConfiguration.weekDays : []
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

module automationAccount_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.4.1' = [
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
      privateDnsZoneGroupName: privateEndpoint.?privateDnsZoneGroupName
      privateDnsZoneResourceIds: privateEndpoint.?privateDnsZoneResourceIds
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
  for (roleAssignment, index) in (roleAssignments ?? []): {
    name: guid(automationAccount.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
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
output systemAssignedMIPrincipalId string = automationAccount.?identity.?principalId ?? ''

@description('The location the resource was deployed into.')
output location string = automationAccount.location

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

type privateEndpointType = {
  @description('Optional. The name of the private endpoint.')
  name: string?

  @description('Optional. The location to deploy the private endpoint to.')
  location: string?

  @description('Optional. The name of the private link connection to create.')
  privateLinkServiceConnectionName: string?

  @description('Required. The subresource to deploy the private endpoint for. For example "blob", "table", "queue" or "file".')
  service: string

  @description('Required. Resource ID of the subnet where the endpoint needs to be created.')
  subnetResourceId: string

  @description('Optional. The name of the private DNS zone group to create if privateDnsZoneResourceIds were provided.')
  privateDnsZoneGroupName: string?

  @description('Optional. The private DNS zone groups to associate the private endpoint with. A DNS zone group can support up to 5 DNS zones.')
  privateDnsZoneResourceIds: string[]?

  @description('Optional. If Manual Private Link Connection is required.')
  isManualConnection: bool?

  @description('Optional. A message passed to the owner of the remote resource with the manual connection request.')
  @maxLength(140)
  manualConnectionRequestMessage: string?

  @description('Optional. Custom DNS configurations.')
  customDnsConfigs: {
    @description('Required. Fqdn that resolves to private endpoint ip address.')
    fqdn: string?

    @description('Required. A list of private ip addresses of the private endpoint.')
    ipAddresses: string[]
  }[]?

  @description('Optional. A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints.')
  ipConfigurations: {
    @description('Required. The name of the resource that is unique within a resource group.')
    name: string

    @description('Required. Properties of private endpoint IP configurations.')
    properties: {
      @description('Required. The ID of a group obtained from the remote resource that this private endpoint should connect to.')
      groupId: string

      @description('Required. The member name of a group obtained from the remote resource that this private endpoint should connect to.')
      memberName: string

      @description('Required. A private ip address obtained from the private endpoint\'s subnet.')
      privateIPAddress: string
    }
  }[]?

  @description('Optional. Application security groups in which the private endpoint IP configuration is included.')
  applicationSecurityGroupResourceIds: string[]?

  @description('Optional. The custom name of the network interface attached to the private endpoint.')
  customNetworkInterfaceName: string?

  @description('Optional. Specify the type of lock.')
  lock: lockType

  @description('Optional. Array of role assignments to create.')
  roleAssignments: roleAssignmentType

  @description('Optional. Tags to be applied on all resources/resource groups in this deployment.')
  tags: object?

  @description('Optional. Enable/Disable usage telemetry for module.')
  enableTelemetry: bool?

  @description('Optional. Specify if you want to deploy the Private Endpoint into a different resource group than the main resource.')
  resourceGroupName: string?
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

type customerManagedKeyType = {
  @description('Required. The resource ID of a key vault to reference a customer managed key for encryption from.')
  keyVaultResourceId: string

  @description('Required. The name of the customer managed key to use for encryption.')
  keyName: string

  @description('Optional. The version of the customer managed key to reference for encryption. If not provided, using \'latest\'.')
  keyVersion: string?

  @description('Optional. User assigned identity to use when fetching the customer managed key. Required if no system assigned identity is available for use.')
  userAssignedIdentityResourceId: string?
}?
