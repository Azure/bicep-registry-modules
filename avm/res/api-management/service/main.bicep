metadata name = 'API Management Services'
metadata description = 'This module deploys an API Management Service.'
metadata owner = 'Azure/module-maintainers'

@description('Optional. Additional datacenter locations of the API Management service.')
param additionalLocations array = []

@description('Required. The name of the API Management service.')
param name string

@description('Optional. List of Certificates that need to be installed in the API Management service. Max supported certificates that can be installed is 10.')
@maxLength(10)
param certificates array = []

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. Custom properties of the API Management service.')
param customProperties object = {}

@description('Optional. Property only valid for an API Management service deployed in multiple locations. This can be used to disable the gateway in master region.')
param disableGateway bool = false

@description('Optional. Property only meant to be used for Consumption SKU Service. This enforces a client certificate to be presented on each request to the gateway. This also enables the ability to authenticate the certificate in the policy on the gateway.')
param enableClientCertificate bool = false

@description('Optional. Custom hostname configuration of the API Management service.')
param hostnameConfigurations array = []

@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentitiesType

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Limit control plane API calls to API Management service with version equal to or newer than this value.')
param minApiVersion string = ''

@description('Optional. The notification sender email address for the service.')
param notificationSenderEmail string = 'apimgmt-noreply@mail.windowsazure.com'

@description('Required. The email address of the owner of the service.')
param publisherEmail string

@description('Required. The name of the owner of the service.')
param publisherName string

@description('Optional. Undelete API Management Service if it was previously soft-deleted. If this flag is specified and set to True all other properties will be ignored.')
param restore bool = false

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. The pricing tier of this API Management service.')
@allowed([
  'Consumption'
  'Developer'
  'Basic'
  'Standard'
  'Premium'
])
param sku string = 'Developer'

@description('Optional. The instance size of this API Management service.')
@allowed([
  1
  2
])
param skuCount int = 1

@description('Optional. The full resource ID of a subnet in a virtual network to deploy the API Management service in.')
param subnetResourceId string = ''

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. The type of VPN in which API Management service needs to be configured in. None (Default Value) means the API Management service is not part of any Virtual Network, External means the API Management deployment is set up inside a Virtual Network having an internet Facing Endpoint, and Internal means that API Management deployment is setup inside a Virtual Network having an Intranet Facing Endpoint only.')
@allowed([
  'None'
  'External'
  'Internal'
])
param virtualNetworkType string = 'None'

@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingType

@description('Optional. A list of availability zones denoting where the resource needs to come from.')
param zones array = []

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

@description('Optional. Identity providers.')
param identityProviders array = []

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

var enableReferencedModulesTelemetry = false

var authorizationServerList = !empty(authorizationServers) ? authorizationServers.secureList : []

var formattedUserAssignedIdentities = reduce(map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }), {}, (cur, next) => union(cur, next)) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities) ? {
  type: (managedIdentities.?systemAssigned ?? false) ? (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned') : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : null)
  userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
} : null

var builtInRoleNames = {
  'API Management Developer Portal Content Editor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c031e6a8-4391-4de0-8d69-4706a7ed3729')
  'API Management Service Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '312a565d-c81f-4fd8-895a-4e21e48d571c')
  'API Management Service Operator Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'e022efe7-f5ba-4159-bbe4-b44f577e9b61')
  'API Management Service Reader Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '71522526-b88f-4d52-b57f-d31fc3546d0d')
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f58310d9-a9f6-439a-9e8d-f62e7b41a168')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
}

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource service 'Microsoft.ApiManagement/service@2021-08-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: sku
    capacity: skuCount
  }
  zones: zones
  identity: identity
  properties: {
    publisherEmail: publisherEmail
    publisherName: publisherName
    notificationSenderEmail: notificationSenderEmail
    hostnameConfigurations: hostnameConfigurations
    additionalLocations: additionalLocations
    customProperties: customProperties
    certificates: certificates
    enableClientCertificate: enableClientCertificate ? true : null
    disableGateway: disableGateway
    virtualNetworkType: virtualNetworkType
    virtualNetworkConfiguration: !empty(subnetResourceId) ? {
      subnetResourceId: subnetResourceId
    } : null
    apiVersionConstraint: !empty(minApiVersion) ? {
      minApiVersion: minApiVersion
    } : null
    restore: restore
  }
}

