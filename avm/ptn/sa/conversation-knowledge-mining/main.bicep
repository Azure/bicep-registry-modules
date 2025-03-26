// // ========== main.bicep ========== //
targetScope = 'resourceGroup'

metadata name = 'Conversation Knowledge Mining Solution Accelerator'
metadata description = '''This module deploys the [Conversation Knowledge Mining Solution Accelerator](https://github.com/microsoft/Conversation-Knowledge-Mining-Solution-Accelerator).

> **Note:** This module is not intended for broad, generic use, as it was designed by the Commercial Solution Areas CTO team, as a Microsoft Solution Accelerator product. Feature requests and bug fix requests are welcome if they support the needs of this organization but may not be incorporated if they aim to make this module more generic than what it needs to be for its primary use case. This module will likely be updated to leverage AVM resource modules in the future. This may result in breaking changes in upcoming versions when these features are implemented.
'''

// ========== Parameters ========== //
// PARAMETERS: Solution configuration
@description('Required. The prefix to add in the default names given to all deployed Azure resources.')
@maxLength(19)
param solutionPrefix string

@description('Optional. Location for all the deployed Azure resources except databases. Defaults to the location of the Resource Group.')
@metadata({ azd: { type: 'location' } })
param solutionLocation string = resourceGroup().location

@description('Optional. Location for all the deployed databases Azure resources. Defaults to East US 2.')
@metadata({ azd: { type: 'location' } })
param databasesLocation string = 'East US 2'

@description('Optional. The tags to apply to all deployed Azure resources.')
param tags object = {
  app: solutionPrefix
  location: solutionLocation
}

// PARAMETERS: Resources configuration
@description('Optional. The configuration to apply for the Conversation Knowledge Mining AI Foundry AI Hub resource.')
param aiFoundryAiHubConfiguration ckmAiFoundryAiHubType = {
  name: '${solutionPrefix}-aifd-aihb'
  location: solutionLocation
  sku: 'Basic'
}

@description('Optional. The configuration to apply for the Conversation Knowledge Mining AI Foundry AI Project resource.')
param aiFoundryAiProjectConfiguration ckmAiFoundryAiProjectType = {
  name: '${solutionPrefix}-aifd-aipj'
  location: solutionLocation
  sku: 'Standard'
}

@description('Optional. The configuration to apply for the Conversation Knowledge Mining AI Foundry AI Services Content Understanding resource.')
param aiFoundryAiServicesContentUnderstandingConfiguration ckmAiFoundryAiServicesContentUnderstandingType = {
  name: '${solutionPrefix}-aifd-aisr-cu'
  location: contains(
      ['West US', 'westus', 'Sweden Central', 'swedencentral', 'Australia East', 'australiaeast'],
      solutionLocation
    )
    ? solutionLocation
    : 'West US'
  sku: 'S0'
}

@description('Optional. The configuration to apply for the Conversation Knowledge Mining AI Foundry AI Services resource.')
param aiFoundryAiServicesConfiguration ckmAiFoundryAiServicesType = {
  name: '${solutionPrefix}-aifd-aisr'
  location: solutionLocation
  sku: 'S0'
  gptModelName: 'gpt-4o-mini'
  gptModelSku: 'GlobalStandard'
  gptModelCapacity: 100
  textEmbeddingModelName: 'text-embedding-ada-002'
  textEmbeddingModelSku: 'Standard'
  textEmbeddingModelCapacity: 80
}

@description('Optional. The configuration to apply for the Conversation Knowledge Mining AI Foundry Application Insights resource.')
param aiFoundryApplicationInsightsConfiguration ckmAiFoundryApplicationInsightsType = {
  name: '${solutionPrefix}-aifd-appi'
  location: solutionLocation
  retentionInDays: 30
}

@description('Optional. The configuration to apply for the Conversation Knowledge Mining AI Foundry Container Registry resource.')
param aiFoundryContainerRegistryConfiguration ckmAiFoundryContainerRegistryType = {
  name: replace('${solutionPrefix}-aifd-creg', '-', '') //NOTE: ACR name should not contain hyphens
  location: solutionLocation
  sku: 'Premium'
}

@description('Optional. The configuration to apply for the Conversation Knowledge Mining AI Foundry Search Services resource.')
param aiFoundrySearchServiceConfiguration ckmAiFoundrySearchServiceType = {
  name: '${solutionPrefix}-aifd-srch'
  location: solutionLocation
  sku: 'basic'
}

@description('Optional. The configuration to apply for the Conversation Knowledge Mining AI Foundry Storage Account resource.')
param aiFoundryStorageAccountConfiguration ckmStorageAccountType = {
  name: replace('${solutionPrefix}-aifd-strg', '-', '')
  location: solutionLocation
  sku: 'Standard_LRS'
}

@description('Optional. The configuration to apply for the Conversation Knowledge Mining Cosmos DB Account resource.')
param cosmosDbAccountConfiguration ckmCosmosDbAccountType = {
  name: '${solutionPrefix}-cmdb'
  location: databasesLocation
}

@description('Optional. The configuration to apply for the Conversation Knowledge Mining Charts Function resource.')
param functionChartsConfiguration ckmFunctionsType = {
  name: '${solutionPrefix}-azfn-fchr'
  location: solutionLocation
  dockerImageContainerRegistryUrl: 'kmcontainerreg.azurecr.io'
  dockerImageName: 'km-charts-function'
  dockerImageTag: 'latest_2025-03-20_276'
  cpu: 1
  memory: '2Gi'
  appScaleLimit: 10
  functionName: 'get_metrics'
}

@description('Optional. The configuration to apply for the Conversation Knowledge Mining Rag Function resource.')
param functionRagConfiguration ckmFunctionsType = {
  name: '${solutionPrefix}-azfn-frag'
  location: solutionLocation
  dockerImageContainerRegistryUrl: 'kmcontainerreg.azurecr.io'
  dockerImageName: 'km-rag-function'
  dockerImageTag: 'latest_2025-03-20_276'
  cpu: 1
  memory: '2Gi'
  appScaleLimit: 10
  functionName: 'stream_openai_text'
}

@description('Optional. The configuration to apply for the Conversation Knowledge Mining Functions Managed Environment resource.')
param functionsManagedEnvironmentConfiguration ckmFunctionsManagedEnvironmentType = {
  name: '${solutionPrefix}-fnme'
  location: solutionLocation
}

@description('Optional. The configuration to apply for the Conversation Knowledge Mining Key Vault resource.')
param keyVaultConfiguration ckmKeyVaultType = {
  name: '${solutionPrefix}-keyv'
  location: solutionLocation
  sku: 'standard'
  createMode: 'default'
  softDeleteEnabled: true
  softDeleteRetentionInDays: 7
  purgeProtectionEnabled: false
  roleAssignments: []
}

@description('Optional. The configuration to apply for the Conversation Knowledge Mining Log Analytics Workspace resource.')
param logAnalyticsWorkspaceConfiguration ckmLogAnalyticsWorkspaceType = {
  name: '${solutionPrefix}-laws'
  location: solutionLocation
  sku: 'PerGB2018'
  dataRetentionInDays: 30
}

@description('Optional. The configuration to apply for the Conversation Knowledge Mining Managed Identity resource.')
param managedIdentityConfiguration ckmManagedIdentityType = {
  name: '${solutionPrefix}-mgid'
  location: solutionLocation
}

@description('Optional. The configuration to apply for the Conversation Knowledge Mining Copy Data Script resource.')
param scriptCopyDataConfiguration ckmScriptType = {
  name: '${solutionPrefix}-scrp-cpdt'
  location: solutionLocation
  githubBaseUrl: 'https://raw.githubusercontent.com/microsoft/Conversation-Knowledge-Mining-Solution-Accelerator/7e1f274415e96070fc1f0306651303ce8ea75268/'
  scriptUrl: 'https://raw.githubusercontent.com/microsoft/Conversation-Knowledge-Mining-Solution-Accelerator/7e1f274415e96070fc1f0306651303ce8ea75268/infra/scripts/copy_kb_files.sh'
}

