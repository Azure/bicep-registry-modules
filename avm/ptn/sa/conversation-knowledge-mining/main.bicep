//TODO: check latest versions of AVM resource modules for those that still deploy regular resources

// // ========== main.bicep ========== //
targetScope = 'resourceGroup'

metadata name = 'Conversation Knowledge Mining Solution Accelerator'
metadata description = '''This module deploys the [Conversation Knowledge Mining Solution Accelerator](https://github.com/microsoft/Conversation-Knowledge-Mining-Solution-Accelerator).

> **Note:** This module is not intended for broad, generic use, as it was designed by the Commercial Solution Areas CTO team, as a Microsoft Solution Accelerator product. Feature requests and bug fix requests are welcome if they support the needs of this organization but may not be incorporated if they aim to make this module more generic than what it needs to be for its primary use case. This module will likely be updated to leverage AVM resource modules in the future. This may result in breaking changes in upcoming versions when these features are implemented.
'''

// ========== Parameters ========== //
// PARAMETERS: names
@description('Required. The prefix to add in the default names given to all deployed Azure resources.')
@maxLength(12)
param solutionPrefix string
@description('Optional. The name of the AI Foundry AI Hub resource. It will override the default given name.')
@maxLength(90)
param aiFoundryAiHubResourceName string = ''
@description('Optional. The name of the AI Foundry AI Project resource. It will override the default given name.')
@maxLength(90)
param aiFoundryAiProjectResourceName string = ''
@description('Optional. The name of the AI Foundry AI Services Content Understanding resource. It will override the default given name.')
@maxLength(90)
param aiFoundryAiServicesContentUnderstandingResourceName string = ''
@description('Optional. The name of the AI Foundry AI Services resource. It will override the default given name.')
@maxLength(90)
param aiFoundryAiServicesResourceName string = ''
@description('Optional. The name of the AI Foundry Application Insights resource. It will override the default given name.')
@maxLength(90)
param aiFoundryApplicationInsightsResourceName string = ''
@description('Optional. The name of the AI Foundry Container Registry resource. It will override the default given name.')
@maxLength(50)
param aiFoundryContainerRegistryResourceName string = ''
@description('Optional. The name of the AI Foundry Search Service resource. It will override the default given name.')
@maxLength(60)
param aiFoundrySearchServiceResourceName string = ''
@description('Optional. The name of the AI Foundry Storage Account resource. It will override the default given name.')
@maxLength(24)
param aiFoundryStorageAccountResourceName string = ''
@description('Optional. The name of the Cosmos DB Account resource. It will override the default given name.')
@maxLength(50)
param cosmosDbAccountResourceName string = ''
@description('Optional. The name of the Function Charts resource. It will override the default given name.')
@maxLength(90)
param functionChartsResourceName string = ''
@description('Optional. The name of the Function RAG resource. It will override the default given name.')
@maxLength(90)
param functionRagResourceName string = ''
@description('Optional. The name of the Functions Managed Environment resource. It will override the default given name.')
@maxLength(90)
param functionsManagedEnvironmentResourceName string = ''
@description('Optional. The name of the Key Vault resource. It will override the default given name.')
@maxLength(24)
param keyVaultResourceName string = ''
@description('Optional. The name of the Log Analytics Workspace resource. It will override the default given name.')
@maxLength(63)
param logAnalyticsWorkspaceResourceName string = ''
@description('Optional. The name of the Managed Identity resource. It will override the default given name.')
@maxLength(128)
param managedIdentityResourceName string = ''
@description('Optional. The name of the Script Copy Data resource. It will override the default given name.')
@maxLength(90)
param scriptCopyDataResourceName string = ''
@description('Optional. The name of the Script Index Data resource. It will override the default given name.')
@maxLength(90)
param scriptIndexDataResourceName string = ''
@description('Optional. The name of the SQL Server resource. It will override the default given name.')
@maxLength(63)
param sqlServerResourceName string = ''
@description('Optional. The name of the Storage Account resource. It will override the default given name.')
@maxLength(24)
param storageAccountResourceName string = ''
@description('Optional. The name of the Web App resource.')
@maxLength(60)
param webAppResourceName string = ''
@description('Optional. The name of the Web App Server Farm resource. It will override the default given name.')
@maxLength(60)
param webAppServerFarmResourceName string = ''

