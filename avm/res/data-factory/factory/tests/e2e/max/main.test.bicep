targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-datafactory.factories-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dffmax'

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
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    storageAccountName: 'dep${namePrefix}st${serviceShort}'
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
      location: resourceLocation
      customerManagedKey: {
        keyName: nestedDependencies.outputs.keyVaultEncryptionKeyName
        keyVaultResourceId: nestedDependencies.outputs.keyVaultResourceId
        userAssignedIdentityResourceId: nestedDependencies.outputs.managedIdentityResourceId
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
      gitConfigureLater: true
      globalParameters: {
        testParameter1: {
          type: 'String'
          value: 'testValue1'
        }
      }
      integrationRuntimes: [
        // The AutoResolveIntegrationRuntime is the default integration runtime and does not need to be defined. It is not a virtual network managed integration runtime by default
        {
          name: 'TestRuntime'
          type: 'SelfHosted'
        }
        {
          // Creating a second integration runtime with a custom name and has a managed virtual network. The name can be anything, but it must be unique within the data factory. We will connect a linked service to this integration runtime.
          managedVirtualNetworkName: 'default'
          name: 'IRvnetManaged'
          type: 'Managed'
          typeProperties: {
            computeProperties: {
              location: 'AutoResolve'
            }
          }
        }
      ]
      linkedServices: [
        {
          // This will connect to the AutoResolveIntegrationRuntime as it does not have a specific integration runtime defined and by default uses the AutoResolveIntegrationRuntime
          name: 'SQLdbLinkedservice'
          type: 'AzureSQLDatabase'
          typeProperties: {
            // An example of a connection string to an Azure SQL Database
            connectionString: 'integrated security=False;encrypt=True;connection timeout=30;data source=mydatabase.${environment().suffixes.sqlServerHostname};initial catalog=mydatabase;user id=myuser'
          }
        }
        {
          // This will connect to the IRvnetManaged integration runtime as it is specifically defined
          name: 'LakeStoreLinkedservice'
          integrationRuntimeName: 'IRvnetManaged'
          description: 'This is a description for the linked service using the IRvnetManaged integration runtime.'
          parameters: {
            storageAccountName: {
              type: 'String'
              defaultValue: 'madeupstorageaccname'
            }
          }
          type: 'AzureBlobFS'
          typeProperties: {
            url: '@{concat(\'https://\', linkedService().storageAccountName, \'.dfs.core.windows.net\')}'
          }
        }
      ]
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
      managedPrivateEndpoints: [
        {
          fqdns: [
            nestedDependencies.outputs.storageAccountBlobEndpoint
          ]
          groupId: 'blob'
          name: '${nestedDependencies.outputs.storageAccountName}-managed-privateEndpoint'
          privateLinkResourceId: nestedDependencies.outputs.storageAccountResourceId
        }
      ]
      managedVirtualNetworkName: 'default'
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
            application: 'AVM'
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
          subnetResourceId: nestedDependencies.outputs.subnetResourceId
        }
      ]
      roleAssignments: [
        {
          name: '12093237-f40a-4f36-868f-accbeebf540c'
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
        userAssignedResourceIds: [
          nestedDependencies.outputs.managedIdentityResourceId
        ]
      }
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
