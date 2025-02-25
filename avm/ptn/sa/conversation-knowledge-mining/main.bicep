// // ========== main.bicep ========== //
targetScope = 'resourceGroup'

metadata name = 'Conversation Knowledge Mining Solution Accelerator'
metadata description = 'This module deploys the [Conversation Knowledge Mining Solution Accelerator](https://github.com/microsoft/Conversation-Knowledge-Mining-Solution-Accelerator).'

// ========== Parameters ========== //
// PARAMETERS: names
@description('Required. The prefix for all deployed components log analytics workspace.')
@maxLength(7)
param environmentName string

// PARAMETERS: locations
//NOTE: allow for individual locations for each resource
//NOTE: determine allowed locations for resources with limited region availability
@description('Optional. Location for the solution deployment. Defaulted to the location of the Resource Group.')
param solutionLocation string = resourceGroup().location
@description('Required. Location for the Content Understanding service deployment.')
@allowed(['West US', 'Sweden Central', 'Australia East'])
@metadata({
  azd: {
    type: 'location'
  }
})
param contentUnderstandingLocation string
@description('Optional. Secondary location for databases creation(example:eastus2).')
param secondaryLocation string = 'East US 2'
@description('Optional. The location for the web app. If empty, contentUnderstandingLocation will be used.')
param ckmWebAppServerFarmLocation string = ''

// PARAMETERS: Web app configuration
@description('Optional. The SKU for the web app. If empty, contentUnderstandingLocation will be used.')
param webApServerFarmSku string = 'P0v3'

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
var varAIFoundryDeploymentName = format(workloadNameFormat, 'aif')
var varAIFoundryApplicationInsightsName = format(workloadNameFormat, 'aifd-appi')
var varAIFoundryContainerRegistryName = replace(format(workloadNameFormat, 'aifd-creg'), '-', '') //NOTE: ACR name should not contain hyphens
var varAIFoundryAIServicesName = format(workloadNameFormat, 'aifd-aisv')
var varAIFoundryAIServicesContentUnderstandingName = format(workloadNameFormat, 'aifd-aisv-cu')
var varAIFoundryAIServicesContentUnderstandingLocation = contentUnderstandingLocation == ''
  ? solutionLocation
  : contentUnderstandingLocation
// var varAIFoundryAIServicesName_m = format(workloadNameFormat, 'aiam')
var varAIFoundrySearchServiceName = format(workloadNameFormat, 'aifd-srch')
var varAIFoundryStorageAccountName = replace(format(workloadNameFormat, 'aifd-strg'), '-', '') //NOTE: SA name should not contain hyphens
var varAIFoundryMachineLearningServicesAIHubName = format(workloadNameFormat, 'aifd-aihb')
var varAIFoundryMachineLearningServicesProjectName = format(workloadNameFormat, 'aifd-aipj')
var varAIFoundryMachineLearningServicesModelPHIServerlessName = format(workloadNameFormat, 'aifd-sphi')
var varStorageAccountName = replace(format(workloadNameFormat, 'strg'), '-', '') //NOTE: SA name should not contain hyphens
var varCosmosDBAccountName = format(workloadNameFormat, 'cmdb')
var varCosmosDBAccountLocation = secondaryLocation
var varSQLServerName = format(workloadNameFormat, 'sqls')
var varSQLServerLocation = secondaryLocation
var varChartsManagedEnviornmentName = format(workloadNameFormat, 'fchr-ftme')
var varChartsFunctionName = format(workloadNameFormat, 'fchr-azfct')
var varChartsStorageAccountName = replace(format(workloadNameFormat, 'fchr-strg'), '-', '')
var varRAGManagedEnviornmentName = format(workloadNameFormat, 'frag-ftme')
var varRAGFunctionName = format(workloadNameFormat, 'frag-azfct')
var varRAGStorageAccountName = replace(format(workloadNameFormat, 'frag-strg'), '-', '')
var varWebAppServerFarmLocation = ckmWebAppServerFarmLocation == '' ? solutionLocation : ckmWebAppServerFarmLocation
var varWebAppServerFarmName = format(workloadNameFormat, 'waoo-srvf')
var varWebAppName = format(workloadNameFormat, 'wapp-wapp')
var varCopyDataScriptName = format(workloadNameFormat, 'scrp-cpdt')
var varIndexDataScriptName = format(workloadNameFormat, 'scrp-idxd')

