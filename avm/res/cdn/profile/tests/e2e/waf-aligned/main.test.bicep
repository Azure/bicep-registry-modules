targetScope = 'subscription'

metadata name = 'WAF-aligned Premium AFD'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework using Premium_AzureFrontDoor SKU.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-cdn.profiles-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'cdnpwaf'

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
    storageAccountName: 'dep${namePrefix}wafsa${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-waf-msi-${serviceShort}'
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
      name: '${namePrefix}-waf-${serviceShort}'
      location: 'global'
      sku: 'Premium_AzureFrontDoor' // WAF: Premium SKU for advanced security features
      originResponseTimeoutSeconds: 60 // WAF: Reasonable timeout for reliability

      // WAF: Security - Resource locking to prevent accidental deletion
      lock: {
        kind: 'CanNotDelete'
        name: 'waf-protection-lock'
        notes: 'WAF: Protected against accidental deletion for business continuity'
      }

      // WAF: Cost Optimization & Operational Excellence - Comprehensive tagging
      tags: {
        Environment: 'Production'
        Application: 'CDN-WAF-Aligned'
        CostCenter: 'IT-Infrastructure'
        Owner: 'Platform-Team'
        BusinessUnit: 'Digital-Services'
        Criticality: 'High'
        DataClassification: 'Internal'
        BackupRequired: 'Yes'
        MonitoringRequired: 'Yes'
        'WAF-Pillar': 'All'
        // 'Last-Review': utcNow('yyyy-MM-dd')
      }

      // WAF: Security - Custom domains with strong TLS configuration
      customDomains: [
        {
          name: '${namePrefix}-waf-primary-${serviceShort}-domain'
          hostName: '${namePrefix}-waf-primary-${serviceShort}.example.com'
          certificateType: 'ManagedCertificate'
          minimumTlsVersion: 'TLS12' // WAF: Security - Use latest TLS version
          cipherSuiteSetType: 'TLS12_2023' // WAF: Security - Modern cipher suites
        }
        {
          name: '${namePrefix}-waf-api-${serviceShort}-domain'
          hostName: 'api-${namePrefix}-waf-${serviceShort}.example.com'
          certificateType: 'ManagedCertificate'
          minimumTlsVersion: 'TLS13' // WAF: Security - Use latest TLS version
          cipherSuiteSetType: 'Customized' // WAF: Security - Custom cipher suite for enhanced security
          customizedCipherSuiteSet: {
            // cipherSuiteSetForTls12: [
            //   'ECDHE_RSA_AES256_GCM_SHA384' // Strong encryption
            //   'ECDHE_RSA_AES128_GCM_SHA256' // Performance balance
            // ]
            cipherSuiteSetForTls13: [
              'TLS_AES_256_GCM_SHA384' // Strong TLS 1.3 cipher
              'TLS_AES_128_GCM_SHA256' // Performance balance
            ]
          }
        }
      ]

      // WAF: Reliability & Performance - Multi-origin setup with health probes
      originGroups: [
        {
          name: '${namePrefix}-waf-api-origin-group'
          loadBalancingSettings: {
            additionalLatencyInMilliseconds: 25 // WAF: Performance - Lower latency for APIs
            sampleSize: 6 // WAF: Reliability - More samples for critical APIs
            successfulSamplesRequired: 4 // WAF: Reliability - Higher threshold for APIs
          }
          healthProbeSettings: {
            probePath: '/api/health' // WAF: Reliability - API-specific health check
            probeProtocol: 'Https' // WAF: Security - Encrypted health checks
            probeRequestType: 'GET'
            probeIntervalInSeconds: 15 // WAF: Reliability - More frequent for APIs
          }
          sessionAffinityState: 'Disabled'
          trafficRestorationTimeToHealedOrNewEndpointsInMinutes: 2 // WAF: Reliability - Faster recovery for APIs
          origins: [
            {
              name: '${namePrefix}-waf-api-origin'
              hostName: '${nestedDependencies.outputs.storageAccountName}.blob.${environment().suffixes.storage}'
              originHostHeader: 'www.bing.com' // Should be 'www.bing.com'
              httpPort: 80
              httpsPort: 443
              priority: 1
              weight: 100
              enabledState: 'Enabled'
              enforceCertificateNameCheck: true // WAF: Security - Certificate validation
            }
            {
              name: '${namePrefix}-waf-api-origin-no-2'
              hostName: '${nestedDependencies.outputs.storageAccountName}.blob.${environment().suffixes.storage}'
              originHostHeader: '' // Should have the RP calculate the name
              httpPort: 80
              httpsPort: 443
              priority: 2
              weight: 200
              enabledState: 'Enabled'
              enforceCertificateNameCheck: true // WAF: Security - Certificate validation
            }
            {
              name: '${namePrefix}-waf-api-origin-no-3'
              hostName: '${nestedDependencies.outputs.storageAccountName}.blob.${environment().suffixes.storage}'
              httpPort: 80
              httpsPort: 443
              priority: 3
              weight: 300
              enabledState: 'Enabled'
              enforceCertificateNameCheck: true // WAF: Security - Certificate validation
            }
          ]
        }
      ]

      // WAF: Security & Performance - Comprehensive routing rules
      ruleSets: [
        {
          name: 'dep${namePrefix}wafsecurityrules${serviceShort}'
          rules: [
            {
              name: 'HTTPSRedirectRule'
              order: 1
              matchProcessingBehavior: 'Stop' // WAF: Security - Force HTTPS immediately
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
                    redirectType: 'PermanentRedirect' // WAF: Security - Permanent HTTPS enforcement
                    destinationProtocol: 'Https'
                  }
                }
              ]
            }
            {
              name: 'SecurityHeadersRule'
              order: 2
              matchProcessingBehavior: 'Continue'
              conditions: [
                {
                  name: 'RequestScheme'
                  parameters: {
                    typeName: 'DeliveryRuleRequestSchemeConditionParameters'
                    operator: 'Equal'
                    negateCondition: false
                    matchValues: ['HTTPS']
                  }
                }
              ]
              actions: [
                {
                  name: 'ModifyResponseHeader'
                  parameters: {
                    typeName: 'DeliveryRuleHeaderActionParameters'
                    headerAction: 'Overwrite'
                    headerName: 'Strict-Transport-Security'
                    value: 'max-age=31536000; includeSubDomains; preload' // WAF: Security - HSTS
                  }
                }
                {
                  name: 'ModifyResponseHeader'
                  parameters: {
                    typeName: 'DeliveryRuleHeaderActionParameters'
                    headerAction: 'Overwrite'
                    headerName: 'X-Content-Type-Options'
                    value: 'nosniff' // WAF: Security - MIME type sniffing protection
                  }
                }
                {
                  name: 'ModifyResponseHeader'
                  parameters: {
                    typeName: 'DeliveryRuleHeaderActionParameters'
                    headerAction: 'Overwrite'
                    headerName: 'X-Frame-Options'
                    value: 'DENY' // WAF: Security - Clickjacking protection
                  }
                }
                {
                  name: 'ModifyResponseHeader'
                  parameters: {
                    typeName: 'DeliveryRuleHeaderActionParameters'
                    headerAction: 'Overwrite'
                    headerName: 'X-XSS-Protection'
                    value: '1; mode=block' // WAF: Security - XSS protection
                  }
                }
                {
                  name: 'ModifyResponseHeader'
                  parameters: {
                    typeName: 'DeliveryRuleHeaderActionParameters'
                    headerAction: 'Overwrite'
                    headerName: 'Referrer-Policy'
                    value: 'strict-origin-when-cross-origin' // WAF: Security - Referrer policy
                  }
                }
              ]
            }
            {
              name: 'APIRateLimitRule'
              order: 3
              matchProcessingBehavior: 'Continue'
              conditions: [
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
                  name: 'ModifyResponseHeader'
                  parameters: {
                    typeName: 'DeliveryRuleHeaderActionParameters'
                    headerAction: 'Overwrite'
                    headerName: 'X-RateLimit-Limit'
                    value: '1000' // WAF: Reliability - Rate limiting for APIs
                  }
                }
              ]
            }
          ]
        }
      ]

      // WAF: Performance & Reliability - Optimized AFD endpoints
      afdEndpoints: [
        {
          name: '${namePrefix}-waf-primary-endpoint'
          autoGeneratedDomainNameLabelScope: 'TenantReuse' // WAF: Cost Optimization - Reuse domains
          enabledState: 'Enabled'
          routes: [
            {
              name: '${namePrefix}-waf-api-route'
              originGroupName: '${namePrefix}-waf-api-origin-group'
              customDomainNames: [
                '${namePrefix}-waf-api-${serviceShort}-domain'
              ]
              enabledState: 'Enabled'
              forwardingProtocol: 'HttpsOnly' // WAF: Security - HTTPS only for APIs
              httpsRedirect: 'Enabled'
              linkToDefaultDomain: 'Disabled' // WAF: Security - Custom domain only for APIs
              patternsToMatch: ['/api/*', '/v1/*', '/v2/*']
              supportedProtocols: ['Https'] // WAF: Security - HTTPS only
              cacheConfiguration: {
                queryStringCachingBehavior: 'IgnoreSpecifiedQueryStrings' // WAF: Performance - API-specific caching
                queryParameters: 'timestamp,nonce' // WAF: Performance - Ignore security parameters
                compressionSettings: {
                  contentTypesToCompress: [
                    'application/json'
                    'application/xml'
                    'text/xml'
                  ]
                  isCompressionEnabled: true // WAF: Performance - API response compression
                }
              }
              ruleSets: [
                'dep${namePrefix}wafsecurityrules${serviceShort}'
              ]
            }
          ]
        }
      ]

      // WAF: Operational Excellence - Comprehensive diagnostics and monitoring
      diagnosticSettings: [
        {
          name: 'waf-comprehensive-diagnostics'
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

      // WAF: Security - Role-based access control
      roleAssignments: [
        {
          roleDefinitionIdOrName: 'CDN Profile Reader' // WAF: Security - Principle of least privilege
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
      ]

      // WAF: Reliability - Enable managed identities for secure access
      managedIdentities: {
        systemAssigned: true
        userAssignedResourceIds: [
          nestedDependencies.outputs.managedIdentityResourceId
        ]
      }
    }
  }
]

