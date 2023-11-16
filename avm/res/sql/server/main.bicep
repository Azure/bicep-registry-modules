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

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments roleAssignmentType

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. The databases to create in the server.')
param databases array = []

@description('Optional. The Elastic Pools to create in the server.')
param elasticPools array = []

@description('Optional. The firewall rules to create in the server.')
param firewallRules array = []

@description('Optional. The virtual network rules to create in the server.')
param virtualNetworkRules array = []

@description('Optional. The security alert policies to create in the server.')
param securityAlertPolicies array = []

@description('Optional. The keys to configure.')
param keys array = []

@description('Conditional. The Azure Active Directory (AAD) administrator authentication. Required if no `administratorLogin` & `administratorLoginPassword` is provided.')
param administrators object = {}

@allowed([
  '1.0'
  '1.1'
  '1.2'
])
@description('Optional. Minimal TLS version allowed.')
param minimalTlsVersion string = '1.2'

@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointType

@description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and neither firewall rules nor virtual network rules are set.')
@allowed([
  ''
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = ''

@description('Optional. Whether or not to restrict outbound network access for this server.')
@allowed([
  ''
  'Enabled'
  'Disabled'
])
param restrictOutboundNetworkAccess string = ''

var formattedUserAssignedIdentities = reduce(map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }), {}, (cur, next) => union(cur, next)) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities) ? {
  type: (managedIdentities.?systemAssigned ?? false) ? (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned') : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : null)
  userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
} : null

var enableReferencedModulesTelemetry = false

@description('Optional. The encryption protection configuration.')
param encryptionProtectorObj object = {}

@description('Optional. The vulnerability assessment configuration.')
param vulnerabilityAssessmentsObj object = {}

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Reservation Purchaser': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f7b75c60-3036-4b75-91c3-6b41c27c1689')
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f58310d9-a9f6-439a-9e8d-f62e7b41a168')
  'SQL DB Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '9b7fa17d-e63e-47b0-bb0a-15c516ac86ec')
  'SQL Managed Instance Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4939a1f6-9ae0-4e48-a1e0-f2cbe897382d')
  'SQL Security Manager': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '056cd41c-7e88-42e1-933e-88ba6a50c9c3')
  'SQL Server Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '6d8ee4ec-f05a-4a1d-8b00-a9b17e38b437')
  'SqlDb Migration Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '189207d4-bb67-4208-a635-b06afe8b2c57')
  'SqlMI Migration Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '1d335eef-eee1-47fe-a9e0-53214eba8872')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
}

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
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

resource server 'Microsoft.Sql/servers@2022-05-01-preview' = {
  location: location
  name: name
  tags: tags
  identity: identity
  properties: {
    administratorLogin: !empty(administratorLogin) ? administratorLogin : null
    administratorLoginPassword: !empty(administratorLoginPassword) ? administratorLoginPassword : null
    administrators: !empty(administrators) ? {
      administratorType: 'ActiveDirectory'
      azureADOnlyAuthentication: administrators.azureADOnlyAuthentication
      login: administrators.login
      principalType: administrators.principalType
      sid: administrators.sid
      tenantId: administrators.tenantId
    } : null
    version: '12.0'
    minimalTlsVersion: minimalTlsVersion
    primaryUserAssignedIdentityId: !empty(primaryUserAssignedIdentityId) ? primaryUserAssignedIdentityId : null
    publicNetworkAccess: !empty(publicNetworkAccess) ? any(publicNetworkAccess) : (!empty(privateEndpoints) && empty(firewallRules) && empty(virtualNetworkRules) ? 'Disabled' : null)
    restrictOutboundNetworkAccess: !empty(restrictOutboundNetworkAccess) ? restrictOutboundNetworkAccess : null
  }
}

resource server_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot delete or modify the resource or child resources.'
  }
  scope: server
}

resource server_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (roleAssignment, index) in (roleAssignments ?? []): {
  name: guid(server.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName
    principalId: roleAssignment.principalId
    description: roleAssignment.?description
    principalType: roleAssignment.?principalType
    condition: roleAssignment.?condition
    conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
    delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
  }
  scope: server
}]

