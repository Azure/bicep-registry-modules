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
param siteConfig resourceInput<'Microsoft.Web/sites/slots@2024-04-01'>.properties.siteConfig = {
  alwaysOn: true
}

@description('Optional. The Function App config object.')
param functionAppConfig object?

@description('Optional. The web site config.')
param configs configType[]?

@description('Optional. The extensions configuration.')
param extensions object[]?

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

@description('Optional. Hostname SSL states are used to manage the SSL bindings for app\'s hostnames.')
param hostNameSslStates resourceInput<'Microsoft.Web/sites/slots@2024-04-01'>.properties.hostNameSslStates?

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
param basicPublishingCredentialsPolicies basicPublishingCredentialsPolicyType[]?

@description('Optional. To enable accessing content over virtual network.')
param vnetContentShareEnabled bool = false

@description('Optional. To enable pulling image over Virtual Network.')
param vnetImagePullEnabled bool = false

@description('Optional. Virtual Network Route All enabled. This causes all outbound traffic to have Virtual Network Security Groups and User Defined Routes applied.')
param vnetRouteAllEnabled bool = false

@description('Optional. Names of hybrid connection relays to connect app with.')
param hybridConnectionRelays hybridConnectionRelayType[]?

@description('Optional. Property to configure various DNS related settings for a site.')
param dnsConfiguration resourceInput<'Microsoft.Web/sites/slots@2024-04-01'>.properties.dnsConfiguration?

@description('Optional. Specifies the scope of uniqueness for the default hostname during resource creation.')
@allowed([
  'NoReuse'
  'ResourceGroupReuse'
  'SubscriptionReuse'
  'TenantReuse'
])
param autoGeneratedDomainNameLabelScope string?

var enableReferencedModulesTelemetry = false

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
    dnsConfiguration: dnsConfiguration
    autoGeneratedDomainNameLabelScope: autoGeneratedDomainNameLabelScope
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
      hybridConnectionResourceId: hybridConnectionRelay.hybridConnectionResourceId
      appName: app.name
      slotName: slot.name
      sendKeyName: hybridConnectionRelay.?sendKeyName
    }
  }
]

module slot_config 'config/main.bicep' = [
  for (config, index) in (configs ?? []): {
    name: '${uniqueString(deployment().name, location)}-Slot-Config-${index}'
    params: {
      appName: app.name
      name: config.name
      slotName: slot.name
      applicationInsightResourceId: config.?applicationInsightResourceId
      properties: config.?properties
      currentAppSettings: config.?retainCurrentAppSettings ?? true && config.name == 'appsettings'
        ? list('${slot.id}/config/appsettings', '2023-12-01').properties
        : {}
      storageAccountResourceId: config.?storageAccountResourceId
      storageAccountUseIdentityAuthentication: config.?storageAccountUseIdentityAuthentication
    }
  }
]

module app_extensions 'extension/main.bicep' = [
  for (extension, index) in (extensions ?? []): {
    name: '${uniqueString(deployment().name, location)}-Slot-Extension=${index}'
    params: {
      appName: app.name
      slotName: slot.name
      name: extension.?name
      kind: extension.?kind
      properties: extension.properties
    }
  }
]

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

