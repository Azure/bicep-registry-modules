# SSH Key Pair Creation

Creates SSH Key Pair Stores them in KeyVault as Secrets

## Description

Creates SSH key pair and stores them in provided AKV.

## Parameters

| Name                                       | Type     | Required | Description                                                                                                                                                                                                   |
| :----------------------------------------- | :------: | :------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `akvName`                                  | `string` | Yes      | The name of the Azure Key Vault                                                                                                                                                                               |
| `location`                                 | `string` | No       | The location of the Key Vault and where to deploy the module resources to                                                                                                                                     |
| `forceUpdateTag`                           | `string` | No       | How the deployment script should be forced to execute                                                                                                                                                         |
| `rbacRoleNeeded`                           | `string` | No       | Azure RoleId that are required for the DeploymentScript resource to import images                                                                                                                             |
| `useExistingManagedIdentity`               | `bool`   | No       | Does the Managed Identity already exists, or should be created                                                                                                                                                |
| `managedIdentityName`                      | `string` | No       | Name of the Managed Identity resource                                                                                                                                                                         |
| `existingManagedIdentitySubId`             | `string` | No       | For an existing Managed Identity, the Subscription Id it is located in                                                                                                                                        |
| `existingManagedIdentityResourceGroupName` | `string` | No       | For an existing Managed Identity, the Resource Group it is located in                                                                                                                                         |
| `sshKeyName`                               | `string` | Yes      | The name of the SSH Key to be created.<br />if name is my-virtual-machine-ssh then the private key will be named my-virtual-machine-sshprivate and the public key will be named my-virtual-machine-sshpublic. |
| `initialScriptDelay`                       | `string` | No       | A delay before the script import operation starts. Primarily to allow Azure AAD Role Assignments to propagate                                                                                                 |
| `cleanupPreference`                        | `string` | No       | When the script resource is cleaned up                                                                                                                                                                        |

## Outputs

| Name                   | Type     | Description                                         |
| :--------------------- | :------: | :-------------------------------------------------- |
| `publicKeyUri`         | `string` | The URI of the public key secret in the Key Vault   |
| `privateKeyUri`        | `string` | The URI of the private key secret in the Key Vault  |
| `publicKeySecretName`  | `string` | The name of the public key secret in the Key Vault  |
| `privateKeySecretName` | `string` | The name of the private key secret in the Key Vault |

## Examples

### Example 1

```bicep
// Test with new managed identity
module test0 'br/public:deployment-scripts/aks-run-command:1.0.1' = {
  name: 'test0-${uniqueString(name)}'
  params: {
    akvName: prereq.outputs.akvName
    location: location
    sshKeyName: 'first-key'
  }
}


```

### Example 2

```bicep
// Test with existing managed identity
module test1 'br/public:deployment-scripts/aks-run-command:1.0.1' = {
  dependsOn: [
    test0
  ]
  name: 'test1-${uniqueString(name)}'
  params: {
    akvName: prereq.outputs.akvName
    location: location
    sshKeyName: 'second-key'
    existingManagedIdentityResourceGroupName: resourceGroup().name
    useExistingManagedIdentity: true
    managedIdentityName: prereq.outputs.identityName
    existingManagedIdentitySubId: subscription().subscriptionId
  }
}
```