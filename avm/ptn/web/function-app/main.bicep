metadata name = 'Function App Pattern'
metadata description = '''Deploys an Azure Function App together with its supporting resources: an App Service Plan, a Storage Account for the Function runtime, an Application Insights component, a Log Analytics workspace, and a User-Assigned Managed Identity used for runtime storage access. When `enableWafAlignment` is set to `true`, the module additionally provisions a Key Vault, configures Private Endpoints for the Function App, Storage Account and Key Vault, enables regional VNet integration, and enforces HTTPS-only / TLS 1.2.'''
metadata owner = 'Azure/avm-ptn-web-functionapp-module-owners-bicep'

import { lockType, diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'

// ================ //
// Parameters       //
// ================ //

@description('Required. The name of the Function App.')
@minLength(2)
@maxLength(60)
param functionAppName string

@description('Optional. The Azure region into which all resources will be deployed.')
param location string = resourceGroup().location

@description('Optional. Resource tags to apply to all created resources.')
param tags object?

@description('Optional. Additional tags to apply only to the Function App resource (merged on top of `tags`). Typically used to surface the AZD service mapping via the `azd-service-name` tag.')
param functionAppTags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. The name of the App Service Plan to create. Defaults to `<functionAppName>-asp`.')
param appServicePlanName string = '${functionAppName}-asp'

@description('Optional. The name of the Storage Account that backs the Function App runtime. Must be globally unique, 3-24 lowercase alphanumeric characters. Defaults to a deterministic name derived from `functionAppName`.')
#disable-next-line BCP334
@maxLength(24)
param storageAccountName string = take(
  toLower(replace(
    replace(
      replace(replace('${functionAppName}sa${uniqueString(resourceGroup().id, functionAppName)}', '-', ''), '_', ''),
      '.',
      ''
    ),
    ' ',
    ''
  )),
  24
)

@description('Optional. The name of the Application Insights component. Defaults to `<functionAppName>-ai`.')
param applicationInsightsName string = '${functionAppName}-ai'

@description('Optional. The name of an existing Log Analytics workspace to associate with Application Insights. If left empty and `enableWafAlignment` is `true`, a new workspace named `<functionAppName>-law` is created.')
param logAnalyticsWorkspaceName string = ''

@description('Optional. Resource ID of an existing Log Analytics workspace to associate with Application Insights. When provided, takes precedence over `logAnalyticsWorkspaceName` and no workspace is created.')
param logAnalyticsWorkspaceResourceId string = ''

@description('Optional. The kind of Function App to deploy.')
@allowed([
  'functionapp'
  'functionapp,linux'
])
param functionAppKind string = 'functionapp,linux'

@description('Optional. The SKU of the App Service Plan that hosts the Function App. Defaults to `Y1` (Consumption). For WAF-aligned deployments use `EP1` or higher to support VNet integration and zone redundancy. `FC1` (Flex Consumption) is supported by the underlying `avm/res/web/site` module but requires the consumer to also supply a compatible `functionAppConfig` (deployment storage, runtime, instance memory, max instance count) via `siteConfigOverrides` / app-settings tuned for Flex; this pattern does not yet wire that up automatically.')
@allowed([
  'Y1'
  'FC1'
  'B1'
  'B2'
  'B3'
  'S1'
  'S2'
  'S3'
  'P1v2'
  'P2v2'
  'P3v2'
  'P0v3'
  'P1v3'
  'P2v3'
  'P3v3'
  'P1mv3'
  'P2mv3'
  'P3mv3'
  'P4mv3'
  'P5mv3'
  'EP1'
  'EP2'
  'EP3'
])
param appServicePlanSkuName string = 'Y1'

@description('Optional. Number of workers for the App Service Plan.')
@minValue(1)
param appServicePlanSkuCapacity int = 1

@description('Optional. The runtime stack of the Function App, e.g. `dotnet-isolated`, `node`, `python`, `java`, `powershell`.')
@allowed([
  'dotnet'
  'dotnet-isolated'
  'java'
  'node'
  'powershell'
  'python'
])
param functionWorkerRuntime string = 'dotnet-isolated'

@description('Optional. When `true`, applies the AVM WAF-aligned baseline: Key Vault, regional VNet integration, HTTPS-only and TLS 1.2 enforcement, public network access disabled on the Storage Account, and Private Endpoints for the Function App, Storage Account and Key Vault. Requires `functionAppSubnetResourceId` and `privateEndpointSubnetResourceId` to be provided.')
param enableWafAlignment bool = false

@description('Optional. The resource ID of the subnet to use for Function App regional VNet integration. Required when `enableWafAlignment` is `true` and `virtualNetworkResourceId` is not provided.')
param functionAppSubnetResourceId string = ''

@description('Optional. The resource ID of the subnet to use for Private Endpoints. Required when `enableWafAlignment` is `true` and `virtualNetworkResourceId` is not provided.')
param privateEndpointSubnetResourceId string = ''

@description('Optional. The name of the Key Vault created when `enableWafAlignment` is `true`. Defaults to `<functionAppName>-kv` (the function app name is truncated so the `-kv` suffix is preserved).')
#disable-next-line BCP334
@maxLength(24)
param keyVaultName string = '${take(functionAppName, 21)}-kv'

@description('Optional. Application settings (`name`/`value` pairs) to merge into the Function App configuration. These are merged on top of the AVM defaults set by this module and override any keys with the same name.')
param appSettingsKeyValuePairs object = {}

@description('Optional. The list of origins that are permitted to make cross-origin requests to the Function App (e.g. `https://portal.azure.com`). When non-empty, these are set as the CORS allowed origins in the site configuration.')
param corsAllowedOrigins string[] = []

@description('Optional. Whether CORS requests with credentials (cookies, authorization headers, or TLS client certificates) are allowed on the Function App. Only takes effect when `corsAllowedOrigins` is non-empty.')
param corsSupportCredentials bool = false

@description('Optional. The scope of uniqueness for the default hostname of the Function App during resource creation.')
@allowed([
  'TenantReuse'
  'SubscriptionReuse'
  'ResourceGroupReuse'
  'NoReuse'
])
param autoGeneratedDomainNameLabelScope string?

@description('Optional. The resource ID of an existing User-Assigned Managed Identity to assign to the Function App and use for runtime storage access. When not provided, a new identity is created and used.')
param userAssignedIdentityResourceId string = ''

@description('Optional. The version of the language runtime stack (e.g. `20` for Node 20, `3.11` for Python 3.11, `8.0` for .NET 8). When provided, sets `linuxFxVersion` for Linux Function Apps or the matching framework version property for Windows Function Apps.')
param runtimeVersion string = ''

@description('Optional. The lock settings for all resources deployed by this module.')
param lock lockType?

@description('Optional. The diagnostic settings of the Function App.')
param diagnosticSettings diagnosticSettingFullType[]?

// ================ //
// Variables        //
// ================ //

var isLinux = endsWith(functionAppKind, 'linux')

// Maps the functionWorkerRuntime value to the prefix used in linuxFxVersion.
var linuxFxVersionPrefixMap = {
  dotnet: 'DOTNET'
  'dotnet-isolated': 'DOTNET-ISOLATED'
  java: 'JAVA'
  node: 'NODE'
  powershell: 'POWERSHELL'
  python: 'PYTHON'
}

var runtimeVersionSiteConfig = !empty(runtimeVersion)
  ? (isLinux
      ? { linuxFxVersion: '${linuxFxVersionPrefixMap[functionWorkerRuntime]}|${runtimeVersion}' }
      : (functionWorkerRuntime == 'node'
          ? { nodeVersion: '~${runtimeVersion}' }
          : functionWorkerRuntime == 'java'
              ? { javaVersion: runtimeVersion }
              : functionWorkerRuntime == 'powershell'
                  ? { powerShellVersion: '~${runtimeVersion}' }
                  : { netFrameworkVersion: 'v${runtimeVersion}' }))
  : {}

// Resolve the Log Analytics workspace strategy:
// 1. Explicit resource ID provided -> use it as-is.
// 2. Workspace name provided (existing) -> reference it.
// 3. Otherwise -> create a new workspace (Application Insights classic mode is deprecated).
var createLogAnalyticsWorkspace = empty(logAnalyticsWorkspaceResourceId) && empty(logAnalyticsWorkspaceName)
var derivedLogAnalyticsWorkspaceName = empty(logAnalyticsWorkspaceName)
  ? '${functionAppName}-law'
  : logAnalyticsWorkspaceName

var createUserAssignedIdentity = empty(userAssignedIdentityResourceId)

// Static app settings (deploy-time known values only — safe for for-expression)
var staticAppSettings = union(
  {
    AzureWebJobsStorage__credential: 'managedidentity'
    FUNCTIONS_EXTENSION_VERSION: '~4'
    FUNCTIONS_WORKER_RUNTIME: functionWorkerRuntime
  },
  appSettingsKeyValuePairs
)

var staticAppSettingsArray = [
  for setting in items(staticAppSettings): {
    name: setting.key
    value: setting.value
  }
]

var runtimeAppSettingsArray = [
  { name: 'AzureWebJobsStorage__accountName', value: storageAccount.outputs.name }
  {
    name: 'AzureWebJobsStorage__clientId'
    value: createUserAssignedIdentity
      ? userAssignedIdentity!.outputs.clientId
      : existingUserAssignedIdentity!.properties.clientId
  }
  { name: 'APPLICATIONINSIGHTS_CONNECTION_STRING', value: applicationInsights.outputs.connectionString }
]

var appSettingsArray = concat(staticAppSettingsArray, runtimeAppSettingsArray)

// Resolved User-Assigned Managed Identity values (created or BYO).
var userAssignedIdentityResolvedResourceId = createUserAssignedIdentity
  ? userAssignedIdentity!.outputs.resourceId
  : userAssignedIdentityResourceId
var userAssignedIdentityPrincipalId = createUserAssignedIdentity
  ? userAssignedIdentity!.outputs.principalId
  : existingUserAssignedIdentity!.properties.principalId

// Build the final site app settings array shape expected by avm/res/web/site.
var siteConfigBase = union(
  {
    minTlsVersion: '1.2'
    ftpsState: enableWafAlignment ? 'Disabled' : 'FtpsOnly'
    http20Enabled: true
    appSettings: appSettingsArray
  },
  enableWafAlignment
    ? {
        vnetRouteAllEnabled: true
      }
    : {},
  runtimeVersionSiteConfig,
  !empty(corsAllowedOrigins)
    ? {
        cors: {
          allowedOrigins: corsAllowedOrigins
          supportCredentials: corsSupportCredentials
        }
      }
    : {}
)

// ================ //
// Telemetry        //
// ================ //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.web-functionapp.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

// ================ //
// Existing refs    //
// ================ //

resource existingLogAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2025-02-01' existing = if (!empty(logAnalyticsWorkspaceName) && empty(logAnalyticsWorkspaceResourceId)) {
  name: logAnalyticsWorkspaceName
}

