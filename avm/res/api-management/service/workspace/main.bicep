metadata name = 'API Management Service Workspace'
metadata description = 'This module deploys an API Management Service Workspace.'

@sys.description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@sys.description('Required. Workspace Name.')
param name string

@sys.description('Required. Name of the workspace.')
param displayName string

@sys.description('Optional. Description of the workspace.')
param description string?

@sys.description('Optional. APIs to deploy in this workspace.')
param apis apiType[]?

@sys.description('Optional. API Version Sets to deploy in this workspace.')
param apiVersionSets apiVersionSetType[]?

@sys.description('Optional. Backends to deploy in this workspace.')
param backends backendType[]?

@sys.description('Optional. Diagnostics to deploy in this workspace.')
param diagnostics diagnosticType[]?

@sys.description('Optional. Loggers to deploy in this workspace.')
param loggers loggerType[]?

@sys.description('Optional. Named values to deploy in this workspace.')
param namedValues namedValueType[]?

@sys.description('Optional. Policies to deploy in this workspace.')
param policies policyType[]?

@sys.description('Optional. Products to deploy in this workspace.')
param products productType[]?

@sys.description('Optional. Subscriptions to deploy in this workspace.')
param subscriptions subscriptionType[]?

@sys.description('Required. Gateway to deploy for this workspace.')
param gateway gatewayConfigType

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@sys.description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

import { diagnosticSettingLogsOnlyType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@sys.description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingLogsOnlyType[]?

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
  'API Management Service Workspace API Developer': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '9565a273-41b9-4368-97d2-aeb0c976a9b3'
  )
  'API Management Service Workspace API Product Manager': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'd59a3e9c-6d52-4a5a-aeed-6bf3cf0e31da'
  )
  'API Management Workspace API Developer': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '56328988-075d-4c6a-8766-d93edd6725b6'
  )
  'API Management Workspace API Product Manager': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '73c2c328-d004-4c5e-938c-35c6f5679a1f'
  )
  'API Management Workspace Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '0c34c906-8d99-4cb7-8bb7-33f5b0a1a799'
  )
  'API Management Workspace Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'ef1c2c96-4a77-49e8-b9a4-6179fe1d2fd2'
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

// ============== //
// Resources      //
// ============== //

resource service 'Microsoft.ApiManagement/service@2024-05-01' existing = {
  name: apiManagementServiceName
}

resource workspace 'Microsoft.ApiManagement/service/workspaces@2024-05-01' = {
  name: name
  parent: service
  properties: {
    displayName: displayName
    description: description
  }
}

module workspace_apis 'api/main.bicep' = [
  for (api, index) in (apis ?? []): {
    name: '${deployment().name}-Api-${index}'
    params: {
      apiManagementServiceName: apiManagementServiceName
      workspaceName: workspace.name
      name: api.name
      policies: api.?policies
      diagnostics: api.?diagnostics
      operations: api.?operations
      apiRevision: api.?apiRevision
      apiRevisionDescription: api.?apiRevisionDescription
      apiType: api.?apiType
      apiVersion: api.?apiVersion
      apiVersionDescription: api.?apiVersionDescription
      authenticationSettings: api.?authenticationSettings
      description: api.?description
      displayName: api.displayName
      format: api.?format
      isCurrent: api.?isCurrent
      path: api.path
      protocols: api.?protocols
      serviceUrl: api.?serviceUrl
      apiVersionSetName: api.?apiVersionSetName
      sourceApiId: api.?sourceApiId
      subscriptionKeyParameterNames: api.?subscriptionKeyParameterNames
      subscriptionRequired: api.?subscriptionRequired
      type: api.?type
      value: api.?value
      wsdlSelector: api.?wsdlSelector
    }
    dependsOn: [
      workspace_apiVersionSets
      workspace_loggers
    ]
  }
]

