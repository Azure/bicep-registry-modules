targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-storage.storageaccounts-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ssawaf'

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
    location: resourceLocation
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}diasa${serviceShort}01'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}'
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
      location: resourceLocation
      name: '${namePrefix}${serviceShort}001'
      skuName: 'Standard_ZRS'
      allowBlobPublicAccess: false
      requireInfrastructureEncryption: true
      largeFileSharesState: 'Enabled'
      enableHierarchicalNamespace: true
      enableSftp: true
      enableNfsV3: true
      privateEndpoints: [
        {
          service: 'blob'
          subnetResourceId: nestedDependencies.outputs.subnetResourceId
          privateDnsZoneGroup: {
            privateDnsZoneGroupConfigs: [
              {
                privateDnsZoneResourceId: nestedDependencies.outputs.privateDNSZoneResourceId
              }
            ]
          }
          tags: {
            'hidden-title': 'This is visible in the resource name'
            Environment: 'Non-Prod'
            Role: 'DeploymentValidation'
          }
        }
      ]
      networkAcls: {
        bypass: 'AzureServices'
        defaultAction: 'Deny'
        virtualNetworkRules: [
          {
            action: 'Allow'
            id: nestedDependencies.outputs.subnetResourceId
          }
        ]
        ipRules: [
          {
            action: 'Allow'
            value: '1.1.1.1'
          }
        ]
      }
      localUsers: [
        {
          storageAccountName: '${namePrefix}${serviceShort}001'
          name: 'testuser'
          hasSharedKey: false
          hasSshKey: true
          hasSshPassword: false
          homeDirectory: 'avdscripts'
          permissionScopes: [
            {
              permissions: 'r'
              service: 'blob'
              resourceName: 'avdscripts'
            }
          ]
        }
      ]
      blobServices: {
        lastAccessTimeTrackingPolicyEnabled: true
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
        containers: [
          {
            name: 'avdscripts'
            enableNfsV3AllSquash: true
            enableNfsV3RootSquash: true
            publicAccess: 'None'
          }
          {
            name: 'archivecontainer'
            publicAccess: 'None'
            metadata: {
              testKey: 'testValue'
            }
            enableWORM: true
            WORMRetention: 666
            allowProtectedAppendWrites: false
          }
        ]
        automaticSnapshotPolicyEnabled: true
        containerDeleteRetentionPolicyEnabled: true
        containerDeleteRetentionPolicyDays: 10
        deleteRetentionPolicyEnabled: true
        deleteRetentionPolicyDays: 9
      }
      fileServices: {
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
        shares: [
          {
            name: 'avdprofiles'
            accessTier: 'Hot'
            shareQuota: 5120
          }
          {
            name: 'avdprofiles2'
            shareQuota: 102400
          }
        ]
      }
      tableServices: {
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
        tables: [
          {
            name: 'table1'
          }
          {
            name: 'table2'
          }
        ]
      }
      queueServices: {
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
        queues: [
          {
            name: 'queue1'
            metadata: {
              key1: 'value1'
              key2: 'value2'
            }
          }
          {
            name: 'queue2'
            metadata: {}
          }
        ]
      }
      sasExpirationPeriod: '180.00:00:00'
      managedIdentities: {
        systemAssigned: true
        userAssignedResourceIds: [
          nestedDependencies.outputs.managedIdentityResourceId
        ]
      }
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
      managementPolicyRules: [
        {
          enabled: true
          name: 'FirstRule'
          type: 'Lifecycle'
          definition: {
            actions: {
              baseBlob: {
                delete: {
                  daysAfterModificationGreaterThan: 30
                }
                tierToCool: {
                  daysAfterLastAccessTimeGreaterThan: 5
                }
              }
            }
            filters: {
              blobIndexMatch: [
                {
                  name: 'BlobIndex'
                  op: '=='
                  value: '1'
                }
              ]
              blobTypes: [
                'blockBlob'
              ]
              prefixMatch: [
                'sample-container/log'
              ]
            }
          }
        }
      ]
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
    dependsOn: [
      nestedDependencies
      diagnosticDependencies
    ]
  }
]
