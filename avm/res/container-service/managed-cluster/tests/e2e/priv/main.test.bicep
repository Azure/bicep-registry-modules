targetScope = 'subscription'

metadata name = 'Using Private Cluster.'
metadata description = 'This instance deploys the module with a private cluster instance.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-containerservice.managedclusters-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'csmpriv'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    privateDnsZoneName: 'privatelink.${resourceLocation}.azmk8s.io'
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
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
      name: '${namePrefix}${serviceShort}001'
      location: resourceLocation
      enablePrivateCluster: true
      primaryAgentPoolProfile: [
        {
          availabilityZones: [
            '3'
          ]
          count: 1
          enableAutoScaling: true
          maxCount: 3
          maxPods: 30
          minCount: 1
          mode: 'System'
          name: 'systempool'
          nodeTaints: [
            'CriticalAddonsOnly=true:NoSchedule'
          ]
          osDiskSizeGB: 0
          osType: 'Linux'
          type: 'VirtualMachineScaleSets'
          vmSize: 'Standard_DS2_v2'
          vnetSubnetID: '${nestedDependencies.outputs.vNetResourceId}/subnets/defaultSubnet'
        }
      ]
      agentPools: [
        {
          availabilityZones: [
            '3'
          ]
          count: 2
          enableAutoScaling: true
          maxCount: 3
          maxPods: 30
          minCount: 1
          minPods: 2
          mode: 'User'
          name: 'userpool1'
          nodeLabels: {}
          osDiskSizeGB: 128
          osType: 'Linux'
          scaleSetEvictionPolicy: 'Delete'
          scaleSetPriority: 'Regular'
          type: 'VirtualMachineScaleSets'
          vmSize: 'Standard_DS2_v2'
          vnetSubnetID: '${nestedDependencies.outputs.vNetResourceId}/subnets/defaultSubnet'
        }
        {
          availabilityZones: [
            '3'
          ]
          count: 2
          enableAutoScaling: true
          maxCount: 3
          maxPods: 30
          minCount: 1
          minPods: 2
          mode: 'User'
          name: 'userpool2'
          nodeLabels: {}
          osDiskSizeGB: 128
          osType: 'Linux'
          scaleSetEvictionPolicy: 'Delete'
          scaleSetPriority: 'Regular'
          type: 'VirtualMachineScaleSets'
          vmSize: 'Standard_DS2_v2'
        }
      ]
      networkPlugin: 'azure'
      skuTier: 'Standard'
      dnsServiceIP: '10.10.200.10'
      serviceCidr: '10.10.200.0/24'
      privateDNSZone: nestedDependencies.outputs.privateDnsZoneResourceId
      managedIdentities: {
        userAssignedResourcesIds: [
          nestedDependencies.outputs.managedIdentityResourceId
        ]
      }
    }
    dependsOn: [
      nestedDependencies
    ]
  }
]
