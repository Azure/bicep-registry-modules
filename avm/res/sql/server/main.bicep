metadata name = 'Azure SQL Servers'
metadata description = 'This module deploys an Azure SQL Server.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The administrator username for the server. Required if no `administrators` object for AAD authentication is provided.')
param administratorLogin string = ''

@description('Conditional. The administrator login password. Required if no `administrators` object for AAD authentication is provided.')
@secure()
param administratorLoginPassword string = ''

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Required. The name of the server.')
param name string

@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentitiesType

@description('Conditional. The resource ID of a user assigned identity to be used by default. Required if "userAssignedIdentities" is not empty.')
param primaryUserAssignedIdentityId string = ''

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. The databases to create in the server.')
param databases databasePropertyType[] = []

@description('Optional. The Elastic Pools to create in the server.')
param elasticPools elasticPoolPropertyType[] = []

@description('Optional. The firewall rules to create in the server.')
param firewallRules array = []

@description('Optional. The virtual network rules to create in the server.')
param virtualNetworkRules array = []

@description('Optional. The security alert policies to create in the server.')
param securityAlertPolicies array = []

@description('Optional. The keys to configure.')
param keys array = []

@description('Conditional. The Azure Active Directory (AAD) administrator authentication. Required if no `administratorLogin` & `administratorLoginPassword` is provided.')
param administrators ServerExternalAdministratorType?

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

@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointType

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
param encryptionProtectorObj object = {}

@description('Optional. The vulnerability assessment configuration.')
param vulnerabilityAssessmentsObj object = {}

@description('Optional. The audit settings configuration.')
param auditSettings auditSettingsType = {} //Use the defaults from the child module

@description('Optional. Key vault reference and secret settings for the module\'s secrets export.')
param secretsExportConfiguration secretsExportConfigurationType?

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
      endIpAddress: firewallRule.?endIpAddress ?? '0.0.0.0'
      startIpAddress: firewallRule.?startIpAddress ?? '0.0.0.0'
    }
  }
]

module server_virtualNetworkRules 'virtual-network-rule/main.bicep' = [
  for (virtualNetworkRule, index) in virtualNetworkRules: {
    name: '${uniqueString(deployment().name, location)}-Sql-VirtualNetworkRules-${index}'
    params: {
      name: virtualNetworkRule.name
      serverName: server.name
      ignoreMissingVnetServiceEndpoint: virtualNetworkRule.?ignoreMissingVnetServiceEndpoint ?? false
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
      disabledAlerts: securityAlertPolicy.?disabledAlerts ?? []
      emailAccountAdmins: securityAlertPolicy.?emailAccountAdmins ?? false
      emailAddresses: securityAlertPolicy.?emailAddresses ?? []
      retentionDays: securityAlertPolicy.?retentionDays ?? 0
      state: securityAlertPolicy.?state ?? 'Disabled'
      storageAccountAccessKey: securityAlertPolicy.?storageAccountAccessKey ?? ''
      storageEndpoint: securityAlertPolicy.?storageEndpoint ?? ''
    }
  }
]

module server_vulnerabilityAssessment 'vulnerability-assessment/main.bicep' = if (!empty(vulnerabilityAssessmentsObj)) {
  name: '${uniqueString(deployment().name, location)}-Sql-VulnAssessm'
  params: {
    serverName: server.name
    name: vulnerabilityAssessmentsObj.name
    recurringScansEmails: vulnerabilityAssessmentsObj.?recurringScansEmails ?? []
    recurringScansEmailSubscriptionAdmins: vulnerabilityAssessmentsObj.?recurringScansEmailSubscriptionAdmins ?? false
    recurringScansIsEnabled: vulnerabilityAssessmentsObj.?recurringScansIsEnabled ?? false
    storageAccountResourceId: vulnerabilityAssessmentsObj.storageAccountResourceId
    useStorageAccountAccessKey: vulnerabilityAssessmentsObj.?useStorageAccountAccessKey ?? false
    createStorageRoleAssignment: vulnerabilityAssessmentsObj.?createStorageRoleAssignment ?? true
  }
  dependsOn: [
    server_securityAlertPolicies
  ]
}

