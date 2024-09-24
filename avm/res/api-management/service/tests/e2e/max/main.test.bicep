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
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    locationRegion1: resourceLocation
    locationRegion2: locationRegion2
    publicIPName: 'dep-${namePrefix}-pip-${serviceShort}'
    publicIpDnsLabelPrefix: 'dep-${namePrefix}-dnsprefix-${uniqueString(deployment().name, resourceLocation)}'
    networkSecurityGroupName: 'nsg'
    virtualNetworkName: 'vnet'
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
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

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      location: resourceLocation
      publisherEmail: 'apimgmt-noreply@mail.windowsazure.com'
      publisherName: '${namePrefix}-az-amorg-x-001'
      additionalLocations: [
        {
          location: '${locationRegion2}'
          sku: {
            name: 'Premium'
            capacity: 1
          }
          disableGateway: false
          publicIpAddressId: nestedDependencies.outputs.publicIPResourceIdRegion2
          virtualNetworkConfiguration: {
            subnetResourceId: nestedDependencies.outputs.subnetResourceIdRegion2
          }
        }
      ]
      virtualNetworkType: 'Internal'
      subnetResourceId: nestedDependencies.outputs.subnetResourceIdRegion1
      publicIpAddressResourceId: nestedDependencies.outputs.publicIPResourceIdRegion1
      apis: [
        {
          apiVersionSet: {
            name: 'echo-version-set'
            properties: {
              description: 'echo-version-set'
              displayName: 'echo-version-set'
              versioningScheme: 'Segment'
            }
          }
          displayName: 'Echo API'
          name: 'echo-api'
          path: 'echo'
          serviceUrl: 'http://echoapi.cloudapp.net/api'
        }
      ]
      authorizationServers: {
        secureList: [
          {
            authorizationEndpoint: '${environment().authentication.loginEndpoint}651b43ce-ccb8-4301-b551-b04dd872d401/oauth2/v2.0/authorize'
            clientId: 'apimclientid'
            clientSecret: customSecret
            clientRegistrationEndpoint: 'http://localhost'
            grantTypes: [
              'authorizationCode'
            ]
            name: 'AuthServer1'
            tokenEndpoint: '${environment().authentication.loginEndpoint}651b43ce-ccb8-4301-b551-b04dd872d401/oauth2/v2.0/token'
          }
        ]
      }
      backends: [
        {
          name: 'backend'
          tls: {
            validateCertificateChain: false
            validateCertificateName: false
          }
          url: 'http://echoapi.cloudapp.net/api'
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
          signinTenant: 'mytenant.onmicrosoft.com'
          allowedTenants: [
            'mytenant.onmicrosoft.com'
          ]
        }
      ]
      loggers: [
        {
          name: 'logger'
          loggerType: 'applicationInsights'
          isBuffered: false
          description: 'Logger to Azure Application Insights'
          credentials: {
            instrumentationKey: nestedDependencies.outputs.appInsightsInstrumentationKey
          }
          resourceId: nestedDependencies.outputs.appInsightsResourceId
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
              consentRequired: false
              enabled: false
            }
          }
        }
      ]
      products: [
        {
          apis: [
            {
              name: 'echo-api'
            }
          ]
          approvalRequired: false
          groups: [
            {
              name: 'developers'
            }
          ]
          name: 'Starter'
          subscriptionRequired: false
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
    dependsOn: [
      nestedDependencies
      diagnosticDependencies
    ]
  }
]
