// ========== //
// Parameters //
// ========== //

param location string = resourceGroup().location
param serviceShort string = 'acr'

// ============ //
// Dependencies //
// ============ //

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: 'adpsxxazsa${serviceShort}01'
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  location: location
  properties: {
    allowBlobPublicAccess: false
  }
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' = {
  name: 'adp-sxx-law-${serviceShort}-01'
  location: location
}

resource eventHubNamespace 'Microsoft.EventHub/namespaces@2021-11-01' = {
  name: 'adp-sxx-evhns-${serviceShort}-01'
  location: location

  resource eventHub 'eventhubs@2021-11-01' = {
    name: 'adp-sxx-evh-${serviceShort}-01'
  }

  resource authorizationRule 'authorizationRules@2021-06-01-preview' = {
    name: 'RootManageSharedAccessKey'
    properties: {
      rights: [
        'Listen'
        'Manage'
        'Send'
      ]
    }
  }
}

// ===== //
// Tests //
// ===== //

// Test 01 - Basic SKU - Minimal Params
module test_01 '../main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-01'
  params: {
    name: 'test01${uniqueString(deployment().name, location)}'
    location: location
  }
}

// Test 02 - Standard SKU - Some basic parmas
module test_02 '../main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-02'
  params: {
    name: 'test02${uniqueString(deployment().name, location)}'
    location: location
    skuName: 'Standard'
    adminUserEnabled: true
    tags: {
      tag1: 'tag1value'
      tag2: 'tag2value'
    }
  }
}

// Test 03 - Premium Test - Network Rules
module test_03 '../main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-03'
  params: {
    name: 'test03${uniqueString(deployment().name, location)}'
    location: location
    skuName: 'Premium'
    publicNetworkAccessEnabled: false
    publicAzureAccessEnabled: false
    networkAllowedIpRanges: [
      '20.112.52.29'
      '20.53.203.50'
    ]
  }
}

// Test 04 - Premium Test - Private Endpoint
module test_04 '../main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-04'
  params: {
    name: 'test04${uniqueString(deployment().name, location)}'
    location: location
    skuName: 'Premium'

  }
}

// Test 05 - Premium Test - Diagnostic Settings
module test_05 '../main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-05'
  params: {
    name: 'test05${uniqueString(deployment().name, location)}'
    location: location
    skuName: 'Premium'

  }
}