module slot_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.11.0' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-slot-PrivateEndpoint-${index}'
    scope: resourceGroup(
      split(privateEndpoint.?resourceGroupResourceId ?? resourceGroup().id, '/')[2],
      split(privateEndpoint.?resourceGroupResourceId ?? resourceGroup().id, '/')[4]
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
output privateEndpoints privateEndpointOutputType[] = [
  for (item, index) in (privateEndpoints ?? []): {
    name: slot_privateEndpoints[index].outputs.name
    resourceId: slot_privateEndpoints[index].outputs.resourceId
    groupId: slot_privateEndpoints[index].outputs.?groupId!
    customDnsConfigs: slot_privateEndpoints[index].outputs.customDnsConfigs
    networkInterfaceResourceIds: slot_privateEndpoints[index].outputs.networkInterfaceResourceIds
  }
]

// ================ //
// Definitions      //
// ================ //
@export()
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
@description('The type of a site configuration.')
@discriminator('name')
type configType =
  | appSettingsConfigType
  | authSettingsConfigType
  | authSettingsV2ConfigType
  | azureStorageAccountConfigType
  | backupConfigType
  | connectionStringsConfigType
  | logsConfigType
  | metadataConfigType
  | pushSettingsConfigType
  | webConfigType

@export()
@description('The type of an app settings configuration.')
type appSettingsConfigType = {
  @description('Required. The type of config.')
  name: 'appsettings'

  @description('Optional. If the provided storage account requires Identity based authentication (\'allowSharedKeyAccess\' is set to false). When set to true, the minimum role assignment required for the App Service Managed Identity to the storage account is \'Storage Blob Data Owner\'.')
  storageAccountUseIdentityAuthentication: bool?

  @description('Optional. Required if app of kind functionapp. Resource ID of the storage account to manage triggers and logging function executions.')
  storageAccountResourceId: string?

  @description('Optional. Resource ID of the application insight to leverage for this resource.')
  applicationInsightResourceId: string?

  @description('Optional. The retain the current app settings. Defaults to true.')
  retainCurrentAppSettings: bool?

  @description('Optional. The app settings key-value pairs except for AzureWebJobsStorage, AzureWebJobsDashboard, APPINSIGHTS_INSTRUMENTATIONKEY and APPLICATIONINSIGHTS_CONNECTION_STRING.')
  properties: {
    @description('Required. An app settings key-value pair.')
    *: string
  }?
}

@export()
@description('The type of an auth settings configuration.')
type authSettingsConfigType = {
  @description('Required. The type of config.')
  name: 'authsettings'

  @description('Required. The config settings.')
  properties: {
    @description('Optional. Gets a JSON string containing the Azure AD Acl settings.')
    aadClaimsAuthorization: string?

    @description('Optional. Login parameters to send to the OpenID Connect authorization endpoint when a user logs in. Each parameter must be in the form "key=value".')
    additionalLoginParams: string[]?

    @description('Optional. Allowed audience values to consider when validating JSON Web Tokens issued by Azure Active Directory. Note that the `ClientID` value is always considered an allowed audience, regardless of this setting.')
    allowedAudiences: string[]?

    @description('Optional. External URLs that can be redirected to as part of logging in or logging out of the app. Note that the query string part of the URL is ignored. This is an advanced setting typically only needed by Windows Store application backends. Note that URLs within the current domain are always implicitly allowed.')
    allowedExternalRedirectUrls: string[]?

    @description('Optional. The path of the config file containing auth settings. If the path is relative, base will the site\'s root directory.')
    authFilePath: string?

    @description('Optional. The Client ID of this relying party application, known as the client_id. This setting is required for enabling OpenID Connection authentication with Azure Active Directory or other 3rd party OpenID Connect providers. More information on [OpenID Connect](http://openid.net/specs/openid-connect-core-1_0.html).')
    clientId: string?

    @description('Optional. The Client Secret of this relying party application (in Azure Active Directory, this is also referred to as the Key). This setting is optional. If no client secret is configured, the OpenID Connect implicit auth flow is used to authenticate end users. Otherwise, the OpenID Connect Authorization Code Flow is used to authenticate end users. More information on [OpenID Connect](http://openid.net/specs/openid-connect-core-1_0.html).')
    @secure()
    clientSecret: string?

    @description('Optional. An alternative to the client secret, that is the thumbprint of a certificate used for signing purposes. This property acts as a replacement for the Client Secret.')
    clientSecretCertificateThumbprint: string?

    @description('Optional. The app setting name that contains the client secret of the relying party application.')
    clientSecretSettingName: string?

    @description('Optional. The ConfigVersion of the Authentication / Authorization feature in use for the current app. The setting in this value can control the behavior of the control plane for Authentication / Authorization.')
    configVersion: string?

    @description('Optional. The default authentication provider to use when multiple providers are configured. This setting is only needed if multiple providers are configured and the unauthenticated client action is set to "RedirectToLoginPage".')
    defaultProvider: ('AzureActiveDirectory' | 'Facebook' | 'Github' | 'Google' | 'MicrosoftAccount' | 'Twitter')?

    @description('Optional. Set to `true` if the Authentication / Authorization feature is enabled for the current app.')
    enabled: bool?

    @description('Optional. The App ID of the Facebook app used for login. This setting is required for enabling Facebook Login. Facebook Login [documentation](https://developers.facebook.com/docs/facebook-login).')
    facebookAppId: string?

    @description('Optional. The App Secret of the Facebook app used for Facebook Login. This setting is required for enabling Facebook Login. Facebook Login [documentation](https://developers.facebook.com/docs/facebook-login).')
    @secure()
    facebookAppSecret: string?

    @description('Optional. The app setting name that contains the app secret used for Facebook Login.')
    facebookAppSecretSettingName: string?

    @description('Optional. The OAuth 2.0 scopes that will be requested as part of Facebook Login authentication. This setting is optional. Facebook Login [documentation](https://developers.facebook.com/docs/facebook-login).')
    facebookOAuthScopes: string[]?

    @description('Optional. The Client Id of the GitHub app used for login. This setting is required for enabling Github login.')
    gitHubClientId: string?

    @description('Optional. The Client Secret of the GitHub app used for Github Login. This setting is required for enabling Github login.')
    @secure()
    gitHubClientSecret: string?

    @description('Optional. The app setting name that contains the client secret of the Github app used for GitHub Login.')
    gitHubClientSecretSettingName: string?

    @description('Optional. The OAuth 2.0 scopes that will be requested as part of GitHub Login authentication.')
    gitHubOAuthScopes: string[]?

    @description('Optional. The OpenID Connect Client ID for the Google web application. This setting is required for enabling Google Sign-In. Google Sign-In [documentation](https://developers.google.com/identity/sign-in/web).')
    googleClientId: string?

    @description('Optional. The client secret associated with the Google web application. This setting is required for enabling Google Sign-In. Google Sign-In [documentation](https://developers.google.com/identity/sign-in/web).')
    @secure()
    googleClientSecret: string?

    @description('Optional. The app setting name that contains the client secret associated with the Google web application.')
    googleClientSecretSettingName: string?

    @description('Optional. The OAuth 2.0 scopes that will be requested as part of Google Sign-In authentication. This setting is optional. If not specified, "openid", "profile", and "email" are used as default scopes. Google Sign-In [documentation](https://developers.google.com/identity/sign-in/web).')
    googleOAuthScopes: string[]?

    @description('Optional. "true" if the auth config settings should be read from a file, "false" otherwise.')
    isAuthFromFile: ('true' | 'false')?

    @description('Optional. The OpenID Connect Issuer URI that represents the entity which issues access tokens for this application. When using Azure Active Directory, this value is the URI of the directory tenant, e.g. https://sts.windows.net/{tenant-guid}/. This URI is a case-sensitive identifier for the token issuer. More information on [OpenID Connect Discovery](http://openid.net/specs/openid-connect-discovery-1_0.html).')
    issuer: string?

    @description('Optional. The OAuth 2.0 client ID that was created for the app used for authentication. This setting is required for enabling Microsoft Account authentication. Microsoft Account OAuth [documentation](https://dev.onedrive.com/auth/msa_oauth.htm).')
    microsoftAccountClientId: string?

    @description('Optional. The OAuth 2.0 client secret that was created for the app used for authentication. This setting is required for enabling Microsoft Account authentication. Microsoft Account OAuth [documentation](https://dev.onedrive.com/auth/msa_oauth.htm).')
    @secure()
    microsoftAccountClientSecret: string?

    @description('Optional. The app setting name containing the OAuth 2.0 client secret that was created for the app used for authentication.')
    microsoftAccountClientSecretSettingName: string?

    @description('Optional. The OAuth 2.0 scopes that will be requested as part of Microsoft Account authentication. This setting is optional. If not specified, "wl.basic" is used as the default scope. Microsoft Account Scopes and permissions [documentation](https://msdn.microsoft.com/en-us/library/dn631845.aspx).')
    microsoftAccountOAuthScopes: string[]?

    @description('Optional. The RuntimeVersion of the Authentication / Authorization feature in use for the current app. The setting in this value can control the behavior of certain features in the Authentication / Authorization module.')
    runtimeVersion: string?

    @description('Optional. The number of hours after session token expiration that a session token can be used to call the token refresh API. The default is 72 hours.')
    tokenRefreshExtensionHours: int?

    @description('Optional. Set to `true` to durably store platform-specific security tokens that are obtained during login flows. The default is `false`.')
    tokenStoreEnabled: bool?

    @description('Optional. The OAuth 1.0a consumer key of the Twitter application used for sign-in. This setting is required for enabling Twitter Sign-In. Twitter Sign-In [documentation](https://dev.twitter.com/web/sign-in).')
    @secure()
    twitterConsumerKey: string?

    @description('Optional. The OAuth 1.0a consumer secret of the Twitter application used for sign-in. This setting is required for enabling Twitter Sign-In. Twitter Sign-In [documentation](https://dev.twitter.com/web/sign-in).')
    @secure()
    twitterConsumerSecret: string?

    @description('Optional. The app setting name that contains the OAuth 1.0a consumer secret of the Twitter application used for sign-in.')
    twitterConsumerSecretSettingName: string?

    @description('Optional. The action to take when an unauthenticated client attempts to access the app.')
    unauthenticatedClientAction: ('AllowAnonymous' | 'RedirectToLoginPage')?

    @description('Optional. Gets a value indicating whether the issuer should be a valid HTTPS url and be validated as such.')
    validateIssuer: bool?
  }
}

@export()
@description('The type of an authSettingsV2 configuration.')
type authSettingsV2ConfigType = {
  @description('Required. The type of config.')
  name: 'authsettingsV2'

  @description('Required. The config settings.')
  properties: {
    @description('Optional. The configuration settings that determines the validation flow of users using App Service Authentication/Authorization.')
    globalValidation: {
      @description('Optional. The paths for which unauthenticated flow would not be redirected to the login page.')
      excludedPaths: string[]?

      @description('Optional. The default authentication provider to use when multiple providers are configured. This setting is only needed if multiple providers are configured and the unauthenticated client action is set to "RedirectToLoginPage".')
      redirectToProvider: string?

      @description('Optional. Set to `true` if the authentication flow is required by every request.')
      requireAuthentication: bool?

      @description('Optional. The action to take when an unauthenticated client attempts to access the app.')
      unauthenticatedClientAction: ('AllowAnonymous' | 'RedirectToLoginPage' | 'Return401' | 'Return403')?
    }?

    @description('Optional. The configuration settings of the HTTP requests for authentication and authorization requests made against App Service Authentication/Authorization.')
    httpSettings: {
      @description('Optional. The configuration settings of a forward proxy used to make the requests.')
      forwardProxy: {
        @description('Optional. The convention used to determine the url of the request made.')
        convention: ('Custom' | 'NoProxy' | 'Standard')?

        @description('Optional. The name of the header containing the host of the request.')
        customHostHeaderName: string?

        @description('Optional. The name of the header containing the scheme of the request.')
        customProtoHeaderName: string?
      }?

      @description('Optional. Set to `false` if the authentication/authorization responses not having the HTTPS scheme are permissible.')
      requireHttps: bool?

      @description('Optional. The configuration settings of the paths HTTP requests.')
      routes: {
        @description('Optional. The prefix that should precede all the authentication/authorization paths.')
        apiPrefix: string?
      }?
    }?

    @description('Optional. The configuration settings of each of the identity providers used to configure App Service Authentication/Authorization.')
    identityProviders: {
      @description('Optional. The configuration settings of the Apple provider.')
      apple: {
        @description('Optional. Set to `false` if the Apple provider should not be enabled despite the set registration.')
        enabled: bool?

        @description('Optional. The configuration settings of the login flow.')
        login: {
          @description('Optional. A list of the scopes that should be requested while authenticating.')
          scopes: string[]?
        }?

        @description('Optional. The configuration settings of the Apple registration.')
        registration: {
          @description('Required. The Client ID of the app used for login.')
          clientId: string

          @description('Required. The app setting name that contains the client secret.')
          clientSecretSettingName: string
        }?
      }?

      @description('Optional. The configuration settings of the Azure Active directory provider.')
      azureActiveDirectory: {
        @description('Optional. Set to `false` if the Azure Active Directory provider should not be enabled despite the set registration.')
        enabled: bool?

        @description('Optional. Gets a value indicating whether the Azure AD configuration was auto-provisioned using 1st party tooling. This is an internal flag primarily intended to support the Azure Management Portal. Users should not read or write to this property.')
        isAutoProvisioned: bool?

        @description('Optional. The configuration settings of the Azure Active Directory login flow.')
        login: {
          @description('Optional. Set to `true` if the www-authenticate provider should be omitted from the request.')
          disableWWWAuthenticate: bool?

          @description('Optional. Login parameters to send to the OpenID Connect authorization endpoint when a user logs in. Each parameter must be in the form "key=value".')
          loginParameters: string[]?
        }?

        @description('Optional. The configuration settings of the Azure Active Directory app registration.')
        registration: {
          @description('Required. The Client ID of this relying party application, known as the client_id. This setting is required for enabling OpenID Connection authentication with Azure Active Directory or other 3rd party OpenID Connect providers. More information on [OpenID Connect](http://openid.net/specs/openid-connect-core-1_0.html).')
          clientId: string

          @description('Optional. An alternative to the client secret thumbprint, that is the issuer of a certificate used for signing purposes. This property acts as a replacement for the Client Secret Certificate Thumbprint.')
          clientSecretCertificateIssuer: string?

          @description('Optional. An alternative to the client secret thumbprint, that is the subject alternative name of a certificate used for signing purposes. This property acts as a replacement for the Client Secret Certificate Thumbprint.')
          clientSecretCertificateSubjectAlternativeName: string?

          @description('Optional. An alternative to the client secret, that is the thumbprint of a certificate used for signing purposes. This property acts as a replacement for the Client Secret.')
          clientSecretCertificateThumbprint: string?

          @description('Optional. The app setting name that contains the client secret of the relying party application.')
          clientSecretSettingName: string?

          #disable-next-line no-hardcoded-env-urls // Just a parameter description
          @description('Optional. The OpenID Connect Issuer URI that represents the entity which issues access tokens for this application. When using Azure Active Directory, this value is the URI of the directory tenant, e.g. https://login.microsoftonline.com/v2.0/{tenant-guid}/. This URI is a case-sensitive identifier for the token issuer. More information on [OpenID Connect Discovery](http://openid.net/specs/openid-connect-discovery-1_0.html).')
          openIdIssuer: string?
        }?

        @description('Optional. The configuration settings of the Azure Active Directory token validation flow.')
        validation: {
          @description('Optional. The list of audiences that can make successful authentication/authorization requests.')
          allowedAudiences: string[]?

          @description('Optional. The configuration settings of the default authorization policy.')
          defaultAuthorizationPolicy: {
            @description('Optional. The configuration settings of the Azure Active Directory allowed applications.')
            allowedApplications: string[]?

            @description('Optional. The configuration settings of the Azure Active Directory allowed principals.')
            allowedPrincipals: {
              @description('Optional. The list of the allowed groups.')
              groups: string[]?

              @description('Optional. The list of the allowed identities.')
              identities: string[]?
            }?
          }?

          @description('Optional. The configuration settings of the checks that should be made while validating the JWT Claims.')
          jwtClaimChecks: {
            @description('Optional. The list of the allowed client applications.')
            allowedClientApplications: string[]?

            @description('Optional. The list of the allowed groups.')
            allowedGroups: string[]?
          }?
        }?
      }?

      @description('Optional. The configuration settings of the Azure Static Web Apps provider.')
      azureStaticWebApps: {
        @description('Optional. Set to `false` if the Azure Static Web Apps provider should not be enabled despite the set registration.')
        enabled: bool?

        @description('Optional. The configuration settings of the Azure Static Web Apps registration.')
        registration: {
          @description('Required. The Client ID of the app used for login.')
          clientId: string
        }?
      }?

      @description('Optional. The map of the name of the alias of each custom Open ID Connect provider to the configuration settings of the custom Open ID Connect provider.')
      customOpenIdConnectProviders: {
        @description('Optional. The alias of each custom Open ID Connect provider.')
        *: {
          @description('Optional. Set to `false` if the custom Open ID provider provider should not be enabled.')
          enabled: bool?

          @description('Optional. The configuration settings of the login flow of the custom Open ID Connect provider.')
          login: {
            @description('Optional. The name of the claim that contains the users name.')
            nameClaimType: string?

            @description('Optional. A list of the scopes that should be requested while authenticating.')
            scopes: string[]?
          }?

          @description('Optional. The configuration settings of the app registration for the custom Open ID Connect provider.')
          registration: {
            @description('Optional. The authentication credentials of the custom Open ID Connect provider.')
            clientCredential: {
              @description('Required. The app setting that contains the client secret for the custom Open ID Connect provider.')
              clientSecretSettingName: string

              @description('Required. The method that should be used to authenticate the user.')
              method: 'ClientSecretPost'
            }?

            @description('Optional. The client id of the custom Open ID Connect provider.')
            clientId: string?

            @description('Optional. The configuration settings of the endpoints used for the custom Open ID Connect provider.')
            openIdConnectConfiguration: {
              @description('Optional. The endpoint to be used to make an authorization request.')
              authorizationEndpoint: string?

              @description('Optional. The endpoint that provides the keys necessary to validate the token.')
              certificationUri: string?

              @description('Optional. The endpoint that issues the token.')
              issuer: string?

              @description('Optional. The endpoint to be used to request a token.')
              tokenEndpoint: string?

              @description('Optional. The endpoint that contains all the configuration endpoints for the provider.')
              wellKnownOpenIdConfiguration: string?
            }?
          }?
        }?
      }?

      @description('Optional. The configuration settings of the Facebook provider.')
      facebook: {
        @description('Optional. Set to `false` if the Facebook provider should not be enabled despite the set registration.')
        enabled: bool?

        @description('Optional. The version of the Facebook api to be used while logging in.')
        graphApiVersion: string?

        @description('Optional. The configuration settings of the login flow.')
        login: {
          @description('Optional. A list of the scopes that should be requested while authenticating.')
          scopes: string[]?
        }?

        @description('Optional. The configuration settings of the app registration for the Facebook provider.')
        registration: {
          @description('Required. The App ID of the app used for login.')
          appId: string

          @description('Required. The app setting name that contains the app secret.')
          appSecretSettingName: string
        }?
      }?

      @description('Optional. The configuration settings of the GitHub provider.')
      gitHub: {
        @description('Optional. Set to `false` if the GitHub provider should not be enabled despite the set registration.')
        enabled: bool?

        @description('Optional. The configuration settings of the login flow.')
        login: {
          @description('Optional. A list of the scopes that should be requested while authenticating.')
          scopes: string[]?
        }?

        @description('Optional. The configuration settings of the app registration for the GitHub provider.')
        registration: {
          @description('Required. The Client ID of the app used for login.')
          clientId: string

          @description('Required. The app setting name that contains the client secret.')
          clientSecretSettingName: string
        }?
      }?

      @description('Optional. The configuration settings of the Google provider.')
      google: {
        @description('Optional. Set to `false` if the Google provider should not be enabled despite the set registration.')
        enabled: bool?

        @description('Optional. The configuration settings of the login flow.')
        login: {
          @description('Optional. A list of the scopes that should be requested while authenticating.')
          scopes: string[]?
        }?

        @description('Optional. The configuration settings of the app registration for the Google provider.')
        registration: {
          @description('Required. The Client ID of the app used for login.')
          clientId: string

          @description('Required. The app setting name that contains the client secret.')
          clientSecretSettingName: string
        }?

        @description('Optional. The configuration settings of the Azure Active Directory token validation flow.')
        validation: {
          @description('Optional. The configuration settings of the allowed list of audiences from which to validate the JWT token.')
          allowedAudiences: string[]?
        }?
      }?

      @description('Optional. The configuration settings of the legacy Microsoft Account provider.')
      legacyMicrosoftAccount: {
        @description('Optional. Set to `false` if the legacy Microsoft Account provider should not be enabled despite the set registration.')
        enabled: bool?

        @description('Optional. The configuration settings of the login flow.')
        login: {
          @description('Optional. A list of the scopes that should be requested while authenticating.')
          scopes: string[]?
        }?

        @description('Optional. The configuration settings of the app registration for the legacy Microsoft Account provider.')
        registration: {
          @description('Required. The Client ID of the app used for login.')
          clientId: string

          @description('Required. The app setting name that contains the client secret.')
          clientSecretSettingName: string
        }?

        @description('Optional. The configuration settings of the legacy Microsoft Account provider token validation flow.')
        validation: {
          @description('Optional. The configuration settings of the allowed list of audiences from which to validate the JWT token.')
          allowedAudiences: string[]?
        }?
      }?

      @description('Optional. The configuration settings of the Twitter provider.')
      twitter: {
        @description('Optional. Set to `false` if the Twitter provider should not be enabled despite the set registration.')
        enabled: bool?

        @description('Optional. The configuration settings of the app registration for the Twitter provider.')
        registration: {
          @description('Optional. The OAuth 1.0a consumer key of the Twitter application used for sign-in. This setting is required for enabling Twitter Sign-In. Twitter Sign-In [documentation](https://dev.twitter.com/web/sign-in).')
          @secure()
          consumerKey: string?

          @description('Optional. The app setting name that contains the OAuth 1.0a consumer secret of the Twitter application used for sign-in.')
          consumerSecretSettingName: string?
        }?
      }?
    }?

    @description('Optional. The configuration settings of the login flow of users using App Service Authentication/Authorization.')
    login: {
      @description('Optional. External URLs that can be redirected to as part of logging in or logging out of the app. Note that the query string part of the URL is ignored. This is an advanced setting typically only needed by Windows Store application backends. Note that URLs within the current domain are always implicitly allowed.')
      allowedExternalRedirectUrls: string[]?

      @description('Optional. The configuration settings of the session cookie\'s expiration.')
      cookieExpiration: {
        @description('Optional. The convention used when determining the session cookie\'s expiration.')
        convention: ('FixedTime' | 'IdentityProviderDerived')?

        @description('Optional. The time after the request is made when the session cookie should expire.')
        timeToExpiration: string?
      }?

      @description('Optional. The configuration settings of the nonce used in the login flow.')
      nonce: {
        @description('Optional. The time after the request is made when the nonce should expire.')
        nonceExpirationInterval: string?

        @description('Optional. Set to `false` if the nonce should not be validated while completing the login flow.')
        validateNonce: bool?
      }?

      @description('Optional. Set to `true` if the fragments from the request are preserved after the login request is made.')
      preserveUrlFragmentsForLogins: bool?

      @description('Optional. The routes that specify the endpoints used for login and logout requests.')
      routes: {
        @description('Optional. The endpoint at which a logout request should be made.')
        logoutEndpoint: string?
      }?

      @description('Optional. The configuration settings of the token store.')
      tokenStore: {
        @description('Optional. The configuration settings of the storage of the tokens if blob storage is used.')
        azureBlobStorage: {
          @description('Optional. The name of the app setting containing the SAS URL of the blob storage containing the tokens.')
          sasUrlSettingName: string?
        }?

        @description('Optional. Set to `true` to durably store platform-specific security tokens that are obtained during login flows.')
        enabled: bool?

        @description('Optional. The configuration settings of the storage of the tokens if a file system is used.')
        fileSystem: {
          @description('Optional. The directory in which the tokens will be stored.')
          directory: string?
        }?

        @description('Optional. The number of hours after session token expiration that a session token can be used to call the token refresh API. The default is 72 hours.')
        tokenRefreshExtensionHours: int?
      }?
    }?

    @description('Optional. The configuration settings of the platform of App Service Authentication/Authorization.')
    platform: {
      @description('Optional. The path of the config file containing auth settings if they come from a file. If the path is relative, base will the site\'s root directory.')
      configFilePath: string?

      @description('Optional. Set to `true` if the Authentication / Authorization feature is enabled for the current app.')
      enabled: bool?

      @description('Optional. The RuntimeVersion of the Authentication / Authorization feature in use for the current app. The setting in this value can control the behavior of certain features in the Authentication / Authorization module.')
      runtimeVersion: string?
    }?
  }
}

@export()
@description('The type of an Azure Storage Account configuration.')
type azureStorageAccountConfigType = {
  @description('Required. The type of config.')
  name: 'azurestorageaccounts'

  @description('Required. The config settings.')
  properties: {
    @description('Optional. The Azure Storage Info configuration.')
    *: {
      @description('Optional. Access key for the storage account.')
      @secure()
      accessKey: string?

      @description('Optional. Name of the storage account.')
      accountName: string?

      @description('Optional. Path to mount the storage within the site\'s runtime environment.')
      mountPath: string?

      @description('Optional. Mounting protocol to use for the storage account.')
      protocol: ('Http' | 'Nfs' | 'Smb')?

      @description('Optional. Name of the file share (container name, for Blob storage).')
      shareName: string?

      @description('Optional. Type of storage.')
      type: ('AzureBlob' | 'AzureFiles')?
    }?
  }
}

@export()
@description('The type for a backup configuration.')
type backupConfigType = {
  @description('Required. The type of config.')
  name: 'backup'

  @description('Required. The config settings.')
  properties: {
    @description('Optional. Name of the backup.')
    backupName: string?

    @description('Optional. Schedule for the backup if it is executed periodically.')
    backupSchedule: {
      @description('Required. How often the backup should be executed (e.g. for weekly backup, this should be set to 7 and FrequencyUnit should be set to Day).')
      frequencyInterval: int

      @description('Required. The unit of time for how often the backup should be executed (e.g. for weekly backup, this should be set to Day and FrequencyInterval should be set to 7).')
      frequencyUnit: ('Day' | 'Hour')

      @description('Required. Set to `True` if the retention policy should always keep at least one backup in the storage account, regardless how old it is.')
      keepAtLeastOneBackup: bool

      @description('Required. After how many days backups should be deleted.')
      retentionPeriodInDays: int

      @description('Optional. When the schedule should start working.')
      startTime: string?
    }?

    @description('Optional. Databases included in the backup.')
    databases: {
      @description('Optional. Contains a connection string to a database which is being backed up or restored. If the restore should happen to a new database, the database name inside is the new one.')
      @secure()
      connectionString: string?

      @description('Optional. Contains a connection string name that is linked to the SiteConfig.ConnectionStrings. This is used during restore with overwrite connection strings options.')
      connectionStringName: string?

      @description('Required. Database type (e.g. SqlAzure / MySql).')
      databaseType: ('LocalMySql' | 'MySql' | 'PostgreSql' | 'SqlAzure')

      @description('Optional. The name of the setting.')
      name: string?
    }[]?

    @description('Optional. Set to `True` if the backup schedule is enabled (must be included in that case), `false` if the backup schedule should be disabled.')
    enabled: bool?

    @description('Optional. SAS URL to the container.')
    storageAccountUrl: string?
  }
}

@export()
@description('The type for a connection string configuration.')
type connectionStringsConfigType = {
  @description('Required. The type of config.')
  name: 'connectionstrings'

  @description('Required. The config settings.')
  properties: {
    @description('Optional. The name of the connection string setting.')
    *: {
      @description('Required. Type of database.')
      type: (
        | 'ApiHub'
        | 'Custom'
        | 'DocDb'
        | 'EventHub'
        | 'MySql'
        | 'NotificationHub'
        | 'PostgreSQL'
        | 'RedisCache'
        | 'ServiceBus'
        | 'SQLAzure'
        | 'SQLServer')

      @description('Required. Value of pair.')
      value: string
    }?
  }
}

@export()
@description('The type of a logs configuration.')
type logsConfigType = {
  @description('Required. The type of config.')
  name: 'logs'

  @description('Required. The config settings.')
  properties: {
    @description('Optional. Application Logs for Azure configuration.')
    applicationLogs: {
      @description('Optional. Application logs to blob storage configuration.')
      azureBlobStorage: {
        @description('Optional. Log level.')
        level: ('Error' | 'Information' | 'Off' | 'Verbose' | 'Warning')?

        @description('Optional. Retention in days. Remove blobs older than X days. 0 or lower means no retention.')
        retentionInDays: int?

        @description('Optional. SAS url to a azure blob container with read/write/list/delete permissions.')
        sasUrl: string?
      }?

      @description('Optional. Application logs to azure table storage configuration.')
      azureTableStorage: {
        @description('Optional. Log level.')
        level: ('Error' | 'Information' | 'Off' | 'Verbose' | 'Warning')?

        @description('Required. SAS URL to an Azure table with add/query/delete permissions.')
        sasUrl: string
      }?

      @description('Optional. Application logs to file system configuration.')
      fileSystem: {
        @description('Optional. Log level.')
        level: ('Error' | 'Information' | 'Off' | 'Verbose' | 'Warning')?
      }?
    }?

    @description('Optional. Detailed error messages configuration.')
    detailedErrorMessages: {
      @description('Optional. Set to `True` if configuration is enabled, false if it is disabled.')
      enabled: bool?
    }?

    @description('Optional. Failed requests tracing configuration.')
    failedRequestsTracing: {
      @description('Optional. Set to `True` if configuration is enabled, false if it is disabled.')
      enabled: bool?
    }?

    @description('Optional. HTTP logs configuration.')
    httpLogs: {
      @description('Optional. Http logs to azure blob storage configuration.')
      azureBlobStorage: {
        @description('Optional. Set to `True` if configuration is enabled, false if it is disabled.')
        enabled: bool?

        @description('Optional. Retention in days. Remove blobs older than X days. 0 or lower means no retention.')
        retentionInDays: int?

        @description('Optional. SAS url to a azure blob container with read/write/list/delete permissions.')
        sasUrl: string?
      }?

      @description('Optional. Http logs to file system configuration.')
      fileSystem: {
        @description('Optional. Set to `True` if configuration is enabled, false if it is disabled.')
        enabled: bool?

        @description('Optional. Retention in days. Remove files older than X days. 0 or lower means no retention.')
        retentionInDays: int?

        @description('Optional. Maximum size in megabytes that http log files can use. When reached old log files will be removed to make space for new ones.')
        @minValue(25)
        @maxValue(100)
        retentionInMb: int?
      }?
    }?
  }
}

@export()
@description('The type of a metadata configuration.')
type metadataConfigType = {
  @description('Required. The type of config.')
  name: 'metadata'

  @description('Required. The config settings.')
  properties: {
    @description('Optional. The metadata key value pair.')
    *: string?
  }
}

@export()
@description('The type of a pushSettings configuration.')
type pushSettingsConfigType = {
  @description('Required. The type of config.')
  name: 'pushsettings'

  @description('Required. The config settings.')
  properties: {
    @description('Optional. Gets or sets a JSON string containing a list of dynamic tags that will be evaluated from user claims in the push registration endpoint.')
    dynamicTagsJson: string?

    @description('Required. Gets or sets a flag indicating whether the Push endpoint is enabled.')
    isPushEnabled: bool

    @description('Optional. Gets or sets a JSON string containing a list of tags that require user authentication to be used in the push registration endpoint. Tags can consist of alphanumeric characters and the following: \'_\', \'@\', \'#\', \'.\', \':\', \'-\'. Validation should be performed at the PushRequestHandler.')
    tagsRequiringAuth: string?

    @description('Optional. Gets or sets a JSON string containing a list of tags that are whitelisted for use by the push registration endpoint.')
    tagWhitelistJson: string?
  }
}

@export()
@description('The type of a web configuration.')
type webConfigType = {
  @description('Required. The type of config.')
  name: 'web'

  @description('Required. The config settings.')
  properties: {
    @description('Optional. Flag to use Managed Identity Creds for ACR pull.')
    acrUseManagedIdentityCreds: bool?

    @description('Optional. If using user managed identity, the user managed identity ClientId.')
    acrUserManagedIdentityID: string?

    @description('Optional. Set to `true` if \'Always On\' is enabled.')
    alwaysOn: bool?

    @description('Optional. Information about the formal API definition for the app.')
    apiDefinition: {
      @description('Required. The URL of the API definition.')
      url: string
    }?

    @description('Optional. Azure API management settings linked to the app.')
    apiManagementConfig: {
      @description('Required. APIM-Api Identifier.')
      id: string
    }?

    @description('Optional. App command line to launch.')
    appCommandLine: string?

    @description('Optional. Application settings.')
    appSettings: {
      @description('Required. Name of the pair.')
      name: string

      @description('Required. Value of the pair.')
      value: string
    }[]?

    @description('Optional. Set to `true` if Auto Heal is enabled.')
    autoHealEnabled: bool?

    @description('Optional. Auto Heal rules.')
    autoHealRules: {
      @description('Optional. Actions to be executed when a rule is triggered.')
      actions: {
        @description('Optional. Predefined action to be taken.')
        actionType: ('CustomAction' | 'LogEvent' | 'Recycle')?

        @description('Optional. Custom action to be taken.')
        customAction: {
          @description('Optional. Executable to be run.')
          exe: string?

          @description('Optional. Parameters for the executable.')
          parameters: string?
        }?

        @description('Optional. Minimum time the process must execute before taking the action.')
        minProcessExecutionTime: string?
      }?

      @description('Optional. Conditions that describe when to execute the auto-heal actions.')
      triggers: {
        @description('Optional. A rule based on private bytes.')
        privateBytesInKB: int?

        @description('Optional. A rule based on total requests.')
        requests: {
          @description('Optional. Request Count.')
          count: int?

          @description('Optional. Time interval.')
          timeInterval: string?
        }?

        @description('Optional. A rule based on request execution time.')
        slowRequests: slowRequestBasedTriggerType?

        @description('Optional. A rule based on multiple Slow Requests Rule with path.')
        slowRequestsWithPath: slowRequestBasedTriggerType[]?

        @description('Optional. A rule based on status codes.')
        statusCodes: {
          @description('Optional. Request Count.')
          count: int?

          @description('Optional. Request Path.')
          path: string?

          @description('Optional. HTTP status code.')
          status: int?

          @description('Optional. Request Sub Status.')
          subStatus: int?

          @description('Optional. Time interval.')
          timeInterval: string?

          @description('Optional. Win32 error code.')
          win32Status: int?
        }[]?

        @description('Optional. A rule based on status codes ranges.')
        statusCodesRange: {
          @description('Optional. Request Count.')
          count: int?

          @description('Optional. Path.')
          path: string?

          @description('Optional. HTTP status code.')
          statusCodes: string?

          @description('Optional. Time interval.')
          timeInterval: string?
        }[]?
      }?
    }?

    @description('Optional. Auto-swap slot name.')
    autoSwapSlotName: string?

    @description('Optional. List of Azure Storage Accounts.')
    azureStorageAccounts: {
      @description('Required. A storage account configuration.')
      *: {
        @description('Optional. Access key for the storage account.')
        @secure()
        accessKey: string?

        @description('Optional. Name of the storage account.')
        accountName: string?

        @description('Optional. Path to mount the storage within the site\'s runtime environment.')
        mountPath: string?

        @description('Optional. Mounting protocol to use for the storage account.')
        protocol: ('Http' | 'Nfs' | 'Smb')?

        @description('Optional. Name of the file share (container name, for Blob storage).')
        shareName: string?

        @description('Optional. Type of storage.')
        type: ('AzureBlob' | 'AzureFiles')?
      }
    }?

    @description('Optional. Connection strings.')
    connectionStrings: {
      @description('Optional. Connection string value.')
      connectionString: string?

      @description('Optional. Name of connection string.')
      name: string?

      @description('Optional. Type of database.')
      type: (
        | 'ApiHub'
        | 'Custom'
        | 'DocDb'
        | 'EventHub'
        | 'MySql'
        | 'NotificationHub'
        | 'PostgreSQL'
        | 'RedisCache'
        | 'ServiceBus'
        | 'SQLAzure'
        | 'SQLServer')?
    }[]?

    @description('Optional. Cross-Origin Resource Sharing (CORS) settings.')
    cors: {
      @description('Optional. Gets or sets the list of origins that should be allowed to make cross-origin calls (for example: http://example.com:12345). Use "*" to allow all.')
      allowedOrigins: string[]?

      @description('Optional. Gets or sets whether CORS requests with credentials are allowed. See [ref](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS#Requests_with_credentials) for more details.')
      supportCredentials: bool?
    }?

    @description('Optional. Default documents.')
    defaultDocuments: string[]?

    @description('Optional. Set to `true` if detailed error logging is enabled.')
    detailedErrorLoggingEnabled: bool?

    @description('Optional. Document root.')
    documentRoot: string?

    @description('Optional. Maximum number of workers that a site can scale out to. This setting only applies to apps in plans where ElasticScaleEnabled is `true`.')
    @minValue(0)
    elasticWebAppScaleLimit: int?

    @description('Optional. This is work around for polymorphic types.')
    experiments: {
      @description('Optional. List of ramp-up rules.')
      rampUpRules: {
        @description('Optional. Hostname of a slot to which the traffic will be redirected if decided to. E.g. myapp-stage.azurewebsites.net.')
        actionHostName: string?

        @description('Optional. Custom decision algorithm can be provided in TiPCallback site extension which URL can be specified.')
        changeDecisionCallbackUrl: string?

        @description('Optional. Specifies interval in minutes to reevaluate ReroutePercentage.')
        changeIntervalInMinutes: int?

        @description('Optional. In auto ramp up scenario this is the step to add/remove from `ReroutePercentage` until it reaches `MinReroutePercentage` or `MaxReroutePercentage`. Site metrics are checked every N minutes specified in `ChangeIntervalInMinutes`. Custom decision algorithm can be provided in TiPCallback site extension which URL can be specified in `ChangeDecisionCallbackUrl`.')
        changeStep: int?

        @description('Optional. Specifies upper boundary below which ReroutePercentage will stay.')
        maxReroutePercentage: int?

        @description('Optional. Specifies lower boundary above which ReroutePercentage will stay.')
        minReroutePercentage: int?

        @description('Optional. Name of the routing rule. The recommended name would be to point to the slot which will receive the traffic in the experiment.')
        name: string?

        @description('Optional. Percentage of the traffic which will be redirected to `ActionHostName`.')
        reroutePercentage: int?
      }[]?
    }?

    @description('Optional. State of FTP / FTPS service.')
    ftpsState: ('AllAllowed' | 'Disabled' | 'FtpsOnly')?

    @description('Optional. Maximum number of workers that a site can scale out to. This setting only applies to the Consumption and Elastic Premium Plans.')
    @minValue(0)
    functionAppScaleLimit: int?

    @description('Optional. Gets or sets a value indicating whether functions runtime scale monitoring is enabled. When enabled, the ScaleController will not monitor event sources directly, but will instead call to the runtime to get scale status.')
    functionsRuntimeScaleMonitoringEnabled: bool?

    @description('Optional. Handler mappings.')
    handlerMappings: {
      @description('Optional. Command-line arguments to be passed to the script processor.')
      arguments: string?

      @description('Optional. Requests with this extension will be handled using the specified FastCGI application.')
      extension: string?

      @description('Optional. The absolute path to the FastCGI application.')
      scriptProcessor: string?
    }[]?

    @description('Optional. Health check path.')
    healthCheckPath: string?

    @description('Optional. Allow clients to connect over http2.0.')
    http20Enabled: bool?

    @description('Optional. Set to `true` if HTTP logging is enabled.')
    httpLoggingEnabled: bool?

    @description('Optional. IP security restrictions for main.')
    ipSecurityRestrictions: scmIpSecurityRestrictionType[]?

    @description('Optional. Default action for main access restriction if no rules are matched.')
    ipSecurityRestrictionsDefaultAction: ('Allow' | 'Deny')?

    @description('Optional. Java container.')
    javaContainer: string?

    @description('Optional. Java container version.')
    javaContainerVersion: string?

    @description('Optional. Java version.')
    javaVersion: string?

    @description('Optional. Identity to use for Key Vault Reference authentication.')
    keyVaultReferenceIdentity: string?

    @description('Optional. Site limits.')
    limits: {
      @description('Optional. Maximum allowed disk size usage in MB.')
      maxDiskSizeInMb: int?

      @description('Optional. Maximum allowed memory usage in MB.')
      maxMemoryInMb: int?

      @description('Optional. Maximum allowed CPU usage percentage.')
      maxPercentageCpu: int?
    }?

    @description('Optional. Linux App Framework and version.')
    linuxFxVersion: string?

    @description('Optional. Site load balancing.')
    loadBalancing: (
      | 'LeastRequests'
      | 'LeastRequestsWithTieBreaker'
      | 'LeastResponseTime'
      | 'PerSiteRoundRobin'
      | 'RequestHash'
      | 'WeightedRoundRobin'
      | 'WeightedTotalTraffic')?

    @description('Optional. Set to `true` to enable local MySQL.')
    localMySqlEnabled: bool?

    @description('Optional. HTTP logs directory size limit.')
    logsDirectorySizeLimit: int?

    @description('Optional. Managed pipeline mode.')
    managedPipelineMode: ('Classic' | 'Integrated')?

    @description('Optional. Managed Service Identity Id.')
    managedServiceIdentityId: int?

    @description('Optional. Application metadata. This property cannot be retrieved, since it may contain secrets.')
    metadata: {
      @description('Required. Pair name.')
      name: string

      @description('Required. Pair Value.')
      value: string
    }[]?

    @description('Optional. Number of minimum instance count for a site. This setting only applies to the Elastic Plans.')
    @minValue(0)
    @maxValue(20)
    minimumElasticInstanceCount: int?

    @description('Optional. The minimum strength TLS cipher suite allowed for an application.')
    minTlsCipherSuite: (
      | 'TLS_AES_128_GCM_SHA256'
      | 'TLS_AES_256_GCM_SHA384'
      | 'TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256'
      | 'TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256'
      | 'TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384'
      | 'TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA'
      | 'TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256'
      | 'TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256'
      | 'TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA'
      | 'TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384'
      | 'TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384'
      | 'TLS_RSA_WITH_AES_128_CBC_SHA'
      | 'TLS_RSA_WITH_AES_128_CBC_SHA256'
      | 'TLS_RSA_WITH_AES_128_GCM_SHA256'
      | 'TLS_RSA_WITH_AES_256_CBC_SHA'
      | 'TLS_RSA_WITH_AES_256_CBC_SHA256'
      | 'TLS_RSA_WITH_AES_256_GCM_SHA384')?

    @description('Optional. MinTlsVersion: configures the minimum version of TLS required for SSL requests.')
    minTlsVersion: ('1.0' | '1.1' | '1.2' | '1.3')?

    @description('Optional. .NET Framework version.')
    netFrameworkVersion: string?

    @description('Optional. Version of Node.js.')
    nodeVersion: string?

    @description('Optional. Number of workers.')
    numberOfWorkers: int?

    @description('Optional. Version of PHP.')
    phpVersion: string?

    @description('Optional. Version of PowerShell.')
    powerShellVersion: string?

    @description('Optional. Number of preWarmed instances. This setting only applies to the Consumption and Elastic Plans.')
    @minValue(0)
    @maxValue(10)
    preWarmedInstanceCount: int?

    @description('Optional. Property to allow or block all public traffic.')
    publicNetworkAccess: string?

    @description('Optional. Publishing user name.')
    publishingUsername: string?

    @description('Optional. Push endpoint settings.')
    push: {
      @description('Optional. Kind of resource.')
      kind: string?

      @description('Optional. PushSettings resource specific properties.')
      properties: {
        @description('Optional. Gets or sets a JSON string containing a list of dynamic tags that will be evaluated from user claims in the push registration endpoint.')
        dynamicTagsJson: string?

        @description('Required. Gets or sets a flag indicating whether the Push endpoint is enabled.')
        isPushEnabled: bool

        @description('Optional. Gets or sets a JSON string containing a list of tags that require user authentication to be used in the push registration endpoint. Tags can consist of alphanumeric characters and the following: \'_\', \'@\', \'#\', \'.\', \':\', \'-\'. Validation should be performed at the PushRequestHandler.')
        tagsRequiringAuth: string?

        @description('Optional. Gets or sets a JSON string containing a list of tags that are whitelisted for use by the push registration endpoint.')
        tagWhitelistJson: string?
      }?
    }?

    @description('Optional. Version of Python.')
    pythonVersion: string?

    @description('Optional. Set to `true` if remote debugging is enabled.')
    remoteDebuggingEnabled: bool?

    @description('Optional. Remote debugging version.')
    remoteDebuggingVersion: string?

    @description('Optional. Set to `true` if request tracing is enabled.')
    requestTracingEnabled: bool?

    @description('Optional. Request tracing expiration time.')
    requestTracingExpirationTime: string?

    @description('Optional. IP security restrictions for scm.')
    scmIpSecurityRestrictions: scmIpSecurityRestrictionType[]?

    @description('Optional. Default action for scm access restriction if no rules are matched.')
    scmIpSecurityRestrictionsDefaultAction: ('Allow' | 'Deny')?

    @description('Optional. IP security restrictions for scm to use main.')
    scmIpSecurityRestrictionsUseMain: bool?

    @description('Optional. ScmMinTlsVersion: configures the minimum version of TLS required for SSL requests for SCM site.')
    scmMinTlsVersion: ('1.0' | '1.1' | '1.2' | '1.3')?

    @description('Optional. SCM type.')
    scmType: (
      | 'BitbucketGit'
      | 'BitbucketHg'
      | 'CodePlexGit'
      | 'CodePlexHg'
      | 'Dropbox'
      | 'ExternalGit'
      | 'ExternalHg'
      | 'GitHub'
      | 'LocalGit'
      | 'None'
      | 'OneDrive'
      | 'Tfs'
      | 'VSO'
      | 'VSTSRM')?

    @description('Optional. Tracing options.')
    tracingOptions: string?

    @description('Optional. Set to `true` to use 32-bit worker process.')
    use32BitWorkerProcess: bool?

    @description('Optional. Virtual applications.')
    virtualApplications: {
      @description('Optional. Physical path.')
      physicalPath: string?

      @description('Optional. Set to `true` if preloading is enabled.')
      preloadEnabled: bool?

      @description('Optional. Virtual directories for virtual application.')
      virtualDirectories: {
        @description('Optional. Physical path.')
        physicalPath: string?

        @description('Optional. Path to virtual application.')
        virtualPath: string?
      }[]?

      @description('Optional. Virtual path.')
      virtualPath: string?
    }[]?

    @description('Optional. Virtual Network name.')
    vnetName: string?

    @description('Optional. The number of private ports assigned to this app. These will be assigned dynamically on runtime.')
    vnetPrivatePortsCount: int?

    @description('Optional. Virtual Network Route All enabled. This causes all outbound traffic to have Virtual Network Security Groups and User Defined Routes applied.')
    vnetRouteAllEnabled: bool?

    @description('Optional. Sets the time zone a site uses for generating timestamps. Compatible with Linux and Windows App Service. Setting the WEBSITE_TIME_ZONE app setting takes precedence over this config. For Linux, expects tz database values https://www.iana.org/time-zones (for a quick reference see [ref](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)). For Windows, expects one of the time zones listed under HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Time Zones.')
    websiteTimeZone: string?

    @description('Optional. Set to `true` if WebSocket is enabled.')
    webSocketsEnabled: bool?

    @description('Optional. Xenon App Framework and version.')
    windowsFxVersion: string?

    @description('Optional. Explicit Managed Service Identity Id.')
    xManagedServiceIdentityId: int?
  }
}

@description('The type of aslow request based trigger.')
type slowRequestBasedTriggerType = {
  @description('Optional. Request Count.')
  count: int?

  @description('Optional. Request Path.')
  path: string?

  @description('Optional. Time interval.')
  timeInterval: string?

  @description('Optional. Time taken.')
  timeTaken: string?
}

@description('The type of a IP security restriction.')
type scmIpSecurityRestrictionType = {
  @description('Optional. Allow or Deny access for this IP range.')
  action: ('Allow' | 'Deny')?

  @description('Optional. IP restriction rule description.')
  description: string?

  @description('''Optional. IP restriction rule headers.
X-Forwarded-Host (https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Forwarded-Host#Examples).
The matching logic is ..
- If the property is null or empty (default), all hosts(or lack of) are allowed.
- A value is compared using ordinal-ignore-case (excluding port number).
- Subdomain wildcards are permitted but don't match the root domain. For example, *.contoso.com matches the subdomain foo.contoso.com
but not the root domain contoso.com or multi-level foo.bar.contoso.com
- Unicode host names are allowed but are converted to Punycode for matching.

X-Forwarded-For (https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Forwarded-For#Examples).
The matching logic is ..
- If the property is null or empty (default), any forwarded-for chains (or lack of) are allowed.
- If any address (excluding port number) in the chain (comma separated) matches the CIDR defined by the property.

X-Azure-FDID and X-FD-HealthProbe.
The matching logic is exact match.''')
  headers: {
    @description('Required. A header.')
    *: string[]
  }?

  @description('Optional. IP address the security restriction is valid for. It can be in form of pure ipv4 address (required SubnetMask property) or CIDR notation such as ipv4/mask (leading bit match). For CIDR, SubnetMask property must not be specified.')
  ipAddress: string?

  @description('Optional. IP restriction rule name.')
  name: string?

  @description('Optional. Priority of IP restriction rule.')
  priority: int?

  @description('Optional. Subnet mask for the range of IP addresses the restriction is valid for.')
  subnetMask: string?

  @description('Optional. (internal) Subnet traffic tag.')
  subnetTrafficTag: int?

  @description('Optional. Defines what this IP filter will be used for. This is to support IP filtering on proxies.')
  tag: ('Default' | 'ServiceTag' | 'XffProxy')?

  @description('Optional. Virtual network resource id.')
  vnetSubnetResourceId: string?

  @description('Optional. (internal) Vnet traffic tag.')
  vnetTrafficTag: int?
}

@export()
@description('The type of a basic publishing credential policy.')
type basicPublishingCredentialsPolicyType = {
  @description('Required. The name of the resource.')
  name: ('scm' | 'ftp')

  @description('Optional. Set to true to enable or false to disable a publishing method.')
  allow: bool?

  @description('Optional. Location for all Resources.')
  location: string?
}

@export()
@description('The type of a hybrid connection relay.')
type hybridConnectionRelayType = {
  @description('Required. The resource ID of the relay namespace hybrid connection.')
  hybridConnectionResourceId: string

  @description('Optional. Name of the authorization rule send key to use.')
  sendKeyName: string?
}