@description('Optional. The configuration to apply for the Conversation Knowledge Mining Copy Data Script resource.')
param scriptIndexDataConfiguration ckmScriptType = {
  name: '${solutionPrefix}-scrp-indt'
  location: solutionLocation
  githubBaseUrl: 'https://raw.githubusercontent.com/microsoft/Conversation-Knowledge-Mining-Solution-Accelerator/7e1f274415e96070fc1f0306651303ce8ea75268/'
  scriptUrl: 'https://raw.githubusercontent.com/microsoft/Conversation-Knowledge-Mining-Solution-Accelerator/7e1f274415e96070fc1f0306651303ce8ea75268/infra/scripts/run_create_index_scripts.sh'
}

@description('Optional. The configuration to apply for the Conversation Knowledge Mining SQL Server resource.')
param sqlServerConfiguration ckmSqlServerType = {
  name: '${solutionPrefix}-sqls'
  location: databasesLocation
  administratorLogin: 'sqladmin'
  administratorPassword: guid(solutionPrefix, subscription().subscriptionId)
  databaseName: '${solutionPrefix}-ckmdb'
  databaseSkuName: 'GP_Gen5_2'
  databaseSkuTier: 'GeneralPurpose'
  databaseSkuFamily: 'Gen5'
  databaseSkuCapacity: 2
}

@description('Optional. The configuration to apply for the Conversation Knowledge Mining Storage Account resource.')
param storageAccountConfiguration ckmStorageAccountType = {
  name: replace('${solutionPrefix}-strg', '-', '')
  location: solutionLocation
  sku: 'Standard_LRS'
}

@description('Optional. The configuration to apply for the Conversation Knowledge Mining Web App Server Farm resource.')
param webAppServerFarmConfiguration ckmWebAppServerFarmType = {
  name: '${solutionPrefix}-wsrv'
  location: solutionLocation
  sku: 'B2'
  webAppResourceName: '${solutionPrefix}-app'
  webAppLocation: solutionLocation
  webAppDockerImageContainerRegistryUrl: 'kmcontainerreg.azurecr.io'
  webAppDockerImageName: 'km-app'
  webAppDockerImageTag: 'latest_2025-03-20_276'
}

// PARAMETERS: Telemetry
@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

// ========== Variables ========== //
// VARIABLES: general defaults
var avmDeploymentNameFormat = 'ckm-deploy-avm-{0}'
var localModuleDeploymentNameFormat = 'ckm-deploy-module-{0}'

// VARIABLES: AI Foundry AI Hub configuration defaults
var aiFoundryAiHubResourceName = aiFoundryAiHubConfiguration.?name ?? '${solutionPrefix}-aifd-aihb'
var aiFoundryAiHubLocation = aiFoundryAiHubConfiguration.?location ?? solutionLocation
var aiFoundryAiHubSkuName = aiFoundryAiHubConfiguration.?sku ?? 'Basic'

// VARIABLES: AI Foundry AI Project configuration defaults
var aiFoundryAiProjectResourceName = aiFoundryAiProjectConfiguration.?name ?? '${solutionPrefix}-aifd-aipj'
var aiFoundryAiProjectLocation = aiFoundryAiProjectConfiguration.?location ?? solutionLocation
var aiFoundryAiProjectSkuName = aiFoundryAiProjectConfiguration.?sku ?? 'Standard'

// VARIABLES: AI Foundry AI Service Content Understanding configuration defaults
var aiFoundryAiServicesContentUnderstandingResourceName = aiFoundryAiServicesContentUnderstandingConfiguration.?name ?? '${solutionPrefix}-aifd-aisr-cu'
var aiFoundryAiServicesContentUnderstandingLocation = aiFoundryAiServicesContentUnderstandingConfiguration.?location ?? (contains(
    ['West US', 'westus', 'Sweden Central', 'swedencentral', 'Australia East', 'australiaeast'],
    solutionLocation
  )
  ? solutionLocation
  : 'West US')
var aiFoundryAiServicesContentUnderstandingSkuName = aiFoundryAiServicesContentUnderstandingConfiguration.?sku ?? 'S0'

// VARIABLES: AI Foundry AI Service configuration defaults
var aiFoundryAiServicesResourceName = aiFoundryAiServicesConfiguration.?name ?? '${solutionPrefix}-aifd-aisr-cu'
var aiFoundryAiServicesLocation = aiFoundryAiServicesConfiguration.?location ?? solutionLocation
var aiFoundryAiServicesSkuName = aiFoundryAiServicesConfiguration.?sku ?? 'S0'
var aiFoundryAIServicesGptModelName = aiFoundryAiServicesConfiguration.?gptModelName ?? 'gpt-4o-mini'
var aiFoundryAiServicesGptModelSku = aiFoundryAiServicesConfiguration.?gptModelSku ?? 'GlobalStandard'
var aiFoundryAIServicesGptModelCapacity = aiFoundryAiServicesConfiguration.?gptModelCapacity ?? 100
var aiFoundryAiServicesTextEmbeddingModelName = aiFoundryAiServicesConfiguration.?textEmbeddingModelName ?? 'text-embedding-ada-002'
var aiFoundryAiServicesTextEmbeddingModelSku = aiFoundryAiServicesConfiguration.?textEmbeddingModelSku ?? 'Standard'
var aiFoundryAiServicesTextEmbeddingModelCapacity = aiFoundryAiServicesConfiguration.?textEmbeddingModelCapacity ?? 80

var varAiFoundryAiServiceGPTModelVersion = '2024-07-18'
var varAiFoundryAiServiceGPTModelVersionPreview = '2024-02-15-preview'
var varAiFoundryAiServiceTextEmbeddingModelVersion = '2'
var varAiFoundryAiServiceProjectConnectionString = '${toLower(replace(aiFoundryAiProjectLocation, ' ', ''))}.api.azureml.ms;${subscription().subscriptionId};${resourceGroup().name};${aiFoundryAiProjectResourceName}'
var varAiFoundryAIServicesModelDeployments = [
  {
    name: aiFoundryAIServicesGptModelName
    model: {
      name: aiFoundryAIServicesGptModelName
      format: 'OpenAI'
      version: varAiFoundryAiServiceGPTModelVersion //NOTE: This attribute is mandatory for AVM, but optional for ARM. Request AVM to make it optional
    }
    sku: {
      name: aiFoundryAiServicesGptModelSku
      capacity: aiFoundryAIServicesGptModelCapacity
    }
    raiPolicyName: 'Microsoft.Default'
  }
  {
    name: aiFoundryAiServicesTextEmbeddingModelName
    model: {
      name: aiFoundryAiServicesTextEmbeddingModelName
      format: 'OpenAI'
      version: varAiFoundryAiServiceTextEmbeddingModelVersion //NOTE: This attribute is mandatory for AVM, but optional for ARM. Request AVM to make it optional
    }
    sku: {
      name: aiFoundryAiServicesTextEmbeddingModelSku
      capacity: aiFoundryAiServicesTextEmbeddingModelCapacity
    }
    raiPolicyName: 'Microsoft.Default'
  }
]

// VARIABLES: AI Foundry Application Insights configuration defaults
var aiFoundryApplicationInsightsResourceName = aiFoundryApplicationInsightsConfiguration.?name ?? '${solutionPrefix}-aifd-appi'
var aiFoundryApplicationInsightsLocation = aiFoundryApplicationInsightsConfiguration.?location ?? solutionLocation
var aiFoundryApplicationInsightsRetentionInDays = aiFoundryApplicationInsightsConfiguration.?retentionInDays ?? 30

// VARIABLES: AI Foundry Search Service configuration defaults
var aiFoundrySearchServiceResourceName = aiFoundrySearchServiceConfiguration.?name ?? '${solutionPrefix}-aifd-srch'
var aiFoundrySearchServiceLocation = aiFoundrySearchServiceConfiguration.?location ?? solutionLocation
var aiFoundrySearchServiceSkuName = aiFoundrySearchServiceConfiguration.?sku ?? 'basic'

// VARIABLES: AI Foundry Container Registry configuration defaults
var aiFoundryContainerRegistryResourceName = aiFoundryContainerRegistryConfiguration.?name ?? replace(
  '${solutionPrefix}-aifd-creg',
  //NOTE: ACR name should not contain hyphens
  '-',
  ''
)
var aiFoundryContainerRegistryLocation = aiFoundryContainerRegistryConfiguration.?location ?? solutionLocation
var aiFoundryContainerRegistrySkuName = aiFoundryContainerRegistryConfiguration.?sku ?? 'Premium'

