@description('The location into which the resources should be deployed')
param location string

@minLength(3)
@maxLength(63)
@description('The name of the PostgreSQL server')
param name string = 'psql${uniqueString(resourceGroup().id, subscription().id, location)}'

@minLength(3)
@maxLength(63)
@description('The name of the virtual network')
param vnetName string = 'vnet${uniqueString(resourceGroup().id, subscription().id, location)}'

@description('Database administrator login name')
@minLength(1)
@secure()
param administratorLogin string

@description('Database administrator password')
@minLength(8)
@maxLength(128)
@secure()
param administratorLoginPassword string

@description('The tier of the particular SKU, e.g. Burstable')
@allowed([ 'Burstable', 'GeneralPurpose', 'MemoryOptimized' ])
param postgresFlexibleServersSkuTier string = 'Burstable'

@description('The name of the sku, typically, tier + family + cores, e.g. Standard_D4s_v3')
param postgresFlexibleServersSkuName string = 'Standard_B1ms'

@description('The version of a PostgreSQL server')
@allowed([ '11', '12', '13' ])
param postgresFlexibleServersversion string = '13'

@description('The mode to create a new PostgreSQL server')
@allowed([ 'Create', 'Default', 'PointInTimeRestore', 'Update' ])
param createMode string = 'Default'

@description('The size of the storage in GB')
@allowed([ 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384 ])
param storageSizeGB int = 32

@description('The number of days a backup is retained')
@minValue(7)
@maxValue(35)
param backupRetentionDays int = 7

@description('The geo-redundant backup setting')
@allowed([ 'Enabled', 'Disabled' ])
param geoRedundantBackup string = 'Disabled'

@description('The high availability mode')
@allowed([ 'Disabled', 'Enabled' ])
param highAvailability string = 'Disabled'

@description('Enable Azure Active Directory based authentication')
param aadEnabled bool = false

@description('The Azure Active Directory data')
param aadData object = {}

@description('The resource group containing  the virtual network.')
param vnetResourceGroup string = resourceGroup().name

var privateDNSZoneName = '${vnetName}.private.postgres.database.azure.com'
var privateDNSZoneLinkName = '${vnetName}privatelink'

@description('Chose to use a new or existing virtual network')
@allowed([ 'new', 'existing', 'none' ])
param newOrExistingVnet string = 'none'

resource newVirtualNetwork 'Microsoft.Network/virtualNetworks@2021-08-01' = if (newOrExistingVnet == 'new') {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'appNet'
        properties: {
          addressPrefix: '10.0.0.0/24'
          delegations: [
            {
              name: 'appDelegation'
              properties: {
                serviceName: 'Microsoft.Web/serverfarms'
              }
            }
          ]
        }
      }
      {
        name: 'dbNet'
        properties: {
          addressPrefix: '10.0.1.0/24'
          delegations: [
            {
              name: 'dbDelegation'
              properties: {
                serviceName: 'Microsoft.DBforPostgreSQL/flexibleServers'
              }
            }
          ]
        }
      }
    ]
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-08-01' existing = {
  name: vnetName
  scope: resourceGroup(vnetResourceGroup)
}

resource privateDNSZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDNSZoneName
  location: 'global'
  dependsOn: [
    newVirtualNetwork
  ]

  resource privateDNSZoneRecordA 'A' = {
    name: uniqueString(name)
    properties: {
      ttl: 30
      aRecords: [
        {
          ipv4Address: '10.0.1.4'
        }
      ]
    }
  }

  resource privateDNSZoneLink 'virtualNetworkLinks' = {
    name: privateDNSZoneLinkName
    location: 'global'
    properties: {
      registrationEnabled: true
      virtualNetwork: {
        id: virtualNetwork.id
      }
    }
  }
}

resource postgresFlexibleServers 'Microsoft.DBforPostgreSQL/flexibleServers@2022-12-01' = {
  name: name
  location: location
  sku: {
    name: postgresFlexibleServersSkuName
    tier: postgresFlexibleServersSkuTier
  }
  dependsOn: [
    privateDNSZone::privateDNSZoneLink
  ]
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    createMode: createMode
    network: newOrExistingVnet == 'none' ? null : {
      delegatedSubnetResourceId: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetwork.name, 'dbNet')
      privateDnsZoneArmResourceId: privateDNSZone.id
    }
    storage: {
      storageSizeGB: storageSizeGB
    }
    backup: {
      backupRetentionDays: backupRetentionDays
      geoRedundantBackup: geoRedundantBackup
    }
    highAvailability: {
      mode: highAvailability
    }
    maintenanceWindow: {
      customWindow: 'Disabled'
      dayOfWeek: 0
      startHour: 0
      startMinute: 0
    }
    version: postgresFlexibleServersversion
  }

  resource administrators 'administrators' = if (aadEnabled) {
    name: contains(aadData, 'objectId') ? aadData.objectId : ''
    properties: {
      tenantId: contains(aadData, 'tenantId') ? aadData.tenantId : ''
      principalName: contains(aadData, 'principalName') ? aadData.principalName : ''
      principalType: contains(aadData, 'principalType') ? aadData.principalType : ''
    }
  }
}
