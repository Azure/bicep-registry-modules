metadata name = 'Cognitive Services'
metadata description = 'This module deploys a Cognitive Service.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of Cognitive Services account.')
param name string

@description('Required. Kind of the Cognitive Services. Use \'Get-AzCognitiveServicesAccountSku\' to determine a valid combinations of \'kind\' and \'SKU\' for your Azure region.')
@allowed([
  'AIServices'
  'AnomalyDetector'
  'CognitiveServices'
  'ComputerVision'
  'ContentModerator'
  'ContentSafety'
  'ConversationalLanguageUnderstanding'
  'CustomVision.Prediction'
  'CustomVision.Training'
  'Face'
  'FormRecognizer'
  'HealthInsights'
  'ImmersiveReader'
  'Internal.AllInOne'
  'LUIS'
  'LUIS.Authoring'
  'LanguageAuthoring'
  'MetricsAdvisor'
  'OpenAI'
  'Personalizer'
  'QnAMaker.v2'
  'SpeechServices'
  'TextAnalytics'
  'TextTranslation'
])
param kind string

@description('Optional. SKU of the Cognitive Services resource. Use \'Get-AzCognitiveServicesAccountSku\' to determine a valid combinations of \'kind\' and \'SKU\' for your Azure region.')
@allowed([
  'C2'
  'C3'
  'C4'
  'F0'
  'F1'
  'S'
  'S0'
  'S1'
  'S10'
  'S2'
  'S3'
  'S4'
  'S5'
  'S6'
  'S7'
  'S8'
  'S9'
])
param sku string = 'S0'

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingType

@description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and networkAcls are not set.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string?

@description('Conditional. Subdomain name used for token-based authentication. Required if \'networkAcls\' or \'privateEndpoints\' are set.')
param customSubDomainName string?

@description('Optional. A collection of rules governing the accessibility from specific network locations.')
param networkAcls object?

@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointType

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. List of allowed FQDN.')
param allowedFqdnList array?

@description('Optional. The API properties for special APIs.')
param apiProperties object?

@description('Optional. Allow only Azure AD authentication. Should be enabled for security reasons.')
param disableLocalAuth bool = true

@description('Optional. The customer managed key definition.')
param customerManagedKey customerManagedKeyType

@description('Optional. The flag to enable dynamic throttling.')
param dynamicThrottlingEnabled bool = false

@description('Optional. Resource migration token.')
param migrationToken string?

@description('Optional. Restore a soft-deleted cognitive service at deployment time. Will fail if no such soft-deleted resource exists.')
param restore bool = false

@description('Optional. Restrict outbound network access.')
param restrictOutboundNetworkAccess bool = true

@description('Optional. The storage accounts for this resource.')
param userOwnedStorage array?

