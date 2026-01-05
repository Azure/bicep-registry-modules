targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-apimanagement.service-${serviceShort}-rg'

@description('Optional. Location to deploy secondary resources to for APIM additionalLocations.')
param locationRegion2 string = 'westus'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'apismax'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. The secret to leverage for authorization server authentication.')
@secure()
param customSecret string = newGuid()

// Enforcing location due to limited availability of the APIM Worskpace Gateway SKU in certain regions.
#disable-next-line no-hardcoded-location
var enforcedLocation = 'uksouth'

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
    locationRegion1: enforcedLocation
    locationRegion2: locationRegion2
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    publicIPNamePrefix: 'dep-${namePrefix}-pip-${serviceShort}'
    publicIpDnsLabelPrefix: 'dep-${namePrefix}-dnsprefix-${uniqueString(deployment().name, enforcedLocation)}'
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
  name: '${uniqueString(deployment().name, enforcedLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}azsa${serviceShort}01'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}'
  }
}

// ============== //
// Test Execution //
// ============== //

var apimName = '${namePrefix}${serviceShort}001'
var backend1Name = 'backend1'
var workspace1Name = 'workspace1'
var workspace1Backend1Name = 'workspace1-backend1'
@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: apimName
      location: enforcedLocation
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
          diagnostics: [
            {
              loggerName: 'logger'
              metrics: true
              name: 'applicationinsights'
            }
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
      serviceDiagnostics: [
        {
          name: 'applicationinsights'
          loggerResourceId: '${resourceGroup.id}/providers/Microsoft.ApiManagement/service/${apimName}/loggers/logger'
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
          name: workspace1Name
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
              apiVersionSetName: 'workspace1-version-set'
              protocols: [
                'https'
              ]
              subscriptionRequired: true
              type: 'http'
              policies: [
                {
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
                      name: 'policy'
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
              name: 'workspace1-version-set'
              displayName: 'workspace1-version-set'
              description: 'Version set for workspace1 APIs'
              versioningScheme: 'Segment'
            }
          ]
          backends: [
            {
              name: workspace1Backend1Name
              type: 'Single'
              description: 'Test workspace backend with maximum properties'
              tls: {
                validateCertificateChain: false
                validateCertificateName: false
              }
              url: 'http://workspace-echoapi.cloudapp.net/api'
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
                url: 'http://wks-myproxy:8888'
                username: 'proxyUser'
                password: 'proxyPassword'
              }
            }
          ]
          diagnostics: [
            {
              name: 'applicationinsights'
              loggerResourceId: '${resourceGroup.id}/providers/Microsoft.ApiManagement/service/${apimName}/workspaces/${workspace1Name}/loggers/workspace-logger'
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
              displayName: 'WorkspaceNamedValue'
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
                  apiResourceId: '${resourceGroup.id}/providers/Microsoft.ApiManagement/service/${apimName}/workspaces/${workspace1Name}/apis/workspace-echo-api'
                }
              ]
              groupLinks: [
                {
                  name: 'workspace-group-link'
                  groupResourceId: '${resourceGroup.id}/providers/Microsoft.ApiManagement/service/${apimName}/groups/developers'
                }
              ]
              policies: [
                {
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
              scope: '${resourceGroup.id}/providers/Microsoft.ApiManagement/service/${apimName}/workspaces/${workspace1Name}/apis/workspace-echo-api'
              allowTracing: true
              state: 'active'
            }
          ]
          gateway: {
            name: '${apimName}-${workspace1Name}-gw'
            capacity: 1
            virtualNetworkType: 'None'
          }
          diagnosticSettings: [
            {
              name: 'customSetting'
              eventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
              eventHubAuthorizationRuleResourceId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
              storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
              workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
            }
          ]
          roleAssignments: [
            {
              name: '832142e9-a3da-4881-9838-c2b8c73ad1e7'
              roleDefinitionIdOrName: 'Owner'
              principalId: nestedDependencies.outputs.managedIdentityPrincipalId
              principalType: 'ServicePrincipal'
            }
            {
              name: guid('Custom seed ${namePrefix}${serviceShort}${workspace1Name}')
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
            {
              roleDefinitionIdOrName: 'API Management Workspace Contributor'
              principalId: nestedDependencies.outputs.managedIdentityPrincipalId
              principalType: 'ServicePrincipal'
            }
          ]
        }
        {
          name: 'workspace2'
          displayName: 'Test Workspace 2'
          description: 'A test workspace with a gateway using External VNet'
          gateway: {
            name: '${apimName}-workspace2-gw'
            capacity: 1
            virtualNetworkType: 'External'
            subnetResourceId: nestedDependencies.outputs.workspaceGatewaySubnetResourceId
          }
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
