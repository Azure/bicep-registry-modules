# Key Vault Certificate Creation

Create Key Vault self-signed certificates and optionally integrate with Application Gateway

## Parameters

| Name                                       | Type     | Required | Description                                                                                                                                     |
| :----------------------------------------- | :------: | :------: | :---------------------------------------------------------------------------------------------------------------------------------------------- |
| `akvName`                                  | `string` | Yes      | The name of the Azure Key Vault                                                                                                                 |
| `agwName`                                  | `string` | No       | The name of the Azure Application Gateway                                                                                                       |
| `location`                                 | `string` | No       | The location to deploy the resources to                                                                                                         |
| `forceUpdateTag`                           | `string` | No       | How the deployment script should be forced to execute                                                                                           |
| `azCliVersion`                             | `string` | No       | Version of the Azure CLI to use                                                                                                                 |
| `timeout`                                  | `string` | No       | Deployment Script timeout                                                                                                                       |
| `retention`                                | `string` | No       | The retention period for the deployment script                                                                                                  |
| `rbacRolesNeededOnKV`                      | `array`  | No       | An array of Azure Key Vault RoleIds that are required for the DeploymentScript resource                                                         |
| `rbacRolesNeededOnAppGw`                   | `array`  | No       | An array of Azure Application Gateway RoleIds that are required for the DeploymentScript resource                                               |
| `useExistingManagedIdentity`               | `bool`   | No       | Does the Managed Identity already exists, or should be created                                                                                  |
| `managedIdentityName`                      | `string` | No       | Name of the Managed Identity resource                                                                                                           |
| `existingManagedIdentitySubId`             | `string` | No       | For an existing Managed Identity, the Subscription Id it is located in                                                                          |
| `existingManagedIdentityResourceGroupName` | `string` | No       | For an existing Managed Identity, the Resource Group it is located in                                                                           |
| `certNames`                                | `array`  | Yes      | An array of Certificate names to create                                                                                                         |
| `agwCertType`                              | `string` | No       | Configured certificate in Application Gateway as Frontend (ssl-cert) or Backend (root-cert)                                                     |
| `initialScriptDelay`                       | `string` | No       | A delay before the script import operation starts. Primarily to allow Azure AAD Role Assignments to propagate                                   |
| `agwCertImportDelay`                       | `string` | No       | A delay before the Application Gateway imports the Certificate from KeyVault. Primarily to allow the certificate creation operation to complete |
| `cleanupPreference`                        | `string` | No       | When the script resource is cleaned up                                                                                                          |
| `agwIdName`                                | `string` | No       | The User Assigned Identity of the Azure Application Gateway                                                                                     |

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

### KeyVault Certificate added to Application Gateway

Creates a single self-signed certificate in Azure KeyVault, and makes it available as a front-end SSL Certificate in Azure Application Gateway.

> Requires the Azure Application Gateway to be configured with a [User Managed Identity](https://docs.microsoft.com/azure/application-gateway/key-vault-certs#obtain-a-user-assigned-managed-identity)

```bicep
param location string = resourceGroup().location
param akvName string =  'yourAzureKeyVault'
param agwName string = 'yourAzureAppGateway'
param agwIdName string = 'id-yourAzureAppGateway'
param certificateName string = 'myapp'

module acrImport 'br/public:deployment-scripts/create-agw-kv-certificate:1.0.1' = {
  name: 'akvCertSingle'
  params: {
    akvName: akvName
    location: location
    certNames: array(certificateName)
    agwName: agwName
    agwIdName: agwIdName
    agwCertType: 'ssl-cert'
  }
}
```