module server_databases 'database/main.bicep' = [for (database, index) in databases: {
  name: '${uniqueString(deployment().name, location)}-Sql-DB-${index}'
  params: {
    name: database.name
    serverName: server.name
    skuTier: contains(database, 'skuTier') ? database.skuTier : 'GeneralPurpose'
    skuName: contains(database, 'skuName') ? database.skuName : 'GP_Gen5_2'
    skuCapacity: contains(database, 'skuCapacity') ? database.skuCapacity : -1
    skuFamily: contains(database, 'skuFamily') ? database.skuFamily : ''
    skuSize: contains(database, 'skuSize') ? database.skuSize : ''
    collation: contains(database, 'collation') ? database.collation : 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: contains(database, 'maxSizeBytes') ? database.maxSizeBytes : 34359738368
    autoPauseDelay: contains(database, 'autoPauseDelay') ? database.autoPauseDelay : 0
    diagnosticSettings: database.?diagnosticSettings
    isLedgerOn: contains(database, 'isLedgerOn') ? database.isLedgerOn : false
    location: location
    licenseType: contains(database, 'licenseType') ? database.licenseType : ''
    maintenanceConfigurationId: contains(database, 'maintenanceConfigurationId') ? database.maintenanceConfigurationId : ''
    minCapacity: contains(database, 'minCapacity') ? database.minCapacity : ''
    highAvailabilityReplicaCount: contains(database, 'highAvailabilityReplicaCount') ? database.highAvailabilityReplicaCount : 0
    readScale: contains(database, 'readScale') ? database.readScale : 'Disabled'
    requestedBackupStorageRedundancy: contains(database, 'requestedBackupStorageRedundancy') ? database.requestedBackupStorageRedundancy : ''
    sampleName: contains(database, 'sampleName') ? database.sampleName : ''
    tags: database.?tags ?? tags
    zoneRedundant: contains(database, 'zoneRedundant') ? database.zoneRedundant : false
    elasticPoolId: contains(database, 'elasticPoolId') ? database.elasticPoolId : ''
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    backupShortTermRetentionPolicy: contains(database, 'backupShortTermRetentionPolicy') ? database.backupShortTermRetentionPolicy : {}
    backupLongTermRetentionPolicy: contains(database, 'backupLongTermRetentionPolicy') ? database.backupLongTermRetentionPolicy : {}
    createMode: contains(database, 'createMode') ? database.createMode : 'Default'
    sourceDatabaseResourceId: contains(database, 'sourceDatabaseResourceId') ? database.sourceDatabaseResourceId : ''
    sourceDatabaseDeletionDate: contains(database, 'sourceDatabaseDeletionDate') ? database.sourceDatabaseDeletionDate : ''
    recoveryServicesRecoveryPointResourceId: contains(database, 'recoveryServicesRecoveryPointResourceId') ? database.recoveryServicesRecoveryPointResourceId : ''
    restorePointInTime: contains(database, 'restorePointInTime') ? database.restorePointInTime : ''
  }
  dependsOn: [
    server_elasticPools // Enables us to add databases to existing elastic pools
  ]
}]

module server_elasticPools 'elastic-pool/main.bicep' = [for (elasticPool, index) in elasticPools: {
  name: '${uniqueString(deployment().name, location)}-SQLServer-ElasticPool-${index}'
  params: {
    name: elasticPool.name
    serverName: server.name
    databaseMaxCapacity: contains(elasticPool, 'databaseMaxCapacity') ? elasticPool.databaseMaxCapacity : 2
    databaseMinCapacity: contains(elasticPool, 'databaseMinCapacity') ? elasticPool.databaseMinCapacity : 0
    highAvailabilityReplicaCount: contains(elasticPool, 'highAvailabilityReplicaCount') ? elasticPool.highAvailabilityReplicaCount : -1
    licenseType: contains(elasticPool, 'licenseType') ? elasticPool.licenseType : 'LicenseIncluded'
    maintenanceConfigurationId: contains(elasticPool, 'maintenanceConfigurationId') ? elasticPool.maintenanceConfigurationId : ''
    maxSizeBytes: contains(elasticPool, 'maxSizeBytes') ? elasticPool.maxSizeBytes : 34359738368
    minCapacity: contains(elasticPool, 'minCapacity') ? elasticPool.minCapacity : -1
    skuCapacity: contains(elasticPool, 'skuCapacity') ? elasticPool.skuCapacity : 2
    skuName: contains(elasticPool, 'skuName') ? elasticPool.skuName : 'GP_Gen5'
    skuTier: contains(elasticPool, 'skuTier') ? elasticPool.skuTier : 'GeneralPurpose'
    zoneRedundant: contains(elasticPool, 'zoneRedundant') ? elasticPool.zoneRedundant : false
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    location: location
    tags: elasticPool.?tags ?? tags
  }
}]

