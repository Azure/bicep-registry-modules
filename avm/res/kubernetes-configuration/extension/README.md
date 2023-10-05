# Kubernetes Configuration Extensions `[Microsoft.KubernetesConfiguration/extensions]`

This module deploys a Kubernetes Configuration Extension.

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
| `Microsoft.KubernetesConfiguration/extensions` | [2022-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KubernetesConfiguration/2022-03-01/extensions) |
| `Microsoft.KubernetesConfiguration/fluxConfigurations` | [2022-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KubernetesConfiguration/2022-03-01/fluxConfigurations) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `clusterName` | string | The name of the AKS cluster that should be configured. |
| `extensionType` | string | Type of the Extension, of which this resource is an instance of. It must be one of the Extension Types registered with Microsoft.KubernetesConfiguration by the Extension publisher. |
| `name` | string | The name of the Flux Configuration. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `configurationProtectedSettings` | secureObject | `{object}` | Configuration settings that are sensitive, as name-value pairs for configuring this extension. |
| `configurationSettings` | object | `{object}` | Configuration settings, as name-value pairs for configuring this extension. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `fluxConfigurations` | array | `[]` | A list of flux configuraitons. |
| `location` | string | `[resourceGroup().location]` | Location for all resources. |
| `releaseNamespace` | string | `''` | Namespace where the extension Release must be placed, for a Cluster scoped extension. If this namespace does not exist, it will be created. |
| `releaseTrain` | string | `'Stable'` | ReleaseTrain this extension participates in for auto-upgrade (e.g. Stable, Preview, etc.) - only if autoUpgradeMinorVersion is "true". |
| `targetNamespace` | string | `''` | Namespace where the extension will be created for an Namespace scoped extension. If this namespace does not exist, it will be created. |
| `version` | string | `''` | Version of the extension for this extension, if it is "pinned" to a specific version. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the extension. |
| `resourceGroupName` | string | The name of the resource group the extension was deployed into. |
| `resourceId` | string | The resource ID of the extension. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `kubernetes-configuration/flux-configuration` | Local reference |

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Common</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module extension './kubernetes-configuration/extension/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-kcecom'
  params: {
    // Required parameters
    clusterName: '<clusterName>'
    extensionType: 'microsoft.flux'
    name: 'kcecom001'
    // Non-required parameters
    configurationSettings: {
      'image-automation-controller.enabled': 'false'
      'image-reflector-controller.enabled': 'false'
      'kustomize-controller.enabled': 'true'
      'notification-controller.enabled': 'false'
      'source-controller.enabled': 'true'
    }
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    fluxConfigurations: [
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
      }
    ]
    releaseNamespace: 'flux-system'
    releaseTrain: 'Stable'
    version: '0.5.2'
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
    "extensionType": {
      "value": "microsoft.flux"
    },
    "name": {
      "value": "kcecom001"
    },
    // Non-required parameters
    "configurationSettings": {
      "value": {
        "image-automation-controller.enabled": "false",
        "image-reflector-controller.enabled": "false",
        "kustomize-controller.enabled": "true",
        "notification-controller.enabled": "false",
        "source-controller.enabled": "true"
      }
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "fluxConfigurations": {
      "value": [
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
          "namespace": "flux-system"
        }
      ]
    },
    "releaseNamespace": {
      "value": "flux-system"
    },
    "releaseTrain": {
      "value": "Stable"
    },
    "version": {
      "value": "0.5.2"
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
module extension './kubernetes-configuration/extension/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-kcemin'
  params: {
    // Required parameters
    clusterName: '<clusterName>'
    extensionType: 'microsoft.flux'
    name: 'kcemin001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    releaseNamespace: 'flux-system'
    releaseTrain: 'Stable'
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
    "extensionType": {
      "value": "microsoft.flux"
    },
    "name": {
      "value": "kcemin001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "releaseNamespace": {
      "value": "flux-system"
    },
    "releaseTrain": {
      "value": "Stable"
    }
  }
}
```

</details>
<p>
