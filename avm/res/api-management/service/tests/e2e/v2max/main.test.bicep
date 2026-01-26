targetScope = 'subscription'

metadata name = 'Deploying an APIM PremiumV2 SKU with a large parameter set'
metadata description = 'This instance deploys the PremiumV2 SKU with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-apimanagement.service-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'apisv2max'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. The secret to leverage for authorization server authentication.')
@secure()
param customSecret string = newGuid()

// Enforcing test locations due to limited availability of the APIM PremiumV2 SKU in certain regions.
var enforcedLocation = 'uksouth'
var enforcedLocationRegion2 = 'germanywestcentral'

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
    locationRegion2: enforcedLocationRegion2
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
@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: apimName
      location: enforcedLocation
      sku: 'PremiumV2'
      availabilityZones: []
      publisherEmail: 'apimgmt-noreply@mail.windowsazure.com'
      publisherName: '${namePrefix}-az-amorg-x-001'
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
            'authorizationCode'
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
          name: '6432d807-dc34-488e-8b15-9c560f79b111'
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
