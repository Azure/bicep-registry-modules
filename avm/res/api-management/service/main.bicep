metadata name = 'API Management Services'
metadata description = 'This module deploys an API Management Service. The default deployment is set to use a Premium SKU to align with Microsoft WAF-aligned best practices. In most cases, non-prod deployments should use a lower-tier SKU.'

@description('Optional. Additional datacenter locations of the API Management service. Not supported with V2 SKUs.')
param additionalLocations additionalLocationType[]?

@description('Required. The name of the API Management service.')
param name string

@description('Optional. List of Certificates that need to be installed in the API Management service. Max supported certificates that can be installed is 10.')
@maxLength(10)
param certificates resourceInput<'Microsoft.ApiManagement/service@2024-05-01'>.properties.certificates?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Custom properties of the API Management service. Not supported if SKU is Consumption.')
param customProperties resourceInput<'Microsoft.ApiManagement/service@2024-05-01'>.properties.customProperties = {
  'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TripleDes168': 'False'
  'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_128_CBC_SHA': 'False'
  'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_256_CBC_SHA': 'False'
  'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_128_CBC_SHA256': 'False'
  'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA': 'False'
  'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_256_CBC_SHA256': 'False'
  'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA': 'False'
  'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_128_GCM_SHA256': 'False'
}

@description('Optional. Property only valid for an API Management service deployed in multiple locations. This can be used to disable the gateway in master region.')
param disableGateway bool = false

@description('Optional. Property only meant to be used for Consumption SKU Service. This enforces a client certificate to be presented on each request to the gateway. This also enables the ability to authenticate the certificate in the policy on the gateway.')
param enableClientCertificate bool = false

@description('Optional. Custom hostname configuration of the API Management service.')
param hostnameConfigurations resourceInput<'Microsoft.ApiManagement/service@2024-05-01'>.properties.hostnameConfigurations?

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.4.1'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.6.0'
@description('Optional. The lock settings of the service.')
param lock lockType?

@description('Optional. Limit control plane API calls to API Management service with version equal to or newer than this value.')
param minApiVersion string?

@description('Optional. The notification sender email address for the service.')
param notificationSenderEmail string = 'apimgmt-noreply@mail.windowsazure.com'

@description('Required. The email address of the owner of the service.')
param publisherEmail string

@description('Required. The name of the owner of the service.')
param publisherName string

@description('Optional. Undelete API Management Service if it was previously soft-deleted. If this flag is specified and set to True all other properties will be ignored.')
param restore bool = false

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.4.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. The pricing tier of this API Management service.')
@allowed([
  'Consumption'
  'Developer'
  'Basic'
  'Standard'
  'Premium'
  'StandardV2'
  'BasicV2'
])
param sku string = 'Premium'

@description('Conditional. The scale units for this API Management service. Required if using Basic, Standard, or Premium skus. For range of capacities for each sku, reference https://azure.microsoft.com/en-us/pricing/details/api-management/.')
param skuCapacity int = 3

@description('Optional. The full resource ID of a subnet in a virtual network to deploy the API Management service in.')
param subnetResourceId string?

@description('Optional. Tags of the resource.')
param tags resourceInput<'Microsoft.ApiManagement/service@2025-05-01'>.tags?

@description('Optional. The type of VPN in which API Management service needs to be configured in. None (Default Value) means the API Management service is not part of any Virtual Network, External means the API Management deployment is set up inside a Virtual Network having an internet Facing Endpoint, and Internal means that API Management deployment is setup inside a Virtual Network having an Intranet Facing Endpoint only.')
@allowed([
  'None'
  'External'
  'Internal'
])
param virtualNetworkType string = 'None'

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.4.1'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

@description('Optional. A list of availability zones denoting where the resource needs to come from. Only supported by Premium sku.')
@allowed([
  1
  2
  3
])
param availabilityZones int[] = [
  1
  2
  3
]

@description('Optional. Necessary to create a new GUID.')
param newGuidValue string = newGuid()

@description('Optional. APIs.')
param apis apiType[]?

@description('Optional. API Version Sets.')
param apiVersionSets apiVersionSetType[]?

@description('Optional. Authorization servers.')
param authorizationServers authorizationServerType[]?

@description('Optional. Backends.')
param backends backendType[]?

@description('Optional. Caches.')
param caches cacheType[]?

@description('Optional. API Diagnostics.')
param apiDiagnostics apiDiagnosticType[]?

@description('Optional. Identity providers.')
param identityProviders identityProviderType[]?

@description('Optional. Loggers.')
param loggers loggerType[]?

@description('Optional. Named values.')
param namedValues namedValueType[]?

@description('Optional. Policies.')
param policies policyType[]?

@description('Optional. Portal settings.')
param portalsettings portalSettingsType[]?

@description('Optional. Products.')
param products productType[]?

@description('Optional. Subscriptions.')
param subscriptions subscriptionType[]?

