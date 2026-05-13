metadata name = 'Function App Pattern'
metadata description = '''Deploys an Azure Function App together with its supporting resources: an App Service Plan, a Storage Account for the Function runtime, and an Application Insights component (with an optional Log Analytics workspace). When `enableWafAlignment` is set to `true`, the module additionally provisions a Key Vault, a Virtual Network and Private Endpoints for the Function App, Storage Account and Key Vault, configures VNet integration, system-assigned managed identity and HTTPS-only / TLS 1.2 enforcement.'''

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
param storageAccountName string = take(toLower(replace('${functionAppName}sa${uniqueString(resourceGroup().id, functionAppName)}', '-', '')), 24)

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

@description('Optional. The SKU of the App Service Plan that hosts the Function App. Defaults to `Y1` (Consumption). For WAF-aligned deployments consider `EP1` or higher to support VNet integration and zone redundancy.')
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

@description('Optional. When `true`, applies the AVM WAF-aligned baseline: Key Vault, Virtual Network with subnets for integration and private endpoints, system-assigned managed identity on the Function App, HTTPS-only and TLS 1.2 enforcement, public network access disabled on the Storage Account and Private Endpoints for the Function App, Storage Account and Key Vault.')
param enableWafAlignment bool = false

@description('Optional. The resource ID of the subnet to use for Function App regional VNet integration. Required when `enableWafAlignment` is `true` and `virtualNetworkResourceId` is not provided.')
param functionAppSubnetResourceId string = ''

@description('Optional. The resource ID of the subnet to use for Private Endpoints. Required when `enableWafAlignment` is `true` and `virtualNetworkResourceId` is not provided.')
param privateEndpointSubnetResourceId string = ''

@description('Optional. The name of the Key Vault created when `enableWafAlignment` is `true`. Defaults to `<functionAppName>-kv` (truncated to 24 chars).')
#disable-next-line BCP334
@maxLength(24)
param keyVaultName string = take('${functionAppName}-kv', 24)

@description('Optional. Application settings (`name`/`value` pairs) to merge into the Function App configuration. These are merged on top of the AVM defaults set by this module and override any keys with the same name.')
param appSettingsKeyValuePairs object = {}

// ================ //
// Variables        //
// ================ //

var isLinux = endsWith(functionAppKind, 'linux')

// Resolve the Log Analytics workspace strategy:
// 1. Explicit resource ID provided -> use it as-is.
// 2. Workspace name provided (existing) -> reference it.
// 3. WAF alignment enabled and no workspace info provided -> create a new workspace.
// 4. Otherwise -> no workspace (Application Insights uses classic mode).
var createLogAnalyticsWorkspace = empty(logAnalyticsWorkspaceResourceId) && empty(logAnalyticsWorkspaceName) && enableWafAlignment
var derivedLogAnalyticsWorkspaceName = empty(logAnalyticsWorkspaceName) ? '${functionAppName}-law' : logAnalyticsWorkspaceName

// Static app settings (deploy-time known values only — safe for for-expression)
var staticAppSettings = union(
  {
    AzureWebJobsStorage__credential: 'managedidentity'
    FUNCTIONS_EXTENSION_VERSION: '~4'
    FUNCTIONS_WORKER_RUNTIME: functionWorkerRuntime
  },
  enableWafAlignment
    ? {
        WEBSITE_VNET_ROUTE_ALL: '1'
      }
    : {},
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
  { name: 'APPLICATIONINSIGHTS_CONNECTION_STRING', value: applicationInsights.outputs.connectionString }
]

var appSettingsArray = concat(staticAppSettingsArray, runtimeAppSettingsArray)

// Build the final site app settings array shape expected by avm/res/web/site.
var siteConfigBase = {
  minTlsVersion: '1.2'
  ftpsState: 'FtpsOnly'
  http20Enabled: true
  appSettings: appSettingsArray
}

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

// ================ //
// Resources        //
// ================ //

module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.15.1' = if (createLogAnalyticsWorkspace) {
  name: take('${uniqueString(deployment().name, location)}-functionApp-law', 64)
  params: {
    name: derivedLogAnalyticsWorkspaceName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

module applicationInsights 'br/public:avm/res/insights/component:0.7.1' = {
  name: take('${uniqueString(deployment().name, location)}-functionApp-ai', 64)
  params: {
    name: applicationInsightsName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    workspaceResourceId: !empty(logAnalyticsWorkspaceResourceId)
      ? logAnalyticsWorkspaceResourceId
      : (createLogAnalyticsWorkspace
          ? logAnalyticsWorkspace!.outputs.resourceId
          : (!empty(logAnalyticsWorkspaceName) ? existingLogAnalyticsWorkspace.id : ''))
  }
}

module storageAccount 'br/public:avm/res/storage/storage-account:0.32.0' = {
  name: take('${uniqueString(deployment().name, location)}-functionApp-sa', 64)
  params: {
    name: storageAccountName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
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
    skuName: appServicePlanSkuName
    skuCapacity: appServicePlanSkuCapacity
    kind: isLinux ? 'linux' : 'app'
    reserved: isLinux
    zoneRedundant: enableWafAlignment && (startsWith(appServicePlanSkuName, 'P') || startsWith(appServicePlanSkuName, 'EP'))
  }
}

module keyVault 'br/public:avm/res/key-vault/vault:0.13.3' = if (enableWafAlignment) {
  name: take('${uniqueString(deployment().name, location)}-functionApp-kv', 64)
  params: {
    name: keyVaultName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
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
    kind: functionAppKind
    serverFarmResourceId: appServicePlan.outputs.resourceId
    httpsOnly: true
    managedIdentities: {
      systemAssigned: true
    }
    virtualNetworkSubnetResourceId: enableWafAlignment && !empty(functionAppSubnetResourceId) ? functionAppSubnetResourceId : null
    publicNetworkAccess: enableWafAlignment ? 'Disabled' : 'Enabled'
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

@description('The principal ID of the system-assigned managed identity on the Function App, if enabled.')
output functionAppSystemAssignedMIPrincipalId string? = functionApp.outputs.?systemAssignedMIPrincipalId

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

@description('The connection string of the Application Insights component.')
output applicationInsightsConnectionString string = applicationInsights.outputs.connectionString

@description('The resource ID of the Key Vault created when `enableWafAlignment` is `true`.')
output keyVaultResourceId string = enableWafAlignment ? keyVault!.outputs.resourceId : ''

@description('The name of the Key Vault created when `enableWafAlignment` is `true`.')
output keyVaultName string = enableWafAlignment ? keyVault!.outputs.name : ''

@description('The resource ID of the Log Analytics workspace created or referenced by this module, if any.')
output logAnalyticsWorkspaceResourceId string = !empty(logAnalyticsWorkspaceResourceId)
  ? logAnalyticsWorkspaceResourceId
  : (createLogAnalyticsWorkspace
      ? logAnalyticsWorkspace!.outputs.resourceId
      : (!empty(logAnalyticsWorkspaceName) ? existingLogAnalyticsWorkspace.id : ''))
