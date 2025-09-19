# Machine Learning Services Workspaces Connections `[Sa/ChatWithYourDataModulesMachineLearningServicesWorkspaceConnection]`

This module creates a connection in a Machine Learning Services workspace.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.MachineLearningServices/workspaces/connections` | 2024-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.machinelearningservices_workspaces_connections.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.MachineLearningServices/2024-10-01/workspaces/connections)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-category) | string | Category of the connection. |
| [`connectionProperties`](#parameter-connectionproperties) | secureObject | The properties of the connection, specific to the auth type. |
| [`machineLearningWorkspaceName`](#parameter-machinelearningworkspacename) | string | The name of the parent Machine Learning Workspace. Required if the template is used in a standalone deployment. |
| [`name`](#parameter-name) | string | Name of the connection to create. |
| [`target`](#parameter-target) | string | The target of the connection. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`expiryTime`](#parameter-expirytime) | string | The expiry time of the connection. |
| [`isSharedToAll`](#parameter-issharedtoall) | bool | Indicates whether the connection is shared to all users in the workspace. |
| [`metadata`](#parameter-metadata) | object | User metadata for the connection. |
| [`sharedUserList`](#parameter-shareduserlist) | array | The shared user list of the connection. |
| [`value`](#parameter-value) | string | Value details of the workspace connection. |

### Parameter: `category`

Category of the connection.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'ADLSGen2'
    'AIServices'
    'AmazonMws'
    'AmazonRdsForOracle'
    'AmazonRdsForSqlServer'
    'AmazonRedshift'
    'AmazonS3Compatible'
    'ApiKey'
    'AzureBlob'
    'AzureDatabricksDeltaLake'
    'AzureDataExplorer'
    'AzureMariaDb'
    'AzureMySqlDb'
    'AzureOneLake'
    'AzureOpenAI'
    'AzurePostgresDb'
    'AzureSqlDb'
    'AzureSqlMi'
    'AzureSynapseAnalytics'
    'AzureTableStorage'
    'BingLLMSearch'
    'Cassandra'
    'CognitiveSearch'
    'CognitiveService'
    'Concur'
    'ContainerRegistry'
    'CosmosDb'
    'CosmosDbMongoDbApi'
    'Couchbase'
    'CustomKeys'
    'Db2'
    'Drill'
    'Dynamics'
    'DynamicsAx'
    'DynamicsCrm'
    'Elasticsearch'
    'Eloqua'
    'FileServer'
    'FtpServer'
    'GenericContainerRegistry'
    'GenericHttp'
    'GenericRest'
    'Git'
    'GoogleAdWords'
    'GoogleBigQuery'
    'GoogleCloudStorage'
    'Greenplum'
    'Hbase'
    'Hdfs'
    'Hive'
    'Hubspot'
    'Impala'
    'Informix'
    'Jira'
    'Magento'
    'ManagedOnlineEndpoint'
    'MariaDb'
    'Marketo'
    'MicrosoftAccess'
    'MongoDbAtlas'
    'MongoDbV2'
    'MySql'
    'Netezza'
    'ODataRest'
    'Odbc'
    'Office365'
    'OpenAI'
    'Oracle'
    'OracleCloudStorage'
    'OracleServiceCloud'
    'PayPal'
    'Phoenix'
    'Pinecone'
    'PostgreSql'
    'Presto'
    'PythonFeed'
    'QuickBooks'
    'Redis'
    'Responsys'
    'S3'
    'Salesforce'
    'SalesforceMarketingCloud'
    'SalesforceServiceCloud'
    'SapBw'
    'SapCloudForCustomer'
    'SapEcc'
    'SapHana'
    'SapOpenHub'
    'SapTable'
    'Serp'
    'Serverless'
    'ServiceNow'
    'Sftp'
    'SharePointOnlineList'
    'Shopify'
    'Snowflake'
    'Spark'
    'SqlServer'
    'Square'
    'Sybase'
    'Teradata'
    'Vertica'
    'WebTable'
    'Xero'
    'Zoho'
  ]
  ```

### Parameter: `connectionProperties`

The properties of the connection, specific to the auth type.

- Required: Yes
- Type: secureObject
- Discriminator: `authType`

<h4>The available variants are:</h4>

