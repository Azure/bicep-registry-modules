# Key Vault Certificate Creation

Create Key Vault self-signed certificates and optionally integrarte with Application Gateway

## Parameters

| Name                                       | Type     | Required | Description                                                                                                   |
| :----------------------------------------- | :------: | :------: | :------------------------------------------------------------------------------------------------------------ |
| `akvName`                                  | `string` | Yes      | The name of the Azure Key Vault                                                                               |
| `agwName`                                  | `string` | No       | The name of the Azure Application Gateway                                                                     |
| `location`                                 | `string` | No       | The location to deploy the resources to                                                                       |
| `forceUpdateTag`                           | `string` | No       | How the deployment script should be forced to execute                                                         |
| `azCliVersion`                             | `string` | No       | Version of the Azure CLI to use                                                                               |
| `timeout`                                  | `string` | No       | Deployment Script timeout                                                                                     |
| `retention`                                | `string` | No       | The retention period for the deployment script                                                                |
| `rbacRolesNeeded`                          | `array`  | No       | An array of Azure RoleIds that are required for the DeploymentScript resource                                 |
| `useExistingManagedIdentity`               | `bool`   | No       | Does the Managed Identity already exists, or should be created                                                |
| `managedIdentityName`                      | `string` | No       | Name of the Managed Identity resource                                                                         |
| `existingManagedIdentitySubId`             | `string` | No       | For an existing Managed Identity, the Subscription Id it is located in                                        |
| `existingManagedIdentityResourceGroupName` | `string` | No       | For an existing Managed Identity, the Resource Group it is located in                                         |
| `certNames`                                | `array`  | Yes      | An array of Certificate names to create                                                                       |
| `agwCertType`                              | `string` | No       | Configured certificate in Application Gateway as Frontend (ssl-cert) or Backend (root-cert)                   |
| `initialScriptDelay`                       | `string` | No       | A delay before the script import operation starts. Primarily to allow Azure AAD Role Assignments to propagate |
| `cleanupPreference`                        | `string` | No       | When the script resource is cleaned up                                                                        |

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