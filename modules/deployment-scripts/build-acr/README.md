<h1 style="color: steelblue;">⚠️ Retired ⚠️</h1>

This module has been retired without a replacement module in Azure Verified Modules (AVM).

For more information, see the informational notice [here](https://github.com/Azure/bicep-registry-modules?tab=readme-ov-file#%EF%B8%8F-new-standard-for-bicep-modules---avm-%EF%B8%8F).

# ACR Image Build

Builds a container image inside ACR from source code

## Details

Azure Container Registry has the capability to build and store container images from source code repository.
This bicep module leverages DeploymentScript to orchestrate the image build.

## Parameters

| Name                                       | Type     | Required | Description                                                                                                                    |
| :----------------------------------------- | :------: | :------: | :----------------------------------------------------------------------------------------------------------------------------- |
| `AcrName`                                  | `string` | Yes      | The name of the Azure Container Registry                                                                                       |
| `location`                                 | `string` | No       | The location of the ACR and where to deploy the module resources to                                                            |
| `forceUpdateTag`                           | `string` | No       | How the deployment script should be forced to execute                                                                          |
| `rbacRoleNeeded`                           | `string` | No       | Azure RoleId that are required for the DeploymentScript resource to import images                                              |
| `useExistingManagedIdentity`               | `bool`   | No       | Does the Managed Identity already exists, or should be created                                                                 |
| `managedIdentityName`                      | `string` | No       | Name of the Managed Identity resource                                                                                          |
| `existingManagedIdentitySubId`             | `string` | No       | For an existing Managed Identity, the Subscription Id it is located in                                                         |
| `existingManagedIdentityResourceGroupName` | `string` | No       | For an existing Managed Identity, the Resource Group it is located in                                                          |
| `initialScriptDelay`                       | `string` | No       | A delay before the script import operation starts. Primarily to allow Azure AAD Role Assignments to propagate                  |
| `cleanupPreference`                        | `string` | No       | When the script resource is cleaned up                                                                                         |
| `gitRepositoryUrl`                         | `string` | Yes      | The Git Repository URL, eg. https://github.com/YOURORG/YOURREPO.git                                                            |
| `gitBranch`                                | `string` | No       | The name of the repository branch to use                                                                                       |
| `buildWorkingDirectory`                    | `string` | No       | The docker context working directory, change this when your Dockerfile and source files are ALL located in a repo subdirectory |
| `dockerfileDirectory`                      | `string` | No       | The subdirectory relative to the working directory that contains the Dockerfile                                                |
| `dockerfileName`                           | `string` | No       | The name of the dockerfile                                                                                                     |
| `imageName`                                | `string` | Yes      | The image name/path you want to create in ACR                                                                                  |
| `imageTag`                                 | `string` | No       | The image tag you want to create                                                                                               |
| `acrBuildPlatform`                         | `string` | No       | The ACR compute platform needed to build the image                                                                             |

## Outputs

| Name       | Type     | Description                                                         |
| :--------- | :------: | :------------------------------------------------------------------ |
| `acrImage` | `string` | The ACR uri the image can be accessed on if building was successful |

## Examples

### Building a linux container image

```bicep
param acrName string
param location string

module buildDaprImage 'br/public:deployment-scripts/build-acr:2.0.2' = {
  name: 'buildAcrImage-linux-dapr'
  params: {
    AcrName: acrName
    location: location
    gitRepositoryUrl:  'https://github.com/Azure-Samples/container-apps-store-api-microservice.git'
    buildWorkingDirectory:  'python-service'
    imageName: 'aca/dapr'
  }
}
```

### Building a Windows container image

```bicep
param acrName string
param location string

module buildWinAcrImage 'br/public:deployment-scripts/build-acr:2.0.2' = {
  name: 'buildAcrImage-win-eshop'
  params: {
    AcrName: acrName
    location: location
    gitRepositoryUrl:  'https://github.com/Azure-Samples/DotNet47WinContainerModernize.git'
    buildWorkingDirectory:  'eShopLegacyWebFormsSolution'
    imageName: 'dotnet/framework/aspnet'
    imageTag: '4.8-windowsservercore-ltsc2019'
    acrBuildPlatform: 'windows'
  }
}
```

### Building and creating a Dapr Container App

```bicep
param acrName string
param acaEnvName string
param location string

module buildDaprImage 'br/public:deployment-scripts/build-acr:2.0.2' = {
  name: 'buildAcrImage-linux-dapr'
  params: {
    AcrName: acrName
    location: location
    gitRepositoryUrl:  'https://github.com/Azure-Samples/container-apps-store-api-microservice.git'
    buildWorkingDirectory:  'python-service'
    imageName: 'aca/dapr'
  }
}

module aca 'br/public:app/dapr-containerapp:1.2.1' = {
  name: 'stateNodeApp'
  params: {
    location: location
    containerAppName: 'pyservice'
    containerAppEnvName: acaEnvName
    containerImage: buildDaprImage.outputs.acrImage
    azureContainerRegistry: acrName
  }
}
```
