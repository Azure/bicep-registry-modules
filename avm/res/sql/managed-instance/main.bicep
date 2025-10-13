metadata name = 'SQL Managed Instances'
metadata description = 'This module deploys a SQL Managed Instance.'

@description('Required. The name of the SQL managed instance.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Conditional. The administrator username for the server. Required if no `administrators` object for AAD authentication is provided.')
param administratorLogin string?

@description('Conditional. The administrator login password. Required if no `administrators` object for AAD authentication is provided.')
@secure()
param administratorLoginPassword string?

@description('Conditional. The Azure Active Directory (AAD) administrator authentication. Required if no `administratorLogin` & `administratorLoginPassword` is provided.')
param administrators serverExternalAdministratorType?

@description('Required. The fully qualified resource ID of the subnet on which the SQL managed instance will be placed.')
param subnetResourceId string

@description('Optional. The name of the SKU, typically, a letter + Number code, e.g. P3.')
param skuName string = 'GP_Gen5'

@description('Optional. The tier or edition of the particular SKU, e.g. Basic, Premium.')
param skuTier string = 'GeneralPurpose'

@description('Optional. Storage size in GB. Increments of 32 GB allowed only.')
@minValue(32)
@maxValue(8192)
param storageSizeInGB int = 32

@description('Optional. The number of vCores.')
param vCores resourceInput<'Microsoft.Sql/managedInstances@2023-08-01'>.properties.vCores = 4

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

@description('Optional. Specifies the mode of database creation. Default: Regular instance creation. Restore: Creates an instance by restoring a set of backups to specific point in time. RestorePointInTime and sourceManagedInstanceResourceId must be specified.')
@allowed([
  'Default'
  'PointInTimeRestore'
])
param managedInstanceCreateMode string = 'Default'

@description('Optional. The resource ID of another managed instance whose DNS zone this managed instance will share after creation.')
param dnsZonePartnerResourceId string?

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
param instancePoolResourceId string?

@description('Optional. Specifies the point in time (ISO8601 format) of the source database that will be restored to create the new database.')
param restorePointInTime string?

@description('Optional. The resource identifier of the source managed instance associated with create operation of this instance.')
param sourceManagedInstanceResourceId string?

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Tags of the resource.')
param tags resourceInput<'Microsoft.Sql/managedInstances@2023-08-01'>.tags?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

@description('Conditional. The resource ID of a user assigned identity to be used by default. Required if `userAssignedIdentities` is not empty.')
param primaryUserAssignedIdentityResourceId string?

@description('Optional. Databases to create in this server.')
param databases databaseType[]?

@description('Optional. The vulnerability assessment configuration.')
param vulnerabilityAssessment vulnerabilityAssessmentType?

@description('Optional. The security alert policy configuration.')
param securityAlertPolicy securityAlertPolicyType?

@description('Optional. The keys to configure.')
param keys keysType[]?

@description('Optional. The encryption protection configuration.')
param encryptionProtector encryptionProtectorType?

@allowed([
  'SystemManaged'
  'Custom1'
  'Custom2'
])
@description('''Optional. The maintenance window for the SQL Managed Instance.

SystemManaged: The system automatically selects a 9-hour maintenance window between 8:00 AM to 5:00 PM local time, Monday - Sunday.
Custom1: Weekday window: 10:00 PM to 6:00 AM local time, Monday - Thursday.
Custom2: Weekend window: 10:00 PM to 6:00 AM local time, Friday - Sunday.
''')
param maintenanceWindow string?

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

var maintenanceConfigurationId = maintenanceWindow == 'Custom1' || maintenanceWindow == 'Custom2'
  ? subscriptionResourceId(
      'Microsoft.Maintenance/publicMaintenanceConfigurations',
      'SQL_${location}_MI_${last(maintenanceWindow!)}'
    )
  : null

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

resource managedInstance 'Microsoft.Sql/managedInstances@2024-05-01-preview' = {
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
    administrators: union({ administratorType: 'ActiveDirectory' }, administrators ?? {})
    subnetId: subnetResourceId
    licenseType: licenseType
    vCores: vCores
    storageSizeInGB: storageSizeInGB
    collation: collation
    dnsZonePartner: dnsZonePartnerResourceId
    publicDataEndpointEnabled: publicDataEndpointEnabled
    sourceManagedInstanceId: sourceManagedInstanceResourceId
    restorePointInTime: restorePointInTime
    proxyOverride: proxyOverride
    timezoneId: timezoneId
    instancePoolId: instancePoolResourceId
    primaryUserAssignedIdentityId: primaryUserAssignedIdentityResourceId
    requestedBackupStorageRedundancy: requestedBackupStorageRedundancy
    zoneRedundant: zoneRedundant
    servicePrincipal: {
      type: servicePrincipal
    }
    minimalTlsVersion: minimalTlsVersion
    maintenanceConfigurationId: maintenanceConfigurationId
  }
}

