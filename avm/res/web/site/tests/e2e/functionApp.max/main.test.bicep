targetScope = 'subscription'

metadata name = 'Function App, using large parameter set'
metadata description = 'This instance deploys the module as Function App with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-web.sites-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'wsfamax'

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
    storageAccountName: 'dep${namePrefix}st${serviceShort}'
    applicationInsightsName: 'dep-${namePrefix}-appi-${serviceShort}'
    relayNamespaceName: 'dep-${namePrefix}-ns-${serviceShort}'
    hybridConnectionName: 'dep-${namePrefix}-hc-${serviceShort}'
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
// For the below test case, please consider the guidelines described here: https://github.com/Azure/ResourceModules/wiki/Getting%20started%20-%20Scenario%202%20Onboard%20module%20library%20and%20CI%20environment#microsoftwebsites
@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      location: enforcedLocation
      kind: 'functionapp'
      serverFarmResourceId: nestedDependencies.outputs.serverFarmResourceId
      configs: [
        {
          // Persisted on service in 'Settings/Environment variables'
          name: 'appsettings'
          applicationInsightResourceId: nestedDependencies.outputs.applicationInsightsResourceId
          storageAccountResourceId: nestedDependencies.outputs.storageAccountResourceId
          storageAccountUseIdentityAuthentication: true
          properties: {
            AzureFunctionsJobHost__logging__logLevel__default: 'Trace'
            EASYAUTH_SECRET: 'https://${namePrefix}-KeyVault${environment().suffixes.keyvaultDns}/secrets/Modules-Test-SP-Password'
            FUNCTIONS_EXTENSION_VERSION: '~4'
            FUNCTIONS_WORKER_RUNTIME: 'dotnet'
          }
        }
        {
          // Persisted on service in 'Settings/Authentication'
          name: 'authsettingsV2'
          properties: {
            globalValidation: {
              requireAuthentication: true
              unauthenticatedClientAction: 'Return401'
            }
            httpSettings: {
              forwardProxy: {
                convention: 'NoProxy'
              }
              requireHttps: true
              routes: {
                apiPrefix: '/.auth'
              }
            }
            identityProviders: {
              azureActiveDirectory: {
                enabled: true
                login: {
                  disableWWWAuthenticate: false
                }
                registration: {
                  clientId: 'd874dd2f-2032-4db1-a053-f0ec243685aa'
                  clientSecretSettingName: 'EASYAUTH_SECRET'
                  openIdIssuer: 'https://sts.windows.net/${tenant().tenantId}/v2.0/'
                }
                validation: {
                  allowedAudiences: [
                    'api://d874dd2f-2032-4db1-a053-f0ec243685aa'
                  ]
                  defaultAuthorizationPolicy: {
                    allowedPrincipals: {}
                  }
                  jwtClaimChecks: {}
                }
              }
            }
            login: {
              allowedExternalRedirectUrls: [
                'string'
              ]
              cookieExpiration: {
                convention: 'FixedTime'
                timeToExpiration: '08:00:00'
              }
              nonce: {
                nonceExpirationInterval: '00:05:00'
                validateNonce: true
              }
              preserveUrlFragmentsForLogins: false
              routes: {}
              tokenStore: {
                azureBlobStorage: {}
                enabled: true
                fileSystem: {}
                tokenRefreshExtensionHours: 72
              }
            }
            platform: {
              enabled: true
              runtimeVersion: '~1'
            }
          }
        }
      ]
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
              name: '845ed19c-78e7-4422-aa3d-b78b67cd1234'
              roleDefinitionIdOrName: 'Owner'
              principalId: nestedDependencies.outputs.managedIdentityPrincipalId
              principalType: 'ServicePrincipal'
            }
            {
              name: guid('A custom seed ${namePrefix}${serviceShort}')
              roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
              principalId: nestedDependencies.outputs.managedIdentityPrincipalId
              principalType: 'ServicePrincipal'
            }
            {
              roleDefinitionIdOrName: subscriptionResourceId(
                'Microsoft.Authorization/roleDefinitions',
                'de139f84-1756-47ae-9be6-808fbbe84772'
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
              applicationInsightResourceId: nestedDependencies.outputs.applicationInsightsResourceId
              properties: {
                ApplicationInsightsAgent_EXTENSION_VERSION: '~2'
              }
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
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
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
          name: '9efc9c10-f482-4af0-9acb-03b5a16f947e'
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
      keyVaultAccessIdentityResourceId: nestedDependencies.outputs.managedIdentityResourceId
      siteConfig: {
        alwaysOn: true
        use32BitWorkerProcess: false
      }
      managedIdentities: {
        systemAssigned: true
        userAssignedResourceIds: [
          nestedDependencies.outputs.managedIdentityResourceId
        ]
      }
      hybridConnectionRelays: [
        {
          hybridConnectionResourceId: nestedDependencies.outputs.hybridConnectionResourceId
          sendKeyName: 'defaultSender'
        }
      ]
      scmSiteAlsoStopped: true
      publicNetworkAccess: 'Disabled'
      outboundVnetRouting: {
        allTraffic: true
        contentShareTraffic: true
        imagePullTraffic: true
      }
      clientAffinityProxyEnabled: true
      clientAffinityPartitioningEnabled: false
      hostNamesDisabled: false
      ipMode: 'IPv4'
    }
  }
]
