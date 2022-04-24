// ========== //
// Parameters //
// ========== //

// Shared
@description('Optional. The location to deploy resources to')
param location string = resourceGroup().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints')
param serviceShort string = 'strg'

// ========== //
// Test Setup //
// ========== //

// General resources
// =================
resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: 'dep-${serviceShort}-az-msi-x-01'
  location: location
}

// Diagnostics
// ===========
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: 'adpcarmlazsa${serviceShort}01'
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    allowBlobPublicAccess: false
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: 'adp-carml-vnet-${serviceShort}-01'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'carml-az-subnet-x-001'
        properties: {
          addressPrefix: '10.0.0.0/24'
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
            }
          ]
        }
      }
      {
        name: 'carml-az-subnet-x-002-privateEndpoints'
        properties: {
          addressPrefix: '10.0.1.0/24'
          privateEndpointNetworkPolicies: 'Disabled'
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
            }
          ]
        }
      }
    ]
  }
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' = {
  name: 'adp-carml-law-${serviceShort}-01'
  location: location
}

resource eventHubNamespace 'Microsoft.EventHub/namespaces@2021-11-01' = {
  name: 'adp-carml-evhns-${serviceShort}-01'
  location: location

  resource eventHub 'eventhubs@2021-11-01' = {
    name: 'adp-carml-evh-${serviceShort}-01'
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

// ============== //
// Test Execution //
// ============== //

// TEST 1 - MIN
module minstrg '../main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-minstrg'
  params: {
    name: '${serviceShort}azsamin001'
    location: location
    allowBlobPublicAccess: false
  }
}

// TEST 2 - Storage V1
module v1strg '../main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-v1strg'
  params: {
    name: '${serviceShort}azsav1001'
    location: location
    storageAccountKind: 'Storage'
    allowBlobPublicAccess: false
  }
}

// TEST 3 - NFS
module nfsstrg '../main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-nfsstrg'
  params: {
    name: '${serviceShort}azsax001'
    location: location
    storageAccountSku: 'Premium_LRS'
    storageAccountKind: 'FileStorage'
    allowBlobPublicAccess: false
    supportsHttpsTrafficOnly: false
    fileServices: {
      shares: [
        {
          name: 'nfsfileshare'
          enabledProtocols: 'NFS'
        }
      ]
    }
  }
}

// TEST 4 - Default
module defstrg '../main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-defstrg'
  params: {
    name: '${serviceShort}azsax002'
    location: location
    storageAccountSku: 'Standard_LRS'
    publicNetworkAccess: 'Disabled'
    allowBlobPublicAccess: false
    supportsHttpsTrafficOnly: false
    requireInfrastructureEncryption: true
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      virtualNetworkRules: [
        {
          id: virtualNetwork.properties.subnets[0].id
          action: 'Allow'
        }
      ]
      ipRules: [
        {
            action: 'Allow'
            value: '1.1.1.1'
        }
      ]
    }
    privateEndpoints: [
      {
        subnetResourceId: virtualNetwork.properties.subnets[1].id
        service: 'blob'
      }
      {
        subnetResourceId: virtualNetwork.properties.subnets[1].id
        service: 'table'
      }
      {
        subnetResourceId: virtualNetwork.properties.subnets[1].id
        service: 'queue'
      }
      {
        subnetResourceId: virtualNetwork.properties.subnets[1].id
        service: 'file'
      }
    ]
    blobServices: {
      diagnosticLogsRetentionInDays: 7
      diagnosticStorageAccountId: storageAccount.id
      diagnosticWorkspaceId: logAnalyticsWorkspace.id
      diagnosticEventHubAuthorizationRuleId: eventHubNamespace::authorizationRule.id
      diagnosticEventHubName: eventHubNamespace::eventHub.name
      containers: [
        {
          name: 'avdscripts'
          publicAccess: 'None'
          roleAssignments: [
            {
              roleDefinitionIdOrName: 'Reader'
              principalIds: [
                managedIdentity.properties.principalId
              ]
              principalType: 'ServicePrincipal'
            }
          ]
        }
        {
          name: 'archivecontainer'
          publicAccess: 'None'
          enableWORM: true
          WORMRetention: 666
          allowProtectedAppendWrites: false
        }
      ]
    }
    fileServices: {
      diagnosticLogsRetentionInDays: 7
      diagnosticStorageAccountId: storageAccount.id
      diagnosticWorkspaceId: logAnalyticsWorkspace.id
      diagnosticEventHubAuthorizationRuleId: eventHubNamespace::authorizationRule.id
      diagnosticEventHubName: eventHubNamespace::eventHub.name
      shares: [
        {
          name: 'avdprofiles'
          shareQuota: '5120'
          roleAssignments: [
            {
              roleDefinitionIdOrName: 'Reader'
              principalIds: [
                managedIdentity.properties.principalId
              ]
              principalType: 'ServicePrincipal'
            }
          ]
        }
        {
          name: 'avdprofiles2'
          shareQuota: '5120'
        }
      ]
    }
    tableServices: {
      diagnosticLogsRetentionInDays: 7
      diagnosticStorageAccountId: storageAccount.id
      diagnosticWorkspaceId: logAnalyticsWorkspace.id
      diagnosticEventHubAuthorizationRuleId: eventHubNamespace::authorizationRule.id
      diagnosticEventHubName: eventHubNamespace::eventHub.name
      tables: [
        'table1'
        'table2'
      ]
    }
    queueServices: {
      diagnosticLogsRetentionInDays: 7
      diagnosticStorageAccountId: storageAccount.id
      diagnosticWorkspaceId: logAnalyticsWorkspace.id
      diagnosticEventHubAuthorizationRuleId: eventHubNamespace::authorizationRule.id
      diagnosticEventHubName: eventHubNamespace::eventHub.name
      queues: [
        {
          name: 'queue1'
          metadata: {}
          roleAssignments: [
            {
              roleDefinitionIdOrName: 'Reader'
              principalIds: [
                managedIdentity.properties.principalId
              ]
              principalType: 'ServicePrincipal'
            }
          ]
        }
        {
          name: 'queue2'
          metadata: {}
        }
      ]
    }
    systemAssignedIdentity: true
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          managedIdentity.properties.principalId
        ]
        principalType: 'ServicePrincipal'
      }
    ]
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: storageAccount.id
    diagnosticWorkspaceId: logAnalyticsWorkspace.id
    diagnosticEventHubAuthorizationRuleId: eventHubNamespace::authorizationRule.id
    diagnosticEventHubName: eventHubNamespace::eventHub.name
  }
}
