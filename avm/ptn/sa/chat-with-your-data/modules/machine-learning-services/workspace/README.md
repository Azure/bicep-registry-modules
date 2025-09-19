# Machine Learning Services Workspaces `[Sa/ChatWithYourDataModulesMachineLearningServicesWorkspace]`

This module deploys a Machine Learning Services Workspace.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Authorization/locks` | 2020-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_locks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks)</li></ul> |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_diagnosticsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)</li></ul> |
| `Microsoft.MachineLearningServices/workspaces` | 2024-10-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.machinelearningservices_workspaces.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.MachineLearningServices/2024-10-01-preview/workspaces)</li></ul> |
| `Microsoft.MachineLearningServices/workspaces/connections` | 2024-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.machinelearningservices_workspaces_connections.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.MachineLearningServices/2024-10-01/workspaces/connections)</li></ul> |
| `Microsoft.Network/privateEndpoints` | 2023-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints)</li></ul> |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2023-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints_privatednszonegroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints/privateDnsZoneGroups)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the machine learning workspace. |
| [`sku`](#parameter-sku) | string | Specifies the SKU, also referred as 'edition' of the Azure Machine Learning workspace. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`associatedApplicationInsightsResourceId`](#parameter-associatedapplicationinsightsresourceid) | string | The resource ID of the associated Application Insights. Required if 'kind' is 'Default' or 'FeatureStore'. |
| [`associatedKeyVaultResourceId`](#parameter-associatedkeyvaultresourceid) | string | The resource ID of the associated Key Vault. Required if 'kind' is 'Default' or 'FeatureStore'. If not provided, the key vault will be managed by Microsoft. |
| [`associatedStorageAccountResourceId`](#parameter-associatedstorageaccountresourceid) | string | The resource ID of the associated Storage Account. Required if 'kind' is 'Default', 'FeatureStore' or 'Hub'. |
| [`hubResourceId`](#parameter-hubresourceid) | string | The resource ID of the hub to associate with the workspace. Required if 'kind' is set to 'Project'. |
| [`primaryUserAssignedIdentity`](#parameter-primaryuserassignedidentity) | string | The user assigned identity resource ID that represents the workspace identity. Required if 'userAssignedIdentities' is not empty and may not be used if 'systemAssignedIdentity' is enabled. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`associatedContainerRegistryResourceId`](#parameter-associatedcontainerregistryresourceid) | string | The resource ID of the associated Container Registry. |
| [`connections`](#parameter-connections) | array | Connections to create in the workspace. |
| [`customerManagedKey`](#parameter-customermanagedkey) | object | The customer managed key definition. |
| [`description`](#parameter-description) | string | The description of this workspace. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`discoveryUrl`](#parameter-discoveryurl) | string | URL for the discovery service to identify regional endpoints for machine learning experimentation services. |
| [`enableServiceSideCMKEncryption`](#parameter-enableservicesidecmkencryption) | bool | Enable service-side encryption. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`friendlyName`](#parameter-friendlyname) | string | The friendly name of the machine learning workspace. |
| [`hbiWorkspace`](#parameter-hbiworkspace) | bool | The flag to signal HBI data in the workspace and reduce diagnostic data collected by the service. |
| [`imageBuildCompute`](#parameter-imagebuildcompute) | string | The compute name for image build. |
| [`ipAllowlist`](#parameter-ipallowlist) | array | List of IPv4 addresse ranges that are allowed to access the workspace. |
| [`kind`](#parameter-kind) | string | The type of Azure Machine Learning workspace to create. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. At least one identity type is required. |
| [`privateEndpoints`](#parameter-privateendpoints) | array | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| [`provisionNetworkNow`](#parameter-provisionnetworknow) | bool | Trigger the provisioning of the managed virtual network when creating the workspace. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Whether or not public network access is allowed for this resource. For security reasons it should be disabled. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`serviceManagedResourcesSettings`](#parameter-servicemanagedresourcessettings) | object | The service managed resource settings. |
| [`sharedPrivateLinkResources`](#parameter-sharedprivatelinkresources) | array | The list of shared private link resources in this workspace. Note: This property is not idempotent. |
| [`systemDatastoresAuthMode`](#parameter-systemdatastoresauthmode) | string | The authentication mode used by the workspace when connecting to the default storage account. |
| [`tags`](#parameter-tags) | object | Resource tags. |

### Parameter: `name`

The name of the machine learning workspace.

- Required: Yes
- Type: string

### Parameter: `sku`

Specifies the SKU, also referred as 'edition' of the Azure Machine Learning workspace.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Basic'
    'Free'
    'Premium'
    'Standard'
  ]
  ```

