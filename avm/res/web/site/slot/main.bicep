metadata name = 'Web/Function App Deployment Slots'
metadata description = 'This module deploys a Web or Function App Deployment Slot.'

@description('Required. Name of the slot.')
param name string

@description('Conditional. The name of the parent site resource. Required if the template is used in a standalone deployment.')
param appName string

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

@description('Optional. The resource ID of the app service plan to use for the slot.')
param serverFarmResourceId string?

@description('Optional. Configures a slot to accept only HTTPS requests. Issues redirect for HTTP requests.')
param httpsOnly bool = true

@description('Optional. If client affinity is enabled.')
param clientAffinityEnabled bool = true

@description('Optional. The resource ID of the app service environment to use for this resource.')
param appServiceEnvironmentResourceId string?

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

@description('Optional. The resource ID of the assigned identity to be used to access a key vault with.')
param keyVaultAccessIdentityResourceId string?

@description('Optional. Checks if Customer provided storage account is required.')
param storageAccountRequired bool = false

@description('Optional. Azure Resource Manager ID of the Virtual network and subnet to be joined by Regional VNET Integration. This must be of the form /subscriptions/{subscriptionName}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{vnetName}/subnets/{subnetName}.')
param virtualNetworkSubnetId string?

@description('Optional. The site config object.')
param siteConfig object = {
  alwaysOn: true
}

@description('Optional. The Function App config object.')
param functionAppConfig object?

@description('Optional. Required if app of kind functionapp. Resource ID of the storage account to manage triggers and logging function executions.')
param storageAccountResourceId string?

@description('Optional. If the provided storage account requires Identity based authentication (\'allowSharedKeyAccess\' is set to false). When set to true, the minimum role assignment required for the App Service Managed Identity to the storage account is \'Storage Blob Data Owner\'.')
param storageAccountUseIdentityAuthentication bool = false

@description('Optional. Resource ID of the app insight to leverage for this resource.')
param appInsightResourceId string?

@description('Optional. The app settings-value pairs except for AzureWebJobsStorage, AzureWebJobsDashboard, APPINSIGHTS_INSTRUMENTATIONKEY and APPLICATIONINSIGHTS_CONNECTION_STRING.')
param appSettingsKeyValuePairs object?

@description('Optional. The auth settings V2 configuration.')
param authSettingV2Configuration object?

@description('Optional. The extension MSDeployment configuration.')
param msDeployConfiguration object?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { privateEndpointSingleServiceType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Configuration details for private endpoints.')
param privateEndpoints privateEndpointSingleServiceType[]?

@description('Optional. Tags of the resource.')
param tags object?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

@description('Optional. To enable client certificate authentication (TLS mutual authentication).')
param clientCertEnabled bool = false

@description('Optional. Client certificate authentication comma-separated exclusion paths.')
param clientCertExclusionPaths string?

@description('Optional. This composes with ClientCertEnabled setting.</p>- ClientCertEnabled: false means ClientCert is ignored.</p>- ClientCertEnabled: true and ClientCertMode: Required means ClientCert is required.</p>- ClientCertEnabled: true and ClientCertMode: Optional means ClientCert is optional or accepted.')
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

@description('Optional. Unique identifier that verifies the custom domains assigned to the app. Customer will add this ID to a txt record for verification.')
param customDomainVerificationId string?

@description('Optional. Maximum allowed daily memory-time quota (applicable on dynamic apps only).')
param dailyMemoryTimeQuota int?

@description('Optional. Setting this value to false disables the app (takes the app offline).')
param enabled bool = true

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Hostname SSL states are used to manage the SSL bindings for app\'s hostnames.')
param hostNameSslStates array?

@description('Optional. Hyper-V sandbox.')
param hyperV bool = false

@description('Optional. Allow or block all public traffic.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string?

@description('Optional. Site redundancy mode.')
@allowed([
  'ActiveActive'
  'Failover'
  'GeoRedundant'
  'Manual'
  'None'
])
param redundancyMode string = 'None'

@description('Optional. The site publishing credential policy names which are associated with the site slot.')
param basicPublishingCredentialsPolicies array?

@description('Optional. To enable accessing content over virtual network.')
param vnetContentShareEnabled bool = false

@description('Optional. To enable pulling image over Virtual Network.')
param vnetImagePullEnabled bool = false

@description('Optional. Virtual Network Route All enabled. This causes all outbound traffic to have Virtual Network Security Groups and User Defined Routes applied.')
param vnetRouteAllEnabled bool = false

@description('Optional. Names of hybrid connection relays to connect app with.')
param hybridConnectionRelays array?

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'SystemAssigned, UserAssigned' : 'SystemAssigned')
        : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : null)
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

resource app 'Microsoft.Web/sites@2024-04-01' existing = {
  name: appName
}

