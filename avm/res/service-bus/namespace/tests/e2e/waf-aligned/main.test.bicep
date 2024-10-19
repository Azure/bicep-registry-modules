targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-servicebus.namespaces-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'sbnwaf'

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
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    location: resourceLocation
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
      name: '${namePrefix}${serviceShort}001'
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
      location: resourceLocation
      skuObject: {
        name: 'Premium'
        capacity: 2
      }
      premiumMessagingPartitions: 1
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
      roleAssignments: []
      networkRuleSets: {
        defaultAction: 'Deny'
        trustedServiceAccessEnabled: true
        virtualNetworkRules: [
          {
            ignoreMissingVnetServiceEndpoint: true
            subnetResourceId: nestedDependencies.outputs.subnetResourceId
          }
        ]
        ipRules: [
          {
            ipMask: '10.0.1.0/32'
            action: 'Allow'
          }
          {
            ipMask: '10.0.2.0/32'
            action: 'Allow'
          }
        ]
      }
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
          name: 'AnotherKey'
          rights: [
            'Listen'
            'Send'
          ]
        }
      ]
      queues: [
        {
          name: '${namePrefix}${serviceShort}q001'
          roleAssignments: []
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
              name: 'AnotherKey'
              rights: [
                'Listen'
                'Send'
              ]
            }
          ]
          autoDeleteOnIdle: 'PT5M'
          maxMessageSizeInKilobytes: 2048
        }
      ]
      topics: [
        {
          name: '${namePrefix}${serviceShort}t001'
          roleAssignments: []
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
              name: 'AnotherKey'
              rights: [
                'Listen'
                'Send'
              ]
            }
          ]
        }
      ]
      diagnosticSettings: [
        {
          eventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
          eventHubAuthorizationRuleResourceId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
          storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
          workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
        }
      ]
      privateEndpoints: [
        {
          service: 'namespace'
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
      managedIdentities: {
        systemAssigned: true
        userAssignedResourcesIds: [
          nestedDependencies.outputs.managedIdentityResourceId
        ]
      }
      disableLocalAuth: true
      publicNetworkAccess: 'Enabled'
      minimumTlsVersion: '1.2'
    }
    dependsOn: [
      nestedDependencies
      diagnosticDependencies
    ]
  }
]
