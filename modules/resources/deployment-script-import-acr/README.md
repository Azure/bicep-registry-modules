# ACR Image Import

An Azure CLI Deployment Script that imports public container images to an Azure Container Registry

## Parameters

| Name                | Type     | Required | Description                                                                  |
| :------------------ | :------: | :------: | :--------------------------------------------------------------------------- |
| `acrName`           | `string` | Yes      | The name of the Azure Container Registry                                     |
| `location`          | `string` | No       | The location to deploy the resources to                                      |
| `forceUpdateTag`    | `string` | No       | How the deployment script should be forced to execute                        |
| `azCliVersion`      | `string` | No       | Version of the Azure CLI to use                                              |
| `timeout`           | `string` | No       | Deployment Script timeout                                                    |
| `retention`         | `string` | No       | The retention period for the deployment script                               |
| `rbacRolesNeeded`   | `array`  | No       | An array of Azure RoleId that are required for the DeploymentScript resource |
| `managedIdName`     | `string` | No       | Name of the Managed Identity resource                                        |
| `images`            | `array`  | No       | An array of fully qualified images names to import                           |
| `cleanupPreference` | `string` | No       | When the script resource is cleaned up                                       |

## Outputs

| Name | Type | Description |
| :--- | :--: | :---------- |

## Examples

### Example 1

```bicep
```

### Example 2

```bicep
```