resource slot 'Microsoft.Web/sites/slots@2024-04-01' = {
  name: name
  parent: app
  location: location
  kind: kind
  tags: tags
  identity: identity
  properties: {
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
    functionAppConfig: functionAppConfig
    clientCertEnabled: clientCertEnabled
    clientCertExclusionPaths: clientCertExclusionPaths
    clientCertMode: clientCertMode
    cloningInfo: cloningInfo
    containerSize: containerSize
    customDomainVerificationId: customDomainVerificationId
    dailyMemoryTimeQuota: dailyMemoryTimeQuota
    enabled: enabled
    hostNameSslStates: hostNameSslStates
    hyperV: hyperV
    publicNetworkAccess: publicNetworkAccess
    redundancyMode: redundancyMode
    vnetContentShareEnabled: vnetContentShareEnabled
    vnetImagePullEnabled: vnetImagePullEnabled
    vnetRouteAllEnabled: vnetRouteAllEnabled
  }
}

module slot_appsettings 'config--appsettings/main.bicep' = if (!empty(appSettingsKeyValuePairs) || !empty(appInsightResourceId) || !empty(storageAccountResourceId)) {
  name: '${uniqueString(deployment().name, location)}-Slot-${name}-Config-AppSettings'
  params: {
    slotName: slot.name
    appName: app.name
    kind: kind
    storageAccountResourceId: storageAccountResourceId
    storageAccountUseIdentityAuthentication: storageAccountUseIdentityAuthentication
    appInsightResourceId: appInsightResourceId
    appSettingsKeyValuePairs: appSettingsKeyValuePairs
    currentAppSettings: !empty(slot.id) ? list('${slot.id}/config/appsettings', '2023-12-01').properties : {}
  }
}

module slot_authsettingsv2 'config--authsettingsv2/main.bicep' = if (!empty(authSettingV2Configuration)) {
  name: '${uniqueString(deployment().name, location)}-Slot-${name}-Config-AuthSettingsV2'
  params: {
    slotName: slot.name
    appName: app.name
    kind: kind
    authSettingV2Configuration: authSettingV2Configuration ?? {}
  }
}

module slot_basicPublishingCredentialsPolicies 'basic-publishing-credentials-policy/main.bicep' = [
  for (basicPublishingCredentialsPolicy, index) in (basicPublishingCredentialsPolicies ?? []): {
    name: '${uniqueString(deployment().name, location)}-Slot-Publish-Cred-${index}'
    params: {
      appName: app.name
      slotName: slot.name
      name: basicPublishingCredentialsPolicy.name
      allow: basicPublishingCredentialsPolicy.?allow
      location: location
    }
  }
]
module slot_hybridConnectionRelays 'hybrid-connection-namespace/relay/main.bicep' = [
  for (hybridConnectionRelay, index) in (hybridConnectionRelays ?? []): {
    name: '${uniqueString(deployment().name, location)}-Slot-HybridConnectionRelay-${index}'
    params: {
      hybridConnectionResourceId: hybridConnectionRelay.resourceId
      appName: app.name
      slotName: slot.name
      sendKeyName: hybridConnectionRelay.?sendKeyName
    }
  }
]

module slot_extensionMSdeploy 'extensions--msdeploy/main.bicep' = if (!empty(msDeployConfiguration)) {
  name: '${uniqueString(deployment().name, location)}-Site-Extension-MSDeploy'
  params: {
    appName: app.name
    msDeployConfiguration: msDeployConfiguration ?? {}
  }
}

resource slot_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: slot
}

resource slot_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
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
    scope: slot
  }
]

resource slot_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(slot.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: slot
  }
]

module slot_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.7.1' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-slot-PrivateEndpoint-${index}'
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
      name: privateEndpoint.?name ?? 'pep-${last(split(app.id, '/'))}-${privateEndpoint.?service ?? 'sites-${slot.name}'}-${index}'
      privateLinkServiceConnections: privateEndpoint.?isManualConnection != true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(app.id, '/'))}-${privateEndpoint.?service ?? 'sites-${slot.name}'}-${index}'
              properties: {
                privateLinkServiceId: app.id // Must be set on the WebApp and not the slot
                groupIds: [
                  privateEndpoint.?service ?? 'sites-${slot.name}' // The required syntax to create the private endpoint for a specific slot
                ]
              }
            }
          ]
        : null
      manualPrivateLinkServiceConnections: privateEndpoint.?isManualConnection == true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(app.id, '/'))}-${privateEndpoint.?service ?? 'sites-${slot.name}'}-${index}'
              properties: {
                privateLinkServiceId: app.id // Must be set on the WebApp and not the slot
                groupIds: [
                  privateEndpoint.?service ?? 'sites-${slot.name}' // The required syntax to create the private endpoint for a specific slot
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

@description('The name of the slot.')
output name string = slot.name

@description('The resource ID of the slot.')
output resourceId string = slot.id

@description('The resource group the slot was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string? = slot.?identity.?principalId

@description('The location the resource was deployed into.')
output location string = slot.location

@description('The private endpoints of the slot.')
output privateEndpoints array = [
  for (pe, i) in (!empty(privateEndpoints) ? array(privateEndpoints) : []): {
    name: slot_privateEndpoints[i].outputs.name
    resourceId: slot_privateEndpoints[i].outputs.resourceId
    groupId: slot_privateEndpoints[i].outputs.groupId
    customDnsConfig: slot_privateEndpoints[i].outputs.customDnsConfig
    networkInterfaceIds: slot_privateEndpoints[i].outputs.networkInterfaceIds
  }
]