// VARIABLES: key vault secrets names
// Secret names can only contain alphanumeric characters and dashes.
// The value you provide may be copied globally for the purpose of running the service.
// The value provided should not include personally identifiable or sensitive information

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
var varCosmosDBSQLDatabaseName = 'db_conversation_history'
var varCosmosDBSQLDatabaseNameCollectionName = 'conversations'
var varCosmosDBSQLDatabaseContainers = [
  {
    name: varCosmosDBSQLDatabaseNameCollectionName
    id: varCosmosDBSQLDatabaseNameCollectionName //NOT: Might not be needed
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
    '46d3xbcp.ptn.sa-ckm.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, solutionLocation), 0, 4)}',
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

module avmManagedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.0' = {
  name: format(deploymentNameFormat, varManagedIdentityName)
  params: {
    name: varManagedIdentityName
    location: solutionLocation
    tags: tags
  }
}

resource existingManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = {
  name: varManagedIdentityName
  dependsOn: [
    avmManagedIdentity
  ]
}

// NOTE: This is a role assignment at RG level and requires Owner permissions at subscription level
// It is important to fine grain permissions

@description('This is the built-in owner role. See https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#owner')
resource resOwnerRoleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  scope: resourceGroup()
  name: '8e3af657-a8ff-443c-a75c-2fe8c4bcb635' //NOTE: Built-in role 'Owner'
}

// Assign Owner role to the managed identity in the resource group
resource resRoleAssignmentOwnerManagedIdResourceGroup 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, existingManagedIdentity.id, resOwnerRoleDefinition.id)
  scope: resourceGroup()
  properties: {
    principalId: avmManagedIdentity.outputs.principalId
    roleDefinitionId: resOwnerRoleDefinition.id
    principalType: 'ServicePrincipal'
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
    enableSoftDelete: true //NOTE: This must vary per environment
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
  }
}

// resource existing_ckm_key_vault 'Microsoft.KeyVault/vaults@2024-04-01-preview' existing = {
//   name: avmKeyVault.outputs.name
// }

//NOTE: Check if this is required

resource kvSecretTenantIdEntry 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  name: '${varKeyVaultName}/TENANT-ID'
  properties: {
    value: subscription().tenantId
  }
  dependsOn: [
    avmKeyVault
  ]
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
  name: format(deploymentNameFormat, varAIFoundryDeploymentName)
  params: {
    location: solutionLocation
    tags: tags
    managedIdentity_name: varManagedIdentityName
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
    machineLearningServicesWorkspaces_phiServerless_name: varAIFoundryMachineLearningServicesModelPHIServerlessName
    gptModelVersionPreview: varGPTModelVersionPreview
    deploymentVersion: armDeploymentSuffix
  }
  dependsOn: [
    avmManagedIdentity
    avmKeyVault
  ]
}

// ========== Storage Account ========== //

module avmStorageAccount 'br/public:avm/res/storage/storage-account:0.17.0' = {
  name: format(deploymentNameFormat, varStorageAccountName)
  params: {
    name: varStorageAccountName
    location: solutionLocation
    tags: tags
    skuName: 'Standard_LRS'
    kind: 'StorageV2'
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    enableHierarchicalNamespace: true //NOTE: Set to true
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    requireInfrastructureEncryption: true
    accessTier: 'Hot'
    blobServices: {
      name: 'default'
      cors: {
        corsRules: []
      }
      deleteRetentionPolicy: {
        enabled: false
        allowPermanentDelete: false
      }
      containers: [
        {
          name: 'data'
          properties: {
            defaultEncryptionScope: '$account-encryption-key'
            denyEncryptionScopeOverride: false
            publicAccess: 'None'
          }
        }
      ]
    }
    roleAssignments: [
      {
        principalId: avmManagedIdentity.outputs.principalId
        roleDefinitionIdOrName: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe' //NOTE: Built-in role 'Storage Blob Data Contributor'
      }
    ]
  }
}

