// // ========== main.bicep ========== //
targetScope = 'resourceGroup'

metadata name = 'Conversation Knowledge Mining Solution Accelerator'
metadata description = '''This module deploys the [Conversation Knowledge Mining Solution Accelerator](https://github.com/microsoft/Conversation-Knowledge-Mining-Solution-Accelerator).

**Note:** This module is not intended for broad, generic use, as it was designed by the Commercial Solution Areas CTO team, as a Microsoft Solution Accelerator product. Feature requests and bug fix requests are welcome if they support the needs of this organization but may not be incorporated if they aim to make this module more generic than what it needs to be for its primary use case. This module will likely be updated to leverage AVM resource modules in the future.

This may result in breaking changes in upcoming versions when these features are implemented.
'''

// ========== Parameters ========== //
// PARAMETERS: names
@description('Required. The prefix for all deployed resources.')
@maxLength(12)
param environmentName string

// PARAMETERS: locations
//NOTE: allow for individual locations for each resource
@description('Required. Location for the Content Understanding service deployment.')
@allowed(['West US', 'Sweden Central', 'Australia East'])
@metadata({
  azd: {
    type: 'location'
  }
})
param contentUnderstandingLocation string
@description('Optional. Location for the solution deployment. Defaulted to the resource group location.')
param solutionLocation string = 'East US'
@description('Optional. Secondary location for databases creation.')
param secondaryLocation string = 'East US 2'
@description('Optional. The location for the web app. If empty, contentUnderstandingLocation will be used.')
param ckmWebAppServerFarmLocation string = ''

// PARAMETERS: Web app configuration
@description('Optional. The SKU for the web app. If empty, contentUnderstandingLocation will be used.')
param webApServerFarmSku string = 'B2'

// PARAMETERS: models configuration
@description('Optional. GPT model deployment type.')
@allowed([
  'Standard'
  'GlobalStandard'
])
param deploymentType string = 'GlobalStandard'
@description('Optional. Name of the GPT model to deploy.')
@allowed([
  'gpt-4o-mini'
  'gpt-4o'
  'gpt-4'
])
param gptModelName string = 'gpt-4o-mini'
@minValue(10)
@description('Optional. Capacity of the GPT deployment. You can increase this, but capacity is limited per model/region, so you will get errors if you go over. [Quotas link](https://learn.microsoft.com/en-us/azure/ai-services/openai/quotas-limits).')
// You can increase this, but capacity is limited per model/region, so you will get errors if you go over. // https://learn.microsoft.com/en-us/azure/ai-services/openai/quotas-limits
param gptDeploymentCapacity int = 100
@description('Optional. Name of the Text Embedding model to deploy.')
@allowed([
  'text-embedding-ada-002'
])
param embeddingModel string = 'text-embedding-ada-002'
@minValue(10)
@description('Optional. Capacity of the Embedding Model deployment.')
param embeddingDeploymentCapacity int = 80

// PARAMETERS: Docker image configuration
@description('Optional. Docker image version to use for all deployed containers (functions and web app).')
param imageTag string = 'latest'

@description('Optional. The version string to add to Resource Group deployments. Defaulted to current UTC time stamp, this default can lead to reach the RG deployment limit.')
param armDeploymentSuffix string = utcNow()

// PARAMETERS: Telemetry
@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

// ========== Variables ========== //
// VARIABLES: defaults
var workloadNameFormat = '${environmentName}-{0}' //${uniqueString(resourceGroup().id, environmentName)}
var tags = {
  app: environmentName
  location: solutionLocation
}
var deploymentNameFormat = 'deploy-{0}-${armDeploymentSuffix}'

// VARIABLES: calculated resource names and locations
// NOTE: Update location to allow individual locations for each resource
var varManagedIdentityName = format(workloadNameFormat, 'mgid')
var varKeyVaultName = format(workloadNameFormat, 'keyv') //NOTE: KV name max length is 24
var varLogAnalyticsWorkspaceName = format(workloadNameFormat, 'laws')
// var varAIFoundryDeploymentName = format(workloadNameFormat, 'aif')
var varAIFoundryApplicationInsightsName = format(workloadNameFormat, 'aifd-appi')
var varAIFoundryContainerRegistryName = replace(format(workloadNameFormat, 'aifd-creg'), '-', '') //NOTE: ACR name should not contain hyphens
var varAIFoundryAIServicesName = format(workloadNameFormat, 'aifd-aisr')
var varAIFoundryAIServicesContentUnderstandingName = format(workloadNameFormat, 'aifd-aisr-cu')
var varAIFoundryAIServicesContentUnderstandingLocation = contentUnderstandingLocation == ''
  ? solutionLocation
  : contentUnderstandingLocation
