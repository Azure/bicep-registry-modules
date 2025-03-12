# Machine Learning Services Workspaces Connections `[Microsoft.MachineLearningServices/workspaces/connections]`

This module creates a connection in a Machine Learning Services workspace.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.MachineLearningServices/workspaces/connections` | [2024-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.MachineLearningServices/2024-10-01/workspaces/connections) |

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
- Type-deciding property: authType

<h4>The available variants are:</h4>

| Variant | Description |
| :-- | :-- |
| [`AAD`](#variant-connectionpropertiesauthtype-aad) |  |
| [`AccessKey`](#variant-connectionpropertiesauthtype-accesskey) |  |
| [`ApiKey`](#variant-connectionpropertiesauthtype-apikey) |  |
| [`CustomKeys`](#variant-connectionpropertiesauthtype-customkeys) |  |
| [`ManagedIdentity`](#variant-connectionpropertiesauthtype-managedidentity) |  |
| [`None`](#variant-connectionpropertiesauthtype-none) |  |
| [`OAuth2`](#variant-connectionpropertiesauthtype-oauth2) |  |
| [`PAT`](#variant-connectionpropertiesauthtype-pat) |  |
| [`SAS`](#variant-connectionpropertiesauthtype-sas) |  |
| [`ServicePrincipal`](#variant-connectionpropertiesauthtype-serviceprincipal) |  |
| [`UsernamePassword`](#variant-connectionpropertiesauthtype-usernamepassword) |  |

### Variant: `connectionProperties.authType-AAD`


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

### Variant: `connectionProperties.authType-CustomKeys`


To use this variant, set the property `authType` to `CustomKeys`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authType`](#parameter-connectionpropertiesauthtype-customkeysauthtype) | string | The authentication type of the connection target. |
| [`credentials`](#parameter-connectionpropertiesauthtype-customkeyscredentials) | object | The credentials for the connection. |

### Parameter: `connectionProperties.authType-CustomKeys.authType`

The authentication type of the connection target.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'CustomKeys'
  ]
  ```

### Parameter: `connectionProperties.authType-CustomKeys.credentials`

The credentials for the connection.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keys`](#parameter-connectionpropertiesauthtype-customkeyscredentialskeys) | object | The custom keys for the connection. |

### Parameter: `connectionProperties.authType-CustomKeys.credentials.keys`

The custom keys for the connection.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`>Any_other_property<`](#parameter-connectionpropertiesauthtype-customkeyscredentialskeys>any_other_property<) | string | Key-value pairs for the custom keys. |

### Parameter: `connectionProperties.authType-CustomKeys.credentials.keys.>Any_other_property<`

Key-value pairs for the custom keys.

- Required: Yes
- Type: string

### Variant: `connectionProperties.authType-ManagedIdentity`


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

### Variant: `connectionProperties.authType-None`


To use this variant, set the property `authType` to `None`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authType`](#parameter-connectionpropertiesauthtype-noneauthtype) | string | The authentication type of the connection target. |

### Parameter: `connectionProperties.authType-None.authType`

The authentication type of the connection target.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'None'
  ]
  ```

### Variant: `connectionProperties.authType-OAuth2`


To use this variant, set the property `authType` to `OAuth2`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authType`](#parameter-connectionpropertiesauthtype-oauth2authtype) | string | The authentication type of the connection target. |
| [`credentials`](#parameter-connectionpropertiesauthtype-oauth2credentials) | object | The credentials for the connection. |

### Parameter: `connectionProperties.authType-OAuth2.authType`

The authentication type of the connection target.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'OAuth2'
  ]
  ```

### Parameter: `connectionProperties.authType-OAuth2.credentials`

The credentials for the connection.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clientId`](#parameter-connectionpropertiesauthtype-oauth2credentialsclientid) | string | The connection client ID in the format of UUID. |
| [`clientSecret`](#parameter-connectionpropertiesauthtype-oauth2credentialsclientsecret) | string | The connection client secret. |
| [`tenantId`](#parameter-connectionpropertiesauthtype-oauth2credentialstenantid) | string | The connection tenant ID. Required by QuickBooks and Xero connection categories. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authUrl`](#parameter-connectionpropertiesauthtype-oauth2credentialsauthurl) | string | The connection auth URL. Required by Concur connection category. |
| [`developerToken`](#parameter-connectionpropertiesauthtype-oauth2credentialsdevelopertoken) | string | The connection developer token. Required by GoogleAdWords connection category. |
| [`password`](#parameter-connectionpropertiesauthtype-oauth2credentialspassword) | string | The connection password. Required by Concur and ServiceNow connection categories where AccessToken grant type is 'Password'. |
| [`refreshToken`](#parameter-connectionpropertiesauthtype-oauth2credentialsrefreshtoken) | string | The connection refresh token. Required by GoogleBigQuery, GoogleAdWords, Hubspot, QuickBooks, Square, Xero and Zoho connection categories. |
| [`username`](#parameter-connectionpropertiesauthtype-oauth2credentialsusername) | string | The connection username. Required by Concur and ServiceNow connection categories where AccessToken grant type is 'Password'. |

### Parameter: `connectionProperties.authType-OAuth2.credentials.clientId`

The connection client ID in the format of UUID.

- Required: Yes
- Type: string

### Parameter: `connectionProperties.authType-OAuth2.credentials.clientSecret`

The connection client secret.

- Required: Yes
- Type: string

### Parameter: `connectionProperties.authType-OAuth2.credentials.tenantId`

The connection tenant ID. Required by QuickBooks and Xero connection categories.

- Required: No
- Type: string

### Parameter: `connectionProperties.authType-OAuth2.credentials.authUrl`

The connection auth URL. Required by Concur connection category.

- Required: No
- Type: string

### Parameter: `connectionProperties.authType-OAuth2.credentials.developerToken`

The connection developer token. Required by GoogleAdWords connection category.

- Required: No
- Type: string

### Parameter: `connectionProperties.authType-OAuth2.credentials.password`

The connection password. Required by Concur and ServiceNow connection categories where AccessToken grant type is 'Password'.

- Required: No
- Type: string

### Parameter: `connectionProperties.authType-OAuth2.credentials.refreshToken`

The connection refresh token. Required by GoogleBigQuery, GoogleAdWords, Hubspot, QuickBooks, Square, Xero and Zoho connection categories.

- Required: No
- Type: string

### Parameter: `connectionProperties.authType-OAuth2.credentials.username`

The connection username. Required by Concur and ServiceNow connection categories where AccessToken grant type is 'Password'.

- Required: No
- Type: string

### Variant: `connectionProperties.authType-PAT`


To use this variant, set the property `authType` to `PAT`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authType`](#parameter-connectionpropertiesauthtype-patauthtype) | string | The authentication type of the connection target. |
| [`credentials`](#parameter-connectionpropertiesauthtype-patcredentials) | object | The credentials for the connection. |

### Parameter: `connectionProperties.authType-PAT.authType`

The authentication type of the connection target.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'PAT'
  ]
  ```

### Parameter: `connectionProperties.authType-PAT.credentials`

The credentials for the connection.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`pat`](#parameter-connectionpropertiesauthtype-patcredentialspat) | string | The connection personal access token. |

### Parameter: `connectionProperties.authType-PAT.credentials.pat`

The connection personal access token.

- Required: Yes
- Type: string

### Variant: `connectionProperties.authType-SAS`


To use this variant, set the property `authType` to `SAS`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authType`](#parameter-connectionpropertiesauthtype-sasauthtype) | string | The authentication type of the connection target. |
| [`credentials`](#parameter-connectionpropertiesauthtype-sascredentials) | object | The credentials for the connection. |

### Parameter: `connectionProperties.authType-SAS.authType`

The authentication type of the connection target.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'SAS'
  ]
  ```

### Parameter: `connectionProperties.authType-SAS.credentials`

The credentials for the connection.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`sas`](#parameter-connectionpropertiesauthtype-sascredentialssas) | string | The connection SAS token. |

### Parameter: `connectionProperties.authType-SAS.credentials.sas`

The connection SAS token.

- Required: Yes
- Type: string

### Variant: `connectionProperties.authType-ServicePrincipal`


To use this variant, set the property `authType` to `ServicePrincipal`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authType`](#parameter-connectionpropertiesauthtype-serviceprincipalauthtype) | string | The authentication type of the connection target. |
| [`credentials`](#parameter-connectionpropertiesauthtype-serviceprincipalcredentials) | object | The credentials for the connection. |

### Parameter: `connectionProperties.authType-ServicePrincipal.authType`

The authentication type of the connection target.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'ServicePrincipal'
  ]
  ```

### Parameter: `connectionProperties.authType-ServicePrincipal.credentials`

The credentials for the connection.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clientId`](#parameter-connectionpropertiesauthtype-serviceprincipalcredentialsclientid) | string | The connection client ID. |
| [`clientSecret`](#parameter-connectionpropertiesauthtype-serviceprincipalcredentialsclientsecret) | string | The connection client secret. |
| [`tenantId`](#parameter-connectionpropertiesauthtype-serviceprincipalcredentialstenantid) | string | The connection tenant ID. |

### Parameter: `connectionProperties.authType-ServicePrincipal.credentials.clientId`

The connection client ID.

- Required: Yes
- Type: string

### Parameter: `connectionProperties.authType-ServicePrincipal.credentials.clientSecret`

The connection client secret.

- Required: Yes
- Type: string

### Parameter: `connectionProperties.authType-ServicePrincipal.credentials.tenantId`

The connection tenant ID.

- Required: Yes
- Type: string

### Variant: `connectionProperties.authType-UsernamePassword`


To use this variant, set the property `authType` to `UsernamePassword`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authType`](#parameter-connectionpropertiesauthtype-usernamepasswordauthtype) | string | The authentication type of the connection target. |
| [`credentials`](#parameter-connectionpropertiesauthtype-usernamepasswordcredentials) | object | The credentials for the connection. |

### Parameter: `connectionProperties.authType-UsernamePassword.authType`

The authentication type of the connection target.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'UsernamePassword'
  ]
  ```

### Parameter: `connectionProperties.authType-UsernamePassword.credentials`

The credentials for the connection.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`password`](#parameter-connectionpropertiesauthtype-usernamepasswordcredentialspassword) | string | The connection password. |
| [`username`](#parameter-connectionpropertiesauthtype-usernamepasswordcredentialsusername) | string | The connection username. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`securityToken`](#parameter-connectionpropertiesauthtype-usernamepasswordcredentialssecuritytoken) | string | The connection security token. Required by connections like SalesForce for extra security in addition to 'UsernamePassword'. |

### Parameter: `connectionProperties.authType-UsernamePassword.credentials.password`

The connection password.

- Required: Yes
- Type: string

### Parameter: `connectionProperties.authType-UsernamePassword.credentials.username`

The connection username.

- Required: Yes
- Type: string

### Parameter: `connectionProperties.authType-UsernamePassword.credentials.securityToken`

The connection security token. Required by connections like SalesForce for extra security in addition to 'UsernamePassword'.

- Required: No
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