resource existingStorageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' existing = {
  name: varStorageAccountName
  dependsOn: [
    avmStorageAccount
  ]
}

resource kvSecretADLSAccountName 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  name: '${varKeyVaultName}/ADLS-ACCOUNT-NAME'
  properties: {
    value: existingStorageAccount.name
  }
  dependsOn: [
    avmKeyVault
  ]
}

resource kvSecretADLSAccountContainer 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  name: '${varKeyVaultName}/ADLS-ACCOUNT-CONTAINER'
  properties: {
    value: 'data'
  }
  dependsOn: [
    avmKeyVault
  ]
}

resource kvSecretADLSAccountKey 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  name: '${varKeyVaultName}/ADLS-ACCOUNT-KEY'
  properties: {
    value: existingStorageAccount.listKeys().keys[0].value
  }
  dependsOn: [
    avmKeyVault
  ]
}

// ========== Cosmos Database ========== //

module avmCosmosDB 'br/public:avm/res/document-db/database-account:0.11.0' = {
  name: format(deploymentNameFormat, varCosmosDBAccountName)
  params: {
    name: varCosmosDBAccountName
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
        name: varCosmosDBSQLDatabaseName
        containers: [
          for container in varCosmosDBSQLDatabaseContainers: {
            name: container.name
            paths: [container.partitionKey]
          }
        ]
      }
    ]
  }
}

resource existingCosmosDB 'Microsoft.DocumentDB/databaseAccounts@2022-05-15' existing = {
  name: varCosmosDBAccountName
  dependsOn: [
    avmCosmosDB
  ]
}

resource kvSecretAzureCosmosDBAccount 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  name: '${varKeyVaultName}/AZURE-COSMOSDB-ACCOUNT'
  properties: {
    value: existingCosmosDB.name
  }
  dependsOn: [
    avmKeyVault
  ]
}

resource kvSecretAzureCosmosDBAccountKey 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  name: '${varKeyVaultName}/AZURE-COSMOSDB-ACCOUNT-KEY'
  properties: {
    value: existingCosmosDB.listKeys().primaryMasterKey
  }
  dependsOn: [
    avmKeyVault
  ]
}

resource kvSecretAzureCosmosDBDatabase 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  name: '${varKeyVaultName}/AZURE-COSMOSDB-DATABASE'
  properties: {
    value: varCosmosDBSQLDatabaseName
  }
  dependsOn: [
    avmKeyVault
  ]
}

resource kvSecretAzureCosmosDBConversationsContainer 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  name: '${varKeyVaultName}/AZURE-COSMOSDB-CONVERSATIONS-CONTAINER'
  properties: {
    value: varCosmosDBSQLDatabaseNameCollectionName
  }
  dependsOn: [
    avmKeyVault
  ]
}

resource kvSecretAzureCosmosDBEnableFeedback 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  name: '${varKeyVaultName}/AZURE-COSMOSDB-ENABLE-FEEDBACK'
  properties: {
    value: 'True'
  }
  dependsOn: [
    avmKeyVault
  ]
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

resource kvSecretSQLDServer 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  name: '${varKeyVaultName}/SQLDB-SERVER'
  properties: {
    value: avmSQLServer.outputs.fullyQualifiedDomainName //'${existingSQLServer.name}.database.windows.net' CHECK THIS
  }
  dependsOn: [
    avmKeyVault
  ]
}

resource kvSecretSQLDBDatabase 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  name: '${varKeyVaultName}/SQLDB-DATABASE'
  properties: {
    value: varSQLDatabaseName
  }
  dependsOn: [
    avmKeyVault
  ]
}

