targetScope = 'subscription'

metadata name = 'Chat with your Data Solution Accelerator - Pattern Module'
metadata description = 'This module deploys an Azure AI Pattern Module.'
metadata owner = 'Azure/module-maintainers'

@description('Provide a 2-13 character prefix for all resources.')
param ResourcePrefix string

@description('Resource group name.')
param resourceGroup string = '${ResourcePrefix}-rg'

@description('Location for all resources.')
param Location string = deployment().location

@description('Name of App Service plan')
param HostingPlanName string = '${ResourcePrefix}-hosting-plan'

@description('The pricing tier for the App Service plan')
@allowed([
  'F1'
  'D1'
  'B1'
  'B2'
  'B3'
  'S1'
  'S2'
  'S3'
  'P1'
  'P2'
  'P3'
  'P4'
])
param HostingPlanSku string = 'B3'

@description('Name of Web App')
param WebsiteName string = '${ResourcePrefix}-website'

@description('Name of Log Analytics Workspace for App Insights')
param logAnalyticsWorkspaceName string = '${ResourcePrefix}-loganalytics'

@description('Name of Application Insights')
param ApplicationInsightsName string = '${ResourcePrefix}-appinsights'

@description('Use semantic search')
param AzureSearchUseSemanticSearch string = 'false'

@description('Semantic search config')
param AzureSearchSemanticSearchConfig string = 'default'

@description('Is the index prechunked')
param AzureSearchIndexIsPrechunked string = 'false'

@description('Top K results')
param AzureSearchTopK string = '5'

@description('Enable in domain')
param AzureSearchEnableInDomain string = 'false'

@description('Content columns')
param AzureSearchContentColumns string = 'content'

@description('Filename column')
param AzureSearchFilenameColumn string = 'filename'

@description('Title column')
param AzureSearchTitleColumn string = 'title'

@description('Url column')
param AzureSearchUrlColumn string = 'url'

@description('Name of Azure OpenAI Resource')
param AzureOpenAIResource string = '${ResourcePrefix}oai'

@description('Azure OpenAI GPT Model Deployment Name')
param AzureOpenAIGPTModel string = 'gpt-35-turbo'

@description('Azure OpenAI GPT Model Name')
param AzureOpenAIGPTModelName string = 'gpt-35-turbo'

@description('Azure OpenAI GPT Model Version')
param AzureOpenAIGPTModelVersion string = '0613'

@description('Azure OpenAI Embedding Model Deployment Name')
param AzureOpenAIEmbeddingModel string = 'text-embedding-ada-002'

@description('Azure OpenAI GPT Model Name')
param AzureOpenAIEmbeddingModelName string = 'text-embedding-ada-002'

@description('Azure OpenAI GPT Model Version')
param AzureOpenAIEmbeddingModelVersion string = '2'

@description('Orchestration strategy: openai_function or langchain str. If you use a old version of turbo (0301), plese select langchain')
@allowed([
  'openai_function'
  'langchain'
])
param OrchestrationStrategy string

@description('Azure OpenAI Temperature')
param AzureOpenAITemperature string = '0'

@description('Azure OpenAI Top P')
param AzureOpenAITopP string = '1'

@description('Azure OpenAI Max Tokens')
param AzureOpenAIMaxTokens string = '1000'

@description('Azure OpenAI Stop Sequence')
param AzureOpenAIStopSequence string = '\n'

@description('Azure OpenAI System Message')
param AzureOpenAISystemMessage string = 'You are an AI assistant that helps people find information.'

@description('Azure OpenAI Api Version')
param AzureOpenAIApiVersion string = '2023-07-01-preview'

@description('Whether or not to stream responses from Azure OpenAI')
param AzureOpenAIStream string = 'true'

@description('Azure AI Search Resource')
param AzureCognitiveSearch string = '${ResourcePrefix}-search'

@description('The SKU of the search service you want to create. E.g. free or standard')
@allowed([
  'free'
  'basic'
  'standard'
  'standard2'
  'standard3'
])
param AzureCognitiveSearchSku string = 'standard'

@description('Azure AI Search Index')
param AzureSearchIndex string = '${ResourcePrefix}-index'

@description('Azure AI Search Conversation Log Index')
param AzureSearchConversationLogIndex string = 'conversations'

@description('Name of Storage Account')
param StorageAccountName string = '${ResourcePrefix}str'