module workspace_apiVersionSets 'api-version-set/main.bicep' = [
  for (apiVersionSet, index) in (apiVersionSets ?? []): {
    name: '${deployment().name}-ApiVerSet-${index}'
    params: {
      apiManagementServiceName: apiManagementServiceName
      workspaceName: workspace.name
      name: apiVersionSet.name
      displayName: apiVersionSet.displayName
      versioningScheme: apiVersionSet.versioningScheme
      description: apiVersionSet.?description
      versionHeaderName: apiVersionSet.?versionHeaderName
      versionQueryName: apiVersionSet.?versionQueryName
    }
  }
]

module workspace_backends 'backend/main.bicep' = [
  for (backend, index) in (backends ?? []): {
    name: '${deployment().name}-Bcknd-${index}'
    params: {
      apiManagementServiceName: apiManagementServiceName
      workspaceName: workspace.name
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
      circuitBreaker: backend.?circuitBreaker
      pool: backend.?pool
      type: backend.?type
    }
  }
]

module workspace_diagnostics 'diagnostic/main.bicep' = [
  for (diagnostic, index) in (diagnostics ?? []): {
    name: '${deployment().name}-Diag-${index}'
    params: {
      apiManagementServiceName: apiManagementServiceName
      workspaceName: workspace.name
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
      workspace_loggers
    ]
  }
]

module workspace_loggers 'logger/main.bicep' = [
  for (logger, index) in (loggers ?? []): {
    name: '${deployment().name}-Logg-${index}'
    params: {
      apiManagementServiceName: apiManagementServiceName
      workspaceName: workspace.name
      name: logger.name
      credentials: logger.?credentials
      isBuffered: logger.?isBuffered
      description: logger.?description
      type: logger.type
      targetResourceId: logger.?targetResourceId
    }
    dependsOn: [
      workspace_namedValues
    ]
  }
]

module workspace_namedValues 'named-value/main.bicep' = [
  for (namedValue, index) in (namedValues ?? []): {
    name: '${deployment().name}-NamVal-${index}'
    params: {
      apiManagementServiceName: apiManagementServiceName
      workspaceName: workspace.name
      displayName: namedValue.displayName
      keyVault: namedValue.?keyVault
      name: namedValue.name
      tags: namedValue.?tags
      secret: namedValue.?secret
      value: namedValue.?value
    }
  }
]

module workspace_policies 'policy/main.bicep' = [
  for (policy, index) in (policies ?? []): {
    name: '${deployment().name}-Pol-${index}'
    params: {
      apiManagementServiceName: apiManagementServiceName
      workspaceName: workspace.name
      name: policy.?name
      format: policy.?format
      value: policy.value
    }
  }
]

module workspace_products 'product/main.bicep' = [
  for (product, index) in (products ?? []): {
    name: '${deployment().name}-Prd-${index}'
    params: {
      apiManagementServiceName: apiManagementServiceName
      workspaceName: workspace.name
      name: product.name
      displayName: product.displayName
      approvalRequired: product.?approvalRequired
      description: product.?description
      apiLinks: product.?apiLinks
      groupLinks: product.?groupLinks
      policies: product.?policies
      state: product.?state
      subscriptionRequired: product.?subscriptionRequired
      subscriptionsLimit: product.?subscriptionsLimit
      terms: product.?terms
    }
    dependsOn: [
      workspace_apis
    ]
  }
]

module workspace_subscriptions 'subscription/main.bicep' = [
  for (subscription, index) in (subscriptions ?? []): {
    name: '${deployment().name}-Sub-${index}'
    params: {
      apiManagementServiceName: apiManagementServiceName
      workspaceName: workspace.name
      name: subscription.name
      displayName: subscription.displayName
      allowTracing: subscription.?allowTracing
      ownerId: subscription.?ownerId
      primaryKey: subscription.?primaryKey
      scope: subscription.?scope
      secondaryKey: subscription.?secondaryKey
      state: subscription.?state
    }
    dependsOn: [
      workspace_apis
      workspace_products
    ]
  }
]

module workspace_gateway 'modules/gateway.bicep' = {
  name: '${deployment().name}-Gw'
  params: {
    name: gateway.name
    location: gateway.?location
    capacity: gateway.?capacity
    virtualNetworkType: gateway.?virtualNetworkType
    subnetResourceId: gateway.?subnetResourceId
    workspaceResourceId: workspace.id
  }
}

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

