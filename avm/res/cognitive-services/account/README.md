# Cognitive Services `[Microsoft.CognitiveServices/accounts]`

This module deploys a Cognitive Service.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.CognitiveServices/accounts` | [2022-12-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2022-12-01/accounts) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/privateEndpoints` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints/privateDnsZoneGroups) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/cognitive-services/account:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [As Speech Service](#example-3-as-speech-service)
- [Using Customer-Managed-Keys with System-Assigned identity](#example-4-using-customer-managed-keys-with-system-assigned-identity)
- [Using Customer-Managed-Keys with User-Assigned identity](#example-5-using-customer-managed-keys-with-user-assigned-identity)
- [WAF-aligned](#example-6-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module account 'br/public:avm/res/cognitive-services/account:<version>' = {
  name: '${uniqueString(deployment().name, location)}-test-csamin'
  params: {
    // Required parameters
    kind: 'SpeechServices'
    name: 'csamin001'
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
    "kind": {
      "value": "SpeechServices"
    },
    "name": {
      "value": "csamin001"
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
module account 'br/public:avm/res/cognitive-services/account:<version>' = {
  name: '${uniqueString(deployment().name, location)}-test-csamax'
  params: {
    // Required parameters
    kind: 'Face'
    name: 'csamax001'
    // Non-required parameters
    customSubDomainName: 'xcsamax'
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        logCategoriesAndGroups: [
          {
            category: 'RequestResponse'
          }
          {
            category: 'Audit'
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
    networkAcls: {
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
        customDnsConfigs: [
          {
            fqdn: 'abc.account.com'
            ipAddresses: [
              '10.0.0.10'
            ]
          }
        ]
        ipConfigurations: [
          {
            name: 'myIPconfig'
            properties: {
              groupId: 'account'
              memberName: 'default'
              privateIPAddress: '10.0.0.10'
            }
          }
        ]
        privateDnsZoneResourceIds: [
          '<privateDNSZoneResourceId>'
        ]
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
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
    sku: 'S0'
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
    "kind": {
      "value": "Face"
    },
    "name": {
      "value": "csamax001"
    },
    // Non-required parameters
    "customSubDomainName": {
      "value": "xcsamax"
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "logCategoriesAndGroups": [
            {
              "category": "RequestResponse"
            },
            {
              "category": "Audit"
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
    "networkAcls": {
      "value": {
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
          "customDnsConfigs": [
            {
              "fqdn": "abc.account.com",
              "ipAddresses": [
                "10.0.0.10"
              ]
            }
          ],
          "ipConfigurations": [
            {
              "name": "myIPconfig",
              "properties": {
                "groupId": "account",
                "memberName": "default",
                "privateIPAddress": "10.0.0.10"
              }
            }
          ],
          "privateDnsZoneResourceIds": [
            "<privateDNSZoneResourceId>"
          ],
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
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
    "sku": {
      "value": "S0"
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

### Example 3: _As Speech Service_

This instance deploys the module as a Speech Service.


<details>

<summary>via Bicep module</summary>

```bicep
module account 'br/public:avm/res/cognitive-services/account:<version>' = {
  name: '${uniqueString(deployment().name, location)}-test-csaspeech'
  params: {
    // Required parameters
    kind: 'SpeechServices'
    name: 'csaspeech001'
    // Non-required parameters
    customSubDomainName: 'speechdomain'
    location: '<location>'
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    privateEndpoints: [
      {
        privateDnsZoneResourceIds: [
          '<privateDNSZoneResourceId>'
        ]
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
    ]
    sku: 'S0'
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
    "kind": {
      "value": "SpeechServices"
    },
    "name": {
      "value": "csaspeech001"
    },
    // Non-required parameters
    "customSubDomainName": {
      "value": "speechdomain"
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
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneResourceIds": [
            "<privateDNSZoneResourceId>"
          ],
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        }
      ]
    },
    "sku": {
      "value": "S0"
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

### Example 4: _Using Customer-Managed-Keys with System-Assigned identity_

This instance deploys the module using Customer-Managed-Keys using a System-Assigned Identity. This required the service to be deployed twice, once as a pre-requisite to create the System-Assigned Identity, and once to use it for accessing the Customer-Managed-Key secret.


<details>

<summary>via Bicep module</summary>

```bicep
module account 'br/public:avm/res/cognitive-services/account:<version>' = {
  name: '${uniqueString(deployment().name, location)}-test-csaecrs'
  params: {
    // Required parameters
    kind: 'SpeechServices'
    name: '<name>'
    // Non-required parameters
    customerManagedKey: {
      keyName: '<keyName>'
      keyVaultResourceId: '<keyVaultResourceId>'
    }
    location: '<location>'
    managedIdentities: {
      systemAssigned: true
    }
    publicNetworkAccess: 'Enabled'
    restrictOutboundNetworkAccess: false
    sku: 'S0'
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
    "kind": {
      "value": "SpeechServices"
    },
    "name": {
      "value": "<name>"
    },
    // Non-required parameters
    "customerManagedKey": {
      "value": {
        "keyName": "<keyName>",
        "keyVaultResourceId": "<keyVaultResourceId>"
      }
    },
    "location": {
      "value": "<location>"
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": true
      }
    },
    "publicNetworkAccess": {
      "value": "Enabled"
    },
    "restrictOutboundNetworkAccess": {
      "value": false
    },
    "sku": {
      "value": "S0"
    }
  }
}
```

</details>
<p>

### Example 5: _Using Customer-Managed-Keys with User-Assigned identity_

This instance deploys the module using Customer-Managed-Keys using a User-Assigned Identity to access the Customer-Managed-Key secret.


<details>

<summary>via Bicep module</summary>

```bicep
module account 'br/public:avm/res/cognitive-services/account:<version>' = {
  name: '${uniqueString(deployment().name, location)}-test-csaencr'
  params: {
    // Required parameters
    kind: 'SpeechServices'
    name: 'csaencr001'
    // Non-required parameters
    customerManagedKey: {
      keyName: '<keyName>'
      keyVaultResourceId: '<keyVaultResourceId>'
      userAssignedIdentityResourceId: '<userAssignedIdentityResourceId>'
    }
    location: '<location>'
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    publicNetworkAccess: 'Enabled'
    restrictOutboundNetworkAccess: false
    sku: 'S0'
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
    "kind": {
      "value": "SpeechServices"
    },
    "name": {
      "value": "csaencr001"
    },
    // Non-required parameters
    "customerManagedKey": {
      "value": {
        "keyName": "<keyName>",
        "keyVaultResourceId": "<keyVaultResourceId>",
        "userAssignedIdentityResourceId": "<userAssignedIdentityResourceId>"
      }
    },
    "location": {
      "value": "<location>"
    },
    "managedIdentities": {
      "value": {
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "publicNetworkAccess": {
      "value": "Enabled"
    },
    "restrictOutboundNetworkAccess": {
      "value": false
    },
    "sku": {
      "value": "S0"
    }
  }
}
```

</details>
<p>

### Example 6: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module account 'br/public:avm/res/cognitive-services/account:<version>' = {
  name: '${uniqueString(deployment().name, location)}-test-csawaf'
  params: {
    // Required parameters
    kind: 'Face'
    name: 'csawaf001'
    // Non-required parameters
    customSubDomainName: 'xcsawaf'
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    managedIdentities: {
      systemAssigned: true
    }
    privateEndpoints: [
      {
        privateDnsZoneResourceIds: [
          '<privateDNSZoneResourceId>'
        ]
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
    ]
    sku: 'S0'
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
    "kind": {
      "value": "Face"
    },
    "name": {
      "value": "csawaf001"
    },
    // Non-required parameters
    "customSubDomainName": {
      "value": "xcsawaf"
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
        "systemAssigned": true
      }
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneResourceIds": [
            "<privateDNSZoneResourceId>"
          ],
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        }
      ]
    },
    "sku": {
      "value": "S0"
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
| [`kind`](#parameter-kind) | string | Kind of the Cognitive Services. Use 'Get-AzCognitiveServicesAccountSku' to determine a valid combinations of 'kind' and 'SKU' for your Azure region. |
| [`name`](#parameter-name) | string | The name of Cognitive Services account. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`customSubDomainName`](#parameter-customsubdomainname) | string | Subdomain name used for token-based authentication. Required if 'networkAcls' or 'privateEndpoints' are set. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowedFqdnList`](#parameter-allowedfqdnlist) | array | List of allowed FQDN. |
| [`apiProperties`](#parameter-apiproperties) | object | The API properties for special APIs. |
| [`customerManagedKey`](#parameter-customermanagedkey) | object | The customer managed key definition. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`disableLocalAuth`](#parameter-disablelocalauth) | bool | Allow only Azure AD authentication. Should be enabled for security reasons. |
| [`dynamicThrottlingEnabled`](#parameter-dynamicthrottlingenabled) | bool | The flag to enable dynamic throttling. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`migrationToken`](#parameter-migrationtoken) | string | Resource migration token. |
| [`networkAcls`](#parameter-networkacls) | object | A collection of rules governing the accessibility from specific network locations. |
| [`privateEndpoints`](#parameter-privateendpoints) | array | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and networkAcls are not set. |
| [`restore`](#parameter-restore) | bool | Restore a soft-deleted cognitive service at deployment time. Will fail if no such soft-deleted resource exists. |
| [`restrictOutboundNetworkAccess`](#parameter-restrictoutboundnetworkaccess) | bool | Restrict outbound network access. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`sku`](#parameter-sku) | string | SKU of the Cognitive Services resource. Use 'Get-AzCognitiveServicesAccountSku' to determine a valid combinations of 'kind' and 'SKU' for your Azure region. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`userOwnedStorage`](#parameter-userownedstorage) | array | The storage accounts for this resource. |

### Parameter: `allowedFqdnList`

List of allowed FQDN.
- Required: No
- Type: array

### Parameter: `apiProperties`

The API properties for special APIs.
- Required: No
- Type: object

### Parameter: `customerManagedKey`

The customer managed key definition.
- Required: No
- Type: object


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`keyName`](#parameter-customermanagedkeykeyname) | Yes | string | Required. The name of the customer managed key to use for encryption. |
| [`keyVaultResourceId`](#parameter-customermanagedkeykeyvaultresourceid) | Yes | string | Required. The resource ID of a key vault to reference a customer managed key for encryption from. |
| [`keyVersion`](#parameter-customermanagedkeykeyversion) | No | string | Optional. The version of the customer managed key to reference for encryption. If not provided, using 'latest'. |
| [`userAssignedIdentityResourceId`](#parameter-customermanagedkeyuserassignedidentityresourceid) | No | string | Optional. User assigned identity to use when fetching the customer managed key. Required if no system assigned identity is available for use. |

### Parameter: `customerManagedKey.keyName`

Required. The name of the customer managed key to use for encryption.

- Required: Yes
- Type: string

### Parameter: `customerManagedKey.keyVaultResourceId`

Required. The resource ID of a key vault to reference a customer managed key for encryption from.

- Required: Yes
- Type: string

### Parameter: `customerManagedKey.keyVersion`

Optional. The version of the customer managed key to reference for encryption. If not provided, using 'latest'.

- Required: No
- Type: string

### Parameter: `customerManagedKey.userAssignedIdentityResourceId`

Optional. User assigned identity to use when fetching the customer managed key. Required if no system assigned identity is available for use.

- Required: No
- Type: string

### Parameter: `customSubDomainName`

Subdomain name used for token-based authentication. Required if 'networkAcls' or 'privateEndpoints' are set.
- Required: No
- Type: string

### Parameter: `diagnosticSettings`

The diagnostic settings of the service.
- Required: No
- Type: array


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-diagnosticsettingseventhubauthorizationruleresourceid) | No | string | Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-diagnosticsettingseventhubname) | No | string | Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-diagnosticsettingsloganalyticsdestinationtype) | No | string | Optional. A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-diagnosticsettingslogcategoriesandgroups) | No | array | Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-diagnosticsettingsmarketplacepartnerresourceid) | No | string | Optional. The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-diagnosticsettingsmetriccategories) | No | array | Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| [`name`](#parameter-diagnosticsettingsname) | No | string | Optional. The name of diagnostic setting. |
| [`storageAccountResourceId`](#parameter-diagnosticsettingsstorageaccountresourceid) | No | string | Optional. Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-diagnosticsettingsworkspaceresourceid) | No | string | Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `diagnosticSettings.eventHubAuthorizationRuleResourceId`

Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.eventHubName`

Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logAnalyticsDestinationType`

Optional. A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.

- Required: No
- Type: string
- Allowed: `[AzureDiagnostics, Dedicated]`

### Parameter: `diagnosticSettings.logCategoriesAndGroups`

Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection.

- Required: No
- Type: array

| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`category`](#parameter-diagnosticsettingslogcategoriesandgroupscategory) | No | string | Optional. Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-diagnosticsettingslogcategoriesandgroupscategorygroup) | No | string | Optional. Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |

### Parameter: `diagnosticSettings.logCategoriesAndGroups.category`

Optional. Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Optional. Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string


### Parameter: `diagnosticSettings.marketplacePartnerResourceId`

Optional. The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.metricCategories`

Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection.

- Required: No
- Type: array

| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`category`](#parameter-diagnosticsettingsmetriccategoriescategory) | Yes | string | Required. Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

### Parameter: `diagnosticSettings.metricCategories.category`

Required. Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string


### Parameter: `diagnosticSettings.name`

Optional. The name of diagnostic setting.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.storageAccountResourceId`

Optional. Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.workspaceResourceId`

Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `disableLocalAuth`

Allow only Azure AD authentication. Should be enabled for security reasons.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `dynamicThrottlingEnabled`

The flag to enable dynamic throttling.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `kind`

Kind of the Cognitive Services. Use 'Get-AzCognitiveServicesAccountSku' to determine a valid combinations of 'kind' and 'SKU' for your Azure region.
- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AnomalyDetector'
    'Bing.Autosuggest.v7'
    'Bing.CustomSearch'
    'Bing.EntitySearch'
    'Bing.Search.v7'
    'Bing.SpellCheck.v7'
    'CognitiveServices'
    'ComputerVision'
    'ContentModerator'
    'CustomVision.Prediction'
    'CustomVision.Training'
    'Face'
    'FormRecognizer'
    'ImmersiveReader'
    'Internal.AllInOne'
    'LUIS'
    'LUIS.Authoring'
    'Personalizer'
    'QnAMaker'
    'SpeechServices'
    'TextAnalytics'
    'TextTranslation'
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


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`kind`](#parameter-lockkind) | No | string | Optional. Specify the type of lock. |
| [`name`](#parameter-lockname) | No | string | Optional. Specify the name of lock. |

### Parameter: `lock.kind`

Optional. Specify the type of lock.

- Required: No
- Type: string
- Allowed: `[CanNotDelete, None, ReadOnly]`

### Parameter: `lock.name`

Optional. Specify the name of lock.

- Required: No
- Type: string

### Parameter: `managedIdentities`

The managed identity definition for this resource.
- Required: No
- Type: object


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`systemAssigned`](#parameter-managedidentitiessystemassigned) | No | bool | Optional. Enables system assigned managed identity on the resource. |
| [`userAssignedResourceIds`](#parameter-managedidentitiesuserassignedresourceids) | No | array | Optional. The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption. |

### Parameter: `managedIdentities.systemAssigned`

Optional. Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `managedIdentities.userAssignedResourceIds`

Optional. The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption.

- Required: No
- Type: array

### Parameter: `migrationToken`

Resource migration token.
- Required: No
- Type: string

### Parameter: `name`

The name of Cognitive Services account.
- Required: Yes
- Type: string

### Parameter: `networkAcls`

A collection of rules governing the accessibility from specific network locations.
- Required: No
- Type: object

### Parameter: `privateEndpoints`

Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.
- Required: No
- Type: array


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`applicationSecurityGroupResourceIds`](#parameter-privateendpointsapplicationsecuritygroupresourceids) | No | array | Optional. Application security groups in which the private endpoint IP configuration is included. |
| [`customDnsConfigs`](#parameter-privateendpointscustomdnsconfigs) | No | array | Optional. Custom DNS configurations. |
| [`customNetworkInterfaceName`](#parameter-privateendpointscustomnetworkinterfacename) | No | string | Optional. The custom name of the network interface attached to the private endpoint. |
| [`enableTelemetry`](#parameter-privateendpointsenabletelemetry) | No | bool | Optional. Enable/Disable usage telemetry for module. |
| [`ipConfigurations`](#parameter-privateendpointsipconfigurations) | No | array | Optional. A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints. |
| [`location`](#parameter-privateendpointslocation) | No | string | Optional. The location to deploy the private endpoint to. |
| [`lock`](#parameter-privateendpointslock) | No | object | Optional. Specify the type of lock. |
| [`manualPrivateLinkServiceConnections`](#parameter-privateendpointsmanualprivatelinkserviceconnections) | No | array | Optional. Manual PrivateLink Service Connections. |
| [`name`](#parameter-privateendpointsname) | No | string | Optional. The name of the private endpoint. |
| [`privateDnsZoneGroupName`](#parameter-privateendpointsprivatednszonegroupname) | No | string | Optional. The name of the private DNS zone group to create if `privateDnsZoneResourceIds` were provided. |
| [`privateDnsZoneResourceIds`](#parameter-privateendpointsprivatednszoneresourceids) | No | array | Optional. The private DNS zone groups to associate the private endpoint with. A DNS zone group can support up to 5 DNS zones. |
| [`roleAssignments`](#parameter-privateendpointsroleassignments) | No | array | Optional. Array of role assignments to create. |
| [`service`](#parameter-privateendpointsservice) | No | string | Optional. The service (sub-) type to deploy the private endpoint for. For example "vault" or "blob". |
| [`subnetResourceId`](#parameter-privateendpointssubnetresourceid) | Yes | string | Required. Resource ID of the subnet where the endpoint needs to be created. |
| [`tags`](#parameter-privateendpointstags) | No | object | Optional. Tags to be applied on all resources/resource groups in this deployment. |

### Parameter: `privateEndpoints.applicationSecurityGroupResourceIds`

Optional. Application security groups in which the private endpoint IP configuration is included.

- Required: No
- Type: array

### Parameter: `privateEndpoints.customDnsConfigs`

Optional. Custom DNS configurations.

- Required: No
- Type: array

| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`fqdn`](#parameter-privateendpointscustomdnsconfigsfqdn) | No | string | Required. Fqdn that resolves to private endpoint IP address. |
| [`ipAddresses`](#parameter-privateendpointscustomdnsconfigsipaddresses) | Yes | array | Required. A list of private IP addresses of the private endpoint. |

### Parameter: `privateEndpoints.customDnsConfigs.fqdn`

Required. Fqdn that resolves to private endpoint IP address.

- Required: No
- Type: string

### Parameter: `privateEndpoints.customDnsConfigs.ipAddresses`

Required. A list of private IP addresses of the private endpoint.

- Required: Yes
- Type: array


### Parameter: `privateEndpoints.customNetworkInterfaceName`

Optional. The custom name of the network interface attached to the private endpoint.

- Required: No
- Type: string

### Parameter: `privateEndpoints.enableTelemetry`

Optional. Enable/Disable usage telemetry for module.

- Required: No
- Type: bool

### Parameter: `privateEndpoints.ipConfigurations`

Optional. A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints.

- Required: No
- Type: array

| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`name`](#parameter-privateendpointsipconfigurationsname) | Yes | string | Required. The name of the resource that is unique within a resource group. |
| [`properties`](#parameter-privateendpointsipconfigurationsproperties) | Yes | object | Required. Properties of private endpoint IP configurations. |

### Parameter: `privateEndpoints.ipConfigurations.name`

Required. The name of the resource that is unique within a resource group.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.ipConfigurations.properties`

Required. Properties of private endpoint IP configurations.

- Required: Yes
- Type: object

| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`groupId`](#parameter-privateendpointsipconfigurationspropertiesgroupid) | Yes | string | Required. The ID of a group obtained from the remote resource that this private endpoint should connect to. |
| [`memberName`](#parameter-privateendpointsipconfigurationspropertiesmembername) | Yes | string | Required. The member name of a group obtained from the remote resource that this private endpoint should connect to. |
| [`privateIPAddress`](#parameter-privateendpointsipconfigurationspropertiesprivateipaddress) | Yes | string | Required. A private IP address obtained from the private endpoint's subnet. |

### Parameter: `privateEndpoints.ipConfigurations.properties.groupId`

Required. The ID of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.ipConfigurations.properties.memberName`

Required. The member name of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.ipConfigurations.properties.privateIPAddress`

Required. A private IP address obtained from the private endpoint's subnet.

- Required: Yes
- Type: string



### Parameter: `privateEndpoints.location`

Optional. The location to deploy the private endpoint to.

- Required: No
- Type: string

### Parameter: `privateEndpoints.lock`

Optional. Specify the type of lock.

- Required: No
- Type: object

### Parameter: `privateEndpoints.manualPrivateLinkServiceConnections`

Optional. Manual PrivateLink Service Connections.

- Required: No
- Type: array

### Parameter: `privateEndpoints.name`

Optional. The name of the private endpoint.

- Required: No
- Type: string

### Parameter: `privateEndpoints.privateDnsZoneGroupName`

Optional. The name of the private DNS zone group to create if `privateDnsZoneResourceIds` were provided.

- Required: No
- Type: string

### Parameter: `privateEndpoints.privateDnsZoneResourceIds`

Optional. The private DNS zone groups to associate the private endpoint with. A DNS zone group can support up to 5 DNS zones.

- Required: No
- Type: array

### Parameter: `privateEndpoints.roleAssignments`

Optional. Array of role assignments to create.

- Required: No
- Type: array

### Parameter: `privateEndpoints.service`

Optional. The service (sub-) type to deploy the private endpoint for. For example "vault" or "blob".

- Required: No
- Type: string

### Parameter: `privateEndpoints.subnetResourceId`

Required. Resource ID of the subnet where the endpoint needs to be created.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.tags`

Optional. Tags to be applied on all resources/resource groups in this deployment.

- Required: No
- Type: object

### Parameter: `publicNetworkAccess`

Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and networkAcls are not set.
- Required: No
- Type: string
- Default: `''`
- Allowed:
  ```Bicep
  [
    ''
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `restore`

Restore a soft-deleted cognitive service at deployment time. Will fail if no such soft-deleted resource exists.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `restrictOutboundNetworkAccess`

Restrict outbound network access.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `roleAssignments`

Array of role assignments to create.
- Required: No
- Type: array


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`condition`](#parameter-roleassignmentscondition) | No | string | Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container" |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | No | string | Optional. Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | No | string | Optional. The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | No | string | Optional. The description of the role assignment. |
| [`principalId`](#parameter-roleassignmentsprincipalid) | Yes | string | Required. The principal ID of the principal (user/group/identity) to assign the role to. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | No | string | Optional. The principal type of the assigned principal ID. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | Yes | string | Required. The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

### Parameter: `roleAssignments.condition`

Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container"

- Required: No
- Type: string

### Parameter: `roleAssignments.conditionVersion`

Optional. Version of the condition.

- Required: No
- Type: string
- Allowed: `[2.0]`

### Parameter: `roleAssignments.delegatedManagedIdentityResourceId`

Optional. The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `roleAssignments.description`

Optional. The description of the role assignment.

- Required: No
- Type: string

### Parameter: `roleAssignments.principalId`

Required. The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.principalType`

Optional. The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed: `[Device, ForeignGroup, Group, ServicePrincipal, User]`

### Parameter: `roleAssignments.roleDefinitionIdOrName`

Required. The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `sku`

SKU of the Cognitive Services resource. Use 'Get-AzCognitiveServicesAccountSku' to determine a valid combinations of 'kind' and 'SKU' for your Azure region.
- Required: No
- Type: string
- Default: `'S0'`
- Allowed:
  ```Bicep
  [
    'C2'
    'C3'
    'C4'
    'F0'
    'F1'
    'S'
    'S0'
    'S1'
    'S10'
    'S2'
    'S3'
    'S4'
    'S5'
    'S6'
    'S7'
    'S8'
    'S9'
  ]
  ```

### Parameter: `tags`

Tags of the resource.
- Required: No
- Type: object

### Parameter: `userOwnedStorage`

The storage accounts for this resource.
- Required: No
- Type: array


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `endpoint` | string | The service endpoint of the cognitive services account. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the cognitive services account. |
| `resourceGroupName` | string | The resource group the cognitive services account was deployed into. |
| `resourceId` | string | The resource ID of the cognitive services account. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/network/private-endpoint:0.3.1` | Remote reference |
