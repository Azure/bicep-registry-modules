metadata name = 'PaaS ASE with CosmosDB Tier 4'
metadata description = 'Creates a PaaS ASE with CosmosDB Tier 4 resiliency configuration.'

// ================ //
// Parameters       //
// ================ //
// @description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
// param enableDefaultTelemetry bool = true
@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Required. The name of the deployment.')
param name string

@description('Optional. Suffix for all resources.')
param suffix string = ''

// Common Parameters

@description('Optional. Tags of the resource.')
param tags object = {}

// Network Parameters

@description('Optional. Virtual Network address space.')
param vNetAddressPrefix string = '192.168.250.0/23'

@description('Optional. Default subnet address prefix.')
param defaultSubnetAddressPrefix string = '192.168.250.0/24'

@description('Optional. PrivateEndpoint subnet address prefix.')
param privateEndpointSubnetAddressPrefix string = '192.168.251.0/24'

// Resources

// // Telemetry - AVS (SFR1)
// // Using placeholder telemetry GUID
// var telemetryId = 'pid-00000000-0000-0000-0000-000000000000'
// resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
//   name: '${telemetryId}-${uniqueString(deployment().name, location)}'
//   properties: {
//     mode: 'Incremental'
//     template: {
//       '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
//       contentVersion: '1.0.0.0'
//       resources: []
//     }
//   }
// }

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.app-paasasecosmosdbt4.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

module defaultNsg 'br/public:avm/res/network/network-security-group:0.5.1' = {
  name: 'defaultNsg-${uniqueString(deployment().name, location)}'
  params: {
    name: '${name}-default-nsg-${suffix}'
    location: location
    tags: tags
    securityRules: []
    enableTelemetry: enableTelemetry
  }
}

module privateEndpointNsg 'br/public:avm/res/network/network-security-group:0.5.1' = {
  name: 'privateEndpointNsg-${uniqueString(deployment().name, location)}'
  params: {
    name: '${name}-privateendpointsubnet-nsg-${suffix}'
    location: location
    tags: tags
    securityRules: []
    enableTelemetry: enableTelemetry
  }
}

// Virtual Network

module vnet 'br/public:avm/res/network/virtual-network:0.7.0' = {
  name: 'vnet-${uniqueString(deployment().name, location)}'
  params: {
    name: '${name}-vNet-${suffix}'
    location: location
    tags: tags
    addressPrefixes: [
      vNetAddressPrefix
    ]
    subnets: [
      {
        name: 'default'
        addressPrefix: defaultSubnetAddressPrefix
        networkSecurityGroupResourceId: defaultNsg.outputs.resourceId
        delegation: 'Microsoft.Web/hostingEnvironments'
        privateEndpointNetworkPolicies: 'Disabled'
        privateLinkServiceNetworkPolicies: 'Enabled'
      }
      {
        name: 'PrivateEndpointSubnet'
        addressPrefix: privateEndpointSubnetAddressPrefix
        networkSecurityGroupResourceId: privateEndpointNsg.outputs.resourceId
        privateEndpointNetworkPolicies: 'Disabled'
        privateLinkServiceNetworkPolicies: 'Enabled'
      }
    ]
    enableTelemetry: enableTelemetry
  }
}

// Private DNS Zones

module appServicePrivateDnsZone 'br/public:avm/res/network/private-dns-zone:0.7.1' = {
  name: 'appServicePrivateDnsZone-${uniqueString(deployment().name, location)}'
  params: {
    name: '${name}.appserviceenvironment.net'
    location: 'global'
    tags: tags
    virtualNetworkLinks: [
      {
        name: 'vnetlink'
        virtualNetworkResourceId: vnet.outputs.resourceId
        registrationEnabled: false
      }
    ]
    enableTelemetry: enableTelemetry
  }
}

module cosmosdbPrivateDnsZone 'br/public:avm/res/network/private-dns-zone:0.7.1' = {
  name: 'cosmosdbPrivateDnsZone-${uniqueString(deployment().name, location)}'
  params: {
    name: 'privatelink.documents.azure.com'
    location: 'global'
    tags: tags
    virtualNetworkLinks: [
      {
        name: 'oxlypsb573er6'
        virtualNetworkResourceId: vnet.outputs.resourceId
        registrationEnabled: false
      }
    ]
    enableTelemetry: enableTelemetry
  }
}

module redisPrivateDnsZone 'br/public:avm/res/network/private-dns-zone:0.7.1' = {
  name: 'redisPrivateDnsZone-${uniqueString(deployment().name, location)}'
  params: {
    name: 'privatelink.redis.cache.windows.net'
    location: 'global'
    tags: tags
    virtualNetworkLinks: [
      {
        name: 'oxlypsb573er6'
        virtualNetworkResourceId: vnet.outputs.resourceId
        registrationEnabled: false
      }
    ]
    enableTelemetry: enableTelemetry
  }
}

// App Service Environment

