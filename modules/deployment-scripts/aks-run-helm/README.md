# AKS Run Helm Script

An Azure CLI Deployment Script that allows you to run a Helm command at a Kubernetes cluster.

## Description

When deploying a Kubernetes cluster, it may be useful to include Helm scripts as part of the deployment process.
Using this Bicep module, you can directly include the setup and configuration of helm apps from any public container registry.
This module helps make sure that each resource has the proper permissions to succesful run these steps.

More information about using Helm on Azure can be found [here](https://docs.microsoft.com/en-us/azure/aks/quickstart-helm)

## Parameters

| Name                                       | Type     | Required | Description                                                                     |
| :----------------------------------------- | :------: | :------: | :------------------------------------------------------------------------------ |
| `aksName`                                  | `string` | Yes      | The name of the Azure Kubernetes Service                                        |
| `location`                                 | `string` | No       | The location to deploy the resources to                                         |
| `forceUpdateTag`                           | `string` | No       | How the deployment script should be forced to execute                           |
| `useExistingManagedIdentity`               | `bool`   | No       | Does the Managed Identity already exists, or should be created                  |
| `managedIdentityName`                      | `string` | No       | Name of the Managed Identity resource                                           |
| `existingManagedIdentitySubId`             | `string` | No       | For an existing Managed Identity, the Subscription Id it is located in          |
| `existingManagedIdentityResourceGroupName` | `string` | No       | For an existing Managed Identity, the Resource Group it is located in           |
| `helmRepo`                                 | `string` | No       | Public Helm Repo Name                                                           |
| `helmRepoURL`                              | `string` | No       | Public Helm Repo URL                                                            |
| `helmApps`                                 | `array`  | No       | Helm Apps {helmApp: 'azure-marketplace/wordpress', helmAppName: 'my-wordpress'} |
| `cleanupPreference`                        | `string` | No       | When the script resource is cleaned up                                          |

## Outputs

| Name        | Type  | Description                |
| :---------- | :---: | :------------------------- |
| helmOutputs | array | Helm Command Output Values |

## Examples

### Running a simple command

```bicep
module runCmd 'br/public:deployment-scripts/aks-run-helm:1.1.0' = {
  name: 'kubectlGetPods'
  params: {
    aksName: aksName
    location: location
    helmApps: [{helmApp: 'azure-marketplace/wordpress', helmAppName: 'my-wordpress'}]
  }
}
```

### Using an existing managed identity

When working with an existing managed identity that has the correct RBAC, you can opt out of new RBAC assignments and set the initial delay to zero.

```bicep
module runCmd 'br/public:deployment-scripts/aks-run-helm:1.1.0' = {
  name: 'kubectlGetNodes'
  params: {
    useExistingManagedIdentity: true
    managedIdentityName: managedIdentityName
    aksName: aksName
    location: location
    helmApps: [{helmApp: 'azure-marketplace/wordpress', helmAppName: 'my-wordpress'}]
  }
}
```

### Sending multiple sequenced commands

The module will sequence each command to run after the previous completes. There is a time impact for the DeploymentScript resource to create, therefore use new command items with consideration.

```bicep
var contributor='b24988ac-6180-42a0-ab88-20f7382dd24c'
var rbacWriter='a7ffa36f-339b-4b5c-8bdf-e2c188b2c0eb'

module runCmd 'br/public:deployment-scripts/aks-run-helm:1.1.0' = {
  name: 'kubectlRunNginx'
  params: {
    aksName: aksName
    location: location
    helmApps: [{helmApp: 'azure-marketplace/wordpress', helmAppName: 'my-wordpress'}]
  }
}
```

```bicep
module runCmd 'br/public:deployment-scripts/aks-run-helm:1.1.0' = {
  name: 'kubectlRunNginx'
  params: {
    aksName: aksName
    location: location
    helmApps: [{helmApp: 'azure-marketplace/wordpress', helmAppName: 'my-wordpress'}]
  }
}
```

### Running Helm Commands

```bicep
module helmInstallIngressController 'br/public:deployment-scripts/aks-run-helm:1.1.0' = {
  name: 'helmInstallIngressController'
  params: {
    aksName: aksName
    location: location
    helmApps: [
      {
        helmApp: 'bitnami/contour'
        helmAppName: 'contour-ingress'
        helmAppParams: '--version 7.7.1 --namespace ingress-basic --create_namespace --set envoy.kind=deployment --set contour.service.externalTrafficPolicy=cluster'
      }
    ]
  }
}
```