targetScope = 'subscription'

metadata name = 'Using private network'
metadata description = 'This instance deploys the module within a virtual network.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-containerinstance.containergroups-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'cicgprivate'

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
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
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
                memoryInGB: '4'
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
      ipAddressType: 'Private'
      ipAddressPorts: [
        {
          protocol: 'Tcp'
          port: 80
        }
        {
          protocol: 'Tcp'
          port: 443
        }
        {
          protocol: 'Tcp'
          port: 8080
        }
      ]
      subnetResourceId: nestedDependencies.outputs.subnetResourceId
    }
  }
]
