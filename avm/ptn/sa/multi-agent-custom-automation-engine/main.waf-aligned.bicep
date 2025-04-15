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

module networkSecurityGroup 'br/public:avm/res/network/network-security-group:0.5.1' = {
  name: 'avm.ptn.sa.macae.network-network-security-group'
  params: {
    name: '${solutionPrefix}nsgr'
    location: solutionLocation
    tags: tags
    enableTelemetry: enableTelemetry
    securityRules: [
      // {
      //   name: 'DenySshRdpOutbound'
      //   properties: {
      //     priority: 200
      //     access: 'Deny'
      //     protocol: '*'
      //     direction: 'Outbound'
      //     sourceAddressPrefix: 'VirtualNetwork'
      //     sourcePortRange: '*'
      //     destinationAddressPrefix: '*'
      //     destinationPortRanges: [
      //       '3389'
      //       '22'
      //     ]
      //   }
      // }
    ]
  }
}

module networkSecurityGroupContainers 'br/public:avm/res/network/network-security-group:0.5.1' = {
  name: 'avm.ptn.sa.macae.network-network-security-group-containers'
  params: {
    name: '${solutionPrefix}nsgrcntr'
    location: solutionLocation
    tags: tags
    enableTelemetry: enableTelemetry
    securityRules: [
      //CONFIGURE: https://learn.microsoft.com/en-us/azure/container-apps/networking?tabs=workload-profiles-env%2Cazure-cli#network-rules
      // {
      //   name: 'DenySshRdpOutbound'
      //   properties: {
      //     priority: 200
      //     access: 'Deny'
      //     protocol: '*'
      //     direction: 'Outbound'
      //     sourceAddressPrefix: 'VirtualNetwork'
      //     sourcePortRange: '*'
      //     destinationAddressPrefix: '*'
      //     destinationPortRanges: [
      //       '3389'
      //       '22'
      //     ]
      //   }
      // }
    ]
  }
}

module virtualNetwork 'br/public:avm/res/network/virtual-network:0.6.1' = {
  name: 'avm.ptn.sa.macae.network-virtual-network'
  params: {
    name: '${solutionPrefix}vnet'
    location: solutionLocation
    tags: tags
    enableTelemetry: enableTelemetry
    addressPrefixes: ['10.0.0.0/8']
    subnets: [
      // The default subnet **must** be the first in the subnets array
      {
        addressPrefix: '10.0.0.0/24' //subnet of size /23 is required for container app
        //defaultOutboundAccess: false TODO: check this configuration for a more restricted outbound access
        name: 'default'
        networkSecurityGroupResourceId: networkSecurityGroup.outputs.resourceId
      }
      {
        // If you use your own VNet, you need to provide a subnet that is dedicated exclusively to the Container App environment you deploy. This subnet isn't available to other services
        // https://learn.microsoft.com/en-us/azure/container-apps/networking?tabs=workload-profiles-env%2Cazure-cli#custom-vnet-configuration
        addressPrefix: '10.0.2.0/23' //subnet of size /23 is required for container app
        //defaultOutboundAccess: false TODO: check this configuration for a more restricted outbound access
        name: 'containers'
        networkSecurityGroupResourceId: networkSecurityGroupContainers.outputs.resourceId
      }
      {
        addressPrefix: '10.0.4.0/26'
        name: 'AzureBastionSubnet'
        //networkSecurityGroupResourceId: networkSecurityGroupBastion.outputs.resourceId
      }
    ]
  }
}

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

// ========== DNS Zone for AI Foundry: Open AI ========== //
var openAiSubResource = 'account'
var openAiPrivateDnsZones = {
  'privatelink.cognitiveservices.azure.com': openAiSubResource
  'privatelink.openai.azure.com': openAiSubResource
  'privatelink.services.ai.azure.com': openAiSubResource
}

module privateDnsZonesAiServices 'br/public:avm/res/network/private-dns-zone:0.7.1' = [
  for zone in objectKeys(openAiPrivateDnsZones): {
    name: 'avm.ptn.sa.macae.private-dns-zone-${uniqueString(deployment().name, zone)}'
    params: {
      name: zone
      tags: tags
      enableTelemetry: enableTelemetry
      virtualNetworkLinks: [{ virtualNetworkResourceId: virtualNetwork.outputs.resourceId }]
    }
  }
]

