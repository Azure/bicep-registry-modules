<h1 style="color: steelblue;">⚠️ Retired ⚠️</h1>

This module has been retired without a replacement module in Azure Verified Modules (AVM).

For more information, see the informational notice [here](https://github.com/Azure/bicep-registry-modules?tab=readme-ov-file#%EF%B8%8F-new-standard-for-bicep-modules---avm-%EF%B8%8F).

# ACR Image Import

An Azure CLI Deployment Script that imports public container images to an Azure Container Registry

## Details

An Azure CLI Deployment Script that imports public container images to an Azure Container Registry.

## Parameters

| Name                                       | Type     | Required | Description                                                                                                   |
| :----------------------------------------- | :------: | :------: | :------------------------------------------------------------------------------------------------------------ |
| `acrName`                                  | `string` | Yes      | The name of the Azure Container Registry                                                                      |
| `location`                                 | `string` | No       | The location to deploy the resources to                                                                       |
| `forceUpdateTag`                           | `string` | No       | How the deployment script should be forced to execute                                                         |
| `rbacRoleNeeded`                           | `string` | No       | Azure RoleId that are required for the DeploymentScript resource to import images                             |
| `useExistingManagedIdentity`               | `bool`   | No       | Does the Managed Identity already exists, or should be created                                                |
| `managedIdentityName`                      | `string` | No       | Name of the Managed Identity resource                                                                         |
| `existingManagedIdentitySubId`             | `string` | No       | For an existing Managed Identity, the Subscription Id it is located in                                        |
| `existingManagedIdentityResourceGroupName` | `string` | No       | For an existing Managed Identity, the Resource Group it is located in                                         |
| `images`                                   | `array`  | Yes      | An array of fully qualified images names to import                                                            |
| `initialScriptDelay`                       | `string` | No       | A delay before the script import operation starts. Primarily to allow Azure AAD Role Assignments to propagate |
| `cleanupPreference`                        | `string` | No       | When the script resource is cleaned up                                                                        |

## Outputs

| Name             | Type    | Description                     |
| :--------------- | :-----: | :------------------------------ |
| `importedImages` | `array` | An array of the imported images |

## Examples

### Importing a single image

```bicep
param location string = resourceGroup().location
param acrName string =  'yourAzureContainerRegistry'

var imageName = 'mcr.microsoft.com/azuredocs/azure-vote-front:v1'

module acrImport 'br/public:deployment-scripts/import-acr:3.0.2' = {
  name: 'testAcrImportSingle'
  params: {
    acrName: acrName
    location: location
    images: array(imageName)
  }
}
```

### Importing multiple images

```bicep
param location string = resourceGroup().location
param acrName string =  'yourAzureContainerRegistry'

var imageNames = [
  'docker.io/bitnami/external-dns:latest'
  'quay.io/jetstack/cert-manager-cainjector:v1.7.2'
  'docker.io/bitnami/redis:latest'
]

module acrImport 'br/public:deployment-scripts/import-acr:3.0.2' = {
  name: 'testAcrImportMulti'
  params: {
    acrName: acrName
    location: location
    images: imageNames
  }
}
```

### Using an existing managed identity

```bicep
param location string = resourceGroup().location
param acrName string =  'yourAzureContainerRegistry'
param existingManagedIdName = 'yourExistingManagedIdentity'

module acrImport 'br/public:deployment-scripts/import-acr:3.0.2' = {
  name: 'testAcrImport'
  params: {
    useExistingManagedIdentity: true
    managedIdentityName: existingManagedIdName
    existingManagedIdentityResourceGroupName: resourceGroup().name
    existingManagedIdentitySubId: subscription().subscriptionId
    rbacRoleNeeded = '' //If the existing ManagedId already has RBAC, we can opt out of the RBAC assignment
    acrName: acr.name
    location: location
    images: array('mcr.microsoft.com/azuredocs/azure-vote-front:v1')
  }
}
```

### Using an longer script delay

```bicep
param location string = resourceGroup().location
param acrName string =  'yourAzureContainerRegistry'

module acrImport 'br/public:deployment-scripts/import-acr:3.0.2' = {
  name: 'testAcrImport'
  params: {
    initialScriptDelay: '60s'
    acrName: acr.name
    location: location
    images: array('mcr.microsoft.com/azuredocs/azure-vote-front:v1')
  }
}
```