@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentitiesType

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Array of deployments about cognitive service accounts to create.')
param deployments deploymentsType

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
  'Cognitive Services Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '25fbc0a9-bd7c-42a3-aa1a-3b75d497ee68'
  )
  'Cognitive Services Custom Vision Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'c1ff6cc2-c111-46fe-8896-e0ef812ad9f3'
  )
  'Cognitive Services Custom Vision Deployment': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '5c4089e1-6d96-4d2f-b296-c1bc7137275f'
  )
  'Cognitive Services Custom Vision Labeler': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '88424f51-ebe7-446f-bc41-7fa16989e96c'
  )
  'Cognitive Services Custom Vision Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '93586559-c37d-4a6b-ba08-b9f0940c2d73'
  )
  'Cognitive Services Custom Vision Trainer': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '0a5ae4ab-0d65-4eeb-be61-29fc9b54394b'
  )
  'Cognitive Services Data Reader (Preview)': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'b59867f0-fa02-499b-be73-45a86b5b3e1c'
  )
  'Cognitive Services Face Recognizer': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '9894cab4-e18a-44aa-828b-cb588cd6f2d7'
  )
  'Cognitive Services Immersive Reader User': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'b2de6794-95db-4659-8781-7e080d3f2b9d'
  )
  'Cognitive Services Language Owner': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f07febfe-79bc-46b1-8b37-790e26e6e498'
  )
  'Cognitive Services Language Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '7628b7b8-a8b2-4cdc-b46f-e9b35248918e'
  )
  'Cognitive Services Language Writer': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f2310ca1-dc64-4889-bb49-c8e0fa3d47a8'
  )
  'Cognitive Services LUIS Owner': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f72c8140-2111-481c-87ff-72b910f6e3f8'
  )
  'Cognitive Services LUIS Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18e81cdc-4e98-4e29-a639-e7d10c5a6226'
  )
  'Cognitive Services LUIS Writer': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '6322a993-d5c9-4bed-b113-e49bbea25b27'
  )
  'Cognitive Services Metrics Advisor Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'cb43c632-a144-4ec5-977c-e80c4affc34a'
  )
  'Cognitive Services Metrics Advisor User': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '3b20f47b-3825-43cb-8114-4bd2201156a8'
  )
  'Cognitive Services OpenAI Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'a001fd3d-188f-4b5d-821b-7da978bf7442'
  )
  'Cognitive Services OpenAI User': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '5e0bd9bd-7b93-4f28-af87-19fc36ad61bd'
  )
  'Cognitive Services QnA Maker Editor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f4cc2bf9-21be-47a1-bdf1-5c5804381025'
  )
  'Cognitive Services QnA Maker Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '466ccd10-b268-4a11-b098-b4849f024126'
  )
  'Cognitive Services Speech Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '0e75ca1e-0464-4b4d-8b93-68208a576181'
  )
  'Cognitive Services Speech User': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f2dc8367-1007-4938-bd23-fe263f013447'
  )
  'Cognitive Services User': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'a97b65f3-24c7-4388-baec-2e87135dc908'
  )
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
  name: '46d3xbcp.res.cognitiveservices-account.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource cMKKeyVault 'Microsoft.KeyVault/vaults@2023-02-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId)) {
  name: last(split((customerManagedKey.?keyVaultResourceId ?? 'dummyVault'), '/'))
  scope: resourceGroup(
    split((customerManagedKey.?keyVaultResourceId ?? '//'), '/')[2],
    split((customerManagedKey.?keyVaultResourceId ?? '////'), '/')[4]
  )

  resource cMKKey 'keys@2023-02-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId) && !empty(customerManagedKey.?keyName)) {
    name: customerManagedKey.?keyName ?? 'dummyKey'
  }
}

resource cMKUserAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = if (!empty(customerManagedKey.?userAssignedIdentityResourceId)) {
  name: last(split(customerManagedKey.?userAssignedIdentityResourceId ?? 'dummyMsi', '/'))
  scope: resourceGroup(
    split((customerManagedKey.?userAssignedIdentityResourceId ?? '//'), '/')[2],
    split((customerManagedKey.?userAssignedIdentityResourceId ?? '////'), '/')[4]
  )
}

resource cognitiveService 'Microsoft.CognitiveServices/accounts@2023-05-01' = {
  name: name
  kind: kind
  identity: identity
  location: location
  tags: tags
  sku: {
    name: sku
  }
  properties: {
    customSubDomainName: customSubDomainName
    networkAcls: !empty(networkAcls ?? {})
      ? {
          defaultAction: networkAcls.?defaultAction
          virtualNetworkRules: networkAcls.?virtualNetworkRules ?? []
          ipRules: networkAcls.?ipRules ?? []
        }
      : null
    publicNetworkAccess: publicNetworkAccess != null
      ? publicNetworkAccess
      : (!empty(networkAcls) ? 'Enabled' : 'Disabled')
    allowedFqdnList: allowedFqdnList
    apiProperties: apiProperties
    disableLocalAuth: disableLocalAuth
    encryption: !empty(customerManagedKey)
      ? {
          keySource: 'Microsoft.KeyVault'
          keyVaultProperties: {
            identityClientId: !empty(customerManagedKey.?userAssignedIdentityResourceId ?? '')
              ? cMKUserAssignedIdentity.properties.clientId
              : null
            keyVaultUri: cMKKeyVault.properties.vaultUri
            keyName: customerManagedKey!.keyName
            keyVersion: !empty(customerManagedKey.?keyVersion ?? '')
              ? customerManagedKey!.keyVersion
              : last(split(cMKKeyVault::cMKKey.properties.keyUriWithVersion, '/'))
          }
        }
      : null
    migrationToken: migrationToken
    restore: restore
    restrictOutboundNetworkAccess: restrictOutboundNetworkAccess
    userOwnedStorage: userOwnedStorage
    dynamicThrottlingEnabled: dynamicThrottlingEnabled
  }
}

