targetScope = 'subscription'

metadata name = 'P2S Entra ID and Certificate Authentication'
metadata description = 'This instance deploys Point-to-Site VPN with Entra ID and certificate authentication using a test root and its signed intermediate. The certificateScenario parameter selects legacy-only, array-only, or combined certificate inputs.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.virtualnetworkgateways-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nvgp2sec'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. The certificate input configuration to test.')
@allowed([
  'legacy'
  'array'
  'combined'
])
param certificateScenario string = 'combined'

var certificates = loadJsonContent('certificates.json')
var clientRootCertificates = certificateScenario == 'legacy'
  ? []
  : concat(
      certificateScenario == 'array'
        ? [
            {
              name: 'RootCert1'
              publicCertData: certificates.root
            }
          ]
        : [],
      [
        {
          name: 'IntermediateCert1'
          publicCertData: certificates.intermediate
        }
      ]
    )

// ============ //
// Dependencies //
// ============ //

resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    location: resourceLocation
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
      name: '${namePrefix}${serviceShort}001'
      gatewayType: 'Vpn'
      virtualNetworkResourceId: nestedDependencies.outputs.vnetResourceId
      clusterSettings: {
        clusterMode: 'activePassiveNoBgp'
      }
      vpnClientAddressPoolPrefix: '172.16.10.0/24'
      clientRootCertificates: clientRootCertificates
      clientRootCertData: certificateScenario == 'array' ? '' : certificates.root
      clientRevokedCertThumbprint: '1f24c630cda418ef2069ffad4fdd5f463a1b69aa'
      vpnClientAadConfiguration: {
        aadAudience: '11111111-1234-4321-1234-111111111111'
        aadIssuer: 'https://sts.windows.net/11111111-1111-1111-1111-111111111111/'
        aadTenant: '${environment().authentication.loginEndpoint}11111111-1111-1111-1111-111111111111'
        vpnAuthenticationTypes: [
          'AAD'
        ]
        vpnClientProtocols: [
          'OpenVPN'
        ]
      }
      vpnGatewayGeneration: 'Generation2'
      skuName: 'VpnGw2AZ'
      vpnType: 'RouteBased'
    }
  }
]

output activeActive bool = testDeployment[0].outputs.activeActive
output location string = testDeployment[0].outputs.location
output name string = testDeployment[0].outputs.name
output primaryPublicIpAddress string? = testDeployment[0].outputs.?primaryPublicIpAddress
output resourceGroupName string = testDeployment[0].outputs.resourceGroupName
output resourceId string = testDeployment[0].outputs.resourceId
output certificateScenario string = certificateScenario
