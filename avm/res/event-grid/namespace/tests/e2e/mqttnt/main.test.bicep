targetScope = 'subscription'

metadata name = 'MQTT Broker with routing to a custom topic'
metadata description = 'This instance deploys the module as a MQTT Broker with routing to a custom topic.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-eventgrid.namespace-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'egnmqttnt'

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
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    eventGridNamespaceName: '${namePrefix}${serviceShort}001'
    eventGridNamespaceTopicName: 'topic1'
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
      managedIdentities: {
        userAssignedResourceIds: [
          nestedDependencies.outputs.managedIdentityResourceId
        ]
      }
      topics: [
        {
          name: 'topic1'
        }
      ]
      topicSpacesState: 'Enabled'
      maximumClientSessionsPerAuthenticationName: 5
      maximumSessionExpiryInHours: 2
      routeTopicResourceId: nestedDependencies.outputs.eventGridNameSpaceTopicResourceId
      routingIdentityInfo: {
        type: 'UserAssigned'
        userAssignedIdentity: nestedDependencies.outputs.managedIdentityResourceId
      }
      routingEnrichments: {
        static: [
          {
            key: 'static1'
            value: 'value1'
            valueType: 'String'
          }
          {
            key: 'static2'
            value: 'value2'
            valueType: 'String'
          }
        ]
        dynamic: [
          {
            key: 'dynamic1'
            value: '\${client.authenticationName}'
          }
        ]
      }
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
      topicSpaces: [
        {
          name: 'topicSpace1'
          topicTemplates: [
            'devices/foo/bar'
            'devices/topic1/+'
          ]
        }
        {
          name: 'topicSpace2'
          topicTemplates: [
            'devices/topic1/+'
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
              roleDefinitionIdOrName: subscriptionResourceId(
                'Microsoft.Authorization/roleDefinitions',
                'acdd72a7-3385-48ef-bd42-f606fba81ae7'
              )
              principalId: nestedDependencies.outputs.managedIdentityPrincipalId
              principalType: 'ServicePrincipal'
            }
          ]
        }
      ]
      permissionBindings: [
        {
          name: 'bindiing1'
          description: 'this is binding1'
          clientGroupName: 'group1'
          topicSpaceName: 'topicSpace1'
          permission: 'Publisher'
        }
        {
          name: 'bindiing2'
          clientGroupName: 'group1'
          topicSpaceName: 'topicSpace2'
          permission: 'Subscriber'
        }
      ]
    }
  }
]
