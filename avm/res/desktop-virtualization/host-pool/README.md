# Azure Virtual Desktop Host Pool `[Microsoft.DesktopVirtualization/hostPools]`

This module deploys an Azure Virtual Desktop Host Pool

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
| `Microsoft.DesktopVirtualization/hostPools` | [2023-09-05](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DesktopVirtualization/2023-09-05/hostPools) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/privateEndpoints` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints/privateDnsZoneGroups) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/desktop-virtualization/host-pool:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module hostPool 'br/public:avm/res/desktop-virtualization/host-pool:<version>' = {
  name: 'hostPoolDeployment'
  params: {
    // Required parameters
    name: 'dvhpmin002'
    // Non-required parameters
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
      "value": "dvhpmin002"
    },
    // Non-required parameters
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
module hostPool 'br/public:avm/res/desktop-virtualization/host-pool:<version>' = {
  name: 'hostPoolDeployment'
  params: {
    // Required parameters
    name: 'dvhpmax001'
    // Non-required parameters
    agentUpdate: {
      maintenanceWindows: [
        {
          dayOfWeek: 'Friday'
          hour: 7
        }
        {
          dayOfWeek: 'Saturday'
          hour: 8
        }
      ]
      maintenanceWindowTimeZone: 'Alaskan Standard Time'
      type: 'Scheduled'
      useSessionHostLocalTime: false
    }
    customRdpProperty: 'audiocapturemode:i:1;audiomode:i:0;drivestoredirect:s:;redirectclipboard:i:1;redirectcomports:i:1;redirectprinters:i:1;redirectsmartcards:i:1;screen mode id:i:2;'
    description: 'My first AVD Host Pool'
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        logCategoriesAndGroups: [
          {
            categoryGroup: 'allLogs'
          }
        ]
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    enableTelemetry: true
    friendlyName: 'AVDv2'
    hostPoolType: 'Pooled'
    loadBalancerType: 'BreadthFirst'
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    maxSessionLimit: 99999
    personalDesktopAssignmentType: 'Automatic'
    privateEndpoints: [
      {
        privateDnsZoneResourceIds: [
          '<privateDNSZoneResourceId>'
        ]
        subnetResourceId: '<subnetResourceId>'
      }
      {
        privateDnsZoneResourceIds: [
          '<privateDNSZoneResourceId>'
        ]
        subnetResourceId: '<subnetResourceId>'
      }
    ]
    publicNetworkAccess: 'Disabled'
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
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    vmTemplate: {
      customImageId: '<customImageId>'
      domain: 'domainname.onmicrosoft.com'
      galleryImageOffer: 'office-365'
      galleryImagePublisher: 'microsoftwindowsdesktop'
      galleryImageSKU: '20h1-evd-o365pp'
      imageType: 'Gallery'
      imageUri: '<imageUri>'
      namePrefix: 'avdv2'
      osDiskType: 'StandardSSD_LRS'
      useManagedDisks: true
      vmSize: {
        cores: 2
        id: 'Standard_D2s_v3'
        ram: 8
      }
    }
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
      "value": "dvhpmax001"
    },
    // Non-required parameters
    "agentUpdate": {
      "value": {
        "maintenanceWindows": [
          {
            "dayOfWeek": "Friday",
            "hour": 7
          },
          {
            "dayOfWeek": "Saturday",
            "hour": 8
          }
        ],
        "maintenanceWindowTimeZone": "Alaskan Standard Time",
        "type": "Scheduled",
        "useSessionHostLocalTime": false
      }
    },
    "customRdpProperty": {
      "value": "audiocapturemode:i:1;audiomode:i:0;drivestoredirect:s:;redirectclipboard:i:1;redirectcomports:i:1;redirectprinters:i:1;redirectsmartcards:i:1;screen mode id:i:2;"
    },
    "description": {
      "value": "My first AVD Host Pool"
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "logCategoriesAndGroups": [
            {
              "categoryGroup": "allLogs"
            }
          ],
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "enableTelemetry": {
      "value": true
    },
    "friendlyName": {
      "value": "AVDv2"
    },
    "hostPoolType": {
      "value": "Pooled"
    },
    "loadBalancerType": {
      "value": "BreadthFirst"
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
    "maxSessionLimit": {
      "value": 99999
    },
    "personalDesktopAssignmentType": {
      "value": "Automatic"
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneResourceIds": [
            "<privateDNSZoneResourceId>"
          ],
          "subnetResourceId": "<subnetResourceId>"
        },
        {
          "privateDnsZoneResourceIds": [
            "<privateDNSZoneResourceId>"
          ],
          "subnetResourceId": "<subnetResourceId>"
        }
      ]
    },
    "publicNetworkAccess": {
      "value": "Disabled"
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
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "vmTemplate": {
      "value": {
        "customImageId": "<customImageId>",
        "domain": "domainname.onmicrosoft.com",
        "galleryImageOffer": "office-365",
        "galleryImagePublisher": "microsoftwindowsdesktop",
        "galleryImageSKU": "20h1-evd-o365pp",
        "imageType": "Gallery",
        "imageUri": "<imageUri>",
        "namePrefix": "avdv2",
        "osDiskType": "StandardSSD_LRS",
        "useManagedDisks": true,
        "vmSize": {
          "cores": 2,
          "id": "Standard_D2s_v3",
          "ram": 8
        }
      }
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
module hostPool 'br/public:avm/res/desktop-virtualization/host-pool:<version>' = {
  name: 'hostPoolDeployment'
  params: {
    // Required parameters
    name: 'dvhpwaf002'
    // Non-required parameters
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    location: '<location>'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
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
      "value": "dvhpwaf002"
    },
    // Non-required parameters
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "location": {
      "value": "<location>"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
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
| [`name`](#parameter-name) | string | Name of the scaling plan. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`agentUpdate`](#parameter-agentupdate) | object | The session host configuration for updating agent, monitoring agent, and stack component. |
| [`customRdpProperty`](#parameter-customrdpproperty) | string | Host Pool RDP properties. |
| [`description`](#parameter-description) | string | Description of the scaling plan. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`friendlyName`](#parameter-friendlyname) | string | Friendly name of the scaling plan. |
| [`hostPoolType`](#parameter-hostpooltype) | string | Set this parameter to Personal if you would like to enable Persistent Desktop experience. Defaults to Pooled. |
| [`loadBalancerType`](#parameter-loadbalancertype) | string | Type of load balancer algorithm. |
| [`location`](#parameter-location) | string | Location of the scaling plan. Defaults to resource group location. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`maxSessionLimit`](#parameter-maxsessionlimit) | int | Maximum number of sessions. |
| [`personalDesktopAssignmentType`](#parameter-personaldesktopassignmenttype) | string | Set the type of assignment for a Personal Host Pool type. |
| [`preferredAppGroupType`](#parameter-preferredappgrouptype) | string | The type of preferred application group type, default to Desktop Application Group. |
| [`privateEndpoints`](#parameter-privateendpoints) | array | Configuration details for private endpoints. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Set public network access. |
| [`ring`](#parameter-ring) | int | The ring number of HostPool. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`ssoadfsAuthority`](#parameter-ssoadfsauthority) | string | URL to customer ADFS server for signing WVD SSO certificates. |
| [`ssoClientId`](#parameter-ssoclientid) | string | ClientId for the registered Relying Party used to issue WVD SSO certificates. |
| [`ssoClientSecretKeyVaultPath`](#parameter-ssoclientsecretkeyvaultpath) | string | Path to Azure KeyVault storing the secret used for communication to ADFS. |
| [`ssoSecretType`](#parameter-ssosecrettype) | string | The type of single sign on Secret Type. |
| [`startVMOnConnect`](#parameter-startvmonconnect) | bool | Enable Start VM on connect to allow users to start the virtual machine from a deallocated state. Important: Custom RBAC role required to power manage VMs. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`tokenValidityLength`](#parameter-tokenvaliditylength) | string | Host Pool token validity length. Usage: 'PT8H' - valid for 8 hours; 'P5D' - valid for 5 days; 'P1Y' - valid for 1 year. When not provided, the token will be valid for 8 hours. |
| [`validationEnvironment`](#parameter-validationenvironment) | bool | Validation host pools allows you to test service changes before they are deployed to production. When set to true, the Host Pool will be deployed in a validation 'ring' (environment) that receives all the new features (might be less stable). Defaults to false that stands for the stable, production-ready environment. |
| [`vmTemplate`](#parameter-vmtemplate) | object | The necessary information for adding more VMs to this Host Pool. |

**Generated parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`baseTime`](#parameter-basetime) | string | Do not provide a value! This date value is used to generate a registration token. |

### Parameter: `name`

Name of the scaling plan.

- Required: Yes
- Type: string

### Parameter: `agentUpdate`

The session host configuration for updating agent, monitoring agent, and stack component.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      useSessionHostLocalTime: true
  }
  ```

