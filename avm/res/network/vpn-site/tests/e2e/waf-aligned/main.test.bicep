targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-network.vpnSites-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nvswaf'

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
    virtualWANName: 'dep-${namePrefix}-vw-${serviceShort}'
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
      name: '${namePrefix}-${serviceShort}'
      virtualWanId: nestedDependencies.outputs.virtualWWANResourceId
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
      tags: {
        'hidden-title': 'This is visible in the resource name'
        tagA: 'valueA'
        tagB: 'valueB'
      }
      deviceProperties: {
        linkSpeedInMbps: 0
      }
      vpnSiteLinks: [
        {
          name: '${namePrefix}-vSite-${serviceShort}'
          properties: {
            bgpProperties: {
              asn: 65010
              bgpPeeringAddress: '1.1.1.1'
            }
            ipAddress: '1.2.3.4'
            linkProperties: {
              linkProviderName: 'contoso'
              linkSpeedInMbps: 5
            }
          }
        }
        {
          name: 'Link1'
          properties: {
            bgpProperties: {
              asn: 65020
              bgpPeeringAddress: '192.168.1.0'
            }
            ipAddress: '2.2.2.2'
            linkProperties: {
              linkProviderName: 'contoso'
              linkSpeedInMbps: 5
            }
          }
        }
      ]
      o365Policy: {
        breakOutCategories: {
          optimize: true
          allow: true
          default: true
        }
      }
    }
    dependsOn: [
      nestedDependencies
    ]
  }
]
