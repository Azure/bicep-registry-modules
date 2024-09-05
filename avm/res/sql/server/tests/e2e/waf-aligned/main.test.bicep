targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-sql.servers-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'sqlswaf'

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
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    location: resourceLocation
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}azsa${serviceShort}01'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}'
    location: resourceLocation
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}'
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
    location: resourceLocation
    vulnerabilityAssessmentsObj: {
      name: 'default'
      emailSubscriptionAdmins: true
      recurringScansIsEnabled: true
      recurringScansEmails: [
        'test1@contoso.com'
        'test2@contoso.com'
      ]
      storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
    }
    elasticPools: [
      {
        name: '${namePrefix}-${serviceShort}-ep-001'
        skuName: 'GP_Gen5'
        skuTier: 'GeneralPurpose'
        skuCapacity: 10
        // Pre-existing 'public' configuration
        maintenanceConfigurationId: '${subscription().id}/providers/Microsoft.Maintenance/publicMaintenanceConfigurations/SQL_${resourceLocation}_DB_1'
      }
    ]
    databases: [
      {
        name: '${namePrefix}-${serviceShort}db-001'
        collation: 'SQL_Latin1_General_CP1_CI_AS'
        skuTier: 'GeneralPurpose'
        skuName: 'ElasticPool'
        capacity: 0
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
        elasticPoolId: '${resourceGroup.id}/providers/Microsoft.Sql/servers/${namePrefix}-${serviceShort}/elasticPools/${namePrefix}-${serviceShort}-ep-001'
        encryptionProtectorObj: {
          serverKeyType: 'AzureKeyVault'
          serverKeyName: '${nestedDependencies.outputs.keyVaultName}_${nestedDependencies.outputs.keyVaultKeyName}_${last(split(nestedDependencies.outputs.keyVaultEncryptionKeyUrl, '/'))}'
        }
        backupShortTermRetentionPolicy: {
          retentionDays: 14
        }
        backupLongTermRetentionPolicy: {
          monthlyRetention: 'P6M'
        }
      }
    ]
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
