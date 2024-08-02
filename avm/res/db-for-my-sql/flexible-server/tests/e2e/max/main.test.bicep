targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-dbformysql.flexibleservers-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dfmsmax'

@description('Optional. The password to leverage for the login.')
@secure()
param password string = newGuid()

@description('Generated. Used as a basis for unique resource names.')
param baseTime string = utcNow('u')

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// Pipeline is selecting random regions which dont support all cosmos features and have constraints when creating new cosmos
#disable-next-line no-hardcoded-location
var enforcedLocation = 'northeurope'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

module nestedDependencies1 'dependencies1.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedDependencies1'
  params: {
    // Adding base time to make the name unique as purge protection must be enabled (but may not be longer than 24 characters total)
    location: enforcedLocation
    managedIdentityName: 'dep-${namePrefix}-msi-ds-${serviceShort}'
    pairedRegionScriptName: 'dep-${namePrefix}-ds-${serviceShort}'
  }
}

module nestedDependencies2 'dependencies2.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedDependencies2'
  params: {
    // Adding base time to make the name unique as purge protection must be enabled (but may not be longer than 24 characters total)
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}-${substring(uniqueString(baseTime), 0, 3)}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    location: enforcedLocation
    geoBackupKeyVaultName: 'dep-${namePrefix}-kvp-${serviceShort}-${substring(uniqueString(baseTime), 0, 2)}'
    geoBackupManagedIdentityName: 'dep-${namePrefix}-msip-${serviceShort}'
    geoBackupLocation: nestedDependencies1.outputs.pairedRegionName
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
      location: enforcedLocation
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
      roleAssignments: [
        {
          name: '2478b63b-0cae-457f-9bd3-9feb00e1925b'
          roleDefinitionIdOrName: 'Owner'
          principalId: nestedDependencies1.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
        {
          name: guid('Custom seed ${namePrefix}${serviceShort}')
          roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
          principalId: nestedDependencies1.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
        {
          roleDefinitionIdOrName: subscriptionResourceId(
            'Microsoft.Authorization/roleDefinitions',
            'acdd72a7-3385-48ef-bd42-f606fba81ae7'
          )
          principalId: nestedDependencies1.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
      ]
      tags: {
        'hidden-title': 'This is visible in the resource name'
        resourceType: 'MySQL Flexible Server'
        serverName: '${namePrefix}${serviceShort}001'
      }
      administratorLogin: 'adminUserName'
      administratorLoginPassword: password
      skuName: 'Standard_D2ads_v5'
      tier: 'GeneralPurpose'
      storageAutoIoScaling: 'Enabled'
      storageSizeGB: 64
      storageIOPS: 400
      backupRetentionDays: 20
      availabilityZone: '1'
      databases: [
        {
          name: 'testdb1'
        }
        {
          name: 'testdb2'
          charset: 'ascii'
          collation: 'ascii_general_ci'
        }
      ]
      firewallRules: [
        {
          endIpAddress: '0.0.0.0'
          name: 'AllowAllWindowsAzureIps'
          startIpAddress: '0.0.0.0'
        }
        {
          endIpAddress: '10.10.10.10'
          name: 'test-rule1'
          startIpAddress: '10.10.10.1'
        }
        {
          endIpAddress: '100.100.100.10'
          name: 'test-rule2'
          startIpAddress: '100.100.100.1'
        }
      ]
      highAvailability: 'SameZone'
      storageAutoGrow: 'Enabled'
      version: '8.0.21'
      customerManagedKey: {
        keyName: nestedDependencies2.outputs.keyName
        keyVaultResourceId: nestedDependencies2.outputs.keyVaultResourceId
        userAssignedIdentityResourceId: nestedDependencies2.outputs.managedIdentityResourceId
      }
      geoRedundantBackup: 'Enabled'
      customerManagedKeyGeo: {
        keyName: nestedDependencies2.outputs.geoBackupKeyName
        keyVaultResourceId: nestedDependencies2.outputs.geoBackupKeyVaultResourceId
        userAssignedIdentityResourceId: nestedDependencies2.outputs.geoBackupManagedIdentityResourceId
      }
      managedIdentities: {
        userAssignedResourceIds: [
          nestedDependencies2.outputs.managedIdentityResourceId
          nestedDependencies2.outputs.geoBackupManagedIdentityResourceId
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
    }
    dependsOn: [
      nestedDependencies1
      nestedDependencies2
      diagnosticDependencies
    ]
  }
]