### Parameter: `customRdpProperty`

Host Pool RDP properties.

- Required: No
- Type: string
- Default: `'audiocapturemode:i:1;audiomode:i:0;drivestoredirect:s:;redirectclipboard:i:1;redirectcomports:i:1;redirectprinters:i:1;redirectsmartcards:i:1;screen mode id:i:2;'`

### Parameter: `description`

Description of the scaling plan.

- Required: No
- Type: string
- Default: `''`

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

### Parameter: `friendlyName`

Friendly name of the scaling plan.

- Required: No
- Type: string
- Default: `''`

### Parameter: `hostPoolType`

Set this parameter to Personal if you would like to enable Persistent Desktop experience. Defaults to Pooled.

- Required: No
- Type: string
- Default: `'Pooled'`
- Allowed:
  ```Bicep
  [
    'Personal'
    'Pooled'
  ]
  ```

### Parameter: `loadBalancerType`

Type of load balancer algorithm.

- Required: No
- Type: string
- Default: `'BreadthFirst'`
- Allowed:
  ```Bicep
  [
    'BreadthFirst'
    'DepthFirst'
    'Persistent'
  ]
  ```

### Parameter: `location`

Location of the scaling plan. Defaults to resource group location.

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

### Parameter: `maxSessionLimit`

Maximum number of sessions.

