@minLength(5)
@maxLength(50)
@description('The name of the Azure Container Registry.')
param name string

@description('Location for all resources.')
param location string = resourceGroup().location

@description('Tags for all resource(s).')
param tags object = {}

@description('The SKU of the Azure Container Registry.')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param skuName string = 'Basic'

@description('Toggle the Azure Container Registry admin user.')
param adminUserEnabled bool = false

@description('Toggle public network access to Azure Container Registry.')
param publicNetworkAccessEnabled bool = true

@description('When public network access is disabled, toggle this to allow Azure services to bypass the public network access rule.')
param publicAzureAccessEnabled bool = true

@description('A list of IP or IP ranges in CIDR format, that should be allowed access to Azure Container Registry.')
param networkAllowedIpRanges array = []

@description('The default action to take when no network rule match is found for accessing Azure Container Registry.')
@allowed([
  'Allow'
  'Deny'
])
param networkDefaultAction string = 'Deny'

@description('Array of role assignment objects that contain the \'roleDefinitionIdOrName\'(string) and \'principalIds\'(array of strings) to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Specify the type of lock.')
param lock string = 'NotSpecified'

@description('Define Private Endpoints that should be created for Azure Container Registry.')
param privateEndpoints array = []

@description('Toggle if Private Endpoints manual approval for Azure Container Registry should be enabled.')
param privateEndpointsApprovalEnabled bool = false

@description('Toggle if Zone Redundancy should be enabled on Azure Container Registry.')
param zoneRedundancyEnabled bool = false

@description('Array of Azure Location configurations that this Azure Container Registry should replicate too.')
param replicationLocations array = []

@description('Toggle if a single data endpoint per region for serving data from Azure Container Registry should be enabled.')
param dataEndpointEnabled bool = false

@description('Toggle if encryption should be enabled on Azure Container Registry.')
param encryptionEnabled bool = false

@description('Toggle if export policy should be enabled on Azure Container Registry.')
param exportPolicyEnabled bool = false

@description('Toggle if quarantine policy should be enabled on Azure Container Registry.')
param quarantinePolicyEnabled bool = false

@description('Toggle if retention policy should be enabled on Azure Container Registry.')
param retentionPolicyEnabled bool = false

@description('Configure the retention policy in days for Azure Container Registry. Only effective is \'retentionPolicyEnabled\' is \'true\'.')
param retentionPolicyInDays int = 10

@description('Toggle if trust policy should be enabled on Azure Container Registry.')
param trustPolicyEnabled bool = false

@description('The client ID of the identity which will be used to access Key Vault.')
param encryptionKeyVaultIdentity string = ''

@description('The Key Vault URI to access the encryption key.')
param encryptionKeyVaultKeyIdentifier string = ''