// PARAMETERS: locations
//NOTE: allow for individual locations for each resource
@description('Required. Location for the AI Foundry Content Understanding service deployment.')
@allowed(['West US', 'Sweden Central', 'Australia East'])
@metadata({ azd: { type: 'location' } })
param aiFoundryAiServicesContentUnderstandingLocation string
@description('Optional. Location for the solution deployment. Defaulted to the resource group location.')
@metadata({ azd: { type: 'location' } })
param solutionLocation string = 'East US'
@description('Optional. Secondary location for databases creation.')
@metadata({ azd: { type: 'location' } })
param databasesLocation string = 'East US 2'
@description('Optional. The location for the Web App Server Farm. Defaulted to the solution location.')
@metadata({ azd: { type: 'location' } })
param webAppServerFarmLocation string = solutionLocation
@description('Optional. Location for the AI Foundry AI Hub resource deployment.')
@metadata({ azd: { type: 'location' } })
param aiFoundryAiHubLocation string = solutionLocation
@description('Optional. Location for the AI Foundry AI Service resource deployment.')
@metadata({ azd: { type: 'location' } })
param aiFoundryAiServicesLocation string = solutionLocation
@description('Optional. Location for the AI Foundry AI Project resource deployment.')
@metadata({ azd: { type: 'location' } })
param aiFoundryAiProjectLocation string = solutionLocation
@description('Optional. Location for the AI Foundry Application Insights resource deployment.')
@metadata({ azd: { type: 'location' } })
param aiFoundryApplicationInsightsLocation string = solutionLocation
@description('Optional. Location for the AI Foundry Container Registry resource deployment.')
@metadata({ azd: { type: 'location' } })
param aiFoundryContainerRegistryLocation string = solutionLocation
@description('Optional. Location for the AI Foundry Search Service resource deployment.')
@metadata({ azd: { type: 'location' } })
param aiFoundrySearchServiceLocation string = solutionLocation
@description('Optional. Location for the AI Foundry Storage Account resource deployment.')
@metadata({ azd: { type: 'location' } })
param aiFoundryStorageAccountLocation string = solutionLocation
@description('Optional. Location for the Cosmos DB Account resource deployment.')
@metadata({ azd: { type: 'location' } })
param cosmosDbAccountLocation string = databasesLocation
@description('Optional. Location for the Function Charts resource deployment.')
@metadata({ azd: { type: 'location' } })
param functionChartsLocation string = solutionLocation
@description('Optional. Location for the Function RAG resource deployment.')
@metadata({ azd: { type: 'location' } })
param functionRagLocation string = solutionLocation
@description('Optional. Location for the Functions Managed Environment resource deployment.')
@metadata({ azd: { type: 'location' } })
param functionsManagedEnvironmentLocation string = solutionLocation
@description('Optional. Location for the Key Vault resource deployment.')
@metadata({ azd: { type: 'location' } })
param keyVaultLocation string = solutionLocation
@description('Optional. Location for the Log Analytics Workspace resource deployment.')
@metadata({ azd: { type: 'location' } })
param logAnalyticsWorkspaceLocation string = solutionLocation
@description('Optional. Location for the Managed Identity resource deployment.')
@metadata({ azd: { type: 'location' } })
param managedIdentityLocation string = solutionLocation
@description('Optional. Location for the Script Copy Data resource deployment.')
@metadata({ azd: { type: 'location' } })
param scriptCopyDataLocation string = solutionLocation
@description('Optional. Location for the Script Index Data resource deployment.')
@metadata({ azd: { type: 'location' } })
param scriptIndexDataLocation string = solutionLocation
@description('Optional. Location for the SQL Server resource deployment.')
@metadata({ azd: { type: 'location' } })
param sqlServerLocation string = databasesLocation
@description('Optional. Location for the Storage Account resource deployment.')
@metadata({ azd: { type: 'location' } })
param storageAccountLocation string = solutionLocation
@description('Optional. Location for the Web App resource deployment.')
@metadata({ azd: { type: 'location' } })
param webAppLocation string = solutionLocation

// PARAMETERS: Log Analytics workspace configuration
@description('Optional. The SKU for the Log Analytics Workspace. If empty, PerGB2018 will be used.')
@allowed(['CapacityReservation', 'Free', 'LACluster', 'PerGB2018', 'PerNode', 'Premium', 'Standalone', 'Standard'])
param logAnalyticsWorkspaceSkuName string = 'PerGB2018'

@description('Optional. The number of days to retain the data in the Log Analytics Workspace. If empty, it will be set to 30 days.')
@minValue(0)
@maxValue(730)
param logAnalyticsWorkspaceDataRetentionInDays int = 30

// PARAMETERS: Key Vault configuration
@allowed(['premium', 'standard'])
@description('Optional. The SKU for the Key Vault. If empty, standard will be used.')
param keyVaultSku string = 'standard'

@description('Optional. The Key Vault create mode. Indicates whether the vault need to be recovered from purge or not. If empty, default will be used.')
@allowed(['default', 'recover'])
param keyVaultCreateMode string = 'default'

@description('Optional. If set to true, The Key Vault soft delete will be enabled. If empty, it will be set to false.')
param keyVaultSoftDeleteEnabled bool = false

@description('Optional. The number of days to retain the soft deleted vault. If empty, it will be set to 7.')
@minValue(7)
@maxValue(90)
param keyVaultSoftDeleteRetentionInDays int = 7

@description('Optional. If set to true, The Key Vault purge protection will be enabled. If empty, it will be set to false.')
param keyVaultPurgeProtectionEnabled bool = false

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to include in the Key Vault.')
param keyVaultRoleAssignments roleAssignmentType[] = []

