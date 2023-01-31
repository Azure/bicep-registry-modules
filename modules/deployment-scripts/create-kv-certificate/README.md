# Key Vault Certificate Creation

Create Key Vault self-signed certificates. Requires Key Vaults to be using RBAC Authorization, not Access Policies.

## Description

Using this Bicep module, you can automate the creation of a certificate within an Azure Key Vault.
To create a signed certificate first configure a certificate issuer within Key Vault. Then set the `issuerName` parameter.

This module is based on the `az cli certificate` create command and more information can be found [here](https://docs.microsoft.com/en-us/cli/azure/keyvault/certificate?view=azure-cli-latest#az-keyvault-certificate-create)

## Parameters

| Name                                       | Type           | Required | Description                                                                                                   |
| :----------------------------------------- | :------------: | :------: | :------------------------------------------------------------------------------------------------------------ |
| `akvName`                                  | `string`       | Yes      | The name of the Azure Key Vault                                                                               |
| `location`                                 | `string`       | Yes      | The location to deploy the resources to                                                                       |
| `forceUpdateTag`                           | `string`       | No       | How the deployment script should be forced to execute                                                         |
| `rbacRolesNeededOnKV`                      | `string`       | No       | The RoleDefinitionId required for the DeploymentScript resource to interact with KeyVault                     |
| `useExistingManagedIdentity`               | `bool`         | No       | Does the Managed Identity already exists, or should be created                                                |
| `managedIdentityName`                      | `string`       | No       | Name of the Managed Identity resource                                                                         |
| `existingManagedIdentitySubId`             | `string`       | No       | For an existing Managed Identity, the Subscription Id it is located in                                        |
| `existingManagedIdentityResourceGroupName` | `string`       | No       | For an existing Managed Identity, the Resource Group it is located in                                         |
| `certificateName`                          | `string`       | Yes      | The name of the certificate to create                                                                         |
| `certificateCommonName`                    | `string`       | No       | The common name of the certificate to create                                                                  |
| `initialScriptDelay`                       | `string`       | No       | A delay before the script import operation starts. Primarily to allow Azure AAD Role Assignments to propagate |
| `cleanupPreference`                        | `string`       | No       | When the script resource is cleaned up                                                                        |
| `issuerName`                               | `string`       | No       | Self, or {IssuerName} for certificate signing                                                                 |
| `issuerProvider`                           | `string`       | No       | Certificate Issuer Provider, DigiCert, GlobalSign, or internal options may be used.                           |
| `accountId`                                | `string`       | No       | Account ID of Certificate Issuer Account                                                                      |
| `issuerPassword`                           | `secureString` | No       | Password of Certificate Issuer Account                                                                        |
| `organizationId`                           | `string`       | No       | Organization ID of Certificate Issuer Account                                                                 |
| `isCrossTenant`                            | `bool`         | No       | Override this parameter if using this in a managed application                                                |

## Outputs

| Name                           | Type   | Description                                       |
| :----------------------------- | :----: | :------------------------------------------------ |
| certificateName                | string | Certificate name                                  |
| certificateSecretId            | string | KeyVault secret id to the created version         |
| certificateSecretIdUnversioned | string | KeyVault secret id which uses the unversioned uri |
| certificateThumbprint          | string | Certificate Thumbprint                            |
| certificateThumbprintHex       | string | Certificate Thumbprint (in hex)                   |

## Examples

### Single KeyVault Certificate

Creates a single self-signed certificate in Azure KeyVault.

```bicep
param location string = resourceGroup().location
param akvName string =  'yourAzureKeyVault'
param certificateName string = 'myapp'

module kvCert 'br/public:deployment-scripts/create-kv-certificate:1.1.1' = {
  name: 'akvCertSingle'
  params: {
    akvName: akvName
    location: location
    certificateName: certificateName
  }
}
output SecretId string = akvCertSingle.outputs.certificateSecretId
output Thumbprint string = akvCertSingle.outputs.certificateThumbprintHex

```

### Single KeyVault Certificate with fqdn common name

Creates a single self-signed certificate in Azure KeyVault using a specific certificate common name.

```bicep
param location string = resourceGroup().location
param akvName string =  'yourAzureKeyVault'
param certificateName string = 'myapp'
param certificateCommonName string = '${certificateName}.mydomain.local'

module kvCert 'br/public:deployment-scripts/create-kv-certificate:1.1.1' = {
  name: 'akvCertSingle'
  params: {
    akvName: akvName
    location: location
    certificateName: certificateName
    certificateCommonName: certificateCommonName
  }
}
output SecretId string = akvCertSingle.outputs.certificateSecretId
output Thumbprint string = akvCertSingle.outputs.certificateThumbprintHex

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

module kvCert 'br/public:deployment-scripts/create-kv-certificate:1.1.1' = [ for certificateName in certificateNames : {
  name: 'akvCert-${certificateName}'
  params: {
    akvName:  akvName
    location: location
    certificateName: certificateName
  }
}]

@description('Array of info from each Certificate')
output createdCertificates array = [for (certificateName, i) in certificateNames: {
  certificateName: certificateName
  certificateSecretId: akvCertMultiple[i].outputs.certificateSecretId
  certificateThumbprint: akvCertMultiple[i].outputs.certificateThumbprintHex
}]
```

### Create Signed Certificate

Using `DigiCert` or `GlobalSign` first requires account setup described [here](https://learn.microsoft.com/en-us/azure/key-vault/certificates/how-to-integrate-certificate-authority)

```bicep
param accountId
@secure
param digicertPassword
param organizationId

module signedCert 'br/public:deployment-scripts/create-kv-certificate:1.1.1' = {
  name: 'akvCert-${certificateName}'
  params: {
    akvName:  akvName
    location: location
    certificateName: certificateName
    certificateCommonName: 'customdomain.com'
    issuerName: 'MyCert'
    issuerProvider: 'DigiCert'
    accountId: accountId
    digicertPassword: digicertPassword
    organizationId: organizationId
  }
}]
```