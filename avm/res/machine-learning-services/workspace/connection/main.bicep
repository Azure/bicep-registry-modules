metadata name = 'Machine Learning Services Workspaces Connections'
metadata description = 'This module creates a connection in a Machine Learning Services workspace.'

// ================ //
// Parameters       //
// ================ //

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

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

@description('Optional. Use the workspace managed identity for the connection.')
param useWorkspaceManagedIdentity bool?

@description('Optional. Whether a private endpoint is required for the connection.')
@allowed([
  'Required'
  'NotRequired'
  'NotApplicable'
])
param peRequirement string?

@description('Required. The properties of the connection, specific to the auth type.')
param connectionProperties connectionPropertyType

// ============================= //
// Existing resources references //
// ============================= //

resource machineLearningWorkspace 'Microsoft.MachineLearningServices/workspaces@2026-09-01' existing = {
  name: machineLearningWorkspaceName
}

// ============== //
// Resources      //
// ============== //

var telemetryIdPrefix = loadJsonContent('metadata.json', 'telemetryIdPrefix')

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2026-06-01' = if (enableTelemetry) {
  name: '${telemetryIdPrefix}.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource connection 'Microsoft.MachineLearningServices/workspaces/connections@2026-09-01' = {
  name: name
  parent: machineLearningWorkspace
  properties: union(
    {
      category: category
      metadata: metadata
      target: target
      ...(expiryTime != null ? { expiryTime: expiryTime } : {})
      ...(isSharedToAll != null ? { isSharedToAll: isSharedToAll } : {})
      ...(sharedUserList != null ? { sharedUserList: sharedUserList } : {})
      ...(useWorkspaceManagedIdentity != null ? { useWorkspaceManagedIdentity: useWorkspaceManagedIdentity } : {})
      ...(peRequirement != null ? { peRequirement: peRequirement } : {})
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

@description('The tpe for the metadata.')
type metadataType = {
  @description('Required. The metadata key-value pairs.')
  *: string
}

@export()
@description('The type of the connection category.')
type categoryType =
  | 'ADLSGen2'
  | 'AIServices'
  | 'AmazonMws'
  | 'AmazonRdsForOracle'
  | 'AmazonRdsForSqlServer'
  | 'AmazonRedshift'
  | 'AmazonS3Compatible'
  | 'ApiManagement'
  | 'ApiKey'
  | 'AppConfig'
  | 'AppInsights'
  | 'AzureBlob'
  | 'AzureContainerAppEnvironment'
  | 'AzureDataExplorer'
  | 'AzureDatabricksDeltaLake'
  | 'AzureKeyVault'
  | 'AzureMariaDb'
  | 'AzureMySqlDb'
  | 'AzureOneLake'
  | 'AzureOpenAI'
  | 'AzurePostgresDb'
  | 'AzureSqlDb'
  | 'AzureSqlMi'
  | 'AzureStorageAccount'
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
  | 'Databricks'
  | 'Db2'
  | 'Drill'
  | 'Dynamics'
  | 'DynamicsAx'
  | 'DynamicsCrm'
  | 'Elasticsearch'
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
  | 'GroundingWithBingSearch'
  | 'GroundingWithCustomSearch'
  | 'Hbase'
  | 'Hdfs'
  | 'Hive'
  | 'Hubspot'
  | 'Impala'
  | 'Informix'
  | 'Jira'
  | 'Magento'
  | 'ManagedOnlineEndpoint'
  | 'MariaDb'
  | 'Marketo'
  | 'MicrosoftAccess'
  | 'MicrosoftFabric'
  | 'ModelGateway'
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
  | 'Pinecone'
  | 'PostgreSql'
  | 'PowerPlatformEnvironment'
  | 'Presto'
  | 'PythonFeed'
  | 'QuickBooks'
  | 'Redis'
  | 'RemoteA2A'
  | 'RemoteTool'
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
  | 'Sharepoint'
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

@description('The connection properties when the auth type is AAD.')
type aadAuthTypeWorkspaceConnectionPropertyType = {
  @description('Required. The authentication type of the connection target.')
  authType: 'AAD'
}

@description('The connection properties when the auth type is AccessKey.')
type accessKeyAuthTypeWorkspaceConnectionPropertyType = {
  @description('Required. The authentication type of the connection target.')
  authType: 'AccessKey'

  @description('Required. The credentials for the connection.')
  credentials: workspaceConnectionAccessKeyType
}

@description('The connection properties when the auth type is AccountKey.')
type accountKeyAuthTypeWorkspaceConnectionPropertyType = {
  @description('Required. The authentication type of the connection target.')
  authType: 'AccountKey'

  @description('Required. The credentials for the connection.')
  credentials: workspaceConnectionAccountKeyType
}

@description('The connection properties when the auth type is ApiKey.')
type apiKeyAuthWorkspaceConnectionPropertyType = {
  @description('Required. The authentication type of the connection target.')
  authType: 'ApiKey'

  @description('Required. The credentials for the connection.')
  credentials: workspaceConnectionApiKeyType
}

@description('The connection properties when the auth type are CustomKeys.')
type customKeysWorkspaceConnectionPropertyType = {
  @description('Required. The authentication type of the connection target.')
  authType: 'CustomKeys'

  @description('Required. The credentials for the connection.')
  credentials: customKeysType
}

@description('The connection properties when the auth type is ManagedIdentity.')
type managedIdentityAuthTypeWorkspaceConnectionPropertyType = {
  @description('Required. The authentication type of the connection target.')
  authType: 'ManagedIdentity'

  @description('Required. The credentials for the connection.')
  credentials: workspaceConnectionManagedIdentityType
}

@description('The connection properties when the auth type is None.')
type noneAuthTypeWorkspaceConnectionPropertyType = {
  @description('Required. The authentication type of the connection target.')
  authType: 'None'
}

@description('The connection properties when the auth type is OAuth2.')
type oauth2AuthTypeWorkspaceConnectionPropertyType = {
  @description('Required. The authentication type of the connection target.')
  authType: 'OAuth2'

  @description('Required. The credentials for the connection.')
  credentials: workspaceConnectionOAuth2Type
}

@description('The connection properties when the auth type is PAT.')
type patAuthTypeWorkspaceConnectionPropertyType = {
  @description('Required. The authentication type of the connection target.')
  authType: 'PAT'

  @description('Required. The credentials for the connection.')
  credentials: workspaceConnectionPersonalAccessTokenType
}

@description('The connection properties when the auth type is SAS.')
type sasAuthTypeWorkspaceConnectionPropertyType = {
  @description('Required. The authentication type of the connection target.')
  authType: 'SAS'

  @description('Required. The credentials for the connection.')
  credentials: workspaceConnectionSharedAccessSignatureType
}

@description('The connection properties when the auth type is ServicePrincipal.')
type servicePrincipalAuthTypeWorkspaceConnectionPropertyType = {
  @description('Required. The authentication type of the connection target.')
  authType: 'ServicePrincipal'

  @description('Required. The credentials for the connection.')
  credentials: workspaceConnectionServicePrincipalType
}

@description('The connection properties when the auth type is UsernamePassword.')
type usernamePasswordAuthTypeWorkspaceConnectionPropertyType = {
  @description('Required. The authentication type of the connection target.')
  authType: 'UsernamePassword'

  @description('Required. The credentials for the connection.')
  credentials: workspaceConnectionUsernamePasswordType
}

@description('The type fot the custom keys.')
type customKeysType = {
  @description('Required. The custom keys for the connection.')
  keys: {
    @description('Required. Key-value pairs for the custom keys.')
    *: string
  }
}

@description('The type for the workspace connection access key.')
type workspaceConnectionAccessKeyType = {
  @description('Required. The connection access key ID.')
  accessKeyId: string

  @description('Required. The connection secret access key.')
  secretAccessKey: string
}

@description('The type for the workspace connection account key.')
type workspaceConnectionAccountKeyType = {
  @description('Required. The connection key.')
  key: string
}

@description('The type for the workspace connection API key.')
type workspaceConnectionApiKeyType = {
  @description('Required. The connection API key.')
  key: string
}

@description('The type for the workspace connection managed identity.')
type workspaceConnectionManagedIdentityType = {
  @description('Required. The connection managed identity ID.')
  clientId: string

  @description('Required. The connection managed identity resource ID.')
  resourceId: string
}

type workspaceConnectionOAuth2Type = {
  @description('Conditional. The connection auth URL. Required if connection category is Concur.')
  authUrl: string?

  @minLength(36)
  @maxLength(36)
  @description('Required. The connection client ID in the format of UUID.')
  clientId: string

  @description('Required. The connection client secret.')
  clientSecret: string

  @description('Conditional. The connection developer token. Required if connection category is GoogleAdWords.')
  developerToken: string?

  @description('Conditional. The connection password. Required if connection category is Concur or ServiceNow where AccessToken grant type is \'Password\'.')
  password: string?

  @description('Conditional. The connection refresh token. Required if connection category is GoogleBigQuery, GoogleAdWords, Hubspot, QuickBooks, Square, Xero or Zoho.')
  refreshToken: string?

  @description('Conditional. The connection tenant ID. Required if connection category is QuickBooks or Xero.')
  tenantId: string?

  @description('Conditional. The connection username. Required if connection category is Concur or ServiceNow where AccessToken grant type is \'Password\'.')
  username: string?
}

@description('The type for the workspace connection personal access token.')
type workspaceConnectionPersonalAccessTokenType = {
  @description('Required. The connection personal access token.')
  pat: string
}

@description('The type for the workspace connection shared access signature.')
type workspaceConnectionSharedAccessSignatureType = {
  @description('Required. The connection SAS token.')
  sas: string
}

@description('The type for the workspace connection service principal.')
type workspaceConnectionServicePrincipalType = {
  @description('Required. The connection client ID.')
  clientId: string

  @description('Required. The connection client secret.')
  clientSecret: string

  @description('Required. The connection tenant ID.')
  tenantId: string
}

@description('The type for the workspace connection username and password.')
type workspaceConnectionUsernamePasswordType = {
  @description('Required. The connection password.')
  password: string

  @description('Conditional. The connection security token. Required if connection is like SalesForce for extra security in addition to \'UsernamePassword\'.')
  securityToken: string?

  @description('Required. The connection username.')
  username: string
}

@secure()
@export()
@description('The type of the connection properties.')
@discriminator('authType')
type connectionPropertyType =
  | aadAuthTypeWorkspaceConnectionPropertyType
  | accessKeyAuthTypeWorkspaceConnectionPropertyType
  | accountKeyAuthTypeWorkspaceConnectionPropertyType
  | apiKeyAuthWorkspaceConnectionPropertyType
  | customKeysWorkspaceConnectionPropertyType
  | managedIdentityAuthTypeWorkspaceConnectionPropertyType
  | noneAuthTypeWorkspaceConnectionPropertyType
  | oauth2AuthTypeWorkspaceConnectionPropertyType
  | patAuthTypeWorkspaceConnectionPropertyType
  | sasAuthTypeWorkspaceConnectionPropertyType
  | servicePrincipalAuthTypeWorkspaceConnectionPropertyType
  | usernamePasswordAuthTypeWorkspaceConnectionPropertyType
