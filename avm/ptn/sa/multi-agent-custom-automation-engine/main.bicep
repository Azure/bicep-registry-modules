extension graphV1
//extension graphBeta

metadata name = '<Add module name>'
metadata description = '<Add description>'

@description('Required. Name of the resource to create.')
param solutionPrefix string

@description('Optional. Location for all Resources.')
param solutionLocation string = resourceGroup().location

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. The UTC time deployment.')
param deploymentTime string = utcNow()

@description('Optional. The tags to apply to all deployed Azure resources.')
param tags object = {
  app: solutionPrefix
  location: solutionLocation
}

@description('Optional. The configuration of the Entra ID Application used to authenticate the website.')
param entraIdApplicationConfiguration macaeEntraIdApplicationFarmType = {
  enabled: false
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
//TODO: Implement the user assigned identity
// module userAssignedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.1' = {
//   name: 'avm.ptn.sa.macae.managed-identity-assigned-identity'
//   params: {
//     name: '${solutionPrefix}uaid'
//     tags: tags
//     location: solutionLocation
//     enableTelemetry: enableTelemetry
//   }
// }

// AI Foundry: AI Services
// NOTE: Required version 'Microsoft.CognitiveServices/accounts@2024-04-01-preview' not available in AVM
var aiServicesAccountName = '${solutionPrefix}aisv'
var aiServicesDeploymentGptName = 'gpt-4o'
var aiServicesDeploymentGptVersion = '2024-08-06'
module aiServices 'br/public:avm/res/cognitive-services/account:0.10.2' = {
  name: 'avm.ptn.sa.macae.cognitive-services-account'
  params: {
    name: aiServicesAccountName
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
    // Check if this is needed
    // managedIdentities: {
    //   systemAssigned: true
    // }
    roleAssignments: [
      {
        principalId: containerApp.outputs.systemAssignedMIPrincipalId!
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
          capacity: 50
        }
      }
    ]
  }
}

