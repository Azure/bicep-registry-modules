metadata name = 'Azure SQL Servers'
metadata description = 'This module deploys an Azure SQL Server.'

@description('Conditional. The administrator username for the server. Required if no `administrators` object for AAD authentication is provided.')
param administratorLogin string = ''

@description('Conditional. The administrator login password. Required if no `administrators` object for AAD authentication is provided.')
@secure()
param administratorLoginPassword string = ''

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Required. The name of the server.')
param name string

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

@description('Conditional. The resource ID of a user assigned identity to be used by default. Required if "userAssignedIdentities" is not empty.')
param primaryUserAssignedIdentityId string = ''

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. The databases to create in the server.')
param databases databasePropertyType[] = []

@description('Optional. The Elastic Pools to create in the server.')
param elasticPools elasticPoolPropertyType[] = []

@description('Optional. The firewall rules to create in the server.')
param firewallRules firewallRuleType[] = []

@description('Optional. The virtual network rules to create in the server.')
param virtualNetworkRules virtualNetworkRuleType[] = []

@description('Optional. The security alert policies to create in the server.')
param securityAlertPolicies securityAlerPolicyType[] = []

@description('Optional. The keys to configure.')
param keys keyType[] = []

@description('Conditional. The Azure Active Directory (AAD) administrator authentication. Required if no `administratorLogin` & `administratorLoginPassword` is provided.')
param administrators serverExternalAdministratorType?

@description('Optional. The Client id used for cross tenant CMK scenario.')
@minLength(36)
@maxLength(36)
param federatedClientId string?

@description('Optional. A CMK URI of the key to use for encryption.')
param keyId string?

@allowed([
  '1.0'
  '1.1'
  '1.2'
  '1.3'
])
@description('Optional. Minimal TLS version allowed.')
param minimalTlsVersion string = '1.2'

@allowed([
  'Disabled'
  'Enabled'
])
@description('Optional. Whether or not to enable IPv6 support for this server.')
param isIPv6Enabled string = 'Disabled'

import { privateEndpointSingleServiceType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointSingleServiceType[]?

@description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and neither firewall rules nor virtual network rules are set.')
@allowed([
  ''
  'Enabled'
  'Disabled'
  'SecuredByPerimeter'
])
param publicNetworkAccess string = ''

@description('Optional. Whether or not to restrict outbound network access for this server.')
@allowed([
  ''
  'Enabled'
  'Disabled'
])
param restrictOutboundNetworkAccess string = ''

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

@description('Optional. The encryption protection configuration.')
param encryptionProtectorObj encryptionProtectorType?

@description('Optional. The vulnerability assessment configuration.')
param vulnerabilityAssessmentsObj vulnerabilityAssessmentType?

@description('Optional. The audit settings configuration. If you want to disable auditing, set the parmaeter to an empty object.')
param auditSettings auditSettingsType = {
  state: 'Enabled'
}

@description('Optional. Key vault reference and secret settings for the module\'s secrets export.')
param secretsExportConfiguration secretsExportConfigurationType?

@description('Optional. The failover groups configuration.')
param failoverGroups failoverGroupType[] = []

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
  name: '46d3xbcp.res.sql-server.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource server 'Microsoft.Sql/servers@2023-08-01-preview' = {
  location: location
  name: name
  tags: tags
  identity: identity
  properties: {
    administratorLogin: !empty(administratorLogin) ? administratorLogin : null
    administratorLoginPassword: !empty(administratorLoginPassword) ? administratorLoginPassword : null
    administrators: union({ administratorType: 'ActiveDirectory' }, administrators ?? {})
    federatedClientId: federatedClientId
    isIPv6Enabled: isIPv6Enabled
    keyId: keyId
    version: '12.0'
    minimalTlsVersion: minimalTlsVersion
    primaryUserAssignedIdentityId: !empty(primaryUserAssignedIdentityId) ? primaryUserAssignedIdentityId : null
    publicNetworkAccess: !empty(publicNetworkAccess)
      ? publicNetworkAccess
      : (!empty(privateEndpoints) && empty(firewallRules) && empty(virtualNetworkRules) ? 'Disabled' : null)
    restrictOutboundNetworkAccess: !empty(restrictOutboundNetworkAccess) ? restrictOutboundNetworkAccess : null
  }
}

resource server_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: server
}

resource server_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(server.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: server
  }
]

