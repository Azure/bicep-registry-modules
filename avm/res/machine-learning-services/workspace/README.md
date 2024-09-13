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
| `Microsoft.MachineLearningServices/workspaces` | [2024-04-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.MachineLearningServices/2024-04-01-preview/workspaces) |
| `Microsoft.MachineLearningServices/workspaces/computes` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.MachineLearningServices/2022-10-01/workspaces/computes) |
| `Microsoft.MachineLearningServices/workspaces/connections` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.MachineLearningServices/2024-04-01/workspaces/connections) |
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

<summary>via JSON Parameter file</summary>

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

<summary>via JSON Parameter file</summary>

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

<summary>via JSON Parameter file</summary>

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

<summary>via JSON Parameter file</summary>

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
    imageBuildCompute: 'testcompute'
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
    systemDatastoresAuthMode: 'accessKey'
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
    "imageBuildCompute": {
      "value": "testcompute"
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
      "value": "accessKey"
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
    systemDatastoresAuthMode: 'identity'
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
      "value": "identity"
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
| [`name`](#parameter-name) | string | The name of the machine learning workspace. |
| [`sku`](#parameter-sku) | string | Specifies the SKU, also referred as 'edition' of the Azure Machine Learning workspace. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`associatedApplicationInsightsResourceId`](#parameter-associatedapplicationinsightsresourceid) | string | The resource ID of the associated Application Insights. Required if 'kind' is 'Default' or 'FeatureStore'. |
| [`associatedKeyVaultResourceId`](#parameter-associatedkeyvaultresourceid) | string | The resource ID of the associated Key Vault. Required if 'kind' is 'Default', 'FeatureStore' or 'Hub'. |
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
| [`description`](#parameter-description) | string | The description of this workspace. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`discoveryUrl`](#parameter-discoveryurl) | string | URL for the discovery service to identify regional endpoints for machine learning experimentation services. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`hbiWorkspace`](#parameter-hbiworkspace) | bool | The flag to signal HBI data in the workspace and reduce diagnostic data collected by the service. |
| [`imageBuildCompute`](#parameter-imagebuildcompute) | string | The compute name for image build. |
| [`kind`](#parameter-kind) | string | The type of Azure Machine Learning workspace to create. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. At least one identity type is required. |
| [`managedNetworkSettings`](#parameter-managednetworksettings) | object | Managed Network settings for a machine learning workspace. |
| [`privateEndpoints`](#parameter-privateendpoints) | array | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
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

The resource ID of the associated Key Vault. Required if 'kind' is 'Default', 'FeatureStore' or 'Hub'.

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

### Parameter: `discoveryUrl`

URL for the discovery service to identify regional endpoints for machine learning experimentation services.

- Required: No
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `hbiWorkspace`

The flag to signal HBI data in the workspace and reduce diagnostic data collected by the service.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `imageBuildCompute`

The compute name for image build.

- Required: No
- Type: string

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
| [`systemAssigned`](#parameter-managedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. Must be false if `primaryUserAssignedIdentity` is provided. |
| [`userAssignedResourceIds`](#parameter-managedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. |

### Parameter: `managedIdentities.systemAssigned`

Enables system assigned managed identity on the resource. Must be false if `primaryUserAssignedIdentity` is provided.

- Required: No
- Type: bool

### Parameter: `managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource.

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

### Parameter: `privateEndpoints.privateDnsZoneGroup`

The private DNS zone group to configure for the private endpoint.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateDnsZoneGroupConfigs`](#parameter-privateendpointsprivatednszonegroupprivatednszonegroupconfigs) | array | The private DNS zone groups to associate the private endpoint. A DNS zone group can support up to 5 DNS zones. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-privateendpointsprivatednszonegroupname) | string | The name of the Private DNS Zone Group. |

### Parameter: `privateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs`

The private DNS zone groups to associate the private endpoint. A DNS zone group can support up to 5 DNS zones.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateDnsZoneResourceId`](#parameter-privateendpointsprivatednszonegroupprivatednszonegroupconfigsprivatednszoneresourceid) | string | The resource id of the private DNS zone. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-privateendpointsprivatednszonegroupprivatednszonegroupconfigsname) | string | The name of the private DNS zone group config. |

### Parameter: `privateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs.privateDnsZoneResourceId`

The resource id of the private DNS zone.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs.name`

The name of the private DNS zone group config.

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

### Parameter: `privateEndpoints.resourceGroupName`

Specify if you want to deploy the Private Endpoint into a different resource group than the main resource.

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
  - `'Role Based Access Control Administrator (Preview)'`

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
    'accessKey'
    'identity'
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
| `resourceGroupName` | string | The resource group the machine learning service was deployed into. |
| `resourceId` | string | The resource ID of the machine learning service. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/network/private-endpoint:0.7.0` | Remote reference |

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
