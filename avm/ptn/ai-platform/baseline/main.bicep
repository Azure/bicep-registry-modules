metadata name = 'AI Platform Baseline'
metadata description = '''This module provides a secure and scalable environment for deploying AI applications on Azure.
The module encompasses all essential components required for building, managing, and observing AI solutions, including a machine learning workspace, observability tools, and necessary data management services.
By integrating with Microsoft Entra ID for secure identity management and utilizing private endpoints for services like Key Vault and Blob Storage, the module ensures secure communication and data access.'''
metadata owner = 'Azure/module-maintainers'

@description('Required. Alphanumberic suffix to use for resource naming.')
@minLength(3)
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Resource tags.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Settings for the user-assigned managed identity.')
param managedIdentitySettings managedIdentitySettingType

@description('Optional. Settings for the Log Analytics workspace.')
param logAnalyticsSettings logAnalyticsSettingType

@description('Optional. Settings for the key vault.')
param keyVaultSettings keyVaultSettingType

@description('Optional. Settings for the storage account.')
param storageAccountSettings storageAccountSettingType

@description('Optional. Settings for the container registry.')
param containerRegistrySettings containerRegistrySettingType

@description('Optional. Settings for Application Insights.')
param applicationInsightsSettings applicationInsightsSettingType

@description('Optional. Settings for the AI Studio workspace hub.')
param workspaceHubSettings workspaceHubSettingType

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2023-07-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.aiplatform-baseline.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: managedIdentitySettings.?name ?? 'id-${name}'
  location: location
  tags: tags
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: logAnalyticsSettings.?name ?? 'log-${name}'
  location: location
  tags: tags
}

module keyVault 'br/public:avm/res/key-vault/vault:0.6.2' = {
  name: '${uniqueString(deployment().name, location)}-key-vault'
  params: {
    name: keyVaultSettings.?name ?? 'kv-${name}'
    location: location
    enableTelemetry: enableTelemetry
    enableRbacAuthorization: true
    enableVaultForDeployment: false
    enableVaultForDiskEncryption: false
    enableVaultForTemplateDeployment: false
    networkAcls: {
      defaultAction: 'Deny'
      bypass: 'AzureServices'
    }
    publicNetworkAccess: 'Disabled'
    enablePurgeProtection: keyVaultSettings.?enablePurgeProtection ?? true
    roleAssignments: [
      {
        principalId: managedIdentity.properties.principalId
        roleDefinitionIdOrName: 'Contributor'
      }
      {
        principalId: managedIdentity.properties.principalId
        roleDefinitionIdOrName: 'Key Vault Administrator'
      }
    ]
    diagnosticSettings: [
      {
        workspaceResourceId: logAnalyticsWorkspace.id
        logCategoriesAndGroups: [
          {
            category: 'AuditEvent'
            enabled: true
          }
        ]
      }
    ]
    tags: tags
  }
}

module storageAccount 'br/public:avm/res/storage/storage-account:0.11.0' = {
  name: '${uniqueString(deployment().name, location)}-storage'
  params: {
    name: storageAccountSettings.?name ?? 'st${name}'
    location: location
    skuName: storageAccountSettings.?sku ?? 'Standard_RAGZRS'
    enableTelemetry: enableTelemetry
    allowBlobPublicAccess: false
    allowSharedKeyAccess: storageAccountSettings.?allowSharedKeyAccess ?? false
    defaultToOAuthAuthentication: !(storageAccountSettings.?allowSharedKeyAccess ?? false)
    publicNetworkAccess: 'Disabled'
    networkAcls: {
      defaultAction: 'Deny'
      bypass: 'AzureServices'
    }
    roleAssignments: [
      {
        principalId: managedIdentity.properties.principalId
        roleDefinitionIdOrName: 'Contributor'
      }
      {
        principalId: managedIdentity.properties.principalId
        roleDefinitionIdOrName: 'Storage Blob Data Contributor'
      }
      {
        principalId: managedIdentity.properties.principalId
        roleDefinitionIdOrName: '69566ab7-960f-475b-8e7c-b3118f30c6bd' // Storage File Data Privileged Contributor
      }
    ]
    tags: tags
  }
}

module containerRegistry 'br/public:avm/res/container-registry/registry:0.3.1' = {
  name: '${uniqueString(deployment().name, location)}-container-registry'
  params: {
    name: containerRegistrySettings.?name ?? 'cr${name}'
    acrSku: 'Premium'
    location: location
    enableTelemetry: enableTelemetry
    publicNetworkAccess: 'Disabled'
    networkRuleBypassOptions: 'AzureServices'
    zoneRedundancy: 'Enabled'
    trustPolicyStatus: containerRegistrySettings.?trustPolicyStatus ?? 'enabled'
    roleAssignments: [
      {
        principalId: managedIdentity.properties.principalId
        roleDefinitionIdOrName: 'Contributor'
      }
      {
        principalId: managedIdentity.properties.principalId
        roleDefinitionIdOrName: 'AcrPull'
      }
    ]
    tags: tags
  }
}

