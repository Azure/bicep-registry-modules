metadata name = 'Web/Function Apps'
metadata description = 'This module deploys a Web or Function App.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the site.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Required. Type of site to deploy.')
@allowed([
  'functionapp' // function app windows os
  'functionapp,linux' // function app linux os
  'functionapp,workflowapp' // logic app workflow
  'functionapp,workflowapp,linux' // logic app docker container
  'functionapp,linux,container' // function app linux container
  'functionapp,linux,container,azurecontainerapps' // function app linux container azure container apps
  'app,linux' // linux web app
  'app' // windows web app
  'linux,api' // linux api app
  'api' // windows api app
  'app,linux,container' // linux container app
  'app,container,windows' // windows container app
])
param kind string

@description('Required. The resource ID of the app service plan to use for the site.')
param serverFarmResourceId string

@description('Optional. Azure Resource Manager ID of the customers selected Managed Environment on which to host this app.')
param managedEnvironmentId string?

@description('Optional. Configures a site to accept only HTTPS requests. Issues redirect for HTTP requests.')
param httpsOnly bool = true

@description('Optional. If client affinity is enabled.')
param clientAffinityEnabled bool = true

@description('Optional. The resource ID of the app service environment to use for this resource.')
param appServiceEnvironmentResourceId string?

@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentitiesType

@description('Optional. The resource ID of the assigned identity to be used to access a key vault with.')
param keyVaultAccessIdentityResourceId string?

@description('Optional. Checks if Customer provided storage account is required.')
param storageAccountRequired bool = false

@description('Optional. Azure Resource Manager ID of the Virtual network and subnet to be joined by Regional VNET Integration. This must be of the form /subscriptions/{subscriptionName}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{vnetName}/subnets/{subnetName}.')
param virtualNetworkSubnetId string?

@description('Optional. To enable accessing content over virtual network.')
param vnetContentShareEnabled bool = false

@description('Optional. To enable pulling image over Virtual Network.')
param vnetImagePullEnabled bool = false

@description('Optional. Virtual Network Route All enabled. This causes all outbound traffic to have Virtual Network Security Groups and User Defined Routes applied.')
param vnetRouteAllEnabled bool = false

@description('Optional. Stop SCM (KUDU) site when the app is stopped.')
param scmSiteAlsoStopped bool = false

@description('Optional. The site config object.')
param siteConfig object = {
  alwaysOn: true
}

@description('Optional. Required if app of kind functionapp. Resource ID of the storage account to manage triggers and logging function executions.')
param storageAccountResourceId string?

@description('Optional. If the provided storage account requires Identity based authentication (\'allowSharedKeyAccess\' is set to false). When set to true, the minimum role assignment required for the App Service Managed Identity to the storage account is \'Storage Blob Data Owner\'.')
param storageAccountUseIdentityAuthentication bool = false

@description('Optional. The web settings api management configuration.')
param apiManagementConfiguration object?

@description('Optional. The extension MSDeployment configuration.')
param msDeployConfiguration object?

@description('Optional. Resource ID of the app insight to leverage for this resource.')
param appInsightResourceId string?

@description('Optional. The app settings-value pairs except for AzureWebJobsStorage, AzureWebJobsDashboard, APPINSIGHTS_INSTRUMENTATIONKEY and APPLICATIONINSIGHTS_CONNECTION_STRING.')
param appSettingsKeyValuePairs object?

@description('Optional. The auth settings V2 configuration.')
param authSettingV2Configuration object?

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. The logs settings configuration.')
param logsConfiguration object?

@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointType

@description('Optional. Configuration for deployment slots for an app.')
param slots array?

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingType

@description('Optional. To enable client certificate authentication (TLS mutual authentication).')
param clientCertEnabled bool = false

@description('Optional. Client certificate authentication comma-separated exclusion paths.')
param clientCertExclusionPaths string?

@description('''
Optional. This composes with ClientCertEnabled setting.
- ClientCertEnabled=false means ClientCert is ignored.
- ClientCertEnabled=true and ClientCertMode=Required means ClientCert is required.
- ClientCertEnabled=true and ClientCertMode=Optional means ClientCert is optional or accepted.
''')
@allowed([
  'Optional'
  'OptionalInteractiveUser'
  'Required'
])
param clientCertMode string = 'Optional'

@description('Optional. If specified during app creation, the app is cloned from a source app.')
param cloningInfo object?

