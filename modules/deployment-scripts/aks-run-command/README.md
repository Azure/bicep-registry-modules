# AKS Run Command Script

An Azure CLI Deployment Script that allows you to run a command on a Kubernetes cluster.

## Description

{{ Add detailed description for the module. }}

## Parameters

| Name                                       | Type     | Required | Description                                                                                                   |
| :----------------------------------------- | :------: | :------: | :------------------------------------------------------------------------------------------------------------ |
| `aksName`                                  | `string` | Yes      | The name of the Azure Kubernetes Service                                                                      |
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
| `scriptContent`                            | `string` | No       | Default Script to issue commands to AKS                                                                       |

## Outputs

| Name          | Type  | Description                                                         |
| :------------ | :---: | :------------------------------------------------------------------ |
| commandOutput | array | Array of command output from each Deployment Script AKS run command |

## Examples

### Example 1

```bicep
```

### Example 2

```bicep
```