// PARAMETERS: AI Foundry Storage Account configuration
@description('Optional. The SKU for the AI Foundry Storage Account. If empty, Standard_LRS will be used.')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
  'Premium_ZRS'
])
param aiFoundryStorageAccountSkuName string = 'Standard_LRS'

// PARAMETERS: AI Foundry Application Insights configuration

@description('Optional. The retention of Application Insights data in days. If empty, Standard will be used.')
@allowed([120, 180, 270, 30, 365, 550, 60, 730, 90])
param aiFoundryApplicationInsightsRetentionInDays int = 30

// PARAMETERS: AI Foundry Container Registry configuration
@description('Optional. The SKU for the AI Foundry Container Registry. If empty, Premium will be used.')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param aiFoundryContainerRegistrySkuName string = 'Premium'

// PARAMETERS: AI Foundry AI Services configuration
@description('Optional. The SKU of the AI Foundry AI Services account. Use \'Get-AzCognitiveServicesAccountSku\' to determine a valid combinations of \'kind\' and \'SKU\' for your Azure region.')
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
param aiFoundryAiServicesSkuName string = 'S0'
@description('Optional. GPT model deployment type of the AI Foundry AI Services account.')
@allowed([
  'Standard'
  'GlobalStandard'
])
param aiFoundryAIServicesGptModelDeploymentType string = 'GlobalStandard'
@description('Optional. Name of the GPT model to deploy in the AI Foundry AI Services account.')
@allowed([
  'gpt-4o-mini'
  'gpt-4o'
  'gpt-4'
])
param aiFoundryAIServicesGptModelName string = 'gpt-4o-mini'
@minValue(10)
@description('Optional. Capacity of the GPT model to deploy in the AI Foundry AI Services account. Capacity is limited per model/region, so you will get errors if you go over. [Quotas link](https://learn.microsoft.com/azure/ai-services/openai/quotas-limits).')
param aiFoundryAIServicesGptModelDeploymentCapacity int = 100
@description('Optional. Name of the Text Embedding model to deploy in the AI Foundry AI Services account.')
@allowed([
  'text-embedding-ada-002'
])
param aiFoundryAiServicesTextEmbeddingModelName string = 'text-embedding-ada-002'
@minValue(10)
@description('Optional. Capacity of the Text Embedding model to deploy in the AI Foundry AI Services account. Capacity is limited per model/region, so you will get errors if you go over. [Quotas link](https://learn.microsoft.com/azure/ai-services/openai/quotas-limits).')
param aiFoundryAiServicesTextEmbeddingModelCapacity int = 80

// PARAMETERS: AI Foundry AI Services Content Understanding configuration
@description('Optional. The SKU of the AI Foundry AI Services account. Use \'Get-AzCognitiveServicesAccountSku\' to determine a valid combinations of \'kind\' and \'SKU\' for your Azure region.')
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
param aiFoundryAiServicesContentUnderstandingSkuName string = 'S0'

// PARAMETERS: AI Foundry Search Services configuration
@description('Optional. The SKU of the AI Foundry Search Service account.')
@allowed([
  'basic'
  'free'
  'standard'
  'standard2'
  'standard3'
  'storage_optimized_l1'
  'storage_optimized_l2'
])
param aiFoundrySearchServiceSkuName string = 'basic'

// PARAMETERS: AI Foundry AI Hub configuration
@description('Optional. The SKU of the AI Foundry AI Hub account.')
@allowed([
  'Basic'
  'Free'
  'Standard'
  'Premium'
])
param aiFoundryAiHubSkuName string = 'Basic'

// PARAMETERS: AI Foundry AI Project configuration
@description('Optional. The SKU of the AI Foundry AI project.')
@allowed([
  'Basic'
  'Free'
  'Standard'
  'Premium'
])
param aiFoundryAiProjectSkuName string = 'Standard'

// PARAMETERS: AI Foundry Storage Account configuration
@description('Optional. The SKU for the Storage Account. If empty, Standard_LRS will be used.')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
  'Premium_ZRS'
])
param storageAccountSkuName string = 'Standard_LRS'

// PARAMETERS: SQL Server configuration
@description('Optional. The administrator login credential for the SQL Server.')
@secure()
#disable-next-line secure-parameter-default
param sqlServerAdministratorLogin string = 'sqladmin'

@description('Optional. The administrator password credential for the SQL Server.')
@secure()
#disable-next-line secure-parameter-default
param sqlServerAdministratorPassword string = 'TestPassword_1234'

@description('Optional. The name of the SQL Server database.')
@maxLength(128)
param sqlServerDatabaseName string = ''

@description('Optional. The SKU name of the SQL Server database. If empty, it will be set to GP_Gen5_2. Find available options: Database.[Sku property](https://learn.microsoft.com/dotnet/api/microsoft.azure.management.sql.models.database.sku).')
param sqlServerDatabaseSkuName string = 'GP_Gen5_2'