resource workspace_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
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
    scope: workspace
  }
]

@sys.description('The name of the API management workspace.')
output name string = workspace.name

@sys.description('The resource ID of the API management workspace.')
output resourceId string = workspace.id

@sys.description('The resource group the API management workspace was deployed into.')
output resourceGroupName string = resourceGroup().name

// =============== //
//   Definitions   //
// =============== //

import * as workspaceApiTypes from 'api/main.bicep'

@export()
@sys.description('The type of an API Management workspace API.')
type apiType = {
  @sys.description('Required. API revision identifier. Must be unique in the current API Management workspace. Non-current revision has ;rev=n as a suffix where n is the revision number.')
  @minLength(1)
  @maxLength(256)
  name: string

  @sys.description('Optional. Array of Policies to apply to the Service API.')
  policies: workspaceApiTypes.policyType[]?

  @sys.description('Optional. Array of diagnostics to apply to the Service API.')
  diagnostics: workspaceApiTypes.diagnosticType[]?

  @sys.description('Optional. The operations of the api.')
  operations: workspaceApiTypes.operationType[]?

  @sys.description('Optional. Describes the Revision of the API. If no value is provided, default revision 1 is created.')
  @minLength(1)
  @maxLength(100)
  apiRevision: string?

  @sys.description('Optional. Description of the API Revision.')
  @maxLength(256)
  apiRevisionDescription: string?

  @sys.description('''Optional. Type of API to create.
* `http` creates a REST API
* `soap` creates a SOAP pass-through API
* `websocket` creates websocket API
* `graphql` creates GraphQL API.''')
  apiType: ('graphql' | 'http' | 'soap' | 'websocket')?

  @sys.description('Optional. Indicates the Version identifier of the API if the API is versioned.')
  @maxLength(100)
  apiVersion: string?

  @sys.description('Optional. Description of the API Version.')
  @maxLength(256)
  apiVersionDescription: string?

  @sys.description('Optional. Collection of authentication settings included into this API.')
  authenticationSettings: resourceInput<'Microsoft.ApiManagement/service/workspaces/apis@2024-05-01'>.properties.authenticationSettings?

  @sys.description('Optional. Description of the API. May include HTML formatting tags.')
  description: string?

  @sys.description('Required. API display name.')
  @maxLength(300)
  displayName: string

  @sys.description('Optional. Format of the Content in which the API is getting imported.')
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

  @sys.description('Optional. Indicates if API revision is current API revision.')
  isCurrent: bool?

  @sys.description('Required. Relative URL uniquely identifying this API and all of its resource paths within the API Management service instance. It is appended to the API endpoint base URL specified during the service instance creation to form a public URL for this API.')
  @maxLength(400)
  path: string

  @sys.description('Optional. Describes on which protocols the operations in this API can be invoked.')
  protocols: string[]?

  @sys.description('Optional. Absolute URL of the backend service implementing this API.')
  @maxLength(2000)
  serviceUrl: string?

  @sys.description('Optional. The name of the API version set to link.')
  apiVersionSetName: string?

  @sys.description('Optional. API identifier of the source API.')
  sourceApiId: string?

  @sys.description('Optional. Protocols over which API is made available.')
  subscriptionKeyParameterNames: resourceInput<'Microsoft.ApiManagement/service/workspaces/apis@2024-05-01'>.properties.subscriptionKeyParameterNames?

  @sys.description('Optional. Specifies whether an API or Product subscription is required for accessing the API.')
  subscriptionRequired: bool?

  @sys.description('Optional. Type of API.')
  type: ('graphql' | 'grpc' | 'http' | 'odata' | 'soap' | 'websocket')?

  @sys.description('Optional. Content value when Importing an API.')
  value: string?

  @sys.description('Optional. Criteria to limit import of WSDL to a subset of the document.')
  wsdlSelector: resourceInput<'Microsoft.ApiManagement/service/workspaces/apis@2024-05-01'>.properties.wsdlSelector?
}

