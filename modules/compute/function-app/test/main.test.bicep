param name string = deployment().name
param location string = resourceGroup().location

param tags object = {
  costcenter: '000'
  environment: 'dev'
  location: resourceGroup().location
}

module dependencies 'prereq.test.bicep' = {
  scope: resourceGroup()
  name: 'dependencies-${uniqueString(resourceGroup().id)}'
  params: {
    name: name
    location: location
    tags: tags
  }
}

module test1 '../main.bicep' = {
  name: 'func1${uniqueString(name)}'
  dependsOn: [
    dependencies
  ]
  params: {
    name: take(replace('fun1-${name}', '.', ''), 55)
    location: location
    sku: {
      name: 'Y1'
      tier: 'Dynamic'
      size: 'Y1'
      family: 'Y'
      capacity: 0
    }
    tags: tags
    storageAccountName: dependencies.outputs.saAccountName
    storgeAccountResourceGroup: resourceGroup().name
    enableSourceControl: false
    enableDockerContainer: true
    dockerImage: 'mcr.microsoft.com/azure-functions/dotnet:4-appservice-quickstart'
    serverOS: 'Linux'
  }
  scope: resourceGroup()
}

module test2 '../main.bicep' = {
  name: 'func2-${uniqueString(name)}'
  scope: resourceGroup()
  dependsOn: [
    dependencies
  ]
  params: {
    name: take(replace('fun2-${name}', '.', ''), 55)
    location: location
    sku: {
      name: 'EP1'
      tier: 'ElasticPremium'
      size: 'EP1'
      family: 'EP'
      capacity: 1
    }
    tags: tags
    maximumElasticWorkerCount: 20
    enableVnetIntegration: true
    enableInsights: true
    workspaceResourceId: dependencies.outputs.workspacesId
    subnetId: dependencies.outputs.subnetResourceIds
    functionsExtensionVersion: '~4'
    functionsWorkerRuntime: 'powershell'
    storageAccountName: dependencies.outputs.saAccountName
    storgeAccountResourceGroup: resourceGroup().name
    enableSourceControl: true
    repoUrl: 'https://github.com/Azure/KeyVault-Secrets-Rotation-Redis-PowerShell.git'
    enableDockerContainer: false
  }
}
