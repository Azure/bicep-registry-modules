targetScope = 'resourceGroup'

// params
@description('''
  Definition of secrets to be auto-rotated. Includes name of the CosmosDB, name of the KeyVault, name of the Secret, name of the Resource Group etc.
  Example:
  [
    {
      type: 'cosmosdb', // mandatory, can be 'cosmosdb', 'redis'
      resourceName: 'cosmosdb-1',
      resourceRg: 'resource-group-1', // optional, default to parameter "resourceGroup().name"
      keyvaultRg: 'resource-group-1', // optional, default to parameter "resourceGroup().name"
      keyvaultName: 'keyvault-1',
      secretName: 'secret-1'
    }
  ]
  It's unlikely that for a single CosmosDB both primary and secondary keys are stored as keyvault secrets, normally one is used and later alternated to the other. Thus for now multiple keys are not supported.
  Note! Currently only support each CosmosDB having 1 secret.
  ''')
param secrets array

@description('Resource ID of the log analytic workspace to be used by the function app.')
param analyticWorkspaceId string

@description('Storage account name for the function app.')
param functionStorageAccountName string

@description('Resource group of the storage account, default to current resource group.')
param functionStorageAccountRg string = resourceGroup().name

@description('Location to be used. Default to resource group\'s location.')
param location string = resourceGroup().location

@description('Tags to be added to the resources created by this module.')
param tags object = {}

@description('The type of App Service hosting plan. Premium must be used to access key vaults behind firewall. Default is EP1.')
@allowed([ 'EP1', 'EP2', 'EP3', 'Y1' ])
param appServicePlanSku string = 'EP1'

@description('The name of the function app that you wish to create. Default is {resource group name}-rotation-fnapp.')
param functionAppName string = '${resourceGroup().name}-rotation-fnapp'

@description('True if vnet integration should be enabled. If set to false, the vnet related parameters will be ignored. Default to false.')
param isEnableVnet bool = false

@description('Name of the subnet to be assigned to function app. Leave empty if private network is not used.')
param functionAppSubnetId string = ''

@description('True if the file share needs to be created in the storage account, this file share will host the function app files. The function app name will be used as the file share name. Default to true. NOTE: This seems required if using deployment script to provision the contents of the function app, if the fileshare does not exist at the time of creation, the deployment will fail.')
param isCreateFileShare bool = true

@description('Name of the file share to be created, default to functionAppName.')
param fileShareName string = functionAppName

@description('True if this module should assigned the role defined by param \'storageRoleId\' to the function app identity. Supports user assigned identity only. Default is false.')
param isAssignStorageRole bool = false

@description('Id of role that should be assigned to the function identity for the storage account. Default to storage account contributor role ID.')
param storageRoleId string = resourceId('Microsoft.Authorization/roleDefinitions', '17d1049b-9a84-46fb-8f53-869881c3d3ab')

@description('True if the storage on which the function will be created is accessible only from private network(vnet). Default to false.')
param isStoragePrivate bool = false

@description('Function app identity type. Default is SystemAssigned, which means the identity created with the function app will be used.')
@allowed([ 'UserAssigned', 'SystemAssigned' ])
param functionAppIdentityType string = 'SystemAssigned'

@description('Name of the user assigned identity used to execute the deployment script for uploading function app source code. Must be provided if NOT using MSDeploy option. If user assigned identity is chosen for the function app, this will also be the identity used. Only effective when \'functionAppIdentityType\' is set to \'UserAssigned\'.')
param userAssignedIdentityName string = ''

@description('Resource group name of the user assigned identity, default to current resource group.')
param userAssignedIdentityRg string = resourceGroup().name

@description('Storage account name to be used by the deployment scripts. Deployment script by default create a temporary storage account during its execution but it is also possible to assign an existing storage instead.')
param deploymentScriptStorage string = ''

@description('Resource group of the deployment script storage, if `deploymentScriptStorage`, this param will be ignored. Default to current resource group.')
param deploymentScriptStorageRg string = resourceGroup().name

@description('True if the role with necessary permissions needed to execute the scripts for the function app is to be granted to the identity, either user assigned or system. Default to false.')
param isGrantExecutorRole bool = false

@description('Depends on the resource type, whether to assign necessary role so that the identity can perform certain operations. E.g. for CosmosDB, granting function app permission to regenerate access key. Sometimes the user assigned identity is already assigned the roles so no need to do it again. Note! This param will be discarded if system assigned identity is used.')
param isAssignResourceRole bool = true

@description('Event grid topic name, to which the keyvault near expiry event will be subscribed.')
param systemTopicName string = ''

@description('Resource group name of the event topic, default to current group. Will be ignored if system topic name is not provided.')
param systemTopicRg string = resourceGroup().name

