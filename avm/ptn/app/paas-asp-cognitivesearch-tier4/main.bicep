@description('The name that will be used as prefix for all resources.')
param name string = 'avmptnopenai'

@description('The location where all resources will be deployed.')
param location string = resourceGroup().location

@description('The environment for the deployed resources e.g. dev, test, prod.')
param environment string = 'default-dev'

@description('Enable or disable telemetry collection')
param enableTelemetry bool = true

@description('Optional. The tags to be assigned to the created resources.')
param tags object = {
  environment: environment
  solution: 'Azure Verified Modules OpenAI Solution'
}

@description('Id of the log analytics workspace resources should send diagnostic logs to')
param logAnalyticsWorkspaceId string = ''

@description('The resource ID of an existing workspace to associate with Application Insights')
param appInsightsWorkspaceResourceId string = ''

@description('API Management publisher email')
param publisherEmail string = 'apimgmt-noreply@mail.windowsazure.com'

@description('API Management publisher name')
param publisherName string = 'azure-verified-modules'

@description('API Management SKU')
param apiManagementSku string = 'Premium_2'

// Resource abbreviations
var abbrs = {
  webapp: 'webapp'
  apiapp: 'apiapp'
  vnet: 'vnet'
  aisearch: 'aisearch'
  appserviceplan: 'appserviceplan'
  docint: 'docint'
  openai: 'openai'
  nsg: 'nsg'
  pe: 'pe'
  smartdetection: 'smartdetection'
  apim: 'apim'
}

// Resource Names
var resourceNames = {
  azureOpenAI: '${name}-${environment}-${abbrs.openai}'
  documentIntelligence: '${name}-${environment}-${abbrs.docint}'
  searchService: '${name}-${environment}-${abbrs.aisearch}'
  virtualNetwork: '${name}-${environment}-${abbrs.vnet}'
  appInsights: '${name}-${environment}-${abbrs.webapp}'
  appServicePlan: '${name}-${environment}-${abbrs.appserviceplan}'
  webapp: '${name}-${environment}-${abbrs.webapp}'
  apiapp: '${name}-${environment}-${abbrs.apiapp}'
  actionGroup: '${name}-${environment}-${abbrs.smartdetection}-mag'
  apiManagement: '${name}-${environment}-${abbrs.apim}'
  // Network Security Groups
  nsgApimSubnet: '${name}-${environment}-${abbrs.vnet}-ApimSubnet-${abbrs.nsg}'
  nsgReservedSubnet: '${name}-${environment}-${abbrs.vnet}-ReservedSubnet-${abbrs.nsg}'
  nsgPrivateEndpointSubnet: '${name}-${environment}-${abbrs.vnet}-PrivateEndpointSubnet-${abbrs.nsg}'
  nsgAppServiceInboundSubnet: '${name}-${environment}-${abbrs.vnet}-AppServiceInboundSubnet-${abbrs.nsg}'
  nsgAppServiceOutboundSubnet: '${name}-${environment}-${abbrs.vnet}-AppServiceOutboundSubnet-${abbrs.nsg}'
  // Private Endpoints
  peDocumentIntelligence: '${name}-${environment}-${abbrs.docint}-${abbrs.pe}'
  peOpenAI: '${name}-${environment}-${abbrs.openai}-${abbrs.pe}'
  peAISearch: '${name}-${environment}-${abbrs.aisearch}-${abbrs.pe}'
  peAppService: '${name}-${environment}-${abbrs.webapp}-${abbrs.pe}'
}

// Define the NSG security rules
var appServiceInboundSubnetSecurityRules = [
  {
    name: 'AllowInboundFromApimToAppServiceInbound'
    properties: {
      protocol: '*'
      sourcePortRange: '*'
      destinationPortRange: '*'
      sourceAddressPrefix: '10.0.0.0/24'
      destinationAddressPrefix: '10.0.1.0/24'
      access: 'Allow'
      priority: 100
      direction: 'Inbound'
    }
  }
  {
    name: 'AllowOutboundFromAppServiceInboundToApim'
    properties: {
      protocol: '*'
      sourcePortRange: '*'
      destinationPortRange: '*'
      sourceAddressPrefix: '10.0.1.0/24'
      destinationAddressPrefix: '10.0.0.0/24'
      access: 'Allow'
      priority: 100
      direction: 'Outbound'
    }
  }
]

