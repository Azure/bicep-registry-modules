targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-storage.storageaccounts-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ssamax'

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
module diagnosticDependencies '../../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
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
      skuName: 'Standard_LRS'
      allowBlobPublicAccess: false
      requireInfrastructureEncryption: true
      largeFileSharesState: 'Enabled'
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
      enableHierarchicalNamespace: true
      enableSftp: true
      enableNfsV3: true
      privateEndpoints: [
        {
          service: 'blob'
          subnetResourceId: nestedDependencies.outputs.customSubnet1ResourceId
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
        {
          service: 'blob'
          subnetResourceId: nestedDependencies.outputs.customSubnet2ResourceId
          privateDnsZoneGroup: {
            privateDnsZoneGroupConfigs: [
              {
                privateDnsZoneResourceId: nestedDependencies.outputs.privateDNSZoneResourceId
              }
            ]
          }
        }
        {
          privateDnsZoneGroup: {
            privateDnsZoneGroupConfigs: [
              {
                privateDnsZoneResourceId: nestedDependencies.outputs.privateDNSZoneResourceId
              }
            ]
          }
          subnetResourceId: nestedDependencies.outputs.customSubnet1ResourceId
          service: 'table'
        }
        {
          privateDnsZoneGroup: {
            privateDnsZoneGroupConfigs: [
              {
                privateDnsZoneResourceId: nestedDependencies.outputs.privateDNSZoneResourceId
              }
            ]
          }
          subnetResourceId: nestedDependencies.outputs.customSubnet1ResourceId
          service: 'queue'
        }
        {
          privateDnsZoneGroup: {
            privateDnsZoneGroupConfigs: [
              {
                privateDnsZoneResourceId: nestedDependencies.outputs.privateDNSZoneResourceId
              }
            ]
          }
          subnetResourceId: nestedDependencies.outputs.customSubnet1ResourceId
          service: 'file'
        }
        {
          privateDnsZoneGroup: {
            privateDnsZoneGroupConfigs: [
              {
                privateDnsZoneResourceId: nestedDependencies.outputs.privateDNSZoneResourceId
              }
            ]
          }
          subnetResourceId: nestedDependencies.outputs.customSubnet1ResourceId
          service: 'web'
        }
        {
          privateDnsZoneGroup: {
            privateDnsZoneGroupConfigs: [
              {
                privateDnsZoneResourceId: nestedDependencies.outputs.privateDNSZoneResourceId
              }
            ]
          }
          subnetResourceId: nestedDependencies.outputs.customSubnet1ResourceId
          service: 'dfs'
        }
      ]
      networkAcls: {
        resourceAccessRules: [
          {
            tenantId: subscription().tenantId
            resourceId: '/subscriptions/${subscription().subscriptionId}/resourceGroups/*/providers/Microsoft.ContainerRegistry/registries/*'
          }
        ]
        bypass: 'AzureServices'
        defaultAction: 'Deny'
        virtualNetworkRules: [
          {
            action: 'Allow'
            id: nestedDependencies.outputs.defaultSubnetResourceId
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
            roleAssignments: [
              {
                roleDefinitionIdOrName: 'Owner'
                principalId: nestedDependencies.outputs.managedIdentityPrincipalId
                principalType: 'ServicePrincipal'
              }
              {
                roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
                principalId: nestedDependencies.outputs.managedIdentityPrincipalId
                principalType: 'ServicePrincipal'
              }
              {
                roleDefinitionIdOrName: subscriptionResourceId(
                  'Microsoft.Authorization/roleDefinitions',
                  'acdd72a7-3385-48ef-bd42-f606fba81ae7'
                )
                principalId: nestedDependencies.outputs.managedIdentityPrincipalId
                principalType: 'ServicePrincipal'
              }
            ]
          }
          {
            name: 'archivecontainer'
            publicAccess: 'None'
            metadata: {
              testKey: 'testValue'
            }
            allowProtectedAppendWrites: false
          }
        ]
        automaticSnapshotPolicyEnabled: true
        containerDeleteRetentionPolicyEnabled: true
        containerDeleteRetentionPolicyDays: 10
        deleteRetentionPolicyEnabled: true
        deleteRetentionPolicyDays: 9
        corsRules: [
          {
            allowedHeaders: [
              'x-ms-meta-data'
              'x-ms-meta-target-path'
              'x-ms-meta-source-path'
            ]
            exposedHeaders: [
              'x-ms-meta-data'
              'x-ms-meta-target-path'
              'x-ms-meta-source-path'
            ]
            allowedOrigins: [
              'http://*.contoso.com'
              'http://www.fabrikam.com'
            ]
            allowedMethods: [
              'GET'
              'PUT'
            ]
            maxAgeInSeconds: 200
          }
        ]
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
            roleAssignments: [
              {
                name: 'cff1213b-7877-4425-b67c-bb1de8950dfb'
                roleDefinitionIdOrName: 'Owner'
                principalId: nestedDependencies.outputs.managedIdentityPrincipalId
                principalType: 'ServicePrincipal'
              }
              {
                name: guid('Custom seed ${namePrefix}${serviceShort}-share-avdprofiles')
                roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
                principalId: nestedDependencies.outputs.managedIdentityPrincipalId
                principalType: 'ServicePrincipal'
              }
              {
                roleDefinitionIdOrName: subscriptionResourceId(
                  'Microsoft.Authorization/roleDefinitions',
                  'acdd72a7-3385-48ef-bd42-f606fba81ae7'
                )
                principalId: nestedDependencies.outputs.managedIdentityPrincipalId
                principalType: 'ServicePrincipal'
              }
            ]
          }
          {
            name: 'avdprofiles2'
            shareQuota: 102400
          }
        ]
        corsRules: [
          {
            allowedHeaders: [
              'x-ms-meta-data'
              'x-ms-meta-target-path'
              'x-ms-meta-source-path'
            ]
            exposedHeaders: [
              'x-ms-meta-data'
              'x-ms-meta-target-path'
              'x-ms-meta-source-path'
            ]
            allowedOrigins: [
              'http://*.contoso.com'
              'http://www.fabrikam.com'
            ]
            allowedMethods: [
              'GET'
              'PUT'
            ]
            maxAgeInSeconds: 200
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
            roleAssignments: [
              {
                roleDefinitionIdOrName: 'Owner'
                principalId: nestedDependencies.outputs.managedIdentityPrincipalId
                principalType: 'ServicePrincipal'
              }
              {
                roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
                principalId: nestedDependencies.outputs.managedIdentityPrincipalId
                principalType: 'ServicePrincipal'
              }
              {
                roleDefinitionIdOrName: subscriptionResourceId(
                  'Microsoft.Authorization/roleDefinitions',
                  'acdd72a7-3385-48ef-bd42-f606fba81ae7'
                )
                principalId: nestedDependencies.outputs.managedIdentityPrincipalId
                principalType: 'ServicePrincipal'
              }
            ]
          }
          {
            name: 'table2'
            roleAssignments: [
              {
                roleDefinitionIdOrName: 'Owner'
                principalId: nestedDependencies.outputs.managedIdentityPrincipalId
                principalType: 'ServicePrincipal'
              }
              {
                roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
                principalId: nestedDependencies.outputs.managedIdentityPrincipalId
                principalType: 'ServicePrincipal'
              }
              {
                roleDefinitionIdOrName: subscriptionResourceId(
                  'Microsoft.Authorization/roleDefinitions',
                  'acdd72a7-3385-48ef-bd42-f606fba81ae7'
                )
                principalId: nestedDependencies.outputs.managedIdentityPrincipalId
                principalType: 'ServicePrincipal'
              }
            ]
          }
        ]
        corsRules: [
          {
            allowedHeaders: [
              'x-ms-meta-data'
              'x-ms-meta-target-path'
              'x-ms-meta-source-path'
            ]
            exposedHeaders: [
              'x-ms-meta-data'
              'x-ms-meta-target-path'
              'x-ms-meta-source-path'
            ]
            allowedOrigins: [
              'http://*.contoso.com'
              'http://www.fabrikam.com'
            ]
            allowedMethods: [
              'GET'
              'PUT'
            ]
            maxAgeInSeconds: 200
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
            roleAssignments: [
              {
                roleDefinitionIdOrName: 'Owner'
                principalId: nestedDependencies.outputs.managedIdentityPrincipalId
                principalType: 'ServicePrincipal'
              }
              {
                roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
                principalId: nestedDependencies.outputs.managedIdentityPrincipalId
                principalType: 'ServicePrincipal'
              }
              {
                roleDefinitionIdOrName: subscriptionResourceId(
                  'Microsoft.Authorization/roleDefinitions',
                  'acdd72a7-3385-48ef-bd42-f606fba81ae7'
                )
                principalId: nestedDependencies.outputs.managedIdentityPrincipalId
                principalType: 'ServicePrincipal'
              }
            ]
          }
          {
            name: 'queue2'
            metadata: {}
          }
        ]
        corsRules: [
          {
            allowedHeaders: [
              'x-ms-meta-data'
              'x-ms-meta-target-path'
              'x-ms-meta-source-path'
            ]
            exposedHeaders: [
              'x-ms-meta-data'
              'x-ms-meta-target-path'
              'x-ms-meta-source-path'
            ]
            allowedOrigins: [
              'http://*.contoso.com'
              'http://www.fabrikam.com'
            ]
            allowedMethods: [
              'GET'
              'PUT'
            ]
            maxAgeInSeconds: 200
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
      roleAssignments: [
        {
          name: '30b99723-a3d8-4e31-8872-b80c960d62bd'
          roleDefinitionIdOrName: 'Owner'
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
        {
          name: guid('Custom seed ${namePrefix}${serviceShort}')
          roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
        {
          roleDefinitionIdOrName: subscriptionResourceId(
            'Microsoft.Authorization/roleDefinitions',
            'acdd72a7-3385-48ef-bd42-f606fba81ae7'
          )
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
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
  }
]