resource existingUserAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' existing = if (!createUserAssignedIdentity) {
  name: last(split(userAssignedIdentityResourceId, '/'))
  scope: resourceGroup(split(userAssignedIdentityResourceId, '/')[2], split(userAssignedIdentityResourceId, '/')[4])
}

// ================ //
// Resources        //
// ================ //

module userAssignedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.5.1' = if (createUserAssignedIdentity) {
  name: take('${uniqueString(deployment().name, location)}-functionApp-uami', 64)
  params: {
    name: '${functionAppName}-uami'
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    lock: lock
  }
}

module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.15.1' = if (createLogAnalyticsWorkspace) {
  name: take('${uniqueString(deployment().name, location)}-functionApp-law', 64)
  params: {
    name: derivedLogAnalyticsWorkspaceName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    lock: lock
  }
}

module applicationInsights 'br/public:avm/res/insights/component:0.7.1' = {
  name: take('${uniqueString(deployment().name, location)}-functionApp-ai', 64)
  params: {
    name: applicationInsightsName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    lock: lock
    workspaceResourceId: !empty(logAnalyticsWorkspaceResourceId)
      ? logAnalyticsWorkspaceResourceId
      : (createLogAnalyticsWorkspace ? logAnalyticsWorkspace!.outputs.resourceId : existingLogAnalyticsWorkspace.id)
  }
}

