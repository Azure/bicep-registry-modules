# Key Vaults `[Microsoft.KeyVault/vaults]`

This module deploys a Key Vault.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.KeyVault/vaults` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults) |
| `Microsoft.KeyVault/vaults/accessPolicies` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/accessPolicies) |
| `Microsoft.KeyVault/vaults/keys` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/keys) |
| `Microsoft.KeyVault/vaults/secrets` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/secrets) |
| `Microsoft.Network/privateEndpoints` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints/privateDnsZoneGroups) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Key Vault. Must be globally unique. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`accessPolicies`](#parameter-accesspolicies) | array | All access policies to create. |
| [`createMode`](#parameter-createmode) | string | The vault's create mode to indicate whether the vault need to be recovered or not. - recover or default. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`enablePurgeProtection`](#parameter-enablepurgeprotection) | bool | Provide 'true' to enable Key Vault's purge protection feature. |
| [`enableRbacAuthorization`](#parameter-enablerbacauthorization) | bool | Property that controls how data actions are authorized. When true, the key vault will use Role Based Access Control (RBAC) for authorization of data actions, and the access policies specified in vault properties will be ignored (warning: this is a preview feature). When false, the key vault will use the access policies specified in vault properties, and any policy stored on Azure Resource Manager will be ignored. If null or not specified, the vault is created with the default value of false. Note that management actions are always authorized with RBAC. |
| [`enableSoftDelete`](#parameter-enablesoftdelete) | bool | Switch to enable/disable Key Vault's soft delete feature. |
| [`enableVaultForDeployment`](#parameter-enablevaultfordeployment) | bool | Specifies if the vault is enabled for deployment by script or compute. |
| [`enableVaultForDiskEncryption`](#parameter-enablevaultfordiskencryption) | bool | Specifies if the azure platform has access to the vault for enabling disk encryption scenarios. |
| [`enableVaultForTemplateDeployment`](#parameter-enablevaultfortemplatedeployment) | bool | Specifies if the vault is enabled for a template deployment. |
| [`keys`](#parameter-keys) | array | All keys to create. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | string | Specify the type of lock. |
| [`networkAcls`](#parameter-networkacls) | object | Service endpoint object information. For security reasons, it is recommended to set the DefaultAction Deny. |
| [`privateEndpoints`](#parameter-privateendpoints) | array | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and networkAcls are not set. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`secrets`](#parameter-secrets) | secureObject | All secrets to create. |
| [`softDeleteRetentionInDays`](#parameter-softdeleteretentionindays) | int | softDelete data retention days. It accepts >=7 and <=90. |
| [`tags`](#parameter-tags) | object | Resource tags. |
| [`vaultSku`](#parameter-vaultsku) | string | Specifies the SKU for the vault. |

### Parameter: `accessPolicies`

All access policies to create.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `createMode`

The vault's create mode to indicate whether the vault need to be recovered or not. - recover or default.
- Required: No
- Type: string
- Default: `'default'`

### Parameter: `diagnosticSettings`

The diagnostic settings of the service.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `enablePurgeProtection`

Provide 'true' to enable Key Vault's purge protection feature.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableRbacAuthorization`

Property that controls how data actions are authorized. When true, the key vault will use Role Based Access Control (RBAC) for authorization of data actions, and the access policies specified in vault properties will be ignored (warning: this is a preview feature). When false, the key vault will use the access policies specified in vault properties, and any policy stored on Azure Resource Manager will be ignored. If null or not specified, the vault is created with the default value of false. Note that management actions are always authorized with RBAC.
- Required: Yes
- Type: bool
- Default: `False`

### Parameter: `enableSoftDelete`

Switch to enable/disable Key Vault's soft delete feature.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableVaultForDeployment`

Specifies if the vault is enabled for deployment by script or compute.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableVaultForDiskEncryption`

Specifies if the azure platform has access to the vault for enabling disk encryption scenarios.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableVaultForTemplateDeployment`

Specifies if the vault is enabled for a template deployment.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `keys`

All keys to create.
- Required: No
- Type: array
- Default: `[]`

### Parameter: `location`

Location for all resources.
- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

