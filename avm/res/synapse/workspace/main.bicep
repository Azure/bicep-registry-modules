metadata name = 'Synapse Workspaces'
metadata description = 'This module deploys a Synapse Workspace.'
metadata owner = 'Azure/module-maintainers'

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
param administrator adminType

@description('Optional. The customer managed key definition.')
param customerManagedKey customerManagedKeyType

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

@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentitiesType

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointType

@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingType

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
      typeProperties: contains(integrationRuntime, 'typeProperties') ? integrationRuntime.typeProperties : {}
    }
  }
]

// Workspace encryption with customer managed keys
// - Assign Synapse Workspace MSI access to encryption key
module workspace_cmk_rbac 'modules/nested_cmkRbac.bicep' = if (encryptionActivateWorkspace) {
  name: '${workspace.name}-cmk-rbac'
  params: {
    workspaceIndentityPrincipalId: workspace.identity.principalId
    keyvaultName: !empty(customerManagedKey.?keyVaultResourceId) ? cMKKeyVault.name : ''
    usesRbacAuthorization: !empty(customerManagedKey.?keyVaultResourceId)
      ? cMKKeyVault.properties.enableRbacAuthorization
      : true
  }
  scope: encryptionActivateWorkspace
    ? resourceGroup(
        split((customerManagedKey.?keyVaultResourceId ?? '//'), '/')[2],
        split((customerManagedKey.?keyVaultResourceId ?? '////'), '/')[4]
      )
    : resourceGroup()
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
module workspace_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.7.1' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-workspace-PrivateEndpoint-${index}'
    scope: resourceGroup(privateEndpoint.?resourceGroupName ?? '')
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
output systemAssignedMIPrincipalId string = workspace.?identity.?principalId ?? ''

@description('The location the resource was deployed into.')
output location string = workspace.location

@description('The private endpoints of the Synapse Workspace.')
output privateEndpoints array = [
  for (pe, i) in (!empty(privateEndpoints) ? array(privateEndpoints) : []): {
    name: workspace_privateEndpoints[i].outputs.name
    resourceId: workspace_privateEndpoints[i].outputs.resourceId
    groupId: workspace_privateEndpoints[i].outputs.groupId
    customDnsConfig: workspace_privateEndpoints[i].outputs.customDnsConfig
    networkInterfaceIds: workspace_privateEndpoints[i].outputs.networkInterfaceIds
  }
]

// =============== //
//   Definitions   //
// =============== //

type managedIdentitiesType = {
  @description('Optional. The resource ID(s) to assign to the resource.')
  userAssignedResourceIds: string[]
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

  @description('Required. The subresource to deploy the private endpoint for. For example "blob", "table", "queue" or "file".')
  service: string

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
    @description('Required. Fqdn that resolves to private endpoint IP address.')
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

type diagnosticSettingType = {
  @description('Optional. The name of diagnostic setting.')
  name: string?

  @description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to \'\' to disable log collection.')
  logCategoriesAndGroups: {
    @description('Optional. Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.')
    category: string?

    @description('Optional. Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to \'AllLogs\' to collect all logs.')
    categoryGroup: string?
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

type adminType = {
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
}?

type firewallRuleType = {
  @description('Required. The name of the firewall rule.')
  name: string

  @description('Required. The start IP address of the firewall rule. Must be IPv4 format.')
  startIpAddress: string

  @description('Required. The end IP address of the firewall rule. Must be IPv4 format. Must be greater than or equal to startIpAddress.')
  endIpAddress: string
}