// var varAIFoundryAIServicesName_m = format(workloadNameFormat, 'aiam')
var varAIFoundrySearchServiceName = format(workloadNameFormat, 'aifd-srch')
var varAIFoundryStorageAccountName = replace(format(workloadNameFormat, 'aifd-strg'), '-', '') //NOTE: SA name should not contain hyphens
var varAIFoundryMachineLearningServicesAIHubName = format(workloadNameFormat, 'aifd-aihb')
var varAIFoundryMachineLearningServicesProjectName = format(workloadNameFormat, 'aifd-aipj')
// var varAIFoundryMachineLearningServicesModelPHIServerlessName = format(workloadNameFormat, 'aifd-sphi')
var varStorageAccountName = replace(format(workloadNameFormat, 'strg'), '-', '') //NOTE: SA name should not contain hyphens
var varCosmosDbAccountName = format(workloadNameFormat, 'cmdb')
var varCosmosDBAccountLocation = secondaryLocation
var varSQLServerName = format(workloadNameFormat, 'sqls')
var varSQLServerLocation = secondaryLocation
var varFunctionsManagedEnvironmentName = format(workloadNameFormat, 'ftme')
//var varChartsManagedEnviornmentName = format(workloadNameFormat, 'fchr-ftme')
var varChartsFunctionName = format(workloadNameFormat, 'fchr-azfct')
//var varChartsStorageAccountName = replace(format(workloadNameFormat, 'fchr-strg'), '-', '')
//var varRAGManagedEnviornmentName = format(workloadNameFormat, 'frag-ftme')
var varRAGFunctionName = format(workloadNameFormat, 'frag-azfct')
//var varRAGStorageAccountName = replace(format(workloadNameFormat, 'frag-strg'), '-', '')
//var varFunctionsStorageAccountName = replace(format(workloadNameFormat, 'func-strg'), '-', '')
var varWebAppServerFarmLocation = ckmWebAppServerFarmLocation == '' ? solutionLocation : ckmWebAppServerFarmLocation
var varWebAppServerFarmName = format(workloadNameFormat, 'waoo-srvf')
var varWebAppName = format(workloadNameFormat, 'wapp-wapp')
var varCopyDataScriptName = format(workloadNameFormat, 'scrp-cpdt')
var varIndexDataScriptName = format(workloadNameFormat, 'scrp-idxd')

// VARIABLES: key vault secrets names
var varKvSecretNameAdlsAccountKey = 'ADLS-ACCOUNT-KEY'
var varKvSecretNameAzureCosmosdbAccountKey = 'AZURE-COSMOSDB-ACCOUNT-KEY'
var varKvSecretNameAdlsAccountContainer = 'ADLS-ACCOUNT-CONTAINER'
var varKvSecretNameAdlsAccountName = 'ADLS-ACCOUNT-NAME'
var varKvSecretNameTenantId = 'TENANT-ID'
var varKvSecretNameAzureCosmosDbAccount = 'AZURE-COSMOSDB-ACCOUNT'
var varKvSecretNameAzureCosmosDbDatabase = 'AZURE-COSMOSDB-DATABASE'
var varKvSecretNameAzureCosmosDbConversationsContainer = 'AZURE-COSMOSDB-CONVERSATIONS-CONTAINER'
var varKvSecretNameAzureCosmosDbEnableFeedback = 'AZURE-COSMOSDB-ENABLE-FEEDBACK'
var varKvSecretNameSqlDbServer = 'SQLDB-SERVER'
var varKvSecretNameSqlDbDatabase = 'SQLDB-DATABASE'
var varKvSecretNameSqlDbUsername = 'SQLDB-USERNAME'
var varKvSecretNameSqlDbPassword = 'SQLDB-PASSWORD'

// VARIABLES: AI Model deployments
var varGPTModelVersion = '2024-07-18'
var varGPTModelVersionPreview = '2024-02-15-preview'
var varTextEmbeddingModelVersion = '2'

