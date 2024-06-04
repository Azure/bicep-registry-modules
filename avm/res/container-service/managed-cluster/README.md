# Azure Kubernetes Service (AKS) Managed Clusters `[Microsoft.ContainerService/managedClusters]`

This module deploys an Azure Kubernetes Service (AKS) Managed Cluster.

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
| `Microsoft.ContainerService/managedClusters` | [2024-03-02-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerService/2024-03-02-preview/managedClusters) |
| `Microsoft.ContainerService/managedClusters/agentPools` | [2023-07-02-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerService/2023-07-02-preview/managedClusters/agentPools) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.KubernetesConfiguration/extensions` | [2022-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KubernetesConfiguration/2022-03-01/extensions) |
| `Microsoft.KubernetesConfiguration/fluxConfigurations` | [2022-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KubernetesConfiguration/2022-03-01/fluxConfigurations) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/container-service/managed-cluster:<version>`.

- [Using Azure CNI Network Plugin.](#example-1-using-azure-cni-network-plugin)
- [Using only defaults](#example-2-using-only-defaults)
- [Using Kubenet Network Plugin.](#example-3-using-kubenet-network-plugin)
- [Using Private Cluster.](#example-4-using-private-cluster)
- [WAF-aligned](#example-5-waf-aligned)

### Example 1: _Using Azure CNI Network Plugin._

This instance deploys the module with Azure CNI network plugin .


<details>

<summary>via Bicep module</summary>

```bicep
module managedCluster 'br/public:avm/res/container-service/managed-cluster:<version>' = {
  name: 'managedClusterDeployment'
  params: {
    // Required parameters
    name: 'csmaz001'
    primaryAgentPoolProfile: [
      {
        availabilityZones: [
          '3'
        ]
        count: 1
        enableAutoScaling: true
        maxCount: 3
        maxPods: 30
        minCount: 1
        mode: 'System'
        name: 'systempool'
        nodeTaints: [
          'CriticalAddonsOnly=true:NoSchedule'
        ]
        osDiskSizeGB: 0
        osType: 'Linux'
        type: 'VirtualMachineScaleSets'
        vmSize: 'Standard_DS2_v2'
        vnetSubnetID: '<vnetSubnetID>'
      }
    ]
    // Non-required parameters
    agentPools: [
      {
        availabilityZones: [
          '3'
        ]
        count: 2
        enableAutoScaling: true
        maxCount: 3
        maxPods: 30
        minCount: 1
        minPods: 2
        mode: 'User'
        name: 'userpool1'
        nodeLabels: {}
        osDiskSizeGB: 128
        osType: 'Linux'
        proximityPlacementGroupResourceId: '<proximityPlacementGroupResourceId>'
        scaleSetEvictionPolicy: 'Delete'
        scaleSetPriority: 'Regular'
        type: 'VirtualMachineScaleSets'
        vmSize: 'Standard_DS2_v2'
        vnetSubnetID: '<vnetSubnetID>'
      }
      {
        availabilityZones: [
          '3'
        ]
        count: 2
        enableAutoScaling: true
        maxCount: 3
        maxPods: 30
        minCount: 1
        minPods: 2
        mode: 'User'
        name: 'userpool2'
        nodeLabels: {}
        osDiskSizeGB: 128
        osType: 'Linux'
        scaleSetEvictionPolicy: 'Delete'
        scaleSetPriority: 'Regular'
        type: 'VirtualMachineScaleSets'
        vmSize: 'Standard_DS2_v2'
        vnetSubnetID: '<vnetSubnetID>'
      }
    ]
    autoUpgradeProfileUpgradeChannel: 'stable'
    customerManagedKey: {
      keyName: '<keyName>'
      keyVaultNetworkAccess: 'Public'
      keyVaultResourceId: '<keyVaultResourceId>'
    }
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
    diskEncryptionSetResourceId: '<diskEncryptionSetResourceId>'
    enableAzureDefender: true
    enableAzureMonitorProfileMetrics: true
    enableKeyvaultSecretsProvider: true
    enableOidcIssuerProfile: true
    enablePodSecurityPolicy: false
    enableStorageProfileBlobCSIDriver: true
    enableStorageProfileDiskCSIDriver: true
    enableStorageProfileFileCSIDriver: true
    enableStorageProfileSnapshotController: true
    enableWorkloadIdentity: true
    fluxExtension: {
      configurations: [
        {
          gitRepository: {
            repositoryRef: {
              branch: 'main'
            }
            sshKnownHosts: ''
            syncIntervalInSeconds: 300
            timeoutInSeconds: 180
            url: 'https://github.com/mspnp/aks-baseline'
          }
          namespace: 'flux-system'
          scope: 'cluster'
        }
        {
          gitRepository: {
            repositoryRef: {
              branch: 'main'
            }
            sshKnownHosts: ''
            syncIntervalInSeconds: 300
            timeoutInSeconds: 180
            url: 'https://github.com/Azure/gitops-flux2-kustomize-helm-mt'
          }
          kustomizations: {
            apps: {
              dependsOn: [
                'infra'
              ]
              path: './apps/staging'
              prune: true
              retryIntervalInSeconds: 120
              syncIntervalInSeconds: 600
              timeoutInSeconds: 600
            }
            infra: {
              dependsOn: []
              path: './infrastructure'
              prune: true
              syncIntervalInSeconds: 600
              timeoutInSeconds: 600
              validation: 'none'
            }
          }
          namespace: 'flux-system-helm'
          scope: 'cluster'
        }
      ]
      configurationSettings: {
        'helm-controller.enabled': 'true'
        'image-automation-controller.enabled': 'false'
        'image-reflector-controller.enabled': 'false'
        'kustomize-controller.enabled': 'true'
        'notification-controller.enabled': 'true'
        'source-controller.enabled': 'true'
      }
    }
    identityProfile: {
      kubeletidentity: {
        resourceId: '<resourceId>'
      }
    }
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    managedIdentities: {
      userAssignedResourcesIds: [
        '<managedIdentityResourceId>'
      ]
    }
    monitoringWorkspaceId: '<monitoringWorkspaceId>'
    networkDataplane: 'azure'
    networkPlugin: 'azure'
    networkPluginMode: 'overlay'
    omsAgentEnabled: true
    openServiceMeshEnabled: true
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
      "value": "csmaz001"
    },
    "primaryAgentPoolProfile": {
      "value": [
        {
          "availabilityZones": [
            "3"
          ],
          "count": 1,
          "enableAutoScaling": true,
          "maxCount": 3,
          "maxPods": 30,
          "minCount": 1,
          "mode": "System",
          "name": "systempool",
          "nodeTaints": [
            "CriticalAddonsOnly=true:NoSchedule"
          ],
          "osDiskSizeGB": 0,
          "osType": "Linux",
          "type": "VirtualMachineScaleSets",
          "vmSize": "Standard_DS2_v2",
          "vnetSubnetID": "<vnetSubnetID>"
        }
      ]
    },
    // Non-required parameters
    "agentPools": {
      "value": [
        {
          "availabilityZones": [
            "3"
          ],
          "count": 2,
          "enableAutoScaling": true,
          "maxCount": 3,
          "maxPods": 30,
          "minCount": 1,
          "minPods": 2,
          "mode": "User",
          "name": "userpool1",
          "nodeLabels": {},
          "osDiskSizeGB": 128,
          "osType": "Linux",
          "proximityPlacementGroupResourceId": "<proximityPlacementGroupResourceId>",
          "scaleSetEvictionPolicy": "Delete",
          "scaleSetPriority": "Regular",
          "type": "VirtualMachineScaleSets",
          "vmSize": "Standard_DS2_v2",
          "vnetSubnetID": "<vnetSubnetID>"
        },
        {
          "availabilityZones": [
            "3"
          ],
          "count": 2,
          "enableAutoScaling": true,
          "maxCount": 3,
          "maxPods": 30,
          "minCount": 1,
          "minPods": 2,
          "mode": "User",
          "name": "userpool2",
          "nodeLabels": {},
          "osDiskSizeGB": 128,
          "osType": "Linux",
          "scaleSetEvictionPolicy": "Delete",
          "scaleSetPriority": "Regular",
          "type": "VirtualMachineScaleSets",
          "vmSize": "Standard_DS2_v2",
          "vnetSubnetID": "<vnetSubnetID>"
        }
      ]
    },
    "autoUpgradeProfileUpgradeChannel": {
      "value": "stable"
    },
    "customerManagedKey": {
      "value": {
        "keyName": "<keyName>",
        "keyVaultNetworkAccess": "Public",
        "keyVaultResourceId": "<keyVaultResourceId>"
      }
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
    "diskEncryptionSetResourceId": {
      "value": "<diskEncryptionSetResourceId>"
    },
    "enableAzureDefender": {
      "value": true
    },
    "enableAzureMonitorProfileMetrics": {
      "value": true
    },
    "enableKeyvaultSecretsProvider": {
      "value": true
    },
    "enableOidcIssuerProfile": {
      "value": true
    },
    "enablePodSecurityPolicy": {
      "value": false
    },
    "enableStorageProfileBlobCSIDriver": {
      "value": true
    },
    "enableStorageProfileDiskCSIDriver": {
      "value": true
    },
    "enableStorageProfileFileCSIDriver": {
      "value": true
    },
    "enableStorageProfileSnapshotController": {
      "value": true
    },
    "enableWorkloadIdentity": {
      "value": true
    },
    "fluxExtension": {
      "value": {
        "configurations": [
          {
            "gitRepository": {
              "repositoryRef": {
                "branch": "main"
              },
              "sshKnownHosts": "",
              "syncIntervalInSeconds": 300,
              "timeoutInSeconds": 180,
              "url": "https://github.com/mspnp/aks-baseline"
            },
            "namespace": "flux-system",
            "scope": "cluster"
          },
          {
            "gitRepository": {
              "repositoryRef": {
                "branch": "main"
              },
              "sshKnownHosts": "",
              "syncIntervalInSeconds": 300,
              "timeoutInSeconds": 180,
              "url": "https://github.com/Azure/gitops-flux2-kustomize-helm-mt"
            },
            "kustomizations": {
              "apps": {
                "dependsOn": [
                  "infra"
                ],
                "path": "./apps/staging",
                "prune": true,
                "retryIntervalInSeconds": 120,
                "syncIntervalInSeconds": 600,
                "timeoutInSeconds": 600
              },
              "infra": {
                "dependsOn": [],
                "path": "./infrastructure",
                "prune": true,
                "syncIntervalInSeconds": 600,
                "timeoutInSeconds": 600,
                "validation": "none"
              }
            },
            "namespace": "flux-system-helm",
            "scope": "cluster"
          }
        ],
        "configurationSettings": {
          "helm-controller.enabled": "true",
          "image-automation-controller.enabled": "false",
          "image-reflector-controller.enabled": "false",
          "kustomize-controller.enabled": "true",
          "notification-controller.enabled": "true",
          "source-controller.enabled": "true"
        }
      }
    },
    "identityProfile": {
      "value": {
        "kubeletidentity": {
          "resourceId": "<resourceId>"
        }
      }
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
        "userAssignedResourcesIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "monitoringWorkspaceId": {
      "value": "<monitoringWorkspaceId>"
    },
    "networkDataplane": {
      "value": "azure"
    },
    "networkPlugin": {
      "value": "azure"
    },
    "networkPluginMode": {
      "value": "overlay"
    },
    "omsAgentEnabled": {
      "value": true
    },
    "openServiceMeshEnabled": {
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

### Example 2: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module managedCluster 'br/public:avm/res/container-service/managed-cluster:<version>' = {
  name: 'managedClusterDeployment'
  params: {
    // Required parameters
    name: 'csmin001'
    primaryAgentPoolProfile: [
      {
        count: 3
        mode: 'System'
        name: 'systempool'
        vmSize: 'Standard_DS2_v2'
      }
    ]
    // Non-required parameters
    location: '<location>'
    managedIdentities: {
      systemAssigned: true
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
      "value": "csmin001"
    },
    "primaryAgentPoolProfile": {
      "value": [
        {
          "count": 3,
          "mode": "System",
          "name": "systempool",
          "vmSize": "Standard_DS2_v2"
        }
      ]
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": true
      }
    }
  }
}
```

</details>
<p>

### Example 3: _Using Kubenet Network Plugin._

This instance deploys the module with Kubenet network plugin .


<details>

<summary>via Bicep module</summary>

```bicep
module managedCluster 'br/public:avm/res/container-service/managed-cluster:<version>' = {
  name: 'managedClusterDeployment'
  params: {
    // Required parameters
    name: 'csmkube001'
    primaryAgentPoolProfile: [
      {
        availabilityZones: [
          '3'
        ]
        count: 1
        enableAutoScaling: true
        maxCount: 3
        maxPods: 30
        minCount: 1
        mode: 'System'
        name: 'systempool'
        nodeTaints: [
          'CriticalAddonsOnly=true:NoSchedule'
        ]
        osDiskSizeGB: 0
        osType: 'Linux'
        type: 'VirtualMachineScaleSets'
        vmSize: 'Standard_DS2_v2'
      }
    ]
    // Non-required parameters
    agentPools: [
      {
        availabilityZones: [
          '3'
        ]
        count: 2
        enableAutoScaling: true
        maxCount: 3
        maxPods: 30
        minCount: 1
        minPods: 2
        mode: 'User'
        name: 'userpool1'
        nodeLabels: {}
        osDiskSizeGB: 128
        osType: 'Linux'
        scaleSetEvictionPolicy: 'Delete'
        scaleSetPriority: 'Regular'
        type: 'VirtualMachineScaleSets'
        vmSize: 'Standard_DS2_v2'
      }
      {
        availabilityZones: [
          '3'
        ]
        count: 2
        enableAutoScaling: true
        maxCount: 3
        maxPods: 30
        minCount: 1
        minPods: 2
        mode: 'User'
        name: 'userpool2'
        nodeLabels: {}
        osDiskSizeGB: 128
        osType: 'Linux'
        scaleSetEvictionPolicy: 'Delete'
        scaleSetPriority: 'Regular'
        type: 'VirtualMachineScaleSets'
        vmSize: 'Standard_DS2_v2'
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
    location: '<location>'
    managedIdentities: {
      userAssignedResourcesIds: [
        '<managedIdentityResourceId>'
      ]
    }
    networkPlugin: 'kubenet'
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
      "value": "csmkube001"
    },
    "primaryAgentPoolProfile": {
      "value": [
        {
          "availabilityZones": [
            "3"
          ],
          "count": 1,
          "enableAutoScaling": true,
          "maxCount": 3,
          "maxPods": 30,
          "minCount": 1,
          "mode": "System",
          "name": "systempool",
          "nodeTaints": [
            "CriticalAddonsOnly=true:NoSchedule"
          ],
          "osDiskSizeGB": 0,
          "osType": "Linux",
          "type": "VirtualMachineScaleSets",
          "vmSize": "Standard_DS2_v2"
        }
      ]
    },
    // Non-required parameters
    "agentPools": {
      "value": [
        {
          "availabilityZones": [
            "3"
          ],
          "count": 2,
          "enableAutoScaling": true,
          "maxCount": 3,
          "maxPods": 30,
          "minCount": 1,
          "minPods": 2,
          "mode": "User",
          "name": "userpool1",
          "nodeLabels": {},
          "osDiskSizeGB": 128,
          "osType": "Linux",
          "scaleSetEvictionPolicy": "Delete",
          "scaleSetPriority": "Regular",
          "type": "VirtualMachineScaleSets",
          "vmSize": "Standard_DS2_v2"
        },
        {
          "availabilityZones": [
            "3"
          ],
          "count": 2,
          "enableAutoScaling": true,
          "maxCount": 3,
          "maxPods": 30,
          "minCount": 1,
          "minPods": 2,
          "mode": "User",
          "name": "userpool2",
          "nodeLabels": {},
          "osDiskSizeGB": 128,
          "osType": "Linux",
          "scaleSetEvictionPolicy": "Delete",
          "scaleSetPriority": "Regular",
          "type": "VirtualMachineScaleSets",
          "vmSize": "Standard_DS2_v2"
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
    "location": {
      "value": "<location>"
    },
    "managedIdentities": {
      "value": {
        "userAssignedResourcesIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "networkPlugin": {
      "value": "kubenet"
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
    }
  }
}
```

</details>
<p>

### Example 4: _Using Private Cluster._

This instance deploys the module with a private cluster instance.


<details>

<summary>via Bicep module</summary>

```bicep
module managedCluster 'br/public:avm/res/container-service/managed-cluster:<version>' = {
  name: 'managedClusterDeployment'
  params: {
    // Required parameters
    name: 'csmpriv001'
    primaryAgentPoolProfile: [
      {
        availabilityZones: [
          '3'
        ]
        count: 1
        enableAutoScaling: true
        maxCount: 3
        maxPods: 30
        minCount: 1
        mode: 'System'
        name: 'systempool'
        nodeTaints: [
          'CriticalAddonsOnly=true:NoSchedule'
        ]
        osDiskSizeGB: 0
        osType: 'Linux'
        type: 'VirtualMachineScaleSets'
        vmSize: 'Standard_DS2_v2'
        vnetSubnetID: '<vnetSubnetID>'
      }
    ]
    // Non-required parameters
    agentPools: [
      {
        availabilityZones: [
          '3'
        ]
        count: 2
        enableAutoScaling: true
        maxCount: 3
        maxPods: 30
        minCount: 1
        minPods: 2
        mode: 'User'
        name: 'userpool1'
        nodeLabels: {}
        osDiskSizeGB: 128
        osType: 'Linux'
        scaleSetEvictionPolicy: 'Delete'
        scaleSetPriority: 'Regular'
        type: 'VirtualMachineScaleSets'
        vmSize: 'Standard_DS2_v2'
        vnetSubnetID: '<vnetSubnetID>'
      }
      {
        availabilityZones: [
          '3'
        ]
        count: 2
        enableAutoScaling: true
        maxCount: 3
        maxPods: 30
        minCount: 1
        minPods: 2
        mode: 'User'
        name: 'userpool2'
        nodeLabels: {}
        osDiskSizeGB: 128
        osType: 'Linux'
        scaleSetEvictionPolicy: 'Delete'
        scaleSetPriority: 'Regular'
        type: 'VirtualMachineScaleSets'
        vmSize: 'Standard_DS2_v2'
      }
    ]
    dnsServiceIP: '10.10.200.10'
    enablePrivateCluster: true
    location: '<location>'
    managedIdentities: {
      userAssignedResourcesIds: [
        '<managedIdentityResourceId>'
      ]
    }
    networkPlugin: 'azure'
    privateDNSZone: '<privateDNSZone>'
    serviceCidr: '10.10.200.0/24'
    skuTier: 'Standard'
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
      "value": "csmpriv001"
    },
    "primaryAgentPoolProfile": {
      "value": [
        {
          "availabilityZones": [
            "3"
          ],
          "count": 1,
          "enableAutoScaling": true,
          "maxCount": 3,
          "maxPods": 30,
          "minCount": 1,
          "mode": "System",
          "name": "systempool",
          "nodeTaints": [
            "CriticalAddonsOnly=true:NoSchedule"
          ],
          "osDiskSizeGB": 0,
          "osType": "Linux",
          "type": "VirtualMachineScaleSets",
          "vmSize": "Standard_DS2_v2",
          "vnetSubnetID": "<vnetSubnetID>"
        }
      ]
    },
    // Non-required parameters
    "agentPools": {
      "value": [
        {
          "availabilityZones": [
            "3"
          ],
          "count": 2,
          "enableAutoScaling": true,
          "maxCount": 3,
          "maxPods": 30,
          "minCount": 1,
          "minPods": 2,
          "mode": "User",
          "name": "userpool1",
          "nodeLabels": {},
          "osDiskSizeGB": 128,
          "osType": "Linux",
          "scaleSetEvictionPolicy": "Delete",
          "scaleSetPriority": "Regular",
          "type": "VirtualMachineScaleSets",
          "vmSize": "Standard_DS2_v2",
          "vnetSubnetID": "<vnetSubnetID>"
        },
        {
          "availabilityZones": [
            "3"
          ],
          "count": 2,
          "enableAutoScaling": true,
          "maxCount": 3,
          "maxPods": 30,
          "minCount": 1,
          "minPods": 2,
          "mode": "User",
          "name": "userpool2",
          "nodeLabels": {},
          "osDiskSizeGB": 128,
          "osType": "Linux",
          "scaleSetEvictionPolicy": "Delete",
          "scaleSetPriority": "Regular",
          "type": "VirtualMachineScaleSets",
          "vmSize": "Standard_DS2_v2"
        }
      ]
    },
    "dnsServiceIP": {
      "value": "10.10.200.10"
    },
    "enablePrivateCluster": {
      "value": true
    },
    "location": {
      "value": "<location>"
    },
    "managedIdentities": {
      "value": {
        "userAssignedResourcesIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "networkPlugin": {
      "value": "azure"
    },
    "privateDNSZone": {
      "value": "<privateDNSZone>"
    },
    "serviceCidr": {
      "value": "10.10.200.0/24"
    },
    "skuTier": {
      "value": "Standard"
    }
  }
}
```

</details>
<p>

### Example 5: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module managedCluster 'br/public:avm/res/container-service/managed-cluster:<version>' = {
  name: 'managedClusterDeployment'
  params: {
    // Required parameters
    name: 'cswaf001'
    primaryAgentPoolProfile: [
      {
        availabilityZones: [
          '3'
        ]
        count: 3
        enableAutoScaling: true
        maxCount: 3
        maxPods: 50
        minCount: 3
        mode: 'System'
        name: 'systempool'
        nodeTaints: [
          'CriticalAddonsOnly=true:NoSchedule'
        ]
        osDiskSizeGB: 0
        osType: 'Linux'
        type: 'VirtualMachineScaleSets'
        vmSize: 'Standard_DS2_v2'
        vnetSubnetID: '<vnetSubnetID>'
      }
    ]
    // Non-required parameters
    agentPools: [
      {
        availabilityZones: [
          '3'
        ]
        count: 3
        enableAutoScaling: true
        maxCount: 3
        maxPods: 50
        minCount: 3
        minPods: 2
        mode: 'User'
        name: 'userpool1'
        nodeLabels: {}
        osDiskSizeGB: 60
        osDiskType: 'Ephemeral'
        osType: 'Linux'
        scaleSetEvictionPolicy: 'Delete'
        scaleSetPriority: 'Regular'
        type: 'VirtualMachineScaleSets'
        vmSize: 'Standard_DS2_v2'
        vnetSubnetID: '<vnetSubnetID>'
      }
      {
        availabilityZones: [
          '3'
        ]
        count: 3
        enableAutoScaling: true
        maxCount: 3
        maxPods: 50
        minCount: 3
        minPods: 2
        mode: 'User'
        name: 'userpool2'
        nodeLabels: {}
        osDiskSizeGB: 60
        osDiskType: 'Ephemeral'
        osType: 'Linux'
        scaleSetEvictionPolicy: 'Delete'
        scaleSetPriority: 'Regular'
        type: 'VirtualMachineScaleSets'
        vmSize: 'Standard_DS2_v2'
      }
    ]
    autoUpgradeProfileUpgradeChannel: 'stable'
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        logCategoriesAndGroups: [
          {
            category: 'kube-apiserver'
          }
          {
            category: 'kube-controller-manager'
          }
          {
            category: 'kube-scheduler'
          }
          {
            category: 'cluster-autoscaler'
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
    ]
    disableLocalAccounts: true
    dnsServiceIP: '10.10.200.10'
    enableAzureDefender: true
    enablePrivateCluster: true
    location: '<location>'
    managedIdentities: {
      userAssignedResourcesIds: [
        '<managedIdentityResourceId>'
      ]
    }
    monitoringWorkspaceId: '<monitoringWorkspaceId>'
    networkPlugin: 'azure'
    networkPolicy: 'azure'
    omsAgentEnabled: true
    privateDNSZone: '<privateDNSZone>'
    serviceCidr: '10.10.200.0/24'
    skuTier: 'Standard'
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
      "value": "cswaf001"
    },
    "primaryAgentPoolProfile": {
      "value": [
        {
          "availabilityZones": [
            "3"
          ],
          "count": 3,
          "enableAutoScaling": true,
          "maxCount": 3,
          "maxPods": 50,
          "minCount": 3,
          "mode": "System",
          "name": "systempool",
          "nodeTaints": [
            "CriticalAddonsOnly=true:NoSchedule"
          ],
          "osDiskSizeGB": 0,
          "osType": "Linux",
          "type": "VirtualMachineScaleSets",
          "vmSize": "Standard_DS2_v2",
          "vnetSubnetID": "<vnetSubnetID>"
        }
      ]
    },
    // Non-required parameters
    "agentPools": {
      "value": [
        {
          "availabilityZones": [
            "3"
          ],
          "count": 3,
          "enableAutoScaling": true,
          "maxCount": 3,
          "maxPods": 50,
          "minCount": 3,
          "minPods": 2,
          "mode": "User",
          "name": "userpool1",
          "nodeLabels": {},
          "osDiskSizeGB": 60,
          "osDiskType": "Ephemeral",
          "osType": "Linux",
          "scaleSetEvictionPolicy": "Delete",
          "scaleSetPriority": "Regular",
          "type": "VirtualMachineScaleSets",
          "vmSize": "Standard_DS2_v2",
          "vnetSubnetID": "<vnetSubnetID>"
        },
        {
          "availabilityZones": [
            "3"
          ],
          "count": 3,
          "enableAutoScaling": true,
          "maxCount": 3,
          "maxPods": 50,
          "minCount": 3,
          "minPods": 2,
          "mode": "User",
          "name": "userpool2",
          "nodeLabels": {},
          "osDiskSizeGB": 60,
          "osDiskType": "Ephemeral",
          "osType": "Linux",
          "scaleSetEvictionPolicy": "Delete",
          "scaleSetPriority": "Regular",
          "type": "VirtualMachineScaleSets",
          "vmSize": "Standard_DS2_v2"
        }
      ]
    },
    "autoUpgradeProfileUpgradeChannel": {
      "value": "stable"
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "logCategoriesAndGroups": [
            {
              "category": "kube-apiserver"
            },
            {
              "category": "kube-controller-manager"
            },
            {
              "category": "kube-scheduler"
            },
            {
              "category": "cluster-autoscaler"
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
        }
      ]
    },
    "disableLocalAccounts": {
      "value": true
    },
    "dnsServiceIP": {
      "value": "10.10.200.10"
    },
    "enableAzureDefender": {
      "value": true
    },
    "enablePrivateCluster": {
      "value": true
    },
    "location": {
      "value": "<location>"
    },
    "managedIdentities": {
      "value": {
        "userAssignedResourcesIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "monitoringWorkspaceId": {
      "value": "<monitoringWorkspaceId>"
    },
    "networkPlugin": {
      "value": "azure"
    },
    "networkPolicy": {
      "value": "azure"
    },
    "omsAgentEnabled": {
      "value": true
    },
    "privateDNSZone": {
      "value": "<privateDNSZone>"
    },
    "serviceCidr": {
      "value": "10.10.200.0/24"
    },
    "skuTier": {
      "value": "Standard"
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
| [`name`](#parameter-name) | string | Specifies the name of the AKS cluster. |
| [`primaryAgentPoolProfile`](#parameter-primaryagentpoolprofile) | array | Properties of the primary agent pool. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`aksServicePrincipalProfile`](#parameter-aksserviceprincipalprofile) | object | Information about a service principal identity for the cluster to use for manipulating Azure APIs. Required if no managed identities are assigned to the cluster. |
| [`appGatewayResourceId`](#parameter-appgatewayresourceid) | string | Specifies the resource ID of connected application gateway. Required if `ingressApplicationGatewayEnabled` is set to `true`. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`aadProfileAdminGroupObjectIDs`](#parameter-aadprofileadmingroupobjectids) | array | Specifies the AAD group object IDs that will have admin role of the cluster. |
| [`aadProfileClientAppID`](#parameter-aadprofileclientappid) | string | The client AAD application ID. |
| [`aadProfileEnableAzureRBAC`](#parameter-aadprofileenableazurerbac) | bool | Specifies whether to enable Azure RBAC for Kubernetes authorization. |
| [`aadProfileManaged`](#parameter-aadprofilemanaged) | bool | Specifies whether to enable managed AAD integration. |
| [`aadProfileServerAppID`](#parameter-aadprofileserverappid) | string | The server AAD application ID. |
| [`aadProfileServerAppSecret`](#parameter-aadprofileserverappsecret) | string | The server AAD application secret. |
| [`aadProfileTenantId`](#parameter-aadprofiletenantid) | string | Specifies the tenant ID of the Azure Active Directory used by the AKS cluster for authentication. |
| [`aciConnectorLinuxEnabled`](#parameter-aciconnectorlinuxenabled) | bool | Specifies whether the aciConnectorLinux add-on is enabled or not. |
| [`adminUsername`](#parameter-adminusername) | string | Specifies the administrator username of Linux virtual machines. |
| [`agentPools`](#parameter-agentpools) | array | Define one or more secondary/additional agent pools. |
| [`authorizedIPRanges`](#parameter-authorizedipranges) | array | IP ranges are specified in CIDR format, e.g. 137.117.106.88/29. This feature is not compatible with clusters that use Public IP Per Node, or clusters that are using a Basic Load Balancer. |
| [`autoScalerProfileBalanceSimilarNodeGroups`](#parameter-autoscalerprofilebalancesimilarnodegroups) | string | Specifies the balance of similar node groups for the auto-scaler of the AKS cluster. |
| [`autoScalerProfileExpander`](#parameter-autoscalerprofileexpander) | string | Specifies the expand strategy for the auto-scaler of the AKS cluster. |
| [`autoScalerProfileMaxEmptyBulkDelete`](#parameter-autoscalerprofilemaxemptybulkdelete) | string | Specifies the maximum empty bulk delete for the auto-scaler of the AKS cluster. |
| [`autoScalerProfileMaxGracefulTerminationSec`](#parameter-autoscalerprofilemaxgracefulterminationsec) | string | Specifies the max graceful termination time interval in seconds for the auto-scaler of the AKS cluster. |
| [`autoScalerProfileMaxNodeProvisionTime`](#parameter-autoscalerprofilemaxnodeprovisiontime) | string | Specifies the maximum node provisioning time for the auto-scaler of the AKS cluster. Values must be an integer followed by an "m". No unit of time other than minutes (m) is supported. |
| [`autoScalerProfileMaxTotalUnreadyPercentage`](#parameter-autoscalerprofilemaxtotalunreadypercentage) | string | Specifies the mximum total unready percentage for the auto-scaler of the AKS cluster. The maximum is 100 and the minimum is 0. |
| [`autoScalerProfileNewPodScaleUpDelay`](#parameter-autoscalerprofilenewpodscaleupdelay) | string | For scenarios like burst/batch scale where you do not want CA to act before the kubernetes scheduler could schedule all the pods, you can tell CA to ignore unscheduled pods before they are a certain age. Values must be an integer followed by a unit ("s" for seconds, "m" for minutes, "h" for hours, etc). |
| [`autoScalerProfileOkTotalUnreadyCount`](#parameter-autoscalerprofileoktotalunreadycount) | string | Specifies the OK total unready count for the auto-scaler of the AKS cluster. |
| [`autoScalerProfileScaleDownDelayAfterAdd`](#parameter-autoscalerprofilescaledowndelayafteradd) | string | Specifies the scale down delay after add of the auto-scaler of the AKS cluster. |
| [`autoScalerProfileScaleDownDelayAfterDelete`](#parameter-autoscalerprofilescaledowndelayafterdelete) | string | Specifies the scale down delay after delete of the auto-scaler of the AKS cluster. |
| [`autoScalerProfileScaleDownDelayAfterFailure`](#parameter-autoscalerprofilescaledowndelayafterfailure) | string | Specifies scale down delay after failure of the auto-scaler of the AKS cluster. |
| [`autoScalerProfileScaleDownUnneededTime`](#parameter-autoscalerprofilescaledownunneededtime) | string | Specifies the scale down unneeded time of the auto-scaler of the AKS cluster. |
| [`autoScalerProfileScaleDownUnreadyTime`](#parameter-autoscalerprofilescaledownunreadytime) | string | Specifies the scale down unready time of the auto-scaler of the AKS cluster. |
| [`autoScalerProfileScanInterval`](#parameter-autoscalerprofilescaninterval) | string | Specifies the scan interval of the auto-scaler of the AKS cluster. |
| [`autoScalerProfileSkipNodesWithLocalStorage`](#parameter-autoscalerprofileskipnodeswithlocalstorage) | string | Specifies if nodes with local storage should be skipped for the auto-scaler of the AKS cluster. |
| [`autoScalerProfileSkipNodesWithSystemPods`](#parameter-autoscalerprofileskipnodeswithsystempods) | string | Specifies if nodes with system pods should be skipped for the auto-scaler of the AKS cluster. |
| [`autoScalerProfileUtilizationThreshold`](#parameter-autoscalerprofileutilizationthreshold) | string | Specifies the utilization threshold of the auto-scaler of the AKS cluster. |
| [`autoUpgradeProfileUpgradeChannel`](#parameter-autoupgradeprofileupgradechannel) | string | Auto-upgrade channel on the AKS cluster. |
| [`azurePolicyEnabled`](#parameter-azurepolicyenabled) | bool | Specifies whether the azurepolicy add-on is enabled or not. For security reasons, this setting should be enabled. |
| [`azurePolicyVersion`](#parameter-azurepolicyversion) | string | Specifies the azure policy version to use. |
| [`backendPoolType`](#parameter-backendpooltype) | string | The type of the managed inbound Load Balancer BackendPool. |
| [`costAnalysisEnabled`](#parameter-costanalysisenabled) | bool | Specifies whether the cost analysis add-on is enabled or not. If Enabled `enableStorageProfileDiskCSIDriver` is set to true as it is needed. |
| [`customerManagedKey`](#parameter-customermanagedkey) | object | The customer managed key definition. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`disableCustomMetrics`](#parameter-disablecustommetrics) | bool | Indicates whether custom metrics collection has to be disabled or not. If not specified the default is false. No custom metrics will be emitted if this field is false but the container insights enabled field is false. |
| [`disableLocalAccounts`](#parameter-disablelocalaccounts) | bool | If set to true, getting static credentials will be disabled for this cluster. This must only be used on Managed Clusters that are AAD enabled. |
| [`disablePrometheusMetricsScraping`](#parameter-disableprometheusmetricsscraping) | bool | Indicates whether prometheus metrics scraping is disabled or not. If not specified the default is false. No prometheus metrics will be emitted if this field is false but the container insights enabled field is false. |
| [`disableRunCommand`](#parameter-disableruncommand) | bool | Whether to disable run command for the cluster or not. |
| [`diskEncryptionSetResourceId`](#parameter-diskencryptionsetresourceid) | string | The resource ID of the disc encryption set to apply to the cluster. For security reasons, this value should be provided. |
| [`dnsPrefix`](#parameter-dnsprefix) | string | Specifies the DNS prefix specified when creating the managed cluster. |
| [`dnsServiceIP`](#parameter-dnsserviceip) | string | Specifies the IP address assigned to the Kubernetes DNS service. It must be within the Kubernetes service address range specified in serviceCidr. |
| [`dnsZoneResourceId`](#parameter-dnszoneresourceid) | string | Specifies the resource ID of connected DNS zone. It will be ignored if `webApplicationRoutingEnabled` is set to `false`. |
| [`enableAzureDefender`](#parameter-enableazuredefender) | bool | Whether to enable Azure Defender. |
| [`enableAzureMonitorProfileMetrics`](#parameter-enableazuremonitorprofilemetrics) | bool | Whether the metric state of the kubenetes cluster is enabled. |
| [`enableContainerInsights`](#parameter-enablecontainerinsights) | bool | Indicates if Azure Monitor Container Insights Logs Addon is enabled. |
| [`enableDnsZoneContributorRoleAssignment`](#parameter-enablednszonecontributorroleassignment) | bool | Specifies whether assing the DNS zone contributor role to the cluster service principal. It will be ignored if `webApplicationRoutingEnabled` is set to `false` or `dnsZoneResourceId` not provided. |
| [`enableImageCleaner`](#parameter-enableimagecleaner) | bool | Whether to enable Image Cleaner for Kubernetes. |
| [`enableKeyvaultSecretsProvider`](#parameter-enablekeyvaultsecretsprovider) | bool | Specifies whether the KeyvaultSecretsProvider add-on is enabled or not. |
| [`enableOidcIssuerProfile`](#parameter-enableoidcissuerprofile) | bool | Whether the The OIDC issuer profile of the Managed Cluster is enabled. |
| [`enablePodSecurityPolicy`](#parameter-enablepodsecuritypolicy) | bool | Whether to enable Kubernetes pod security policy. Requires enabling the pod security policy feature flag on the subscription. |
| [`enablePrivateCluster`](#parameter-enableprivatecluster) | bool | Specifies whether to create the cluster as a private cluster or not. |
| [`enablePrivateClusterPublicFQDN`](#parameter-enableprivateclusterpublicfqdn) | bool | Whether to create additional public FQDN for private cluster or not. |
| [`enableRBAC`](#parameter-enablerbac) | bool | Whether to enable Kubernetes Role-Based Access Control. |
| [`enableSecretRotation`](#parameter-enablesecretrotation) | string | Specifies whether the KeyvaultSecretsProvider add-on uses secret rotation. |
| [`enableStorageProfileBlobCSIDriver`](#parameter-enablestorageprofileblobcsidriver) | bool | Whether the AzureBlob CSI Driver for the storage profile is enabled. |
| [`enableStorageProfileDiskCSIDriver`](#parameter-enablestorageprofilediskcsidriver) | bool | Whether the AzureDisk CSI Driver for the storage profile is enabled. |
| [`enableStorageProfileFileCSIDriver`](#parameter-enablestorageprofilefilecsidriver) | bool | Whether the AzureFile CSI Driver for the storage profile is enabled. |
| [`enableStorageProfileSnapshotController`](#parameter-enablestorageprofilesnapshotcontroller) | bool | Whether the snapshot controller for the storage profile is enabled. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`enableWorkloadIdentity`](#parameter-enableworkloadidentity) | bool | Whether to enable Workload Identity. Requires OIDC issuer profile to be enabled. |
| [`fluxExtension`](#parameter-fluxextension) | object | Settings and configurations for the flux extension. |
| [`httpApplicationRoutingEnabled`](#parameter-httpapplicationroutingenabled) | bool | Specifies whether the httpApplicationRouting add-on is enabled or not. |
| [`httpProxyConfig`](#parameter-httpproxyconfig) | object | Configurations for provisioning the cluster with HTTP proxy servers. |
| [`identityProfile`](#parameter-identityprofile) | object | Identities associated with the cluster. |
| [`imageCleanerIntervalHours`](#parameter-imagecleanerintervalhours) | int | The interval in hours Image Cleaner will run. The maximum value is three months. |
| [`ingressApplicationGatewayEnabled`](#parameter-ingressapplicationgatewayenabled) | bool | Specifies whether the ingressApplicationGateway (AGIC) add-on is enabled or not. |
| [`kedaAddon`](#parameter-kedaaddon) | bool | Enables Kubernetes Event-driven Autoscaling (KEDA). |
| [`kubeDashboardEnabled`](#parameter-kubedashboardenabled) | bool | Specifies whether the kubeDashboard add-on is enabled or not. |
| [`kubernetesVersion`](#parameter-kubernetesversion) | string | Version of Kubernetes specified when creating the managed cluster. |
| [`loadBalancerSku`](#parameter-loadbalancersku) | string | Specifies the sku of the load balancer used by the virtual machine scale sets used by nodepools. |
| [`location`](#parameter-location) | string | Specifies the location of AKS cluster. It picks up Resource Group's location by default. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. Only one type of identity is supported: system-assigned or user-assigned, but not both. |
| [`managedOutboundIPCount`](#parameter-managedoutboundipcount) | int | Outbound IP Count for the Load balancer. |
| [`metricAnnotationsAllowList`](#parameter-metricannotationsallowlist) | string | A comma-separated list of Kubernetes cluster metrics annotations. |
| [`metricLabelsAllowlist`](#parameter-metriclabelsallowlist) | string | A comma-separated list of kubernetes cluster metrics labels. |
| [`monitoringWorkspaceId`](#parameter-monitoringworkspaceid) | string | Resource ID of the monitoring log analytics workspace. |
| [`networkDataplane`](#parameter-networkdataplane) | string | Network dataplane used in the Kubernetes cluster. Not compatible with kubenet network plugin. |
| [`networkPlugin`](#parameter-networkplugin) | string | Specifies the network plugin used for building Kubernetes network. |
| [`networkPluginMode`](#parameter-networkpluginmode) | string | Network plugin mode used for building the Kubernetes network. Not compatible with kubenet network plugin. |
| [`networkPolicy`](#parameter-networkpolicy) | string | Specifies the network policy used for building Kubernetes network. - calico or azure. |
| [`nodeResourceGroup`](#parameter-noderesourcegroup) | string | Name of the resource group containing agent pool nodes. |
| [`omsAgentEnabled`](#parameter-omsagentenabled) | bool | Specifies whether the OMS agent is enabled. |
| [`openServiceMeshEnabled`](#parameter-openservicemeshenabled) | bool | Specifies whether the openServiceMesh add-on is enabled or not. |
| [`outboundType`](#parameter-outboundtype) | string | Specifies outbound (egress) routing method. |
| [`podCidr`](#parameter-podcidr) | string | Specifies the CIDR notation IP range from which to assign pod IPs when kubenet is used. |
| [`podIdentityProfileAllowNetworkPluginKubenet`](#parameter-podidentityprofileallownetworkpluginkubenet) | bool | Running in Kubenet is disabled by default due to the security related nature of AAD Pod Identity and the risks of IP spoofing. |
| [`podIdentityProfileEnable`](#parameter-podidentityprofileenable) | bool | Whether the pod identity addon is enabled. |
| [`podIdentityProfileUserAssignedIdentities`](#parameter-podidentityprofileuserassignedidentities) | array | The pod identities to use in the cluster. |
| [`podIdentityProfileUserAssignedIdentityExceptions`](#parameter-podidentityprofileuserassignedidentityexceptions) | array | The pod identity exceptions to allow. |
| [`privateDNSZone`](#parameter-privatednszone) | string | Private DNS Zone configuration. Set to 'system' and AKS will create a private DNS zone in the node resource group. Set to '' to disable private DNS Zone creation and use public DNS. Supply the resource ID here of an existing Private DNS zone to use an existing zone. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Allow or deny public network access for AKS. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`serviceCidr`](#parameter-servicecidr) | string | A CIDR notation IP range from which to assign service cluster IPs. It must not overlap with any Subnet IP ranges. |
| [`skuTier`](#parameter-skutier) | string | Tier of a managed cluster SKU. |
| [`sshPublicKey`](#parameter-sshpublickey) | string | Specifies the SSH RSA public key string for the Linux nodes. |
| [`supportPlan`](#parameter-supportplan) | string | The support plan for the Managed Cluster. |
| [`syslogPort`](#parameter-syslogport) | int | The syslog host port. If not specified, the default port is 28330. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`webApplicationRoutingEnabled`](#parameter-webapplicationroutingenabled) | bool | Specifies whether the webApplicationRoutingEnabled add-on is enabled or not. |

### Parameter: `name`

Specifies the name of the AKS cluster.

- Required: Yes
- Type: string

### Parameter: `primaryAgentPoolProfile`

Properties of the primary agent pool.

- Required: Yes
- Type: array

### Parameter: `aksServicePrincipalProfile`

Information about a service principal identity for the cluster to use for manipulating Azure APIs. Required if no managed identities are assigned to the cluster.

- Required: No
- Type: object

### Parameter: `appGatewayResourceId`

Specifies the resource ID of connected application gateway. Required if `ingressApplicationGatewayEnabled` is set to `true`.

- Required: No
- Type: string

### Parameter: `aadProfileAdminGroupObjectIDs`

Specifies the AAD group object IDs that will have admin role of the cluster.

- Required: No
- Type: array

### Parameter: `aadProfileClientAppID`

The client AAD application ID.

- Required: No
- Type: string

### Parameter: `aadProfileEnableAzureRBAC`

Specifies whether to enable Azure RBAC for Kubernetes authorization.

- Required: No
- Type: bool
- Default: `[parameters('enableRBAC')]`

### Parameter: `aadProfileManaged`

Specifies whether to enable managed AAD integration.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `aadProfileServerAppID`

The server AAD application ID.

- Required: No
- Type: string

### Parameter: `aadProfileServerAppSecret`

The server AAD application secret.

- Required: No
- Type: string

### Parameter: `aadProfileTenantId`

Specifies the tenant ID of the Azure Active Directory used by the AKS cluster for authentication.

- Required: No
- Type: string
- Default: `[subscription().tenantId]`

### Parameter: `aciConnectorLinuxEnabled`

Specifies whether the aciConnectorLinux add-on is enabled or not.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `adminUsername`

Specifies the administrator username of Linux virtual machines.

- Required: No
- Type: string
- Default: `'azureuser'`

### Parameter: `agentPools`

Define one or more secondary/additional agent pools.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-agentpoolsname) | string | The name of the agent pool. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`availabilityZones`](#parameter-agentpoolsavailabilityzones) | array | The availability zones of the agent pool. |
| [`count`](#parameter-agentpoolscount) | int | The number of agents (VMs) to host docker containers. Allowed values must be in the range of 1 to 100 (inclusive). |
| [`enableAutoScaling`](#parameter-agentpoolsenableautoscaling) | bool | Whether to enable auto-scaling for the agent pool. |
| [`enableDefaultTelemetry`](#parameter-agentpoolsenabledefaulttelemetry) | bool | The enable default telemetry of the agent pool. |
| [`enableEncryptionAtHost`](#parameter-agentpoolsenableencryptionathost) | bool | Whether to enable encryption at host for the agent pool. |
| [`enableFIPS`](#parameter-agentpoolsenablefips) | bool | Whether to enable FIPS for the agent pool. |
| [`enableNodePublicIP`](#parameter-agentpoolsenablenodepublicip) | bool | Whether to enable node public IP for the agent pool. |
| [`enableUltraSSD`](#parameter-agentpoolsenableultrassd) | bool | Whether to enable Ultra SSD for the agent pool. |
| [`gpuInstanceProfile`](#parameter-agentpoolsgpuinstanceprofile) | string | The GPU instance profile of the agent pool. |
| [`kubeletDiskType`](#parameter-agentpoolskubeletdisktype) | string | The kubelet disk type of the agent pool. |
| [`maxCount`](#parameter-agentpoolsmaxcount) | int | The maximum number of agents (VMs) to host docker containers. Allowed values must be in the range of 1 to 100 (inclusive). |
| [`maxPods`](#parameter-agentpoolsmaxpods) | int | The maximum number of pods that can run on a node. |
| [`maxSurge`](#parameter-agentpoolsmaxsurge) | string | The maximum number of nodes that can be created during an upgrade. |
| [`minCount`](#parameter-agentpoolsmincount) | int | The minimum number of agents (VMs) to host docker containers. Allowed values must be in the range of 1 to 100 (inclusive). |
| [`minPods`](#parameter-agentpoolsminpods) | int | The minimum number of pods that can run on a node. |
| [`mode`](#parameter-agentpoolsmode) | string | The mode of the agent pool. |
| [`nodeLabels`](#parameter-agentpoolsnodelabels) | object | The node labels of the agent pool. |
| [`nodePublicIpPrefixId`](#parameter-agentpoolsnodepublicipprefixid) | string | The node public IP prefix ID of the agent pool. |
| [`nodeTaints`](#parameter-agentpoolsnodetaints) | array | The node taints of the agent pool. |
| [`orchestratorVersion`](#parameter-agentpoolsorchestratorversion) | string | The Kubernetes version of the agent pool. |
| [`osDiskSizeGB`](#parameter-agentpoolsosdisksizegb) | int | The OS disk size in GB of the agent pool. |
| [`osDiskType`](#parameter-agentpoolsosdisktype) | string | The OS disk type of the agent pool. |
| [`osSku`](#parameter-agentpoolsossku) | string | The OS SKU of the agent pool. |
| [`osType`](#parameter-agentpoolsostype) | string | The OS type of the agent pool. |
| [`podSubnetId`](#parameter-agentpoolspodsubnetid) | string | The pod subnet ID of the agent pool. |
| [`proximityPlacementGroupResourceId`](#parameter-agentpoolsproximityplacementgroupresourceid) | string | The proximity placement group resource ID of the agent pool. |
| [`scaleDownMode`](#parameter-agentpoolsscaledownmode) | string | The scale down mode of the agent pool. |
| [`scaleSetEvictionPolicy`](#parameter-agentpoolsscalesetevictionpolicy) | string | The scale set eviction policy of the agent pool. |
| [`scaleSetPriority`](#parameter-agentpoolsscalesetpriority) | string | The scale set priority of the agent pool. |
| [`sourceResourceId`](#parameter-agentpoolssourceresourceid) | string | The source resource ID to create the agent pool from. |
| [`spotMaxPrice`](#parameter-agentpoolsspotmaxprice) | int | The spot max price of the agent pool. |
| [`tags`](#parameter-agentpoolstags) | object | The tags of the agent pool. |
| [`type`](#parameter-agentpoolstype) | string | The type of the agent pool. |
| [`vmSize`](#parameter-agentpoolsvmsize) | string | The VM size of the agent pool. |
| [`vnetSubnetID`](#parameter-agentpoolsvnetsubnetid) | string | The VNet subnet ID of the agent pool. |
| [`workloadRuntime`](#parameter-agentpoolsworkloadruntime) | string | The workload runtime of the agent pool. |

### Parameter: `agentPools.name`

The name of the agent pool.

- Required: No
- Type: string

### Parameter: `agentPools.availabilityZones`

The availability zones of the agent pool.

- Required: No
- Type: array

### Parameter: `agentPools.count`

The number of agents (VMs) to host docker containers. Allowed values must be in the range of 1 to 100 (inclusive).

- Required: No
- Type: int

### Parameter: `agentPools.enableAutoScaling`

Whether to enable auto-scaling for the agent pool.

- Required: No
- Type: bool

### Parameter: `agentPools.enableDefaultTelemetry`

The enable default telemetry of the agent pool.

- Required: No
- Type: bool

### Parameter: `agentPools.enableEncryptionAtHost`

Whether to enable encryption at host for the agent pool.

- Required: No
- Type: bool

### Parameter: `agentPools.enableFIPS`

Whether to enable FIPS for the agent pool.

- Required: No
- Type: bool

### Parameter: `agentPools.enableNodePublicIP`

Whether to enable node public IP for the agent pool.

- Required: No
- Type: bool

### Parameter: `agentPools.enableUltraSSD`

Whether to enable Ultra SSD for the agent pool.

- Required: No
- Type: bool

### Parameter: `agentPools.gpuInstanceProfile`

The GPU instance profile of the agent pool.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'MIG1g'
    'MIG2g'
    'MIG3g'
    'MIG4g'
    'MIG7g'
  ]
  ```

### Parameter: `agentPools.kubeletDiskType`

The kubelet disk type of the agent pool.

- Required: No
- Type: string

### Parameter: `agentPools.maxCount`

The maximum number of agents (VMs) to host docker containers. Allowed values must be in the range of 1 to 100 (inclusive).

- Required: No
- Type: int

### Parameter: `agentPools.maxPods`

The maximum number of pods that can run on a node.

- Required: No
- Type: int

### Parameter: `agentPools.maxSurge`

The maximum number of nodes that can be created during an upgrade.

- Required: No
- Type: string

### Parameter: `agentPools.minCount`

The minimum number of agents (VMs) to host docker containers. Allowed values must be in the range of 1 to 100 (inclusive).

- Required: No
- Type: int

### Parameter: `agentPools.minPods`

The minimum number of pods that can run on a node.

- Required: No
- Type: int

### Parameter: `agentPools.mode`

The mode of the agent pool.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'System'
    'User'
  ]
  ```

### Parameter: `agentPools.nodeLabels`

The node labels of the agent pool.

- Required: No
- Type: object

### Parameter: `agentPools.nodePublicIpPrefixId`

The node public IP prefix ID of the agent pool.

- Required: No
- Type: string

### Parameter: `agentPools.nodeTaints`

The node taints of the agent pool.

- Required: No
- Type: array

### Parameter: `agentPools.orchestratorVersion`

The Kubernetes version of the agent pool.

- Required: No
- Type: string

### Parameter: `agentPools.osDiskSizeGB`

The OS disk size in GB of the agent pool.

- Required: No
- Type: int

### Parameter: `agentPools.osDiskType`

The OS disk type of the agent pool.

- Required: No
- Type: string

### Parameter: `agentPools.osSku`

The OS SKU of the agent pool.

- Required: No
- Type: string

### Parameter: `agentPools.osType`

The OS type of the agent pool.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Linux'
    'Windows'
  ]
  ```

### Parameter: `agentPools.podSubnetId`

The pod subnet ID of the agent pool.

- Required: No
- Type: string

### Parameter: `agentPools.proximityPlacementGroupResourceId`

The proximity placement group resource ID of the agent pool.

- Required: No
- Type: string

### Parameter: `agentPools.scaleDownMode`

The scale down mode of the agent pool.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Deallocate'
    'Delete'
  ]
  ```

### Parameter: `agentPools.scaleSetEvictionPolicy`

The scale set eviction policy of the agent pool.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Deallocate'
    'Delete'
  ]
  ```

### Parameter: `agentPools.scaleSetPriority`

The scale set priority of the agent pool.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Low'
    'Regular'
    'Spot'
  ]
  ```

### Parameter: `agentPools.sourceResourceId`

The source resource ID to create the agent pool from.

- Required: No
- Type: string

### Parameter: `agentPools.spotMaxPrice`

The spot max price of the agent pool.

- Required: No
- Type: int

### Parameter: `agentPools.tags`

The tags of the agent pool.

- Required: No
- Type: object

### Parameter: `agentPools.type`

The type of the agent pool.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AvailabilitySet'
    'VirtualMachineScaleSets'
  ]
  ```

### Parameter: `agentPools.vmSize`

The VM size of the agent pool.

- Required: No
- Type: string

### Parameter: `agentPools.vnetSubnetID`

The VNet subnet ID of the agent pool.

- Required: No
- Type: string

### Parameter: `agentPools.workloadRuntime`

The workload runtime of the agent pool.

- Required: No
- Type: string

### Parameter: `authorizedIPRanges`

IP ranges are specified in CIDR format, e.g. 137.117.106.88/29. This feature is not compatible with clusters that use Public IP Per Node, or clusters that are using a Basic Load Balancer.

- Required: No
- Type: array

### Parameter: `autoScalerProfileBalanceSimilarNodeGroups`

Specifies the balance of similar node groups for the auto-scaler of the AKS cluster.

- Required: No
- Type: string
- Default: `'false'`
- Allowed:
  ```Bicep
  [
    'false'
    'true'
  ]
  ```

### Parameter: `autoScalerProfileExpander`

Specifies the expand strategy for the auto-scaler of the AKS cluster.

- Required: No
- Type: string
- Default: `'random'`
- Allowed:
  ```Bicep
  [
    'least-waste'
    'most-pods'
    'priority'
    'random'
  ]
  ```

### Parameter: `autoScalerProfileMaxEmptyBulkDelete`

Specifies the maximum empty bulk delete for the auto-scaler of the AKS cluster.

- Required: No
- Type: string
- Default: `'10'`

### Parameter: `autoScalerProfileMaxGracefulTerminationSec`

Specifies the max graceful termination time interval in seconds for the auto-scaler of the AKS cluster.

- Required: No
- Type: string
- Default: `'600'`

### Parameter: `autoScalerProfileMaxNodeProvisionTime`

Specifies the maximum node provisioning time for the auto-scaler of the AKS cluster. Values must be an integer followed by an "m". No unit of time other than minutes (m) is supported.

- Required: No
- Type: string
- Default: `'15m'`

### Parameter: `autoScalerProfileMaxTotalUnreadyPercentage`

Specifies the mximum total unready percentage for the auto-scaler of the AKS cluster. The maximum is 100 and the minimum is 0.

- Required: No
- Type: string
- Default: `'45'`

### Parameter: `autoScalerProfileNewPodScaleUpDelay`

For scenarios like burst/batch scale where you do not want CA to act before the kubernetes scheduler could schedule all the pods, you can tell CA to ignore unscheduled pods before they are a certain age. Values must be an integer followed by a unit ("s" for seconds, "m" for minutes, "h" for hours, etc).

- Required: No
- Type: string
- Default: `'0s'`

### Parameter: `autoScalerProfileOkTotalUnreadyCount`

Specifies the OK total unready count for the auto-scaler of the AKS cluster.

- Required: No
- Type: string
- Default: `'3'`

### Parameter: `autoScalerProfileScaleDownDelayAfterAdd`

Specifies the scale down delay after add of the auto-scaler of the AKS cluster.

- Required: No
- Type: string
- Default: `'10m'`

### Parameter: `autoScalerProfileScaleDownDelayAfterDelete`

Specifies the scale down delay after delete of the auto-scaler of the AKS cluster.

- Required: No
- Type: string
- Default: `'20s'`

### Parameter: `autoScalerProfileScaleDownDelayAfterFailure`

Specifies scale down delay after failure of the auto-scaler of the AKS cluster.

- Required: No
- Type: string
- Default: `'3m'`

### Parameter: `autoScalerProfileScaleDownUnneededTime`

Specifies the scale down unneeded time of the auto-scaler of the AKS cluster.

- Required: No
- Type: string
- Default: `'10m'`

### Parameter: `autoScalerProfileScaleDownUnreadyTime`

Specifies the scale down unready time of the auto-scaler of the AKS cluster.

- Required: No
- Type: string
- Default: `'20m'`

### Parameter: `autoScalerProfileScanInterval`

Specifies the scan interval of the auto-scaler of the AKS cluster.

- Required: No
- Type: string
- Default: `'10s'`

### Parameter: `autoScalerProfileSkipNodesWithLocalStorage`

Specifies if nodes with local storage should be skipped for the auto-scaler of the AKS cluster.

- Required: No
- Type: string
- Default: `'true'`
- Allowed:
  ```Bicep
  [
    'false'
    'true'
  ]
  ```

### Parameter: `autoScalerProfileSkipNodesWithSystemPods`

Specifies if nodes with system pods should be skipped for the auto-scaler of the AKS cluster.

- Required: No
- Type: string
- Default: `'true'`
- Allowed:
  ```Bicep
  [
    'false'
    'true'
  ]
  ```

### Parameter: `autoScalerProfileUtilizationThreshold`

Specifies the utilization threshold of the auto-scaler of the AKS cluster.

- Required: No
- Type: string
- Default: `'0.5'`

### Parameter: `autoUpgradeProfileUpgradeChannel`

Auto-upgrade channel on the AKS cluster.

- Required: No
- Type: string
- Default: `'stable'`
- Allowed:
  ```Bicep
  [
    'node-image'
    'none'
    'patch'
    'rapid'
    'stable'
  ]
  ```

### Parameter: `azurePolicyEnabled`

Specifies whether the azurepolicy add-on is enabled or not. For security reasons, this setting should be enabled.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `azurePolicyVersion`

Specifies the azure policy version to use.

- Required: No
- Type: string
- Default: `'v2'`

### Parameter: `backendPoolType`

The type of the managed inbound Load Balancer BackendPool.

- Required: No
- Type: string
- Default: `'NodeIPConfiguration'`
- Allowed:
  ```Bicep
  [
    'NodeIP'
    'NodeIPConfiguration'
  ]
  ```

### Parameter: `costAnalysisEnabled`

Specifies whether the cost analysis add-on is enabled or not. If Enabled `enableStorageProfileDiskCSIDriver` is set to true as it is needed.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `customerManagedKey`

The customer managed key definition.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyName`](#parameter-customermanagedkeykeyname) | string | The name of the customer managed key to use for encryption. |
| [`keyVaultNetworkAccess`](#parameter-customermanagedkeykeyvaultnetworkaccess) | string | Network access of key vault. The possible values are Public and Private. Public means the key vault allows public access from all networks. Private means the key vault disables public access and enables private link. The default value is Public. |
| [`keyVaultResourceId`](#parameter-customermanagedkeykeyvaultresourceid) | string | The resource ID of a key vault to reference a customer managed key for encryption from. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyVersion`](#parameter-customermanagedkeykeyversion) | string | The version of the customer managed key to reference for encryption. If not provided, using 'latest'. |

### Parameter: `customerManagedKey.keyName`

The name of the customer managed key to use for encryption.

- Required: Yes
- Type: string

### Parameter: `customerManagedKey.keyVaultNetworkAccess`

Network access of key vault. The possible values are Public and Private. Public means the key vault allows public access from all networks. Private means the key vault disables public access and enables private link. The default value is Public.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Private'
    'Public'
  ]
  ```

### Parameter: `customerManagedKey.keyVaultResourceId`

The resource ID of a key vault to reference a customer managed key for encryption from.

- Required: Yes
- Type: string

### Parameter: `customerManagedKey.keyVersion`

The version of the customer managed key to reference for encryption. If not provided, using 'latest'.

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

### Parameter: `disableCustomMetrics`

Indicates whether custom metrics collection has to be disabled or not. If not specified the default is false. No custom metrics will be emitted if this field is false but the container insights enabled field is false.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `disableLocalAccounts`

If set to true, getting static credentials will be disabled for this cluster. This must only be used on Managed Clusters that are AAD enabled.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `disablePrometheusMetricsScraping`

Indicates whether prometheus metrics scraping is disabled or not. If not specified the default is false. No prometheus metrics will be emitted if this field is false but the container insights enabled field is false.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `disableRunCommand`

Whether to disable run command for the cluster or not.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `diskEncryptionSetResourceId`

The resource ID of the disc encryption set to apply to the cluster. For security reasons, this value should be provided.

- Required: No
- Type: string

### Parameter: `dnsPrefix`

Specifies the DNS prefix specified when creating the managed cluster.

- Required: No
- Type: string
- Default: `[parameters('name')]`

### Parameter: `dnsServiceIP`

Specifies the IP address assigned to the Kubernetes DNS service. It must be within the Kubernetes service address range specified in serviceCidr.

- Required: No
- Type: string

### Parameter: `dnsZoneResourceId`

Specifies the resource ID of connected DNS zone. It will be ignored if `webApplicationRoutingEnabled` is set to `false`.

- Required: No
- Type: string

### Parameter: `enableAzureDefender`

Whether to enable Azure Defender.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableAzureMonitorProfileMetrics`

Whether the metric state of the kubenetes cluster is enabled.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableContainerInsights`

Indicates if Azure Monitor Container Insights Logs Addon is enabled.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableDnsZoneContributorRoleAssignment`

Specifies whether assing the DNS zone contributor role to the cluster service principal. It will be ignored if `webApplicationRoutingEnabled` is set to `false` or `dnsZoneResourceId` not provided.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableImageCleaner`

Whether to enable Image Cleaner for Kubernetes.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableKeyvaultSecretsProvider`

Specifies whether the KeyvaultSecretsProvider add-on is enabled or not.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableOidcIssuerProfile`

Whether the The OIDC issuer profile of the Managed Cluster is enabled.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enablePodSecurityPolicy`

Whether to enable Kubernetes pod security policy. Requires enabling the pod security policy feature flag on the subscription.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enablePrivateCluster`

Specifies whether to create the cluster as a private cluster or not.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enablePrivateClusterPublicFQDN`

Whether to create additional public FQDN for private cluster or not.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableRBAC`

Whether to enable Kubernetes Role-Based Access Control.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableSecretRotation`

Specifies whether the KeyvaultSecretsProvider add-on uses secret rotation.

- Required: No
- Type: string
- Default: `'false'`
- Allowed:
  ```Bicep
  [
    'false'
    'true'
  ]
  ```

### Parameter: `enableStorageProfileBlobCSIDriver`

Whether the AzureBlob CSI Driver for the storage profile is enabled.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableStorageProfileDiskCSIDriver`

Whether the AzureDisk CSI Driver for the storage profile is enabled.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableStorageProfileFileCSIDriver`

Whether the AzureFile CSI Driver for the storage profile is enabled.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableStorageProfileSnapshotController`

Whether the snapshot controller for the storage profile is enabled.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableWorkloadIdentity`

Whether to enable Workload Identity. Requires OIDC issuer profile to be enabled.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `fluxExtension`

Settings and configurations for the flux extension.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-fluxextensionname) | string | The name of the extension. |
| [`releaseTrain`](#parameter-fluxextensionreleasetrain) | string | The release train of the extension. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`configurationProtectedSettings`](#parameter-fluxextensionconfigurationprotectedsettings) | object | The configuration protected settings of the extension. |
| [`configurations`](#parameter-fluxextensionconfigurations) | array | The flux configurations of the extension. |
| [`configurationSettings`](#parameter-fluxextensionconfigurationsettings) | object | The configuration settings of the extension. |
| [`releaseNamespace`](#parameter-fluxextensionreleasenamespace) | string | Namespace where the extension Release must be placed. |
| [`targetNamespace`](#parameter-fluxextensiontargetnamespace) | string | Namespace where the extension will be created for an Namespace scoped extension. |
| [`version`](#parameter-fluxextensionversion) | string | The version of the extension. |

### Parameter: `fluxExtension.name`

The name of the extension.

- Required: No
- Type: string

### Parameter: `fluxExtension.releaseTrain`

The release train of the extension.

- Required: No
- Type: string

### Parameter: `fluxExtension.configurationProtectedSettings`

The configuration protected settings of the extension.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`sshPrivateKey`](#parameter-fluxextensionconfigurationprotectedsettingssshprivatekey) | string | The SSH private key to use for Git authentication. |

### Parameter: `fluxExtension.configurationProtectedSettings.sshPrivateKey`

The SSH private key to use for Git authentication.

- Required: No
- Type: string

### Parameter: `fluxExtension.configurations`

The flux configurations of the extension.

- Required: No
- Type: array

### Parameter: `fluxExtension.configurationSettings`

The configuration settings of the extension.

- Required: No
- Type: object

### Parameter: `fluxExtension.releaseNamespace`

Namespace where the extension Release must be placed.

- Required: No
- Type: string

### Parameter: `fluxExtension.targetNamespace`

Namespace where the extension will be created for an Namespace scoped extension.

- Required: No
- Type: string

### Parameter: `fluxExtension.version`

The version of the extension.

- Required: No
- Type: string

### Parameter: `httpApplicationRoutingEnabled`

Specifies whether the httpApplicationRouting add-on is enabled or not.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `httpProxyConfig`

Configurations for provisioning the cluster with HTTP proxy servers.

- Required: No
- Type: object

### Parameter: `identityProfile`

Identities associated with the cluster.

- Required: No
- Type: object

### Parameter: `imageCleanerIntervalHours`

The interval in hours Image Cleaner will run. The maximum value is three months.

- Required: No
- Type: int
- Default: `24`

### Parameter: `ingressApplicationGatewayEnabled`

Specifies whether the ingressApplicationGateway (AGIC) add-on is enabled or not.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `kedaAddon`

Enables Kubernetes Event-driven Autoscaling (KEDA).

- Required: No
- Type: bool
- Default: `False`

### Parameter: `kubeDashboardEnabled`

Specifies whether the kubeDashboard add-on is enabled or not.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `kubernetesVersion`

Version of Kubernetes specified when creating the managed cluster.

- Required: No
- Type: string

### Parameter: `loadBalancerSku`

Specifies the sku of the load balancer used by the virtual machine scale sets used by nodepools.

- Required: No
- Type: string
- Default: `'standard'`
- Allowed:
  ```Bicep
  [
    'basic'
    'standard'
  ]
  ```

### Parameter: `location`

Specifies the location of AKS cluster. It picks up Resource Group's location by default.

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

The managed identity definition for this resource. Only one type of identity is supported: system-assigned or user-assigned, but not both.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`systemAssigned`](#parameter-managedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. |
| [`userAssignedResourcesIds`](#parameter-managedidentitiesuserassignedresourcesids) | array | The resource ID(s) to assign to the resource. |

### Parameter: `managedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `managedIdentities.userAssignedResourcesIds`

The resource ID(s) to assign to the resource.

- Required: No
- Type: array

### Parameter: `managedOutboundIPCount`

Outbound IP Count for the Load balancer.

- Required: No
- Type: int
- Default: `0`

### Parameter: `metricAnnotationsAllowList`

A comma-separated list of Kubernetes cluster metrics annotations.

- Required: No
- Type: string
- Default: `''`

### Parameter: `metricLabelsAllowlist`

A comma-separated list of kubernetes cluster metrics labels.

- Required: No
- Type: string
- Default: `''`

### Parameter: `monitoringWorkspaceId`

Resource ID of the monitoring log analytics workspace.

- Required: No
- Type: string

### Parameter: `networkDataplane`

Network dataplane used in the Kubernetes cluster. Not compatible with kubenet network plugin.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'azure'
    'cilium'
  ]
  ```

### Parameter: `networkPlugin`

Specifies the network plugin used for building Kubernetes network.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'azure'
    'kubenet'
  ]
  ```

### Parameter: `networkPluginMode`

Network plugin mode used for building the Kubernetes network. Not compatible with kubenet network plugin.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'overlay'
  ]
  ```

### Parameter: `networkPolicy`

Specifies the network policy used for building Kubernetes network. - calico or azure.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'azure'
    'calico'
  ]
  ```

### Parameter: `nodeResourceGroup`

Name of the resource group containing agent pool nodes.

- Required: No
- Type: string
- Default: `[format('{0}_aks_{1}_nodes', resourceGroup().name, parameters('name'))]`

### Parameter: `omsAgentEnabled`

Specifies whether the OMS agent is enabled.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `openServiceMeshEnabled`

Specifies whether the openServiceMesh add-on is enabled or not.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `outboundType`

Specifies outbound (egress) routing method.

- Required: No
- Type: string
- Default: `'loadBalancer'`
- Allowed:
  ```Bicep
  [
    'loadBalancer'
    'managedNATGateway'
    'userAssignedNATGateway'
    'userDefinedRouting'
  ]
  ```

### Parameter: `podCidr`

Specifies the CIDR notation IP range from which to assign pod IPs when kubenet is used.

- Required: No
- Type: string

### Parameter: `podIdentityProfileAllowNetworkPluginKubenet`

Running in Kubenet is disabled by default due to the security related nature of AAD Pod Identity and the risks of IP spoofing.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `podIdentityProfileEnable`

Whether the pod identity addon is enabled.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `podIdentityProfileUserAssignedIdentities`

The pod identities to use in the cluster.

- Required: No
- Type: array

### Parameter: `podIdentityProfileUserAssignedIdentityExceptions`

The pod identity exceptions to allow.

- Required: No
- Type: array

### Parameter: `privateDNSZone`

Private DNS Zone configuration. Set to 'system' and AKS will create a private DNS zone in the node resource group. Set to '' to disable private DNS Zone creation and use public DNS. Supply the resource ID here of an existing Private DNS zone to use an existing zone.

- Required: No
- Type: string

### Parameter: `publicNetworkAccess`

Allow or deny public network access for AKS.

- Required: No
- Type: string
- Default: `'Disabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
    'SecuredByPerimeter'
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

### Parameter: `serviceCidr`

A CIDR notation IP range from which to assign service cluster IPs. It must not overlap with any Subnet IP ranges.

- Required: No
- Type: string

### Parameter: `skuTier`

Tier of a managed cluster SKU.

- Required: No
- Type: string
- Default: `'Standard'`
- Allowed:
  ```Bicep
  [
    'Free'
    'Premium'
    'Standard'
  ]
  ```

### Parameter: `sshPublicKey`

Specifies the SSH RSA public key string for the Linux nodes.

- Required: No
- Type: string

### Parameter: `supportPlan`

The support plan for the Managed Cluster.

- Required: No
- Type: string
- Default: `'KubernetesOfficial'`
- Allowed:
  ```Bicep
  [
    'AKSLongTermSupport'
    'KubernetesOfficial'
  ]
  ```

### Parameter: `syslogPort`

The syslog host port. If not specified, the default port is 28330.

- Required: No
- Type: int
- Default: `28330`

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `webApplicationRoutingEnabled`

Specifies whether the webApplicationRoutingEnabled add-on is enabled or not.

- Required: No
- Type: bool
- Default: `False`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `addonProfiles` | object | The addonProfiles of the Kubernetes cluster. |
| `controlPlaneFQDN` | string | The control plane FQDN of the managed cluster. |
| `ingressApplicationGatewayIdentityObjectId` | string | The Object ID of Application Gateway Ingress Controller (AGIC) identity. |
| `keyvaultIdentityClientId` | string | The Client ID of the Key Vault Secrets Provider identity. |
| `keyvaultIdentityObjectId` | string | The Object ID of the Key Vault Secrets Provider identity. |
| `kubeletIdentityClientId` | string | The Client ID of the AKS identity. |
| `kubeletIdentityObjectId` | string | The Object ID of the AKS identity. |
| `kubeletIdentityResourceId` | string | The Resource ID of the AKS identity. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the managed cluster. |
| `oidcIssuerUrl` | string | The OIDC token issuer URL. |
| `omsagentIdentityObjectId` | string | The Object ID of the OMS agent identity. |
| `resourceGroupName` | string | The resource group the managed cluster was deployed into. |
| `resourceId` | string | The resource ID of the managed cluster. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |
| `webAppRoutingIdentityObjectId` | string | The Object ID of Web Application Routing. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/kubernetes-configuration/extension:0.2.0` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
