# Machine Learning Services Workspaces `[Microsoft.MachineLearningServices/workspaces]`

This module deploys a Machine Learning Services Workspace.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Notes](#Notes)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.MachineLearningServices/workspaces` | [2024-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.MachineLearningServices/2024-10-01-preview/workspaces) |
| `Microsoft.MachineLearningServices/workspaces/computes` | [2024-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.MachineLearningServices/2024-10-01/workspaces/computes) |
| `Microsoft.MachineLearningServices/workspaces/connections` | [2024-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.MachineLearningServices/2024-10-01/workspaces/connections) |
| `Microsoft.MachineLearningServices/workspaces/datastores` | [2024-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.MachineLearningServices/2024-10-01/workspaces/datastores) |
| `Microsoft.Network/privateEndpoints` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints/privateDnsZoneGroups) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/machine-learning-services/workspace:<version>`.

- [Creating Azure AI Studio resources](#example-1-creating-azure-ai-studio-resources)
- [Using only defaults](#example-2-using-only-defaults)
- [Using Customer-Managed-Keys with User-Assigned identity](#example-3-using-customer-managed-keys-with-user-assigned-identity)
- [Creating Azure ML managed feature store](#example-4-creating-azure-ml-managed-feature-store)
- [Using large parameter set](#example-5-using-large-parameter-set)
- [WAF-aligned](#example-6-waf-aligned)

### Example 1: _Creating Azure AI Studio resources_

This instance deploys an Azure AI hub workspace.


<details>

<summary>via Bicep module</summary>

```bicep
module workspace 'br/public:avm/res/machine-learning-services/workspace:<version>' = {
  name: 'workspaceDeployment'
  params: {
    // Required parameters
    name: 'mlswai001'
    sku: 'Basic'
    // Non-required parameters
    associatedApplicationInsightsResourceId: '<associatedApplicationInsightsResourceId>'
    associatedKeyVaultResourceId: '<associatedKeyVaultResourceId>'
    associatedStorageAccountResourceId: '<associatedStorageAccountResourceId>'
    connections: [
      {
        category: 'AIServices'
        connectionProperties: {
          authType: 'ApiKey'
          credentials: {
            key: 'key'
          }
        }
        metadata: {
          ApiType: 'Azure'
          ApiVersion: '2023-07-01-preview'
          DeploymentApiVersion: '2023-10-01-preview'
          Location: '<Location>'
          ResourceId: '<ResourceId>'
        }
        name: 'ai'
        target: '<target>'
      }
    ]
    kind: 'Hub'
    location: '<location>'
    workspaceHubConfig: {
      additionalWorkspaceStorageAccounts: '<additionalWorkspaceStorageAccounts>'
      defaultWorkspaceResourceGroup: '<defaultWorkspaceResourceGroup>'
    }
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
    "name": {
      "value": "mlswai001"
    },
    "sku": {
      "value": "Basic"
    },
    // Non-required parameters
    "associatedApplicationInsightsResourceId": {
      "value": "<associatedApplicationInsightsResourceId>"
    },
    "associatedKeyVaultResourceId": {
      "value": "<associatedKeyVaultResourceId>"
    },
    "associatedStorageAccountResourceId": {
      "value": "<associatedStorageAccountResourceId>"
    },
    "connections": {
      "value": [
        {
          "category": "AIServices",
          "connectionProperties": {
            "authType": "ApiKey",
            "credentials": {
              "key": "key"
            }
          },
          "metadata": {
            "ApiType": "Azure",
            "ApiVersion": "2023-07-01-preview",
            "DeploymentApiVersion": "2023-10-01-preview",
            "Location": "<Location>",
            "ResourceId": "<ResourceId>"
          },
          "name": "ai",
          "target": "<target>"
        }
      ]
    },
    "kind": {
      "value": "Hub"
    },
    "location": {
      "value": "<location>"
    },
    "workspaceHubConfig": {
      "value": {
        "additionalWorkspaceStorageAccounts": "<additionalWorkspaceStorageAccounts>",
        "defaultWorkspaceResourceGroup": "<defaultWorkspaceResourceGroup>"
      }
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/machine-learning-services/workspace:<version>'

// Required parameters
param name = 'mlswai001'
param sku = 'Basic'
// Non-required parameters
param associatedApplicationInsightsResourceId = '<associatedApplicationInsightsResourceId>'
param associatedKeyVaultResourceId = '<associatedKeyVaultResourceId>'
param associatedStorageAccountResourceId = '<associatedStorageAccountResourceId>'
param connections = [
  {
    category: 'AIServices'
    connectionProperties: {
      authType: 'ApiKey'
      credentials: {
        key: 'key'
      }
    }
    metadata: {
      ApiType: 'Azure'
      ApiVersion: '2023-07-01-preview'
      DeploymentApiVersion: '2023-10-01-preview'
      Location: '<Location>'
      ResourceId: '<ResourceId>'
    }
    name: 'ai'
    target: '<target>'
  }
]
param kind = 'Hub'
param location = '<location>'
param workspaceHubConfig = {
  additionalWorkspaceStorageAccounts: '<additionalWorkspaceStorageAccounts>'
  defaultWorkspaceResourceGroup: '<defaultWorkspaceResourceGroup>'
}
```

</details>
<p>

### Example 2: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module workspace 'br/public:avm/res/machine-learning-services/workspace:<version>' = {
  name: 'workspaceDeployment'
  params: {
    // Required parameters
    name: 'mlswmin001'
    sku: 'Basic'
    // Non-required parameters
    associatedApplicationInsightsResourceId: '<associatedApplicationInsightsResourceId>'
    associatedKeyVaultResourceId: '<associatedKeyVaultResourceId>'
    associatedStorageAccountResourceId: '<associatedStorageAccountResourceId>'
    location: '<location>'
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
    "name": {
      "value": "mlswmin001"
    },
    "sku": {
      "value": "Basic"
    },
    // Non-required parameters
    "associatedApplicationInsightsResourceId": {
      "value": "<associatedApplicationInsightsResourceId>"
    },
    "associatedKeyVaultResourceId": {
      "value": "<associatedKeyVaultResourceId>"
    },
    "associatedStorageAccountResourceId": {
      "value": "<associatedStorageAccountResourceId>"
    },
    "location": {
      "value": "<location>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/machine-learning-services/workspace:<version>'

// Required parameters
param name = 'mlswmin001'
param sku = 'Basic'
// Non-required parameters
param associatedApplicationInsightsResourceId = '<associatedApplicationInsightsResourceId>'
param associatedKeyVaultResourceId = '<associatedKeyVaultResourceId>'
param associatedStorageAccountResourceId = '<associatedStorageAccountResourceId>'
param location = '<location>'
```

</details>
<p>

### Example 3: _Using Customer-Managed-Keys with User-Assigned identity_

This instance deploys the module using Customer-Managed-Keys using a User-Assigned Identity to access the Customer-Managed-Key secret.


<details>

<summary>via Bicep module</summary>

```bicep
module workspace 'br/public:avm/res/machine-learning-services/workspace:<version>' = {
  name: 'workspaceDeployment'
  params: {
    // Required parameters
    name: 'mlswecr001'
    sku: 'Basic'
    // Non-required parameters
    associatedApplicationInsightsResourceId: '<associatedApplicationInsightsResourceId>'
    associatedKeyVaultResourceId: '<associatedKeyVaultResourceId>'
    associatedStorageAccountResourceId: '<associatedStorageAccountResourceId>'
    customerManagedKey: {
      keyName: '<keyName>'
      keyVaultResourceId: '<keyVaultResourceId>'
      userAssignedIdentityResourceId: '<userAssignedIdentityResourceId>'
    }
    location: '<location>'
    managedIdentities: {
      systemAssigned: false
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    managedNetworkSettings: {
      firewallSku: 'Basic'
      isolationMode: 'AllowInternetOutbound'
      outboundRules: {
        rule: {
          category: 'UserDefined'
          destination: {
            serviceResourceId: '<serviceResourceId>'
            subresourceTarget: 'blob'
          }
          type: 'PrivateEndpoint'
        }
      }
    }
    primaryUserAssignedIdentity: '<primaryUserAssignedIdentity>'
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
    "name": {
      "value": "mlswecr001"
    },
    "sku": {
      "value": "Basic"
    },
    // Non-required parameters
    "associatedApplicationInsightsResourceId": {
      "value": "<associatedApplicationInsightsResourceId>"
    },
    "associatedKeyVaultResourceId": {
      "value": "<associatedKeyVaultResourceId>"
    },
    "associatedStorageAccountResourceId": {
      "value": "<associatedStorageAccountResourceId>"
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
        "systemAssigned": false,
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "managedNetworkSettings": {
      "value": {
        "firewallSku": "Basic",
        "isolationMode": "AllowInternetOutbound",
        "outboundRules": {
          "rule": {
            "category": "UserDefined",
            "destination": {
              "serviceResourceId": "<serviceResourceId>",
              "subresourceTarget": "blob"
            },
            "type": "PrivateEndpoint"
          }
        }
      }
    },
    "primaryUserAssignedIdentity": {
      "value": "<primaryUserAssignedIdentity>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/machine-learning-services/workspace:<version>'

// Required parameters
param name = 'mlswecr001'
param sku = 'Basic'
// Non-required parameters
param associatedApplicationInsightsResourceId = '<associatedApplicationInsightsResourceId>'
param associatedKeyVaultResourceId = '<associatedKeyVaultResourceId>'
param associatedStorageAccountResourceId = '<associatedStorageAccountResourceId>'
param customerManagedKey = {
  keyName: '<keyName>'
  keyVaultResourceId: '<keyVaultResourceId>'
  userAssignedIdentityResourceId: '<userAssignedIdentityResourceId>'
}
param location = '<location>'
param managedIdentities = {
  systemAssigned: false
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param managedNetworkSettings = {
  firewallSku: 'Basic'
  isolationMode: 'AllowInternetOutbound'
  outboundRules: {
    rule: {
      category: 'UserDefined'
      destination: {
        serviceResourceId: '<serviceResourceId>'
        subresourceTarget: 'blob'
      }
      type: 'PrivateEndpoint'
    }
  }
}
param primaryUserAssignedIdentity = '<primaryUserAssignedIdentity>'
```

</details>
<p>

### Example 4: _Creating Azure ML managed feature store_

This instance deploys an Azure ML managed feature store.


<details>

<summary>via Bicep module</summary>

```bicep
module workspace 'br/public:avm/res/machine-learning-services/workspace:<version>' = {
  name: 'workspaceDeployment'
  params: {
    // Required parameters
    name: 'mlswfs001'
    sku: 'Basic'
    // Non-required parameters
    associatedApplicationInsightsResourceId: '<associatedApplicationInsightsResourceId>'
    associatedKeyVaultResourceId: '<associatedKeyVaultResourceId>'
    associatedStorageAccountResourceId: '<associatedStorageAccountResourceId>'
    featureStoreSettings: {
      computeRuntime: {
        sparkRuntimeVersion: '3.3'
      }
    }
    kind: 'FeatureStore'
    location: '<location>'
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
    "name": {
      "value": "mlswfs001"
    },
    "sku": {
      "value": "Basic"
    },
    // Non-required parameters
    "associatedApplicationInsightsResourceId": {
      "value": "<associatedApplicationInsightsResourceId>"
    },
    "associatedKeyVaultResourceId": {
      "value": "<associatedKeyVaultResourceId>"
    },
    "associatedStorageAccountResourceId": {
      "value": "<associatedStorageAccountResourceId>"
    },
    "featureStoreSettings": {
      "value": {
        "computeRuntime": {
          "sparkRuntimeVersion": "3.3"
        }
      }
    },
    "kind": {
      "value": "FeatureStore"
    },
    "location": {
      "value": "<location>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/machine-learning-services/workspace:<version>'

// Required parameters
param name = 'mlswfs001'
param sku = 'Basic'
// Non-required parameters
param associatedApplicationInsightsResourceId = '<associatedApplicationInsightsResourceId>'
param associatedKeyVaultResourceId = '<associatedKeyVaultResourceId>'
param associatedStorageAccountResourceId = '<associatedStorageAccountResourceId>'
param featureStoreSettings = {
  computeRuntime: {
    sparkRuntimeVersion: '3.3'
  }
}
param kind = 'FeatureStore'
param location = '<location>'
```

</details>
<p>

### Example 5: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module workspace 'br/public:avm/res/machine-learning-services/workspace:<version>' = {
  name: 'workspaceDeployment'
  params: {
    // Required parameters
    name: 'mlswmax001'
    sku: 'Premium'
    // Non-required parameters
    associatedApplicationInsightsResourceId: '<associatedApplicationInsightsResourceId>'
    associatedKeyVaultResourceId: '<associatedKeyVaultResourceId>'
    associatedStorageAccountResourceId: '<associatedStorageAccountResourceId>'
    computes: [
      {
        computeLocation: '<computeLocation>'
        computeType: 'AmlCompute'
        description: 'Default CPU Cluster'
        disableLocalAuth: false
        location: '<location>'
        managedIdentities: {
          systemAssigned: false
          userAssignedResourceIds: [
            '<managedIdentityResourceId>'
          ]
        }
        name: 'DefaultCPU'
        properties: {
          enableNodePublicIp: true
          isolatedNetwork: false
          osType: 'Linux'
          remoteLoginPortPublicAccess: 'Disabled'
          scaleSettings: {
            maxNodeCount: 3
            minNodeCount: 0
            nodeIdleTimeBeforeScaleDown: 'PT5M'
          }
          vmPriority: 'Dedicated'
          vmSize: 'STANDARD_DS11_V2'
        }
        sku: 'Basic'
      }
    ]
    connections: [
      {
        category: 'ApiKey'
        connectionProperties: {
          authType: 'ApiKey'
          credentials: {
            key: 'key'
          }
        }
        name: 'connection'
        target: 'https://example.com'
      }
    ]
    datastores: [
      {
        name: 'datastore'
        properties: {
          accountName: 'myaccount'
          containerName: 'my-container'
          credentials: {
            credentialsType: 'None'
          }
          datastoreType: 'AzureBlob'
          endpoint: '<endpoint>'
          protocol: 'https'
          resourceGroup: '<resourceGroup>'
          serviceDataAccessAuthIdentity: 'None'
          subscriptionId: '<subscriptionId>'
        }
      }
    ]
    description: 'The cake is a lie.'
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
    discoveryUrl: 'http://example.com'
    friendlyName: 'Workspace'
    imageBuildCompute: 'testcompute'
    ipAllowlist: [
      '1.2.3.4/32'
    ]
    kind: 'Default'
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    managedIdentities: {
      systemAssigned: false
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    managedNetworkSettings: {
      isolationMode: 'Disabled'
    }
    primaryUserAssignedIdentity: '<primaryUserAssignedIdentity>'
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          name: 'group1'
          privateDnsZoneGroupConfigs: [
            {
              name: 'config1'
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
      {
        privateDnsZoneGroup: {
          name: 'group2'
          privateDnsZoneGroupConfigs: [
            {
              name: 'config2'
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        subnetResourceId: '<subnetResourceId>'
      }
    ]
    provisionNetworkNow: true
    roleAssignments: [
      {
        name: 'f9b5b0d9-f27e-4c89-bacf-1bbc4a99dbce'
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
    serverlessComputeSettings: {
      serverlessComputeCustomSubnet: '<serverlessComputeCustomSubnet>'
      serverlessComputeNoPublicIP: true
    }
    systemDatastoresAuthMode: 'AccessKey'
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

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "mlswmax001"
    },
    "sku": {
      "value": "Premium"
    },
    // Non-required parameters
    "associatedApplicationInsightsResourceId": {
      "value": "<associatedApplicationInsightsResourceId>"
    },
    "associatedKeyVaultResourceId": {
      "value": "<associatedKeyVaultResourceId>"
    },
    "associatedStorageAccountResourceId": {
      "value": "<associatedStorageAccountResourceId>"
    },
    "computes": {
      "value": [
        {
          "computeLocation": "<computeLocation>",
          "computeType": "AmlCompute",
          "description": "Default CPU Cluster",
          "disableLocalAuth": false,
          "location": "<location>",
          "managedIdentities": {
            "systemAssigned": false,
            "userAssignedResourceIds": [
              "<managedIdentityResourceId>"
            ]
          },
          "name": "DefaultCPU",
          "properties": {
            "enableNodePublicIp": true,
            "isolatedNetwork": false,
            "osType": "Linux",
            "remoteLoginPortPublicAccess": "Disabled",
            "scaleSettings": {
              "maxNodeCount": 3,
              "minNodeCount": 0,
              "nodeIdleTimeBeforeScaleDown": "PT5M"
            },
            "vmPriority": "Dedicated",
            "vmSize": "STANDARD_DS11_V2"
          },
          "sku": "Basic"
        }
      ]
    },
    "connections": {
      "value": [
        {
          "category": "ApiKey",
          "connectionProperties": {
            "authType": "ApiKey",
            "credentials": {
              "key": "key"
            }
          },
          "name": "connection",
          "target": "https://example.com"
        }
      ]
    },
    "datastores": {
      "value": [
        {
          "name": "datastore",
          "properties": {
            "accountName": "myaccount",
            "containerName": "my-container",
            "credentials": {
              "credentialsType": "None"
            },
            "datastoreType": "AzureBlob",
            "endpoint": "<endpoint>",
            "protocol": "https",
            "resourceGroup": "<resourceGroup>",
            "serviceDataAccessAuthIdentity": "None",
            "subscriptionId": "<subscriptionId>"
          }
        }
      ]
    },
    "description": {
      "value": "The cake is a lie."
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
    "discoveryUrl": {
      "value": "http://example.com"
    },
    "friendlyName": {
      "value": "Workspace"
    },
    "imageBuildCompute": {
      "value": "testcompute"
    },
    "ipAllowlist": {
      "value": [
        "1.2.3.4/32"
      ]
    },
    "kind": {
      "value": "Default"
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
        "systemAssigned": false,
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "managedNetworkSettings": {
      "value": {
        "isolationMode": "Disabled"
      }
    },
    "primaryUserAssignedIdentity": {
      "value": "<primaryUserAssignedIdentity>"
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "name": "group1",
            "privateDnsZoneGroupConfigs": [
              {
                "name": "config1",
                "privateDnsZoneResourceId": "<privateDnsZoneResourceId>"
              }
            ]
          },
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        },
        {
          "privateDnsZoneGroup": {
            "name": "group2",
            "privateDnsZoneGroupConfigs": [
              {
                "name": "config2",
                "privateDnsZoneResourceId": "<privateDnsZoneResourceId>"
              }
            ]
          },
          "subnetResourceId": "<subnetResourceId>"
        }
      ]
    },
    "provisionNetworkNow": {
      "value": true
    },
    "roleAssignments": {
      "value": [
        {
          "name": "f9b5b0d9-f27e-4c89-bacf-1bbc4a99dbce",
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
    "serverlessComputeSettings": {
      "value": {
        "serverlessComputeCustomSubnet": "<serverlessComputeCustomSubnet>",
        "serverlessComputeNoPublicIP": true
      }
    },
    "systemDatastoresAuthMode": {
      "value": "AccessKey"
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/machine-learning-services/workspace:<version>'

// Required parameters
param name = 'mlswmax001'
param sku = 'Premium'
// Non-required parameters
param associatedApplicationInsightsResourceId = '<associatedApplicationInsightsResourceId>'
param associatedKeyVaultResourceId = '<associatedKeyVaultResourceId>'
param associatedStorageAccountResourceId = '<associatedStorageAccountResourceId>'
param computes = [
  {
    computeLocation: '<computeLocation>'
    computeType: 'AmlCompute'
    description: 'Default CPU Cluster'
    disableLocalAuth: false
    location: '<location>'
    managedIdentities: {
      systemAssigned: false
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    name: 'DefaultCPU'
    properties: {
      enableNodePublicIp: true
      isolatedNetwork: false
      osType: 'Linux'
      remoteLoginPortPublicAccess: 'Disabled'
      scaleSettings: {
        maxNodeCount: 3
        minNodeCount: 0
        nodeIdleTimeBeforeScaleDown: 'PT5M'
      }
      vmPriority: 'Dedicated'
      vmSize: 'STANDARD_DS11_V2'
    }
    sku: 'Basic'
  }
]
param connections = [
  {
    category: 'ApiKey'
    connectionProperties: {
      authType: 'ApiKey'
      credentials: {
        key: 'key'
      }
    }
    name: 'connection'
    target: 'https://example.com'
  }
]
param datastores = [
  {
    name: 'datastore'
    properties: {
      accountName: 'myaccount'
      containerName: 'my-container'
      credentials: {
        credentialsType: 'None'
      }
      datastoreType: 'AzureBlob'
      endpoint: '<endpoint>'
      protocol: 'https'
      resourceGroup: '<resourceGroup>'
      serviceDataAccessAuthIdentity: 'None'
      subscriptionId: '<subscriptionId>'
    }
  }
]
param description = 'The cake is a lie.'
param diagnosticSettings = [
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
param discoveryUrl = 'http://example.com'
param friendlyName = 'Workspace'
param imageBuildCompute = 'testcompute'
param ipAllowlist = [
  '1.2.3.4/32'
]
param kind = 'Default'
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param managedIdentities = {
  systemAssigned: false
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param managedNetworkSettings = {
  isolationMode: 'Disabled'
}
param primaryUserAssignedIdentity = '<primaryUserAssignedIdentity>'
param privateEndpoints = [
  {
    privateDnsZoneGroup: {
      name: 'group1'
      privateDnsZoneGroupConfigs: [
        {
          name: 'config1'
          privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
        }
      ]
    }
    subnetResourceId: '<subnetResourceId>'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
  }
  {
    privateDnsZoneGroup: {
      name: 'group2'
      privateDnsZoneGroupConfigs: [
        {
          name: 'config2'
          privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
        }
      ]
    }
    subnetResourceId: '<subnetResourceId>'
  }
]
param provisionNetworkNow = true
param roleAssignments = [
  {
    name: 'f9b5b0d9-f27e-4c89-bacf-1bbc4a99dbce'
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
param serverlessComputeSettings = {
  serverlessComputeCustomSubnet: '<serverlessComputeCustomSubnet>'
  serverlessComputeNoPublicIP: true
}
param systemDatastoresAuthMode = 'AccessKey'
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
```

</details>
<p>

### Example 6: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module workspace 'br/public:avm/res/machine-learning-services/workspace:<version>' = {
  name: 'workspaceDeployment'
  params: {
    // Required parameters
    name: 'mlswwaf001'
    sku: 'Standard'
    // Non-required parameters
    associatedApplicationInsightsResourceId: '<associatedApplicationInsightsResourceId>'
    associatedKeyVaultResourceId: '<associatedKeyVaultResourceId>'
    associatedStorageAccountResourceId: '<associatedStorageAccountResourceId>'
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    location: '<location>'
    managedNetworkSettings: {
      firewallSku: 'Standard'
      isolationMode: 'AllowOnlyApprovedOutbound'
      outboundRules: {
        rule1: {
          category: 'UserDefined'
          destination: {
            serviceResourceId: '<serviceResourceId>'
            sparkEnabled: true
            subresourceTarget: 'blob'
          }
          type: 'PrivateEndpoint'
        }
        rule2: {
          category: 'UserDefined'
          destination: 'pypi.org'
          type: 'FQDN'
        }
        rule3: {
          category: 'UserDefined'
          destination: {
            portRanges: '80,443'
            protocol: 'TCP'
            serviceTag: 'AppService'
          }
          type: 'ServiceTag'
        }
      }
    }
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
    ]
    systemDatastoresAuthMode: 'Identity'
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

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "mlswwaf001"
    },
    "sku": {
      "value": "Standard"
    },
    // Non-required parameters
    "associatedApplicationInsightsResourceId": {
      "value": "<associatedApplicationInsightsResourceId>"
    },
    "associatedKeyVaultResourceId": {
      "value": "<associatedKeyVaultResourceId>"
    },
    "associatedStorageAccountResourceId": {
      "value": "<associatedStorageAccountResourceId>"
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
    "managedNetworkSettings": {
      "value": {
        "firewallSku": "Standard",
        "isolationMode": "AllowOnlyApprovedOutbound",
        "outboundRules": {
          "rule1": {
            "category": "UserDefined",
            "destination": {
              "serviceResourceId": "<serviceResourceId>",
              "sparkEnabled": true,
              "subresourceTarget": "blob"
            },
            "type": "PrivateEndpoint"
          },
          "rule2": {
            "category": "UserDefined",
            "destination": "pypi.org",
            "type": "FQDN"
          },
          "rule3": {
            "category": "UserDefined",
            "destination": {
              "portRanges": "80,443",
              "protocol": "TCP",
              "serviceTag": "AppService"
            },
            "type": "ServiceTag"
          }
        }
      }
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDnsZoneGroupConfigs": [
              {
                "privateDnsZoneResourceId": "<privateDnsZoneResourceId>"
              }
            ]
          },
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        }
      ]
    },
    "systemDatastoresAuthMode": {
      "value": "Identity"
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/machine-learning-services/workspace:<version>'

// Required parameters
param name = 'mlswwaf001'
param sku = 'Standard'
// Non-required parameters
param associatedApplicationInsightsResourceId = '<associatedApplicationInsightsResourceId>'
param associatedKeyVaultResourceId = '<associatedKeyVaultResourceId>'
param associatedStorageAccountResourceId = '<associatedStorageAccountResourceId>'
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param location = '<location>'
param managedNetworkSettings = {
  firewallSku: 'Standard'
  isolationMode: 'AllowOnlyApprovedOutbound'
  outboundRules: {
    rule1: {
      category: 'UserDefined'
      destination: {
        serviceResourceId: '<serviceResourceId>'
        sparkEnabled: true
        subresourceTarget: 'blob'
      }
      type: 'PrivateEndpoint'
    }
    rule2: {
      category: 'UserDefined'
      destination: 'pypi.org'
      type: 'FQDN'
    }
    rule3: {
      category: 'UserDefined'
      destination: {
        portRanges: '80,443'
        protocol: 'TCP'
        serviceTag: 'AppService'
      }
      type: 'ServiceTag'
    }
  }
}
param privateEndpoints = [
  {
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        {
          privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
        }
      ]
    }
    subnetResourceId: '<subnetResourceId>'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
  }
]
param systemDatastoresAuthMode = 'Identity'
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
```

</details>
<p>

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
| [`featureStoreSettings`](#parameter-featurestoresettings) | object | Settings for feature store type workspaces. Required if 'kind' is set to 'FeatureStore'. |
| [`hubResourceId`](#parameter-hubresourceid) | string | The resource ID of the hub to associate with the workspace. Required if 'kind' is set to 'Project'. |
| [`primaryUserAssignedIdentity`](#parameter-primaryuserassignedidentity) | string | The user assigned identity resource ID that represents the workspace identity. Required if 'userAssignedIdentities' is not empty and may not be used if 'systemAssignedIdentity' is enabled. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`associatedContainerRegistryResourceId`](#parameter-associatedcontainerregistryresourceid) | string | The resource ID of the associated Container Registry. |
| [`computes`](#parameter-computes) | array | Computes to create respectively attach to the workspace. |
| [`connections`](#parameter-connections) | array | Connections to create in the workspace. |
| [`customerManagedKey`](#parameter-customermanagedkey) | object | The customer managed key definition. |
| [`datastores`](#parameter-datastores) | array | Datastores to create in the workspace. |
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
| [`managedNetworkSettings`](#parameter-managednetworksettings) | object | Managed Network settings for a machine learning workspace. |
| [`privateEndpoints`](#parameter-privateendpoints) | array | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| [`provisionNetworkNow`](#parameter-provisionnetworknow) | bool | Trigger the provisioning of the managed virtual network when creating the workspace. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Whether or not public network access is allowed for this resource. For security reasons it should be disabled. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`serverlessComputeSettings`](#parameter-serverlesscomputesettings) | object | Settings for serverless compute created in the workspace. |
| [`serviceManagedResourcesSettings`](#parameter-servicemanagedresourcessettings) | object | The service managed resource settings. |
| [`sharedPrivateLinkResources`](#parameter-sharedprivatelinkresources) | array | The list of shared private link resources in this workspace. Note: This property is not idempotent. |
| [`systemDatastoresAuthMode`](#parameter-systemdatastoresauthmode) | string | The authentication mode used by the workspace when connecting to the default storage account. |
| [`tags`](#parameter-tags) | object | Resource tags. |
| [`workspaceHubConfig`](#parameter-workspacehubconfig) | object | Configuration for workspace hub settings. |

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

### Parameter: `featureStoreSettings`

Settings for feature store type workspaces. Required if 'kind' is set to 'FeatureStore'.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`computeRuntime`](#parameter-featurestoresettingscomputeruntime) | object | Compute runtime config for feature store type workspace. |
| [`offlineStoreConnectionName`](#parameter-featurestoresettingsofflinestoreconnectionname) | string | The offline store connection name. |
| [`onlineStoreConnectionName`](#parameter-featurestoresettingsonlinestoreconnectionname) | string | The online store connection name. |

### Parameter: `featureStoreSettings.computeRuntime`

Compute runtime config for feature store type workspace.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`sparkRuntimeVersion`](#parameter-featurestoresettingscomputeruntimesparkruntimeversion) | string | The spark runtime version. |

### Parameter: `featureStoreSettings.computeRuntime.sparkRuntimeVersion`

The spark runtime version.

- Required: No
- Type: string

### Parameter: `featureStoreSettings.offlineStoreConnectionName`

The offline store connection name.

- Required: No
- Type: string

### Parameter: `featureStoreSettings.onlineStoreConnectionName`

The online store connection name.

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

### Parameter: `computes`

Computes to create respectively attach to the workspace.

- Required: No
- Type: array

### Parameter: `connections`

Connections to create in the workspace.

- Required: No
- Type: array
- Default: `[]`

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
| [`AccountKey`](#variant-connectionsconnectionpropertiesauthtype-accountkey) | The connection properties when the auth type is AccountKey. |
| [`ApiKey`](#variant-connectionsconnectionpropertiesauthtype-apikey) | The connection properties when the auth type is ApiKey. |
| [`CustomKeys`](#variant-connectionsconnectionpropertiesauthtype-customkeys) | The connection properties when the auth type are CustomKeys. |
| [`ManagedIdentity`](#variant-connectionsconnectionpropertiesauthtype-managedidentity) | The connection properties when the auth type is ManagedIdentity. |
| [`None`](#variant-connectionsconnectionpropertiesauthtype-none) | The connection properties when the auth type is None. |
| [`OAuth2`](#variant-connectionsconnectionpropertiesauthtype-oauth2) | The connection properties when the auth type is OAuth2. |
| [`PAT`](#variant-connectionsconnectionpropertiesauthtype-pat) | The connection properties when the auth type is PAT. |
| [`SAS`](#variant-connectionsconnectionpropertiesauthtype-sas) | The connection properties when the auth type is SAS. |
| [`ServicePrincipal`](#variant-connectionsconnectionpropertiesauthtype-serviceprincipal) | The connection properties when the auth type is ServicePrincipal. |
| [`UsernamePassword`](#variant-connectionsconnectionpropertiesauthtype-usernamepassword) | The connection properties when the auth type is UsernamePassword. |

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

### Variant: `connections.connectionProperties.authType-AccountKey`
The connection properties when the auth type is AccountKey.

To use this variant, set the property `authType` to `AccountKey`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authType`](#parameter-connectionsconnectionpropertiesauthtype-accountkeyauthtype) | string | The authentication type of the connection target. |
| [`credentials`](#parameter-connectionsconnectionpropertiesauthtype-accountkeycredentials) | object | The credentials for the connection. |

### Parameter: `connections.connectionProperties.authType-AccountKey.authType`

The authentication type of the connection target.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AccountKey'
  ]
  ```

### Parameter: `connections.connectionProperties.authType-AccountKey.credentials`

The credentials for the connection.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`key`](#parameter-connectionsconnectionpropertiesauthtype-accountkeycredentialskey) | string | The connection key. |

### Parameter: `connections.connectionProperties.authType-AccountKey.credentials.key`

The connection key.

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

### Variant: `connections.connectionProperties.authType-CustomKeys`
The connection properties when the auth type are CustomKeys.

To use this variant, set the property `authType` to `CustomKeys`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authType`](#parameter-connectionsconnectionpropertiesauthtype-customkeysauthtype) | string | The authentication type of the connection target. |
| [`credentials`](#parameter-connectionsconnectionpropertiesauthtype-customkeyscredentials) | object | The credentials for the connection. |

### Parameter: `connections.connectionProperties.authType-CustomKeys.authType`

The authentication type of the connection target.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'CustomKeys'
  ]
  ```

### Parameter: `connections.connectionProperties.authType-CustomKeys.credentials`

The credentials for the connection.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keys`](#parameter-connectionsconnectionpropertiesauthtype-customkeyscredentialskeys) | object | The custom keys for the connection. |

### Parameter: `connections.connectionProperties.authType-CustomKeys.credentials.keys`

The custom keys for the connection.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`>Any_other_property<`](#parameter-connectionsconnectionpropertiesauthtype-customkeyscredentialskeys>any_other_property<) | string | Key-value pairs for the custom keys. |

### Parameter: `connections.connectionProperties.authType-CustomKeys.credentials.keys.>Any_other_property<`

Key-value pairs for the custom keys.

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

### Variant: `connections.connectionProperties.authType-None`
The connection properties when the auth type is None.

To use this variant, set the property `authType` to `None`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authType`](#parameter-connectionsconnectionpropertiesauthtype-noneauthtype) | string | The authentication type of the connection target. |

### Parameter: `connections.connectionProperties.authType-None.authType`

The authentication type of the connection target.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'None'
  ]
  ```

### Variant: `connections.connectionProperties.authType-OAuth2`
The connection properties when the auth type is OAuth2.

To use this variant, set the property `authType` to `OAuth2`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authType`](#parameter-connectionsconnectionpropertiesauthtype-oauth2authtype) | string | The authentication type of the connection target. |
| [`credentials`](#parameter-connectionsconnectionpropertiesauthtype-oauth2credentials) | object | The credentials for the connection. |

### Parameter: `connections.connectionProperties.authType-OAuth2.authType`

The authentication type of the connection target.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'OAuth2'
  ]
  ```

### Parameter: `connections.connectionProperties.authType-OAuth2.credentials`

The credentials for the connection.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clientId`](#parameter-connectionsconnectionpropertiesauthtype-oauth2credentialsclientid) | string | The connection client ID in the format of UUID. |
| [`clientSecret`](#parameter-connectionsconnectionpropertiesauthtype-oauth2credentialsclientsecret) | string | The connection client secret. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authUrl`](#parameter-connectionsconnectionpropertiesauthtype-oauth2credentialsauthurl) | string | The connection auth URL. Required if connection category is Concur. |
| [`developerToken`](#parameter-connectionsconnectionpropertiesauthtype-oauth2credentialsdevelopertoken) | string | The connection developer token. Required if connection category is GoogleAdWords. |
| [`password`](#parameter-connectionsconnectionpropertiesauthtype-oauth2credentialspassword) | string | The connection password. Required if connection category is Concur or ServiceNow where AccessToken grant type is 'Password'. |
| [`refreshToken`](#parameter-connectionsconnectionpropertiesauthtype-oauth2credentialsrefreshtoken) | string | The connection refresh token. Required if connection category is GoogleBigQuery, GoogleAdWords, Hubspot, QuickBooks, Square, Xero or Zoho. |
| [`tenantId`](#parameter-connectionsconnectionpropertiesauthtype-oauth2credentialstenantid) | string | The connection tenant ID. Required if connection category is QuickBooks or Xero. |
| [`username`](#parameter-connectionsconnectionpropertiesauthtype-oauth2credentialsusername) | string | The connection username. Required if connection category is Concur or ServiceNow where AccessToken grant type is 'Password'. |

### Parameter: `connections.connectionProperties.authType-OAuth2.credentials.clientId`

The connection client ID in the format of UUID.

- Required: Yes
- Type: string

### Parameter: `connections.connectionProperties.authType-OAuth2.credentials.clientSecret`

The connection client secret.

- Required: Yes
- Type: string

### Parameter: `connections.connectionProperties.authType-OAuth2.credentials.authUrl`

The connection auth URL. Required if connection category is Concur.

- Required: No
- Type: string

### Parameter: `connections.connectionProperties.authType-OAuth2.credentials.developerToken`

The connection developer token. Required if connection category is GoogleAdWords.

- Required: No
- Type: string

### Parameter: `connections.connectionProperties.authType-OAuth2.credentials.password`

The connection password. Required if connection category is Concur or ServiceNow where AccessToken grant type is 'Password'.

- Required: No
- Type: string

### Parameter: `connections.connectionProperties.authType-OAuth2.credentials.refreshToken`

The connection refresh token. Required if connection category is GoogleBigQuery, GoogleAdWords, Hubspot, QuickBooks, Square, Xero or Zoho.

- Required: No
- Type: string

### Parameter: `connections.connectionProperties.authType-OAuth2.credentials.tenantId`

The connection tenant ID. Required if connection category is QuickBooks or Xero.

- Required: No
- Type: string

### Parameter: `connections.connectionProperties.authType-OAuth2.credentials.username`

The connection username. Required if connection category is Concur or ServiceNow where AccessToken grant type is 'Password'.

- Required: No
- Type: string

### Variant: `connections.connectionProperties.authType-PAT`
The connection properties when the auth type is PAT.

To use this variant, set the property `authType` to `PAT`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authType`](#parameter-connectionsconnectionpropertiesauthtype-patauthtype) | string | The authentication type of the connection target. |
| [`credentials`](#parameter-connectionsconnectionpropertiesauthtype-patcredentials) | object | The credentials for the connection. |

### Parameter: `connections.connectionProperties.authType-PAT.authType`

The authentication type of the connection target.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'PAT'
  ]
  ```

### Parameter: `connections.connectionProperties.authType-PAT.credentials`

The credentials for the connection.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`pat`](#parameter-connectionsconnectionpropertiesauthtype-patcredentialspat) | string | The connection personal access token. |

### Parameter: `connections.connectionProperties.authType-PAT.credentials.pat`

The connection personal access token.

- Required: Yes
- Type: string

### Variant: `connections.connectionProperties.authType-SAS`
The connection properties when the auth type is SAS.

To use this variant, set the property `authType` to `SAS`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authType`](#parameter-connectionsconnectionpropertiesauthtype-sasauthtype) | string | The authentication type of the connection target. |
| [`credentials`](#parameter-connectionsconnectionpropertiesauthtype-sascredentials) | object | The credentials for the connection. |

### Parameter: `connections.connectionProperties.authType-SAS.authType`

The authentication type of the connection target.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'SAS'
  ]
  ```

### Parameter: `connections.connectionProperties.authType-SAS.credentials`

The credentials for the connection.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`sas`](#parameter-connectionsconnectionpropertiesauthtype-sascredentialssas) | string | The connection SAS token. |

### Parameter: `connections.connectionProperties.authType-SAS.credentials.sas`

The connection SAS token.

- Required: Yes
- Type: string

### Variant: `connections.connectionProperties.authType-ServicePrincipal`
The connection properties when the auth type is ServicePrincipal.

To use this variant, set the property `authType` to `ServicePrincipal`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authType`](#parameter-connectionsconnectionpropertiesauthtype-serviceprincipalauthtype) | string | The authentication type of the connection target. |
| [`credentials`](#parameter-connectionsconnectionpropertiesauthtype-serviceprincipalcredentials) | object | The credentials for the connection. |

### Parameter: `connections.connectionProperties.authType-ServicePrincipal.authType`

The authentication type of the connection target.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'ServicePrincipal'
  ]
  ```

### Parameter: `connections.connectionProperties.authType-ServicePrincipal.credentials`

The credentials for the connection.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clientId`](#parameter-connectionsconnectionpropertiesauthtype-serviceprincipalcredentialsclientid) | string | The connection client ID. |
| [`clientSecret`](#parameter-connectionsconnectionpropertiesauthtype-serviceprincipalcredentialsclientsecret) | string | The connection client secret. |
| [`tenantId`](#parameter-connectionsconnectionpropertiesauthtype-serviceprincipalcredentialstenantid) | string | The connection tenant ID. |

### Parameter: `connections.connectionProperties.authType-ServicePrincipal.credentials.clientId`

The connection client ID.

- Required: Yes
- Type: string

### Parameter: `connections.connectionProperties.authType-ServicePrincipal.credentials.clientSecret`

The connection client secret.

- Required: Yes
- Type: string

### Parameter: `connections.connectionProperties.authType-ServicePrincipal.credentials.tenantId`

The connection tenant ID.

- Required: Yes
- Type: string

### Variant: `connections.connectionProperties.authType-UsernamePassword`
The connection properties when the auth type is UsernamePassword.

To use this variant, set the property `authType` to `UsernamePassword`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authType`](#parameter-connectionsconnectionpropertiesauthtype-usernamepasswordauthtype) | string | The authentication type of the connection target. |
| [`credentials`](#parameter-connectionsconnectionpropertiesauthtype-usernamepasswordcredentials) | object | The credentials for the connection. |

### Parameter: `connections.connectionProperties.authType-UsernamePassword.authType`

The authentication type of the connection target.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'UsernamePassword'
  ]
  ```

### Parameter: `connections.connectionProperties.authType-UsernamePassword.credentials`

The credentials for the connection.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`password`](#parameter-connectionsconnectionpropertiesauthtype-usernamepasswordcredentialspassword) | string | The connection password. |
| [`username`](#parameter-connectionsconnectionpropertiesauthtype-usernamepasswordcredentialsusername) | string | The connection username. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`securityToken`](#parameter-connectionsconnectionpropertiesauthtype-usernamepasswordcredentialssecuritytoken) | string | The connection security token. Required if connection is like SalesForce for extra security in addition to 'UsernamePassword'. |

### Parameter: `connections.connectionProperties.authType-UsernamePassword.credentials.password`

The connection password.

- Required: Yes
- Type: string

### Parameter: `connections.connectionProperties.authType-UsernamePassword.credentials.username`

The connection username.

- Required: Yes
- Type: string

### Parameter: `connections.connectionProperties.authType-UsernamePassword.credentials.securityToken`

The connection security token. Required if connection is like SalesForce for extra security in addition to 'UsernamePassword'.

- Required: No
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

### Parameter: `datastores`

Datastores to create in the workspace.

- Required: No
- Type: array
- Default: `[]`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-datastoresname) | string | Name of the datastore to create. |
| [`properties`](#parameter-datastoresproperties) | object | The properties of the datastore. |

### Parameter: `datastores.name`

Name of the datastore to create.

- Required: Yes
- Type: string

### Parameter: `datastores.properties`

The properties of the datastore.

- Required: Yes
- Type: object

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

### Parameter: `managedNetworkSettings`

Managed Network settings for a machine learning workspace.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`isolationMode`](#parameter-managednetworksettingsisolationmode) | string | Isolation mode for the managed network of a machine learning workspace. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`firewallSku`](#parameter-managednetworksettingsfirewallsku) | string | The firewall SKU used for FQDN rules. |
| [`outboundRules`](#parameter-managednetworksettingsoutboundrules) | object | Outbound rules for the managed network of a machine learning workspace. |

### Parameter: `managedNetworkSettings.isolationMode`

Isolation mode for the managed network of a machine learning workspace.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AllowInternetOutbound'
    'AllowOnlyApprovedOutbound'
    'Disabled'
  ]
  ```

### Parameter: `managedNetworkSettings.firewallSku`

The firewall SKU used for FQDN rules.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Basic'
    'Standard'
  ]
  ```

### Parameter: `managedNetworkSettings.outboundRules`

Outbound rules for the managed network of a machine learning workspace.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`>Any_other_property<`](#parameter-managednetworksettingsoutboundrules>any_other_property<) | object | The outbound rule. The name of the rule is the object key. |

### Parameter: `managedNetworkSettings.outboundRules.>Any_other_property<`

The outbound rule. The name of the rule is the object key.

- Required: Yes
- Type: object
- Discriminator: `type`

<h4>The available variants are:</h4>

| Variant | Description |
| :-- | :-- |
| [`FQDN`](#variant-managednetworksettingsoutboundrules>any_other_property<type-fqdn) | The type for the FQDN outbound rule. |
| [`PrivateEndpoint`](#variant-managednetworksettingsoutboundrules>any_other_property<type-privateendpoint) | The type for the private endpoint outbound rule. |
| [`ServiceTag`](#variant-managednetworksettingsoutboundrules>any_other_property<type-servicetag) | The type for the service tag outbound rule. |

### Variant: `managedNetworkSettings.outboundRules.>Any_other_property<.type-FQDN`
The type for the FQDN outbound rule.

To use this variant, set the property `type` to `FQDN`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`destination`](#parameter-managednetworksettingsoutboundrules>any_other_property<type-fqdndestination) | string | Fully Qualified Domain Name to allow for outbound traffic. |
| [`type`](#parameter-managednetworksettingsoutboundrules>any_other_property<type-fqdntype) | string | Type of a managed network Outbound Rule of a machine learning workspace. Only supported when 'isolationMode' is 'AllowOnlyApprovedOutbound'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-managednetworksettingsoutboundrules>any_other_property<type-fqdncategory) | string | Category of a managed network Outbound Rule of a machine learning workspace. |

### Parameter: `managedNetworkSettings.outboundRules.>Any_other_property<.type-FQDN.destination`

Fully Qualified Domain Name to allow for outbound traffic.

- Required: Yes
- Type: string

### Parameter: `managedNetworkSettings.outboundRules.>Any_other_property<.type-FQDN.type`

Type of a managed network Outbound Rule of a machine learning workspace. Only supported when 'isolationMode' is 'AllowOnlyApprovedOutbound'.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'FQDN'
  ]
  ```

### Parameter: `managedNetworkSettings.outboundRules.>Any_other_property<.type-FQDN.category`

Category of a managed network Outbound Rule of a machine learning workspace.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Dependency'
    'Recommended'
    'Required'
    'UserDefined'
  ]
  ```

### Variant: `managedNetworkSettings.outboundRules.>Any_other_property<.type-PrivateEndpoint`
The type for the private endpoint outbound rule.

To use this variant, set the property `type` to `PrivateEndpoint`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`destination`](#parameter-managednetworksettingsoutboundrules>any_other_property<type-privateendpointdestination) | object | Service Tag destination for a Service Tag Outbound Rule for the managed network of a machine learning workspace. |
| [`type`](#parameter-managednetworksettingsoutboundrules>any_other_property<type-privateendpointtype) | string | Type of a managed network Outbound Rule of a machine learning workspace. Only supported when 'isolationMode' is 'AllowOnlyApprovedOutbound' or 'AllowInternetOutbound'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-managednetworksettingsoutboundrules>any_other_property<type-privateendpointcategory) | string | Category of a managed network Outbound Rule of a machine learning workspace. |

### Parameter: `managedNetworkSettings.outboundRules.>Any_other_property<.type-PrivateEndpoint.destination`

Service Tag destination for a Service Tag Outbound Rule for the managed network of a machine learning workspace.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`serviceResourceId`](#parameter-managednetworksettingsoutboundrules>any_other_property<type-privateendpointdestinationserviceresourceid) | string | The resource ID of the target resource for the private endpoint. |
| [`subresourceTarget`](#parameter-managednetworksettingsoutboundrules>any_other_property<type-privateendpointdestinationsubresourcetarget) | string | The sub resource to connect for the private endpoint. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`sparkEnabled`](#parameter-managednetworksettingsoutboundrules>any_other_property<type-privateendpointdestinationsparkenabled) | bool | Whether the private endpoint can be used by jobs running on Spark. |

### Parameter: `managedNetworkSettings.outboundRules.>Any_other_property<.type-PrivateEndpoint.destination.serviceResourceId`

The resource ID of the target resource for the private endpoint.

- Required: Yes
- Type: string

### Parameter: `managedNetworkSettings.outboundRules.>Any_other_property<.type-PrivateEndpoint.destination.subresourceTarget`

The sub resource to connect for the private endpoint.

- Required: Yes
- Type: string

### Parameter: `managedNetworkSettings.outboundRules.>Any_other_property<.type-PrivateEndpoint.destination.sparkEnabled`

Whether the private endpoint can be used by jobs running on Spark.

- Required: No
- Type: bool

### Parameter: `managedNetworkSettings.outboundRules.>Any_other_property<.type-PrivateEndpoint.type`

Type of a managed network Outbound Rule of a machine learning workspace. Only supported when 'isolationMode' is 'AllowOnlyApprovedOutbound' or 'AllowInternetOutbound'.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'PrivateEndpoint'
  ]
  ```

### Parameter: `managedNetworkSettings.outboundRules.>Any_other_property<.type-PrivateEndpoint.category`

Category of a managed network Outbound Rule of a machine learning workspace.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Dependency'
    'Recommended'
    'Required'
    'UserDefined'
  ]
  ```

### Variant: `managedNetworkSettings.outboundRules.>Any_other_property<.type-ServiceTag`
The type for the service tag outbound rule.

To use this variant, set the property `type` to `ServiceTag`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`destination`](#parameter-managednetworksettingsoutboundrules>any_other_property<type-servicetagdestination) | object | Service Tag destination for a Service Tag Outbound Rule for the managed network of a machine learning workspace. |
| [`type`](#parameter-managednetworksettingsoutboundrules>any_other_property<type-servicetagtype) | string | Type of a managed network Outbound Rule of a machine learning workspace. Only supported when 'isolationMode' is 'AllowOnlyApprovedOutbound'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-managednetworksettingsoutboundrules>any_other_property<type-servicetagcategory) | string | Category of a managed network Outbound Rule of a machine learning workspace. |

### Parameter: `managedNetworkSettings.outboundRules.>Any_other_property<.type-ServiceTag.destination`

Service Tag destination for a Service Tag Outbound Rule for the managed network of a machine learning workspace.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`portRanges`](#parameter-managednetworksettingsoutboundrules>any_other_property<type-servicetagdestinationportranges) | string | The name of the service tag to allow. |
| [`protocol`](#parameter-managednetworksettingsoutboundrules>any_other_property<type-servicetagdestinationprotocol) | string | The protocol to allow. Provide an asterisk(*) to allow any protocol. |
| [`serviceTag`](#parameter-managednetworksettingsoutboundrules>any_other_property<type-servicetagdestinationservicetag) | string | Which ports will be allow traffic by this rule. Provide an asterisk(*) to allow any port. |

### Parameter: `managedNetworkSettings.outboundRules.>Any_other_property<.type-ServiceTag.destination.portRanges`

The name of the service tag to allow.

- Required: Yes
- Type: string

### Parameter: `managedNetworkSettings.outboundRules.>Any_other_property<.type-ServiceTag.destination.protocol`

The protocol to allow. Provide an asterisk(*) to allow any protocol.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    '*'
    'ICMP'
    'TCP'
    'UDP'
  ]
  ```

### Parameter: `managedNetworkSettings.outboundRules.>Any_other_property<.type-ServiceTag.destination.serviceTag`

Which ports will be allow traffic by this rule. Provide an asterisk(*) to allow any port.

- Required: Yes
- Type: string

### Parameter: `managedNetworkSettings.outboundRules.>Any_other_property<.type-ServiceTag.type`

Type of a managed network Outbound Rule of a machine learning workspace. Only supported when 'isolationMode' is 'AllowOnlyApprovedOutbound'.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'ServiceTag'
  ]
  ```

### Parameter: `managedNetworkSettings.outboundRules.>Any_other_property<.type-ServiceTag.category`

Category of a managed network Outbound Rule of a machine learning workspace.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Dependency'
    'Recommended'
    'Required'
    'UserDefined'
  ]
  ```

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

### Parameter: `serverlessComputeSettings`

Settings for serverless compute created in the workspace.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`serverlessComputeCustomSubnet`](#parameter-serverlesscomputesettingsserverlesscomputecustomsubnet) | string | The resource ID of an existing virtual network subnet in which serverless compute nodes should be deployed. |
| [`serverlessComputeNoPublicIP`](#parameter-serverlesscomputesettingsserverlesscomputenopublicip) | bool | The flag to signal if serverless compute nodes deployed in custom vNet would have no public IP addresses for a workspace with private endpoint. |

### Parameter: `serverlessComputeSettings.serverlessComputeCustomSubnet`

The resource ID of an existing virtual network subnet in which serverless compute nodes should be deployed.

- Required: No
- Type: string

### Parameter: `serverlessComputeSettings.serverlessComputeNoPublicIP`

The flag to signal if serverless compute nodes deployed in custom vNet would have no public IP addresses for a workspace with private endpoint.

- Required: No
- Type: bool

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

### Parameter: `workspaceHubConfig`

Configuration for workspace hub settings.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`additionalWorkspaceStorageAccounts`](#parameter-workspacehubconfigadditionalworkspacestorageaccounts) | array | The resource IDs of additional storage accounts to attach to the workspace. |
| [`defaultWorkspaceResourceGroup`](#parameter-workspacehubconfigdefaultworkspaceresourcegroup) | string | The resource ID of the default resource group for projects created in the workspace hub. |

### Parameter: `workspaceHubConfig.additionalWorkspaceStorageAccounts`

The resource IDs of additional storage accounts to attach to the workspace.

- Required: No
- Type: array

### Parameter: `workspaceHubConfig.defaultWorkspaceResourceGroup`

The resource ID of the default resource group for projects created in the workspace hub.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the machine learning service. |
| `privateEndpoints` | array | The private endpoints of the resource. |
| `resourceGroupName` | string | The resource group the machine learning service was deployed into. |
| `resourceId` | string | The resource ID of the machine learning service. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/network/private-endpoint:0.10.1` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |

## Notes

### Parameter Usage: `computes`

Array to specify the compute resources to create respectively attach.
In case you provide a resource ID, it will attach the resource and ignore "properties". In this case "computeLocation", "sku", "systemAssignedIdentity", "userAssignedIdentities" as well as "tags" don't need to be provided respectively are being ignored.
Attaching a compute is not idempotent and will fail in case you try to redeploy over an existing compute in AML. I.e. for the first run set "deploy" to true, and after successful deployment to false.
For more information see https://learn.microsoft.com/en-us/azure/templates/microsoft.machinelearningservices/workspaces/computes?tabs=bicep

<details>

<summary>Parameter JSON format</summary>

```json
"computes": {
    "value": [
        // Attach existing resources
        {
            "name": "DefaultAKS",
            "location": "westeurope",
            "description": "Default AKS Cluster",
            "disableLocalAuth": false,
            "deployCompute": true,
            "computeType": "AKS",
            "resourceId": "/subscriptions/[[subscriptionId]]/resourceGroups/validation-rg/providers/Microsoft.ContainerService/managedClusters/xxx"
        },
        // Create new compute resource
        {
            "name": "DefaultCPU",
            "location": "westeurope",
            "computeLocation": "westeurope",
            "sku": "Basic",
            "systemAssignedIdentity": true,
            "userAssignedIdentities": {
                "/subscriptions/[[subscriptionId]]/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-[[namePrefix]]-az-msi-x-001": {}
            },
            "description": "Default CPU Cluster",
            "disableLocalAuth": false,
            "computeType": "AmlCompute",
            "properties": {
                "enableNodePublicIp": true,
                "isolatedNetwork": false,
                "osType": "Linux",
                "remoteLoginPortPublicAccess": "Disabled",
                "scaleSettings": {
                    "maxNodeCount": 3,
                    "minNodeCount": 0,
                    "nodeIdleTimeBeforeScaleDown": "PT5M"
                },
                "vmPriority": "Dedicated",
                "vmSize": "STANDARD_DS11_V2"
            }
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
computes: [
    // Attach existing resources
    {
        name: 'DefaultAKS'
        location: 'westeurope'
        description: 'Default AKS Cluster'
        disableLocalAuth: false
        deployCompute: true
        computeType: 'AKS'
        resourceId: '/subscriptions/[[subscriptionId]]/resourceGroups/validation-rg/providers/Microsoft.ContainerService/managedClusters/xxx'
    }
    // Create new compute resource
    {
        name: 'DefaultCPU'
        location: 'westeurope'
        computeLocation: 'westeurope'
        sku: 'Basic'
        systemAssignedIdentity: true
        userAssignedIdentities: {
            '/subscriptions/[[subscriptionId]]/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-[[namePrefix]]-az-msi-x-001': {}
        }
        description: 'Default CPU Cluster'
        disableLocalAuth: false
        computeType: 'AmlCompute'
        properties: {
            enableNodePublicIp: true
            isolatedNetwork: false
            osType: 'Linux'
            remoteLoginPortPublicAccess: 'Disabled'
            scaleSettings: {
                maxNodeCount: 3
                minNodeCount: 0
                nodeIdleTimeBeforeScaleDown: 'PT5M'
            }
            vmPriority: 'Dedicated'
            vmSize: 'STANDARD_DS11_V2'
        }
    }
]
```

</details>
<p>

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
