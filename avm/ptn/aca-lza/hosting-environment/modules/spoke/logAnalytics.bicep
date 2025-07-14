targetScope = 'resourceGroup'
@description('Required. The resource names definition')
param resourcesNames object

@description('The location where the resources will be created. This should be the same region as the hub.')
param location string

@description('Optional. The tags to be assigned to the created resources.')
param tags object = {}

// Location pairs mapping for replication (no primary == secondary)
var locationPairs = {
  // North America
  canadacentral: 'centralus'
  canadaeast: 'canadacentral'
  centralus: 'eastus'
  eastus: 'eastus2'
  eastus2: 'eastus'
  northcentralus: 'centralus'
  southcentralus: 'westus'
  westcentralus: 'westus'
  westus: 'westus2'
  westus2: 'westus'
  westus3: 'westus2'
  // South America
  brazilsouth: 'brazilsoutheast'
  brazilsoutheast: 'brazilsouth'
  // Europe
  francecentral: 'westeurope'
  francesouth: 'francecentral'
  germanynorth: 'northeurope'
  germanywestcentral: 'germanynorth'
  italynorth: 'francecentral'
  northeurope: 'westeurope'
  norwayeast: 'northeurope'
  norwaywest: 'northeurope'
  polandcentral: 'northeurope'
  southuk: 'westeurope'
  spaincentral: 'francecentral'
  swedencentral: 'northeurope'
  swedensouth: 'swedencentral'
  switzerlandnorth: 'westeurope'
  switzerlandwest: 'westeurope'
  westeurope: 'northeurope'
  westuk: 'southuk'
  // Middle East
  qatarcentral: 'uaecentral'
  uaecentral: 'uaenorth'
  uaenorth: 'qatarcentral'
  // India
  centralindia: 'southindia'
  southindia: 'centralindia'
  // Asia Pacific
  eastasia: 'southeastasia'
  japaneast: 'japanwest'
  japanwest: 'japaneast'
  koreacentral: 'koreasouth'
  koreasouth: 'koreacentral'
  southeastasia: 'eastasia'
  // Oceania
  australiacentral: 'australiaeast'
  australiacentral2: 'australiacentral'
  australiaeast: 'australiasoutheast'
  australiasoutheast: 'australiaeast'
  // Africa
  southafricanorth: 'southafricawest'
  southafricawest: 'southafricanorth'
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2025-02-01' = {
  name: resourcesNames.logAnalyticsWorkspace
  location: location
  tags: tags
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
    features: {
      searchVersion: '2'
    }
    replication: {
      enabled: true
      location: locationPairs[location]
    }
  }
}

output resourceId string = logAnalyticsWorkspace.id
