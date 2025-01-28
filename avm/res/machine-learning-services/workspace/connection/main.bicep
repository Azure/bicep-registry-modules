metadata name = 'Machine Learning Services Workspaces Connections'
metadata description = 'This module creates a connection in a Machine Learning Services workspace.'

// ================ //
// Parameters       //
// ================ //

@description('Required. Name of the connection to create.')
param name string

@description('Required. The name of the parent Machine Learning Workspace. Required if the template is used in a standalone deployment.')
param machineLearningWorkspaceName string

@description('Required. Category of the connection.')
param category categoryType

@description('Optional. The expiry time of the connection.')
param expiryTime string?

@description('Optional. Indicates whether the connection is shared to all users in the workspace.')
param isSharedToAll bool?

@description('Optional. User metadata for the connection.')
param metadata metadataType = {}

@description('Optional. The shared user list of the connection.')
param sharedUserList string[]?

@description('Required. The target of the connection.')
param target string

@description('Optional. Value details of the workspace connection.')
param value string?

@description('Required. The properties of the connection, specific to the auth type.')
param connectionProperties connectionPropertyType

// ============================= //
// Existing resources references //
// ============================= //

resource machineLearningWorkspace 'Microsoft.MachineLearningServices/workspaces@2022-10-01' existing = {
  name: machineLearningWorkspaceName
}

// ============== //
// Resources      //
// ============== //

resource connection 'Microsoft.MachineLearningServices/workspaces/connections@2024-04-01' = {
  name: name
  parent: machineLearningWorkspace
  properties: union(
    {
      category: category
      expiryTime: expiryTime
      isSharedToAll: isSharedToAll
      metadata: metadata
      sharedUserList: sharedUserList
      target: target
      value: value
    },
    connectionProperties
  )
}

// ============ //
// Outputs      //
// ============ //

@description('The resource ID of the connection.')
output resourceId string = connection.id

@description('The name of the connection.')
output name string = connection.name

@description('The name of the resource group the connection was created in.')
output resourceGroupName string = resourceGroup().name

// ================ //
// Definitions      //
// ================ //

type metadataType = {
  @description('Required. The metadata key-value pairs.')
  *: string
}

@export()
type categoryType =
  | 'ADLSGen2'
  | 'AIServices'
  | 'AmazonMws'
  | 'AmazonRdsForOracle'
  | 'AmazonRdsForSqlServer'
  | 'AmazonRedshift'
  | 'AmazonS3Compatible'
  | 'ApiKey'
  | 'AzureBlob'
  | 'AzureDataExplorer'
  | 'AzureDatabricksDeltaLake'
  | 'AzureMariaDb'
  | 'AzureMySqlDb'
  | 'AzureOneLake'
  | 'AzureOpenAI'
  | 'AzurePostgresDb'
  | 'AzureSqlDb'
  | 'AzureSqlMi'
  | 'AzureSynapseAnalytics'
  | 'AzureTableStorage'
  | 'BingLLMSearch'
  | 'Cassandra'
  | 'CognitiveSearch'
  | 'CognitiveService'
  | 'Concur'
  | 'ContainerRegistry'
  | 'CosmosDb'
  | 'CosmosDbMongoDbApi'
  | 'Couchbase'
  | 'CustomKeys'
  | 'Db2'
  | 'Drill'
  | 'Dynamics'
  | 'DynamicsAx'
  | 'DynamicsCrm'
  | 'Eloqua'
  | 'FileServer'
  | 'FtpServer'
  | 'GenericContainerRegistry'
  | 'GenericHttp'
  | 'GenericRest'
  | 'Git'
  | 'GoogleAdWords'
  | 'GoogleBigQuery'
  | 'GoogleCloudStorage'
  | 'Greenplum'
  | 'Hbase'
  | 'Hdfs'
  | 'Hive'
  | 'Hubspot'
  | 'Impala'
  | 'Informix'
  | 'Jira'
  | 'Magento'
  | 'MariaDb'
  | 'Marketo'
  | 'MicrosoftAccess'
  | 'MongoDbAtlas'
  | 'MongoDbV2'
  | 'MySql'
  | 'Netezza'
  | 'ODataRest'
  | 'Odbc'
  | 'Office365'
  | 'OpenAI'
  | 'Oracle'
  | 'OracleCloudStorage'
  | 'OracleServiceCloud'
  | 'PayPal'
  | 'Phoenix'
  | 'PostgreSql'
  | 'Presto'
  | 'PythonFeed'
  | 'QuickBooks'
  | 'Redis'
  | 'Responsys'
  | 'S3'
  | 'Salesforce'
  | 'SalesforceMarketingCloud'
  | 'SalesforceServiceCloud'
  | 'SapBw'
  | 'SapCloudForCustomer'
  | 'SapEcc'
  | 'SapHana'
  | 'SapOpenHub'
  | 'SapTable'
  | 'Serp'
  | 'Serverless'
  | 'ServiceNow'
  | 'Sftp'
  | 'SharePointOnlineList'
  | 'Shopify'
  | 'Snowflake'
  | 'Spark'
  | 'SqlServer'
  | 'Square'
  | 'Sybase'
  | 'Teradata'
  | 'Vertica'
  | 'WebTable'
  | 'Xero'
  | 'Zoho'

type aadAuthTypeWorkspaceConnectionPropertyType = {
  @description('Required. The authentication type of the connection target.')
  authType: 'AAD'
}

type accessKeyAuthTypeWorkspaceConnectionPropertyType = {
  @description('Required. The authentication type of the connection target.')
  authType: 'AccessKey'

  @description('Required. The credentials for the connection.')
  credentials: workspaceConnectionAccessKeyType
}

