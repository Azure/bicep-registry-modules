@description('Optional, default is false. Set to true if you want to deploy ASE v3 instead of Multitenant App Service Plan.')
param deployAseV3 bool = false

@description('Optional if deployAseV3 = false. The identifier for the App Service Environment v3 resource.')
@minLength(1)
@maxLength(36)
param aseName string

@description('Required. Name of the App Service Plan.')
@minLength(1)
@maxLength(40)
param appServicePlanName string

@description('Required. Name of the web app.')
@maxLength(60)
param webAppName string

@description('Required. Name of the managed Identity that will be assigned to the web app.')
@minLength(3)
@maxLength(128)
param managedIdentityName string

@description('Optional S1 is default. Defines the name, tier, size, family and capacity of the App Service Plan. Plans ending to _AZ, are deploying at least three instances in three Availability Zones. EP* is only for functions')
@allowed([
  'S1'
  'S2'
  'S3'
  'P1V3'
  'P2V3'
  'P3V3'
  'EP1'
  'EP2'
  'EP3'
  'ASE_I1V2'
  'ASE_I2V2'
  'ASE_I3V2'
])
param sku string

@description('Optional. Set to true if you want to deploy the App Service Plan in a zone redundant manner. Default is true.')
param zoneRedundant bool = true

@description('Optional. Location for all resources.')
param location string

@description('Resource tags that we might need to add to all resources (i.e. Environment, Cost center, application name etc)')
param tags object

@description('Default is empty. If empty no Private Endpoint will be created for the resoure. Otherwise, the subnet where the private endpoint will be attached to')
param subnetPrivateEndpointId string = ''

@description('Optional. Array of custom objects describing vNet links of the DNS zone. Each object should contain vnetName, vnetId, registrationEnabled')
param virtualNetworkLinks array = []

@description('Kind of server OS of the App Service Plan')
@allowed(['windows', 'linux'])
param webAppBaseOs string

@description('An existing Log Analytics WS Id for creating app Insights, diagnostics etc.')
param logAnalyticsWsId string

@description('The subnet ID that is dedicated to Web Server, for Vnet Injection of the web app. If deployAseV3=true then this is the subnet dedicated to the ASE v3')
param subnetIdForVnetInjection string

@description('Optional. If true, apps assigned to this App Service plan can be scaled independently. If false, apps assigned to this App Service plan will scale to all instances of the plan.')
param perSiteScaling bool = false

@description('Optional, default is 20. Maximum number of total workers allowed for this ElasticScaleEnabled App Service Plan.')
param maximumElasticWorkerCount int = 20

@description('Optional. Scaling worker count.')
param targetWorkerCount int = 0

@description('Optional, default is Windows. Kind of server OS.')
@allowed([
  'Windows'
  'Linux'
])
param serverOS string = 'Windows'

@description('Optional. The instance size of the hosting plan (small, medium, or large).')
@allowed([
  0
  1
  2
])
param targetWorkerSize int = 0

@description('Optional. The name of metrics that will be streamed.')
param diagnosticMetricsToEnable array = [
  {
    metricCategories: [
      {
        category: 'AllMetrics'
      }
    ]
    workspaceResourceId: logAnalyticsWsId
  }
]

@description('Optional. The site configuration for the web app.')
param siteConfig object = {
  alwaysOn: true
  ftpsState: 'FtpsOnly'
  minTlsVersion: '1.2'
  healthCheckPath: '/healthz'
  http20Enabled: true
}

@description('Optional. Kind of web app. Defaults to app.')
@allowed([
  'api'
  'app'
  'app,container,windows'
  'app,linux'
  'app,linux,container'
  'functionapp'
  'functionapp,linux'
  'functionapp,linux,container'
  'functionapp,linux,container,azurecontainerapps'
  'functionapp,workflowapp'
  'functionapp,workflowapp,linux'
  'linux,api'
])
param kind string = 'app'

var webAppDnsZoneName = 'privatelink.azurewebsites.net'
var slotName = 'staging'

// ============ //
// Dependencies //
// ============ //

// var siteConfigConfigurationMap = {
//   windowsNet6: {
//     metadata: [
//       {
//         name: 'CURRENT_STACK'
//         value: 'dotnet'
//       }
//     ]
//     netFrameworkVersion: 'v6.0'
//     use32BitWorkerProcess: false
//   }
//   windowsNet7: {
//     metadata: [
//       {
//         name: 'CURRENT_STACK'
//         value: 'dotnet'
//       }
//     ]
//     netFrameworkVersion: 'v7.0'
//     use32BitWorkerProcess: false
//   }
//   windowsAspNet486: {
//     metadata: [
//       {
//         name: 'CURRENT_STACK'
//         value: 'dotnet'
//       }
//     ]
//     netFrameworkVersion: 'v4.0'
//     use32BitWorkerProcess: false
//   }
//   linuxJava17Se: {
//     linuxFxVersion: 'java|17-java17'
//     use32BitWorkerProcess: false
//   }
//   linuxNet8: {
//     linuxFxVersion: 'dotnetcore|8.0'
//     use32BitWorkerProcess: false
//   }
//   linuxNet7: {
//     linuxFxVersion: 'dotnetcore|7.0'
//     use32BitWorkerProcess: false
//   }
//   linuxNet6: {
//     linuxFxVersion: 'dotnetcore|6.0'
//     use32BitWorkerProcess: false
//   }
//   linuxNode18: {
//     linuxFxVersion: 'node|18-lts'
//     use32BitWorkerProcess: false
//   }
// }

