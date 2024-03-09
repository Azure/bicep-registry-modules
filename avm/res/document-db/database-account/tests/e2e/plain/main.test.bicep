targetScope = 'subscription'

metadata name = 'Plain'
metadata description = 'This instance deploys the module without a Database.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-documentdb.databaseaccounts-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dddapln'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    pairedRegionScriptName: 'dep-${namePrefix}-ds-${serviceShort}'
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
module testDeployment '../../../main.bicep' = [for iteration in [ 'init', 'idem' ]: {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
  params: {
    name: '${namePrefix}${serviceShort}001'
    location: resourceLocation
    locations: [
      {
        failoverPriority: 0
        isZoneRedundant: false
        locationName: resourceLocation
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
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
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
        roleDefinitionIdOrName: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
        principalId: nestedDependencies.outputs.managedIdentityPrincipalId
        principalType: 'ServicePrincipal'
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
}]

module enableAnalyticalStorage '../../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-analytical-${serviceShort}'
  params: {
    location: resourceLocation
    enableAnalyticalStorage: true
    name: 'analytical-enabled-acc'
    locations: [
      {
        failoverPriority: 0
        isZoneRedundant: false
        locationName: resourceLocation
      }
    ]
    sqlDatabases: [
      {
        name: 'empty-database'
      }
    ]
  }
  dependsOn: [
    nestedDependencies
    diagnosticDependencies
  ]
}

module enabledisableLocalAuth '../../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-disableLocalAuth-${serviceShort}'
  params: {
    disableLocalAuth: true
    location: resourceLocation
    name: 'disable-local-auth-acc'
    locations: [
      {
        failoverPriority: 0
        isZoneRedundant: false
        locationName: resourceLocation
      }
    ]
    sqlDatabases: [
      {
        name: 'empty-database'
      }
    ]
  }
  dependsOn: [
    nestedDependencies
    diagnosticDependencies
  ]
}

/* Cant run this test as the regions selected by the pipeline could not support zone redundant
module enableZoneRedundant '../../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-zoneRedudant-${serviceShort}'
  params: {
    location: resourceLocation
    name: 'zone-redundant-acc'
    locations: [
      {
        failoverPriority: 0
        isZoneRedundant: true
        locationName: resourceLocation
      }
      {
        failoverPriority: 1
        isZoneRedundant: true
        locationName: nestedDependencies.outputs.pairedRegionName
      }
    ]
  }
  dependsOn: [
    nestedDependencies
    diagnosticDependencies
  ]
}
*/

module disableAutomaticFailover '../../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-disableAutomaticFailover-${serviceShort}'
  params: {
    automaticFailover: false
    location: resourceLocation
    name: 'disable-automatic-failover-acc'
    locations: [
      {
        failoverPriority: 0
        isZoneRedundant: false
        locationName: resourceLocation
      }
    ]
    sqlDatabases: [
      {
        name: 'empty-database'
      }
    ]
  }
  dependsOn: [
    nestedDependencies
    diagnosticDependencies
  ]
}

module periodicBackup '../../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-periodicBackup-${serviceShort}'
  params: {
    location: resourceLocation
    name: 'periodic-backup-acc'
    backupPolicyType: 'Periodic'
    backupIntervalInMinutes: 300
    backupStorageRedundancy: 'Zone'
    backupRetentionIntervalInHours: 16
    locations: [
      {
        failoverPriority: 0
        isZoneRedundant: false
        locationName: resourceLocation
      }
    ]
    sqlDatabases: [
      {
        name: 'empty-database'
      }
    ]
  }
  dependsOn: [
    nestedDependencies
    diagnosticDependencies
  ]
}
