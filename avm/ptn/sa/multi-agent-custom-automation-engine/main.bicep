metadata name = '<Add module name>'
metadata description = '<Add description>'

@description('Required. Name of the resource to create.')
param solutionPrefix string

@description('Optional. Location for all Resources.')
param solutionLocation string = resourceGroup().location

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. The tags to apply to all deployed Azure resources.')
param tags object = {
  app: solutionPrefix
  location: solutionLocation
}

//
// Add your parameters here
//

// ============== //
// Resources      //
// ============== //

/* #disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.[[REPLACE WITH TELEMETRY IDENTIFIER]].${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
} */

// ========== Log Analytics Workspace ========== //
module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.11.1' = {
  name: 'avm.ptn.sa.macae.operational-insights-workspace'
  params: {
    name: '${solutionPrefix}laws'
    tags: tags
    location: solutionLocation
    enableTelemetry: enableTelemetry
    skuName: 'PerGB2018'
    dataRetention: 30
  }
}

// ========== Application Insights ========== //
module applicationInsights 'br/public:avm/res/insights/component:0.6.0' = {
  name: 'avm.ptn.sa.macae.insights-component'
  params: {
    name: '${solutionPrefix}appi'
    workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
    tags: tags
    location: solutionLocation
    enableTelemetry: enableTelemetry
    diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }]
    kind: 'web'
    disableIpMasking: false
    flowType: 'Bluefield'
    requestSource: 'rest'
  }
}

// ========== User assigned identity ========== //
module userAssignedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.1' = {
  name: 'avm.ptn.sa.macae.managed-identity-assigned-identity'
  params: {
    name: '${solutionPrefix}uaid'
    tags: tags
    location: solutionLocation
    enableTelemetry: enableTelemetry
  }
}

// AI Foundry: AI Services
// NOTE: Required version 'Microsoft.CognitiveServices/accounts@2024-04-01-preview' not available in AVM
var aiServicesDeploymentGptName = 'gpt-4o'
var aiServicesDeploymentGptVersion = '2024-08-06'
module aiServices 'br/public:avm/res/cognitive-services/account:0.10.2' = {
  name: 'avm.ptn.sa.macae.cognitive-services-account'
  params: {
    name: '${solutionPrefix}aisv'
    tags: tags
    location: solutionLocation
    enableTelemetry: enableTelemetry
    diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }]
    sku: 'S0'
    kind: 'OpenAI'
    disableLocalAuth: true
    customSubDomainName: '${solutionPrefix}aisv'
    apiProperties: {
      staticsEnabled: false
    }
    publicNetworkAccess: 'Enabled' //TODO: block and connect to vnet
    managedIdentities: {
      systemAssigned: true
    }
    roleAssignments: [
      {
        principalId: userAssignedIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Cognitive Services OpenAI User'
      }
    ]
    deployments: [
      {
        name: aiServicesDeploymentGptName
        model: {
          format: 'OpenAI'
          name: aiServicesDeploymentGptName
          version: aiServicesDeploymentGptVersion
        }
        sku: {
          name: 'GlobalStandard'
          capacity: 10
        }
      }
    ]
  }
}

var cosmosDbDatabaseName = 'autogen'
var cosmosDbDatabaseMemoryContainerName = 'autogen'
// ========== Cosmos DB ========== //
module cosmosDb 'br/public:avm/res/document-db/database-account:0.12.0' = {
  name: 'avm.ptn.sa.macae.cosmos-db'
  params: {
    // Required parameters
    name: '${solutionPrefix}csdb'
    tags: tags
    location: solutionLocation
    enableTelemetry: enableTelemetry
    diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }]
    databaseAccountOfferType: 'Standard'
    enableFreeTier: false
    networkRestrictions: {
      publicNetworkAccess: 'Enabled'
    }
    sqlDatabases: [
      {
        name: cosmosDbDatabaseName
        containers: [
          {
            name: cosmosDbDatabaseMemoryContainerName
            paths: [
              '/session_id'
            ]
            kind: 'Hash'
            version: 2
          }
        ]
      }
    ]
    locations: [
      {
        locationName: solutionLocation
        failoverPriority: 0
      }
    ]
    capabilitiesToAdd: [
      'EnableServerless'
    ]
    roleAssignments: [
      {
        principalId: userAssignedIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Contributor'
      }
    ]
  }
}

