# App Service Environments `[Microsoft.Web/hostingEnvironments]`

This module deploys an App Service Environment.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Web/hostingEnvironments` | [2022-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2022-03-01/hostingEnvironments) |
| `Microsoft.Web/hostingEnvironments/configurations` | [2022-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/hostingEnvironments/configurations) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/web/hosting-environment:<version>`.

- [Using default parameter set](#example-1-using-default-parameter-set)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using default parameter set_

This instance deploys the module with a base set of parameters. Note it does include the use of Availability zones by default.


<details>

<summary>via Bicep module</summary>

```bicep
module hostingEnvironment 'br/public:avm/res/web/hosting-environment:<version>' = {
  name: 'hostingEnvironmentDeployment'
  params: {
    // Required parameters
    name: 'whemin001'
    subnetResourceId: '<subnetResourceId>'
    // Non-required parameters
    kind: 'ASEv3'
    location: '<location>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "whemin001"
    },
    "subnetResourceId": {
      "value": "<subnetResourceId>"
    },
    // Non-required parameters
    "kind": {
      "value": "ASEv3"
    },
    "location": {
      "value": "<location>"
    }
  }
}
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module hostingEnvironment 'br/public:avm/res/web/hosting-environment:<version>' = {
  name: 'hostingEnvironmentDeployment'
  params: {
    // Required parameters
    name: 'whemax001'
    subnetResourceId: '<subnetResourceId>'
    // Non-required parameters
    allowNewPrivateEndpointConnections: true
    clusterSettings: [
      {
        name: 'DisableTls1.0'
        value: '1'
      }
    ]
    customDnsSuffix: 'internal.contoso.com'
    customDnsSuffixCertificateUrl: '<customDnsSuffixCertificateUrl>'
    customDnsSuffixKeyVaultReferenceIdentity: '<customDnsSuffixKeyVaultReferenceIdentity>'
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    ftpEnabled: true
    inboundIpAddressOverride: '10.0.0.10'
    internalLoadBalancingMode: 'Web, Publishing'
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    remoteDebugEnabled: true
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Owner'
      }
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
      }
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
      }
    ]
    tags: {
      'hidden-title': 'This is visible in the resource name'
      hostingEnvironmentName: 'whemax001'
      resourceType: 'App Service Environment'
    }
    upgradePreference: 'Late'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "whemax001"
    },
    "subnetResourceId": {
      "value": "<subnetResourceId>"
    },
    // Non-required parameters
    "allowNewPrivateEndpointConnections": {
      "value": true
    },
    "clusterSettings": {
      "value": [
        {
          "name": "DisableTls1.0",
          "value": "1"
        }
      ]
    },
    "customDnsSuffix": {
      "value": "internal.contoso.com"
    },
    "customDnsSuffixCertificateUrl": {
      "value": "<customDnsSuffixCertificateUrl>"
    },
    "customDnsSuffixKeyVaultReferenceIdentity": {
      "value": "<customDnsSuffixKeyVaultReferenceIdentity>"
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "ftpEnabled": {
      "value": true
    },
    "inboundIpAddressOverride": {
      "value": "10.0.0.10"
    },
    "internalLoadBalancingMode": {
      "value": "Web, Publishing"
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": true,
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "remoteDebugEnabled": {
      "value": true
    },
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Owner"
        },
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "b24988ac-6180-42a0-ab88-20f7382dd24c"
        },
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "<roleDefinitionIdOrName>"
        }
      ]
    },
    "tags": {
      "value": {
        "hidden-title": "This is visible in the resource name",
        "hostingEnvironmentName": "whemax001",
        "resourceType": "App Service Environment"
      }
    },
    "upgradePreference": {
      "value": "Late"
    }
  }
}
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module hostingEnvironment 'br/public:avm/res/web/hosting-environment:<version>' = {
  name: 'hostingEnvironmentDeployment'
  params: {
    // Required parameters
    name: 'whewaf001'
    subnetResourceId: '<subnetResourceId>'
    // Non-required parameters
    allowNewPrivateEndpointConnections: true
    clusterSettings: [
      {
        name: 'DisableTls1.0'
        value: '1'
      }
    ]
    customDnsSuffix: 'internal.contoso.com'
    customDnsSuffixCertificateUrl: '<customDnsSuffixCertificateUrl>'
    customDnsSuffixKeyVaultReferenceIdentity: '<customDnsSuffixKeyVaultReferenceIdentity>'
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    ftpEnabled: true
    inboundIpAddressOverride: '10.0.0.10'
    internalLoadBalancingMode: 'Web, Publishing'
    location: '<location>'
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    remoteDebugEnabled: true
    tags: {
      'hidden-title': 'This is visible in the resource name'
      hostingEnvironmentName: 'whewaf001'
      resourceType: 'App Service Environment'
    }
    upgradePreference: 'Late'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "whewaf001"
    },
    "subnetResourceId": {
      "value": "<subnetResourceId>"
    },
    // Non-required parameters
    "allowNewPrivateEndpointConnections": {
      "value": true
    },
    "clusterSettings": {
      "value": [
        {
          "name": "DisableTls1.0",
          "value": "1"
        }
      ]
    },
    "customDnsSuffix": {
      "value": "internal.contoso.com"
    },
    "customDnsSuffixCertificateUrl": {
      "value": "<customDnsSuffixCertificateUrl>"
    },
    "customDnsSuffixKeyVaultReferenceIdentity": {
      "value": "<customDnsSuffixKeyVaultReferenceIdentity>"
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "ftpEnabled": {
      "value": true
    },
    "inboundIpAddressOverride": {
      "value": "10.0.0.10"
    },
    "internalLoadBalancingMode": {
      "value": "Web, Publishing"
    },
    "location": {
      "value": "<location>"
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": true,
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "remoteDebugEnabled": {
      "value": true
    },
    "tags": {
      "value": {
        "hidden-title": "This is visible in the resource name",
        "hostingEnvironmentName": "whewaf001",
        "resourceType": "App Service Environment"
      }
    },
    "upgradePreference": {
      "value": "Late"
    }
  }
}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the resource to create. |
| [`subnetResourceId`](#parameter-subnetresourceid) | string | ResourceId for the subnet. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowNewPrivateEndpointConnections`](#parameter-allownewprivateendpointconnections) | bool | Property to enable and disable new private endpoint connection creation on ASE. |
| [`clusterSettings`](#parameter-clustersettings) | array | Custom settings for changing the behavior of the App Service Environment. |
| [`customDnsSuffix`](#parameter-customdnssuffix) | string | Enable the default custom domain suffix to use for all sites deployed on the ASE. If provided, then customDnsSuffixCertificateUrl and customDnsSuffixKeyVaultReferenceIdentity are required. |
| [`customDnsSuffixCertificateUrl`](#parameter-customdnssuffixcertificateurl) | string | The URL referencing the Azure Key Vault certificate secret that should be used as the default SSL/TLS certificate for sites with the custom domain suffix. Required if customDnsSuffix is not empty. |
| [`customDnsSuffixKeyVaultReferenceIdentity`](#parameter-customdnssuffixkeyvaultreferenceidentity) | string | The user-assigned identity to use for resolving the key vault certificate reference. If not specified, the system-assigned ASE identity will be used if available. Required if customDnsSuffix is not empty. |
| [`dedicatedHostCount`](#parameter-dedicatedhostcount) | int | The Dedicated Host Count. If `zoneRedundant` is false, and you want physical hardware isolation enabled, set to 2. Otherwise 0. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`dnsSuffix`](#parameter-dnssuffix) | string | DNS suffix of the App Service Environment. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`frontEndScaleFactor`](#parameter-frontendscalefactor) | int | Scale factor for frontends. |
| [`ftpEnabled`](#parameter-ftpenabled) | bool | Property to enable and disable FTP on ASEV3. |
| [`inboundIpAddressOverride`](#parameter-inboundipaddressoverride) | string | Customer provided Inbound IP Address. Only able to be set on Ase create. |
| [`internalLoadBalancingMode`](#parameter-internalloadbalancingmode) | string | Specifies which endpoints to serve internally in the Virtual Network for the App Service Environment. - None, Web, Publishing, Web,Publishing. "None" Exposes the ASE-hosted apps on an internet-accessible IP address. |
| [`kind`](#parameter-kind) | string | Kind of resource. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`remoteDebugEnabled`](#parameter-remotedebugenabled) | bool | Property to enable and disable Remote Debug on ASEv3. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`upgradePreference`](#parameter-upgradepreference) | string | Specify preference for when and how the planned maintenance is applied. |
| [`zoneRedundant`](#parameter-zoneredundant) | bool | Switch to make the App Service Environment zone redundant. If enabled, the minimum App Service plan instance count will be three, otherwise 1. If enabled, the `dedicatedHostCount` must be set to `-1`. |

### Parameter: `name`

Name of the resource to create.

- Required: Yes
- Type: string

### Parameter: `subnetResourceId`

ResourceId for the subnet.

- Required: Yes
- Type: string

### Parameter: `allowNewPrivateEndpointConnections`

Property to enable and disable new private endpoint connection creation on ASE.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `clusterSettings`

Custom settings for changing the behavior of the App Service Environment.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    {
      name: 'DisableTls1.0'
      value: '1'
    }
  ]
  ```

### Parameter: `customDnsSuffix`

Enable the default custom domain suffix to use for all sites deployed on the ASE. If provided, then customDnsSuffixCertificateUrl and customDnsSuffixKeyVaultReferenceIdentity are required.

- Required: No
- Type: string
- Default: `''`

### Parameter: `customDnsSuffixCertificateUrl`

The URL referencing the Azure Key Vault certificate secret that should be used as the default SSL/TLS certificate for sites with the custom domain suffix. Required if customDnsSuffix is not empty.

- Required: No
- Type: string
- Default: `''`

### Parameter: `customDnsSuffixKeyVaultReferenceIdentity`

The user-assigned identity to use for resolving the key vault certificate reference. If not specified, the system-assigned ASE identity will be used if available. Required if customDnsSuffix is not empty.

- Required: No
- Type: string
- Default: `''`

### Parameter: `dedicatedHostCount`

The Dedicated Host Count. If `zoneRedundant` is false, and you want physical hardware isolation enabled, set to 2. Otherwise 0.

- Required: No
- Type: int
- Default: `0`

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
| [`logCategoriesAndGroups`](#parameter-diagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-diagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
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

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-diagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-diagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to 'AllLogs' to collect all logs. |

### Parameter: `diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to 'AllLogs' to collect all logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

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

### Parameter: `dnsSuffix`

DNS suffix of the App Service Environment.

- Required: No
- Type: string
- Default: `''`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `frontEndScaleFactor`

Scale factor for frontends.

- Required: No
- Type: int
- Default: `15`

### Parameter: `ftpEnabled`

Property to enable and disable FTP on ASEV3.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `inboundIpAddressOverride`

Customer provided Inbound IP Address. Only able to be set on Ase create.

- Required: No
- Type: string
- Default: `''`

### Parameter: `internalLoadBalancingMode`

Specifies which endpoints to serve internally in the Virtual Network for the App Service Environment. - None, Web, Publishing, Web,Publishing. "None" Exposes the ASE-hosted apps on an internet-accessible IP address.

- Required: No
- Type: string
- Default: `'None'`
- Allowed:
  ```Bicep
  [
    'None'
    'Publishing'
    'Web'
    'Web, Publishing'
  ]
  ```

### Parameter: `kind`

Kind of resource.

- Required: No
- Type: string
- Default: `'ASEv3'`
- Allowed:
  ```Bicep
  [
    'ASEv3'
  ]
  ```

### Parameter: `location`

Location for all Resources.

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

### Parameter: `managedIdentities`

The managed identity definition for this resource.

- Required: No
- Type: object

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

### Parameter: `remoteDebugEnabled`

Property to enable and disable Remote Debug on ASEv3.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator (Preview)'`
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

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `upgradePreference`

Specify preference for when and how the planned maintenance is applied.

- Required: No
- Type: string
- Default: `'None'`
- Allowed:
  ```Bicep
  [
    'Early'
    'Late'
    'Manual'
    'None'
  ]
  ```

### Parameter: `zoneRedundant`

Switch to make the App Service Environment zone redundant. If enabled, the minimum App Service plan instance count will be three, otherwise 1. If enabled, the `dedicatedHostCount` must be set to `-1`.

- Required: No
- Type: bool
- Default: `False`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the App Service Environment. |
| `resourceGroupName` | string | The resource group the App Service Environment was deployed into. |
| `resourceId` | string | The resource ID of the App Service Environment. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