module ase './ase.module.bicep' = if (deployAseV3) {
  name: take('${aseName}-ASEv3-Deployment', 64)
  params: {
    name: aseName
    location: location
    tags: tags
    subnetResourceId: subnetIdForVnetInjection
    zoneRedundant: zoneRedundant
    allowNewPrivateEndpointConnections: true
    virtualNetworkLinks: virtualNetworkLinks
  }
}

module appInsights 'br/public:avm/res/insights/component:0.4.1' = {
  name: '${uniqueString(deployment().name, location)}-appInsights-Deployment'
  params: {
    name: 'appi-${webAppName}'
    location: location
    tags: tags
    workspaceResourceId: logAnalyticsWsId
    applicationType: 'web'
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
    retentionInDays: 90
    samplingPercentage: 100
  }
}

module plan 'br/public:avm/res/web/serverfarm:0.2.4' = {
  name: take('${webAppName}-app-Deployment', 64)
  params: {
    name: appServicePlanName
    location: location
    tags: tags
    skuName: sku
    zoneRedundant: zoneRedundant
    kind: (webAppBaseOs =~ 'linux') ? 'Linux' : 'Windows'
    perSiteScaling: perSiteScaling
    maximumElasticWorkerCount: (maximumElasticWorkerCount < 3 && zoneRedundant) ? 3 : maximumElasticWorkerCount
    reserved: serverOS == 'Linux'
    targetWorkerCount: (targetWorkerCount < 3 && zoneRedundant) ? 3 : targetWorkerCount
    targetWorkerSize: targetWorkerSize
    appServiceEnvironmentId: deployAseV3 ? ase.outputs.resourceId : ''
    diagnosticSettings: diagnosticMetricsToEnable
  }
}

module webApp 'br/public:avm/res/web/site:0.9.0' = {
  name: take('${webAppName}-webApp-Deployment', 64)
  params: {
    kind: !empty(kind) ? 'app,linux' : 'app'
    name: webAppName
    location: location
    serverFarmResourceId: plan.outputs.resourceId
    appInsightResourceId: appInsights.outputs.resourceId
    siteConfig: siteConfig
    clientAffinityEnabled: false
    diagnosticSettings: [
      {
        workspaceResourceId: logAnalyticsWsId
      }
    ]
    virtualNetworkSubnetId: !(deployAseV3) ? subnetIdForVnetInjection : ''
    managedIdentities: {
      userAssignedResourceIds: ['${webAppUserAssignedManagedIdentity.outputs.resourceId}']
    }
    slots: [
      {
        name: slotName
      }
    ]
    privateEndpoints: (!empty(subnetPrivateEndpointId) && !deployAseV3)
      ? [
          {
            name: 'webApp'
            subnetResourceId: subnetPrivateEndpointId
            privateDnsZoneGroup: {
              name: 'webApp'
              privateDnsZoneGroupConfigs: [
                {
                  name: webAppDnsZoneName
                  privateDnsZoneResourceId: webAppPrivateDnsZone.outputs.resourceId
                }
              ]
            }
          }
        ]
      : []
    tags: tags
  }
}

module webAppPrivateDnsZone 'br/public:avm/res/network/private-dns-zone:0.6.0' = if (!empty(subnetPrivateEndpointId) && !deployAseV3) {
  name: take('${replace(webAppDnsZoneName, '.', '-')}-PrivateDnsZoneDeployment', 64)
  params: {
    name: webAppDnsZoneName
    location: 'global'
    virtualNetworkLinks: virtualNetworkLinks
    tags: tags
  }
}

module webAppUserAssignedManagedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.0' = {
  name: '${uniqueString(deployment().name, location, 'webapp')}-deployment'
  params: {
    name: managedIdentityName
    location: location
    tags: tags
  }
}

module peWebAppSlot 'br/public:avm/res/network/private-endpoint:0.9.0' = if (!empty(subnetPrivateEndpointId) && !deployAseV3) {
  name: take('pe-${webAppName}-slot-${slotName}-Deployment', 64)
  params: {
    name: take('pe-${webAppName}-slot-${slotName}', 64)
    location: location
    tags: tags
    privateDnsZoneGroup: (!empty(subnetPrivateEndpointId) && !deployAseV3)
      ? {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: webAppPrivateDnsZone.outputs.resourceId
            }
          ]
        }
      : null
    subnetResourceId: subnetPrivateEndpointId
    privateLinkServiceConnections: [
      {
        name: 'webApp'
        properties: {
          privateLinkServiceId: webApp.outputs.resourceId
          groupIds: ['sites-${slotName}']
        }
      }
    ]
  }
}

output webAppName string = webApp.outputs.name
output webAppHostName string = webApp.outputs.defaultHostname
output webAppResourceId string = webApp.outputs.resourceId
output webAppLocation string = webApp.outputs.location
output webAppSystemAssignedPrincipalId string = webAppUserAssignedManagedIdentity.outputs.principalId

@description('The Internal ingress IP of the ASE.')
output internalInboundIpAddress string = deployAseV3 ? ase.outputs.internalInboundIpAddress : ''

@description('The name of the ASE.')
output aseName string = deployAseV3 ? ase.outputs.name : ''
