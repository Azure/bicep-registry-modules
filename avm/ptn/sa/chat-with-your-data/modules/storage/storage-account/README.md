# Storage Accounts `[Sa/ChatWithYourDataSolutionAcceleratorModulesStorageStorageAccount]`

This module deploys a Storage Account.

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
| `Microsoft.Network/privateEndpoints` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/privateEndpoints)</li></ul> |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints_privatednszonegroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/privateEndpoints/privateDnsZoneGroups)</li></ul> |
| `Microsoft.Storage/storageAccounts` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts)</li></ul> |
| `Microsoft.Storage/storageAccounts/blobServices` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_blobservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/blobServices)</li></ul> |
| `Microsoft.Storage/storageAccounts/blobServices/containers` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_blobservices_containers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/blobServices/containers)</li></ul> |
| `Microsoft.Storage/storageAccounts/queueServices` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_queueservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/queueServices)</li></ul> |
| `Microsoft.Storage/storageAccounts/queueServices/queues` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_queueservices_queues.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/queueServices/queues)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Storage Account. Must be lower-case. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`accessTier`](#parameter-accesstier) | string | Required if the Storage Account kind is set to BlobStorage. The access tier is used for billing. The "Premium" access tier is the default value for premium block blobs storage account type and it cannot be changed for the premium block blobs storage account type. |
| [`enableHierarchicalNamespace`](#parameter-enablehierarchicalnamespace) | bool | If true, enables Hierarchical Namespace for the storage account. Required if enableSftp or enableNfsV3 is set to true. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowBlobPublicAccess`](#parameter-allowblobpublicaccess) | bool | Indicates whether public access is enabled for all blobs or containers in the storage account. For security reasons, it is recommended to set it to false. |
| [`allowCrossTenantReplication`](#parameter-allowcrosstenantreplication) | bool | Allow or disallow cross AAD tenant object replication. |
| [`allowedCopyScope`](#parameter-allowedcopyscope) | string | Restrict copy to and from Storage Accounts within an AAD tenant or with Private Links to the same VNet. |
| [`allowSharedKeyAccess`](#parameter-allowsharedkeyaccess) | bool | Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Azure AD). The default value is null, which is equivalent to true. |
| [`azureFilesIdentityBasedAuthentication`](#parameter-azurefilesidentitybasedauthentication) | object | Provides the identity based authentication settings for Azure Files. |
| [`blobServices`](#parameter-blobservices) | object | Blob service and containers to deploy. |
| [`customDomainName`](#parameter-customdomainname) | string | Sets the custom domain name assigned to the storage account. Name is the CNAME source. |
| [`customDomainUseSubDomainName`](#parameter-customdomainusesubdomainname) | bool | Indicates whether indirect CName validation is enabled. This should only be set on updates. |
| [`customerManagedKey`](#parameter-customermanagedkey) | object | The customer managed key definition. |
| [`defaultToOAuthAuthentication`](#parameter-defaulttooauthauthentication) | bool | A boolean flag which indicates whether the default authentication is OAuth or not. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`dnsEndpointType`](#parameter-dnsendpointtype) | string | Allows you to specify the type of endpoint. Set this to AzureDNSZone to create a large number of accounts in a single subscription, which creates accounts in an Azure DNS Zone and the endpoint URL will have an alphanumeric DNS Zone identifier. |
| [`enableNfsV3`](#parameter-enablenfsv3) | bool | If true, enables NFS 3.0 support for the storage account. Requires enableHierarchicalNamespace to be true. |
| [`enableSftp`](#parameter-enablesftp) | bool | If true, enables Secure File Transfer Protocol for the storage account. Requires enableHierarchicalNamespace to be true. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`isLocalUserEnabled`](#parameter-islocaluserenabled) | bool | Enables local users feature, if set to true. |
| [`keyType`](#parameter-keytype) | string | The keyType to use with Queue & Table services. |
| [`kind`](#parameter-kind) | string | Type of Storage Account to create. |
| [`largeFileSharesState`](#parameter-largefilesharesstate) | string | Allow large file shares if set to 'Enabled'. It cannot be disabled once it is enabled. Only supported on locally redundant and zone redundant file shares. It cannot be set on FileStorage storage accounts (storage accounts for premium file shares). |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`minimumTlsVersion`](#parameter-minimumtlsversion) | string | Set the minimum TLS version on request to storage. The TLS versions 1.0 and 1.1 are deprecated and not supported anymore. |
| [`networkAcls`](#parameter-networkacls) | object | Networks ACLs, this value contains IPs to whitelist and/or Subnet information. If in use, bypass needs to be supplied. For security reasons, it is recommended to set the DefaultAction Deny. |
| [`privateEndpoints`](#parameter-privateendpoints) | array | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and networkAcls are not set. |
| [`queueServices`](#parameter-queueservices) | object | Queue service and queues to create. |
| [`requireInfrastructureEncryption`](#parameter-requireinfrastructureencryption) | bool | A Boolean indicating whether or not the service applies a secondary layer of encryption with platform managed keys for data at rest. For security reasons, it is recommended to set it to true. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`sasExpirationAction`](#parameter-sasexpirationaction) | string | The SAS expiration action. Allowed values are Block and Log. |
| [`sasExpirationPeriod`](#parameter-sasexpirationperiod) | string | The SAS expiration period. DD.HH:MM:SS. |
| [`skuName`](#parameter-skuname) | string | Storage Account Sku Name - note: certain V2 SKUs require the use of: kind = FileStorage. |
| [`supportsHttpsTrafficOnly`](#parameter-supportshttpstrafficonly) | bool | Allows HTTPS traffic only to storage service if sets to true. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `name`

Name of the Storage Account. Must be lower-case.

- Required: Yes
- Type: string

### Parameter: `accessTier`

Required if the Storage Account kind is set to BlobStorage. The access tier is used for billing. The "Premium" access tier is the default value for premium block blobs storage account type and it cannot be changed for the premium block blobs storage account type.

- Required: No
- Type: string
- Default: `'Hot'`
- Allowed:
  ```Bicep
  [
    'Cold'
    'Cool'
    'Hot'
    'Premium'
  ]
  ```

### Parameter: `enableHierarchicalNamespace`

If true, enables Hierarchical Namespace for the storage account. Required if enableSftp or enableNfsV3 is set to true.

- Required: No
- Type: bool

### Parameter: `allowBlobPublicAccess`

Indicates whether public access is enabled for all blobs or containers in the storage account. For security reasons, it is recommended to set it to false.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `allowCrossTenantReplication`

Allow or disallow cross AAD tenant object replication.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `allowedCopyScope`

Restrict copy to and from Storage Accounts within an AAD tenant or with Private Links to the same VNet.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AAD'
    'PrivateLink'
  ]
  ```

### Parameter: `allowSharedKeyAccess`

Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Azure AD). The default value is null, which is equivalent to true.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `azureFilesIdentityBasedAuthentication`

Provides the identity based authentication settings for Azure Files.

- Required: No
- Type: object

### Parameter: `blobServices`

Blob service and containers to deploy.

- Required: No
- Type: object
- Default: `[if(not(equals(parameters('kind'), 'FileStorage')), createObject('containerDeleteRetentionPolicyEnabled', true(), 'containerDeleteRetentionPolicyDays', 7, 'deleteRetentionPolicyEnabled', true(), 'deleteRetentionPolicyDays', 6), createObject())]`

### Parameter: `customDomainName`

Sets the custom domain name assigned to the storage account. Name is the CNAME source.

- Required: No
- Type: string
- Default: `''`

### Parameter: `customDomainUseSubDomainName`

Indicates whether indirect CName validation is enabled. This should only be set on updates.

- Required: No
- Type: bool
- Default: `False`

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
| [`autoRotationEnabled`](#parameter-customermanagedkeyautorotationenabled) | bool | Enable or disable auto-rotating to the latest key version. Default is `true`. If set to `false`, the latest key version at the time of the deployment is used. |
| [`keyVersion`](#parameter-customermanagedkeykeyversion) | string | The version of the customer managed key to reference for encryption. If not provided, using version as per 'autoRotationEnabled' setting. |
| [`userAssignedIdentityResourceId`](#parameter-customermanagedkeyuserassignedidentityresourceid) | string | User assigned identity to use when fetching the customer managed key. Required if no system assigned identity is available for use. |

### Parameter: `customerManagedKey.keyName`

The name of the customer managed key to use for encryption.

- Required: Yes
- Type: string

### Parameter: `customerManagedKey.keyVaultResourceId`

The resource ID of a key vault to reference a customer managed key for encryption from.

- Required: Yes
- Type: string

### Parameter: `customerManagedKey.autoRotationEnabled`

Enable or disable auto-rotating to the latest key version. Default is `true`. If set to `false`, the latest key version at the time of the deployment is used.

- Required: No
- Type: bool

### Parameter: `customerManagedKey.keyVersion`

The version of the customer managed key to reference for encryption. If not provided, using version as per 'autoRotationEnabled' setting.

- Required: No
- Type: string

### Parameter: `customerManagedKey.userAssignedIdentityResourceId`

User assigned identity to use when fetching the customer managed key. Required if no system assigned identity is available for use.

- Required: No
- Type: string

### Parameter: `defaultToOAuthAuthentication`

A boolean flag which indicates whether the default authentication is OAuth or not.

- Required: No
- Type: bool
- Default: `False`

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
| [`marketplacePartnerResourceId`](#parameter-diagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-diagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-diagnosticsettingsname) | string | The name of diagnostic setting. |
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

The name of diagnostic setting.

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

### Parameter: `dnsEndpointType`

Allows you to specify the type of endpoint. Set this to AzureDNSZone to create a large number of accounts in a single subscription, which creates accounts in an Azure DNS Zone and the endpoint URL will have an alphanumeric DNS Zone identifier.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureDnsZone'
    'Standard'
  ]
  ```

### Parameter: `enableNfsV3`

If true, enables NFS 3.0 support for the storage account. Requires enableHierarchicalNamespace to be true.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableSftp`

If true, enables Secure File Transfer Protocol for the storage account. Requires enableHierarchicalNamespace to be true.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `isLocalUserEnabled`

Enables local users feature, if set to true.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `keyType`

The keyType to use with Queue & Table services.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Account'
    'Service'
  ]
  ```

### Parameter: `kind`

Type of Storage Account to create.

- Required: No
- Type: string
- Default: `'StorageV2'`
- Allowed:
  ```Bicep
  [
    'BlobStorage'
    'BlockBlobStorage'
    'FileStorage'
    'Storage'
    'StorageV2'
  ]
  ```

### Parameter: `largeFileSharesState`

Allow large file shares if set to 'Enabled'. It cannot be disabled once it is enabled. Only supported on locally redundant and zone redundant file shares. It cannot be set on FileStorage storage accounts (storage accounts for premium file shares).

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

The managed identity definition for this resource.

- Required: No
- Type: object

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

### Parameter: `minimumTlsVersion`

Set the minimum TLS version on request to storage. The TLS versions 1.0 and 1.1 are deprecated and not supported anymore.

- Required: No
- Type: string
- Default: `'TLS1_2'`
- Allowed:
  ```Bicep
  [
    'TLS1_2'
  ]
  ```

### Parameter: `networkAcls`

Networks ACLs, this value contains IPs to whitelist and/or Subnet information. If in use, bypass needs to be supplied. For security reasons, it is recommended to set the DefaultAction Deny.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`bypass`](#parameter-networkaclsbypass) | string | Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Possible values are any combination of Logging,Metrics,AzureServices (For example, "Logging, Metrics"), or None to bypass none of those traffics. |
| [`defaultAction`](#parameter-networkaclsdefaultaction) | string | Specifies the default action of allow or deny when no other rules match. |
| [`ipRules`](#parameter-networkaclsiprules) | array | Sets the IP ACL rules. |
| [`resourceAccessRules`](#parameter-networkaclsresourceaccessrules) | array | Sets the resource access rules. Array entries must consist of "tenantId" and "resourceId" fields only. |
| [`virtualNetworkRules`](#parameter-networkaclsvirtualnetworkrules) | array | Sets the virtual network rules. |

### Parameter: `networkAcls.bypass`

Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Possible values are any combination of Logging,Metrics,AzureServices (For example, "Logging, Metrics"), or None to bypass none of those traffics.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureServices'
    'AzureServices, Logging'
    'AzureServices, Logging, Metrics'
    'AzureServices, Metrics'
    'Logging'
    'Logging, Metrics'
    'Metrics'
    'None'
  ]
  ```

### Parameter: `networkAcls.defaultAction`

Specifies the default action of allow or deny when no other rules match.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Allow'
    'Deny'
  ]
  ```

### Parameter: `networkAcls.ipRules`

Sets the IP ACL rules.

- Required: No
- Type: array

### Parameter: `networkAcls.resourceAccessRules`

Sets the resource access rules. Array entries must consist of "tenantId" and "resourceId" fields only.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`resourceId`](#parameter-networkaclsresourceaccessrulesresourceid) | string | The resource ID of the target service. Can also contain a wildcard, if multiple services e.g. in a resource group should be included. |
| [`tenantId`](#parameter-networkaclsresourceaccessrulestenantid) | string | The ID of the tenant in which the resource resides in. |

### Parameter: `networkAcls.resourceAccessRules.resourceId`

The resource ID of the target service. Can also contain a wildcard, if multiple services e.g. in a resource group should be included.

- Required: Yes
- Type: string

### Parameter: `networkAcls.resourceAccessRules.tenantId`

The ID of the tenant in which the resource resides in.

- Required: Yes
- Type: string

### Parameter: `networkAcls.virtualNetworkRules`

Sets the virtual network rules.

- Required: No
- Type: array

### Parameter: `privateEndpoints`

Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`service`](#parameter-privateendpointsservice) | string | The subresource to deploy the private endpoint for. For example "blob", "table", "queue" or "file" for a Storage Account's Private Endpoints. |
| [`subnetResourceId`](#parameter-privateendpointssubnetresourceid) | string | Resource ID of the subnet where the endpoint needs to be created. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`applicationSecurityGroupResourceIds`](#parameter-privateendpointsapplicationsecuritygroupresourceids) | array | Application security groups in which the private endpoint IP configuration is included. |
| [`customDnsConfigs`](#parameter-privateendpointscustomdnsconfigs) | array | Custom DNS configurations. |
| [`customNetworkInterfaceName`](#parameter-privateendpointscustomnetworkinterfacename) | string | The custom name of the network interface attached to the private endpoint. |
| [`enableTelemetry`](#parameter-privateendpointsenabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`ipConfigurations`](#parameter-privateendpointsipconfigurations) | array | A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints. |
| [`isManualConnection`](#parameter-privateendpointsismanualconnection) | bool | If Manual Private Link Connection is required. |
| [`location`](#parameter-privateendpointslocation) | string | The location to deploy the private endpoint to. |
| [`lock`](#parameter-privateendpointslock) | object | Specify the type of lock. |
| [`manualConnectionRequestMessage`](#parameter-privateendpointsmanualconnectionrequestmessage) | string | A message passed to the owner of the remote resource with the manual connection request. |
| [`name`](#parameter-privateendpointsname) | string | The name of the private endpoint. |
| [`privateDnsZoneGroup`](#parameter-privateendpointsprivatednszonegroup) | object | The private DNS zone group to configure for the private endpoint. |
| [`privateLinkServiceConnectionName`](#parameter-privateendpointsprivatelinkserviceconnectionname) | string | The name of the private link connection to create. |
| [`resourceGroupResourceId`](#parameter-privateendpointsresourcegroupresourceid) | string | The resource ID of the Resource Group the Private Endpoint will be created in. If not specified, the Resource Group of the provided Virtual Network Subnet is used. |
| [`roleAssignments`](#parameter-privateendpointsroleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-privateendpointstags) | object | Tags to be applied on all resources/resource groups in this deployment. |

### Parameter: `privateEndpoints.service`

The subresource to deploy the private endpoint for. For example "blob", "table", "queue" or "file" for a Storage Account's Private Endpoints.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.subnetResourceId`

Resource ID of the subnet where the endpoint needs to be created.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.applicationSecurityGroupResourceIds`

Application security groups in which the private endpoint IP configuration is included.

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

The custom name of the network interface attached to the private endpoint.

- Required: No
- Type: string

### Parameter: `privateEndpoints.enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool

### Parameter: `privateEndpoints.ipConfigurations`

A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints.

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

The location to deploy the private endpoint to.

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

The name of the private endpoint.

- Required: No
- Type: string

### Parameter: `privateEndpoints.privateDnsZoneGroup`

The private DNS zone group to configure for the private endpoint.

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

### Parameter: `privateEndpoints.tags`

Tags to be applied on all resources/resource groups in this deployment.

- Required: No
- Type: object

### Parameter: `publicNetworkAccess`

Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and networkAcls are not set.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `queueServices`

Queue service and queues to create.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `requireInfrastructureEncryption`

A Boolean indicating whether or not the service applies a secondary layer of encryption with platform managed keys for data at rest. For security reasons, it is recommended to set it to true.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Reader and Data Access'`
  - `'Role Based Access Control Administrator'`
  - `'Storage Account Backup Contributor'`
  - `'Storage Account Contributor'`
  - `'Storage Account Key Operator Service Role'`
  - `'Storage Blob Data Contributor'`
  - `'Storage Blob Data Owner'`
  - `'Storage Blob Data Reader'`
  - `'Storage Blob Delegator'`
  - `'Storage File Data Privileged Contributor'`
  - `'Storage File Data Privileged Reader'`
  - `'Storage File Data SMB Share Contributor'`
  - `'Storage File Data SMB Share Elevated Contributor'`
  - `'Storage File Data SMB Share Reader'`
  - `'Storage Queue Data Contributor'`
  - `'Storage Queue Data Message Processor'`
  - `'Storage Queue Data Message Sender'`
  - `'Storage Queue Data Reader'`
  - `'Storage Table Data Contributor'`
  - `'Storage Table Data Reader'`
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

### Parameter: `sasExpirationAction`

The SAS expiration action. Allowed values are Block and Log.

- Required: No
- Type: string
- Default: `'Log'`
- Allowed:
  ```Bicep
  [
    'Block'
    'Log'
  ]
  ```

### Parameter: `sasExpirationPeriod`

The SAS expiration period. DD.HH:MM:SS.

- Required: No
- Type: string
- Default: `''`

### Parameter: `skuName`

Storage Account Sku Name - note: certain V2 SKUs require the use of: kind = FileStorage.

- Required: No
- Type: string
- Default: `'Standard_GRS'`
- Allowed:
  ```Bicep
  [
    'Premium_LRS'
    'Premium_ZRS'
    'PremiumV2_LRS'
    'PremiumV2_ZRS'
    'Standard_GRS'
    'Standard_GZRS'
    'Standard_LRS'
    'Standard_RAGRS'
    'Standard_RAGZRS'
    'Standard_ZRS'
    'StandardV2_GRS'
    'StandardV2_GZRS'
    'StandardV2_LRS'
    'StandardV2_ZRS'
  ]
  ```

### Parameter: `supportsHttpsTrafficOnly`

Allows HTTPS traffic only to storage service if sets to true.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed storage account. |
| `resourceId` | string | The resource ID of the deployed storage account. |
| `serviceEndpoints` | object | All service endpoints of the deployed storage account, Note Standard_LRS and Standard_ZRS accounts only have a blob service endpoint. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/network/private-endpoint:0.11.0` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.6.0` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.6.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
