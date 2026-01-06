targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-containerinstance.containergroups-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'cicgwaf'

@description('Optional. A token to inject into the name of each resource.')
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
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
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
      availabilityZone: 1
      containers: [
        {
          name: '${namePrefix}-az-aci-x-001'
          properties: {
            command: []
            environmentVariables: []
            image: 'mcr.microsoft.com/azuredocs/aci-helloworld'
            ports: [
              {
                port: 80
                protocol: 'Tcp'
              }
              {
                port: 443
                protocol: 'Tcp'
              }
            ]
            resources: {
              requests: {
                cpu: 2
                memoryInGB: '2'
              }
            }
          }
        }
        {
          name: '${namePrefix}-az-aci-x-002'
          properties: {
            command: []
            environmentVariables: []
            image: 'mcr.microsoft.com/azuredocs/aci-helloworld'
            ports: [
              {
                port: 8080
                protocol: 'Tcp'
              }
            ]
            resources: {
              requests: {
                cpu: 2
                memoryInGB: '2'
              }
            }
          }
        }
      ]
      ipAddress: {
        ports: [
          {
            protocol: 'Tcp'
            port: 80
          }
          {
            protocol: 'Tcp'
            port: 443
          }
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
