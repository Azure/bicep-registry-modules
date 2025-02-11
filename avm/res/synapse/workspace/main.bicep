metadata name = 'Synapse Workspaces'
metadata description = 'This module deploys a Synapse Workspace.'

// Parameters
@maxLength(50)
@description('Required. The name of the Synapse Workspace.')
param name string

@description('Optional. The geo-location where the resource lives.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Enable or Disable AzureADOnlyAuthentication on All Workspace sub-resource.')
param azureADOnlyAuthentication bool = false

@description('Optional. AAD object ID of initial workspace admin.')
param initialWorkspaceAdminObjectID string = ''

@description('Required. Resource ID of the default ADLS Gen2 storage account.')
param defaultDataLakeStorageAccountResourceId string

@description('Required. The default ADLS Gen2 file system.')
param defaultDataLakeStorageFilesystem string

@description('Optional. Create managed private endpoint to the default storage account or not. If Yes is selected, a managed private endpoint connection request is sent to the workspace\'s primary Data Lake Storage Gen2 account for Spark pools to access data. This must be approved by an owner of the storage account.')
param defaultDataLakeStorageCreateManagedPrivateEndpoint bool = false

@description('Optional. The Entra ID administrator for the synapse workspace.')
param administrator administratorType?

import { customerManagedKeyType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The customer managed key definition.')
param customerManagedKey customerManagedKeyType?

@description('Optional. Activate workspace by adding the system managed identity in the KeyVault containing the customer managed key and activating the workspace.')
param encryptionActivateWorkspace bool = false

@maxLength(90)
@description('Optional. Workspace managed resource group. The resource group name uniquely identifies the resource group within the user subscriptionId. The resource group name must be no longer than 90 characters long, and must be alphanumeric characters (Char.IsLetterOrDigit()) and \'-\', \'_\', \'(\', \')\' and\'.\'. Note that the name cannot end with \'.\'.')
param managedResourceGroupName string = ''

@description('Optional. Enable this to ensure that connection from your workspace to your data sources use Azure Private Links. You can create managed private endpoints to your data sources.')
param managedVirtualNetwork bool = false

@description('Optional. The Integration Runtimes to create.')
param integrationRuntimes array = []

@description('Optional. Allowed AAD Tenant IDs For Linking.')
param allowedAadTenantIdsForLinking array = []

@description('Optional. Linked Access Check On Target Resource.')
param linkedAccessCheckOnTargetResource bool = false

@description('Optional. Prevent Data Exfiltration.')
param preventDataExfiltration bool = false

@allowed([
  'Enabled'
  'Disabled'
])
@description('Optional. Enable or Disable public network access to workspace.')
param publicNetworkAccess string = 'Enabled'

@description('Optional. List of firewall rules to be created in the workspace.')
param firewallRules firewallRuleType[]?

@description('Optional. Purview Resource ID.')
param purviewResourceID string = ''

@description('Required. Login for administrator access to the workspace\'s SQL pools.')
param sqlAdministratorLogin string

@description('Optional. Password for administrator access to the workspace\'s SQL pools. If you don\'t provide a password, one will be automatically generated. You can change the password later.')
@secure()
param sqlAdministratorLoginPassword string = ''

@description('Optional. The account URL of the data lake storage account.')
param accountUrl string = 'https://${last(split(defaultDataLakeStorageAccountResourceId, '/'))!}.dfs.${environment().suffixes.storage}'

@description('Optional. Git integration settings.')
param workspaceRepositoryConfiguration object?

import { managedIdentityOnlyUserAssignedType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityOnlyUserAssignedType?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

import { privateEndpointMultiServiceType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointMultiServiceType[]?

import { diagnosticSettingLogsOnlyType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingLogsOnlyType[]?

// Variables

var cmkUserAssignedIdentityAsArray = !empty(customerManagedKey.?userAssignedIdentityResourceId ?? [])
  ? [customerManagedKey.?userAssignedIdentityResourceId]
  : []

var userAssignedIdentitiesUnion = !empty(managedIdentities)
  ? union(managedIdentities.?userAssignedResourceIds ?? [], cmkUserAssignedIdentityAsArray)
  : cmkUserAssignedIdentityAsArray

var formattedUserAssignedIdentities = reduce(
  map((userAssignedIdentitiesUnion ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = {
  type: !empty(userAssignedIdentitiesUnion) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned'
  userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
}

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Resource Policy Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '36243c78-bf99-498c-9df9-86d9f8d28608'
  )
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
  name: '46d3xbcp.res.synapse-workspace.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource workspace 'Microsoft.Synapse/workspaces@2021-06-01' = {
  name: name
  location: location
  identity: identity
  tags: tags
  properties: {
    azureADOnlyAuthentication: azureADOnlyAuthentication ? azureADOnlyAuthentication : null
    cspWorkspaceAdminProperties: !empty(initialWorkspaceAdminObjectID)
      ? {
          initialWorkspaceAdminObjectId: initialWorkspaceAdminObjectID
        }
      : null
    defaultDataLakeStorage: {
      resourceId: defaultDataLakeStorageAccountResourceId
      accountUrl: accountUrl
      filesystem: defaultDataLakeStorageFilesystem
      createManagedPrivateEndpoint: managedVirtualNetwork ? defaultDataLakeStorageCreateManagedPrivateEndpoint : null
    }
    encryption: !empty(customerManagedKey)
      ? {
          cmk: {
            kekIdentity: !empty(customerManagedKey.?userAssignedIdentityResourceId)
              ? {
                  userAssignedIdentity: cMKUserAssignedIdentity.id
                }
              : {
                  useSystemAssignedIdentity: empty(customerManagedKey.?userAssignedIdentityResourceId)
                }
            key: {
              keyVaultUrl: cMKKeyVault::cMKKey.properties.keyUri
              name: customerManagedKey!.keyName
            }
          }
        }
      : null
    managedResourceGroupName: !empty(managedResourceGroupName) ? managedResourceGroupName : null
    managedVirtualNetwork: managedVirtualNetwork ? 'default' : null
    managedVirtualNetworkSettings: managedVirtualNetwork
      ? {
          allowedAadTenantIdsForLinking: allowedAadTenantIdsForLinking
          linkedAccessCheckOnTargetResource: linkedAccessCheckOnTargetResource
          preventDataExfiltration: preventDataExfiltration
        }
      : null
    publicNetworkAccess: managedVirtualNetwork ? publicNetworkAccess : null
    purviewConfiguration: !empty(purviewResourceID)
      ? {
          purviewResourceId: purviewResourceID
        }
      : null
    sqlAdministratorLogin: sqlAdministratorLogin
    sqlAdministratorLoginPassword: !empty(sqlAdministratorLoginPassword) ? sqlAdministratorLoginPassword : null
    workspaceRepositoryConfiguration: workspaceRepositoryConfiguration
  }
}

// Workspace integration runtimes
module synapse_integrationRuntimes 'integration-runtime/main.bicep' = [
  for (integrationRuntime, index) in integrationRuntimes: {
    name: '${uniqueString(deployment().name, location)}-Synapse-IntegrationRuntime-${index}'
    params: {
      workspaceName: workspace.name
      name: integrationRuntime.name
      type: integrationRuntime.type
      typeProperties: integrationRuntime.?typeProperties ?? {}
    }
  }
]

// Workspace encryption with customer managed keys
// - Assign Synapse Workspace MSI access to encryption key
module workspace_cmk_rbac 'modules/nested_cmkRbac.bicep' = if (encryptionActivateWorkspace) {
  name: '${workspace.name}-cmk-rbac'
  params: {
    workspaceIndentityPrincipalId: workspace.identity.principalId
    keyvaultName: !empty(customerManagedKey!.keyVaultResourceId) ? cMKKeyVault.name : ''
    usesRbacAuthorization: !empty(customerManagedKey!.keyVaultResourceId)
      ? cMKKeyVault.properties.enableRbacAuthorization
      : true
  }
  scope: resourceGroup(
    split((customerManagedKey.?keyVaultResourceId ?? '//'), '/')[2],
    split((customerManagedKey.?keyVaultResourceId ?? '////'), '/')[4]
  )
}

// - Workspace encryption - Activate Workspace
module workspace_key 'key/main.bicep' = if (encryptionActivateWorkspace) {
  name: '${workspace.name}-cmk-activation'
  params: {
    name: customerManagedKey!.keyName
    isActiveCMK: true
    keyVaultResourceId: cMKKeyVault.id
    workspaceName: workspace.name
  }
  dependsOn: [
    workspace_cmk_rbac
  ]
}

// - Workspace Entra ID Administrator
module workspace_administrator 'administrators/main.bicep' = if (!empty(administrator)) {
  name: '${workspace.name}-administrator'
  params: {
    workspaceName: workspace.name
    administratorType: administrator!.administratorType
    login: administrator!.login
    sid: administrator!.sid
    tenantId: administrator.?tenantId
  }
}

// Resource Lock
resource workspace_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: workspace
}

// RBAC
resource workspace_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(workspace.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: workspace
  }
]

// Firewall Rules
module workspace_firewallRules 'firewall-rules/main.bicep' = [
  for (rule, index) in (firewallRules ?? []): {
    name: '${uniqueString(deployment().name, location)}-workspace-FirewallRule-${index}'
    params: {
      name: rule.name
      endIpAddress: rule.endIpAddress
      startIpAddress: rule.startIpAddress
      workspaceName: workspace.name
    }
  }
]

// Endpoints
module workspace_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.9.1' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-workspace-PrivateEndpoint-${index}'
    scope: !empty(privateEndpoint.?resourceGroupResourceId)
      ? resourceGroup(
          split((privateEndpoint.?resourceGroupResourceId ?? '//'), '/')[2],
          split((privateEndpoint.?resourceGroupResourceId ?? '////'), '/')[4]
        )
      : resourceGroup(
          split((privateEndpoint.?subnetResourceId ?? '//'), '/')[2],
          split((privateEndpoint.?subnetResourceId ?? '////'), '/')[4]
        )
    params: {
      name: privateEndpoint.?name ?? 'pep-${last(split(workspace.id, '/'))}-${privateEndpoint.service}-${index}'
      privateLinkServiceConnections: privateEndpoint.?isManualConnection != true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(workspace.id, '/'))}-${privateEndpoint.service}-${index}'
              properties: {
                privateLinkServiceId: workspace.id
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
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(workspace.id, '/'))}-${privateEndpoint.service}-${index}'
              properties: {
                privateLinkServiceId: workspace.id
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

// Diagnostics Settings
resource workspace_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for (diagnosticSetting, index) in (diagnosticSettings ?? []): {
    name: diagnosticSetting.?name ?? '${name}-diagnosticSettings'
    properties: {
      storageAccountId: diagnosticSetting.?storageAccountResourceId
      workspaceId: diagnosticSetting.?workspaceResourceId
      eventHubAuthorizationRuleId: diagnosticSetting.?eventHubAuthorizationRuleResourceId
      eventHubName: diagnosticSetting.?eventHubName
      logs: diagnosticSetting.?logCategoriesAndGroups ?? [
        {
          categoryGroup: 'AllLogs'
          enabled: true
        }
      ]
      marketplacePartnerId: diagnosticSetting.?marketplacePartnerResourceId
      logAnalyticsDestinationType: diagnosticSetting.?logAnalyticsDestinationType
    }
    scope: workspace
  }
]

@description('The resource ID of the deployed Synapse Workspace.')
output resourceID string = workspace.id

@description('The name of the deployed Synapse Workspace.')
output name string = workspace.name

@description('The resource group of the deployed Synapse Workspace.')
output resourceGroupName string = resourceGroup().name

@description('The workspace connectivity endpoints.')
output connectivityEndpoints object = workspace.properties.connectivityEndpoints

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string? = workspace.?identity.?principalId

@description('The location the resource was deployed into.')
output location string = workspace.location

@description('The private endpoints of the Synapse Workspace.')
output privateEndpoints privateEndpointOutputType[] = [
  for (pe, i) in (privateEndpoints ?? []): {
    name: workspace_privateEndpoints[i].outputs.name
    resourceId: workspace_privateEndpoints[i].outputs.resourceId
    groupId: workspace_privateEndpoints[i].outputs.groupId
    customDnsConfigs: workspace_privateEndpoints[i].outputs.customDnsConfig
    networkInterfaceResourceIds: workspace_privateEndpoints[i].outputs.networkInterfaceResourceIds
  }
]

// =============== //
//   Definitions   //
// =============== //

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
@description('The synapse workspace administrator\'s interface.')
type administratorType = {
  @description('Required. Workspace active directory administrator type.')
  administratorType: string

  @description('Required. Login of the workspace active directory administrator.')
  @secure()
  login: string

  @description('Required. Object ID of the workspace active directory administrator.')
  @secure()
  sid: string

  @description('Optional. Tenant ID of the workspace active directory administrator.')
  @secure()
  tenantId: string?
}

@export()
@description('The synapse workspace firewall rule\'s interface.')
type firewallRuleType = {
  @description('Required. The name of the firewall rule.')
  name: string

  @description('Required. The start IP address of the firewall rule. Must be IPv4 format.')
  startIpAddress: string

  @description('Required. The end IP address of the firewall rule. Must be IPv4 format. Must be greater than or equal to startIpAddress.')
  endIpAddress: string
}
