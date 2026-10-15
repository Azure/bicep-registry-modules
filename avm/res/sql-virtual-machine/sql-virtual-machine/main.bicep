metadata name = 'SQL Virtual Machine'
metadata description = 'This module deploys an Azure SQL Virtual Machine.'

@description('Required. The resource ID of the underlying virtual machine.')
param virtualMachineResourceId string

@description('Optional. The name of the SQL virtual machine. Must match the name of the underlying virtual machine. Defaults to the name of the virtual machine referenced in `virtualMachineResourceId`.')
param name string = last(split(virtualMachineResourceId, '/'))

@description('Required. The SQL Server license type.')
@allowed([
  'AHUB'
  'DR'
  'PAYG'
])
param sqlServerLicenseType string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@secure()
@description('Optional. Automated backup settings for SQL Server. Note: Automated Backup authenticates to the target storage account using a storage account access key, so the storage account must allow shared key access and be reachable from the virtual machine.')
param autoBackupSettings resourceInput<'Microsoft.SqlVirtualMachine/sqlVirtualMachines@2023-10-01'>.properties.autoBackupSettings?

@description('Optional. Automated patching settings for the SQL virtual machine. Note: Automated Patching is scheduled to retire on September 17, 2027 and should not be used for new environments. Use Azure Update Manager (for example, a maintenance configuration assigned to the underlying virtual machine) instead. Do not combine multiple patching solutions on the same virtual machine.')
param autoPatchingSettings resourceInput<'Microsoft.SqlVirtualMachine/sqlVirtualMachines@2023-10-01'>.properties.autoPatchingSettings?

@description('Optional. SQL best practices assessment settings.')
param assessmentSettings resourceInput<'Microsoft.SqlVirtualMachine/sqlVirtualMachines@2023-10-01'>.properties.assessmentSettings?

@description('Optional. Enable automatic upgrade of the SQL IaaS Agent extension.')
param enableAutomaticUpgrade bool = true

@secure()
@description('Optional. Key Vault credential settings for the SQL virtual machine.')
param keyVaultCredentialSettings resourceInput<'Microsoft.SqlVirtualMachine/sqlVirtualMachines@2023-10-01'>.properties.keyVaultCredentialSettings?

@description('Optional. SQL IaaS Agent least privilege mode.')
@allowed([
  'Enabled'
  'NotSet'
])
param leastPrivilegeMode string = 'Enabled'

@secure()
@description('Optional. SQL Server configuration management settings.')
param serverConfigurationsManagementSettings resourceInput<'Microsoft.SqlVirtualMachine/sqlVirtualMachines@2023-10-01'>.properties.serverConfigurationsManagementSettings?

@description('Optional. SQL Server image offer. Examples include SQL2019-WS2022 and SQL2022-WS2022.')
param sqlImageOffer string?

@description('Optional. SQL Server edition.')
@allowed([
  'Developer'
  'Enterprise'
  'Express'
  'Standard'
  'Web'
])
param sqlImageSku string?

@description('Optional. SQL Server IaaS Agent management mode. Although the API documents this property as automatically detected, it must be set to `Full` when `leastPrivilegeMode` is `Enabled`, as the registration may otherwise fall back to `LightWeight` mode and fail.')
@allowed([
  'Full'
  'LightWeight'
  'NoAgent'
])
param sqlManagement string = 'Full'

@description('Optional. Resource ID of the SQL virtual machine group that this SQL virtual machine is or will be part of.')
param sqlVirtualMachineGroupResourceId string?

@description('Optional. SQL Server storage configuration settings. Cannot be combined with `serverConfigurationsManagementSettings.sqlStorageUpdateSettings` or `serverConfigurationsManagementSettings.sqlWorkloadTypeUpdateSettings`; use `storageWorkloadType` instead.')
param storageConfigurationSettings resourceInput<'Microsoft.SqlVirtualMachine/sqlVirtualMachines@2023-10-01'>.properties.storageConfigurationSettings?

@description('Optional. Virtual machine identity details used for SQL IaaS Agent extension configurations.')
param virtualMachineIdentitySettings resourceInput<'Microsoft.SqlVirtualMachine/sqlVirtualMachines@2023-10-01'>.properties.virtualMachineIdentitySettings?

@secure()
@description('Optional. Domain credentials for configuring a Windows Server Failover Cluster for a SQL availability group.')
param wsfcDomainCredentials resourceInput<'Microsoft.SqlVirtualMachine/sqlVirtualMachines@2023-10-01'>.properties.wsfcDomainCredentials?

@description('Optional. Static IP address used for the Windows Server Failover Cluster.')
param wsfcStaticIp string?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Tags of the resource.')
param tags resourceInput<'Microsoft.SqlVirtualMachine/sqlVirtualMachines@2023-10-01'>.tags?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var builtInRoleNames = {
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
  'Virtual Machine Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '9980e02c-c2be-4d73-94e8-173b1dc7cf3c'
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

var telemetryIdPrefix = loadJsonContent('metadata.json', 'telemetryIdPrefix')

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '${telemetryIdPrefix}.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource sqlVirtualMachine 'Microsoft.SqlVirtualMachine/sqlVirtualMachines@2023-10-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    assessmentSettings: assessmentSettings
    autoBackupSettings: autoBackupSettings
    autoPatchingSettings: autoPatchingSettings
    enableAutomaticUpgrade: enableAutomaticUpgrade
    keyVaultCredentialSettings: keyVaultCredentialSettings
    leastPrivilegeMode: leastPrivilegeMode
    serverConfigurationsManagementSettings: serverConfigurationsManagementSettings
    sqlImageOffer: sqlImageOffer
    sqlImageSku: sqlImageSku
    sqlManagement: sqlManagement
    sqlServerLicenseType: sqlServerLicenseType
    sqlVirtualMachineGroupResourceId: sqlVirtualMachineGroupResourceId
    storageConfigurationSettings: storageConfigurationSettings
    virtualMachineIdentitySettings: virtualMachineIdentitySettings
    virtualMachineResourceId: virtualMachineResourceId
    wsfcDomainCredentials: wsfcDomainCredentials
    wsfcStaticIp: wsfcStaticIp
  }
}

resource sqlVirtualMachine_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?notes ?? (lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.')
  }
  scope: sqlVirtualMachine
}

resource sqlVirtualMachine_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(
      sqlVirtualMachine.id,
      roleAssignment.principalId,
      roleAssignment.roleDefinitionId
    )
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: sqlVirtualMachine
  }
]

@description('The name of the SQL virtual machine.')
output name string = sqlVirtualMachine.name

@description('The resource ID of the SQL virtual machine.')
output resourceId string = sqlVirtualMachine.id

@description('The name of the resource group in which the SQL virtual machine was created.')
output resourceGroupName string = resourceGroup().name

@description('The location of the SQL virtual machine.')
output location string = sqlVirtualMachine.location
