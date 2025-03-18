metadata name = 'SQL Managed Instances'
metadata description = 'This module deploys a SQL Managed Instance.'

@description('Required. The name of the SQL managed instance.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Required. The username used to establish jumpbox VMs.')
param administratorLogin string

@description('Required. The password given to the admin user.')
@secure()
param administratorLoginPassword string

@description('Required. The fully qualified resource ID of the subnet on which the SQL managed instance will be placed.')
param subnetResourceId string

@description('Optional. The name of the SKU, typically, a letter + Number code, e.g. P3.')
param skuName string = 'GP_Gen5'

@description('Optional. The tier or edition of the particular SKU, e.g. Basic, Premium.')
param skuTier string = 'GeneralPurpose'

@description('Optional. Storage size in GB. Minimum value: 32. Maximum value: 8192. Increments of 32 GB allowed only.')
param storageSizeInGB int = 32

@description('Optional. The number of vCores. Allowed values: 8, 16, 24, 32, 40, 64, 80.')
param vCores int = 4

@description('Optional. The license type. Possible values are \'LicenseIncluded\' (regular price inclusive of a new SQL license) and \'BasePrice\' (discounted AHB price for bringing your own SQL licenses).')
@allowed([
  'LicenseIncluded'
  'BasePrice'
])
param licenseType string = 'LicenseIncluded'

@description('Optional. If the service has different generations of hardware, for the same SKU, then that can be captured here.')
param hardwareFamily string = 'Gen5'

@description('Optional. Whether or not multi-az is enabled.')
param zoneRedundant bool = false

@description('Optional. Service principal type. If using AD Authentication and applying Admin, must be set to `SystemAssigned`. Then Global Admin must allow Reader access to Azure AD for the Service Principal.')
@allowed([
  'None'
  'SystemAssigned'
])
param servicePrincipal string = 'None'

@description('Optional. Specifies the mode of database creation. Default: Regular instance creation. Restore: Creates an instance by restoring a set of backups to specific point in time. RestorePointInTime and SourceManagedInstanceId must be specified.')
@allowed([
  'Default'
  'PointInTimeRestore'
])
param managedInstanceCreateMode string = 'Default'

@description('Optional. The resource ID of another managed instance whose DNS zone this managed instance will share after creation.')
param dnsZonePartner string = ''

@description('Optional. Collation of the managed instance.')
param collation string = 'SQL_Latin1_General_CP1_CI_AS'

@description('Optional. Connection type used for connecting to the instance.')
@allowed([
  'Proxy'
  'Redirect'
  'Default'
])
param proxyOverride string = 'Proxy'

@description('Optional. Whether or not the public data endpoint is enabled.')
param publicDataEndpointEnabled bool = false

@description('Optional. ID of the timezone. Allowed values are timezones supported by Windows.')
param timezoneId string = 'UTC'

@description('Optional. The resource ID of the instance pool this managed server belongs to.')
param instancePoolResourceId string = ''

@description('Optional. Specifies the point in time (ISO8601 format) of the source database that will be restored to create the new database.')
param restorePointInTime string = ''

@description('Optional. The resource identifier of the source managed instance associated with create operation of this instance.')
param sourceManagedInstanceId string = ''

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

@description('Conditional. The resource ID of a user assigned identity to be used by default. Required if "userAssignedIdentities" is not empty.')
param primaryUserAssignedIdentityId string = ''

@description('Optional. Databases to create in this server.')
param databases array = []

@description('Optional. The vulnerability assessment configuration.')
param vulnerabilityAssessmentsObj object = {}

@description('Optional. The security alert policy configuration.')
param securityAlertPoliciesObj object = {}

@description('Optional. The keys to configure.')
param keys array = []

@description('Optional. The encryption protection configuration.')
param encryptionProtectorObj object = {}

@description('Optional. The administrator configuration.')
param administratorsObj object = {}

@description('Optional. Minimal TLS version allowed.')
@allowed([
  'None'
  '1.0'
  '1.1'
  '1.2'
])
param minimalTlsVersion string = '1.2'

