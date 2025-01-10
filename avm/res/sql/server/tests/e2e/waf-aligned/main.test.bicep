targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-sql.servers-${serviceShort}-rg'

// Enforce uksouth to avoid restrictions around zone redundancy in certain regions
#disable-next-line no-hardcoded-location
var enforcedLocation = 'uksouth'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'sqlswaf'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Generated. Used as a basis for unique resource names.')
param baseTime string = utcNow('u')

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedDependencies'
  params: {
    // Adding base time to make the name unique as purge protection must be enabled (but may not be longer than 24 characters total)
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}-${substring(uniqueString(baseTime), 0, 3)}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    location: enforcedLocation
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}azsa${serviceShort}01'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}'
    location: enforcedLocation
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}'
  params: {
    name: '${namePrefix}-${serviceShort}'
    primaryUserAssignedIdentityId: nestedDependencies.outputs.managedIdentityResourceId
    administrators: {
      azureADOnlyAuthentication: true
      login: 'myspn'
      sid: nestedDependencies.outputs.managedIdentityPrincipalId
      principalType: 'Application'
      tenantId: tenant().tenantId
    }
    location: enforcedLocation
    vulnerabilityAssessmentsObj: {
      name: 'default'
      recurringScans: {
        emailSubscriptionAdmins: true
        isEnabled: true
        emails: [
          'test1@contoso.com'
          'test2@contoso.com'
        ]
      }
      storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
    }
    elasticPools: [
      {
        name: '${namePrefix}-${serviceShort}-ep-001'
        sku: {
          name: 'GP_Gen5'
          tier: 'GeneralPurpose'
          capacity: 10
        }
        maintenanceConfigurationId: '${subscription().id}/providers/Microsoft.Maintenance/publicMaintenanceConfigurations/SQL_${enforcedLocation}_DB_1'
      }
    ]
    databases: [
      {
        name: '${namePrefix}-${serviceShort}db-001'
        collation: 'SQL_Latin1_General_CP1_CI_AS'
        sku: {
          name: 'ElasticPool'
          tier: 'GeneralPurpose'
          capacity: 0
        }
        maxSizeBytes: 34359738368
        licenseType: 'LicenseIncluded'
        diagnosticSettings: [
          {
            name: 'customSetting'
            eventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
            eventHubAuthorizationRuleResourceId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
            storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
            workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
          }
        ]
        elasticPoolResourceId: '${resourceGroup.id}/providers/Microsoft.Sql/servers/${namePrefix}-${serviceShort}/elasticPools/${namePrefix}-${serviceShort}-ep-001'
        backupShortTermRetentionPolicy: {
          retentionDays: 14
        }
        backupLongTermRetentionPolicy: {
          monthlyRetention: 'P6M'
        }
      }
    ]
    encryptionProtectorObj: {
      serverKeyType: 'AzureKeyVault'
      serverKeyName: '${nestedDependencies.outputs.keyVaultName}_${nestedDependencies.outputs.keyVaultKeyName}_${last(split(nestedDependencies.outputs.keyVaultEncryptionKeyUrl, '/'))}'
    }
    securityAlertPolicies: [
      {
        name: 'Default'
        state: 'Enabled'
        emailAccountAdmins: true
      }
    ]
    keys: [
      {
        serverKeyType: 'AzureKeyVault'
        uri: nestedDependencies.outputs.keyVaultEncryptionKeyUrl
      }
    ]
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        nestedDependencies.outputs.managedIdentityResourceId
      ]
    }
    privateEndpoints: [
      {
        subnetResourceId: nestedDependencies.outputs.privateEndpointSubnetResourceId
        service: 'sqlServer'
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
    virtualNetworkRules: [
      {
        ignoreMissingVnetServiceEndpoint: true
        name: 'newVnetRule1'
        virtualNetworkSubnetId: nestedDependencies.outputs.serviceEndpointSubnetResourceId
      }
    ]
    restrictOutboundNetworkAccess: 'Disabled'
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