Specify the type of lock.
- Required: No
- Type: string
- Default: `''`
- Allowed: `['', CanNotDelete, ReadOnly]`

### Parameter: `name`

Name of the Key Vault. Must be globally unique.
- Required: Yes
- Type: string

### Parameter: `networkAcls`

Service endpoint object information. For security reasons, it is recommended to set the DefaultAction Deny.
- Required: No
- Type: object
- Default: `{object}`

### Parameter: `privateEndpoints`

Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.
- Required: No
- Type: array
- Default: `[]`

To use Private Endpoint the following dependencies must be deployed:

- Destination subnet must be created with the following configuration option - `"privateEndpointNetworkPolicies": "Disabled"`. Setting this option acknowledges that NSG rules are not applied to Private Endpoints (this capability is coming soon). A full example is available in the Virtual Network Module.
- Although not strictly required, it is highly recommended to first create a private DNS Zone to host Private Endpoint DNS records. See [Azure Private Endpoint DNS configuration](https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-dns) for more information.

<details>

<summary>Parameter JSON format</summary>

```json
"privateEndpoints": {
    "value": [
        // Example showing all available fields
        {
            "name": "sxx-az-pe", // Optional: Name will be automatically generated if one is not provided here
            "subnetResourceId": "/subscriptions/[[subscriptionId]]/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001",
            "service": "<serviceName>", // e.g. vault, registry, blob
            "privateDnsZoneGroup": {
                "privateDNSResourceIds": [ // Optional: No DNS record will be created if a private DNS zone Resource ID is not specified
                    "/subscriptions/[[subscriptionId]]/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/<privateDnsZoneName>" // e.g. privatelink.vaultcore.azure.net, privatelink.azurecr.io, privatelink.blob.core.windows.net
                ]
            },
            "ipConfigurations":[
                {
                    "name": "myIPconfigTest02",
                    "properties": {
                        "groupId": "blob",
                        "memberName": "blob",
                        "privateIPAddress": "10.0.0.30"
                    }
                }
            ],
            "customDnsConfigs": [
                {
                    "fqdn": "customname.test.local",
                    "ipAddresses": [
                        "10.10.10.10"
                    ]
                }
            ]
        },
        // Example showing only mandatory fields
        {
            "subnetResourceId": "/subscriptions/[[subscriptionId]]/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001",
            "service": "<serviceName>" // e.g. vault, registry, blob
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
privateEndpoints:  [
    // Example showing all available fields
    {
        name: 'sxx-az-pe' // Optional: Name will be automatically generated if one is not provided here
        subnetResourceId: '/subscriptions/[[subscriptionId]]/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001'
        service: '<serviceName>' // e.g. vault, registry, blob
        privateDnsZoneGroup: {
            privateDNSResourceIds: [ // Optional: No DNS record will be created if a private DNS zone Resource ID is not specified
                '/subscriptions/[[subscriptionId]]/resourceGroups/validation-rg/providers/Microsoft.Network/privateDnsZones/<privateDnsZoneName>' // e.g. privatelink.vaultcore.azure.net, privatelink.azurecr.io, privatelink.blob.core.windows.net
            ]
        }
        customDnsConfigs: [
            {
                fqdn: 'customname.test.local'
                ipAddresses: [
                    '10.10.10.10'
                ]
            }
        ]
        ipConfigurations:[
          {
            name: 'myIPconfigTest02'
            properties: {
              groupId: 'blob'
              memberName: 'blob'
              privateIPAddress: '10.0.0.30'
            }
          }
        ]
    }
    // Example showing only mandatory fields
    {
        subnetResourceId: '/subscriptions/[[subscriptionId]]/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/sxx-az-vnet-x-001/subnets/sxx-az-subnet-x-001'
        service: '<serviceName>' // e.g. vault, registry, blob
    }
]
```

</details>
<p>

### Parameter: `publicNetworkAccess`

Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and networkAcls are not set.
- Required: No
- Type: string
- Default: `''`
- Allowed: `['', Disabled, Enabled]`

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array
- Default: `[]`

