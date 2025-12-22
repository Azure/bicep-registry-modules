targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-apimanagement.service-${serviceShort}-rg'

@description('Optional. The location to deploy primary resources to.')
param resourceLocation string = deployment().location

@description('Optional. Location to deploy secondary resources to for APIM additionalLocations.')
param locationRegion2 string = 'westus'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'apismax'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. The secret to leverage for authorization server authentication.')
@secure()
param customSecret string = newGuid()

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
    locationRegion1: resourceLocation
    locationRegion2: locationRegion2
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    publicIPNamePrefix: 'dep-${namePrefix}-pip-${serviceShort}'
    publicIpDnsLabelPrefix: 'dep-${namePrefix}-dnsprefix-${uniqueString(deployment().name, resourceLocation)}'
    networkSecurityGroupNamePrefix: 'dep-${namePrefix}-nsg-${serviceShort}'
    virtualNetworkNamePrefix: 'dep-${namePrefix}-vnet-${serviceShort}'
    routeTableNamePrefix: 'dep-${namePrefix}-rt-${serviceShort}'
    applicationInsightsName: 'dep-${namePrefix}-ai-${serviceShort}'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-s-${serviceShort}'
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}azsa${serviceShort}01'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}'
    location: resourceLocation
  }
}

// ============== //
// Test Execution //
// ============== //

