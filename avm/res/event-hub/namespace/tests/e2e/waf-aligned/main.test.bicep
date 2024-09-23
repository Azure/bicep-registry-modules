targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-eventhub.namespaces-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ehnwaf'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    storageAccountName: 'dep${namePrefix}sa${serviceShort}'
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}diasa${serviceShort}03'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}01'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}01'
    location: resourceLocation
  }
}

// ============== //
// Test Execution //
// ============== //
@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      location: resourceLocation
      skuName: 'Standard'
      skuCapacity: 2
      authorizationRules: [
        {
          name: 'RootManageSharedAccessKey'
          rights: [
            'Listen'
            'Manage'
            'Send'
          ]
        }
        {
          name: 'SendListenAccess'
          rights: [
            'Listen'
            'Send'
          ]
        }
      ]
      diagnosticSettings: [
        {
          name: 'customSetting'
          metricCategories: [
            {
              category: 'AllMetrics'
            }
          ]
          eventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
          eventHubAuthorizationRuleResourceId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
          storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
          workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
        }
      ]
      eventhubs: [
        {
          name: '${namePrefix}-az-evh-x-001'
        }
        {
          name: '${namePrefix}-az-evh-x-002'
          authorizationRules: [
            {
              name: 'RootManageSharedAccessKey'
              rights: [
                'Listen'
                'Manage'
                'Send'
              ]
            }
            {
              name: 'SendListenAccess'
              rights: [
                'Listen'
                'Send'
              ]
            }
          ]
          captureDescriptionDestinationArchiveNameFormat: '{Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}'
          captureDescriptionDestinationBlobContainer: 'eventhub'
          captureDescriptionDestinationName: 'EventHubArchive.AzureBlockBlob'
          captureDescriptionDestinationStorageAccountResourceId: nestedDependencies.outputs.storageAccountResourceId
          captureDescriptionEnabled: true
          captureDescriptionEncoding: 'Avro'
          captureDescriptionIntervalInSeconds: 300
          captureDescriptionSizeLimitInBytes: 314572800
          captureDescriptionSkipEmptyArchives: true
          consumergroups: [
            {
              name: 'custom'
              userMetadata: 'customMetadata'
            }
          ]
          messageRetentionInDays: 1
          partitionCount: 2
          status: 'Active'
          retentionDescriptionCleanupPolicy: 'Delete'
          retentionDescriptionRetentionTimeInHours: 3
        }
        {
          name: '${namePrefix}-az-evh-x-003'
          retentionDescriptionCleanupPolicy: 'Compact'
          retentionDescriptionTombstoneRetentionTimeInHours: 24
        }
      ]
      networkRuleSets: {
        defaultAction: 'Deny'
        ipRules: [
          {
            action: 'Allow'
            ipMask: '10.10.10.10'
          }
        ]
        trustedServiceAccessEnabled: false
        virtualNetworkRules: [
          {
            ignoreMissingVnetServiceEndpoint: true
            subnetResourceId: nestedDependencies.outputs.subnetResourceId
          }
        ]
      }
      privateEndpoints: [
        {
          privateDnsZoneGroup: {
            privateDnsZoneGroupConfigs: [
              {
                privateDnsZoneResourceId: nestedDependencies.outputs.privateDNSZoneResourceId
              }
            ]
          }
          subnetResourceId: nestedDependencies.outputs.subnetResourceId
          tags: {
            'hidden-title': 'This is visible in the resource name'
            Environment: 'Non-Prod'
            Role: 'DeploymentValidation'
          }
        }
      ]
      kafkaEnabled: true
      disableLocalAuth: true
      isAutoInflateEnabled: true
      minimumTlsVersion: '1.2'
      maximumThroughputUnits: 4
      publicNetworkAccess: 'Disabled'
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
  }
]