var appServiceOutboundSubnetSecurityRules = [
  {
    name: 'AllowInboundFromPrivateEndpointToAppServiceOutbound'
    properties: {
      protocol: '*'
      sourcePortRange: '*'
      destinationPortRange: '*'
      sourceAddressPrefix: '10.0.3.0/24'
      destinationAddressPrefix: '10.0.2.0/24'
      access: 'Allow'
      priority: 100
      direction: 'Inbound'
    }
  }
  {
    name: 'AllowOutboundFromAppServiceOutboundToPrivateEndpoint'
    properties: {
      protocol: '*'
      sourcePortRange: '*'
      destinationPortRange: '*'
      sourceAddressPrefix: '10.0.2.0/24'
      destinationAddressPrefix: '10.0.3.0/24'
      access: 'Allow'
      priority: 100
      direction: 'Outbound'
    }
  }
]

var privateEndpointSubnetSecurityRules = [
  {
    name: 'AllowOutboundFromPrivateEndpointToAppServiceOutbound'
    properties: {
      protocol: '*'
      sourcePortRange: '*'
      destinationPortRange: '*'
      sourceAddressPrefix: '10.0.3.0/24'
      destinationAddressPrefix: '10.0.2.0/24'
      access: 'Allow'
      priority: 100
      direction: 'Outbound'
    }
  }
  {
    name: 'AllowInboundFromAppServiceOutboundToPrivateEndpoint'
    properties: {
      protocol: '*'
      sourcePortRange: '*'
      destinationPortRange: '*'
      sourceAddressPrefix: '10.0.2.0/24'
      destinationAddressPrefix: '10.0.3.0/24'
      access: 'Allow'
      priority: 100
      direction: 'Inbound'
    }
  }
]

// Web app configurations
var webAppSettings = {
  ftpsState: 'FtpsOnly'
  ipRestrictionDefaultAction: 'Deny'
  scmIpRestrictionDefaultAction: 'Deny'
  vnetRouteAllEnabled: true
}

resource avmTelemetry 'Microsoft.Resources/deployments@2023-07-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.cognitive-search.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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
}

// Network Security Groups
module nsgApimSubnet 'br/public:avm/res/network/network-security-group:0.5.1' = {
  name: 'nsg-apimSubnet-deployment'
  params: {
    name: resourceNames.nsgApimSubnet
    location: location
    tags: tags
    securityRules: []
    diagnosticSettings: logAnalyticsWorkspaceId == ''
      ? []
      : [
          {
            name: 'diagnostics'
            workspaceResourceId: logAnalyticsWorkspaceId
            logCategoriesAndGroups: [
              {
                category: 'NetworkSecurityGroupEvent'
              }
              {
                category: 'NetworkSecurityGroupRuleCounter'
              }
            ]
          }
        ]
  }
}

module nsgReservedSubnet 'br/public:avm/res/network/network-security-group:0.5.1' = {
  name: 'nsg-reservedSubnet-deployment'
  params: {
    name: resourceNames.nsgReservedSubnet
    location: location
    tags: tags
    securityRules: []
    diagnosticSettings: logAnalyticsWorkspaceId == ''
      ? []
      : [
          {
            name: 'diagnostics'
            workspaceResourceId: logAnalyticsWorkspaceId
            logCategoriesAndGroups: [
              {
                category: 'NetworkSecurityGroupEvent'
              }
              {
                category: 'NetworkSecurityGroupRuleCounter'
              }
            ]
          }
        ]
  }
}