- Required: No
- Type: int
- Default: `99999`

### Parameter: `personalDesktopAssignmentType`

Set the type of assignment for a Personal Host Pool type.

- Required: No
- Type: string
- Default: `''`
- Allowed:
  ```Bicep
  [
    ''
    'Automatic'
    'Direct'
  ]
  ```

### Parameter: `preferredAppGroupType`

The type of preferred application group type, default to Desktop Application Group.

- Required: No
- Type: string
- Default: `'Desktop'`
- Allowed:
  ```Bicep
  [
    'Desktop'
    'None'
    'RailApplications'
  ]
  ```

### Parameter: `privateEndpoints`

Configuration details for private endpoints.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
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
| [`privateDnsZoneGroupName`](#parameter-privateendpointsprivatednszonegroupname) | string | The name of the private DNS zone group to create if `privateDnsZoneResourceIds` were provided. |
| [`privateDnsZoneResourceIds`](#parameter-privateendpointsprivatednszoneresourceids) | array | The private DNS zone groups to associate the private endpoint with. A DNS zone group can support up to 5 DNS zones. |
| [`resourceGroupName`](#parameter-privateendpointsresourcegroupname) | string | Specify if you want to deploy the Private Endpoint into a different resource group than the main resource. |
| [`roleAssignments`](#parameter-privateendpointsroleassignments) | array | Array of role assignments to create. |
| [`service`](#parameter-privateendpointsservice) | string | The subresource to deploy the private endpoint for. For example "vault", "mysqlServer" or "dataFactory". |
| [`tags`](#parameter-privateendpointstags) | object | Tags to be applied on all resources/resource groups in this deployment. |

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
| [`fqdn`](#parameter-privateendpointscustomdnsconfigsfqdn) | string | Fqdn that resolves to private endpoint IP address. |
| [`ipAddresses`](#parameter-privateendpointscustomdnsconfigsipaddresses) | array | A list of private IP addresses of the private endpoint. |

### Parameter: `privateEndpoints.customDnsConfigs.fqdn`

Fqdn that resolves to private endpoint IP address.

- Required: No
- Type: string

### Parameter: `privateEndpoints.customDnsConfigs.ipAddresses`

A list of private IP addresses of the private endpoint.

- Required: Yes
- Type: array

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

### Parameter: `privateEndpoints.manualConnectionRequestMessage`

A message passed to the owner of the remote resource with the manual connection request.

- Required: No
- Type: string

### Parameter: `privateEndpoints.name`

The name of the private endpoint.

- Required: No
- Type: string

### Parameter: `privateEndpoints.privateDnsZoneGroupName`

The name of the private DNS zone group to create if `privateDnsZoneResourceIds` were provided.

- Required: No
- Type: string

### Parameter: `privateEndpoints.privateDnsZoneResourceIds`

The private DNS zone groups to associate the private endpoint with. A DNS zone group can support up to 5 DNS zones.

- Required: No
- Type: array

### Parameter: `privateEndpoints.resourceGroupName`

Specify if you want to deploy the Private Endpoint into a different resource group than the main resource.

- Required: No
- Type: string

### Parameter: `privateEndpoints.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

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

The subresource to deploy the private endpoint for. For example "vault", "mysqlServer" or "dataFactory".

- Required: No
- Type: string

### Parameter: `privateEndpoints.tags`

Tags to be applied on all resources/resource groups in this deployment.

- Required: No
- Type: object

### Parameter: `publicNetworkAccess`

Set public network access.

- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
    'EnabledForClientsOnly'
    'EnabledForSessionHostsOnly'
  ]
  ```

### Parameter: `ring`

The ring number of HostPool.

- Required: No
- Type: int
- Default: `-1`

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

### Parameter: `ssoadfsAuthority`

URL to customer ADFS server for signing WVD SSO certificates.

- Required: No
- Type: string
- Default: `''`

### Parameter: `ssoClientId`

ClientId for the registered Relying Party used to issue WVD SSO certificates.

- Required: No
- Type: string
- Default: `''`

### Parameter: `ssoClientSecretKeyVaultPath`

Path to Azure KeyVault storing the secret used for communication to ADFS.

- Required: No
- Type: string
- Default: `''`

### Parameter: `ssoSecretType`

The type of single sign on Secret Type.

- Required: No
- Type: string
- Default: `''`
- Allowed:
  ```Bicep
  [
    ''
    'Certificate'
    'CertificateInKeyVault'
    'SharedKey'
    'SharedKeyInKeyVault'
  ]
  ```

### Parameter: `startVMOnConnect`

Enable Start VM on connect to allow users to start the virtual machine from a deallocated state. Important: Custom RBAC role required to power manage VMs.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `tokenValidityLength`

Host Pool token validity length. Usage: 'PT8H' - valid for 8 hours; 'P5D' - valid for 5 days; 'P1Y' - valid for 1 year. When not provided, the token will be valid for 8 hours.

- Required: No
- Type: string
- Default: `'PT8H'`

### Parameter: `validationEnvironment`

Validation host pools allows you to test service changes before they are deployed to production. When set to true, the Host Pool will be deployed in a validation 'ring' (environment) that receives all the new features (might be less stable). Defaults to false that stands for the stable, production-ready environment.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `vmTemplate`

The necessary information for adding more VMs to this Host Pool.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `baseTime`

Do not provide a value! This date value is used to generate a registration token.

- Required: No
- Type: string
- Default: `[utcNow('u')]`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location of the host pool. |
| `name` | string | The name of the host pool. |
| `resourceGroupName` | string | The name of the resource group the host pool was created in. |
| `resourceId` | string | The resource ID of the host pool. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/network/private-endpoint:0.4.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
