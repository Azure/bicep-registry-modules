targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.loadbalancers-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nlbmax'

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
    publicIPName: 'dep-${namePrefix}-pip-${serviceShort}'
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
          name: 'publicIPConfig1'
          publicIPAddressId: nestedDependencies.outputs.publicIPResourceId
        }
      ]
      backendAddressPools: [
        {
          name: 'backendAddressPool1'
        }
        {
          name: 'backendAddressPool2'
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
      inboundNatRules: [
        {
          backendPort: 443
          enableFloatingIP: false
          enableTcpReset: false
          frontendIPConfigurationName: 'publicIPConfig1'
          frontendPort: 443
          idleTimeoutInMinutes: 4
          name: 'inboundNatRule1'
          protocol: 'Tcp'
        }
        {
          backendPort: 3389
          frontendIPConfigurationName: 'publicIPConfig1'
          frontendPort: 3389
          name: 'inboundNatRule2'
        }
      ]
      loadBalancingRules: [
        {
          backendAddressPoolName: 'backendAddressPool1'
          backendPort: 80
          disableOutboundSnat: true
          enableFloatingIP: false
          enableTcpReset: false
          frontendIPConfigurationName: 'publicIPConfig1'
          frontendPort: 80
          idleTimeoutInMinutes: 5
          loadDistribution: 'Default'
          name: 'publicIPLBRule1'
          probeName: 'probe1'
          protocol: 'Tcp'
        }
        {
          backendAddressPoolName: 'backendAddressPool2'
          backendPort: 8080
          frontendIPConfigurationName: 'publicIPConfig1'
          frontendPort: 8080
          loadDistribution: 'Default'
          name: 'publicIPLBRule2'
          probeName: 'probe2'
        }
      ]
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
      outboundRules: [
        {
          allocatedOutboundPorts: 63984
          backendAddressPoolName: 'backendAddressPool1'
          frontendIPConfigurationName: 'publicIPConfig1'
          name: 'outboundRule1'
        }
      ]
      probes: [
        {
          intervalInSeconds: 10
          name: 'probe1'
          numberOfProbes: 5
          port: 80
          protocol: 'Tcp'
        }
        {
          name: 'probe2'
          port: 443
          protocol: 'Https'
          requestPath: '/'
        }
      ]
      roleAssignments: [
        {
          name: '3a5b2a4a-3584-4d6b-9cf0-ceb1e4f88a5d'
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
    }
  }
]
