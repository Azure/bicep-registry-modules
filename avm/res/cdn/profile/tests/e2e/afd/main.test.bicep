targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-cdn.profiles-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'cdnpafd'

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '[[namePrefix]]'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-nestedDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}cdnstore${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [for iteration in [ 'init', 'idem' ]: {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}-${iteration}'
  params: {
    name: 'dep-${namePrefix}-test-${serviceShort}'
    location: 'global'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    originResponseTimeoutSeconds: 60
    sku: 'Standard_AzureFrontDoor'
    enableDefaultTelemetry: enableDefaultTelemetry
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
    customDomains: [
      {
        name: 'dep-${namePrefix}-test-${serviceShort}-custom-domain'
        hostName: 'dep-${namePrefix}-test-${serviceShort}-custom-domain.azurewebsites.net'
        certificateType: 'ManagedCertificate'
      }
    ]
    origionGroups: [
      {
        name: 'dep-${namePrefix}-test-${serviceShort}-origin-group'
        loadBalancingSettings: {
          additionalLatencyInMilliseconds: 50
          sampleSize: 4
          successfulSamplesRequired: 3
        }
        origins: [
          {
            name: 'dep-${namePrefix}-test-${serviceShort}-origin'
            hostName: 'dep-${namePrefix}-test-${serviceShort}-origin.azurewebsites.net'
          }
        ]
      }
    ]
    ruleSets: [
      {
        name: 'dep${namePrefix}test${serviceShort}ruleset'
        rules: [
          {
            name: 'dep${namePrefix}test${serviceShort}rule'
            order: 1
            actions: [
              {
                name: 'UrlRedirect'
                parameters: {
                  typeName: 'DeliveryRuleUrlRedirectActionParameters'
                  redirectType: 'PermanentRedirect'
                  destinationProtocol: 'Https'
                  customPath: '/test123'
                  customHostname: 'dev-etradefd.trade.azure.defra.cloud'
                }
              }
            ]
          }
        ]
      }
    ]
    afdEndpoints: [
      {
        name: 'dep-${namePrefix}-test-${serviceShort}-afd-endpoint'
        routes: [
          {
            name: 'dep-${namePrefix}-test-${serviceShort}-afd-route'
            originGroupName: 'dep-${namePrefix}-test-${serviceShort}-origin-group'
            customDomainName: 'dep-${namePrefix}-test-${serviceShort}-custom-domain'
            ruleSets: [
              {
                name: 'dep${namePrefix}test${serviceShort}ruleset'
              }
            ]
          }
        ]
      }
    ]
  }
}]
