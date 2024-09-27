targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-databricks.workspaces-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dwmax'

@description('Generated. Used as a basis for unique resource names.')
param baseTime string = utcNow('u')

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Required. The object id of the AzureDatabricks Enterprise Application. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'CI-AzureDatabricksEnterpriseApplicationObjectId\'.')
@secure()
param azureDatabricksEnterpriseApplicationObjectId string = ''

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
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    location: resourceLocation
    amlWorkspaceName: 'dep-${namePrefix}-aml-${serviceShort}'
    applicationInsightsName: 'dep-${namePrefix}-appi-${serviceShort}'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    loadBalancerName: 'dep-${namePrefix}-lb-${serviceShort}'
    storageAccountName: 'dep${namePrefix}sa${serviceShort}'
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    networkSecurityGroupName: 'dep-${namePrefix}-nsg-${serviceShort}'
    databricksApplicationObjectId: azureDatabricksEnterpriseApplicationObjectId
    keyVaultDiskName: 'dep-${namePrefix}-kve-${serviceShort}-${substring(uniqueString(baseTime), 0, 3)}'
    // Adding base time to make the name unique as purge protection must be enabled (but may not be longer than 24 characters total)
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}-${substring(uniqueString(baseTime), 0, 3)}'
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}diasa${serviceShort}'
    logAnalyticsWorkspaceName: nestedDependencies.outputs.logAnalyticsWorkspaceName
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
      name: '${namePrefix}${serviceShort}002'
      location: resourceLocation
      diagnosticSettings: [
        {
          name: 'customSetting'
          eventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
          eventHubAuthorizationRuleResourceId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
          storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
          workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
          logCategoriesAndGroups: [
            {
              category: 'jobs'
            }
            {
              category: 'notebook'
            }
          ]
        }
      ]
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
      roleAssignments: [
        {
          name: '2754e64b-b96e-44bc-9cb2-6e39b057f515'
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
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
      customerManagedKey: {
        keyName: nestedDependencies.outputs.keyVaultKeyName
        keyVaultResourceId: nestedDependencies.outputs.keyVaultResourceId
      }
      customerManagedKeyManagedDisk: {
        keyName: nestedDependencies.outputs.keyVaultDiskKeyName
        keyVaultResourceId: nestedDependencies.outputs.keyVaultDiskResourceId
        rotationToLatestKeyVersionEnabled: true
      }
      storageAccountName: 'sa${namePrefix}${serviceShort}001'
      storageAccountSkuName: 'Standard_ZRS'
      publicIpName: 'nat-gw-public-ip'
      natGatewayName: 'nat-gateway'
      prepareEncryption: true
      requiredNsgRules: 'NoAzureDatabricksRules'
      skuName: 'premium'
      amlWorkspaceResourceId: nestedDependencies.outputs.machineLearningWorkspaceResourceId
      customPrivateSubnetName: nestedDependencies.outputs.customPrivateSubnetName
      customPublicSubnetName: nestedDependencies.outputs.customPublicSubnetName
      publicNetworkAccess: 'Disabled'
      disablePublicIp: true
      loadBalancerResourceId: nestedDependencies.outputs.loadBalancerResourceId
      loadBalancerBackendPoolName: nestedDependencies.outputs.loadBalancerBackendPoolName
      customVirtualNetworkResourceId: nestedDependencies.outputs.virtualNetworkResourceId
      privateEndpoints: [
        {
          privateDnsZoneGroup: {
            privateDnsZoneGroupConfigs: [
              {
                privateDnsZoneResourceId: nestedDependencies.outputs.privateDNSZoneResourceId
              }
            ]
          }
          service: 'databricks_ui_api'
          subnetResourceId: nestedDependencies.outputs.primarySubnetResourceId
          tags: {
            Environment: 'Non-Prod'
            Role: 'DeploymentValidation'
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
          subnetResourceId: nestedDependencies.outputs.secondarySubnetResourceId
          service: 'browser_authentication'
        }
      ]
      // Please do not change the name of the managed resource group as the CI's removal logic relies on it
      managedResourceGroupResourceId: '${subscription().id}/resourceGroups/rg-${resourceGroupName}-managed'
      requireInfrastructureEncryption: true
      vnetAddressPrefix: '10.100'
      defaultCatalog: {
        //initialName: '' Cannot be set to anything other than an empty string. {"code":"InvalidInitialCatalogName","message":"Currently custom initial catalog name is not supported. This capability will be added in future."}
        initialType: 'UnityCatalog' // Choose between 'HiveCatalog' OR 'UnityCatalog'
      }
    }
    dependsOn: [
      nestedDependencies
      diagnosticDependencies
    ]
  }
]