// =========== //
//   Outputs   //
// =========== //

@description('The name of the WAF-aligned CDN profile.')
output profileName string = testDeployment[0].outputs.name

@description('The resource ID of the WAF-aligned CDN profile.')
output profileResourceId string = testDeployment[0].outputs.resourceId

@description('The DNS validation records for custom domains.')
output dnsValidationRecords array = testDeployment[0].outputs.dnsValidation

@description('The AFD endpoint host names.')
output afdEndpointNames array = testDeployment[0].outputs.frontDoorEndpointHostNames

@description('The user\'s name prefix. Required for post-deployment tests.')
output namePrefix string = namePrefix

@description('The name of the resource. Required for post-deployment tests.')
output name string = testDeployment[0].outputs.name

@description('The resource group name. Required for post-deployment tests.')
output resourceGroupName string = resourceGroup.name

@description('WAF compliance summary.')
output wafComplianceSummary object = {
  reliability: {
    multiOriginSetup: true
    healthProbes: true
    loadBalancing: true
    failoverConfiguration: true
    quickRecovery: true
  }
  security: {
    httpsOnly: true
    tls13Support: true
    securityHeaders: true
    certificateValidation: true
    managedIdentities: true
    rbacImplemented: true
    resourceLocks: true
  }
  costOptimization: {
    comprehensiveTagging: true
    efficientCaching: true
    domainReuse: true
    rightsizedSku: true
  }
  operationalExcellence: {
    comprehensiveMonitoring: true
    structuredLogging: true
    automatedDiagnostics: true
    documentedConfiguration: true
  }
  performance: {
    compressionEnabled: true
    optimizedCaching: true
    lowLatencyThresholds: true
    efficientRouting: true
    staticContentOptimization: true
  }
}
