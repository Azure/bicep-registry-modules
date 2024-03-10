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

// Pipeline is selecting random regions which dont support all cosmos features and have constraints when creating new cosmos
var eastUsResourceLocation = 'eastus'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: eastUsResourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, eastUsResourceLocation)}-nestedDependencies'
  params: {
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    pairedRegionScriptName: 'dep-${namePrefix}-ds-${serviceShort}'
    location: eastUsResourceLocation
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, eastUsResourceLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}diasa${serviceShort}01'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}'
    location: eastUsResourceLocation
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [for iteration in [ 'init', 'idem' ]: {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, eastUsResourceLocation)}-test-${serviceShort}-${iteration}'
  params: {
    name: '${namePrefix}${serviceShort}001'
    location: eastUsResourceLocation
    locations: [
      {
        failoverPriority: 0
        isZoneRedundant: false
        locationName: eastUsResourceLocation
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

module enableSystemAssignedManagedIdentity '../../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, eastUsResourceLocation)}-systemMI-${serviceShort}'
  params: {
    location: eastUsResourceLocation
    name: 'system-assigned-mi'
    locations: [
      {
        failoverPriority: 0
        isZoneRedundant: false
        locationName: eastUsResourceLocation
      }
    ]
    managedIdentities: {
      systemAssigned: true
    }
  }
}

module enableUserAssignedManagedIdentity '../../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, eastUsResourceLocation)}-userMI-${serviceShort}'
  params: {
    location: eastUsResourceLocation
    name: 'user-assigned-mi'
    locations: [
      {
        failoverPriority: 0
        isZoneRedundant: false
        locationName: eastUsResourceLocation
      }
    ]
    managedIdentities: {
      userAssignedResourceIds: [
        nestedDependencies.outputs.managedIdentityResourceId
      ]
    }
  }
  dependsOn: [
    nestedDependencies
  ]
}

module enableAnalyticalStorage '../../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, eastUsResourceLocation)}-analytical-${serviceShort}'
  params: {
    location: eastUsResourceLocation
    enableAnalyticalStorage: true
    name: 'analytical-enabled-acc'
    locations: [
      {
        failoverPriority: 0
        isZoneRedundant: false
        locationName: eastUsResourceLocation
      }
    ]
    sqlDatabases: [
      {
        name: 'empty-database'
      }
    ]
  }
}

module enabledisableLocalAuth '../../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, eastUsResourceLocation)}-disableLocal-${serviceShort}'
  params: {
    disableLocalAuth: true
    location: eastUsResourceLocation
    name: 'disable-local-auth-acc'
    locations: [
      {
        failoverPriority: 0
        isZoneRedundant: false
        locationName: eastUsResourceLocation
      }
    ]
    sqlDatabases: [
      {
        name: 'empty-database'
      }
    ]
  }
}

module enableZoneRedundant '../../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, eastUsResourceLocation)}-zoneRedudant-${serviceShort}'
  params: {
    location: eastUsResourceLocation
    name: 'zone-redundant-acc'
    locations: [
      {
        failoverPriority: 0
        isZoneRedundant: true
        locationName: eastUsResourceLocation
      }
      {
        failoverPriority: 1
        isZoneRedundant: true
        locationName: nestedDependencies.outputs.pairedRegionName
      }
    ]
  }
}

module disableAutomaticFailover '../../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, eastUsResourceLocation)}-disableAutoFailover-${serviceShort}'
  params: {
    automaticFailover: false
    location: eastUsResourceLocation
    name: 'disable-automatic-failover-acc'
    locations: [
      {
        failoverPriority: 0
        isZoneRedundant: false
        locationName: eastUsResourceLocation
      }
    ]
    sqlDatabases: [
      {
        name: 'empty-database'
      }
    ]
  }
}

module enableContinousBackup '../../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, eastUsResourceLocation)}-continousBackup-${serviceShort}'
  params: {
    location: eastUsResourceLocation
    name: 'continous-backup-acc'
    backupPolicyType: 'Continuous'
    backupPolicyContinuousTier: 'Continuous7Days'
    locations: [
      {
        failoverPriority: 0
        isZoneRedundant: false
        locationName: eastUsResourceLocation
      }
    ]
    sqlDatabases: [
      {
        name: 'empty-database'
      }
    ]
  }
}

module enablePeriodicBackup '../../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, eastUsResourceLocation)}-periodicBackup-${serviceShort}'
  params: {
    location: eastUsResourceLocation
    name: 'periodic-backup-acc'
    backupPolicyType: 'Periodic'
    backupIntervalInMinutes: 300
    backupStorageRedundancy: 'Zone'
    backupRetentionIntervalInHours: 16
    locations: [
      {
        failoverPriority: 0
        isZoneRedundant: false
        locationName: eastUsResourceLocation
      }
    ]
    sqlDatabases: [
      {
        name: 'empty-database'
      }
    ]
  }
}
