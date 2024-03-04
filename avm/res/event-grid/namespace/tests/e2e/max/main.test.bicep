targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-eventgrid.namespace-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'egnmax'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
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
    eventHubName: 'dep-${namePrefix}-evh-${serviceShort}'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}'
    location: resourceLocation
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}diasa${serviceShort}01'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${uniqueString(serviceShort, namePrefix)}-evh-01'
    eventHubNamespaceName: 'dep-${uniqueString(serviceShort, namePrefix)}-evh-01'
    location: resourceLocation
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [for iteration in [ 'init', 'idem' ]: {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
  params: {
    name: '${namePrefix}${serviceShort}001'
    location: resourceLocation
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        nestedDependencies.outputs.managedIdentityResourceId
      ]
    }
    // lock: {
    //   kind: 'CanNotDelete'
    //   name: 'myCustomLockName'
    // }
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
    privateEndpoints: [
      {
        subnetResourceId: nestedDependencies.outputs.subnetResourceId
        privateDnsZoneResourceIds: [
          nestedDependencies.outputs.privateDNSZoneResourceId
        ]
        tags: {
          'hidden-title': 'This is visible in the resource name'
          Environment: 'Non-Prod'
          Role: 'DeploymentValidation'
        }
      }
      {
        subnetResourceId: nestedDependencies.outputs.subnetResourceId
        privateDnsZoneResourceIds: [
          nestedDependencies.outputs.privateDNSZoneResourceId
        ]
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
        roleDefinitionIdOrName: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
        principalId: nestedDependencies.outputs.managedIdentityPrincipalId
        principalType: 'ServicePrincipal'
      }
    ]
    tags: {
      'hidden-title': 'This is visible in the resource name'
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
    topics: [
      {
        name: 'topic1'
        eventRetentionInDays: 7
        eventSubscriptions: [
          {
            name: 'subscription1'
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
                roleDefinitionIdOrName: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
                principalId: nestedDependencies.outputs.managedIdentityPrincipalId
                principalType: 'ServicePrincipal'
              }
            ]
            deliveryConfiguration: {
              deliveryMode: 'Queue'
              queue: {
                receiveLockDurationInSeconds: 60
                maxDeliveryCount: 10
                eventTimeToLive: 'P7D'
              }
            }
          }
          {
            name: 'subscription2'
            deliveryConfiguration: {
              deliveryMode: 'Push'
              push: {
                maxDeliveryCount: 10
                eventTimeToLive: 'P7D'
                deliveryWithResourceIdentity: {
                  identity: {
                    type: 'UserAssigned'
                    userAssignedIdentity: nestedDependencies.outputs.managedIdentityResourceId
                  }
                  destination: {
                    endpointType: 'EventHub'
                    properties: {
                      resourceId: nestedDependencies.outputs.eventHubResourceId
                      deliveryAttributeMappings: [
                        {
                          properties: {
                            value: 'staticVaule'
                            isSecret: false
                          }
                          name: 'StaticHeader1'
                          type: 'Static'
                        }
                        {
                          properties: {
                            sourceField: 'id'
                          }
                          name: 'DynamicHeader1'
                          type: 'Dynamic'
                        }
                        {
                          properties: {
                            value: 'Hidden'
                            isSecret: true
                          }
                          name: 'StaticSecretHeader1'
                          type: 'Static'
                        }
                      ]
                    }
                  }
                }
              }
            }
          }
        ]
      }
      {
        name: 'topic2'
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
            roleDefinitionIdOrName: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
            principalId: nestedDependencies.outputs.managedIdentityPrincipalId
            principalType: 'ServicePrincipal'
          }
        ]
        lock: {
          kind: 'CanNotDelete'
          name: 'myCustomLockName'
        }
      }
    ]
    topicSpacesState: 'Enabled'
    maximumClientSessionsPerAuthenticationName: 95
    maximumSessionExpiryInHours: 6
    alternativeAuthenticationNameSources: [
      'ClientCertificateEmail'
      'ClientCertificateUri'
    ]
    // caCertificates: [
    //   {
    //     name: 'exampleCert'
    //     encodedCertificate: '''
    //     '''
    //   }
    // ]
    clients: [
      {
        name: 'client1'
        authenticationName: 'client2auth'
        description: 'this is client2'
        clientCertificateAuthenticationValidationSchema: 'ThumbprintMatch'
        clientCertificateAuthenticationAllowedThumbprints: [
          '1111111111111111111111111111111111111111'
          '2222222222222222222222222222222222222222'
        ]
        state: 'Enabled'
        attributes: {
          room: '345'
          floor: 12
          deviceTypes: [
            'Fan'
            'Light'
          ]
        }
      }
      {
        name: 'client2'
        clientCertificateAuthenticationValidationSchema: 'ThumbprintMatch'
        clientCertificateAuthenticationAllowedThumbprints: [
          '3333333333333333333333333333333333333333'
        ]
      }
      {
        name: 'client3'
      }
      {
        name: 'client4'
        clientCertificateAuthenticationValidationSchema: 'IpMatchesAuthenticationName'
      }
    ]
    clientGroups: [
      {
        name: 'group1'
        query: 'attributes.keyName IN [\'a\', \'b\', \'c\']'
        description: 'this is group1'
      }
    ]
  }
}]