module nsgPrivateEndpointSubnet 'br/public:avm/res/network/network-security-group:0.5.1' = {
  name: 'nsg-privateEndpointSubnet-deployment'
  params: {
    name: resourceNames.nsgPrivateEndpointSubnet
    location: location
    tags: tags
    securityRules: privateEndpointSubnetSecurityRules
    diagnosticSettings: logAnalyticsWorkspaceId == ''
      ? []
      : [
          {
            name: 'diagnostics'
            workspaceResourceId: logAnalyticsWorkspaceId
            logCategoriesAndGroups: [
              {
                category: 'NetworkSecurityGroupEvent'
              }
              {
                category: 'NetworkSecurityGroupRuleCounter'
              }
            ]
          }
        ]
  }
}

module nsgAppServiceInboundSubnet 'br/public:avm/res/network/network-security-group:0.5.1' = {
  name: 'nsg-appServiceInboundSubnet-deployment'
  params: {
    name: resourceNames.nsgAppServiceInboundSubnet
    location: location
    tags: tags
    securityRules: appServiceInboundSubnetSecurityRules
    diagnosticSettings: logAnalyticsWorkspaceId == ''
      ? []
      : [
          {
            name: 'diagnostics'
            workspaceResourceId: logAnalyticsWorkspaceId
            logCategoriesAndGroups: [
              {
                category: 'NetworkSecurityGroupEvent'
              }
              {
                category: 'NetworkSecurityGroupRuleCounter'
              }
            ]
          }
        ]
  }
}

module nsgAppServiceOutboundSubnet 'br/public:avm/res/network/network-security-group:0.5.1' = {
  name: 'nsg-appServiceOutboundSubnet-deployment'
  params: {
    name: resourceNames.nsgAppServiceOutboundSubnet
    location: location
    tags: tags
    securityRules: appServiceOutboundSubnetSecurityRules
    diagnosticSettings: logAnalyticsWorkspaceId == ''
      ? []
      : [
          {
            name: 'diagnostics'
            workspaceResourceId: logAnalyticsWorkspaceId
            logCategoriesAndGroups: [
              {
                category: 'NetworkSecurityGroupEvent'
              }
              {
                category: 'NetworkSecurityGroupRuleCounter'
              }
            ]
          }
        ]
  }
}

// Virtual Network
module virtualNetwork 'br/public:avm/res/network/virtual-network:0.6.1' = {
  name: 'vnet-deployment'
  params: {
    name: resourceNames.virtualNetwork
    location: location
    tags: tags
    addressPrefixes: [
      '10.0.0.0/16'
    ]
    subnets: [
      {
        name: 'ApimSubnet'
        addressPrefix: '10.0.0.0/24'
        networkSecurityGroupResourceId: nsgApimSubnet.outputs.resourceId
      }
      {
        name: 'AppServiceInboundSubnet'
        addressPrefix: '10.0.1.0/24'
        networkSecurityGroupResourceId: nsgAppServiceInboundSubnet.outputs.resourceId
      }
      {
        name: 'AppServiceOutboundSubnet'
        addressPrefix: '10.0.2.0/24'
        networkSecurityGroupResourceId: nsgAppServiceOutboundSubnet.outputs.resourceId
        serviceEndpoints: [
          'Microsoft.Storage'
        ]
        delegation: 'Microsoft.Web/serverFarms'
      }
      {
        name: 'PrivateEndpointSubnet'
        addressPrefix: '10.0.3.0/24'
        networkSecurityGroupResourceId: nsgPrivateEndpointSubnet.outputs.resourceId
        privateEndpointNetworkPolicies: 'Enabled'
      }
      {
        name: 'ReservedSubnet'
        addressPrefix: '10.0.4.0/24'
        networkSecurityGroupResourceId: nsgReservedSubnet.outputs.resourceId
      }
    ]
    diagnosticSettings: logAnalyticsWorkspaceId == ''
      ? []
      : [
          {
            name: 'diagnostics'
            workspaceResourceId: logAnalyticsWorkspaceId
            metricCategories: [
              {
                category: 'AllMetrics'
              }
            ]
            logCategoriesAndGroups: [
              {
                category: 'VMProtectionAlerts'
              }
            ]
          }
        ]
  }
}