@description('Name of Function App for Batch document processing')
param FunctionName string = '${ResourcePrefix}-backend'

@description('Azure Form Recognizer Name')
param FormRecognizerName string = '${ResourcePrefix}-formrecog'

@description('Azure Form Recognizer Location')
param FormRecognizerLocation string = Location

@description('Azure Speech Service Name')
param SpeechServiceName string = '${ResourcePrefix}-speechservice'

@description('Azure Content Safety Name')
param ContentSafetyName string = '${ResourcePrefix}-contentsafety'
param newGuidString string = newGuid()

@allowed([
  'keys'
  'rbac'
])
param authType string = 'keys'

@description('Id of the user or app to assign application roles')
param principalId string = ''

var WebAppImageName = 'DOCKER|fruoccopublic.azurecr.io/rag-webapp'
var AdminWebAppImageName = 'DOCKER|fruoccopublic.azurecr.io/rag-adminwebapp'
var BackendImageName = 'DOCKER|fruoccopublic.azurecr.io/rag-backend'

var BlobContainerName = 'documents'
var QueueName = 'doc-processing'
var ClientKey = '${uniqueString(guid(resourceGroup().id, deployment().name))}${newGuidString}'
var EventGridSystemTopicName = 'doc-processing'

// Resources

resource rgResource 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: resourceGroup
  location: Location
}

module OpenAI 'br/public:avm/res/cognitive-services/account:0.3.4' = {
  scope: rgResource
  name: '${uniqueString(deployment().name)}-${AzureOpenAIResource}'
  params: {
    location: Location
    kind: 'OpenAI' // TODO; Waiting for https://github.com/Azure/bicep-registry-modules/pull/980
    name: AzureOpenAIResource
    sku: 'S0'
    customSubDomainName: AzureOpenAIResource
    managedIdentities: {
      systemAssigned: true
    }
  }
}

resource OpenAIGPTDeployment 'Microsoft.CognitiveServices/accounts/deployments@2023-05-01' = {
  name: AzureOpenAIGPTModelName
  parent: OpenAI // TODO
  properties: {
    model: {
      format: 'OpenAI'
      name: AzureOpenAIGPTModel
      version: AzureOpenAIGPTModelVersion
    }
  }
  sku: {
    name: 'Standard'
    capacity: 30
  }
}

resource OpenAIEmbeddingDeployment 'Microsoft.CognitiveServices/accounts/deployments@2023-05-01' = {
  name: AzureOpenAIEmbeddingModelName
  parent: OpenAI // TODO
  properties: {
    model: {
      format: 'OpenAI'
      name: AzureOpenAIEmbeddingModel
      version: AzureOpenAIEmbeddingModelVersion
    }
  }
  sku: {
    name: 'Standard'
    capacity: 30
  }
  dependsOn: [
    OpenAIGPTDeployment
  ]
}

module AzureCognitiveSearch_resource 'br/public:avm/res/search/search-service:0.1.5' = {
  scope: rgResource
  name: '${uniqueString(deployment().name)}-${AzureCognitiveSearch}'
  params: {
    location: Location
    name: AzureCognitiveSearch
    tags: {
      deployment: 'chatwithyourdata-sa'
    }
    sku: AzureCognitiveSearchSku
    managedIdentities: {
      systemAssigned: true
    }
    authOptions: authType == 'keys' ? {
      aadOrApiKey: {
        aadAuthFailureMode: 'http401WithBearerChallenge'
      }
    } : null
    disableLocalAuth: authType == 'keys' ? false : true
    replicaCount: 1
    partitionCount: 1
  }
}

module SpeechService 'br/public:avm/res/cognitive-services/account:0.3.4' = {
  scope: rgResource
  name: '${uniqueString(deployment().name)}-${SpeechServiceName}'
  params: {
    name: SpeechServiceName
    sku: 'S0'
    kind: 'SpeechServices'
    networkAcls: {
      defaultAction: 'Allow'
      virtualNetworkRules: []
      ipRules: []
    }
    publicNetworkAccess: 'Enabled'
  }
}

resource FormRecognizer 'Microsoft.CognitiveServices/accounts@2022-12-01' = {
  name: FormRecognizerName
  location: FormRecognizerLocation
  sku: {
    name: 'S0'
  }
  kind: 'FormRecognizer'
  identity: {
    type: 'None'
  }
  properties: {
    networkAcls: {
      defaultAction: 'Allow'
      virtualNetworkRules: []
      ipRules: []
    }
    publicNetworkAccess: 'Enabled'
  }
}