module storageAccount 'br/public:avm/res/storage/storage-account:0.32.0' = {
  name: take('${uniqueString(deployment().name, location)}-functionApp-sa', 64)
  params: {
    name: storageAccountName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    lock: lock
    skuName: enableWafAlignment ? 'Standard_GRS' : 'Standard_LRS'
    kind: 'StorageV2'
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
    publicNetworkAccess: enableWafAlignment ? 'Disabled' : 'Enabled'
    networkAcls: enableWafAlignment
      ? {
          bypass: 'AzureServices'
          defaultAction: 'Deny'
        }
      : {
          bypass: 'AzureServices'
          defaultAction: 'Allow'
        }
    roleAssignments: [
      // Storage Blob Data Contributor – read/write access to blobs for the Function host and bindings.
      {
        roleDefinitionIdOrName: 'Storage Blob Data Contributor'
        principalId: userAssignedIdentityPrincipalId
        principalType: 'ServicePrincipal'
      }
      // Storage Queue Data Contributor – internal queue management.
      {
        roleDefinitionIdOrName: 'Storage Queue Data Contributor'
        principalId: userAssignedIdentityPrincipalId
        principalType: 'ServicePrincipal'
      }
      // Storage Table Data Contributor – Durable Functions / internal task hub.
      {
        roleDefinitionIdOrName: 'Storage Table Data Contributor'
        principalId: userAssignedIdentityPrincipalId
        principalType: 'ServicePrincipal'
      }
    ]
    privateEndpoints: (enableWafAlignment && !empty(privateEndpointSubnetResourceId))
      ? [
          {
            name: 'pe-${storageAccountName}-blob'
            service: 'blob'
            subnetResourceId: privateEndpointSubnetResourceId
          }
          {
            name: 'pe-${storageAccountName}-file'
            service: 'file'
            subnetResourceId: privateEndpointSubnetResourceId
          }
          {
            name: 'pe-${storageAccountName}-queue'
            service: 'queue'
            subnetResourceId: privateEndpointSubnetResourceId
          }
          {
            name: 'pe-${storageAccountName}-table'
            service: 'table'
            subnetResourceId: privateEndpointSubnetResourceId
          }
        ]
      : null
  }
}