module server_databases 'database/main.bicep' = [
  for (database, index) in databases: {
    name: '${uniqueString(deployment().name, location)}-Sql-DB-${index}'
    params: {
      // properties derived from parent server resource, no override allowed
      serverName: server.name
      location: location

      // properties from the database object. If not provided, parent server resource properties will be used
      tags: database.?tags ?? tags

      // properties from the databse object. If not provided, defaults specified in the child resource will be used
      name: database.name
      sku: database.?sku
      autoPauseDelay: database.?autoPauseDelay
      availabilityZone: database.?availabilityZone
      catalogCollation: database.?catalogCollation
      collation: database.?collation
      createMode: database.?createMode
      elasticPoolResourceId: database.?elasticPoolResourceId
      encryptionProtector: database.?encryptionProtector
      encryptionProtectorAutoRotation: database.?encryptionProtectorAutoRotation
      federatedClientId: database.?federatedClientId
      freeLimitExhaustionBehavior: database.?freeLimitExhaustionBehavior
      highAvailabilityReplicaCount: database.?highAvailabilityReplicaCount
      isLedgerOn: database.?isLedgerOn
      licenseType: database.?licenseType
      longTermRetentionBackupResourceId: database.?longTermRetentionBackupResourceId
      maintenanceConfigurationId: database.?maintenanceConfigurationId
      manualCutover: database.?manualCutover
      maxSizeBytes: database.?maxSizeBytes
      minCapacity: database.?minCapacity
      performCutover: database.?performCutover
      preferredEnclaveType: database.?preferredEnclaveType
      readScale: database.?readScale
      recoverableDatabaseResourceId: database.?recoverableDatabaseResourceId
      recoveryServicesRecoveryPointResourceId: database.?recoveryServicesRecoveryPointResourceId
      requestedBackupStorageRedundancy: database.?requestedBackupStorageRedundancy
      restorableDroppedDatabaseResourceId: database.?restorableDroppedDatabaseResourceId
      restorePointInTime: database.?restorePointInTime
      sampleName: database.?sampleName
      secondaryType: database.?secondaryType
      sourceDatabaseDeletionDate: database.?sourceDatabaseDeletionDate
      sourceDatabaseResourceId: database.?sourceDatabaseResourceId
      sourceResourceId: database.?sourceResourceId
      useFreeLimit: database.?useFreeLimit
      zoneRedundant: database.?zoneRedundant

      diagnosticSettings: database.?diagnosticSettings
      backupShortTermRetentionPolicy: database.?backupShortTermRetentionPolicy
      backupLongTermRetentionPolicy: database.?backupLongTermRetentionPolicy
    }
    dependsOn: [
      server_elasticPools // Enables us to add databases to existing elastic pools
    ]
  }
]

module server_elasticPools 'elastic-pool/main.bicep' = [
  for (elasticPool, index) in elasticPools: {
    name: '${uniqueString(deployment().name, location)}-SQLServer-ElasticPool-${index}'
    params: {
      // properties derived from parent server resource, no override allowed
      serverName: server.name
      location: location

      // properties from the elastic pool object. If not provided, parent server resource properties will be used
      tags: elasticPool.?tags ?? tags

      // properties from the elastic pool object. If not provided, defaults specified in the child resource will be used
      name: elasticPool.name
      sku: elasticPool.?sku
      autoPauseDelay: elasticPool.?autoPauseDelay
      availabilityZone: elasticPool.?availabilityZone
      highAvailabilityReplicaCount: elasticPool.?highAvailabilityReplicaCount
      licenseType: elasticPool.?licenseType
      maintenanceConfigurationId: elasticPool.?maintenanceConfigurationId
      maxSizeBytes: elasticPool.?maxSizeBytes
      minCapacity: elasticPool.?minCapacity
      perDatabaseSettings: elasticPool.?perDatabaseSettings
      preferredEnclaveType: elasticPool.?preferredEnclaveType
      zoneRedundant: elasticPool.?zoneRedundant
    }
  }
]

