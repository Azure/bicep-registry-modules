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

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
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

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. The pricing tier of this API Management service.')
@allowed([
  'Consumption'
  'Developer'
  'Basic'
  'Standard'
  'Premium'
  'BasicV2'
  'StandardV2'
  'PremiumV2'
])
param sku string = 'Premium'

@description('Conditional. The scale units for this API Management service. Required if using Basic, Standard, or Premium skus. For range of capacities for each sku, reference https://azure.microsoft.com/en-us/pricing/details/api-management/.')
param skuCapacity int = 3

@description('Optional. The full resource ID of a subnet in a virtual network to deploy the API Management service in. VNet injection is supported with Developer, Premium, and PremiumV2 SKUs only.')
param subnetResourceId string?

@description('Optional. Tags of the resource.')
param tags resourceInput<'Microsoft.ApiManagement/service@2024-05-01'>.tags?

@description('Conditional. The type of VPN in which API Management service needs to be configured in. None (Default Value) means the API Management service is not part of any Virtual Network, External means the API Management deployment is set up inside a Virtual Network having an internet Facing Endpoint, and Internal means that API Management deployment is setup inside a Virtual Network having an Intranet Facing Endpoint only. VNet injection (External/Internal) is supported with Developer, Premium, and PremiumV2 SKUs only. Required if `subnetResourceId` is used and must be set to `External` or `Internal`.')
@allowed([
  'None'
  'External'
  'Internal'
])
param virtualNetworkType string = 'None'

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
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

import { privateEndpointSingleServiceType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointSingleServiceType[]?

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

@description('Optional. API Management Service Diagnostics.')
param serviceDiagnostics serviceDiagnosticType[]?

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

@description('Optional. Workspaces. Only supported with Premium and PremiumV2 SKUs.')
param workspaces workspaceType[]?

@description('Optional. Public Standard SKU IP V4 based IP address to be associated with Virtual Network deployed service in the region. Supported only for Developer and Premium SKUs when deployed in Virtual Network.')
param publicIpAddressResourceId string?

@description('Optional. Enable the Developer Portal. The developer portal is not supported on the Consumption SKU.')
param enableDeveloperPortal bool = false

@description('Optional. Whether or not public endpoint access is allowed for this API Management service. If set to \'Disabled\', private endpoints are the exclusive access method. MUST be enabled during service creation.')
param publicNetworkAccess resourceInput<'Microsoft.ApiManagement/service@2024-05-01'>.properties.publicNetworkAccess?

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
    publicNetworkAccess: !empty(publicNetworkAccess)
      ? publicNetworkAccess
      : (!empty(privateEndpoints ?? []) ? 'Disabled' : 'Enabled')
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
      service_loggers
    ]
  }
]