module server_keys 'key/main.bicep' = [
  for (key, index) in keys: {
    name: '${uniqueString(deployment().name, location)}-Sql-Key-${index}'
    params: {
      name: key.?name
      serverName: server.name
      serverKeyType: key.?serverKeyType ?? 'ServiceManaged'
      uri: key.?uri ?? ''
    }
  }
]

module server_encryptionProtector 'encryption-protector/main.bicep' = if (!empty(encryptionProtectorObj)) {
  name: '${uniqueString(deployment().name, location)}-Sql-EncryProtector'
  params: {
    sqlServerName: server.name
    serverKeyName: encryptionProtectorObj.serverKeyName
    serverKeyType: encryptionProtectorObj.?serverKeyType ?? 'ServiceManaged'
    autoRotationEnabled: encryptionProtectorObj.?autoRotationEnabled ?? true
  }
  dependsOn: [
    server_keys
  ]
}

module server_audit_settings 'audit-settings/main.bicep' = if (auditSettings != null) {
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

@description('The name of the deployed SQL server.')
output name string = server.name

@description('The resource ID of the deployed SQL server.')
output resourceId string = server.id

@description('The resource group of the deployed SQL server.')
output resourceGroupName string = resourceGroup().name

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string = server.?identity.?principalId ?? ''

@description('The location the resource was deployed into.')
output location string = server.location

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
  @description('Optional. The name (as GUID) of the role assignment. If not provided, a GUID will be generated.')
  name: string?

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

  @description('Optional. The subresource to deploy the private endpoint for. For example "vault", "mysqlServer" or "dataFactory".')
  service: string?

  @description('Required. Resource ID of the subnet where the endpoint needs to be created.')
  subnetResourceId: string

  @description('Optional. The private DNS zone group to configure for the private endpoint.')
  privateDnsZoneGroup: {
    @description('Optional. The name of the Private DNS Zone Group.')
    name: string?

    @description('Required. The private DNS zone groups to associate the private endpoint. A DNS zone group can support up to 5 DNS zones.')
    privateDnsZoneGroupConfigs: {
      @description('Optional. The name of the private DNS zone group config.')
      name: string?

      @description('Required. The resource id of the private DNS zone.')
      privateDnsZoneResourceId: string
    }[]
  }?

  @description('Optional. If Manual Private Link Connection is required.')
  isManualConnection: bool?

  @description('Optional. A message passed to the owner of the remote resource with the manual connection request.')
  @maxLength(140)
  manualConnectionRequestMessage: string?

  @description('Optional. Custom DNS configurations.')
  customDnsConfigs: {
    @description('Optional. FQDN that resolves to private endpoint IP address.')
    fqdn: string?

    @description('Required. A list of private IP addresses of the private endpoint.')
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

      @description('Required. A private IP address obtained from the private endpoint\'s subnet.')
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

type secretsExportConfigurationType = {
  @description('Required. The resource ID of the key vault where to store the secrets of this module.')
  keyVaultResourceId: string

  @description('Optional. The sqlAdminPassword secret name to create.')
  sqlAdminPasswordSecretName: string?

  @description('Optional. The sqlAzureConnectionString secret name to create.')
  sqlAzureConnectionStringSercretName: string?
}?

type ServerExternalAdministratorType = {
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
  diagnosticSettings: diagnosticSettingType?

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

import { elasticPoolPerDatabaseSettingsType, elasticPoolSkuType } from 'elastic-pool/main.bicep'
import { databaseSkuType, diagnosticSettingType, shortTermBackupRetentionPolicyType, longTermBackupRetentionPolicyType } from 'database/main.bicep'

import { secretSetType } from 'modules/keyVaultExport.bicep'
type secretsOutputType = {
  @description('An exported secret\'s references.')
  *: secretSetType
}