@batchSize(1)
resource cognitiveService_deployments 'Microsoft.CognitiveServices/accounts/deployments@2023-05-01' = [
  for (deployment, index) in (deployments ?? []): {
    parent: cognitiveService
    name: deployment.?name ?? '${name}-deployments'
    properties: {
      model: deployment.model
      raiPolicyName: deployment.?raiPolicyName
    }
    sku: deployment.?sku ?? {
      name: sku
    }
  }
]

resource cognitiveService_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: cognitiveService
}

resource cognitiveService_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
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
    scope: cognitiveService
  }
]

module cognitiveService_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.6.1' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-cognitiveService-PrivateEndpoint-${index}'
    scope: resourceGroup(privateEndpoint.?resourceGroupName ?? '')
    params: {
      name: privateEndpoint.?name ?? 'pep-${last(split(cognitiveService.id, '/'))}-${privateEndpoint.?service ?? 'account'}-${index}'
      privateLinkServiceConnections: privateEndpoint.?isManualConnection != true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(cognitiveService.id, '/'))}-${privateEndpoint.?service ?? 'account'}-${index}'
              properties: {
                privateLinkServiceId: cognitiveService.id
                groupIds: [
                  privateEndpoint.?service ?? 'account'
                ]
              }
            }
          ]
        : null
      manualPrivateLinkServiceConnections: privateEndpoint.?isManualConnection == true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(cognitiveService.id, '/'))}-${privateEndpoint.?service ?? 'account'}-${index}'
              properties: {
                privateLinkServiceId: cognitiveService.id
                groupIds: [
                  privateEndpoint.?service ?? 'account'
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

resource cognitiveService_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(cognitiveService.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: cognitiveService
  }
]

@description('The name of the cognitive services account.')
output name string = cognitiveService.name

@description('The resource ID of the cognitive services account.')
output resourceId string = cognitiveService.id

@description('The resource group the cognitive services account was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The service endpoint of the cognitive services account.')
output endpoint string = cognitiveService.properties.endpoint

@description('All endpoints available for the cognitive services account, types depends on the cognitive service kind.')
output endpoints endpointsType = cognitiveService.properties.endpoints

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string = cognitiveService.?identity.?principalId ?? ''

@description('The location the resource was deployed into.')
output location string = cognitiveService.location

// ================ //
// Definitions      //
// ================ //

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

type managedIdentitiesType = {
  @description('Optional. Enables system assigned managed identity on the resource.')
  systemAssigned: bool?

  @description('Optional. The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption.')
  userAssignedResourceIds: string[]?
}?

type customerManagedKeyType = {
  @description('Required. The resource ID of a key vault to reference a customer managed key for encryption from.')
  keyVaultResourceId: string

  @description('Required. The name of the customer managed key to use for encryption.')
  keyName: string

  @description('Optional. The version of the customer managed key to reference for encryption. If not provided, using \'latest\'.')
  keyVersion: string?

  @description('Optional. User assigned identity to use when fetching the customer managed key. Required if no system assigned identity is available for use.')
  userAssignedIdentityResourceId: string?
}?

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

type deploymentsType = {
  @description('Optional. Specify the name of cognitive service account deployment.')
  name: string?

  @description('Required. Properties of Cognitive Services account deployment model.')
  model: {
    @description('Required. The name of Cognitive Services account deployment model.')
    name: string

    @description('Required. The format of Cognitive Services account deployment model.')
    format: string

    @description('Required. The version of Cognitive Services account deployment model.')
    version: string
  }

  @description('Optional. The resource model definition representing SKU.')
  sku: {
    @description('Required. The name of the resource model definition representing SKU.')
    name: string

    @description('Optional. The capacity of the resource model definition representing SKU.')
    capacity: int?
  }?

  @description('Optional. The name of RAI policy.')
  raiPolicyName: string?
}[]?

type endpointsType = {
  @description('Type of the endpoint.')
  name: string?
  @description('The endpoint URI.')
  endpoint: string?
}?
