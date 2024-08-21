# Machine Learning Services Workspaces Connections `[Microsoft.MachineLearningServices/workspaces/connections]`

This module creates a connection in a Machine Learning Services workspace.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.MachineLearningServices/workspaces/connections` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.MachineLearningServices/2024-04-01/workspaces/connections) |

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

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