@description('Optional. Size of the function container.')
param containerSize int?

@description('Optional. Maximum allowed daily memory-time quota (applicable on dynamic apps only).')
param dailyMemoryTimeQuota int?

@description('Optional. Setting this value to false disables the app (takes the app offline).')
param enabled bool = true

@description('Optional. Hostname SSL states are used to manage the SSL bindings for app\'s hostnames.')
param hostNameSslStates array?

@description('Optional. Hyper-V sandbox.')
param hyperV bool = false

@description('Optional. Site redundancy mode.')
@allowed([
  'ActiveActive'
  'Failover'
  'GeoRedundant'
  'Manual'
  'None'
])
param redundancyMode string = 'None'

@description('Optional. The site publishing credential policy names which are associated with the sites.')
param basicPublishingCredentialsPolicies array?

@description('Optional. Names of hybrid connection relays to connect app with.')
param hybridConnectionRelays array?

@description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string?

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'SystemAssigned, UserAssigned' : 'SystemAssigned')
        : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : 'None')
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

var builtInRoleNames = {
  'App Compliance Automation Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '0f37683f-2463-46b6-9ce7-9b788b988ba2'
  )
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
  'Web Plan Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '2cc479cb-7b4d-49a8-b449-8c00fd0f0a4b'
  )
  'Website Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'de139f84-1756-47ae-9be6-808fbbe84772'
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
  name: '46d3xbcp.res.web-site.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource app 'Microsoft.Web/sites@2022-09-01' = {
  name: name
  location: location
  kind: kind
  tags: tags
  identity: identity
  properties: {
    managedEnvironmentId: !empty(managedEnvironmentId) ? managedEnvironmentId : null
    serverFarmId: serverFarmResourceId
    clientAffinityEnabled: clientAffinityEnabled
    httpsOnly: httpsOnly
    hostingEnvironmentProfile: !empty(appServiceEnvironmentResourceId)
      ? {
          id: appServiceEnvironmentResourceId
        }
      : null
    storageAccountRequired: storageAccountRequired
    keyVaultReferenceIdentity: keyVaultAccessIdentityResourceId
    virtualNetworkSubnetId: virtualNetworkSubnetId
    siteConfig: siteConfig
    clientCertEnabled: clientCertEnabled
    clientCertExclusionPaths: clientCertExclusionPaths
    clientCertMode: clientCertMode
    cloningInfo: cloningInfo
    containerSize: containerSize
    dailyMemoryTimeQuota: dailyMemoryTimeQuota
    enabled: enabled
    hostNameSslStates: hostNameSslStates
    hyperV: hyperV
    redundancyMode: redundancyMode
    publicNetworkAccess: !empty(publicNetworkAccess)
      ? any(publicNetworkAccess)
      : (!empty(privateEndpoints) ? 'Disabled' : 'Enabled')
    vnetContentShareEnabled: vnetContentShareEnabled
    vnetImagePullEnabled: vnetImagePullEnabled
    vnetRouteAllEnabled: vnetRouteAllEnabled
    scmSiteAlsoStopped: scmSiteAlsoStopped
  }
}

module app_appsettings 'config--appsettings/main.bicep' = if (!empty(appSettingsKeyValuePairs) || !empty(appInsightResourceId) || !empty(storageAccountResourceId)) {
  name: '${uniqueString(deployment().name, location)}-Site-Config-AppSettings'
  params: {
    appName: app.name
    kind: kind
    storageAccountResourceId: storageAccountResourceId
    storageAccountUseIdentityAuthentication: storageAccountUseIdentityAuthentication
    appInsightResourceId: appInsightResourceId
    appSettingsKeyValuePairs: appSettingsKeyValuePairs
  }
}

module app_authsettingsv2 'config--authsettingsv2/main.bicep' = if (!empty(authSettingV2Configuration)) {
  name: '${uniqueString(deployment().name, location)}-Site-Config-AuthSettingsV2'
  params: {
    appName: app.name
    kind: kind
    authSettingV2Configuration: authSettingV2Configuration ?? {}
  }
}

module app_logssettings 'config--logs/main.bicep' = if (!empty(logsConfiguration ?? {})) {
  name: '${uniqueString(deployment().name, location)}-Site-Config-Logs'
  params: {
    appName: app.name
    logsConfiguration: logsConfiguration
  }
  dependsOn: [
    app_appsettings
  ]
}

