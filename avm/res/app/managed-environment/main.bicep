metadata name = 'App ManagedEnvironments'
metadata description = 'This module deploys an App Managed Environment (also known as a Container App Environment).'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the Container Apps Managed Environment.')
param name string

@description('Required. Existing Log Analytics Workspace resource ID. Note: This value is not required as per the resource type. However, not providing it currently causes an issue that is tracked [here](https://github.com/Azure/bicep/issues/9990).')
param logAnalyticsWorkspaceResourceId string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentitiesType

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. Logs destination.')
param logsDestination string = 'log-analytics'

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Application Insights connection string.')
@secure()
param appInsightsConnectionString string = ''

@description('Optional. Application Insights connection string used by Dapr to export Service to Service communication telemetry.')
@secure()
param daprAIConnectionString string = ''

@description('Optional. Azure Monitor instrumentation key used by Dapr to export Service to Service communication telemetry.')
@secure()
param daprAIInstrumentationKey string = ''

@description('Conditional. CIDR notation IP range assigned to the Docker bridge, network. It must not overlap with any other provided IP ranges and can only be used when the environment is deployed into a virtual network. If not provided, it will be set with a default value by the platform. Required if zoneRedundant is set to true to make the resource WAF compliant.')
param dockerBridgeCidr string = ''

@description('Conditional. Resource ID of a subnet for infrastructure components. This is used to deploy the environment into a virtual network. Must not overlap with any other provided IP ranges. Required if "internal" is set to true. Required if zoneRedundant is set to true to make the resource WAF compliant.')
param infrastructureSubnetId string = ''

@description('Conditional. Boolean indicating the environment only has an internal load balancer. These environments do not have a public static IP resource. If set to true, then "infrastructureSubnetId" must be provided. Required if zoneRedundant is set to true to make the resource WAF compliant.')
param internal bool = false

@description('Conditional. IP range in CIDR notation that can be reserved for environment infrastructure IP addresses. It must not overlap with any other provided IP ranges and can only be used when the environment is deployed into a virtual network. If not provided, it will be set with a default value by the platform. Required if zoneRedundant is set to true  to make the resource WAF compliant.')
param platformReservedCidr string = ''

@description('Conditional. An IP address from the IP range defined by "platformReservedCidr" that will be reserved for the internal DNS server. It must not be the first address in the range and can only be used when the environment is deployed into a virtual network. If not provided, it will be set with a default value by the platform. Required if zoneRedundant is set to true to make the resource WAF compliant.')
param platformReservedDnsIP string = ''

@description('Optional. Whether or not to encrypt peer traffic.')
param peerTrafficEncryption bool = true

@description('Optional. Whether or not this Managed Environment is zone-redundant.')
param zoneRedundant bool = true

@description('Optional. Password of the certificate used by the custom domain.')
@secure()
param certificatePassword string = ''

@description('Optional. Certificate to use for the custom domain. PFX or PEM.')
@secure()
param certificateValue string = ''

@description('Optional. DNS suffix for the environment domain.')
param dnsSuffix string = ''

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Open Telemetry configuration.')
param openTelemetryConfiguration object = {}

@description('Conditional. Workload profiles configured for the Managed Environment. Required if zoneRedundant is set to true to make the resource WAF compliant.')
param workloadProfiles array = []

@description('Conditional. Name of the infrastructure resource group. If not provided, it will be set with a default value. Required if zoneRedundant is set to true to make the resource WAF compliant.')
param infrastructureResourceGroupName string = take('ME_${name}', 63)

@description('Optional. The list of storages to mount on the environment.')
param storages storageType

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned')
        : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : 'None')
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

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
  name: '46d3xbcp.res.app-managedenvironment.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' existing = if (!empty(logAnalyticsWorkspaceResourceId)) {
  name: last(split(logAnalyticsWorkspaceResourceId, '/'))!
  scope: resourceGroup(split(logAnalyticsWorkspaceResourceId, '/')[2], split(logAnalyticsWorkspaceResourceId, '/')[4])
}

resource managedEnvironment 'Microsoft.App/managedEnvironments@2024-02-02-preview' = {
  name: name
  location: location
  tags: tags
  identity: identity
  properties: {
    appInsightsConfiguration: {
      connectionString: appInsightsConnectionString
    }
    appLogsConfiguration: {
      destination: logsDestination
      logAnalyticsConfiguration: {
        customerId: logAnalyticsWorkspace.properties.customerId
        sharedKey: logAnalyticsWorkspace.listKeys().primarySharedKey
      }
    }
    daprAIConnectionString: daprAIConnectionString
    daprAIInstrumentationKey: daprAIInstrumentationKey
    customDomainConfiguration: {
      certificatePassword: certificatePassword
      certificateValue: !empty(certificateValue) ? certificateValue : null
      dnsSuffix: dnsSuffix
    }
    openTelemetryConfiguration: !empty(openTelemetryConfiguration) ? openTelemetryConfiguration : null
    peerTrafficConfiguration: {
      encryption: {
        enabled: peerTrafficEncryption
      }
    }
    vnetConfiguration: {
      internal: internal
      infrastructureSubnetId: !empty(infrastructureSubnetId) ? infrastructureSubnetId : null
      dockerBridgeCidr: !empty(infrastructureSubnetId) ? dockerBridgeCidr : null
      platformReservedCidr: empty(workloadProfiles) && !empty(infrastructureSubnetId) ? platformReservedCidr : null
      platformReservedDnsIP: empty(workloadProfiles) && !empty(infrastructureSubnetId) ? platformReservedDnsIP : null
    }
    workloadProfiles: !empty(workloadProfiles) ? workloadProfiles : null
    zoneRedundant: zoneRedundant
    infrastructureResourceGroup: infrastructureResourceGroupName
  }

  resource storage 'storages' = [
    for storage in (storages ?? []): {
      name: storage.shareName
      properties: {
        nfsAzureFile: storage.kind == 'NFS'
          ? {
              accessMode: storage.accessMode
              server: '${storage.storageAccountName}.file.${environment().suffixes.storage}'
              shareName: '/${storage.storageAccountName}/${storage.shareName}'
            }
          : null
        azureFile: storage.kind == 'SMB'
          ? {
              accessMode: storage.accessMode
              accountName: storage.storageAccountName
              accountKey: listkeys(
                resourceId('Microsoft.Storage/storageAccounts', storage.storageAccountName),
                '2023-01-01'
              ).keys[0].value
              shareName: storage.shareName
            }
          : null
      }
    }
  ]
}

resource managedEnvironment_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(
      managedEnvironment.id,
      roleAssignment.principalId,
      roleAssignment.roleDefinitionId
    )
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: managedEnvironment
  }
]

resource managedEnvironment_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: managedEnvironment
}

@description('The name of the resource group the Managed Environment was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = managedEnvironment.location

@description('The name of the Managed Environment.')
output name string = managedEnvironment.name

@description('The resource ID of the Managed Environment.')
output resourceId string = managedEnvironment.id

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string = managedEnvironment.?identity.?principalId ?? ''

@description('The Default domain of the Managed Environment.')
output defaultDomain string = managedEnvironment.properties.defaultDomain

@description('The IP address of the Managed Environment.')
output staticIp string = managedEnvironment.properties.staticIp

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

type storageType = {
  @description('Required. Access mode for storage: "ReadOnly" or "ReadWrite".')
  accessMode: ('ReadOnly' | 'ReadWrite')

  @description('Required. Type of storage: "SMB" or "NFS".')
  kind: ('SMB' | 'NFS')

  @description('Required. Storage account name.')
  storageAccountName: string

  @description('Required. File share name.')
  shareName: string
}[]?
