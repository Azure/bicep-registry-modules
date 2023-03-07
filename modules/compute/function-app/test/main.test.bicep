targetScope = 'subscription'

param name string = deployment().name

param location string = deployment().location

param tags object = {
  LOB: 'ENT'
  contact: 'iep.dev@nuance.com'
  costcenter: '000'
  environment: 'dev'
  location: deployment().location
  team: 'IEP'
}

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: name
  location: location
}

module dependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: 'dependencies-${uniqueString(resourceGroup.id)}'
  params: {
    name: name
    location: location
    tags: tags
  }
}

@description(''' 
- This test setup the Azure Function with appInsights (Microsoft.Insights/components).
- Make sure enableaInsights: true.
- with functions of array

Dependency list: 
- Microsoft.ManagedIdentity/userAssignedIdentities
- Microsoft.OperationalInsights/workspaces

''')
module test '../main.bicep' = {
  name: 'test-azure-func-${guid(name)}'
  dependsOn: [
    dependencies
  ]
  params: {
    name: 'test1-${name}'
    location: location
    sku: {
      name: 'Y1'
      tier: 'Dynamic'
      size: 'Y1'
      family: 'Y'
      capacity: 0
    }
    tags: tags
    identityType: 'UserAssigned'
    userAssignedIdentityId: dependencies.outputs.userAssignedIdentitiesId
    workspaceResourceId: dependencies.outputs.workspacesId
    enableInsights: true
    functions: [
      {
        name: 'function2'
        config: {
          bindings: [
            {
              name: 'myTimer'
              type: 'timerTrigger'
              direction: 'in'
              schedule: '0 */1 * * * *'
            }
            {
              name: 'outputBlob2'
              direction: 'out'
              type: 'blob'
              path: 'outcontainer/{rand-guid}'
              connection: 'AzureWebJobsStorage'
            }
          ]
        }
        enabled: true
        files: {
          'index.js': loadTextContent('functions_source_code/test_1_index.js', 'utf-8')
        }
        language: 'node'
      }
    ]
    functionsWorkerRuntime: 'node'
    storgeAccountName: dependencies.outputs.saAccountName
    storgeAccountResourceGroup: dependencies.outputs.saResourceGroupName
  }
  scope: resourceGroup
}

@description(''' 
- This test setup the Azure Function without appInsights (Microsoft.Insights/components).
- enableaInsights default value is false and workspaceResourceId default value is empty so both params not required to pass.
- without any function

Dependency list: 
- Microsoft.ManagedIdentity/userAssignedIdentities

''')

module test2 '../module.bicep' = {
  name: 'test-azure-func2-${guid(name)}'
  dependsOn: [
    dependencies
  ]
  params: {
    name: 'test2-${name}'
    location: location
    sku: {
      name: 'Y1'
      tier: 'Dynamic'
      size: 'Y1'
      family: 'Y'
      capacity: 0
    }
    tags: tags
    storgeAccountName: dependencies.outputs.saAccountName
    storgeAccountResourceGroup: dependencies.outputs.saResourceGroupName
  }
  scope: resourceGroup

}

// TODO: should add test case using sourcecontrol extension later
module test3 '../module.bicep' = {
  name: 'test-azure-func3-${guid(name)}'
  scope: resourceGroup
  dependsOn: [
    dependencies
  ]
  params: {
    name: 'test3-${name}'
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
    subnetId: dependencies.outputs.subnets[0].id
    functionsExtensionVersion: '~4'
    functionsWorkerRuntime: 'powershell'
    storgeAccountName: dependencies.outputs.saAccountName
    storgeAccountResourceGroup: dependencies.outputs.saResourceGroupName
    enablePackageDeploy: true
    functionPackageUri: dependencies.outputs.zipFileUri
  }
}
