targetScope = 'subscription'

metadata name = 'Using spot priority for the VM'
metadata description = 'This instance deploys the module with spot priority and an ephemeral OS disk.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-compute.virtualMachines-${serviceShort}-rg'

// Capacity constraints for VM type
#disable-next-line no-hardcoded-location
var enforcedLocation = 'uksouth'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'cvmlinspot'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedDependencies'
  params: {
    location: enforcedLocation
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    sshDeploymentScriptName: 'dep-${namePrefix}-ds-${serviceShort}'
    sshKeyName: 'dep-${namePrefix}-ssh-${serviceShort}'
  }
}

// ============== //
// Test Execution //
// ============== //

// resource sshKey 'Microsoft.Compute/sshPublicKeys@2022-03-01' existing = {
//   name: sshKeyName
//   scope: resourceGroup
// }

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-${iteration}'
    params: {
      adminUsername: 'localAdminUser'
      disablePasswordAuthentication: true
      evictionPolicy: 'Delete'
      imageReference: {
        offer: 'debian-12'
        publisher: 'debian'
        sku: '12-arm64'
        version: 'latest'
      }
      location: enforcedLocation
      name: '${namePrefix}${serviceShort}'
      nicConfigurations: [
        {
          ipConfigurations: [
            {
              name: 'ipconfig01'
              subnetResourceId: nestedDependencies.outputs.subnetResourceId
              pipConfiguration: {
                name: 'pip-01'
              }
            }
          ]
          nicSuffix: '-nic-01'
        }
      ]
      osDisk: {
        caching: 'ReadOnly'
        deleteOption: 'Delete'
        diffDiskSettings: {
          placement: 'NvmeDisk'
        }
        diskSizeGB: 75
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
      osType: 'Linux'
      priority: 'Spot'
      publicKeys: [
        {
          keyData: nestedDependencies.outputs.SSHKeyPublicKey
          path: '/home/localAdminUser/.ssh/authorized_keys'
        }
      ]
      vmSize: 'Standard_D2plds_v6'
      zone: 0
    }
    dependsOn: [
      nestedDependencies // Required to leverage `existing` SSH key reference
    ]
  }
]
