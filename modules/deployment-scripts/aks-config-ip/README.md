# AKS Confiugre Public IP

An Azure CLI Deployment Script that allows you to configure a Public IP address with AKS.

## Description

An ingress controller is a piece of software that provides reverse proxy, configurable traffic routing, and TLS termination for Kubernetes services.
Kubernetes ingress resources are used to configure the ingress rules and routes for individual Kubernetes services.
When you use an ingress controller and ingress rules, a single IP address can be used to route traffic to multiple services in a Kubernetes cluster.

[This]((https://docs.microsoft.com/en-us/azure/aks/ingress-basic?tabs=azure-cli)) article shows you how to deploy the NGINX ingress controller in an Azure Kubernetes Service (AKS) cluster manually. Two applications are then run in the AKS cluster, each of which is accessible over the single IP address.

## Parameters

| Name                                       | Type     | Required | Description                                                            |
| :----------------------------------------- | :------: | :------: | :--------------------------------------------------------------------- |
| `aksName`                                  | `string` | Yes      | The name of the Azure Kubernetes Service                               |
| `location`                                 | `string` | No       | The location to deploy the resources to                                |
| `forceUpdateTag`                           | `string` | No       | How the deployment script should be forced to execute                  |
| `useExistingManagedIdentity`               | `bool`   | No       | Does the Managed Identity already exists, or should be created         |
| `managedIdentityName`                      | `string` | No       | Name of the Managed Identity resource                                  |
| `existingManagedIdentitySubId`             | `string` | No       | For an existing Managed Identity, the Subscription Id it is located in |
| `existingManagedIdentityResourceGroupName` | `string` | No       | For an existing Managed Identity, the Resource Group it is located in  |
| `publicIP`                                 | `string` | Yes      | Azure Public IP to attach to AKS                                       |
| `publicIPResourceGroup`                    | `string` | No       | Resource Group of Azure Public IP                                      |
| `cleanupPreference`                        | `string` | No       | When the script resource is cleaned up                                 |

## Outputs

| Name | Type | Description |
| :--- | :--: | :---------- |

## Examples

### Running a simple command

```bicep
module runCmd 'br/public:deployment-scripts/aks-run-helm:1.0.1' = {
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
module runCmd 'br/public:deployment-scripts/aks-run-helm:1.0.1' = {
  name: 'kubectlGetNodes'
  params: {
    useExistingManagedIdentity: true
    initialScriptDelay: '0'
    managedIdentityName: managedIdentityName
    rbacRolesNeeded:[]
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

module runCmd 'br/public:deployment-scripts/aks-run-helm:1.0.1' = {
  name: 'kubectlRunNginx'
  params: {
    aksName: aksName
    location: location
    helmApps: [{helmApp: 'azure-marketplace/wordpress', helmAppName: 'my-wordpress'}]
  }
}
```

```bicep
module runCmd 'br/public:deployment-scripts/aks-run-helm:1.0.1' = {
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
module helmInstallIngressController 'br/public:deployment-scripts/aks-run-helm:1.0.1' = {
  name: 'helmInstallIngressController'
  params: {
    aksName: aksName
    location: location
    helmApps: [
      {
        helmApp: 'bitnami/contour'
        helmAppName: 'contour-ingress'
        helmParams: '--version 7.7.1 --namespace ingress-basic --create_namespace --set envoy.kind=deployment --set contour.service.externalTrafficPolicy=cluster'
      }
    ]
  }
}
```