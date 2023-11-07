# AKS Run Command Script

An Azure CLI Deployment Script that allows you to run a command on a Kubernetes cluster.

## Details

AKS run command allows you to remotely invoke commands in an AKS cluster through the AKS API. This module makes use of a custom script to expose this capability in a Bicep accessible module.
This module configures the required permissions so that you do not have to configure the identity.

## Parameters

| Name                                       | Type     | Required | Description                                                                                                   |
| :----------------------------------------- | :------: | :------: | :------------------------------------------------------------------------------------------------------------ |
| `aksName`                                  | `string` | Yes      | The name of the Azure Kubernetes Service                                                                      |
| `location`                                 | `string` | Yes      | The location to deploy the resources to                                                                       |
| `forceUpdateTag`                           | `string` | No       | How the deployment script should be forced to execute                                                         |
| `rbacRolesNeeded`                          | `array`  | No       | An array of Azure RoleIds that are required for the DeploymentScript resource                                 |
| `newOrExistingManagedIdentity`             | `string` | No       | Create "new" or use "existing" Managed Identity. Default: new                                                 |
| `managedIdentityName`                      | `string` | No       | Name of the Managed Identity resource                                                                         |
| `existingManagedIdentitySubId`             | `string` | No       | For an existing Managed Identity, the Subscription Id it is located in                                        |
| `existingManagedIdentityResourceGroupName` | `string` | No       | For an existing Managed Identity, the Resource Group it is located in                                         |
| `commands`                                 | `array`  | Yes      | An array of commands to run                                                                                   |
| `initialScriptDelay`                       | `string` | No       | A delay before the script import operation starts. Primarily to allow Azure AAD Role Assignments to propagate |
| `cleanupPreference`                        | `string` | No       | When the script resource is cleaned up                                                                        |
| `isCrossTenant`                            | `bool`   | No       | Set to true when deploying template across tenants                                                            |

## Outputs

| Name            | Type    | Description                                                         |
| :-------------- | :-----: | :------------------------------------------------------------------ |
| `commandOutput` | `array` | Array of command output from each Deployment Script AKS run command |

## Examples

### Running a simple command

```bicep
module runCmd 'br/public:deployment-scripts/aks-run-command:2.0.2' = {
  name: 'kubectlGetPods'
  params: {
    aksName: aksName
    location: location
    commands: [
      'kubectl get pods'
    ]
  }
}
```

### Using an existing managed identity

When working with an existing managed identity that has the correct RBAC, you can opt out of new RBAC assignments and set the initial delay to zero.

```bicep
module runCmd 'br/public:deployment-scripts/aks-run-command:2.0.2' = {
  name: 'kubectlGetNodes'
  params: {
    useExistingManagedIdentity: true
    initialScriptDelay: '0'
    managedIdentityName: managedIdentityName
    rbacRolesNeeded:[]
    aksName: aksName
    location: location
    commands: [
      'kubectl get nodes'
    ]
  }
}
```

### Sending multiple sequenced commands

The module will sequence each command to run after the previous completes. There is a time impact for the DeploymentScript resource to create, therefore use new command items with consideration.

```bicep
var contributor='b24988ac-6180-42a0-ab88-20f7382dd24c'
var rbacWriter='a7ffa36f-339b-4b5c-8bdf-e2c188b2c0eb'

module runCmd 'br/public:deployment-scripts/aks-run-command:2.0.2' = {
  name: 'kubectlRunNginx'
  params: {
    aksName: aksName
    location: location
    rbacRolesNeeded:[
      contributor
      rbacWriter
    ]
    commands: [
      'kubectl run nginx --image=nginx'
      'kubectl get pods'
    ]
  }
}
```

```bicep
module runCmd 'br/public:deployment-scripts/aks-run-command:2.0.2' = {
  name: 'kubectlRunNginx'
  params: {
    aksName: aksName
    location: location
    rbacRolesNeeded:[
      contributor
      rbacWriter
    ]
    commands: [
      'kubectl run nginx --image=nginx; kubectl get pods'
    ]
  }
}
```

### Running Helm Commands

```bicep
module helmInstallIngressController 'br/public:deployment-scripts/aks-run-command:2.0.2' = {
  name: 'helmInstallIngressController'
  params: {
    aksName: aksName
    location: location
    rbacRolesNeeded:[
      contributor
      rbacWriter
    ]
    commands: [
      'helm repo add bitnami https://charts.bitnami.com/bitnami; helm repo update'
      'helm upgrade --install  contour-ingress bitnami/contour --version 7.7.1 --namespace ingress-basic --create-namespace --set envoy.kind=deployment --set contour.service.externalTrafficPolicy=cluster'
    ]
  }
}
```