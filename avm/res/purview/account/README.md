# Purview Accounts `[Microsoft.Purview/accounts]`

This module deploys a Purview Account.

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
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/privateEndpoints` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.Purview/accounts` | [2021-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Purview/2021-07-01/accounts) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/purview/account:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module account 'br/public:avm/res/purview/account:<version>' = {
  name: 'accountDeployment'
  params: {
    // Required parameters
    name: 'pvamin001'
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
      "value": "pvamin001"
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
module account 'br/public:avm/res/purview/account:<version>' = {
  name: 'accountDeployment'
  params: {
    // Required parameters
    name: 'pvamax001'
    // Non-required parameters
    accountPrivateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        service: 'account'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
    ]
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    eventHubPrivateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        service: 'namespace'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
    ]
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    managedResourceGroupName: 'pvamax001-managed-rg'
    portalPrivateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        service: 'portal'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        subnetResourceId: '<subnetResourceId>'
      }
    ]
    publicNetworkAccess: 'Disabled'
    roleAssignments: [
      {
        name: '8372742c-408e-4a8a-a748-aca787a0e33e'
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Owner'
      }
      {
        name: '<name>'
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
    storageBlobPrivateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        service: 'blob'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
    ]
    storageQueuePrivateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        service: 'queue'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        subnetResourceId: '<subnetResourceId>'
      }
    ]
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
      "value": "pvamax001"
    },
    // Non-required parameters
    "accountPrivateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDnsZoneGroupConfigs": [
              {
                "privateDnsZoneResourceId": "<privateDnsZoneResourceId>"
              }
            ]
          },
          "service": "account",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        }
      ]
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "metricCategories": [
            {
              "category": "AllMetrics"
            }
          ],
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "eventHubPrivateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDnsZoneGroupConfigs": [
              {
                "privateDnsZoneResourceId": "<privateDnsZoneResourceId>"
              }
            ]
          },
          "service": "namespace",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        }
      ]
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
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "managedResourceGroupName": {
      "value": "pvamax001-managed-rg"
    },
    "portalPrivateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDnsZoneGroupConfigs": [
              {
                "privateDnsZoneResourceId": "<privateDnsZoneResourceId>"
              }
            ]
          },
          "service": "portal",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        },
        {
          "privateDnsZoneGroup": {
            "privateDnsZoneGroupConfigs": [
              {
                "privateDnsZoneResourceId": "<privateDnsZoneResourceId>"
              }
            ]
          },
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
          "name": "8372742c-408e-4a8a-a748-aca787a0e33e",
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Owner"
        },
        {
          "name": "<name>",
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
    "storageBlobPrivateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDnsZoneGroupConfigs": [
              {
                "privateDnsZoneResourceId": "<privateDnsZoneResourceId>"
              }
            ]
          },
          "service": "blob",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        }
      ]
    },
    "storageQueuePrivateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDnsZoneGroupConfigs": [
              {
                "privateDnsZoneResourceId": "<privateDnsZoneResourceId>"
              }
            ]
          },
          "service": "queue",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        },
        {
          "privateDnsZoneGroup": {
            "privateDnsZoneGroupConfigs": [
              {
                "privateDnsZoneResourceId": "<privateDnsZoneResourceId>"
              }
            ]
          },
          "subnetResourceId": "<subnetResourceId>"
        }
      ]
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

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module account 'br/public:avm/res/purview/account:<version>' = {
  name: 'accountDeployment'
  params: {
    // Required parameters
    name: 'pvawaf001'
    // Non-required parameters
    accountPrivateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        service: 'account'
        subnetResourceId: '<subnetResourceId>'
      }
    ]
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    eventHubPrivateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        service: 'namespace'
        subnetResourceId: '<subnetResourceId>'
      }
    ]
    location: '<location>'
    managedResourceGroupName: 'pvawaf001-managed-rg'
    portalPrivateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        service: 'portal'
        subnetResourceId: '<subnetResourceId>'
      }
    ]
    publicNetworkAccess: 'Disabled'
    storageBlobPrivateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        service: 'blob'
        subnetResourceId: '<subnetResourceId>'
      }
    ]
    storageQueuePrivateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        service: 'queue'
        subnetResourceId: '<subnetResourceId>'
      }
    ]
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
      "value": "pvawaf001"
    },
    // Non-required parameters
    "accountPrivateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDnsZoneGroupConfigs": [
              {
                "privateDnsZoneResourceId": "<privateDnsZoneResourceId>"
              }
            ]
          },
          "service": "account",
          "subnetResourceId": "<subnetResourceId>"
        }
      ]
    },
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
    "eventHubPrivateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDnsZoneGroupConfigs": [
              {
                "privateDnsZoneResourceId": "<privateDnsZoneResourceId>"
              }
            ]
          },
          "service": "namespace",
          "subnetResourceId": "<subnetResourceId>"
        }
      ]
    },
    "location": {
      "value": "<location>"
    },
    "managedResourceGroupName": {
      "value": "pvawaf001-managed-rg"
    },
    "portalPrivateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDnsZoneGroupConfigs": [
              {
                "privateDnsZoneResourceId": "<privateDnsZoneResourceId>"
              }
            ]
          },
          "service": "portal",
          "subnetResourceId": "<subnetResourceId>"
        }
      ]
    },
    "publicNetworkAccess": {
      "value": "Disabled"
    },
    "storageBlobPrivateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDnsZoneGroupConfigs": [
              {
                "privateDnsZoneResourceId": "<privateDnsZoneResourceId>"
              }
            ]
          },
          "service": "blob",
          "subnetResourceId": "<subnetResourceId>"
        }
      ]
    },
    "storageQueuePrivateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDnsZoneGroupConfigs": [
              {
                "privateDnsZoneResourceId": "<privateDnsZoneResourceId>"
              }
            ]
          },
          "service": "queue",
          "subnetResourceId": "<subnetResourceId>"
        }
      ]
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
| [`name`](#parameter-name) | string | Name of the Purview Account. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`accountPrivateEndpoints`](#parameter-accountprivateendpoints) | array | Configuration details for Purview Account private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. Make sure the service property is set to 'account'. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`eventHubPrivateEndpoints`](#parameter-eventhubprivateendpoints) | array | Configuration details for Purview Managed Event Hub namespace private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. Make sure the service property is set to 'namespace'. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`managedResourceGroupName`](#parameter-managedresourcegroupname) | string | The Managed Resource Group Name. A managed Storage Account, and an Event Hubs will be created in the selected subscription for catalog ingestion scenarios. Default is 'managed-rg-<purview-account-name>'. |
| [`portalPrivateEndpoints`](#parameter-portalprivateendpoints) | array | Configuration details for Purview Portal private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. Make sure the service property is set to 'portal'. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`storageBlobPrivateEndpoints`](#parameter-storageblobprivateendpoints) | array | Configuration details for Purview Managed Storage Account blob private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. Make sure the service property is set to 'blob'. |
| [`storageQueuePrivateEndpoints`](#parameter-storagequeueprivateendpoints) | array | Configuration details for Purview Managed Storage Account queue private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. Make sure the service property is set to 'queue'. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `name`

Name of the Purview Account.

- Required: Yes
- Type: string

### Parameter: `accountPrivateEndpoints`

Configuration details for Purview Account private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. Make sure the service property is set to 'account'.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`subnetResourceId`](#parameter-accountprivateendpointssubnetresourceid) | string | Resource ID of the subnet where the endpoint needs to be created. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`applicationSecurityGroupResourceIds`](#parameter-accountprivateendpointsapplicationsecuritygroupresourceids) | array | Application security groups in which the private endpoint IP configuration is included. |
| [`customDnsConfigs`](#parameter-accountprivateendpointscustomdnsconfigs) | array | Custom DNS configurations. |
| [`customNetworkInterfaceName`](#parameter-accountprivateendpointscustomnetworkinterfacename) | string | The custom name of the network interface attached to the private endpoint. |
| [`enableTelemetry`](#parameter-accountprivateendpointsenabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`ipConfigurations`](#parameter-accountprivateendpointsipconfigurations) | array | A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints. |
| [`isManualConnection`](#parameter-accountprivateendpointsismanualconnection) | bool | If Manual Private Link Connection is required. |
| [`location`](#parameter-accountprivateendpointslocation) | string | The location to deploy the private endpoint to. |
| [`lock`](#parameter-accountprivateendpointslock) | object | Specify the type of lock. |
| [`manualConnectionRequestMessage`](#parameter-accountprivateendpointsmanualconnectionrequestmessage) | string | A message passed to the owner of the remote resource with the manual connection request. |
| [`name`](#parameter-accountprivateendpointsname) | string | The name of the private endpoint. |
| [`privateDnsZoneGroup`](#parameter-accountprivateendpointsprivatednszonegroup) | object | The private DNS zone group to configure for the private endpoint. |
| [`privateLinkServiceConnectionName`](#parameter-accountprivateendpointsprivatelinkserviceconnectionname) | string | The name of the private link connection to create. |
| [`resourceGroupName`](#parameter-accountprivateendpointsresourcegroupname) | string | Specify if you want to deploy the Private Endpoint into a different resource group than the main resource. |
| [`roleAssignments`](#parameter-accountprivateendpointsroleassignments) | array | Array of role assignments to create. |
| [`service`](#parameter-accountprivateendpointsservice) | string | The subresource to deploy the private endpoint for. For example "vault", "mysqlServer" or "dataFactory". |
| [`tags`](#parameter-accountprivateendpointstags) | object | Tags to be applied on all resources/resource groups in this deployment. |

### Parameter: `accountPrivateEndpoints.subnetResourceId`

Resource ID of the subnet where the endpoint needs to be created.

- Required: Yes
- Type: string

### Parameter: `accountPrivateEndpoints.applicationSecurityGroupResourceIds`

Application security groups in which the private endpoint IP configuration is included.

- Required: No
- Type: array

### Parameter: `accountPrivateEndpoints.customDnsConfigs`

Custom DNS configurations.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`fqdn`](#parameter-accountprivateendpointscustomdnsconfigsfqdn) | string | Fqdn that resolves to private endpoint IP address. |
| [`ipAddresses`](#parameter-accountprivateendpointscustomdnsconfigsipaddresses) | array | A list of private IP addresses of the private endpoint. |

### Parameter: `accountPrivateEndpoints.customDnsConfigs.fqdn`

Fqdn that resolves to private endpoint IP address.

- Required: No
- Type: string

### Parameter: `accountPrivateEndpoints.customDnsConfigs.ipAddresses`

A list of private IP addresses of the private endpoint.

- Required: Yes
- Type: array

### Parameter: `accountPrivateEndpoints.customNetworkInterfaceName`

The custom name of the network interface attached to the private endpoint.

- Required: No
- Type: string

### Parameter: `accountPrivateEndpoints.enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool

### Parameter: `accountPrivateEndpoints.ipConfigurations`

A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-accountprivateendpointsipconfigurationsname) | string | The name of the resource that is unique within a resource group. |
| [`properties`](#parameter-accountprivateendpointsipconfigurationsproperties) | object | Properties of private endpoint IP configurations. |

### Parameter: `accountPrivateEndpoints.ipConfigurations.name`

The name of the resource that is unique within a resource group.

- Required: Yes
- Type: string

### Parameter: `accountPrivateEndpoints.ipConfigurations.properties`

Properties of private endpoint IP configurations.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`groupId`](#parameter-accountprivateendpointsipconfigurationspropertiesgroupid) | string | The ID of a group obtained from the remote resource that this private endpoint should connect to. |
| [`memberName`](#parameter-accountprivateendpointsipconfigurationspropertiesmembername) | string | The member name of a group obtained from the remote resource that this private endpoint should connect to. |
| [`privateIPAddress`](#parameter-accountprivateendpointsipconfigurationspropertiesprivateipaddress) | string | A private IP address obtained from the private endpoint's subnet. |

### Parameter: `accountPrivateEndpoints.ipConfigurations.properties.groupId`

The ID of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: string

### Parameter: `accountPrivateEndpoints.ipConfigurations.properties.memberName`

The member name of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: string

### Parameter: `accountPrivateEndpoints.ipConfigurations.properties.privateIPAddress`

A private IP address obtained from the private endpoint's subnet.

- Required: Yes
- Type: string

### Parameter: `accountPrivateEndpoints.isManualConnection`

If Manual Private Link Connection is required.

- Required: No
- Type: bool

### Parameter: `accountPrivateEndpoints.location`

The location to deploy the private endpoint to.

- Required: No
- Type: string

### Parameter: `accountPrivateEndpoints.lock`

Specify the type of lock.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-accountprivateendpointslockkind) | string | Specify the type of lock. |
| [`name`](#parameter-accountprivateendpointslockname) | string | Specify the name of lock. |

### Parameter: `accountPrivateEndpoints.lock.kind`

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

### Parameter: `accountPrivateEndpoints.lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `accountPrivateEndpoints.manualConnectionRequestMessage`

A message passed to the owner of the remote resource with the manual connection request.

- Required: No
- Type: string

### Parameter: `accountPrivateEndpoints.name`

The name of the private endpoint.

- Required: No
- Type: string

### Parameter: `accountPrivateEndpoints.privateDnsZoneGroup`

The private DNS zone group to configure for the private endpoint.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateDnsZoneGroupConfigs`](#parameter-accountprivateendpointsprivatednszonegroupprivatednszonegroupconfigs) | array | The private DNS zone groups to associate the private endpoint. A DNS zone group can support up to 5 DNS zones. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-accountprivateendpointsprivatednszonegroupname) | string | The name of the Private DNS Zone Group. |

### Parameter: `accountPrivateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs`

The private DNS zone groups to associate the private endpoint. A DNS zone group can support up to 5 DNS zones.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateDnsZoneResourceId`](#parameter-accountprivateendpointsprivatednszonegroupprivatednszonegroupconfigsprivatednszoneresourceid) | string | The resource id of the private DNS zone. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-accountprivateendpointsprivatednszonegroupprivatednszonegroupconfigsname) | string | The name of the private DNS zone group config. |

### Parameter: `accountPrivateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs.privateDnsZoneResourceId`

The resource id of the private DNS zone.

- Required: Yes
- Type: string

### Parameter: `accountPrivateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs.name`

The name of the private DNS zone group config.

- Required: No
- Type: string

### Parameter: `accountPrivateEndpoints.privateDnsZoneGroup.name`

The name of the Private DNS Zone Group.

- Required: No
- Type: string

### Parameter: `accountPrivateEndpoints.privateLinkServiceConnectionName`

The name of the private link connection to create.

- Required: No
- Type: string

### Parameter: `accountPrivateEndpoints.resourceGroupName`

Specify if you want to deploy the Private Endpoint into a different resource group than the main resource.

- Required: No
- Type: string

### Parameter: `accountPrivateEndpoints.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-accountprivateendpointsroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-accountprivateendpointsroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-accountprivateendpointsroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-accountprivateendpointsroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-accountprivateendpointsroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-accountprivateendpointsroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-accountprivateendpointsroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-accountprivateendpointsroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `accountPrivateEndpoints.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `accountPrivateEndpoints.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `accountPrivateEndpoints.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `accountPrivateEndpoints.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `accountPrivateEndpoints.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `accountPrivateEndpoints.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `accountPrivateEndpoints.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `accountPrivateEndpoints.roleAssignments.principalType`

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

### Parameter: `accountPrivateEndpoints.service`

The subresource to deploy the private endpoint for. For example "vault", "mysqlServer" or "dataFactory".

- Required: No
- Type: string

### Parameter: `accountPrivateEndpoints.tags`

Tags to be applied on all resources/resource groups in this deployment.

- Required: No
- Type: object

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

### Parameter: `eventHubPrivateEndpoints`

Configuration details for Purview Managed Event Hub namespace private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. Make sure the service property is set to 'namespace'.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`subnetResourceId`](#parameter-eventhubprivateendpointssubnetresourceid) | string | Resource ID of the subnet where the endpoint needs to be created. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`applicationSecurityGroupResourceIds`](#parameter-eventhubprivateendpointsapplicationsecuritygroupresourceids) | array | Application security groups in which the private endpoint IP configuration is included. |
| [`customDnsConfigs`](#parameter-eventhubprivateendpointscustomdnsconfigs) | array | Custom DNS configurations. |
| [`customNetworkInterfaceName`](#parameter-eventhubprivateendpointscustomnetworkinterfacename) | string | The custom name of the network interface attached to the private endpoint. |
| [`enableTelemetry`](#parameter-eventhubprivateendpointsenabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`ipConfigurations`](#parameter-eventhubprivateendpointsipconfigurations) | array | A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints. |
| [`isManualConnection`](#parameter-eventhubprivateendpointsismanualconnection) | bool | If Manual Private Link Connection is required. |
| [`location`](#parameter-eventhubprivateendpointslocation) | string | The location to deploy the private endpoint to. |
| [`lock`](#parameter-eventhubprivateendpointslock) | object | Specify the type of lock. |
| [`manualConnectionRequestMessage`](#parameter-eventhubprivateendpointsmanualconnectionrequestmessage) | string | A message passed to the owner of the remote resource with the manual connection request. |
| [`name`](#parameter-eventhubprivateendpointsname) | string | The name of the private endpoint. |
| [`privateDnsZoneGroup`](#parameter-eventhubprivateendpointsprivatednszonegroup) | object | The private DNS zone group to configure for the private endpoint. |
| [`privateLinkServiceConnectionName`](#parameter-eventhubprivateendpointsprivatelinkserviceconnectionname) | string | The name of the private link connection to create. |
| [`resourceGroupName`](#parameter-eventhubprivateendpointsresourcegroupname) | string | Specify if you want to deploy the Private Endpoint into a different resource group than the main resource. |
| [`roleAssignments`](#parameter-eventhubprivateendpointsroleassignments) | array | Array of role assignments to create. |
| [`service`](#parameter-eventhubprivateendpointsservice) | string | The subresource to deploy the private endpoint for. For example "vault", "mysqlServer" or "dataFactory". |
| [`tags`](#parameter-eventhubprivateendpointstags) | object | Tags to be applied on all resources/resource groups in this deployment. |

### Parameter: `eventHubPrivateEndpoints.subnetResourceId`

Resource ID of the subnet where the endpoint needs to be created.

- Required: Yes
- Type: string

### Parameter: `eventHubPrivateEndpoints.applicationSecurityGroupResourceIds`

Application security groups in which the private endpoint IP configuration is included.

- Required: No
- Type: array

### Parameter: `eventHubPrivateEndpoints.customDnsConfigs`

Custom DNS configurations.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`fqdn`](#parameter-eventhubprivateendpointscustomdnsconfigsfqdn) | string | Fqdn that resolves to private endpoint IP address. |
| [`ipAddresses`](#parameter-eventhubprivateendpointscustomdnsconfigsipaddresses) | array | A list of private IP addresses of the private endpoint. |

### Parameter: `eventHubPrivateEndpoints.customDnsConfigs.fqdn`

Fqdn that resolves to private endpoint IP address.

- Required: No
- Type: string

### Parameter: `eventHubPrivateEndpoints.customDnsConfigs.ipAddresses`

A list of private IP addresses of the private endpoint.

- Required: Yes
- Type: array

### Parameter: `eventHubPrivateEndpoints.customNetworkInterfaceName`

The custom name of the network interface attached to the private endpoint.

- Required: No
- Type: string

### Parameter: `eventHubPrivateEndpoints.enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool

### Parameter: `eventHubPrivateEndpoints.ipConfigurations`

A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-eventhubprivateendpointsipconfigurationsname) | string | The name of the resource that is unique within a resource group. |
| [`properties`](#parameter-eventhubprivateendpointsipconfigurationsproperties) | object | Properties of private endpoint IP configurations. |

### Parameter: `eventHubPrivateEndpoints.ipConfigurations.name`

The name of the resource that is unique within a resource group.

- Required: Yes
- Type: string

### Parameter: `eventHubPrivateEndpoints.ipConfigurations.properties`

Properties of private endpoint IP configurations.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`groupId`](#parameter-eventhubprivateendpointsipconfigurationspropertiesgroupid) | string | The ID of a group obtained from the remote resource that this private endpoint should connect to. |
| [`memberName`](#parameter-eventhubprivateendpointsipconfigurationspropertiesmembername) | string | The member name of a group obtained from the remote resource that this private endpoint should connect to. |
| [`privateIPAddress`](#parameter-eventhubprivateendpointsipconfigurationspropertiesprivateipaddress) | string | A private IP address obtained from the private endpoint's subnet. |

### Parameter: `eventHubPrivateEndpoints.ipConfigurations.properties.groupId`

The ID of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: string

### Parameter: `eventHubPrivateEndpoints.ipConfigurations.properties.memberName`

The member name of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: string

### Parameter: `eventHubPrivateEndpoints.ipConfigurations.properties.privateIPAddress`

A private IP address obtained from the private endpoint's subnet.

- Required: Yes
- Type: string

### Parameter: `eventHubPrivateEndpoints.isManualConnection`

If Manual Private Link Connection is required.

- Required: No
- Type: bool

### Parameter: `eventHubPrivateEndpoints.location`

The location to deploy the private endpoint to.

- Required: No
- Type: string

### Parameter: `eventHubPrivateEndpoints.lock`

Specify the type of lock.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-eventhubprivateendpointslockkind) | string | Specify the type of lock. |
| [`name`](#parameter-eventhubprivateendpointslockname) | string | Specify the name of lock. |

### Parameter: `eventHubPrivateEndpoints.lock.kind`

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

### Parameter: `eventHubPrivateEndpoints.lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `eventHubPrivateEndpoints.manualConnectionRequestMessage`

A message passed to the owner of the remote resource with the manual connection request.

- Required: No
- Type: string

### Parameter: `eventHubPrivateEndpoints.name`

The name of the private endpoint.

- Required: No
- Type: string

### Parameter: `eventHubPrivateEndpoints.privateDnsZoneGroup`

The private DNS zone group to configure for the private endpoint.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateDnsZoneGroupConfigs`](#parameter-eventhubprivateendpointsprivatednszonegroupprivatednszonegroupconfigs) | array | The private DNS zone groups to associate the private endpoint. A DNS zone group can support up to 5 DNS zones. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-eventhubprivateendpointsprivatednszonegroupname) | string | The name of the Private DNS Zone Group. |

### Parameter: `eventHubPrivateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs`

The private DNS zone groups to associate the private endpoint. A DNS zone group can support up to 5 DNS zones.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateDnsZoneResourceId`](#parameter-eventhubprivateendpointsprivatednszonegroupprivatednszonegroupconfigsprivatednszoneresourceid) | string | The resource id of the private DNS zone. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-eventhubprivateendpointsprivatednszonegroupprivatednszonegroupconfigsname) | string | The name of the private DNS zone group config. |

### Parameter: `eventHubPrivateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs.privateDnsZoneResourceId`

The resource id of the private DNS zone.

- Required: Yes
- Type: string

### Parameter: `eventHubPrivateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs.name`

The name of the private DNS zone group config.

- Required: No
- Type: string

### Parameter: `eventHubPrivateEndpoints.privateDnsZoneGroup.name`

The name of the Private DNS Zone Group.

- Required: No
- Type: string

### Parameter: `eventHubPrivateEndpoints.privateLinkServiceConnectionName`

The name of the private link connection to create.

- Required: No
- Type: string

### Parameter: `eventHubPrivateEndpoints.resourceGroupName`

Specify if you want to deploy the Private Endpoint into a different resource group than the main resource.

- Required: No
- Type: string

### Parameter: `eventHubPrivateEndpoints.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-eventhubprivateendpointsroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-eventhubprivateendpointsroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-eventhubprivateendpointsroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-eventhubprivateendpointsroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-eventhubprivateendpointsroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-eventhubprivateendpointsroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-eventhubprivateendpointsroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-eventhubprivateendpointsroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `eventHubPrivateEndpoints.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `eventHubPrivateEndpoints.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `eventHubPrivateEndpoints.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `eventHubPrivateEndpoints.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `eventHubPrivateEndpoints.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `eventHubPrivateEndpoints.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `eventHubPrivateEndpoints.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `eventHubPrivateEndpoints.roleAssignments.principalType`

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

### Parameter: `eventHubPrivateEndpoints.service`

The subresource to deploy the private endpoint for. For example "vault", "mysqlServer" or "dataFactory".

- Required: No
- Type: string

### Parameter: `eventHubPrivateEndpoints.tags`

Tags to be applied on all resources/resource groups in this deployment.

- Required: No
- Type: object

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
| [`userAssignedResourceIds`](#parameter-managedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. |

### Parameter: `managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource.

- Required: Yes
- Type: array

### Parameter: `managedResourceGroupName`

The Managed Resource Group Name. A managed Storage Account, and an Event Hubs will be created in the selected subscription for catalog ingestion scenarios. Default is 'managed-rg-<purview-account-name>'.

- Required: No
- Type: string
- Default: `[format('managed-rg-{0}', parameters('name'))]`

### Parameter: `portalPrivateEndpoints`

Configuration details for Purview Portal private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. Make sure the service property is set to 'portal'.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`subnetResourceId`](#parameter-portalprivateendpointssubnetresourceid) | string | Resource ID of the subnet where the endpoint needs to be created. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`applicationSecurityGroupResourceIds`](#parameter-portalprivateendpointsapplicationsecuritygroupresourceids) | array | Application security groups in which the private endpoint IP configuration is included. |
| [`customDnsConfigs`](#parameter-portalprivateendpointscustomdnsconfigs) | array | Custom DNS configurations. |
| [`customNetworkInterfaceName`](#parameter-portalprivateendpointscustomnetworkinterfacename) | string | The custom name of the network interface attached to the private endpoint. |
| [`enableTelemetry`](#parameter-portalprivateendpointsenabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`ipConfigurations`](#parameter-portalprivateendpointsipconfigurations) | array | A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints. |
| [`isManualConnection`](#parameter-portalprivateendpointsismanualconnection) | bool | If Manual Private Link Connection is required. |
| [`location`](#parameter-portalprivateendpointslocation) | string | The location to deploy the private endpoint to. |
| [`lock`](#parameter-portalprivateendpointslock) | object | Specify the type of lock. |
| [`manualConnectionRequestMessage`](#parameter-portalprivateendpointsmanualconnectionrequestmessage) | string | A message passed to the owner of the remote resource with the manual connection request. |
| [`name`](#parameter-portalprivateendpointsname) | string | The name of the private endpoint. |
| [`privateDnsZoneGroup`](#parameter-portalprivateendpointsprivatednszonegroup) | object | The private DNS zone group to configure for the private endpoint. |
| [`privateLinkServiceConnectionName`](#parameter-portalprivateendpointsprivatelinkserviceconnectionname) | string | The name of the private link connection to create. |
| [`resourceGroupName`](#parameter-portalprivateendpointsresourcegroupname) | string | Specify if you want to deploy the Private Endpoint into a different resource group than the main resource. |
| [`roleAssignments`](#parameter-portalprivateendpointsroleassignments) | array | Array of role assignments to create. |
| [`service`](#parameter-portalprivateendpointsservice) | string | The subresource to deploy the private endpoint for. For example "vault", "mysqlServer" or "dataFactory". |
| [`tags`](#parameter-portalprivateendpointstags) | object | Tags to be applied on all resources/resource groups in this deployment. |

### Parameter: `portalPrivateEndpoints.subnetResourceId`

Resource ID of the subnet where the endpoint needs to be created.

- Required: Yes
- Type: string

### Parameter: `portalPrivateEndpoints.applicationSecurityGroupResourceIds`

Application security groups in which the private endpoint IP configuration is included.

- Required: No
- Type: array

### Parameter: `portalPrivateEndpoints.customDnsConfigs`

Custom DNS configurations.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`fqdn`](#parameter-portalprivateendpointscustomdnsconfigsfqdn) | string | Fqdn that resolves to private endpoint IP address. |
| [`ipAddresses`](#parameter-portalprivateendpointscustomdnsconfigsipaddresses) | array | A list of private IP addresses of the private endpoint. |

### Parameter: `portalPrivateEndpoints.customDnsConfigs.fqdn`

Fqdn that resolves to private endpoint IP address.

- Required: No
- Type: string

### Parameter: `portalPrivateEndpoints.customDnsConfigs.ipAddresses`

A list of private IP addresses of the private endpoint.

- Required: Yes
- Type: array

### Parameter: `portalPrivateEndpoints.customNetworkInterfaceName`

The custom name of the network interface attached to the private endpoint.

- Required: No
- Type: string

### Parameter: `portalPrivateEndpoints.enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool

### Parameter: `portalPrivateEndpoints.ipConfigurations`

A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-portalprivateendpointsipconfigurationsname) | string | The name of the resource that is unique within a resource group. |
| [`properties`](#parameter-portalprivateendpointsipconfigurationsproperties) | object | Properties of private endpoint IP configurations. |

### Parameter: `portalPrivateEndpoints.ipConfigurations.name`

The name of the resource that is unique within a resource group.

- Required: Yes
- Type: string

### Parameter: `portalPrivateEndpoints.ipConfigurations.properties`

Properties of private endpoint IP configurations.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`groupId`](#parameter-portalprivateendpointsipconfigurationspropertiesgroupid) | string | The ID of a group obtained from the remote resource that this private endpoint should connect to. |
| [`memberName`](#parameter-portalprivateendpointsipconfigurationspropertiesmembername) | string | The member name of a group obtained from the remote resource that this private endpoint should connect to. |
| [`privateIPAddress`](#parameter-portalprivateendpointsipconfigurationspropertiesprivateipaddress) | string | A private IP address obtained from the private endpoint's subnet. |

### Parameter: `portalPrivateEndpoints.ipConfigurations.properties.groupId`

The ID of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: string

### Parameter: `portalPrivateEndpoints.ipConfigurations.properties.memberName`

The member name of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: string

### Parameter: `portalPrivateEndpoints.ipConfigurations.properties.privateIPAddress`

A private IP address obtained from the private endpoint's subnet.

- Required: Yes
- Type: string

### Parameter: `portalPrivateEndpoints.isManualConnection`

If Manual Private Link Connection is required.

- Required: No
- Type: bool

### Parameter: `portalPrivateEndpoints.location`

The location to deploy the private endpoint to.

- Required: No
- Type: string

### Parameter: `portalPrivateEndpoints.lock`

Specify the type of lock.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-portalprivateendpointslockkind) | string | Specify the type of lock. |
| [`name`](#parameter-portalprivateendpointslockname) | string | Specify the name of lock. |

### Parameter: `portalPrivateEndpoints.lock.kind`

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

### Parameter: `portalPrivateEndpoints.lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `portalPrivateEndpoints.manualConnectionRequestMessage`

A message passed to the owner of the remote resource with the manual connection request.

- Required: No
- Type: string

### Parameter: `portalPrivateEndpoints.name`

The name of the private endpoint.

- Required: No
- Type: string

### Parameter: `portalPrivateEndpoints.privateDnsZoneGroup`

The private DNS zone group to configure for the private endpoint.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateDnsZoneGroupConfigs`](#parameter-portalprivateendpointsprivatednszonegroupprivatednszonegroupconfigs) | array | The private DNS zone groups to associate the private endpoint. A DNS zone group can support up to 5 DNS zones. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-portalprivateendpointsprivatednszonegroupname) | string | The name of the Private DNS Zone Group. |

### Parameter: `portalPrivateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs`

The private DNS zone groups to associate the private endpoint. A DNS zone group can support up to 5 DNS zones.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateDnsZoneResourceId`](#parameter-portalprivateendpointsprivatednszonegroupprivatednszonegroupconfigsprivatednszoneresourceid) | string | The resource id of the private DNS zone. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-portalprivateendpointsprivatednszonegroupprivatednszonegroupconfigsname) | string | The name of the private DNS zone group config. |

### Parameter: `portalPrivateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs.privateDnsZoneResourceId`

The resource id of the private DNS zone.

- Required: Yes
- Type: string

### Parameter: `portalPrivateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs.name`

The name of the private DNS zone group config.

- Required: No
- Type: string

### Parameter: `portalPrivateEndpoints.privateDnsZoneGroup.name`

The name of the Private DNS Zone Group.

- Required: No
- Type: string

### Parameter: `portalPrivateEndpoints.privateLinkServiceConnectionName`

The name of the private link connection to create.

- Required: No
- Type: string

### Parameter: `portalPrivateEndpoints.resourceGroupName`

Specify if you want to deploy the Private Endpoint into a different resource group than the main resource.

- Required: No
- Type: string

### Parameter: `portalPrivateEndpoints.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-portalprivateendpointsroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-portalprivateendpointsroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-portalprivateendpointsroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-portalprivateendpointsroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-portalprivateendpointsroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-portalprivateendpointsroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-portalprivateendpointsroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-portalprivateendpointsroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `portalPrivateEndpoints.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `portalPrivateEndpoints.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `portalPrivateEndpoints.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `portalPrivateEndpoints.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `portalPrivateEndpoints.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `portalPrivateEndpoints.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `portalPrivateEndpoints.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `portalPrivateEndpoints.roleAssignments.principalType`

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

### Parameter: `portalPrivateEndpoints.service`

The subresource to deploy the private endpoint for. For example "vault", "mysqlServer" or "dataFactory".

- Required: No
- Type: string

### Parameter: `portalPrivateEndpoints.tags`

Tags to be applied on all resources/resource groups in this deployment.

- Required: No
- Type: object

### Parameter: `publicNetworkAccess`

Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set.

- Required: No
- Type: string
- Default: `'NotSpecified'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
    'NotSpecified'
  ]
  ```

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
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

### Parameter: `storageBlobPrivateEndpoints`

Configuration details for Purview Managed Storage Account blob private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. Make sure the service property is set to 'blob'.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`subnetResourceId`](#parameter-storageblobprivateendpointssubnetresourceid) | string | Resource ID of the subnet where the endpoint needs to be created. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`applicationSecurityGroupResourceIds`](#parameter-storageblobprivateendpointsapplicationsecuritygroupresourceids) | array | Application security groups in which the private endpoint IP configuration is included. |
| [`customDnsConfigs`](#parameter-storageblobprivateendpointscustomdnsconfigs) | array | Custom DNS configurations. |
| [`customNetworkInterfaceName`](#parameter-storageblobprivateendpointscustomnetworkinterfacename) | string | The custom name of the network interface attached to the private endpoint. |
| [`enableTelemetry`](#parameter-storageblobprivateendpointsenabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`ipConfigurations`](#parameter-storageblobprivateendpointsipconfigurations) | array | A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints. |
| [`isManualConnection`](#parameter-storageblobprivateendpointsismanualconnection) | bool | If Manual Private Link Connection is required. |
| [`location`](#parameter-storageblobprivateendpointslocation) | string | The location to deploy the private endpoint to. |
| [`lock`](#parameter-storageblobprivateendpointslock) | object | Specify the type of lock. |
| [`manualConnectionRequestMessage`](#parameter-storageblobprivateendpointsmanualconnectionrequestmessage) | string | A message passed to the owner of the remote resource with the manual connection request. |
| [`name`](#parameter-storageblobprivateendpointsname) | string | The name of the private endpoint. |
| [`privateDnsZoneGroup`](#parameter-storageblobprivateendpointsprivatednszonegroup) | object | The private DNS zone group to configure for the private endpoint. |
| [`privateLinkServiceConnectionName`](#parameter-storageblobprivateendpointsprivatelinkserviceconnectionname) | string | The name of the private link connection to create. |
| [`resourceGroupName`](#parameter-storageblobprivateendpointsresourcegroupname) | string | Specify if you want to deploy the Private Endpoint into a different resource group than the main resource. |
| [`roleAssignments`](#parameter-storageblobprivateendpointsroleassignments) | array | Array of role assignments to create. |
| [`service`](#parameter-storageblobprivateendpointsservice) | string | The subresource to deploy the private endpoint for. For example "vault", "mysqlServer" or "dataFactory". |
| [`tags`](#parameter-storageblobprivateendpointstags) | object | Tags to be applied on all resources/resource groups in this deployment. |

### Parameter: `storageBlobPrivateEndpoints.subnetResourceId`

Resource ID of the subnet where the endpoint needs to be created.

- Required: Yes
- Type: string

### Parameter: `storageBlobPrivateEndpoints.applicationSecurityGroupResourceIds`

Application security groups in which the private endpoint IP configuration is included.

- Required: No
- Type: array

### Parameter: `storageBlobPrivateEndpoints.customDnsConfigs`

Custom DNS configurations.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`fqdn`](#parameter-storageblobprivateendpointscustomdnsconfigsfqdn) | string | Fqdn that resolves to private endpoint IP address. |
| [`ipAddresses`](#parameter-storageblobprivateendpointscustomdnsconfigsipaddresses) | array | A list of private IP addresses of the private endpoint. |

### Parameter: `storageBlobPrivateEndpoints.customDnsConfigs.fqdn`

Fqdn that resolves to private endpoint IP address.

- Required: No
- Type: string

### Parameter: `storageBlobPrivateEndpoints.customDnsConfigs.ipAddresses`

A list of private IP addresses of the private endpoint.

- Required: Yes
- Type: array

### Parameter: `storageBlobPrivateEndpoints.customNetworkInterfaceName`

The custom name of the network interface attached to the private endpoint.

- Required: No
- Type: string

### Parameter: `storageBlobPrivateEndpoints.enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool

### Parameter: `storageBlobPrivateEndpoints.ipConfigurations`

A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-storageblobprivateendpointsipconfigurationsname) | string | The name of the resource that is unique within a resource group. |
| [`properties`](#parameter-storageblobprivateendpointsipconfigurationsproperties) | object | Properties of private endpoint IP configurations. |

### Parameter: `storageBlobPrivateEndpoints.ipConfigurations.name`

The name of the resource that is unique within a resource group.

- Required: Yes
- Type: string

### Parameter: `storageBlobPrivateEndpoints.ipConfigurations.properties`

Properties of private endpoint IP configurations.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`groupId`](#parameter-storageblobprivateendpointsipconfigurationspropertiesgroupid) | string | The ID of a group obtained from the remote resource that this private endpoint should connect to. |
| [`memberName`](#parameter-storageblobprivateendpointsipconfigurationspropertiesmembername) | string | The member name of a group obtained from the remote resource that this private endpoint should connect to. |
| [`privateIPAddress`](#parameter-storageblobprivateendpointsipconfigurationspropertiesprivateipaddress) | string | A private IP address obtained from the private endpoint's subnet. |

### Parameter: `storageBlobPrivateEndpoints.ipConfigurations.properties.groupId`

The ID of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: string

### Parameter: `storageBlobPrivateEndpoints.ipConfigurations.properties.memberName`

The member name of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: string

### Parameter: `storageBlobPrivateEndpoints.ipConfigurations.properties.privateIPAddress`

A private IP address obtained from the private endpoint's subnet.

- Required: Yes
- Type: string

### Parameter: `storageBlobPrivateEndpoints.isManualConnection`

If Manual Private Link Connection is required.

- Required: No
- Type: bool

### Parameter: `storageBlobPrivateEndpoints.location`

The location to deploy the private endpoint to.

- Required: No
- Type: string

### Parameter: `storageBlobPrivateEndpoints.lock`

Specify the type of lock.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-storageblobprivateendpointslockkind) | string | Specify the type of lock. |
| [`name`](#parameter-storageblobprivateendpointslockname) | string | Specify the name of lock. |

### Parameter: `storageBlobPrivateEndpoints.lock.kind`

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

### Parameter: `storageBlobPrivateEndpoints.lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `storageBlobPrivateEndpoints.manualConnectionRequestMessage`

A message passed to the owner of the remote resource with the manual connection request.

- Required: No
- Type: string

### Parameter: `storageBlobPrivateEndpoints.name`

The name of the private endpoint.

- Required: No
- Type: string

### Parameter: `storageBlobPrivateEndpoints.privateDnsZoneGroup`

The private DNS zone group to configure for the private endpoint.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateDnsZoneGroupConfigs`](#parameter-storageblobprivateendpointsprivatednszonegroupprivatednszonegroupconfigs) | array | The private DNS zone groups to associate the private endpoint. A DNS zone group can support up to 5 DNS zones. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-storageblobprivateendpointsprivatednszonegroupname) | string | The name of the Private DNS Zone Group. |

### Parameter: `storageBlobPrivateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs`

The private DNS zone groups to associate the private endpoint. A DNS zone group can support up to 5 DNS zones.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateDnsZoneResourceId`](#parameter-storageblobprivateendpointsprivatednszonegroupprivatednszonegroupconfigsprivatednszoneresourceid) | string | The resource id of the private DNS zone. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-storageblobprivateendpointsprivatednszonegroupprivatednszonegroupconfigsname) | string | The name of the private DNS zone group config. |

### Parameter: `storageBlobPrivateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs.privateDnsZoneResourceId`

The resource id of the private DNS zone.

- Required: Yes
- Type: string

### Parameter: `storageBlobPrivateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs.name`

The name of the private DNS zone group config.

- Required: No
- Type: string

### Parameter: `storageBlobPrivateEndpoints.privateDnsZoneGroup.name`

The name of the Private DNS Zone Group.

- Required: No
- Type: string

### Parameter: `storageBlobPrivateEndpoints.privateLinkServiceConnectionName`

The name of the private link connection to create.

- Required: No
- Type: string

### Parameter: `storageBlobPrivateEndpoints.resourceGroupName`

Specify if you want to deploy the Private Endpoint into a different resource group than the main resource.

- Required: No
- Type: string

### Parameter: `storageBlobPrivateEndpoints.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-storageblobprivateendpointsroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-storageblobprivateendpointsroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-storageblobprivateendpointsroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-storageblobprivateendpointsroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-storageblobprivateendpointsroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-storageblobprivateendpointsroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-storageblobprivateendpointsroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-storageblobprivateendpointsroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `storageBlobPrivateEndpoints.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `storageBlobPrivateEndpoints.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `storageBlobPrivateEndpoints.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `storageBlobPrivateEndpoints.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `storageBlobPrivateEndpoints.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `storageBlobPrivateEndpoints.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `storageBlobPrivateEndpoints.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `storageBlobPrivateEndpoints.roleAssignments.principalType`

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

### Parameter: `storageBlobPrivateEndpoints.service`

The subresource to deploy the private endpoint for. For example "vault", "mysqlServer" or "dataFactory".

- Required: No
- Type: string

### Parameter: `storageBlobPrivateEndpoints.tags`

Tags to be applied on all resources/resource groups in this deployment.

- Required: No
- Type: object

### Parameter: `storageQueuePrivateEndpoints`

Configuration details for Purview Managed Storage Account queue private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. Make sure the service property is set to 'queue'.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`subnetResourceId`](#parameter-storagequeueprivateendpointssubnetresourceid) | string | Resource ID of the subnet where the endpoint needs to be created. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`applicationSecurityGroupResourceIds`](#parameter-storagequeueprivateendpointsapplicationsecuritygroupresourceids) | array | Application security groups in which the private endpoint IP configuration is included. |
| [`customDnsConfigs`](#parameter-storagequeueprivateendpointscustomdnsconfigs) | array | Custom DNS configurations. |
| [`customNetworkInterfaceName`](#parameter-storagequeueprivateendpointscustomnetworkinterfacename) | string | The custom name of the network interface attached to the private endpoint. |
| [`enableTelemetry`](#parameter-storagequeueprivateendpointsenabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`ipConfigurations`](#parameter-storagequeueprivateendpointsipconfigurations) | array | A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints. |
| [`isManualConnection`](#parameter-storagequeueprivateendpointsismanualconnection) | bool | If Manual Private Link Connection is required. |
| [`location`](#parameter-storagequeueprivateendpointslocation) | string | The location to deploy the private endpoint to. |
| [`lock`](#parameter-storagequeueprivateendpointslock) | object | Specify the type of lock. |
| [`manualConnectionRequestMessage`](#parameter-storagequeueprivateendpointsmanualconnectionrequestmessage) | string | A message passed to the owner of the remote resource with the manual connection request. |
| [`name`](#parameter-storagequeueprivateendpointsname) | string | The name of the private endpoint. |
| [`privateDnsZoneGroup`](#parameter-storagequeueprivateendpointsprivatednszonegroup) | object | The private DNS zone group to configure for the private endpoint. |
| [`privateLinkServiceConnectionName`](#parameter-storagequeueprivateendpointsprivatelinkserviceconnectionname) | string | The name of the private link connection to create. |
| [`resourceGroupName`](#parameter-storagequeueprivateendpointsresourcegroupname) | string | Specify if you want to deploy the Private Endpoint into a different resource group than the main resource. |
| [`roleAssignments`](#parameter-storagequeueprivateendpointsroleassignments) | array | Array of role assignments to create. |
| [`service`](#parameter-storagequeueprivateendpointsservice) | string | The subresource to deploy the private endpoint for. For example "vault", "mysqlServer" or "dataFactory". |
| [`tags`](#parameter-storagequeueprivateendpointstags) | object | Tags to be applied on all resources/resource groups in this deployment. |

### Parameter: `storageQueuePrivateEndpoints.subnetResourceId`

Resource ID of the subnet where the endpoint needs to be created.

- Required: Yes
- Type: string

### Parameter: `storageQueuePrivateEndpoints.applicationSecurityGroupResourceIds`

Application security groups in which the private endpoint IP configuration is included.

- Required: No
- Type: array

### Parameter: `storageQueuePrivateEndpoints.customDnsConfigs`

Custom DNS configurations.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`fqdn`](#parameter-storagequeueprivateendpointscustomdnsconfigsfqdn) | string | Fqdn that resolves to private endpoint IP address. |
| [`ipAddresses`](#parameter-storagequeueprivateendpointscustomdnsconfigsipaddresses) | array | A list of private IP addresses of the private endpoint. |

### Parameter: `storageQueuePrivateEndpoints.customDnsConfigs.fqdn`

Fqdn that resolves to private endpoint IP address.

- Required: No
- Type: string

### Parameter: `storageQueuePrivateEndpoints.customDnsConfigs.ipAddresses`

A list of private IP addresses of the private endpoint.

- Required: Yes
- Type: array

### Parameter: `storageQueuePrivateEndpoints.customNetworkInterfaceName`

The custom name of the network interface attached to the private endpoint.

- Required: No
- Type: string

### Parameter: `storageQueuePrivateEndpoints.enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool

### Parameter: `storageQueuePrivateEndpoints.ipConfigurations`

A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-storagequeueprivateendpointsipconfigurationsname) | string | The name of the resource that is unique within a resource group. |
| [`properties`](#parameter-storagequeueprivateendpointsipconfigurationsproperties) | object | Properties of private endpoint IP configurations. |

### Parameter: `storageQueuePrivateEndpoints.ipConfigurations.name`

The name of the resource that is unique within a resource group.

- Required: Yes
- Type: string

### Parameter: `storageQueuePrivateEndpoints.ipConfigurations.properties`

Properties of private endpoint IP configurations.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`groupId`](#parameter-storagequeueprivateendpointsipconfigurationspropertiesgroupid) | string | The ID of a group obtained from the remote resource that this private endpoint should connect to. |
| [`memberName`](#parameter-storagequeueprivateendpointsipconfigurationspropertiesmembername) | string | The member name of a group obtained from the remote resource that this private endpoint should connect to. |
| [`privateIPAddress`](#parameter-storagequeueprivateendpointsipconfigurationspropertiesprivateipaddress) | string | A private IP address obtained from the private endpoint's subnet. |

### Parameter: `storageQueuePrivateEndpoints.ipConfigurations.properties.groupId`

The ID of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: string

### Parameter: `storageQueuePrivateEndpoints.ipConfigurations.properties.memberName`

The member name of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: string

### Parameter: `storageQueuePrivateEndpoints.ipConfigurations.properties.privateIPAddress`

A private IP address obtained from the private endpoint's subnet.

- Required: Yes
- Type: string

### Parameter: `storageQueuePrivateEndpoints.isManualConnection`

If Manual Private Link Connection is required.

- Required: No
- Type: bool

### Parameter: `storageQueuePrivateEndpoints.location`

The location to deploy the private endpoint to.

- Required: No
- Type: string

### Parameter: `storageQueuePrivateEndpoints.lock`

Specify the type of lock.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-storagequeueprivateendpointslockkind) | string | Specify the type of lock. |
| [`name`](#parameter-storagequeueprivateendpointslockname) | string | Specify the name of lock. |

### Parameter: `storageQueuePrivateEndpoints.lock.kind`

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

### Parameter: `storageQueuePrivateEndpoints.lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `storageQueuePrivateEndpoints.manualConnectionRequestMessage`

A message passed to the owner of the remote resource with the manual connection request.

- Required: No
- Type: string

### Parameter: `storageQueuePrivateEndpoints.name`

The name of the private endpoint.

- Required: No
- Type: string

### Parameter: `storageQueuePrivateEndpoints.privateDnsZoneGroup`

The private DNS zone group to configure for the private endpoint.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateDnsZoneGroupConfigs`](#parameter-storagequeueprivateendpointsprivatednszonegroupprivatednszonegroupconfigs) | array | The private DNS zone groups to associate the private endpoint. A DNS zone group can support up to 5 DNS zones. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-storagequeueprivateendpointsprivatednszonegroupname) | string | The name of the Private DNS Zone Group. |

### Parameter: `storageQueuePrivateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs`

The private DNS zone groups to associate the private endpoint. A DNS zone group can support up to 5 DNS zones.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateDnsZoneResourceId`](#parameter-storagequeueprivateendpointsprivatednszonegroupprivatednszonegroupconfigsprivatednszoneresourceid) | string | The resource id of the private DNS zone. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-storagequeueprivateendpointsprivatednszonegroupprivatednszonegroupconfigsname) | string | The name of the private DNS zone group config. |

### Parameter: `storageQueuePrivateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs.privateDnsZoneResourceId`

The resource id of the private DNS zone.

- Required: Yes
- Type: string

### Parameter: `storageQueuePrivateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs.name`

The name of the private DNS zone group config.

- Required: No
- Type: string

### Parameter: `storageQueuePrivateEndpoints.privateDnsZoneGroup.name`

The name of the Private DNS Zone Group.

- Required: No
- Type: string

### Parameter: `storageQueuePrivateEndpoints.privateLinkServiceConnectionName`

The name of the private link connection to create.

- Required: No
- Type: string

### Parameter: `storageQueuePrivateEndpoints.resourceGroupName`

Specify if you want to deploy the Private Endpoint into a different resource group than the main resource.

- Required: No
- Type: string

### Parameter: `storageQueuePrivateEndpoints.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-storagequeueprivateendpointsroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-storagequeueprivateendpointsroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-storagequeueprivateendpointsroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-storagequeueprivateendpointsroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-storagequeueprivateendpointsroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-storagequeueprivateendpointsroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-storagequeueprivateendpointsroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-storagequeueprivateendpointsroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `storageQueuePrivateEndpoints.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `storageQueuePrivateEndpoints.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `storageQueuePrivateEndpoints.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `storageQueuePrivateEndpoints.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `storageQueuePrivateEndpoints.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `storageQueuePrivateEndpoints.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `storageQueuePrivateEndpoints.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `storageQueuePrivateEndpoints.roleAssignments.principalType`

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

### Parameter: `storageQueuePrivateEndpoints.service`

The subresource to deploy the private endpoint for. For example "vault", "mysqlServer" or "dataFactory".

- Required: No
- Type: string

### Parameter: `storageQueuePrivateEndpoints.tags`

Tags to be applied on all resources/resource groups in this deployment.

- Required: No
- Type: object

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `accountPrivateEndpoints` | array | The private endpoints of the Purview Account. |
| `eventHubPrivateEndpoints` | array | The private endpoints of the managed Event Hub Namespace. |
| `location` | string | The location the resource was deployed into. |
| `managedEventHubId` | string | The resource ID of the managed Event Hub Namespace. |
| `managedResourceGroupId` | string | The resource ID of the managed resource group. |
| `managedResourceGroupName` | string | The name of the managed resource group. |
| `managedStorageAccountId` | string | The resource ID of the managed storage account. |
| `name` | string | The name of the Purview Account. |
| `portalPrivateEndpoints` | array | The private endpoints of the Purview Account Portal. |
| `resourceGroupName` | string | The resource group the Purview Account was deployed into. |
| `resourceId` | string | The resource ID of the Purview Account. |
| `storageBlobPrivateEndpoints` | array | The private endpoints of the managed storage account blob service. |
| `storageQueuePrivateEndpoints` | array | The private endpoints of the managed storage account queue service. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/network/private-endpoint:0.7.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