@description('Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
param diagnosticLogsRetentionInDays int = 365

@description('Resource ID of the diagnostic storage account.')
param diagnosticStorageAccountId string = ''

@description('Resource ID of the diagnostic log analytics workspace.')
param diagnosticWorkspaceId string = ''

@description('Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param diagnosticEventHubAuthorizationRuleId string = ''

@description('Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param diagnosticEventHubName string = ''

@description('The name of logs that will be streamed.')
@allowed([
  'ContainerRegistryRepositoryEvents'
  'ContainerRegistryLoginEvents'
])
param logsToEnable array = [
  'ContainerRegistryRepositoryEvents'
  'ContainerRegistryLoginEvents'
]

@description('The name of metrics that will be streamed.')
@allowed([
  'AllMetrics'
])
param metricsToEnable array = [
  'AllMetrics'
]

var diagnosticsLogs = [for log in logsToEnable: {
  category: log
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

var diagnosticsMetrics = [for metric in metricsToEnable: {
  category: metric
  timeGrain: null
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

var varNetworkAllowedIpRanges = [for item in networkAllowedIpRanges: {
  value: item
  action: 'Allow'
}]

var IS_PREMIUM_SKU = skuName == 'Premium'

var varPrivateEndpoints = [for privateEndpoint in privateEndpoints: {
  name: '${privateEndpoint.name}-${containerRegistry.name}'
  privateLinkServiceId: containerRegistry.id
  groupIds: [
    'registry'
  ]
  subnetId: privateEndpoint.subnetId
  privateDnsZones: contains(privateEndpoint, 'privateDnsZoneId') ? [
    {
      name: 'default'
      zoneId: privateEndpoint.privateDnsZoneId
    }
  ] : []
}]

var varReplicationLocations = [for replicationLocation in replicationLocations: {
  location: replicationLocation.location
  regionEndpointEnabled: contains(replicationLocation, 'regionEndpointEnabled') ? replicationLocation.regionEndpointEnabled : false
  zoneRedundancy: contains(replicationLocation, 'zoneRedundancy') ? replicationLocation.zoneRedundancy : false
}]

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2021-09-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: skuName
  }
  properties: {
    adminUserEnabled: adminUserEnabled
    publicNetworkAccess: IS_PREMIUM_SKU ? publicNetworkAccessEnabled ? 'Enabled' : 'Disabled' : null
    networkRuleBypassOptions: IS_PREMIUM_SKU ? publicAzureAccessEnabled ? 'AzureServices' : 'None' : null
    networkRuleSet: IS_PREMIUM_SKU ? {
      defaultAction: networkDefaultAction
      ipRules: varNetworkAllowedIpRanges
    } : null
    dataEndpointEnabled: dataEndpointEnabled
    encryption: IS_PREMIUM_SKU ? encryptionEnabled ? {
      keyVaultProperties: {
        identity: encryptionKeyVaultIdentity
        keyIdentifier: encryptionKeyVaultKeyIdentifier
      }
      status: 'enabled'
    } : null : null
    zoneRedundancy: IS_PREMIUM_SKU ? zoneRedundancyEnabled ? 'Enabled' : 'Disabled' : null
    policies: {
      exportPolicy: publicAzureAccessEnabled == 'false' ? {
        status: exportPolicyEnabled ? 'enabled' : 'disabled'
      } : null
      quarantinePolicy: {
        status: quarantinePolicyEnabled ? 'enabled' : 'disabled'
      }
      retentionPolicy: IS_PREMIUM_SKU ? retentionPolicyEnabled ? {
        days: retentionPolicyInDays
        status: 'enabled'
      } : null : null
      trustPolicy: IS_PREMIUM_SKU ? trustPolicyEnabled ? {
        status: 'enabled'
        type: 'Notary'
      } : null : null
    }
  }
}

resource replications 'Microsoft.ContainerRegistry/registries/replications@2021-09-01' = [for replicationLocation in varReplicationLocations: if (IS_PREMIUM_SKU) {
  name: replicationLocation.location
  parent: containerRegistry
  location: replicationLocation.location
  tags: tags
  properties: {
    regionEndpointEnabled: replicationLocation.regionEndpointEnabled
    zoneRedundancy: replicationLocation.zoneRedundancy ? 'Enabled' : 'Disabled'
  }
}]

resource containerRegistry_lock 'Microsoft.Authorization/locks@2020-05-01' = if (lock != 'NotSpecified') {
  name: '${containerRegistry.name}-${lock}-lock'
  properties: {
    level: lock
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: containerRegistry
}

resource containerRegistry_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (!empty(diagnosticStorageAccountId) || !empty(diagnosticWorkspaceId) || !empty(diagnosticEventHubAuthorizationRuleId) || !empty(diagnosticEventHubName)) {
  name: '${containerRegistry.name}-diagnosticSettings'
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    metrics: diagnosticsMetrics
    logs: diagnosticsLogs
  }
  scope: containerRegistry
}

module containerRegistry_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-acr-rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    resourceId: containerRegistry.id
  }
}]

module containerRegistry_privateEndpoint '.bicep/nested_privateEndpoint.bicep' = {
  name: '${uniqueString(deployment().name, location)}-acr-private-endpoints'
  params: {
    location: location
    privateEndpoints: varPrivateEndpoints
    tags: tags
    manualApprovalEnabled: privateEndpointsApprovalEnabled
  }
}

@description('The resource group the Azure Container Registry was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the Azure Container Registry.')
output resourceId string = containerRegistry.id

@description('The name of the Azure Container Registry.')
output name string = containerRegistry.name

@description('The login server URL of the Azure Container Registry.')
output loginServer string = containerRegistry.properties.loginServer