// Private DNS Zones for private endpoints
module openaiPrivateDnsZone 'br/public:avm/res/network/private-dns-zone:0.7.0' = {
  name: 'openai-private-dns-zone'
  params: {
    name: 'privatelink.openai.azure.com'
    location: 'global'
    tags: tags
    virtualNetworkLinks: [
      {
        virtualNetworkResourceId: virtualNetwork.outputs.resourceId
        registrationEnabled: false
        name: '${resourceNames.virtualNetwork}-link'
      }
    ]
  }
}

module docIntelPrivateDnsZone 'br/public:avm/res/network/private-dns-zone:0.7.0' = {
  name: 'docintel-private-dns-zone'
  params: {
    name: 'privatelink.cognitiveservices.azure.com'
    location: 'global'
    tags: tags
    virtualNetworkLinks: [
      {
        virtualNetworkResourceId: virtualNetwork.outputs.resourceId
        registrationEnabled: false
        name: '${resourceNames.virtualNetwork}-link'
      }
    ]
  }
}

module searchPrivateDnsZone 'br/public:avm/res/network/private-dns-zone:0.7.0' = {
  name: 'search-private-dns-zone'
  params: {
    name: 'privatelink.search.windows.net'
    location: 'global'
    tags: tags
    virtualNetworkLinks: [
      {
        virtualNetworkResourceId: virtualNetwork.outputs.resourceId
        registrationEnabled: false
        name: '${resourceNames.virtualNetwork}-link'
      }
    ]
  }
}

module sitesPrivateDnsZone 'br/public:avm/res/network/private-dns-zone:0.7.0' = {
  name: 'sites-private-dns-zone'
  params: {
    name: 'privatelink.azurewebsites.net'
    location: 'global'
    tags: tags
    virtualNetworkLinks: [
      {
        virtualNetworkResourceId: virtualNetwork.outputs.resourceId
        registrationEnabled: false
        name: '${resourceNames.virtualNetwork}-link'
      }
    ]
  }
}

// Action Group - Smart Detection
module actionGroup 'br/public:avm/res/insights/action-group:0.5.0' = {
  name: 'action-group-deployment'
  params: {
    name: resourceNames.actionGroup
    location: 'global'
    tags: tags
    groupShortName: 'SmartDetect'
    enabled: true
    armRoleReceivers: [
      {
        name: 'Monitoring Contributor'
        roleId: '749f88d5-cbae-40b8-bcfc-e573ddc772fa'
        useCommonAlertSchema: true
      }
      {
        name: 'Monitoring Reader'
        roleId: '43d0d8ad-25c7-4714-9337-8ba259a9fe05'
        useCommonAlertSchema: true
      }
    ]
  }
}

// Azure OpenAI resource
module azureOpenAI 'br/public:avm/res/cognitive-services/account:0.10.2' = {
  name: 'openai-deployment'
  params: {
    name: resourceNames.azureOpenAI
    location: location
    tags: tags
    kind: 'OpenAI'
    sku: 'S0'
    customSubDomainName: resourceNames.azureOpenAI
    publicNetworkAccess: 'Disabled'
    networkAcls: {
      defaultAction: 'Deny'
      ipRules: []
      virtualNetworkRules: []
    }
    diagnosticSettings: logAnalyticsWorkspaceId == ''
      ? []
      : [
          {
            name: 'diagnostics'
            workspaceResourceId: logAnalyticsWorkspaceId
            metricCategories: [
              {
                category: 'AllMetrics'
              }
            ]
          }
        ]
  }
}