// VARIABLES: AI Foundry Storage Account configuration defaults
var aiFoundryStorageAccountResourceName = aiFoundryStorageAccountConfiguration.?name ?? replace(
  '${solutionPrefix}-aifd-strg',
  '-',
  ''
)
var aiFoundryStorageAccountLocation = aiFoundryStorageAccountConfiguration.?location ?? solutionLocation
var aiFoundryStorageAccountSkuName = aiFoundryStorageAccountConfiguration.?sku ?? 'Standard_LRS'

// VARIABLES: CosmosDB configuration defaults
var cosmosDbAccountResourceName = cosmosDbAccountConfiguration.?name ?? '${solutionPrefix}-cmdb'
var cosmosDbAccountLocation = cosmosDbAccountConfiguration.?location ?? databasesLocation

var varCosmosDbSqlDbName = 'db_conversation_history'
var varCosmosDbSqlDbCollName = 'conversations'
var varCosmosDbAccountSqlDbContainers = [
  {
    name: varCosmosDbSqlDbCollName
    id: varCosmosDbSqlDbCollName //NOT: Might not be needed
    partitionKey: '/userId'
  }
]

// VARIABLES: Function Charts configuration defaults
var functionChartsResourceName = functionChartsConfiguration.?name ?? '${solutionPrefix}-azfn-fchr'
var functionChartsLocation = functionChartsConfiguration.?location ?? solutionLocation
var functionChartDockerImageContainerRegistryUrl = functionChartsConfiguration.?dockerImageContainerRegistryUrl ?? 'kmcontainerreg.azurecr.io'
var functionChartDockerImageName = functionChartsConfiguration.?dockerImageName ?? 'km-charts-function'
var functionChartDockerImageTag = functionChartsConfiguration.?dockerImageTag ?? 'latest_2025-03-20_276'
var functionChartCpu = functionChartsConfiguration.?cpu ?? 1
var functionChartMemory = functionChartsConfiguration.?memory ?? '2Gi'
var functionChartAppScaleLimit = functionChartsConfiguration.?appScaleLimit ?? 10
var functionChartsFunctionName = functionChartsConfiguration.?functionName ?? 'get_metrics'

// VARIABLES: Function Rag configuration defaults
var functionRagResourceName = functionRagConfiguration.?name ?? '${solutionPrefix}-azfn-frag'
var functionRagLocation = functionRagConfiguration.?location ?? solutionLocation
var functionRagDockerImageContainerRegistryUrl = functionRagConfiguration.?dockerImageContainerRegistryUrl ?? 'kmcontainerreg.azurecr.io'
var functionRagDockerImageName = functionRagConfiguration.?dockerImageName ?? 'km-rag-function'
var functionRagDockerImageTag = functionRagConfiguration.?dockerImageTag ?? 'latest_2025-03-20_276'
var functionRagCpu = functionRagConfiguration.?cpu ?? 1
var functionRagMemory = functionRagConfiguration.?memory ?? '2Gi'
var functionRagAppScaleLimit = functionRagConfiguration.?appScaleLimit ?? 10
var functionRagFunctionName = functionRagConfiguration.?functionName ?? 'stream_openai_text'

// VARIABLES: Functions Managed Environment configuration defaults
var functionsManagedEnvironmentResourceName = functionsManagedEnvironmentConfiguration.?name ?? '${solutionPrefix}-fnme'
var functionsManagedEnvironmentLocation = functionsManagedEnvironmentConfiguration.?location ?? solutionLocation

// VARIABLES: Key Vault configuration defaults
var keyVaultResourceName = keyVaultConfiguration.?name ?? '${solutionPrefix}-keyv'
var keyVaultLocation = keyVaultConfiguration.?location ?? solutionLocation
var keyVaultSku = keyVaultConfiguration.?sku ?? 'standard'
var keyVaultCreateMode = keyVaultConfiguration.?createMode ?? 'default'
var keyVaultSoftDeleteEnabled = keyVaultConfiguration.?softDeleteEnabled ?? true
var keyVaultSoftDeleteRetentionInDays = keyVaultConfiguration.?softDeleteRetentionInDays ?? 7
var keyVaultPurgeProtectionEnabled = keyVaultConfiguration.?purgeProtectionEnabled ?? false
var keyVaultRoleAssignments = keyVaultConfiguration.?roleAssignments ?? []

var varKvSecretNameAdlsAccountKey = 'ADLS-ACCOUNT-KEY'
var varKvSecretNameAzureCosmosdbAccountKey = 'AZURE-COSMOSDB-ACCOUNT-KEY'

// VARIABLES: Log Analytics configuration defaults
var logAnalyticsWorkspaceResourceName = logAnalyticsWorkspaceConfiguration.?name ?? '${solutionPrefix}-laws'
var logAnalyticsWorkspaceLocation = logAnalyticsWorkspaceConfiguration.?location ?? solutionLocation
var logAnalyticsWorkspaceSkuName = logAnalyticsWorkspaceConfiguration.?sku ?? 'PerGB2018'
var logAnalyticsWorkspaceDataRetentionInDays = logAnalyticsWorkspaceConfiguration.?dataRetentionInDays ?? 30

// VARIABLES: Managed Identity configuration defaults
var managedIdentityResourceName = managedIdentityConfiguration.?name ?? '${solutionPrefix}-mgid'
var managedIdentityLocation = managedIdentityConfiguration.?location ?? solutionLocation

// VARIABLES: Script Copy Data configuration defaults
var scriptCopyDataResourceName = scriptCopyDataConfiguration.?name ?? '${solutionPrefix}-scrp-cpdt'
var scriptCopyDataLocation = scriptCopyDataConfiguration.?location ?? solutionLocation
var scriptCopyDataGithubBaseUrl = scriptCopyDataConfiguration.?githubBaseUrl ?? 'https://raw.githubusercontent.com/microsoft/Conversation-Knowledge-Mining-Solution-Accelerator/7e1f274415e96070fc1f0306651303ce8ea75268/'
var scriptCopyDataScriptUrl = scriptCopyDataConfiguration.?scriptUrl ?? 'https://raw.githubusercontent.com/microsoft/Conversation-Knowledge-Mining-Solution-Accelerator/7e1f274415e96070fc1f0306651303ce8ea75268/infra/scripts/copy_kb_files.sh'

// VARIABLES: Script Index Data configuration defaults
var scriptIndexDataResourceName = scriptIndexDataConfiguration.?name ?? '${solutionPrefix}-scrp-indt'
var scriptIndexDataLocation = scriptIndexDataConfiguration.?location ?? solutionLocation
var scriptIndexDataGithubBaseUrl = scriptIndexDataConfiguration.?githubBaseUrl ?? 'https://raw.githubusercontent.com/microsoft/Conversation-Knowledge-Mining-Solution-Accelerator/7e1f274415e96070fc1f0306651303ce8ea75268/'
var scriptIndexDataScriptUrl = scriptIndexDataConfiguration.?scriptUrl ?? 'https://raw.githubusercontent.com/microsoft/Conversation-Knowledge-Mining-Solution-Accelerator/7e1f274415e96070fc1f0306651303ce8ea75268/infra/scripts/run_create_index_scripts.sh'

// VARIABLES: SQL Server configuration defaults
var sqlServerResourceName = sqlServerConfiguration.?name ?? '${solutionPrefix}-sqls'
var sqlServerLocation = sqlServerConfiguration.?location ?? databasesLocation
var sqlServerAdministratorLogin = sqlServerConfiguration.?administratorLogin ?? 'sqladmin'
var sqlServerAdministratorPassword = sqlServerConfiguration.?administratorPassword ?? guid(
  solutionPrefix,
  subscription().subscriptionId
)
var sqlServerDatabaseName = sqlServerConfiguration.?databaseName ?? '${solutionPrefix}-ckmdb'
var sqlServerDatabaseSkuName = sqlServerConfiguration.?databaseSkuName ?? 'GP_Gen5_2'
var sqlServerDatabaseSkuTier = sqlServerConfiguration.?databaseSkuTier ?? 'GeneralPurpose'
var sqlServerDatabaseSkuFamily = sqlServerConfiguration.?databaseSkuFamily ?? 'Gen5'
var sqlServerDatabaseSkuCapacity = sqlServerConfiguration.?databaseSkuCapacity ?? 2

