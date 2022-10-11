# ACR Image Build

Builds an container image inside ACR

## Description

Azure Container Registry has the capability to build and store container images from source code repository.
This bicep module leverages DeploymentScript to orchestrate the image build.

## Parameters

| Name                                       | Type     | Required | Description                                                                                                   |
| :----------------------------------------- | :------: | :------: | :------------------------------------------------------------------------------------------------------------ |
| `AcrName`                                  | `string` | Yes      | The name of the Azure Container Registry                                                                      |
| `location`                                 | `string` | No       | The location to deploy the resources to                                                                       |
| `forceUpdateTag`                           | `string` | No       | How the deployment script should be forced to execute                                                         |
| `rbacRoleNeeded`                           | `string` | No       | Azure RoleId that are required for the DeploymentScript resource to import images                             |
| `useExistingManagedIdentity`               | `bool`   | No       | Does the Managed Identity already exists, or should be created                                                |
| `managedIdentityName`                      | `string` | No       | Name of the Managed Identity resource                                                                         |
| `existingManagedIdentitySubId`             | `string` | No       | For an existing Managed Identity, the Subscription Id it is located in                                        |
| `existingManagedIdentityResourceGroupName` | `string` | No       | For an existing Managed Identity, the Resource Group it is located in                                         |
| `initialScriptDelay`                       | `string` | No       | A delay before the script import operation starts. Primarily to allow Azure AAD Role Assignments to propagate |
| `cleanupPreference`                        | `string` | No       | When the script resource is cleaned up                                                                        |
| `gitRepositoryUrl`                         | `string` | Yes      | The Git Repository URL, eg. https://github.com/YOURORG/YOURREPO.git                                           |
| `gitBranch`                                | `string` | No       | The name of the repository branch to use                                                                      |
| `gitRepoDirectory`                         | `string` | No       | The directory in the repo that contains the dockerfile                                                        |
| `imageName`                                | `string` | Yes      | The image name/path you want to create in ACR                                                                 |
| `imageTag`                                 | `string` | No       | The image tag you want to create                                                                              |
| `acrBuildPlatform`                         | `string` | No       | The ACR compute platform needed to build the image                                                            |

## Outputs

| Name     | Type   | Description                                                         |
| :------- | :----: | :------------------------------------------------------------------ |
| acrImage | string | The ACR uri the image can be accessed on if building was successful |

## Examples

### Building a linux container image

```bicep
module buildDaprImage 'br/public:deployment-scripts/build-acr:1.0.1' = {
  name: 'buildAcrImage-linux-dapr'
  params: {
    AcrName: acr.name
    location: location
    gitRepositoryUrl:  'https://github.com/Azure-Samples/container-apps-store-api-microservice.git'
    gitRepoDirectory:  'python-service'
    imageName: 'aca/dapr'
  }
}
```

### Building a Windows container image

```bicep
module buildWinAcrImage 'br/public:deployment-scripts/build-acr:1.0.1' = {
  name: 'buildAcrImage-win-eshop'
  params: {
    AcrName: acr.name
    location: location
    gitRepositoryUrl:  'https://github.com/Azure-Samples/DotNet47WinContainerModernize.git'
    gitRepoDirectory:  'eShopLegacyWebFormsSolution'
    imageName: 'dotnet/framework/aspnet'
    imageTag: '4.8-windowsservercore-ltsc2019'
    acrBuildPlatform: 'windows'
  }
}
```