Create a role assignment for the given resource. If you want to assign a service principal / managed identity that is created in the same deployment, make sure to also specify the `'principalType'` parameter and set it to `'ServicePrincipal'`. This will ensure the role assignment waits for the principal's propagation in Azure.

<details>

<summary>Parameter JSON format</summary>

```json
"roleAssignments": {
    "value": [
        {
            "roleDefinitionIdOrName": "Reader",
            "description": "Reader Role Assignment",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012", // object 1
                "78945612-1234-1234-1234-123456789012" // object 2
            ]
        },
        {
            "roleDefinitionIdOrName": "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11",
            "principalIds": [
                "12345678-1234-1234-1234-123456789012" // object 1
            ],
            "principalType": "ServicePrincipal"
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
roleAssignments: [
    {
        roleDefinitionIdOrName: 'Reader'
        description: 'Reader Role Assignment'
        principalIds: [
            '12345678-1234-1234-1234-123456789012' // object 1
            '78945612-1234-1234-1234-123456789012' // object 2
        ]
    }
    {
        roleDefinitionIdOrName: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'
        principalIds: [
            '12345678-1234-1234-1234-123456789012' // object 1
        ]
        principalType: 'ServicePrincipal'
    }
]
```

</details>
<p>

### Parameter: `secrets`

All secrets to create.
- Required: No
- Type: secureObject
- Default: `{object}`

### Parameter: `softDeleteRetentionInDays`

softDelete data retention days. It accepts >=7 and <=90.
- Required: No
- Type: int
- Default: `90`

### Parameter: `tags`

Resource tags.
- Required: No
- Type: object
- Default: `{object}`

Tag names and tag values can be provided as needed. A tag can be left without a value.

<details>

<summary>Parameter JSON format</summary>

```json
"tags": {
    "value": {
        "Environment": "Non-Prod",
        "Contact": "test.user@testcompany.com",
        "PurchaseOrder": "1234",
        "CostCenter": "7890",
        "ServiceName": "DeploymentValidation",
        "Role": "DeploymentValidation"
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
tags: {
    Environment: 'Non-Prod'
    Contact: 'test.user@testcompany.com'
    PurchaseOrder: '1234'
    CostCenter: '7890'
    ServiceName: 'DeploymentValidation'
    Role: 'DeploymentValidation'
}
```

</details>
<p>

### Parameter: `vaultSku`