var varAIFoundryAIServicesModelDeployments = [
  {
    name: gptModelName
    model: {
      name: gptModelName
      format: 'OpenAI'
      version: varGPTModelVersion //NOTE: This attribute is mandatory for AVM, but optional for ARM. Request AVM to make it optional
    }
    sku: {
      name: deploymentType
      capacity: gptDeploymentCapacity
    }
    raiPolicyName: 'Microsoft.Default'
  }
  {
    name: embeddingModel
    model: {
      name: embeddingModel
      format: 'OpenAI'
      version: varTextEmbeddingModelVersion //NOTE: This attribute is mandatory for AVM, but optional for ARM. Request AVM to make it optional
    }
    sku: {
      name: 'Standard'
      capacity: embeddingDeploymentCapacity
    }
    raiPolicyName: 'Microsoft.Default'
  }
]

// VARIABLES: CosmosDB
var varCosmosDbSqlDbName = 'db_conversation_history'
var varCosmosDbSqlDbCollName = 'conversations'
var varCosdbSqlDbContainers = [
  {
    name: varCosmosDbSqlDbCollName
    id: varCosmosDbSqlDbCollName //NOT: Might not be needed
    partitionKey: '/userId'
  }
]

// VARIABLES: SQL Database
var varSQLDatabaseName = '${varSQLServerName }-sql-db'
var varSQLServerAdministratorLogin = 'sqladmin' //NOTE: credentials should not be hardcoded
var varSQLServerAdministratorPassword = 'TestPassword_1234' //NOTE: credentials should not be hardcoded

// VARIABLES: Deployment scripts
var varCKMGithubBaseUrl = 'https://raw.githubusercontent.com/microsoft/Conversation-Knowledge-Mining-Solution-Accelerator/main/'
var varStorageContainerName = 'data'

// VARIABLES: Function settings
var varChartsDockerImageName = 'DOCKER|kmcontainerreg.azurecr.io/km-charts-function:${imageTag}'
var varChartsFunctionFunctionName = 'get_metrics'
var varRAGDockerImageName = 'DOCKER|kmcontainerreg.azurecr.io/km-rag-function:${imageTag}'
var varRAGFunctionFunctionName = 'stream_openai_text'

// VARIABLES: Web App settings
var varWebAppImageName = 'DOCKER|kmcontainerreg.azurecr.io/km-app:${imageTag}'
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

// ========== Managed Identity ========== //

// resource avmManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-07-31-preview' = {
//   name: varManagedIdentityName
//   location: solutionLocation
//   tags: tags
// }

module avmManagedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.0' = {
  name: format(deploymentNameFormat, varManagedIdentityName)
  params: {
    name: varManagedIdentityName
    location: solutionLocation
    tags: tags
  }
}

// NOTE: This assignment should leverage AVM module [avm/res/resources/resource-group](https://azure.github.io/Azure-Verified-Modules/indexes/bicep/bicep-resource-modules/), but current target scope is resourceGroup
// TODO: Owner permissions to RG is a bad practice, fine grain permissions
module assignResourceGroupOwner 'modules/rbac-rg-owner.bicep' = {
  name: 'rbac-rg-owner'
  params: {
    managedIdentityResourceId: avmManagedIdentity.outputs.resourceId
    managedIdentityPrincipalId: avmManagedIdentity.outputs.principalId
  }
}

// ========== Key Vault ========== //
module avmKeyVault 'br/public:avm/res/key-vault/vault:0.11.2' = {
  name: format(deploymentNameFormat, varKeyVaultName)
  params: {
    name: varKeyVaultName
    tags: tags
    location: solutionLocation
    sku: 'standard'
    createMode: 'default'
    enableVaultForDeployment: true
    enableVaultForDiskEncryption: true
    enableVaultForTemplateDeployment: true
    enableSoftDelete: true //NOTE: This must become a parameter
    softDeleteRetentionInDays: 7
    enablePurgeProtection: false //NOTE: Set to true on original
    publicNetworkAccess: 'Enabled'
    enableRbacAuthorization: true
    accessPolicies: [
      //NOTE: This should be moved to RBAC
      {
        objectId: avmManagedIdentity.outputs.principalId
        permissions: {
          //NOTE: Fine grain permissions for Production environment
          keys: ['all']
          secrets: ['all']
          certificates: ['all']
          storage: ['all']
        }
      }
    ]
    roleAssignments: [
      {
        principalId: avmManagedIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: '00482a5a-887f-4fb3-b363-3b7fe8e74483' //NOTE: Built-in role 'Key Vault Administrator'
      }
    ]
    secrets: [
      { name: varKvSecretNameAdlsAccountContainer, value: 'data' }
      { name: varKvSecretNameAdlsAccountName, value: varStorageAccountName }
      { name: varKvSecretNameTenantId, value: subscription().tenantId }
      { name: varKvSecretNameAzureCosmosDbAccount, value: varCosmosDbAccountName }
      { name: varKvSecretNameAzureCosmosDbDatabase, value: varCosmosDbSqlDbName }
      { name: varKvSecretNameAzureCosmosDbConversationsContainer, value: varCosmosDbSqlDbCollName }
      { name: varKvSecretNameAzureCosmosDbEnableFeedback, value: 'True' }
      { name: varKvSecretNameSqlDbServer, value: '${varSQLServerName}${environment().suffixes.sqlServerHostname}' } //value: '${varSQLServerName}.database.windows.net'
      { name: varKvSecretNameSqlDbDatabase, value: varSQLDatabaseName }
      { name: varKvSecretNameSqlDbUsername, value: varSQLServerAdministratorLogin }
      { name: varKvSecretNameSqlDbPassword, value: varSQLServerAdministratorPassword }
    ]
  }
}

