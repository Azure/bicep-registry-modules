targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-digitaltwins.digitaltwinsinstances-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dtdtiwaf'

@description('Optional. A token to inject into the name of each resource.')
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
    eventHubName: 'dep-${uniqueString(serviceShort)}-dti-evh-01'
    eventHubNamespaceName: 'dep-${uniqueString(serviceShort)}-dti-evhns-01'
    serviceBusName: 'dep-${uniqueString(serviceShort)}-sb-01'
    eventGridDomainName: 'dep-${uniqueString(serviceShort)}-evg-01'
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}diasa${serviceShort}03'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${uniqueString(serviceShort)}-evh-01'
    eventHubNamespaceName: 'dep-${uniqueString(serviceShort)}-evh-01'
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
    eventHubEndpoint: {
      authenticationType: 'IdentityBased'
      endpointUri: 'sb://${nestedDependencies.outputs.eventhubNamespaceName}.servicebus.windows.net/'
      entityPath: nestedDependencies.outputs.eventhubName
      managedIdentities: {
        userAssignedResourceId: nestedDependencies.outputs.managedIdentityResourceId
      }
    }
    serviceBusEndpoint: {
      authenticationType: 'IdentityBased'
      endpointUri: 'sb://${nestedDependencies.outputs.serviceBusName}.servicebus.windows.net/'
      entityPath: nestedDependencies.outputs.serviceBusTopicName
      managedIdentities: {
        userAssignedResourceId: nestedDependencies.outputs.managedIdentityResourceId
      }
    }
    eventGridEndpoint: {
      eventGridDomainId: nestedDependencies.outputs.eventGridDomainResourceId
      topicEndpoint: nestedDependencies.outputs.eventGridEndpoint
    }
    name: '${namePrefix}${serviceShort}001'
    managedIdentities: {
      userAssignedResourceIds: [
        nestedDependencies.outputs.managedIdentityResourceId
      ]
    }
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
        privateDnsZoneResourceIds: [
          nestedDependencies.outputs.privateDNSZoneResourceId
        ]
        service: 'vault'
        subnetResourceId: nestedDependencies.outputs.subnetResourceId
        tags: {
          'hidden-title': 'This is visible in the resource name'
          Environment: 'Non-Prod'
          Role: 'DeploymentValidation'
        }
        roleAssignments: [
          {
            roleDefinitionIdOrName: 'Owner'
            principalId: nestedDependencies.outputs.managedIdentityResourceId
            principalType: 'ServicePrincipal'
          }
          {
            roleDefinitionIdOrName: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
            principalId: nestedDependencies.outputs.managedIdentityResourceId
            principalType: 'ServicePrincipal'
          }
        ]
        ipConfigurations: [
          {
            name: 'myIPconfig'
            properties: {
              groupId: 'API'
              memberName: 'default'
              privateIPAddress: '10.0.0.10'
            }
          }
        ]
        customDnsConfigs: [
          {
            fqdn: 'abc.keyvault.com'
            ipAddresses: [
              '10.0.0.10'
            ]
          }
        ]
      }
    ]
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalId: nestedDependencies.outputs.managedIdentityPrincipalResourceId
        principalType: 'ServicePrincipal'
      }
    ]
    tags: {
      'hidden-title': 'This is visible in the resource name'
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
  }
}]