resource ContentSafety 'Microsoft.CognitiveServices/accounts@2022-03-01' = {
  name: ContentSafetyName
  location: Location
  sku: {
    name: 'S0'
  }
  kind: 'ContentSafety'
  identity: {
    type: 'None'
  }
  properties: {
    networkAcls: {
      defaultAction: 'Allow'
      virtualNetworkRules: []
      ipRules: []
    }
  }
}

module HostingPlan 'br/public:avm/res/web/serverfarm:0.1.0' = {
  scope: rgResource
  name: '${uniqueString(deployment().name)}-${HostingPlanName}'
  params: {
    name: HostingPlanName
    location: Location
    sku: {
      name: HostingPlanSku
    }
    reserved: true
    kind: 'Linux'
  }
}

module Website 'br/public:avm/res/web/site:0.2.0' = {
  scope: rgResource
  name: '${uniqueString(deployment().name)}-${WebsiteName}'
  params: {
    name: WebsiteName
    serverFarmResourceId: HostingPlan.outputs.resourceId
    siteConfig: {
      appSettings: [
        { name: 'APPINSIGHTS_INSTRUMENTATIONKEY', value: reference(ApplicationInsights.id, '2015-05-01').InstrumentationKey }
        { name: 'AZURE_SEARCH_SERVICE', value: 'https://${AzureCognitiveSearch}.search.windows.net' }
        { name: 'AZURE_AUTH_TYPE', value: authType }
        { name: 'AZURE_SEARCH_KEY', value: authType == 'keys' ? listAdminKeys('Microsoft.Search/searchServices/${AzureCognitiveSearch}', '2021-04-01-preview').primaryKey : null }
        { name: 'AZURE_SEARCH_INDEX', value: AzureSearchIndex }
        { name: 'AZURE_SEARCH_USE_SEMANTIC_SEARCH', value: AzureSearchUseSemanticSearch }
        { name: 'AZURE_SEARCH_SEMANTIC_SEARCH_CONFIG', value: AzureSearchSemanticSearchConfig }
        { name: 'AZURE_SEARCH_INDEX_IS_PRECHUNKED', value: AzureSearchIndexIsPrechunked }
        { name: 'AZURE_SEARCH_TOP_K', value: AzureSearchTopK }
        { name: 'AZURE_SEARCH_ENABLE_IN_DOMAIN', value: AzureSearchEnableInDomain }
        { name: 'AZURE_SEARCH_CONTENT_COLUMNS', value: AzureSearchContentColumns }
        { name: 'AZURE_SEARCH_FILENAME_COLUMN', value: AzureSearchFilenameColumn }
        { name: 'AZURE_SEARCH_TITLE_COLUMN', value: AzureSearchTitleColumn }
        { name: 'AZURE_SEARCH_URL_COLUMN', value: AzureSearchUrlColumn }
        { name: 'AZURE_OPENAI_RESOURCE', value: AzureOpenAIResource }
        { name: 'AZURE_OPENAI_KEY', value: authType == 'keys' ? OpenAI.listKeys('2023-05-01').key1 : null }
        { name: 'AZURE_OPENAI_MODEL', value: AzureOpenAIGPTModel }
        { name: 'AZURE_OPENAI_MODEL_NAME', value: AzureOpenAIGPTModelName }
        { name: 'AZURE_OPENAI_TEMPERATURE', value: AzureOpenAITemperature }
        { name: 'AZURE_OPENAI_TOP_P', value: AzureOpenAITopP }
        { name: 'AZURE_OPENAI_MAX_TOKENS', value: AzureOpenAIMaxTokens }
        { name: 'AZURE_OPENAI_STOP_SEQUENCE', value: AzureOpenAIStopSequence }
        { name: 'AZURE_OPENAI_SYSTEM_MESSAGE', value: AzureOpenAISystemMessage }
        { name: 'AZURE_OPENAI_API_VERSION', value: AzureOpenAIApiVersion }
        { name: 'AZURE_OPENAI_STREAM', value: AzureOpenAIStream }
        { name: 'AZURE_OPENAI_EMBEDDING_MODEL', value: AzureOpenAIEmbeddingModel }
        { name: 'AZURE_FORM_RECOGNIZER_ENDPOINT', value: 'https://${Location}.api.cognitive.microsoft.com/' }
        { name: 'AZURE_FORM_RECOGNIZER_KEY', value: listKeys('Microsoft.CognitiveServices/accounts/${FormRecognizerName}', '2023-05-01').key1 }
        { name: 'AZURE_BLOB_ACCOUNT_NAME', value: StorageAccountName }
        { name: 'AZURE_BLOB_ACCOUNT_KEY', value: listKeys(StorageAccount.id, '2019-06-01').keys[0].value }
        { name: 'AZURE_BLOB_CONTAINER_NAME', value: BlobContainerName }
        { name: 'DOCUMENT_PROCESSING_QUEUE_NAME', value: QueueName }
        { name: 'BACKEND_URL', value: 'https://${FunctionName}.azurewebsites.net' }
        { name: 'FUNCTION_KEY', value: ClientKey }
        { name: 'ORCHESTRATION_STRATEGY', value: OrchestrationStrategy }
        { name: 'AZURE_CONTENT_SAFETY_ENDPOINT', value: 'https://${Location}.api.cognitive.microsoft.com/' }
        { name: 'AZURE_CONTENT_SAFETY_KEY', value: listKeys('Microsoft.CognitiveServices/accounts/${ContentSafetyName}', '2023-05-01').key1 }
      ]
      linuxFxVersion: AdminWebAppImageName
      minTlsVersion: '1.2'
    }
    managedIdentities: authType == 'rbac' ? {
      systemAssigned: true
    } : null
    dependsOn: [
      HostingPlan
    ]
  }
}

