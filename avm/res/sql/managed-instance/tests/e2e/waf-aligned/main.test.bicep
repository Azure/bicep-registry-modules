targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-sql.managedinstances-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'sqlmiwaf'

@description('Generated. Used as a basis for unique resource names.')
param baseTime string = utcNow('u')

@description('Optional. The password to leverage for the login.')
@secure()
param password string = newGuid()

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-11-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    // Adding base time to make the name unique as purge protection must be enabled (but may not be longer than 24 characters total)
    keyVaultName: 'dep${namePrefix}kv${serviceShort}${substring(uniqueString(baseTime), 0, 3)}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    pairedRegionScriptName: 'dep-${namePrefix}-ds-${serviceShort}'
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    networkSecurityGroupName: 'dep-${namePrefix}-nsg-${serviceShort}'
    routeTableName: 'dep-${namePrefix}-rt-${serviceShort}'
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: toLower('dep${namePrefix}wf${serviceShort}01')
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}'
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
      name: '${namePrefix}-${serviceShort}'
      administratorLogin: 'adminUserName'
      administratorLoginPassword: password
      subnetResourceId: nestedDependencies.outputs.subnetResourceId
      collation: 'SQL_Latin1_General_CP1_CI_AS'
      databases: [
        {
          backupLongTermRetentionPolicy: {
            name: 'default'
          }
          backupShortTermRetentionPolicy: {
            name: 'default'
          }
          name: '${namePrefix}-${serviceShort}-db-001'
          diagnosticSettings: [
            {
              name: 'customSetting'
              eventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
              eventHubAuthorizationRuleResourceId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
              storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
              workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
            }
          ]
        }
      ]
      diagnosticSettings: [
        {
          name: 'customSetting'
          logCategoriesAndGroups: [
            {
              categoryGroup: 'allLogs'
            }
          ]
          eventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
          eventHubAuthorizationRuleResourceId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
          storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
          workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
        }
      ]
      dnsZonePartnerResourceId: ''
      encryptionProtector: {
        serverKeyName: '${nestedDependencies.outputs.keyVaultName}_${nestedDependencies.outputs.keyVaultKeyName}_${last(split(nestedDependencies.outputs.keyVaultEncryptionKeyUrl, '/'))}'
        serverKeyType: 'AzureKeyVault'
      }
      hardwareFamily: 'Gen5'
      keys: [
        {
          name: '${nestedDependencies.outputs.keyVaultName}_${nestedDependencies.outputs.keyVaultKeyName}_${last(split(nestedDependencies.outputs.keyVaultEncryptionKeyUrl, '/'))}'
          serverKeyType: 'AzureKeyVault'
          uri: nestedDependencies.outputs.keyVaultEncryptionKeyUrl
        }
      ]
      licenseType: 'LicenseIncluded'
      primaryUserAssignedIdentityResourceId: nestedDependencies.outputs.managedIdentityResourceId
      proxyOverride: 'Proxy'
      publicDataEndpointEnabled: false
      securityAlertPolicy: {
        emailAccountAdmins: true
        name: 'default'
        state: 'Enabled'
        storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
        emailAddresses: [
          'test1@contoso.com'
          'test2@contoso.com'
        ]
      }
      servicePrincipal: 'SystemAssigned'
      skuName: 'GP_Gen5'
      skuTier: 'GeneralPurpose'
      storageSizeInGB: 32
      managedIdentities: {
        systemAssigned: true
        userAssignedResourceIds: [
          nestedDependencies.outputs.managedIdentityResourceId
        ]
      }
      maintenanceWindow: 'Custom2'
      timezoneId: 'UTC'
      vCores: 4
      vulnerabilityAssessment: {
        name: 'default'
        recurringScans: {
          isEnabled: true
          emailSubscriptionAdmins: true
          emails: [
            'test1@contoso.com'
            'test2@contoso.com'
          ]
        }
        storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
      }
    }
  }
]
