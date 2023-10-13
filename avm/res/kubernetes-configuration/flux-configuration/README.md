# Kubernetes Configuration Flux Configurations `[Microsoft.KubernetesConfiguration/fluxConfigurations]`

This module deploys a Kubernetes Configuration Flux Configuration.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Notes](#Notes)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.KubernetesConfiguration/fluxConfigurations` | [2022-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KubernetesConfiguration/2022-03-01/fluxConfigurations) |

## Usage examples

The following module usage examples are retrieved from the content of the files hosted in the module's `tests` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

   >**Note**: To reference the module, please use the following syntax `br/public:avm-res-kubernetesconfiguration-fluxconfiguration:1.0.0`.

- [Default](#example-1-default)
- [Max](#example-2-max)
- [Waf-Aligned](#example-3-waf-aligned)

### Example 1: _Default_

<details>

<summary>via Bicep module</summary>

```bicep
module fluxConfiguration 'br/public:avm-res-kubernetesconfiguration-fluxconfiguration:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-kcfcdef'
  params: {
    // Required parameters
    clusterName: '<clusterName>'
    name: 'kcfcdef001'
    namespace: 'flux-system'
    sourceKind: 'GitRepository'
    // Non-required parameters
    bucket: '<bucket>'
    configurationProtectedSettings: '<configurationProtectedSettings>'
    gitRepository: {
      repositoryRef: {
        branch: 'main'
      }
      sshKnownHosts: ''
      syncIntervalInSeconds: 300
      timeoutInSeconds: 180
      url: 'https://github.com/mspnp/aks-baseline'
    }
    kustomizations: '<kustomizations>'
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
    "clusterName": {
      "value": "<clusterName>"
    },
    "name": {
      "value": "kcfcdef001"
    },
    "namespace": {
      "value": "flux-system"
    },
    "sourceKind": {
      "value": "GitRepository"
    },
    // Non-required parameters
    "bucket": {
      "value": "<bucket>"
    },
    "configurationProtectedSettings": {
      "value": "<configurationProtectedSettings>"
    },
    "gitRepository": {
      "value": {
        "repositoryRef": {
          "branch": "main"
        },
        "sshKnownHosts": "",
        "syncIntervalInSeconds": 300,
        "timeoutInSeconds": 180,
        "url": "https://github.com/mspnp/aks-baseline"
      }
    },
    "kustomizations": {
      "value": "<kustomizations>"
    },
    "location": {
      "value": "<location>"
    }
  }
}
```

</details>
<p>

### Example 2: _Max_

<details>

<summary>via Bicep module</summary>

```bicep
module fluxConfiguration 'br/public:avm-res-kubernetesconfiguration-fluxconfiguration:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-kcfcmax'
  params: {
    // Required parameters
    clusterName: '<clusterName>'
    name: 'kcfcmax001'
    namespace: 'flux-system'
    sourceKind: 'GitRepository'
    // Non-required parameters
    bucket: '<bucket>'
    configurationProtectedSettings: '<configurationProtectedSettings>'
    gitRepository: {
      repositoryRef: {
        branch: 'main'
      }
      sshKnownHosts: ''
      syncIntervalInSeconds: 300
      timeoutInSeconds: 180
      url: 'https://github.com/mspnp/aks-baseline'
    }
    kustomizations: {
      unified: {
        dependsOn: []
        force: false
        path: './cluster-manifests'
        prune: true
        syncIntervalInSeconds: 300
        timeoutInSeconds: 300
      }
    }
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
    "clusterName": {
      "value": "<clusterName>"
    },
    "name": {
      "value": "kcfcmax001"
    },
    "namespace": {
      "value": "flux-system"
    },
    "sourceKind": {
      "value": "GitRepository"
    },
    // Non-required parameters
    "bucket": {
      "value": "<bucket>"
    },
    "configurationProtectedSettings": {
      "value": "<configurationProtectedSettings>"
    },
    "gitRepository": {
      "value": {
        "repositoryRef": {
          "branch": "main"
        },
        "sshKnownHosts": "",
        "syncIntervalInSeconds": 300,
        "timeoutInSeconds": 180,
        "url": "https://github.com/mspnp/aks-baseline"
      }
    },
    "kustomizations": {
      "value": {
        "unified": {
          "dependsOn": [],
          "force": false,
          "path": "./cluster-manifests",
          "prune": true,
          "syncIntervalInSeconds": 300,
          "timeoutInSeconds": 300
        }
      }
    },
    "location": {
      "value": "<location>"
    }
  }
}
```

</details>
<p>

### Example 3: _Waf-Aligned_

<details>

<summary>via Bicep module</summary>

```bicep
module fluxConfiguration 'br/public:avm-res-kubernetesconfiguration-fluxconfiguration:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-kcfcwaf'
  params: {
    // Required parameters
    clusterName: '<clusterName>'
    name: 'kcfcwaf001'
    namespace: 'flux-system'
    sourceKind: 'GitRepository'
    // Non-required parameters
    bucket: '<bucket>'
    configurationProtectedSettings: '<configurationProtectedSettings>'
    gitRepository: {
      repositoryRef: {
        branch: 'main'
      }
      sshKnownHosts: ''
      syncIntervalInSeconds: 300
      timeoutInSeconds: 180
      url: 'https://github.com/mspnp/aks-baseline'
    }
    kustomizations: {
      unified: {
        dependsOn: []
        force: false
        path: './cluster-manifests'
        prune: true
        syncIntervalInSeconds: 300
        timeoutInSeconds: 300
      }
    }
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
    "clusterName": {
      "value": "<clusterName>"
    },
    "name": {
      "value": "kcfcwaf001"
    },
    "namespace": {
      "value": "flux-system"
    },
    "sourceKind": {
      "value": "GitRepository"
    },
    // Non-required parameters
    "bucket": {
      "value": "<bucket>"
    },
    "configurationProtectedSettings": {
      "value": "<configurationProtectedSettings>"
    },
    "gitRepository": {
      "value": {
        "repositoryRef": {
          "branch": "main"
        },
        "sshKnownHosts": "",
        "syncIntervalInSeconds": 300,
        "timeoutInSeconds": 180,
        "url": "https://github.com/mspnp/aks-baseline"
      }
    },
    "kustomizations": {
      "value": {
        "unified": {
          "dependsOn": [],
          "force": false,
          "path": "./cluster-manifests",
          "prune": true,
          "syncIntervalInSeconds": 300,
          "timeoutInSeconds": 300
        }
      }
    },
    "location": {
      "value": "<location>"
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
| [`clusterName`](#parameter-clustername) | string | The name of the AKS cluster that should be configured. |
| [`name`](#parameter-name) | string | The name of the Flux Configuration. |
| [`namespace`](#parameter-namespace) | string | The namespace to which this configuration is installed to. Maximum of 253 lower case alphanumeric characters, hyphen and period only. |
| [`scope`](#parameter-scope) | string | Scope at which the configuration will be installed. |
| [`sourceKind`](#parameter-sourcekind) | string | Source Kind to pull the configuration data from. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`bucket`](#parameter-bucket) | object | Parameters to reconcile to the GitRepository source kind type. Required if `sourceKind` is `Bucket`. |
| [`gitRepository`](#parameter-gitrepository) | object | Parameters to reconcile to the GitRepository source kind type. Required if `sourceKind` is `GitRepository`. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`configurationProtectedSettings`](#parameter-configurationprotectedsettings) | secureObject | Key-value pairs of protected configuration settings for the configuration. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`kustomizations`](#parameter-kustomizations) | object | Array of kustomizations used to reconcile the artifact pulled by the source type on the cluster. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`suspend`](#parameter-suspend) | bool | Whether this configuration should suspend its reconciliation of its kustomizations and sources. |

### Parameter: `bucket`

Parameters to reconcile to the GitRepository source kind type. Required if `sourceKind` is `Bucket`.
- Required: No
- Type: object

### Parameter: `clusterName`

The name of the AKS cluster that should be configured.
- Required: Yes
- Type: string

### Parameter: `configurationProtectedSettings`

Key-value pairs of protected configuration settings for the configuration.
- Required: No
- Type: secureObject

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `gitRepository`

Parameters to reconcile to the GitRepository source kind type. Required if `sourceKind` is `GitRepository`.
- Required: No
- Type: object

### Parameter: `kustomizations`

Array of kustomizations used to reconcile the artifact pulled by the source type on the cluster.
- Required: No
- Type: object

### Parameter: `location`

Location for all resources.
- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `name`

The name of the Flux Configuration.
- Required: Yes
- Type: string

### Parameter: `namespace`

The namespace to which this configuration is installed to. Maximum of 253 lower case alphanumeric characters, hyphen and period only.
- Required: Yes
- Type: string

### Parameter: `scope`

Scope at which the configuration will be installed.
- Required: Yes
- Type: string
- Allowed: `[cluster, namespace]`

### Parameter: `sourceKind`

Source Kind to pull the configuration data from.
- Required: Yes
- Type: string
- Allowed: `[Bucket, GitRepository]`

### Parameter: `suspend`

Whether this configuration should suspend its reconciliation of its kustomizations and sources.
- Required: No
- Type: bool
- Default: `False`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the flux configuration. |
| `resourceGroupName` | string | The name of the resource group the flux configuration was deployed into. |
| `resourceId` | string | The resource ID of the flux configuration. |

## Cross-referenced modules

_None_

## Notes

To use this module, it is required to register the AKS-ExtensionManager feature in your subscription. To do so, you can use the following command:

```powershell
az feature register --namespace Microsoft.ContainerService --name AKS-ExtensionManager
```

Further it is required to register the following Azure service providers. (It's OK to re-register an existing provider.)

```powershell
az provider register --namespace Microsoft.Kubernetes
az provider register --namespace Microsoft.ContainerService
az provider register --namespace Microsoft.KubernetesConfiguration
```

For more details see [Prerequisites](https://learn.microsoft.com/en-us/azure/azure-arc/kubernetes/tutorial-use-gitops-flux2)
