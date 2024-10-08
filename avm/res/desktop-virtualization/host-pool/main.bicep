metadata name = 'Azure Virtual Desktop Host Pool'
metadata description = 'This module deploys an Azure Virtual Desktop Host Pool'
metadata owner = 'Azure/module-maintainers'

@sys.description('Required. Name of the scaling plan.')
param name string

@sys.description('Optional. Location of the scaling plan. Defaults to resource group location.')
param location string = resourceGroup().location

@sys.description('Optional. Friendly name of the scaling plan.')
param friendlyName string = ''

@sys.description('Optional. Description of the scaling plan.')
param description string = ''

@sys.description('Optional. Set this parameter to Personal if you would like to enable Persistent Desktop experience. Defaults to Pooled.')
@allowed([
  'Personal'
  'Pooled'
])
param hostPoolType string = 'Pooled'

@sys.description('Optional. Set public network access.')
@allowed([
  'Disabled'
  'Enabled'
  'EnabledForClientsOnly'
  'EnabledForSessionHostsOnly'
])
param publicNetworkAccess string = 'Enabled'

@sys.description('Optional. Configuration details for private endpoints.')
param privateEndpoints privateEndpointType

@sys.description('Optional. Set the type of assignment for a Personal Host Pool type.')
@allowed([
  'Automatic'
  'Direct'
  ''
])
param personalDesktopAssignmentType string = ''

@sys.description('Optional. Type of load balancer algorithm.')
@allowed([
  'BreadthFirst'
  'DepthFirst'
  'Persistent'
])
param loadBalancerType string = 'BreadthFirst'

@sys.description('Optional. Maximum number of sessions.')
param maxSessionLimit int = 99999

@sys.description('Optional. Host Pool RDP properties.')
param customRdpProperty string = 'audiocapturemode:i:1;audiomode:i:0;drivestoredirect:s:;redirectclipboard:i:1;redirectcomports:i:1;redirectprinters:i:1;redirectsmartcards:i:1;screen mode id:i:2;'

@sys.description('Optional. Validation host pools allows you to test service changes before they are deployed to production. When set to true, the Host Pool will be deployed in a validation \'ring\' (environment) that receives all the new features (might be less stable). Defaults to false that stands for the stable, production-ready environment.')
param validationEnvironment bool = false

@sys.description('Optional. The necessary information for adding more VMs to this Host Pool.')
param vmTemplate object = {}

@sys.description('Optional. Host Pool token validity length. Usage: \'PT8H\' - valid for 8 hours; \'P5D\' - valid for 5 days; \'P1Y\' - valid for 1 year. When not provided, the token will be valid for 8 hours.')
param tokenValidityLength string = 'PT8H'

@sys.description('Generated. Do not provide a value! This date value is used to generate a registration token.')
param baseTime string = utcNow('u')

@sys.description('Optional. The type of preferred application group type, default to Desktop Application Group.')
@allowed([
  'Desktop'
  'None'
  'RailApplications'
])
param preferredAppGroupType string = 'Desktop'

@sys.description('Optional. Enable Start VM on connect to allow users to start the virtual machine from a deallocated state. Important: Custom RBAC role required to power manage VMs.')
param startVMOnConnect bool = false

@sys.description('Optional. The session host configuration for updating agent, monitoring agent, and stack component.')
param agentUpdate object = {
  type: 'Scheduled'
  useSessionHostLocalTime: true
  maintenanceWindows: [
    {
      dayOfWeek: 'Sunday'
      hour: 12
    }
  ]
}

@sys.description('Optional. The ring number of HostPool.')
param ring int = -1

@sys.description('Optional. URL to customer ADFS server for signing WVD SSO certificates.')
param ssoadfsAuthority string = ''

@sys.description('Optional. ClientId for the registered Relying Party used to issue WVD SSO certificates.')
param ssoClientId string = ''

@sys.description('Optional. Path to Azure KeyVault storing the secret used for communication to ADFS.')
#disable-next-line secure-secrets-in-params
param ssoClientSecretKeyVaultPath string = ''