resource managedInstance_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?notes ?? (lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.')
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
  for (database, index) in (databases ?? []): {
    name: '${uniqueString(deployment().name, location)}-SqlMi-DB-${index}'
    params: {
      name: database.name
      managedInstanceName: managedInstance.name
      catalogCollation: database.?catalogCollation
      collation: database.?collation
      createMode: database.?createMode
      diagnosticSettings: database.?diagnosticSettings
      location: database.?location ?? managedInstance.location
      lock: database.?lock ?? lock
      longTermRetentionBackupResourceId: database.?longTermRetentionBackupResourceId
      recoverableDatabaseId: database.?recoverableDatabaseId
      restorableDroppedDatabaseId: database.?restorableDroppedDatabaseId
      restorePointInTime: database.?restorePointInTime
      sourceDatabaseId: database.?sourceDatabaseId
      storageContainerSasToken: database.?storageContainerSasToken
      storageContainerUri: database.?storageContainerUri
      tags: database.?tags ?? tags
      backupShortTermRetentionPolicy: database.?backupShortTermRetentionPolicy
      backupLongTermRetentionPolicy: database.?backupLongTermRetentionPolicy
    }
  }
]

module managedInstance_securityAlertPolicy 'security-alert-policy/main.bicep' = if (!empty(securityAlertPolicy)) {
  name: '${uniqueString(deployment().name, location)}-SqlMi-SecAlertPol'
  params: {
    managedInstanceName: managedInstance.name
    name: securityAlertPolicy!.name
    emailAccountAdmins: securityAlertPolicy.?emailAccountAdmins
    state: securityAlertPolicy.?state
    disabledAlerts: securityAlertPolicy!.?disabledAlerts
    emailAddresses: securityAlertPolicy!.?emailAddresses
    retentionDays: securityAlertPolicy!.?retentionDays
    storageAccountResourceId: securityAlertPolicy!.?storageAccountResourceId
  }
}

module managedInstance_vulnerabilityAssessment 'vulnerability-assessment/main.bicep' = if (!empty(vulnerabilityAssessment) && (managedIdentities.?systemAssigned ?? false)) {
  name: '${uniqueString(deployment().name, location)}-SqlMi-VulnAssessm'
  params: {
    managedInstanceName: managedInstance.name
    name: vulnerabilityAssessment!.name
    recurringScans: vulnerabilityAssessment.?recurringScans
    storageAccountResourceId: vulnerabilityAssessment!.storageAccountResourceId
    useStorageAccountAccessKey: vulnerabilityAssessment!.?useStorageAccountAccessKey
    createStorageRoleAssignment: vulnerabilityAssessment!.?createStorageRoleAssignment
  }
  dependsOn: [
    managedInstance_securityAlertPolicy
  ]
}

module managedInstance_keys 'key/main.bicep' = [
  for (key, index) in (keys ?? []): {
    name: '${uniqueString(deployment().name, location)}-SqlMi-Key-${index}'
    params: {
      name: key.name
      managedInstanceName: managedInstance.name
      serverKeyType: key.?serverKeyType
      uri: key.?uri
    }
  }
]

