targetScope = 'subscription'

metadata name = 'Web App, using large parameter set'
metadata description = 'This instance deploys the module as Web App with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-web.sites-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'wswamax'

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
    serverFarmName: 'dep-${namePrefix}-sf-${serviceShort}'
    relayNamespaceName: 'dep-${namePrefix}-ns-${serviceShort}'
    storageAccountName: 'dep${namePrefix}st${serviceShort}'
    hybridConnectionName: 'dep-${namePrefix}-hc-${serviceShort}'
    apiManagementName: 'dep-${namePrefix}-apim-${serviceShort}'
    location: resourceLocation
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
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
      kind: 'app'
      serverFarmResourceId: nestedDependencies.outputs.serverFarmResourceId
      dnsConfiguration: {
        dnsMaxCacheTimeout: 45
        dnsRetryAttemptCount: 3
        dnsRetryAttemptTimeout: 5
        dnsServers: [
          '168.63.129.16'
        ]
      }
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
          dnsConfiguration: {
            dnsMaxCacheTimeout: 45
            dnsRetryAttemptCount: 3
            dnsRetryAttemptTimeout: 5
            dnsServers: [
              '168.63.129.20'
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
          roleAssignments: [
            {
              name: '845ed19c-78e7-4422-aa3d-b78b67cd78a2'
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
          name: '0c2c82ef-069c-4085-b1bc-01614e0aa5ff'
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
          // Persisted on service in 'Settings/Environment variables'
          name: 'appsettings'
          storageAccountResourceId: nestedDependencies.outputs.storageAccountResourceId
          storageAccountUseIdentityAuthentication: true
        }
        {
          // Persisted on service in 'Monitoring/App Service logs'
          name: 'logs'
          properties: {
            applicationLogs: { fileSystem: { level: 'Verbose' } }
            detailedErrorMessages: { enabled: true }
            failedRequestsTracing: { enabled: true }
            httpLogs: { fileSystem: { enabled: true, retentionInDays: 1, retentionInMb: 35 } }
          }
        }
        {
          // Persisted on service in 'API/API Management'
          name: 'web'
          properties: {
            ipSecurityRestrictions: [
              {
                action: 'Allow'
                description: 'Test IP Restriction'
                tag: 'ServiceTag'
                name: 'Test Restriction'
                priority: 200
                ipAddress: 'ApiManagement'
              }
            ]
            apiManagementConfig: {
              id: '${nestedDependencies.outputs.apiManagementResourceId}/apis/todo-api'
            }
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
      vnetContentShareEnabled: true
      vnetImagePullEnabled: true
      vnetRouteAllEnabled: true
      publicNetworkAccess: 'Disabled'
    }
  }
]