@description('Optional. The storage account type used to store backups for this database.')
@allowed([
  'Geo'
  'GeoZone'
  'Local'
  'Zone'
])
param requestedBackupStorageRedundancy string = 'Geo'

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned')
        : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : null)
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Reservation Purchaser': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f7b75c60-3036-4b75-91c3-6b41c27c1689'
  )
  'Role Based Access Control Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
  'SQL DB Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '9b7fa17d-e63e-47b0-bb0a-15c516ac86ec'
  )
  'SQL Managed Instance Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '4939a1f6-9ae0-4e48-a1e0-f2cbe897382d'
  )
  'SQL Security Manager': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '056cd41c-7e88-42e1-933e-88ba6a50c9c3'
  )
  'SQL Server Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '6d8ee4ec-f05a-4a1d-8b00-a9b17e38b437'
  )
  'SqlDb Migration Role': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '189207d4-bb67-4208-a635-b06afe8b2c57'
  )
  'SqlMI Migration Role': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '1d335eef-eee1-47fe-a9e0-53214eba8872'
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
  name: '46d3xbcp.res.sql-managedinstance.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource managedInstance 'Microsoft.Sql/managedInstances@2023-08-01-preview' = {
  name: name
  location: location
  tags: tags
  identity: identity
  sku: {
    name: skuName
    tier: skuTier
    family: hardwareFamily
  }

  properties: {
    managedInstanceCreateMode: managedInstanceCreateMode
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    subnetId: subnetResourceId
    licenseType: licenseType
    vCores: vCores
    storageSizeInGB: storageSizeInGB
    collation: collation
    dnsZonePartner: !empty(dnsZonePartner) ? dnsZonePartner : null
    publicDataEndpointEnabled: publicDataEndpointEnabled
    sourceManagedInstanceId: !empty(sourceManagedInstanceId) ? sourceManagedInstanceId : null
    restorePointInTime: !empty(restorePointInTime) ? restorePointInTime : null
    proxyOverride: proxyOverride
    timezoneId: timezoneId
    instancePoolId: !empty(instancePoolResourceId) ? instancePoolResourceId : null
    primaryUserAssignedIdentityId: !empty(primaryUserAssignedIdentityId) ? primaryUserAssignedIdentityId : null
    requestedBackupStorageRedundancy: requestedBackupStorageRedundancy
    zoneRedundant: zoneRedundant
    servicePrincipal: {
      type: servicePrincipal
    }
    minimalTlsVersion: minimalTlsVersion
  }
}

resource managedInstance_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: managedInstance
}

resource managedInstance_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for (diagnosticSetting, index) in (diagnosticSettings ?? []): {
    name: diagnosticSetting.?name ?? '${name}-diagnosticSettings'
    properties: {
      storageAccountId: diagnosticSetting.?storageAccountResourceId
      workspaceId: diagnosticSetting.?workspaceResourceId
      eventHubAuthorizationRuleId: diagnosticSetting.?eventHubAuthorizationRuleResourceId
      eventHubName: diagnosticSetting.?eventHubName
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
    scope: managedInstance
  }
]

resource managedInstance_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(managedInstance.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: managedInstance
  }
]

module managedInstance_databases 'database/main.bicep' = [
  for (database, index) in databases: {
    name: '${uniqueString(deployment().name, location)}-SqlMi-DB-${index}'
    params: {
      name: database.name
      managedInstanceName: managedInstance.name
      catalogCollation: database.?catalogCollation ?? 'SQL_Latin1_General_CP1_CI_AS'
      collation: database.?collation ?? 'SQL_Latin1_General_CP1_CI_AS'
      createMode: database.?createMode ?? 'Default'
      diagnosticSettings: database.?diagnosticSettings
      location: database.?location ?? managedInstance.location
      lock: database.?lock ?? lock
      longTermRetentionBackupResourceId: database.?longTermRetentionBackupResourceId ?? ''
      recoverableDatabaseId: database.?recoverableDatabaseId ?? ''
      restorableDroppedDatabaseId: database.?restorableDroppedDatabaseId ?? ''
      restorePointInTime: database.?restorePointInTime ?? ''
      sourceDatabaseId: database.?sourceDatabaseId ?? ''
      storageContainerSasToken: database.?storageContainerSasToken ?? ''
      storageContainerUri: database.?storageContainerUri ?? ''
      tags: database.?tags ?? tags
      backupShortTermRetentionPoliciesObj: database.?backupShortTermRetentionPolicies ?? {}
      backupLongTermRetentionPoliciesObj: database.?backupLongTermRetentionPolicies ?? {}
    }
  }
]