module managedInstance_encryptionProtector 'encryption-protector/main.bicep' = if (!empty(encryptionProtector)) {
  name: '${uniqueString(deployment().name, location)}-SqlMi-EncryProtector'
  params: {
    managedInstanceName: managedInstance.name
    serverKeyName: encryptionProtector!.serverKeyName
    serverKeyType: encryptionProtector.?serverKeyType
    autoRotationEnabled: encryptionProtector.?autoRotationEnabled ?? true
  }
  dependsOn: [
    managedInstance_keys
  ]
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

// =============== //
//   Definitions   //
// =============== //

import { diagnosticSettingLogsOnlyType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
import { managedInstanceShortTermRetentionPolicyType, managedInstanceLongTermRetentionPolicyType } from 'database/main.bicep'

@export()
@description('The type for a sever-external administrator.')
type serverExternalAdministratorType = {
  @description('Required. Azure Active Directory only Authentication enabled.')
  azureADOnlyAuthentication: bool

  @description('Required. Login name of the server administrator.')
  login: string

  @description('Required. Principal Type of the sever administrator.')
  principalType: 'Application' | 'Group' | 'User'

  @description('Required. SID (object ID) of the server administrator.')
  sid: string

  @description('Optional. Tenant ID of the administrator.')
  tenantId: string?
}

@export()
@description('The type for the vulnerability assessment configuration.')
type vulnerabilityAssessmentType = {
  @description('Required. The name of the vulnerability assessment.')
  name: string

  @description('Optional. The recurring scans configuration.')
  recurringScans: resourceInput<'Microsoft.Sql/managedInstances/vulnerabilityAssessments@2023-08-01'>.properties.recurringScans?

  @description('Required. A blob storage to hold the scan results.')
  storageAccountResourceId: string

  @description('Optional. Use Access Key to access the storage account. The storage account cannot be behind a firewall or virtual network. If an access key is not used, the SQL MI system assigned managed identity must be assigned the Storage Blob Data Contributor role on the storage account.')
  useStorageAccountAccessKey: bool?

  @description('Optional. Create the Storage Blob Data Contributor role assignment on the storage account. Note, the role assignment must not already exist on the storage account.')
  createStorageRoleAssignment: bool?
}

@export()
@description('The type for the security alert policy configuration.')
type securityAlertPolicyType = {
  @description('Required. The name of the security alert policy.')
  name: string

  @description('Optional. Enables advanced data security features, like recuring vulnerability assesment scans and ATP. If enabled, storage account must be provided.')
  state: ('Enabled' | 'Disabled')?

  @description('Optional. Specifies that the schedule scan notification will be is sent to the subscription administrators.')
  emailAccountAdmins: bool?

  @description('Optional. Specifies an array of e-mail addresses to which the alert is sent.')
  emailAddresses: string[]?

  @description('Optional. Specifies the number of days to keep in the Threat Detection audit logs.')
  retentionDays: int?

  @description('Optional. Specifies an array of alerts that are disabled.')
  disabledAlerts: (
    | 'Sql_Injection'
    | 'Sql_Injection_Vulnerability'
    | 'Access_Anomaly'
    | 'Data_Exfiltration'
    | 'Unsafe_Action'
    | 'Brute_Force')[]?

  @description('Conditional. A blob storage to  hold all Threat Detection audit logs. Required if state is \'Enabled\'.')
  storageAccountResourceId: string?
}

@export()
@description('The type for the keys configuration.')
type keysType = {
  @description('Required. The name of the key. Must follow the [<keyVaultName>_<keyName>_<keyVersion>] pattern.')
  name: string

  @description('Optional. The encryption protector type like "ServiceManaged", "AzureKeyVault".')
  serverKeyType: ('AzureKeyVault' | 'ServiceManaged')?

  @description('Optional. The URI of the key. If the ServerKeyType is AzureKeyVault, then either the URI or the keyVaultName/keyName combination is required.')
  uri: string?
}

@export()
@description('The type for the encryption protector configuration.')
type encryptionProtectorType = {
  @description('Required. The name of the SQL managed instance key.')
  serverKeyName: string

  @description('Optional. The encryption protector type like "ServiceManaged", "AzureKeyVault".')
  serverKeyType: ('AzureKeyVault' | 'ServiceManaged')?

  @description('Optional. Key auto rotation opt-in flag.')
  autoRotationEnabled: bool?
}

@export()
@description('The type for a database.')
type databaseType = {
  @description('Required. The name of the SQL managed instance database.')
  name: string

  @description('Optional. Location for all resources.')
  location: string?

  @description('Optional. Collation of the managed instance database.')
  collation: string?

  @description('Optional. Collation of the managed instance.')
  catalogCollation: string?

  @description('Optional. Managed database create mode. PointInTimeRestore: Create a database by restoring a point in time backup of an existing database. SourceDatabaseName, SourceManagedInstanceName and PointInTime must be specified. RestoreExternalBackup: Create a database by restoring from external backup files. Collation, StorageContainerUri and StorageContainerSasToken must be specified. Recovery: Creates a database by restoring a geo-replicated backup. RecoverableDatabaseId must be specified as the recoverable database resource ID to restore. RestoreLongTermRetentionBackup: Create a database by restoring from a long term retention backup (longTermRetentionBackupResourceId required).')
  createMode: (
    | 'Default'
    | 'RestoreExternalBackup'
    | 'PointInTimeRestore'
    | 'Recovery'
    | 'RestoreLongTermRetentionBackup')?

  @description('Conditional. The resource identifier of the source database associated with create operation of this database. Required if createMode is PointInTimeRestore.')
  sourceDatabaseId: string?

  @description('Conditional. Specifies the point in time (ISO8601 format) of the source database that will be restored to create the new database. Required if createMode is PointInTimeRestore.')
  restorePointInTime: string?

  @description('Optional. The restorable dropped database resource ID to restore when creating this database.')
  restorableDroppedDatabaseId: string?

  @description('Conditional. Specifies the uri of the storage container where backups for this restore are stored. Required if createMode is RestoreExternalBackup.')
  storageContainerUri: string?

  @description('Conditional. Specifies the storage container sas token. Required if createMode is RestoreExternalBackup.')
  @secure()
  storageContainerSasToken: string?

  @description('Conditional. The resource identifier of the recoverable database associated with create operation of this database. Required if createMode is Recovery.')
  recoverableDatabaseId: string?

  @description('Conditional. The resource ID of the Long Term Retention backup to be used for restore of this managed database. Required if createMode is RestoreLongTermRetentionBackup.')
  longTermRetentionBackupResourceId: string?

  @description('Optional. The database-level diagnostic settings of the service.')
  diagnosticSettings: diagnosticSettingLogsOnlyType[]?

  @description('Optional. The lock settings of the service.')
  lock: lockType?

  @description('Optional. The configuration for the backup short term retention policy definition.')
  backupShortTermRetentionPolicy: managedInstanceShortTermRetentionPolicyType?

  @description('Optional. The configuration for the backup long term retention policy definition.')
  backupLongTermRetentionPolicy: managedInstanceLongTermRetentionPolicyType?

  @description('Optional. Tags of the resource.')
  tags: resourceInput<'Microsoft.Sql/managedInstances/databases@2023-08-01'>.tags?
}
