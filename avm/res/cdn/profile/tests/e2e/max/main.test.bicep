targetScope = 'subscription'

metadata name = 'Using maximum parameter set'
metadata description = 'This instance deploys the module with all available features and parameters for Premium_AzureFrontDoor SKU.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-cdn.profiles.max-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'cdnpmax'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}cdnstore${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    location: resourceLocation
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}diasa${serviceShort}03'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}01'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}01'
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
      name: '${namePrefix}-test-${serviceShort}'
      location: 'global'
      sku: 'Premium_AzureFrontDoor'
      originResponseTimeoutSeconds: 240

      // Managed Identity
      managedIdentities: {
        systemAssigned: true
        userAssignedResourceIds: [
          nestedDependencies.outputs.managedIdentityResourceId
        ]
      }

      // Lock configuration
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
        notes: 'This resource cannot be deleted for security reasons.'
      }

      // Tags
      tags: {
        Environment: 'Test'
        Application: 'CDN'
        CostCenter: '12345'
        Owner: 'TestTeam'
      }

      // Custom Domains with simplified configurations (FIXED)
      customDomains: [
        {
          name: '${namePrefix}-test1-${serviceShort}-custom-domain'
          hostName: '${namePrefix}-test1-${serviceShort}-custom-domain.azurewebsites.net'
          certificateType: 'ManagedCertificate'
          minimumTlsVersion: 'TLS12'
        }
        {
          name: '${namePrefix}-test2-${serviceShort}-custom-domain'
          hostName: '${namePrefix}-test2-${serviceShort}-custom-domain.azurewebsites.net'
          certificateType: 'ManagedCertificate'
          minimumTlsVersion: 'TLS12'
          cipherSuiteSetType: 'TLS12_2022'
        }
        {
          name: '${namePrefix}-test3-${serviceShort}-custom-domain'
          hostName: '${namePrefix}-test3-${serviceShort}-custom-domain.azurewebsites.net'
          certificateType: 'ManagedCertificate'
          minimumTlsVersion: 'TLS13'
          cipherSuiteSetType: 'Customized'
          customizedCipherSuiteSet: {
            // cipherSuiteSetForTls12: [
            //   'DHE_RSA_AES128_GCM_SHA256'
            //   'DHE_RSA_AES256_GCM_SHA384'
            //   'ECDHE_RSA_AES128_GCM_SHA256'
            //   'ECDHE_RSA_AES256_GCM_SHA384'
            // ]
            cipherSuiteSetForTls13: [
              'TLS_AES_128_GCM_SHA256'
              'TLS_AES_256_GCM_SHA384'
            ]
          }
        }
      ]

      // Origin Groups with realistic hostnames (FIXED)
      originGroups: [
        {
          name: '${namePrefix}-test-${serviceShort}-origin-group-1'
          loadBalancingSettings: {
            additionalLatencyInMilliseconds: 50
            sampleSize: 4
            successfulSamplesRequired: 3
          }
          healthProbeSettings: {
            probePath: '/health'
            probeProtocol: 'Https'
            probeRequestType: 'GET'
            probeIntervalInSeconds: 120
          }
          sessionAffinityState: 'Enabled'
          trafficRestorationTimeToHealedOrNewEndpointsInMinutes: 15
          origins: [
            {
              name: '${namePrefix}-test-${serviceShort}-origin-1'
              hostName: '${nestedDependencies.outputs.storageAccountName}.blob.${environment().suffixes.storage}'
              httpPort: 80
              httpsPort: 443
              priority: 1
              weight: 1000
              enabledState: 'Enabled'
              enforceCertificateNameCheck: true
            }
          ]
        }
        {
          name: '${namePrefix}-test-${serviceShort}-origin-group-2'
          loadBalancingSettings: {
            additionalLatencyInMilliseconds: 100
            sampleSize: 6
            successfulSamplesRequired: 4
          }
          sessionAffinityState: 'Disabled'
          trafficRestorationTimeToHealedOrNewEndpointsInMinutes: 10
          origins: [
            {
              name: '${namePrefix}-test-${serviceShort}-origin-2'
              hostName: '${nestedDependencies.outputs.storageAccountName}.blob.${environment().suffixes.storage}'
              httpPort: 80
              httpsPort: 443
              priority: 1
              weight: 1000
              enabledState: 'Enabled'
              enforceCertificateNameCheck: true
            }
          ]
        }
      ]

      // Rule Sets with comprehensive rules
      ruleSets: [
        {
          name: 'dep${namePrefix}test${serviceShort}ruleset1'
          rules: [
            {
              name: 'dep${namePrefix}test${serviceShort}rule1'
              order: 1
              matchProcessingBehavior: 'Continue'
              conditions: [
                // {
                //   name: 'RequestMethod'
                //   parameters: {
                //     typeName: 'DeliveryRuleRequestMethodConditionParameters'
                //     operator: 'Equal'
                //     negateCondition: false
                //     matchValues: ['GET', 'POST']
                //     transforms: []
                //   }
                // }
              ]
              actions: [
                {
                  name: 'UrlRedirect'
                  parameters: {
                    typeName: 'DeliveryRuleUrlRedirectActionParameters'
                    redirectType: 'PermanentRedirect'
                    destinationProtocol: 'Https'
                    customPath: '/v2/api/'
                    customHostname: 'api.example.com'
                  }
                }
              ]
            }
          ]
        }
      ]

      // AFD Endpoints with simplified routing (FIXED)
      afdEndpoints: [
        {
          name: '${namePrefix}-test-${serviceShort}-afd-endpoint-1'
          autoGeneratedDomainNameLabelScope: 'TenantReuse'
          enabledState: 'Enabled'
          routes: [
            {
              name: '${namePrefix}-test-${serviceShort}-afd-route-1'
              originGroupName: '${namePrefix}-test-${serviceShort}-origin-group-1'
              customDomainNames: [
                '${namePrefix}-test1-${serviceShort}-custom-domain'
              ]
              enabledState: 'Enabled'
              forwardingProtocol: 'MatchRequest'
              httpsRedirect: 'Enabled'
              linkToDefaultDomain: 'Enabled'
              patternsToMatch: ['/api/*', '/health']
              supportedProtocols: ['Http', 'Https']
              cacheConfiguration: {
                queryStringCachingBehavior: 'IncludeSpecifiedQueryStrings'
                queryParameters: 'version,locale'
                compressionSettings: {
                  contentTypesToCompress: [
                    'application/json'
                    'text/css'
                    'text/html'
                  ]
                  isCompressionEnabled: true
                }
              }
              ruleSets: [
                'dep${namePrefix}test${serviceShort}ruleset1'
              ]
            }
          ]
        }
      ]

      // Diagnostics settings
      diagnosticSettings: [
        {
          name: 'customSetting'
          logCategoriesAndGroups: [
            {
              categoryGroup: 'allLogs'
              enabled: true
            }
          ]
          metricCategories: [
            {
              category: 'AllMetrics'
              enabled: true
            }
          ]
          eventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
          eventHubAuthorizationRuleResourceId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
          storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
          workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
        }
      ]

      // Role assignments
      roleAssignments: [
        {
          roleDefinitionIdOrName: 'CDN Profile Contributor'
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
      ]
    }
  }
]

// =========== //
//   Outputs   //
// =========== //

@description('The name of the CDN profile.')
output profileName string = testDeployment[0].outputs.name

@description('The resource ID of the CDN profile.')
output profileResourceId string = testDeployment[0].outputs.resourceId

@description('The DNS validation records for custom domains.')
output dnsValidationRecords array = testDeployment[0].outputs.dnsValidation

@description('The AFD endpoint host names.')
output afdEndpointNames array = testDeployment[0].outputs.frontDoorEndpointHostNames

@description('The resource group name.')
output resourceGroupName string = resourceGroup.name

@description('The system-assigned managed identity principal ID.')
output systemAssignedMIPrincipalId string? = testDeployment[0].outputs.?systemAssignedMIPrincipalId