@sys.description('Optional. The type of single sign on Secret Type.')
@allowed([
  ''
  'Certificate'
  'CertificateInKeyVault'
  'SharedKey'
  'SharedKeyInKeyVault'
])
#disable-next-line secure-secrets-in-params
param ssoSecretType string = ''

@sys.description('Optional. Tags of the resource.')
param tags object?

@sys.description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@sys.description('Optional. The lock settings of the service.')
param lock lockType

@sys.description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@sys.description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingType

var builtInRoleNames = {
  Owner: '/providers/Microsoft.Authorization/roleDefinitions/8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
  Contributor: '/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
  Reader: '/providers/Microsoft.Authorization/roleDefinitions/acdd72a7-3385-48ef-bd42-f606fba81ae7'
  'Role Based Access Control Administrator': '/providers/Microsoft.Authorization/roleDefinitions/f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  'User Access Administrator': '/providers/Microsoft.Authorization/roleDefinitions/18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  'Application Group Contributor': '/providers/Microsoft.Authorization/roleDefinitions/ca6382a4-1721-4bcf-a114-ff0c70227b6b'
  'Desktop Virtualization Application Group Contributor': '/providers/Microsoft.Authorization/roleDefinitions/86240b0e-9422-4c43-887b-b61143f32ba8'
  'Desktop Virtualization Application Group Reader': '/providers/Microsoft.Authorization/roleDefinitions/aebf23d0-b568-4e86-b8f9-fe83a2c6ab55'
  'Desktop Virtualization Contributor': '/providers/Microsoft.Authorization/roleDefinitions/082f0a83-3be5-4ba1-904c-961cca79b387'
  'Desktop Virtualization Host Pool Contributor': '/providers/Microsoft.Authorization/roleDefinitions/e307426c-f9b6-4e81-87de-d99efb3c32bc'
  'Desktop Virtualization Host Pool Reader': '/providers/Microsoft.Authorization/roleDefinitions/ceadfde2-b300-400a-ab7b-6143895aa822'
  'Desktop Virtualization Power On Off Contributor': '/providers/Microsoft.Authorization/roleDefinitions/40c5ff49-9181-41f8-ae61-143b0e78555e'
  'Desktop Virtualization Reader': '/providers/Microsoft.Authorization/roleDefinitions/49a72310-ab8d-41df-bbb0-79b649203868'
  'Desktop Virtualization Session Host Operator': '/providers/Microsoft.Authorization/roleDefinitions/2ad6aaab-ead9-4eaa-8ac5-da422f562408'
  'Desktop Virtualization User': '/providers/Microsoft.Authorization/roleDefinitions/1d18fff3-a72a-46b5-b4a9-0b38a3cd7e63'
  'Desktop Virtualization User Session Operator': '/providers/Microsoft.Authorization/roleDefinitions/ea4bfff8-7fb4-485a-aadd-d4129a0ffaa6'
  'Desktop Virtualization Virtual Machine Contributor': '/providers/Microsoft.Authorization/roleDefinitions/a959dbd1-f747-45e3-8ba6-dd80f235f97c'
  'Desktop Virtualization Workspace Contributor': '/providers/Microsoft.Authorization/roleDefinitions/21efdde3-836f-432b-bf3d-3e8e734d4b2b'
  'Desktop Virtualization Workspace Reader': '/providers/Microsoft.Authorization/roleDefinitions/0fa44ee9-7a7d-466b-9bb2-2bf446b1204d'
  'Managed Application Contributor Role': '/providers/Microsoft.Authorization/roleDefinitions/641177b8-a67a-45b9-a033-47bc880bb21e'
  'Managed Application Operator Role': '/providers/Microsoft.Authorization/roleDefinitions/c7393b34-138c-406f-901b-d8cf2b17e6ae'
  'Managed Applications Reader': '/providers/Microsoft.Authorization/roleDefinitions/b9331d33-8a36-4f8c-b097-4f54124fdb44'
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
  name: take(
    '46d3xbcp.res.desktopvirtualization-hostpool.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}',
    64
  )
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

resource hostPool 'Microsoft.DesktopVirtualization/hostPools@2024-04-03' = {
  name: name
  location: location
  tags: tags
  properties: {
    friendlyName: friendlyName
    description: description
    hostPoolType: hostPoolType
    publicNetworkAccess: publicNetworkAccess
    customRdpProperty: customRdpProperty
    personalDesktopAssignmentType: any(personalDesktopAssignmentType)
    preferredAppGroupType: preferredAppGroupType
    maxSessionLimit: maxSessionLimit
    loadBalancerType: loadBalancerType
    startVMOnConnect: startVMOnConnect
    validationEnvironment: validationEnvironment
    registrationInfo: {
      expirationTime: dateTimeAdd(baseTime, tokenValidityLength)
      token: null
      registrationTokenOperation: 'Update'
    }
    vmTemplate: ((!empty(vmTemplate)) ? null : string(vmTemplate))
    agentUpdate: agentUpdate
    ring: ring != -1 ? ring : null
    ssoadfsAuthority: ssoadfsAuthority
    ssoClientId: ssoClientId
    ssoClientSecretKeyVaultPath: ssoClientSecretKeyVaultPath
    ssoSecretType: ssoSecretType
  }
}

module hostPool_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.7.1' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-hostPool-PrivateEndpoint-${index}'
    scope: resourceGroup(privateEndpoint.?resourceGroupName ?? '')
    params: {
      name: privateEndpoint.?name ?? 'pep-${last(split(hostPool.id, '/'))}-${privateEndpoint.?service ?? 'connection'}-${index}'
      privateLinkServiceConnections: privateEndpoint.?isManualConnection != true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(hostPool.id, '/'))}-${privateEndpoint.?service ?? 'connection'}-${index}'
              properties: {
                privateLinkServiceId: hostPool.id
                groupIds: [
                  privateEndpoint.?service ?? 'connection'
                ]
              }
            }
          ]
        : null
      manualPrivateLinkServiceConnections: privateEndpoint.?isManualConnection == true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(hostPool.id, '/'))}-${privateEndpoint.?service ?? 'connection'}-${index}'
              properties: {
                privateLinkServiceId: hostPool.id
                groupIds: [
                  privateEndpoint.?service ?? 'connection'
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

resource hostPool_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: hostPool
}

resource hostPool_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(hostPool.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: hostPool
  }
]

