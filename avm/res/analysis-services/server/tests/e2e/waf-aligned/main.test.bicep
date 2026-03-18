targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-analysisservices.servers-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'asswaf'

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

// Diagnostics
// ===========
module diagnosticDependencies1 '../../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-diagnosticDependencies1'
  params: {
    storageAccountName: 'dep${namePrefix}azsa${serviceShort}01'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}1'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}1'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}1'
    location: resourceLocation
  }
}
module diagnosticDependencies2 '../../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-diagnosticDependencies2'
  params: {
    storageAccountName: 'dep${namePrefix}azsa${serviceShort}02'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}2'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}2'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}2'
    location: resourceLocation
  }
}
module diagnosticDependencies3 '../../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-diagnosticDependencies3'
  params: {
    storageAccountName: 'dep${namePrefix}azsa${serviceShort}03'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}3'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}3'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}'
    location: resourceLocation
  }
}
module diagnosticDependencies4 '../../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-diagnosticDependencies4'
  params: {
    storageAccountName: 'dep${namePrefix}azsa${serviceShort}04'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}4'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}4'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}4'
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
      name: '${namePrefix}${serviceShort}'
      location: resourceLocation
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
      skuName: 'S0'
      skuCapacity: 1
      firewallSettings: {
        firewallRules: [
          {
            firewallRuleName: 'AllowFromAll'
            rangeStart: '0.0.0.0'
            rangeEnd: '255.255.255.255'
          }
        ]
        enablePowerBIService: true
      }
      diagnosticSettings: [
        {
          name: 'customSettingDef'
          eventHubName: diagnosticDependencies1.outputs.eventHubNamespaceEventHubName
          eventHubAuthorizationRuleResourceId: diagnosticDependencies1.outputs.eventHubAuthorizationRuleId
          storageAccountResourceId: diagnosticDependencies1.outputs.storageAccountResourceId
          workspaceResourceId: diagnosticDependencies1.outputs.logAnalyticsWorkspaceResourceId
        }
        {
          name: 'customSettingOnlyLog'
          eventHubName: diagnosticDependencies2.outputs.eventHubNamespaceEventHubName
          eventHubAuthorizationRuleResourceId: diagnosticDependencies2.outputs.eventHubAuthorizationRuleId
          storageAccountResourceId: diagnosticDependencies2.outputs.storageAccountResourceId
          workspaceResourceId: diagnosticDependencies2.outputs.logAnalyticsWorkspaceResourceId
          logCategoriesAndGroups: [
            {
              category: 'Engine'
            }
            {
              category: 'Service'
            }
          ]
        }
        {
          name: 'customSettingOnlyMetric'
          eventHubName: diagnosticDependencies3.outputs.eventHubNamespaceEventHubName
          eventHubAuthorizationRuleResourceId: diagnosticDependencies3.outputs.eventHubAuthorizationRuleId
          storageAccountResourceId: diagnosticDependencies3.outputs.storageAccountResourceId
          workspaceResourceId: diagnosticDependencies3.outputs.logAnalyticsWorkspaceResourceId
          metricCategories: [
            {
              category: 'AllMetrics'
            }
          ]
        }
        {
          name: 'customSettingExpl'
          eventHubName: diagnosticDependencies4.outputs.eventHubNamespaceEventHubName
          eventHubAuthorizationRuleResourceId: diagnosticDependencies4.outputs.eventHubAuthorizationRuleId
          storageAccountResourceId: diagnosticDependencies4.outputs.storageAccountResourceId
          workspaceResourceId: diagnosticDependencies4.outputs.logAnalyticsWorkspaceResourceId
          metricCategories: [
            {
              category: 'AllMetrics'
            }
          ]
          logCategoriesAndGroups: [
            {
              category: 'Engine'
            }
            {
              category: 'Service'
            }
          ]
        }
      ]
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
  }
]
