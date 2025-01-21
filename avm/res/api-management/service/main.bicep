metadata name = 'API Management Services'
metadata description = 'This module deploys an API Management Service. The default deployment is set to use a Premium SKU to align with Microsoft WAF-aligned best practices. In most cases, non-prod deployments should use a lower-tier SKU.'

@description('Optional. Additional datacenter locations of the API Management service. Not supported with V2 SKUs.')
param additionalLocations array = []

@description('Required. The name of the API Management service.')
param name string

@description('Optional. List of Certificates that need to be installed in the API Management service. Max supported certificates that can be installed is 10.')
@maxLength(10)
param certificates array = []

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Custom properties of the API Management service. Not supported if SKU is Consumption.')
param customProperties object = {
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
param hostnameConfigurations array = []

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.4.1'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.4.1'
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
param skuCapacity int = 2

@description('Optional. The full resource ID of a subnet in a virtual network to deploy the API Management service in.')
param subnetResourceId string?

@description('Optional. Tags of the resource.')
param tags object?

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
param zones array = [1, 2]

@description('Optional. Necessary to create a new GUID.')
param newGuidValue string = newGuid()

@description('Optional. APIs.')
param apis array = []

@description('Optional. API Version Sets.')
param apiVersionSets array = []

@description('Optional. Authorization servers.')
@secure()
param authorizationServers object = {}

@description('Optional. Backends.')
param backends array = []

@description('Optional. Caches.')
param caches array = []

@description('Optional. API Diagnostics.')
param apiDiagnostics array = []

@description('Optional. Identity providers.')
param identityProviders array = []

@description('Optional. Loggers.')
param loggers array = []

@description('Optional. Named values.')
param namedValues array = []

@description('Optional. Policies.')
param policies array = []

@description('Optional. Portal settings.')
param portalsettings array = []

@description('Optional. Products.')
param products array = []

@description('Optional. Subscriptions.')
param subscriptions array = []

@description('Optional. Public Standard SKU IP V4 based IP address to be associated with Virtual Network deployed service in the region. Supported only for Developer and Premium SKU being deployed in Virtual Network.')
param publicIpAddressResourceId string?

var authorizationServerList = !empty(authorizationServers) ? authorizationServers.secureList : []

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

resource service 'Microsoft.ApiManagement/service@2023-05-01-preview' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: sku
    capacity: contains(sku, 'Consumption') ? 0 : contains(sku, 'Developer') ? 1 : skuCapacity
  }
  zones: contains(sku, 'Premium') ? zones : []
  identity: identity
  properties: {
    publisherEmail: publisherEmail
    publisherName: publisherName
    notificationSenderEmail: notificationSenderEmail
    hostnameConfigurations: hostnameConfigurations
    additionalLocations: contains(sku, 'Premium') ? additionalLocations : []
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
    publicIpAddressId: !empty(publicIpAddressResourceId) ? publicIpAddressResourceId : null
    apiVersionConstraint: !empty(minApiVersion)
      ? {
          minApiVersion: minApiVersion
        }
      : {
          minApiVersion: '2021-08-01'
        }
    restore: restore
  }
}

module service_apis 'api/main.bicep' = [
  for (api, index) in apis: {
    name: '${uniqueString(deployment().name, location)}-Apim-Api-${index}'
    params: {
      apiManagementServiceName: service.name
      displayName: api.displayName
      name: api.name
      path: api.path
      apiDescription: api.?apiDescription
      apiRevision: api.?apiRevision
      apiRevisionDescription: api.?apiRevisionDescription
      apiType: api.?apiType
      apiVersion: api.?apiVersion
      apiVersionDescription: api.?apiVersionDescription
      apiVersionSetId: api.?apiVersionSetId
      authenticationSettings: api.?authenticationSettings
      format: api.?format ?? 'openapi'
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
    }
    dependsOn: [
      service_apiVersionSets
    ]
  }
]

module service_apiVersionSets 'api-version-set/main.bicep' = [
  for (apiVersionSet, index) in apiVersionSets: {
    name: '${uniqueString(deployment().name, location)}-Apim-ApiVersionSet-${index}'
    params: {
      apiManagementServiceName: service.name
      name: apiVersionSet.name
      properties: apiVersionSet.?properties ?? {}
    }
  }
]

module service_authorizationServers 'authorization-server/main.bicep' = [
  for (authorizationServer, index) in authorizationServerList: {
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
    }
  }
]

