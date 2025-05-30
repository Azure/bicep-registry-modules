targetScope = 'subscription'

metadata name = 'Test with all (max) parameters.'
metadata description = 'This test deploys the pattern using all parameters. This test performs bulk parameter validation.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-cosmos-db-account-container-app-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'cdaamax'

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

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-depdencies-${serviceShort}'
  params: {
    location: resourceLocation
    managedIdentityName: 'dep-${namePrefix}${serviceShort}${substring(uniqueString(baseTime), 0, 3)}-identity'
    deploymentScriptName: 'dep-${namePrefix}${serviceShort}${substring(uniqueString(baseTime), 0, 3)}-script'
    virtualNetworkName: 'dep-${namePrefix}${serviceShort}${substring(uniqueString(baseTime), 0, 3)}-vnet'
    subnetName: 'dep-${namePrefix}${serviceShort}${substring(uniqueString(baseTime), 0, 3)}-subnet'
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
      name: '${namePrefix}${serviceShort}${substring(uniqueString(baseTime), 0, 3)}'
      location: resourceLocation
      enableTelemetry: true
      tags: {
        test: 'max'
      }
      database: {
        type: 'NoSQL'
        tags: {
          type: 'nosql'
        }
        additionalLocations: [
          nestedDependencies.outputs.pairedRegionName
        ]
        serverless: true
        zoneRedundant: false
        publicNetworkAccessEnabled: true
        enableLogAnalytics: false
        additionalRoleBasedAccessControlPrincipals: [
          nestedDependencies.outputs.userAssignedManagedIdentityResourceId
        ]
        databases: [
          {
            name: 'example-database'
            containers: [
              {
                name: 'example-container'
                partitionKeys: [
                  '/id'
                ]
                seed: 'cosmicworks-employees'
              }
            ]
          }
        ]
      }
      web: {
        tags: {
          host: 'azure-container-apps'
          platform: 'docker'
        }
        zoneRedundant: false
        publicNetworkAccessEnabled: false
        enableLogAnalytics: false
        virtualNetworkSubnetResourceId: nestedDependencies.outputs.virtualNetworkSubnetResourceId
        additionalRoleBasedAccessControlPrincipals: [
          nestedDependencies.outputs.userAssignedManagedIdentityResourceId
        ]
        tiers: [
          {
            tags: {
              description: 'Example web application tier.'
            }
            name: 'example-tier-1'
            port: 80
            image: 'nginx:latest'
            allowIngress: false
            useManagedIdentity: true
            cpu: '0.25'
            memory: '0.5Gi'
            environment: [
              {
                name: 'LABELS_HEADER'
                value: 'Example Tier Header'
              }
              {
                name: 'DATABASE_ENDPOINT'
                knownValue: 'AzureCosmosDBEndpoint'
              }
              {
                name: 'RELATED_TIER_ENDPOINT'
                tierEndpoint: 'example-tier-2'
                format: '{0}/openapi/v1.json'
              }
            ]
          }
          {
            name: 'example-tier-2'
          }
        ]
      }
    }
  }
]