@export()
@sys.description('The type of an API Management workspace API Version Set.')
type apiVersionSetType = {
  @sys.description('Required. API Version set name.')
  name: string

  @sys.description('Required. The display name of the API Version Set.')
  @minLength(1)
  @maxLength(100)
  displayName: string

  @sys.description('Required. An value that determines where the API Version identifier will be located in a HTTP request.')
  versioningScheme: ('Header' | 'Query' | 'Segment')

  @sys.description('Optional. Description of API Version Set.')
  description: string?

  @sys.description('Optional. Name of HTTP header parameter that indicates the API Version if versioningScheme is set to header.')
  @minLength(1)
  @maxLength(100)
  versionHeaderName: string?

  @sys.description('Optional. Name of query parameter that indicates the API Version if versioningScheme is set to query.')
  @minLength(1)
  @maxLength(100)
  versionQueryName: string?
}

@export()
@sys.description('The type of an API Management workspace Backend.')
type backendType = {
  @sys.description('Required. Backend Name.')
  name: string

  @sys.description('Optional. Backend Credentials Contract Properties. Not supported for Backend Pools.')
  credentials: resourceInput<'Microsoft.ApiManagement/service/workspaces/backends@2024-05-01'>.properties.credentials?

  @sys.description('Optional. Backend Description.')
  description: string?

  @sys.description('Optional. Backend communication protocol. http or soap. Not supported for Backend Pools.')
  protocol: string?

  @sys.description('Optional. Backend Proxy Contract Properties. Not supported for Backend Pools.')
  proxy: resourceInput<'Microsoft.ApiManagement/service/workspaces/backends@2024-05-01'>.properties.proxy?

  @sys.description('Optional. Management Uri of the Resource in External System. This URL can be the Arm Resource ID of Logic Apps, Function Apps or API Apps. Not supported for Backend Pools.')
  resourceId: string?

  @sys.description('Optional. Backend Service Fabric Cluster Properties. Not supported for Backend Pools.')
  serviceFabricCluster: resourceInput<'Microsoft.ApiManagement/service/workspaces/backends@2024-05-01'>.properties.properties.serviceFabricCluster?

  @sys.description('Optional. Backend Title.')
  title: string?

  @sys.description('Optional. Backend TLS Properties. Not supported for Backend Pools. If not specified and type is Single, TLS properties will default to validateCertificateChain and validateCertificateName set to true.')
  tls: resourceInput<'Microsoft.ApiManagement/service/workspaces/backends@2024-05-01'>.properties.tls?

  @sys.description('Conditional. Runtime URL of the Backend. Required if type is Single and not supported if type is Pool.')
  @minLength(1)
  @maxLength(2000)
  url: string?

  @sys.description('Optional. Backend Circuit Breaker Configuration. Not supported for Backend Pools.')
  circuitBreaker: resourceInput<'Microsoft.ApiManagement/service/workspaces/backends@2024-05-01'>.properties.circuitBreaker?

  @sys.description('Conditional. Backend pool configuration for load balancing. Required if type is Pool and not supported if type is Single.')
  pool: resourceInput<'Microsoft.ApiManagement/service/workspaces/backends@2024-05-01'>.properties.pool?

  @sys.description('Optional. Type of the backend. A backend can be either Single or Pool.')
  type: ('Single' | 'Pool')?
}