@description('Optional. Public Standard SKU IP V4 based IP address to be associated with Virtual Network deployed service in the region. Supported only for Developer and Premium SKU being deployed in Virtual Network.')
param publicIpAddressResourceId string?

@description('Optional. Enable the Developer Portal. The developer portal is not supported on the Consumption SKU.')
param enableDeveloperPortal bool = false

var enableReferencedModulesTelemetry bool = false

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
  'API Management Developer Portal Content Editor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'c031e6a8-4391-4de0-8d69-4706a7ed3729'
  )
  'API Management Service Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '312a565d-c81f-4fd8-895a-4e21e48d571c'
  )
  'API Management Service Operator Role': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'e022efe7-f5ba-4159-bbe4-b44f577e9b61'
  )
  'API Management Service Reader Role': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '71522526-b88f-4d52-b57f-d31fc3546d0d'
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
  name: '46d3xbcp.res.apimanagement-service.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource service 'Microsoft.ApiManagement/service@2024-05-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: sku
    capacity: contains(sku, 'Consumption') ? 0 : contains(sku, 'Developer') ? 1 : skuCapacity
  }
  zones: contains(sku, 'Premium') ? map(availabilityZones, zone => string(zone)) : []
  identity: identity
  properties: {
    publisherEmail: publisherEmail
    publisherName: publisherName
    notificationSenderEmail: notificationSenderEmail
    hostnameConfigurations: hostnameConfigurations
    additionalLocations: contains(sku, 'Premium') && !empty(additionalLocations)
      ? map((additionalLocations ?? []), additLoc => {
          location: additLoc.location
          sku: additLoc.sku
          disableGateway: additLoc.?disableGateway
          natGatewayState: additLoc.?natGatewayState
          publicIpAddressId: additLoc.?publicIpAddressResourceId
          virtualNetworkConfiguration: additLoc.?virtualNetworkConfiguration
          zones: map(additLoc.?availabilityZones ?? [], zone => string(zone))
        })
      : []
    customProperties: contains(sku, 'Consumption') ? null : customProperties
    certificates: certificates
    enableClientCertificate: enableClientCertificate ? true : null
    disableGateway: disableGateway
    virtualNetworkType: virtualNetworkType
    virtualNetworkConfiguration: !empty(subnetResourceId)
      ? {
          subnetResourceId: subnetResourceId
        }
      : null
    publicIpAddressId: publicIpAddressResourceId
    apiVersionConstraint: !empty(minApiVersion)
      ? {
          minApiVersion: minApiVersion
        }
      : {
          minApiVersion: '2021-08-01'
        }
    restore: restore
    developerPortalStatus: sku != 'Consumption' ? (enableDeveloperPortal ? 'Enabled' : 'Disabled') : null
  }
}

module service_apis 'api/main.bicep' = [
  for (api, index) in (apis ?? []): {
    name: '${uniqueString(deployment().name, location)}-Apim-Api-${index}'
    params: {
      apiManagementServiceName: service.name
      displayName: api.displayName
      name: api.name
      path: api.path
      description: api.?description
      apiRevision: api.?apiRevision
      apiRevisionDescription: api.?apiRevisionDescription
      apiType: api.?apiType
      apiVersion: api.?apiVersion
      apiVersionDescription: api.?apiVersionDescription
      apiVersionSetName: api.?apiVersionSetName
      authenticationSettings: api.?authenticationSettings
      format: api.?format
      isCurrent: api.?isCurrent
      protocols: api.?protocols
      policies: api.?policies
      serviceUrl: api.?serviceUrl
      sourceApiId: api.?sourceApiId
      subscriptionKeyParameterNames: api.?subscriptionKeyParameterNames
      subscriptionRequired: api.?subscriptionRequired
      type: api.?type
      value: api.?value
      wsdlSelector: api.?wsdlSelector
      diagnostics: api.?diagnostics
      operations: api.?operations
      enableTelemetry: enableReferencedModulesTelemetry
    }
    dependsOn: [
      service_apiVersionSets
    ]
  }
]

module service_apiVersionSets 'api-version-set/main.bicep' = [
  for (apiVersionSet, index) in (apiVersionSets ?? []): {
    name: '${uniqueString(deployment().name, location)}-Apim-ApiVersionSet-${index}'
    params: {
      apiManagementServiceName: service.name
      name: apiVersionSet.name
      displayName: apiVersionSet.displayName
      versioningScheme: apiVersionSet.versioningScheme
      description: apiVersionSet.?description
      versionHeaderName: apiVersionSet.?versionHeaderName
      versionQueryName: apiVersionSet.?versionQueryName
      enableTelemetry: enableReferencedModulesTelemetry
    }
  }
]

