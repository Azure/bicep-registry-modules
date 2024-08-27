metadata name = 'Network Application Gateways'
metadata description = 'This module deploys a Network Application Gateway.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the Application Gateway.')
@maxLength(80)
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentitiesType

@description('Optional. Authentication certificates of the application gateway resource.')
param authenticationCertificates array = []

@description('Optional. Upper bound on number of Application Gateway capacity.')
param autoscaleMaxCapacity int = -1

@description('Optional. Lower bound on number of Application Gateway capacity.')
param autoscaleMinCapacity int = -1

@description('Optional. Backend address pool of the application gateway resource.')
param backendAddressPools array = []

@description('Optional. Backend http settings of the application gateway resource.')
param backendHttpSettingsCollection array = []

@description('Optional. Custom error configurations of the application gateway resource.')
param customErrorConfigurations array = []

@description('Optional. Whether FIPS is enabled on the application gateway resource.')
param enableFips bool = false

@description('Optional. Whether HTTP2 is enabled on the application gateway resource.')
param enableHttp2 bool = false

@description('Optional. The resource ID of an associated firewall policy. Should be configured for security reasons.')
param firewallPolicyId string = ''

@description('Optional. Frontend IP addresses of the application gateway resource.')
param frontendIPConfigurations array = []

@description('Optional. Frontend ports of the application gateway resource.')
param frontendPorts array = []

@description('Optional. Subnets of the application gateway resource.')
param gatewayIPConfigurations array = []

@description('Optional. Enable request buffering.')
param enableRequestBuffering bool = false

@description('Optional. Enable response buffering.')
param enableResponseBuffering bool = false

@description('Optional. Http listeners of the application gateway resource.')
param httpListeners array = []

@description('Optional. Load distribution policies of the application gateway resource.')
param loadDistributionPolicies array = []

@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointType

@description('Optional. PrivateLink configurations on application gateway.')
param privateLinkConfigurations array = []

@description('Optional. Probes of the application gateway resource.')
param probes array = []

@description('Optional. Redirect configurations of the application gateway resource.')
param redirectConfigurations array = []

@description('Optional. Request routing rules of the application gateway resource.')
param requestRoutingRules array = []

@description('Optional. Rewrite rules for the application gateway resource.')
param rewriteRuleSets array = []

@description('Optional. The name of the SKU for the Application Gateway.')
@allowed([
  'Standard_Small'
  'Standard_Medium'
  'Standard_Large'
  'WAF_Medium'
  'WAF_Large'
  'Standard_v2'
  'WAF_v2'
])
param sku string = 'WAF_v2'

@description('Optional. The number of Application instances to be configured.')
@minValue(0)
@maxValue(10)
param capacity int = 2

@description('Optional. SSL certificates of the application gateway resource.')
param sslCertificates array = []

@description('Optional. Ssl cipher suites to be enabled in the specified order to application gateway.')
@allowed([
  'TLS_DHE_DSS_WITH_3DES_EDE_CBC_SHA'
  'TLS_DHE_DSS_WITH_AES_128_CBC_SHA'
  'TLS_DHE_DSS_WITH_AES_128_CBC_SHA256'
  'TLS_DHE_DSS_WITH_AES_256_CBC_SHA'
  'TLS_DHE_DSS_WITH_AES_256_CBC_SHA256'
  'TLS_DHE_RSA_WITH_AES_128_CBC_SHA'
  'TLS_DHE_RSA_WITH_AES_128_GCM_SHA256'
  'TLS_DHE_RSA_WITH_AES_256_CBC_SHA'
  'TLS_DHE_RSA_WITH_AES_256_GCM_SHA384'
  'TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA'
  'TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256'
  'TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256'
  'TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA'
  'TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384'
  'TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384'
  'TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA'
  'TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256'
  'TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256'
  'TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA'
  'TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384'
  'TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384'
  'TLS_RSA_WITH_3DES_EDE_CBC_SHA'
  'TLS_RSA_WITH_AES_128_CBC_SHA'
  'TLS_RSA_WITH_AES_128_CBC_SHA256'
  'TLS_RSA_WITH_AES_128_GCM_SHA256'
  'TLS_RSA_WITH_AES_256_CBC_SHA'
  'TLS_RSA_WITH_AES_256_CBC_SHA256'
  'TLS_RSA_WITH_AES_256_GCM_SHA384'
])
param sslPolicyCipherSuites array = [
  'TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384'
  'TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256'
]

