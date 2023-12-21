targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-databricks.workspaces-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dwwaf'

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Generated. Used as a basis for unique resource names.')
param baseTime string = utcNow('u')

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '[[namePrefix]]'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-nestedDependencies'
  params: {
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    amlWorkspaceName: 'dep-${namePrefix}-aml-${serviceShort}'
    applicationInsightsName: 'dep-${namePrefix}-appi-${serviceShort}'
    loadBalancerName: 'dep-${namePrefix}-lb-${serviceShort}'
    storageAccountName: 'dep${namePrefix}sa${serviceShort}'
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    networkSecurityGroupName: 'dep-${namePrefix}-nsg-${serviceShort}'
    // Adding base time to make the name unique as purge protection must be enabled (but may not be longer than 24 characters total)
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}-${substring(uniqueString(baseTime), 0, 3)}'
    keyVaultDiskName: 'dep-${namePrefix}-kve-${serviceShort}-${substring(uniqueString(baseTime), 0, 3)}'
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../../.shared/.templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}diasa${serviceShort}'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}'
    location: location
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [for iteration in [ 'init', 'idem' ]: {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}-${iteration}'
  params: {
    enableDefaultTelemetry: enableDefaultTelemetry
    name: '${namePrefix}${serviceShort}001'
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
        privateDnsZoneResourceIds: [
          nestedDependencies.outputs.privateDNSZoneResourceId
        ]
        subnetResourceId: nestedDependencies.outputs.defaultSubnetResourceId
        tags: {
          Environment: 'Non-Prod'
          Role: 'DeploymentValidation'
        }
      }
    ]
    managedResourceGroupResourceId: '${subscription().id}/resourceGroups/rg-${resourceGroupName}-managed'
    requireInfrastructureEncryption: true
    vnetAddressPrefix: '10.100'
    location: resourceGroup.location
  }
}]
