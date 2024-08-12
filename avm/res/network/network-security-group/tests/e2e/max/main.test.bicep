targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.networksecuritygroups-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nnsgmax'

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
    applicationSecurityGroupName: 'dep-${namePrefix}-asg-${serviceShort}'
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
      diagnosticSettings: [
        {
          name: 'customSetting'
          eventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
          eventHubAuthorizationRuleResourceId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
          storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
          workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
        }
      ]
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
      roleAssignments: [
        {
          name: 'b6d38ee8-4058-42b1-af6a-b8d585cf61ef'
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
      securityRules: [
        {
          name: 'Specific'
          properties: {
            access: 'Allow'
            description: 'Tests specific IPs and ports'
            destinationAddressPrefix: '*'
            destinationPortRange: '8080'
            direction: 'Inbound'
            priority: 100
            protocol: '*'
            sourceAddressPrefix: '*'
            sourcePortRange: '*'
          }
        }
        {
          name: 'Ranges'
          properties: {
            access: 'Allow'
            description: 'Tests Ranges'
            destinationAddressPrefixes: [
              '10.2.0.0/16'
              '10.3.0.0/16'
            ]
            destinationPortRanges: [
              '90'
              '91'
            ]
            direction: 'Inbound'
            priority: 101
            protocol: '*'
            sourceAddressPrefixes: [
              '10.0.0.0/16'
              '10.1.0.0/16'
            ]
            sourcePortRanges: [
              '80'
              '81'
            ]
          }
        }
        {
          name: 'Port_8082'
          properties: {
            access: 'Allow'
            description: 'Allow inbound access on TCP 8082'
            destinationApplicationSecurityGroupResourceIds: [
              nestedDependencies.outputs.applicationSecurityGroupResourceId
            ]
            destinationPortRange: '8082'
            direction: 'Inbound'
            priority: 102
            protocol: '*'
            sourceApplicationSecurityGroupResourceIds: [
              nestedDependencies.outputs.applicationSecurityGroupResourceId
            ]
            sourcePortRange: '*'
          }
        }
        {
          name: 'Deny-All-Inbound'
          properties: {
            access: 'Deny'
            direction: 'Inbound'
            priority: 4095
            protocol: '*'
            sourcePortRange: '*'
            destinationPortRange: '*'
            sourceAddressPrefix: '*'
            destinationAddressPrefix: '*'
          }
        }
        {
          name: 'Allow-AzureCloud-Tcp'
          properties: {
            access: 'Allow'
            direction: 'Outbound'
            priority: 250
            protocol: 'Tcp'
            destinationAddressPrefix: 'AzureCloud'
            sourceAddressPrefixes: [
              '10.10.10.0/24'
              '192.168.1.0/24'
            ]
            sourcePortRange: '*'
            destinationPortRange: '443'
          }
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
