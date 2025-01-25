targetScope = 'subscription'

metadata name = 'Using only defaults'
metadata description = 'This instance deploys the module with the minimum set of required parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-servicefabric.clusters-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'sfcmin'

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
      managementEndpoint: 'https://${namePrefix}${serviceShort}001.westeurope.cloudapp.azure.com:19080'
      reliabilityLevel: 'None'
      certificate: {
        thumbprint: '0AC113D5E1D94C401DDEB0EE2B1B96CC130'
      }
      nodeTypes: [
        {
          applicationPorts: {
            endPort: 30000
            startPort: 20000
          }
          clientConnectionEndpointPort: 19000
          durabilityLevel: 'Bronze'
          ephemeralPorts: {
            endPort: 65534
            startPort: 49152
          }
          httpGatewayEndpointPort: 19080
          isPrimary: true
          name: 'Node01'
        }
      ]
    }
  }
]