module managedInstance_securityAlertPolicy 'security-alert-policy/main.bicep' = if (!empty(securityAlertPoliciesObj)) {
  name: '${uniqueString(deployment().name, location)}-SqlMi-SecAlertPol'
  params: {
    managedInstanceName: managedInstance.name
    name: securityAlertPoliciesObj.name
    emailAccountAdmins: securityAlertPoliciesObj.?emailAccountAdmins ?? false
    state: securityAlertPoliciesObj.?state ?? 'Disabled'
  }
}

module managedInstance_vulnerabilityAssessment 'vulnerability-assessment/main.bicep' = if (!empty(vulnerabilityAssessmentsObj) && (managedIdentities.?systemAssigned ?? false)) {
  name: '${uniqueString(deployment().name, location)}-SqlMi-VulnAssessm'
  params: {
    managedInstanceName: managedInstance.name
    name: vulnerabilityAssessmentsObj.name
    recurringScansEmails: vulnerabilityAssessmentsObj.?recurringScansEmails ?? []
    recurringScansEmailSubscriptionAdmins: vulnerabilityAssessmentsObj.?recurringScansEmailSubscriptionAdmins ?? false
    recurringScansIsEnabled: vulnerabilityAssessmentsObj.?recurringScansIsEnabled ?? false
    storageAccountResourceId: vulnerabilityAssessmentsObj.storageAccountResourceId
    useStorageAccountAccessKey: vulnerabilityAssessmentsObj.?useStorageAccountAccessKey ?? false
    createStorageRoleAssignment: vulnerabilityAssessmentsObj.?createStorageRoleAssignment ?? true
  }
  dependsOn: [
    managedInstance_securityAlertPolicy
  ]
}

module managedInstance_keys 'key/main.bicep' = [
  for (key, index) in keys: {
    name: '${uniqueString(deployment().name, location)}-SqlMi-Key-${index}'
    params: {
      name: key.name
      managedInstanceName: managedInstance.name
      serverKeyType: key.?serverKeyType ?? 'ServiceManaged'
      uri: key.?uri ?? ''
    }
  }
]

module managedInstance_encryptionProtector 'encryption-protector/main.bicep' = if (!empty(encryptionProtectorObj)) {
  name: '${uniqueString(deployment().name, location)}-SqlMi-EncryProtector'
  params: {
    managedInstanceName: managedInstance.name
    serverKeyName: encryptionProtectorObj.serverKeyName
    serverKeyType: encryptionProtectorObj.?serverKeyType ?? 'ServiceManaged'
    autoRotationEnabled: encryptionProtectorObj.?autoRotationEnabled ?? true
  }
  dependsOn: [
    managedInstance_keys
  ]
}

module managedInstance_administrator 'administrator/main.bicep' = if (!empty(administratorsObj)) {
  name: '${uniqueString(deployment().name, location)}-SqlMi-Admin'
  params: {
    managedInstanceName: managedInstance.name
    login: administratorsObj.name
    sid: administratorsObj.sid
    tenantId: administratorsObj.?tenantId ?? ''
  }
}

@description('The name of the deployed managed instance.')
output name string = managedInstance.name

@description('The resource ID of the deployed managed instance.')
output resourceId string = managedInstance.id

@description('The resource group of the deployed managed instance.')
output resourceGroupName string = resourceGroup().name

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string? = managedInstance.?identity.?principalId

@description('The location the resource was deployed into.')
output location string = managedInstance.location
