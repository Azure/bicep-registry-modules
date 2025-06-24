metadata name = 'Azure SQL Servers'
metadata description = 'This module deploys an Azure SQL Server.'

@description('Conditional. The administrator username for the server. Required if no `administrators` object for AAD authentication is provided.')
param administratorLogin string?

@description('Conditional. The administrator login password. Required if no `administrators` object for AAD authentication is provided.')
@secure()
param administratorLoginPassword string?

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Required. The name of the server.')
param name string

import { managedIdentityAllType, managedIdentityOnlyUserAssignedType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

@description('Conditional. The resource ID of a user assigned identity to be used by default. Required if "userAssignedIdentities" is not empty.')
param primaryUserAssignedIdentityResourceId string?

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

@description('Optional. The databases to create in the server.')
param databases databaseType[]?

@description('Optional. The Elastic Pools to create in the server.')
param elasticPools elasticPoolType[]?

@description('Optional. The firewall rules to create in the server.')
param firewallRules firewallRuleType[]?

@description('Optional. The virtual network rules to create in the server.')
param virtualNetworkRules virtualNetworkRuleType[]?

@description('Optional. The security alert policies to create in the server.')
param securityAlertPolicies securityAlerPolicyType[]?

@description('Optional. The keys to configure.')
param keys keyType[]?

import { customerManagedKeyWithAutoRotateType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The customer managed key definition for server TDE.')
param customerManagedKey customerManagedKeyWithAutoRotateType?

@description('Conditional. The Azure Active Directory (AAD) administrator authentication. Required if no `administratorLogin` & `administratorLoginPassword` is provided.')
param administrators serverExternalAdministratorType?

@description('Optional. The Client id used for cross tenant CMK scenario.')
@minLength(36)
@maxLength(36)
param federatedClientId string?

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

import { privateEndpointSingleServiceType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
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
  'Enabled'
  'Disabled'
])
param restrictOutboundNetworkAccess string?

@description('Optional. SQL logical server connection policy.')
@allowed([
  'Default'
  'Redirect'
  'Proxy'
])
param connectionPolicy string = 'Default'

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

@description('Optional. The vulnerability assessment configuration.')
param vulnerabilityAssessmentsObj vulnerabilityAssessmentType?

@description('Optional. The audit settings configuration. If you want to disable auditing, set the parmaeter to an empty object.')
param auditSettings auditSettingsType = {
  state: 'Enabled'
}

@description('Optional. Key vault reference and secret settings for the module\'s secrets export.')
param secretsExportConfiguration secretsExportConfigurationType?

@description('Optional. The failover groups configuration.')
param failoverGroups failoverGroupType[]?

var enableReferencedModulesTelemetry = false

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Log Analytics Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '92aaf0da-9dab-42b6-94a3-d43ce8d16293'
  )
  'Log Analytics Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '73c42c96-874c-492b-b04d-ab87d138a893'
  )
  'Monitoring Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '749f88d5-cbae-40b8-bcfc-e573ddc772fa'
  )
  'Monitoring Metrics Publisher': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '3913510d-42f4-4e42-8a64-420c390055eb'
  )
  'Monitoring Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '43d0d8ad-25c7-4714-9337-8ba259a9fe05'
  )
  'Reservation Purchaser': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f7b75c60-3036-4b75-91c3-6b41c27c1689'
  )
  'Resource Policy Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '36243c78-bf99-498c-9df9-86d9f8d28608'
  )
  'SQL DB Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '9b7fa17d-e63e-47b0-bb0a-15c516ac86ec'
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

resource cMKKeyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId)) {
  name: last(split(customerManagedKey.?keyVaultResourceId!, '/'))
  scope: resourceGroup(
    split(customerManagedKey.?keyVaultResourceId!, '/')[2],
    split(customerManagedKey.?keyVaultResourceId!, '/')[4]
  )

  resource cMKKey 'keys@2023-07-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId) && !empty(customerManagedKey.?keyName)) {
    name: customerManagedKey.?keyName!
  }
}

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

