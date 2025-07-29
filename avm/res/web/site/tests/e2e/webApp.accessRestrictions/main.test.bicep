targetScope = 'subscription'

metadata name = 'Access Restrictions'
metadata description = 'This instance deploys the module demonstrating access restrictions for Front Door and Application Gateway scenarios.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-web.sites-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'wsacr'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    serverFarmName: 'dep-${namePrefix}-sf-${serviceShort}'
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
      kind: 'app'
      serverFarmResourceId: nestedDependencies.outputs.serverFarmResourceId
      httpsOnly: true
      siteConfig: {
        alwaysOn: true
        minTlsVersion: '1.2'
        ftpsState: 'FtpsOnly'
      }
      configs: [
        {
          // Configure access restrictions for various scenarios
          name: 'web'
          properties: {
            ipSecurityRestrictions: [
              {
                // Allow access from Azure Front Door service
                action: 'Allow'
                description: 'Allow access from Azure Front Door'
                name: 'Azure Front Door'
                priority: 100
                ipAddress: 'AzureFrontDoor.Backend'
                tag: 'ServiceTag'
              }
              {
                // Allow access from Application Gateway service tag
                // Note: For better security, consider using vnetSubnetResourceId instead
                // to restrict to specific Application Gateway subnet
                action: 'Allow'
                description: 'Allow access from Application Gateway'
                name: 'Application Gateway'
                priority: 200
                ipAddress: 'GatewayManager'
                tag: 'ServiceTag'
              }
              {
                // Allow access from specific IP range (example office network)
                action: 'Allow'
                description: 'Allow access from office network'
                name: 'Office Network'
                priority: 300
                ipAddress: '203.0.113.0/24'
              }
              {
                // Example of using Front Door ID header validation
                action: 'Allow'
                description: 'Allow specific Front Door instance with X-Azure-FDID header'
                name: 'Specific Front Door Instance'
                priority: 400
                ipAddress: 'AzureFrontDoor.Backend'
                tag: 'ServiceTag'
                headers: {
                  'x-azure-fdid': [
                    'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
                  ]
                }
              }
            ]
            ipSecurityRestrictionsDefaultAction: 'Allow'
          }
        }
      ]
    }
  }
]