type accountKeyAuthTypeWorkspaceConnectionPropertyType = {
  @description('Required. The authentication type of the connection target.')
  authType: 'AccountKey'

  @description('Required. The credentials for the connection.')
  credentials: workspaceConnectionAccountKey
}

type apiKeyAuthWorkspaceConnectionPropertyType = {
  @description('Required. The authentication type of the connection target.')
  authType: 'ApiKey'

  @description('Required. The credentials for the connection.')
  credentials: workspaceConnectionApiKeyType
}

type customKeysWorkspaceConnectionPropertyType = {
  @description('Required. The authentication type of the connection target.')
  authType: 'CustomKeys'

  @description('Required. The credentials for the connection.')
  credentials: customKeysType
}

type managedIdentityAuthTypeWorkspaceConnectionPropertyType = {
  @description('Required. The authentication type of the connection target.')
  authType: 'ManagedIdentity'

  @description('Required. The credentials for the connection.')
  credentials: workspaceConnectionManagedIdentityType
}

type noneAuthTypeWorkspaceConnectionPropertyType = {
  @description('Required. The authentication type of the connection target.')
  authType: 'None'
}

type oauth2AuthTypeWorkspaceConnectionPropertyType = {
  @description('Required. The authentication type of the connection target.')
  authType: 'OAuth2'

  @description('Required. The credentials for the connection.')
  credentials: workspaceConnectionOAuth2Type
}

type patAuthTypeWorkspaceConnectionPropertyType = {
  @description('Required. The authentication type of the connection target.')
  authType: 'PAT'

  @description('Required. The credentials for the connection.')
  credentials: workspaceConnectionPersonalAccessTokenType
}

type sasAuthTypeWorkspaceConnectionPropertyType = {
  @description('Required. The authentication type of the connection target.')
  authType: 'SAS'

  @description('Required. The credentials for the connection.')
  credentials: workspaceConnectionSharedAccessSignatureType
}

type servicePrincipalAuthTypeWorkspaceConnectionPropertyType = {
  @description('Required. The authentication type of the connection target.')
  authType: 'ServicePrincipal'

  @description('Required. The credentials for the connection.')
  credentials: workspaceConnectionServicePrincipalType
}

type usernamePasswordAuthTypeWorkspaceConnectionPropertyType = {
  @description('Required. The authentication type of the connection target.')
  authType: 'UsernamePassword'

  @description('Required. The credentials for the connection.')
  credentials: workspaceConnectionUsernamePasswordType
}

type customKeysType = {
  @description('Required. The custom keys for the connection.')
  keys: {
    @description('Required. Key-value pairs for the custom keys.')
    *: string
  }
}

type workspaceConnectionAccessKeyType = {
  @description('Required. The connection access key ID.')
  accessKeyId: string

  @description('Required. The connection secret access key.')
  secretAccessKey: string
}

type workspaceConnectionAccountKey = {
  @description('Required. The connection key.')
  key: string
}

type workspaceConnectionApiKeyType = {
  @description('Required. The connection API key.')
  key: string
}

type workspaceConnectionManagedIdentityType = {
  @description('Required. The connection managed identity ID.')
  clientId: string

  @description('Required. The connection managed identity resource ID.')
  resourceId: string
}

type workspaceConnectionOAuth2Type = {
  @description('Conditional. The connection auth URL. Required by Concur connection category.')
  authUrl: string?

  @minLength(36)
  @maxLength(36)
  @description('Required. The connection client ID in the format of UUID.')
  clientId: string

  @description('Required. The connection client secret.')
  clientSecret: string

  @description('Conditional. The connection developer token. Required by GoogleAdWords connection category.')
  developerToken: string?

  @description('Conditional. The connection password. Required by Concur and ServiceNow connection categories where AccessToken grant type is \'Password\'.')
  password: string?

  @description('Conditional. The connection refresh token. Required by GoogleBigQuery, GoogleAdWords, Hubspot, QuickBooks, Square, Xero and Zoho connection categories.')
  refreshToken: string?

  @description('Required. The connection tenant ID. Required by QuickBooks and Xero connection categories.')
  tenantId: string?

  @description('Conditional. The connection username. Required by Concur and ServiceNow connection categories where AccessToken grant type is \'Password\'.')
  username: string?
}

type workspaceConnectionPersonalAccessTokenType = {
  @description('Required. The connection personal access token.')
  pat: string
}

type workspaceConnectionSharedAccessSignatureType = {
  @description('Required. The connection SAS token.')
  sas: string
}

type workspaceConnectionServicePrincipalType = {
  @description('Required. The connection client ID.')
  clientId: string

  @description('Required. The connection client secret.')
  clientSecret: string

  @description('Required. The connection tenant ID.')
  tenantId: string
}

type workspaceConnectionUsernamePasswordType = {
  @description('Required. The connection password.')
  password: string

  @description('Conditional. The connection security token. Required by connections like SalesForce for extra security in addition to \'UsernamePassword\'.')
  securityToken: string?

  @description('Required. The connection username.')
  username: string
}

@secure()
@export()
@discriminator('authType')
type connectionPropertyType =
  | aadAuthTypeWorkspaceConnectionPropertyType
  | accessKeyAuthTypeWorkspaceConnectionPropertyType
  | apiKeyAuthWorkspaceConnectionPropertyType
  | customKeysWorkspaceConnectionPropertyType
  | managedIdentityAuthTypeWorkspaceConnectionPropertyType
  | noneAuthTypeWorkspaceConnectionPropertyType
  | oauth2AuthTypeWorkspaceConnectionPropertyType
  | patAuthTypeWorkspaceConnectionPropertyType
  | sasAuthTypeWorkspaceConnectionPropertyType
  | servicePrincipalAuthTypeWorkspaceConnectionPropertyType
  | usernamePasswordAuthTypeWorkspaceConnectionPropertyType