module service_authorizationServers 'authorization-server/main.bicep' = [
  for (authorizationServer, index) in (authorizationServers ?? []): {
    name: '${uniqueString(deployment().name, location)}-Apim-AuthorizationServer-${index}'
    params: {
      apiManagementServiceName: service.name
      name: authorizationServer.name
      displayName: authorizationServer.displayName
      authorizationEndpoint: authorizationServer.authorizationEndpoint
      authorizationMethods: authorizationServer.?authorizationMethods ?? ['GET']
      bearerTokenSendingMethods: authorizationServer.?bearerTokenSendingMethods ?? ['authorizationHeader']
      clientAuthenticationMethod: authorizationServer.?clientAuthenticationMethod ?? ['Basic']
      clientId: authorizationServer.clientId
      clientSecret: authorizationServer.clientSecret
      clientRegistrationEndpoint: authorizationServer.?clientRegistrationEndpoint ?? ''
      defaultScope: authorizationServer.?defaultScope ?? ''
      grantTypes: authorizationServer.grantTypes
      resourceOwnerPassword: authorizationServer.?resourceOwnerPassword ?? ''
      resourceOwnerUsername: authorizationServer.?resourceOwnerUsername ?? ''
      serverDescription: authorizationServer.?serverDescription ?? ''
      supportState: authorizationServer.?supportState ?? false
      tokenBodyParameters: authorizationServer.?tokenBodyParameters ?? []
      tokenEndpoint: authorizationServer.?tokenEndpoint ?? ''
      enableTelemetry: enableReferencedModulesTelemetry
    }
  }
]

module service_backends 'backend/main.bicep' = [
  for (backend, index) in (backends ?? []): {
    name: '${uniqueString(deployment().name, location)}-Apim-Backend-${index}'
    params: {
      apiManagementServiceName: service.name
      url: backend.url
      description: backend.?description
      credentials: backend.?credentials
      name: backend.name
      protocol: backend.?protocol
      proxy: backend.?proxy
      resourceId: backend.?resourceId
      serviceFabricCluster: backend.?serviceFabricCluster
      title: backend.?title
      tls: backend.?tls ?? { validateCertificateChain: true, validateCertificateName: true }
      enableTelemetry: enableReferencedModulesTelemetry
    }
  }
]

module service_caches 'cache/main.bicep' = [
  for (cache, index) in (caches ?? []): {
    name: '${uniqueString(deployment().name, location)}-Apim-Cache-${index}'
    params: {
      apiManagementServiceName: service.name
      description: cache.?description
      connectionString: cache.connectionString
      name: cache.name
      resourceId: cache.?resourceId
      useFromLocation: cache.useFromLocation
      enableTelemetry: enableReferencedModulesTelemetry
    }
  }
]

module service_apiDiagnostics 'api/diagnostics/main.bicep' = [
  for (apidiagnostic, index) in (apiDiagnostics ?? []): {
    name: '${uniqueString(deployment().name, location)}-Apim-Api-Diagnostic-${index}'
    params: {
      apiManagementServiceName: service.name
      apiName: apidiagnostic.apiName
      loggerName: apidiagnostic.?loggerName
      name: apidiagnostic.?name
      alwaysLog: apidiagnostic.?alwaysLog
      backend: apidiagnostic.?backend
      frontend: apidiagnostic.?frontend
      httpCorrelationProtocol: apidiagnostic.?httpCorrelationProtocol
      logClientIp: apidiagnostic.?logClientIp
      metrics: apidiagnostic.?metrics
      operationNameFormat: apidiagnostic.?operationNameFormat
      samplingPercentage: apidiagnostic.?samplingPercentage
      verbosity: apidiagnostic.?verbosity
      enableTelemetry: enableReferencedModulesTelemetry
    }
    dependsOn: [
      service_apis
      service_loggers
    ]
  }
]

module service_identityProviders 'identity-provider/main.bicep' = [
  for (identityProvider, index) in (identityProviders ?? []): {
    name: '${uniqueString(deployment().name, location)}-Apim-IdentityProvider-${index}'
    params: {
      apiManagementServiceName: service.name
      name: identityProvider.name
      allowedTenants: identityProvider.?allowedTenants
      authority: identityProvider.?authority
      clientId: identityProvider.?clientId
      clientLibrary: identityProvider.?clientLibrary
      clientSecret: identityProvider.?clientSecret
      passwordResetPolicyName: identityProvider.?passwordResetPolicyName
      profileEditingPolicyName: identityProvider.?profileEditingPolicyName
      signInPolicyName: identityProvider.?signInPolicyName
      signInTenant: identityProvider.?signInTenant
      signUpPolicyName: identityProvider.?signUpPolicyName
      type: identityProvider.?type
      enableTelemetry: enableReferencedModulesTelemetry
    }
  }
]

module service_loggers 'logger/main.bicep' = [
  for (logger, index) in (loggers ?? []): {
    name: '${uniqueString(deployment().name, location)}-Apim-Logger-${index}'
    params: {
      name: logger.name
      apiManagementServiceName: service.name
      credentials: logger.?credentials
      isBuffered: logger.?isBuffered
      description: logger.?loggerDescription
      type: logger.?type ?? 'azureMonitor'
      targetResourceId: logger.?targetResourceId
      enableTelemetry: enableReferencedModulesTelemetry
    }
    dependsOn: [
      service_namedValues
    ]
  }
]

