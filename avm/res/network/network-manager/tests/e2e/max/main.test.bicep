targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.networkmanagers-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nnmmax'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    virtualNetworkHubName: 'dep-${namePrefix}-vnetHub-${serviceShort}'
    virtualNetworkSpoke1Name: 'dep-${namePrefix}-vnetSpoke1-${serviceShort}'
    virtualNetworkSpoke2Name: 'dep-${namePrefix}-vnetSpoke2-${serviceShort}'
    virtualNetworkSpoke3Name: 'dep-${namePrefix}-vnetSpoke3-${serviceShort}'
    location: resourceLocation
  }
}

// ============== //
// Test Execution //
// ============== //

var networkManagerName = '${namePrefix}${serviceShort}001'
var networkManagerExpecetedResourceID = '${resourceGroup.id}/providers/Microsoft.Network/networkManagers/${networkManagerName}'

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: networkManagerName
      location: resourceLocation
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
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
      networkManagerScopeAccesses: [
        'Connectivity'
        'SecurityAdmin'
      ]
      networkManagerScopes: {
        managementGroups: [
          // Note: Required the `Microsoft.Network` provider to be registered at management group level via `az provider register --namespace Microsoft.Network -m '<MgmtGroupName>'`
          '/providers/Microsoft.Management/managementGroups/#_managementGroupId_#'
        ]
      }
      networkGroups: [
        {
          name: 'network-group-spokes-1'
          description: 'network-group-spokes description'
          staticMembers: [
            {
              name: 'virtualNetworkSpoke1'
              resourceId: nestedDependencies.outputs.virtualNetworkSpoke1Id
            }
            {
              name: 'virtualNetworkSpoke2'
              resourceId: nestedDependencies.outputs.virtualNetworkSpoke2Id
            }
          ]
        }
        {
          name: 'network-group-spokes-2'
          staticMembers: [
            {
              name: 'virtualNetworkSpoke3'
              resourceId: nestedDependencies.outputs.virtualNetworkSpoke3Id
            }
          ]
        }
        {
          name: 'network-group-spokes-3'
        }
      ]
      connectivityConfigurations: [
        {
          name: 'hubSpokeConnectivity'
          description: 'hubSpokeConnectivity description'
          connectivityTopology: 'HubAndSpoke'
          hubs: [
            {
              resourceId: nestedDependencies.outputs.virtualNetworkHubId
              resourceType: 'Microsoft.Network/virtualNetworks'
            }
          ]
          deleteExistingPeering: true
          isGlobal: false
          appliesToGroups: [
            {
              networkGroupResourceId: '${networkManagerExpecetedResourceID}/networkGroups/network-group-spokes-1'
              useHubGateway: false
              groupConnectivity: 'None'
              isGlobal: false
            }
          ]
        }
        {
          name: 'MeshConnectivity-1'
          description: 'MeshConnectivity description'
          connectivityTopology: 'Mesh'
          deleteExistingPeering: true
          isGlobal: true
          appliesToGroups: [
            {
              networkGroupResourceId: '${networkManagerExpecetedResourceID}/networkGroups/network-group-spokes-3'
              useHubGateway: false
              groupConnectivity: 'DirectlyConnected'
              isGlobal: true
            }
          ]
        }
        {
          name: 'MeshConnectivity-2'
          connectivityTopology: 'Mesh'
          appliesToGroups: [
            {
              networkGroupResourceId: '${networkManagerExpecetedResourceID}/networkGroups/network-group-spokes-2'
              useHubGateway: false
              groupConnectivity: 'DirectlyConnected'
              isGlobal: false
            }
          ]
          isGlobal: false
        }
      ]
      scopeConnections: [
        {
          name: 'scope-connection-test'
          description: 'description of the scope connection'
          resourceId: subscription().id
          tenantId: tenant().tenantId
        }
      ]
      securityAdminConfigurations: [
        {
          name: 'test-security-admin-config-1'
          description: 'description of the security admin config'
          applyOnNetworkIntentPolicyBasedServices: [
            'AllowRulesOnly'
          ]
          ruleCollections: [
            {
              name: 'test-rule-collection-1'
              description: 'test-rule-collection-description'
              appliesToGroups: [
                {
                  networkGroupResourceId: '${networkManagerExpecetedResourceID}/networkGroups/network-group-spokes-1'
                }
              ]
              rules: [
                {
                  name: 'test-inbound-allow-rule-1'
                  description: 'test-inbound-allow-rule-1-description'
                  access: 'Allow'
                  direction: 'Inbound'
                  priority: 150
                  protocol: 'Tcp'
                }
                {
                  name: 'test-outbound-deny-rule-2'
                  description: 'test-outbound-deny-rule-2-description'
                  access: 'Deny'
                  direction: 'Outbound'
                  priority: 200
                  protocol: 'Tcp'
                  sourcePortRanges: [
                    '80'
                    '442-445'
                  ]
                  sources: [
                    {
                      addressPrefix: 'AppService.WestEurope'
                      addressPrefixType: 'ServiceTag'
                    }
                  ]
                }
              ]
            }
            {
              name: 'test-rule-collection-2'
              appliesToGroups: [
                {
                  networkGroupResourceId: '${networkManagerExpecetedResourceID}/networkGroups/network-group-spokes-2'
                }
                {
                  networkGroupResourceId: '${networkManagerExpecetedResourceID}/networkGroups/network-group-spokes-3'
                }
              ]
              rules: [
                {
                  name: 'test-inbound-allow-rule-3'
                  access: 'Allow'
                  direction: 'Inbound'
                  destinationPortRanges: [
                    '80'
                    '442-445'
                  ]
                  destinations: [
                    {
                      addressPrefix: '192.168.20.20'
                      addressPrefixType: 'IPPrefix'
                    }
                  ]
                  priority: 250
                  protocol: 'Tcp'
                }
                {
                  name: 'test-inbound-allow-rule-4'
                  description: 'test-inbound-allow-rule-4-description'
                  access: 'Allow'
                  direction: 'Inbound'
                  sources: [
                    {
                      addressPrefix: '10.0.0.0/24'
                      addressPrefixType: 'IPPrefix'
                    }
                    {
                      addressPrefix: '100.100.100.100'
                      addressPrefixType: 'IPPrefix'
                    }
                  ]
                  destinations: [
                    {
                      addressPrefix: '172.16.0.0/24'
                      addressPrefixType: 'IPPrefix'
                    }
                    {
                      addressPrefix: '172.16.1.0/24'
                      addressPrefixType: 'IPPrefix'
                    }
                  ]
                  priority: 260
                  protocol: 'Tcp'
                }
              ]
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
    dependsOn: [
      nestedDependencies
    ]
  }
]