@description('Optional. The SKU tier of the SQL Server database. If empty, it will be set to GeneralPurpose. Find available options: Database.[Sku property](https://learn.microsoft.com/dotnet/api/microsoft.azure.management.sql.models.database.sku).')
param sqlServerDatabaseSkuTier string = 'GeneralPurpose'

@description('Optional. The SKU Family of the SQL Server database. If empty, it will be set to Gen5. Find available options: Database.[Sku property](https://learn.microsoft.com/dotnet/api/microsoft.azure.management.sql.models.database.sku).')
param sqlServerDatabaseSkuFamily string = 'Gen5'

@description('Optional. The SKU capacity of the SQL Server database. If empty, it will be set to 2. Find available options: Database.[Sku property](https://learn.microsoft.com/dotnet/api/microsoft.azure.management.sql.models.database.sku).')
param sqlServerDatabaseSkuCapacity int = 2

// PARAMETERS: Function Charts configuration
@description('Optional. The url of the Container Registry where the docker image for the Charts function is located.')
param functionChartDockerImageContainerRegistryUrl string = 'kmcontainerreg.azurecr.io'
@description('Optional. The name of the docker image for the Charts function.')
param functionChartDockerImageName string = 'km-charts-function'
@description('Optional. The tag of the docker image for the Charts function.')
param functionChartDockerImageTag string = 'latest'
@description('Optional. The required CPU in cores of the Charts function.')
param functionChartCpu int = 1
@description('Optional. The required memory in GiB of the Charts function.')
param functionChartMemory string = '2Gi'
@description('Optional. The maximum number of workers that the Charts function can scale out.')
param functionChartAppScaleLimit int = 10
@description('Optional. The name of the function to be used to get the metrics in the Charts function.')
param functionChartsFunctionName string = 'get_metrics'

// PARAMETERS: Function Rag configuration
@description('Optional. The url of the Container Registry where the docker image for the Rag function is located.')
param functionRagDockerImageContainerRegistryUrl string = 'kmcontainerreg.azurecr.io'
@description('Optional. The name of the docker image for the Rag function.')
param functionRagDockerImageName string = 'km-rag-function'
@description('Optional. The tag of the docker image for the Rag function.')
param functionRagDockerImageTag string = 'latest'
@description('Optional. The required CPU in cores of the Rag function.')
param functionRagCpu int = 1
@description('Optional. The required memory in GiB of the Rag function.')
param functionRagMemory string = '2Gi'
@description('Optional. The maximum number of workers that the Rag function can scale out.')
param functionRagAppScaleLimit int = 10
@description('Optional. The name of the function to be used to stream text in the Rag function.')
param functionRagFunctionName string = 'stream_openai_text'

// PARAMETERS: Web app configuration
@description('Optional. The SKU for the web app. If empty it will be set to B2.')
param webAppServerFarmSku string = 'B2'
@description('Optional. The url of the Container Registry where the docker image for Conversation Knowledge Mining webapp is located.')
param webAppDockerImageContainerRegistryUrl string = 'kmcontainerreg.azurecr.io'
@description('Optional. The name of the docker image for the Rag function.')
param webAppDockerImageName string = 'km-app'
@description('Optional. The tag of the docker image for the Rag function.')
param webAppDockerImageTag string = 'latest'

// PARAMETERS: Telemetry
@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

// ========== Variables ========== //
// VARIABLES: defaults
var varWorkloadNameFormat = '${solutionPrefix}-{0}' //${uniqueString(resourceGroup().id, solutionPrefix)}
var tags = {
  app: solutionPrefix
  location: solutionLocation
}
var avmDeploymentNameFormat = 'ckm-deploy-avm-{0}'
var localModuleDeploymentNameFormat = 'ckm-deploy-module-{0}'

// VARIABLES: calculated resource names

var varAiFoundryAiHubResourceName = empty(aiFoundryAiHubResourceName)
  ? format(varWorkloadNameFormat, 'aifd-aihb')
  : aiFoundryAiHubResourceName
var varAiFoundryAiProjectResourceName = empty(aiFoundryAiProjectResourceName)
  ? format(varWorkloadNameFormat, 'aifd-aipj')
  : aiFoundryAiProjectResourceName
var varAiFoundryAiServicesContentUnderstandingResourceName = empty(aiFoundryAiServicesContentUnderstandingResourceName)
  ? format(varWorkloadNameFormat, 'aifd-aisr-cu')
  : aiFoundryAiServicesContentUnderstandingResourceName
var varAiFoundryAiServiceResourceName = empty(aiFoundryAiServicesResourceName)
  ? format(varWorkloadNameFormat, 'aifd-aisr')
  : aiFoundryAiServicesResourceName
var varAiFoundryApplicationInsightsResourceName = empty(aiFoundryApplicationInsightsResourceName)
  ? format(varWorkloadNameFormat, 'aifd-appi')
  : aiFoundryApplicationInsightsResourceName