module service_namedValues 'named-value/main.bicep' = [
  for (namedValue, index) in (namedValues ?? []): {
    name: '${uniqueString(deployment().name, location)}-Apim-NamedValue-${index}'
    params: {
      apiManagementServiceName: service.name
      displayName: namedValue.displayName
      keyVault: namedValue.?keyVault
      name: namedValue.name
      tags: namedValue.?tags // Note: these are not resource tags
      secret: namedValue.?secret
      value: namedValue.?value ?? newGuidValue
      enableTelemetry: enableReferencedModulesTelemetry
    }
  }
]

module service_portalsettings 'portalsetting/main.bicep' = [
  for (portalsetting, index) in (portalsettings ?? []): {
    name: '${uniqueString(deployment().name, location)}-Apim-PortalSetting-${index}'
    params: {
      apiManagementServiceName: service.name
      name: portalsetting.name
      properties: portalsetting.properties
      enableTelemetry: enableReferencedModulesTelemetry
    }
  }
]

module service_policies 'policy/main.bicep' = [
  for (policy, index) in (policies ?? []): {
    name: '${uniqueString(deployment().name, location)}-Apim-Policy-${index}'
    params: {
      apiManagementServiceName: service.name
      value: policy.value
      format: policy.?format
      enableTelemetry: enableReferencedModulesTelemetry
    }
  }
]

module service_products 'product/main.bicep' = [
  for (product, index) in (products ?? []): {
    name: '${uniqueString(deployment().name, location)}-Apim-Product-${index}'
    params: {
      displayName: product.displayName
      apiManagementServiceName: service.name
      apis: product.?apis
      approvalRequired: product.?approvalRequired
      groups: product.?groups
      name: product.name
      description: product.?description
      state: product.?state
      subscriptionRequired: product.?subscriptionRequired
      subscriptionsLimit: product.?subscriptionsLimit
      terms: product.?terms
      enableTelemetry: enableReferencedModulesTelemetry
    }
    dependsOn: [
      service_apis
    ]
  }
]

module service_subscriptions 'subscription/main.bicep' = [
  for (subscription, index) in (subscriptions ?? []): {
    name: '${uniqueString(deployment().name, location)}-Apim-Subscription-${index}'
    params: {
      apiManagementServiceName: service.name
      name: subscription.name
      displayName: subscription.displayName
      allowTracing: subscription.?allowTracing
      ownerId: subscription.?ownerId
      primaryKey: subscription.?primaryKey
      scope: subscription.?scope
      secondaryKey: subscription.?secondaryKey
      state: subscription.?state
      enableTelemetry: enableReferencedModulesTelemetry
    }
  }
]

resource service_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?notes ?? (lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.')
  }
  scope: service
}

resource service_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
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
    scope: service
  }
]

resource service_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(service.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: service
  }
]

@description('The name of the API management service.')
output name string = service.name

@description('The resource ID of the API management service.')
output resourceId string = service.id