// VARIABLES: Storage Account configuration defaults
var storageAccountResourceName = storageAccountConfiguration.?name ?? replace('${solutionPrefix}-aifd-strg', '-', '')
var storageAccountLocation = storageAccountConfiguration.?location ?? solutionLocation
var storageAccountSkuName = storageAccountConfiguration.?sku ?? 'Standard_LRS'

var varStorageContainerName = 'data'

// VARIABLES: Web App Server configuration defaults
var webAppServerFarmResourceName = webAppServerFarmConfiguration.?name ?? '${solutionPrefix}-wsrv'
var webAppServerFarmLocation = webAppServerFarmConfiguration.?location ?? solutionLocation
var webAppServerFarmSkuName = webAppServerFarmConfiguration.?sku ?? 'B2'
var webAppResourceName = webAppServerFarmConfiguration.?webAppResourceName ?? '${solutionPrefix}-app'
var webAppLocation = webAppServerFarmConfiguration.?webAppLocation ?? solutionLocation
var webAppDockerImageContainerRegistryUrl = webAppServerFarmConfiguration.?webAppDockerImageContainerRegistryUrl ?? 'kmcontainerreg.azurecr.io'
var webAppDockerImageName = webAppServerFarmConfiguration.?webAppDockerImageName ?? 'km-app'
var webAppDockerImageTag = webAppServerFarmConfiguration.?webAppDockerImageTag ?? 'latest_2025-03-20_276'

var varWebAppAppConfigReact = '''{
  "appConfig": {
    "THREE_COLUMN": {
      "DASHBOARD": 50,
      "CHAT": 33,
      "CHATHISTORY": 17
    },
    "TWO_COLUMN": {
      "DASHBOARD_CHAT": {
        "DASHBOARD": 65,
        "CHAT": 35
      },
      "CHAT_CHATHISTORY": {
        "CHAT": 80,
        "CHATHISTORY": 20
      }
    }
  },
  "charts": [
    {
      "id": "SATISFIED",
      "name": "Satisfied",
      "type": "card",
      "layout": { "row": 1, "column": 1, "height": 11 }
    },
    {
      "id": "TOTAL_CALLS",
      "name": "Total Calls",
      "type": "card",
      "layout": { "row": 1, "column": 2, "span": 1 }
    },
    {
      "id": "AVG_HANDLING_TIME",
      "name": "Average Handling Time",
      "type": "card",
      "layout": { "row": 1, "column": 3, "span": 1 }
    },
    {
      "id": "SENTIMENT",
      "name": "Topics Overview",
      "type": "donutchart",
      "layout": { "row": 2, "column": 1, "width": 40, "height": 44.5 }
    },
    {
      "id": "AVG_HANDLING_TIME_BY_TOPIC",
      "name": "Average Handling Time By Topic",
      "type": "bar",
      "layout": { "row": 2, "column": 2, "row-span": 2, "width": 60 }
    },
    {
      "id": "TOPICS",
      "name": "Trending Topics",
      "type": "table",
      "layout": { "row": 3, "column": 1, "span": 2 }
    },
    {
      "id": "KEY_PHRASES",
      "name": "Key Phrases",
      "type": "wordcloud",
      "layout": { "row": 3, "column": 2, "height": 44.5 }
    }
  ]
}'''

// ========== Telemetry ========== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: take(
    '46d3xbcp.ptn.sa-convknowledgemining.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, solutionLocation), 0, 4)}',
    64
  )
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

module avmManagedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.0' = {
  name: format(avmDeploymentNameFormat, managedIdentityResourceName)
  params: {
    name: managedIdentityResourceName
    tags: tags
    location: managedIdentityLocation
    enableTelemetry: enableTelemetry
  }
}

// NOTE: This assignment should leverage AVM module [avm/res/resources/resource-group](https://azure.github.io/Azure-Verified-Modules/indexes/bicep/bicep-resource-modules/), but current target scope is resourceGroup
// TODO: Owner permissions to RG is an unsecure practice, fine grain permissions
module assignResourceGroupOwner 'modules/rbac-rg-owner.bicep' = {
  name: format(localModuleDeploymentNameFormat, 'rbac-rg-owner')
  params: {
    managedIdentityResourceId: avmManagedIdentity.outputs.resourceId
    managedIdentityPrincipalId: avmManagedIdentity.outputs.principalId
  }
}

// ========== Log Analytics Workspace ========== //
module avmLogAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.11.1' = {
  name: format(avmDeploymentNameFormat, logAnalyticsWorkspaceResourceName)
  params: {
    name: logAnalyticsWorkspaceResourceName
    tags: tags
    location: logAnalyticsWorkspaceLocation
    enableTelemetry: enableTelemetry
    skuName: logAnalyticsWorkspaceSkuName
    dataRetention: logAnalyticsWorkspaceDataRetentionInDays
  }
}

// ========== Key Vault ========== //
module avmKeyVault 'br/public:avm/res/key-vault/vault:0.12.1' = {
  name: format(avmDeploymentNameFormat, keyVaultResourceName)
  params: {
    name: keyVaultResourceName
    tags: tags
    location: keyVaultLocation
    enableTelemetry: enableTelemetry
    diagnosticSettings: [{ workspaceResourceId: avmLogAnalyticsWorkspace.outputs.resourceId }]
    sku: keyVaultSku
    createMode: keyVaultCreateMode
    enableSoftDelete: keyVaultSoftDeleteEnabled
    softDeleteRetentionInDays: keyVaultSoftDeleteRetentionInDays
    enablePurgeProtection: keyVaultPurgeProtectionEnabled
    publicNetworkAccess: 'Enabled'
    enableRbacAuthorization: true
    roleAssignments: concat(
      [
        {
          principalId: avmManagedIdentity.outputs.principalId
          principalType: 'ServicePrincipal'
          roleDefinitionIdOrName: 'Key Vault Administrator'
        }
      ],
      keyVaultRoleAssignments
    )
    secrets: [
      { name: 'ADLS-ACCOUNT-CONTAINER', value: varStorageContainerName }
      { name: 'ADLS-ACCOUNT-NAME', value: storageAccountResourceName }
      { name: 'TENANT-ID', value: subscription().tenantId }
      { name: 'AZURE-COSMOSDB-ACCOUNT', value: cosmosDbAccountResourceName }
      { name: 'AZURE-COSMOSDB-DATABASE', value: varCosmosDbSqlDbName }
      { name: 'AZURE-COSMOSDB-CONVERSATIONS-CONTAINER', value: varCosmosDbSqlDbCollName }
      { name: 'AZURE-COSMOSDB-ENABLE-FEEDBACK', value: 'True' }
      { name: 'SQLDB-SERVER', value: '${sqlServerResourceName}${environment().suffixes.sqlServerHostname}' }
      { name: 'SQLDB-DATABASE', value: sqlServerDatabaseName }
      { name: 'SQLDB-USERNAME', value: sqlServerAdministratorLogin }
      { name: 'SQLDB-PASSWORD', value: sqlServerAdministratorPassword }
      { name: 'AZURE-OPENAI-PREVIEW-API-VERSION', value: varAiFoundryAiServiceGPTModelVersionPreview }
      { name: 'AZURE-AI-PROJECT-CONN-STRING', value: varAiFoundryAiServiceProjectConnectionString }
      { name: 'AZURE-OPEN-AI-DEPLOYMENT-MODEL', value: varAiFoundryAIServicesModelDeployments[0].model.name }
      { name: 'AZURE-OPENAI-CU-VERSION', value: '?api-version=2024-12-01-preview' }
      { name: 'AZURE-SEARCH-ENDPOINT', value: 'https://${aiFoundrySearchServiceResourceName}.search.windows.net' }
      { name: 'AZURE-SEARCH-SERVICE', value: aiFoundrySearchServiceResourceName }
      { name: 'AZURE-SEARCH-INDEX', value: 'transcripts_index' }
      { name: 'COG-SERVICES-NAME', value: aiFoundryAiServicesResourceName }
      { name: 'AZURE-SUBSCRIPTION-ID', value: subscription().subscriptionId }
      { name: 'AZURE-RESOURCE-GROUP', value: resourceGroup().name }
      { name: 'AZURE-LOCATION', value: solutionLocation }
    ]
  }
}

