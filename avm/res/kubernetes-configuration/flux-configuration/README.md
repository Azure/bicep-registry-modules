# Kubernetes Configuration Flux Configurations `[Microsoft.KubernetesConfiguration/fluxConfigurations]`

This module deploys a Kubernetes Configuration Flux Configuration.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Notes](#Notes)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.KubernetesConfiguration/fluxConfigurations` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KubernetesConfiguration/fluxConfigurations) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/kubernetes-configuration/flux-configuration:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module fluxConfiguration 'br/public:avm/res/kubernetes-configuration/flux-configuration:<version>' = {
  name: 'fluxConfigurationDeployment'
  params: {
    // Required parameters
    clusterName: '<clusterName>'
    kustomizations: {
      unified: {
        path: './cluster-manifests'
      }
    }
    name: 'kcfcmin001'
    namespace: 'flux-system'
    scope: 'cluster'
    sourceKind: 'GitRepository'
    // Non-required parameters
    gitRepository: {
      repositoryRef: {
        branch: 'main'
      }
      sshKnownHosts: ''
      syncIntervalInSeconds: 300
      timeoutInSeconds: 180
      url: 'https://github.com/mspnp/aks-baseline'
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
    "kustomizations": {
      "value": {
        "unified": {
          "path": "./cluster-manifests"
        }
      }
    },
    "name": {
      "value": "kcfcmin001"
    },
    "namespace": {
      "value": "flux-system"
    },
    "scope": {
      "value": "cluster"
    },
    "sourceKind": {
      "value": "GitRepository"
    },
    // Non-required parameters
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
module fluxConfiguration 'br/public:avm/res/kubernetes-configuration/flux-configuration:<version>' = {
  name: 'fluxConfigurationDeployment'
  params: {
    // Required parameters
    clusterName: '<clusterName>'
    kustomizations: {
      unified: {
        dependsOn: []
        force: false
        path: './cluster-manifests'
        postBuild: {
          substitute: {
            TEST_VAR1: 'foo'
            TEST_VAR2: 'bar'
          }
        }
        prune: true
        syncIntervalInSeconds: 300
        timeoutInSeconds: 300
      }
    }
    name: 'kcfcmax001'
    namespace: 'flux-system'
    scope: 'cluster'
    sourceKind: 'GitRepository'
    // Non-required parameters
    gitRepository: {
      repositoryRef: {
        branch: 'main'
      }
      sshKnownHosts: ''
      syncIntervalInSeconds: 300
      timeoutInSeconds: 180
      url: 'https://github.com/mspnp/aks-baseline'
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
    "kustomizations": {
      "value": {
        "unified": {
          "dependsOn": [],
          "force": false,
          "path": "./cluster-manifests",
          "postBuild": {
            "substitute": {
              "TEST_VAR1": "foo",
              "TEST_VAR2": "bar"
            }
          },
          "prune": true,
          "syncIntervalInSeconds": 300,
          "timeoutInSeconds": 300
        }
      }
    },
    "name": {
      "value": "kcfcmax001"
    },
    "namespace": {
      "value": "flux-system"
    },
    "scope": {
      "value": "cluster"
    },
    "sourceKind": {
      "value": "GitRepository"
    },
    // Non-required parameters
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
    "location": {
      "value": "<location>"
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
module fluxConfiguration 'br/public:avm/res/kubernetes-configuration/flux-configuration:<version>' = {
  name: 'fluxConfigurationDeployment'
  params: {
    // Required parameters
    clusterName: '<clusterName>'
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
    name: 'kcfcwaf001'
    namespace: 'flux-system'
    scope: 'cluster'
    sourceKind: 'GitRepository'
    // Non-required parameters
    gitRepository: {
      repositoryRef: {
        branch: 'main'
      }
      sshKnownHosts: ''
      syncIntervalInSeconds: 300
      timeoutInSeconds: 180
      url: 'https://github.com/mspnp/aks-baseline'
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
    "name": {
      "value": "kcfcwaf001"
    },
    "namespace": {
      "value": "flux-system"
    },
    "scope": {
      "value": "cluster"
    },
    "sourceKind": {
      "value": "GitRepository"
    },
    // Non-required parameters
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
| [`kustomizations`](#parameter-kustomizations) | object | Array of kustomizations used to reconcile the artifact pulled by the source type on the cluster. |
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
| [`location`](#parameter-location) | string | Location for all resources. |
| [`suspend`](#parameter-suspend) | bool | Whether this configuration should suspend its reconciliation of its kustomizations and sources. |

### Parameter: `clusterName`

The name of the AKS cluster that should be configured.

- Required: Yes
- Type: string

### Parameter: `kustomizations`

Array of kustomizations used to reconcile the artifact pulled by the source type on the cluster.

- Required: Yes
- Type: object

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
- Allowed:
  ```Bicep
  [
    'cluster'
    'namespace'
  ]
  ```

### Parameter: `sourceKind`

Source Kind to pull the configuration data from.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Bucket'
    'GitRepository'
  ]
  ```

### Parameter: `bucket`

Parameters to reconcile to the GitRepository source kind type. Required if `sourceKind` is `Bucket`.

- Required: No
- Type: object

### Parameter: `gitRepository`

Parameters to reconcile to the GitRepository source kind type. Required if `sourceKind` is `GitRepository`.

- Required: No
- Type: object

### Parameter: `configurationProtectedSettings`

Key-value pairs of protected configuration settings for the configuration.

- Required: No
- Type: secureObject

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

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

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