// ========== Log Analytics Workspace ========== //

// NOTE: Deploying this resource to use latest version of AVM Application Insights - Resource ID of the log analytics workspace which the
// data will be ingested to. This property is required to create an application with this API version.
// Applications from older versions will not have this property.
module avmLogAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.9.1' = {
  name: format(deploymentNameFormat, varLogAnalyticsWorkspaceName)
  params: {
    name: varLogAnalyticsWorkspaceName
    location: solutionLocation
    tags: tags
    skuName: 'PerGB2018'
    dataRetention: 30
  }
}

// ========== AI Foundry ========== //

module moduleAIFoundry './modules/ai-foundry.bicep' = {
  //name: format(deploymentNameFormat, varAIFoundryDeploymentName)
  name: 'module-ai-foundry'
  params: {
    location: solutionLocation
    tags: tags
    //managedIdentity_name: varManagedIdentityName
    keyVault_name: varKeyVaultName
    avm_operational_insights_workspace_resourceId: avmLogAnalyticsWorkspace.outputs.resourceId
    applicationInsights_name: varAIFoundryApplicationInsightsName
    containerRegistry_name: varAIFoundryContainerRegistryName
    aiServices_name: varAIFoundryAIServicesName
    //aiServices_m_name: varAIFoundryAIServicesName_m
    aiServices_cu_name: varAIFoundryAIServicesContentUnderstandingName
    aiServices_cu_location: varAIFoundryAIServicesContentUnderstandingLocation
    aiServices_deployments: varAIFoundryAIServicesModelDeployments
    searchService_name: varAIFoundrySearchServiceName
    storageAccount_name: varAIFoundryStorageAccountName
    machineLearningServicesWorkspaces_aihub_name: varAIFoundryMachineLearningServicesAIHubName
    machineLearningServicesWorkspaces_project_name: varAIFoundryMachineLearningServicesProjectName
    //    machineLearningServicesWorkspaces_phiServerless_name: varAIFoundryMachineLearningServicesModelPHIServerlessName
    gptModelVersionPreview: varGPTModelVersionPreview
    deploymentVersion: armDeploymentSuffix
    managedIdentityPrincipalId: avmManagedIdentity.outputs.principalId
  }
}

// ========== Storage Account ========== //

