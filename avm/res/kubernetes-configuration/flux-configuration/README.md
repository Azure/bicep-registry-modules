# Kubernetes Configuration Flux Configurations `[Microsoft.KubernetesConfiguration/fluxConfigurations]`

This module deploys a Kubernetes Configuration Flux Configuration.

## Navigation

- [Prerequisites](#Prerequisites)
- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Prerequisites

Registration of your subscription with the AKS-ExtensionManager feature flag. Use the following command:

```powershell
az feature register --namespace Microsoft.ContainerService --name AKS-ExtensionManager
```

Registration of the following Azure service providers. (It's OK to re-register an existing provider.)

```powershell
az provider register --namespace Microsoft.Kubernetes
az provider register --namespace Microsoft.ContainerService
az provider register --namespace Microsoft.KubernetesConfiguration
```

For Details see [Prerequisites](https://learn.microsoft.com/en-us/azure/azure-arc/kubernetes/tutorial-use-gitops-flux2)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.KubernetesConfiguration/fluxConfigurations` | [2022-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KubernetesConfiguration/2022-03-01/fluxConfigurations) |

## Parameters

**Required parameters**

| Parameter Name | Type | Allowed Values | Description |
| :-- | :-- | :-- | :-- |
| `clusterName` | string |  | The name of the AKS cluster that should be configured. |
| `name` | string |  | The name of the Flux Configuration. |
| `namespace` | string |  | The namespace to which this configuration is installed to. Maximum of 253 lower case alphanumeric characters, hyphen and period only. |
| `scope` | string | `[cluster, namespace]` | Scope at which the configuration will be installed. |
| `sourceKind` | string | `[Bucket, GitRepository]` | Source Kind to pull the configuration data from. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `bucket` | object | `{object}` | Parameters to reconcile to the GitRepository source kind type. |
| `configurationProtectedSettings` | secureObject | `{object}` | Key-value pairs of protected configuration settings for the configuration. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `gitRepository` | object | `{object}` | Parameters to reconcile to the GitRepository source kind type. |
| `kustomizations` | object | `{object}` | Array of kustomizations used to reconcile the artifact pulled by the source type on the cluster. |
| `location` | string | `[resourceGroup().location]` | Location for all resources. |
| `suspend` | bool | `False` | Whether this configuration should suspend its reconciliation of its kustomizations and sources. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the flux configuration. |
| `resourceGroupName` | string | The name of the resource group the flux configuration was deployed into. |
| `resourceId` | string | The resource ID of the flux configuration. |

## Cross-referenced modules

_None_

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Common</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module fluxConfiguration './kubernetes-configuration/flux-configuration/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-kcfccom'
  params: {
    // Required parameters
    clusterName: '<clusterName>'
    name: 'kcfccom001'
    namespace: 'flux-system'
    sourceKind: 'GitRepository'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
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
      "value": "kcfccom001"
    },
    "namespace": {
      "value": "flux-system"
    },
    "sourceKind": {
      "value": "GitRepository"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
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
module fluxConfiguration './kubernetes-configuration/flux-configuration/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-kcfcmin'
  params: {
    // Required parameters
    clusterName: '<clusterName>'
    name: 'kcfcmin001'
    namespace: 'flux-system'
    sourceKind: 'GitRepository'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    gitRepository: {
      repositoryRef: {
        branch: 'main'
      }
      sshKnownHosts: ''
      syncIntervalInSeconds: 300
      timeoutInSeconds: 180
      url: 'https://github.com/mspnp/aks-baseline'
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
    "clusterName": {
      "value": "<clusterName>"
    },
    "name": {
      "value": "kcfcmin001"
    },
    "namespace": {
      "value": "flux-system"
    },
    "sourceKind": {
      "value": "GitRepository"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
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
    }
  }
}
```

</details>
<p>
