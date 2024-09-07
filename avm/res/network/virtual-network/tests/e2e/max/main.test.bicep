targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.virtualnetworks-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nvnmax'

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
    location: resourceLocation
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    routeTableName: 'dep-${namePrefix}-rt-${serviceShort}'
    networkSecurityGroupName: 'dep-${namePrefix}-nsg-${serviceShort}'
    networkSecurityGroupBastionName: 'dep-${namePrefix}-nsg-bastion-${serviceShort}'
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
      roleAssignments: [
        {
          name: 'f5c27a7b-9b18-4dc1-b002-db3c38e80b64'
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
              roleDefinitionIdOrName: 'Owner'
              principalId: nestedDependencies.outputs.managedIdentityPrincipalId
              principalType: 'ServicePrincipal'
            }
            {
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
          routeTableResourceId: nestedDependencies.outputs.routeTableResourceId
          serviceEndpoints: [
            'Microsoft.Storage'
            'Microsoft.Sql'
          ]
        }
        {
          addressPrefix: cidrSubnet(addressPrefix, 24, 2)
          delegation: 'Microsoft.Netapp/volumes'
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
          name: '${namePrefix}-az-subnet-x-004'
          networkSecurityGroupResourceId: ''
          natGatewayResourceId: ''
          routeTableResourceId: ''
        }
        {
          addressPrefix: cidrSubnet(addressPrefix, 24, 5)
          name: 'AzureBastionSubnet'
          networkSecurityGroupResourceId: nestedDependencies.outputs.networkSecurityGroupBastionResourceId
        }
        {
          addressPrefix: cidrSubnet(addressPrefix, 24, 6)
          name: 'AzureFirewallSubnet'
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