var varAiFoundryContainerRegistryResourceName = empty(aiFoundryContainerRegistryResourceName)
  ? replace(format(varWorkloadNameFormat, 'aifd-creg'), '-', '') //NOTE: ACR name should not contain hyphens
  : aiFoundryContainerRegistryResourceName
var varAiFoundrySearchServiceResourceName = empty(aiFoundrySearchServiceResourceName)
  ? format(varWorkloadNameFormat, 'aifd-srch')
  : aiFoundrySearchServiceResourceName
var varAiFoundryStorageAccountResourceName = empty(aiFoundryStorageAccountResourceName)
  ? replace(format(varWorkloadNameFormat, 'aifd-strg'), '-', '') //NOTE: SA name should not contain hyphens
  : aiFoundryStorageAccountResourceName
var varCosmosDbAccountResourceName = empty(cosmosDbAccountResourceName)
  ? format(varWorkloadNameFormat, 'cmdb')
  : cosmosDbAccountResourceName
var varFunctionChartsResourceName = empty(functionChartsResourceName)
  ? format(varWorkloadNameFormat, 'fchr-azfn')
  : functionChartsResourceName
var varFunctionRagResourceName = empty(functionRagResourceName)
  ? format(varWorkloadNameFormat, 'frag-azfn')
  : functionRagResourceName
var varFunctionsManagedEnvironmentResourceName = empty(functionsManagedEnvironmentResourceName)
  ? format(varWorkloadNameFormat, 'ftme')
  : functionsManagedEnvironmentResourceName
var varKeyVaultResourceName = empty(keyVaultResourceName)
  ? format(varWorkloadNameFormat, 'keyv') //NOTE: KV name max length is 24
  : keyVaultResourceName
var varLogAnalyticsWorkspaceResourceName = empty(logAnalyticsWorkspaceResourceName)
  ? format(varWorkloadNameFormat, 'laws')
  : logAnalyticsWorkspaceResourceName
var varManagedIdentityResourceName = empty(managedIdentityResourceName)
  ? format(varWorkloadNameFormat, 'mgid')
  : managedIdentityResourceName
var varScriptCopyDataResourceName = empty(scriptCopyDataResourceName)
  ? format(varWorkloadNameFormat, 'scrp-cpdt')
  : scriptCopyDataResourceName
var varScriptIndexDataResourceName = empty(scriptIndexDataResourceName)
  ? format(varWorkloadNameFormat, 'scrp-idxd')
  : scriptIndexDataResourceName
var varSqlServerResourceName = empty(sqlServerResourceName)
  ? format(varWorkloadNameFormat, 'sqls')
  : sqlServerResourceName
var varSqlServerDatabaseName = empty(sqlServerDatabaseName)
  ? '${varSqlServerResourceName}-ckmdb'
  : sqlServerDatabaseName

var varStorageAccountResourceName = empty(storageAccountResourceName)
  ? replace(format(varWorkloadNameFormat, 'strg'), '-', '') //NOTE: SA name should not contain hyphens
  : storageAccountResourceName
var varWebAppResourceName = empty(webAppResourceName) ? format(varWorkloadNameFormat, 'wapp-wapp') : webAppResourceName
var varWebAppServerFarmResourceName = empty(webAppServerFarmResourceName)
  ? format(varWorkloadNameFormat, 'waoo-srvf')
  : webAppServerFarmResourceName

// VARIABLES: Key Vault configuration
var varKvSecretNameAdlsAccountKey = 'ADLS-ACCOUNT-KEY'
var varKvSecretNameAzureCosmosdbAccountKey = 'AZURE-COSMOSDB-ACCOUNT-KEY'

// VARIABLES: AI Model deployments
var varAiFoundryAiServiceGPTModelVersion = '2024-07-18'
var varAiFoundryAiServiceGPTModelVersionPreview = '2024-02-15-preview'
var varAiFoundryAiServiceTextEmbeddingModelVersion = '2'
var varAiFoundryAiServiceProjectConnectionString = '${toLower(replace(aiFoundryAiProjectLocation, ' ', ''))}.api.azureml.ms;${subscription().subscriptionId};${resourceGroup().name};${varAiFoundryAiProjectResourceName}'
var varAiFoundryAIServicesModelDeployments = [
  {
    name: aiFoundryAIServicesGptModelName
    model: {
      name: aiFoundryAIServicesGptModelName
      format: 'OpenAI'
      version: varAiFoundryAiServiceGPTModelVersion //NOTE: This attribute is mandatory for AVM, but optional for ARM. Request AVM to make it optional
    }
    sku: {
      name: aiFoundryAIServicesGptModelDeploymentType
      capacity: aiFoundryAIServicesGptModelDeploymentCapacity
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
      name: 'Standard'
      capacity: aiFoundryAiServicesTextEmbeddingModelCapacity
    }
    raiPolicyName: 'Microsoft.Default'
  }
]