### Parameter: `associatedApplicationInsightsResourceId`

The resource ID of the associated Application Insights. Required if 'kind' is 'Default' or 'FeatureStore'.

- Required: No
- Type: string

### Parameter: `associatedKeyVaultResourceId`

The resource ID of the associated Key Vault. Required if 'kind' is 'Default' or 'FeatureStore'. If not provided, the key vault will be managed by Microsoft.

- Required: No
- Type: string

### Parameter: `associatedStorageAccountResourceId`

The resource ID of the associated Storage Account. Required if 'kind' is 'Default', 'FeatureStore' or 'Hub'.

- Required: No
- Type: string

### Parameter: `hubResourceId`

The resource ID of the hub to associate with the workspace. Required if 'kind' is set to 'Project'.

- Required: No
- Type: string

### Parameter: `primaryUserAssignedIdentity`

The user assigned identity resource ID that represents the workspace identity. Required if 'userAssignedIdentities' is not empty and may not be used if 'systemAssignedIdentity' is enabled.

- Required: No
- Type: string

### Parameter: `associatedContainerRegistryResourceId`

The resource ID of the associated Container Registry.

- Required: No
- Type: string

### Parameter: `connections`

Connections to create in the workspace.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-connectionscategory) | string | Category of the connection. |
| [`connectionProperties`](#parameter-connectionsconnectionproperties) | secureObject | The properties of the connection, specific to the auth type. |
| [`name`](#parameter-connectionsname) | string | Name of the connection to create. |
| [`target`](#parameter-connectionstarget) | string | The target of the connection. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`expiryTime`](#parameter-connectionsexpirytime) | string | The expiry time of the connection. |
| [`isSharedToAll`](#parameter-connectionsissharedtoall) | bool | Indicates whether the connection is shared to all users in the workspace. |
| [`metadata`](#parameter-connectionsmetadata) | object | User metadata for the connection. |
| [`sharedUserList`](#parameter-connectionsshareduserlist) | array | The shared user list of the connection. |
| [`value`](#parameter-connectionsvalue) | string | Value details of the workspace connection. |

### Parameter: `connections.category`

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

### Parameter: `connections.connectionProperties`

The properties of the connection, specific to the auth type.

- Required: Yes
- Type: secureObject
- Discriminator: `authType`

<h4>The available variants are:</h4>

| Variant | Description |
| :-- | :-- |
| [`AAD`](#variant-connectionsconnectionpropertiesauthtype-aad) | The connection properties when the auth type is AAD. |
| [`AccessKey`](#variant-connectionsconnectionpropertiesauthtype-accesskey) | The connection properties when the auth type is AccessKey. |
| [`ApiKey`](#variant-connectionsconnectionpropertiesauthtype-apikey) | The connection properties when the auth type is ApiKey. |
| [`ManagedIdentity`](#variant-connectionsconnectionpropertiesauthtype-managedidentity) | The connection properties when the auth type is ManagedIdentity. |

### Variant: `connections.connectionProperties.authType-AAD`
The connection properties when the auth type is AAD.

To use this variant, set the property `authType` to `AAD`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authType`](#parameter-connectionsconnectionpropertiesauthtype-aadauthtype) | string | The authentication type of the connection target. |

### Parameter: `connections.connectionProperties.authType-AAD.authType`

The authentication type of the connection target.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AAD'
  ]
  ```

### Variant: `connections.connectionProperties.authType-AccessKey`
The connection properties when the auth type is AccessKey.

To use this variant, set the property `authType` to `AccessKey`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authType`](#parameter-connectionsconnectionpropertiesauthtype-accesskeyauthtype) | string | The authentication type of the connection target. |
| [`credentials`](#parameter-connectionsconnectionpropertiesauthtype-accesskeycredentials) | object | The credentials for the connection. |

### Parameter: `connections.connectionProperties.authType-AccessKey.authType`

The authentication type of the connection target.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AccessKey'
  ]
  ```

### Parameter: `connections.connectionProperties.authType-AccessKey.credentials`

The credentials for the connection.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`accessKeyId`](#parameter-connectionsconnectionpropertiesauthtype-accesskeycredentialsaccesskeyid) | string | The connection access key ID. |
| [`secretAccessKey`](#parameter-connectionsconnectionpropertiesauthtype-accesskeycredentialssecretaccesskey) | string | The connection secret access key. |

### Parameter: `connections.connectionProperties.authType-AccessKey.credentials.accessKeyId`

The connection access key ID.

- Required: Yes
- Type: string

### Parameter: `connections.connectionProperties.authType-AccessKey.credentials.secretAccessKey`

The connection secret access key.

- Required: Yes
- Type: string

### Variant: `connections.connectionProperties.authType-ApiKey`
The connection properties when the auth type is ApiKey.

To use this variant, set the property `authType` to `ApiKey`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authType`](#parameter-connectionsconnectionpropertiesauthtype-apikeyauthtype) | string | The authentication type of the connection target. |
| [`credentials`](#parameter-connectionsconnectionpropertiesauthtype-apikeycredentials) | object | The credentials for the connection. |

### Parameter: `connections.connectionProperties.authType-ApiKey.authType`

The authentication type of the connection target.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'ApiKey'
  ]
  ```

### Parameter: `connections.connectionProperties.authType-ApiKey.credentials`

The credentials for the connection.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`key`](#parameter-connectionsconnectionpropertiesauthtype-apikeycredentialskey) | string | The connection API key. |

### Parameter: `connections.connectionProperties.authType-ApiKey.credentials.key`

The connection API key.

- Required: Yes
- Type: string

### Variant: `connections.connectionProperties.authType-ManagedIdentity`
The connection properties when the auth type is ManagedIdentity.

To use this variant, set the property `authType` to `ManagedIdentity`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authType`](#parameter-connectionsconnectionpropertiesauthtype-managedidentityauthtype) | string | The authentication type of the connection target. |
| [`credentials`](#parameter-connectionsconnectionpropertiesauthtype-managedidentitycredentials) | object | The credentials for the connection. |

### Parameter: `connections.connectionProperties.authType-ManagedIdentity.authType`

The authentication type of the connection target.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'ManagedIdentity'
  ]
  ```

### Parameter: `connections.connectionProperties.authType-ManagedIdentity.credentials`

The credentials for the connection.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clientId`](#parameter-connectionsconnectionpropertiesauthtype-managedidentitycredentialsclientid) | string | The connection managed identity ID. |
| [`resourceId`](#parameter-connectionsconnectionpropertiesauthtype-managedidentitycredentialsresourceid) | string | The connection managed identity resource ID. |

### Parameter: `connections.connectionProperties.authType-ManagedIdentity.credentials.clientId`

The connection managed identity ID.

- Required: Yes
- Type: string

### Parameter: `connections.connectionProperties.authType-ManagedIdentity.credentials.resourceId`

The connection managed identity resource ID.

- Required: Yes
- Type: string

### Parameter: `connections.name`

Name of the connection to create.

- Required: Yes
- Type: string

### Parameter: `connections.target`

The target of the connection.

- Required: Yes
- Type: string

### Parameter: `connections.expiryTime`

The expiry time of the connection.

- Required: No
- Type: string

### Parameter: `connections.isSharedToAll`

Indicates whether the connection is shared to all users in the workspace.

- Required: No
- Type: bool

### Parameter: `connections.metadata`

User metadata for the connection.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`>Any_other_property<`](#parameter-connectionsmetadata>any_other_property<) | string | The metadata key-value pairs. |

### Parameter: `connections.metadata.>Any_other_property<`

The metadata key-value pairs.

- Required: Yes
- Type: string

### Parameter: `connections.sharedUserList`

The shared user list of the connection.

- Required: No
- Type: array

### Parameter: `connections.value`

Value details of the workspace connection.

- Required: No
- Type: string

### Parameter: `customerManagedKey`

The customer managed key definition.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyName`](#parameter-customermanagedkeykeyname) | string | The name of the customer managed key to use for encryption. |
| [`keyVaultResourceId`](#parameter-customermanagedkeykeyvaultresourceid) | string | The resource ID of a key vault to reference a customer managed key for encryption from. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyVersion`](#parameter-customermanagedkeykeyversion) | string | The version of the customer managed key to reference for encryption. If not provided, the deployment will use the latest version available at deployment time. |
| [`userAssignedIdentityResourceId`](#parameter-customermanagedkeyuserassignedidentityresourceid) | string | User assigned identity to use when fetching the customer managed key. Required if no system assigned identity is available for use. |

### Parameter: `customerManagedKey.keyName`

The name of the customer managed key to use for encryption.

- Required: Yes
- Type: string

### Parameter: `customerManagedKey.keyVaultResourceId`

The resource ID of a key vault to reference a customer managed key for encryption from.

- Required: Yes
- Type: string

### Parameter: `customerManagedKey.keyVersion`

The version of the customer managed key to reference for encryption. If not provided, the deployment will use the latest version available at deployment time.

- Required: No
- Type: string

### Parameter: `customerManagedKey.userAssignedIdentityResourceId`

User assigned identity to use when fetching the customer managed key. Required if no system assigned identity is available for use.

- Required: No
- Type: string

### Parameter: `description`

The description of this workspace.

- Required: No
- Type: string

### Parameter: `diagnosticSettings`

The diagnostic settings of the service.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-diagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-diagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-diagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-diagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-diagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-diagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-diagnosticsettingsname) | string | The name of the diagnostic setting. |
| [`storageAccountResourceId`](#parameter-diagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-diagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logAnalyticsDestinationType`

A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureDiagnostics'
    'Dedicated'
  ]
  ```

### Parameter: `diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-diagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-diagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-diagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-diagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-diagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `diagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `diagnosticSettings.name`

The name of the diagnostic setting.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `discoveryUrl`

URL for the discovery service to identify regional endpoints for machine learning experimentation services.

- Required: No
- Type: string

### Parameter: `enableServiceSideCMKEncryption`

Enable service-side encryption.

- Required: No
- Type: bool

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `friendlyName`

The friendly name of the machine learning workspace.

- Required: No
- Type: string

### Parameter: `hbiWorkspace`

The flag to signal HBI data in the workspace and reduce diagnostic data collected by the service.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `imageBuildCompute`

The compute name for image build.

- Required: No
- Type: string

### Parameter: `ipAllowlist`

List of IPv4 addresse ranges that are allowed to access the workspace.

- Required: No
- Type: array

### Parameter: `kind`

The type of Azure Machine Learning workspace to create.

- Required: No
- Type: string
- Default: `'Default'`
- Allowed:
  ```Bicep
  [
    'Default'
    'FeatureStore'
    'Hub'
    'Project'
  ]
  ```

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

The lock settings of the service.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-lockkind) | string | Specify the type of lock. |
| [`name`](#parameter-lockname) | string | Specify the name of lock. |
| [`notes`](#parameter-locknotes) | string | Specify the notes of the lock. |

### Parameter: `lock.kind`

Specify the type of lock.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'CanNotDelete'
    'None'
    'ReadOnly'
  ]
  ```

### Parameter: `lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `lock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `managedIdentities`

The managed identity definition for this resource. At least one identity type is required.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      systemAssigned: true
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`systemAssigned`](#parameter-managedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. |
| [`userAssignedResourceIds`](#parameter-managedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption. |

### Parameter: `managedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption.

- Required: No
- Type: array

### Parameter: `privateEndpoints`

Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`subnetResourceId`](#parameter-privateendpointssubnetresourceid) | string | Resource ID of the subnet where the endpoint needs to be created. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`applicationSecurityGroupResourceIds`](#parameter-privateendpointsapplicationsecuritygroupresourceids) | array | Application security groups in which the Private Endpoint IP configuration is included. |
| [`customDnsConfigs`](#parameter-privateendpointscustomdnsconfigs) | array | Custom DNS configurations. |
| [`customNetworkInterfaceName`](#parameter-privateendpointscustomnetworkinterfacename) | string | The custom name of the network interface attached to the Private Endpoint. |
| [`enableTelemetry`](#parameter-privateendpointsenabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`ipConfigurations`](#parameter-privateendpointsipconfigurations) | array | A list of IP configurations of the Private Endpoint. This will be used to map to the first-party Service endpoints. |
| [`isManualConnection`](#parameter-privateendpointsismanualconnection) | bool | If Manual Private Link Connection is required. |
| [`location`](#parameter-privateendpointslocation) | string | The location to deploy the Private Endpoint to. |
| [`lock`](#parameter-privateendpointslock) | object | Specify the type of lock. |
| [`manualConnectionRequestMessage`](#parameter-privateendpointsmanualconnectionrequestmessage) | string | A message passed to the owner of the remote resource with the manual connection request. |
| [`name`](#parameter-privateendpointsname) | string | The name of the Private Endpoint. |
| [`privateDnsZoneGroup`](#parameter-privateendpointsprivatednszonegroup) | object | The private DNS Zone Group to configure for the Private Endpoint. |
| [`privateLinkServiceConnectionName`](#parameter-privateendpointsprivatelinkserviceconnectionname) | string | The name of the private link connection to create. |
| [`resourceGroupResourceId`](#parameter-privateendpointsresourcegroupresourceid) | string | The resource ID of the Resource Group the Private Endpoint will be created in. If not specified, the Resource Group of the provided Virtual Network Subnet is used. |
| [`roleAssignments`](#parameter-privateendpointsroleassignments) | array | Array of role assignments to create. |
| [`service`](#parameter-privateendpointsservice) | string | The subresource to deploy the Private Endpoint for. For example "vault" for a Key Vault Private Endpoint. |
| [`tags`](#parameter-privateendpointstags) | object | Tags to be applied on all resources/Resource Groups in this deployment. |

### Parameter: `privateEndpoints.subnetResourceId`

Resource ID of the subnet where the endpoint needs to be created.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.applicationSecurityGroupResourceIds`

Application security groups in which the Private Endpoint IP configuration is included.

- Required: No
- Type: array

### Parameter: `privateEndpoints.customDnsConfigs`

Custom DNS configurations.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ipAddresses`](#parameter-privateendpointscustomdnsconfigsipaddresses) | array | A list of private IP addresses of the private endpoint. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`fqdn`](#parameter-privateendpointscustomdnsconfigsfqdn) | string | FQDN that resolves to private endpoint IP address. |

### Parameter: `privateEndpoints.customDnsConfigs.ipAddresses`

A list of private IP addresses of the private endpoint.

- Required: Yes
- Type: array

### Parameter: `privateEndpoints.customDnsConfigs.fqdn`

FQDN that resolves to private endpoint IP address.

- Required: No
- Type: string

### Parameter: `privateEndpoints.customNetworkInterfaceName`

The custom name of the network interface attached to the Private Endpoint.

- Required: No
- Type: string

### Parameter: `privateEndpoints.enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool

### Parameter: `privateEndpoints.ipConfigurations`

A list of IP configurations of the Private Endpoint. This will be used to map to the first-party Service endpoints.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-privateendpointsipconfigurationsname) | string | The name of the resource that is unique within a resource group. |
| [`properties`](#parameter-privateendpointsipconfigurationsproperties) | object | Properties of private endpoint IP configurations. |

### Parameter: `privateEndpoints.ipConfigurations.name`

The name of the resource that is unique within a resource group.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.ipConfigurations.properties`

Properties of private endpoint IP configurations.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`groupId`](#parameter-privateendpointsipconfigurationspropertiesgroupid) | string | The ID of a group obtained from the remote resource that this private endpoint should connect to. |
| [`memberName`](#parameter-privateendpointsipconfigurationspropertiesmembername) | string | The member name of a group obtained from the remote resource that this private endpoint should connect to. |
| [`privateIPAddress`](#parameter-privateendpointsipconfigurationspropertiesprivateipaddress) | string | A private IP address obtained from the private endpoint's subnet. |

### Parameter: `privateEndpoints.ipConfigurations.properties.groupId`

The ID of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.ipConfigurations.properties.memberName`

The member name of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.ipConfigurations.properties.privateIPAddress`

A private IP address obtained from the private endpoint's subnet.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.isManualConnection`

If Manual Private Link Connection is required.

- Required: No
- Type: bool

### Parameter: `privateEndpoints.location`

The location to deploy the Private Endpoint to.

- Required: No
- Type: string

### Parameter: `privateEndpoints.lock`

Specify the type of lock.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-privateendpointslockkind) | string | Specify the type of lock. |
| [`name`](#parameter-privateendpointslockname) | string | Specify the name of lock. |
| [`notes`](#parameter-privateendpointslocknotes) | string | Specify the notes of the lock. |

### Parameter: `privateEndpoints.lock.kind`

Specify the type of lock.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'CanNotDelete'
    'None'
    'ReadOnly'
  ]
  ```

### Parameter: `privateEndpoints.lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `privateEndpoints.lock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `privateEndpoints.manualConnectionRequestMessage`

A message passed to the owner of the remote resource with the manual connection request.

- Required: No
- Type: string

### Parameter: `privateEndpoints.name`

The name of the Private Endpoint.

- Required: No
- Type: string

### Parameter: `privateEndpoints.privateDnsZoneGroup`

The private DNS Zone Group to configure for the Private Endpoint.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateDnsZoneGroupConfigs`](#parameter-privateendpointsprivatednszonegroupprivatednszonegroupconfigs) | array | The private DNS Zone Groups to associate the Private Endpoint. A DNS Zone Group can support up to 5 DNS zones. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-privateendpointsprivatednszonegroupname) | string | The name of the Private DNS Zone Group. |

### Parameter: `privateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs`

The private DNS Zone Groups to associate the Private Endpoint. A DNS Zone Group can support up to 5 DNS zones.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateDnsZoneResourceId`](#parameter-privateendpointsprivatednszonegroupprivatednszonegroupconfigsprivatednszoneresourceid) | string | The resource id of the private DNS zone. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-privateendpointsprivatednszonegroupprivatednszonegroupconfigsname) | string | The name of the private DNS Zone Group config. |

### Parameter: `privateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs.privateDnsZoneResourceId`

The resource id of the private DNS zone.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs.name`

The name of the private DNS Zone Group config.

- Required: No
- Type: string

### Parameter: `privateEndpoints.privateDnsZoneGroup.name`

The name of the Private DNS Zone Group.

- Required: No
- Type: string

### Parameter: `privateEndpoints.privateLinkServiceConnectionName`

The name of the private link connection to create.

- Required: No
- Type: string

### Parameter: `privateEndpoints.resourceGroupResourceId`

The resource ID of the Resource Group the Private Endpoint will be created in. If not specified, the Resource Group of the provided Virtual Network Subnet is used.

- Required: No
- Type: string

### Parameter: `privateEndpoints.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'DNS Resolver Contributor'`
  - `'DNS Zone Contributor'`
  - `'Domain Services Contributor'`
  - `'Domain Services Reader'`
  - `'Network Contributor'`
  - `'Owner'`
  - `'Private DNS Zone Contributor'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-privateendpointsroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-privateendpointsroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-privateendpointsroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-privateendpointsroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-privateendpointsroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-privateendpointsroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-privateendpointsroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-privateendpointsroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `privateEndpoints.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `privateEndpoints.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `privateEndpoints.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `privateEndpoints.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `privateEndpoints.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `privateEndpoints.roleAssignments.principalType`

The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Device'
    'ForeignGroup'
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `privateEndpoints.service`

The subresource to deploy the Private Endpoint for. For example "vault" for a Key Vault Private Endpoint.

- Required: No
- Type: string

### Parameter: `privateEndpoints.tags`

Tags to be applied on all resources/Resource Groups in this deployment.

- Required: No
- Type: object

### Parameter: `provisionNetworkNow`

Trigger the provisioning of the managed virtual network when creating the workspace.

- Required: No
- Type: bool

### Parameter: `publicNetworkAccess`

Whether or not public network access is allowed for this resource. For security reasons it should be disabled.

- Required: No
- Type: string
- Default: `'Disabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'AzureML Compute Operator'`
  - `'AzureML Data Scientist'`
  - `'AzureML Metrics Writer (preview)'`
  - `'AzureML Registry User'`
  - `'Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-roleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-roleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-roleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `roleAssignments.principalType`

The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Device'
    'ForeignGroup'
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `serviceManagedResourcesSettings`

The service managed resource settings.

- Required: No
- Type: object

### Parameter: `sharedPrivateLinkResources`

The list of shared private link resources in this workspace. Note: This property is not idempotent.

- Required: No
- Type: array

### Parameter: `systemDatastoresAuthMode`

The authentication mode used by the workspace when connecting to the default storage account.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AccessKey'
    'Identity'
    'UserDelegationSAS'
  ]
  ```

### Parameter: `tags`

Resource tags.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the machine learning service. |
| `resourceGroupName` | string | The resource group the machine learning service was deployed into. |
| `resourceId` | string | The resource ID of the machine learning service. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/network/private-endpoint:0.10.1` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.6.0` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.6.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