module app_websettings 'config--web/main.bicep' = if (!empty(apiManagementConfiguration ?? {})) {
  name: '${uniqueString(deployment().name, location)}-Site-Config-Web'
  params: {
    appName: app.name
    apiManagementConfiguration: apiManagementConfiguration
  }
}

module extension_msdeploy 'extensions--msdeploy/main.bicep' = if (!empty(msDeployConfiguration)) {
  name: '${uniqueString(deployment().name, location)}-Site-Extension-MSDeploy'
  params: {
    appName: app.name
    msDeployConfiguration: msDeployConfiguration ?? {}
  }
}

@batchSize(1)
module app_slots 'slot/main.bicep' = [
  for (slot, index) in (slots ?? []): {
    name: '${uniqueString(deployment().name, location)}-Slot-${slot.name}'
    params: {
      name: slot.name
      appName: app.name
      location: location
      kind: kind
      serverFarmResourceId: serverFarmResourceId
      httpsOnly: slot.?httpsOnly ?? httpsOnly
      appServiceEnvironmentResourceId: appServiceEnvironmentResourceId
      clientAffinityEnabled: slot.?clientAffinityEnabled ?? clientAffinityEnabled
      managedIdentities: slot.?managedIdentities ?? managedIdentities
      keyVaultAccessIdentityResourceId: slot.?keyVaultAccessIdentityResourceId ?? keyVaultAccessIdentityResourceId
      storageAccountRequired: slot.?storageAccountRequired ?? storageAccountRequired
      virtualNetworkSubnetId: slot.?virtualNetworkSubnetId ?? virtualNetworkSubnetId
      siteConfig: slot.?siteConfig ?? siteConfig
      storageAccountResourceId: slot.?storageAccountResourceId ?? storageAccountResourceId
      storageAccountUseIdentityAuthentication: slot.?storageAccountUseIdentityAuthentication ?? storageAccountUseIdentityAuthentication
      appInsightResourceId: slot.?appInsightResourceId ?? appInsightResourceId
      authSettingV2Configuration: slot.?authSettingV2Configuration ?? authSettingV2Configuration
      msDeployConfiguration: slot.?msDeployConfiguration ?? msDeployConfiguration
      diagnosticSettings: slot.?diagnosticSettings
      roleAssignments: slot.?roleAssignments
      appSettingsKeyValuePairs: slot.?appSettingsKeyValuePairs ?? appSettingsKeyValuePairs
      basicPublishingCredentialsPolicies: slot.?basicPublishingCredentialsPolicies ?? basicPublishingCredentialsPolicies
      lock: slot.?lock ?? lock
      privateEndpoints: slot.?privateEndpoints ?? []
      tags: slot.?tags ?? tags
      clientCertEnabled: slot.?clientCertEnabled
      clientCertExclusionPaths: slot.?clientCertExclusionPaths
      clientCertMode: slot.?clientCertMode
      cloningInfo: slot.?cloningInfo
      containerSize: slot.?containerSize
      customDomainVerificationId: slot.?customDomainVerificationId
      dailyMemoryTimeQuota: slot.?dailyMemoryTimeQuota
      enabled: slot.?enabled
      enableTelemetry: slot.?enableTelemetry ?? enableTelemetry
      hostNameSslStates: slot.?hostNameSslStates
      hyperV: slot.?hyperV
      publicNetworkAccess: slot.?publicNetworkAccess ?? ((!empty(slot.?privateEndpoints) || !empty(privateEndpoints))
        ? 'Disabled'
        : 'Enabled')
      redundancyMode: slot.?redundancyMode
      vnetContentShareEnabled: slot.?vnetContentShareEnabled
      vnetImagePullEnabled: slot.?vnetImagePullEnabled
      vnetRouteAllEnabled: slot.?vnetRouteAllEnabled
      hybridConnectionRelays: slot.?hybridConnectionRelays
    }
  }
]

module app_basicPublishingCredentialsPolicies 'basic-publishing-credentials-policy/main.bicep' = [
  for (basicPublishingCredentialsPolicy, index) in (basicPublishingCredentialsPolicies ?? []): {
    name: '${uniqueString(deployment().name, location)}-Site-Publish-Cred-${index}'
    params: {
      webAppName: app.name
      name: basicPublishingCredentialsPolicy.name
      allow: basicPublishingCredentialsPolicy.?allow
      location: location
    }
  }
]

