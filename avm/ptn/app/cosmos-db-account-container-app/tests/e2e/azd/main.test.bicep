targetScope = 'subscription'

metadata name = 'Test using a typical use-case pattern for Azure Developer CLI (AZD).'
metadata description = 'This test deploys a common web application using that would be used with an Azure Developer CLI (AZD) template. The web application has two tiers for front-end and back-end and is backed by an Azure Cosmos DB for NoSQL account.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-cosmos-db-account-container-app-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'cdaaazd'

@description('Generated. Used as a basis for unique resource names.')
param baseTime string = utcNow('u')

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-03-01' = {
  name: resourceGroupName
  location: resourceLocation
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
      name: '${namePrefix}${serviceShort}${substring(uniqueString(baseTime), 0, 3)}'
      location: resourceLocation
      database: {
        type: 'NoSQL'
        additionalRoleBasedAccessControlPrincipals: [
          deployer().objectId
        ]
        databases: [
          {
            name: 'cosmicworks'
            containers: [
              {
                name: 'products'
                partitionKeys: [
                  '/category'
                  '/subCategory'
                ]
                seed: 'cosmicworks-products'
              }
            ]
          }
        ]
      }
      web: {
        additionalRoleBasedAccessControlPrincipals: [
          deployer().objectId
        ]
        tiers: [
          {
            name: 'back-end'
            tags: {
              'azd-service-name': 'api'
            }
            image: 'mcr.microsoft.com/dotnet/samples:aspnetapp-9.0'
            port: 8080
            allowIngress: true
            useManagedIdentity: true
            environment: [
              {
                name: 'CONFIGURATION__AZURECOSMOSDB__ENDPOINT'
                knownValue: 'AzureCosmosDBEndpoint'
              }
              {
                name: 'CONFIGURATION__AZURECOSMOSDB__DATABASENAME'
                value: 'cosmicworks'
              }
              {
                name: 'CONFIGURATION__AZURECOSMOSDB__CONTAINERNAME'
                value: 'products'
              }
            ]
          }
          {
            name: 'front-end'
            tags: {
              'azd-service-name': 'web'
            }
            image: 'mcr.microsoft.com/dotnet/samples:aspnetapp-9.0'
            port: 8080
            allowIngress: true
            useManagedIdentity: true
            environment: [
              {
                name: 'CONFIGURATION__API__ENDPOINT'
                tierEndpoint: 'back-end'
                format: '{0}/api'
              }
            ]
          }
        ]
      }
    }
  }
]