Specifies the SKU for the vault.
- Required: No
- Type: string
- Default: `'premium'`
- Allowed: `[premium, standard]`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the key vault. |
| `resourceGroupName` | string | The name of the resource group the key vault was created in. |
| `resourceId` | string | The resource ID of the key vault. |
| `uri` | string | The URI of the key vault. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `network/private-endpoint` | Local reference |

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Common</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module vault './key-vault/vault/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-kvvcom'
  params: {
    name: 'kvvcom002'
    accessPolicies: [
      {
        objectId: '<objectId>'
        permissions: {
          keys: [
            'get'
            'list'
            'update'
          ]
          secrets: [
            'all'
          ]
        }
        tenantId: '<tenantId>'
      }
      {
        objectId: '<objectId>'
        permissions: {
          certificates: [
            'backup'
            'create'
            'delete'
          ]
          secrets: [
            'all'
          ]
        }
      }
    ]
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        logCategoriesAndGroups: [
          {
            category: 'AzurePolicyEvaluationDetails'
          }
          {
            category: 'AuditEvent'
          }
        ]
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    enablePurgeProtection: false
    enableRbacAuthorization: false
    keys: [
      {
        attributesExp: 1725109032
        attributesNbf: 10000
        name: 'keyName'
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        rotationPolicy: {
          attributes: {
            expiryTime: 'P2Y'
          }
          lifetimeActions: [
            {
              action: {
                type: 'Rotate'
              }
              trigger: {
                timeBeforeExpiry: 'P2M'
              }
            }
            {
              action: {
                type: 'Notify'
              }
              trigger: {
                timeBeforeExpiry: 'P30D'
              }
            }
          ]
        }
      }
    ]
    lock: 'CanNotDelete'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      ipRules: [
        {
          value: '40.74.28.0/23'
        }
      ]
      virtualNetworkRules: [
        {
          id: '<id>'
          ignoreMissingVnetServiceEndpoint: false
        }
      ]
    }
    privateEndpoints: [
      {
        privateDnsZoneResourceIds: [
          '<privateDNSResourceId>'
        ]
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        service: 'vault'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
    ]
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    secrets: {
      secureList: [
        {
          attributesExp: 1702648632
          attributesNbf: 10000
          contentType: 'Something'
          name: 'secretName'
          roleAssignments: [
            {
              principalId: '<principalId>'
              principalType: 'ServicePrincipal'
              roleDefinitionIdOrName: 'Reader'
            }
          ]
          value: 'secretValue'
        }
      ]
    }
    softDeleteRetentionInDays: 7
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
    "name": {
      "value": "kvvcom002"
    },
    "accessPolicies": {
      "value": [
        {
          "objectId": "<objectId>",
          "permissions": {
            "keys": [
              "get",
              "list",
              "update"
            ],
            "secrets": [
              "all"
            ]
          },
          "tenantId": "<tenantId>"
        },
        {
          "objectId": "<objectId>",
          "permissions": {
            "certificates": [
              "backup",
              "create",
              "delete"
            ],
            "secrets": [
              "all"
            ]
          }
        }
      ]
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "logCategoriesAndGroups": [
            {
              "category": "AzurePolicyEvaluationDetails"
            },
            {
              "category": "AuditEvent"
            }
          ],
          "metricCategories": [
            {
              "category": "AllMetrics"
            }
          ],
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        },
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "enablePurgeProtection": {
      "value": false
    },
    "enableRbacAuthorization": {
      "value": false
    },
    "keys": {
      "value": [
        {
          "attributesExp": 1725109032,
          "attributesNbf": 10000,
          "name": "keyName",
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "rotationPolicy": {
            "attributes": {
              "expiryTime": "P2Y"
            },
            "lifetimeActions": [
              {
                "action": {
                  "type": "Rotate"
                },
                "trigger": {
                  "timeBeforeExpiry": "P2M"
                }
              },
              {
                "action": {
                  "type": "Notify"
                },
                "trigger": {
                  "timeBeforeExpiry": "P30D"
                }
              }
            ]
          }
        }
      ]
    },
    "lock": {
      "value": "CanNotDelete"
    },
    "networkAcls": {
      "value": {
        "bypass": "AzureServices",
        "defaultAction": "Deny",
        "ipRules": [
          {
            "value": "40.74.28.0/23"
          }
        ],
        "virtualNetworkRules": [
          {
            "id": "<id>",
            "ignoreMissingVnetServiceEndpoint": false
          }
        ]
      }
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneResourceIds": [
            "<privateDNSResourceId>"
          ],
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "service": "vault",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        }
      ]
    },
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    },
    "secrets": {
      "value": {
        "secureList": [
          {
            "attributesExp": 1702648632,
            "attributesNbf": 10000,
            "contentType": "Something",
            "name": "secretName",
            "roleAssignments": [
              {
                "principalId": "<principalId>",
                "principalType": "ServicePrincipal",
                "roleDefinitionIdOrName": "Reader"
              }
            ],
            "value": "secretValue"
          }
        ]
      }
    },
    "softDeleteRetentionInDays": {
      "value": 7
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

<h3>Example 2: Min</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module vault './key-vault/vault/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-kvvmin'
  params: {
    // Required parameters
    name: 'kvvmin002'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    enablePurgeProtection: false
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
      "value": "kvvmin002"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "enablePurgeProtection": {
      "value": false
    }
  }
}
```

</details>
<p>

<h3>Example 3: Pe</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module vault './key-vault/vault/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-kvvpe'
  params: {
    // Required parameters
    name: 'kvvpe001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    enablePurgeProtection: false
    privateEndpoints: [
      {
        privateDnsZoneResourceIds: [
          '<privateDNSResourceId>'
        ]
        service: 'vault'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
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
      "value": "kvvpe001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "enablePurgeProtection": {
      "value": false
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneResourceIds": [
            "<privateDNSResourceId>"
          ],
          "service": "vault",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
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