module appServicePlan 'br/public:avm/res/web/serverfarm:0.7.0' = {
  name: take('${uniqueString(deployment().name, location)}-functionApp-asp', 64)
  params: {
    name: appServicePlanName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    lock: lock
    skuName: appServicePlanSkuName
    skuCapacity: appServicePlanSkuCapacity
    kind: isLinux ? 'linux' : 'app'
    reserved: isLinux
    zoneRedundant: enableWafAlignment && (startsWith(appServicePlanSkuName, 'P') || startsWith(
      appServicePlanSkuName,
      'EP'
    ))
  }
}

module keyVault 'br/public:avm/res/key-vault/vault:0.13.3' = if (enableWafAlignment) {
  name: take('${uniqueString(deployment().name, location)}-functionApp-kv', 64)
  params: {
    name: keyVaultName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    lock: lock
    enableRbacAuthorization: true
    enableSoftDelete: true
    enablePurgeProtection: true
    publicNetworkAccess: 'Disabled'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
    }
    privateEndpoints: !empty(privateEndpointSubnetResourceId)
      ? [
          {
            name: 'pe-${keyVaultName}'
            service: 'vault'
            subnetResourceId: privateEndpointSubnetResourceId
          }
        ]
      : null
  }
}

module functionApp 'br/public:avm/res/web/site:0.23.0' = {
  name: take('${uniqueString(deployment().name, location)}-functionApp-site', 64)
  params: {
    name: functionAppName
    location: location
    tags: union(tags ?? {}, functionAppTags ?? {})
    enableTelemetry: enableTelemetry
    lock: lock
    diagnosticSettings: diagnosticSettings
    kind: functionAppKind
    serverFarmResourceId: appServicePlan.outputs.resourceId
    httpsOnly: true
    managedIdentities: {
      userAssignedResourceIds: [
        userAssignedIdentityResolvedResourceId
      ]
    }
    virtualNetworkSubnetResourceId: enableWafAlignment && !empty(functionAppSubnetResourceId)
      ? functionAppSubnetResourceId
      : null
    publicNetworkAccess: enableWafAlignment ? 'Disabled' : 'Enabled'
    autoGeneratedDomainNameLabelScope: autoGeneratedDomainNameLabelScope
    siteConfig: siteConfigBase
    privateEndpoints: (enableWafAlignment && !empty(privateEndpointSubnetResourceId))
      ? [
          {
            name: 'pe-${functionAppName}'
            service: 'sites'
            subnetResourceId: privateEndpointSubnetResourceId
          }
        ]
      : null
  }
}