module app_hybridConnectionRelays 'hybrid-connection-namespace/relay/main.bicep' = [
  for (hybridConnectionRelay, index) in (hybridConnectionRelays ?? []): {
    name: '${uniqueString(deployment().name, location)}-HybridConnectionRelay-${index}'
    params: {
      hybridConnectionResourceId: hybridConnectionRelay.resourceId
      appName: app.name
      sendKeyName: hybridConnectionRelay.?sendKeyName
    }
  }
]

resource app_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: app
}

resource app_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for (diagnosticSetting, index) in (diagnosticSettings ?? []): {
    name: diagnosticSetting.?name ?? '${name}-diagnosticSettings'
    properties: {
      storageAccountId: diagnosticSetting.?storageAccountResourceId
      workspaceId: diagnosticSetting.?workspaceResourceId
      eventHubAuthorizationRuleId: diagnosticSetting.?eventHubAuthorizationRuleResourceId
      eventHubName: diagnosticSetting.?eventHubName
      metrics: [
        for group in (diagnosticSetting.?metricCategories ?? [{ category: 'AllMetrics' }]): {
          category: group.category
          enabled: group.?enabled ?? true
          timeGrain: null
        }
      ]
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
    scope: app
  }
]

resource app_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(app.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: app
  }
]

module app_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.7.1' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-app-PrivateEndpoint-${index}'
    scope: resourceGroup(privateEndpoint.?resourceGroupName ?? '')
    params: {
      name: privateEndpoint.?name ?? 'pep-${last(split(app.id, '/'))}-${privateEndpoint.?service ?? 'sites'}-${index}'
      privateLinkServiceConnections: privateEndpoint.?isManualConnection != true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(app.id, '/'))}-${privateEndpoint.?service ?? 'sites'}-${index}'
              properties: {
                privateLinkServiceId: app.id
                groupIds: [
                  privateEndpoint.?service ?? 'sites'
                ]
              }
            }
          ]
        : null
      manualPrivateLinkServiceConnections: privateEndpoint.?isManualConnection == true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(app.id, '/'))}-${privateEndpoint.?service ?? 'sites'}-${index}'
              properties: {
                privateLinkServiceId: app.id
                groupIds: [
                  privateEndpoint.?service ?? 'sites'
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

@description('The name of the site.')
output name string = app.name

@description('The resource ID of the site.')
output resourceId string = app.id

@description('The list of the slots.')
output slots array = [for (slot, index) in (slots ?? []): app_slots[index].name]

@description('The list of the slot resource ids.')
output slotResourceIds array = [for (slot, index) in (slots ?? []): app_slots[index].outputs.resourceId]

@description('The resource group the site was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string = app.?identity.?principalId ?? ''

@description('The principal ID of the system assigned identity of slots.')
output slotSystemAssignedMIPrincipalIds array = [
  for (slot, index) in (slots ?? []): app_slots[index].outputs.systemAssignedMIPrincipalId
]

@description('The location the resource was deployed into.')
output location string = app.location

@description('Default hostname of the app.')
output defaultHostname string = app.properties.defaultHostName

@description('Unique identifier that verifies the custom domains assigned to the app. Customer will add this ID to a txt record for verification.')
output customDomainVerificationId string = app.properties.customDomainVerificationId

@description('The private endpoints of the site.')
output privateEndpoints array = [
  for (pe, i) in (!empty(privateEndpoints) ? array(privateEndpoints) : []): {
    name: app_privateEndpoints[i].outputs.name
    resourceId: app_privateEndpoints[i].outputs.resourceId
    groupId: app_privateEndpoints[i].outputs.groupId
    customDnsConfig: app_privateEndpoints[i].outputs.customDnsConfig
    networkInterfaceIds: app_privateEndpoints[i].outputs.networkInterfaceIds
  }
]

@description('The private endpoints of the slots.')
output slotPrivateEndpoints array = [for (slot, index) in (slots ?? []): app_slots[index].outputs.privateEndpoints]

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

  @description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.')
  logCategoriesAndGroups: {
    @description('Optional. Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.')
    category: string?

    @description('Optional. Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.')
    categoryGroup: string?

    @description('Optional. Enable or disable the category explicitly. Default is `true`.')
    enabled: bool?
  }[]?

  @description('Optional. The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.')
  metricCategories: {
    @description('Required. Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.')
    category: string

    @description('Optional. Enable or disable the category explicitly. Default is `true`.')
    enabled: bool?
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
