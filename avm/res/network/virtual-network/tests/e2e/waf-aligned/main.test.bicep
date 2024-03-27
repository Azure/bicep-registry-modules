targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.virtualnetworks-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nvnwaf'

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
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    routeTableName: 'dep-${namePrefix}-rt-${serviceShort}'
    networkSecurityGroupName: 'dep-${namePrefix}-nsg-${serviceShort}'
    networkSecurityGroupBastionName: 'dep-${namePrefix}-nsg-bastion-${serviceShort}'
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

var addressPrefix = '10.0.0.0/16'
@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      location: resourceLocation
      addressPrefixes: [
        addressPrefix
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
      dnsServers: [
        '10.0.1.4'
        '10.0.1.5'
      ]
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
      flowTimeoutInMinutes: 20
      subnets: [
        {
          addressPrefix: cidrSubnet(addressPrefix, 24, 0)
          name: 'GatewaySubnet'
        }
        {
          addressPrefix: cidrSubnet(addressPrefix, 24, 1)
          name: '${namePrefix}-az-subnet-x-001'
          networkSecurityGroupResourceId: nestedDependencies.outputs.networkSecurityGroupResourceId
          roleAssignments: [
            {
              roleDefinitionIdOrName: 'Reader'
              principalId: nestedDependencies.outputs.managedIdentityPrincipalId
              principalType: 'ServicePrincipal'
            }
          ]
          routeTableResourceId: nestedDependencies.outputs.routeTableResourceId
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
            }
            {
              service: 'Microsoft.Sql'
            }
          ]
        }
        {
          addressPrefix: cidrSubnet(addressPrefix, 24, 2)
          delegations: [
            {
              name: 'netappDel'
              properties: {
                serviceName: 'Microsoft.Netapp/volumes'
              }
            }
          ]
          name: '${namePrefix}-az-subnet-x-002'
          networkSecurityGroupResourceId: nestedDependencies.outputs.networkSecurityGroupResourceId
        }
        {
          addressPrefix: cidrSubnet(addressPrefix, 24, 3)
          name: '${namePrefix}-az-subnet-x-003'
          networkSecurityGroupResourceId: nestedDependencies.outputs.networkSecurityGroupResourceId
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        {
          addressPrefix: cidrSubnet(addressPrefix, 24, 4)
          name: 'AzureBastionSubnet'
          networkSecurityGroupResourceId: nestedDependencies.outputs.networkSecurityGroupBastionResourceId
        }
        {
          addressPrefix: cidrSubnet(addressPrefix, 24, 5)
          name: 'AzureFirewallSubnet'
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
  }
]
