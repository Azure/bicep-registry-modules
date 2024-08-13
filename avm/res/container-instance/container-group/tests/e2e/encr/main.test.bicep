targetScope = 'subscription'

metadata name = 'Using CMK '
metadata description = 'This instance deploys the module with a customer-managed key (CMK).'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-containerinstance.containergroups-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'cicgencr'

@description('Generated. Used as a basis for unique resource names.')
param baseTime string = utcNow('u')

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
    location: resourceLocation
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    // Adding base time to make the name unique as purge protection must be enabled (but may not be longer than 24 characters total)
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}-${substring(uniqueString(baseTime), 0, 3)}'
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
      location: resourceLocation
      name: '${namePrefix}${serviceShort}001'
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
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
                memoryInGB: 2
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
                memoryInGB: 2
              }
            }
          }
        }
      ]
      ipAddressPorts: [
        {
          protocol: 'Tcp'
          port: 80
        }
        {
          protocol: 'Tcp'
          port: 443
        }
      ]
      managedIdentities: {
        systemAssigned: true
        userAssignedResourceIds: [
          nestedDependencies.outputs.managedIdentityResourceId
        ]
      }
      customerManagedKey: {
        keyName: nestedDependencies.outputs.keyVaultEncryptionKeyName
        keyVaultResourceId: nestedDependencies.outputs.keyVaultResourceId
        userAssignedIdentityResourceId: nestedDependencies.outputs.managedIdentityResourceId
      }
    }
  }
]
