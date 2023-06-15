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
| `certificateNames`                         | `array`        | Yes      | The names of the certificate to create. Use when creating many certificates.                                  |
| `certificateCommonNames`                   | `array`        | No       | The common names of the certificate to create. Use when creating many certificates.                           |
| `initialScriptDelay`                       | `string`       | No       | A delay before the script import operation starts. Primarily to allow Azure AAD Role Assignments to propagate |
| `cleanupPreference`                        | `string`       | No       | When the script resource is cleaned up                                                                        |
| `issuerName`                               | `string`       | No       | Self, or user defined {IssuerName} for certificate signing                                                    |
| `issuerProvider`                           | `string`       | No       | Certificate Issuer Provider, DigiCert, GlobalSign, or internal options may be used.                           |
| `disabled`                                 | `bool`         | No       | Create certificate in disabled state. Default: false                                                          |
| `accountId`                                | `string`       | No       | Account ID of Certificate Issuer Account                                                                      |
| `issuerPassword`                           | `securestring` | No       | Password of Certificate Issuer Account                                                                        |
| `organizationId`                           | `string`       | No       | Organization ID of Certificate Issuer Account                                                                 |
| `isCrossTenant`                            | `bool`         | No       | Override this parameter if using this in cross tenant scenarios                                               |
| `reuseKey`                                 | `bool`         | No       | The default policy might cause errors about CSR being used before, so set this to false if that happens       |
| `validity`                                 | `int`          | No       | Optional. Override default validityInMonths 12 value                                                          |
| `performRoleAssignment`                    | `bool`         | No       | Set to false to disable role assignments within this module. Default: true                                    |

## Outputs

| Name                              | Type    | Description                                        |
| :-------------------------------- | :-----: | :------------------------------------------------- |
| `certificateNames`                | `array` | Certificate names                                  |
| `certificateSecretIds`            | `array` | KeyVault secret ids to the created version         |
| `certificateSecretIdUnversioneds` | `array` | KeyVault secret ids which uses the unversioned uri |
| `certificateThumbpints`           | `array` | Certificate Thumbprints                            |
| `certificateThumbprintHexs`       | `array` | Certificate Thumbprints (in hex)                   |

## Examples

### Single KeyVault Certificate

Creates a single self-signed certificate in Azure KeyVault.

```bicep
param location string = resourceGroup().location
param akvName string = 'yourAzureKeyVault'
param certificateName string = 'myapp'

module kvCert 'br/public:deployment-scripts/create-kv-certificate:3.4' = {
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

module kvCert 'br/public:deployment-scripts/create-kv-certificate:3.4' = {
  name: 'akvCertSingle'
  params: {
    akvName: akvName
    location: location
    certificateNames: [certificateName]
    certificateCommonNames: [certificateCommonName]
  }
}
output SecretId string = akvCertSingle.outputs.certificateSecretIds[0]
output Thumbprint string = akvCertSingle.outputs.certificateThumbprintHexs[0]

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

module kvCert 'br/public:deployment-scripts/create-kv-certificate:3.1.1' = {
  name: 'akvCert-${certificateName}'
  params: {
    akvName:  akvName
    location: location
    certificateNames: certificateNames
  }
}

@description('Array of info from each Certificate')
output createdCertificates array = [for (certificateName, i) in certificateNames: {
  certificateName: kvCert.outputs.certificateNames[i]
  certificateSecretId: kvCert.outputs.certificateSecretIds[i]
  certificateThumbprint: kvCert.outputs.certificateThumbprintHexs[i]
}]
```

### Create Signed Certificate

Using `DigiCert` or `GlobalSign` first requires account setup described [here](https://learn.microsoft.com/en-us/azure/key-vault/certificates/how-to-integrate-certificate-authority)

```bicep
param accountId
@secure
param issuerPassword
param organizationId

module signedCert 'br/public:deployment-scripts/create-kv-certificate:3.1.1' = {
  name: 'akvCert-${certificateName}'
  params: {
    akvName:  akvName
    location: location
    certificateName: [certificateName]
    certificateCommonName: ['customdomain.com']
    issuerName: 'MyCert'
    issuerProvider: 'DigiCert'
    accountId: accountId
    issuerPassword: issuerPassword
    organizationId: organizationId
  }
}]
```