// ==========Backend Container App Environment ========== //
module containerAppEnvironment 'br/public:avm/res/app/managed-environment:0.10.2' = {
  name: 'avm.ptn.sa.macae.container-app-environment'
  params: {
    name: '${solutionPrefix}cenv'
    tags: tags
    location: solutionLocation
    enableTelemetry: enableTelemetry
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
    appInsightsConnectionString: applicationInsights.outputs.connectionString
    publicNetworkAccess: 'Enabled' //TODO: block and connect to vnet
    zoneRedundant: false //TODO: make it zone redundant for waf aligned
  }
}
resource aspireDashboard 'Microsoft.App/managedEnvironments/dotNetComponents@2024-10-02-preview' = {
  name: '${solutionPrefix}cenv/aspire-dashboard'
  properties: {
    componentType: 'AspireDashboard'
  }
  dependsOn: [containerAppEnvironment]
}
var test = containerApp.outputs.systemAssignedMIPrincipalId
// ==========Backend Container App Service ========== //
module containerApp 'br/public:avm/res/app/container-app:0.14.2' = {
  name: 'avm.ptn.sa.macae.container-app'
  params: {
    name: '${solutionPrefix}capp'
    tags: tags
    location: solutionLocation
    enableTelemetry: enableTelemetry
    environmentResourceId: containerAppEnvironment.outputs.resourceId
    managedIdentities: { systemAssigned: true, userAssignedResourceIds: [userAssignedIdentity.outputs.resourceId] }
    ingressTargetPort: 8000
    ingressExternal: true
    activeRevisionsMode: 'Single'
    corsPolicy: {
      allowedOrigins: [
        'https://${webSiteName}.azurewebsites.net'
        'http://${webSiteName}.azurewebsites.net'
      ]
    }
    scaleSettings: {
      //TODO: Make maxReplicas and minReplicas parameterized
      maxReplicas: 1
      minReplicas: 1
      rules: [
        {
          name: 'http-scaler'
          http: {
            metadata: {
              concurrentRequests: '100'
            }
          }
        }
      ]
    }
    containers: [
      {
        name: 'backend'
        //TODO: Make image parameterized for the registry name and the appversion
        image: 'biabcontainerreg.azurecr.io/macaebackend:latest'
        resources: {
          //TODO: Make cpu and memory parameterized
          cpu: '2.0'
          memory: '4.0Gi'
        }
        env: [
          {
            name: 'COSMOSDB_ENDPOINT'
            value: cosmosDb.outputs.endpoint
          }
          {
            name: 'COSMOSDB_DATABASE'
            value: cosmosDbDatabaseName
          }
          {
            name: 'COSMOSDB_CONTAINER'
            value: cosmosDbDatabaseMemoryContainerName
          }
          {
            name: 'AZURE_OPENAI_ENDPOINT'
            value: aiServices.outputs.endpoint
          }
          {
            name: 'AZURE_OPENAI_DEPLOYMENT_NAME'
            value: aiServicesDeploymentGptName
          }
          {
            name: 'AZURE_OPENAI_API_VERSION'
            value: '2024-08-01-preview'
          }
          {
            name: 'FRONTEND_SITE_NAME'
            value: 'https://${webSiteName}.azurewebsites.net'
          }
          {
            name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
            value: applicationInsights.outputs.connectionString
          }
        ]
      }
    ]
  }
}

