targetScope = 'subscription'

metadata name = 'Linux Web App, using large parameter set'
metadata description = 'This instance deploys the module asa Linux Web App with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-web.sites-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'wswalmax'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// Note, we enforce the location due to quota restrictions in other regions (esp. east-us)
#disable-next-line no-hardcoded-location
var enforcedLocation = 'swedencentral'
// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedDependencies'
  params: {
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    serverFarmName: 'dep-${namePrefix}-sf-${serviceShort}'
    relayNamespaceName: 'dep-${namePrefix}-ns-${serviceShort}'
    storageAccountName: 'dep${namePrefix}st${serviceShort}'
    hybridConnectionName: 'dep-${namePrefix}-hc-${serviceShort}'
    applicationInsightsName: 'dep-${namePrefix}-appi-${serviceShort}'
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}diasa${serviceShort}01'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}'
  }
}

// ============== //
// Test Execution //
// ============== //
@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      location: enforcedLocation
      kind: 'app,linux'
      serverFarmResourceId: nestedDependencies.outputs.serverFarmResourceId
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
      httpsOnly: true
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
      slots: [
        {
          name: 'slot1'
          diagnosticSettings: [
            {
              name: 'customSetting'
              eventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
              eventHubAuthorizationRuleResourceId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
              storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
              workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
            }
          ]
          privateEndpoints: [
            {
              subnetResourceId: nestedDependencies.outputs.subnetResourceId
              privateDnsZoneGroup: {
                privateDnsZoneGroupConfigs: [
                  {
                    privateDnsZoneResourceId: nestedDependencies.outputs.privateDNSZoneResourceId
                  }
                ]
              }
              tags: {
                'hidden-title': 'This is visible in the resource name'
                Environment: 'Non-Prod'
                Role: 'DeploymentValidation'
              }
              service: 'sites-slot1'
            }
          ]
          basicPublishingCredentialsPolicies: [
            {
              name: 'ftp'
              allow: false
            }
            {
              name: 'scm'
              allow: false
            }
          ]
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
          siteConfig: {
            alwaysOn: true
            metadata: [
              {
                name: 'CURRENT_STACK'
                value: 'dotnetcore'
              }
            ]
          }
          configs: [
            {
              name: 'appsettings'
              storageAccountResourceId: nestedDependencies.outputs.storageAccountResourceId
              storageAccountUseIdentityAuthentication: true
              applicationInsightResourceId: nestedDependencies.outputs.applicationInsightsResourceId
            }
          ]
          hybridConnectionRelays: [
            {
              hybridConnectionResourceId: nestedDependencies.outputs.hybridConnectionResourceId
              sendKeyName: 'defaultSender'
            }
          ]
        }
        {
          name: 'slot2'
          basicPublishingCredentialsPolicies: [
            {
              name: 'ftp'
            }
            {
              name: 'scm'
            }
          ]
          configs: [
            {
              name: 'appsettings'
              storageAccountResourceId: nestedDependencies.outputs.storageAccountResourceId
              storageAccountUseIdentityAuthentication: true
            }
          ]
        }
      ]
      privateEndpoints: [
        {
          subnetResourceId: nestedDependencies.outputs.subnetResourceId
          privateDnsZoneGroup: {
            privateDnsZoneGroupConfigs: [
              {
                privateDnsZoneResourceId: nestedDependencies.outputs.privateDNSZoneResourceId
              }
            ]
          }
          tags: {
            'hidden-title': 'This is visible in the resource name'
            Environment: 'Non-Prod'
            Role: 'DeploymentValidation'
          }
        }
        {
          subnetResourceId: nestedDependencies.outputs.subnetResourceId
          privateDnsZoneGroup: {
            privateDnsZoneGroupConfigs: [
              {
                privateDnsZoneResourceId: nestedDependencies.outputs.privateDNSZoneResourceId
              }
            ]
          }
        }
      ]
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
      siteConfig: {
        alwaysOn: true
        metadata: [
          {
            name: 'CURRENT_STACK'
            value: 'dotnetcore'
          }
        ]
      }
      configs: [
        {
          name: 'appsettings'
          storageAccountResourceId: nestedDependencies.outputs.storageAccountResourceId
          storageAccountUseIdentityAuthentication: true
          applicationInsightResourceId: nestedDependencies.outputs.applicationInsightsResourceId
          properties: {
            ApplicationInsightsAgent_EXTENSION_VERSION: '~3'
          }
        }
      ]
      managedIdentities: {
        systemAssigned: true
        userAssignedResourceIds: [
          nestedDependencies.outputs.managedIdentityResourceId
        ]
      }
      basicPublishingCredentialsPolicies: [
        {
          name: 'ftp'
          allow: false
        }
        {
          name: 'scm'
          allow: false
        }
      ]
      hybridConnectionRelays: [
        {
          hybridConnectionResourceId: nestedDependencies.outputs.hybridConnectionResourceId
          sendKeyName: 'defaultSender'
        }
      ]
      scmSiteAlsoStopped: true
      outboundVnetRouting: {
        allTraffic: true
        contentShareTraffic: true
        imagePullTraffic: true
      }
      publicNetworkAccess: 'Disabled'
      clientAffinityProxyEnabled: true
      clientAffinityPartitioningEnabled: false
      hostNamesDisabled: false
      reserved: true
      ipMode: 'IPv4'
    }
  }
]