module ase 'br/public:avm/res/web/hosting-environment:0.4.0' = {
  name: 'ase-${uniqueString(deployment().name, location)}'
  params: {
    name: '${name}-${suffix}'
    location: location
    tags: tags
    kind: 'ASEv3'
    internalLoadBalancingMode: 'Web, Publishing'
    // Worker pool configuration is defined in clusterSettings
    clusterSettings: [
      {
        name: 'WorkerSize'
        value: 'Standard_D2d_v4'
      }
    ]
    customDnsSuffix: '${name}.appserviceenvironment.net'
    networkConfiguration: {
      frontEndScaleFactor: 15
      upgradePreference: 'None'
      zoneRedundant: false
    }
    subnetResourceId: vnet.outputs.subnetResourceIds[0]
    enableTelemetry: enableTelemetry
  }
}

// App Service Plan

module asp 'br/public:avm/res/web/serverfarm:0.4.1' = {
  name: 'asp-${uniqueString(deployment().name, location)}'
  params: {
    name: '${name}-asp-${suffix}'
    location: location
    tags: tags
    kind: 'linux'
    skuName: 'S1'
    skuCapacity: 1
    appServiceEnvironmentId: ase.outputs.resourceId
    enableTelemetry: enableTelemetry
  }
}

// CosmosDB Account

module cosmosdbAccount 'br/public:avm/res/document-db/database-account:0.15.0' = {
  name: 'cosmosdbAccount-${uniqueString(deployment().name, location)}'
  params: {
    name: '${name}-cosmos-${suffix}'
    location: location
    tags: tags
    defaultConsistencyLevel: 'Session'

    capabilitiesToAdd: [
      'EnableServerless'
    ]

    failoverLocations: [
      {
        locationName: location
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]

    maxStalenessPrefix: 100
    maxIntervalInSeconds: 5

    networkRestrictions: {
      publicNetworkAccess: 'Disabled'
    }

    sqlDatabases: [
      {
        name: '${name}-cosmosdb'
        containers: [
          {
            name: 'defaultContainer'
            paths: [
              '/partitionKey'
            ]
          }
        ]
      }
    ]
    enableTelemetry: enableTelemetry
  }
}

// SQL Private Endpoint

module cosmosdbPrivateEndpoint 'br/public:avm/res/network/private-endpoint:0.11.0' = {
  name: 'cosmosdbPrivateEndpoint-${uniqueString(deployment().name, location)}'
  params: {
    name: '${name}-CosmosPrivateEndpoint-${suffix}'
    location: location
    tags: tags
    subnetResourceId: vnet.outputs.subnetResourceIds[1]
    privateLinkServiceConnections: [
      {
        name: 'CosmosPrivateEndpoint'
        properties: {
          privateLinkServiceId: cosmosdbAccount.outputs.resourceId
          groupIds: [
            'Sql'
          ]
          requestMessage: 'Auto-approved'
        }
      }
    ]
    customDnsConfigs: [
      {
        fqdn: '${name}-cosmos.documents.azure.com'
        ipAddresses: [
          '192.168.251.4'
        ]
      }
    ]
    customNetworkInterfaceName: '${name}-CosmosPrivateEndpoint-nic-${suffix}'
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        {
          name: 'default'
          privateDnsZoneResourceId: cosmosdbPrivateDnsZone.outputs.resourceId
        }
      ]
    }
    enableTelemetry: enableTelemetry
  }
}

// Redis Cache

module redis 'br/public:avm/res/cache/redis:0.15.0' = {
  name: 'redis-${uniqueString(deployment().name, location)}'
  params: {
    name: '${name}-redis-${suffix}'
    location: location
    tags: tags
    skuName: 'Basic'
    capacity: 0
    enableNonSslPort: false
    minimumTlsVersion: '1.2'
    publicNetworkAccess: 'Disabled'
    redisVersion: '6'
    privateEndpoints: [
      {
        name: '${name}-ReddisPrivateEndpoint-${suffix}'
        subnetResourceId: vnet.outputs.subnetResourceIds[1]
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              name: 'default'
              privateDnsZoneResourceId: redisPrivateDnsZone.outputs.resourceId
            }
          ]
        }
        customNetworkInterfaceName: '${name}-ReddisPrivateEndpoint-nic-${suffix}'
      }
    ]
    enableTelemetry: enableTelemetry
  }
}

// Outputs

@description('The resource ID of the virtual network.')
output vnetResourceId string = vnet.outputs.resourceId

@description('The resource ID of the CosmosDB account.')
output cosmosDbResourceId string = cosmosdbAccount.outputs.resourceId

@description('The resource ID of the Redis cache.')
output redisCacheResourceId string = redis.outputs.resourceId

// @description('The resource ID of the App Service Environment.')
// output appServiceEnvironmentResourceId string = ase.outputs.resourceId

// @description('The resource ID of the App Service Plan.')
// output appServicePlanResourceId string = asp.outputs.resourceId

@description('Resource. Resource Group Name.')
output resourceGroupName string = resourceGroup().name