// ================ //
// Outputs          //
// ================ //

@description('The name of the resource group the resources were deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the resources were deployed into.')
output location string = location

@description('The resource ID of the deployed Function App.')
output functionAppResourceId string = functionApp.outputs.resourceId

@description('The name of the deployed Function App.')
output functionAppName string = functionApp.outputs.name

@description('The default hostname of the deployed Function App.')
output functionAppDefaultHostname string = functionApp.outputs.defaultHostname

@description('The resource ID of the User-Assigned Managed Identity used by the Function App for runtime storage access (created by this module or supplied via `userAssignedIdentityResourceId`).')
output userAssignedIdentityResourceId string = userAssignedIdentityResolvedResourceId

@description('The principal (object) ID of the User-Assigned Managed Identity used by the Function App.')
output userAssignedIdentityPrincipalId string = userAssignedIdentityPrincipalId

@description('The client ID of the User-Assigned Managed Identity used by the Function App.')
output userAssignedIdentityClientId string = createUserAssignedIdentity
  ? userAssignedIdentity!.outputs.clientId
  : existingUserAssignedIdentity!.properties.clientId

@description('The resource ID of the App Service Plan.')
output appServicePlanResourceId string = appServicePlan.outputs.resourceId

@description('The name of the App Service Plan.')
output appServicePlanName string = appServicePlan.outputs.name

@description('The resource ID of the Storage Account that backs the Function App runtime.')
output storageAccountResourceId string = storageAccount.outputs.resourceId

@description('The name of the Storage Account that backs the Function App runtime.')
output storageAccountName string = storageAccount.outputs.name

@description('The resource ID of the Application Insights component.')
output applicationInsightsResourceId string = applicationInsights.outputs.resourceId

@description('The name of the Application Insights component.')
output applicationInsightsName string = applicationInsights.outputs.name

@description('The resource ID of the Key Vault created when `enableWafAlignment` is `true`.')
output keyVaultResourceId string? = enableWafAlignment ? keyVault!.outputs.resourceId : null

@description('The name of the Key Vault created when `enableWafAlignment` is `true`.')
output keyVaultName string? = enableWafAlignment ? keyVault!.outputs.name : null

@description('The resource ID of the Log Analytics workspace created or referenced by this module.')
output logAnalyticsWorkspaceResourceId string = !empty(logAnalyticsWorkspaceResourceId)
  ? logAnalyticsWorkspaceResourceId
  : (createLogAnalyticsWorkspace ? logAnalyticsWorkspace!.outputs.resourceId : existingLogAnalyticsWorkspace.id)