module WebsiteName_admin 'br/public:avm/res/web/site:0.2.0' = {
  scope: rgResource
  name: '${uniqueString(deployment().name)}-${WebsiteName}-admin'
  params: {
    name: '${WebsiteName}-admin'
    serverFarmResourceId: HostingPlan.outputs.resourceId
    siteConfig: {
      appSettings: [
        { name: 'APPINSIGHTS_INSTRUMENTATIONKEY', value: reference(ApplicationInsights.id, '2015-05-01').InstrumentationKey }
        { name: 'AZURE_SEARCH_SERVICE', value: 'https://${AzureCognitiveSearch}.search.windows.net' }
        { name: 'AZURE_AUTH_TYPE', value: authType }
        { name: 'AZURE_SEARCH_KEY', value: authType == 'keys' ? listAdminKeys('Microsoft.Search/searchServices/${AzureCognitiveSearch}', '2021-04-01-preview').primaryKey : null }
        { name: 'AZURE_SEARCH_INDEX', value: AzureSearchIndex }
        { name: 'AZURE_SEARCH_USE_SEMANTIC_SEARCH', value: AzureSearchUseSemanticSearch }
        { name: 'AZURE_SEARCH_SEMANTIC_SEARCH_CONFIG', value: AzureSearchSemanticSearchConfig }
        { name: 'AZURE_SEARCH_INDEX_IS_PRECHUNKED', value: AzureSearchIndexIsPrechunked }
        { name: 'AZURE_SEARCH_TOP_K', value: AzureSearchTopK }
        { name: 'AZURE_SEARCH_ENABLE_IN_DOMAIN', value: AzureSearchEnableInDomain }
        { name: 'AZURE_SEARCH_CONTENT_COLUMNS', value: AzureSearchContentColumns }
        { name: 'AZURE_SEARCH_FILENAME_COLUMN', value: AzureSearchFilenameColumn }
        { name: 'AZURE_SEARCH_TITLE_COLUMN', value: AzureSearchTitleColumn }
        { name: 'AZURE_SEARCH_URL_COLUMN', value: AzureSearchUrlColumn }
        { name: 'AZURE_OPENAI_RESOURCE', value: AzureOpenAIResource }
        { name: 'AZURE_OPENAI_KEY', value: authType == 'keys' ? OpenAI.listKeys('2023-05-01').key1 : null }
        { name: 'AZURE_OPENAI_MODEL', value: AzureOpenAIGPTModel }
        { name: 'AZURE_OPENAI_MODEL_NAME', value: AzureOpenAIGPTModelName }
        { name: 'AZURE_OPENAI_TEMPERATURE', value: AzureOpenAITemperature }
        { name: 'AZURE_OPENAI_TOP_P', value: AzureOpenAITopP }
        { name: 'AZURE_OPENAI_MAX_TOKENS', value: AzureOpenAIMaxTokens }
        { name: 'AZURE_OPENAI_STOP_SEQUENCE', value: AzureOpenAIStopSequence }
        { name: 'AZURE_OPENAI_SYSTEM_MESSAGE', value: AzureOpenAISystemMessage }
        { name: 'AZURE_OPENAI_API_VERSION', value: AzureOpenAIApiVersion }
        { name: 'AZURE_OPENAI_STREAM', value: AzureOpenAIStream }
        { name: 'AZURE_OPENAI_EMBEDDING_MODEL', value: AzureOpenAIEmbeddingModel }
        { name: 'AZURE_FORM_RECOGNIZER_ENDPOINT', value: 'https://${Location}.api.cognitive.microsoft.com/' }
        { name: 'AZURE_FORM_RECOGNIZER_KEY', value: listKeys('Microsoft.CognitiveServices/accounts/${FormRecognizerName}', '2023-05-01').key1 }
        { name: 'AZURE_BLOB_ACCOUNT_NAME', value: StorageAccountName }
        { name: 'AZURE_BLOB_ACCOUNT_KEY', value: listKeys(StorageAccount.id, '2019-06-01').keys[0].value }
        { name: 'AZURE_BLOB_CONTAINER_NAME', value: BlobContainerName }
        { name: 'DOCUMENT_PROCESSING_QUEUE_NAME', value: QueueName }
        { name: 'BACKEND_URL', value: 'https://${FunctionName}.azurewebsites.net' }
        { name: 'FUNCTION_KEY', value: ClientKey }
        { name: 'ORCHESTRATION_STRATEGY', value: OrchestrationStrategy }
        { name: 'AZURE_CONTENT_SAFETY_ENDPOINT', value: 'https://${Location}.api.cognitive.microsoft.com/' }
        { name: 'AZURE_CONTENT_SAFETY_KEY', value: listKeys('Microsoft.CognitiveServices/accounts/${ContentSafetyName}', '2023-05-01').key1 }
      ]
      linuxFxVersion: AdminWebAppImageName
      minTlsVersion: '1.2'
    }
    managedIdentities: authType == 'rbac' ? {
      systemAssigned: true
    } : null
    dependsOn: [
      HostingPlan
    ]
  }
}

