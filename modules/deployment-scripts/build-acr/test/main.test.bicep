param location string = resourceGroup().location
param AcrName string = 'cr${uniqueString(resourceGroup().id)}'

// Pre-reqs
resource acr 'Microsoft.ContainerRegistry/registries@2021-12-01-preview' = {
  name: AcrName
  location: location
  sku: {
    name: 'Basic'
  }
}

// Windows test

module buildWinAcrImage '../main.bicep' = {
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

// Linux image test

module buildDaprImage '../main.bicep' = {
  name: 'buildAcrImage-linux-dapr'
  params: {
    AcrName: acr.name
    location: location
    gitRepositoryUrl:  'https://github.com/Azure-Samples/container-apps-store-api-microservice.git'
    gitRepoDirectory:  'python-service'
    imageName: 'aca/dapr'
  }
}

// Output test, lets stand up a Container App!
module myenv 'br/public:app/dapr-containerapps-environment:1.2.1' = {
  name: 'state'
  params: {
    location: location
    nameseed: 'stateSt1'
    applicationEntityName: 'appdata'
    daprComponentType: 'state.azure.blobstorage'
  }
}

module aca 'br/public:app/dapr-containerapp:1.0.2' = {
  name: 'stateNodeApp'
  params: {
    location: location
    containerAppName: 'pyservice'
    containerAppEnvName: myenv.outputs.containerAppEnvironmentName
    containerImage: buildDaprImage.outputs.acrImage
    azureContainerRegistry: acr.name
  }
}