// ========== AI Foundry ========== //

module moduleAIFoundry './modules/ai-foundry.bicep' = {
  name: format(localModuleDeploymentNameFormat, 'ai-foundry')
  params: {
    aiHubLocation: aiFoundryAiHubLocation
    aiHubResourceName: aiFoundryAiHubResourceName
    aiHubSkuName: aiFoundryAiHubSkuName
    aiProjectLocation: aiFoundryAiProjectLocation
    aiProjectResourceName: aiFoundryAiProjectResourceName
    aiProjectSkuName: aiFoundryAiProjectSkuName
    aiServicesLocation: aiFoundryAiServicesLocation
    aiServicesContentUnderstandingLocation: aiFoundryAiServicesContentUnderstandingLocation
    aiServicesContentUnderstandingResourceName: aiFoundryAiServicesContentUnderstandingResourceName
    aiServicesContentUnderstandingSkuName: aiFoundryAiServicesContentUnderstandingSkuName
    aiServicesModelDeployments: varAiFoundryAIServicesModelDeployments
    aiServicesResourceName: aiFoundryAiServicesResourceName
    aiServicesSkuName: aiFoundryAiServicesSkuName
    applicationInsightsLocation: aiFoundryApplicationInsightsLocation
    applicationInsightsResourceName: aiFoundryApplicationInsightsResourceName
    applicationInsightsRetentionInDays: aiFoundryApplicationInsightsRetentionInDays
    containerRegistryLocation: aiFoundryContainerRegistryLocation
    containerRegistryResourceName: aiFoundryContainerRegistryResourceName
    containerRegistrySkuName: aiFoundryContainerRegistrySkuName
    enableTelemetry: enableTelemetry
    keyVaultResourceName: avmKeyVault.outputs.name
    logAnalyticsWorkspaceResourceId: avmLogAnalyticsWorkspace.outputs.resourceId
    managedIdentityPrincipalId: avmManagedIdentity.outputs.principalId
    searchServiceLocation: aiFoundrySearchServiceLocation
    searchServiceResourceName: aiFoundrySearchServiceResourceName
    searchServiceSkuName: aiFoundrySearchServiceSkuName
    storageAccountLocation: aiFoundryStorageAccountLocation
    storageAccountResourceName: aiFoundryStorageAccountResourceName
    storageAccountSkuName: aiFoundryStorageAccountSkuName
    tags: tags
    avmDeploymentNameFormat: avmDeploymentNameFormat
    localModuleDeploymentNameFormat: localModuleDeploymentNameFormat
  }
}

// ========== Storage Account ========== //

module avmStorageAccount 'br/public:avm/res/storage/storage-account:0.18.2' = {
  name: format(avmDeploymentNameFormat, storageAccountResourceName)
  params: {
    name: storageAccountResourceName
    tags: tags
    location: storageAccountLocation
    enableTelemetry: enableTelemetry
    diagnosticSettings: [{ workspaceResourceId: avmLogAnalyticsWorkspace.outputs.resourceId }]
    skuName: storageAccountSkuName
    allowSharedKeyAccess: false
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
    blobServices: {
      corsRules: []
      deleteRetentionPolicyEnabled: false
      containerDeleteRetentionPolicyDays: 7
      containerDeleteRetentionPolicyEnabled: false
      diagnosticSettings: [{ workspaceResourceId: avmLogAnalyticsWorkspace.outputs.resourceId }]
      containers: [
        {
          name: varStorageContainerName
          publicAccess: 'None'
          defaultEncryptionScope: '$account-encryption-key'
          denyEncryptionScopeOverride: false
        }
      ]
    }
    roleAssignments: [
      {
        principalId: avmManagedIdentity.outputs.principalId
        roleDefinitionIdOrName: 'Storage Blob Data Contributor'
      }
      {
        principalId: functionCharts.identity.principalId
        //#disable-next-line BCP321
        //principalId: avmFunctionCharts.outputs.?systemAssignedMIPrincipalId
        roleDefinitionIdOrName: 'Storage Blob Data Contributor'
      }
    ]
    secretsExportConfiguration: {
      keyVaultResourceId: avmKeyVault.outputs.resourceId
      accessKey1Name: varKvSecretNameAdlsAccountKey
    }
  }
}

// ========== Cosmos Database ========== //