module avmStorageAccount 'br/public:avm/res/storage/storage-account:0.18.1' = {
  name: format(deploymentNameFormat, varStorageAccountName)
  params: {
    name: varStorageAccountName
    location: solutionLocation
    tags: tags
    skuName: 'Standard_LRS'
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
        principalId: resWebapp.identity.principalId
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

module avmCosmosDB 'br/public:avm/res/document-db/database-account:0.11.0' = {
  name: format(deploymentNameFormat, varCosmosDbAccountName)
  params: {
    name: varCosmosDbAccountName
    tags: tags
    location: varCosmosDBAccountLocation
    defaultConsistencyLevel: 'Session'
    locations: [
      {
        locationName: varCosmosDBAccountLocation
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
          for container in varCosdbSqlDbContainers: {
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

module avmSQLServer 'br/public:avm/res/sql/server:0.12.2' = {
  name: format(deploymentNameFormat, varSQLServerName)
  params: {
    name: varSQLServerName
    tags: tags
    location: varSQLServerLocation
    administratorLogin: varSQLServerAdministratorLogin
    administratorLoginPassword: varSQLServerAdministratorPassword
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
        name: varSQLDatabaseName
        sku: {
          name: 'GP_Gen5_2'
          tier: 'GeneralPurpose'
          family: 'Gen5'
          capacity: 2
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
  name: format(deploymentNameFormat, varCopyDataScriptName)
  params: {
    kind: 'AzureCLI'
    name: varCopyDataScriptName
    tags: tags
    location: solutionLocation
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

module avmDeploymentScritptIndexData 'br/public:avm/res/resources/deployment-script:0.5.1' = {
  name: format(deploymentNameFormat, varIndexDataScriptName)
  params: {
    kind: 'AzureCLI'
    name: varIndexDataScriptName
    tags: tags
    location: solutionLocation
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

module avmFunctionsManagedEnvironment 'br/public:avm/res/app/managed-environment:0.9.0' = {
  name: format(deploymentNameFormat, varFunctionsManagedEnvironmentName)
  params: {
    name: varFunctionsManagedEnvironmentName
    tags: tags
    location: solutionLocation
    zoneRedundant: false
    workloadProfiles: [
      {
        workloadProfileType: 'Consumption'
        name: 'Consumption'
      }
    ]
    peerTrafficEncryption: false
    logAnalyticsWorkspaceResourceId: avmLogAnalyticsWorkspace.outputs.resourceId
  }
}

resource resWebapp 'Microsoft.Web/sites@2023-12-01' = {
  name: varChartsFunctionName
  location: solutionLocation
  kind: 'functionapp,linux,container,azurecontainerapps'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage_accountname'
          value: moduleAIFoundry.outputs.storageAccount_name
        }
        {
          name: 'SQLDB_DATABASE'
          value: varSQLDatabaseName
        }
        {
          name: 'SQLDB_PASSWORD'
          value: varSQLServerAdministratorPassword
        }
        {
          name: 'SQLDB_SERVER'
          value: avmSQLServer.outputs.fullyQualifiedDomainName //'${varSQLServerName}.database.windows.net' CHECK THIS
        }
        {
          name: 'SQLDB_USERNAME'
          value: varSQLServerAdministratorLogin
        }
      ]
      linuxFxVersion: varChartsDockerImageName
      functionAppScaleLimit: 10
      minimumElasticInstanceCount: 0
      // use32BitWorkerProcess: false
      // ftpsState: 'FtpsOnly'
    }
    managedEnvironmentId: avmFunctionsManagedEnvironment.outputs.resourceId
    workloadProfileName: 'Consumption'
    // virtualNetworkSubnetId: null
    // clientAffinityEnabled: false
    resourceConfig: {
      cpu: 1
      memory: '2Gi'
    }
    storageAccountRequired: false
  }
}

// module avmStorageAccountCharts 'br/public:avm/res/storage/storage-account:0.17.3' = {
//   name: format(deploymentNameFormat, varChartsStorageAccountName)
//   params: {
//     name: varChartsStorageAccountName
//     location: solutionLocation
//     tags: tags
//     skuName: 'Standard_LRS'
//     kind: 'StorageV2'
//     accessTier: 'Hot'
//     roleAssignments: [
//       {
//         principalId: resWebapp.identity.principalId
//         roleDefinitionIdOrName: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe' //NOTE: Built-in role 'Storage Blob Data Contributor'
//       }
//     ]
//   }
// }

//========== Azure function: Rag ========== //

module moduleFunctionRAG 'modules/function-rag.bicep' = {
  name: 'module-function-rag'
  params: {
    ragFunctionName: varRAGFunctionName
    solutionLocation: solutionLocation
    tags: tags
    ragStorageAccountName: moduleAIFoundry.outputs.storageAccount_name
    aiFoundryAIHubProjectConnectionString: moduleAIFoundry.outputs.aiHub_project_connectionString
    AIFoundryAISearchServiceConnectionString: moduleAIFoundry.outputs.aiSearch_connectionString
    aiFoundryAIServicesName: moduleAIFoundry.outputs.aiServices_name
    aiFoundryOpenAIServicesEndpoint: moduleAIFoundry.outputs.aiServices_endpoint
    aiFoundrySearchServicesName: moduleAIFoundry.outputs.aiSearch_name
    functionsManagedEnvironmentResourceId: avmFunctionsManagedEnvironment.outputs.resourceId
    gptModelName: gptModelName
    gptModelVersionPreview: varGPTModelVersionPreview
    ragDockerImageName: varRAGDockerImageName
    sqlDatabaseName: varSQLDatabaseName
    sqlServerAdministratorLogin: varSQLServerAdministratorLogin
    sqlServerAdministratorPassword: varSQLServerAdministratorPassword
    sqlServerFullyQualifiedDomainName: avmSQLServer.outputs.fullyQualifiedDomainName
  }
}

// module avmStorageAccountFunctions 'br/public:avm/res/storage/storage-account:0.17.3' = {
//   name: format(deploymentNameFormat, varFunctionsStorageAccountName)
//   params: {
//     name: varFunctionsStorageAccountName
//     location: solutionLocation
//     tags: tags
//     skuName: 'Standard_LRS'
//     kind: 'StorageV2'
//     accessTier: 'Hot'
//     roleAssignments: [
//       // {
//       //   principalId: moduleFunctionRAG.outputs.principalId
//       //   roleDefinitionIdOrName: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe' //NOTE: Built-in role 'Storage Blob Data Contributor'
//       // }
//       {
//         principalId: resWebapp.identity.principalId
//         roleDefinitionIdOrName: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe' //NOTE: Built-in role 'Storage Blob Data Contributor'
//       }
//     ]
//   }
// }

// module avmStorageAccountRAG 'br/public:avm/res/storage/storage-account:0.17.3' = {
//   name: format(deploymentNameFormat, varRAGStorageAccountName)
//   params: {
//     name: varRAGStorageAccountName
//     location: solutionLocation
//     tags: tags
//     skuName: 'Standard_LRS'
//     kind: 'StorageV2'
//     accessTier: 'Hot'
//     roleAssignments: [
//       {
//         principalId: moduleFunctionRAG.outputs.principalId
//         roleDefinitionIdOrName: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe' //NOTE: Built-in role 'Storage Blob Data Contributor'
//       }
//     ]
//   }
// }

module rbacAiprojectAideveloper 'modules/rbac-aiproject-aideveloper.bicep' = {
  name: 'module-rbac-aiproject-aideveloper'
  params: {
    aiServicesProjectResourceName: moduleAIFoundry.outputs.aiHub_project_name
    identityPrincipalId: moduleFunctionRAG.outputs.principalId
    aiServicesProjectResourceId: moduleAIFoundry.outputs.aiHub_project_resourceId
    ragFunctionResourceId: moduleFunctionRAG.outputs.resourceId
  }
}

//========== CKM Webapp ========== //

module avmServerFarmWebapp 'br/public:avm/res/web/serverfarm:0.4.1' = {
  name: format(deploymentNameFormat, varWebAppServerFarmName)
  params: {
    name: varWebAppServerFarmName
    tags: tags
    location: varWebAppServerFarmLocation
    skuName: webApServerFarmSku
    reserved: true
    kind: 'linux'
  }
}

module moduleWebsiteWebapp 'modules/webapp.bicep' = {
  name: 'module-webapp'
  params: {
    deploymentName: format(deploymentNameFormat, varWebAppName)
    webAppName: varWebAppName
    location: solutionLocation
    tags: tags
    serverFarmResourceId: avmServerFarmWebapp.outputs.resourceId
    appInsightsResourceId: moduleAIFoundry.outputs.appInsights_resourceId
    aiFoundryAIServicesName: moduleAIFoundry.outputs.aiServices_name
    webAppImageName: varWebAppImageName
    appInsightsInstrumentationKey: moduleAIFoundry.outputs.appInsights_instrumentationKey
    aiServicesEndpoint: moduleAIFoundry.outputs.aiServices_endpoint
    gptModelName: gptModelName
    gptModelVersionPreview: varGPTModelVersionPreview
    aiServicesResourceName: moduleAIFoundry.outputs.aiServices_name
    managedIdentityDefaultHostName: resWebapp.properties.defaultHostName
    chartsFunctionFunctionName: varChartsFunctionFunctionName
    webAppAppConfigReact: varWebAppAppConfigReact
    cosmosDbSqlDbName: varCosmosDbSqlDbName
    cosmosDbSqlDbNameCollectionName: varCosmosDbSqlDbCollName
    ragFunctionDefaultHostName: moduleFunctionRAG.outputs.defaultHostName
    ragFunctionFunctionName: varRAGFunctionFunctionName
    avmCosmosDbResourceName: avmCosmosDB.outputs.name
  }
}

module rbac 'modules/rbac-cosmosdb-contributor.bicep' = {
  name: 'module-rbac-cosmosdb-contributor'
  params: {
    cosmosDBAccountName: avmCosmosDB.outputs.name
    principalId: moduleWebsiteWebapp.outputs.webAppSystemAssignedPrincipalId
  }
}

@description('The resource group the resources were deployed into.')
output resourceGroupName string = resourceGroup().name
