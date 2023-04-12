param name string = take(deployment().name, 55)
param location string = resourceGroup().location

param enableDockerContainer bool = true

param tags object = {
  LOB: 'ENT'
  contact: 'iep.dev@nuance.com'
  costcenter: '000'
  environment: 'dev'
  location: resourceGroup().location
  team: 'IEP'
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

@description('''
- This test setup the Azure Function without appInsights (Microsoft.Insights/components).
- enableaInsights default value is false and workspaceResourceId default value is empty so both params not required to pass.
- without any function

Dependency list:
- Microsoft.ManagedIdentity/userAssignedIdentities

''')

module test1 '../main.bicep' = {
  name: 'func1${uniqueString(name)}'
  dependsOn: [
    dependencies
  ]
  params: {
    name: 'fun1-${name}'
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
    enableDockerContainer: enableDockerContainer
    serverOS: 'Linux'

  }
  scope: resourceGroup()

}

// TODO: should add test case using sourcecontrol extension later
module test2 '../main.bicep' = {
  name: 'func2-${uniqueString(name)}'
  scope: resourceGroup()
  dependsOn: [
    dependencies
  ]
  params: {
    name: 'func2-${name}'
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
    subnetId: dependencies.outputs.subnets
    functionsExtensionVersion: '~4'
    functionsWorkerRuntime: 'powershell'
    storageAccountName: dependencies.outputs.saAccountName
    storgeAccountResourceGroup: resourceGroup().name
    enablePackageDeploy: true
  }
}