module service_apiVersionSets 'api-version-set/main.bicep' = [
  for (apiVersionSet, index) in (apiVersionSets ?? []): {
    name: '${uniqueString(deployment().name, location)}-Apim-ApiVerSet-${index}'
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
    name: '${uniqueString(deployment().name, location)}-Apim-AuthSrv-${index}'
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

@batchSize(1)
module service_backends 'backend/main.bicep' = [
  for (backend, index) in (backends ?? []): {
    name: '${uniqueString(deployment().name, location)}-Apim-Bcknd-${index}'
    params: {
      apiManagementServiceName: service.name
      url: backend.?url
      description: backend.?description
      credentials: backend.?credentials
      name: backend.name
      protocol: backend.?protocol
      proxy: backend.?proxy
      resourceId: backend.?resourceId
      serviceFabricCluster: backend.?serviceFabricCluster
      title: backend.?title
      tls: backend.?tls
      enableTelemetry: enableReferencedModulesTelemetry
      circuitBreaker: backend.?circuitBreaker
      pool: backend.?pool
      type: backend.?type
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

module service_identityProviders 'identity-provider/main.bicep' = [
  for (identityProvider, index) in (identityProviders ?? []): {
    name: '${uniqueString(deployment().name, location)}-Apim-IdProvdr-${index}'
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
    name: '${uniqueString(deployment().name, location)}-Apim-Logg-${index}'
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
    name: '${uniqueString(deployment().name, location)}-Apim-NamVal-${index}'
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
    name: '${uniqueString(deployment().name, location)}-Apim-PrtSet-${index}'
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
    name: '${uniqueString(deployment().name, location)}-Apim-Pol-${index}'
    params: {
      name: policy.?name
      apiManagementServiceName: service.name
      value: policy.value
      format: policy.?format
      enableTelemetry: enableReferencedModulesTelemetry
    }
  }
]

module service_products 'product/main.bicep' = [
  for (product, index) in (products ?? []): {
    name: '${uniqueString(deployment().name, location)}-Apim-Prd-${index}'
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
    name: '${uniqueString(deployment().name, location)}-Apim-Subscr-${index}'
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
    dependsOn: [
      service_apis
      service_products
    ]
  }
]

module service_diagnostics 'diagnostic/main.bicep' = [
  for (diagnostic, index) in (serviceDiagnostics ?? []): {
    name: '${uniqueString(deployment().name, location)}-Apim-SvcDiag-${index}'
    params: {
      apiManagementServiceName: service.name
      name: diagnostic.name
      loggerResourceId: diagnostic.loggerResourceId
      alwaysLog: diagnostic.?alwaysLog
      backend: diagnostic.?backend
      frontend: diagnostic.?frontend
      httpCorrelationProtocol: diagnostic.?httpCorrelationProtocol
      logClientIp: diagnostic.?logClientIp
      metrics: diagnostic.?metrics
      operationNameFormat: diagnostic.?operationNameFormat
      samplingPercentage: diagnostic.?samplingPercentage
      verbosity: diagnostic.?verbosity
    }
    dependsOn: [
      service_loggers
    ]
  }
]

module service_workspaces 'workspace/main.bicep' = [
  for (workspace, index) in (workspaces ?? []): if (contains(['Premium', 'PremiumV2'], sku)) {
    name: '${uniqueString(deployment().name, location)}-Apim-Wksp-${index}'
    params: {
      apiManagementServiceName: service.name
      name: workspace.name
      displayName: workspace.displayName
      description: workspace.?description
      apis: workspace.?apis
      apiVersionSets: workspace.?apiVersionSets
      backends: workspace.?backends
      products: workspace.?products
      diagnostics: workspace.?diagnostics
      loggers: workspace.?loggers
      namedValues: workspace.?namedValues
      policies: workspace.?policies
      subscriptions: workspace.?subscriptions
      gateway: workspace.gateway
      diagnosticSettings: workspace.?diagnosticSettings
      roleAssignments: workspace.?roleAssignments
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

module service_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.11.1' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-service-PrivateEndpoint-${index}'
    scope: resourceGroup(
      split(privateEndpoint.?resourceGroupResourceId ?? resourceGroup().id, '/')[2],
      split(privateEndpoint.?resourceGroupResourceId ?? resourceGroup().id, '/')[4]
    )
    params: {
      name: privateEndpoint.?name ?? 'pep-${last(split(service.id, '/'))}-${privateEndpoint.?service ?? 'gateway'}-${index}'
      privateLinkServiceConnections: privateEndpoint.?isManualConnection != true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(service.id, '/'))}-${privateEndpoint.?service ?? 'gateway'}-${index}'
              properties: {
                privateLinkServiceId: service.id
                groupIds: [
                  privateEndpoint.?service ?? 'Gateway' // Upper-case as per portal
                ]
              }
            }
          ]
        : null
      manualPrivateLinkServiceConnections: privateEndpoint.?isManualConnection == true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(service.id, '/'))}-${privateEndpoint.?service ?? 'gateway'}-${index}'
              properties: {
                privateLinkServiceId: service.id
                groupIds: [
                  privateEndpoint.?service ?? 'Gateway' // Upper-case as per portal
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

@description('The private endpoints of the key vault.')
output privateEndpoints privateEndpointOutputType[] = [
  for (item, index) in (privateEndpoints ?? []): {
    name: service_privateEndpoints[index].outputs.name
    resourceId: service_privateEndpoints[index].outputs.resourceId
    groupId: service_privateEndpoints[index].outputs.?groupId!
    customDnsConfigs: service_privateEndpoints[index].outputs.customDnsConfigs
    networkInterfaceResourceIds: service_privateEndpoints[index].outputs.networkInterfaceResourceIds
  }
]

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

  @description('Optional. HTTP verbs supported by the authorization endpoint. GET must be always present.')
  authorizationMethods: resourceInput<'Microsoft.ApiManagement/service/authorizationServers@2024-05-01'>.properties.authorizationMethods?

  @description('Optional. Specifies the mechanism by which access token is passed to the API. - authorizationHeader or query.')
  bearerTokenSendingMethods: resourceInput<'Microsoft.ApiManagement/service/authorizationServers@2024-05-01'>.properties.bearerTokenSendingMethods?

  @description('Optional. Method of authentication supported by the token endpoint of this authorization server. Possible values are Basic and/or Body. When Body is specified, client credentials and other parameters are passed within the request body in the application/x-www-form-urlencoded format. - Basic or Body.')
  clientAuthenticationMethod: resourceInput<'Microsoft.ApiManagement/service/authorizationServers@2024-05-01'>.properties.clientAuthenticationMethod?

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
  grantTypes: (
    | 'authorizationCode'
    | 'authorizationCodeWithPkce'
    | 'clientCredentials'
    | 'implicit'
    | 'resourceOwnerPassword')[]

  @description('Optional. Can be optionally specified when resource owner password grant type is supported by this authorization server. Default resource owner password.')
  @secure()
  resourceOwnerPassword: string?

  @description('Optional. Can be optionally specified when resource owner password grant type is supported by this authorization server. Default resource owner username.')
  resourceOwnerUsername: string?

  @description('Optional. If true, authorization server will include state parameter from the authorization request to its response. Client may use state parameter to raise protocol security.')
  supportState: bool?

  @description('Optional. Additional parameters required by the token endpoint of this authorization server represented as an array of JSON objects with name and value string properties, i.e. {"name" : "name value", "value": "a value"}.')
  tokenBodyParameters: resourceInput<'Microsoft.ApiManagement/service/authorizationServers@2024-05-01'>.properties.tokenBodyParameters?

  @description('Optional. OAuth token endpoint. Contains absolute URI to entity being referenced.')
  tokenEndpoint: string?
}

import * as apiTypes from 'api/main.bicep'

@export()
@description('The type of an API Management service API.')
type apiType = {
  @minLength(1)
  @maxLength(256)
  @description('Required. API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.')
  name: string

  @description('Optional. Array of Policies to apply to the Service API.')
  policies: apiTypes.policyType[]?

  @description('Optional. Array of diagnostics to apply to the Service API.')
  diagnostics: apiTypes.diagnosticType[]?

  @description('Optional. The operations of the api.')
  operations: apiTypes.operationType[]?

  @minLength(1)
  @maxLength(100)
  @description('Optional. Describes the Revision of the API. If no value is provided, default revision 1 is created.')
  apiRevision: string?

  @maxLength(256)
  @description('Optional. Description of the API Revision.')
  apiRevisionDescription: string?

  @description('''Optional. Type of API to create.
* `http` creates a REST API
* `soap` creates a SOAP pass-through API
* `websocket` creates websocket API
* `graphql` creates GraphQL API.''')
  apiType: ('graphql' | 'http' | 'soap' | 'websocket')?

  @maxLength(100)
  @description('Optional. Indicates the Version identifier of the API if the API is versioned.')
  apiVersion: string?

  @maxLength(256)
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
    | 'graphql-link'
    | 'grpc'
    | 'grpc-link'
    | 'odata'
    | 'odata-link'
    | 'openapi'
    | 'openapi+json'
    | 'openapi+json-link'
    | 'openapi-link'
    | 'swagger-json'
    | 'swagger-link-json'
    | 'wadl-link-json'
    | 'wadl-xml'
    | 'wsdl'
    | 'wsdl-link')?

  @description('Optional. Indicates if API revision is current API revision.')
  isCurrent: bool?

  @maxLength(400)
  @description('Required. Relative URL uniquely identifying this API and all of its resource paths within the API Management service instance. It is appended to the API endpoint base URL specified during the service instance creation to form a public URL for this API.')
  path: string

  @description('Optional. Describes on which protocols the operations in this API can be invoked.')
  protocols: ('http' | 'https' | 'ws' | 'wss')[]?

  @description('Optional. Absolute URL of the backend service implementing this API. Cannot be more than 2000 characters long.')
  @maxLength(2000)
  serviceUrl: string?

  @description('Optional. The name of the API version set to link.')
  apiVersionSetName: string?

  @description('Optional. API identifier of the source API.')
  sourceApiId: string?

  @description('Optional. Protocols over which API is made available.')
  subscriptionKeyParameterNames: resourceInput<'Microsoft.ApiManagement/service/apis@2024-05-01'>.properties.subscriptionKeyParameterNames?

  @description('Optional. Specifies whether an API or Product subscription is required for accessing the API.')
  subscriptionRequired: bool?

  @description('Optional. Type of API.')
  type: ('graphql' | 'grpc' | 'http' | 'odata' | 'soap' | 'websocket')?

  @description('Optional. Content value when Importing an API.')
  value: string?

  @description('Optional. Criteria to limit import of WSDL to a subset of the document.')
  wsdlSelector: resourceInput<'Microsoft.ApiManagement/service/apis@2024-05-01'>.properties.wsdlSelector?
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
    name: (
      | 'Basic'
      | 'BasicV2'
      | 'Consumption'
      | 'Developer'
      | 'Isolated'
      | 'Premium'
      | 'PremiumV2'
      | 'Standard'
      | 'StandardV2')
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
@description('The type of a backend configuration.')
type backendType = {
  @description('Required. Backend Name.')
  name: string

  @description('Optional. Backend Credentials Contract Properties. Not supported for Backend Pools.')
  credentials: resourceInput<'Microsoft.ApiManagement/service/backends@2024-05-01'>.properties.credentials?

  @description('Optional. Backend Description.')
  description: string?

  @description('Optional. Backend communication protocol. http or soap. Not supported for Backend Pools.')
  protocol: string?

  @description('Optional. Backend Proxy Contract Properties. Not supported for Backend Pools.')
  proxy: resourceInput<'Microsoft.ApiManagement/service/backends@2024-05-01'>.properties.proxy?

  @description('Optional. Management Uri of the Resource in External System. This URL can be the Arm Resource ID of Logic Apps, Function Apps or API Apps. Not supported for Backend Pools.')
  resourceId: string?

  @description('Optional. Backend Service Fabric Cluster Properties. Not supported for Backend Pools.')
  serviceFabricCluster: resourceInput<'Microsoft.ApiManagement/service/backends@2024-05-01'>.properties.properties.serviceFabricCluster?

  @description('Optional. Backend Title.')
  title: string?

  @description('Optional. Backend TLS Properties. Not supported for Backend Pools. If not specified and type is Single, TLS properties will default to validateCertificateChain and validateCertificateName set to true.')
  tls: resourceInput<'Microsoft.ApiManagement/service/backends@2024-05-01'>.properties.tls?

  @minLength(1)
  @maxLength(2000)
  @description('Conditional. Runtime URL of the Backend. Required if type is Single and not supported if type is Pool.')
  url: string?

  @description('Optional. Backend Circuit Breaker Configuration. Not supported for Backend Pools.')
  circuitBreaker: resourceInput<'Microsoft.ApiManagement/service/backends@2024-05-01'>.properties.circuitBreaker?

  @description('Conditional. Backend pool configuration for load balancing. Required if type is Pool and not supported if type is Single.')
  pool: resourceInput<'Microsoft.ApiManagement/service/backends@2024-05-01'>.properties.pool?

  @description('Optional. Type of the backend. A backend can be either Single or Pool.')
  type: ('Single' | 'Pool')?
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
  @description('Required. Logger name.')
  name: string

  @maxLength(256)
  @description('Optional. Description of the logger.')
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
  @minLength(1)
  @maxLength(256)
  @description('Required. Unique name of NamedValue. It may contain only letters, digits, period, dash, and underscore characters.')
  displayName: string

  @description('Optional. KeyVault location details of the namedValue.')
  keyVault: resourceInput<'Microsoft.ApiManagement/service/namedValues@2024-05-01'>.properties.keyVault?

  @description('Required. The name of the named value.')
  name: string

  @description('Optional. Tags that when provided can be used to filter the NamedValue list.')
  tags: resourceInput<'Microsoft.ApiManagement/service/namedValues@2024-05-01'>.properties.tags?

  @description('Optional. Determines whether the value is a secret and should be encrypted or not.')
  secret: bool?

  @secure()
  @maxLength(4096)
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
@description('The type of a service diagnostic.')
type serviceDiagnosticType = {
  @description('Required. Diagnostic Name.')
  name: string

  @description('Required. Logger resource ID.')
  loggerResourceId: string

  @description('Optional. Specifies for what type of messages sampling settings should not apply.')
  alwaysLog: string?

  @description('Optional. Diagnostic settings for incoming/outgoing HTTP messages to the Backend.')
  backend: resourceInput<'Microsoft.ApiManagement/service/diagnostics@2024-05-01'>.properties.backend?

  @description('Optional. Diagnostic settings for incoming/outgoing HTTP messages to the Gateway.')
  frontend: resourceInput<'Microsoft.ApiManagement/service/diagnostics@2024-05-01'>.properties.frontend?

  @description('Conditional. Sets correlation protocol to use for Application Insights diagnostics. Required if using Application Insights.')
  httpCorrelationProtocol: ('Legacy' | 'None' | 'W3C')?

  @description('Optional. Log the ClientIP.')
  logClientIp: bool?

  @description('Conditional. Emit custom metrics via emit-metric policy. Required if using Application Insights.')
  metrics: bool?

  @description('Optional. The format of the Operation Name for Application Insights telemetries.')
  operationNameFormat: ('Name' | 'Url')?

  @description('Optional. Rate of sampling for fixed-rate sampling. Specifies the percentage of requests that are logged.')
  samplingPercentage: int?

  @description('Optional. The verbosity level applied to traces emitted by trace policies.')
  verbosity: ('error' | 'information' | 'verbose')?
}

@export()
@description('The type of a subscription.')
type subscriptionType = {
  @description('Required. Subscription name.')
  name: string

  @minLength(1)
  @maxLength(100)
  @description('Required. API Management Service Subscriptions name.')
  displayName: string

  @description('Optional. Determines whether tracing can be enabled.')
  allowTracing: bool?

  @description('Optional. User (user ID path) for whom subscription is being created in form /users/{userId}.')
  ownerId: string?

  @minLength(1)
  @maxLength(256)
  @description('Optional. Primary subscription key. If not specified during request key will be generated automatically.')
  primaryKey: string?

  @description('Optional. Scope like "/products/{productId}" or "/apis" or "/apis/{apiId}".')
  scope: string?

  @minLength(1)
  @maxLength(256)
  @description('Optional. Secondary subscription key. If not specified during request key will be generated automatically.')
  secondaryKey: string?

  @description('''Optional. Initial subscription state. If no value is specified, subscription is created with Submitted state. Possible states are:
* active - the subscription is active
* suspended - the subscription is blocked, and the subscriber cannot call any APIs of the product
* submitted - the subscription request has been made by the developer, but has not yet been approved or rejected
* rejected - the subscription request has been denied by an administrator
* cancelled - the subscription has been cancelled by the developer or administrator
* expired - the subscription reached its expiration date and was deactivated.''')
  state: ('active' | 'cancelled' | 'expired' | 'rejected' | 'submitted' | 'suspended')?
}

import * as workspaceTypes from 'workspace/main.bicep'

@export()
@description('The type for API Management Workspaces.')
type workspaceType = {
  @description('Required. Workspace Name.')
  name: string

  @description('Required. Name of the workspace.')
  displayName: string

  @description('Optional. Description of the workspace.')
  description: string?

  @description('Optional. APIs to deploy in this workspace.')
  apis: workspaceTypes.apiType[]?

  @description('Optional. API Version Sets to deploy in this workspace.')
  apiVersionSets: workspaceTypes.apiVersionSetType[]?

  @description('Optional. Backends to deploy in this workspace.')
  backends: workspaceTypes.backendType[]?

  @description('Optional. Diagnostics to deploy in this workspace.')
  diagnostics: workspaceTypes.diagnosticType[]?

  @description('Optional. Loggers to deploy in this workspace.')
  loggers: workspaceTypes.loggerType[]?

  @description('Optional. Named values to deploy in this workspace.')
  namedValues: workspaceTypes.namedValueType[]?

  @description('Optional. Policies to deploy in this workspace.')
  policies: workspaceTypes.policyType[]?

  @description('Optional. Products to deploy in this workspace.')
  products: workspaceTypes.productType[]?

  @description('Optional. Subscriptions to deploy in this workspace.')
  subscriptions: workspaceTypes.subscriptionType[]?

  @description('Required. Gateway configuration for this workspace.')
  gateway: workspaceTypes.gatewayConfigType

  @description('Optional. Diagnostic settings for the workspace.')
  diagnosticSettings: diagnosticSettingFullType[]?

  @description('Optional. Role assignments for the workspace.')
  roleAssignments: roleAssignmentType[]?
}

import { productPolicyType } from 'product/main.bicep'

@export()
@description('The type of a product.')
type productType = {
  @minLength(1)
  @maxLength(256)
  @description('Required. Product Name.')
  name: string

  @minLength(1)
  @maxLength(300)
  @description('Required. Product display name.')
  displayName: string

  @description('Optional. Whether subscription approval is required. If false, new subscriptions will be approved automatically enabling developers to call the product\'s APIs immediately after subscribing. If true, administrators must manually approve the subscription before the developer can any of the product\'s APIs. Can be present only if subscriptionRequired property is present and has a value of false.')
  approvalRequired: bool?

  @maxLength(1000)
  @description('Optional. Product description. May include HTML formatting tags.')
  description: string?

  @description('Optional. Names of Product APIs.')
  apis: string[]?

  @description('Optional. Names of Product Groups.')
  groups: string[]?

  @description('Optional. Array of Policies to apply to the Service Product.')
  policies: productPolicyType[]?

  @description('Optional. Whether product is published or not. Published products are discoverable by users of developer portal. Non published products are visible only to administrators.')
  state: ('notPublished' | 'published')?

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