module applicationInsights 'br/public:avm/res/insights/component:0.3.1' = {
  name: '${uniqueString(deployment().name, location)}-appi'
  params: {
    name: applicationInsightsSettings.?name ?? 'appi-${name}'
    location: location
    kind: 'web'
    enableTelemetry: enableTelemetry
    workspaceResourceId: logAnalyticsWorkspace.id
    roleAssignments: [
      {
        principalId: managedIdentity.properties.principalId
        roleDefinitionIdOrName: 'Contributor'
      }
    ]
    tags: tags
  }
}

module workspaceHub 'br/public:avm/res/machine-learning-services/workspace:0.4.0' = {
  name: '${uniqueString(deployment().name, location)}-hub'
  params: {
    name: workspaceHubSettings.?name ?? 'hub-${name}'
    sku: 'Standard'
    location: location
    enableTelemetry: enableTelemetry
    kind: 'Hub'
    associatedApplicationInsightsResourceId: applicationInsights.outputs.resourceId
    associatedKeyVaultResourceId: keyVault.outputs.resourceId
    associatedStorageAccountResourceId: storageAccount.outputs.resourceId
    associatedContainerRegistryResourceId: containerRegistry.outputs.resourceId
    workspaceHubConfig: {
      defaultWorkspaceResourceGroup: resourceGroup().id
    }
    managedIdentities: {
      userAssignedResourceIds: [
        managedIdentity.id
      ]
    }
    primaryUserAssignedIdentity: managedIdentity.id
    computes: workspaceHubSettings.?computes
    managedNetworkSettings: {
      isolationMode: workspaceHubSettings.?networkIsolationMode ?? 'AllowInternetOutbound'
      outboundRules: workspaceHubSettings.?networkOutboundRules
    }
    systemDatastoresAuthMode: 'identity'
    roleAssignments: [
      {
        principalId: managedIdentity.properties.principalId
        roleDefinitionIdOrName: 'Contributor'
      }
    ]
    tags: tags
  }
}

// ============ //
// Outputs      //
// ============ //

@description('The name of the resource group the module was deployed to.')
output resourceGroupName string = resourceGroup().name

@description('The location the module was deployed to.')
output location string = location

@description('The resource ID of the application insights component.')
output applicationInsightsResourceId string = applicationInsights.outputs.resourceId

@description('The name of the application insights component.')
output applicationInsightsName string = applicationInsights.outputs.name

@description('The application ID of the application insights component.')
output applicationInsightsApplicationId string = applicationInsights.outputs.applicationId

@description('The instrumentation key of the application insights component.')
output applicationInsightsInstrumentationKey string = applicationInsights.outputs.instrumentationKey

@description('The connection string of the application insights component.')
output applicationInsightsConnectionString string = applicationInsights.outputs.connectionString

@description('The resource ID of the log analytics workspace.')
output logAnalyticsWorkspaceResourceId string = logAnalyticsWorkspace.id

@description('The name of the log analytics workspace.')
output logAnalyticsWorkspaceName string = logAnalyticsWorkspace.name

@description('The resource ID of the user assigned managed identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The name of the user assigned managed identity.')
output managedIdentityName string = managedIdentity.name

@description('The principal ID of the user assigned managed identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The client ID of the user assigned managed identity.')
output managedIdentityClientId string = managedIdentity.properties.clientId

@description('The resource ID of the key vault.')
output keyVaultResourceId string = keyVault.outputs.resourceId

@description('The name of the key vault.')
output keyVaultName string = keyVault.outputs.name

@description('The URI of the key vault.')
output keyVaultUri string = keyVault.outputs.uri

@description('The resource ID of the storage account.')
output storageAccountResourceId string = storageAccount.outputs.resourceId

@description('The name of the storage account.')
output storageAccountName string = storageAccount.outputs.name

@description('The resource ID of the container registry.')
output containerRegistryResourceId string = containerRegistry.outputs.resourceId

@description('The name of the container registry.')
output containerRegistryName string = containerRegistry.outputs.name

@description('The resource ID of the workspace hub.')
output workspaceHubResourceId string = workspaceHub.outputs.resourceId

@description('The name of the workspace hub.')
output workspaceHubName string = workspaceHub.outputs.name

// ================ //
// Definitions      //
// ================ //

