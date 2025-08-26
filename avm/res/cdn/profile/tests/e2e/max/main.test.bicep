targetScope = 'subscription'

metadata name = 'Using maximum parameter set'
metadata description = 'This instance deploys the module with all available features and parameters for Premium_AzureFrontDoor SKU.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-cdn.profiles-${serviceShort}-rg'

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
      name: 'dep-${namePrefix}-test-${serviceShort}'
      location: 'global'
      sku: 'Premium_AzureFrontDoor'
      originResponseTimeoutSeconds: 240

      // Managed Identity
      managedIdentities: {
        systemAssigned: true
        userAssignedResourceIds: [
          nestedDependencies.outputs.managedIdentityPrincipalId
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

      // Secrets (for customer certificates)
      secrets: [
        {
          name: 'dep-${namePrefix}-secret-${serviceShort}'
          secretSource: {
            id: '/subscriptions/subscription-id/resourceGroups/rg-name/providers/Microsoft.KeyVault/vaults/vault-name/secrets/secret-name'
          }
          secretVersion: 'latest'
          useLatestVersion: true
        }
      ]

      // Custom Domains with all possible configurations
      customDomains: [
        {
          name: 'dep-${namePrefix}-test1-${serviceShort}-custom-domain'
          hostName: 'dep-${namePrefix}-test1-${serviceShort}-custom-domain.azurewebsites.net'
          certificateType: 'ManagedCertificate'
          minimumTlsVersion: 'TLS12'
          azureDnsZoneResourceId: ''
          extendedProperties: {
            customProperty1: 'value1'
            customProperty2: 'value2'
          }
          preValidatedCustomDomainResourceId: ''
          secretName: ''
          cipherSuiteSetType: ''
          customizedCipherSuiteSet: {}
        }
        {
          name: 'dep-${namePrefix}-test2-${serviceShort}-custom-domain'
          hostName: 'dep-${namePrefix}-test2-${serviceShort}-custom-domain.azurewebsites.net'
          certificateType: 'ManagedCertificate'
          minimumTlsVersion: 'TLS12'
          cipherSuiteSetType: 'TLS12_2022'
          azureDnsZoneResourceId: ''
          extendedProperties: {}
          preValidatedCustomDomainResourceId: ''
          secretName: ''
          customizedCipherSuiteSet: {}
        }
        {
          name: 'dep-${namePrefix}-test3-${serviceShort}-custom-domain'
          hostName: 'dep-${namePrefix}-test3-${serviceShort}-custom-domain.azurewebsites.net'
          certificateType: 'ManagedCertificate'
          minimumTlsVersion: 'TLS13'
          cipherSuiteSetType: 'Customized'
          customizedCipherSuiteSet: {
            cipherSuiteSetForTls12: [
              'DHE_RSA_AES128_GCM_SHA256'
              'DHE_RSA_AES256_GCM_SHA384'
              'ECDHE_RSA_AES128_GCM_SHA256'
              'ECDHE_RSA_AES256_GCM_SHA384'
              'DHE_RSA_AES128_CBC_SHA256'
              'DHE_RSA_AES256_CBC_SHA256'
              'ECDHE_RSA_AES128_CBC_SHA256'
              'ECDHE_RSA_AES256_CBC_SHA384'
            ]
            cipherSuiteSetForTls13: [
              'TLS_AES_128_GCM_SHA256'
              'TLS_AES_256_GCM_SHA384'
              'TLS_CHACHA20_POLY1305_SHA256'
            ]
          }
          azureDnsZoneResourceId: ''
          extendedProperties: {}
          preValidatedCustomDomainResourceId: ''
          secretName: ''
        }
        {
          name: 'dep-${namePrefix}-test4-${serviceShort}-custom-domain'
          hostName: 'dep-${namePrefix}-test4-${serviceShort}-custom-domain.azurewebsites.net'
          certificateType: 'CustomerCertificate'
          minimumTlsVersion: 'TLS12'
          secretName: 'dep-${namePrefix}-secret-${serviceShort}'
          azureDnsZoneResourceId: ''
          extendedProperties: {}
          preValidatedCustomDomainResourceId: ''
          cipherSuiteSetType: ''
          customizedCipherSuiteSet: {}
        }
      ]

      // Origin Groups with comprehensive settings
      originGroups: [
        {
          name: 'dep-${namePrefix}-test-${serviceShort}-origin-group-1'
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
              name: 'dep-${namePrefix}-test-${serviceShort}-origin-1'
              hostName: 'dep-${namePrefix}-test-${serviceShort}-origin-1.azurewebsites.net'
              httpPort: 80
              httpsPort: 443
              originHostHeader: 'dep-${namePrefix}-test-${serviceShort}-origin-1.azurewebsites.net'
              priority: 1
              weight: 1000
              enabledState: 'Enabled'
              enforceCertificateNameCheck: true
              sharedPrivateLinkResource: {}
            }
            {
              name: 'dep-${namePrefix}-test-${serviceShort}-origin-2'
              hostName: 'dep-${namePrefix}-test-${serviceShort}-origin-2.azurewebsites.net'
              httpPort: 8080
              httpsPort: 8443
              originHostHeader: 'dep-${namePrefix}-test-${serviceShort}-origin-2.azurewebsites.net'
              priority: 2
              weight: 500
              enabledState: 'Enabled'
              enforceCertificateNameCheck: false
              sharedPrivateLinkResource: {}
            }
          ]
        }
        {
          name: 'dep-${namePrefix}-test-${serviceShort}-origin-group-2'
          loadBalancingSettings: {
            additionalLatencyInMilliseconds: 100
            sampleSize: 6
            successfulSamplesRequired: 4
          }
          healthProbeSettings: {
            probePath: '/api/health'
            probeProtocol: 'Http'
            probeRequestType: 'HEAD'
            probeIntervalInSeconds: 240
          }
          sessionAffinityState: 'Disabled'
          trafficRestorationTimeToHealedOrNewEndpointsInMinutes: 10
          origins: [
            {
              name: 'dep-${namePrefix}-test-${serviceShort}-origin-3'
              hostName: 'dep-${namePrefix}-test-${serviceShort}-origin-3.azurewebsites.net'
              httpPort: 80
              httpsPort: 443
              originHostHeader: 'dep-${namePrefix}-test-${serviceShort}-origin-3.azurewebsites.net'
              priority: 1
              weight: 1000
              enabledState: 'Enabled'
              enforceCertificateNameCheck: true
              sharedPrivateLinkResource: {}
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
                {
                  name: 'RequestMethod'
                  parameters: {
                    typeName: 'DeliveryRuleRequestMethodConditionParameters'
                    operator: 'Equal'
                    negateCondition: false
                    matchValues: ['GET', 'POST']
                    transforms: []
                  }
                }
                {
                  name: 'RequestUri'
                  parameters: {
                    typeName: 'DeliveryRuleRequestUriConditionParameters'
                    operator: 'BeginsWith'
                    negateCondition: false
                    matchValues: ['/api/']
                    transforms: ['Lowercase']
                  }
                }
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
                    customQueryString: 'version=2'
                    customFragment: 'section1'
                  }
                }
                {
                  name: 'ModifyResponseHeader'
                  parameters: {
                    typeName: 'DeliveryRuleHeaderActionParameters'
                    headerAction: 'Append'
                    headerName: 'X-Custom-Header'
                    value: 'CustomValue'
                  }
                }
                {
                  name: 'ModifyRequestHeader'
                  parameters: {
                    typeName: 'DeliveryRuleHeaderActionParameters'
                    headerAction: 'Overwrite'
                    headerName: 'X-Forwarded-For'
                    value: '{client_ip}'
                  }
                }
              ]
            }
            {
              name: 'dep${namePrefix}test${serviceShort}rule2'
              order: 2
              matchProcessingBehavior: 'Stop'
              conditions: [
                {
                  name: 'RequestHeader'
                  parameters: {
                    typeName: 'DeliveryRuleRequestHeaderConditionParameters'
                    operator: 'Contains'
                    negateCondition: false
                    matchValues: ['mobile']
                    headerName: 'User-Agent'
                    transforms: ['Lowercase']
                  }
                }
              ]
              actions: [
                {
                  name: 'UrlRewrite'
                  parameters: {
                    typeName: 'DeliveryRuleUrlRewriteActionParameters'
                    sourcePattern: '/old-path/(.*)'
                    destination: '/new-path/$1'
                    preserveUnmatchedPath: false
                  }
                }
                {
                  name: 'CacheExpiration'
                  parameters: {
                    typeName: 'DeliveryRuleCacheExpirationActionParameters'
                    cacheBehavior: 'Override'
                    cacheType: 'All'
                    cacheDuration: '1.00:00:00'
                  }
                }
              ]
            }
          ]
        }
        {
          name: 'dep${namePrefix}test${serviceShort}ruleset2'
          rules: [
            {
              name: 'dep${namePrefix}test${serviceShort}rule3'
              order: 1
              matchProcessingBehavior: 'Continue'
              conditions: [
                {
                  name: 'RequestScheme'
                  parameters: {
                    typeName: 'DeliveryRuleRequestSchemeConditionParameters'
                    operator: 'Equal'
                    negateCondition: false
                    matchValues: ['HTTP']
                  }
                }
              ]
              actions: [
                {
                  name: 'UrlRedirect'
                  parameters: {
                    typeName: 'DeliveryRuleUrlRedirectActionParameters'
                    redirectType: 'PermanentRedirect'
                    destinationProtocol: 'Https'
                    customPath: ''
                    customHostname: ''
                    customQueryString: ''
                    customFragment: ''
                  }
                }
              ]
            }
          ]
        }
      ]

      // AFD Endpoints with comprehensive routing
      afdEndpoints: [
        {
          name: 'dep-${namePrefix}-test-${serviceShort}-afd-endpoint-1'
          autoGeneratedDomainNameLabelScope: 'TenantReuse'
          enabledState: 'Enabled'
          tags: {
            EndpointType: 'Primary'
            Purpose: 'API'
          }
          routes: [
            {
              name: 'dep-${namePrefix}-test-${serviceShort}-afd-route-1'
              originGroupName: 'dep-${namePrefix}-test-${serviceShort}-origin-group-1'
              customDomainNames: [
                'dep-${namePrefix}-test1-${serviceShort}-custom-domain'
                'dep-${namePrefix}-test2-${serviceShort}-custom-domain'
              ]
              enabledState: 'Enabled'
              forwardingProtocol: 'MatchRequest'
              httpsRedirect: 'Enabled'
              linkToDefaultDomain: 'Enabled'
              originPath: '/v1'
              patternsToMatch: ['/api/*', '/health']
              supportedProtocols: ['Http', 'Https']
              cacheConfiguration: {
                queryStringCachingBehavior: 'IncludeSpecifiedQueryStrings'
                queryParameters: 'version,locale'
                compressionSettings: {
                  contentTypesToCompress: [
                    'application/json'
                    'application/javascript'
                    'text/css'
                    'text/html'
                    'text/plain'
                    'text/xml'
                    'application/xml'
                    'font/woff'
                    'font/woff2'
                  ]
                  isCompressionEnabled: true
                }
              }
              ruleSets: [
                {
                  name: 'dep${namePrefix}test${serviceShort}ruleset1'
                }
              ]
            }
            {
              name: 'dep-${namePrefix}-test-${serviceShort}-afd-route-2'
              originGroupName: 'dep-${namePrefix}-test-${serviceShort}-origin-group-2'
              customDomainNames: [
                'dep-${namePrefix}-test3-${serviceShort}-custom-domain'
              ]
              enabledState: 'Enabled'
              forwardingProtocol: 'HttpsOnly'
              httpsRedirect: 'Enabled'
              linkToDefaultDomain: 'Disabled'
              originPath: '/v2'
              patternsToMatch: ['/admin/*', '/dashboard/*']
              supportedProtocols: ['Https']
              cacheConfiguration: {
                queryStringCachingBehavior: 'IgnoreQueryString'
                queryParameters: ''
                compressionSettings: {
                  contentTypesToCompress: [
                    'application/json'
                    'text/html'
                    'text/css'
                  ]
                  isCompressionEnabled: true
                }
              }
              ruleSets: [
                {
                  name: 'dep${namePrefix}test${serviceShort}ruleset2'
                }
              ]
            }
          ]
        }
        {
          name: 'dep-${namePrefix}-test-${serviceShort}-afd-endpoint-2'
          autoGeneratedDomainNameLabelScope: 'SubscriptionReuse'
          enabledState: 'Enabled'
          tags: {
            EndpointType: 'Secondary'
            Purpose: 'Static'
          }
          routes: [
            {
              name: 'dep-${namePrefix}-test-${serviceShort}-afd-route-3'
              originGroupName: 'dep-${namePrefix}-test-${serviceShort}-origin-group-1'
              customDomainNames: [
                'dep-${namePrefix}-test4-${serviceShort}-custom-domain'
              ]
              enabledState: 'Enabled'
              forwardingProtocol: 'HttpOnly'
              httpsRedirect: 'Disabled'
              linkToDefaultDomain: 'Enabled'
              originPath: '/static'
              patternsToMatch: ['/images/*', '/css/*', '/js/*']
              supportedProtocols: ['Http']
              cacheConfiguration: {
                queryStringCachingBehavior: 'UseQueryString'
                queryParameters: ''
                compressionSettings: {
                  contentTypesToCompress: [
                    'text/css'
                    'application/javascript'
                    'text/plain'
                    'image/svg+xml'
                  ]
                  isCompressionEnabled: true
                }
              }
              ruleSets: []
            }
          ]
        }
      ]

      // Security Policies (Premium feature)
      securityPolicies: [
        {
          name: 'dep-${namePrefix}-test-${serviceShort}-security-policy-1'
          wafPolicyResourceId: '/subscriptions/subscription-id/resourceGroups/rg-name/providers/Microsoft.Network/FrontDoorWebApplicationFirewallPolicies/waf-policy-name'
          associations: [
            {
              domains: [
                {
                  id: 'dep-${namePrefix}-test1-${serviceShort}-custom-domain'
                }
                {
                  id: 'dep-${namePrefix}-test2-${serviceShort}-custom-domain'
                }
              ]
              patternsToMatch: ['/api/*', '/admin/*']
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
          name: '50362c78-6910-43c3-8639-9cae123943bb'
          roleDefinitionIdOrName: 'Owner'
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
        {
          name: guid('Custom seed ${namePrefix}${serviceShort}')
          roleDefinitionIdOrName: 'CDN Profile Contributor'
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
        {
          roleDefinitionIdOrName: 'CDN Endpoint Reader'
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
output systemAssignedMIPrincipalId string = testDeployment[0].outputs.?systemAssignedMIPrincipalId