resource StorageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: StorageAccountName
  location: Location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_GRS'
  }
  properties: {
    minimumTlsVersion: 'TLS1_2'
  }
}

resource StorageAccountName_default_BlobContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-08-01' = {
  name: '${StorageAccountName}/default/${BlobContainerName}'
  properties: {
    publicAccess: 'None'
  }
  dependsOn: [
    StorageAccount
  ]
}

resource StorageAccountName_default_config 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-08-01' = {
  name: '${StorageAccountName}/default/config'
  properties: {
    publicAccess: 'None'
  }
  dependsOn: [
    StorageAccount
  ]
}

resource StorageAccountName_default 'Microsoft.Storage/storageAccounts/queueServices@2022-09-01' = {
  parent: StorageAccount
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource StorageAccountName_default_doc_processing 'Microsoft.Storage/storageAccounts/queueServices/queues@2022-09-01' = {
  parent: StorageAccountName_default
  name: 'doc-processing'
  properties: {
    metadata: {}
  }
  dependsOn: []
}

resource StorageAccountName_default_doc_processing_poison 'Microsoft.Storage/storageAccounts/queueServices/queues@2022-09-01' = {
  parent: StorageAccountName_default
  name: 'doc-processing-poison'
  properties: {
    metadata: {}
  }
  dependsOn: []
}

module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.2.0' = {
  scope: rgResource
  name: '${uniqueString(deployment().name)}-${logAnalyticsWorkspaceName}'
  params: {
    name: logAnalyticsWorkspaceName
    location: Location
    sku: 'PerGB2018'
  }
}

resource ApplicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: ApplicationInsightsName
  location: Location
  tags: {
    'hidden-link:${resourceId('Microsoft.Web/sites', ApplicationInsightsName)}': 'Resource'
  }
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspace.id
  }
  kind: 'web'
}