// VARIABLES: CosmosDB
var varCosmosDbSqlDbName = 'db_conversation_history'
var varCosmosDbSqlDbCollName = 'conversations'
var varCosmosDbAccountSqlDbContainers = [
  {
    name: varCosmosDbSqlDbCollName
    id: varCosmosDbSqlDbCollName //NOT: Might not be needed
    partitionKey: '/userId'
  }
]

// VARIABLES: Deployment scripts
var varCKMGithubBaseUrl = 'https://raw.githubusercontent.com/microsoft/Conversation-Knowledge-Mining-Solution-Accelerator/main/'
var varStorageContainerName = 'data'

// VARIABLES: Web App settings
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
  name: format(avmDeploymentNameFormat, varManagedIdentityResourceName)
  params: {
    name: varManagedIdentityResourceName
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
  name: format(avmDeploymentNameFormat, varLogAnalyticsWorkspaceResourceName)
  params: {
    name: varLogAnalyticsWorkspaceResourceName
    tags: tags
    location: logAnalyticsWorkspaceLocation
    enableTelemetry: enableTelemetry
    skuName: logAnalyticsWorkspaceSkuName
    dataRetention: logAnalyticsWorkspaceDataRetentionInDays
  }
}

// ========== Key Vault ========== //
module avmKeyVault 'br/public:avm/res/key-vault/vault:0.12.1' = {
  name: format(avmDeploymentNameFormat, varKeyVaultResourceName)
  params: {
    name: varKeyVaultResourceName
    tags: tags
    location: keyVaultLocation
    enableTelemetry: enableTelemetry
    diagnosticSettings: [{ workspaceResourceId: avmLogAnalyticsWorkspace.outputs.resourceId }]
    sku: keyVaultSku
    createMode: keyVaultCreateMode
    enableVaultForDeployment: true
    enableVaultForDiskEncryption: true
    enableVaultForTemplateDeployment: true
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
          roleDefinitionIdOrName: '00482a5a-887f-4fb3-b363-3b7fe8e74483' //NOTE: Built-in role 'Key Vault Administrator'
        }
      ],
      keyVaultRoleAssignments
    )
    secrets: [
      { name: 'ADLS-ACCOUNT-CONTAINER', value: 'data' }
      { name: 'ADLS-ACCOUNT-NAME', value: varStorageAccountResourceName }
      { name: 'TENANT-ID', value: subscription().tenantId }
      { name: 'AZURE-COSMOSDB-ACCOUNT', value: varCosmosDbAccountResourceName }
      { name: 'AZURE-COSMOSDB-DATABASE', value: varCosmosDbSqlDbName }
      { name: 'AZURE-COSMOSDB-CONVERSATIONS-CONTAINER', value: varCosmosDbSqlDbCollName }
      { name: 'AZURE-COSMOSDB-ENABLE-FEEDBACK', value: 'True' }
      { name: 'SQLDB-SERVER', value: '${varSqlServerResourceName}${environment().suffixes.sqlServerHostname}' }
      { name: 'SQLDB-DATABASE', value: varSqlServerDatabaseName }
      { name: 'SQLDB-USERNAME', value: sqlServerAdministratorLogin }
      { name: 'SQLDB-PASSWORD', value: sqlServerAdministratorPassword }
      { name: 'AZURE-OPENAI-PREVIEW-API-VERSION', value: varAiFoundryAiServiceGPTModelVersionPreview }
      { name: 'AZURE-AI-PROJECT-CONN-STRING', value: varAiFoundryAiServiceProjectConnectionString }
      { name: 'AZURE-OPEN-AI-DEPLOYMENT-MODEL', value: varAiFoundryAIServicesModelDeployments[0].model.name }
      { name: 'AZURE-OPENAI-CU-VERSION', value: '?api-version=2024-12-01-preview' }
      { name: 'AZURE-SEARCH-ENDPOINT', value: 'https://${varAiFoundrySearchServiceResourceName}.search.windows.net' }
      { name: 'AZURE-SEARCH-SERVICE', value: varAiFoundrySearchServiceResourceName }
      { name: 'AZURE-SEARCH-INDEX', value: 'transcripts_index' }
      { name: 'COG-SERVICES-NAME', value: varAiFoundryAiServiceResourceName }
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
    aiHubResourceName: varAiFoundryAiHubResourceName
    aiHubSkuName: aiFoundryAiHubSkuName
    aiProjectLocation: aiFoundryAiProjectLocation
    aiProjectResourceName: varAiFoundryAiProjectResourceName
    aiProjectSkuName: aiFoundryAiProjectSkuName
    aiServicesLocation: aiFoundryAiServicesLocation
    aiServicesContentUnderstandingLocation: aiFoundryAiServicesContentUnderstandingLocation
    aiServicesContentUnderstandingResourceName: varAiFoundryAiServicesContentUnderstandingResourceName
    aiServicesContentUnderstandingSkuName: aiFoundryAiServicesContentUnderstandingSkuName
    aiServicesModelDeployments: varAiFoundryAIServicesModelDeployments
    aiServicesResourceName: varAiFoundryAiServiceResourceName
    aiServicesSkuName: aiFoundryAiServicesSkuName
    applicationInsightsLocation: aiFoundryApplicationInsightsLocation
    applicationInsightsResourceName: varAiFoundryApplicationInsightsResourceName
    applicationInsightsRetentionInDays: aiFoundryApplicationInsightsRetentionInDays
    containerRegistryLocation: aiFoundryContainerRegistryLocation
    containerRegistryResourceName: varAiFoundryContainerRegistryResourceName
    containerRegistrySkuName: aiFoundryContainerRegistrySkuName
    enableTelemetry: enableTelemetry
    keyVaultResourceName: avmKeyVault.outputs.name
    logAnalyticsWorkspaceResourceId: avmLogAnalyticsWorkspace.outputs.resourceId
    managedIdentityPrincipalId: avmManagedIdentity.outputs.principalId
    searchServiceLocation: aiFoundrySearchServiceLocation
    searchServiceResourceName: varAiFoundrySearchServiceResourceName
    searchServiceSkuName: aiFoundrySearchServiceSkuName
    storageAccountLocation: aiFoundryStorageAccountLocation
    storageAccountResourceName: varAiFoundryStorageAccountResourceName
    storageAccountSkuName: aiFoundryStorageAccountSkuName
    tags: tags
    avmDeploymentNameFormat: avmDeploymentNameFormat
    localModuleDeploymentNameFormat: localModuleDeploymentNameFormat
  }
}

