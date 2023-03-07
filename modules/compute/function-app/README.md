# 

## Description

This is a low-level Bicep module for managing Azure Functions, it supports an array of function, also the user has the option to either choose use user assigned identity or system assigned identity and also support the storage account to be in different resource group.

## Parameters

| Name | Type | Required | Description |
| :--- | :--: | :------: | :---------- |
| name | string | Yes | Name for the Azure Function App. |
| location | string |  Yes | Location for all resources. |
| tags |  object | No | Tags for all resources within Azure Function App module. |
| serverOS | string | No | Kind of server OS, eith Windows or Linux |
| perSiteScaling | bool | No | If true, apps assigned to this app service plan can be scaled independently.  If false, apps assigned to this app service plan will scale to all instances of the plan.') |
| maximumElasticWorkerCount | int |  No | Maximum number of total workers allowed for this ElasticScaleEnabled app service plan. |
| targetWorkerCount | int | No |  Scaling worker count. |
| targetWorkerSizeId | int | No | The instance size of the hosting plan (small, medium, or large). |
| identityType | string | No | The type of identity used for the virtual machine. The type \'SystemAssigned, UserAssigned\' includes both an implicitly created identity and a set of user assigned identities. The type \'None\' will remove any identities from the sites ( app or functionapp). |
| userAssignedIdentityId | string | No |  Specify the resource ID of the user assigned Managed Identity, if \'identity\' is set as \'UserAssigned\'. |
| httpsOnly | bool | No | Configures a site to accept only HTTPS requests. Issues redirect for HTTP requests. |
| appServiceEnvironmentId | string | No | The resource ID of the app service environment to use for this resource. |
| clientAffinityEnabled | bool | No | If client affinity is enabled. |
| kind | string | Yes | Type of site to deploy, either functionapp or app |
| functionsExtensionVersion | string | No |  Version of the function extension. |
| functionsWorkerRuntime | string | No | Runtime of the function worker. |
| functionsDefaultNodeversion | string | No | NodeJS version. |
| publicNetworkAccessForIngestion |string | No | The network access type for accessing Application Insights ingestion. - Enabled or Disabled.|
| publicNetworkAccessForQuery | string |  No | The network access type for accessing Application Insights query. - Enabled or Disabled. |
| appInsightsType | string |  No | Application type, either web or other |
| appInsightsKind | string | No | The kind of application that this component refers to, used to customize UI. |
| enableInsights | bool | No | Enabled or Disable Insights for Azure functions |
| workspaceResourceId | string  | No | Resource ID of the log analytics workspace which the data will be ingested to, if enableaInsights is false. |
| functions | array | No | List of Azure function (Actual object where our code resides). |
| enableVnetIntegration | bool | No | Enable Vnet Integration or not. |
| subnetId | string | string | No | The subnet that will be integrated to enable vnet Integration. |
| enableSourceControl | bool | No | Enable Source control for the function. |
| repoUrl | string | No |  Repository or source control URL. |
| branch | string | No  | Name of branch to use for deployment. |
| isManualIntegration | bool | No | To limit to manual integration; to enable continuous integration (which configures webhooks into online repos like GitHub). |
| isMercurial | boot | No | true for a Mercurial repository; false for a Git repository. |
| storgeAccountName | string | Yes |  Name of the storage account used by function app. |
| storgeAccountResourceGroup | string | Yes | Resource Group of storage account used by function app. |
| enablePackageDeploy | bool | No |  True to deploy functions from zip package. "functionPackageUri" must be specified if enabled. The package option and sourcecontrol option should not be enabled at the same time. |
| functionPackageUri | string | No | URI to the function source code zip package, must be accessible by the deployer. E.g. A zip file on Azure storage in the same resource group. |

















## Outputs

| Name | Type | Description |
| :--- | :--: | :---------- |
| siteId | string | Get resource id for app or functionapp. |
| siteName | string | Get resource name for app or functionapp. |
| serverfarmsId | string | Get resource ID of the app service plan. |
| serverfarmsName | string | Get name of the app service plan. |
| functions | array | Array of functions having name , language,isDisabled and id of functions. |
| sitePrincipalId | string | Principal Id of the identity assigned to the function app. |



## Examples

### Example 1

```bicep
targetScope = 'subscription'

param name string = deployment().name

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: name
  location: deployment().location
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
    location: deployment().location
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
    storgeAccountName: dependencies.outputs.saAccountName
    storgeAccountResourceGroup: dependencies.outputs.saResourceGroupName
    enableInsights: true
    functions: [
      {
        name: 'function1'
        config: {
          bindings: [
            {
              name: 'myTimer'
              type: 'timerTrigger'
              direction: 'in'
              schedule: '0 */1 * * * *'
            }
            {
              name: 'outputBlob1'
              direction: 'out'
              type: 'blob'
              path: 'outcontainer/{rand-guid}'
              connection: 'AzureWebJobsStorage'
            }
          ]
        }
        enabled: true
        files: {
          'index.js': 'module.exports = async function (context, myTimer) {\r\n    var timeStamp = new Date().toISOString();\r\n    \r\n    if (myTimer.IsPastDue)\r\n    {\r\n        context.log(\'JavaScript is running late!\');\r\n    }\r\n    context.bindings.outputBlob1 = \'hello func1\';\r\n    context.log(\'written hello to blob func2\',timeStamp);\r\n    context.log(\'JavaScript timer trigger function ran!\', timeStamp);   \r\n};'
        }
        language: 'node'
      }
      //note: 2nd function within same function app
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
          'index.js': 'module.exports = async function (context, myTimer) {\r\n    var timeStamp = new Date().toISOString();\r\n    \r\n    if (myTimer.IsPastDue)\r\n    {\r\n        context.log(\'JavaScript is running late!\');\r\n    }\r\n    context.bindings.outputBlob2 = \'hello func2\';\r\n    context.log(\'written hello to blob func2\',timeStamp);\r\n    context.log(\'JavaScript timer trigger function ran!\', timeStamp);   \r\n};'
        }
        language: 'node'
      }
    ]
  }
}
```

### Example 2

```@description('''
Below test shows how to enable vnet integration and include functions from a source such as github.
''')

module test3 '../main.bicep' = {
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
    functionsExtensionVersion: '~3'
    functionsWorkerRuntime: 'powershell'
    enableSourceControl: true
    repoUrl: 'https://github.com/Azure/KeyVault-Secrets-Rotation-Redis-PowerShell.git'
    branch: 'main'
    storgeAccountName: dependencies.outputs.saAccountName
    storgeAccountResourceGroup: dependencies.outputs.saResourceGroupName
  }
}


/*output section*/
@description('Get resource id for app or functionapp.')
output siteId string = sites.id

@description('Get resource name for app or functionapp.')
output siteName string = sites.name

@description('Get resource ID of the app service plan.')
output serverfarmsId string = serverfarms.id

@description('Get name of the app service plan.')
output serverfarmsName string = serverfarms.name

@description('Array of functions having name , language,isDisabled and id of functions.')
output subnets array = [for function in functions: {
  name: function.name
  language: function.language
  isDisabled: function.isDisabled
  id: '${sites.id}/functions/${function.name}'
  files: function.files
}]
```