module Function 'br/public:avm/res/web/site:0.2.0' = {
  scope: rgResource
  name: '${uniqueString(deployment().name)}-${FunctionName}'
  params: {
    name: FunctionName
    kind: 'functionapp,linux'
    serverFarmResourceId: HostingPlan.outputs.resourceId
    clientAffinityEnabled: false
    httpsOnly: true
    siteConfig: {
      appSettings: [
        { name: 'FUNCTIONS_EXTENSION_VERSION', value: '~4' }
        { name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE', value: 'false' }
        { name: 'APPINSIGHTS_INSTRUMENTATIONKEY', value: reference(ApplicationInsights.id, '2015-05-01').InstrumentationKey }
        { name: 'AzureWebJobsStorage', value: 'DefaultEndpointsProtocol=https;AccountName=${StorageAccountName};AccountKey=${listKeys(StorageAccount.id, '2019-06-01').keys[0].value};EndpointSuffix=core.windows.net' }
        { name: 'AZURE_AUTH_TYPE', value: authType }
        { name: 'AZURE_OPENAI_MODEL', value: AzureOpenAIGPTModel }
        { name: 'AZURE_OPENAI_EMBEDDING_MODEL', value: AzureOpenAIEmbeddingModel }
        { name: 'AZURE_OPENAI_RESOURCE', value: AzureOpenAIResource }
        { name: 'AZURE_OPENAI_KEY', value: authType == 'keys' ? OpenAI.listKeys('2023-05-01').key1 : null }
        { name: 'AZURE_BLOB_ACCOUNT_NAME', value: StorageAccountName }
        { name: 'AZURE_BLOB_ACCOUNT_KEY', value: listKeys(StorageAccount.id, '2019-06-01').keys[0].value }
        { name: 'AZURE_BLOB_CONTAINER_NAME', value: BlobContainerName }
        { name: 'AZURE_FORM_RECOGNIZER_ENDPOINT', value: 'https://${Location}.api.cognitive.microsoft.com/' }
        { name: 'AZURE_FORM_RECOGNIZER_KEY', value: listKeys('Microsoft.CognitiveServices/accounts/${FormRecognizerName}', '2023-05-01').key1 }
        { name: 'AZURE_SEARCH_SERVICE', value: 'https://${AzureCognitiveSearch}.search.windows.net' }
        { name: 'AZURE_SEARCH_KEY', value: authType == 'keys' ? listAdminKeys('Microsoft.Search/searchServices/${AzureCognitiveSearch}', '2021-04-01-preview').primaryKey : null }
        { name: 'DOCUMENT_PROCESSING_QUEUE_NAME', value: QueueName }
        { name: 'AZURE_OPENAI_API_VERSION', value: AzureOpenAIApiVersion }
        { name: 'AZURE_SEARCH_INDEX', value: AzureSearchIndex }
        { name: 'ORCHESTRATION_STRATEGY', value: OrchestrationStrategy }
        { name: 'AZURE_CONTENT_SAFETY_ENDPOINT', value: 'https://${Location}.api.cognitive.microsoft.com/' }
        { name: 'AZURE_CONTENT_SAFETY_KEY', value: listKeys('Microsoft.CognitiveServices/accounts/${ContentSafetyName}', '2023-05-01').key1 }
      ]
      cors: {
        allowedOrigins: [
          'https://portal.azure.com'
        ]
      }
      use32BitWorkerProcess: false
      linuxFxVersion: BackendImageName
      appCommandLine: ''
      alwaysOn: true
      minTlsVersion: '1.2'
    }
    managedIdentities: authType == 'rbac' ? {
      systemAssigned: true
    } : null
    dependsOn: [
      HostingPlan
    ]
  }
}

resource FunctionName_default_clientKey 'Microsoft.Web/sites/host/functionKeys@2018-11-01' = {
  name: '${FunctionName}/default/clientKey'
  properties: {
    name: 'ClientKey'
    value: ClientKey
  }
  dependsOn: [
    Function
    WaitFunctionDeploymentSection
  ]
}

resource WaitFunctionDeploymentSection 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  kind: 'AzurePowerShell'
  name: 'WaitFunctionDeploymentSection'
  location: Location
  properties: {
    azPowerShellVersion: '3.0'
    scriptContent: 'start-sleep -Seconds 300'
    cleanupPreference: 'Always'
    retentionInterval: 'PT1H'
  }
  dependsOn: [
    Function
  ]
}

