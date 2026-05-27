metadata name = 'Application Gateway with Linux container and egress lockdown'
metadata description = 'This instance deploys the module with Application Gateway ingress, Linux container workload, egress lockdown via Azure Firewall UDR, jumpbox VM, and custom diagnostic settings across all resources.'

targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-ptn.appsvclza-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'apagw'

@description('Optional. Test name prefix.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. The password to leverage for the jumpbox VM.')
@secure()
param password string = newGuid()

// Hardcoded to 'australiaeast' because App Service PV3 plans are not available in all regions
#disable-next-line no-hardcoded-location
var enforcedLocation = 'australiaeast'

// Diagnostics
// ===========
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

module diagnosticDependencies '../../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}diasa${serviceShort}03'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}01'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}01'
    location: enforcedLocation
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-${iteration}'
    params: {
      workloadName: take('${namePrefix}${serviceShort}', 10)
      logAnalyticsWorkspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
      tags: {
        environment: 'test'
        scenario: 'app-gateway'
      }

      // Networking: Application Gateway path
      spokeNetworkConfig: {
        resourceGroupName: resourceGroupName
        ingressOption: 'applicationGateway'
        appGwSubnetAddressSpace: '10.240.12.0/24'
        enableEgressLockdown: true
      }

      // Linux container workload
      servicePlanConfig: {
        kind: 'linux'
        diagnosticSettings: [
          {
            eventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
            eventHubAuthorizationRuleResourceId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
            storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
            workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
            metricCategories: [
              {
                category: 'AllMetrics'
              }
            ]
          }
        ]
      }
      appServiceConfig: {
        kind: 'app,linux,container'
        container: {
          imageName: 'mcr.microsoft.com/appsvc/staticsite:latest'
        }
        diagnosticSettings: [
          {
            eventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
            eventHubAuthorizationRuleResourceId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
            storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
            workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
            logCategoriesAndGroups: [
              {
                categoryGroup: 'allLogs'
              }
            ]
            metricCategories: [
              {
                category: 'AllMetrics'
              }
            ]
          }
        ]
      }

      // Diagnostic settings
      aseConfig: {
        diagnosticSettings: [
          {
            eventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
            eventHubAuthorizationRuleResourceId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
            storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
            workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
            logCategoriesAndGroups: [
              {
                categoryGroup: 'allLogs'
              }
            ]
          }
        ]
      }
      appGatewayConfig: {
        diagnosticSettings: [
          {
            eventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
            eventHubAuthorizationRuleResourceId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
            storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
            workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
            logCategoriesAndGroups: [
              {
                categoryGroup: 'allLogs'
              }
            ]
            metricCategories: [
              {
                category: 'AllMetrics'
              }
            ]
          }
        ]
      }
      keyVaultConfig: {
        diagnosticSettings: [
          {
            eventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
            eventHubAuthorizationRuleResourceId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
            storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
            workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
            logCategoriesAndGroups: [
              {
                categoryGroup: 'allLogs'
              }
            ]
          }
        ]
      }

      // VM / Jump host settings
      location: enforcedLocation
    }
  }
]

// ================================= //
// Example: Deploy a jumpbox VM      //
// ================================= //
// This demonstrates how to deploy a jumpbox VM into the spoke VNet created by the LZA module.
// Customers can use the `dependencies.bicep` template as a starting point.
// Note: The spoke resource group name follows the LZA default: rg-spoke-{workloadName}-{env}-{location}

var spokeResourceGroupName = resourceGroupName

// Placeholder Bastion resource ID for validation (dry-run) deployments.
// Replace with a real Bastion resource ID for actual deployments.
var bastionPlaceholderResourceId = '/subscriptions/${subscription().subscriptionId}/resourceGroups/rg-hub-bastion/providers/Microsoft.Network/bastionHosts/bst-appsvc-lza'

module jumpbox './dependencies.bicep' = {
  name: '${uniqueString(deployment().name, enforcedLocation)}-jumpbox'
  scope: az.resourceGroup(spokeResourceGroupName)
  dependsOn: [
    testDeployment
  ]
  params: {
    vmName: take('vm-${namePrefix}${serviceShort}', 15)
    spokeVnetName: testDeployment[0].outputs.spokeVnetName
    vmAdminUsername: 'azureuser'
    vmAdminPassword: password
    bastionResourceId: bastionPlaceholderResourceId
    vmSize: 'Standard_D2s_v4'
    location: enforcedLocation
    tags: {
      environment: 'test'
      scenario: 'app-gateway-jumpbox'
    }
  }
}

output testDeploymentOutputs object = testDeployment[0].outputs