// Document Intelligence resource
module documentIntelligence 'br/public:avm/res/cognitive-services/account:0.10.2' = {
  name: 'docint-deployment'
  params: {
    name: resourceNames.documentIntelligence
    location: location
    tags: tags
    kind: 'FormRecognizer'
    sku: 'S0'
    customSubDomainName: resourceNames.documentIntelligence
    publicNetworkAccess: 'Disabled'
    networkAcls: {
      defaultAction: 'Deny'
      ipRules: []
      virtualNetworkRules: []
    }
    managedIdentities: {
      systemAssigned: true
    }
    diagnosticSettings: logAnalyticsWorkspaceId == ''
      ? []
      : [
          {
            name: 'diagnostics'
            workspaceResourceId: logAnalyticsWorkspaceId
            metricCategories: [
              {
                category: 'AllMetrics'
              }
            ]
          }
        ]
  }
}

// Search Service
module searchService 'br/public:avm/res/search/search-service:0.9.2' = {
  name: 'search-service-deployment'
  params: {
    name: resourceNames.searchService
    location: location
    tags: tags
    sku: 'standard'
    publicNetworkAccess: 'Disabled'
    authOptions: {
      apiKeyOnly: {}
    }
    replicaCount: 1
    partitionCount: 1
    hostingMode: 'default'
    semanticSearch: 'free'
    networkRuleSet: {
      bypass: 'None'
      ipRules: []
    }
    diagnosticSettings: logAnalyticsWorkspaceId == ''
      ? []
      : [
          {
            name: 'diagnostics'
            workspaceResourceId: logAnalyticsWorkspaceId
            metricCategories: [
              {
                category: 'AllMetrics'
              }
            ]
            logCategoriesAndGroups: [
              {
                categoryGroup: 'allLogs'
              }
            ]
          }
        ]
  }
}

// App Service Plan
module appServicePlan 'br/public:avm/res/web/serverfarm:0.4.1' = {
  name: 'app-service-plan-deployment'
  params: {
    name: resourceNames.appServicePlan
    location: location
    tags: tags
    skuName: 'P0v3'
    reserved: true // Required for Linux
    diagnosticSettings: logAnalyticsWorkspaceId == ''
      ? []
      : [
          {
            name: 'diagnostics'
            workspaceResourceId: logAnalyticsWorkspaceId
            metricCategories: [
              {
                category: 'AllMetrics'
              }
            ]
          }
        ]
  }
}