// ========== AI Foundry: Open AI ==========
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
    privateEndpoints: [
      {
        subnetResourceId: virtualNetwork.outputs.subnetResourceIds[0]
        service: openAiSubResource
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: map(objectKeys(openAiPrivateDnsZones), zone => {
            name: replace(zone, '.', '-')
            privateDnsZoneResourceId: resourceId('Microsoft.Network/privateDnsZones', zone)
          })
        }
      }
    ]
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
          capacity: 50
        }
      }
    ]
  }
}

// ========== DNS Zone for Cosmos DB ========== //
module privateDnsZoneCosmosDb 'br/public:avm/res/network/private-dns-zone:0.7.0' = {
  name: 'avm.ptn.sa.macae.network-private-dns-zone-cosmos-db'
  params: {
    name: 'privatelink.documents.azure.com'
    enableTelemetry: enableTelemetry
    virtualNetworkLinks: [{ virtualNetworkResourceId: virtualNetwork.outputs.resourceId }]
    tags: tags
  }
}

// ========== Cosmos DB ========== //
var cosmosDbDatabaseName = 'autogen'
var cosmosDbDatabaseMemoryContainerName = 'autogen'
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
      networkAclBypass: 'None'
      publicNetworkAccess: 'Disabled'
    }
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [{ privateDnsZoneResourceId: privateDnsZoneCosmosDb.outputs.resourceId }]
        }
        service: 'Sql'
        subnetResourceId: virtualNetwork.outputs.subnetResourceIds[0]
      }
    ]
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

// ========== Container App Environment ========== //
module containerAppEnvironment 'br/public:avm/res/app/managed-environment:0.10.2' = {
  name: 'avm.ptn.sa.macae.container-app-environment'
  params: {
    name: '${solutionPrefix}cenv'
    location: solutionLocation
    tags: tags
    enableTelemetry: enableTelemetry
    logsDestination: 'log-analtyics'
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
    appInsightsConnectionString: applicationInsights.outputs.connectionString
    publicNetworkAccess: 'Disabled'
    zoneRedundant: false //TODO: make it zone redundant for waf aligned
    infrastructureSubnetId: virtualNetwork.outputs.subnetResourceIds[1]
    internal: true
  }
}
resource aspireDashboard 'Microsoft.App/managedEnvironments/dotNetComponents@2024-10-02-preview' = {
  name: '${solutionPrefix}cenv/aspire-dashboard'
  properties: {
    componentType: 'AspireDashboard'
  }
  dependsOn: [containerAppEnvironment]
}

// ========== DNS zone for Container App Environment ========== //
module dnsZoneContainerApp 'br/public:avm/res/network/private-dns-zone:0.7.1' = {
  name: 'avm.ptn.sa.macae.network-private-dns-zone-containers'
  params: {
    name: 'privatelink.${toLower(replace(containerAppEnvironment.outputs.location,' ',''))}.azurecontainerapps.io'
    enableTelemetry: enableTelemetry
    virtualNetworkLinks: [{ virtualNetworkResourceId: virtualNetwork.outputs.resourceId }]
  }
}

// ========== Backend Container App Service ========== //
module containerApp 'br/public:avm/res/app/container-app:0.14.2' = {
  name: 'avm.ptn.sa.macae.container-app'
  params: {
    name: '${solutionPrefix}capp'
    tags: tags
    location: solutionLocation
    enableTelemetry: enableTelemetry
    environmentResourceId: containerAppEnvironment.outputs.resourceId
    managedIdentities: { userAssignedResourceIds: [userAssignedIdentity.outputs.resourceId] }
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
            value: aiServicesDeploymentGptVersion
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
    publicNetworkAccess: 'Enabled' //TODO: use Azure Front Door WAF or Application Gateway WAF instead
    privateEndpoints: [{ subnetResourceId: virtualNetwork.outputs.subnetResourceIds[0] }]
    appSettingsKeyValuePairs: {
      SCM_DO_BUILD_DURING_DEPLOYMENT: 'true'
      DOCKER_REGISTRY_SERVER_URL: 'https://biabcontainerreg.azurecr.io'
      WEBSITES_PORT: '3000'
      WEBSITES_CONTAINER_START_TIME_LIMIT: '1800' // 30 minutes, adjust as needed
      BACKEND_API_URL: 'https://${containerApp.outputs.fqdn}'
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