// variables
var rotationFunctionNames = {
  cosmosdb: 'AKVCosmosDBRotation'
  redis: 'AKVRedisRotation'
}

var zipfile = loadFileAsBase64('./functionapp.zip')

var filename = 'functionapp.zip'

var suffix = uniqueString(functionAppName)

var websiteContirbutorRoleId = resourceId('Microsoft.Authorization/roleDefinitions', 'de139f84-1756-47ae-9be6-808fbbe84772')

var deployZipScript = loadTextContent('./scripts/deploye-zip.sh')

resource uai 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = if (userAssignedIdentityName != '') {
  name: userAssignedIdentityName
  scope: resourceGroup(userAssignedIdentityRg)
}

@description('Defines storageAccounts for Azure Function App.')
resource appStorageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' existing = {
  name: functionStorageAccountName
  scope: resourceGroup(functionStorageAccountRg)
}

resource scriptStorageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' existing = if (deploymentScriptStorage != '') {
  name: deploymentScriptStorage
  scope: resourceGroup(deploymentScriptStorageRg)
}

module fileShare './modules/create-fileshare.bicep' = if (isCreateFileShare) {
  name: 'create-fileshare-${suffix}'
  scope: resourceGroup(functionStorageAccountRg)
  params: {
    storageAccountName: functionStorageAccountName
    fileShareName: fileShareName
  }
}

@description('Grant the given role to identity for the storage account if needed.')
module grantStorageRole './modules/storage-role-assignment.bicep' = if (isAssignStorageRole && functionAppIdentityType == 'UserAssigned' && userAssignedIdentityName != '') {
  name: 'grant-storage-role-${suffix}'
  scope: resourceGroup(functionStorageAccountRg)
  params: {
    storageAccountName: functionStorageAccountName
    uaiPrincipalId: uai.properties.principalId
    storageRoleId: storageRoleId
  }
}

@description('Application service plan.')
resource serverfarms 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: functionAppName
  location: location
  tags: tags
  sku: {
    name: appServicePlanSku
  }
  properties: {
    perSiteScaling: false
    maximumElasticWorkerCount: 1
    targetWorkerCount: 0
    targetWorkerSizeId: 0
  }
}

@description('Insight for the function app.')
resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: 'ai-${functionAppName}'
  location: location
  tags: tags
  kind: 'azfunc'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: analyticWorkspaceId
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

@description('Create the key rotation function app.')
resource functions 'Microsoft.Web/sites@2022-03-01' = {
  name: functionAppName
  location: location
  tags: tags
  kind: 'functionapp'
  identity: {
    type: functionAppIdentityType
    userAssignedIdentities: (functionAppIdentityType == 'UserAssigned') ? {
      '${uai.id}': {}
    } : null
  }
  properties: {
    serverFarmId: serverfarms.id
    httpsOnly: true
    clientAffinityEnabled: true
  }

  resource networkConfig 'networkConfig@2022-09-01' = if (isEnableVnet) {
    name: 'virtualNetwork'
    properties: {
      subnetResourceId: functionAppSubnetId
    }
  }

  resource config 'config@2022-09-01' = {
    name: 'appsettings'
    properties: union({
        AzureWebJobsStorage: 'DefaultEndpointsProtocol=https;AccountName=${appStorageAccount.name};AccountKey=${appStorageAccount.listKeys().keys[0].value};'
        AzureWebJobsDashboard: 'DefaultEndpointsProtocol=https;AccountName=${appStorageAccount.name};AccountKey=${appStorageAccount.listKeys().keys[0].value};'
        WEBSITE_CONTENTSHARE: functionAppName
        WEBSITE_CONTENTAZUREFILECONNECTIONSTRING: 'DefaultEndpointsProtocol=https;AccountName=${appStorageAccount.name};AccountKey=${appStorageAccount.listKeys().keys[0].value};'
        FUNCTIONS_EXTENSION_VERSION: '~4'
        FUNCTIONS_WORKER_RUNTIME: 'powershell'
        APPINSIGHTS_INSTRUMENTATIONKEY: appInsights.properties.InstrumentationKey
        APPLICATIONINSIGHTS_CONNECTION_STRING: appInsights.properties.ConnectionString
      }, union(isStoragePrivate ? { WEBSITE_CONTENTOVERVNET: 1 } : {},
        functionAppIdentityType == 'SystemAssigned' ? {
          IS_USER_ASSIGNED_IDENTITY: 'false'
        } : {
          IS_USER_ASSIGNED_IDENTITY: 'true'
          USER_ASSIGNED_IDENTITY_CLIENT_ID: uai.properties.clientId
        }))
    dependsOn: isEnableVnet ? [ networkConfig ] : []
  }
}

