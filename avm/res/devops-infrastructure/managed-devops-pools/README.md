# Managed DevOps Pools `[Microsoft.DevOpsInfrastructure/manageddevopspools]`

This module deploys the Managed DevOps Pools resource.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.DevOpsInfrastructure/pools` | [2024-04-04-preview](https://learn.microsoft.com/en-us/azure/templates) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`agentProfile`](#parameter-agentprofile) | object | Defines how the machine will be handled once it executed a job. |
| [`concurrency`](#parameter-concurrency) | int | Defines how many resources can there be created at any given time. |
| [`devCenterProjectResourceId`](#parameter-devcenterprojectresourceid) | string | The resource id of the DevCenter Project the pool belongs to. |
| [`fabricProfileSkuName`](#parameter-fabricprofileskuname) | string | The Azure SKU name of the machines in the pool. |
| [`images`](#parameter-images) | array | The VM images of the machines in the pool. |
| [`name`](#parameter-name) | string | Name of the pool. It needs to be globally unique. |
| [`organizationProfile`](#parameter-organizationprofile) | object | Defines the organization in which the pool will be used. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataDisks`](#parameter-datadisks) | array | A list of empty data disks to attach. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | The geo-location where the resource lives. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`logonType`](#parameter-logontype) | string | Determines how the service should be run. By default, this will be set to Service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed service identities assigned to this resource. |
| [`osDiskStorageAccount`](#parameter-osdiskstorageaccount) | string | The Azure SKU name of the machines in the pool. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`secretsManagementSettings`](#parameter-secretsmanagementsettings) | object | The secret management settings of the machines in the pool. |
| [`subnetResourceId`](#parameter-subnetresourceid) | string | The subnet id on which to put all machines created in the pool. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `agentProfile`

Defines how the machine will be handled once it executed a job.

- Required: Yes
- Type: object

### Parameter: `concurrency`

Defines how many resources can there be created at any given time.

- Required: Yes
- Type: int

### Parameter: `devCenterProjectResourceId`

The resource id of the DevCenter Project the pool belongs to.

- Required: Yes
- Type: string

### Parameter: `fabricProfileSkuName`

The Azure SKU name of the machines in the pool.

- Required: Yes
- Type: string

### Parameter: `images`

The VM images of the machines in the pool.

- Required: Yes
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`aliases`](#parameter-imagesaliases) | array | List of aliases to reference the image by. |
| [`buffer`](#parameter-imagesbuffer) | string | The percentage of the buffer to be allocated to this image. |
| [`resourceId`](#parameter-imagesresourceid) | string | The resource id of the image. |
| [`wellKnownImageName`](#parameter-imageswellknownimagename) | string | The image to use from a well-known set of images made available to customers. |

### Parameter: `images.aliases`

List of aliases to reference the image by.

- Required: No
- Type: array

### Parameter: `images.buffer`

The percentage of the buffer to be allocated to this image.

- Required: No
- Type: string

### Parameter: `images.resourceId`

The resource id of the image.

- Required: No
- Type: string

### Parameter: `images.wellKnownImageName`

The image to use from a well-known set of images made available to customers.

- Required: No
- Type: string

### Parameter: `name`

Name of the pool. It needs to be globally unique.

- Required: Yes
- Type: string

### Parameter: `organizationProfile`

Defines the organization in which the pool will be used.

- Required: Yes
- Type: object

### Parameter: `dataDisks`

A list of empty data disks to attach.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`caching`](#parameter-datadiskscaching) | string | The type of caching to be enabled for the data disks. The default value for caching is readwrite. For information about the caching options see: https://blogs.msdn.microsoft.com/windowsazurestorage/2012/06/27/exploring-windows-azure-drives-disks-and-images/. |
| [`diskSizeGiB`](#parameter-datadisksdisksizegib) | int | The initial disk size in gigabytes. |
| [`driveLetter`](#parameter-datadisksdriveletter) | string | The drive letter for the empty data disk. If not specified, it will be the first available letter. Letters A, C, D, and E are not allowed. |
| [`storageAccountType`](#parameter-datadisksstorageaccounttype) | string | The storage Account type to be used for the data disk. If omitted, the default is Standard_LRS. |

### Parameter: `dataDisks.caching`

The type of caching to be enabled for the data disks. The default value for caching is readwrite. For information about the caching options see: https://blogs.msdn.microsoft.com/windowsazurestorage/2012/06/27/exploring-windows-azure-drives-disks-and-images/.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'None'
    'ReadOnly'
    'ReadWrite'
  ]
  ```

### Parameter: `dataDisks.diskSizeGiB`

The initial disk size in gigabytes.

- Required: No
- Type: int

### Parameter: `dataDisks.driveLetter`

The drive letter for the empty data disk. If not specified, it will be the first available letter. Letters A, C, D, and E are not allowed.

- Required: No
- Type: string

### Parameter: `dataDisks.storageAccountType`

The storage Account type to be used for the data disk. If omitted, the default is Standard_LRS.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Premium_LRS'
    'Premium_ZRS'
    'Standard_LRS'
    'StandardSSD_LRS'
    'StandardSSD_ZRS'
  ]
  ```

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

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

The geo-location where the resource lives.

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

### Parameter: `logonType`

Determines how the service should be run. By default, this will be set to Service.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Interactive'
    'Service'
  ]
  ```

### Parameter: `managedIdentities`

The managed service identities assigned to this resource.

- Required: No
- Type: object
- Example:
  ```Bicep
  {
    systemAssigned: true,
    userAssignedResourceIds: [
      '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myManagedIdentity'
    ]
  }
  {
    systemAssigned: true
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`systemAssigned`](#parameter-managedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. |
| [`userAssignedResourceIds`](#parameter-managedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. |

### Parameter: `managedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource.

- Required: No
- Type: array

### Parameter: `osDiskStorageAccount`

The Azure SKU name of the machines in the pool.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Premium'
    'Standard'
    'StandardSSD'
  ]
  ```

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

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

### Parameter: `secretsManagementSettings`

The secret management settings of the machines in the pool.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyExportable`](#parameter-secretsmanagementsettingskeyexportable) | bool | The secret management settings of the machines in the pool. |
| [`observedCertificates`](#parameter-secretsmanagementsettingsobservedcertificates) | array | The list of certificates to install on all machines in the pool. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`certificateStoreLocation`](#parameter-secretsmanagementsettingscertificatestorelocation) | string | Where to store certificates on the machine. |

### Parameter: `secretsManagementSettings.keyExportable`

The secret management settings of the machines in the pool.

- Required: Yes
- Type: bool

### Parameter: `secretsManagementSettings.observedCertificates`

The list of certificates to install on all machines in the pool.

- Required: Yes
- Type: array

### Parameter: `secretsManagementSettings.certificateStoreLocation`

Where to store certificates on the machine.

- Required: No
- Type: string

### Parameter: `subnetResourceId`

The subnet id on which to put all machines created in the pool.

- Required: No
- Type: string

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object


## Outputs

| Output | Type |
| :-- | :-- |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