module service_apis 'api/main.bicep' = [for (api, index) in apis: {
  name: '${uniqueString(deployment().name, location)}-Apim-Api-${index}'
  params: {
    apiManagementServiceName: service.name
    displayName: api.displayName
    name: api.name
    path: api.path
    apiDescription: contains(api, 'apiDescription') ? api.apiDescription : ''
    apiRevision: contains(api, 'apiRevision') ? api.apiRevision : ''
    apiRevisionDescription: contains(api, 'apiRevisionDescription') ? api.apiRevisionDescription : ''
    apiType: contains(api, 'apiType') ? api.apiType : 'http'
    apiVersion: contains(api, 'apiVersion') ? api.apiVersion : ''
    apiVersionDescription: contains(api, 'apiVersionDescription') ? api.apiVersionDescription : ''
    apiVersionSetId: contains(api, 'apiVersionSetId') ? api.apiVersionSetId : ''
    authenticationSettings: contains(api, 'authenticationSettings') ? api.authenticationSettings : {}
    format: contains(api, 'format') ? api.format : 'openapi'
    isCurrent: contains(api, 'isCurrent') ? api.isCurrent : true
    protocols: contains(api, 'protocols') ? api.protocols : [
      'https'
    ]
    policies: contains(api, 'policies') ? api.policies : []
    serviceUrl: contains(api, 'serviceUrl') ? api.serviceUrl : ''
    sourceApiId: contains(api, 'sourceApiId') ? api.sourceApiId : ''
    subscriptionKeyParameterNames: contains(api, 'subscriptionKeyParameterNames') ? api.subscriptionKeyParameterNames : {}
    subscriptionRequired: contains(api, 'subscriptionRequired') ? api.subscriptionRequired : false
    type: contains(api, 'type') ? api.type : 'http'
    value: contains(api, 'value') ? api.value : ''
    wsdlSelector: contains(api, 'wsdlSelector') ? api.wsdlSelector : {}
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
  dependsOn: [
    service_apiVersionSets
  ]
}]

module service_apiVersionSets 'api-version-set/main.bicep' = [for (apiVersionSet, index) in apiVersionSets: {
  name: '${uniqueString(deployment().name, location)}-Apim-ApiVersionSet-${index}'
  params: {
    apiManagementServiceName: service.name
    name: apiVersionSet.name
    properties: contains(apiVersionSet, 'properties') ? apiVersionSet.properties : {}
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module service_authorizationServers 'authorization-server/main.bicep' = [for (authorizationServer, index) in authorizationServerList: {
  name: '${uniqueString(deployment().name, location)}-Apim-AuthorizationServer-${index}'
  params: {
    apiManagementServiceName: service.name
    name: authorizationServer.name
    authorizationEndpoint: authorizationServer.authorizationEndpoint
    authorizationMethods: contains(authorizationServer, 'authorizationMethods') ? authorizationServer.authorizationMethods : [
      'GET'
    ]
    bearerTokenSendingMethods: contains(authorizationServer, 'bearerTokenSendingMethods') ? authorizationServer.bearerTokenSendingMethods : [
      'authorizationHeader'
    ]
    clientAuthenticationMethod: contains(authorizationServer, 'clientAuthenticationMethod') ? authorizationServer.clientAuthenticationMethod : [
      'Basic'
    ]
    clientId: authorizationServer.clientId
    clientSecret: authorizationServer.clientSecret
    clientRegistrationEndpoint: contains(authorizationServer, 'clientRegistrationEndpoint') ? authorizationServer.clientRegistrationEndpoint : ''
    defaultScope: contains(authorizationServer, 'defaultScope') ? authorizationServer.defaultScope : ''
    grantTypes: authorizationServer.grantTypes
    resourceOwnerPassword: contains(authorizationServer, 'resourceOwnerPassword') ? authorizationServer.resourceOwnerPassword : ''
    resourceOwnerUsername: contains(authorizationServer, 'resourceOwnerUsername') ? authorizationServer.resourceOwnerUsername : ''
    serverDescription: contains(authorizationServer, 'serverDescription') ? authorizationServer.serverDescription : ''
    supportState: contains(authorizationServer, 'supportState') ? authorizationServer.supportState : false
    tokenBodyParameters: contains(authorizationServer, 'tokenBodyParameters') ? authorizationServer.tokenBodyParameters : []
    tokenEndpoint: contains(authorizationServer, 'tokenEndpoint') ? authorizationServer.tokenEndpoint : ''
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module service_backends 'backend/main.bicep' = [for (backend, index) in backends: {
  name: '${uniqueString(deployment().name, location)}-Apim-Backend-${index}'
  params: {
    apiManagementServiceName: service.name
    url: contains(backend, 'url') ? backend.url : ''
    description: contains(backend, 'description') ? backend.description : ''
    credentials: contains(backend, 'credentials') ? backend.credentials : {}
    name: backend.name
    protocol: contains(backend, 'protocol') ? backend.protocol : 'http'
    proxy: contains(backend, 'proxy') ? backend.proxy : {}
    resourceId: contains(backend, 'resourceId') ? backend.resourceId : ''
    serviceFabricCluster: contains(backend, 'serviceFabricCluster') ? backend.serviceFabricCluster : {}
    title: contains(backend, 'title') ? backend.title : ''
    tls: contains(backend, 'tls') ? backend.tls : {
      validateCertificateChain: false
      validateCertificateName: false
    }
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module service_caches 'cache/main.bicep' = [for (cache, index) in caches: {
  name: '${uniqueString(deployment().name, location)}-Apim-Cache-${index}'
  params: {
    apiManagementServiceName: service.name
    description: contains(cache, 'description') ? cache.description : ''
    connectionString: cache.connectionString
    name: cache.name
    resourceId: contains(cache, 'resourceId') ? cache.resourceId : ''
    useFromLocation: cache.useFromLocation
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module service_identityProviders 'identity-provider/main.bicep' = [for (identityProvider, index) in identityProviders: {
  name: '${uniqueString(deployment().name, location)}-Apim-IdentityProvider-${index}'
  params: {
    apiManagementServiceName: service.name
    name: identityProvider.name
    enableIdentityProviders: contains(identityProvider, 'enableIdentityProviders') ? identityProvider.enableIdentityProviders : false
    allowedTenants: contains(identityProvider, 'allowedTenants') ? identityProvider.allowedTenants : []
    authority: contains(identityProvider, 'authority') ? identityProvider.authority : ''
    clientId: contains(identityProvider, 'clientId') ? identityProvider.clientId : ''
    clientSecret: contains(identityProvider, 'clientSecret') ? identityProvider.clientSecret : ''
    passwordResetPolicyName: contains(identityProvider, 'passwordResetPolicyName') ? identityProvider.passwordResetPolicyName : ''
    profileEditingPolicyName: contains(identityProvider, 'profileEditingPolicyName') ? identityProvider.profileEditingPolicyName : ''
    signInPolicyName: contains(identityProvider, 'signInPolicyName') ? identityProvider.signInPolicyName : ''
    signInTenant: contains(identityProvider, 'signInTenant') ? identityProvider.signInTenant : ''
    signUpPolicyName: contains(identityProvider, 'signUpPolicyName') ? identityProvider.signUpPolicyName : ''
    type: contains(identityProvider, 'type') ? identityProvider.type : 'aad'
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module service_namedValues 'named-value/main.bicep' = [for (namedValue, index) in namedValues: {
  name: '${uniqueString(deployment().name, location)}-Apim-NamedValue-${index}'
  params: {
    apiManagementServiceName: service.name
    displayName: namedValue.displayName
    keyVault: contains(namedValue, 'keyVault') ? namedValue.keyVault : {}
    name: namedValue.name
    tags: namedValue.?tags // Note: these are not resource tags
    secret: contains(namedValue, 'secret') ? namedValue.secret : false
    value: contains(namedValue, 'value') ? namedValue.value : newGuidValue
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module service_portalsettings 'portalsetting/main.bicep' = [for (portalsetting, index) in portalsettings: {
  name: '${uniqueString(deployment().name, location)}-Apim-PortalSetting-${index}'
  params: {
    apiManagementServiceName: service.name
    name: portalsetting.name
    properties: contains(portalsetting, 'properties') ? portalsetting.properties : {}
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module service_policies 'policy/main.bicep' = [for (policy, index) in policies: {
  name: '${uniqueString(deployment().name, location)}-Apim-Policy-${index}'
  params: {
    apiManagementServiceName: service.name
    value: policy.value
    format: contains(policy, 'format') ? policy.format : 'xml'
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module service_products 'product/main.bicep' = [for (product, index) in products: {
  name: '${uniqueString(deployment().name, location)}-Apim-Product-${index}'
  params: {
    apiManagementServiceName: service.name
    apis: contains(product, 'apis') ? product.apis : []
    approvalRequired: contains(product, 'approvalRequired') ? product.approvalRequired : false
    groups: contains(product, 'groups') ? product.groups : []
    name: product.name
    description: contains(product, 'description') ? product.description : ''
    state: contains(product, 'state') ? product.state : 'published'
    subscriptionRequired: contains(product, 'subscriptionRequired') ? product.subscriptionRequired : false
    subscriptionsLimit: contains(product, 'subscriptionsLimit') ? product.subscriptionsLimit : 1
    terms: contains(product, 'terms') ? product.terms : ''
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
  dependsOn: [
    service_apis
  ]
}]

module service_subscriptions 'subscription/main.bicep' = [for (subscription, index) in subscriptions: {
  name: '${uniqueString(deployment().name, location)}-Apim-Subscription-${index}'
  params: {
    apiManagementServiceName: service.name
    name: contains(subscription, 'name') ? subscription.name : ''
    allowTracing: contains(subscription, 'allowTracing') ? subscription.allowTracing : false
    ownerId: contains(subscription, 'ownerId') ? subscription.ownerId : ''
    primaryKey: contains(subscription, 'primaryKey') ? subscription.primaryKey : ''
    scope: contains(subscription, 'scope') ? subscription.scope : '/apis'
    secondaryKey: contains(subscription, 'secondaryKey') ? subscription.secondaryKey : ''
    state: contains(subscription, 'state') ? subscription.state : ''
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

resource service_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot delete or modify the resource or child resources.'
  }
  scope: service
}

resource service_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [for (diagnosticSetting, index) in (diagnosticSettings ?? []): {
  name: diagnosticSetting.?name ?? '${name}-diagnosticSettings'
  properties: {
    storageAccountId: diagnosticSetting.?storageAccountResourceId
    workspaceId: diagnosticSetting.?workspaceResourceId
    eventHubAuthorizationRuleId: diagnosticSetting.?eventHubAuthorizationRuleResourceId
    eventHubName: diagnosticSetting.?eventHubName
    metrics: diagnosticSetting.?metricCategories ?? [
      {
        category: 'AllMetrics'
        timeGrain: null
        enabled: true
      }
    ]
    logs: diagnosticSetting.?logCategoriesAndGroups ?? [
      {
        categoryGroup: 'AllLogs'
        enabled: true
      }
    ]
    marketplacePartnerId: diagnosticSetting.?marketplacePartnerResourceId
    logAnalyticsDestinationType: diagnosticSetting.?logAnalyticsDestinationType
  }
  scope: service
}]

resource service_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (roleAssignment, index) in (roleAssignments ?? []): {
  name: guid(service.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : contains(roleAssignment.roleDefinitionIdOrName, '/providers/Microsoft.Authorization/roleDefinitions/') ? roleAssignment.roleDefinitionIdOrName : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName)
    principalId: roleAssignment.principalId
    description: roleAssignment.?description
    principalType: roleAssignment.?principalType
    condition: roleAssignment.?condition
    conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
    delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
  }
  scope: service
}]

@description('The name of the API management service.')
output name string = service.name

@description('The resource ID of the API management service.')
output resourceId string = service.id

@description('The resource group the API management service was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string = (managedIdentities.?systemAssigned ?? false) && contains(service.identity, 'principalId') ? service.identity.principalId : ''

@description('The location the resource was deployed into.')
output location string = service.location

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
  @description('Required. The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
  roleDefinitionIdOrName: string

  @description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
  principalId: string

  @description('Optional. The principal type of the assigned principal ID.')
  principalType: ('ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup' | 'Device')?

  @description('Optional. The description of the role assignment.')
  description: string?

  @description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container"')
  condition: string?

  @description('Optional. Version of the condition.')
  conditionVersion: '2.0'?

  @description('Optional. The Resource Id of the delegated managed identity resource.')
  delegatedManagedIdentityResourceId: string?
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

  @description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to \'\' to disable log collection.')
  metricCategories: {
    @description('Required. Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to \'AllMetrics\' to collect all metrics.')
    category: string
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
