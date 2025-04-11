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
module avmInsightsComponent 'br/public:avm/res/insights/component:0.6.0' = {
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

// ==========Backend Container App Service ========== //
module containerApp 'br/public:avm/res/app/container-app:0.15.0' = {
  name: 'avm.ptn.sa.macae.container-app'
  params: {
    tags: tags
    // Required parameters
    containers: [
      {
        //TODO: Make image parameterized for the registry name and the appversion
        image: 'biabcontainerreg.azurecr.io/macaebackend:latest'
        name: 'backend'
        //TODO: Figure out if rules are needed
        // rules: [
        //   {
        //     name: 'http-scaler'
        //     http: {
        //       concurrentRequests: '100'
        //     }
        //   }
        // ]
        resources: {
          //TODO: Make cpu and memory parameterized
          cpu: '2.0'
          memory: '4.0Gi'
        }
        env: [
          {
            name: 'COSMOSDB_ENDPOINT'
            value: avmCosmosDB.outputs.endpoint
          }
          {
            name: 'COSMOSDB_DATABASE'
            value: 'cosmos::autogenDb.name'
          }
          {
            name: 'COSMOSDB_CONTAINER'
            value: 'cosmos::autogenDb::memoryContainer.name'
          }
          {
            name: 'AZURE_OPENAI_ENDPOINT'
            value: avmCognitiveServicesAccounts.outputs.endpoint
          }
          {
            name: 'AZURE_OPENAI_DEPLOYMENT_NAME'
            value: avmCognitiveServicesAccounts.outputs.name
          }
          {
            name: 'AZURE_OPENAI_API_VERSION'
            value: '2024-08-06'
          }
          {
            name: 'FRONTEND_SITE_NAME'
            //TODO: Add frontend site name
            value: 'TODO: ADD NAME'
          }
          {
            name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
            value: avmInsightsComponent.outputs.connectionString
          }
        ]
      }
    ]
    ingressTargetPort: 8000
    ingressExternal: true
    activeRevisionsMode: 'Single'
    corsPolicy: {
      allowedOrigins: [
        //TODO: ADD FRONTEND URL http and https 'https://${format(uniqueNameFormat, 'frontend')}.azurewebsites.net'
        'https://frontend.azurewebsites.net'
        'http://frontend.azurewebsites.net'
      ]
    }
    environmentResourceId: '<environmentResourceId>'
    name: 'acamin001'
    scaleSettings: {
      //TODO: Make maxReplicas and minReplicas parameterized
      maxReplicas: 1
      minReplicas: 1
    }
  }
}

// ========== Frontend server farm ========== //
module serverfarm 'br/public:avm/res/web/serverfarm:0.4.1' = {
  name: 'avm.ptn.sa.macae.frontend-server-farm'
  params: {
    tags: tags
    location: solutionLocation
    name: 'wsfmin001'
    skuName: 'P1v2'
    skuCapacity: 1
    reserved: true
    kind: 'linux'
  }
}

// ==========Frontend Container App Service ========== //
module frontendAppService 'br/public:avm/res/web/site:0.15.1' = {
  name: 'avm.ptn.sa.macae.frontend-web-app'
  params: {
    tags: tags
    // Required parameters
    kind: 'app,linux,container'
    name: 'frontend'
    //TODO: Add server farm resource id
    serverFarmResourceId: '<serverFarmResourceId>'
    siteConfig: {
      reserved: true
      lunixFxVersion: 'DOCKER|biabcontainerreg.azurecr.io/macaefrontend:latest'
      appSettings: [
        {
          name: 'DOCKER_REGISTRY_SERVER_URL'
          //TODO: Add docker registry url
          value: 'dockerRegistryUrl'
        }
        {
          name: 'WEBSITES_PORT'
          value: '3000'
        }
        {
          name: 'WEBSITES_CONTAINER_START_TIME_LIMIT' // Add startup time limit
          value: '1800' // 30 minutes, adjust as needed
        }
        {
          name: 'BACKEND_API_URL'
          value: 'https://${containerApp.outputs.fqdn}'
        }
      ]
    }
    managedIdentities: {
      userAssignedResourceIds: [
        userAssignedIdentity.outputs.resourceId
      ]
    }
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
module avmCognitiveServicesAccounts 'br/public:avm/res/cognitive-services/account:0.10.2' = {
  name: 'avm.ptn.sa.macae.cognitive-services-account'
  params: {
    name: '${solutionPrefix}aisv'
    tags: tags
    location: solutionLocation
    enableTelemetry: enableTelemetry
    diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }]
    sku: 'S0'
    kind: 'AIServices'
    disableLocalAuth: true
    customSubDomainName: '${solutionPrefix}aisv'
    apiProperties: {
      staticsEnabled: false
    }
    publicNetworkAccess: 'Enabled' //TODO: block and connect to vnet
    roleAssignments: [
      {
        principalId: userAssignedIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Cognitive Services OpenAI User'
      }
    ]
    deployments: [
      {
        name: 'gpt-4o'
        model: {
          format: 'OpenAI'
          name: 'gpt-4o'
          version: '2024-08-06'
        }
        sku: {
          name: 'GlobalStandard'
          capacity: 50
        }
      }
    ]
  }
}

// ========== Cosmos DB ========== //
module avmCosmosDB 'br/public:avm/res/document-db/database-account:0.12.0' = {
  name: 'avm.ptn.sa.macae.cosmos-db'
  params: {
    // Required parameters
    name: 'analytical'
    databaseAccountOfferType: 'Standard'
    enableFreeTier: false
    locations: [
      {
        locationName: solutionLocation
        failoverPriority: 0
      }
    ]
    capabilitiesToAdd: [
      'EnableServerless'
    ]
    lock: {
      //TODO: Unsure is this is the same as the "kind" property in the original template
      name: 'GlobalDocumentDB'
    }
  }
}

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
