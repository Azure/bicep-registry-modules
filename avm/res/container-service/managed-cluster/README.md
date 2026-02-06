# Azure Kubernetes Service (AKS) Managed Clusters `[Microsoft.ContainerService/managedClusters]`

This module deploys an Azure Kubernetes Service (AKS) Managed Cluster.

You can reference the module as follows:
```bicep
module managedCluster 'br/public:avm/res/container-service/managed-cluster:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Authorization/locks` | 2020-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_locks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks)</li></ul> |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |
| `Microsoft.ContainerService/managedClusters` | 2025-09-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerservice_managedclusters.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerService/2025-09-01/managedClusters)</li></ul> |
| `Microsoft.ContainerService/managedClusters/agentPools` | 2025-09-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerservice_managedclusters_agentpools.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerService/2025-09-01/managedClusters/agentPools)</li></ul> |
| `Microsoft.ContainerService/managedClusters/maintenanceConfigurations` | 2025-09-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerservice_managedclusters_maintenanceconfigurations.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerService/2025-09-01/managedClusters/maintenanceConfigurations)</li></ul> |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_diagnosticsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)</li></ul> |
| `Microsoft.KubernetesConfiguration/extensions` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.kubernetesconfiguration_extensions.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KubernetesConfiguration/2024-11-01/extensions)</li></ul> |
| `Microsoft.KubernetesConfiguration/fluxConfigurations` | 2025-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.kubernetesconfiguration_fluxconfigurations.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KubernetesConfiguration/2025-04-01/fluxConfigurations)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/container-service/managed-cluster:<version>`.

- [Using only defaults and use AKS Automatic mode (PREVIEW)](#example-1-using-only-defaults-and-use-aks-automatic-mode-preview)
- [Using only defaults](#example-2-using-only-defaults)
- [Enabling encryption via a Disk Encryption Set (DES) using Customer-Managed-Keys (CMK) and a User-Assigned Identity](#example-3-enabling-encryption-via-a-disk-encryption-set-des-using-customer-managed-keys-cmk-and-a-user-assigned-identity)
- [Using Istio Service Mesh add-on](#example-4-using-istio-service-mesh-add-on)
- [Using Kubenet Network Plugin.](#example-5-using-kubenet-network-plugin)
- [Using large parameter set](#example-6-using-large-parameter-set)
- [Using Private Cluster.](#example-7-using-private-cluster)
- [WAF-aligned](#example-8-waf-aligned)

### Example 1: _Using only defaults and use AKS Automatic mode (PREVIEW)_

This instance deploys the module with the set of automatic parameters.'

Node autoprovisioning (NAP) for AKS is currently in PREVIEW.
Register the NodeAutoProvisioningPreview feature flag using the az feature register command.

MICROSOFT MAY NOT PROVIDE SUPPORT FOR THIS, PLEASE CHECK THE [PRODUCT DOCS](https://learn.microsoft.com/en-us/azure/aks/node-autoprovision?tabs=azure-cli#enable-node-autoprovisioning) FOR CLARIFICATION.


You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/automatic]


<details>

<summary>via Bicep module</summary>

```bicep
module managedCluster 'br/public:avm/res/container-service/managed-cluster:<version>' = {
  params: {
    // Required parameters
    name: 'csauto001'
    primaryAgentPoolProfiles: [
      {
        count: 1
        mode: 'System'
        name: 'systempool'
        vmSize: 'Standard_DS4_v2'
      }
    ]
    // Non-required parameters
    aadProfile: {
      enableAzureRBAC: true
      managed: true
    }
    autoUpgradeProfile: {
      nodeOSUpgradeChannel: 'NodeImage'
    }
    defaultIngressControllerType: 'Internal'
    disableLocalAccounts: true
    enableKeyvaultSecretsProvider: true
    enableSecretRotation: true
    maintenanceConfigurations: [
      {
        maintenanceWindow: {
          durationHours: 4
          schedule: {
            absoluteMonthly: '<absoluteMonthly>'
            daily: '<daily>'
            relativeMonthly: '<relativeMonthly>'
            weekly: {
              dayOfWeek: 'Sunday'
              intervalWeeks: 1
            }
          }
          startDate: '2024-07-03'
          startTime: '00:00'
          utcOffset: '+00:00'
        }
        name: 'aksManagedAutoUpgradeSchedule'
      }
    ]
    managedIdentities: {
      systemAssigned: true
    }
    nodeProvisioningProfile: {
      mode: 'Auto'
    }
    nodeResourceGroupProfile: {
      restrictionLevel: 'ReadOnly'
    }
    outboundType: 'managedNATGateway'
    publicNetworkAccess: 'Enabled'
    skuName: 'Automatic'
    webApplicationRoutingEnabled: true
    workloadAutoScalerProfile: {
      keda: {
        enabled: true
      }
      verticalPodAutoscaler: {
        enabled: true
      }
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
      "value": "csauto001"
    },
    "primaryAgentPoolProfiles": {
      "value": [
        {
          "count": 1,
          "mode": "System",
          "name": "systempool",
          "vmSize": "Standard_DS4_v2"
        }
      ]
    },
    // Non-required parameters
    "aadProfile": {
      "value": {
        "enableAzureRBAC": true,
        "managed": true
      }
    },
    "autoUpgradeProfile": {
      "value": {
        "nodeOSUpgradeChannel": "NodeImage"
      }
    },
    "defaultIngressControllerType": {
      "value": "Internal"
    },
    "disableLocalAccounts": {
      "value": true
    },
    "enableKeyvaultSecretsProvider": {
      "value": true
    },
    "enableSecretRotation": {
      "value": true
    },
    "maintenanceConfigurations": {
      "value": [
        {
          "maintenanceWindow": {
            "durationHours": 4,
            "schedule": {
              "absoluteMonthly": "<absoluteMonthly>",
              "daily": "<daily>",
              "relativeMonthly": "<relativeMonthly>",
              "weekly": {
                "dayOfWeek": "Sunday",
                "intervalWeeks": 1
              }
            },
            "startDate": "2024-07-03",
            "startTime": "00:00",
            "utcOffset": "+00:00"
          },
          "name": "aksManagedAutoUpgradeSchedule"
        }
      ]
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": true
      }
    },
    "nodeProvisioningProfile": {
      "value": {
        "mode": "Auto"
      }
    },
    "nodeResourceGroupProfile": {
      "value": {
        "restrictionLevel": "ReadOnly"
      }
    },
    "outboundType": {
      "value": "managedNATGateway"
    },
    "publicNetworkAccess": {
      "value": "Enabled"
    },
    "skuName": {
      "value": "Automatic"
    },
    "webApplicationRoutingEnabled": {
      "value": true
    },
    "workloadAutoScalerProfile": {
      "value": {
        "keda": {
          "enabled": true
        },
        "verticalPodAutoscaler": {
          "enabled": true
        }
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
using 'br/public:avm/res/container-service/managed-cluster:<version>'

// Required parameters
param name = 'csauto001'
param primaryAgentPoolProfiles = [
  {
    count: 1
    mode: 'System'
    name: 'systempool'
    vmSize: 'Standard_DS4_v2'
  }
]
// Non-required parameters
param aadProfile = {
  enableAzureRBAC: true
  managed: true
}
param autoUpgradeProfile = {
  nodeOSUpgradeChannel: 'NodeImage'
}
param defaultIngressControllerType = 'Internal'
param disableLocalAccounts = true
param enableKeyvaultSecretsProvider = true
param enableSecretRotation = true
param maintenanceConfigurations = [
  {
    maintenanceWindow: {
      durationHours: 4
      schedule: {
        absoluteMonthly: '<absoluteMonthly>'
        daily: '<daily>'
        relativeMonthly: '<relativeMonthly>'
        weekly: {
          dayOfWeek: 'Sunday'
          intervalWeeks: 1
        }
      }
      startDate: '2024-07-03'
      startTime: '00:00'
      utcOffset: '+00:00'
    }
    name: 'aksManagedAutoUpgradeSchedule'
  }
]
param managedIdentities = {
  systemAssigned: true
}
param nodeProvisioningProfile = {
  mode: 'Auto'
}
param nodeResourceGroupProfile = {
  restrictionLevel: 'ReadOnly'
}
param outboundType = 'managedNATGateway'
param publicNetworkAccess = 'Enabled'
param skuName = 'Automatic'
param webApplicationRoutingEnabled = true
param workloadAutoScalerProfile = {
  keda: {
    enabled: true
  }
  verticalPodAutoscaler: {
    enabled: true
  }
}
```

</details>
<p>

### Example 2: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/defaults]


<details>

<summary>via Bicep module</summary>

```bicep
module managedCluster 'br/public:avm/res/container-service/managed-cluster:<version>' = {
  params: {
    // Required parameters
    name: 'csmin001'
    primaryAgentPoolProfiles: [
      {
        count: 3
        mode: 'System'
        name: 'systempool'
        vmSize: 'Standard_DS4_v2'
      }
    ]
    // Non-required parameters
    aadProfile: {
      enableAzureRBAC: true
      managed: true
    }
    managedIdentities: {
      systemAssigned: true
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
      "value": "csmin001"
    },
    "primaryAgentPoolProfiles": {
      "value": [
        {
          "count": 3,
          "mode": "System",
          "name": "systempool",
          "vmSize": "Standard_DS4_v2"
        }
      ]
    },
    // Non-required parameters
    "aadProfile": {
      "value": {
        "enableAzureRBAC": true,
        "managed": true
      }
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/container-service/managed-cluster:<version>'

// Required parameters
param name = 'csmin001'
param primaryAgentPoolProfiles = [
  {
    count: 3
    mode: 'System'
    name: 'systempool'
    vmSize: 'Standard_DS4_v2'
  }
]
// Non-required parameters
param aadProfile = {
  enableAzureRBAC: true
  managed: true
}
param managedIdentities = {
  systemAssigned: true
}
```

</details>
<p>

### Example 3: _Enabling encryption via a Disk Encryption Set (DES) using Customer-Managed-Keys (CMK) and a User-Assigned Identity_

This instance deploys the module with encryption-at-rest using a Disk Encryption Set (DES) secured by Customer-Managed Keys (CMK), and leveraging a User-Assigned Managed Identity to access the key.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/des-cmk-uami]


<details>

<summary>via Bicep module</summary>

```bicep
module managedCluster 'br/public:avm/res/container-service/managed-cluster:<version>' = {
  params: {
    // Required parameters
    name: 'csmscmk001'
    primaryAgentPoolProfiles: [
      {
        count: 3
        mode: 'System'
        name: 'systempool'
        vmSize: 'Standard_DS4_v2'
      }
    ]
    // Non-required parameters
    aadProfile: {
      enableAzureRBAC: true
      managed: true
    }
    diskEncryptionSetResourceId: '<diskEncryptionSetResourceId>'
    managedIdentities: {
      systemAssigned: true
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
      "value": "csmscmk001"
    },
    "primaryAgentPoolProfiles": {
      "value": [
        {
          "count": 3,
          "mode": "System",
          "name": "systempool",
          "vmSize": "Standard_DS4_v2"
        }
      ]
    },
    // Non-required parameters
    "aadProfile": {
      "value": {
        "enableAzureRBAC": true,
        "managed": true
      }
    },
    "diskEncryptionSetResourceId": {
      "value": "<diskEncryptionSetResourceId>"
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/container-service/managed-cluster:<version>'

// Required parameters
param name = 'csmscmk001'
param primaryAgentPoolProfiles = [
  {
    count: 3
    mode: 'System'
    name: 'systempool'
    vmSize: 'Standard_DS4_v2'
  }
]
// Non-required parameters
param aadProfile = {
  enableAzureRBAC: true
  managed: true
}
param diskEncryptionSetResourceId = '<diskEncryptionSetResourceId>'
param managedIdentities = {
  systemAssigned: true
}
```

</details>
<p>

### Example 4: _Using Istio Service Mesh add-on_

This instance deploys the module with Istio Service Mesh add-on and plug a Certificate Authority from Key Vault.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/istio]


<details>

<summary>via Bicep module</summary>

```bicep
module managedCluster 'br/public:avm/res/container-service/managed-cluster:<version>' = {
  params: {
    // Required parameters
    name: 'csist001'
    primaryAgentPoolProfiles: [
      {
        count: 2
        mode: 'System'
        name: 'systempool'
        vmSize: 'Standard_DS4_v2'
      }
    ]
    // Non-required parameters
    aadProfile: {
      enableAzureRBAC: true
      managed: true
    }
    enableKeyvaultSecretsProvider: true
    enableSecretRotation: true
    location: '<location>'
    managedIdentities: {
      systemAssigned: true
    }
    serviceMeshProfile: {
      istio: {
        certificateAuthority: {
          plugin: {
            certChainObjectName: '<certChainObjectName>'
            certObjectName: '<certObjectName>'
            keyObjectName: '<keyObjectName>'
            keyVaultId: '<keyVaultId>'
            rootCertObjectName: '<rootCertObjectName>'
          }
        }
        components: {
          ingressGateways: [
            {
              enabled: true
              mode: 'Internal'
            }
          ]
        }
        revisions: [
          'asm-1-27'
        ]
      }
      mode: 'Istio'
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
      "value": "csist001"
    },
    "primaryAgentPoolProfiles": {
      "value": [
        {
          "count": 2,
          "mode": "System",
          "name": "systempool",
          "vmSize": "Standard_DS4_v2"
        }
      ]
    },
    // Non-required parameters
    "aadProfile": {
      "value": {
        "enableAzureRBAC": true,
        "managed": true
      }
    },
    "enableKeyvaultSecretsProvider": {
      "value": true
    },
    "enableSecretRotation": {
      "value": true
    },
    "location": {
      "value": "<location>"
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": true
      }
    },
    "serviceMeshProfile": {
      "value": {
        "istio": {
          "certificateAuthority": {
            "plugin": {
              "certChainObjectName": "<certChainObjectName>",
              "certObjectName": "<certObjectName>",
              "keyObjectName": "<keyObjectName>",
              "keyVaultId": "<keyVaultId>",
              "rootCertObjectName": "<rootCertObjectName>"
            }
          },
          "components": {
            "ingressGateways": [
              {
                "enabled": true,
                "mode": "Internal"
              }
            ]
          },
          "revisions": [
            "asm-1-27"
          ]
        },
        "mode": "Istio"
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
using 'br/public:avm/res/container-service/managed-cluster:<version>'

// Required parameters
param name = 'csist001'
param primaryAgentPoolProfiles = [
  {
    count: 2
    mode: 'System'
    name: 'systempool'
    vmSize: 'Standard_DS4_v2'
  }
]
// Non-required parameters
param aadProfile = {
  enableAzureRBAC: true
  managed: true
}
param enableKeyvaultSecretsProvider = true
param enableSecretRotation = true
param location = '<location>'
param managedIdentities = {
  systemAssigned: true
}
param serviceMeshProfile = {
  istio: {
    certificateAuthority: {
      plugin: {
        certChainObjectName: '<certChainObjectName>'
        certObjectName: '<certObjectName>'
        keyObjectName: '<keyObjectName>'
        keyVaultId: '<keyVaultId>'
        rootCertObjectName: '<rootCertObjectName>'
      }
    }
    components: {
      ingressGateways: [
        {
          enabled: true
          mode: 'Internal'
        }
      ]
    }
    revisions: [
      'asm-1-27'
    ]
  }
  mode: 'Istio'
}
```

</details>
<p>

### Example 5: _Using Kubenet Network Plugin._

This instance deploys the module with Kubenet network plugin .

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/kubenet]


<details>

<summary>via Bicep module</summary>

```bicep
module managedCluster 'br/public:avm/res/container-service/managed-cluster:<version>' = {
  params: {
    // Required parameters
    name: 'csmkube001'
    primaryAgentPoolProfiles: [
      {
        availabilityZones: [
          3
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
        vmSize: 'Standard_DS4_v2'
      }
    ]
    // Non-required parameters
    aadProfile: {
      enableAzureRBAC: true
      managed: true
    }
    agentPools: [
      {
        availabilityZones: [
          3
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
        vmSize: 'Standard_DS4_v2'
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
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    networkPlugin: 'kubenet'
    roleAssignments: [
      {
        name: '<name>'
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
      "value": "csmkube001"
    },
    "primaryAgentPoolProfiles": {
      "value": [
        {
          "availabilityZones": [
            3
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
          "vmSize": "Standard_DS4_v2"
        }
      ]
    },
    // Non-required parameters
    "aadProfile": {
      "value": {
        "enableAzureRBAC": true,
        "managed": true
      }
    },
    "agentPools": {
      "value": [
        {
          "availabilityZones": [
            3
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
          "vmSize": "Standard_DS4_v2"
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
    "managedIdentities": {
      "value": {
        "userAssignedResourceIds": [
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
          "name": "<name>",
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
using 'br/public:avm/res/container-service/managed-cluster:<version>'

// Required parameters
param name = 'csmkube001'
param primaryAgentPoolProfiles = [
  {
    availabilityZones: [
      3
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
    vmSize: 'Standard_DS4_v2'
  }
]
// Non-required parameters
param aadProfile = {
  enableAzureRBAC: true
  managed: true
}
param agentPools = [
  {
    availabilityZones: [
      3
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
    vmSize: 'Standard_DS4_v2'
  }
]
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
param managedIdentities = {
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param networkPlugin = 'kubenet'
param roleAssignments = [
  {
    name: '<name>'
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
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
```

</details>
<p>

### Example 6: _Using large parameter set_

This instance deploys the module with most of its features enabled to test maximum parameter coverage.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/max]


<details>

<summary>via Bicep module</summary>

```bicep
module managedCluster 'br/public:avm/res/container-service/managed-cluster:<version>' = {
  params: {
    // Required parameters
    name: 'csmax001'
    primaryAgentPoolProfiles: [
      {
        availabilityZones: [
          1
          2
        ]
        count: 1
        enableAutoScaling: true
        maxCount: 3
        maxPods: 50
        minCount: 1
        mode: 'System'
        name: 'systempool'
        nodeTaints: [
          'CriticalAddonsOnly=true:NoSchedule'
        ]
        osDiskSizeGB: 128
        osDiskType: 'Managed'
        osType: 'Linux'
        powerState: {
          code: 'Running'
        }
        type: 'VirtualMachineScaleSets'
        upgradeSettings: {
          drainTimeoutInMinutes: 30
          maxSurge: '33%'
          nodeSoakDurationInMinutes: 0
        }
        vmSize: 'Standard_DS2_v2'
        vnetSubnetResourceId: '<vnetSubnetResourceId>'
      }
    ]
    // Non-required parameters
    aadProfile: {
      enableAzureRBAC: true
      managed: true
      tenantID: '<tenantID>'
    }
    aciConnectorLinuxEnabled: false
    agentPools: [
      {
        availabilityZones: [
          1
        ]
        count: 1
        enableAutoScaling: true
        kubeletConfig: {
          allowedUnsafeSysctls: [
            'net.core.somaxconn'
          ]
          containerLogMaxFiles: 5
          containerLogMaxSizeMB: 50
          cpuCfsQuota: true
          cpuCfsQuotaPeriod: '100ms'
          cpuManagerPolicy: 'static'
          failSwapOn: false
          imageGcHighThreshold: 85
          imageGcLowThreshold: 80
          podMaxPids: 100
          topologyManagerPolicy: 'best-effort'
        }
        maxCount: 2
        maxPods: 30
        minCount: 1
        minPods: 0
        mode: 'User'
        name: 'userpool1'
        nodeLabels: {
          environment: 'dev'
          workload: 'general'
        }
        nodeTaints: []
        osDiskSizeGB: 30
        osDiskType: 'Ephemeral'
        osType: 'Linux'
        powerState: {
          code: 'Running'
        }
        scaleSetEvictionPolicy: 'Delete'
        scaleSetPriority: 'Regular'
        type: 'VirtualMachineScaleSets'
        upgradeSettings: {
          drainTimeoutInMinutes: 30
          maxSurge: '50%'
          nodeSoakDurationInMinutes: 0
        }
        vmSize: 'Standard_D2s_v3'
        vnetSubnetResourceId: '<vnetSubnetResourceId>'
      }
    ]
    aiToolchainOperatorProfile: {
      enabled: false
    }
    allocatedOutboundPorts: 0
    apiServerAccessProfile: {
      enablePrivateCluster: true
      enableVnetIntegration: true
      privateDNSZone: '<privateDNSZone>'
      subnetId: '<subnetId>'
    }
    appGatewayResourceId: '<appGatewayResourceId>'
    autoScalerProfile: {
      'balance-similar-node-groups': 'false'
      'daemonset-eviction-for-empty-nodes': false
      'daemonset-eviction-for-occupied-nodes': true
      expander: 'random'
      'ignore-daemonsets-utilization': false
      'max-empty-bulk-delete': '10'
      'max-graceful-termination-sec': '600'
      'max-node-provision-time': '15m'
      'max-total-unready-percentage': '45'
      'new-pod-scale-up-delay': '0s'
      'ok-total-unready-count': '3'
      'scale-down-delay-after-add': '10m'
      'scale-down-delay-after-delete': '20s'
      'scale-down-delay-after-failure': '3m'
      'scale-down-unneeded-time': '10m'
      'scale-down-unready-time': '20m'
      'scale-down-utilization-threshold': '0.5'
      'scan-interval': '10s'
      'skip-nodes-with-local-storage': 'true'
      'skip-nodes-with-system-pods': 'true'
    }
    autoUpgradeProfile: {
      nodeOSUpgradeChannel: 'NodeImage'
      upgradeChannel: 'stable'
    }
    azurePolicyEnabled: true
    azurePolicyVersion: 'v2'
    backendPoolType: 'NodeIPConfiguration'
    costAnalysisEnabled: true
    defaultIngressControllerType: 'Internal'
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
            category: 'kube-audit'
          }
          {
            category: 'kube-audit-admin'
          }
          {
            category: 'guard'
          }
          {
            category: 'cluster-autoscaler'
          }
          {
            category: 'cloud-controller-manager'
          }
          {
            category: 'csi-azuredisk-controller'
          }
          {
            category: 'csi-azurefile-controller'
          }
          {
            category: 'csi-snapshot-controller'
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
    diskEncryptionSetResourceId: '<diskEncryptionSetResourceId>'
    dnsServiceIP: '10.10.200.10'
    enableDnsZoneContributorRoleAssignment: true
    enableKeyvaultSecretsProvider: true
    enableOidcIssuerProfile: true
    enableRBAC: true
    enableSecretRotation: true
    enableStorageProfileBlobCSIDriver: true
    enableStorageProfileDiskCSIDriver: true
    enableStorageProfileFileCSIDriver: true
    enableStorageProfileSnapshotController: true
    httpApplicationRoutingEnabled: false
    identityProfile: {
      kubeletidentity: {
        resourceId: '<resourceId>'
      }
    }
    idleTimeoutInMinutes: 30
    ingressApplicationGatewayEnabled: true
    kubeDashboardEnabled: false
    linuxProfile: {
      adminUsername: 'azureuser'
      ssh: {
        publicKeys: [
          {
            keyData: '<keyData>'
          }
        ]
      }
    }
    loadBalancerSku: 'standard'
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    maintenanceConfigurations: [
      {
        maintenanceWindow: {
          durationHours: 4
          schedule: {
            weekly: {
              dayOfWeek: 'Sunday'
              intervalWeeks: 1
            }
          }
          startDate: '2024-07-15'
          startTime: '00:00'
          utcOffset: '+00:00'
        }
        name: 'aksManagedAutoUpgradeSchedule'
      }
      {
        maintenanceWindow: {
          durationHours: 6
          schedule: {
            weekly: {
              dayOfWeek: 'Saturday'
              intervalWeeks: 1
            }
          }
          startDate: '2024-07-15'
          startTime: '02:00'
          utcOffset: '+00:00'
        }
        name: 'aksManagedNodeOSUpgradeSchedule'
      }
    ]
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    managedOutboundIPCount: 2
    monitoringWorkspaceResourceId: '<monitoringWorkspaceResourceId>'
    networkDataplane: 'azure'
    networkPlugin: 'azure'
    networkPluginMode: 'overlay'
    networkPolicy: 'azure'
    nodeProvisioningProfile: {
      mode: 'Manual'
    }
    nodeResourceGroup: '<nodeResourceGroup>'
    nodeResourceGroupProfile: {
      restrictionLevel: 'ReadOnly'
    }
    omsAgentEnabled: true
    omsAgentUseAADAuth: true
    openServiceMeshEnabled: false
    outboundPublicIPResourceIds: [
      '<publicIPAKSResourceId>'
    ]
    outboundType: 'loadBalancer'
    podCidr: '10.244.0.0/16'
    podIdentityProfile: {
      enabled: false
    }
    publicNetworkAccess: 'Disabled'
    roleAssignments: [
      {
        name: '<name>'
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Owner'
      }
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Azure Kubernetes Service RBAC Cluster Admin'
      }
    ]
    securityProfile: {
      defender: {
        logAnalyticsWorkspaceResourceId: '<logAnalyticsWorkspaceResourceId>'
        securityMonitoring: {
          enabled: true
        }
      }
      imageCleaner: {
        enabled: true
        intervalHours: 48
      }
    }
    serviceCidr: '10.10.200.0/24'
    serviceMeshProfile: {
      mode: 'Disabled'
    }
    skuName: 'Base'
    skuTier: 'Standard'
    supportPlan: 'KubernetesOfficial'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    upgradeSettings: {
      overrideSettings: {
        forceUpgrade: false
        until: '2025-12-31T23:59:59Z'
      }
    }
    webApplicationRoutingEnabled: true
    workloadAutoScalerProfile: {
      keda: {
        enabled: true
      }
      verticalPodAutoscaler: {
        enabled: true
      }
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
      "value": "csmax001"
    },
    "primaryAgentPoolProfiles": {
      "value": [
        {
          "availabilityZones": [
            1,
            2
          ],
          "count": 1,
          "enableAutoScaling": true,
          "maxCount": 3,
          "maxPods": 50,
          "minCount": 1,
          "mode": "System",
          "name": "systempool",
          "nodeTaints": [
            "CriticalAddonsOnly=true:NoSchedule"
          ],
          "osDiskSizeGB": 128,
          "osDiskType": "Managed",
          "osType": "Linux",
          "powerState": {
            "code": "Running"
          },
          "type": "VirtualMachineScaleSets",
          "upgradeSettings": {
            "drainTimeoutInMinutes": 30,
            "maxSurge": "33%",
            "nodeSoakDurationInMinutes": 0
          },
          "vmSize": "Standard_DS2_v2",
          "vnetSubnetResourceId": "<vnetSubnetResourceId>"
        }
      ]
    },
    // Non-required parameters
    "aadProfile": {
      "value": {
        "enableAzureRBAC": true,
        "managed": true,
        "tenantID": "<tenantID>"
      }
    },
    "aciConnectorLinuxEnabled": {
      "value": false
    },
    "agentPools": {
      "value": [
        {
          "availabilityZones": [
            1
          ],
          "count": 1,
          "enableAutoScaling": true,
          "kubeletConfig": {
            "allowedUnsafeSysctls": [
              "net.core.somaxconn"
            ],
            "containerLogMaxFiles": 5,
            "containerLogMaxSizeMB": 50,
            "cpuCfsQuota": true,
            "cpuCfsQuotaPeriod": "100ms",
            "cpuManagerPolicy": "static",
            "failSwapOn": false,
            "imageGcHighThreshold": 85,
            "imageGcLowThreshold": 80,
            "podMaxPids": 100,
            "topologyManagerPolicy": "best-effort"
          },
          "maxCount": 2,
          "maxPods": 30,
          "minCount": 1,
          "minPods": 0,
          "mode": "User",
          "name": "userpool1",
          "nodeLabels": {
            "environment": "dev",
            "workload": "general"
          },
          "nodeTaints": [],
          "osDiskSizeGB": 30,
          "osDiskType": "Ephemeral",
          "osType": "Linux",
          "powerState": {
            "code": "Running"
          },
          "scaleSetEvictionPolicy": "Delete",
          "scaleSetPriority": "Regular",
          "type": "VirtualMachineScaleSets",
          "upgradeSettings": {
            "drainTimeoutInMinutes": 30,
            "maxSurge": "50%",
            "nodeSoakDurationInMinutes": 0
          },
          "vmSize": "Standard_D2s_v3",
          "vnetSubnetResourceId": "<vnetSubnetResourceId>"
        }
      ]
    },
    "aiToolchainOperatorProfile": {
      "value": {
        "enabled": false
      }
    },
    "allocatedOutboundPorts": {
      "value": 0
    },
    "apiServerAccessProfile": {
      "value": {
        "enablePrivateCluster": true,
        "enableVnetIntegration": true,
        "privateDNSZone": "<privateDNSZone>",
        "subnetId": "<subnetId>"
      }
    },
    "appGatewayResourceId": {
      "value": "<appGatewayResourceId>"
    },
    "autoScalerProfile": {
      "value": {
        "balance-similar-node-groups": "false",
        "daemonset-eviction-for-empty-nodes": false,
        "daemonset-eviction-for-occupied-nodes": true,
        "expander": "random",
        "ignore-daemonsets-utilization": false,
        "max-empty-bulk-delete": "10",
        "max-graceful-termination-sec": "600",
        "max-node-provision-time": "15m",
        "max-total-unready-percentage": "45",
        "new-pod-scale-up-delay": "0s",
        "ok-total-unready-count": "3",
        "scale-down-delay-after-add": "10m",
        "scale-down-delay-after-delete": "20s",
        "scale-down-delay-after-failure": "3m",
        "scale-down-unneeded-time": "10m",
        "scale-down-unready-time": "20m",
        "scale-down-utilization-threshold": "0.5",
        "scan-interval": "10s",
        "skip-nodes-with-local-storage": "true",
        "skip-nodes-with-system-pods": "true"
      }
    },
    "autoUpgradeProfile": {
      "value": {
        "nodeOSUpgradeChannel": "NodeImage",
        "upgradeChannel": "stable"
      }
    },
    "azurePolicyEnabled": {
      "value": true
    },
    "azurePolicyVersion": {
      "value": "v2"
    },
    "backendPoolType": {
      "value": "NodeIPConfiguration"
    },
    "costAnalysisEnabled": {
      "value": true
    },
    "defaultIngressControllerType": {
      "value": "Internal"
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
              "category": "kube-audit"
            },
            {
              "category": "kube-audit-admin"
            },
            {
              "category": "guard"
            },
            {
              "category": "cluster-autoscaler"
            },
            {
              "category": "cloud-controller-manager"
            },
            {
              "category": "csi-azuredisk-controller"
            },
            {
              "category": "csi-azurefile-controller"
            },
            {
              "category": "csi-snapshot-controller"
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
    "diskEncryptionSetResourceId": {
      "value": "<diskEncryptionSetResourceId>"
    },
    "dnsServiceIP": {
      "value": "10.10.200.10"
    },
    "enableDnsZoneContributorRoleAssignment": {
      "value": true
    },
    "enableKeyvaultSecretsProvider": {
      "value": true
    },
    "enableOidcIssuerProfile": {
      "value": true
    },
    "enableRBAC": {
      "value": true
    },
    "enableSecretRotation": {
      "value": true
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
    "httpApplicationRoutingEnabled": {
      "value": false
    },
    "identityProfile": {
      "value": {
        "kubeletidentity": {
          "resourceId": "<resourceId>"
        }
      }
    },
    "idleTimeoutInMinutes": {
      "value": 30
    },
    "ingressApplicationGatewayEnabled": {
      "value": true
    },
    "kubeDashboardEnabled": {
      "value": false
    },
    "linuxProfile": {
      "value": {
        "adminUsername": "azureuser",
        "ssh": {
          "publicKeys": [
            {
              "keyData": "<keyData>"
            }
          ]
        }
      }
    },
    "loadBalancerSku": {
      "value": "standard"
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
    "maintenanceConfigurations": {
      "value": [
        {
          "maintenanceWindow": {
            "durationHours": 4,
            "schedule": {
              "weekly": {
                "dayOfWeek": "Sunday",
                "intervalWeeks": 1
              }
            },
            "startDate": "2024-07-15",
            "startTime": "00:00",
            "utcOffset": "+00:00"
          },
          "name": "aksManagedAutoUpgradeSchedule"
        },
        {
          "maintenanceWindow": {
            "durationHours": 6,
            "schedule": {
              "weekly": {
                "dayOfWeek": "Saturday",
                "intervalWeeks": 1
              }
            },
            "startDate": "2024-07-15",
            "startTime": "02:00",
            "utcOffset": "+00:00"
          },
          "name": "aksManagedNodeOSUpgradeSchedule"
        }
      ]
    },
    "managedIdentities": {
      "value": {
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "managedOutboundIPCount": {
      "value": 2
    },
    "monitoringWorkspaceResourceId": {
      "value": "<monitoringWorkspaceResourceId>"
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
    "networkPolicy": {
      "value": "azure"
    },
    "nodeProvisioningProfile": {
      "value": {
        "mode": "Manual"
      }
    },
    "nodeResourceGroup": {
      "value": "<nodeResourceGroup>"
    },
    "nodeResourceGroupProfile": {
      "value": {
        "restrictionLevel": "ReadOnly"
      }
    },
    "omsAgentEnabled": {
      "value": true
    },
    "omsAgentUseAADAuth": {
      "value": true
    },
    "openServiceMeshEnabled": {
      "value": false
    },
    "outboundPublicIPResourceIds": {
      "value": [
        "<publicIPAKSResourceId>"
      ]
    },
    "outboundType": {
      "value": "loadBalancer"
    },
    "podCidr": {
      "value": "10.244.0.0/16"
    },
    "podIdentityProfile": {
      "value": {
        "enabled": false
      }
    },
    "publicNetworkAccess": {
      "value": "Disabled"
    },
    "roleAssignments": {
      "value": [
        {
          "name": "<name>",
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Owner"
        },
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Azure Kubernetes Service RBAC Cluster Admin"
        }
      ]
    },
    "securityProfile": {
      "value": {
        "defender": {
          "logAnalyticsWorkspaceResourceId": "<logAnalyticsWorkspaceResourceId>",
          "securityMonitoring": {
            "enabled": true
          }
        },
        "imageCleaner": {
          "enabled": true,
          "intervalHours": 48
        }
      }
    },
    "serviceCidr": {
      "value": "10.10.200.0/24"
    },
    "serviceMeshProfile": {
      "value": {
        "mode": "Disabled"
      }
    },
    "skuName": {
      "value": "Base"
    },
    "skuTier": {
      "value": "Standard"
    },
    "supportPlan": {
      "value": "KubernetesOfficial"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "upgradeSettings": {
      "value": {
        "overrideSettings": {
          "forceUpgrade": false,
          "until": "2025-12-31T23:59:59Z"
        }
      }
    },
    "webApplicationRoutingEnabled": {
      "value": true
    },
    "workloadAutoScalerProfile": {
      "value": {
        "keda": {
          "enabled": true
        },
        "verticalPodAutoscaler": {
          "enabled": true
        }
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
using 'br/public:avm/res/container-service/managed-cluster:<version>'

// Required parameters
param name = 'csmax001'
param primaryAgentPoolProfiles = [
  {
    availabilityZones: [
      1
      2
    ]
    count: 1
    enableAutoScaling: true
    maxCount: 3
    maxPods: 50
    minCount: 1
    mode: 'System'
    name: 'systempool'
    nodeTaints: [
      'CriticalAddonsOnly=true:NoSchedule'
    ]
    osDiskSizeGB: 128
    osDiskType: 'Managed'
    osType: 'Linux'
    powerState: {
      code: 'Running'
    }
    type: 'VirtualMachineScaleSets'
    upgradeSettings: {
      drainTimeoutInMinutes: 30
      maxSurge: '33%'
      nodeSoakDurationInMinutes: 0
    }
    vmSize: 'Standard_DS2_v2'
    vnetSubnetResourceId: '<vnetSubnetResourceId>'
  }
]
// Non-required parameters
param aadProfile = {
  enableAzureRBAC: true
  managed: true
  tenantID: '<tenantID>'
}
param aciConnectorLinuxEnabled = false
param agentPools = [
  {
    availabilityZones: [
      1
    ]
    count: 1
    enableAutoScaling: true
    kubeletConfig: {
      allowedUnsafeSysctls: [
        'net.core.somaxconn'
      ]
      containerLogMaxFiles: 5
      containerLogMaxSizeMB: 50
      cpuCfsQuota: true
      cpuCfsQuotaPeriod: '100ms'
      cpuManagerPolicy: 'static'
      failSwapOn: false
      imageGcHighThreshold: 85
      imageGcLowThreshold: 80
      podMaxPids: 100
      topologyManagerPolicy: 'best-effort'
    }
    maxCount: 2
    maxPods: 30
    minCount: 1
    minPods: 0
    mode: 'User'
    name: 'userpool1'
    nodeLabels: {
      environment: 'dev'
      workload: 'general'
    }
    nodeTaints: []
    osDiskSizeGB: 30
    osDiskType: 'Ephemeral'
    osType: 'Linux'
    powerState: {
      code: 'Running'
    }
    scaleSetEvictionPolicy: 'Delete'
    scaleSetPriority: 'Regular'
    type: 'VirtualMachineScaleSets'
    upgradeSettings: {
      drainTimeoutInMinutes: 30
      maxSurge: '50%'
      nodeSoakDurationInMinutes: 0
    }
    vmSize: 'Standard_D2s_v3'
    vnetSubnetResourceId: '<vnetSubnetResourceId>'
  }
]
param aiToolchainOperatorProfile = {
  enabled: false
}
param allocatedOutboundPorts = 0
param apiServerAccessProfile = {
  enablePrivateCluster: true
  enableVnetIntegration: true
  privateDNSZone: '<privateDNSZone>'
  subnetId: '<subnetId>'
}
param appGatewayResourceId = '<appGatewayResourceId>'
param autoScalerProfile = {
  'balance-similar-node-groups': 'false'
  'daemonset-eviction-for-empty-nodes': false
  'daemonset-eviction-for-occupied-nodes': true
  expander: 'random'
  'ignore-daemonsets-utilization': false
  'max-empty-bulk-delete': '10'
  'max-graceful-termination-sec': '600'
  'max-node-provision-time': '15m'
  'max-total-unready-percentage': '45'
  'new-pod-scale-up-delay': '0s'
  'ok-total-unready-count': '3'
  'scale-down-delay-after-add': '10m'
  'scale-down-delay-after-delete': '20s'
  'scale-down-delay-after-failure': '3m'
  'scale-down-unneeded-time': '10m'
  'scale-down-unready-time': '20m'
  'scale-down-utilization-threshold': '0.5'
  'scan-interval': '10s'
  'skip-nodes-with-local-storage': 'true'
  'skip-nodes-with-system-pods': 'true'
}
param autoUpgradeProfile = {
  nodeOSUpgradeChannel: 'NodeImage'
  upgradeChannel: 'stable'
}
param azurePolicyEnabled = true
param azurePolicyVersion = 'v2'
param backendPoolType = 'NodeIPConfiguration'
param costAnalysisEnabled = true
param defaultIngressControllerType = 'Internal'
param diagnosticSettings = [
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
        category: 'kube-audit'
      }
      {
        category: 'kube-audit-admin'
      }
      {
        category: 'guard'
      }
      {
        category: 'cluster-autoscaler'
      }
      {
        category: 'cloud-controller-manager'
      }
      {
        category: 'csi-azuredisk-controller'
      }
      {
        category: 'csi-azurefile-controller'
      }
      {
        category: 'csi-snapshot-controller'
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
param disableLocalAccounts = true
param diskEncryptionSetResourceId = '<diskEncryptionSetResourceId>'
param dnsServiceIP = '10.10.200.10'
param enableDnsZoneContributorRoleAssignment = true
param enableKeyvaultSecretsProvider = true
param enableOidcIssuerProfile = true
param enableRBAC = true
param enableSecretRotation = true
param enableStorageProfileBlobCSIDriver = true
param enableStorageProfileDiskCSIDriver = true
param enableStorageProfileFileCSIDriver = true
param enableStorageProfileSnapshotController = true
param httpApplicationRoutingEnabled = false
param identityProfile = {
  kubeletidentity: {
    resourceId: '<resourceId>'
  }
}
param idleTimeoutInMinutes = 30
param ingressApplicationGatewayEnabled = true
param kubeDashboardEnabled = false
param linuxProfile = {
  adminUsername: 'azureuser'
  ssh: {
    publicKeys: [
      {
        keyData: '<keyData>'
      }
    ]
  }
}
param loadBalancerSku = 'standard'
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param maintenanceConfigurations = [
  {
    maintenanceWindow: {
      durationHours: 4
      schedule: {
        weekly: {
          dayOfWeek: 'Sunday'
          intervalWeeks: 1
        }
      }
      startDate: '2024-07-15'
      startTime: '00:00'
      utcOffset: '+00:00'
    }
    name: 'aksManagedAutoUpgradeSchedule'
  }
  {
    maintenanceWindow: {
      durationHours: 6
      schedule: {
        weekly: {
          dayOfWeek: 'Saturday'
          intervalWeeks: 1
        }
      }
      startDate: '2024-07-15'
      startTime: '02:00'
      utcOffset: '+00:00'
    }
    name: 'aksManagedNodeOSUpgradeSchedule'
  }
]
param managedIdentities = {
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param managedOutboundIPCount = 2
param monitoringWorkspaceResourceId = '<monitoringWorkspaceResourceId>'
param networkDataplane = 'azure'
param networkPlugin = 'azure'
param networkPluginMode = 'overlay'
param networkPolicy = 'azure'
param nodeProvisioningProfile = {
  mode: 'Manual'
}
param nodeResourceGroup = '<nodeResourceGroup>'
param nodeResourceGroupProfile = {
  restrictionLevel: 'ReadOnly'
}
param omsAgentEnabled = true
param omsAgentUseAADAuth = true
param openServiceMeshEnabled = false
param outboundPublicIPResourceIds = [
  '<publicIPAKSResourceId>'
]
param outboundType = 'loadBalancer'
param podCidr = '10.244.0.0/16'
param podIdentityProfile = {
  enabled: false
}
param publicNetworkAccess = 'Disabled'
param roleAssignments = [
  {
    name: '<name>'
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'Owner'
  }
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'Azure Kubernetes Service RBAC Cluster Admin'
  }
]
param securityProfile = {
  defender: {
    logAnalyticsWorkspaceResourceId: '<logAnalyticsWorkspaceResourceId>'
    securityMonitoring: {
      enabled: true
    }
  }
  imageCleaner: {
    enabled: true
    intervalHours: 48
  }
}
param serviceCidr = '10.10.200.0/24'
param serviceMeshProfile = {
  mode: 'Disabled'
}
param skuName = 'Base'
param skuTier = 'Standard'
param supportPlan = 'KubernetesOfficial'
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
param upgradeSettings = {
  overrideSettings: {
    forceUpgrade: false
    until: '2025-12-31T23:59:59Z'
  }
}
param webApplicationRoutingEnabled = true
param workloadAutoScalerProfile = {
  keda: {
    enabled: true
  }
  verticalPodAutoscaler: {
    enabled: true
  }
}
```

</details>
<p>

### Example 7: _Using Private Cluster._

This instance deploys the module with a private cluster instance.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/priv]


<details>

<summary>via Bicep module</summary>

```bicep
module managedCluster 'br/public:avm/res/container-service/managed-cluster:<version>' = {
  params: {
    // Required parameters
    name: 'csmpriv001'
    primaryAgentPoolProfiles: [
      {
        availabilityZones: [
          3
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
        vmSize: 'Standard_DS4_v2'
        vnetSubnetResourceId: '<vnetSubnetResourceId>'
      }
    ]
    // Non-required parameters
    aadProfile: {
      enableAzureRBAC: true
      managed: true
    }
    agentPools: [
      {
        availabilityZones: [
          3
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
        vmSize: 'Standard_DS4_v2'
        vnetSubnetResourceId: '<vnetSubnetResourceId>'
      }
    ]
    apiServerAccessProfile: {
      enablePrivateCluster: true
      privateDNSZone: '<privateDNSZone>'
    }
    dnsServiceIP: '10.10.200.10'
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    networkPlugin: 'azure'
    serviceCidr: '10.10.200.0/24'
    skuTier: 'Standard'
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
      "value": "csmpriv001"
    },
    "primaryAgentPoolProfiles": {
      "value": [
        {
          "availabilityZones": [
            3
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
          "vmSize": "Standard_DS4_v2",
          "vnetSubnetResourceId": "<vnetSubnetResourceId>"
        }
      ]
    },
    // Non-required parameters
    "aadProfile": {
      "value": {
        "enableAzureRBAC": true,
        "managed": true
      }
    },
    "agentPools": {
      "value": [
        {
          "availabilityZones": [
            3
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
          "vmSize": "Standard_DS4_v2",
          "vnetSubnetResourceId": "<vnetSubnetResourceId>"
        }
      ]
    },
    "apiServerAccessProfile": {
      "value": {
        "enablePrivateCluster": true,
        "privateDNSZone": "<privateDNSZone>"
      }
    },
    "dnsServiceIP": {
      "value": "10.10.200.10"
    },
    "managedIdentities": {
      "value": {
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "networkPlugin": {
      "value": "azure"
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/container-service/managed-cluster:<version>'

// Required parameters
param name = 'csmpriv001'
param primaryAgentPoolProfiles = [
  {
    availabilityZones: [
      3
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
    vmSize: 'Standard_DS4_v2'
    vnetSubnetResourceId: '<vnetSubnetResourceId>'
  }
]
// Non-required parameters
param aadProfile = {
  enableAzureRBAC: true
  managed: true
}
param agentPools = [
  {
    availabilityZones: [
      3
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
    vmSize: 'Standard_DS4_v2'
    vnetSubnetResourceId: '<vnetSubnetResourceId>'
  }
]
param apiServerAccessProfile = {
  enablePrivateCluster: true
  privateDNSZone: '<privateDNSZone>'
}
param dnsServiceIP = '10.10.200.10'
param managedIdentities = {
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param networkPlugin = 'azure'
param serviceCidr = '10.10.200.0/24'
param skuTier = 'Standard'
```

</details>
<p>

### Example 8: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Well-Architected Framework.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/waf-aligned]


<details>

<summary>via Bicep module</summary>

```bicep
module managedCluster 'br/public:avm/res/container-service/managed-cluster:<version>' = {
  params: {
    // Required parameters
    name: 'cswaf001'
    primaryAgentPoolProfiles: [
      {
        availabilityZones: [
          3
        ]
        count: 1
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
        vmSize: 'Standard_DS4_v2'
        vnetSubnetResourceId: '<vnetSubnetResourceId>'
      }
    ]
    // Non-required parameters
    aadProfile: {
      enableAzureRBAC: true
      managed: true
    }
    agentPools: [
      {
        availabilityZones: [
          3
        ]
        count: 2
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
        vmSize: 'Standard_DS4_v2'
        vnetSubnetResourceId: '<vnetSubnetResourceId>'
      }
      {
        availabilityZones: [
          3
        ]
        count: 2
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
        vmSize: 'Standard_DS4_v2'
      }
    ]
    apiServerAccessProfile: {
      enablePrivateCluster: true
      privateDNSZone: '<privateDNSZone>'
    }
    autoUpgradeProfile: {
      nodeOSUpgradeChannel: 'Unmanaged'
      upgradeChannel: 'stable'
    }
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
    maintenanceConfigurations: [
      {
        maintenanceWindow: {
          durationHours: 4
          schedule: {
            weekly: {
              dayOfWeek: 'Sunday'
              intervalWeeks: 1
            }
          }
          startDate: '2024-07-15'
          startTime: '00:00'
          utcOffset: '+00:00'
        }
        name: 'aksManagedAutoUpgradeSchedule'
      }
      {
        maintenanceWindow: {
          durationHours: 4
          schedule: {
            weekly: {
              dayOfWeek: 'Sunday'
              intervalWeeks: 1
            }
          }
          startDate: '2024-07-15'
          startTime: '00:00'
          utcOffset: '+00:00'
        }
        name: 'aksManagedNodeOSUpgradeSchedule'
      }
    ]
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    monitoringWorkspaceResourceId: '<monitoringWorkspaceResourceId>'
    networkPlugin: 'azure'
    networkPolicy: 'azure'
    omsAgentEnabled: true
    securityProfile: {
      defender: {
        logAnalyticsWorkspaceResourceId: '<logAnalyticsWorkspaceResourceId>'
        securityMonitoring: {
          enabled: true
        }
      }
    }
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

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "cswaf001"
    },
    "primaryAgentPoolProfiles": {
      "value": [
        {
          "availabilityZones": [
            3
          ],
          "count": 1,
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
          "vmSize": "Standard_DS4_v2",
          "vnetSubnetResourceId": "<vnetSubnetResourceId>"
        }
      ]
    },
    // Non-required parameters
    "aadProfile": {
      "value": {
        "enableAzureRBAC": true,
        "managed": true
      }
    },
    "agentPools": {
      "value": [
        {
          "availabilityZones": [
            3
          ],
          "count": 2,
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
          "vmSize": "Standard_DS4_v2",
          "vnetSubnetResourceId": "<vnetSubnetResourceId>"
        },
        {
          "availabilityZones": [
            3
          ],
          "count": 2,
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
          "vmSize": "Standard_DS4_v2"
        }
      ]
    },
    "apiServerAccessProfile": {
      "value": {
        "enablePrivateCluster": true,
        "privateDNSZone": "<privateDNSZone>"
      }
    },
    "autoUpgradeProfile": {
      "value": {
        "nodeOSUpgradeChannel": "Unmanaged",
        "upgradeChannel": "stable"
      }
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
    "maintenanceConfigurations": {
      "value": [
        {
          "maintenanceWindow": {
            "durationHours": 4,
            "schedule": {
              "weekly": {
                "dayOfWeek": "Sunday",
                "intervalWeeks": 1
              }
            },
            "startDate": "2024-07-15",
            "startTime": "00:00",
            "utcOffset": "+00:00"
          },
          "name": "aksManagedAutoUpgradeSchedule"
        },
        {
          "maintenanceWindow": {
            "durationHours": 4,
            "schedule": {
              "weekly": {
                "dayOfWeek": "Sunday",
                "intervalWeeks": 1
              }
            },
            "startDate": "2024-07-15",
            "startTime": "00:00",
            "utcOffset": "+00:00"
          },
          "name": "aksManagedNodeOSUpgradeSchedule"
        }
      ]
    },
    "managedIdentities": {
      "value": {
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "monitoringWorkspaceResourceId": {
      "value": "<monitoringWorkspaceResourceId>"
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
    "securityProfile": {
      "value": {
        "defender": {
          "logAnalyticsWorkspaceResourceId": "<logAnalyticsWorkspaceResourceId>",
          "securityMonitoring": {
            "enabled": true
          }
        }
      }
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/container-service/managed-cluster:<version>'

// Required parameters
param name = 'cswaf001'
param primaryAgentPoolProfiles = [
  {
    availabilityZones: [
      3
    ]
    count: 1
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
    vmSize: 'Standard_DS4_v2'
    vnetSubnetResourceId: '<vnetSubnetResourceId>'
  }
]
// Non-required parameters
param aadProfile = {
  enableAzureRBAC: true
  managed: true
}
param agentPools = [
  {
    availabilityZones: [
      3
    ]
    count: 2
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
    vmSize: 'Standard_DS4_v2'
    vnetSubnetResourceId: '<vnetSubnetResourceId>'
  }
  {
    availabilityZones: [
      3
    ]
    count: 2
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
    vmSize: 'Standard_DS4_v2'
  }
]
param apiServerAccessProfile = {
  enablePrivateCluster: true
  privateDNSZone: '<privateDNSZone>'
}
param autoUpgradeProfile = {
  nodeOSUpgradeChannel: 'Unmanaged'
  upgradeChannel: 'stable'
}
param diagnosticSettings = [
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
param disableLocalAccounts = true
param dnsServiceIP = '10.10.200.10'
param maintenanceConfigurations = [
  {
    maintenanceWindow: {
      durationHours: 4
      schedule: {
        weekly: {
          dayOfWeek: 'Sunday'
          intervalWeeks: 1
        }
      }
      startDate: '2024-07-15'
      startTime: '00:00'
      utcOffset: '+00:00'
    }
    name: 'aksManagedAutoUpgradeSchedule'
  }
  {
    maintenanceWindow: {
      durationHours: 4
      schedule: {
        weekly: {
          dayOfWeek: 'Sunday'
          intervalWeeks: 1
        }
      }
      startDate: '2024-07-15'
      startTime: '00:00'
      utcOffset: '+00:00'
    }
    name: 'aksManagedNodeOSUpgradeSchedule'
  }
]
param managedIdentities = {
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param monitoringWorkspaceResourceId = '<monitoringWorkspaceResourceId>'
param networkPlugin = 'azure'
param networkPolicy = 'azure'
param omsAgentEnabled = true
param securityProfile = {
  defender: {
    logAnalyticsWorkspaceResourceId: '<logAnalyticsWorkspaceResourceId>'
    securityMonitoring: {
      enabled: true
    }
  }
}
param serviceCidr = '10.10.200.0/24'
param skuTier = 'Standard'
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
| [`name`](#parameter-name) | string | Specifies the name of the AKS cluster. |
| [`primaryAgentPoolProfiles`](#parameter-primaryagentpoolprofiles) | array | Properties of the primary agent pool. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`aksServicePrincipalProfile`](#parameter-aksserviceprincipalprofile) | object | Information about a service principal identity for the cluster to use for manipulating Azure APIs. Required if no managed identities are assigned to the cluster. |
| [`appGatewayResourceId`](#parameter-appgatewayresourceid) | string | Specifies the resource ID of connected application gateway. Required if `ingressApplicationGatewayEnabled` is set to `true`. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`aadProfile`](#parameter-aadprofile) | object | Enable Azure Active Directory integration. |
| [`aciConnectorLinuxEnabled`](#parameter-aciconnectorlinuxenabled) | bool | Specifies whether the aciConnectorLinux add-on is enabled or not. |
| [`advancedNetworking`](#parameter-advancednetworking) | object | Advanced Networking profile for enabling observability and security feature suite on a cluster. For more information see https://aka.ms/aksadvancednetworking. |
| [`agentPools`](#parameter-agentpools) | array | Define one or more secondary/additional agent pools. |
| [`aiToolchainOperatorProfile`](#parameter-aitoolchainoperatorprofile) | object | AI toolchain operator settings that apply to the whole cluster. |
| [`allocatedOutboundPorts`](#parameter-allocatedoutboundports) | int | The desired number of allocated SNAT ports per VM. Default is 0, which results in Azure dynamically allocating ports. |
| [`apiServerAccessProfile`](#parameter-apiserveraccessprofile) | object | The access profile for managed cluster API server. |
| [`autoScalerProfile`](#parameter-autoscalerprofile) | object | Parameters to be applied to the cluster-autoscaler when enabled. |
| [`autoUpgradeProfile`](#parameter-autoupgradeprofile) | object | The auto upgrade configuration. |
| [`azureMonitorProfile`](#parameter-azuremonitorprofile) | object | Azure Monitor addon profiles for monitoring the managed cluster. |
| [`azurePolicyEnabled`](#parameter-azurepolicyenabled) | bool | Specifies whether the azurepolicy add-on is enabled or not. For security reasons, this setting should be enabled. |
| [`azurePolicyVersion`](#parameter-azurepolicyversion) | string | Specifies the azure policy version to use. |
| [`backendPoolType`](#parameter-backendpooltype) | string | The type of the managed inbound Load Balancer BackendPool. |
| [`bootstrapProfile`](#parameter-bootstrapprofile) | object | Profile of the cluster bootstrap configuration. |
| [`costAnalysisEnabled`](#parameter-costanalysisenabled) | bool | Specifies whether the cost analysis add-on is enabled or not. If Enabled `enableStorageProfileDiskCSIDriver` is set to true as it is needed. |
| [`defaultIngressControllerType`](#parameter-defaultingresscontrollertype) | string | Ingress type for the default NginxIngressController custom resource. It will be ignored if `webApplicationRoutingEnabled` is set to `false`. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`disableLocalAccounts`](#parameter-disablelocalaccounts) | bool | If set to true, getting static credentials will be disabled for this cluster. This must only be used on Managed Clusters that are AAD enabled. |
| [`diskEncryptionSetResourceId`](#parameter-diskencryptionsetresourceid) | string | The Resource ID of the disk encryption set to use for enabling encryption at rest. For security reasons, this value should be provided. |
| [`dnsPrefix`](#parameter-dnsprefix) | string | Specifies the DNS prefix specified when creating the managed cluster. |
| [`dnsServiceIP`](#parameter-dnsserviceip) | string | Specifies the IP address assigned to the Kubernetes DNS service. It must be within the Kubernetes service address range specified in serviceCidr. |
| [`dnsZoneResourceId`](#parameter-dnszoneresourceid) | string | Specifies the resource ID of connected DNS zone. It will be ignored if `webApplicationRoutingEnabled` is set to `false`. |
| [`enableDnsZoneContributorRoleAssignment`](#parameter-enablednszonecontributorroleassignment) | bool | Specifies whether assing the DNS zone contributor role to the cluster service principal. It will be ignored if `webApplicationRoutingEnabled` is set to `false` or `dnsZoneResourceId` not provided. |
| [`enableKeyvaultSecretsProvider`](#parameter-enablekeyvaultsecretsprovider) | bool | Specifies whether the KeyvaultSecretsProvider add-on is enabled or not. |
| [`enableOidcIssuerProfile`](#parameter-enableoidcissuerprofile) | bool | Whether the The OIDC issuer profile of the Managed Cluster is enabled. |
| [`enableRBAC`](#parameter-enablerbac) | bool | Whether to enable Kubernetes Role-Based Access Control. |
| [`enableSecretRotation`](#parameter-enablesecretrotation) | bool | Specifies whether the KeyvaultSecretsProvider add-on uses secret rotation. |
| [`enableStorageProfileBlobCSIDriver`](#parameter-enablestorageprofileblobcsidriver) | bool | Whether the AzureBlob CSI Driver for the storage profile is enabled. |
| [`enableStorageProfileDiskCSIDriver`](#parameter-enablestorageprofilediskcsidriver) | bool | Whether the AzureDisk CSI Driver for the storage profile is enabled. |
| [`enableStorageProfileFileCSIDriver`](#parameter-enablestorageprofilefilecsidriver) | bool | Whether the AzureFile CSI Driver for the storage profile is enabled. |
| [`enableStorageProfileSnapshotController`](#parameter-enablestorageprofilesnapshotcontroller) | bool | Whether the snapshot controller for the storage profile is enabled. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`fluxExtension`](#parameter-fluxextension) | object | Settings and configurations for the flux extension. |
| [`fqdnSubdomain`](#parameter-fqdnsubdomain) | string | The FQDN subdomain of the private cluster with custom private dns zone. This cannot be updated once the Managed Cluster has been created. |
| [`httpApplicationRoutingEnabled`](#parameter-httpapplicationroutingenabled) | bool | Specifies whether the httpApplicationRouting add-on is enabled or not. |
| [`httpProxyConfig`](#parameter-httpproxyconfig) | object | Configurations for provisioning the cluster with HTTP proxy servers. |
| [`identityProfile`](#parameter-identityprofile) | object | Identities associated with the cluster. |
| [`idleTimeoutInMinutes`](#parameter-idletimeoutinminutes) | int | Desired outbound flow idle timeout in minutes. |
| [`ingressApplicationGatewayEnabled`](#parameter-ingressapplicationgatewayenabled) | bool | Specifies whether the ingressApplicationGateway (AGIC) add-on is enabled or not. |
| [`ipFamilies`](#parameter-ipfamilies) | array | The IP families used for the cluster. |
| [`kubeDashboardEnabled`](#parameter-kubedashboardenabled) | bool | Specifies whether the kubeDashboard add-on is enabled or not. |
| [`kubernetesVersion`](#parameter-kubernetesversion) | string | Version of Kubernetes specified when creating the managed cluster. |
| [`linuxProfile`](#parameter-linuxprofile) | object | The profile for Linux VMs in the Managed Cluster. |
| [`loadBalancerSku`](#parameter-loadbalancersku) | string | Specifies the sku of the load balancer used by the virtual machine scale sets used by nodepools. |
| [`location`](#parameter-location) | string | Specifies the location of AKS cluster. It picks up Resource Group's location by default. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`maintenanceConfigurations`](#parameter-maintenanceconfigurations) | array | Maintenance configurations for the managed cluster. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. Only one type of identity is supported: system-assigned or user-assigned, but not both. |
| [`managedOutboundIPCount`](#parameter-managedoutboundipcount) | int | Outbound IP Count for the Load balancer. |
| [`monitoringWorkspaceResourceId`](#parameter-monitoringworkspaceresourceid) | string | Resource ID of the monitoring log analytics workspace. |
| [`natGatewayProfile`](#parameter-natgatewayprofile) | object | NAT Gateway profile for the cluster. |
| [`networkDataplane`](#parameter-networkdataplane) | string | Network dataplane used in the Kubernetes cluster. Not compatible with kubenet network plugin. |
| [`networkMode`](#parameter-networkmode) | string | Network mode used for building the Kubernetes network. |
| [`networkPlugin`](#parameter-networkplugin) | string | Specifies the network plugin used for building Kubernetes network. |
| [`networkPluginMode`](#parameter-networkpluginmode) | string | Network plugin mode used for building the Kubernetes network. Not compatible with kubenet network plugin. |
| [`networkPolicy`](#parameter-networkpolicy) | string | Specifies the network policy used for building Kubernetes network. - calico or azure. |
| [`nodeProvisioningProfile`](#parameter-nodeprovisioningprofile) | object | Node provisioning settings that apply to the whole cluster. |
| [`nodeResourceGroup`](#parameter-noderesourcegroup) | string | Name of the resource group containing agent pool nodes. |
| [`nodeResourceGroupProfile`](#parameter-noderesourcegroupprofile) | object | The node resource group configuration profile. |
| [`omsAgentEnabled`](#parameter-omsagentenabled) | bool | Specifies whether the OMS agent is enabled. |
| [`omsAgentUseAADAuth`](#parameter-omsagentuseaadauth) | bool | Specifies whether the OMS agent is using managed identity authentication. |
| [`openServiceMeshEnabled`](#parameter-openservicemeshenabled) | bool | Specifies whether the openServiceMesh add-on is enabled or not. |
| [`outboundPublicIPPrefixResourceIds`](#parameter-outboundpublicipprefixresourceids) | array | A list of the resource IDs of the public IP prefixes to use for the load balancer outbound rules. |
| [`outboundPublicIPResourceIds`](#parameter-outboundpublicipresourceids) | array | A list of the resource IDs of the public IP addresses to use for the load balancer outbound rules. |
| [`outboundType`](#parameter-outboundtype) | string | Specifies outbound (egress) routing method. |
| [`podCidr`](#parameter-podcidr) | string | Specifies the CIDR notation IP range from which to assign pod IPs when kubenet is used. |
| [`podCidrs`](#parameter-podcidrs) | array | The CIDR notation IP ranges from which to assign pod IPs. One IPv4 CIDR is expected for single-stack networking. Two CIDRs, one for each IP family (IPv4/IPv6), is expected for dual-stack networking. |
| [`podIdentityProfile`](#parameter-podidentityprofile) | object | The pod identity profile of the Managed Cluster. See [use AAD pod identity](https://learn.microsoft.com/azure/aks/use-azure-ad-pod-identity) for more details on AAD pod identity integration. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Allow or deny public network access for AKS. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`securityProfile`](#parameter-securityprofile) | object | Security profile for the managed cluster. |
| [`serviceCidr`](#parameter-servicecidr) | string | A CIDR notation IP range from which to assign service cluster IPs. It must not overlap with any Subnet IP ranges. |
| [`serviceCidrs`](#parameter-servicecidrs) | array | The CIDR notation IP ranges from which to assign service cluster IPs. One IPv4 CIDR is expected for single-stack networking. Two CIDRs, one for each IP family (IPv4/IPv6), is expected for dual-stack networking. They must not overlap with any Subnet IP ranges. |
| [`serviceMeshProfile`](#parameter-servicemeshprofile) | object | Service mesh profile for a managed cluster. |
| [`skuName`](#parameter-skuname) | string | Name of a managed cluster SKU. |
| [`skuTier`](#parameter-skutier) | string | Tier of a managed cluster SKU. |
| [`staticEgressGatewayProfile`](#parameter-staticegressgatewayprofile) | object | Static egress gateway profile for the cluster. |
| [`supportPlan`](#parameter-supportplan) | string | The support plan for the Managed Cluster. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`upgradeSettings`](#parameter-upgradesettings) | object | Settings for upgrading the cluster with override options. |
| [`webApplicationRoutingEnabled`](#parameter-webapplicationroutingenabled) | bool | Specifies whether the webApplicationRoutingEnabled add-on is enabled or not. |
| [`windowsProfile`](#parameter-windowsprofile) | object | The profile for Windows VMs in the Managed Cluster. |
| [`workloadAutoScalerProfile`](#parameter-workloadautoscalerprofile) | object | Workload Auto-scaler profile for the managed cluster. |

### Parameter: `name`

Specifies the name of the AKS cluster.

- Required: Yes
- Type: string

### Parameter: `primaryAgentPoolProfiles`

Properties of the primary agent pool.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-primaryagentpoolprofilesname) | string | The name of the agent pool. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`availabilityZones`](#parameter-primaryagentpoolprofilesavailabilityzones) | array | The availability zones of the agent pool. |
| [`capacityReservationGroupResourceId`](#parameter-primaryagentpoolprofilescapacityreservationgroupresourceid) | string | AKS will associate the specified agent pool with the Capacity Reservation Group. |
| [`count`](#parameter-primaryagentpoolprofilescount) | int | The number of agents (VMs) to host docker containers. Allowed values must be in the range of 1 to 100 (inclusive). |
| [`enableAutoScaling`](#parameter-primaryagentpoolprofilesenableautoscaling) | bool | Whether to enable auto-scaling for the agent pool. |
| [`enableDefaultTelemetry`](#parameter-primaryagentpoolprofilesenabledefaulttelemetry) | bool | The enable default telemetry of the agent pool. |
| [`enableEncryptionAtHost`](#parameter-primaryagentpoolprofilesenableencryptionathost) | bool | Whether to enable encryption at host for the agent pool. |
| [`enableFIPS`](#parameter-primaryagentpoolprofilesenablefips) | bool | Whether to enable FIPS for the agent pool. |
| [`enableNodePublicIP`](#parameter-primaryagentpoolprofilesenablenodepublicip) | bool | Whether to enable node public IP for the agent pool. |
| [`enableUltraSSD`](#parameter-primaryagentpoolprofilesenableultrassd) | bool | Whether to enable Ultra SSD for the agent pool. |
| [`gatewayProfile`](#parameter-primaryagentpoolprofilesgatewayprofile) | object | Represents the Gateway node pool configuration. |
| [`gpuInstanceProfile`](#parameter-primaryagentpoolprofilesgpuinstanceprofile) | string | The GPU instance profile of the agent pool. |
| [`gpuProfile`](#parameter-primaryagentpoolprofilesgpuprofile) | object | GPU settings. |
| [`hostGroupResourceId`](#parameter-primaryagentpoolprofileshostgroupresourceid) | string | Host group resource ID. |
| [`kubeletConfig`](#parameter-primaryagentpoolprofileskubeletconfig) | object | Kubelet configuration on agent pool nodes. |
| [`kubeletDiskType`](#parameter-primaryagentpoolprofileskubeletdisktype) | string | The kubelet disk type of the agent pool. |
| [`linuxOSConfig`](#parameter-primaryagentpoolprofileslinuxosconfig) | object | The Linux OS configuration of the agent pool. |
| [`localDNSProfile`](#parameter-primaryagentpoolprofileslocaldnsprofile) | object | Local DNS configuration. |
| [`maxCount`](#parameter-primaryagentpoolprofilesmaxcount) | int | The maximum number of agents (VMs) to host docker containers. Allowed values must be in the range of 1 to 100 (inclusive). |
| [`maxPods`](#parameter-primaryagentpoolprofilesmaxpods) | int | The maximum number of pods that can run on a node. |
| [`messageOfTheDay`](#parameter-primaryagentpoolprofilesmessageoftheday) | string | A message of the day will be a multi-line message that is prepended to the command prompt and the SSH login message. |
| [`minCount`](#parameter-primaryagentpoolprofilesmincount) | int | The minimum number of agents (VMs) to host docker containers. Allowed values must be in the range of 1 to 100 (inclusive). |
| [`minPods`](#parameter-primaryagentpoolprofilesminpods) | int | The minimum number of pods that can run on a node. |
| [`mode`](#parameter-primaryagentpoolprofilesmode) | string | The mode of the agent pool. |
| [`networkProfile`](#parameter-primaryagentpoolprofilesnetworkprofile) | object | Network profile to be used for agent pool nodes. |
| [`nodeLabels`](#parameter-primaryagentpoolprofilesnodelabels) | object | The node labels of the agent pool. |
| [`nodePublicIpPrefixResourceId`](#parameter-primaryagentpoolprofilesnodepublicipprefixresourceid) | string | The node public IP prefix ID of the agent pool. |
| [`nodeTaints`](#parameter-primaryagentpoolprofilesnodetaints) | array | The node taints of the agent pool. |
| [`orchestratorVersion`](#parameter-primaryagentpoolprofilesorchestratorversion) | string | The Kubernetes version of the agent pool. |
| [`osDiskSizeGB`](#parameter-primaryagentpoolprofilesosdisksizegb) | int | The OS disk size in GB of the agent pool. |
| [`osDiskType`](#parameter-primaryagentpoolprofilesosdisktype) | string | The OS disk type of the agent pool. |
| [`osSKU`](#parameter-primaryagentpoolprofilesossku) | string | The OS SKU of the agent pool. |
| [`osType`](#parameter-primaryagentpoolprofilesostype) | string | The OS type of the agent pool. |
| [`podIPAllocationMode`](#parameter-primaryagentpoolprofilespodipallocationmode) | string | Pod IP allocation mode. |
| [`podSubnetResourceId`](#parameter-primaryagentpoolprofilespodsubnetresourceid) | string | The pod subnet ID of the agent pool. |
| [`powerState`](#parameter-primaryagentpoolprofilespowerstate) | object | Power State of the agent pool. |
| [`proximityPlacementGroupResourceId`](#parameter-primaryagentpoolprofilesproximityplacementgroupresourceid) | string | The proximity placement group resource ID of the agent pool. |
| [`scaleDownMode`](#parameter-primaryagentpoolprofilesscaledownmode) | string | The scale down mode of the agent pool. |
| [`scaleSetEvictionPolicy`](#parameter-primaryagentpoolprofilesscalesetevictionpolicy) | string | The scale set eviction policy of the agent pool. |
| [`scaleSetPriority`](#parameter-primaryagentpoolprofilesscalesetpriority) | string | The scale set priority of the agent pool. |
| [`securityProfile`](#parameter-primaryagentpoolprofilessecurityprofile) | object | The security settings of an agent pool. |
| [`sourceResourceId`](#parameter-primaryagentpoolprofilessourceresourceid) | string | The source resource ID to create the agent pool from. |
| [`spotMaxPrice`](#parameter-primaryagentpoolprofilesspotmaxprice) | int | The spot max price of the agent pool. |
| [`tags`](#parameter-primaryagentpoolprofilestags) | object | The tags of the agent pool. |
| [`type`](#parameter-primaryagentpoolprofilestype) | string | The type of the agent pool. |
| [`upgradeSettings`](#parameter-primaryagentpoolprofilesupgradesettings) | object | Upgrade settings. |
| [`virtualMachinesProfile`](#parameter-primaryagentpoolprofilesvirtualmachinesprofile) | object | Virtual Machines resource status. |
| [`vmSize`](#parameter-primaryagentpoolprofilesvmsize) | string | The VM size of the agent pool. |
| [`vnetSubnetResourceId`](#parameter-primaryagentpoolprofilesvnetsubnetresourceid) | string | The VNet subnet ID of the agent pool. |
| [`windowsProfile`](#parameter-primaryagentpoolprofileswindowsprofile) | object | The Windows profile of the agent pool. |
| [`workloadRuntime`](#parameter-primaryagentpoolprofilesworkloadruntime) | string | The workload runtime of the agent pool. |

### Parameter: `primaryAgentPoolProfiles.name`

The name of the agent pool.

- Required: Yes
- Type: string

### Parameter: `primaryAgentPoolProfiles.availabilityZones`

The availability zones of the agent pool.

- Required: No
- Type: array

### Parameter: `primaryAgentPoolProfiles.capacityReservationGroupResourceId`

AKS will associate the specified agent pool with the Capacity Reservation Group.

- Required: No
- Type: string

### Parameter: `primaryAgentPoolProfiles.count`

The number of agents (VMs) to host docker containers. Allowed values must be in the range of 1 to 100 (inclusive).

- Required: No
- Type: int

### Parameter: `primaryAgentPoolProfiles.enableAutoScaling`

Whether to enable auto-scaling for the agent pool.

- Required: No
- Type: bool

### Parameter: `primaryAgentPoolProfiles.enableDefaultTelemetry`

The enable default telemetry of the agent pool.

- Required: No
- Type: bool

### Parameter: `primaryAgentPoolProfiles.enableEncryptionAtHost`

Whether to enable encryption at host for the agent pool.

- Required: No
- Type: bool

### Parameter: `primaryAgentPoolProfiles.enableFIPS`

Whether to enable FIPS for the agent pool.

- Required: No
- Type: bool

### Parameter: `primaryAgentPoolProfiles.enableNodePublicIP`

Whether to enable node public IP for the agent pool.

- Required: No
- Type: bool

### Parameter: `primaryAgentPoolProfiles.enableUltraSSD`

Whether to enable Ultra SSD for the agent pool.

- Required: No
- Type: bool

### Parameter: `primaryAgentPoolProfiles.gatewayProfile`

Represents the Gateway node pool configuration.

- Required: No
- Type: object

### Parameter: `primaryAgentPoolProfiles.gpuInstanceProfile`

The GPU instance profile of the agent pool.

- Required: No
- Type: string

### Parameter: `primaryAgentPoolProfiles.gpuProfile`

GPU settings.

- Required: No
- Type: object

### Parameter: `primaryAgentPoolProfiles.hostGroupResourceId`

Host group resource ID.

- Required: No
- Type: string

### Parameter: `primaryAgentPoolProfiles.kubeletConfig`

Kubelet configuration on agent pool nodes.

- Required: No
- Type: object

### Parameter: `primaryAgentPoolProfiles.kubeletDiskType`

The kubelet disk type of the agent pool.

- Required: No
- Type: string

### Parameter: `primaryAgentPoolProfiles.linuxOSConfig`

The Linux OS configuration of the agent pool.

- Required: No
- Type: object

### Parameter: `primaryAgentPoolProfiles.localDNSProfile`

Local DNS configuration.

- Required: No
- Type: object

### Parameter: `primaryAgentPoolProfiles.maxCount`

The maximum number of agents (VMs) to host docker containers. Allowed values must be in the range of 1 to 100 (inclusive).

- Required: No
- Type: int

### Parameter: `primaryAgentPoolProfiles.maxPods`

The maximum number of pods that can run on a node.

- Required: No
- Type: int

### Parameter: `primaryAgentPoolProfiles.messageOfTheDay`

A message of the day will be a multi-line message that is prepended to the command prompt and the SSH login message.

- Required: No
- Type: string

### Parameter: `primaryAgentPoolProfiles.minCount`

The minimum number of agents (VMs) to host docker containers. Allowed values must be in the range of 1 to 100 (inclusive).

- Required: No
- Type: int

### Parameter: `primaryAgentPoolProfiles.minPods`

The minimum number of pods that can run on a node.

- Required: No
- Type: int

### Parameter: `primaryAgentPoolProfiles.mode`

The mode of the agent pool.

- Required: No
- Type: string

### Parameter: `primaryAgentPoolProfiles.networkProfile`

Network profile to be used for agent pool nodes.

- Required: No
- Type: object

### Parameter: `primaryAgentPoolProfiles.nodeLabels`

The node labels of the agent pool.

- Required: No
- Type: object

### Parameter: `primaryAgentPoolProfiles.nodePublicIpPrefixResourceId`

The node public IP prefix ID of the agent pool.

- Required: No
- Type: string

### Parameter: `primaryAgentPoolProfiles.nodeTaints`

The node taints of the agent pool.

- Required: No
- Type: array

### Parameter: `primaryAgentPoolProfiles.orchestratorVersion`

The Kubernetes version of the agent pool.

- Required: No
- Type: string

### Parameter: `primaryAgentPoolProfiles.osDiskSizeGB`

The OS disk size in GB of the agent pool.

- Required: No
- Type: int

### Parameter: `primaryAgentPoolProfiles.osDiskType`

The OS disk type of the agent pool.

- Required: No
- Type: string

### Parameter: `primaryAgentPoolProfiles.osSKU`

The OS SKU of the agent pool.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureLinux'
    'AzureLinux3'
    'CBLMariner'
    'Ubuntu'
    'Ubuntu2204'
    'Ubuntu2404'
    'Windows2019'
    'Windows2022'
    'Windows2025'
  ]
  ```

### Parameter: `primaryAgentPoolProfiles.osType`

The OS type of the agent pool.

- Required: No
- Type: string

### Parameter: `primaryAgentPoolProfiles.podIPAllocationMode`

Pod IP allocation mode.

- Required: No
- Type: string

### Parameter: `primaryAgentPoolProfiles.podSubnetResourceId`

The pod subnet ID of the agent pool.

- Required: No
- Type: string

### Parameter: `primaryAgentPoolProfiles.powerState`

Power State of the agent pool.

- Required: No
- Type: object

### Parameter: `primaryAgentPoolProfiles.proximityPlacementGroupResourceId`

The proximity placement group resource ID of the agent pool.

- Required: No
- Type: string

### Parameter: `primaryAgentPoolProfiles.scaleDownMode`

The scale down mode of the agent pool.

- Required: No
- Type: string

### Parameter: `primaryAgentPoolProfiles.scaleSetEvictionPolicy`

The scale set eviction policy of the agent pool.

- Required: No
- Type: string

### Parameter: `primaryAgentPoolProfiles.scaleSetPriority`

The scale set priority of the agent pool.

- Required: No
- Type: string

### Parameter: `primaryAgentPoolProfiles.securityProfile`

The security settings of an agent pool.

- Required: No
- Type: object

### Parameter: `primaryAgentPoolProfiles.sourceResourceId`

The source resource ID to create the agent pool from.

- Required: No
- Type: string

### Parameter: `primaryAgentPoolProfiles.spotMaxPrice`

The spot max price of the agent pool.

- Required: No
- Type: int

### Parameter: `primaryAgentPoolProfiles.tags`

The tags of the agent pool.

- Required: No
- Type: object

### Parameter: `primaryAgentPoolProfiles.type`

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

### Parameter: `primaryAgentPoolProfiles.upgradeSettings`

Upgrade settings.

- Required: No
- Type: object

### Parameter: `primaryAgentPoolProfiles.virtualMachinesProfile`

Virtual Machines resource status.

- Required: No
- Type: object

### Parameter: `primaryAgentPoolProfiles.vmSize`

The VM size of the agent pool.

- Required: No
- Type: string

### Parameter: `primaryAgentPoolProfiles.vnetSubnetResourceId`

The VNet subnet ID of the agent pool.

- Required: No
- Type: string

### Parameter: `primaryAgentPoolProfiles.windowsProfile`

The Windows profile of the agent pool.

- Required: No
- Type: object

### Parameter: `primaryAgentPoolProfiles.workloadRuntime`

The workload runtime of the agent pool.

- Required: No
- Type: string

### Parameter: `aksServicePrincipalProfile`

Information about a service principal identity for the cluster to use for manipulating Azure APIs. Required if no managed identities are assigned to the cluster.

- Required: No
- Type: object

### Parameter: `appGatewayResourceId`

Specifies the resource ID of connected application gateway. Required if `ingressApplicationGatewayEnabled` is set to `true`.

- Required: No
- Type: string

### Parameter: `aadProfile`

Enable Azure Active Directory integration.

- Required: No
- Type: object

### Parameter: `aciConnectorLinuxEnabled`

Specifies whether the aciConnectorLinux add-on is enabled or not.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `advancedNetworking`

Advanced Networking profile for enabling observability and security feature suite on a cluster. For more information see https://aka.ms/aksadvancednetworking.

- Required: No
- Type: object

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
| [`capacityReservationGroupResourceId`](#parameter-agentpoolscapacityreservationgroupresourceid) | string | AKS will associate the specified agent pool with the Capacity Reservation Group. |
| [`count`](#parameter-agentpoolscount) | int | The number of agents (VMs) to host docker containers. Allowed values must be in the range of 1 to 100 (inclusive). |
| [`enableAutoScaling`](#parameter-agentpoolsenableautoscaling) | bool | Whether to enable auto-scaling for the agent pool. |
| [`enableDefaultTelemetry`](#parameter-agentpoolsenabledefaulttelemetry) | bool | The enable default telemetry of the agent pool. |
| [`enableEncryptionAtHost`](#parameter-agentpoolsenableencryptionathost) | bool | Whether to enable encryption at host for the agent pool. |
| [`enableFIPS`](#parameter-agentpoolsenablefips) | bool | Whether to enable FIPS for the agent pool. |
| [`enableNodePublicIP`](#parameter-agentpoolsenablenodepublicip) | bool | Whether to enable node public IP for the agent pool. |
| [`enableUltraSSD`](#parameter-agentpoolsenableultrassd) | bool | Whether to enable Ultra SSD for the agent pool. |
| [`gatewayProfile`](#parameter-agentpoolsgatewayprofile) | object | Represents the Gateway node pool configuration. |
| [`gpuInstanceProfile`](#parameter-agentpoolsgpuinstanceprofile) | string | The GPU instance profile of the agent pool. |
| [`gpuProfile`](#parameter-agentpoolsgpuprofile) | object | GPU settings. |
| [`hostGroupResourceId`](#parameter-agentpoolshostgroupresourceid) | string | Host group resource ID. |
| [`kubeletConfig`](#parameter-agentpoolskubeletconfig) | object | Kubelet configuration on agent pool nodes. |
| [`kubeletDiskType`](#parameter-agentpoolskubeletdisktype) | string | The kubelet disk type of the agent pool. |
| [`linuxOSConfig`](#parameter-agentpoolslinuxosconfig) | object | The Linux OS configuration of the agent pool. |
| [`localDNSProfile`](#parameter-agentpoolslocaldnsprofile) | object | Local DNS configuration. |
| [`maxCount`](#parameter-agentpoolsmaxcount) | int | The maximum number of agents (VMs) to host docker containers. Allowed values must be in the range of 1 to 100 (inclusive). |
| [`maxPods`](#parameter-agentpoolsmaxpods) | int | The maximum number of pods that can run on a node. |
| [`messageOfTheDay`](#parameter-agentpoolsmessageoftheday) | string | A message of the day will be a multi-line message that is prepended to the command prompt and the SSH login message. |
| [`minCount`](#parameter-agentpoolsmincount) | int | The minimum number of agents (VMs) to host docker containers. Allowed values must be in the range of 1 to 100 (inclusive). |
| [`minPods`](#parameter-agentpoolsminpods) | int | The minimum number of pods that can run on a node. |
| [`mode`](#parameter-agentpoolsmode) | string | The mode of the agent pool. |
| [`networkProfile`](#parameter-agentpoolsnetworkprofile) | object | Network profile to be used for agent pool nodes. |
| [`nodeLabels`](#parameter-agentpoolsnodelabels) | object | The node labels of the agent pool. |
| [`nodePublicIpPrefixResourceId`](#parameter-agentpoolsnodepublicipprefixresourceid) | string | The node public IP prefix ID of the agent pool. |
| [`nodeTaints`](#parameter-agentpoolsnodetaints) | array | The node taints of the agent pool. |
| [`orchestratorVersion`](#parameter-agentpoolsorchestratorversion) | string | The Kubernetes version of the agent pool. |
| [`osDiskSizeGB`](#parameter-agentpoolsosdisksizegb) | int | The OS disk size in GB of the agent pool. |
| [`osDiskType`](#parameter-agentpoolsosdisktype) | string | The OS disk type of the agent pool. |
| [`osSKU`](#parameter-agentpoolsossku) | string | The OS SKU of the agent pool. |
| [`osType`](#parameter-agentpoolsostype) | string | The OS type of the agent pool. |
| [`podIPAllocationMode`](#parameter-agentpoolspodipallocationmode) | string | Pod IP allocation mode. |
| [`podSubnetResourceId`](#parameter-agentpoolspodsubnetresourceid) | string | The pod subnet ID of the agent pool. |
| [`powerState`](#parameter-agentpoolspowerstate) | object | Power State of the agent pool. |
| [`proximityPlacementGroupResourceId`](#parameter-agentpoolsproximityplacementgroupresourceid) | string | The proximity placement group resource ID of the agent pool. |
| [`scaleDownMode`](#parameter-agentpoolsscaledownmode) | string | The scale down mode of the agent pool. |
| [`scaleSetEvictionPolicy`](#parameter-agentpoolsscalesetevictionpolicy) | string | The scale set eviction policy of the agent pool. |
| [`scaleSetPriority`](#parameter-agentpoolsscalesetpriority) | string | The scale set priority of the agent pool. |
| [`securityProfile`](#parameter-agentpoolssecurityprofile) | object | The security settings of an agent pool. |
| [`sourceResourceId`](#parameter-agentpoolssourceresourceid) | string | The source resource ID to create the agent pool from. |
| [`spotMaxPrice`](#parameter-agentpoolsspotmaxprice) | int | The spot max price of the agent pool. |
| [`tags`](#parameter-agentpoolstags) | object | The tags of the agent pool. |
| [`type`](#parameter-agentpoolstype) | string | The type of the agent pool. |
| [`upgradeSettings`](#parameter-agentpoolsupgradesettings) | object | Upgrade settings. |
| [`virtualMachinesProfile`](#parameter-agentpoolsvirtualmachinesprofile) | object | Virtual Machines resource status. |
| [`vmSize`](#parameter-agentpoolsvmsize) | string | The VM size of the agent pool. |
| [`vnetSubnetResourceId`](#parameter-agentpoolsvnetsubnetresourceid) | string | The VNet subnet ID of the agent pool. |
| [`windowsProfile`](#parameter-agentpoolswindowsprofile) | object | The Windows profile of the agent pool. |
| [`workloadRuntime`](#parameter-agentpoolsworkloadruntime) | string | The workload runtime of the agent pool. |

### Parameter: `agentPools.name`

The name of the agent pool.

- Required: Yes
- Type: string

### Parameter: `agentPools.availabilityZones`

The availability zones of the agent pool.

- Required: No
- Type: array

### Parameter: `agentPools.capacityReservationGroupResourceId`

AKS will associate the specified agent pool with the Capacity Reservation Group.

- Required: No
- Type: string

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

### Parameter: `agentPools.gatewayProfile`

Represents the Gateway node pool configuration.

- Required: No
- Type: object

### Parameter: `agentPools.gpuInstanceProfile`

The GPU instance profile of the agent pool.

- Required: No
- Type: string

### Parameter: `agentPools.gpuProfile`

GPU settings.

- Required: No
- Type: object

### Parameter: `agentPools.hostGroupResourceId`

Host group resource ID.

- Required: No
- Type: string

### Parameter: `agentPools.kubeletConfig`

Kubelet configuration on agent pool nodes.

- Required: No
- Type: object

### Parameter: `agentPools.kubeletDiskType`

The kubelet disk type of the agent pool.

- Required: No
- Type: string

### Parameter: `agentPools.linuxOSConfig`

The Linux OS configuration of the agent pool.

- Required: No
- Type: object

### Parameter: `agentPools.localDNSProfile`

Local DNS configuration.

- Required: No
- Type: object

### Parameter: `agentPools.maxCount`

The maximum number of agents (VMs) to host docker containers. Allowed values must be in the range of 1 to 100 (inclusive).

- Required: No
- Type: int

### Parameter: `agentPools.maxPods`

The maximum number of pods that can run on a node.

- Required: No
- Type: int

### Parameter: `agentPools.messageOfTheDay`

A message of the day will be a multi-line message that is prepended to the command prompt and the SSH login message.

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

### Parameter: `agentPools.networkProfile`

Network profile to be used for agent pool nodes.

- Required: No
- Type: object

### Parameter: `agentPools.nodeLabels`

The node labels of the agent pool.

- Required: No
- Type: object

### Parameter: `agentPools.nodePublicIpPrefixResourceId`

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

### Parameter: `agentPools.osSKU`

The OS SKU of the agent pool.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureLinux'
    'AzureLinux3'
    'CBLMariner'
    'Ubuntu'
    'Ubuntu2204'
    'Ubuntu2404'
    'Windows2019'
    'Windows2022'
    'Windows2025'
  ]
  ```

### Parameter: `agentPools.osType`

The OS type of the agent pool.

- Required: No
- Type: string

### Parameter: `agentPools.podIPAllocationMode`

Pod IP allocation mode.

- Required: No
- Type: string

### Parameter: `agentPools.podSubnetResourceId`

The pod subnet ID of the agent pool.

- Required: No
- Type: string

### Parameter: `agentPools.powerState`

Power State of the agent pool.

- Required: No
- Type: object

### Parameter: `agentPools.proximityPlacementGroupResourceId`

The proximity placement group resource ID of the agent pool.

- Required: No
- Type: string

### Parameter: `agentPools.scaleDownMode`

The scale down mode of the agent pool.

- Required: No
- Type: string

### Parameter: `agentPools.scaleSetEvictionPolicy`

The scale set eviction policy of the agent pool.

- Required: No
- Type: string

### Parameter: `agentPools.scaleSetPriority`

The scale set priority of the agent pool.

- Required: No
- Type: string

### Parameter: `agentPools.securityProfile`

The security settings of an agent pool.

- Required: No
- Type: object

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

### Parameter: `agentPools.upgradeSettings`

Upgrade settings.

- Required: No
- Type: object

### Parameter: `agentPools.virtualMachinesProfile`

Virtual Machines resource status.

- Required: No
- Type: object

### Parameter: `agentPools.vmSize`

The VM size of the agent pool.

- Required: No
- Type: string

### Parameter: `agentPools.vnetSubnetResourceId`

The VNet subnet ID of the agent pool.

- Required: No
- Type: string

### Parameter: `agentPools.windowsProfile`

The Windows profile of the agent pool.

- Required: No
- Type: object

### Parameter: `agentPools.workloadRuntime`

The workload runtime of the agent pool.

- Required: No
- Type: string

### Parameter: `aiToolchainOperatorProfile`

AI toolchain operator settings that apply to the whole cluster.

- Required: No
- Type: object

### Parameter: `allocatedOutboundPorts`

The desired number of allocated SNAT ports per VM. Default is 0, which results in Azure dynamically allocating ports.

- Required: No
- Type: int
- Default: `0`

### Parameter: `apiServerAccessProfile`

The access profile for managed cluster API server.

- Required: No
- Type: object

### Parameter: `autoScalerProfile`

Parameters to be applied to the cluster-autoscaler when enabled.

- Required: No
- Type: object

### Parameter: `autoUpgradeProfile`

The auto upgrade configuration.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      upgradeChannel: 'stable'
  }
  ```

### Parameter: `azureMonitorProfile`

Azure Monitor addon profiles for monitoring the managed cluster.

- Required: No
- Type: object

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

### Parameter: `bootstrapProfile`

Profile of the cluster bootstrap configuration.

- Required: No
- Type: object

### Parameter: `costAnalysisEnabled`

Specifies whether the cost analysis add-on is enabled or not. If Enabled `enableStorageProfileDiskCSIDriver` is set to true as it is needed.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `defaultIngressControllerType`

Ingress type for the default NginxIngressController custom resource. It will be ignored if `webApplicationRoutingEnabled` is set to `false`.

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

### Parameter: `disableLocalAccounts`

If set to true, getting static credentials will be disabled for this cluster. This must only be used on Managed Clusters that are AAD enabled.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `diskEncryptionSetResourceId`

The Resource ID of the disk encryption set to use for enabling encryption at rest. For security reasons, this value should be provided.

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

### Parameter: `enableDnsZoneContributorRoleAssignment`

Specifies whether assing the DNS zone contributor role to the cluster service principal. It will be ignored if `webApplicationRoutingEnabled` is set to `false` or `dnsZoneResourceId` not provided.

- Required: No
- Type: bool
- Default: `True`

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

### Parameter: `enableRBAC`

Whether to enable Kubernetes Role-Based Access Control.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableSecretRotation`

Specifies whether the KeyvaultSecretsProvider add-on uses secret rotation.

- Required: No
- Type: bool
- Default: `False`

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

### Parameter: `fluxExtension`

Settings and configurations for the flux extension.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`configurationProtectedSettings`](#parameter-fluxextensionconfigurationprotectedsettings) | object | The configuration protected settings of the extension. |
| [`configurationSettings`](#parameter-fluxextensionconfigurationsettings) | object | The configuration settings of the extension. |
| [`fluxConfigurations`](#parameter-fluxextensionfluxconfigurations) | array | The flux configurations of the extension. |
| [`name`](#parameter-fluxextensionname) | string | The name of the extension. |
| [`releaseNamespace`](#parameter-fluxextensionreleasenamespace) | string | Namespace where the extension Release must be placed. |
| [`releaseTrain`](#parameter-fluxextensionreleasetrain) | string | The release train of the extension. |
| [`targetNamespace`](#parameter-fluxextensiontargetnamespace) | string | Namespace where the extension will be created for an Namespace scoped extension. |
| [`version`](#parameter-fluxextensionversion) | string | The version of the extension. |

### Parameter: `fluxExtension.configurationProtectedSettings`

The configuration protected settings of the extension.

- Required: No
- Type: object

### Parameter: `fluxExtension.configurationSettings`

The configuration settings of the extension.

- Required: No
- Type: object

### Parameter: `fluxExtension.fluxConfigurations`

The flux configurations of the extension.

- Required: No
- Type: array

### Parameter: `fluxExtension.name`

The name of the extension.

- Required: No
- Type: string

### Parameter: `fluxExtension.releaseNamespace`

Namespace where the extension Release must be placed.

- Required: No
- Type: string

### Parameter: `fluxExtension.releaseTrain`

The release train of the extension.

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

### Parameter: `fqdnSubdomain`

The FQDN subdomain of the private cluster with custom private dns zone. This cannot be updated once the Managed Cluster has been created.

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

### Parameter: `idleTimeoutInMinutes`

Desired outbound flow idle timeout in minutes.

- Required: No
- Type: int
- Default: `30`

### Parameter: `ingressApplicationGatewayEnabled`

Specifies whether the ingressApplicationGateway (AGIC) add-on is enabled or not.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `ipFamilies`

The IP families used for the cluster.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    'IPv4'
  ]
  ```

### Parameter: `kubeDashboardEnabled`

Specifies whether the kubeDashboard add-on is enabled or not.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `kubernetesVersion`

Version of Kubernetes specified when creating the managed cluster.

- Required: No
- Type: string

### Parameter: `linuxProfile`

The profile for Linux VMs in the Managed Cluster.

- Required: No
- Type: object

### Parameter: `loadBalancerSku`

Specifies the sku of the load balancer used by the virtual machine scale sets used by nodepools.

- Required: No
- Type: string
- Default: `'standard'`

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
| [`notes`](#parameter-locknotes) | string | Specify the notes of the lock. |

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

### Parameter: `lock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `maintenanceConfigurations`

Maintenance configurations for the managed cluster.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`maintenanceWindow`](#parameter-maintenanceconfigurationsmaintenancewindow) | object | Maintenance window for the maintenance configuration. |
| [`name`](#parameter-maintenanceconfigurationsname) | string | Name of maintenance window. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`notAllowedTime`](#parameter-maintenanceconfigurationsnotallowedtime) | array | Time slots on which upgrade is not allowed. |
| [`timeInWeek`](#parameter-maintenanceconfigurationstimeinweek) | array | Time slots during the week when planned maintenance is allowed to proceed. |

### Parameter: `maintenanceConfigurations.maintenanceWindow`

Maintenance window for the maintenance configuration.

- Required: Yes
- Type: object

### Parameter: `maintenanceConfigurations.name`

Name of maintenance window.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'aksManagedAutoUpgradeSchedule'
    'aksManagedNodeOSUpgradeSchedule'
  ]
  ```

### Parameter: `maintenanceConfigurations.notAllowedTime`

Time slots on which upgrade is not allowed.

- Required: No
- Type: array

### Parameter: `maintenanceConfigurations.timeInWeek`

Time slots during the week when planned maintenance is allowed to proceed.

- Required: No
- Type: array

### Parameter: `managedIdentities`

The managed identity definition for this resource. Only one type of identity is supported: system-assigned or user-assigned, but not both.

- Required: No
- Type: object

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

### Parameter: `managedOutboundIPCount`

Outbound IP Count for the Load balancer.

- Required: No
- Type: int
- Default: `0`

### Parameter: `monitoringWorkspaceResourceId`

Resource ID of the monitoring log analytics workspace.

- Required: No
- Type: string

### Parameter: `natGatewayProfile`

NAT Gateway profile for the cluster.

- Required: No
- Type: object

### Parameter: `networkDataplane`

Network dataplane used in the Kubernetes cluster. Not compatible with kubenet network plugin.

- Required: No
- Type: string

### Parameter: `networkMode`

Network mode used for building the Kubernetes network.

- Required: No
- Type: string

### Parameter: `networkPlugin`

Specifies the network plugin used for building Kubernetes network.

- Required: No
- Type: string

### Parameter: `networkPluginMode`

Network plugin mode used for building the Kubernetes network. Not compatible with kubenet network plugin.

- Required: No
- Type: string

### Parameter: `networkPolicy`

Specifies the network policy used for building Kubernetes network. - calico or azure.

- Required: No
- Type: string

### Parameter: `nodeProvisioningProfile`

Node provisioning settings that apply to the whole cluster.

- Required: No
- Type: object

### Parameter: `nodeResourceGroup`

Name of the resource group containing agent pool nodes.

- Required: No
- Type: string
- Default: `[format('{0}_aks_{1}_nodes', resourceGroup().name, parameters('name'))]`

### Parameter: `nodeResourceGroupProfile`

The node resource group configuration profile.

- Required: No
- Type: object

### Parameter: `omsAgentEnabled`

Specifies whether the OMS agent is enabled.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `omsAgentUseAADAuth`

Specifies whether the OMS agent is using managed identity authentication.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `openServiceMeshEnabled`

Specifies whether the openServiceMesh add-on is enabled or not.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `outboundPublicIPPrefixResourceIds`

A list of the resource IDs of the public IP prefixes to use for the load balancer outbound rules.

- Required: No
- Type: array

### Parameter: `outboundPublicIPResourceIds`

A list of the resource IDs of the public IP addresses to use for the load balancer outbound rules.

- Required: No
- Type: array

### Parameter: `outboundType`

Specifies outbound (egress) routing method.

- Required: No
- Type: string
- Default: `'loadBalancer'`

### Parameter: `podCidr`

Specifies the CIDR notation IP range from which to assign pod IPs when kubenet is used.

- Required: No
- Type: string

### Parameter: `podCidrs`

The CIDR notation IP ranges from which to assign pod IPs. One IPv4 CIDR is expected for single-stack networking. Two CIDRs, one for each IP family (IPv4/IPv6), is expected for dual-stack networking.

- Required: No
- Type: array

### Parameter: `podIdentityProfile`

The pod identity profile of the Managed Cluster. See [use AAD pod identity](https://learn.microsoft.com/azure/aks/use-azure-ad-pod-identity) for more details on AAD pod identity integration.

- Required: No
- Type: object

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
- Roles configurable by name:
  - `'Azure Kubernetes Fleet Manager Contributor Role'`
  - `'Azure Kubernetes Fleet Manager RBAC Admin'`
  - `'Azure Kubernetes Fleet Manager RBAC Cluster Admin'`
  - `'Azure Kubernetes Fleet Manager RBAC Reader'`
  - `'Azure Kubernetes Fleet Manager RBAC Writer'`
  - `'Azure Kubernetes Service Cluster Admin Role'`
  - `'Azure Kubernetes Service Cluster Monitoring User'`
  - `'Azure Kubernetes Service Cluster User Role'`
  - `'Azure Kubernetes Service Contributor Role'`
  - `'Azure Kubernetes Service RBAC Admin'`
  - `'Azure Kubernetes Service RBAC Cluster Admin'`
  - `'Azure Kubernetes Service RBAC Reader'`
  - `'Azure Kubernetes Service RBAC Writer'`
  - `'Contributor'`
  - `'Kubernetes Agentless Operator'`
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

### Parameter: `securityProfile`

Security profile for the managed cluster.

- Required: No
- Type: object

### Parameter: `serviceCidr`

A CIDR notation IP range from which to assign service cluster IPs. It must not overlap with any Subnet IP ranges.

- Required: No
- Type: string

### Parameter: `serviceCidrs`

The CIDR notation IP ranges from which to assign service cluster IPs. One IPv4 CIDR is expected for single-stack networking. Two CIDRs, one for each IP family (IPv4/IPv6), is expected for dual-stack networking. They must not overlap with any Subnet IP ranges.

- Required: No
- Type: array

### Parameter: `serviceMeshProfile`

Service mesh profile for a managed cluster.

- Required: No
- Type: object

### Parameter: `skuName`

Name of a managed cluster SKU.

- Required: No
- Type: string
- Default: `'Base'`

### Parameter: `skuTier`

Tier of a managed cluster SKU.

- Required: No
- Type: string
- Default: `'Standard'`

### Parameter: `staticEgressGatewayProfile`

Static egress gateway profile for the cluster.

- Required: No
- Type: object

### Parameter: `supportPlan`

The support plan for the Managed Cluster.

- Required: No
- Type: string
- Default: `'KubernetesOfficial'`

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `upgradeSettings`

Settings for upgrading the cluster with override options.

- Required: No
- Type: object

### Parameter: `webApplicationRoutingEnabled`

Specifies whether the webApplicationRoutingEnabled add-on is enabled or not.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `windowsProfile`

The profile for Windows VMs in the Managed Cluster.

- Required: No
- Type: object

### Parameter: `workloadAutoScalerProfile`

Workload Auto-scaler profile for the managed cluster.

- Required: No
- Type: object

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
| `br/public:avm/res/kubernetes-configuration/extension:0.3.8` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.6.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