resource server 'Microsoft.Sql/servers@2023-08-01' = {
  location: location
  name: name
  tags: tags
  identity: identity
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    administrators: union({ administratorType: 'ActiveDirectory' }, administrators ?? {})
    federatedClientId: federatedClientId
    isIPv6Enabled: isIPv6Enabled
    keyId: customerManagedKey != null
      ? !empty(customerManagedKey.?keyVersion)
          ? '${cMKKeyVault::cMKKey.properties.keyUri}/${customerManagedKey!.?keyVersion}'
          : cMKKeyVault::cMKKey.properties.keyUriWithVersion
      : null
    version: '12.0'
    minimalTlsVersion: minimalTlsVersion
    primaryUserAssignedIdentityId: primaryUserAssignedIdentityResourceId
    publicNetworkAccess: !empty(publicNetworkAccess)
      ? publicNetworkAccess
      : (!empty(privateEndpoints) && empty(firewallRules) && empty(virtualNetworkRules) ? 'Disabled' : null)
    restrictOutboundNetworkAccess: restrictOutboundNetworkAccess
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
  for (database, index) in (databases ?? []): {
    name: '${uniqueString(deployment().name, location)}-Sql-DB-${index}'
    params: {
      // properties derived from parent server resource, no override allowed
      serverName: server.name
      location: location

      // properties from the database object. If not provided, parent server resource properties will be used
      tags: database.?tags ?? tags

      // properties from the databse object. If not provided, defaults specified in the child resource will be used
      name: database.name
      managedIdentities: database.?managedIdentities
      sku: database.?sku
      autoPauseDelay: database.?autoPauseDelay
      availabilityZone: database.?availabilityZone
      catalogCollation: database.?catalogCollation
      collation: database.?collation
      createMode: database.?createMode
      elasticPoolResourceId: database.?elasticPoolResourceId
      customerManagedKey: database.?customerManagedKey
      federatedClientId: database.?federatedClientId
      freeLimitExhaustionBehavior: database.?freeLimitExhaustionBehavior
      highAvailabilityReplicaCount: database.?highAvailabilityReplicaCount
      isLedgerOn: database.?isLedgerOn
      licenseType: database.?licenseType
      lock: database.?lock
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
  for (elasticPool, index) in (elasticPools ?? []): {
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
      lock: elasticPool.?lock
      maintenanceConfigurationId: elasticPool.?maintenanceConfigurationId
      maxSizeBytes: elasticPool.?maxSizeBytes
      minCapacity: elasticPool.?minCapacity
      perDatabaseSettings: elasticPool.?perDatabaseSettings
      preferredEnclaveType: elasticPool.?preferredEnclaveType
      zoneRedundant: elasticPool.?zoneRedundant
    }
  }
]

module server_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.11.0' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-server-PrivateEndpoint-${index}'
    scope: resourceGroup(
      split(privateEndpoint.?resourceGroupResourceId ?? resourceGroup().id, '/')[2],
      split(privateEndpoint.?resourceGroupResourceId ?? resourceGroup().id, '/')[4]
    )
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
      enableTelemetry: enableReferencedModulesTelemetry
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
  for (firewallRule, index) in (firewallRules ?? []): {
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
  for (virtualNetworkRule, index) in (virtualNetworkRules ?? []): {
    name: '${uniqueString(deployment().name, location)}-Sql-VirtualNetworkRules-${index}'
    params: {
      serverName: server.name
      name: virtualNetworkRule.name
      ignoreMissingVnetServiceEndpoint: virtualNetworkRule.?ignoreMissingVnetServiceEndpoint
      virtualNetworkSubnetResourceId: virtualNetworkRule.virtualNetworkSubnetResourceId
    }
  }
]

module server_securityAlertPolicies 'security-alert-policy/main.bicep' = [
  for (securityAlertPolicy, index) in (securityAlertPolicies ?? []): {
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
  for (key, index) in (keys ?? []): {
    name: '${uniqueString(deployment().name, location)}-Sql-Key-${index}'
    params: {
      serverName: server.name
      name: key.?name
      serverKeyType: key.?serverKeyType
      uri: key.?uri
    }
  }
]

module cmk_key 'key/main.bicep' = if (customerManagedKey != null) {
  name: '${uniqueString(deployment().name, location)}-Sql-Key'
  params: {
    serverName: server.name
    name: '${cMKKeyVault.name}_${customerManagedKey.?keyName}_${!empty(customerManagedKey.?keyVersion) ? customerManagedKey.?keyVersion : last(split(cMKKeyVault::cMKKey.properties.keyUriWithVersion, '/'))}'
    serverKeyType: 'AzureKeyVault'
    uri: !empty(customerManagedKey.?keyVersion)
      ? '${cMKKeyVault::cMKKey.properties.keyUri}/${customerManagedKey!.?keyVersion}'
      : cMKKeyVault::cMKKey.properties.keyUriWithVersion
  }
}

module server_encryptionProtector 'encryption-protector/main.bicep' = if (customerManagedKey != null) {
  name: '${uniqueString(deployment().name, location)}-Sql-EncryProtector'
  params: {
    sqlServerName: server.name
    serverKeyName: cmk_key.outputs.name
    serverKeyType: 'AzureKeyVault'
    autoRotationEnabled: customerManagedKey.?autoRotationEnabled
  }
}

module server_audit_settings 'audit-setting/main.bicep' = if (!empty(auditSettings)) {
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
    split(secretsExportConfiguration.?keyVaultResourceId!, '/')[2],
    split(secretsExportConfiguration.?keyVaultResourceId!, '/')[4]
  )
  params: {
    keyVaultName: last(split(secretsExportConfiguration.?keyVaultResourceId!, '/'))
    secretsToSet: union(
      [],
      contains(secretsExportConfiguration!, 'sqlAdminPasswordSecretName')
        ? [
            {
              name: secretsExportConfiguration!.?sqlAdminPasswordSecretName
              value: administratorLoginPassword
            }
          ]
        : [],
      contains(secretsExportConfiguration!, 'sqlAzureConnectionStringSecretName')
        ? [
            {
              name: secretsExportConfiguration!.?sqlAzureConnectionStringSecretName
              value: 'Server=${server.properties.fullyQualifiedDomainName}; Database=${!empty(databases) ? databases[?0].name : ''}; User=${administratorLogin}; Password=${administratorLoginPassword}'
            }
          ]
        : []
    )
  }
}

module failover_groups 'failover-group/main.bicep' = [
  for (failoverGroup, index) in (failoverGroups ?? []): {
    name: '${uniqueString(deployment().name, location)}-Sql-FailoverGroup-${index}'
    params: {
      name: failoverGroup.name
      tags: failoverGroup.?tags ?? tags
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

resource server_connection_policy 'Microsoft.Sql/servers/connectionPolicies@2023-08-01' = {
  name: 'default'
  parent: server
  properties: {
    connectionType: connectionPolicy
  }
}

@description('The name of the deployed SQL server.')
output name string = server.name

@description('The resource ID of the deployed SQL server.')
output resourceId string = server.id

@description('The fully qualified domain name of the deployed SQL server.')
output fullyQualifiedDomainName string = server.properties.fullyQualifiedDomainName

@description('The resource group of the deployed SQL server.')
output resourceGroupName string = resourceGroup().name

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string? = server.?identity.?principalId

@description('The location the resource was deployed into.')
output location string = server.location

import { secretsOutputType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('A hashtable of references to the secrets exported to the provided Key Vault. The key of each reference is each secret\'s name.')
output exportedSecrets secretsOutputType = (secretsExportConfiguration != null)
  ? toObject(secretsExport.outputs.secretsSet, secret => last(split(secret.secretResourceId, '/')), secret => secret)
  : {}

@description('The private endpoints of the SQL server.')
output privateEndpoints privateEndpointOutputType[] = [
  for (pe, index) in (privateEndpoints ?? []): {
    name: server_privateEndpoints[index].outputs.name
    resourceId: server_privateEndpoints[index].outputs.resourceId
    groupId: server_privateEndpoints[index].outputs.?groupId!
    customDnsConfigs: server_privateEndpoints[index].outputs.customDnsConfigs
    networkInterfaceResourceIds: server_privateEndpoints[index].outputs.networkInterfaceResourceIds
  }
]

// =============== //
//   Definitions   //
// =============== //

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
import { perDatabaseSettingsType, skuType } from 'elastic-pool/main.bicep'
import { databaseSkuType, shortTermBackupRetentionPolicyType, longTermBackupRetentionPolicyType } from 'database/main.bicep'
import { recurringScansType } from 'vulnerability-assessment/main.bicep'
import { readOnlyEndpointType, readWriteEndpointType } from 'failover-group/main.bicep'

@export()
@description('The type for a private endpoint output.')
type privateEndpointOutputType = {
  @description('The name of the private endpoint.')
  name: string

  @description('The resource ID of the private endpoint.')
  resourceId: string

  @description('The group Id for the private endpoint Group.')
  groupId: string?

  @description('The custom DNS configurations of the private endpoint.')
  customDnsConfigs: {
    @description('FQDN that resolves to private endpoint IP address.')
    fqdn: string?

    @description('A list of private IP addresses of the private endpoint.')
    ipAddresses: string[]
  }[]

  @description('The IDs of the network interfaces associated with the private endpoint.')
  networkInterfaceResourceIds: string[]
}

@export()
@description('The type for audit settings.')
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
@description('The type for a secrets export configuration.')
type secretsExportConfigurationType = {
  @description('Required. The resource ID of the key vault where to store the secrets of this module.')
  keyVaultResourceId: string

  @description('Optional. The sqlAdminPassword secret name to create.')
  sqlAdminPasswordSecretName: string?

  @description('Optional. The sqlAzureConnectionString secret name to create.')
  sqlAzureConnectionStringSecretName: string?
}

@export()
@description('The type for a sever-external administrator.')
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
@description('The type for a database.')
type databaseType = {
  @description('Required. The name of the Elastic Pool.')
  name: string

  @description('Optional. Tags of the resource.')
  tags: object?

  @description('Optional. The lock settings of the database.')
  lock: lockType?

  @description('Optional. The managed identities for the database.')
  managedIdentities: managedIdentityOnlyUserAssignedType?

  @description('Optional. The database SKU.')
  sku: databaseSkuType?

  @description('Optional. Time in minutes after which database is automatically paused. A value of -1 means that automatic pause is disabled.')
  autoPauseDelay: int?

  @description('Required. If set to 1, 2 or 3, the availability zone is hardcoded to that value. If set to -1, no zone is defined. Note that the availability zone numbers here are the logical availability zone in your Azure subscription. Different subscriptions might have a different mapping of the physical zone and logical zone. To understand more, please refer to [Physical and logical availability zones](https://learn.microsoft.com/en-us/azure/reliability/availability-zones-overview?tabs=azure-cli#physical-and-logical-availability-zones).')
  availabilityZone: (-1 | 1 | 2 | 3)

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

  @description('Optional. The customer managed key definition for database TDE.')
  customerManagedKey: customerManagedKeyWithAutoRotateType?

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
@description('The type for an elastic pool property.')
type elasticPoolType = {
  @description('Required. The name of the Elastic Pool.')
  name: string

  @description('Optional. Tags of the resource.')
  tags: object?

  @description('Optional. The lock settings of the elastic pool.')
  lock: lockType?

  @description('Optional. The elastic pool SKU.')
  sku: skuType?

  @description('Optional. Time in minutes after which elastic pool is automatically paused. A value of -1 means that automatic pause is disabled.')
  autoPauseDelay: int?

  @description('Required. If set to 1, 2 or 3, the availability zone is hardcoded to that value. If set to -1, no zone is defined. Note that the availability zone numbers here are the logical availability zone in your Azure subscription. Different subscriptions might have a different mapping of the physical zone and logical zone. To understand more, please refer to [Physical and logical availability zones](https://learn.microsoft.com/en-us/azure/reliability/availability-zones-overview?tabs=azure-cli#physical-and-logical-availability-zones).')
  availabilityZone: (-1 | 1 | 2 | 3)

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
  perDatabaseSettings: perDatabaseSettingsType?

  @description('Optional. Type of enclave requested on the elastic pool.')
  preferredEnclaveType: 'Default' | 'VBS'?

  @description('Optional. Array of role assignments to create.')
  roleAssignments: roleAssignmentType[]?

  @description('Optional. Whether or not this elastic pool is zone redundant, which means the replicas of this elastic pool will be spread across multiple availability zones.')
  zoneRedundant: bool?
}

@export()
@description('The type for a vulnerability assessment.')
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
@description('The type for a firewall rule.')
type firewallRuleType = {
  @description('Required. The name of the firewall rule.')
  name: string

  @description('Optional. The start IP address of the firewall rule. Must be IPv4 format. Use value \'0.0.0.0\' for all Azure-internal IP addresses.')
  startIpAddress: string?

  @description('Optional. The end IP address of the firewall rule. Must be IPv4 format. Must be greater than or equal to startIpAddress. Use value \'0.0.0.0\' for all Azure-internal IP addresses.')
  endIpAddress: string?
}

@export()
@description('The type for a key.')
type keyType = {
  @description('Optional. The name of the key. Must follow the [<keyVaultName>_<keyName>_<keyVersion>] pattern.')
  name: string?

  @description('Optional. The server key type.')
  serverKeyType: 'ServiceManaged' | 'AzureKeyVault'?

  @description('Optional. The URI of the server key. If the ServerKeyType is AzureKeyVault, then the URI is required. The AKV URI is required to be in this format: \'https://YourVaultName.azure.net/keys/YourKeyName/YourKeyVersion\'.')
  uri: string?
}

@export()
@description('The type for a virtual network rule.')
type virtualNetworkRuleType = {
  @description('Required. The name of the Server Virtual Network Rule.')
  name: string

  @description('Required. The resource ID of the virtual network subnet.')
  virtualNetworkSubnetResourceId: string

  @description('Optional. Allow creating a firewall rule before the virtual network has vnet service endpoint enabled.')
  ignoreMissingVnetServiceEndpoint: bool?
}

@export()
@description('The type for a security alert policy.')
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
@description('The type for a failover group.')
type failoverGroupType = {
  @description('Required. The name of the failover group.')
  name: string

  @description('Optional. Tags of the resource.')
  tags: object?

  @description('Required. List of databases in the failover group.')
  databases: string[]

  @description('Required. List of the partner servers for the failover group.')
  partnerServers: string[]

  @description('Optional. Read-only endpoint of the failover group instance.')
  readOnlyEndpoint: readOnlyEndpointType?

  @description('Required. Read-write endpoint of the failover group instance.')
  readWriteEndpoint: readWriteEndpointType

  @description('Required. Databases secondary type on partner server.')
  secondaryType: 'Geo' | 'Standby'
}