@export()
@sys.description('The type of an API Management workspace Diagnostic.')
type diagnosticType = {
  @sys.description('Required. Diagnostic Name.')
  name: string

  @sys.description('Required. Logger resource ID.')
  loggerResourceId: string

  @sys.description('Optional. Specifies for what type of messages sampling settings should not apply.')
  alwaysLog: string?

  @sys.description('Optional. Diagnostic settings for incoming/outgoing HTTP messages to the Backend.')
  backend: resourceInput<'Microsoft.ApiManagement/service/workspaces/diagnostics@2024-05-01'>.properties.backend?

  @sys.description('Optional. Diagnostic settings for incoming/outgoing HTTP messages to the Gateway.')
  frontend: resourceInput<'Microsoft.ApiManagement/service/workspaces/diagnostics@2024-05-01'>.properties.frontend?

  @sys.description('Conditional. Sets correlation protocol to use for Application Insights diagnostics. Required if using Application Insights.')
  httpCorrelationProtocol: ('Legacy' | 'None' | 'W3C')?

  @sys.description('Optional. Log the ClientIP.')
  logClientIp: bool?

  @sys.description('Conditional. Emit custom metrics via emit-metric policy. Required if using Application Insights.')
  metrics: bool?

  @sys.description('Optional. The format of the Operation Name for Application Insights telemetries.')
  operationNameFormat: ('Name' | 'Url')?

  @sys.description('Optional. Rate of sampling for fixed-rate sampling. Specifies the percentage of requests that are logged.')
  samplingPercentage: int?

  @sys.description('Optional. The verbosity level applied to traces emitted by trace policies.')
  verbosity: ('error' | 'information' | 'verbose')?
}

@export()
@sys.description('The type of an API Management workspace Logger.')
type loggerType = {
  @sys.description('Required. Logger name.')
  name: string

  @sys.description('Optional. Description of the logger.')
  @maxLength(256)
  description: string?

  @sys.description('Optional. Whether records are buffered in the logger before publishing.')
  isBuffered: bool?

  @sys.description('Required. Logger type.')
  type: ('applicationInsights' | 'azureEventHub' | 'azureMonitor')

  @sys.description('Conditional. Azure Resource Id of a log target (either Azure Event Hub resource or Azure Application Insights resource). Required if loggerType = applicationInsights or azureEventHub.')
  targetResourceId: string?

  @sys.description('Conditional. The name and SendRule connection string of the event hub for azureEventHub logger. Instrumentation key for applicationInsights logger. Required if loggerType = applicationInsights or azureEventHub, ignored if loggerType = azureMonitor.')
  credentials: resourceInput<'Microsoft.ApiManagement/service/workspaces/loggers@2024-05-01'>.properties.credentials?
}

@export()
@sys.description('The type of an API Management workspace Named Value.')
type namedValueType = {
  @sys.description('Required. Unique name of NamedValue. It may contain only letters, digits, period, dash, and underscore characters.')
  @minLength(1)
  @maxLength(256)
  displayName: string

  @sys.description('Optional. KeyVault location details of the namedValue.')
  keyVault: resourceInput<'Microsoft.ApiManagement/service/workspaces/namedValues@2024-05-01'>.properties.keyVault?

  @sys.description('Required. The name of the named value.')
  name: string

  @sys.description('Optional. Tags that when provided can be used to filter the NamedValue list.')
  tags: resourceInput<'Microsoft.ApiManagement/service/workspaces/namedValues@2024-05-01'>.properties.tags?

  @sys.description('Optional. Determines whether the value is a secret and should be encrypted or not.')
  secret: bool?

  @sys.description('Optional. Value of the NamedValue. Can contain policy expressions. It may not be empty or consist only of whitespace. This property will not be filled on \'GET\' operations! Use \'/listSecrets\' POST request to get the value.')
  @maxLength(4096)
  value: string?
}

@export()
@sys.description('The type of an API Management workspace Policy.')
type policyType = {
  @sys.description('Optional. The name of the policy.')
  name: string?

  @sys.description('Optional. Format of the policyContent.')
  format: ('rawxml' | 'rawxml-link' | 'xml' | 'xml-link')?

  @sys.description('Required. Contents of the Policy as defined by the format.')
  value: string
}

import * as workspaceProductTypes from 'product/main.bicep'