| Variant | Description |
| :-- | :-- |
| [`AAD`](#variant-connectionpropertiesauthtype-aad) | The connection properties when the auth type is AAD. |
| [`AccessKey`](#variant-connectionpropertiesauthtype-accesskey) | The connection properties when the auth type is AccessKey. |
| [`ApiKey`](#variant-connectionpropertiesauthtype-apikey) | The connection properties when the auth type is ApiKey. |
| [`ManagedIdentity`](#variant-connectionpropertiesauthtype-managedidentity) | The connection properties when the auth type is ManagedIdentity. |

### Variant: `connectionProperties.authType-AAD`
The connection properties when the auth type is AAD.

To use this variant, set the property `authType` to `AAD`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authType`](#parameter-connectionpropertiesauthtype-aadauthtype) | string | The authentication type of the connection target. |

### Parameter: `connectionProperties.authType-AAD.authType`

The authentication type of the connection target.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AAD'
  ]
  ```

### Variant: `connectionProperties.authType-AccessKey`
The connection properties when the auth type is AccessKey.

To use this variant, set the property `authType` to `AccessKey`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authType`](#parameter-connectionpropertiesauthtype-accesskeyauthtype) | string | The authentication type of the connection target. |
| [`credentials`](#parameter-connectionpropertiesauthtype-accesskeycredentials) | object | The credentials for the connection. |

### Parameter: `connectionProperties.authType-AccessKey.authType`

The authentication type of the connection target.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AccessKey'
  ]
  ```

### Parameter: `connectionProperties.authType-AccessKey.credentials`

The credentials for the connection.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`accessKeyId`](#parameter-connectionpropertiesauthtype-accesskeycredentialsaccesskeyid) | string | The connection access key ID. |
| [`secretAccessKey`](#parameter-connectionpropertiesauthtype-accesskeycredentialssecretaccesskey) | string | The connection secret access key. |

### Parameter: `connectionProperties.authType-AccessKey.credentials.accessKeyId`

The connection access key ID.

- Required: Yes
- Type: string

### Parameter: `connectionProperties.authType-AccessKey.credentials.secretAccessKey`

The connection secret access key.

- Required: Yes
- Type: string

### Variant: `connectionProperties.authType-ApiKey`
The connection properties when the auth type is ApiKey.

To use this variant, set the property `authType` to `ApiKey`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authType`](#parameter-connectionpropertiesauthtype-apikeyauthtype) | string | The authentication type of the connection target. |
| [`credentials`](#parameter-connectionpropertiesauthtype-apikeycredentials) | object | The credentials for the connection. |

### Parameter: `connectionProperties.authType-ApiKey.authType`

The authentication type of the connection target.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'ApiKey'
  ]
  ```

### Parameter: `connectionProperties.authType-ApiKey.credentials`

The credentials for the connection.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`key`](#parameter-connectionpropertiesauthtype-apikeycredentialskey) | string | The connection API key. |

### Parameter: `connectionProperties.authType-ApiKey.credentials.key`

The connection API key.

- Required: Yes
- Type: string

### Variant: `connectionProperties.authType-ManagedIdentity`
The connection properties when the auth type is ManagedIdentity.

To use this variant, set the property `authType` to `ManagedIdentity`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authType`](#parameter-connectionpropertiesauthtype-managedidentityauthtype) | string | The authentication type of the connection target. |
| [`credentials`](#parameter-connectionpropertiesauthtype-managedidentitycredentials) | object | The credentials for the connection. |

### Parameter: `connectionProperties.authType-ManagedIdentity.authType`

The authentication type of the connection target.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'ManagedIdentity'
  ]
  ```

### Parameter: `connectionProperties.authType-ManagedIdentity.credentials`

The credentials for the connection.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clientId`](#parameter-connectionpropertiesauthtype-managedidentitycredentialsclientid) | string | The connection managed identity ID. |
| [`resourceId`](#parameter-connectionpropertiesauthtype-managedidentitycredentialsresourceid) | string | The connection managed identity resource ID. |

### Parameter: `connectionProperties.authType-ManagedIdentity.credentials.clientId`

The connection managed identity ID.

- Required: Yes
- Type: string

### Parameter: `connectionProperties.authType-ManagedIdentity.credentials.resourceId`

The connection managed identity resource ID.

- Required: Yes
- Type: string

### Parameter: `machineLearningWorkspaceName`

The name of the parent Machine Learning Workspace. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `name`

Name of the connection to create.

- Required: Yes
- Type: string

### Parameter: `target`

The target of the connection.

- Required: Yes
- Type: string

### Parameter: `expiryTime`

The expiry time of the connection.

- Required: No
- Type: string

### Parameter: `isSharedToAll`

Indicates whether the connection is shared to all users in the workspace.

- Required: No
- Type: bool

### Parameter: `metadata`

User metadata for the connection.

- Required: No
- Type: object
- Default: `{}`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`>Any_other_property<`](#parameter-metadata>any_other_property<) | string | The metadata key-value pairs. |

### Parameter: `metadata.>Any_other_property<`

The metadata key-value pairs.

- Required: Yes
- Type: string

### Parameter: `sharedUserList`

The shared user list of the connection.

- Required: No
- Type: array

### Parameter: `value`

Value details of the workspace connection.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the connection. |
| `resourceGroupName` | string | The name of the resource group the connection was created in. |
| `resourceId` | string | The resource ID of the connection. |
