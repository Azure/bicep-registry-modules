targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-cdn.profiles-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'cdnpwaf'

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
    storageAccountName: 'dep${namePrefix}cdnstore${serviceShort}'
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
      name: 'dep-${namePrefix}-test-${serviceShort}'
      location: resourceLocation
      originResponseTimeoutSeconds: 60
      sku: 'Standard_Microsoft'
      endpointProperties: {
        originHostHeader: '${nestedDependencies.outputs.storageAccountName}.blob.${environment().suffixes.storage}'
        contentTypesToCompress: [
          'text/plain'
          'text/html'
          'text/css'
          'text/javascript'
          'application/x-javascript'
          'application/javascript'
          'application/json'
          'application/xml'
        ]
        isCompressionEnabled: true
        isHttpAllowed: true
        isHttpsAllowed: true
        queryStringCachingBehavior: 'IgnoreQueryString'
        origins: [
          {
            name: 'dep-${namePrefix}-cdn-endpoint01'
            properties: {
              hostName: '${nestedDependencies.outputs.storageAccountName}.blob.${environment().suffixes.storage}'
              httpPort: 80
              httpsPort: 443
              enabled: true
            }
          }
        ]
        originGroups: []
        geoFilters: []
      }
    }
    dependsOn: [
      nestedDependencies
    ]
  }
]
