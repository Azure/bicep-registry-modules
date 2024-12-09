targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module with the minimum set of required parameters to deploy a WAF-aligned internal load balancer.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.loadbalancers-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nlbwaf'

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
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
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
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      location: resourceLocation
      frontendIPConfigurations: [
        {
          name: 'privateIPConfig1'
          subnetId: nestedDependencies.outputs.subnetResourceId
          zones: [
            1
            2
            3
          ]
        }
      ]
      backendAddressPools: [
        {
          name: 'servers'
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
      inboundNatRules: [
        {
          backendPort: 443
          enableFloatingIP: false
          enableTcpReset: false
          frontendIPConfigurationName: 'privateIPConfig1'
          frontendPort: 443
          idleTimeoutInMinutes: 4
          name: 'inboundNatRule1'
          protocol: 'Tcp'
        }
        {
          backendAddressPoolName: 'servers'
          backendPort: 3389
          frontendIPConfigurationName: 'privateIPConfig1'
          frontendPortRangeStart: 5000
          frontendPortRangeEnd: 5010
          loadDistribution: 'Default'
          name: 'inboundNatRule2'
          probeName: 'probe2'
        }
      ]
      skuName: 'Standard'
      loadBalancingRules: [
        {
          backendAddressPoolName: 'servers'
          backendPort: 0
          disableOutboundSnat: true
          enableFloatingIP: true
          enableTcpReset: false
          frontendIPConfigurationName: 'privateIPConfig1'
          frontendPort: 0
          idleTimeoutInMinutes: 4
          loadDistribution: 'Default'
          name: 'privateIPLBRule1'
          probeName: 'probe1'
          protocol: 'All'
        }
      ]
      probes: [
        {
          intervalInSeconds: 5
          name: 'probe1'
          numberOfProbes: 2
          port: '62000'
          protocol: 'Tcp'
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