@export()
@sys.description('The type of an API Management workspace Product.')
type productType = {
  @sys.description('Required. Product Name.')
  @minLength(1)
  @maxLength(256)
  name: string

  @sys.description('Required. Product display name.')
  @minLength(1)
  @maxLength(300)
  displayName: string

  @sys.description('Optional. Whether subscription approval is required. If false, new subscriptions will be approved automatically enabling developers to call the product\'s APIs immediately after subscribing. If true, administrators must manually approve the subscription before the developer can any of the product\'s APIs. Can be present only if subscriptionRequired property is present and has a value of false.')
  approvalRequired: bool?

  @sys.description('Optional. Product description. May include HTML formatting tags.')
  @maxLength(1000)
  description: string?

  @sys.description('Optional. Names of Product API Links.')
  apiLinks: workspaceProductTypes.apiLinkType[]?

  @sys.description('Optional. Names of Product Group Links.')
  groupLinks: workspaceProductTypes.groupLinkType[]?

  @sys.description('Optional. Array of Policies to apply to the Product.')
  policies: workspaceProductTypes.productPolicyType[]?

  @sys.description('Optional. Whether product is published or not. Published products are discoverable by users of developer portal. Non published products are visible only to administrators.')
  state: ('notPublished' | 'published')?

  @sys.description('Optional. Whether a product subscription is required for accessing APIs included in this product. If true, the product is referred to as "protected" and a valid subscription key is required for a request to an API included in the product to succeed. If false, the product is referred to as "open" and requests to an API included in the product can be made without a subscription key. If property is omitted when creating a new product it\'s value is assumed to be true.')
  subscriptionRequired: bool?

  @sys.description('Optional. Whether the number of subscriptions a user can have to this product at the same time. Set to null or omit to allow unlimited per user subscriptions. Can be present only if subscriptionRequired property is present and has a value of false.')
  subscriptionsLimit: int?

  @sys.description('Optional. Product terms of use. Developers trying to subscribe to the product will be presented and required to accept these terms before they can complete the subscription process.')
  terms: string?
}

@export()
@sys.description('The type of an API Management workspace Subscription.')
type subscriptionType = {
  @sys.description('Required. Subscription name.')
  name: string

  @sys.description('Required. API Management Service Subscriptions name.')
  @minLength(1)
  @maxLength(100)
  displayName: string

  @sys.description('Optional. Determines whether tracing can be enabled.')
  allowTracing: bool?

  @sys.description('Optional. User (user ID path) for whom subscription is being created in form /users/{userId}.')
  ownerId: string?

  @sys.description('Optional. Primary subscription key. If not specified during request key will be generated automatically.')
  @minLength(1)
  @maxLength(256)
  primaryKey: string?

  @sys.description('Optional. Scope like "/products/{productId}" or "/apis" or "/apis/{apiId}".')
  scope: string?

  @sys.description('Optional. Secondary subscription key. If not specified during request key will be generated automatically.')
  @minLength(1)
  @maxLength(256)
  secondaryKey: string?

  @sys.description('''Optional. Initial subscription state. If no value is specified, subscription is created with Submitted state. Possible states are:
* active - the subscription is active
* suspended - the subscription is blocked, and the subscriber cannot call any APIs of the product
* submitted - the subscription request has been made by the developer, but has not yet been approved or rejected
* rejected - the subscription request has been denied by an administrator
* cancelled - the subscription has been cancelled by the developer or administrator
* expired - the subscription reached its expiration date and was deactivated.''')
  state: ('active' | 'cancelled' | 'expired' | 'rejected' | 'submitted' | 'suspended')?
}

@export()
@sys.description('The type of an API Management workspace Gateway configuration.')
type gatewayConfigType = {
  @sys.description('Required. Gateway name.')
  name: string

  @sys.description('Optional. Location where the gateway will be deployed.')
  location: string?

  @sys.description('Optional. Gateway SKU capacity. Defaults to 1.')
  @minValue(1)
  @maxValue(32)
  capacity: int?

  @sys.description('Optional. Virtual Network Type of the gateway. Defaults to None.')
  virtualNetworkType: ('External' | 'Internal' | 'None')?

  @sys.description('Conditional. The resource ID of the subnet to associate with the gateway backend. Required if virtualNetworkType is External or Internal. The subnet must be in the same region and subscription as the APIM instance and must be delegated to the required service: `Microsoft.Web/serverFarms` for External virtualNetworkType, `Microsoft.Web/hostingEnvironments` for Internal virtualNetworkType.')
  subnetResourceId: string?
}