type managedIdentitySettingType = {
  @description('Optional. The name of the user-assigned managed identity.')
  name: string?
}?

type logAnalyticsSettingType = {
  @description('Optional. The name of the Log Analytics workspace.')
  name: string?
}?

type keyVaultSettingType = {
  @description('Optional. The name of the key vault.')
  name: string?

  @description('Optional. Provide \'true\' to enable Key Vault\'s purge protection feature. Defaults to \'true\'.')
  enablePurgeProtection: bool?
}?

type storageAccountSettingType = {
  @description('Optional. The name of the storage account.')
  name: string?

  @description('Optional. Storage account SKU. Defaults to \'Standard_RAGZRS\'.')
  sku:
    | 'Standard_LRS'
    | 'Standard_GRS'
    | 'Standard_RAGRS'
    | 'Standard_ZRS'
    | 'Premium_LRS'
    | 'Premium_ZRS'
    | 'Standard_GZRS'
    | 'Standard_RAGZRS'?

  @description('Optional. Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Microsoft Entra ID. Defaults to \'false\'.')
  allowSharedKeyAccess: bool?
}?

type containerRegistrySettingType = {
  @description('Optional. The name of the container registry.')
  name: string?

  @description('Optional. Whether the trust policy is enabled for the container registry. Defaults to \'enabled\'.')
  trustPolicyStatus: 'enabled' | 'disabled'?
}?

type applicationInsightsSettingType = {
  @description('Optional. The name of the Application Insights resource.')
  name: string?
}?

type workspaceHubSettingType = {
  @description('Optional. The name of the AI Studio workspace hub.')
  name: string?

  @description('Optional. Computes to create and attach to the workspace hub.')
  computes: array?

  @description('Optional. The network isolation mode of the workspace hub. Defaults to \'AllowInternetOutbound\'.')
  networkIsolationMode: 'AllowInternetOutbound' | 'AllowOnlyApprovedOutbound'?

  @description('Optional. The outbound rules for the managed network of the workspace hub.')
  networkOutboundRules: networkOutboundRuleType
}?

@discriminator('type')
type OutboundRuleType = FqdnOutboundRuleType | PrivateEndpointOutboundRule | ServiceTagOutboundRule

type FqdnOutboundRuleType = {
  @sys.description('Required. Type of a managed network Outbound Rule of the  workspace hub. Only supported when \'isolationMode\' is \'AllowOnlyApprovedOutbound\'.')
  type: 'FQDN'

  @sys.description('Required. Fully Qualified Domain Name to allow for outbound traffic.')
  destination: string

  @sys.description('Optional. Category of a managed network Outbound Rule of the workspace hub.')
  category: 'Dependency' | 'Recommended' | 'Required' | 'UserDefined'?
}

type PrivateEndpointOutboundRule = {
  @sys.description('Required. Type of a managed network Outbound Rule of the workspace hub.')
  type: 'PrivateEndpoint'

  @sys.description('Required. Service Tag destination for a Service Tag Outbound Rule for the managed network of the workspace hub.')
  destination: {
    @sys.description('Required. The resource ID of the target resource for the private endpoint.')
    serviceResourceId: string

    @sys.description('Optional. Whether the private endpoint can be used by jobs running on Spark.')
    sparkEnabled: bool?

    @sys.description('Required. The sub resource to connect for the private endpoint.')
    subresourceTarget: string
  }

  @sys.description('Optional. Category of a managed network Outbound Rule of the workspace hub.')
  category: 'Dependency' | 'Recommended' | 'Required' | 'UserDefined'?
}

type ServiceTagOutboundRule = {
  @sys.description('Required. Type of a managed network Outbound Rule of the workspace hub. Only supported when \'isolationMode\' is \'AllowOnlyApprovedOutbound\'.')
  type: 'ServiceTag'

  @sys.description('Required. Service Tag destination for a Service Tag Outbound Rule for the managed network of the workspace hub.')
  destination: {
    @sys.description('Required. The name of the service tag to allow.')
    portRanges: string

    @sys.description('Required. The protocol to allow. Provide an asterisk(*) to allow any protocol.')
    protocol: 'TCP' | 'UDP' | 'ICMP' | '*'

    @sys.description('Required. Which ports will be allow traffic by this rule. Provide an asterisk(*) to allow any port.')
    serviceTag: string
  }

  @sys.description('Optional. Category of a managed network Outbound Rule of the workspace hub.')
  category: 'Dependency' | 'Recommended' | 'Required' | 'UserDefined'?
}

@sys.description('Optional. Outbound rules for the managed network of the workspace hub.')
type networkOutboundRuleType = {
  @sys.description('Required. The outbound rule. The name of the rule is the object key.')
  *: OutboundRuleType
}?
