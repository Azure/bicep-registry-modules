# Azure Run CLI Command Script

An Azure CLI Deployment Script that allows you to run a command on the resource group.

## Description

{{ Add detailed description for the module. }}

## Parameters

| Name                                       | Type     | Required | Description                                                                                                   |
| :----------------------------------------- | :------: | :------: | :------------------------------------------------------------------------------------------------------------ |
| `location`                                 | `string` | No       | The location to deploy the resources to                                                                       |
| `forceUpdateTag`                           | `string` | No       | How the deployment script should be forced to execute                                                         |
| `rbacRolesNeeded`                          | `array`  | No       | An array of Azure RoleIds that are required for the DeploymentScript resource                                 |
| `useExistingManagedIdentity`               | `bool`   | No       | Does the Managed Identity already exists, or should be created                                                |
| `managedIdentityName`                      | `string` | No       | Name of the Managed Identity resource                                                                         |
| `existingManagedIdentitySubId`             | `string` | No       | For an existing Managed Identity, the Subscription Id it is located in                                        |
| `existingManagedIdentityResourceGroupName` | `string` | No       | For an existing Managed Identity, the Resource Group it is located in                                         |
| `commands`                                 | `array`  | Yes      | An array of commands to run                                                                                   |
| `initialScriptDelay`                       | `string` | No       | A delay before the script import operation starts. Primarily to allow Azure AAD Role Assignments to propagate |
| `cleanupPreference`                        | `string` | No       | When the script resource is cleaned up                                                                        |
| `scriptContent`                            | `string` | Yes      | Azure CLI Script                                                                                              |
| `environmentVariables`                     | `array`  | No       | Addtional Environmental Variables to set for script.                                                          |

## Outputs

| Name          | Type  | Description                                                         |
| :------------ | :---: | :------------------------------------------------------------------ |
| commandOutput | array | Array of command output from each Deployment Script AKS run command |

## Examples

### Running a simple command

```bicep
module runCmd 'br/public:deployment-scripts/aks-run-command:1.0.1' = {
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
module runCmd 'br/public:deployment-scripts/aks-run-command:1.0.1' = {
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

module runCmd 'br/public:deployment-scripts/aks-run-command:1.0.1' = {
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
module runCmd 'br/public:deployment-scripts/aks-run-command:1.0.1' = {
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
module helmInstallIngressController 'br/public:deployment-scripts/aks-run-command:1.0.1' = {
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