# Azure Container Registries (ACR) `[Microsoft.ContainerRegistry/registries]`

This module deploys an Azure Container Registry (ACR).

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
| `Microsoft.ContainerRegistry/registries` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries) |
| `Microsoft.ContainerRegistry/registries/cacheRules` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/cacheRules) |
| `Microsoft.ContainerRegistry/registries/credentialSets` | [2023-11-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/credentialSets) |
| `Microsoft.ContainerRegistry/registries/replications` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/replications) |
| `Microsoft.ContainerRegistry/registries/scopeMaps` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/scopeMaps) |
| `Microsoft.ContainerRegistry/registries/webhooks` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/webhooks) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/privateEndpoints` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints/privateDnsZoneGroups) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/container-registry/registry:<version>`.

- [Using cache rules](#example-1-using-cache-rules)
- [Using only defaults](#example-2-using-only-defaults)
- [Using encryption with Customer-Managed-Key](#example-3-using-encryption-with-customer-managed-key)
- [Using large parameter set](#example-4-using-large-parameter-set)
- [Using `scopeMaps` in parameter set](#example-5-using-scopemaps-in-parameter-set)
- [WAF-aligned](#example-6-waf-aligned)

### Example 1: _Using cache rules_

This instance deploys the module with a credential set and a cache rule.


<details>

<summary>via Bicep module</summary>

```bicep
module registry 'br/public:avm/res/container-registry/registry:<version>' = {
  name: 'registryDeployment'
  params: {
    // Required parameters
    name: '<name>'
    // Non-required parameters
    acrAdminUserEnabled: false
    acrSku: 'Standard'
    cacheRules: [
      {
        credentialSetResourceId: '<credentialSetResourceId>'
        name: 'customRule'
        sourceRepository: 'docker.io/library/hello-world'
        targetRepository: 'cached-docker-hub/hello-world'
      }
    ]
    credentialSets: [
      {
        authCredentials: [
          {
            name: 'Credential1'
            passwordSecretIdentifier: '<passwordSecretIdentifier>'
            usernameSecretIdentifier: '<usernameSecretIdentifier>'
          }
        ]
        loginServer: 'docker.io'
        managedIdentities: {
          systemAssigned: true
        }
        name: 'default'
      }
    ]
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
      "value": "<name>"
    },
    // Non-required parameters
    "acrAdminUserEnabled": {
      "value": false
    },
    "acrSku": {
      "value": "Standard"
    },
    "cacheRules": {
      "value": [
        {
          "credentialSetResourceId": "<credentialSetResourceId>",
          "name": "customRule",
          "sourceRepository": "docker.io/library/hello-world",
          "targetRepository": "cached-docker-hub/hello-world"
        }
      ]
    },
    "credentialSets": {
      "value": [
        {
          "authCredentials": [
            {
              "name": "Credential1",
              "passwordSecretIdentifier": "<passwordSecretIdentifier>",
              "usernameSecretIdentifier": "<usernameSecretIdentifier>"
            }
          ],
          "loginServer": "docker.io",
          "managedIdentities": {
            "systemAssigned": true
          },
          "name": "default"
        }
      ]
    },
    "location": {
      "value": "<location>"
    }
  }
}
```

</details>
<p>

### Example 2: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module registry 'br/public:avm/res/container-registry/registry:<version>' = {
  name: 'registryDeployment'
  params: {
    // Required parameters
    name: 'crrmin001'
    // Non-required parameters
    acrSku: 'Standard'
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
      "value": "crrmin001"
    },
    // Non-required parameters
    "acrSku": {
      "value": "Standard"
    },
    "location": {
      "value": "<location>"
    }
  }
}
```

</details>
<p>

### Example 3: _Using encryption with Customer-Managed-Key_

This instance deploys the module using Customer-Managed-Keys using a User-Assigned Identity to access the Customer-Managed-Key secret.


<details>

<summary>via Bicep module</summary>

```bicep
module registry 'br/public:avm/res/container-registry/registry:<version>' = {
  name: 'registryDeployment'
  params: {
    // Required parameters
    name: 'crrencr001'
    // Non-required parameters
    acrSku: 'Premium'
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
    publicNetworkAccess: 'Disabled'
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
      "value": "crrencr001"
    },
    // Non-required parameters
    "acrSku": {
      "value": "Premium"
    },
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
      "value": "Disabled"
    }
  }
}
```

</details>
<p>

### Example 4: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module registry 'br/public:avm/res/container-registry/registry:<version>' = {
  name: 'registryDeployment'
  params: {
    // Required parameters
    name: 'crrmax001'
    // Non-required parameters
    acrAdminUserEnabled: false
    acrSku: 'Premium'
    azureADAuthenticationAsArmPolicyStatus: 'enabled'
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
    exportPolicyStatus: 'enabled'
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
    networkRuleSetIpRules: [
      {
        action: 'Allow'
        value: '40.74.28.0/23'
      }
    ]
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
      {
        privateDnsZoneResourceIds: [
          '<privateDNSZoneResourceId>'
        ]
        subnetResourceId: '<subnetResourceId>'
      }
    ]
    quarantinePolicyStatus: 'enabled'
    replications: [
      {
        location: '<location>'
        name: '<name>'
      }
    ]
    roleAssignments: [
      {
        name: '60395919-cfd3-47bf-8349-775ddebb255e'
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
    softDeletePolicyDays: 7
    softDeletePolicyStatus: 'disabled'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    trustPolicyStatus: 'enabled'
    webhooks: [
      {
        name: 'acrx001webhook'
        serviceUri: 'https://www.contoso.com/webhook'
      }
    ]
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
      "value": "crrmax001"
    },
    // Non-required parameters
    "acrAdminUserEnabled": {
      "value": false
    },
    "acrSku": {
      "value": "Premium"
    },
    "azureADAuthenticationAsArmPolicyStatus": {
      "value": "enabled"
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
    "exportPolicyStatus": {
      "value": "enabled"
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
    "networkRuleSetIpRules": {
      "value": [
        {
          "action": "Allow",
          "value": "40.74.28.0/23"
        }
      ]
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
        },
        {
          "privateDnsZoneResourceIds": [
            "<privateDNSZoneResourceId>"
          ],
          "subnetResourceId": "<subnetResourceId>"
        }
      ]
    },
    "quarantinePolicyStatus": {
      "value": "enabled"
    },
    "replications": {
      "value": [
        {
          "location": "<location>",
          "name": "<name>"
        }
      ]
    },
    "roleAssignments": {
      "value": [
        {
          "name": "60395919-cfd3-47bf-8349-775ddebb255e",
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
    "softDeletePolicyDays": {
      "value": 7
    },
    "softDeletePolicyStatus": {
      "value": "disabled"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "trustPolicyStatus": {
      "value": "enabled"
    },
    "webhooks": {
      "value": [
        {
          "name": "acrx001webhook",
          "serviceUri": "https://www.contoso.com/webhook"
        }
      ]
    }
  }
}
```

</details>
<p>

### Example 5: _Using `scopeMaps` in parameter set_

This instance deploys the module with the scopeMaps feature.


<details>

<summary>via Bicep module</summary>

```bicep
module registry 'br/public:avm/res/container-registry/registry:<version>' = {
  name: 'registryDeployment'
  params: {
    // Required parameters
    name: 'crrs001'
    // Non-required parameters
    acrSku: 'Standard'
    location: '<location>'
    scopeMaps: [
      {
        actions: [
          'repositories/*/content/read'
        ]
        description: 'This is a test for scopeMaps feature.'
        name: 'testscopemap'
      }
    ]
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
      "value": "crrs001"
    },
    // Non-required parameters
    "acrSku": {
      "value": "Standard"
    },
    "location": {
      "value": "<location>"
    },
    "scopeMaps": {
      "value": [
        {
          "actions": [
            "repositories/*/content/read"
          ],
          "description": "This is a test for scopeMaps feature.",
          "name": "testscopemap"
        }
      ]
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
module registry 'br/public:avm/res/container-registry/registry:<version>' = {
  name: 'registryDeployment'
  params: {
    // Required parameters
    name: 'crrwaf001'
    // Non-required parameters
    acrAdminUserEnabled: false
    acrSku: 'Premium'
    azureADAuthenticationAsArmPolicyStatus: 'enabled'
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    exportPolicyStatus: 'enabled'
    location: '<location>'
    privateEndpoints: [
      {
        privateDnsZoneResourceIds: [
          '<privateDNSResourceId>'
        ]
        subnetResourceId: '<subnetResourceId>'
      }
    ]
    quarantinePolicyStatus: 'enabled'
    replications: [
      {
        location: '<location>'
        name: '<name>'
      }
    ]
    softDeletePolicyDays: 7
    softDeletePolicyStatus: 'disabled'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    trustPolicyStatus: 'enabled'
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
      "value": "crrwaf001"
    },
    // Non-required parameters
    "acrAdminUserEnabled": {
      "value": false
    },
    "acrSku": {
      "value": "Premium"
    },
    "azureADAuthenticationAsArmPolicyStatus": {
      "value": "enabled"
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
    "exportPolicyStatus": {
      "value": "enabled"
    },
    "location": {
      "value": "<location>"
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneResourceIds": [
            "<privateDNSResourceId>"
          ],
          "subnetResourceId": "<subnetResourceId>"
        }
      ]
    },
    "quarantinePolicyStatus": {
      "value": "enabled"
    },
    "replications": {
      "value": [
        {
          "location": "<location>",
          "name": "<name>"
        }
      ]
    },
    "softDeletePolicyDays": {
      "value": 7
    },
    "softDeletePolicyStatus": {
      "value": "disabled"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "trustPolicyStatus": {
      "value": "enabled"
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
| [`name`](#parameter-name) | string | Name of your Azure Container Registry. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`acrAdminUserEnabled`](#parameter-acradminuserenabled) | bool | Enable admin user that have push / pull permission to the registry. |
| [`acrSku`](#parameter-acrsku) | string | Tier of your Azure container registry. |
| [`anonymousPullEnabled`](#parameter-anonymouspullenabled) | bool | Enables registry-wide pull from unauthenticated clients. It's in preview and available in the Standard and Premium service tiers. |
| [`azureADAuthenticationAsArmPolicyStatus`](#parameter-azureadauthenticationasarmpolicystatus) | string | The value that indicates whether the policy for using ARM audience token for a container registr is enabled or not. Default is enabled. |
| [`cacheRules`](#parameter-cacherules) | array | Array of Cache Rules. |
| [`credentialSets`](#parameter-credentialsets) | array | Array of Credential Sets. |
| [`customerManagedKey`](#parameter-customermanagedkey) | object | The customer managed key definition. |
| [`dataEndpointEnabled`](#parameter-dataendpointenabled) | bool | Enable a single data endpoint per region for serving data. Not relevant in case of disabled public access. Note, requires the 'acrSku' to be 'Premium'. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`exportPolicyStatus`](#parameter-exportpolicystatus) | string | The value that indicates whether the export policy is enabled or not. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`networkRuleBypassOptions`](#parameter-networkrulebypassoptions) | string | Whether to allow trusted Azure services to access a network restricted registry. |
| [`networkRuleSetDefaultAction`](#parameter-networkrulesetdefaultaction) | string | The default action of allow or deny when no other rules match. |
| [`networkRuleSetIpRules`](#parameter-networkrulesetiprules) | array | The IP ACL rules. Note, requires the 'acrSku' to be 'Premium'. |
| [`privateEndpoints`](#parameter-privateendpoints) | array | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. Note, requires the 'acrSku' to be 'Premium'. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and networkRuleSetIpRules are not set.  Note, requires the 'acrSku' to be 'Premium'. |
| [`quarantinePolicyStatus`](#parameter-quarantinepolicystatus) | string | The value that indicates whether the quarantine policy is enabled or not. Note, requires the 'acrSku' to be 'Premium'. |
| [`replications`](#parameter-replications) | array | All replications to create. |
| [`retentionPolicyDays`](#parameter-retentionpolicydays) | int | The number of days to retain an untagged manifest after which it gets purged. |
| [`retentionPolicyStatus`](#parameter-retentionpolicystatus) | string | The value that indicates whether the retention policy is enabled or not. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`scopeMaps`](#parameter-scopemaps) | array | Scope maps setting. |
| [`softDeletePolicyDays`](#parameter-softdeletepolicydays) | int | The number of days after which a soft-deleted item is permanently deleted. |
| [`softDeletePolicyStatus`](#parameter-softdeletepolicystatus) | string | Soft Delete policy status. Default is disabled. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`trustPolicyStatus`](#parameter-trustpolicystatus) | string | The value that indicates whether the trust policy is enabled or not. Note, requires the 'acrSku' to be 'Premium'. |
| [`webhooks`](#parameter-webhooks) | array | All webhooks to create. |
| [`zoneRedundancy`](#parameter-zoneredundancy) | string | Whether or not zone redundancy is enabled for this container registry. |

### Parameter: `name`

Name of your Azure Container Registry.

- Required: Yes
- Type: string

### Parameter: `acrAdminUserEnabled`

Enable admin user that have push / pull permission to the registry.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `acrSku`

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

### Parameter: `anonymousPullEnabled`

Enables registry-wide pull from unauthenticated clients. It's in preview and available in the Standard and Premium service tiers.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `azureADAuthenticationAsArmPolicyStatus`

The value that indicates whether the policy for using ARM audience token for a container registr is enabled or not. Default is enabled.

- Required: No
- Type: string
- Default: `'enabled'`
- Allowed:
  ```Bicep
  [
    'disabled'
    'enabled'
  ]
  ```

### Parameter: `cacheRules`

Array of Cache Rules.

- Required: No
- Type: array

### Parameter: `credentialSets`

Array of Credential Sets.

- Required: No
- Type: array
- Default: `[]`

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
| [`keyVersion`](#parameter-customermanagedkeykeyversion) | string | The version of the customer managed key to reference for encryption. If not provided, using 'latest'. |
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

The version of the customer managed key to reference for encryption. If not provided, using 'latest'.

- Required: No
- Type: string

### Parameter: `customerManagedKey.userAssignedIdentityResourceId`

User assigned identity to use when fetching the customer managed key. Required if no system assigned identity is available for use.

- Required: No
- Type: string

### Parameter: `dataEndpointEnabled`

Enable a single data endpoint per region for serving data. Not relevant in case of disabled public access. Note, requires the 'acrSku' to be 'Premium'.

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

### Parameter: `exportPolicyStatus`

The value that indicates whether the export policy is enabled or not.

- Required: No
- Type: string
- Default: `'disabled'`
- Allowed:
  ```Bicep
  [
    'disabled'
    'enabled'
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

### Parameter: `networkRuleBypassOptions`

Whether to allow trusted Azure services to access a network restricted registry.

- Required: No
- Type: string
- Default: `'AzureServices'`
- Allowed:
  ```Bicep
  [
    'AzureServices'
    'None'
  ]
  ```

### Parameter: `networkRuleSetDefaultAction`

The default action of allow or deny when no other rules match.

- Required: No
- Type: string
- Default: `'Deny'`
- Allowed:
  ```Bicep
  [
    'Allow'
    'Deny'
  ]
  ```

### Parameter: `networkRuleSetIpRules`

The IP ACL rules. Note, requires the 'acrSku' to be 'Premium'.

- Required: No
- Type: array

### Parameter: `privateEndpoints`

Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. Note, requires the 'acrSku' to be 'Premium'.

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
| [`privateLinkServiceConnectionName`](#parameter-privateendpointsprivatelinkserviceconnectionname) | string | The name of the private link connection to create. |
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

### Parameter: `privateEndpoints.privateLinkServiceConnectionName`

The name of the private link connection to create.

- Required: No
- Type: string

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

The subresource to deploy the private endpoint for. For example "vault", "mysqlServer" or "dataFactory".

- Required: No
- Type: string

### Parameter: `privateEndpoints.tags`

Tags to be applied on all resources/resource groups in this deployment.

- Required: No
- Type: object

### Parameter: `publicNetworkAccess`

Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and networkRuleSetIpRules are not set.  Note, requires the 'acrSku' to be 'Premium'.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `quarantinePolicyStatus`

The value that indicates whether the quarantine policy is enabled or not. Note, requires the 'acrSku' to be 'Premium'.

- Required: No
- Type: string
- Default: `'disabled'`
- Allowed:
  ```Bicep
  [
    'disabled'
    'enabled'
  ]
  ```

### Parameter: `replications`

All replications to create.

- Required: No
- Type: array

### Parameter: `retentionPolicyDays`

The number of days to retain an untagged manifest after which it gets purged.

- Required: No
- Type: int
- Default: `15`

### Parameter: `retentionPolicyStatus`

The value that indicates whether the retention policy is enabled or not.

- Required: No
- Type: string
- Default: `'enabled'`
- Allowed:
  ```Bicep
  [
    'disabled'
    'enabled'
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

### Parameter: `scopeMaps`

Scope maps setting.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`actions`](#parameter-scopemapsactions) | array | The list of scoped permissions for registry artifacts. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-scopemapsdescription) | string | The user friendly description of the scope map. |
| [`name`](#parameter-scopemapsname) | string | The name of the scope map. |

### Parameter: `scopeMaps.actions`

The list of scoped permissions for registry artifacts.

- Required: Yes
- Type: array

### Parameter: `scopeMaps.description`

The user friendly description of the scope map.

- Required: No
- Type: string

### Parameter: `scopeMaps.name`

The name of the scope map.

- Required: No
- Type: string

### Parameter: `softDeletePolicyDays`

The number of days after which a soft-deleted item is permanently deleted.

- Required: No
- Type: int
- Default: `7`

### Parameter: `softDeletePolicyStatus`

Soft Delete policy status. Default is disabled.

- Required: No
- Type: string
- Default: `'disabled'`
- Allowed:
  ```Bicep
  [
    'disabled'
    'enabled'
  ]
  ```

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `trustPolicyStatus`

The value that indicates whether the trust policy is enabled or not. Note, requires the 'acrSku' to be 'Premium'.

- Required: No
- Type: string
- Default: `'disabled'`
- Allowed:
  ```Bicep
  [
    'disabled'
    'enabled'
  ]
  ```

### Parameter: `webhooks`

All webhooks to create.

- Required: No
- Type: array

### Parameter: `zoneRedundancy`

Whether or not zone redundancy is enabled for this container registry.

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


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `credentialSetsResourceIds` | array | The Resource IDs of the ACR Credential Sets. |
| `credentialSetsSystemAssignedMIPrincipalIds` | array | The Principal IDs of the ACR Credential Sets system-assigned identities. |
| `location` | string | The location the resource was deployed into. |
| `loginServer` | string | The reference to the Azure container registry. |
| `name` | string | The Name of the Azure container registry. |
| `resourceGroupName` | string | The name of the Azure container registry. |
| `resourceId` | string | The resource ID of the Azure container registry. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/network/private-endpoint:0.4.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