module avmCosmosDB 'br/public:avm/res/document-db/database-account:0.11.2' = {
  name: format(avmDeploymentNameFormat, cosmosDbAccountResourceName)
  params: {
    name: cosmosDbAccountResourceName
    tags: tags
    location: cosmosDbAccountLocation
    enableTelemetry: enableTelemetry
    diagnosticSettings: [{ workspaceResourceId: avmLogAnalyticsWorkspace.outputs.resourceId }]
    locations: [
      {
        locationName: cosmosDbAccountLocation
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
    automaticFailover: false
    disableLocalAuth: false
    capabilitiesToAdd: ['EnableServerless']
    serverVersion: '4.0'
    sqlDatabases: [
      {
        name: varCosmosDbSqlDbName
        containers: [
          for container in varCosmosDbAccountSqlDbContainers: {
            name: container.name
            paths: [container.partitionKey]
          }
        ]
      }
    ]
    secretsExportConfiguration: {
      keyVaultResourceId: avmKeyVault.outputs.resourceId
      primaryWriteKeySecretName: varKvSecretNameAzureCosmosdbAccountKey
    }
  }
}

// ========== SQL Database Server ========== //

module avmSQLServer 'br/public:avm/res/sql/server:0.13.1' = {
  name: format(avmDeploymentNameFormat, sqlServerResourceName)
  params: {
    name: sqlServerResourceName
    tags: tags
    location: sqlServerLocation
    enableTelemetry: enableTelemetry
    administratorLogin: sqlServerAdministratorLogin
    administratorLoginPassword: sqlServerAdministratorPassword
    publicNetworkAccess: 'Enabled'
    restrictOutboundNetworkAccess: 'Disabled'
    firewallRules: [
      {
        name: 'AllowSpecificRange'
        startIpAddress: '0.0.0.0'
        endIpAddress: '0.0.0.0'
      }
    ]
    databases: [
      {
        name: sqlServerDatabaseName
        diagnosticSettings: [{ workspaceResourceId: avmLogAnalyticsWorkspace.outputs.resourceId }]
        sku: {
          name: sqlServerDatabaseSkuName
          tier: sqlServerDatabaseSkuTier
          family: sqlServerDatabaseSkuFamily
          capacity: sqlServerDatabaseSkuCapacity
        }
        autoPauseDelay: 60
        minCapacity: '1'
        zoneRedundant: false
      }
    ]
  }
}

//========== Deployment script to upload sample data ========== //

module avmDeploymentScriptCopyData 'br/public:avm/res/resources/deployment-script:0.5.1' = {
  name: format(avmDeploymentNameFormat, scriptCopyDataResourceName)
  params: {
    kind: 'AzureCLI'
    name: scriptCopyDataResourceName
    tags: tags
    location: scriptCopyDataLocation
    enableTelemetry: enableTelemetry
    managedIdentities: {
      userAssignedResourceIds: [
        avmManagedIdentity.outputs.resourceId
      ]
    }
    azCliVersion: '2.50.0'
    primaryScriptUri: scriptCopyDataScriptUrl
    arguments: '${avmStorageAccount.outputs.name} ${varStorageContainerName} ${scriptCopyDataGithubBaseUrl}'
    timeout: 'PT1H'
    retentionInterval: 'PT1H'
    cleanupPreference: 'OnSuccess'
  }
  dependsOn: [
    #disable-next-line no-unnecessary-dependson
    moduleAIFoundry
  ]
}

//========== Deployment script to process and index data ========== //

module avmDeploymentScriptIndexData 'br/public:avm/res/resources/deployment-script:0.5.1' = {
  name: format(avmDeploymentNameFormat, scriptIndexDataResourceName)
  params: {
    kind: 'AzureCLI'
    name: scriptIndexDataResourceName
    tags: tags
    location: scriptIndexDataLocation
    enableTelemetry: enableTelemetry
    managedIdentities: {
      userAssignedResourceIds: [
        avmManagedIdentity.outputs.resourceId
      ]
    }
    azCliVersion: '2.52.0'
    primaryScriptUri: scriptIndexDataScriptUrl
    arguments: '${scriptIndexDataGithubBaseUrl} ${avmKeyVault.outputs.name}'
    timeout: 'PT1H'
    retentionInterval: 'PT1H'
    cleanupPreference: 'OnSuccess'
  }
  dependsOn: [moduleAIFoundry, avmSQLServer, avmDeploymentScriptCopyData]
}

//========== Azure function: Managed Environment ========== //

module avmFunctionsManagedEnvironment 'br/public:avm/res/app/managed-environment:0.10.0' = {
  name: format(avmDeploymentNameFormat, functionsManagedEnvironmentResourceName)
  params: {
    name: functionsManagedEnvironmentResourceName
    tags: tags
    location: functionsManagedEnvironmentLocation
    enableTelemetry: enableTelemetry
    zoneRedundant: false
    workloadProfiles: [
      {
        workloadProfileType: 'Consumption'
        name: 'Consumption'
      }
    ]
    publicNetworkAccess: 'Enabled'
    peerTrafficEncryption: false
    logAnalyticsWorkspaceResourceId: avmLogAnalyticsWorkspace.outputs.resourceId
  }
}

// NOTE: This version of the AVM module does not support the deployment to Azure Container Apps Environment resource
// ERROR: VnetRouteAllEnabled cannot be configured for function app deployed on Azure Container Apps. Please try to configure from Azure Container Apps Environment resource

// module avmFunctionCharts 'br/public:avm/res/web/site:0.15.0' = {
//   name: format(avmDeploymentNameFormat, functionChartsResourceName)
//   params: {
//     name: functionChartsResourceName
//     tags: tags
//     location: functionChartsLocation
//     enableTelemetry: enableTelemetry
//     diagnosticSettings: [{ workspaceResourceId: avmLogAnalyticsWorkspace.outputs.resourceId }]
//     kind: 'functionapp,linux,container,azurecontainerapps'
//     managedIdentities: {
//       systemAssigned: true
//     }
//     managedEnvironmentId: avmFunctionsManagedEnvironment.outputs.resourceId
//     serverFarmResourceId: 'null'
//     siteConfig: {
//       linuxFxVersion: 'DOCKER|${functionChartDockerImageContainerRegistryUrl}/${functionChartDockerImageName}:${functionChartDockerImageTag}'
//       functionAppScaleLimit: functionChartAppScaleLimit
//       minimumElasticInstanceCount: 0
//     }
//     appSettingsKeyValuePairs: {
//       AzureWebJobsStorage_accountname: moduleAIFoundry.outputs.storageAccountName
//       SQLDB_DATABASE: sqlServerDatabaseName
//       SQLDB_PASSWORD: sqlServerAdministratorPassword
//       SQLDB_SERVER: avmSQLServer.outputs.fullyQualifiedDomainName
//       SQLDB_USERNAME: sqlServerAdministratorLogin
//     }
//     // workloadProfileName: 'Consumption'
//     // resourceConfig: {
//     //   cpu: functionChartCpu
//     //   memory: functionChartMemory
//     // }
//     storageAccountRequired: false
//     appInsightResourceId: moduleAIFoundry.outputs.applicationInsightsResourceId
//   }
// }

resource functionCharts 'Microsoft.Web/sites@2023-12-01' = {
  name: functionChartsResourceName
  tags: tags
  location: functionChartsLocation
  kind: 'functionapp,linux,container,azurecontainerapps'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    siteConfig: {
      appSettings: [
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: moduleAIFoundry.outputs.applicationInsightsConnectionString
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: moduleAIFoundry.outputs.applicationInsightsInstrumentationKey
        }
        {
          name: 'AzureWebJobsStorage_accountname'
          value: moduleAIFoundry.outputs.storageAccountName
        }
        {
          name: 'SQLDB_DATABASE'
          value: sqlServerDatabaseName
        }
        {
          name: 'SQLDB_PASSWORD'
          value: sqlServerAdministratorPassword
        }
        {
          name: 'SQLDB_SERVER'
          value: avmSQLServer.outputs.fullyQualifiedDomainName
        }
        {
          name: 'SQLDB_USERNAME'
          value: sqlServerAdministratorLogin
        }
      ]
      linuxFxVersion: 'DOCKER|${functionChartDockerImageContainerRegistryUrl}/${functionChartDockerImageName}:${functionChartDockerImageTag}'
      functionAppScaleLimit: functionChartAppScaleLimit
      minimumElasticInstanceCount: 0
      // use32BitWorkerProcess: false
      // ftpsState: 'FtpsOnly'
    }
    managedEnvironmentId: avmFunctionsManagedEnvironment.outputs.resourceId
    workloadProfileName: 'Consumption'
    // virtualNetworkSubnetId: null
    // clientAffinityEnabled: false
    resourceConfig: {
      cpu: functionChartCpu
      memory: functionChartMemory
    }
    storageAccountRequired: false
  }
}

//========== Azure function: Rag ========== //

module moduleFunctionRAG 'modules/function-rag.bicep' = {
  name: format(localModuleDeploymentNameFormat, 'function-rag')
  params: {
    aiFoundryAIHubProjectConnectionString: varAiFoundryAiServiceProjectConnectionString
    aiFoundryAISearchServiceConnectionString: moduleAIFoundry.outputs.aiSearchConnectionString
    aiFoundryAIServicesName: moduleAIFoundry.outputs.aiServicesName
    aiFoundryOpenAIServicesEndpoint: moduleAIFoundry.outputs.aiServicesEndpoint
    aiFoundrySearchServicesName: moduleAIFoundry.outputs.aiSearchName
    applicationInsightsConnectionString: moduleAIFoundry.outputs.applicationInsightsConnectionString
    applicationInsightsInstrumentationKey: moduleAIFoundry.outputs.applicationInsightsInstrumentationKey
    functionRagAppScaleLimit: functionRagAppScaleLimit
    functionRagCpu: functionRagCpu
    functionRagMemory: functionRagMemory
    functionsManagedEnvironmentResourceId: avmFunctionsManagedEnvironment.outputs.resourceId
    gptModelName: aiFoundryAIServicesGptModelName
    gptModelVersionPreview: varAiFoundryAiServiceGPTModelVersionPreview
    ragDockerImageName: 'DOCKER|${functionRagDockerImageContainerRegistryUrl}/${functionRagDockerImageName}:${functionRagDockerImageTag}'
    ragFunctionName: functionRagResourceName
    ragStorageAccountName: moduleAIFoundry.outputs.storageAccountName
    ragFunctionLocation: functionRagLocation
    sqlDatabaseName: sqlServerDatabaseName
    sqlServerAdministratorLogin: sqlServerAdministratorLogin
    sqlServerAdministratorPassword: sqlServerAdministratorPassword
    sqlServerFullyQualifiedDomainName: avmSQLServer.outputs.fullyQualifiedDomainName
    tags: tags
  }
}

module rbacAiProjectAiDeveloper 'modules/rbac-aiproject-aideveloper.bicep' = {
  name: format(localModuleDeploymentNameFormat, 'rbac-aiproject-aideveloper')
  params: {
    aiServicesProjectResourceName: moduleAIFoundry.outputs.aiProjectName
    ragFunctionPrincipalId: moduleFunctionRAG.outputs.principalId
    ragFunctionResourceId: moduleFunctionRAG.outputs.resourceId
  }
}

//========== CKM Webapp ========== //

module avmServerFarmWebapp 'br/public:avm/res/web/serverfarm:0.4.1' = {
  name: format(avmDeploymentNameFormat, webAppServerFarmResourceName)
  params: {
    name: webAppServerFarmResourceName
    tags: tags
    location: webAppServerFarmLocation
    enableTelemetry: enableTelemetry
    diagnosticSettings: [{ workspaceResourceId: avmLogAnalyticsWorkspace.outputs.resourceId }]
    skuName: webAppServerFarmSkuName
    kind: 'linux'
  }
}