module service_backends 'backend/main.bicep' = [
  for (backend, index) in backends: {
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
      tls: backend.?tls
    }
  }
]

module service_caches 'cache/main.bicep' = [
  for (cache, index) in caches: {
    name: '${uniqueString(deployment().name, location)}-Apim-Cache-${index}'
    params: {
      apiManagementServiceName: service.name
      description: cache.?description
      connectionString: cache.connectionString
      name: cache.name
      resourceId: cache.?resourceId
      useFromLocation: cache.useFromLocation
    }
  }
]

module service_apiDiagnostics 'api/diagnostics/main.bicep' = [
  for (apidiagnostic, index) in apiDiagnostics: {
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
    }
    dependsOn: [
      service_apis
      service_loggers
    ]
  }
]

module service_identityProviders 'identity-provider/main.bicep' = [
  for (identityProvider, index) in identityProviders: {
    name: '${uniqueString(deployment().name, location)}-Apim-IdentityProvider-${index}'
    params: {
      apiManagementServiceName: service.name
      name: identityProvider.name
      allowedTenants: identityProvider.?allowedTenants ?? []
      authority: identityProvider.?authority ?? ''
      clientId: identityProvider.?clientId ?? ''
      clientLibrary: identityProvider.?clientLibrary ?? ''
      clientSecret: identityProvider.?clientSecret ?? ''
      passwordResetPolicyName: identityProvider.?passwordResetPolicyName ?? ''
      profileEditingPolicyName: identityProvider.?profileEditingPolicyName ?? ''
      signInPolicyName: identityProvider.?signInPolicyName ?? ''
      signInTenant: identityProvider.?signInTenant ?? ''
      signUpPolicyName: identityProvider.?signUpPolicyName ?? ''
      type: identityProvider.?type ?? 'aad'
    }
  }
]

module service_loggers 'logger/main.bicep' = [
  for (logger, index) in loggers: {
    name: '${uniqueString(deployment().name, location)}-Apim-Logger-${index}'
    params: {
      name: logger.name
      apiManagementServiceName: service.name
      credentials: logger.?credentials ?? {}
      isBuffered: logger.?isBuffered
      description: logger.?loggerDescription
      type: logger.?loggerType ?? 'azureMonitor'
      targetResourceId: logger.?targetResourceId ?? ''
    }
    dependsOn: [
      service_namedValues
    ]
  }
]

module service_namedValues 'named-value/main.bicep' = [
  for (namedValue, index) in namedValues: {
    name: '${uniqueString(deployment().name, location)}-Apim-NamedValue-${index}'
    params: {
      apiManagementServiceName: service.name
      displayName: namedValue.displayName
      keyVault: namedValue.?keyVault ?? {}
      name: namedValue.name
      tags: namedValue.?tags // Note: these are not resource tags
      secret: namedValue.?secret ?? false
      value: namedValue.?value ?? newGuidValue
    }
  }
]

module service_portalsettings 'portalsetting/main.bicep' = [
  for (portalsetting, index) in portalsettings: if (!empty(portalsetting.properties)) {
    name: '${uniqueString(deployment().name, location)}-Apim-PortalSetting-${index}'
    params: {
      apiManagementServiceName: service.name
      name: portalsetting.name
      properties: portalsetting.properties
    }
  }
]

module service_policies 'policy/main.bicep' = [
  for (policy, index) in policies: {
    name: '${uniqueString(deployment().name, location)}-Apim-Policy-${index}'
    params: {
      apiManagementServiceName: service.name
      value: policy.value
      format: policy.?format ?? 'xml'
    }
  }
]

module service_products 'product/main.bicep' = [
  for (product, index) in products: {
    name: '${uniqueString(deployment().name, location)}-Apim-Product-${index}'
    params: {
      displayName: product.displayName
      apiManagementServiceName: service.name
      apis: product.?apis ?? []
      approvalRequired: product.?approvalRequired ?? false
      groups: product.?groups ?? []
      name: product.name
      description: product.?description ?? ''
      state: product.?state ?? 'published'
      subscriptionRequired: product.?subscriptionRequired ?? false
      subscriptionsLimit: product.?subscriptionsLimit ?? 1
      terms: product.?terms ?? ''
    }
    dependsOn: [
      service_apis
    ]
  }
]

module service_subscriptions 'subscription/main.bicep' = [
  for (subscription, index) in subscriptions: {
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
    }
  }
]

resource service_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
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
