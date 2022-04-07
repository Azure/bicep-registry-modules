# ACR Image Import

An Azure CLI Deployment Script that imports public container images to an Azure Container Registry

## Parameters

| Name                                       | Type     | Required | Description                                                                                                   |
| :----------------------------------------- | :------: | :------: | :------------------------------------------------------------------------------------------------------------ |
| `acrName`                                  | `string` | Yes      | The name of the Azure Container Registry                                                                      |
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
| `images`                                   | `array`  | Yes      | An array of fully qualified images names to import                                                            |
| `initialScriptDelay`                       | `string` | No       | A delay before the script import operation starts. Primarily to allow Azure AAD Role Assignments to propagate |
| `cleanupPreference`                        | `string` | No       | When the script resource is cleaned up                                                                        |

## Outputs

| Name | Type | Description |
| :--- | :--: | :---------- |

## Examples

### Importing a single image

```bicep
param location string = resourceGroup().location
param acrName string =  'yourAzureContainerRegistry'

var imageName = 'mcr.microsoft.com/azuredocs/azure-vote-front:v1'

module acrImport 'br/public:deployment-scripts/import-acr:1.0.1' = {
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

module acrImport 'br/public:deployment-scripts/import-acr:1.0.1' = {
  name: 'testAcrImportMulti'
  params: {
    acrName: acrName
    location: location
    images: imageNames
  }
}
```

### Setting a specific Azure CLI Version to use

```bicep
param location string = resourceGroup().location
param acrName string =  'yourAzureContainerRegistry'

module acrImport 'br/public:deployment-scripts/import-acr:1.0.1' = {
  name: 'testAcrImportAZV'
  params: {
    azCliVersion: '2.34.1'
    acrName: acrName
    location: location
    images: array('mcr.microsoft.com/azuredocs/azure-vote-front:v1')
  }
}
```

### Using an existing managed identity

```bicep
param location string = resourceGroup().location
param acrName string =  'yourAzureContainerRegistry'
param existingManagedIdName = 'yourExistingManagedIdentity'

module acrImport 'br/public:deployment-scripts/import-acr:1.0.1' = {
  name: 'testAcrImport'
  params: {
    useExistingManagedIdentity: true
    managedIdentityName: existingManagedIdName
    existingManagedIdentityResourceGroupName: resourceGroup().name
    existingManagedIdentitySubId: subscription().id
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

module acrImport 'br/public:deployment-scripts/import-acr:1.0.1' = {
  name: 'testAcrImport'
  params: {
    initialScriptDelay: '60s'
    acrName: acr.name
    location: location
    images: array('mcr.microsoft.com/azuredocs/azure-vote-front:v1')
  }
}
```