@description('Optional. Ssl protocol enums.')
@allowed([
  'TLSv1_0'
  'TLSv1_1'
  'TLSv1_2'
  'TLSv1_3'
])
param sslPolicyMinProtocolVersion string = 'TLSv1_2'

@description('Optional. Ssl predefined policy name enums.')
@allowed([
  'AppGwSslPolicy20150501'
  'AppGwSslPolicy20170401'
  'AppGwSslPolicy20170401S'
  'AppGwSslPolicy20220101'
  'AppGwSslPolicy20220101S'
  ''
])
param sslPolicyName string = ''

@description('Optional. Type of Ssl Policy.')
@allowed([
  'Custom'
  'CustomV2'
  'Predefined'
])
param sslPolicyType string = 'Custom'

@description('Optional. SSL profiles of the application gateway resource.')
param sslProfiles array = []

@description('Optional. Trusted client certificates of the application gateway resource.')
param trustedClientCertificates array = []

@description('Optional. Trusted Root certificates of the application gateway resource.')
param trustedRootCertificates array = []

@description('Optional. URL path map of the application gateway resource.')
param urlPathMaps array = []

@description('Optional. Application gateway web application firewall configuration. Should be configured for security reasons.')
param webApplicationFirewallConfiguration object = {}

@description('Optional. A list of availability zones denoting where the resource needs to come from.')
param zones array = []

@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingType

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: !empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : null
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. Resource tags.')
param tags object?

@description('Optional. Backend settings of the application gateway resource. For default limits, see [Application Gateway limits](https://learn.microsoft.com/en-us/azure/azure-subscription-service-limits#application-gateway-limits).')
param backendSettingsCollection array = []

@description('Optional. Listeners of the application gateway resource. For default limits, see [Application Gateway limits](https://learn.microsoft.com/en-us/azure/azure-subscription-service-limits#application-gateway-limits).')
param listeners array = []

@description('Optional. Routing rules of the application gateway resource.')
param routingRules array = []

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
  'User Access Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  )
}

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.network-appgw.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource applicationGateway 'Microsoft.Network/applicationGateways@2023-04-01' = {
  name: name
  location: location
  tags: tags
  identity: identity
  properties: union(
    {
      authenticationCertificates: authenticationCertificates
      autoscaleConfiguration: autoscaleMaxCapacity > 0 && autoscaleMinCapacity >= 0
        ? {
            maxCapacity: autoscaleMaxCapacity
            minCapacity: autoscaleMinCapacity
          }
        : null
      backendAddressPools: backendAddressPools
      backendHttpSettingsCollection: backendHttpSettingsCollection
      backendSettingsCollection: backendSettingsCollection
      customErrorConfigurations: customErrorConfigurations
      enableHttp2: enableHttp2
      firewallPolicy: !empty(firewallPolicyId)
        ? {
            id: firewallPolicyId
          }
        : null
      forceFirewallPolicyAssociation: !empty(firewallPolicyId)
      frontendIPConfigurations: frontendIPConfigurations
      frontendPorts: frontendPorts
      gatewayIPConfigurations: gatewayIPConfigurations
      globalConfiguration: endsWith(sku, 'v2')
        ? {
            enableRequestBuffering: enableRequestBuffering
            enableResponseBuffering: enableResponseBuffering
          }
        : null
      httpListeners: httpListeners
      loadDistributionPolicies: loadDistributionPolicies
      listeners: listeners
      privateLinkConfigurations: privateLinkConfigurations
      probes: probes
      redirectConfigurations: redirectConfigurations
      requestRoutingRules: requestRoutingRules
      routingRules: routingRules
      rewriteRuleSets: rewriteRuleSets
      sku: {
        name: sku
        tier: endsWith(sku, 'v2') ? sku : substring(sku, 0, indexOf(sku, '_'))
        capacity: autoscaleMaxCapacity > 0 && autoscaleMinCapacity >= 0 ? null : capacity
      }
      sslCertificates: sslCertificates
      sslPolicy: sslPolicyType != 'Predefined'
        ? {
            cipherSuites: sslPolicyCipherSuites
            minProtocolVersion: sslPolicyMinProtocolVersion
            policyName: empty(sslPolicyName) ? null : sslPolicyName
            policyType: sslPolicyType
          }
        : {
            policyName: empty(sslPolicyName) ? null : sslPolicyName
            policyType: sslPolicyType
          }
      sslProfiles: sslProfiles
      trustedClientCertificates: trustedClientCertificates
      trustedRootCertificates: trustedRootCertificates
      urlPathMaps: urlPathMaps
    },
    (enableFips
      ? {
          enableFips: enableFips
        }
      : {}),
    (!empty(webApplicationFirewallConfiguration)
      ? { webApplicationFirewallConfiguration: webApplicationFirewallConfiguration }
      : {})
  )
  zones: zones
}