resource kvSecretSQLDBUsername 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  name: '${varKeyVaultName}/SQLDB-USERNAME'
  properties: {
    value: varSQLServerAdministratorLogin
  }
  dependsOn: [
    avmKeyVault
  ]
}

resource kvSecretSQLDBPassword 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  name: '${varKeyVaultName}/SQLDB-PASSWORD'
  properties: {
    value: varSQLServerAdministratorPassword
  }
  dependsOn: [
    avmKeyVault
  ]
}

//========== Deployment script to upload sample data ========== //

module avmDeploymentScritptCopyData 'br/public:avm/res/resources/deployment-script:0.5.1' = {
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
}

//========== Deployment script to process and index data ========== //

// NOT WORKING. Troubleshoot
//
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
}

//========== Azure function: Chart ========== //

module avmManagedEnvironmentCharts 'br/public:avm/res/app/managed-environment:0.9.0' = {
  name: format(deploymentNameFormat, varChartsManagedEnviornmentName)
  params: {
    name: varChartsManagedEnviornmentName
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

// NOTE: AVM module deployment is not working for this Azure Function configuration
// ERROR: VnetRouteAllEnabled cannot be configured for function app deployed on Azure Container Apps. Please try to configure from Azure Container Apps Environment resource

// module ckm_functions_chart_avm_web_sites 'br/public:avm/res/web/site:0.13.3' = {
//   name: format(deploymentNameFormat, varChartsFunctionName)
//   params: {
//     name: varChartsFunctionName
//     tags: tags
//     location: solutionLocation
//     kind: 'functionapp,linux,container,azurecontainerapps'
//     managedIdentities: {
//       systemAssigned: true
//     }
//     appSettingsKeyValuePairs: {
//       'AzureWebJobsStorage': 'DefaultEndpointsProtocol=https;AccountName=${varChartsStorageAccountName};EndpointSuffix=core.windows.net'
//       'SQLDB_DATABASE': varSQLDatabaseName
//       'SQLDB_PASSWORD': varSQLServerAdministratorPassword
//       'SQLDB_SERVER': varSQLServerName
//     }
//     siteConfig: {
//       linuxFxVersion: varChartsDockerImageName
//       functionAppScaleLimit: 10
//       minimumElasticInstanceCount: 0
//     }
//     managedEnvironmentId: avmManagedEnvironmentCharts.outputs.resourceId
//     serverFarmResourceId: avmManagedEnvironmentCharts.outputs.resourceId
//     // Missing configuration in AVM:
//     // workloadProfileName: 'Consumption'
//     // resourceConfig: {
//     //   cpu: 1
//     //   memory: '2Gi'
//     // }
//     storageAccountRequired: false
//     vnetRouteAllEnabled: false
//     resRoleAssignmentOwnerManagedIdResourceGroups: [
//       {
//         principalId: avmManagedIdentity.outputs.principalId
//         roleDefinitionIdOrName: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe' //NOTE: Built-in role 'Storage Blob Data Contributor'
//       }
//     ]
//   }
// }

resource resManagedIdentity 'Microsoft.Web/sites@2023-12-01' = {
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
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${varChartsStorageAccountName};EndpointSuffix=core.windows.net'
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
    managedEnvironmentId: avmManagedEnvironmentCharts.outputs.resourceId
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

module avmStorageAccountCharts 'br/public:avm/res/storage/storage-account:0.17.3' = {
  name: format(deploymentNameFormat, varChartsStorageAccountName)
  params: {
    name: varChartsStorageAccountName
    location: solutionLocation
    tags: tags
    skuName: 'Standard_LRS'
    kind: 'StorageV2'
    accessTier: 'Hot'
    roleAssignments: [
      {
        principalId: resManagedIdentity.identity.principalId
        roleDefinitionIdOrName: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe' //NOTE: Built-in role 'Storage Blob Data Contributor'
      }
    ]
  }
}

//========== Azure function: Rag ========== //

// NOTE: Can we share the same managed environment for both functions?
module avmManagedEnvironmentRAG 'br/public:avm/res/app/managed-environment:0.9.0' = {
  name: format(deploymentNameFormat, varRAGManagedEnviornmentName)
  params: {
    name: varRAGManagedEnviornmentName
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

resource existingAIFoundryAIServices 'Microsoft.CognitiveServices/accounts@2024-10-01' existing = {
  name: varAIFoundryAIServicesName
  dependsOn: [
    moduleAIFoundry
  ]
}

resource existingAIFoundrySearchServices 'Microsoft.Search/searchServices@2024-06-01-preview' existing = {
  name: varAIFoundrySearchServiceName
  dependsOn: [
    moduleAIFoundry
  ]
}

resource resFunctionRAG 'Microsoft.Web/sites@2023-12-01' = {
  name: varRAGFunctionName
  location: solutionLocation
  kind: 'functionapp,linux,container,azurecontainerapps'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${varRAGStorageAccountName};EndpointSuffix=core.windows.net'
        }
        {
          name: 'PYTHON_ENABLE_INIT_INDEXING'
          value: '1'
        }
        {
          name: 'PYTHON_ISOLATE_WORKER_DEPENDENCIES'
          value: '1'
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
          value: avmSQLServer.outputs.fullyQualifiedDomainName //'${varSQLServerName}.database.windows.net'
        }
        {
          name: 'SQLDB_USERNAME'
          value: varSQLServerAdministratorLogin
        }
        {
          name: 'AZURE_OPEN_AI_ENDPOINT'
          value: moduleAIFoundry.outputs.aiServices_endpoint
        }
        {
          name: 'AZURE_OPEN_AI_API_KEY'
          value: existingAIFoundryAIServices.listKeys().key1
        }
        {
          name: 'AZURE_AI_PROJECT_CONN_STRING'
          value: moduleAIFoundry.outputs.aiHub_project_connectionString
        }
        {
          name: 'OPENAI_API_VERSION'
          value: varGPTModelVersionPreview
        }
        {
          name: 'AZURE_OPEN_AI_DEPLOYMENT_MODEL'
          value: gptModelName
        }
        {
          name: 'AZURE_AI_SEARCH_ENDPOINT'
          value: moduleAIFoundry.outputs.aiSearch_connectionString
        }
        {
          name: 'AZURE_AI_SEARCH_API_KEY'
          value: existingAIFoundrySearchServices.listAdminKeys().primaryKey
        }
        {
          name: 'AZURE_AI_SEARCH_INDEX'
          value: 'call_transcripts_index'
        }
      ]
      linuxFxVersion: varRAGDockerImageName
      functionAppScaleLimit: 10
      minimumElasticInstanceCount: 0
      // use32BitWorkerProcess: false
      // ftpsState: 'FtpsOnly'
    }
    managedEnvironmentId: avmManagedEnvironmentRAG.outputs.resourceId
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

module avmStorageAccountRAG 'br/public:avm/res/storage/storage-account:0.17.3' = {
  name: format(deploymentNameFormat, varRAGStorageAccountName)
  params: {
    name: varRAGStorageAccountName
    location: solutionLocation
    tags: tags
    skuName: 'Standard_LRS'
    kind: 'StorageV2'
    accessTier: 'Hot'
    roleAssignments: [
      {
        principalId: resFunctionRAG.identity.principalId
        roleDefinitionIdOrName: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe' //NOTE: Built-in role 'Storage Blob Data Contributor'
      }
    ]
  }
}

resource resRoleDefinitionAIDeveloper 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: '64702f94-c441-49e6-a78b-ef80e0188fee' //NOTE: Built-in role 'AI Developer'
}

resource existingAIFoundryAIServicesProject 'Microsoft.MachineLearningServices/workspaces@2024-01-01-preview' existing = {
  name: varAIFoundryMachineLearningServicesProjectName
}

resource resRoleAssignmentAIDeveloperManagedIDAIWorkspaceProject 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resFunctionRAG.id, existingAIFoundryAIServicesProject.id, resRoleDefinitionAIDeveloper.id)
  scope: existingAIFoundryAIServicesProject
  properties: {
    roleDefinitionId: resRoleDefinitionAIDeveloper.id
    principalId: resFunctionRAG.identity.principalId
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

module avmWebsiteWebapp 'br/public:avm/res/web/site:0.13.3' = {
  name: format(deploymentNameFormat, varWebAppName)
  params: {
    name: varWebAppName
    tags: tags
    kind: 'app,linux,container'
    location: varWebAppServerFarmLocation
    serverFarmResourceId: avmServerFarmWebapp.outputs.resourceId
    appInsightResourceId: moduleAIFoundry.outputs.appInsights_resourceId
    managedIdentities: {
      systemAssigned: true
    }
    siteConfig: {
      linuxFxVersion: varWebAppImageName
    }
    appSettingsKeyValuePairs: {
      APPINSIGHTS_INSTRUMENTATIONKEY: moduleAIFoundry.outputs.appInsights_instrumentationKey
      AZURE_OPENAI_API_VERSION: varGPTModelVersionPreview
      AZURE_OPENAI_DEPLOYMENT_NAME: gptModelName
      AZURE_OPENAI_ENDPOINT: moduleAIFoundry.outputs.aiServices_endpoint
      AZURE_OPENAI_API_KEY: existingAIFoundryAIServices.listKeys().key1
      AZURE_OPENAI_RESOURCE: moduleAIFoundry.outputs.aiServices_name
      AZURE_OPENAI_PREVIEW_API_VERSION: varGPTModelVersionPreview
      USE_CHAT_HISTORY_ENABLED: 'True'
      USE_GRAPHRAG: 'False'
      CHART_DASHBOARD_URL: 'https://${resManagedIdentity.properties.defaultHostName}/api/${varChartsFunctionFunctionName}?data_type=charts'
      CHART_DASHBOARD_FILTERS_URL: 'https://${resManagedIdentity.properties.defaultHostName}/api/${varChartsFunctionFunctionName}?data_type=filters'
      GRAPHRAG_URL: 'TBD'
      RAG_URL: 'https://${resFunctionRAG.properties.defaultHostName}/api/${varRAGFunctionFunctionName}'
      REACT_APP_LAYOUT_CONFIG: varWebAppAppConfigReact
      AzureCosmosDB_ACCOUNT: avmCosmosDB.outputs.name
      //AzureCosmosDB_ACCOUNT_KEY: existingCosmosDB.listKeys().primaryMasterKey //AzureCosmosDB_ACCOUNT_KEY
      AzureCosmosDB_CONVERSATIONS_CONTAINER: varCosmosDBSQLDatabaseNameCollectionName
      AzureCosmosDB_DATABASE: varCosmosDBSQLDatabaseName
      AzureCosmosDB_ENABLE_FEEDBACK: 'True'
      SCM_DO_BUILD_DURING_DEPLOYMENT: 'true'
      UWSGI_PROCESSES: '2'
      UWSGI_THREADS: '2'
    }
  }
}

resource resContributorRoleDefinition 'Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions@2024-05-15' existing = {
  parent: existingCosmosDB
  name: '00000000-0000-0000-0000-000000000002'
}

resource resRoleAssignmentContributorWebappCosomosDB 'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments@2024-12-01-preview' = {
  parent: existingCosmosDB
  name: guid(resContributorRoleDefinition.id, existingCosmosDB.id)
  properties: {
    principalId: avmWebsiteWebapp.outputs.?systemAssignedMIPrincipalId
    roleDefinitionId: resContributorRoleDefinition.id
    scope: existingCosmosDB.id
  }
}

@description('The resource group the resources were deployed into.')
output resourceGroupName string = resourceGroup().name