resource EventGridSystemTopic 'Microsoft.EventGrid/systemTopics@2021-12-01' = {
  name: EventGridSystemTopicName
  location: Location
  properties: {
    source: StorageAccount.id
    topicType: 'Microsoft.Storage.StorageAccounts'
  }
}

resource EventGridSystemTopicName_BlobEvents 'Microsoft.EventGrid/systemTopics/eventSubscriptions@2021-12-01' = {
  parent: EventGridSystemTopic
  name: 'BlobEvents'
  properties: {
    destination: {
      endpointType: 'StorageQueue'
      properties: {
        queueMessageTimeToLiveInSeconds: -1
        queueName: StorageAccountName_default_doc_processing.name
        resourceId: StorageAccount.id
      }
    }
    filter: {
      includedEventTypes: [
        'Microsoft.Storage.BlobCreated'
        'Microsoft.Storage.BlobDeleted'
      ]
      enableAdvancedFilteringOnArrays: true
      subjectBeginsWith: '/blobServices/default/containers/${BlobContainerName}/blobs/'
    }
    labels: []
    eventDeliverySchema: 'EventGridSchema'
    retryPolicy: {
      maxDeliveryAttempts: 30
      eventTimeToLiveInMinutes: 1440
    }
  }
}

module rgRbac 'br/public:avm/res/resources/resource-group:0.2.2' = {
  name: '${uniqueString(deployment().name)}-rg'
  params: {
    name: resourceGroup
    location: Location
    roleAssignments: authType == 'rbac' ? [
      {
        // Cognitive Services OpenAI Contributor role for Search resource
        principalId: AzureCognitiveSearch_resource.outputs.systemAssignedMIPrincipalId
        roleDefinitionIdOrName: 'a001fd3d-188f-4b5d-821b-7da978bf7442'
        principalType: 'ServicePrincipal'
      }
      {
        // Cognitive Services OpenAI Contributor role for the Website resource
        principalId: Website.outputs.systemAssignedMIPrincipalId
        roleDefinitionIdOrName: 'a001fd3d-188f-4b5d-821b-7da978bf7442'
        principalType: 'ServicePrincipal'
      }
      {
        // Cognitive Services OpenAI Contributor role for the Function resource
        principalId: Function.outputs.systemAssignedMIPrincipalId
        roleDefinitionIdOrName: 'a001fd3d-188f-4b5d-821b-7da978bf7442'
        principalType: 'ServicePrincipal'
      }
      {
        // Cognitive Services OpenAI Contributor role for the Admin Website resource
        principalId: WebsiteName_admin.outputs.systemAssignedMIPrincipalId
        roleDefinitionIdOrName: 'a001fd3d-188f-4b5d-821b-7da978bf7442'
        principalType: 'ServicePrincipal'
      }
      {
        // Cognitive Services OpenAI User role for the Website resource
        principalId: Website.outputs.systemAssignedMIPrincipalId
        roleDefinitionIdOrName: '5e0bd9bd-7b93-4f28-af87-19fc36ad61bd'
        principalType: 'ServicePrincipal'
      }
      {
        // Search Index Data Reader role for the OpenAI resource
        principalId: OpenAI.outputs.systemAssignedMIPrincipalId
        roleDefinitionIdOrName: '1407120a-92aa-4202-b7e9-c0e197c71c8f'
        principalType: 'ServicePrincipal'
      }
      {
        // Search Service Contributor role for the OpenAI resource
        principalId: OpenAI.outputs.systemAssignedMIPrincipalId
        roleDefinitionIdOrName: '7ca78c08-252a-4471-8644-bb5ff32d4ba0'
        principalType: 'ServicePrincipal'
      }
      {
        // Search Service Contributor role for the Website resource
        principalId: Website.outputs.systemAssignedMIPrincipalId
        roleDefinitionIdOrName: '7ca78c08-252a-4471-8644-bb5ff32d4ba0'
        principalType: 'ServicePrincipal'
      }
      {
        // Search Service Contributor role for the Function resource
        principalId: Function.outputs.systemAssignedMIPrincipalId
        roleDefinitionIdOrName: '7ca78c08-252a-4471-8644-bb5ff32d4ba0'
        principalType: 'ServicePrincipal'
      }
      {
        // Search Service Contributor role for the Admin Website resource
        principalId: WebsiteName_admin.outputs.systemAssignedMIPrincipalId
        roleDefinitionIdOrName: '7ca78c08-252a-4471-8644-bb5ff32d4ba0'
        principalType: 'ServicePrincipal'
      }
      {
        // Search Index Data Reader role for the Website resource
        principalId: Website.outputs.systemAssignedMIPrincipalId
        roleDefinitionIdOrName: '1407120a-92aa-4202-b7e9-c0e197c71c8f'
        principalType: 'ServicePrincipal'
      }
      {
        // Storage Blob Data Reader role for the Website resource
        principalId: Website.outputs.systemAssignedMIPrincipalId
        roleDefinitionIdOrName: '2a2b9908-6ea1-4ae2-8e65-a410df84e7d1'
        principalType: 'ServicePrincipal'
      }
      {
        // Storage Blob Data Reader role for the Function resource
        principalId: Function.outputs.systemAssignedMIPrincipalId
        roleDefinitionIdOrName: '2a2b9908-6ea1-4ae2-8e65-a410df84e7d1'
        principalType: 'ServicePrincipal'
      }
      {
        // Storage Blob Data Reader role for the Admin Website resource
        principalId: WebsiteName_admin.outputs.systemAssignedMIPrincipalId
        roleDefinitionIdOrName: '2a2b9908-6ea1-4ae2-8e65-a410df84e7d1'
        principalType: 'ServicePrincipal'
      }
      {
        // Reader role for the Website resource
        // Used to read index definitions
        principalId: Website.outputs.systemAssignedMIPrincipalId
        roleDefinitionIdOrName: 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
        principalType: 'ServicePrincipal'
      }
      {
        // Reader role for the Function resource
        // Used to read index definitions
        principalId: Function.outputs.systemAssignedMIPrincipalId
        roleDefinitionIdOrName: 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
        principalType: 'ServicePrincipal'
      }
      {
        // Reader role for the Admin Website resource
        // Used to read index definitions
        principalId: WebsiteName_admin.outputs.systemAssignedMIPrincipalId
        roleDefinitionIdOrName: 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
        principalType: 'ServicePrincipal'
      }
      {
        // Search Index Data Contributor for the Website resource
        principalId: Website.outputs.systemAssignedMIPrincipalId
        roleDefinitionIdOrName: '8ebe5a00-799e-43f5-93ac-243d3dce84a7'
        principalType: 'ServicePrincipal'
      }
      {
        // Search Index Data Contributor for the Function resource
        principalId: Function.outputs.systemAssignedMIPrincipalId
        roleDefinitionIdOrName: '8ebe5a00-799e-43f5-93ac-243d3dce84a7'
        principalType: 'ServicePrincipal'
      }
      {
        // Search Index Data Contributor for the Admin Website resource
        principalId: WebsiteName_admin.outputs.systemAssignedMIPrincipalId
        roleDefinitionIdOrName: '8ebe5a00-799e-43f5-93ac-243d3dce84a7'
        principalType: 'ServicePrincipal'
      }
    ] : null
  }
}