module moduleWebsiteWebapp 'modules/webapp.bicep' = {
  name: format(localModuleDeploymentNameFormat, 'webapp')
  params: {
    deploymentName: format(avmDeploymentNameFormat, webAppResourceName)
    webAppName: webAppResourceName
    tags: tags
    location: webAppLocation
    enableTelemetry: enableTelemetry
    serverFarmResourceId: avmServerFarmWebapp.outputs.resourceId
    appInsightsResourceId: moduleAIFoundry.outputs.applicationInsightsResourceId
    aiFoundryAIServicesName: moduleAIFoundry.outputs.aiServicesName
    webAppImageName: 'DOCKER|${webAppDockerImageContainerRegistryUrl}/${webAppDockerImageName}:${webAppDockerImageTag}'
    appInsightsInstrumentationKey: moduleAIFoundry.outputs.applicationInsightsInstrumentationKey
    aiServicesEndpoint: moduleAIFoundry.outputs.aiServicesEndpoint
    gptModelName: aiFoundryAIServicesGptModelName
    gptModelVersionPreview: varAiFoundryAiServiceGPTModelVersionPreview
    aiServicesResourceName: moduleAIFoundry.outputs.aiServicesName
    chartsFunctionDefaultHostName: functionCharts.properties.defaultHostName
    //chartsFunctionDefaultHostName: avmFunctionCharts.outputs.defaultHostname
    chartsFunctionFunctionName: functionChartsFunctionName
    webAppAppConfigReact: varWebAppAppConfigReact
    cosmosDbSqlDbName: varCosmosDbSqlDbName
    cosmosDbSqlDbNameCollectionName: varCosmosDbSqlDbCollName
    ragFunctionDefaultHostName: moduleFunctionRAG.outputs.defaultHostName
    ragFunctionFunctionName: functionRagFunctionName
    cosmosDbResourceName: avmCosmosDB.outputs.name
  }
}

module rbac 'modules/rbac-cosmosdb-contributor.bicep' = {
  name: format(localModuleDeploymentNameFormat, 'rbac-cosmosdb-contributor')
  params: {
    cosmosDBAccountName: avmCosmosDB.outputs.name
    principalId: moduleWebsiteWebapp.outputs.webAppSystemAssignedPrincipalId
  }
}

@description('The resource group the resources were deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The url of the webapp where the deployed Conversation Knowledge Mining solution can be accessed.')
output webAppUrl string = '${webAppResourceName}.azurewebsites.net'

// =============== //
//   Definitions   //
// =============== //

@export()
@description('The type for the Conversation Knowledge Mining AI Foundry AI Hub resource configuration.')
type ckmAiFoundryAiHubType = {
  @description('Optional. The name of the AI Foundry AI Hub resource.')
  @maxLength(90)
  name: string?

  @description('Optional. Location for the AI Foundry AI Hub resource.')
  @metadata({ azd: { type: 'location' } })
  location: string?

  @description('Optional. The SKU of the AI Foundry AI Hub resource.')
  sku: ('Basic' | 'Free' | 'Standard' | 'Premium')?
}

@export()
@description('The type for the Conversation Knowledge Mining AI Foundry AI Project resource configuration.')
type ckmAiFoundryAiProjectType = {
  @description('Optional. The name of the AI Foundry AI Project resource.')
  @maxLength(90)
  name: string?

  @description('Optional. Location for the AI Foundry AI Project resource deployment.')
  @metadata({ azd: { type: 'location' } })
  location: string?

  @description('Optional. The SKU of the AI Foundry AI Project resource.')
  sku: ('Basic' | 'Free' | 'Standard' | 'Premium')?
}

@export()
@description('The type for the Conversation Knowledge Mining AI Foundry AI Services Content Understanding resource configuration.')
type ckmAiFoundryAiServicesContentUnderstandingType = {
  @description('Optional. The name of the AI Foundry AI Services Content Understanding resource.')
  @maxLength(90)
  name: string?
  @description('Optional. Location for the AI Foundry Content Understanding service deployment.')
  @metadata({ azd: { type: 'location' } })
  location: ('West US' | 'westus' | 'Sweden Central' | 'swedencentral' | 'Australia East' | 'australiaeast')?
  @description('Optional. The SKU of the AI Foundry AI Services account. Use \'Get-AzCognitiveServicesAccountSku\' to determine a valid combinations of \'kind\' and \'SKU\' for your Azure region.')
  sku: (
    | 'C2'
    | 'C3'
    | 'C4'
    | 'F0'
    | 'F1'
    | 'S'
    | 'S0'
    | 'S1'
    | 'S10'
    | 'S2'
    | 'S3'
    | 'S4'
    | 'S5'
    | 'S6'
    | 'S7'
    | 'S8'
    | 'S9')?
}

@export()
@description('The type for the Conversation Knowledge Mining AI Foundry AI Services resource configuration.')
type ckmAiFoundryAiServicesType = {
  @description('Optional. The name of the AI Foundry AI Services resource.')
  @maxLength(90)
  name: string?

  @description('Optional. Location for the AI Foundry AI Services resource.')
  @metadata({ azd: { type: 'location' } })
  location: string?

  @description('Optional. The SKU of the AI Foundry AI Services resource. Use \'Get-AzCognitiveServicesAccountSku\' to determine a valid combinations of \'kind\' and \'SKU\' for your Azure region.')
  sku: (
    | 'C2'
    | 'C3'
    | 'C4'
    | 'F0'
    | 'F1'
    | 'S'
    | 'S0'
    | 'S1'
    | 'S10'
    | 'S2'
    | 'S3'
    | 'S4'
    | 'S5'
    | 'S6'
    | 'S7'
    | 'S8'
    | 'S9')?

  @description('Optional. Name of the GPT model to deploy in the AI Foundry AI Services account.')
  gptModelName: ('gpt-4o-mini' | 'gpt-4o' | 'gpt-4')?

  @description('Optional. GPT model deployment type of the AI Foundry AI Services account.')
  gptModelSku: ('GlobalStandard' | 'Standard')?

  @minValue(10)
  @description('Optional. Capacity of the GPT model to deploy in the AI Foundry AI Services account. Capacity is limited per model/region, so you will get errors if you go over. [Quotas link](https://learn.microsoft.com/azure/ai-services/openai/quotas-limits).')
  gptModelCapacity: int?

  @description('Optional. Name of the Text Embedding model to deploy in the AI Foundry AI Services account.')
  textEmbeddingModelName: ('text-embedding-ada-002')?

  @description('Optional. GPT model deployment type of the AI Foundry AI Services account.')
  textEmbeddingModelSku: ('Standard')?

  @minValue(10)
  @description('Optional. Capacity of the Text Embedding model to deploy in the AI Foundry AI Services account. Capacity is limited per model/region, so you will get errors if you go over. [Quotas link](https://learn.microsoft.com/azure/ai-services/openai/quotas-limits).')
  textEmbeddingModelCapacity: int?
}

@export()
@description('The type for the Conversation Knowledge Mining AI Foundry Application Insights resource configuration.')
type ckmAiFoundryApplicationInsightsType = {
  @description('Optional. The name of the AI Foundry Application Insights resource.')
  @maxLength(90)
  name: string?

  @description('Optional. Location for the AI Foundry Application Insights resource.')
  @metadata({ azd: { type: 'location' } })
  location: string?

  @description('Optional. The retention of Application Insights data in days. If empty, Standard will be used.')
  retentionInDays: (120 | 180 | 270 | 30 | 365 | 550 | 60 | 730 | 90)?
}

@export()
@description('The type for the Conversation Knowledge Mining AI Foundry Container Registry resource configuration.')
type ckmAiFoundryContainerRegistryType = {
  @description('Optional. The name of the AI Foundry Container Registry resource.')
  @maxLength(50)
  name: string?

  @description('Optional. Location for the AI Foundry Container Registry resource.')
  @metadata({ azd: { type: 'location' } })
  location: string?

  @description('Optional. The SKU for the AI Foundry Container Registry resource.')
  sku: ('Basic' | 'Standard' | 'Premium')?
}

@export()
@description('The type for the Conversation Knowledge Mining AI Foundry Search Services resource configuration.')
type ckmAiFoundrySearchServiceType = {
  @description('Optional. The name of the AI Foundry Search Services resource.')
  @maxLength(60)
  name: string?

  @description('Optional. Location for the AI Foundry Search Services resource.')
  @metadata({ azd: { type: 'location' } })
  location: string?

  @description('Optional. The SKU for the AI Foundry Search Services resource.')
  sku: ('basic' | 'free' | 'standard' | 'standard2' | 'standard3' | 'storage_optimized_l1' | 'storage_optimized_l2')?
}

