targetScope = 'subscription'

metadata name = 'IPSec connection with APIPA configuration'
metadata description = 'This instance deploys the module with IPSec connection type and APIPA (gatewayCustomBgpIpAddresses) configuration.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.connections-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ncapipa'

@description('Optional. The password to leverage for the shared key.')
@secure()
param password string = newGuid()

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
    location: resourceLocation
    primaryPublicIPName: 'dep-${namePrefix}-pip-${serviceShort}-1'
    primaryVirtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}-1'
    primaryVirtualNetworkGatewayName: 'dep-${namePrefix}-vpn-gw-${serviceShort}-1'
    localNetworkGatewayName: 'dep-${namePrefix}-lng-${serviceShort}-1'
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
      virtualNetworkGateway1: {
        id: nestedDependencies.outputs.primaryVNETGatewayResourceID
      }
      localNetworkGateway2ResourceId: nestedDependencies.outputs.localNetworkGatewayResourceID
      connectionType: 'IPsec'
      enableBgp: true
      useLocalAzureIpAddress: true
      vpnSharedKey: password
      // APIPA (Automatic Private IP Addressing) configuration for custom BGP IP addresses
      gatewayCustomBgpIpAddresses: [
        {
          customBgpIpAddress: '169.254.21.1'
          ipConfigurationId: '${nestedDependencies.outputs.primaryVNETGatewayResourceID}/ipConfigurations/default'
        }
      ]
      customIPSecPolicy: {
        saLifeTimeSeconds: 3600
        saDataSizeKilobytes: 102400000
        ipsecEncryption: 'AES256'
        ipsecIntegrity: 'SHA256'
        ikeEncryption: 'AES256'
        ikeIntegrity: 'SHA256'
        dhGroup: 'DHGroup14'
        pfsGroup: 'PFS14'
      }
      tags: {
        'hidden-title': 'IPSec APIPA Connection Test'
        Environment: 'Test'
        Role: 'DeploymentValidation'
      }
    }
  }
]