// Application Insights
module appInsights 'br/public:avm/res/insights/component:0.6.0' = {
  name: 'app-insights-deployment'
  params: {
    name: resourceNames.appInsights
    location: location
    tags: tags
    kind: 'web'
    workspaceResourceId: appInsightsWorkspaceResourceId
    applicationType: 'web'
    samplingPercentage: 0
    retentionInDays: 90
    disableIpMasking: false
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

// API Management
module apiManagement 'br/public:avm/res/api-management/service:0.9.1' = {
  name: 'api-management-deployment'
  params: {
    name: resourceNames.apiManagement
    location: location
    tags: tags
    publisherEmail: publisherEmail
    publisherName: publisherName
    sku: apiManagementSku
    skuCapacity: 2
    virtualNetworkType: 'Internal'
    subnetResourceId: virtualNetwork.outputs.subnetResourceIds[0] // ApimSubnet
    diagnosticSettings: logAnalyticsWorkspaceId == ''
      ? []
      : [
          {
            name: 'diagnostics'
            workspaceResourceId: logAnalyticsWorkspaceId
            metricCategories: [
              {
                category: 'AllMetrics'
              }
            ]
            logCategoriesAndGroups: [
              {
                categoryGroup: 'allLogs'
              }
            ]
          }
        ]
  }
}

// Web App
module webApp 'br/public:avm/res/web/site:0.11.0' = {
  name: 'web-app-deployment'
  params: {
    name: resourceNames.webapp
    location: location
    tags: tags
    kind: 'app,linux'
    serverFarmResourceId: appServicePlan.outputs.resourceId
    virtualNetworkSubnetId: virtualNetwork.outputs.subnetResourceIds[2] // AppServiceOutboundSubnet
    publicNetworkAccess: 'Disabled'
    httpsOnly: true
    appInsightResourceId: appInsights.outputs.resourceId
    appSettingsKeyValuePairs: {
      APPLICATIONINSIGHTS_CONNECTION_STRING: appInsights.outputs.connectionString
      ApplicationInsightsAgent_EXTENSION_VERSION: '~3'
      XDT_MicrosoftApplicationInsights_Mode: 'default'
    }
    siteConfig: {
      ftpsState: webAppSettings.ftpsState
      ipSecurityRestrictionsDefaultAction: webAppSettings.ipRestrictionDefaultAction
      scmIpSecurityRestrictionsDefaultAction: webAppSettings.scmIpRestrictionDefaultAction
      vnetRouteAllEnabled: webAppSettings.vnetRouteAllEnabled
    }
    diagnosticSettings: logAnalyticsWorkspaceId == ''
      ? []
      : [
          {
            name: 'diagnostics'
            workspaceResourceId: logAnalyticsWorkspaceId
            metricCategories: [
              {
                category: 'AllMetrics'
              }
            ]
            logCategoriesAndGroups: [
              {
                categoryGroup: 'allLogs'
              }
              {
                category: 'FunctionAppLogs'
              }
            ]
          }
        ]
  }
}

// API App
module apiApp 'br/public:avm/res/web/site:0.11.0' = {
  name: 'api-app-deployment'
  params: {
    name: resourceNames.apiapp
    location: location
    tags: tags
    kind: 'app,linux'
    serverFarmResourceId: appServicePlan.outputs.resourceId
    virtualNetworkSubnetId: virtualNetwork.outputs.subnetResourceIds[2] // AppServiceOutboundSubnet
    publicNetworkAccess: 'Disabled'
    httpsOnly: true
    appInsightResourceId: appInsights.outputs.resourceId
    appSettingsKeyValuePairs: {
      APPLICATIONINSIGHTS_CONNECTION_STRING: appInsights.outputs.connectionString
      ApplicationInsightsAgent_EXTENSION_VERSION: '~3'
      XDT_MicrosoftApplicationInsights_Mode: 'default'
    }
    siteConfig: {
      ftpsState: webAppSettings.ftpsState
      ipSecurityRestrictionsDefaultAction: webAppSettings.ipRestrictionDefaultAction
      scmIpSecurityRestrictionsDefaultAction: webAppSettings.scmIpRestrictionDefaultAction
      vnetRouteAllEnabled: webAppSettings.vnetRouteAllEnabled
    }
    diagnosticSettings: logAnalyticsWorkspaceId == ''
      ? []
      : [
          {
            name: 'diagnostics'
            workspaceResourceId: logAnalyticsWorkspaceId
            metricCategories: [
              {
                category: 'AllMetrics'
              }
            ]
            logCategoriesAndGroups: [
              {
                categoryGroup: 'allLogs'
              }
              {
                category: 'FunctionAppLogs'
              }
            ]
          }
        ]
  }
}

// Private Endpoints
module openaiPrivateEndpoint 'br/public:avm/res/network/private-endpoint:0.10.1' = {
  name: 'openai-pe-deployment'
  params: {
    name: resourceNames.peOpenAI
    location: location
    tags: tags
    privateLinkServiceConnections: [
      {
        name: 'pse-${resourceNames.peOpenAI}'
        properties: {
          privateLinkServiceId: azureOpenAI.outputs.resourceId
          groupIds: [
            'account'
          ]
        }
      }
    ]
    customNetworkInterfaceName: '${resourceNames.peOpenAI}-nic'
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          groupId: 'account'
          memberName: 'default'
          privateIPAddress: '10.0.3.4'
        }
      }
    ]
    subnetResourceId: virtualNetwork.outputs.subnetResourceIds[3] // PrivateEndpointSubnet
    customDnsConfigs: [
      {
        fqdn: '${resourceNames.azureOpenAI}.openai.azure.com'
        ipAddresses: [
          '10.0.3.4'
        ]
      }
    ]
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        {
          privateDnsZoneResourceId: openaiPrivateDnsZone.outputs.resourceId
        }
      ]
    }
  }
}

