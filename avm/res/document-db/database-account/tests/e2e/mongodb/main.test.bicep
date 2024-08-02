targetScope = 'subscription'

metadata name = 'Mongo Database'
metadata description = 'This instance deploys the module with a Mongo Database.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-documentdb.databaseaccounts-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dddamng'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// Pipeline is selecting random regions which dont support all cosmos features and have constraints when creating new cosmos
#disable-next-line no-hardcoded-location
var enforcedLocation = 'eastasia'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedDependencies'
  params: {
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    pairedRegionScriptName: 'dep-${namePrefix}-ds-${serviceShort}'
    location: enforcedLocation
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}diasa${serviceShort}01'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}'
    location: enforcedLocation
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      locations: [
        {
          failoverPriority: 0
          isZoneRedundant: false
          locationName: enforcedLocation
        }
        {
          failoverPriority: 1
          isZoneRedundant: false
          locationName: nestedDependencies.outputs.pairedRegionName
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
      location: enforcedLocation
      mongodbDatabases: [
        {
          collections: [
            {
              indexes: [
                {
                  key: {
                    keys: [
                      '_id'
                    ]
                  }
                }
                {
                  key: {
                    keys: [
                      '$**'
                    ]
                  }
                }
                {
                  key: {
                    keys: [
                      'car_id'
                      'car_model'
                    ]
                  }
                  options: {
                    unique: true
                  }
                }
                {
                  key: {
                    keys: [
                      '_ts'
                    ]
                  }
                  options: {
                    expireAfterSeconds: 2629746
                  }
                }
              ]
              name: 'car_collection'
              shardKey: {
                car_id: 'Hash'
              }
              throughput: 600
            }
            {
              indexes: [
                {
                  key: {
                    keys: [
                      '_id'
                    ]
                  }
                }
                {
                  key: {
                    keys: [
                      '$**'
                    ]
                  }
                }
                {
                  key: {
                    keys: [
                      'truck_id'
                      'truck_model'
                    ]
                  }
                  options: {
                    unique: true
                  }
                }
                {
                  key: {
                    keys: [
                      '_ts'
                    ]
                  }
                  options: {
                    expireAfterSeconds: 2629746
                  }
                }
              ]
              name: 'truck_collection'
              shardKey: {
                truck_id: 'Hash'
              }
            }
          ]
          name: '${namePrefix}-mdb-${serviceShort}-001'
          throughput: 800
        }
        {
          collections: [
            {
              indexes: [
                {
                  key: {
                    keys: [
                      '_id'
                    ]
                  }
                }
                {
                  key: {
                    keys: [
                      '$**'
                    ]
                  }
                }
                {
                  key: {
                    keys: [
                      'bike_id'
                      'bike_model'
                    ]
                  }
                  options: {
                    unique: true
                  }
                }
                {
                  key: {
                    keys: [
                      '_ts'
                    ]
                  }
                  options: {
                    expireAfterSeconds: 2629746
                  }
                }
              ]
              name: 'bike_collection'
              shardKey: {
                bike_id: 'Hash'
              }
            }
            {
              indexes: [
                {
                  key: {
                    keys: [
                      '_id'
                    ]
                  }
                }
                {
                  key: {
                    keys: [
                      '$**'
                    ]
                  }
                }
                {
                  key: {
                    keys: [
                      'bicycle_id'
                      'bicycle_model'
                    ]
                  }
                  options: {
                    unique: true
                  }
                }
                {
                  key: {
                    keys: [
                      '_ts'
                    ]
                  }
                  options: {
                    expireAfterSeconds: 2629746
                  }
                }
              ]
              name: 'bicycle_collection'
              shardKey: {
                bicycle_id: 'Hash'
              }
            }
          ]
          name: '${namePrefix}-mdb-${serviceShort}-002'
        }
      ]
      roleAssignments: [
        {
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
      managedIdentities: {
        systemAssigned: true
      }
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
  }
]