module server_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.7.1' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-server-PrivateEndpoint-${index}'
    scope: resourceGroup(privateEndpoint.?resourceGroupName ?? '')
    params: {
      name: privateEndpoint.?name ?? 'pep-${last(split(server.id, '/'))}-${privateEndpoint.?service ?? 'sqlServer'}-${index}'
      privateLinkServiceConnections: privateEndpoint.?isManualConnection != true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(server.id, '/'))}-${privateEndpoint.?service ?? 'sqlServer'}-${index}'
              properties: {
                privateLinkServiceId: server.id
                groupIds: [
                  privateEndpoint.?service ?? 'sqlServer'
                ]
              }
            }
          ]
        : null
      manualPrivateLinkServiceConnections: privateEndpoint.?isManualConnection == true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(server.id, '/'))}-${privateEndpoint.?service ?? 'sqlServer'}-${index}'
              properties: {
                privateLinkServiceId: server.id
                groupIds: [
                  privateEndpoint.?service ?? 'sqlServer'
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

module server_firewallRules 'firewall-rule/main.bicep' = [
  for (firewallRule, index) in firewallRules: {
    name: '${uniqueString(deployment().name, location)}-Sql-FirewallRules-${index}'
    params: {
      name: firewallRule.name
      serverName: server.name
      endIpAddress: firewallRule.?endIpAddress
      startIpAddress: firewallRule.?startIpAddress
    }
  }
]

module server_virtualNetworkRules 'virtual-network-rule/main.bicep' = [
  for (virtualNetworkRule, index) in virtualNetworkRules: {
    name: '${uniqueString(deployment().name, location)}-Sql-VirtualNetworkRules-${index}'
    params: {
      serverName: server.name
      name: virtualNetworkRule.name
      ignoreMissingVnetServiceEndpoint: virtualNetworkRule.?ignoreMissingVnetServiceEndpoint
      virtualNetworkSubnetId: virtualNetworkRule.virtualNetworkSubnetId
    }
  }
]

module server_securityAlertPolicies 'security-alert-policy/main.bicep' = [
  for (securityAlertPolicy, index) in securityAlertPolicies: {
    name: '${uniqueString(deployment().name, location)}-Sql-SecAlertPolicy-${index}'
    params: {
      name: securityAlertPolicy.name
      serverName: server.name
      disabledAlerts: securityAlertPolicy.?disabledAlerts
      emailAccountAdmins: securityAlertPolicy.?emailAccountAdmins
      emailAddresses: securityAlertPolicy.?emailAddresses
      retentionDays: securityAlertPolicy.?retentionDays
      state: securityAlertPolicy.?state
      storageAccountAccessKey: securityAlertPolicy.?storageAccountAccessKey
      storageEndpoint: securityAlertPolicy.?storageEndpoint
    }
  }
]

module server_vulnerabilityAssessment 'vulnerability-assessment/main.bicep' = if (vulnerabilityAssessmentsObj != null) {
  name: '${uniqueString(deployment().name, location)}-Sql-VulnAssessm'
  params: {
    serverName: server.name
    name: vulnerabilityAssessmentsObj!.name
    recurringScans: vulnerabilityAssessmentsObj.?recurringScans
    storageAccountResourceId: vulnerabilityAssessmentsObj!.storageAccountResourceId
    useStorageAccountAccessKey: vulnerabilityAssessmentsObj.?useStorageAccountAccessKey
    createStorageRoleAssignment: vulnerabilityAssessmentsObj.?createStorageRoleAssignment
  }
  dependsOn: [
    server_securityAlertPolicies
  ]
}

module server_keys 'key/main.bicep' = [
  for (key, index) in keys: {
    name: '${uniqueString(deployment().name, location)}-Sql-Key-${index}'
    params: {
      serverName: server.name
      name: key.?name
      serverKeyType: key.?serverKeyType
      uri: key.?uri
    }
  }
]

module server_encryptionProtector 'encryption-protector/main.bicep' = if (encryptionProtectorObj != null) {
  name: '${uniqueString(deployment().name, location)}-Sql-EncryProtector'
  params: {
    sqlServerName: server.name
    serverKeyName: encryptionProtectorObj!.serverKeyName
    serverKeyType: encryptionProtectorObj.?serverKeyType
    autoRotationEnabled: encryptionProtectorObj.?autoRotationEnabled
  }
  dependsOn: [
    server_keys
  ]
}

module server_audit_settings 'audit-settings/main.bicep' = if (!empty(auditSettings)) {
  name: '${uniqueString(deployment().name, location)}-Sql-AuditSettings'
  params: {
    serverName: server.name
    name: auditSettings.?name ?? 'default'
    state: auditSettings.?state
    auditActionsAndGroups: auditSettings.?auditActionsAndGroups
    isAzureMonitorTargetEnabled: auditSettings.?isAzureMonitorTargetEnabled
    isDevopsAuditEnabled: auditSettings.?isDevopsAuditEnabled
    isManagedIdentityInUse: auditSettings.?isManagedIdentityInUse
    isStorageSecondaryKeyInUse: auditSettings.?isStorageSecondaryKeyInUse
    queueDelayMs: auditSettings.?queueDelayMs
    retentionDays: auditSettings.?retentionDays
    storageAccountResourceId: auditSettings.?storageAccountResourceId
  }
}

module secretsExport 'modules/keyVaultExport.bicep' = if (secretsExportConfiguration != null) {
  name: '${uniqueString(deployment().name, location)}-secrets-kv'
  scope: resourceGroup(
    split((secretsExportConfiguration.?keyVaultResourceId ?? '//'), '/')[2],
    split((secretsExportConfiguration.?keyVaultResourceId ?? '////'), '/')[4]
  )
  params: {
    keyVaultName: last(split(secretsExportConfiguration.?keyVaultResourceId ?? '//', '/'))
    secretsToSet: union(
      [],
      contains(secretsExportConfiguration!, 'sqlAdminPasswordSecretName')
        ? [
            {
              name: secretsExportConfiguration!.sqlAdminPasswordSecretName
              value: administratorLoginPassword
            }
          ]
        : [],
      contains(secretsExportConfiguration!, 'sqlAzureConnectionStringSercretName')
        ? [
            {
              name: secretsExportConfiguration!.sqlAzureConnectionStringSercretName
              value: 'Server=${server.properties.fullyQualifiedDomainName}; Database=${!empty(databases) ? databases[0].name : ''}; User=${administratorLogin}; Password=${administratorLoginPassword}'
            }
          ]
        : []
    )
  }
}

module failover_groups 'failover-group/main.bicep' = [
  for (failoverGroup, index) in failoverGroups: {
    name: '${uniqueString(deployment().name, location)}-Sql-FailoverGroup-${index}'
    params: {
      name: failoverGroup.name
      serverName: server.name
      databases: failoverGroup.databases
      partnerServers: failoverGroup.partnerServers
      readOnlyEndpoint: failoverGroup.?readOnlyEndpoint
      readWriteEndpoint: failoverGroup.readWriteEndpoint
      secondaryType: failoverGroup.secondaryType
    }
    dependsOn: [
      server_databases
    ]
  }
]

@description('The name of the deployed SQL server.')
output name string = server.name

@description('The resource ID of the deployed SQL server.')
output resourceId string = server.id

@description('The fully qualified domain name of the deployed SQL server.')
output fullyQualifiedDomainName string = server.properties.fullyQualifiedDomainName

@description('The resource group of the deployed SQL server.')
output resourceGroupName string = resourceGroup().name

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string = server.?identity.?principalId ?? ''

@description('The location the resource was deployed into.')
output location string = server.location

import { secretsOutputType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@description('A hashtable of references to the secrets exported to the provided Key Vault. The key of each reference is each secret\'s name.')
output exportedSecrets secretsOutputType = (secretsExportConfiguration != null)
  ? toObject(secretsExport.outputs.secretsSet, secret => last(split(secret.secretResourceId, '/')), secret => secret)
  : {}

@description('The private endpoints of the SQL server.')
output privateEndpoints array = [
  for (pe, i) in (!empty(privateEndpoints) ? array(privateEndpoints) : []): {
    name: server_privateEndpoints[i].outputs.name
    resourceId: server_privateEndpoints[i].outputs.resourceId
    groupId: server_privateEndpoints[i].outputs.groupId
    customDnsConfig: server_privateEndpoints[i].outputs.customDnsConfig
    networkInterfaceIds: server_privateEndpoints[i].outputs.networkInterfaceIds
  }
]

// =============== //
//   Definitions   //
// =============== //

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
import { elasticPoolPerDatabaseSettingsType, elasticPoolSkuType } from 'elastic-pool/main.bicep'
import { databaseSkuType, shortTermBackupRetentionPolicyType, longTermBackupRetentionPolicyType } from 'database/main.bicep'
import { recurringScansType } from 'vulnerability-assessment/main.bicep'
import { failoverGroupReadOnlyEndpointType, failoverGroupReadWriteEndpointType } from 'failover-group/main.bicep'

@export()
type auditSettingsType = {
  @description('Optional. Specifies the name of the audit settings.')
  name: string?

  @description('Optional. Specifies the Actions-Groups and Actions to audit.')
  auditActionsAndGroups: string[]?

  @description('Optional. Specifies whether audit events are sent to Azure Monitor.')
  isAzureMonitorTargetEnabled: bool?

  @description('Optional. Specifies the state of devops audit. If state is Enabled, devops logs will be sent to Azure Monitor.')
  isDevopsAuditEnabled: bool?

  @description('Optional. Specifies whether Managed Identity is used to access blob storage.')
  isManagedIdentityInUse: bool?

  @description('Optional. Specifies whether storageAccountAccessKey value is the storage\'s secondary key.')
  isStorageSecondaryKeyInUse: bool?

  @description('Optional. Specifies the amount of time in milliseconds that can elapse before audit actions are forced to be processed.')
  queueDelayMs: int?

  @description('Optional. Specifies the number of days to keep in the audit logs in the storage account.')
  retentionDays: int?

  @description('Optional. Specifies the state of the audit. If state is Enabled, storageEndpoint or isAzureMonitorTargetEnabled are required.')
  state: 'Enabled' | 'Disabled'?

  @description('Optional. Specifies the identifier key of the auditing storage account.')
  storageAccountResourceId: string?
}

@export()
type secretsExportConfigurationType = {
  @description('Required. The resource ID of the key vault where to store the secrets of this module.')
  keyVaultResourceId: string

  @description('Optional. The sqlAdminPassword secret name to create.')
  sqlAdminPasswordSecretName: string?

  @description('Optional. The sqlAzureConnectionString secret name to create.')
  sqlAzureConnectionStringSercretName: string?
}

@export()
type serverExternalAdministratorType = {
  @description('Optional. Type of the sever administrator.')
  administratorType: 'ActiveDirectory'?

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
type databasePropertyType = {
  @description('Required. The name of the Elastic Pool.')
  name: string

  @description('Optional. Tags of the resource.')
  tags: object?

  @description('Optional. The database SKU.')
  sku: databaseSkuType?

  @description('Optional. Time in minutes after which database is automatically paused. A value of -1 means that automatic pause is disabled.')
  autoPauseDelay: int?

  @description('Optional. Specifies the availability zone the database is pinned to.')
  availabilityZone: '1' | '2' | '3' | 'NoPreference'?

  @description('Optional. Collation of the metadata catalog.')
  catalogCollation: string?

  @description('Optional. The collation of the database.')
  collation: string?

  @description('Optional. Specifies the mode of database creation.')
  createMode:
    | 'Copy'
    | 'Default'
    | 'OnlineSecondary'
    | 'PointInTimeRestore'
    | 'Recovery'
    | 'Restore'
    | 'RestoreExternalBackup'
    | 'RestoreExternalBackupSecondary'
    | 'RestoreLongTermRetentionBackup'
    | 'Secondary'?

  @description('Optional. The resource identifier of the elastic pool containing this database.')
  elasticPoolResourceId: string?

  @description('Optional. The azure key vault URI of the database if it\'s configured with per Database Customer Managed Keys.')
  encryptionProtector: string?

  @description('Optional. The flag to enable or disable auto rotation of database encryption protector AKV key.')
  encryptionProtectorAutoRotation: bool?

  @description('Optional. The Client id used for cross tenant per database CMK scenario.')
  @minLength(36)
  @maxLength(36)
  federatedClientId: string?

  @description('Optional. Specifies the behavior when monthly free limits are exhausted for the free database.')
  freeLimitExhaustionBehavior: 'AutoPause' | 'BillOverUsage'?

  @description('Optional. The number of secondary replicas associated with the database that are used to provide high availability. Not applicable to a Hyperscale database within an elastic pool.')
  highAvailabilityReplicaCount: int?

  @description('Optional. Whether or not this database is a ledger database, which means all tables in the database are ledger tables.')
  isLedgerOn: bool?

  // keys
  @description('Optional. The license type to apply for this database.')
  licenseType: 'BasePrice' | 'LicenseIncluded'?

  @description('Optional. The resource identifier of the long term retention backup associated with create operation of this database.')
  longTermRetentionBackupResourceId: string?

  @description('Optional. Maintenance configuration id assigned to the database. This configuration defines the period when the maintenance updates will occur.')
  maintenanceConfigurationId: string?

  @description('Optional. Whether or not customer controlled manual cutover needs to be done during Update Database operation to Hyperscale tier.')
  manualCutover: bool?

  @description('Optional. The max size of the database expressed in bytes.')
  maxSizeBytes: int?

  // string to enable fractional values
  @description('Optional. Minimal capacity that database will always have allocated, if not paused.')
  minCapacity: string?

  @description('Optional. To trigger customer controlled manual cutover during the wait state while Scaling operation is in progress.')
  performCutover: bool?

  @description('Optional. Type of enclave requested on the database.')
  preferredEnclaveType: 'Default' | 'VBS'?

  @description('Optional. The state of read-only routing. If enabled, connections that have application intent set to readonly in their connection string may be routed to a readonly secondary replica in the same region. Not applicable to a Hyperscale database within an elastic pool.')
  readScale: 'Disabled' | 'Enabled'?

  @description('Optional. The resource identifier of the recoverable database associated with create operation of this database.')
  recoverableDatabaseResourceId: string?

  @description('Optional. The resource identifier of the recovery point associated with create operation of this database.')
  recoveryServicesRecoveryPointResourceId: string?

  @description('Optional. The storage account type to be used to store backups for this database.')
  requestedBackupStorageRedundancy: 'Geo' | 'GeoZone' | 'Local' | 'Zone'?

  @description('Optional. The resource identifier of the restorable dropped database associated with create operation of this database.')
  restorableDroppedDatabaseResourceId: string?

  @description('Optional. Specifies the point in time (ISO8601 format) of the source database that will be restored to create the new database.')
  restorePointInTime: string?

  @description('Optional. The name of the sample schema to apply when creating this database.')
  sampleName: string?

  @description('Optional. The secondary type of the database if it is a secondary.')
  secondaryType: 'Geo' | 'Named' | 'Standby'?

  @description('Optional. Specifies the time that the database was deleted.')
  sourceDatabaseDeletionDate: string?

  @description('Optional. The resource identifier of the source database associated with create operation of this database.')
  sourceDatabaseResourceId: string?

  @description('Optional. The resource identifier of the source associated with the create operation of this database.')
  sourceResourceId: string?

  @description('Optional. Whether or not the database uses free monthly limits. Allowed on one database in a subscription.')
  useFreeLimit: bool?

  @description('Optional. Whether or not this database is zone redundant, which means the replicas of this database will be spread across multiple availability zones.')
  zoneRedundant: bool?

  @description('Optional. The diagnostic settings of the service.')
  diagnosticSettings: diagnosticSettingFullType[]?

  @description('Optional. The short term backup retention policy for the database.')
  backupShortTermRetentionPolicy: shortTermBackupRetentionPolicyType?

  @description('Optional. The long term backup retention policy for the database.')
  backupLongTermRetentionPolicy: longTermBackupRetentionPolicyType?
}

@export()
type elasticPoolPropertyType = {
  @description('Required. The name of the Elastic Pool.')
  name: string

  @description('Optional. Tags of the resource.')
  tags: object?

  @description('Optional. The elastic pool SKU.')
  sku: elasticPoolSkuType?

  @description('Optional. Time in minutes after which elastic pool is automatically paused. A value of -1 means that automatic pause is disabled.')
  autoPauseDelay: int?

  @description('Optional. Specifies the availability zone the pool\'s primary replica is pinned to.')
  availabilityZone: '1' | '2' | '3' | 'NoPreference'?

  @description('Optional. The number of secondary replicas associated with the elastic pool that are used to provide high availability. Applicable only to Hyperscale elastic pools.')
  highAvailabilityReplicaCount: int?

  @description('Optional. The license type to apply for this elastic pool.')
  licenseType: 'BasePrice' | 'LicenseIncluded'?

  @description('Optional. Maintenance configuration id assigned to the elastic pool. This configuration defines the period when the maintenance updates will will occur.')
  maintenanceConfigurationId: string?

  @description('Optional. The storage limit for the database elastic pool in bytes.')
  maxSizeBytes: int?

  @description('Optional. Minimal capacity that serverless pool will not shrink below, if not paused.')
  minCapacity: int?

  @description('Optional. The per database settings for the elastic pool.')
  perDatabaseSettings: elasticPoolPerDatabaseSettingsType?

  @description('Optional. Type of enclave requested on the elastic pool.')
  preferredEnclaveType: 'Default' | 'VBS'?

  @description('Optional. Whether or not this elastic pool is zone redundant, which means the replicas of this elastic pool will be spread across multiple availability zones.')
  zoneRedundant: bool?
}

@export()
type encryptionProtectorType = {
  @description('Required. The name of the server key.')
  serverKeyName: string

  @description('Optional. The encryption protector type.')
  serverKeyType: 'ServiceManaged' | 'AzureKeyVault'?

  @description('Optional. Key auto rotation opt-in flag.')
  autoRotationEnabled: bool?
}

@export()
type vulnerabilityAssessmentType = {
  @description('Required. The name of the vulnerability assessment.')
  name: string

  @description('Optional. The recurring scans settings.')
  recurringScans: recurringScansType?

  @description('Required. The resource ID of the storage account to store the scan reports.')
  storageAccountResourceId: string

  @description('Optional. Specifies whether to use the storage account access key to access the storage account.')
  useStorageAccountAccessKey: bool?

  @description('Optional. Specifies whether to create a role assignment for the storage account.')
  createStorageRoleAssignment: bool?
}

@export()
type firewallRuleType = {
  @description('Required. The name of the firewall rule.')
  name: string

  @description('Optional. The start IP address of the firewall rule. Must be IPv4 format. Use value \'0.0.0.0\' for all Azure-internal IP addresses.')
  startIpAddress: string?

  @description('Optional. The end IP address of the firewall rule. Must be IPv4 format. Must be greater than or equal to startIpAddress. Use value \'0.0.0.0\' for all Azure-internal IP addresses.')
  endIpAddress: string?
}

@export()
type keyType = {
  @description('Optional. The name of the key. Must follow the [<keyVaultName>_<keyName>_<keyVersion>] pattern.')
  name: string?

  @description('Optional. The server key type.')
  serverKeyType: 'ServiceManaged' | 'AzureKeyVault'?

  @description('Optional. The URI of the server key. If the ServerKeyType is AzureKeyVault, then the URI is required. The AKV URI is required to be in this format: \'https://YourVaultName.azure.net/keys/YourKeyName/YourKeyVersion\'.')
  uri: string?
}

@export()
type virtualNetworkRuleType = {
  @description('Required. The name of the Server Virtual Network Rule.')
  name: string

  @description('Required. The resource ID of the virtual network subnet.')
  virtualNetworkSubnetId: string

  @description('Optional. Allow creating a firewall rule before the virtual network has vnet service endpoint enabled.')
  ignoreMissingVnetServiceEndpoint: bool?
}

@export()
type securityAlerPolicyType = {
  @description('Required. The name of the Security Alert Policy.')
  name: string

  @description('Optional. Alerts to disable.')
  disabledAlerts: (
    | 'Sql_Injection'
    | 'Sql_Injection_Vulnerability'
    | 'Access_Anomaly'
    | 'Data_Exfiltration'
    | 'Unsafe_Action'
    | 'Brute_Force')[]?

  @description('Optional. Specifies that the alert is sent to the account administrators.')
  emailAccountAdmins: bool?

  @description('Optional. Specifies an array of email addresses to which the alert is sent.')
  emailAddresses: string[]?

  @description('Optional. Specifies the number of days to keep in the Threat Detection audit logs.')
  retentionDays: int?

  @description('Optional. Specifies the state of the policy, whether it is enabled or disabled or a policy has not been applied yet on the specific database.')
  state: 'Enabled' | 'Disabled'?

  @description('Optional. Specifies the identifier key of the Threat Detection audit storage account.')
  storageAccountAccessKey: string?

  @description('Optional. Specifies the blob storage endpoint. This blob storage will hold all Threat Detection audit logs.')
  storageEndpoint: string?
}

@export()
type failoverGroupType = {
  @description('Required. The name of the failover group.')
  name: string

  @description('Required. List of databases in the failover group.')
  databases: string[]

  @description('Required. List of the partner servers for the failover group.')
  partnerServers: string[]

  @description('Optional. Read-only endpoint of the failover group instance.')
  readOnlyEndpoint: failoverGroupReadOnlyEndpointType?

  @description('Required. Read-write endpoint of the failover group instance.')
  readWriteEndpoint: failoverGroupReadWriteEndpointType

  @description('Required. Databases secondary type on partner server.')
  secondaryType: 'Geo' | 'Standby'
}