module documentIntelligencePrivateEndpoint 'br/public:avm/res/network/private-endpoint:0.10.1' = {
  name: 'docint-pe-deployment'
  params: {
    name: resourceNames.peDocumentIntelligence
    location: location
    tags: tags
    privateLinkServiceConnections: [
      {
        name: 'pse-${resourceNames.peDocumentIntelligence}'
        properties: {
          privateLinkServiceId: documentIntelligence.outputs.resourceId
          groupIds: [
            'account'
          ]
        }
      }
    ]
    customNetworkInterfaceName: '${resourceNames.peDocumentIntelligence}-nic'
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          groupId: 'account'
          memberName: 'default'
          privateIPAddress: '10.0.3.5'
        }
      }
    ]
    subnetResourceId: virtualNetwork.outputs.subnetResourceIds[3] // PrivateEndpointSubnet
    customDnsConfigs: [
      {
        fqdn: '${resourceNames.documentIntelligence}.cognitiveservices.azure.com'
        ipAddresses: [
          '10.0.3.5'
        ]
      }
    ]
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        {
          privateDnsZoneResourceId: docIntelPrivateDnsZone.outputs.resourceId
        }
      ]
    }
  }
}

module searchPrivateEndpoint 'br/public:avm/res/network/private-endpoint:0.10.1' = {
  name: 'search-pe-deployment'
  params: {
    name: resourceNames.peAISearch
    location: location
    tags: tags
    privateLinkServiceConnections: [
      {
        name: 'pse-${resourceNames.peAISearch}'
        properties: {
          privateLinkServiceId: searchService.outputs.resourceId
          groupIds: [
            'searchService'
          ]
        }
      }
    ]
    customNetworkInterfaceName: '${resourceNames.peAISearch}-nic'
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          groupId: 'searchService'
          memberName: 'default'
          privateIPAddress: '10.0.3.6'
        }
      }
    ]
    subnetResourceId: virtualNetwork.outputs.subnetResourceIds[3] // PrivateEndpointSubnet
    customDnsConfigs: [
      {
        fqdn: '${resourceNames.searchService}.search.windows.net'
        ipAddresses: [
          '10.0.3.6'
        ]
      }
    ]
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        {
          privateDnsZoneResourceId: searchPrivateDnsZone.outputs.resourceId
        }
      ]
    }
  }
}

module appServicePrivateEndpoint 'br/public:avm/res/network/private-endpoint:0.10.1' = {
  name: 'appservice-pe-deployment'
  params: {
    name: resourceNames.peAppService
    location: location
    tags: tags
    privateLinkServiceConnections: [
      {
        name: 'pse-${resourceNames.peAppService}'
        properties: {
          privateLinkServiceId: webApp.outputs.resourceId
          groupIds: [
            'sites'
          ]
        }
      }
    ]
    customNetworkInterfaceName: '${resourceNames.peAppService}-nic'
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          groupId: 'sites'
          memberName: 'default'
          privateIPAddress: '10.0.3.7'
        }
      }
    ]
    subnetResourceId: virtualNetwork.outputs.subnetResourceIds[3] // PrivateEndpointSubnet
    customDnsConfigs: [
      {
        fqdn: '${resourceNames.webapp}.azurewebsites.net'
        ipAddresses: [
          '10.0.3.7'
        ]
      }
    ]
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        {
          privateDnsZoneResourceId: sitesPrivateDnsZone.outputs.resourceId
        }
      ]
    }
  }
}

// Outputs
output openAiResourceId string = azureOpenAI.outputs.resourceId
output searchServiceResourceId string = searchService.outputs.resourceId
output documentIntelligenceResourceId string = documentIntelligence.outputs.resourceId
output webAppResourceId string = webApp.outputs.resourceId
output apiAppResourceId string = apiApp.outputs.resourceId
output apiManagementResourceId string = apiManagement.outputs.resourceId
output virtualNetworkResourceId string = virtualNetwork.outputs.resourceId