// ========== Cosmos DB ========== ///
var cosmosDbName = '${solutionPrefix}csdb'
var cosmosDbDatabaseName = 'autogen'
var cosmosDbDatabaseMemoryContainerName = 'autogen'
module cosmosDb 'br/public:avm/res/document-db/database-account:0.12.0' = {
  name: 'avm.ptn.sa.macae.cosmos-db'
  params: {
    // Required parameters
    name: cosmosDbName
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
    sqlRoleAssignmentsPrincipalIds: [
      //userAssignedIdentity.outputs.principalId
      containerApp.outputs.?systemAssignedMIPrincipalId
    ]
    sqlRoleDefinitions: [
      {
        // Replace this with built-in role definition Cosmos DB Built-in Data Contributor: https://docs.azure.cn/en-us/cosmos-db/nosql/security/reference-data-plane-roles#cosmos-db-built-in-data-contributor
        roleType: 'CustomRole'
        roleName: 'Cosmos DB SQL Data Contributor'
        name: 'cosmos-db-sql-data-contributor'
        dataAction: [
          'Microsoft.DocumentDB/databaseAccounts/readMetadata'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/*'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/*'
        ]
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

// ==========Backend Container App Service ========== //
module containerApp 'br/public:avm/res/app/container-app:0.14.2' = {
  name: 'avm.ptn.sa.macae.container-app'
  params: {
    name: '${solutionPrefix}capp'
    tags: tags
    location: solutionLocation
    enableTelemetry: enableTelemetry
    environmentResourceId: containerAppEnvironment.outputs.resourceId
    managedIdentities: {
      systemAssigned: true //TODO: remove this, work with user assigned identity
      //userAssignedResourceIds: [userAssignedIdentity.outputs.resourceId]
    }
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
            value: 'https://${cosmosDbName}.documents.azure.com:443/'
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
            value: 'https://${aiServicesAccountName}.openai.azure.com/'
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

// ========== Entra ID Application ========== //
resource entraIdApplication 'Microsoft.Graph/applications@v1.0' = if (entraIdApplicationConfiguration.?enabled!) {
  displayName: '${webSiteName}-app'
  uniqueName: '${webSiteName}-app-${uniqueString(resourceGroup().id, webSiteName)}'
  description: 'EntraId Application for ${webSiteName} authentication'
  passwordCredentials: [
    {
      displayName: 'Credential for website ${webSiteName}'
      endDateTime: dateTimeAdd(deploymentTime, 'P180D')
      // keyId: 'string'
      // startDateTime: 'string'
    }
  ]
}

var graphAppId = '00000003-0000-0000-c000-000000000000' //Microsoft Graph ID
// Get the Microsoft Graph service principal so that the scope names can be looked up and mapped to a permission ID
resource msGraphSP 'Microsoft.Graph/servicePrincipals@v1.0' existing = {
  appId: graphAppId
}

// ========== Entra ID Service Principal ========== //
resource entraIdServicePrincipal 'Microsoft.Graph/servicePrincipals@v1.0' = if (entraIdApplicationConfiguration.?enabled!) {
  appId: entraIdApplication.appId
}

// Grant the OAuth2.0 scopes (requested in parameters) to the basic app, for all users in the tenant
resource graphScopesAssignment 'Microsoft.Graph/oauth2PermissionGrants@v1.0' = if (entraIdApplicationConfiguration.?enabled!) {
  clientId: entraIdServicePrincipal.id
  resourceId: msGraphSP.id
  consentType: 'AllPrincipals'
  scope: 'User.Read'
}

// ========== Frontend web site ========== //
var webSiteName = '${solutionPrefix}wapp'
var entraIdApplicationId = '721995ba-068c-4523-9cab-7438b52f92b9'
var entraIdApplicationCredentialSecretSettingName = 'MICROSOFT_PROVIDER_AUTHENTICATION_SECRET'

module webSite 'br/public:avm/res/web/site:0.15.1' = {
  name: 'avm.ptn.sa.macae.web-site'
  params: {
    tags: tags
    kind: 'app,linux,container'
    name: webSiteName
    location: solutionLocation
    serverFarmResourceId: webServerfarm.outputs.resourceId
    appInsightResourceId: applicationInsights.outputs.resourceId
    siteConfig: {
      linuxFxVersion: 'DOCKER|biabcontainerreg.azurecr.io/macaefrontend:latest'
    }
    appSettingsKeyValuePairs: union(
      {
        SCM_DO_BUILD_DURING_DEPLOYMENT: 'true'
        DOCKER_REGISTRY_SERVER_URL: 'https://biabcontainerreg.azurecr.io'
        WEBSITES_PORT: '3000'
        WEBSITES_CONTAINER_START_TIME_LIMIT: '1800' // 30 minutes, adjust as needed
        BACKEND_API_URL: 'https://${containerApp.outputs.fqdn}'
      },
      (entraIdApplicationConfiguration.?enabled!
        ? { '${entraIdApplicationCredentialSecretSettingName}': entraIdApplication.passwordCredentials[0].secretText }
        : {})
    )
    authSettingV2Configuration: {
      platform: {
        enabled: entraIdApplicationConfiguration.?enabled!
        runtimeVersion: '~1'
      }
      login: {
        cookieExpiration: {
          convention: 'FixedTime'
          timeToExpiration: '08:00:00'
        }
        nonce: {
          nonceExpirationInterval: '00:05:00'
          validateNonce: true
        }
        preserveUrlFragmentsForLogins: false
        routes: {}
        tokenStore: {
          azureBlobStorage: {}
          enabled: true
          fileSystem: {}
          tokenRefreshExtensionHours: 72
        }
      }
      globalValidation: {
        requireAuthentication: true
        unauthenticatedClientAction: 'RedirectToLoginPage'
        redirectToProvider: 'azureactivedirectory'
      }
      httpSettings: {
        forwardProxy: {
          convention: 'NoProxy'
        }
        requireHttps: true
        routes: {
          apiPrefix: '/.auth'
        }
      }
      identityProviders: {
        azureActiveDirectory: entraIdApplicationConfiguration.?enabled!
          ? {
              isAutoProvisioned: true
              enabled: true
              login: {
                disableWWWAuthenticate: false
              }
              registration: {
                clientId: entraIdApplicationId //create application in AAD
                clientSecretSettingName: entraIdApplicationCredentialSecretSettingName
                openIdIssuer: 'https://sts.windows.net/${tenant().tenantId}/v2.0/'
              }
              validation: {
                allowedAudiences: [
                  'api://${entraIdApplicationId}'
                ]
                defaultAuthorizationPolicy: {
                  allowedPrincipals: {}
                  allowedApplications: ['86e2d249-6832-461f-8888-cfa0394a5f8c']
                }
                jwtClaimChecks: {}
              }
            }
          : {}
      }
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

@export()
@description('The type for the Multi-Agent Custom Automation Entra ID Application resource configuration.')
type macaeEntraIdApplicationFarmType = {
  @description('Optional. If the Entra ID Application for website authentication should be enabled or not.')
  enabled: bool?
}
