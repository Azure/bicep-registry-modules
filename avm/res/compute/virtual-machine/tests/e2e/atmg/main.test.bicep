// WARNING: this test is disabled, as there is an known issue on Azure, preventing deployment, see https://techcommunity.microsoft.com/t5/azure-infrastructure/enabling-azure-automanage-or-creating-a-custom-configuration/m-p/4251861
targetScope = 'subscription'

metadata name = 'Using automanage for the VM.'
metadata description = 'This instance deploys the module with registering to an automation account.'

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
param serviceShort string = 'cvmlinatmg'

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
    sshDeploymentScriptName: 'dep-${namePrefix}-ds-${serviceShort}'
    sshKeyName: 'dep-${namePrefix}-ssh-${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
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
  for iteration in ['init', 'idem']: if (false) {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-${iteration}'
    params: {
      location: enforcedLocation
      name: '${namePrefix}${serviceShort}'
      adminUsername: 'localAdminUser'
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts-gen2'
        version: 'latest'
      }
      zone: 0
      nicConfigurations: [
        {
          ipConfigurations: [
            {
              name: 'ipconfig01'
              pipConfiguration: {
                publicIpNameSuffix: '-pip-01'
                zones: [
                  1
                  2
                  3
                ]
              }
              subnetResourceId: nestedDependencies.outputs.subnetResourceId
            }
          ]
          nicSuffix: '-nic-01'
        }
      ]
      osDisk: {
        diskSizeGB: 128
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
      osType: 'Linux'
      vmSize: 'Standard_D2s_v3'
      configurationProfile: '/providers/Microsoft.Automanage/bestPractices/AzureBestPracticesProduction'
      disablePasswordAuthentication: true
      publicKeys: [
        {
          keyData: nestedDependencies.outputs.SSHKeyPublicKey
          path: '/home/localAdminUser/.ssh/authorized_keys'
        }
      ]
    }
    dependsOn: [
      nestedDependencies // Required to leverage `existing` SSH key reference
    ]
  }
]