@description('The resource group the API management service was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string? = service.?identity.?principalId

@description('The location the resource was deployed into.')
output location string = service.location

// =============== //
//   Definitions   //
// =============== //

@export()
@description('The type for an authorization server.')
type authorizationServerType = {
  @description('Required. Identifier of the authorization server.')
  name: string

  @description('Required. API Management Service Authorization Servers name. Must be 1 to 50 characters long.')
  @maxLength(50)
  displayName: string

  @description('Required. OAuth authorization endpoint. See <http://tools.ietf.org/html/rfc6749#section-3.2>.')
  authorizationEndpoint: string

  @description('Optional. HTTP verbs supported by the authorization endpoint. GET must be always present. POST is optional. - HEAD, OPTIONS, TRACE, GET, POST, PUT, PATCH, DELETE.')
  authorizationMethods: string[]?

  @description('Optional. Specifies the mechanism by which access token is passed to the API. - authorizationHeader or query.')
  bearerTokenSendingMethods: string[]?

  @description('Optional. Method of authentication supported by the token endpoint of this authorization server. Possible values are Basic and/or Body. When Body is specified, client credentials and other parameters are passed within the request body in the application/x-www-form-urlencoded format. - Basic or Body.')
  clientAuthenticationMethod: string[]?

  @description('Required. Client or app ID registered with this authorization server.')
  @secure()
  clientId: string

  @description('Optional. Optional reference to a page where client or app registration for this authorization server is performed. Contains absolute URL to entity being referenced.')
  clientRegistrationEndpoint: string?

  @description('Required. Client or app secret registered with this authorization server. This property will not be filled on \'GET\' operations! Use \'/listSecrets\' POST request to get the value.')
  @secure()
  clientSecret: string

  @description('Optional. Access token scope that is going to be requested by default. Can be overridden at the API level. Should be provided in the form of a string containing space-delimited values.')
  defaultScope: string?

  @description('Optional. Description of the authorization server. Can contain HTML formatting tags.')
  serverDescription: string?

  @description('Required. Form of an authorization grant, which the client uses to request the access token. - authorizationCode, implicit, resourceOwnerPassword, clientCredentials.')
  grantTypes: ('authorizationCode' | 'clientCredentials' | 'implicit' | 'resourceOwnerPassword')[]

  @description('Optional. Can be optionally specified when resource owner password grant type is supported by this authorization server. Default resource owner password.')
  @secure()
  resourceOwnerPassword: string?

  @description('Optional. Can be optionally specified when resource owner password grant type is supported by this authorization server. Default resource owner username.')
  resourceOwnerUsername: string?

  @description('Optional. If true, authorization server will include state parameter from the authorization request to its response. Client may use state parameter to raise protocol security.')
  supportState: bool?

  @description('Optional. Additional parameters required by the token endpoint of this authorization server represented as an array of JSON objects with name and value string properties, i.e. {"name" : "name value", "value": "a value"}. - TokenBodyParameterContract object.')
  tokenBodyParameters: resourceInput<'Microsoft.ApiManagement/service/authorizationServers@2024-05-01'>.properties.tokenBodyParameters?

  @description('Optional. OAuth token endpoint. Contains absolute URI to entity being referenced.')
  tokenEndpoint: string?
}

import * as apiTypes from 'api/main.bicep'

@export()
@description('The type of an API Management service API.')
type apiType = {
  @description('Required. API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.')
  name: string

  @description('Optional. Array of Policies to apply to the Service API.')
  policies: apiTypes.policyType[]?

  @description('Optional. Array of diagnostics to apply to the Service API.')
  diagnostics: apiTypes.diagnosticType[]?

  @description('Optional. The operations of the api.')
  operations: apiTypes.operationType[]?

  @description('Optional. Describes the Revision of the API. If no value is provided, default revision 1 is created.')
  apiRevision: string?

  @description('Optional. Description of the API Revision.')
  apiRevisionDescription: string?

  @description('Optional. Type of API to create. * http creates a REST API * soap creates a SOAP pass-through API * websocket creates websocket API * graphql creates GraphQL API.')
  apiType: ('graphql' | 'http' | 'soap' | 'websocket')?

  @description('Optional. Indicates the Version identifier of the API if the API is versioned.')
  apiVersion: string?

  @description('Optional. The name of the API version set to link.')
  apiVersionSetName: string?

  @description('Optional. Description of the API Version.')
  apiVersionDescription: string?

  @description('Optional. Collection of authentication settings included into this API.')
  authenticationSettings: resourceInput<'Microsoft.ApiManagement/service/apis@2024-05-01'>.properties.authenticationSettings?

  @description('Optional. Description of the API. May include HTML formatting tags.')
  description: string?

  @description('Required. API name. Must be 1 to 300 characters long.')
  @maxLength(300)
  displayName: string

  @description('Optional. Format of the Content in which the API is getting imported.')
  format: (
    | 'wadl-xml'
    | 'wadl-link-json'
    | 'swagger-json'
    | 'swagger-link-json'
    | 'wsdl'
    | 'wsdl-link'
    | 'openapi'
    | 'openapi+json'
    | 'openapi-link'
    | 'openapi+json-link')?

  @description('Optional. Indicates if API revision is current API revision.')
  isCurrent: bool?

  @description('Required. Relative URL uniquely identifying this API and all of its resource paths within the API Management service instance. It is appended to the API endpoint base URL specified during the service instance creation to form a public URL for this API.')
  path: string

  @description('Optional. Describes on which protocols the operations in this API can be invoked. - HTTP or HTTPS.')
  protocols: string[]?

  @description('Optional. Absolute URL of the backend service implementing this API. Cannot be more than 2000 characters long.')
  @maxLength(2000)
  serviceUrl: string?

  @description('Optional. API identifier of the source API.')
  sourceApiId: string?

  @description('Optional. Protocols over which API is made available.')
  subscriptionKeyParameterNames: resourceInput<'Microsoft.ApiManagement/service/apis@2024-05-01'>.properties.subscriptionKeyParameterNames?

  @description('Optional. Specifies whether an API or Product subscription is required for accessing the API.')
  subscriptionRequired: bool?

  @description('Optional. Type of API.')
  type: ('graphql' | 'http' | 'soap' | 'websocket')?

  @description('Optional. Content value when Importing an API.')
  value: string?
}

@export()
@description('The type of an API Management service API Version Set.')
type apiVersionSetType = {
  @description('Required. API Version set name.')
  name: string

  @description('Required. The display name of the Name of API Version Set.')
  @minLength(1)
  @maxLength(100)
  displayName: string

  @description('Required. An value that determines where the API Version identifier will be located in a HTTP request.')
  versioningScheme: ('Header' | 'Query' | 'Segment')

  @description('Optional. Description of API Version Set.')
  description: string?

  @description('Optional. Name of HTTP header parameter that indicates the API Version if versioningScheme is set to header.')
  @minLength(1)
  @maxLength(100)
  versionHeaderName: string?

  @description('Optional. Name of query parameter that indicates the API Version if versioningScheme is set to query.')
  @minLength(1)
  @maxLength(100)
  versionQueryName: string?
}

@export()
@description('The type of an API Management service additional location.')
type additionalLocationType = {
  @description('Optional. Property only valid for an Api Management service deployed in multiple locations. This can be used to disable the gateway in this additional location.')
  disableGateway: bool?

  @description('Required. The location name of the additional region among Azure Data center regions.')
  location: string

  @description('Optional. Property can be used to enable NAT Gateway for this API Management service.')
  natGatewayState: ('Disabled' | 'Enabled')?

  @description('Optional. Public Standard SKU IP V4 based IP address to be associated with Virtual Network deployed service in the location. Supported only for Premium SKU being deployed in Virtual Network.')
  publicIpAddressResourceId: string?

  @description('Required. SKU properties of the API Management service.')
  sku: {
    @description('Required. Capacity of the SKU (number of deployed units of the SKU). For Consumption SKU capacity must be specified as 0.')
    capacity: int

    @description('Required. Name of the Sku.')
    name: ('Basic' | 'BasicV2' | 'Consumption' | 'Developer' | 'Isolated' | 'Premium' | 'Standard' | 'StandardV2')
  }

  @description('Optional. Virtual network configuration for the location.')
  virtualNetworkConfiguration: {
    @description('Required. The full resource ID of a subnet in a virtual network to deploy the API Management service in.')
    subnetResourceId: string
  }?

  @description('Optional. A list of availability zones denoting where the resource needs to come from.')
  availabilityZones: (1 | 2 | 3)[]?
}

@export()
@description('The type of a backend configuration.')
type backendType = {
  @description('Required. Backend Name.')
  name: string

  @description('Optional. Backend Credentials Contract Properties.')
  credentials: resourceInput<'Microsoft.ApiManagement/service/backends@2024-05-01'>.properties.credentials?

  @description('Optional. Backend Description.')
  description: string?

  @description('Optional. Backend communication protocol. - http or soap.')
  protocol: string?

  @description('Optional. Backend Proxy Contract Properties.')
  proxy: resourceInput<'Microsoft.ApiManagement/service/backends@2024-05-01'>.properties.proxy?

  @description('Optional. Management Uri of the Resource in External System. This URL can be the Arm Resource ID of Logic Apps, Function Apps or API Apps.')
  resourceId: string?

  @description('Optional. Backend Service Fabric Cluster Properties.')
  serviceFabricCluster: resourceInput<'Microsoft.ApiManagement/service/backends@2024-05-01'>.properties.properties.serviceFabricCluster?

  @description('Optional. Backend Title.')
  title: string?

  @description('Optional. Backend TLS Properties.')
  tls: resourceInput<'Microsoft.ApiManagement/service/backends@2024-05-01'>.properties.tls?

  @description('Required. Runtime URL of the Backend.')
  url: string
}

@export()
@description('The type of a cache.')
type cacheType = {
  @description('Required. Identifier of the Cache entity. Cache identifier (should be either \'default\' or valid Azure region identifier).')
  name: string

  @description('Required. Runtime connection string to cache. Can be referenced by a named value like so, {{<named-value>}}.')
  connectionString: string

  @description('Optional. Cache description.')
  description: string?

  @description('Optional. Original uri of entity in external system cache points to.')
  resourceId: string?

  @description('Required. Location identifier to use cache from (should be either \'default\' or valid Azure region identifier).')
  useFromLocation: string
}

@export()
@description('The type of an API diagnostic setting.')
type apiDiagnosticType = {
  @description('Required. The name of the parent API.')
  apiName: string

  @description('Required. The name of the logger.')
  loggerName: string

  @description('Optional. Type of diagnostic resource.')
  name: ('azuremonitor' | 'applicationinsights' | 'local')?

  @description('Optional. Specifies for what type of messages sampling settings should not apply.')
  alwaysLog: string?

  @description('Optional. Diagnostic settings for incoming/outgoing HTTP messages to the Backend.')
  backend: resourceInput<'Microsoft.ApiManagement/service/apis/diagnostics@2024-05-01'>.properties.backend?

  @description('Optional. Diagnostic settings for incoming/outgoing HTTP messages to the Gateway.')
  frontend: resourceInput<'Microsoft.ApiManagement/service/apis/diagnostics@2024-05-01'>.properties.frontend?

  @description('Conditional. Sets correlation protocol to use for Application Insights diagnostics. Required if using Application Insights.')
  httpCorrelationProtocol: ('Legacy' | 'None' | 'W3C')?

  @description('Optional. Log the ClientIP.')
  logClientIp: bool?

  @description('Conditional. Emit custom metrics via emit-metric policy. Required if using Application Insights.')
  metrics: bool?

  @description('Conditional. The format of the Operation Name for Application Insights telemetries. Required if using Application Insights.')
  operationNameFormat: ('Name' | 'URI')?

  @description('Optional. Rate of sampling for fixed-rate sampling. Specifies the percentage of requests that are logged. 0% sampling means zero requests logged, while 100% sampling means all requests logged.')
  samplingPercentage: int?

  @description('Optional. The verbosity level applied to traces emitted by trace policies.')
  verbosity: ('error' | 'information' | 'verbose')?
}

@export()
@description('The type of an identity provider.')
type identityProviderType = {
  @description('Optional. List of Allowed Tenants when configuring Azure Active Directory login. - string.')
  allowedTenants: resourceInput<'Microsoft.ApiManagement/service/identityProviders@2024-05-01'>.properties.allowedTenants?

  @description('Optional. OpenID Connect discovery endpoint hostname for AAD or AAD B2C.')
  authority: string?

  @description('Conditional. Client ID of the Application in the external Identity Provider. Required if identity provider is used.')
  clientId: string?

  @description('Optional. The client library to be used in the developer portal. Only applies to AAD and AAD B2C Identity Provider.')
  clientLibrary: ('ADAL' | 'MSAL-2')?

  @description('Conditional. Client secret of the Application in external Identity Provider, used to authenticate login request. Required if identity provider is used.')
  @secure()
  clientSecret: string?

  @description('Optional. Password Reset Policy Name. Only applies to AAD B2C Identity Provider.')
  #disable-next-line secure-secrets-in-params // Not a secret
  passwordResetPolicyName: string?

  @description('Optional. Profile Editing Policy Name. Only applies to AAD B2C Identity Provider.')
  profileEditingPolicyName: string?

  @description('Optional. Signin Policy Name. Only applies to AAD B2C Identity Provider.')
  signInPolicyName: string?

  @description('Optional. The TenantId to use instead of Common when logging into Active Directory.')
  signInTenant: string?

  @description('Optional. Signup Policy Name. Only applies to AAD B2C Identity Provider.')
  signUpPolicyName: string?

  @description('Optional. Identity Provider Type identifier.')
  type: ('aad' | 'aadB2C' | 'facebook' | 'google' | 'microsoft' | 'twitter')?

  @description('Required. Identity provider name.')
  name: string
}

@export()
@description('The type of a logger.')
type loggerType = {
  @description('Required. Resource Name.')
  name: string

  @description('Optional. Logger description.')
  description: string?

  @description('Optional. Whether records are buffered in the logger before publishing.')
  isBuffered: bool?

  @description('Required. Logger type.')
  type: ('applicationInsights' | 'azureEventHub' | 'azureMonitor')

  @description('Conditional. Azure Resource Id of a log target (either Azure Event Hub resource or Azure Application Insights resource). Required if loggerType = applicationInsights or azureEventHub.')
  targetResourceId: string?

  @secure()
  @description('Conditional. The name and SendRule connection string of the event hub for azureEventHub logger. Instrumentation key for applicationInsights logger. Required if loggerType = applicationInsights or azureEventHub.')
  credentials: resourceInput<'Microsoft.ApiManagement/service/loggers@2024-05-01'>.properties.credentials?
}

@export()
@description('The type of a named-value.')
type namedValueType = {
  @description('Required. Unique name of NamedValue. It may contain only letters, digits, period, dash, and underscore characters.')
  displayName: string

  @description('Optional. KeyVault location details of the namedValue.')
  keyVault: resourceInput<'Microsoft.ApiManagement/service/namedValues@2024-05-01'>.properties.keyVault?

  @description('Required. Named value Name.')
  name: string

  @description('Optional. Tags that when provided can be used to filter the NamedValue list. - string.')
  tags: resourceInput<'Microsoft.ApiManagement/service/namedValues@2024-05-01'>.properties.tags?

  @description('Optional. Determines whether the value is a secret and should be encrypted or not. Default value is false.')
  #disable-next-line secure-secrets-in-params // Not a secret
  secret: bool?

  @description('Optional. Value of the NamedValue. Can contain policy expressions. It may not be empty or consist only of whitespace. This property will not be filled on \'GET\' operations! Use \'/listSecrets\' POST request to get the value.')
  value: string?
}

@export()
@description('The type of a policy.')
type policyType = {
  @description('Optional. The name of the policy.')
  name: string?

  @description('Optional. Format of the policyContent.')
  format: ('rawxml' | 'rawxml-link' | 'xml' | 'xml-link')?

  @description('Required. Contents of the Policy as defined by the format.')
  value: string
}

@export()
@description('The type of a subscription.')
type subscriptionType = {
  @description('Optional. Determines whether tracing can be enabled.')
  allowTracing: bool?

  @description('Required. API Management Service Subscriptions name. Must be 1 to 100 characters long.')
  @maxLength(100)
  displayName: string

  @description('Optional. User (user ID path) for whom subscription is being created in form /users/{userId}.')
  ownerId: string?

  @description('Optional. Primary subscription key. If not specified during request key will be generated automatically.')
  primaryKey: string?

  @description('Optional. Scope type to choose between a product, "allAPIs" or a specific API. Scope like "/products/{productId}" or "/apis" or "/apis/{apiId}".')
  scope: string?

  @description('Optional. Secondary subscription key. If not specified during request key will be generated automatically.')
  secondaryKey: string?

  @description('Optional. Initial subscription state. If no value is specified, subscription is created with Submitted state. Possible states are "*" active "?" the subscription is active, "*" suspended "?" the subscription is blocked, and the subscriber cannot call any APIs of the product, * submitted ? the subscription request has been made by the developer, but has not yet been approved or rejected, * rejected ? the subscription request has been denied by an administrator, * cancelled ? the subscription has been cancelled by the developer or administrator, * expired ? the subscription reached its expiration date and was deactivated. - suspended, active, expired, submitted, rejected, cancelled.')
  state: string?

  @description('Required. Subscription name.')
  name: string
}

@export()
@description('The type of a product.')
type productType = {
  @description('Required. API Management Service Products name. Must be 1 to 300 characters long.')
  @maxLength(300)
  displayName: string

  @description('Optional. Whether subscription approval is required. If false, new subscriptions will be approved automatically enabling developers to call the products APIs immediately after subscribing. If true, administrators must manually approve the subscription before the developer can any of the products APIs. Can be present only if subscriptionRequired property is present and has a value of false.')
  approvalRequired: bool?

  @description('Optional. Product description. May include HTML formatting tags.')
  description: string?

  @description('Optional. Names of Product APIs.')
  apis: string[]?

  @description('Optional. Names of Product Groups.')
  groups: string[]?

  @description('Required. Product Name.')
  name: string

  @description('Optional. whether product is published or not. Published products are discoverable by users of developer portal. Non published products are visible only to administrators. Default state of Product is notPublished. - notPublished or published.')
  state: string?

  @description('Optional. Whether a product subscription is required for accessing APIs included in this product. If true, the product is referred to as "protected" and a valid subscription key is required for a request to an API included in the product to succeed. If false, the product is referred to as "open" and requests to an API included in the product can be made without a subscription key. If property is omitted when creating a new product it\'s value is assumed to be true.')
  subscriptionRequired: bool?

  @description('Optional. Whether the number of subscriptions a user can have to this product at the same time. Set to null or omit to allow unlimited per user subscriptions. Can be present only if subscriptionRequired property is present and has a value of false.')
  subscriptionsLimit: int?

  @description('Optional. Product terms of use. Developers trying to subscribe to the product will be presented and required to accept these terms before they can complete the subscription process.')
  terms: string?
}

@export()
@description('The type for the portal settings properties.')
@discriminator('name')
type portalSettingsType = signInPropertiesType | signUpPropertiesType | delegationPropertiesType

@export()
@description('The type for sign-in portal settings.')
type signInPropertiesType = {
  @description('Required. The name of the portal-setting.')
  name: 'signin'

  @description('Required. The portal-settings contract properties.')
  properties: {
    @description('Required. Redirect Anonymous users to the Sign-In page.')
    enabled: bool
  }
}

@export()
@description('The type for sign-up portal settings.')
type signUpPropertiesType = {
  @description('Required. The name of the portal-setting.')
  name: 'signup'

  @description('Required. The portal-settings contract properties.')
  properties: {
    @description('Optional. Allow users to sign up on a developer portal.')
    enabled: bool?

    @description('Optional. Terms of service contract properties.')
    termsOfService: {
      @description('Otional. Ask user for consent to the terms of service.')
      consentRequired: bool?
      @description('Otional. Display terms of service during a sign-up process.')
      enabled: bool?
      @description('Otional. A terms of service text.')
      text: string?
    }?
  }
}

@export()
@description('The type for delegation portal settings.')
type delegationPropertiesType = {
  @description('Required. The name of the portal-setting.')
  name: 'delegation'

  @description('Required. The portal-settings contract properties.')
  properties: {
    @description('Optional. Subscriptions delegation settings.')
    subscriptions: {
      @description('Required. Enable or disable delegation for subscriptions.')
      enabled: bool
    }?

    @description('Optional. A delegation Url.')
    url: string?

    @description('Optional. User registration delegation settings.')
    userRegistration: {
      @description('Required. Enable or disable delegation for user registration.')
      enabled: bool
    }?

    @secure()
    @description('Optional. A base64-encoded validation key to validate, that a request is coming from Azure API Management.')
    validationKey: string?
  }
}