@export()
@description('The type for the Conversation Knowledge Mining Cosmos DB Account resource configuration.')
type ckmCosmosDbAccountType = {
  @description('Optional. The name of the Cosmos DB Account resource.')
  @maxLength(60)
  name: string?

  @description('Optional. Location for the Cosmos DB Account resource.')
  @metadata({ azd: { type: 'location' } })
  location: string?
}

@export()
@description('The type for the Conversation Knowledge Mining Function resource configuration.')
type ckmFunctionsType = {
  @description('Optional. The name of the Function resource.')
  @maxLength(60)
  name: string?

  @description('Optional. Location for the Function resource.')
  @metadata({ azd: { type: 'location' } })
  location: string?

  @description('Optional. The url of the Container Registry where the docker image for the function is located.')
  dockerImageContainerRegistryUrl: string?

  @description('Optional. The name of the docker image for the function.')
  dockerImageName: string?

  @description('Optional. The tag of the docker image for the function.')
  dockerImageTag: string?

  @description('Optional. The required CPU in cores of the function.')
  cpu: int?

  @description('Optional. The required memory in GiB of the function.')
  memory: string?

  @description('Optional. The maximum number of workers that the function can scale out.')
  appScaleLimit: int?

  @description('Optional. The name of the function to be used to get the metrics in the function.')
  functionName: string?
}

@export()
@description('The type for the Conversation Knowledge Mining Functions Managed Environment resource configuration.')
type ckmFunctionsManagedEnvironmentType = {
  @description('Optional. The name of the Functions Managed Environment resource.')
  @maxLength(60)
  name: string?

  @description('Optional. Location for the Functions Managed Environment resource.')
  @metadata({ azd: { type: 'location' } })
  location: string?
}

@export()
import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('The type for the Conversation Knowledge Mining Key Vault resource configuration.')
type ckmKeyVaultType = {
  @description('Optional. The name of the Key Vault resource.')
  @maxLength(24)
  name: string?

  @description('Optional. Location for the Key Vault resource.')
  @metadata({ azd: { type: 'location' } })
  location: string?

  @description('Optional. The SKU for the Key Vault resource.')
  sku: ('premium' | 'standard')?

  @description('Optional. The Key Vault create mode. Indicates whether the vault need to be recovered from purge or not. If empty, default will be used.')
  createMode: ('default' | 'recover')?

  @description('Optional. If set to true, The Key Vault soft delete will be enabled.')
  softDeleteEnabled: bool?

  @description('Optional. The number of days to retain the soft deleted vault. If empty, it will be set to 7.')
  @minValue(7)
  @maxValue(90)
  softDeleteRetentionInDays: int?

  @description('Optional. If set to true, The Key Vault purge protection will be enabled. If empty, it will be set to false.')
  purgeProtectionEnabled: bool?

  @description('Optional. Array of role assignments to include in the Key Vault.')
  roleAssignments: roleAssignmentType[]?
}

@export()
@description('The type for the Conversation Knowledge Mining Log Analytics Workspace resource configuration.')
type ckmLogAnalyticsWorkspaceType = {
  @description('Optional. The name of the Log Analytics Workspace resource.')
  @maxLength(63)
  name: string?

  @description('Optional. Location for the Log Analytics Workspace resource.')
  @metadata({ azd: { type: 'location' } })
  location: string?

  @description('Optional. The SKU for the Log Analytics Workspace resource.')
  sku: ('CapacityReservation' | 'Free' | 'LACluster' | 'PerGB2018' | 'PerNode' | 'Premium' | 'Standalone' | 'Standard')?

  @description('Optional. The number of days to retain the data in the Log Analytics Workspace. If empty, it will be set to 30 days.')
  @maxValue(730)
  dataRetentionInDays: int?
}

@export()
@description('The type for the Conversation Knowledge Mining Managed Identity resource configuration.')
type ckmManagedIdentityType = {
  @description('Optional. The name of the Managed Identity resource.')
  @maxLength(128)
  name: string?

  @description('Optional. Location for the Managed Identity resource.')
  @metadata({ azd: { type: 'location' } })
  location: string?
}

@export()
@description('The type for the Conversation Knowledge Mining Script resource configuration.')
type ckmScriptType = {
  @description('Optional. The name of the Script resource.')
  @maxLength(90)
  name: string?

  @description('Optional. Location for the Script resource.')
  @metadata({ azd: { type: 'location' } })
  location: string?

  @description('Optional. The base Raw Url of the GitHub repository where the Copy Data Script is located.')
  githubBaseUrl: string?

  @description('Optional. The Url where the Copy Data Script is located.')
  scriptUrl: string?
}

@export()
@description('The type for the Conversation Knowledge Mining SQL Server resource configuration.')
type ckmSqlServerType = {
  @description('Optional. The name of the SQL Server resource.')
  @maxLength(63)
  name: string?

  @description('Optional. Location for the SQL Server resource.')
  @metadata({ azd: { type: 'location' } })
  location: string?

  @description('Optional. The administrator login credential for the SQL Server.')
  @secure()
  #disable-next-line secure-parameter-default
  administratorLogin: string?

  @description('Optional. The administrator password credential for the SQL Server.')
  @secure()
  #disable-next-line secure-parameter-default
  administratorPassword: string?

  @description('Optional. The name of the SQL Server database.')
  @maxLength(128)
  databaseName: string?

  @description('Optional. The SKU name of the SQL Server database. If empty, it will be set to GP_Gen5_2. Find available options: Database.[Sku property](https://learn.microsoft.com/dotnet/api/microsoft.azure.management.sql.models.database.sku).')
  databaseSkuName: string?

  @description('Optional. The SKU tier of the SQL Server database. If empty, it will be set to GeneralPurpose. Find available options: Database.[Sku property](https://learn.microsoft.com/dotnet/api/microsoft.azure.management.sql.models.database.sku).')
  databaseSkuTier: string?

  @description('Optional. The SKU Family of the SQL Server database. If empty, it will be set to Gen5. Find available options: Database.[Sku property](https://learn.microsoft.com/dotnet/api/microsoft.azure.management.sql.models.database.sku).')
  databaseSkuFamily: string?

  @description('Optional. The SKU capacity of the SQL Server database. If empty, it will be set to 2. Find available options: Database.[Sku property](https://learn.microsoft.com/dotnet/api/microsoft.azure.management.sql.models.database.sku).')
  databaseSkuCapacity: int?
}

@export()
@description('The type for the Conversation Knowledge Mining Storage Account resource configuration.')
type ckmStorageAccountType = {
  @description('Optional. The name of the Storage Account resource.')
  @maxLength(60)
  name: string?

  @description('Optional. Location for the Storage Account resource.')
  @metadata({ azd: { type: 'location' } })
  location: string?

  @description('Optional. The SKU for the Storage Account resource.')
  sku: ('Standard_LRS' | 'Standard_GRS' | 'Standard_RAGRS' | 'Standard_ZRS' | 'Premium_LRS' | 'Premium_ZRS')?
}

@export()
@description('The type for the Conversation Knowledge Mining Web App Server Farm resource configuration.')
type ckmWebAppServerFarmType = {
  @description('Optional. The name of the Web App Server Farm resource.')
  @maxLength(60)
  name: string?

  @description('Optional. Location for the Web App Server Farm resource.')
  @metadata({ azd: { type: 'location' } })
  location: string?

  @description('Optional. The SKU for the Web App Server Farm resource.')
  sku: string?

  @description('Optional. The name of the Web App resource.')
  @maxLength(60)
  webAppResourceName: string?

  @description('Optional. Location for the Web App resource deployment.')
  @metadata({ azd: { type: 'location' } })
  webAppLocation: string?

  @description('Optional. The url of the Container Registry where the docker image for Conversation Knowledge Mining webapp is located.')
  webAppDockerImageContainerRegistryUrl: string?

  @description('Optional. The name of the docker image for the Rag function.')
  webAppDockerImageName: string?

  @description('Optional. The tag of the docker image for the Rag function.')
  webAppDockerImageTag: string?
}