// ========== Storage Account ========== //

module avmStorageAccount 'br/public:avm/res/storage/storage-account:0.18.2' = {
  name: format(avmDeploymentNameFormat, varStorageAccountResourceName)
  params: {
    name: varStorageAccountResourceName
    tags: tags
    location: storageAccountLocation
    enableTelemetry: enableTelemetry
    diagnosticSettings: [{ workspaceResourceId: avmLogAnalyticsWorkspace.outputs.resourceId }]
    skuName: storageAccountSkuName
    kind: 'StorageV2'
    accessTier: 'Hot'
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    allowCrossTenantReplication: false
    allowSharedKeyAccess: false
    requireInfrastructureEncryption: true
    enableHierarchicalNamespace: false
    largeFileSharesState: 'Disabled'
    enableNfsV3: false
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    blobServices: {
      corsRules: []
      automaticSnapshotPolicyEnabled: false
      deleteRetentionPolicyAllowPermanentDelete: false
      deleteRetentionPolicyDays: 7
      deleteRetentionPolicyEnabled: false
      containerDeleteRetentionPolicyAllowPermanentDelete: false
      containerDeleteRetentionPolicyDays: 7
      containerDeleteRetentionPolicyEnabled: false
      diagnosticSettings: [{ workspaceResourceId: avmLogAnalyticsWorkspace.outputs.resourceId }]
      containers: [
        {
          name: 'data'
          publicAccess: 'None'
          defaultEncryptionScope: '$account-encryption-key'
          denyEncryptionScopeOverride: false
        }
      ]
    }
    roleAssignments: [
      {
        principalId: avmManagedIdentity.outputs.principalId
        roleDefinitionIdOrName: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe' //NOTE: Built-in role 'Storage Blob Data Contributor'
      }
      {
        principalId: functionCharts.identity.principalId
        //#disable-next-line BCP321
        //principalId: avmFunctionCharts.outputs.?systemAssignedMIPrincipalId
        roleDefinitionIdOrName: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe' //NOTE: Built-in role 'Storage Blob Data Contributor'
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
  name: format(avmDeploymentNameFormat, varCosmosDbAccountResourceName)
  params: {
    name: varCosmosDbAccountResourceName
    tags: tags
    location: cosmosDbAccountLocation
    enableTelemetry: enableTelemetry
    diagnosticSettings: [{ workspaceResourceId: avmLogAnalyticsWorkspace.outputs.resourceId }]
    defaultConsistencyLevel: 'Session'
    locations: [
      {
        locationName: cosmosDbAccountLocation
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
    databaseAccountOfferType: 'Standard'
    automaticFailover: false
    enableMultipleWriteLocations: false
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
  name: format(avmDeploymentNameFormat, varSqlServerResourceName)
  params: {
    name: varSqlServerResourceName
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
        name: varSqlServerDatabaseName
        diagnosticSettings: [{ workspaceResourceId: avmLogAnalyticsWorkspace.outputs.resourceId }]
        sku: {
          name: sqlServerDatabaseSkuName
          tier: sqlServerDatabaseSkuTier
          family: sqlServerDatabaseSkuFamily
          capacity: sqlServerDatabaseSkuCapacity
        }
        collation: 'SQL_Latin1_General_CP1_CI_AS'
        autoPauseDelay: 60
        minCapacity: '1'
        readScale: 'Disabled'
        zoneRedundant: false
      }
    ]
  }
}

//========== Deployment script to upload sample data ========== //

module avmDeploymentScriptCopyData 'br/public:avm/res/resources/deployment-script:0.5.1' = {
  name: format(avmDeploymentNameFormat, varScriptCopyDataResourceName)
  params: {
    kind: 'AzureCLI'
    name: varScriptCopyDataResourceName
    tags: tags
    location: scriptCopyDataLocation
    enableTelemetry: enableTelemetry
    managedIdentities: {
      userAssignedResourceIds: [
        avmManagedIdentity.outputs.resourceId
      ]
    }
    azCliVersion: '2.50.0'
    primaryScriptUri: '${varCKMGithubBaseUrl}infra/scripts/copy_kb_files.sh'
    arguments: '${avmStorageAccount.outputs.name} ${varStorageContainerName} ${varCKMGithubBaseUrl}'
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
  name: format(avmDeploymentNameFormat, varScriptIndexDataResourceName)
  params: {
    kind: 'AzureCLI'
    name: varScriptIndexDataResourceName
    tags: tags
    location: scriptIndexDataLocation
    enableTelemetry: enableTelemetry
    managedIdentities: {
      userAssignedResourceIds: [
        avmManagedIdentity.outputs.resourceId
      ]
    }
    azCliVersion: '2.52.0'
    primaryScriptUri: '${varCKMGithubBaseUrl}infra/scripts/run_create_index_scripts.sh'
    arguments: '${varCKMGithubBaseUrl} ${avmKeyVault.outputs.name}'
    timeout: 'PT1H'
    retentionInterval: 'PT1H'
    cleanupPreference: 'OnSuccess'
  }
  dependsOn: [moduleAIFoundry, avmSQLServer, avmDeploymentScriptCopyData]
}

//========== Azure function: Managed Environment ========== //

module avmFunctionsManagedEnvironment 'br/public:avm/res/app/managed-environment:0.10.0' = {
  name: format(avmDeploymentNameFormat, varFunctionsManagedEnvironmentResourceName)
  params: {
    name: varFunctionsManagedEnvironmentResourceName
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
//   name: format(avmDeploymentNameFormat, varFunctionChartsResourceName)
//   params: {
//     name: varFunctionChartsResourceName
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
//       SQLDB_DATABASE: varSqlServerDatabaseName
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
  name: varFunctionChartsResourceName
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
          value: varSqlServerDatabaseName
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
    ragFunctionName: varFunctionRagResourceName
    ragStorageAccountName: moduleAIFoundry.outputs.storageAccountName
    solutionLocation: functionRagLocation
    sqlDatabaseName: varSqlServerDatabaseName
    sqlServerAdministratorLogin: sqlServerAdministratorLogin
    sqlServerAdministratorPassword: sqlServerAdministratorPassword
    sqlServerFullyQualifiedDomainName: avmSQLServer.outputs.fullyQualifiedDomainName
    tags: tags
  }
}

module rbacAiprojectAideveloper 'modules/rbac-aiproject-aideveloper.bicep' = {
  name: format(localModuleDeploymentNameFormat, 'rbac-aiproject-aideveloper')
  params: {
    aiServicesProjectResourceName: moduleAIFoundry.outputs.aiProjectName
    identityPrincipalId: moduleFunctionRAG.outputs.principalId
    aiServicesProjectResourceId: moduleAIFoundry.outputs.aiProjectResourceId
    ragFunctionResourceId: moduleFunctionRAG.outputs.resourceId
  }
}

//========== CKM Webapp ========== //

module avmServerFarmWebapp 'br/public:avm/res/web/serverfarm:0.4.1' = {
  name: format(avmDeploymentNameFormat, varWebAppServerFarmResourceName)
  params: {
    name: varWebAppServerFarmResourceName
    tags: tags
    location: webAppServerFarmLocation
    enableTelemetry: enableTelemetry
    diagnosticSettings: [{ workspaceResourceId: avmLogAnalyticsWorkspace.outputs.resourceId }]
    skuName: webAppServerFarmSku
    reserved: true
    kind: 'linux'
  }
}

module moduleWebsiteWebapp 'modules/webapp.bicep' = {
  name: format(localModuleDeploymentNameFormat, 'webapp')
  params: {
    deploymentName: format(avmDeploymentNameFormat, varWebAppResourceName)
    webAppName: varWebAppResourceName
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
    managedIdentityDefaultHostName: functionCharts.properties.defaultHostName
    //managedIdentityDefaultHostName: avmFunctionCharts.outputs.defaultHostname
    chartsFunctionFunctionName: functionChartsFunctionName
    webAppAppConfigReact: varWebAppAppConfigReact
    cosmosDbSqlDbName: varCosmosDbSqlDbName
    cosmosDbSqlDbNameCollectionName: varCosmosDbSqlDbCollName
    ragFunctionDefaultHostName: moduleFunctionRAG.outputs.defaultHostName
    ragFunctionFunctionName: functionRagFunctionName
    avmCosmosDbResourceName: avmCosmosDB.outputs.name
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
output webAppUrl string = '${varWebAppResourceName}.azurewebsites.net'
