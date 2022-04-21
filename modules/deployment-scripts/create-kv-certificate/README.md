# Key Vault Certificate Creation

Create Key Vault self-signed certificates

## Parameters

| Name                                       | Type     | Required | Description                                                                                                   |
| :----------------------------------------- | :------: | :------: | :------------------------------------------------------------------------------------------------------------ |
| `akvName`                                  | `string` | Yes      | The name of the Azure Key Vault                                                                               |
| `location`                                 | `string` | No       | The location to deploy the resources to                                                                       |
| `forceUpdateTag`                           | `string` | No       | How the deployment script should be forced to execute                                                         |
| `azCliVersion`                             | `string` | No       | Version of the Azure CLI to use                                                                               |
| `timeout`                                  | `string` | No       | Deployment Script timeout                                                                                     |
| `retention`                                | `string` | No       | The retention period for the deployment script                                                                |
| `rbacRolesNeededOnKV`                      | `string` | No       | The RoleDefinitionId required for the DeploymentScript resource to interact with KeyVault                     |
| `useExistingManagedIdentity`               | `bool`   | No       | Does the Managed Identity already exists, or should be created                                                |
| `managedIdentityName`                      | `string` | No       | Name of the Managed Identity resource                                                                         |
| `existingManagedIdentitySubId`             | `string` | No       | For an existing Managed Identity, the Subscription Id it is located in                                        |
| `existingManagedIdentityResourceGroupName` | `string` | No       | For an existing Managed Identity, the Resource Group it is located in                                         |
| `certNames`                                | `array`  | Yes      | An array of Certificate names to create                                                                       |
| `initialScriptDelay`                       | `string` | No       | A delay before the script import operation starts. Primarily to allow Azure AAD Role Assignments to propagate |
| `cleanupPreference`                        | `string` | No       | When the script resource is cleaned up                                                                        |

## Outputs

| Name                | Type  | Description                                           |
| :------------------ | :---: | :---------------------------------------------------- |
| createdCertificates | array | Array of info from each Certificate Deployment Script |

## Examples

### Single KeyVault Certificate

Creates a single self-signed certificate in Azure KeyVault.

```bicep
param location string = resourceGroup().location
param akvName string =  'yourAzureKeyVault'
param certificateName string = 'myapp'

module acrImport 'br/public:deployment-scripts/create-agw-kv-certificate:1.0.1' = {
  name: 'akvCertSingle'
  params: {
    akvName: akvName
    location: location
    certNames: array(certificateName)
  }
}
```

### Multiple KeyVault Certificates

Create multiple self-signed certificates in Azure KeyVault

```bicep
param location string = resourceGroup().location
param akvName string =  'yourAzureKeyVault'
param certificateNames array = [
  'myapp'
  'myotherapp'
]

module acrImport 'br/public:deployment-scripts/create-agw-kv-certificate:1.0.1' = {
  name: 'akvCertSingle'
  params: {
    akvName: akvName
    location: location
    certNames: certificateNames
  }
}
```