var apimName = '${namePrefix}${serviceShort}001'
var backend1Name = 'backend1'
@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: apimName
      location: resourceLocation
      publisherEmail: 'apimgmt-noreply@mail.windowsazure.com'
      publisherName: '${namePrefix}-az-amorg-x-001'
      additionalLocations: [
        {
          location: locationRegion2
          sku: {
            name: 'Premium'
            capacity: 1
          }
          disableGateway: false
          virtualNetworkConfiguration: {
            subnetResourceId: nestedDependencies.outputs.subnetResourceIdRegion2
          }
        }
      ]
      virtualNetworkType: 'External'
      subnetResourceId: nestedDependencies.outputs.subnetResourceIdRegion1
      publicNetworkAccess: 'Enabled'
      apis: [
        {
          displayName: 'Echo API'
          apiVersionSetName: 'echo-version-set'
          name: 'echo-api'
          path: 'echo'
          serviceUrl: 'http://echoapi.cloudapp.net/api'
          protocols: [
            'http'
            'https'
          ]
        }
      ]
      apiVersionSets: [
        {
          name: 'echo-version-set'
          description: 'echo-version-set'
          displayName: 'echo-version-set'
          versioningScheme: 'Segment'
        }
      ]
      authorizationServers: [
        {
          authorizationEndpoint: '${environment().authentication.loginEndpoint}651b43ce-ccb8-4301-b551-b04dd872d401/oauth2/v2.0/authorize'
          clientId: 'apimclientid'
          clientSecret: customSecret
          clientRegistrationEndpoint: 'http://localhost'
          grantTypes: [
            'authorizationCodeWithPkce'
          ]
          name: 'AuthServer1'
          displayName: 'AuthServer1'
          tokenEndpoint: '${environment().authentication.loginEndpoint}651b43ce-ccb8-4301-b551-b04dd872d401/oauth2/v2.0/token'
        }
      ]
      backends: [
        {
          name: backend1Name
          type: 'Single'
          description: 'Test backend with maximum properties'
          tls: {
            validateCertificateChain: false
            validateCertificateName: false
          }
          url: 'http://echoapi.cloudapp.net/api'
          circuitBreaker: {
            rules: [
              {
                name: 'rule1'
                failureCondition: {
                  count: 1
                  interval: 'PT1H'
                  statusCodeRanges: [
                    { min: 400, max: 499 }
                    { min: 500, max: 599 }
                  ]
                  errorReasons: ['OperationNotFound', 'ClientConnectionFailure']
                }
                acceptRetryAfter: false
                tripDuration: 'PT1H'
              }
            ]
          }
          credentials: {
            authorization: {
              parameter: 'dXNlcm5hbWU6c2VjcmV0cGFzc3dvcmQ=' // base64 encoded 'username:secretpassword'
              scheme: 'Basic'
            }
            query: {
              queryParam1: [
                'value1'
              ]
            }
            header: {}
          }
          proxy: {
            url: 'http://myproxy:8888'
            username: 'proxyUser'
            password: 'proxyPassword'
          }
        }
        {
          name: 'backend2'
          type: 'Pool'
          pool: {
            services: [
              {
                id: '${resourceGroup.id}/providers/Microsoft.ApiManagement/service/${apimName}/backends/${backend1Name}'
              }
            ]
          }
        }
      ]
      caches: [
        {
          connectionString: 'connectionstringtest'
          name: 'westeurope'
          useFromLocation: 'westeurope'
        }
      ]
      apiDiagnostics: [
        {
          loggerName: 'logger'
          apiName: 'echo-api'
          metrics: true
          name: 'applicationinsights'
        }
      ]
      serviceDiagnostics: [
        {
          name: 'applicationinsights'
          loggerId: '${resourceGroup.id}/providers/Microsoft.ApiManagement/service/${apimName}/loggers/logger'
          alwaysLog: 'allErrors'
          httpCorrelationProtocol: 'W3C'
          logClientIp: true
          metrics: true
          operationNameFormat: 'Url'
          samplingPercentage: 100
          verbosity: 'verbose'
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
      identityProviders: [
        {
          name: 'aad'
          clientId: 'apimClientid'
          clientLibrary: 'MSAL-2'
          clientSecret: 'apimSlientSecret'
          authority: split(environment().authentication.loginEndpoint, '/')[2]
          signInTenant: 'mytenant.onmicrosoft.com'
          allowedTenants: [
            'mytenant.onmicrosoft.com'
          ]
        }
      ]
      loggers: [
        {
          name: 'logger'
          type: 'applicationInsights'
          isBuffered: false
          description: 'Logger to Azure Application Insights'
          credentials: {
            instrumentationKey: nestedDependencies.outputs.appInsightsInstrumentationKey
          }
          targetResourceId: nestedDependencies.outputs.appInsightsResourceId
        }
        {
          name: 'azuremonitor'
          type: 'azureMonitor'
          isBuffered: true
        }
      ]
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
      namedValues: [
        {
          displayName: 'apimkey'
          name: 'apimkey'
          secret: true
        }
      ]
      policies: [
        {
          name: 'policy1'
          format: 'xml'
          value: '<policies> <inbound> <rate-limit-by-key calls=\'250\' renewal-period=\'60\' counter-key=\'@(context.Request.IpAddress)\' /> </inbound> <backend> <forward-request /> </backend> <outbound> </outbound> </policies>'
        }
      ]
      portalsettings: [
        {
          name: 'signin'
          properties: {
            enabled: false
          }
        }
        {
          name: 'signup'
          properties: {
            enabled: false
            termsOfService: {
              consentRequired: true
              enabled: true
              text: 'Terms of service text'
            }
          }
        }
      ]
      products: [
        {
          apis: [
            'echo-api'
          ]
          approvalRequired: false
          groups: [
            'developers'
          ]
          name: 'Starter'
          displayName: 'Starter'
          subscriptionRequired: false
          policies: [
            {
              name: 'productPolicy1'
              format: 'xml'
              value: '<policies> <inbound> <rate-limit-by-key calls=\'250\' renewal-period=\'60\' counter-key=\'@(context.Request.IpAddress)\' /> </inbound> <backend> <forward-request /> </backend> <outbound> </outbound> </policies>'
            }
          ]
        }
      ]
      roleAssignments: [
        {
          name: '6352c3e3-ac6b-43d5-ac43-1077ff373721'
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
      subscriptions: [
        {
          name: 'testArmSubscriptionAllApis'
          scope: '/apis'
          displayName: 'testArmSubscriptionAllApis'
        }
      ]
      workspaces: [
        {
          name: 'test-workspace-1'
          displayName: 'Test Workspace 1'
          description: 'A comprehensive test workspace with all child modules'
          apis: [
            {
              name: 'workspace-echo-api'
              displayName: 'Workspace Echo API'
              path: 'workspace-echo'
              serviceUrl: 'http://echoapi.cloudapp.net/api'
              apiRevision: '1'
              apiRevisionDescription: 'Initial revision of workspace API'
              apiType: 'http'
              apiVersion: 'v1'
              apiVersionDescription: 'Version 1 of workspace API'
              description: 'Workspace Echo API for testing'
              format: 'openapi+json'
              isCurrent: true
              protocols: [
                'https'
              ]
              subscriptionRequired: true
              type: 'http'
              policies: [
                {
                  name: 'workspaceApiPolicy'
                  format: 'xml'
                  value: '<policies><inbound><base /></inbound><backend><base /></backend><outbound><base /></outbound></policies>'
                }
              ]
              operations: [
                {
                  name: 'get-resource'
                  displayName: 'Get Resource'
                  method: 'GET'
                  urlTemplate: '/resource'
                  description: 'Get resource operation'
                  policies: [
                    {
                      name: 'operationPolicy'
                      format: 'xml'
                      value: '<policies><inbound><base /></inbound><backend><base /></backend><outbound><base /></outbound></policies>'
                    }
                  ]
                }
              ]
              diagnostics: [
                {
                  name: 'applicationinsights'
                  loggerName: 'workspace-logger'
                  alwaysLog: 'allErrors'
                  httpCorrelationProtocol: 'W3C'
                  logClientIp: true
                  metrics: true
                  operationNameFormat: 'Url'
                  samplingPercentage: 100
                  verbosity: 'verbose'
                }
              ]
            }
          ]
          apiVersionSets: [
            {
              name: 'workspace-version-set'
              displayName: 'Workspace Version Set'
              description: 'Version set for workspace APIs'
              versioningScheme: 'Segment'
            }
          ]
          backends: [
            {
              name: 'workspace-backend'
              type: 'Single'
              title: 'Workspace Backend'
              description: 'Backend for workspace APIs'
              url: 'https://workspace-backend.example.com'
              protocol: 'http'
              tls: {
                validateCertificateChain: true
                validateCertificateName: true
              }
              credentials: {
                authorization: {
                  parameter: 'd29ya3NwYWNlLWF1dGg=' // base64 encoded 'workspace-auth'
                  scheme: 'Basic'
                }
                header: {
                  'x-workspace-header': [
                    'workspace-value'
                  ]
                }
              }
            }
          ]
          diagnostics: [
            {
              name: 'applicationinsights'
              loggerId: '${resourceGroup.id}/providers/Microsoft.ApiManagement/service/${apimName}/workspaces/test-workspace/loggers/workspace-logger'
              alwaysLog: 'allErrors'
              httpCorrelationProtocol: 'W3C'
              logClientIp: true
              metrics: true
              operationNameFormat: 'Url'
              samplingPercentage: 100
              verbosity: 'verbose'
            }
          ]
          loggers: [
            {
              name: 'workspace-logger'
              type: 'applicationInsights'
              description: 'Workspace Application Insights Logger'
              isBuffered: false
              credentials: {
                instrumentationKey: nestedDependencies.outputs.appInsightsInstrumentationKey
              }
              targetResourceId: nestedDependencies.outputs.appInsightsResourceId
            }
          ]
          namedValues: [
            {
              name: 'workspace-named-value'
              displayName: 'Workspace Named Value'
              value: 'workspace-secret-value'
              secret: true
              tags: [
                'test'
                'max-test'
              ]
            }
          ]
          policies: [
            {
              name: 'workspace-policy'
              format: 'xml'
              value: '<policies><inbound><rate-limit-by-key calls="100" renewal-period="60" counter-key="@(context.Request.IpAddress)" /></inbound><backend><forward-request /></backend><outbound></outbound></policies>'
            }
          ]
          products: [
            {
              name: 'workspace-product'
              displayName: 'Workspace Product'
              description: 'A test product in workspace with all features'
              approvalRequired: true
              subscriptionRequired: true
              subscriptionsLimit: 5
              state: 'published'
              terms: 'Terms and conditions for workspace product'
              apiLinks: [
                {
                  name: 'workspace-api-link'
                  apiId: '${resourceGroup.id}/providers/Microsoft.ApiManagement/service/${apimName}/workspaces/test-workspace/apis/workspace-echo-api'
                }
              ]
              groupLinks: [
                {
                  name: 'workspace-group-link'
                  groupId: '${resourceGroup.id}/providers/Microsoft.ApiManagement/service/${apimName}/groups/developers'
                }
              ]
              policies: [
                {
                  name: 'workspace-product-policy'
                  format: 'xml'
                  value: '<policies><inbound><quota-by-key calls="1000" renewal-period="3600" counter-key="@(context.Subscription.Id)" /></inbound><backend><forward-request /></backend><outbound></outbound></policies>'
                }
              ]
            }
          ]
          subscriptions: [
            {
              name: 'workspace-subscription'
              displayName: 'Workspace Test Subscription'
              scope: '${resourceGroup.id}/providers/Microsoft.ApiManagement/service/${apimName}/workspaces/test-workspace-1/apis/workspace-echo-api'
              allowTracing: true
              state: 'active'
            }
          ]
        }
        {
          name: 'test-workspace-2'
          displayName: 'Test Workspace 2'
          description: 'Second test workspace with minimal configuration'
          apis: [
            {
              name: 'workspace-simple-api'
              displayName: 'Workspace Simple API'
              path: 'workspace-simple'
              serviceUrl: 'https://simple-backend.example.com/api'
              protocols: [
                'https'
                'http'
              ]
              subscriptionRequired: false
              type: 'http'
            }
            {
              name: 'workspace-graphql-api'
              displayName: 'Workspace GraphQL API'
              path: 'workspace-graphql'
              apiType: 'graphql'
              type: 'graphql'
              description: 'GraphQL API in workspace'
              protocols: [
                'https'
              ]
            }
          ]
          apiVersionSets: [
            {
              name: 'workspace-version-set-2'
              displayName: 'Workspace Version Set 2'
              versioningScheme: 'Header'
              versionHeaderName: 'api-version'
            }
          ]
          backends: [
            {
              name: 'workspace-backend-2'
              type: 'Single'
              url: 'https://backend2.example.com'
              description: 'Second workspace backend with minimal config'
            }
            {
              name: 'workspace-pool-backend'
              type: 'Pool'
              description: 'Pool backend in workspace'
              pool: {
                services: [
                  {
                    id: '${resourceGroup.id}/providers/Microsoft.ApiManagement/service/${apimName}/workspaces/test-workspace-2/backends/workspace-backend-2'
                  }
                ]
              }
            }
          ]
          diagnostics: [
            {
              name: 'applicationinsights'
              loggerId: '${resourceGroup.id}/providers/Microsoft.ApiManagement/service/${apimName}/workspaces/test-workspace-2/loggers/ws2-logger'
              metrics: true
              operationNameFormat: 'Name'
              samplingPercentage: 50
            }
          ]
          loggers: [
            {
              name: 'ws2-logger'
              type: 'azureMonitor'
              description: 'Azure Monitor logger for workspace 2'
              isBuffered: true
            }
          ]
          namedValues: [
            {
              name: 'ws2-config-value'
              displayName: 'Workspace 2 Config'
              value: 'workspace-2-config'
            }
          ]
          policies: [
            {
              name: 'ws2-policy'
              format: 'rawxml'
              value: '<policies><inbound><set-header name="X-Workspace" exists-action="override"><value>workspace-2</value></set-header></inbound><backend><forward-request /></backend><outbound></outbound></policies>'
            }
          ]
          products: [
            {
              name: 'ws2-product'
              displayName: 'Workspace 2 Product'
              subscriptionRequired: false
              state: 'notPublished'
              apiLinks: [
                {
                  name: 'ws2-api-link'
                  apiId: '${resourceGroup.id}/providers/Microsoft.ApiManagement/service/${apimName}/workspaces/test-workspace-2/apis/workspace-simple-api'
                }
              ]
            }
          ]
          subscriptions: [
            {
              name: 'ws2-subscription'
              displayName: 'Workspace 2 Subscription'
              scope: '/apis'
              allowTracing: false
              state: 'submitted'
            }
          ]
        }
      ]
      managedIdentities: {
        systemAssigned: true
        userAssignedResourceIds: [
          nestedDependencies.outputs.managedIdentityResourceId
        ]
      }
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
  }
]