@description('Assign executor role to identity')
module grantExecutorRole './modules/script-role-assignment.bicep' = if (isGrantExecutorRole) {
  name: 'grant-executor-role-${suffix}'
  params: {
    functionAppName: functions.name
    scriptExecutorRoleId: websiteContirbutorRoleId
    uaiPrincipalId: uai.properties.principalId
  }
}

@description('Deploy function app files.')
resource deployFunctionZip 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'upload-site-files-${suffix}'
  location: location
  dependsOn: isGrantExecutorRole ? [ functions, grantExecutorRole ] : [ functions ]
  kind: 'AzureCLI'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${uai.id}': {}
    }
  }
  properties: union({
      azCliVersion: '2.26.1'
      timeout: 'PT5M'
      retentionInterval: 'PT1H'
      scriptContent: deployZipScript
      environmentVariables: [
        {
          name: 'ZIP_FILE'
          value: zipfile
        }
        {
          name: 'FILE_NAME'
          value: filename
        }
        {
          name: 'RESOURCE_GROUP_NAME'
          value: resourceGroup().name
        }
        {
          name: 'FUNCTION_APP_NAME'
          value: functions.name
        }
      ]
    }, deploymentScriptStorage == '' ? {} : {
      storageAccountSettings: {
        storageAccountName: deploymentScriptStorage
        storageAccountKey: scriptStorageAccount.listKeys().keys[0].value
      }
    })
}

@description('Grant contributor role of the CosmosDB to the function app.')
module grantAccess './modules/role-assignment.bicep' = [for item in secrets: if (functionAppIdentityType == 'SystemAssigned' || functionAppIdentityType == 'UserAssigned' && isAssignResourceRole) {
  name: 'role-assignment-${item.resourceName}-${suffix}'
  scope: resourceGroup(contains(item, 'resourceRg') ? item.resourceRg : resourceGroup().name)
  params: {
    type: item.type
    resourceName: item.resourceName
    functionAppName: functionAppName
    functionAppPrincipalId: functionAppIdentityType == 'SystemAssigned' ? functions.identity.principalId : uai.properties.principalId
  }
  dependsOn: [ deployFunctionZip ]
}]

@description('Create access policy of the keyvault secrets for the function app')
module addAccessPolicy './modules/access-policy.bicep' = [for item in items(reduce(secrets, {}, (cur, next) => union(cur, { '${next.keyvaultName}': (contains(next, 'keyvaultRg') ? next.keyvaultRg : resourceGroup().name) }))): {
  name: 'ap-${uniqueString(item.key)}-${suffix}'
  scope: resourceGroup(item.value)
  params: {
    keyvaultName: item.key
    principalId: functionAppIdentityType == 'SystemAssigned' ? functions.identity.principalId : uai.properties.principalId
  }
  dependsOn: [ deployFunctionZip ]
}]

@batchSize(1)
@description('Create Keyvault event subscription and let the function app consume it.')
module eventSubscription './modules/event-subscription.bicep' = [for item in secrets: if (systemTopicName == '') {
  name: 'kv-event-sub-${uniqueString('${item.keyvaultName}${item.secretName}')}-${suffix}'
  scope: resourceGroup(contains(item, 'keyvaultRg') ? item.keyvaultRg : resourceGroup().name)
  params: {
    functionAppName: functionAppName
    functionAppRg: resourceGroup().name
    functionName: rotationFunctionNames[item.type]
    keyvaultName: item.keyvaultName
    secretName: item.secretName
  }
  dependsOn: [
    grantAccess
    addAccessPolicy
  ]
}]

@batchSize(1)
@description('Create event subscription to the system topic and let the function app consume it.')
module topicSubscription './modules/topic-subscription.bicep' = [for item in secrets: if (systemTopicName != '') {
  name: 'topic-sub-${uniqueString('${item.keyvaultName}${item.secretName}')}-${suffix}'
  scope: resourceGroup(systemTopicRg)
  params: {
    functionAppName: functionAppName
    functionAppRg: resourceGroup().name
    functionName: rotationFunctionNames[item.type]
    keyvaultName: item.keyvaultName
    secretName: item.secretName
    systemTopicName: systemTopicName
  }
  dependsOn: [ deployFunctionZip ]
}]

@description('ID of the function app created.')
output id string = functions.id

@description('Name of the function app created.')
output name string = functions.name

@description('ID of the App Insight created.')
output appInsightId string = appInsights.id

@description('Name of the App Insight created.')
output appInsightName string = appInsights.name

@description('ID of the server farm created.')
output serverFarmId string = serverfarms.id

@description('Name of the server farm created.')
output serverFarmName string = serverfarms.name