resource hostPool_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
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
    scope: hostPool
  }
]

@sys.description('The resource ID of the host pool.')
output resourceId string = hostPool.id

@sys.description('The name of the resource group the host pool was created in.')
output resourceGroupName string = resourceGroup().name

@sys.description('The name of the host pool.')
output name string = hostPool.name

@sys.description('The location of the host pool.')
output location string = hostPool.location

@sys.description('The private endpoints of the host pool.')
output privateEndpoints array = [
  for (pe, i) in (!empty(privateEndpoints) ? array(privateEndpoints) : []): {
    name: hostPool_privateEndpoints[i].outputs.name
    resourceId: hostPool_privateEndpoints[i].outputs.resourceId
    groupId: hostPool_privateEndpoints[i].outputs.groupId
    customDnsConfig: hostPool_privateEndpoints[i].outputs.customDnsConfig
    networkInterfaceIds: hostPool_privateEndpoints[i].outputs.networkInterfaceIds
  }
]

// ================ //
// Definitions      //
// ================ //

type diagnosticSettingType = {
  @sys.description('Optional. The name of diagnostic setting.')
  name: string?

  @sys.description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.')
  logCategoriesAndGroups: {
    @sys.description('Optional. Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.')
    category: string?

    @sys.description('Optional. Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.')
    categoryGroup: string?

    @sys.description('Optional. Enable or disable the category explicitly. Default is `true`.')
    enabled: bool?
  }[]?

  @sys.description('Optional. A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.')
  logAnalyticsDestinationType: ('Dedicated' | 'AzureDiagnostics')?

  @sys.description('Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  workspaceResourceId: string?

  @sys.description('Optional. Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  storageAccountResourceId: string?

  @sys.description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
  eventHubAuthorizationRuleResourceId: string?

  @sys.description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  eventHubName: string?

  @sys.description('Optional. The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.')
  marketplacePartnerResourceId: string?
}[]?

type roleAssignmentType = {
  @sys.description('Optional. The name (as GUID) of the role assignment. If not provided, a GUID will be generated.')
  name: string?

  @sys.description('Required. The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
  roleDefinitionIdOrName: string

  @sys.description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
  principalId: string

  @sys.description('Optional. The principal type of the assigned principal ID.')
  principalType: ('ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup' | 'Device')?

  @sys.description('Optional. The description of the role assignment.')
  description: string?

  @sys.description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".')
  condition: string?

  @sys.description('Optional. Version of the condition.')
  conditionVersion: '2.0'?

  @sys.description('Optional. The Resource Id of the delegated managed identity resource.')
  delegatedManagedIdentityResourceId: string?
}[]?

type privateEndpointType = {
  @sys.description('Optional. The name of the private endpoint.')
  name: string?

  @sys.description('Optional. The location to deploy the private endpoint to.')
  location: string?

  @sys.description('Optional. The name of the private link connection to create.')
  privateLinkServiceConnectionName: string?

  @sys.description('Optional. The subresource to deploy the private endpoint for. For example "vault", "mysqlServer" or "dataFactory".')
  service: string?

  @sys.description('Required. Resource ID of the subnet where the endpoint needs to be created.')
  subnetResourceId: string

  @sys.description('Optional. The private DNS zone group to configure for the private endpoint.')
  privateDnsZoneGroup: {
    @sys.description('Optional. The name of the Private DNS Zone Group.')
    name: string?

    @sys.description('Required. The private DNS zone groups to associate the private endpoint. A DNS zone group can support up to 5 DNS zones.')
    privateDnsZoneGroupConfigs: {
      @sys.description('Optional. The name of the private DNS zone group config.')
      name: string?

      @sys.description('Required. The resource id of the private DNS zone.')
      privateDnsZoneResourceId: string
    }[]
  }?

  @sys.description('Optional. If Manual Private Link Connection is required.')
  isManualConnection: bool?

  @sys.description('Optional. A message passed to the owner of the remote resource with the manual connection request.')
  @maxLength(140)
  manualConnectionRequestMessage: string?

  @sys.description('Optional. Custom DNS configurations.')
  customDnsConfigs: {
    @sys.description('Required. Fqdn that resolves to private endpoint IP address.')
    fqdn: string?

    @sys.description('Required. A list of private IP addresses of the private endpoint.')
    ipAddresses: string[]
  }[]?

  @sys.description('Optional. A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints.')
  ipConfigurations: {
    @sys.description('Required. The name of the resource that is unique within a resource group.')
    name: string

    @sys.description('Required. Properties of private endpoint IP configurations.')
    properties: {
      @sys.description('Required. The ID of a group obtained from the remote resource that this private endpoint should connect to.')
      groupId: string

      @sys.description('Required. The member name of a group obtained from the remote resource that this private endpoint should connect to.')
      memberName: string

      @sys.description('Required. A private IP address obtained from the private endpoint\'s subnet.')
      privateIPAddress: string
    }
  }[]?

  @sys.description('Optional. Application security groups in which the private endpoint IP configuration is included.')
  applicationSecurityGroupResourceIds: string[]?

  @sys.description('Optional. The custom name of the network interface attached to the private endpoint.')
  customNetworkInterfaceName: string?

  @sys.description('Optional. Specify the type of lock.')
  lock: lockType

  @sys.description('Optional. Array of role assignments to create.')
  roleAssignments: roleAssignmentType

  @sys.description('Optional. Tags to be applied on all resources/resource groups in this deployment.')
  tags: object?

  @sys.description('Optional. Enable/Disable usage telemetry for module.')
  enableTelemetry: bool?

  @sys.description('Optional. Specify if you want to deploy the Private Endpoint into a different resource group than the main resource.')
  resourceGroupName: string?
}[]?

type lockType = {
  @sys.description('Optional. Specify the name of lock.')
  name: string?

  @sys.description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?
