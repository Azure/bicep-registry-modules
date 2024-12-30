targetScope = 'subscription'

metadata name = 'Using client and server certificate parameter set'
metadata description = 'This instance deploys the module with client and server certificates using thumbprints and common names.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-servicefabric.clusters-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'sfccrt'

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
      certificateCommonNames: {
        commonNames: [
          {
            certificateCommonName: 'certcommon'
            certificateIssuerThumbprint: '0AC113D5E1D94C401DDEB0EE2B1B96CC130'
          }
        ]
        x509StoreName: 'My'
      }
      clientCertificateThumbprints: [
        {
          certificateThumbprint: 'D945B0AC4BDF78D31FB6F09CF375E0B9DC7BBBBE'
          isAdmin: true
        }
      ]
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