module rgRbacPrincipalId 'br/public:avm/res/resources/resource-group:0.2.2' = {
  name: '${uniqueString(deployment().name)}-rg'
  params: {
    name: resourceGroup
    location: Location
    roleAssignments: authType == 'rbac' && principalId != '' ? [
      {
        // Cognitive Services OpenAI Contributor role for the User
        principalId: principalId
        roleDefinitionIdOrName: 'a001fd3d-188f-4b5d-821b-7da978bf7442'
        principalType: 'User'
      }
      {
        // Search Service Contributor role for the Admin Website resource
        principalId: principalId
        roleDefinitionIdOrName: '7ca78c08-252a-4471-8644-bb5ff32d4ba0'
        principalType: 'User'
      }
      {
        // Storage Blob Data Reader role for the Admin Website resource
        principalId: principalId
        roleDefinitionIdOrName: '2a2b9908-6ea1-4ae2-8e65-a410df84e7d1'
        principalType: 'User'
      }
      {
        // Reader role for Admin Website resource
        // Used to read index definitions
        principalId: principalId
        roleDefinitionIdOrName: 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
        principalType: 'User'
      }
      {
        // Search Index Data Contributor for Admin Website resource
        principalId: principalId
        roleDefinitionIdOrName: '8ebe5a00-799e-43f5-93ac-243d3dce84a7'
        principalType: 'User'
      }
    ] : null
  }
}