// ========== Frontend server farm ========== //
module webServerfarm 'br/public:avm/res/web/serverfarm:0.4.1' = {
  name: 'avm.ptn.sa.macae.web-server-farm'
  params: {
    tags: tags
    location: solutionLocation
    name: '${solutionPrefix}sfrm'
    skuName: 'P1v2'
    skuCapacity: 1
    reserved: true
    kind: 'linux'
    zoneRedundant: false //TODO: make it zone redundant for waf aligned
  }
}
// ========== Frontend web site ========== //
var webSiteName = '${solutionPrefix}wapp'
module webSite 'br/public:avm/res/web/site:0.15.1' = {
  name: 'avm.ptn.sa.macae.web-site'
  params: {
    tags: tags
    kind: 'app,linux,container'
    name: webSiteName
    location: solutionLocation
    serverFarmResourceId: webServerfarm.outputs.resourceId
    managedIdentities: { userAssignedResourceIds: [userAssignedIdentity.outputs.resourceId] }
    appInsightResourceId: applicationInsights.outputs.resourceId
    siteConfig: {
      linuxFxVersion: 'DOCKER|biabcontainerreg.azurecr.io/macaefrontend:latest'
    }
    appSettingsKeyValuePairs: {
      SCM_DO_BUILD_DURING_DEPLOYMENT: 'true'
      DOCKER_REGISTRY_SERVER_URL: 'https://biabcontainerreg.azurecr.io'
      WEBSITES_PORT: '3000'
      WEBSITES_CONTAINER_START_TIME_LIMIT: '1800' // 30 minutes, adjust as needed
      BACKEND_API_URL: 'https://${containerApp.outputs.fqdn}'
    }
  }
}

resource aoaiUserRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-05-01-preview' existing = {
  name: '5e0bd9bd-7b93-4f28-af87-19fc36ad61bd' //'Cognitive Services OpenAI User'
}

resource assignAoaRole 'Microsoft.Resources/deployments@2021-04-01' = {
  name: 'assignAoaRole'
  dependsOn: [
    containerApp
    aiServices
  ]
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: [
        {
          type: 'Microsoft.Authorization/roleAssignments'
          apiVersion: '2022-04-01'
          name: guid(
            '${containerApp.outputs.resourceId}',
            '${aiServices.outputs.resourceId}',
            '${aoaiUserRoleDefinition.id}'
          )
          properties: {
            principalId: '${containerApp.outputs.systemAssignedMIPrincipalId}'
            roleDefinitionId: '${aoaiUserRoleDefinition.id}'
            principalType: 'ServicePrincipal'
          }
        }
      ]
    }
  }
}
// ========== Cosmos DB Role Assignment ========== //
resource contributorRoleDefinition 'Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions@2021-06-15' existing = {
  name: '${cosmosDb.outputs.name}/00000000-0000-0000-0000-000000000002'
}
var cosmosAssignCli = 'az cosmosdb sql role assignment create --resource-group "${resourceGroup().name}" --account-name "${cosmosDb.outputs.name}" --role-definition-id "${contributorRoleDefinition.id}" --scope "${cosmosDb.outputs.resourceId}" --principal-id "${containerApp.outputs.systemAssignedMIPrincipalId}"'

module deploymentScriptCLI 'br/public:avm/res/resources/deployment-script:0.5.1' = {
  name: 'deploymentScriptCLI'
  params: {
    kind: 'AzureCLI'
    name: 'assignCosmosDbRole'
    location: resourceGroup().location
    azCliVersion: '2.69.0'
    scriptContent: cosmosAssignCli
    managedIdentities: {
      userAssignedResourceIds: [
        userAssignedIdentity.outputs.resourceId
      ]
    }
  }
  dependsOn: [
    containerApp
    cosmosDb
  ]
}

output cosmosAssignCli string = cosmosAssignCli
// ============ //
// Outputs      //
// ============ //

// Add your outputs here

// @description('The resource ID of the resource.')
// output resourceId string = <Resource>.id

// @description('The name of the resource.')
// output name string = <Resource>.name

// @description('The location the resource was deployed into.')
// output location string = <Resource>.location

// ================ //
// Definitions      //
// ================ //
//
// Add your User-defined-types here, if any
//
