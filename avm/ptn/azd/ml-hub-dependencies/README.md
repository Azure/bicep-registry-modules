# Azd Azure Machine Learning Dependencies `[Azd/MlHubDependencies]`

Creates all the dependencies required for a Machine Learning Service.

**Note:** This module is not intended for broad, generic use, as it was designed to cater for the requirements of the AZD CLI product. Feature requests and bug fix requests are welcome if they support the development of the AZD CLI but may not be incorporated if they aim to make this module more generic than what it needs to be for its primary use case.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.CognitiveServices/accounts` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2023-05-01/accounts) |
| `Microsoft.CognitiveServices/accounts/deployments` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2023-05-01/accounts/deployments) |
| `Microsoft.ContainerRegistry/registries` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries) |
| `Microsoft.ContainerRegistry/registries/cacheRules` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/cacheRules) |
| `Microsoft.ContainerRegistry/registries/credentialSets` | [2023-11-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/credentialSets) |
| `Microsoft.ContainerRegistry/registries/replications` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/replications) |
| `Microsoft.ContainerRegistry/registries/scopeMaps` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/scopeMaps) |
| `Microsoft.ContainerRegistry/registries/webhooks` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/webhooks) |
| `Microsoft.Insights/components` | [2020-02-02](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2020-02-02/components) |
| `microsoft.insights/components/linkedStorageAccounts` | [2020-03-01-preview](https://learn.microsoft.com/en-us/azure/templates/microsoft.insights/2020-03-01-preview/components/linkedStorageAccounts) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.KeyVault/vaults` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults) |
| `Microsoft.KeyVault/vaults/accessPolicies` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/accessPolicies) |
| `Microsoft.KeyVault/vaults/keys` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/keys) |
| `Microsoft.KeyVault/vaults/secrets` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/secrets) |
| `Microsoft.Network/privateEndpoints` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.OperationalInsights/workspaces` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2022-10-01/workspaces) |
| `Microsoft.OperationalInsights/workspaces/dataExports` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/dataExports) |
| `Microsoft.OperationalInsights/workspaces/dataSources` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/dataSources) |
| `Microsoft.OperationalInsights/workspaces/linkedServices` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/linkedServices) |
| `Microsoft.OperationalInsights/workspaces/linkedStorageAccounts` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/linkedStorageAccounts) |
| `Microsoft.OperationalInsights/workspaces/savedSearches` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/savedSearches) |
| `Microsoft.OperationalInsights/workspaces/storageInsightConfigs` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/storageInsightConfigs) |
| `Microsoft.OperationalInsights/workspaces/tables` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2022-10-01/workspaces/tables) |
| `Microsoft.OperationsManagement/solutions` | [2015-11-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationsManagement/2015-11-01-preview/solutions) |
| `Microsoft.Portal/dashboards` | [2020-09-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Portal/2020-09-01-preview/dashboards) |
| `Microsoft.Search/searchServices` | [2024-03-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Search/2024-03-01-preview/searchServices) |
| `Microsoft.Search/searchServices/sharedPrivateLinkResources` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Search/2023-11-01/searchServices/sharedPrivateLinkResources) |
| `Microsoft.Storage/storageAccounts` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts) |
| `Microsoft.Storage/storageAccounts/blobServices` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices) |
| `Microsoft.Storage/storageAccounts/blobServices/containers` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices/containers) |
| `Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices/containers/immutabilityPolicies) |
| `Microsoft.Storage/storageAccounts/fileServices` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-04-01/storageAccounts/fileServices) |
| `Microsoft.Storage/storageAccounts/fileServices/shares` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-01-01/storageAccounts/fileServices/shares) |
| `Microsoft.Storage/storageAccounts/localUsers` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-04-01/storageAccounts/localUsers) |
| `Microsoft.Storage/storageAccounts/managementPolicies` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-01-01/storageAccounts/managementPolicies) |
| `Microsoft.Storage/storageAccounts/queueServices` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-04-01/storageAccounts/queueServices) |
| `Microsoft.Storage/storageAccounts/queueServices/queues` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-04-01/storageAccounts/queueServices/queues) |
| `Microsoft.Storage/storageAccounts/tableServices` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-04-01/storageAccounts/tableServices) |
| `Microsoft.Storage/storageAccounts/tableServices/tables` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-04-01/storageAccounts/tableServices/tables) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/azd/ml-hub-dependencies:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module mlHubDependencies 'br/public:avm/ptn/azd/ml-hub-dependencies:<version>' = {
  name: 'mlHubDependenciesDeployment'
  params: {
    // Required parameters
    cognitiveServicesName: 'cog07hubdmin'
    keyVaultName: 'key07hubdmin'
    storageAccountName: 'st07hubdmin'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "cognitiveServicesName": {
      "value": "cog07hubdmin"
    },
    "keyVaultName": {
      "value": "key07hubdmin"
    },
    "storageAccountName": {
      "value": "st07hubdmin"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/azd/ml-hub-dependencies:<version>'

// Required parameters
param cognitiveServicesName = 'cog07hubdmin'
param keyVaultName = 'key07hubdmin'
param storageAccountName = 'st07hubdmin'
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module using large parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module mlHubDependencies 'br/public:avm/ptn/azd/ml-hub-dependencies:<version>' = {
  name: 'mlHubDependenciesDeployment'
  params: {
    // Required parameters
    cognitiveServicesName: 'cs08mhdpmax'
    keyVaultName: 'kv08mhdpmax'
    storageAccountName: 'sa08mhdpmax'
    // Non-required parameters
    applicationInsightsDashboardName: 'aid08mhdpmax'
    applicationInsightsName: 'ai08mhdpmax'
    containerRegistryName: 'cr08mhdpmax'
    logAnalyticsName: 'log08mhdpmax'
    searchServiceName: 'sea08mhdpmax'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "cognitiveServicesName": {
      "value": "cs08mhdpmax"
    },
    "keyVaultName": {
      "value": "kv08mhdpmax"
    },
    "storageAccountName": {
      "value": "sa08mhdpmax"
    },
    // Non-required parameters
    "applicationInsightsDashboardName": {
      "value": "aid08mhdpmax"
    },
    "applicationInsightsName": {
      "value": "ai08mhdpmax"
    },
    "containerRegistryName": {
      "value": "cr08mhdpmax"
    },
    "logAnalyticsName": {
      "value": "log08mhdpmax"
    },
    "searchServiceName": {
      "value": "sea08mhdpmax"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/azd/ml-hub-dependencies:<version>'

// Required parameters
param cognitiveServicesName = 'cs08mhdpmax'
param keyVaultName = 'kv08mhdpmax'
param storageAccountName = 'sa08mhdpmax'
// Non-required parameters
param applicationInsightsDashboardName = 'aid08mhdpmax'
param applicationInsightsName = 'ai08mhdpmax'
param containerRegistryName = 'cr08mhdpmax'
param logAnalyticsName = 'log08mhdpmax'
param searchServiceName = 'sea08mhdpmax'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`cognitiveServicesName`](#parameter-cognitiveservicesname) | string | Name of the OpenAI cognitive services. |
| [`keyVaultName`](#parameter-keyvaultname) | string | Name of the key vault. |
| [`storageAccountName`](#parameter-storageaccountname) | string | Name of the storage account. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. Required if `assignRbacRole` is `true` and `managedIdentityName` is `null`. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowBlobPublicAccess`](#parameter-allowblobpublicaccess) | bool | Indicates whether public access is enabled for all blobs or containers in the storage account. For security reasons, it is recommended to set it to false. |
| [`applicationInsightsDashboardName`](#parameter-applicationinsightsdashboardname) | string | The resource portal dashboards name. |
| [`applicationInsightsName`](#parameter-applicationinsightsname) | string | The resource insights components name. |
| [`authOptions`](#parameter-authoptions) | object | Defines the options for how the data plane API of a Search service authenticates requests. Must remain an empty object {} if 'disableLocalAuth' is set to true. |
| [`blobServices`](#parameter-blobservices) | object | Blob service and containers to deploy. |
| [`cmkEnforcement`](#parameter-cmkenforcement) | string | Describes a policy that determines how resources within the search service are to be encrypted with Customer Managed Keys. |
| [`cognitiveServicesCustomSubDomainName`](#parameter-cognitiveservicescustomsubdomainname) | string | The custom subdomain name used to access the API. Defaults to the value of the name parameter. |
| [`cognitiveServicesDeployments`](#parameter-cognitiveservicesdeployments) | array | Array of deployments about cognitive service accounts to create. |
| [`cognitiveServicesDisableLocalAuth`](#parameter-cognitiveservicesdisablelocalauth) | bool | Allow only Azure AD authentication. Should be enabled for security reasons. |
| [`cognitiveServicesKind`](#parameter-cognitiveserviceskind) | string | Kind of the Cognitive Services. |
| [`cognitiveServicesNetworkAcls`](#parameter-cognitiveservicesnetworkacls) | object | A collection of rules governing the accessibility from specific network locations. |
| [`cognitiveServicesPublicNetworkAccess`](#parameter-cognitiveservicespublicnetworkaccess) | string | Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and networkAcls are not set. |
| [`cognitiveServicesSku`](#parameter-cognitiveservicessku) | string | SKU of the Cognitive Services resource. |
| [`containerRegistryName`](#parameter-containerregistryname) | string | Name of the container registry. |
| [`dataRetention`](#parameter-dataretention) | int | Number of days data will be retained for. |
| [`disableLocalAuth`](#parameter-disablelocalauth) | bool | When set to true, calls to the search service will not be permitted to utilize API keys for authentication. This cannot be set to true if 'authOptions' are defined. |
| [`dnsEndpointType`](#parameter-dnsendpointtype) | string | Allows you to specify the type of endpoint in the storage account. Set this to AzureDNSZone to create a large number of accounts in a single subscription, which creates accounts in an Azure DNS Zone and the endpoint URL will have an alphanumeric DNS Zone identifier. |
| [`enablePurgeProtection`](#parameter-enablepurgeprotection) | bool | Provide 'true' to enable Key Vault's purge protection feature. |
| [`enableRbacAuthorization`](#parameter-enablerbacauthorization) | bool | Property that controls how data actions are authorized. When true, the key vault will use Role Based Access Control (RBAC) for authorization of data actions, and the access policies specified in vault properties will be ignored. When false, the key vault will use the access policies specified in vault properties, and any policy stored on Azure Resource Manager will be ignored. Note that management actions are always authorized with RBAC. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`enableVaultForDeployment`](#parameter-enablevaultfordeployment) | bool | Specifies if the vault is enabled for deployment by script or compute. |
| [`enableVaultForTemplateDeployment`](#parameter-enablevaultfortemplatedeployment) | bool | Specifies if the vault is enabled for a template deployment. |
| [`fileServices`](#parameter-fileservices) | object | File service and shares to deploy. |
| [`hostingMode`](#parameter-hostingmode) | string | Applicable only for the standard3 SKU. You can set this property to enable up to 3 high density partitions that allow up to 1000 indexes, which is much higher than the maximum indexes allowed for any other SKU. For the standard3 SKU, the value is either 'default' or 'highDensity'. For all other SKUs, this value must be 'default'. |
| [`keyVaultSku`](#parameter-keyvaultsku) | string | Specifies the SKU for the vault. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`logAnalyticsName`](#parameter-loganalyticsname) | string | The resource operational insights workspaces name. |
| [`logAnalyticsSkuName`](#parameter-loganalyticsskuname) | string | The name of the SKU. |
| [`networkAcls`](#parameter-networkacls) | object | Networks ACLs, this value contains IPs to whitelist and/or Subnet information. If in use, bypass needs to be supplied. For security reasons, it is recommended to set the DefaultAction Deny. |
| [`networkRuleSet`](#parameter-networkruleset) | object | Network specific rules that determine how the Azure Cognitive Search service may be reached. |
| [`partitionCount`](#parameter-partitioncount) | int | The number of partitions in the search service; if specified, it can be 1, 2, 3, 4, 6, or 12. Values greater than 1 are only valid for standard SKUs. For 'standard3' services with hostingMode set to 'highDensity', the allowed values are between 1 and 3. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Whether or not public network access is allowed for the storage account. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and networkAcls are not set. |
| [`queueServices`](#parameter-queueservices) | object | Queue service and queues to create. |
| [`registryAcrSku`](#parameter-registryacrsku) | string | Tier of your Azure container registry. |
| [`registryPublicNetworkAccess`](#parameter-registrypublicnetworkaccess) | string | Public network access setting. |
| [`replicaCount`](#parameter-replicacount) | int | The number of replicas in the search service. If specified, it must be a value between 1 and 12 inclusive for standard SKUs or between 1 and 3 inclusive for basic SKU. |
| [`searchServiceName`](#parameter-searchservicename) | string | Name of the Azure Cognitive Search service. |
| [`searchServicePublicNetworkAccess`](#parameter-searchservicepublicnetworkaccess) | string | This value can be set to 'Enabled' to avoid breaking changes on existing customer resources and templates. If set to 'Disabled', traffic over public interface is not allowed, and private endpoint connections would be the exclusive access method. |
| [`searchServiceSku`](#parameter-searchservicesku) | string | Defines the SKU of an Azure Cognitive Search Service, which determines price tier and capacity limits. |
| [`semanticSearch`](#parameter-semanticsearch) | string | Sets options that control the availability of semantic search. This configuration is only possible for certain search SKUs in certain locations. |
| [`tableServices`](#parameter-tableservices) | object | Table service and tables to create. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `cognitiveServicesName`

Name of the OpenAI cognitive services.

- Required: Yes
- Type: string

### Parameter: `keyVaultName`

Name of the key vault.

- Required: Yes
- Type: string

### Parameter: `storageAccountName`

Name of the storage account.

- Required: Yes
- Type: string

### Parameter: `managedIdentities`

The managed identity definition for this resource. Required if `assignRbacRole` is `true` and `managedIdentityName` is `null`.

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

### Parameter: `allowBlobPublicAccess`

Indicates whether public access is enabled for all blobs or containers in the storage account. For security reasons, it is recommended to set it to false.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `applicationInsightsDashboardName`

The resource portal dashboards name.

- Required: No
- Type: string
- Default: `''`

### Parameter: `applicationInsightsName`

The resource insights components name.

- Required: No
- Type: string
- Default: `''`

### Parameter: `authOptions`

Defines the options for how the data plane API of a Search service authenticates requests. Must remain an empty object {} if 'disableLocalAuth' is set to true.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `blobServices`

Blob service and containers to deploy.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      containerDeleteRetentionPolicyDays: 7
      containers: [
        {
          name: 'default'
        }
      ]
      corsRules: [
        {
          allowedHeaders: [
            '*'
          ]
          allowedMethods: [
            'DELETE'
            'GET'
            'HEAD'
            'OPTIONS'
            'PATCH'
            'POST'
            'PUT'
          ]
          allowedOrigins: [
            'https://*.ai.azure.com'
            'https://*.ml.azure.com'
            'https://ai.azure.com'
            'https://ml.azure.com'
            'https://mlworkspace.azure.ai'
            'https://mlworkspace.azureml-test.net'
            'https://mlworkspacecanary.azure.ai'
          ]
          exposedHeaders: [
            '*'
          ]
          maxAgeInSeconds: 1800
        }
      ]
      deleteRetentionPolicyAllowPermanentDelete: true
      deleteRetentionPolicyDays: 6
      deleteRetentionPolicyEnabled: true
  }
  ```

### Parameter: `cmkEnforcement`

Describes a policy that determines how resources within the search service are to be encrypted with Customer Managed Keys.

- Required: No
- Type: string
- Default: `'Unspecified'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
    'Unspecified'
  ]
  ```

### Parameter: `cognitiveServicesCustomSubDomainName`

The custom subdomain name used to access the API. Defaults to the value of the name parameter.

- Required: No
- Type: string
- Default: `[parameters('cognitiveServicesName')]`

### Parameter: `cognitiveServicesDeployments`

Array of deployments about cognitive service accounts to create.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `cognitiveServicesDisableLocalAuth`

Allow only Azure AD authentication. Should be enabled for security reasons.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `cognitiveServicesKind`

Kind of the Cognitive Services.

- Required: No
- Type: string
- Default: `'AIServices'`

### Parameter: `cognitiveServicesNetworkAcls`

A collection of rules governing the accessibility from specific network locations.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      defaultAction: 'Allow'
  }
  ```

### Parameter: `cognitiveServicesPublicNetworkAccess`

Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and networkAcls are not set.

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

### Parameter: `cognitiveServicesSku`

SKU of the Cognitive Services resource.

- Required: No
- Type: string
- Default: `'S0'`

### Parameter: `containerRegistryName`

Name of the container registry.

- Required: No
- Type: string
- Default: `''`

### Parameter: `dataRetention`

Number of days data will be retained for.

- Required: No
- Type: int
- Default: `30`

### Parameter: `disableLocalAuth`

When set to true, calls to the search service will not be permitted to utilize API keys for authentication. This cannot be set to true if 'authOptions' are defined.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `dnsEndpointType`

Allows you to specify the type of endpoint in the storage account. Set this to AzureDNSZone to create a large number of accounts in a single subscription, which creates accounts in an Azure DNS Zone and the endpoint URL will have an alphanumeric DNS Zone identifier.

- Required: No
- Type: string
- Default: `'Standard'`
- Allowed:
  ```Bicep
  [
    ''
    'AzureDnsZone'
    'Standard'
  ]
  ```

### Parameter: `enablePurgeProtection`

Provide 'true' to enable Key Vault's purge protection feature.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableRbacAuthorization`

Property that controls how data actions are authorized. When true, the key vault will use Role Based Access Control (RBAC) for authorization of data actions, and the access policies specified in vault properties will be ignored. When false, the key vault will use the access policies specified in vault properties, and any policy stored on Azure Resource Manager will be ignored. Note that management actions are always authorized with RBAC.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableVaultForDeployment`

Specifies if the vault is enabled for deployment by script or compute.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableVaultForTemplateDeployment`

Specifies if the vault is enabled for a template deployment.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `fileServices`

File service and shares to deploy.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      name: 'default'
  }
  ```

### Parameter: `hostingMode`

Applicable only for the standard3 SKU. You can set this property to enable up to 3 high density partitions that allow up to 1000 indexes, which is much higher than the maximum indexes allowed for any other SKU. For the standard3 SKU, the value is either 'default' or 'highDensity'. For all other SKUs, this value must be 'default'.

- Required: No
- Type: string
- Default: `'default'`
- Allowed:
  ```Bicep
  [
    'default'
    'highDensity'
  ]
  ```

### Parameter: `keyVaultSku`

Specifies the SKU for the vault.

- Required: No
- Type: string
- Default: `'standard'`
- Allowed:
  ```Bicep
  [
    'premium'
    'standard'
  ]
  ```

### Parameter: `location`

Location for all Resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `logAnalyticsName`

The resource operational insights workspaces name.

- Required: No
- Type: string
- Default: `''`

### Parameter: `logAnalyticsSkuName`

The name of the SKU.

- Required: No
- Type: string
- Default: `'PerGB2018'`
- Allowed:
  ```Bicep
  [
    'CapacityReservation'
    'Free'
    'LACluster'
    'PerGB2018'
    'PerNode'
    'Premium'
    'Standalone'
    'Standard'
  ]
  ```

### Parameter: `networkAcls`

Networks ACLs, this value contains IPs to whitelist and/or Subnet information. If in use, bypass needs to be supplied. For security reasons, it is recommended to set the DefaultAction Deny.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
  }
  ```

### Parameter: `networkRuleSet`

Network specific rules that determine how the Azure Cognitive Search service may be reached.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      bypass: 'None'
      ipRules: []
  }
  ```

### Parameter: `partitionCount`

The number of partitions in the search service; if specified, it can be 1, 2, 3, 4, 6, or 12. Values greater than 1 are only valid for standard SKUs. For 'standard3' services with hostingMode set to 'highDensity', the allowed values are between 1 and 3.

- Required: No
- Type: int
- Default: `1`

### Parameter: `publicNetworkAccess`

Whether or not public network access is allowed for the storage account. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and networkAcls are not set.

- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed:
  ```Bicep
  [
    ''
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `queueServices`

Queue service and queues to create.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      name: 'default'
  }
  ```

### Parameter: `registryAcrSku`

Tier of your Azure container registry.

- Required: No
- Type: string
- Default: `'Basic'`
- Allowed:
  ```Bicep
  [
    'Basic'
    'Premium'
    'Standard'
  ]
  ```

### Parameter: `registryPublicNetworkAccess`

Public network access setting.

- Required: No
- Type: string
- Default: `'Enabled'`

### Parameter: `replicaCount`

The number of replicas in the search service. If specified, it must be a value between 1 and 12 inclusive for standard SKUs or between 1 and 3 inclusive for basic SKU.

- Required: No
- Type: int
- Default: `1`

### Parameter: `searchServiceName`

Name of the Azure Cognitive Search service.

- Required: No
- Type: string
- Default: `''`

### Parameter: `searchServicePublicNetworkAccess`

This value can be set to 'Enabled' to avoid breaking changes on existing customer resources and templates. If set to 'Disabled', traffic over public interface is not allowed, and private endpoint connections would be the exclusive access method.

- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `searchServiceSku`

Defines the SKU of an Azure Cognitive Search Service, which determines price tier and capacity limits.

- Required: No
- Type: string
- Default: `'standard'`
- Allowed:
  ```Bicep
  [
    'basic'
    'free'
    'standard'
    'standard2'
    'standard3'
    'storage_optimized_l1'
    'storage_optimized_l2'
  ]
  ```

### Parameter: `semanticSearch`

Sets options that control the availability of semantic search. This configuration is only possible for certain search SKUs in certain locations.

- Required: No
- Type: string
- Default: `'disabled'`
- Allowed:
  ```Bicep
  [
    'disabled'
    'free'
    'standard'
  ]
  ```

### Parameter: `tableServices`

Table service and tables to create.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      name: 'default'
  }
  ```

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object
- Example:
  ```Bicep
  {
      "key1": "value1"
      "key2": "value2"
  }
  ```

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `applicationInsightsConnectionString` | string | The connection string of the application insights. |
| `applicationInsightsInstrumentationKey` | string | The instrumentation key of the application insights. |
| `applicationInsightsName` | string | The name of the application insights. |
| `applicationInsightsResourceId` | string | The resource ID of the application insights. |
| `cognitiveServicesEndpoint` | string | The endpoint of the cognitive services. |
| `cognitiveServicesName` | string | The name of the cognitive services. |
| `cognitiveServicesResourceId` | string | The resource ID of the cognitive services. |
| `containerRegistryEndpoint` | string | The endpoint of the container registry. |
| `containerRegistryName` | string | The name of the container registry. |
| `containerRegistryResourceId` | string | The resource ID of the container registry. |
| `keyVaultEndpoint` | string | The endpoint of the key vault. |
| `keyVaultName` | string | The name of the key vault. |
| `keyVaultResourceId` | string | The resource ID of the key vault. |
| `logAnalyticsWorkspaceName` | string | The name of the loganalytics workspace. |
| `logAnalyticsWorkspaceResourceId` | string | The resource ID of the loganalytics workspace. |
| `resourceGroupName` | string | The name of the resource group the module was deployed to. |
| `searchServiceEndpoint` | string | The endpoint of the search service. |
| `searchServiceName` | string | The name of the search service. |
| `searchServiceResourceId` | string | The resource ID of the search service. |
| `storageAccountName` | string | The name of the storage account. |
| `storageAccountResourceId` | string | The resource ID of the storage account. |
| `systemAssignedMiPrincipalId` | string | The system assigned mi principal Id key of the search service. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/ptn/azd/insights-dashboard:0.1.0` | Remote reference |
| `br/public:avm/res/cognitive-services/account:0.7.0` | Remote reference |
| `br/public:avm/res/container-registry/registry:0.4.0` | Remote reference |
| `br/public:avm/res/key-vault/vault:0.7.1` | Remote reference |
| `br/public:avm/res/operational-insights/workspace:0.6.0` | Remote reference |
| `br/public:avm/res/search/search-service:0.6.0` | Remote reference |
| `br/public:avm/res/storage/storage-account:0.9.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