module server_privateEndpoints '../../network/private-endpoint/main.bicep' = [for (privateEndpoint, index) in (privateEndpoints ?? []): {
  name: '${uniqueString(deployment().name, location)}-server-PrivateEndpoint-${index}'
  params: {
    groupIds: [
      privateEndpoint.?service ?? 'sqlServer'
    ]
    name: privateEndpoint.?name ?? 'pep-${last(split(server.id, '/'))}-${privateEndpoint.?service ?? 'sqlServer'}-${index}'
    serviceResourceId: server.id
    subnetResourceId: privateEndpoint.subnetResourceId
    enableDefaultTelemetry: privateEndpoint.?enableDefaultTelemetry ?? enableReferencedModulesTelemetry
    location: privateEndpoint.?location ?? reference(split(privateEndpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location
    lock: privateEndpoint.?lock ?? lock
    privateDnsZoneGroupName: privateEndpoint.?privateDnsZoneGroupName
    privateDnsZoneResourceIds: privateEndpoint.?privateDnsZoneResourceIds
    roleAssignments: privateEndpoint.?roleAssignments
    tags: privateEndpoint.?tags ?? tags
    manualPrivateLinkServiceConnections: privateEndpoint.?manualPrivateLinkServiceConnections
    customDnsConfigs: privateEndpoint.?customDnsConfigs
    ipConfigurations: privateEndpoint.?ipConfigurations
    applicationSecurityGroupResourceIds: privateEndpoint.?applicationSecurityGroupResourceIds
    customNetworkInterfaceName: privateEndpoint.?customNetworkInterfaceName
  }
}]

module server_firewallRules 'firewall-rule/main.bicep' = [for (firewallRule, index) in firewallRules: {
  name: '${uniqueString(deployment().name, location)}-Sql-FirewallRules-${index}'
  params: {
    name: firewallRule.name
    serverName: server.name
    endIpAddress: contains(firewallRule, 'endIpAddress') ? firewallRule.endIpAddress : '0.0.0.0'
    startIpAddress: contains(firewallRule, 'startIpAddress') ? firewallRule.startIpAddress : '0.0.0.0'
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module server_virtualNetworkRules 'virtual-network-rule/main.bicep' = [for (virtualNetworkRule, index) in virtualNetworkRules: {
  name: '${uniqueString(deployment().name, location)}-Sql-VirtualNetworkRules-${index}'
  params: {
    name: virtualNetworkRule.name
    serverName: server.name
    ignoreMissingVnetServiceEndpoint: contains(virtualNetworkRule, 'ignoreMissingVnetServiceEndpoint') ? virtualNetworkRule.ignoreMissingVnetServiceEndpoint : false
    virtualNetworkSubnetId: virtualNetworkRule.virtualNetworkSubnetId
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module server_securityAlertPolicies 'security-alert-policy/main.bicep' = [for (securityAlertPolicy, index) in securityAlertPolicies: {
  name: '${uniqueString(deployment().name, location)}-Sql-SecAlertPolicy-${index}'
  params: {
    name: securityAlertPolicy.name
    serverName: server.name
    disabledAlerts: contains(securityAlertPolicy, 'disabledAlerts') ? securityAlertPolicy.disabledAlerts : []
    emailAccountAdmins: contains(securityAlertPolicy, 'emailAccountAdmins') ? securityAlertPolicy.emailAccountAdmins : false
    emailAddresses: contains(securityAlertPolicy, 'emailAddresses') ? securityAlertPolicy.emailAddresses : []
    retentionDays: contains(securityAlertPolicy, 'retentionDays') ? securityAlertPolicy.retentionDays : 0
    state: contains(securityAlertPolicy, 'state') ? securityAlertPolicy.state : 'Disabled'
    storageAccountAccessKey: contains(securityAlertPolicy, 'storageAccountAccessKey') ? securityAlertPolicy.storageAccountAccessKey : ''
    storageEndpoint: contains(securityAlertPolicy, 'storageEndpoint') ? securityAlertPolicy.storageEndpoint : ''
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module server_vulnerabilityAssessment 'vulnerability-assessment/main.bicep' = if (!empty(vulnerabilityAssessmentsObj)) {
  name: '${uniqueString(deployment().name, location)}-Sql-VulnAssessm'
  params: {
    serverName: server.name
    name: vulnerabilityAssessmentsObj.name
    recurringScansEmails: contains(vulnerabilityAssessmentsObj, 'recurringScansEmails') ? vulnerabilityAssessmentsObj.recurringScansEmails : []
    recurringScansEmailSubscriptionAdmins: contains(vulnerabilityAssessmentsObj, 'recurringScansEmailSubscriptionAdmins') ? vulnerabilityAssessmentsObj.recurringScansEmailSubscriptionAdmins : false
    recurringScansIsEnabled: contains(vulnerabilityAssessmentsObj, 'recurringScansIsEnabled') ? vulnerabilityAssessmentsObj.recurringScansIsEnabled : false
    storageAccountResourceId: vulnerabilityAssessmentsObj.storageAccountResourceId
    useStorageAccountAccessKey: contains(vulnerabilityAssessmentsObj, 'useStorageAccountAccessKey') ? vulnerabilityAssessmentsObj.useStorageAccountAccessKey : false
    createStorageRoleAssignment: contains(vulnerabilityAssessmentsObj, 'createStorageRoleAssignment') ? vulnerabilityAssessmentsObj.createStorageRoleAssignment : true
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
  dependsOn: [
    server_securityAlertPolicies
  ]
}

module server_keys 'key/main.bicep' = [for (key, index) in keys: {
  name: '${uniqueString(deployment().name, location)}-Sql-Key-${index}'
  params: {
    name: key.name
    serverName: server.name
    serverKeyType: contains(key, 'serverKeyType') ? key.serverKeyType : 'ServiceManaged'
    uri: contains(key, 'uri') ? key.uri : ''
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module server_encryptionProtector 'encryption-protector/main.bicep' = if (!empty(encryptionProtectorObj)) {
  name: '${uniqueString(deployment().name, location)}-Sql-EncryProtector'
  params: {
    sqlServerName: server.name
    serverKeyName: encryptionProtectorObj.serverKeyName
    serverKeyType: contains(encryptionProtectorObj, 'serverKeyType') ? encryptionProtectorObj.serverKeyType : 'ServiceManaged'
    autoRotationEnabled: contains(encryptionProtectorObj, 'autoRotationEnabled') ? encryptionProtectorObj.autoRotationEnabled : true
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
  dependsOn: [
    server_keys
  ]
}

@description('The name of the deployed SQL server.')
output name string = server.name

@description('The resource ID of the deployed SQL server.')
output resourceId string = server.id

@description('The resource group of the deployed SQL server.')
output resourceGroupName string = resourceGroup().name

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string = (managedIdentities.?systemAssigned ?? false) && contains(server.identity, 'principalId') ? server.identity.principalId : ''

@description('The location the resource was deployed into.')
output location string = server.location

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
  @description('Required. The name of the role to assign. If it cannot be found you can specify the role definition ID instead.')
  roleDefinitionIdOrName: string

  @description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
  principalId: string

  @description('Optional. The principal type of the assigned principal ID.')
  principalType: ('ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup' | 'Device')?

  @description('Optional. The description of the role assignment.')
  description: string?

  @description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container"')
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

  @description('Optional. The service (sub-) type to deploy the private endpoint for. For example "vault" or "blob".')
  service: string?

  @description('Required. Resource ID of the subnet where the endpoint needs to be created.')
  subnetResourceId: string

  @description('Optional. The name of the private DNS zone group to create if privateDnsZoneResourceIds were provided.')
  privateDnsZoneGroupName: string?

  @description('Optional. The private DNS zone groups to associate the private endpoint with. A DNS zone group can support up to 5 DNS zones.')
  privateDnsZoneResourceIds: string[]?

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

  @description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
  roleAssignments: roleAssignmentType

  @description('Optional. Tags to be applied on all resources/resource groups in this deployment.')
  tags: object?

  @description('Optional. Manual PrivateLink Service Connections.')
  manualPrivateLinkServiceConnections: array?

  @description('Optional. Enable/Disable usage telemetry for module.')
  enableTelemetry: bool?
}[]?