resource applicationGateway_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: applicationGateway
}

resource applicationGateway_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
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
    scope: applicationGateway
  }
]

module applicationGateway_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.4.1' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-applicationGateway-PrivateEndpoint-${index}'
    scope: resourceGroup(privateEndpoint.?resourceGroupName ?? '')
    params: {
      name: privateEndpoint.?name ?? 'pep-${last(split(applicationGateway.id, '/'))}-${privateEndpoint.service}-${index}'
      privateLinkServiceConnections: privateEndpoint.?isManualConnection != true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(applicationGateway.id, '/'))}-${privateEndpoint.service}-${index}'
              properties: {
                privateLinkServiceId: applicationGateway.id
                groupIds: [
                  privateEndpoint.service
                ]
              }
            }
          ]
        : null
      manualPrivateLinkServiceConnections: privateEndpoint.?isManualConnection == true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(applicationGateway.id, '/'))}-${privateEndpoint.service}-${index}'
              properties: {
                privateLinkServiceId: applicationGateway.id
                groupIds: [
                  privateEndpoint.service
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
      privateDnsZoneGroupName: privateEndpoint.?privateDnsZoneGroupName
      privateDnsZoneResourceIds: privateEndpoint.?privateDnsZoneResourceIds
      roleAssignments: privateEndpoint.?roleAssignments
      tags: privateEndpoint.?tags ?? tags
      customDnsConfigs: privateEndpoint.?customDnsConfigs
      ipConfigurations: privateEndpoint.?ipConfigurations
      applicationSecurityGroupResourceIds: privateEndpoint.?applicationSecurityGroupResourceIds
      customNetworkInterfaceName: privateEndpoint.?customNetworkInterfaceName
    }
  }
]

resource applicationGateway_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (roleAssignments ?? []): {
    name: guid(applicationGateway.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
    properties: {
      roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName)
        ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName]
        : contains(roleAssignment.roleDefinitionIdOrName, '/providers/Microsoft.Authorization/roleDefinitions/')
            ? roleAssignment.roleDefinitionIdOrName
            : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName)
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: applicationGateway
  }
]

@description('The name of the application gateway.')
output name string = applicationGateway.name

@description('The resource ID of the application gateway.')
output resourceId string = applicationGateway.id

@description('The resource group the application gateway was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = applicationGateway.location

// =============== //
//   Definitions   //
// =============== //

type managedIdentitiesType = {
  @description('Optional. The resource ID(s) to assign to the resource.')
  userAssignedResourceIds: string[]
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

  @description('Required. The subresource to deploy the private endpoint for. For example "blob", "table", "queue" or "file".')
  service: string

  @description('Required. Resource ID of the subnet where the endpoint needs to be created.')
  subnetResourceId: string

  @description('Optional. The name of the private DNS zone group to create if `privateDnsZoneResourceIds` were provided.')
  privateDnsZoneGroupName: string?

  @description('Optional. The private DNS zone groups to associate the private endpoint with. A DNS zone group can support up to 5 DNS zones.')
  privateDnsZoneResourceIds: string[]?

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
